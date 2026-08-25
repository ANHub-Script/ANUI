--[[

    Crypt   |   SHA-256 + HMAC-SHA256

    Small, dependency-free hashing helpers used by the GitHub key service.
    Built on `bit32`, which every modern Roblox executor exposes.

]]

local Crypt = {}

local band, bxor, bnot = bit32.band, bit32.bxor, bit32.bnot
local rrotate, rshift = bit32.rrotate, bit32.rshift
local floor = math.floor
local schar, sbyte, srep, sformat, ssub = string.char, string.byte, string.rep, string.format, string.sub

local MOD = 4294967296 -- 2^32

-- SHA-256 round constants: first 32 bits of the fractional parts of the
-- cube roots of the first 64 primes.
local K = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}

-- Big-endian integer -> `count` raw bytes.
local function toBytesBE(n, count)
    local out = {}
    for i = count, 1, -1 do
        out[i] = schar(n % 256)
        n = floor(n / 256)
    end
    return table.concat(out)
end

-- Read 4 big-endian bytes at `i` as an unsigned 32-bit word.
local function wordBE(s, i)
    local a, b, c, d = sbyte(s, i, i + 3)
    return ((a * 256 + b) * 256 + c) * 256 + d
end

-- Core compression. Returns the 8 state words as a list.
local function digest(msg)
    local h1, h2, h3, h4 = 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a
    local h5, h6, h7, h8 = 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19

    -- Pad: 0x80, zeros until 56 mod 64, then the 64-bit big-endian bit length.
    local bitLen = #msg * 8
    msg = msg .. "\128"
    msg = msg .. srep("\0", (56 - (#msg % 64)) % 64)
    msg = msg .. toBytesBE(floor(bitLen / MOD), 4) .. toBytesBE(bitLen % MOD, 4)

    local w = {}
    for chunk = 1, #msg, 64 do
        for i = 1, 16 do
            w[i] = wordBE(msg, chunk + (i - 1) * 4)
        end
        for i = 17, 64 do
            local x, y = w[i - 15], w[i - 2]
            local s0 = bxor(rrotate(x, 7), rrotate(x, 18), rshift(x, 3))
            local s1 = bxor(rrotate(y, 17), rrotate(y, 19), rshift(y, 10))
            w[i] = (w[i - 16] + s0 + w[i - 7] + s1) % MOD
        end

        local a, b, c, d, e, f, g, hh = h1, h2, h3, h4, h5, h6, h7, h8
        for i = 1, 64 do
            local S1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
            local ch = bxor(band(e, f), band(bnot(e), g))
            local t1 = (hh + S1 + ch + K[i] + w[i]) % MOD
            local S0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
            local maj = bxor(band(a, b), band(a, c), band(b, c))
            local t2 = (S0 + maj) % MOD

            hh, g, f = g, f, e
            e = (d + t1) % MOD
            d, c, b = c, b, a
            a = (t1 + t2) % MOD
        end

        h1 = (h1 + a) % MOD; h2 = (h2 + b) % MOD; h3 = (h3 + c) % MOD; h4 = (h4 + d) % MOD
        h5 = (h5 + e) % MOD; h6 = (h6 + f) % MOD; h7 = (h7 + g) % MOD; h8 = (h8 + hh) % MOD
    end

    return { h1, h2, h3, h4, h5, h6, h7, h8 }
end

-- SHA-256 as a 64-character lowercase hex string.
function Crypt.SHA256(msg)
    local h = digest(tostring(msg))
    local out = {}
    for i = 1, 8 do
        out[i] = sformat("%08x", h[i])
    end
    return table.concat(out)
end

-- SHA-256 as 32 raw bytes. Needed for HMAC key folding.
function Crypt.SHA256Raw(msg)
    local h = digest(tostring(msg))
    local out = {}
    for i = 1, 8 do
        out[i] = toBytesBE(h[i], 4)
    end
    return table.concat(out)
end

-- HMAC-SHA256 as a 64-character lowercase hex string.
function Crypt.HMAC(key, msg)
    key, msg = tostring(key), tostring(msg)

    if #key > 64 then
        key = Crypt.SHA256Raw(key)
    end
    key = key .. srep("\0", 64 - #key)

    local outer, inner = {}, {}
    for i = 1, 64 do
        local b = sbyte(key, i)
        outer[i] = schar(bxor(b, 0x5c))
        inner[i] = schar(bxor(b, 0x36))
    end

    return Crypt.SHA256(table.concat(outer) .. Crypt.SHA256Raw(table.concat(inner) .. msg))
end

-- Constant-time-ish string compare. Avoids leaking the match position via
-- early return; not a hard guarantee in Lua, but better than `==` on secrets.
function Crypt.Equals(a, b)
    a, b = tostring(a), tostring(b)
    if #a ~= #b then
        return false
    end
    local diff = 0
    for i = 1, #a do
        diff = bit32.bor(diff, bxor(sbyte(a, i), sbyte(b, i)))
    end
    return diff == 0
end

-- Short, stable device fingerprint: first `len` hex chars of SHA-256.
function Crypt.Fingerprint(value, len)
    return ssub(Crypt.SHA256(value), 1, len or 32)
end

return Crypt
