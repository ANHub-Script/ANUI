--[[

    GitHub Key API   |   per-device keys, 24h TTL, DB stored in a GitHub repo

    Read path (this file)  : GET raw.githubusercontent.com/<owner>/<repo>/<branch>/<db>
    Write path (website)   : docs/public/getkey/  -> GitHub contents API

    The database is a single JSON file keyed by a SHA-256 fingerprint of the
    device HWID, so raw HWIDs never land in a public repo. One active key per
    device: regenerating overwrites the entry, which kills the previous key.

]]

local Crypt = require("../Crypt")

local cloneref = (cloneref or clonereference or function(instance) return instance end)

local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))

local GitHubKey = {}

local DAY = 86400

local MONTHS = {
    Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
    Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12,
}

-- Parses an HTTP `Date` header ("Mon, 25 Aug 2026 12:34:56 GMT") into a UNIX
-- timestamp. Used as a trusted clock so a player cannot extend a key's life by
-- winding their system clock back.
local function parseHttpDate(value)
    if type(value) ~= "string" then
        return nil
    end

    local day, monthName, year, hour, min, sec =
        value:match("(%d+)%s+(%a+)%s+(%d+)%s+(%d+):(%d+):(%d+)")

    local month = monthName and MONTHS[monthName]
    if not (day and month and year) then
        return nil
    end

    local ok, stamp = pcall(os.time, {
        year = tonumber(year),
        month = month,
        day = tonumber(day),
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec),
    })

    return ok and stamp or nil
end

-- Header lookup that tolerates the casing differences between executors.
local function findHeader(headers, name)
    if type(headers) ~= "table" then
        return nil
    end
    local wanted = name:lower()
    for k, v in next, headers do
        if type(k) == "string" and k:lower() == wanted then
            return v
        end
    end
    return nil
end

-- 3900 -> "1h 5m", 45 -> "45s"
local function formatDuration(seconds)
    seconds = math.max(0, math.floor(seconds))

    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)

    if hours > 0 then
        return string.format("%dh %dm", hours, minutes)
    elseif minutes > 0 then
        return string.format("%dm", minutes)
    end
    return string.format("%ds", seconds)
end

local function jsonDecode(body)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    return ok and decoded or nil
end

local function jsonEncode(value)
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(value)
    end)
    return ok and encoded or nil
end

--[[
    Owner    string   GitHub user/org that owns the database repo.
    Repo     string   Repository name.
    Branch   string   Branch the database lives on. Defaults to "main".
    DBPath   string   Path to the JSON database. Defaults to "db/keys.json".
    URL      string   Public key-generator page. `Copy()` puts it on the clipboard.
    Secret   string   Optional HMAC secret. When set, each entry's signature is
                      verified, so a repo write alone cannot forge a valid key.
    Folder   string   Workspace folder for the offline cache file.
]]
function GitHubKey.New(Owner, Repo, Branch, DBPath, URL, Secret, Folder)
    Branch = Branch or "main"
    DBPath = DBPath or "db/keys.json"

    local frequest = request or http_request or syn_request
        or (syn and syn.request) or (http and http.request)
    local fsetclipboard = setclipboard or toclipboard or set_clipboard
        or (Clipboard and Clipboard.set)

    local gethwidFn = gethwid or getexecutorhwid or function()
        return tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or "unknown")
    end

    local rawHWID
    do
        local ok, value = pcall(gethwidFn)
        rawHWID = ok and tostring(value) or "unknown"
    end

    -- What the database is keyed by. Stable per device, and reveals nothing
    -- about the HWID itself once published.
    local fingerprint = Crypt.Fingerprint(rawHWID, 32)

    local cachePath = (Folder or "ANUI") .. "/" .. fingerprint .. ".keycache"

    local base = "https://raw.githubusercontent.com/"
        .. Owner .. "/" .. Repo .. "/" .. Branch .. "/" .. DBPath

    -- raw.githubusercontent.com sits behind a CDN with a multi-minute TTL. A
    -- unique query string per request defeats it, which is what makes a
    -- freshly generated key usable straight away.
    local function dbURL()
        return base .. "?cb=" .. tostring(os.time()) .. "-" .. tostring(math.random(1000000, 9999999))
    end

    -- Returns: database table, trusted-now timestamp, error message
    local function fetchDB()
        if frequest then
            local ok, response = pcall(frequest, {
                Url = dbURL(),
                Method = "GET",
                Headers = {
                    ["Cache-Control"] = "no-cache, no-store, max-age=0",
                    ["Pragma"] = "no-cache",
                    ["User-Agent"] = "Roblox/ANUI-KeySystem",
                },
            })

            if not ok or type(response) ~= "table" then
                return nil, os.time(), "Could not reach the key server."
            end

            local status = response.StatusCode or response.status_code or 0

            if status == 404 then
                return nil, os.time(), "Key database not found. Check Owner/Repo/Branch/DBPath."
            elseif status ~= 200 then
                return nil, os.time(), "Key server returned status " .. tostring(status) .. "."
            end

            -- Prefer GitHub's clock over the local one.
            local now = parseHttpDate(findHeader(response.Headers or response.headers, "date"))
                or os.time()

            local db = jsonDecode(response.Body or response.body or "")
            if not db or type(db.keys) ~= "table" then
                return nil, now, "Key database is malformed."
            end

            return db, now, nil
        end

        -- No `request` global: fall back to HttpGet. Loses the trusted clock.
        local ok, body = pcall(function()
            return game:HttpGetAsync(dbURL())
        end)

        if not ok or type(body) ~= "string" then
            return nil, os.time(), "Could not reach the key server (no HTTP support)."
        end

        local db = jsonDecode(body)
        if not db or type(db.keys) ~= "table" then
            return nil, os.time(), "Key database is malformed."
        end

        return db, os.time(), nil
    end

    -- Offline cache -----------------------------------------------------------
    -- Written on every successful online verification so a network hiccup does
    -- not lock a player out of a key they legitimately hold. The cache can only
    -- ever confirm what the server already confirmed, and never outlives the
    -- key's own expiry.

    local function readCache()
        if not (isfile and readfile) or not isfile(cachePath) then
            return nil
        end
        local ok, body = pcall(readfile, cachePath)
        return ok and jsonDecode(body) or nil
    end

    local function writeCache(entry)
        if not writefile then
            return
        end
        local body = jsonEncode({
            key = entry.key,
            fingerprint = fingerprint,
            issued_at = entry.issued_at,
            expires_at = entry.expires_at,
            sig = entry.sig,
        })
        if body then
            pcall(writefile, cachePath, body)
        end
    end

    local function clearCache()
        if delfile and isfile and isfile(cachePath) then
            pcall(delfile, cachePath)
        end
    end

    -- Signature ---------------------------------------------------------------

    local function expectedSignature(entry)
        return Crypt.HMAC(Secret, table.concat({
            tostring(entry.key),
            fingerprint,
            tostring(math.floor(tonumber(entry.issued_at) or 0)),
            tostring(math.floor(tonumber(entry.expires_at) or 0)),
        }, "|")):sub(1, 32)
    end

    local function signatureValid(entry)
        if not Secret or Secret == "" then
            return true -- signature checking disabled
        end
        return Crypt.Equals(tostring(entry.sig or ""), expectedSignature(entry))
    end

    -- Verification ------------------------------------------------------------

    local lastInfo = nil

    local function normalizeKey(key)
        return tostring(key or ""):gsub("%s", ""):upper()
    end

    -- Falls back to the cache only when the network failed outright, never when
    -- the server answered and rejected the key.
    local function verifyOffline(key, now)
        local cached = readCache()
        if not cached then
            return false
        end
        if cached.fingerprint ~= fingerprint then
            return false
        end
        if not Crypt.Equals(normalizeKey(cached.key), key) then
            return false
        end
        if not signatureValid(cached) then
            return false
        end

        local expires = math.floor(tonumber(cached.expires_at) or 0)
        if now >= expires then
            return false
        end

        lastInfo = { key = cached.key, expires_at = expires, offline = true }
        return true, expires - now
    end

    local function verifyKey(key)
        key = normalizeKey(key)

        if key == "" then
            return false, "Enter your key first."
        end

        local db, now, err = fetchDB()

        if not db then
            local ok, remaining = verifyOffline(key, now)
            if ok then
                return true, "Verified from offline cache. Expires in " .. formatDuration(remaining) .. "."
            end
            return false, err or "Key verification failed."
        end

        local entry = db.keys[fingerprint]

        if type(entry) ~= "table" then
            return false, "No key issued for this device yet. Press Get key to generate one."
        end

        if entry.revoked == true then
            clearCache()
            return false, "This key was revoked."
        end

        if not Crypt.Equals(normalizeKey(entry.key), key) then
            clearCache()
            return false, "Wrong key. If you regenerated, the previous key no longer works."
        end

        if not signatureValid(entry) then
            clearCache()
            return false, "Key signature is invalid."
        end

        local expires = math.floor(tonumber(entry.expires_at) or 0)

        if now >= expires then
            clearCache()
            return false, "Key expired " .. formatDuration(now - expires) .. " ago. Generate a new one."
        end

        lastInfo = {
            key = entry.key,
            issued_at = math.floor(tonumber(entry.issued_at) or 0),
            expires_at = expires,
            regen = tonumber(entry.regen) or 0,
            offline = false,
        }

        writeCache(entry)

        return true, "Key valid. Expires in " .. formatDuration(expires - now) .. "."
    end

    -- Clipboard ---------------------------------------------------------------

    -- The generator page reads the fingerprint out of the URL fragment, so the
    -- player never has to copy it by hand.
    local function keyLink()
        if not URL or URL == "" then
            return nil
        end
        local separator = URL:find("#") and "&" or "#"
        return URL .. separator .. "fp=" .. fingerprint
    end

    local function copyLink()
        -- Without a generator URL there is still something useful to hand over:
        -- the fingerprint the player needs to paste on the site.
        local payload = keyLink() or fingerprint

        if fsetclipboard then
            pcall(fsetclipboard, payload)
        end
        return payload
    end

    return {
        Verify = verifyKey,
        Copy = copyLink,

        -- Extras beyond the service contract, handy for custom UI.
        Link = keyLink,
        HWID = function() return rawHWID end,
        Fingerprint = function() return fingerprint end,
        Info = function() return lastInfo end,
        Fetch = fetchDB,
        ClearCache = clearCache,
    }
end

return GitHubKey
