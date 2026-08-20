-- if game.PlaceId ~= 122821966131621 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Resource Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local character = LocalPlayer.Character
local rootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
humanoid.WalkSpeed = 100  -- nilai default biasanya 16

local FolderPath = "ANUI/ResourceIncremental"
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local LastConfigFile = FolderPath .. "/LastConfig.txt"
local IsPremium = false
local ValidKeys = {"ANHUB-2025"}
local Config = {}
local ConfigName = "ANConfig"
local IsLoadingConfig = false
local ConfigNameInput

VirtualUser = game:GetService("VirtualUser")

task.spawn(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)
local function NormalizeConfigName(name)
    if typeof(name) ~= "string" then
        return "ANConfig"
    end

    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then
        return "ANConfig"
    end

    return name
end

local function SaveLastConfigName()
    if writefile then
        pcall(function()
            writefile(LastConfigFile, ConfigName)
        end)
    end
end

local function LoadLastConfigName()
    if readfile and isfile and isfile(LastConfigFile) then
        local ok, savedName = pcall(function()
            return readfile(LastConfigFile)
        end)

        if ok and typeof(savedName) == "string" and savedName ~= "" then
            ConfigName = NormalizeConfigName(savedName)
        end
    end
end

local function FinishConfigLoad(delaySeconds)
    task.delay(delaySeconds or 1, function()
        IsLoadingConfig = false
    end)
end

local function GetOrCreateConfig()
    if not Window or not Window.ConfigManager then
        return nil
    end

    ConfigName = NormalizeConfigName(ConfigName)
    local cfg = Window.ConfigManager:GetConfig(ConfigName)
    if cfg then
        cfg:SetAsCurrent()
        return cfg
    end

    return Window.ConfigManager:CreateConfig(ConfigName,true)
end

local UI
local Window

local function Notify(title, content, icon)
    task.spawn(function()
        pcall(function()
            if UI and UI.Notify then
                UI:Notify({ Title = title, Content = content, Icon = icon, Duration = 3 })
            end
        end)
    end)
end

local GameIconURL = string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", game.GameId)
local BaseProfile = {
    Banner = "rbxassetid://124762019485618",
    Avatar = "rbxassetid://84366761557806",
    Status = true,
    Badges = {
        {
            Icon = "geist:logo-discord", Title = "Discord", Desc = "Join ANHUB Discord",
            Callback = function() setclipboard("https://discord.gg/bUkCZvmrpH") Notify("Discord", "Invite link copied!", "geist:logo-discord") end
        },
        {
            Icon = "youtube", Desc = "Subscribe to YouTube",
            Callback = function() setclipboard("https://www.youtube.com/@ANHubRoblox") Notify("YouTube", "Channel link copied!", "youtube") end
        }
    }
}

local function MakeProfile(data)
    local p = table.clone(BaseProfile)
    for k, v in pairs(data or {}) do p[k] = v end
    return p
end

pcall(function()
    if makefolder and isfolder then
        if not isfolder("ANUI") then makefolder("ANUI") end
        if not isfolder(FolderPath) then makefolder(FolderPath) end
    end
end)

LoadLastConfigName()

local function LoadKeySystemData()
    local url = "https://raw.githubusercontent.com/AdityaNugrahaInside/ANHub/refs/heads/main/Key.txt"
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        for line in response:gmatch("[^\r\n]+") do
            local parts = string.split(line, ":")
            if #parts >= 2 then
                local useridInFile = string.gsub(parts[1], "%s+", "")
                local keyInFile = string.gsub(parts[2], "%s+", "")

                table.insert(ValidKeys, keyInFile)

                if useridInFile == tostring(LocalPlayer.UserId) then
                    IsPremium = true
                end
            end
        end
    end
end

LoadKeySystemData()
getgenv().IsPremium = IsPremium

UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v=" .. math.random()))()

Window = UI:CreateWindow({
    Title = "AN Hub - Resource Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "ResourceIncremental",
    Size = UDim2.fromOffset(580, 460),
    KeySystem = {
        Enabled = not IsPremium,
        Title = "ANHub Access",
        Description = "Free Key: ANHUB-2025",
        Key = ValidKeys,
        URL = "https://discord.gg/bUkCZvmrpH",
        Note = "Premium Users are auto-verified!",
        SaveKey = true
    }
})
UI:SetTheme("Midnight")
task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
Window:Tab({
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Resource Incremental" }),
    SidebarProfile = true
})
local function IsWindowAlive()
    return Window and not Window.Destroyed
end

local function IsWindowOpen()
    return IsWindowAlive() and not Window.Closed
end

do
    if IsPremium then
        Window:Tag({
            Title = "Premium User",
            Icon = "crown",
            Color = Color3.fromHex("#FFD700")
        })
    else
        Window:Tag({
            Title = "Free User",
            Icon = "user",
            Color = Color3.fromHex("#FFFFFF")
        })
    end
end

pcall(function()
    if writefile and isfile and (not isfile(ExpiryFile)) then
        writefile(ExpiryFile, tostring(os.time() + 86400))
    end
end)

function GetIcon(id)
    return string.format("rbxassetid://%s", id)
end


ElementDescCache = setmetatable({}, { __mode = "k" })
ElementTitleCache = setmetatable({}, { __mode = "k" })
ElementImageCache = setmetatable({}, { __mode = "k" })

function SafeSetDesc(elem, text)
    if not elem then return end
    if ElementDescCache[elem] == text then return end
    ElementDescCache[elem] = text
    pcall(function()
        elem:SetDesc(text)
    end)
end

function SafeSetTitle(elem, text)
    if not elem then return end
    if ElementTitleCache[elem] == text then return end
    ElementTitleCache[elem] = text
    pcall(function()
        elem:SetTitle(text)
    end)
end

function SafeSetMainImage(elem, icon, size)
    if not elem then return end
    local key = tostring(icon) .. "|" .. tostring(size)
    if ElementImageCache[elem] == key then return end
    ElementImageCache[elem] = key
    pcall(function()
        elem:SetMainImage(icon, size)
    end)
end
ManagedLoops = {}
local Connections = {}  -- simpan semua koneksi yang akan diputus saat Window hancur

function AddConnection(connection)
    table.insert(Connections, connection)
    return connection
end

function DisconnectAll()
    for _, conn in ipairs(Connections) do
        pcall(function() conn:Disconnect() end)
    end
    Connections = {}
end
ManagedLoopRunnerActive = false
ManagedLoopMinWait = 0.01
ManagedLoopIdleWait = 0.05

function ShouldStopManagedLoop()
    return not IsWindowAlive()
end

function NormalizeManagedLoopInterval(interval)
    return math.max(tonumber(interval) or ManagedLoopMinWait, ManagedLoopMinWait)
end

function GetManagedLoopSleep(now)
    local nextDelay = nil
    for _, current in pairs(ManagedLoops) do
        if current and current.nextRunAt then
            local remaining = current.nextRunAt - now
            if remaining <= 0 then
                return ManagedLoopMinWait
            end
            if not nextDelay or remaining < nextDelay then
                nextDelay = remaining
            end
        end
    end
    if not nextDelay then
        return ManagedLoopIdleWait
    end
    return math.clamp(nextDelay, ManagedLoopMinWait, ManagedLoopIdleWait)
end

function EnsureManagedLoopRunner()
    if ManagedLoopRunnerActive then
        return
    end
    ManagedLoopRunnerActive = true
    task.spawn(function()
        while ManagedLoopRunnerActive do
            if ShouldStopManagedLoop() then
                table.clear(ManagedLoops)
                ManagedLoopRunnerActive = false
                break
            end
            local hasActiveLoop = false
            local now = os.clock()
            local due = nil
            for key, current in pairs(ManagedLoops) do
                if current then
                    hasActiveLoop = true
                    if now >= (current.nextRunAt or 0) then
                        -- Jadwalkan tembakan berikutnya dari TARGET, bukan dari waktu selesai
                        -- callback. Ini menghilangkan drift: periode = interval, bukan
                        -- interval + durasi kerja callback.
                        local interval = NormalizeManagedLoopInterval(current.interval)
                        current.interval = interval
                        local base = current.nextRunAt
                        if not base or base <= 0 then base = now end
                        current.nextRunAt = base + interval
                        if current.nextRunAt <= now then
                            -- Tertinggal lebih dari satu periode: sinkronkan ulang tanpa
                            -- menembak beruntun (mis. setelah lag / frame berat).
                            current.nextRunAt = now + interval
                        end
                        due = due or {}
                        due[#due + 1] = current
                    end
                end
            end
            -- Dispatch dilakukan SETELAH iterasi pairs() selesai supaya callback bebas
            -- memanggil Start/StopManagedLoop tanpa merusak iterasi, dan dijalankan lewat
            -- task.spawn supaya callback yang yield/berat tidak menahan runner ini maupun
            -- menggeser jadwal loop lain. Flag `busy` mencegah tumpang-tindih instance
            -- callback yang sama bila durasinya melebihi interval.
            if due then
                for _, current in ipairs(due) do
                    local shouldRun = true
                    if current.predicate then
                        local ok, result = pcall(current.predicate)
                        shouldRun = ok and result or false
                    end
                    if shouldRun and not current.busy then
                        current.busy = true
                        task.spawn(function()
                            pcall(current.callback)
                            current.busy = false
                        end)
                    end
                end
            end
            if not hasActiveLoop then
                ManagedLoopRunnerActive = false
                break
            end
            task.wait(GetManagedLoopSleep(os.clock()))
        end
    end)
end

function StopManagedLoop(key)
    ManagedLoops[key] = nil
end

function StartManagedLoop(key, interval, predicate, callback)
    StopManagedLoop(key)
    local token = {
        interval = NormalizeManagedLoopInterval(interval),
        predicate = predicate,
        callback = callback,
        nextRunAt = 0
    }
    ManagedLoops[key] = token
    EnsureManagedLoopRunner()
    return token
end

function IsWindowReady()
    return Window and (not Window.Destroyed) and (not Window.Closed)
end

function StartWindowLoop(key, interval, callback, options)
    options = options or {}
    return StartManagedLoop(key, interval, function()
        if options.requireWindowReady and (not IsWindowReady()) then
            return false
        end
        if options.predicate then
            return options.predicate()
        end
        return true
    end, callback)
end

function StartStatusLoop(key, interval, callback)
    return StartWindowLoop(key, interval, callback, {
        requireWindowReady = true
    })
end

FM_CategoryDescriptions = {}
function FM_GetElementFrame(elem)
    return rawget(elem, "ElementFrame") or elem.UIElements and elem.UIElements.Main or rawget(elem, "GroupFrame")
end
Categories = {}
function FM_Add(cat, elem)
    if not Categories[cat] then
        Categories[cat] = {}
    end
    table.insert(Categories[cat], elem)
    local frame = FM_GetElementFrame(elem)
    if frame then
        frame.Visible = false
    end
    return elem
end
function FM_OnChange(selected)
    for name, elems in pairs(Categories) do
        local vis = name == selected
        for _, e in ipairs(elems) do
            local f = FM_GetElementFrame(e)
            if f then
                f.Visible = vis
            end
        end
    end
end

local function JSONPretty(val, indent)
    indent = indent or 0
    local valType = typeof(val) -- Menggunakan typeof untuk deteksi Instance

    if valType == "table" then
        local s = "{\n"
        for k, v in pairs(val) do
            local formattedKey = typeof(k) == "number" and tostring(k) or "\"" .. tostring(k) .. "\""
            s = s .. string.rep("    ", indent + 1) .. formattedKey .. ": " .. tostring(JSONPretty(v, indent + 1)) .. ",\n"
        end
        return s .. string.rep("    ", indent) .. "}"
    elseif valType == "string" then
        return "\"" .. val .. "\""
    elseif valType == "Instance" then
        -- PERBAIKAN: Jika objek adalah Instance, ambil jalur lengkapnya (Hierarchy)
        return "\"" .. val:GetFullName() .. "\""
    elseif valType == "function" then
        local info = debug.getinfo(val)
        return "\"function: " .. tostring(info.source) .. " | Line: " .. tostring(info.linedefined) .. "\""
    else
        -- Untuk tipe data lain seperti boolean, number, atau RBXScriptConnection
        local result = tostring(val)
        if valType == "number" or valType == "boolean" then
            return result
        else
            return "\"" .. result .. "\""
        end
    end
end
Modules = {}
local function requireModule(folder,configs)
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("ModuleScript") then
            configs[child.Name] = require(child)
        end
    end
end
local function requireRemote(folder,configs)
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("RemoteEvent")  or child:IsA("RemoteFunction") then
            configs[child.Name] = child
        end
    end
end
task.spawn(function()
    requireModule(ReplicatedStorage.Modules,Modules)
    -- requireRemote(ReplicatedStorage.Remotes,Remotes)
end)


local UpgradesModule = Modules.Upgrades
local EternityNum = Modules.EternityNum
local Manager = Modules.Manager
local UpgradeRemote = ReplicatedStorage.Remotes.Others.Upgrades
Options = {}
local function GetIconCurrency(Currency)
    if Currency == "Cake" then return GetIcon(128060885870663) end
    if Currency == "Gems" then return GetIcon(94608819086911) end
    Screen = LocalPlayer.PlayerGui.Screen.Values:FindFirstChild(Currency,true)
    if Screen then
        Icon = Screen:FindFirstChild("ImageLabel",true)
        if Icon then
            return Icon.Image
        end
    end
    return GetIcon(98866142472743)
end
table.insert(Options,{Title = "Automation",Icon = GetIcon(131036042070680)})
table.insert(Options,{Title = "Rune Forge",Icon = GetIcon(130771603262049)})
table.insert(Options,{Title = "Shards",Icon = GetIcon(71115136155824)})
CurrencyPriority = {
    "Cash", "Rebirths", "Clicks", "Bronze", "Iron",
    "Steak", "Sausage", "Wood", "Planks", "Paper", "Coins", "Strength", "Speed",
    "Power", "Cubes", "Spheres", "Dices", "Cake", "Gems", "Diamonds",
    "Shells", "Sand", "Fish", "Coconuts"
}
CurrencyRank = {}
for i, currency in ipairs(CurrencyPriority) do
    CurrencyRank[currency] = i
    table.insert(Options,{Title = currency,Icon = GetIconCurrency(currency)})
end
-- [[ MAIN TAB ]] --
MenuMain = Window:Section({
    Title = "Menu",
    Opened = true,
})
BoardsMain = MenuMain:Tab({
    Title = "Feature",
})
FM_CategorySelector = BoardsMain:Category({
    Default = "Automation",
    Options = Options,
    Callback = FM_OnChange
})
if FM_CategorySelector.ElementFrame then
    FM_CategorySelector.ElementFrame.Parent = BoardsMain.UIElements.ContainerFrameCanvas
    FM_CategorySelector.ElementFrame.Position = UDim2.new(0, 0, 0, BoardsMain.UIElements.ContainerFrame.Position.Y.Offset)
    local catSize = FM_CategorySelector.ElementFrame.Size.Y.Offset
    BoardsMain.UIElements.ContainerFrame.Position = UDim2.new(0, 0, 0, BoardsMain.UIElements.ContainerFrame.Position.Y.Offset + catSize)
    BoardsMain.UIElements.ContainerFrame.Size = UDim2.new(1, 0, 1, BoardsMain.UIElements.ContainerFrame.Size.Y.Offset - catSize)
    local pad = BoardsMain.UIElements.ContainerFrame:FindFirstChildOfClass("UIPadding")
    if pad then
        pad.PaddingTop = UDim.new(0, 5)
    end
end
local function GetColorFromSequence(colorSequence, t)
    t = math.clamp(t, 0, 1)
    local keypoints = colorSequence.Keypoints

    if #keypoints == 1 then
        return keypoints[1].Value
    end

    for i = 1, #keypoints - 1 do
        local k1 = keypoints[i]
        local k2 = keypoints[i + 1]
        if t >= k1.Time and t <= k2.Time then
            local alpha = (t - k1.Time) / (k2.Time - k1.Time)
            return k1.Value:Lerp(k2.Value, alpha)
        end
    end

    -- fallback
    return keypoints[#keypoints].Value
end
local function Color3ToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
end

-- Bikin teks rune jadi gradient (terang -> warna asli -> gelap) dari 1 warna dasar
-- Memakai tag <gradient=...> yang didukung WindUI di Title/Desc
local function GetRuneGradientTag(color, text)
    local light = Color3.new(
        color.R + (1 - color.R) * 0.6,
        color.G + (1 - color.G) * 0.6,
        color.B + (1 - color.B) * 0.6
    )
    local dark = Color3.new(color.R * 0.55, color.G * 0.55, color.B * 0.55)
    return string.format("<gradient=%s,%s,%s>%s</gradient>",
        Color3ToHex(light), Color3ToHex(color), Color3ToHex(dark), text)
end

-- =====================================================
-- INISIALISASI DATA & VARIABEL
-- =====================================================
Config.Upgraders = Config.Upgraders or {}

local UpgradesModule = Modules.Upgrades
local EternityNum = Modules.EternityNum
local Manager = Modules.Manager
local UpgradeRemote = ReplicatedStorage.Remotes.Others.Upgrades

-- Cache nilai
UpgradeValueCache = {}
StatValueCache = {}

function GetUpgradeValueObj(upgName)
    local obj = UpgradeValueCache[upgName]
    if obj and obj.Parent == LocalPlayer.upgrades then
        return obj
    end
    obj = LocalPlayer.upgrades:FindFirstChild(upgName)
    if obj then UpgradeValueCache[upgName] = obj end
    return obj
end

function GetStatValueObj(statName)
    local obj = StatValueCache[statName]
    if obj and obj.Parent == LocalPlayer.stats then
        return obj
    end
    obj = LocalPlayer.stats:FindFirstChild(statName)
    if obj then StatValueCache[statName] = obj end
    return obj
end

-- Visibility, MaxLevel, Cost (dari client)
function checkVisible(upgradeData)
    if not upgradeData.Visible or #upgradeData.Visible == 0 then return true end
    for _, condition in ipairs(upgradeData.Visible) do
        local folder, stat, op, value = unpack(condition)
        local obj = LocalPlayer[folder] and LocalPlayer[folder]:FindFirstChild(stat)
        if obj then
            local val = obj.Value
            local target = tonumber(value)
            if op == ">=" and not EternityNum.meeq(val, target) then return false end
            if op == "<=" and not EternityNum.leeq(val, target) then return false end
            if op == "==" and not EternityNum.eq(val, target) then return false end
            if op == ">"  and not EternityNum.me(val, target) then return false end
            if op == "<"  and not EternityNum.le(val, target) then return false end
        end
    end
    return true
end

function calcMaxLevel(upgradeData)
    local maxLevel = tonumber(upgradeData.Max) or 1
    if upgradeData.Increase then
        for _, inc in ipairs(upgradeData.Increase) do
            local folder, stat, op, value, action, amount = unpack(inc)
            local obj = LocalPlayer[folder] and LocalPlayer[folder]:FindFirstChild(stat)
            if obj then
                local val = obj.Value
                local target = tonumber(value)
                local conditionMet = false
                if op == ">=" then conditionMet = target <= val
                elseif op == ">" then conditionMet = target < val
                elseif op == "<=" then conditionMet = val <= target
                elseif op == "<" then conditionMet = val < target
                elseif op == "==" then conditionMet = val == target end
                if conditionMet then
                    local amt = tonumber(amount)
                    if action == "+=" then maxLevel = maxLevel + amt
                    elseif action == "-=" then maxLevel = maxLevel - amt
                    elseif action == "*=" then maxLevel = maxLevel * amt
                    elseif action == "/=" then maxLevel = maxLevel / amt end
                end
            end
        end
    end
    return math.floor(maxLevel)
end

function calcCost(upgradeData, level)
    local baseCost = tonumber(upgradeData.BaseCost) or 1
    local costScaling = tonumber(upgradeData.Costscaling) or 1
    if baseCost <= 0 then baseCost = 1 end
    if costScaling <= 0 then costScaling = 1 end

    if upgradeData.HigherBaseCost then
        for _, h in ipairs(upgradeData.HigherBaseCost) do
            local stat, op, value, action, newBase = unpack(h)
            local obj = LocalPlayer.upgrades:FindFirstChild(stat)
            if obj then
                local val = obj.Value
                local target = tonumber(value)
                local cond = false
                if op == ">=" then cond = target <= val
                elseif op == ">" then cond = target < val
                elseif op == "<=" then cond = val <= target
                elseif op == "<" then cond = val < target
                elseif op == "==" then cond = val == target end
                if cond and action == "BaseCost" then
                    baseCost = tonumber(newBase) or baseCost
                end
            end
        end
    end

    if upgradeData.HigherScaling then
        for _, h in ipairs(upgradeData.HigherScaling) do
            local stat, op, value, action, newScale = unpack(h)
            local obj = LocalPlayer.upgrades:FindFirstChild(stat)
            if obj then
                local val = obj.Value
                local target = tonumber(value)
                local cond = false
                if op == ">=" then cond = target <= val
                elseif op == ">" then cond = target < val
                elseif op == "<=" then cond = val <= target
                elseif op == "<" then cond = val < target
                elseif op == "==" then cond = val == target end
                if cond and action == "Costscaling" then
                    costScaling = tonumber(newScale) or costScaling
                end
            end
        end
    end

    local eBase = EternityNum.fromNumber(baseCost)
    local eScale = EternityNum.fromNumber(costScaling)
    local eLevel = EternityNum.fromNumber(level)
    return EternityNum.mul(eBase, EternityNum.pow(eScale, eLevel))
end

function safeManagerText(value, formatType)
    return Manager.Text(LocalPlayer, value, formatType)
end

function getRewardText(upgradeData, level)
    local maxLevel = calcMaxLevel(upgradeData)
    local isMaxed = level >= maxLevel
    local sym = upgradeData.Symbol
    local give = tonumber(upgradeData.SymbolGive) or 1

    if sym == "+" then
        local cur = EternityNum.add(level, give)
        if isMaxed then
            return "+" .. safeManagerText(cur, "stats")
        else
            return "+" .. safeManagerText(cur, "stats") .. " > +" .. safeManagerText(EternityNum.add(level + 1, give), "stats")
        end
    elseif sym == "*" then
        local cur = EternityNum.add(EternityNum.mul(level, give), 1)
        if isMaxed then
            return "x" .. safeManagerText(cur, "stats")
        else
            return "x" .. safeManagerText(cur, "stats") .. " > x" .. safeManagerText(EternityNum.add(EternityNum.mul(level + 1, give), 1), "stats")
        end
    elseif sym == "^" then
        local cur = EternityNum.pow(EternityNum.fromNumber(give), EternityNum.fromNumber(level))
        local nxt = EternityNum.pow(EternityNum.fromNumber(give), EternityNum.fromNumber(level + 1))
        if isMaxed then
            return "x" .. safeManagerText(cur, "stats")
        else
            return "x" .. safeManagerText(cur, "stats") .. " > x" .. safeManagerText(nxt, "stats")
        end
    elseif sym == "-" then
        local ifminus = tonumber(upgradeData.ifminus) or 3
        local cur = ifminus - level * give
        local nxt = ifminus - (level + 1) * give
        local curDisplay = math.floor(cur * 10 + 0.5) / 10
        local nxtDisplay = math.floor(nxt * 10 + 0.5) / 10
        if isMaxed then
            return curDisplay .. "s"
        else
            return curDisplay .. "s > " .. nxtDisplay .. "s"
        end
    elseif sym == "++" then
        local ifpp = tonumber(upgradeData["if++"]) or 0
        local cur = EternityNum.add(ifpp, EternityNum.mul(level, give))
        if isMaxed then
            return safeManagerText(cur, "stats")
        else
            return safeManagerText(cur, "stats") .. " > " .. safeManagerText(EternityNum.add(ifpp, EternityNum.mul(level + 1, give)), "stats")
        end
    end
    return ""
end



-- =====================================================
-- RESET SYSTEM (StartManagedLoop per Reset)
-- =====================================================
Boosts = Modules.Boosts
ResetRemote = ReplicatedStorage.Remotes.Others.ResetLayers

ResetTypes = {
    Rebirth = {
        Cost = { Number = 1000, Currency = "Cash" },
        StatGet = "Rebirths",
        PowExponent = 1
    },
    Iron = {
        Cost = { Number = 50000000, Currency = "Bronze" },
        StatGet = "Iron",
        PowExponent = 0.2
    },
    Gold = {
        Cost = { Number = 100000000000, Currency = "Iron" },
        StatGet = "Gold",
        PowExponent = 0.2
    },
    Sausage = {
        Cost = { Number = 2500000000000, Currency = "Steak" },
        StatGet = "Sausage",
        PowExponent = 1
    },
    Planks = {
        Cost = { Number = 10000, Currency = "Wood" },
        StatGet = "Planks",
        PowExponent = 0.5
    },
    Coins = {
        Cost = { Number = 5000000000000000, Currency = "Paper" },
        StatGet = "Coins",
        PowExponent = 0.5,
        Remote = ReplicatedStorage.Remotes.Features.Coins
    },
    Sand = {
        Cost = { Number = 1000000, Currency = "Shells" },
        StatGet = "Sand",
        PowExponent = 0.5
    },
    Sun = {
        Cost = { Number = 50000000, Currency = "Coconuts" },
        StatGet = "Sun",
        PowExponent = 0.4
    },
    Spheres = {
        Cost = { Number = "1e35", Currency = "Cubes" },
        StatGet = "Spheres",
        PowExponent = 0.4
    },
    Cake = {
        Cost = { Number = 100, Currency = "Blueberry" },
        StatGet = "Cake",
        PowExponent = 1
    },
    Power = {
        Cost = { Strength = "1e24", Speed = "1e13" },
        StatGet = "Power",
        PowExponent = 1
    }
}

ResetOrder = { "Rebirth", "Iron", "Gold", "Sausage", "Planks", "Coins", "Sand", "Sun", "Power","Spheres","Cake"}

-- Min gain default
Config.AutoFarm = Config.AutoFarm or {}
Config.AutoFarm.RebirthMinGain = 5
Config.AutoFarm.IronMinGain = 1

-- Tabel toggle
ResetToggles = {}

-- Fungsi autoReset (tidak diubah)
function autoReset(resetType)
    local config = ResetTypes[resetType]
    if not config then return false, "Unknown" end

    if resetType == "Power" then
        local strengthCost = EternityNum.fromString(config.Cost.Strength)
        local speedCost = EternityNum.fromString(config.Cost.Speed)
        local strengthObj = GetStatValueObj("Strength")
        local speedObj = GetStatValueObj("Speed")
        if not (strengthObj and speedObj) then return false, "Missing Strength/Speed" end
        if not (EternityNum.meeq(strengthObj.Value, strengthCost) and EternityNum.meeq(speedObj.Value, speedCost)) then
            return false, "Need Strength & Speed"
        end
    else
        local currencyObj = GetStatValueObj(config.Cost.Currency)
        if not currencyObj then return false, "Missing currency" end
        if not EternityNum.meeq(currencyObj.Value, config.Cost.Number) then
            return false, string.format("Need %s %s", safeManagerText(config.Cost.Number, "stats"), config.Cost.Currency)
        end
    end

    local currencyValue, minAmount
    if resetType == "Power" then
        local strengthObj = GetStatValueObj("Strength")
        if not strengthObj then return false, "Missing Strength" end
        currencyValue = strengthObj.Value
        minAmount = EternityNum.fromString(config.Cost.Strength)
    else
        local currencyObj = GetStatValueObj(config.Cost.Currency)
        if not currencyObj then return false, "Missing currency" end
        currencyValue = currencyObj.Value
        minAmount = EternityNum.fromNumber(config.Cost.Number)
    end

    local divResult = EternityNum.div(currencyValue, minAmount)
    local baseReward
    if config.PowExponent and config.PowExponent ~= 1 then
        baseReward = EternityNum.pow(divResult, EternityNum.fromNumber(config.PowExponent))
    else
        baseReward = divResult
    end

    local boost = 1
    pcall(function()
        if Boosts[resetType] then boost = Boosts[resetType](Player) end
    end)

    local totalReward = EternityNum.mul(baseReward, boost)
    local minGain = Config.AutoFarm[resetType .. "MinGain"] or config.MinGain or 1
    if EternityNum.le(totalReward, minGain) then
        return false, string.format("Gain < %d %s", minGain, config.StatGet)
    end

    local rewardText = safeManagerText(totalReward, "stats")
    if config.Remote then
        pcall(function() config.Remote:FireServer() end)
    else
        pcall(function() ResetRemote:FireServer(resetType) end)
    end
    return true, string.format("+%s %s", rewardText, config.StatGet)
end

-- Pewarnaan (fungsi Coloring boleh diambil dari definisi sebelumnya, jika tidak ada, definisikan di sini)

-- Update deskripsi semua toggle reset
function UpdateResetDescriptions()
    for _, resetType in ipairs(ResetOrder) do
        local config = ResetTypes[resetType]
        local toggle = ResetToggles[resetType]
        if not (config and toggle) then continue end
        local ano = resetType
        if resetType == "Rebirth" then
            ano = "Rebirths"
        end
        UpgradeGUI = nil
        local descLines = {}
        task.spawn(function()
            pcall(function()
                UpgradeGUI = LocalPlayer.PlayerGui.Features:FindFirstChild(ano,true).Board:WaitForChild("Container")
            end)
        end)
        if not UpgradeGUI then
            task.spawn(function()
                UpgradeGUI = LocalPlayer.PlayerGui.SummerFeatures:FindFirstChild(ano,true).Board:WaitForChild("Container")
            end)
        end
        table.insert(descLines,UpgradeGUI.Desc.Text)
        if resetType == "Coins" then
            table.insert(descLines,UpgradeGUI.Current.Text)
            table.insert(descLines,UpgradeGUI.Next.Text)
        else
            table.insert(descLines,string.format("<font color=\"#%s\">%s</font>",UpgradeGUI.Amount:FindFirstChild("UIStroke").Color:ToHex(),UpgradeGUI.Amount.Text))
        end
        table.insert(descLines,UpgradeGUI.Requirement.Text)
        SafeSetDesc(toggle, table.concat(descLines, "\n"))
    end
end

-- Buat toggle untuk setiap reset
local currentGroup = nil
local countInGroup = 0
for _, resetType in ipairs(ResetOrder) do
    local config = ResetTypes[resetType]

    local toggle = BoardsMain:Toggle({
        Title = resetType,
        Flag = "AutoFarm_" .. resetType .. "_Cfg",
        Callback = function(val)
            Config.Upgraders["Auto" .. resetType] = val
            if val then
                StartManagedLoop("AutoReset_" .. resetType, 0.5, function()
                    return Config.Upgraders["Auto" .. resetType] == true
                end, function()
                    autoReset(resetType)
                end)
            else
                StopManagedLoop("AutoReset_" .. resetType)
            end
        end
    })
    if config.StatGet == "Sun" then
        FM_Add("Coconuts", toggle)
    elseif config.StatGet == "Gold" then
        FM_Add("Iron", toggle)
    else
        FM_Add(config.StatGet, toggle)
    end

    SafeSetMainImage(toggle, GetIconCurrency(config.StatGet), 30)
    ResetToggles[resetType] = toggle
end

-- Status loop untuk deskripsi
StartStatusLoop("Status_ResetDescriptions", 0.5, function()
    UpdateResetDescriptions()
end)
-- =====================================================
-- AUTO ROLL DICE (KLIK TOMBOL)
-- =====================================================
-- Config.Upgraders.AutoRollDice = false

-- local function findDiceRollButton()
--     local DicesBoard = LocalPlayer.PlayerGui:FindFirstChild("Features")
--     if not DicesBoard then return nil end
--     DicesBoard = DicesBoard:FindFirstChild("Dices")
--     if not DicesBoard then return nil end
--     DicesBoard = DicesBoard:FindFirstChild("Board")
--     if not DicesBoard then return nil end
--     DicesBoard = DicesBoard:FindFirstChild("Container")
--     if not DicesBoard then return nil end
--     return DicesBoard:FindFirstChild("TextButton")
-- end


-- local AutoRollDiceToggle = BoardsMain:Toggle({
--     Title = "Auto Roll Dice",
--     Image = GetIconCurrency("Dices"),
--     Flag = "AutoFarm_DiceRoll_Cfg",
--     Callback = function(val)
--         Config.Upgraders.AutoRollDice = val
--         if val then
--             StartManagedLoop("AutoRollDice", 2, function()
--                 return Config.Upgraders.AutoRollDice
--             end, function()
--                 local button = findDiceRollButton()
--                 if button then
--                     -- Memicu event Activated pada tombol GUI
--                     pcall(function()
--                         button.Activated:Fire()
--                     end)
--                 end
--             end)
--         else
--             StopManagedLoop("AutoRollDice")
--         end
--     end
-- })
-- FM_Add("Dices", AutoRollDiceToggle)

-- -- Status loop
-- StartStatusLoop("Status_AutoRollDice", 1, function()
--     if not AutoRollDiceToggle then return end
--     local button = findDiceRollButton()
--     local statusText
--     if button then
--         statusText = "🟢 Auto Roll aktif\n🎲 Menekan tombol dadu..."
--     else
--         statusText = "🔴 Tombol dadu tidak ditemukan"
--     end
--     SafeSetDesc(AutoRollDiceToggle, statusText)
-- end)
-- =====================================================
-- CUBE TIER (StartManagedLoop + StartStatusLoop)
-- =====================================================
CubeTierRemote = ReplicatedStorage.Remotes.Features.CubeTier
CubeTierCosts = {
    { Amount = "1e9",   Currency = "Cubes" },
    { Amount = "2.5e12",Currency = "Cubes" },
    { Amount = "5e16",  Currency = "Cubes" },
    { Amount = "2.5e21",Currency = "Cubes" },
    { Amount = "5e27",  Currency = "Cubes" },
    { Amount = "1e30",  Currency = "Cubes" },
    { Amount = "2.5e31",Currency = "Cubes" },
    { Amount = "1e33",  Currency = "Cubes" },
    { Amount = "1e37",  Currency = "Cubes" },
    { Amount = "1e46",  Currency = "Cubes" },
    { Amount = "1e55",  Currency = "Cubes" },
    { Amount = "5e58",  Currency = "Cubes" },
    { Amount = "1e63",  Currency = "Cubes" },
    { Amount = "5e64",  Currency = "Cubes" }
}
CubeCurrencyColor = "#34d2eb"

function autoCubeTier()
    local currentTier = LocalPlayer.stats.CubeTier.Value
    if currentTier >= #CubeTierCosts then
        return false, "MAXED"
    end

    local costData = CubeTierCosts[currentTier + 1]
    local requiredAmount = EternityNum.fromString(costData.Amount)
    local playerCubes = LocalPlayer.stats.Cubes.Value

    if EternityNum.meeq(playerCubes, requiredAmount) then
        pcall(function()
            CubeTierRemote:FireServer()
        end)
        return true, "TIER UP!"
    end

    return false, string.format("Need %s %s", safeManagerText(requiredAmount, "stats"), costData.Currency)
end

AutoCubeTierToggle = BoardsMain:Toggle({
    Title = "Cube Tier",
    Image = GetIconCurrency("Cubes"),
    Flag = "Reset_CubeTier_Cfg",
    Callback = function(val)
        Config.Upgraders.AutoCubeTier = val
        if val then
            StartManagedLoop("CubeTier", 0.5, function()
                return Config.Upgraders.AutoCubeTier
            end, function()
                autoCubeTier()
            end)
        else
            StopManagedLoop("CubeTier")
        end
    end
})
FM_Add("Cubes", AutoCubeTierToggle)
task.spawn(function()
    StartStatusLoop("Status_CubeTier", 0.5, function()
    if not AutoCubeTierToggle then return end
    UI = LocalPlayer.PlayerGui.Features.CubeTier.Board:WaitForChild("Container")
    desc = {}
    table.insert(desc,UI.desc.Text)
    table.insert(desc,UI.TextLabel.Text)

    local currentTier = LocalPlayer.stats.CubeTier.Value
    local maxTier = #CubeTierCosts
    local descText

    if currentTier >= maxTier then
        descText = "🧊 Cube Tier MAXED (" .. maxTier .. "/" .. maxTier .. ")"
    else
        local costData = CubeTierCosts[currentTier + 1]
        local costAmount = EternityNum.fromString(costData.Amount)
        local playerCubes = LocalPlayer.stats.Cubes.Value
        local canBuy = EternityNum.meeq(playerCubes, costAmount)
        local costText = safeManagerText(costAmount, "stats")
        local ownedText = safeManagerText(playerCubes, "stats")
        local currencyColored = '<font color="' .. CubeCurrencyColor .. '">Cubes</font>'
        local icon = canBuy and "🟢" or "🔴"
        descText = string.format("%s\n%s Cost: %s %s\n💰 Owned: %s",table.concat(desc, "\n"), icon, costText, currencyColored, ownedText)
    end

    SafeSetDesc(AutoCubeTierToggle, descText)
    end)
end)
-- =====================================================
-- SORTING BERDASARKAN CURRENCY LALU PREFIX/INDEX
-- =====================================================

SortedUpgrades = {}
CurrencyOrder = {}
AllUpgradesOrdered = {}

for upgradeName, upgradeData in pairs(UpgradesModule.Upgrades) do
    local currency = type(upgradeData) == "table" and upgradeData.Currency or nil
    if currency then
        if not SortedUpgrades[currency] then
            SortedUpgrades[currency] = {}
            table.insert(CurrencyOrder, currency)
        end
        local prefix, index = string.match(upgradeName, "^(.-)Upgrade(%d+)$")
        table.insert(SortedUpgrades[currency], {
            name = upgradeName,
            data = upgradeData,
            prefix = prefix or upgradeName,
            index = tonumber(index) or math.huge
        })
    end
end

table.sort(CurrencyOrder, function(a, b)
    local rankA, rankB = CurrencyRank[a], CurrencyRank[b]
    if rankA and rankB then return rankA < rankB end
    if rankA then return true end
    if rankB then return false end
    return a < b
end)

for _, currency in ipairs(CurrencyOrder) do
    table.sort(SortedUpgrades[currency], function(a, b)
        if a.prefix ~= b.prefix then return a.prefix < b.prefix end
        if a.index ~= b.index then return a.index < b.index end
        return a.name < b.name
    end)
end

for _, currency in ipairs(CurrencyOrder) do
    for _, entry in ipairs(SortedUpgrades[currency]) do
        table.insert(AllUpgradesOrdered, entry)
    end
end

-- =====================================================
-- MEMBUAT TOGGLE PER UPGRADE DENGAN STARTMANAGEDLOOP
-- =====================================================
UpgradeToggles = {}
local groupSize = 2
local currentGroup = nil
local countInGroup = 0
local currentGroupCategory = nil

for _, entry in ipairs(AllUpgradesOrdered) do
    local upgradeName = entry.name
    local upgradeData = entry.data
    local currency = upgradeData.Currency
    local displayName = upgradeData.Name
    local targetCategory = currency

    if countInGroup % groupSize == 0 or currentGroupCategory ~= targetCategory then
        currentGroup = BoardsMain:Group({})
        FM_Add(targetCategory, currentGroup)
        currentGroupCategory = targetCategory
        countInGroup = 0
    end

    local toggle = currentGroup:Toggle({
        Title = string.format("[%s] %s", currency, displayName),
        Flag = "Upgrades_" .. upgradeName,
        Value = false,
        Callback = function(val)
            Config.Upgraders[upgradeName] = val
            if val then
                StartManagedLoop("AutoUpg_" .. upgradeName, 0.5, function()
                    return Config.Upgraders[upgradeName] == true
                end, function()
                    if not checkVisible(upgradeData) then return end
                    local upgObj = GetUpgradeValueObj(upgradeData.UpgName)
                    if not upgObj then return end
                    local currentLevel = upgObj.Value
                    local maxLevel = calcMaxLevel(upgradeData)
                    if currentLevel >= maxLevel then return end

                    local cost = calcCost(upgradeData, currentLevel)
                    local currencyObj = GetStatValueObj(currency)
                    if not currencyObj then return end
                    if EternityNum.meeq(currencyObj.Value, cost) then
                        pcall(function()
                            UpgradeRemote:FireServer(upgradeName, "Max")
                        end)
                    end
                end)
            else
                StopManagedLoop("AutoUpg_" .. upgradeName)
            end
        end
    })

    UpgradeToggles[upgradeName] = toggle
    countInGroup = countInGroup + 1
end

-- =====================================================
-- STATUS UPDATE UNTUK SEMUA TOGGLE
-- =====================================================
LastStatusText = {}

function updateToggleStatus(upgradeName, upgradeData, toggle)
    UpgradeGUI = LocalPlayer:FindFirstChild(upgradeName,true)
    SafeSetMainImage(toggle,UpgradeGUI.Image.Image,30)
    local upgObj = GetUpgradeValueObj(upgradeData.UpgName)
    local currentLevel = upgObj and upgObj.Value or 0
    local maxLevel = calcMaxLevel(upgradeData)
    local visible = checkVisible(upgradeData)
    local UIGradient = UpgradeGUI.UpgName.UIGradient.Color
    local csolor = GetColorFromSequence(UIGradient, 0.5)
    local UpgName = GetRuneGradientTag(csolor,UpgradeGUI.UpgName.Text)
    local UIGradient = UpgradeGUI.UpgGive.UIGradient.Color
    local csolor = GetColorFromSequence(UIGradient, 0.5)
    local UpgGive = GetRuneGradientTag(csolor,UpgradeGUI.UpgGive.Text)
    local titleText = string.format("%s %s",UpgName,UpgradeGUI.UpgMax.Text)
    local descText = {}
    local currencyName = upgradeData.Currency

    if not visible then
        toggle:Lock("🔒 Locked")
    else
        toggle:Unlock()
    end
    table.insert(descText,string.format("%s", UpgGive))

    if currentLevel >= maxLevel then
        table.insert(descText,UpgradeGUI.UpgCost.Text)
        toggle:Disable()
    else
        table.insert(descText,UpgradeGUI.UpgCost.Text .. GetIconCurrency(upgradeData.Currency))
        toggle:Enable()
    end

    SafeSetTitle(toggle, titleText)
    SafeSetDesc(toggle, table.concat(descText,"\n"))
end

StartStatusLoop("Status_UpgradeToggles", 0.5, function()
    for _, currency in ipairs(CurrencyOrder) do
        for _, entry in ipairs(SortedUpgrades[currency]) do
            local toggle = UpgradeToggles[entry.name]
            if toggle then
                updateToggleStatus(entry.name, entry.data, toggle)
            end
        end
    end
end)
-- =====================================================
-- AUTO UPGRADE TREE (StartManagedLoop)
-- =====================================================
local UpgradeTreeModule = Modules.UpgradeTree
local UpgradeTreeData = UpgradeTreeModule.UpgradeTree
local UpgradeTreeRemote = ReplicatedStorage.Remotes.Features.UpgradeTree
local UpgradeTreeFolder = LocalPlayer:WaitForChild("UpgradeTree")
local StatsFolder = LocalPlayer:WaitForChild("stats")

-- Cache nilai
local function getTreeValue(folder, name)
    return folder and folder:FindFirstChild(name)
end

-- Fungsi checkUnlock (sama seperti client)
local function checkTreeUnlock(upgradeData, upgradeName)
    if upgradeName then
        local ownObj = getTreeValue(UpgradeTreeFolder, upgradeName)
        if ownObj and EternityNum.meeq(ownObj.Value, 1) then
            return true
        end
    end
    if not upgradeData.Unlocks then return true end
    for _, cond in ipairs(upgradeData.Unlocks) do
        local folderName, statName, op, target = unpack(cond)
        local folder = LocalPlayer:FindFirstChild(folderName)
        if not folder then return false end
        local obj = folder:FindFirstChild(statName)
        if not obj then return false end
        local val = obj.Value
        local targetVal = target
        if op == "meeq" then
            if not EternityNum.meeq(val, targetVal) then return false end
        elseif op == "me" then
            if not EternityNum.me(val, targetVal) then return false end
        elseif op == "leeq" then
            if not EternityNum.leeq(val, targetVal) then return false end
        elseif op == "le" then
            if not EternityNum.le(val, targetVal) then return false end
        elseif op == "eq" then
            if typeof(val) == "boolean" then
                if val ~= targetVal then return false end
            else
                if not EternityNum.eq(val, targetVal) then return false end
            end
        else
            return false
        end
    end
    return true
end

-- Fungsi untuk menghitung biaya
local function getTreeCost(upgradeData, level)
    local baseCost = upgradeData.Cost.BaseCost
    local scale = upgradeData.Cost.Scale
    if level > 0 then
        local eBase = EternityNum.fromNumber(baseCost)
        local eScale = EternityNum.fromNumber(scale)
        local eLevel = EternityNum.fromNumber(level)
        return EternityNum.mul(eBase, EternityNum.pow(eScale, eLevel))
    else
        return EternityNum.fromNumber(baseCost)
    end
end

-- Urutkan node berdasarkan nama
local TreeNodesOrdered = {}
for name, data in pairs(UpgradeTreeData) do
    table.insert(TreeNodesOrdered, {name = name, data = data})
end
table.sort(TreeNodesOrdered, function(a, b) return a.name < b.name end)

-- Toggle Auto Upgrade Tree
Config.Upgraders.AutoUpgradeTree = false

-- =====================================================
-- AUTO MOVE TO FIRST CLIENT SCRAP
-- =====================================================
Config.AutoMoveScrap = false

local function getFirstClientScrap()
    local scrapsFolder = Workspace:FindFirstChild("ClientScraps")
    if not scrapsFolder then return nil end

    for _, child in ipairs(scrapsFolder:GetChildren()) do
        if child:IsA("BasePart") then
            return child
        end
    end
    return nil
end
Yuhu = BoardsMain:Group({})
local AutoMoveScrapToggle = Yuhu:Toggle({
    Title = "Farm Scrap",
    Image = GetIcon(126864658174743),
    Flag = "Automation_MoveFirstScrap_Cfg",
    Value = false,
    Callback = function(val)
        Config.AutoMoveScrap = val
        if val then
            StartManagedLoop("AutoMoveFirstScrap", 0.5, function()
                return Config.AutoMoveScrap
            end, function()
                local character = LocalPlayer.Character
                if not character then return end

                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid then return end

                local target = getFirstClientScrap()
                if not target then return end

                humanoid:MoveTo(target.Position)
            end)
        else
            StopManagedLoop("AutoMoveFirstScrap")
        end
    end
})
local AutoUpgradeTreeToggle = Yuhu:Toggle({
    Title = "🌳 Auto Upgrade Tree",
    Flag = "Upgrades_AutoUpgradeTree",
    Callback = function(val)
        Config.Upgraders.AutoUpgradeTree = val
        if val then
            StartManagedLoop("AutoUpgradeTree", 0.5, function()
                return Config.Upgraders.AutoUpgradeTree
            end, function()
                for _, entry in ipairs(TreeNodesOrdered) do
                    local name = entry.name
                    local data = entry.data
                    if checkTreeUnlock(data, name) then
                        local lvlObj = UpgradeTreeFolder:FindFirstChild(name)
                        local level = lvlObj and lvlObj.Value or 0
                        if level < data.Max then
                            local cost = getTreeCost(data, level)
                            local currencyObj = StatsFolder:FindFirstChild(data.Cost.Currency)
                            if currencyObj and EternityNum.meeq(currencyObj.Value, cost) then
                                pcall(function()
                                    UpgradeTreeRemote:FireServer(name)
                                end)
                            end
                        end
                    end
                end
            end)
        else
            StopManagedLoop("AutoUpgradeTree")
        end
    end
})
FM_Add("Automation", Yuhu)

-- Status loop
StartStatusLoop("Status_AutoUpgradeTree", 1, function()
    if not AutoUpgradeTreeToggle then return end
    local unlockedCount = 0
    local affordableCount = 0
    local maxedCount = 0
    local totalCount = #TreeNodesOrdered
    for _, entry in ipairs(TreeNodesOrdered) do
        local name = entry.name
        local data = entry.data
        if checkTreeUnlock(data, name) then
            unlockedCount = unlockedCount + 1
            local lvlObj = UpgradeTreeFolder:FindFirstChild(name)
            local level = lvlObj and lvlObj.Value or 0
            if level >= data.Max then
                maxedCount = maxedCount + 1
            else
                local cost = getTreeCost(data, level)
                local currencyObj = StatsFolder:FindFirstChild(data.Cost.Currency)
                if currencyObj and EternityNum.meeq(currencyObj.Value, cost) then
                    affordableCount = affordableCount + 1
                end
            end
        end
    end
    local desc = string.format(
        "Unlocked: %d/%d\nAffordable: %d\nMaxed: %d",
        unlockedCount, totalCount, affordableCount, maxedCount
    )
    SafeSetDesc(AutoUpgradeTreeToggle, desc)
end)


local function ResolveFarmTouchParts(partOrResolver)
    if type(partOrResolver) == "function" then
        local ok, result = pcall(partOrResolver)
        if ok then
            return result
        end
        return nil
    end

    return partOrResolver
end

local function FireFarmTouch(root, target, touchState)
    if not root or not target then
        return
    end

    if type(target) == "table" then
        for _, part in ipairs(target) do
            FireFarmTouch(root, part, touchState)
        end
        return
    end

    if target.Name == "COCONUTSSPAWN" then
        for _, part in ipairs(target:GetChildren()) do
            pcall(function()
                firetouchinterest(root, part, touchState)
            end)
        end
    else
        pcall(function()
            firetouchinterest(root, target, touchState)
        end)
    end
end

local function GetButtonsTouchParts()
    local touchParts = {}
    local world = Workspace:FindFirstChild("World")
    local features = world and world:FindFirstChild("Features")
    local buttons = features and features:FindFirstChild("Buttons")

    if not buttons then
        return touchParts
    end

    for _, button in ipairs(buttons:GetChildren()) do
        local touchPart = button:FindFirstChild("TouchPart")
        if touchPart then
            table.insert(touchParts, touchPart)
        end
    end

    return touchParts
end

function FarmFireTouch(getState, Part)
    while getState() do
        if Window.Destroyed then
            break
        end

        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        FireFarmTouch(root, ResolveFarmTouchParts(Part), 0)
        task.wait(0.1)
    end

    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    FireFarmTouch(root, ResolveFarmTouchParts(Part), 1)
end

-- Data definisi tiap toggle Auto Farm: tinggal tambah 1 baris di sini kalau mau nambah farm baru,
-- tidak perlu tulis ulang blok Toggle/Callback/FarmFireTouch tiap kali.
-- GetPart dibuat function (bukan value langsung) supaya Part-nya baru di-resolve saat toggle
-- dinyalakan, bukan saat script dimuat (aman kalau Part-nya belum ada, misal fitur musiman).
local FarmToggleGroups = {
    {
        { Title = "Wood", Image = GetIcon(105244998457244), Flag = "WoodFarm_Cfg", Key = "AutoFarmWood",
            GetPart = function() return workspace.World.Others.WoodGainPart end },
        { Title = "Paper", Image = GetIcon(85206068391092), Flag = "PaperFarm_Cfg", Key = "AutoFarmPaper",
            GetPart = function() return workspace.World.Features.Paper.Button.TouchPart end },
    },
    {
        { Title = "Coconuts", Image = GetIconCurrency("Coconuts"), Flag = "Summer_CoconutFarm_Cfg", Key = "AutoFarmCoconut",
            GetPart = function() return workspace.World.SummerFeatures.COCONUTSSPAWN end },
        { Title = "Shrines", Image = GetIcon(88061784222994), Flag = "AutoFarmShrines_Cfg", Key = "AutoFarmShrines",
            GetPart = function() return workspace.World.Features.Shrines.Button.TouchPart end },
    },
    {
        { Title = "Bronze", Image = GetIcon(135211014528277), Flag = "AutoFarmBronze_Cfg", Key = "AutoFarmBronze",
            GetPart = function() return workspace.World.Features.Bronze.Button.TouchPart end },
    },
}

local function CreateFarmToggle(group, def)
    group:Toggle({
        Title = def.Title,
        Image = def.Image,
        Flag = def.Flag,
        Callback = function(val)
            Config.Upgraders[def.Key] = val
            FarmFireTouch(function()
                return Config.Upgraders[def.Key]
            end, def.GetPart)
        end
    })
end

for _, group in ipairs(FarmToggleGroups) do
    FarmGroups = BoardsMain:Group({})
    for _, def in ipairs(group) do
        CreateFarmToggle(FarmGroups, def)
    end
    FM_Add("Automation", FarmGroups)
end
-- Cache Frame "Right" tiap board biar gak query ulang tiap detik
local BoardRightCache = {}
local function GetBoardRight(cacheKey, pathFn)
    local cached = BoardRightCache[cacheKey]
    if cached and cached.Parent then
        return cached
    end
    local ok, result = pcall(pathFn)
    if ok and result then
        BoardRightCache[cacheKey] = result
        return result
    end
    return nil
end

-- Ambil teks Boost dari frame level tertentu, contoh: Right["1"].Boost.Text
local function GetBoostText(rightFrame, level)
    if not rightFrame then return nil end
    local ok, levelFrame = pcall(function() return rightFrame:FindFirstChild(tostring(level)) end)
    if not ok or not levelFrame then return nil end
    local boostLabel = levelFrame:FindFirstChild("Boost") or levelFrame:FindFirstChild("Boost", true)
    if not boostLabel then return nil end
    local text = levelFrame:FindFirstChild("number", true).Text .. " : ".. boostLabel.Text
    return (text ~= "" and text) or nil
end

-- Gabungkan semua Boost yang sudah dimiliki (level 1..currentLevel) jadi satu baris teks
local function BuildOwnedBoostsText(rightFrame, currentLevel)
    local owned = {}
    for i = 1, currentLevel do
        local text = GetBoostText(rightFrame, i)
        if text then
            table.insert(owned, text)
        end
    end
    return #owned > 0 and "\n" .. table.concat(owned, "\n") or "-"
end

local function findRuneForgeTable(targetFirstRune)
    for _, obj in pairs(getgc(true)) do
        if type(obj) == "table" then
            local first = rawget(obj, "1")
            if type(first) == "table" then
                local runeVal = rawget(first, "rune")
                if runeVal == targetFirstRune then
                    -- Pastikan ada currency & color
                    if rawget(first, "currency") ~= nil then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end
local function getRuneForgeTable(typeName, targetFirstRune, fallbackTable)
    local cached = _G["RuneForgeTable_" .. typeName]
    if cached then return cached end

    local found = findRuneForgeTable(targetFirstRune)
    if found then
        _G["RuneForgeTable_" .. typeName] = found
        return found
    end
    return fallbackTable
end
local RuneForge1MData = getRuneForgeTable("1M", "1M Infinity", {})
Auto1MRuneForgeToggle = BoardsMain:Toggle({
    Title = "1M Rune Forge",
    Flag = "AutoFarm_1MRuneForge_Cfg",
    Callback = function(val)
        Config.Upgraders.Auto1MRuneForge = val
        if val then
            StartManagedLoop("Auto1MRuneForge", 1, function()
                return Config.Upgraders.Auto1MRuneForge
            end, function()
                local currentLevel = LocalPlayer.stats["1MRuneForge"].Value
                local costData = RuneForge1MData[tostring(currentLevel + 1)]
                if not costData then return end
                local runeObj = LocalPlayer.Runes:FindFirstChild(costData.rune)
                if runeObj and runeObj.Value >= costData.currency then
                    pcall(function()
                        ReplicatedStorage.Remotes.Features.Event1MRuneForge:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("Auto1MRuneForge")
        end
    end
})
FM_Add("Rune Forge", Auto1MRuneForgeToggle)

StartStatusLoop("Status_1MRuneForge", 1, function()
    if not Auto1MRuneForgeToggle then return end
    local currentLevel = LocalPlayer.stats["1MRuneForge"].Value
    local rightFrame = GetBoardRight("1MRuneForge", function()
        return LocalPlayer.PlayerGui.Features["1MRuneForge"].Board.Container.Right
    end)
    local ownedBoosts = BuildOwnedBoostsText(rightFrame, currentLevel)
    local costData = RuneForge1MData[tostring(currentLevel + 1)]
    if not costData then
        SafeSetDesc(Auto1MRuneForgeToggle, string.format("MAXED\nOwned Boost: %s", ownedBoosts))
        return
    end
    local runeObj = LocalPlayer.Runes:FindFirstChild(costData.rune)
    local owned = runeObj and runeObj.Value or 0
    local canBuy = owned >= costData.currency
    local icon = canBuy and "🟢" or "🔴"
    local coloredRune = GetRuneGradientTag(costData.color, costData.rune)
    local nextBoostText = GetBoostText(rightFrame, currentLevel + 1)
    local nextBoostLine = nextBoostText and nextBoostText or "-"
    SafeSetDesc(Auto1MRuneForgeToggle, string.format(
        "%s Cost: %s %s\n%s: %s\nOwned Boost: %s\n%s",
        icon, safeManagerText(costData.currency,"stats"), coloredRune, coloredRune, safeManagerText(owned,"stats"),
        ownedBoosts, nextBoostLine
    ))
end)

-- =====================================================
-- AUTO RUNE FORGE (versi biasa, bukan 1M)
-- Table currency/rune/color-nya JUGA diambil langsung dari
-- memori game (getgc) lewat getRuneForgeTable, sama seperti 1M di atas.
-- Entry pertamanya bernama rune "Noob" makanya dipakai sebagai penanda pencarian.
-- =====================================================
local RuneForgeData = getRuneForgeTable("RuneForge", "Noob", {})

local function IsRuneForgeLocked(nextLevel)
    -- Level 8 ke atas butuh BodyTier >= 4 (lihat logic decompile: v20 >= 8 and BodyTier.Value < 4)
    local bodyTier = LocalPlayer.stats:FindFirstChild("BodyTier")
    if nextLevel >= 8 and bodyTier and bodyTier.Value < 4 then
        return true
    end
    return false
end

AutoRuneForgeToggle = BoardsMain:Toggle({
    Title = "Rune Forge",
    Flag = "AutoFarm_RuneForge_Cfg",
    Callback = function(val)
        Config.Upgraders.AutoRuneForge = val
        if val then
            StartManagedLoop("AutoRuneForge", 1, function()
                return Config.Upgraders.AutoRuneForge
            end, function()
                local nextLevel = LocalPlayer.stats.RuneForge.Value + 1
                if IsRuneForgeLocked(nextLevel) then return end
                local costData = RuneForgeData[tostring(nextLevel)]
                if not costData then return end
                local runeObj = LocalPlayer.Runes:FindFirstChild(costData.rune)
                if runeObj and runeObj.Value >= costData.currency then
                    pcall(function()
                        ReplicatedStorage.Remotes.Features.RuneForge:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoRuneForge")
        end
    end
})
FM_Add("Rune Forge", AutoRuneForgeToggle)

StartStatusLoop("Status_RuneForge", 1, function()
    if not AutoRuneForgeToggle then return end
    local currentLevel = LocalPlayer.stats.RuneForge.Value
    local nextLevel = currentLevel + 1
    local rightFrame = GetBoardRight("RuneForge", function()
        return LocalPlayer.PlayerGui.Features.RuneForge.Board.Container.Right
    end)
    local ownedBoosts = BuildOwnedBoostsText(rightFrame, currentLevel)
    local locked = IsRuneForgeLocked(nextLevel)
    local costData = (not locked) and RuneForgeData[tostring(nextLevel)] or nil
    if locked then
        SafeSetDesc(AutoRuneForgeToggle, string.format("🔒 Butuh Body Tier 4\nOwned Boost: %s", ownedBoosts))
        return
    end
    if not costData then
        SafeSetDesc(AutoRuneForgeToggle, string.format("MAXED\nOwned Boost: %s", ownedBoosts))
        return
    end
    local runeObj = LocalPlayer.Runes:FindFirstChild(costData.rune)
    local owned = runeObj and runeObj.Value or 0
    local canBuy = owned >= costData.currency
    local icon = canBuy and "🟢" or "🔴"
    local coloredRune = GetRuneGradientTag(costData.color, costData.rune)
    local nextBoostText = GetBoostText(rightFrame, nextLevel)
    local nextBoostLine = nextBoostText and nextBoostText or "-"
    SafeSetDesc(AutoRuneForgeToggle, string.format(
        "%s Cost: %s %s\n%s: %s\nOwned Boost: %s\n%s",
        icon, safeManagerText(costData.currency,"stats"), coloredRune, coloredRune, safeManagerText(owned,"stats"),
        ownedBoosts, nextBoostLine
    ))
end)
-- =====================================================
-- AUTO SUMMER RUNE FORGE
-- Table currency/rune/color diambil dari memori game (getgc)
-- lewat getRuneForgeTable, sama seperti RuneForge & 1MRuneForge di atas.
-- =====================================================
local SummerRuneForgeData = getRuneForgeTable("SummerRuneForge", "Leviathan", {})

AutoSummerRuneForgeToggle = BoardsMain:Toggle({
    Title = "Summer Rune Forge",
    Flag = "AutoFarm_SummerRuneForge_Cfg",
    Callback = function(val)
        Config.Upgraders.AutoSummerRuneForge = val
        if val then
            StartManagedLoop("AutoSummerRuneForge", 1, function()
                return Config.Upgraders.AutoSummerRuneForge
            end, function()
                local currentLevel = LocalPlayer.stats.SummerRuneForge.Value
                local costData = SummerRuneForgeData[tostring(currentLevel + 1)]
                if not costData then return end
                local runeObj = LocalPlayer.Runes:FindFirstChild(costData.rune)
                if runeObj and runeObj.Value >= costData.currency then
                    pcall(function()
                        ReplicatedStorage.Remotes.SummerFeatures.SummerRuneForge:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoSummerRuneForge")
        end
    end
})
FM_Add("Rune Forge", AutoSummerRuneForgeToggle)

StartStatusLoop("Status_SummerRuneForge", 1, function()
    if not AutoSummerRuneForgeToggle then return end
    local currentLevel = LocalPlayer.stats.SummerRuneForge.Value
    local rightFrame = GetBoardRight("SummerRuneForge", function()
        return LocalPlayer.PlayerGui.SummerFeatures.SummerRuneForge.Board.Container.Right
    end)
    local ownedBoosts = BuildOwnedBoostsText(rightFrame, currentLevel)
    local costData = SummerRuneForgeData[tostring(currentLevel + 1)]
    if not costData then
        SafeSetDesc(AutoSummerRuneForgeToggle, string.format("MAXED\nOwned Boost: %s", ownedBoosts))
        return
    end
    local runeObj = LocalPlayer.Runes:FindFirstChild(costData.rune)
    local owned = runeObj and runeObj.Value or 0
    local canBuy = owned >= costData.currency
    local icon = canBuy and "🟢" or "🔴"
    local coloredRune = GetRuneGradientTag(costData.color, costData.rune)
    local nextBoostText = GetBoostText(rightFrame, currentLevel + 1)
    local nextBoostLine = nextBoostText and nextBoostText or "-"
    SafeSetDesc(AutoSummerRuneForgeToggle, string.format(
        "%s Cost: %s %s\n%s: %s\nOwned Boost: %s\n%s",
        icon, safeManagerText(costData.currency,"stats"), coloredRune, coloredRune, safeManagerText(owned,"stats"),
        ownedBoosts, nextBoostLine
    ))
end)

-- =====================================================
-- AUTO SUMMER DROP
-- Beda dari fitur farm/upgrade lain: ini murni event-based (RemoteEvent),
-- bukan touch-part atau tabel cost. Server ngirim ("Spawn", id, itemType)
-- tiap kali item baru muncul di layar -- kita cukup numpang dengerin remote
-- yang sama, lalu langsung FireServer("Collect", id) begitu event masuk.
-- Gak perlu render GUI, klik, atau tunggu posisi sama sekali.
-- Dibungkus pcall + FindFirstChild biar aman kalau event Summer lagi off-season
-- (remote-nya belum ada), scriptnya tetap jalan normal tanpa fitur ini.
-- =====================================================
Config.Upgraders.AutoSummerDrop = false

-- Rekap jumlah tiap jenis item yang udah dikoleksi dari awal sampai sekarang
-- (SummerDropOrder dipakai biar urutan tampilnya konsisten -- Lua table pairs()
-- gak jamin urutan, jadi urutan "pertama kali muncul" disimpan manual).
local SummerDropStats = {}
local SummerDropOrder = {}

local function RecordSummerDropCollect(itemType)
    if type(itemType) ~= "string" or itemType == "" then return end
    if not SummerDropStats[itemType] then
        SummerDropStats[itemType] = 0
        table.insert(SummerDropOrder, itemType)
    end
    SummerDropStats[itemType] = SummerDropStats[itemType] + 1
end

local function BuildSummerDropDescription()
    if #SummerDropOrder == 0 then
        return "Belum ada yang dikoleksi"
    end
    local lines = {}
    for _, itemType in ipairs(SummerDropOrder) do
        table.insert(lines, string.format("%s: %d", itemType, SummerDropStats[itemType]))
    end
    return table.concat(lines, "\n")
end

do
    local ok, SummerDropRemote = pcall(function()
        return ReplicatedStorage.Remotes.SummerFeatures.SummerDrop
    end)

    if ok and SummerDropRemote then
        local SummerDropConnection
        SummerDropConnection = SummerDropRemote.OnClientEvent:Connect(function(action, id, itemType)
            if Window.Destroyed then
                if SummerDropConnection then
                    SummerDropConnection:Disconnect()
                    SummerDropConnection = nil
                end
                return
            end
            if action == "Spawn" and Config.Upgraders.AutoSummerDrop then
                pcall(function()
                    SummerDropRemote:FireServer("Collect", id)
                end)
                RecordSummerDropCollect(itemType)
                if AutoSummerDropToggle then
                    SafeSetDesc(AutoSummerDropToggle, BuildSummerDropDescription())
                end
            end
        end)

        -- Putus koneksinya begitu Window di-destroy (misal player klik tombol close UI),
        -- biar gak ada listener nyangkut terus jalan di background tanpa guna.
        Window:OnDestroy(function()
            if SummerDropConnection then
                SummerDropConnection:Disconnect()
                SummerDropConnection = nil
            end
        end)

        AutoSummerDropToggle = BoardsMain:Toggle({
            Title = "Summer Drop",
            Desc = "Belum ada yang dikoleksi",
            Flag = "AutoFarm_SummerDrop_Cfg",
            Callback = function(val)
                Config.Upgraders.AutoSummerDrop = val
            end
        })
        FM_Add("Fish", AutoSummerDropToggle)
    end
end

-- =====================================================
-- AUTO BODY TIER
-- Table cost per tier (angka, currency) DAN mapping warna currency-nya
-- SEMUA diambil dinamis dari memori game (getgc), tidak ada satupun yang
-- dihardcode. Kalau devnya nambah tier/currency/warna baru, otomatis kebaca.
-- =====================================================

-- Ambil semua fungsi yang terhubung ke sebuah Signal (butuh dukungan getconnections dari executor)
local function GetConnectedFunctions(signal)
    local fns = {}
    local ok, conns = pcall(getconnections, signal)
    if not ok or not conns then return fns end
    for _, conn in ipairs(conns) do
        local fn = conn.Function or conn.Callback
        if type(fn) == "function" then
            table.insert(fns, fn)
        end
    end
    return fns
end

-- Telusuri upvalue sebuah fungsi (dan fungsi-fungsi di dalam upvalue-nya) buat nyari
-- tabel yang cocok predicate. Ini JAUH lebih presisi dibanding scan getgc() ke semua
-- tabel yang ada di memori, karena cuma nyari di closure yang BENERAN nempel ke
-- LocalScript UI BodyTier itu sendiri -- gak bakal ketuker sama tabel fitur lain
-- yang kebetulan bentuknya mirip (misal CubeTierCosts milik game).
local function FindTableInUpvalues(fn, predicate, visited, depth)
    visited = visited or {}
    depth = depth or 0
    if not fn or depth > 3 or visited[fn] then return nil end
    visited[fn] = true

    local ok, ups = pcall(debug.getupvalues, fn)
    if not ok or not ups then return nil end

    for _, uv in pairs(ups) do
        if type(uv) == "table" then
            local okPred, matched = pcall(predicate, uv)
            if okPred and matched then
                return uv
            end
        end
    end

    for _, uv in pairs(ups) do
        if type(uv) == "function" then
            local found = FindTableInUpvalues(uv, predicate, visited, depth + 1)
            if found then return found end
        end
    end

    return nil
end

-- Hitung berapa banyak currency BERBEDA yang dipakai di dalam tabel cost (array {cost,currency})
local function CountDistinctCurrencies(t)
    local currencies = {}
    for _, entry in pairs(t) do
        if type(entry) == "table" and type(rawget(entry, 2)) == "string" then
            currencies[rawget(entry, 2)] = true
        end
    end
    local count = 0
    for _ in pairs(currencies) do count = count + 1 end
    return count
end

-- PENTING: syarat "minimal 2 currency berbeda" WAJIB ada di sini (bukan cuma di
-- fallback getgc), soalnya BodyTier & CubeTier sama-sama require module
-- EternityNum/Manager yang sama -- penelusuran upvalue rekursif (FindTableInUpvalues)
-- bisa saja nyasar nemu tabel CubeTierCosts lewat closure module itu kalau gak
-- difilter ketat di sini juga. BodyTier py Strength/Speed/Power (>=2 currency),
-- sedangkan CubeTier cuma "Cubes" doang (1 currency) -- jadi pembeda yang aman.
local function IsBodyTierCostShape(t)
    local first = rawget(t, 1)
    if type(first) ~= "table" then return false end
    local costVal = rawget(first, 1)
    local currencyName = rawget(first, 2)
    if not (type(costVal) == "string" and type(currencyName) == "string"
        and tonumber(costVal) ~= nil and LocalPlayer.stats:FindFirstChild(currencyName) ~= nil) then
        return false
    end
    return CountDistinctCurrencies(t) >= 2
end

-- Sama seperti di atas: CubeTier cuma punya 1 warna ("Cubes"), BodyTier minimal 2
-- (Strength/Speed/Power) -- jadi syarat total >= 2 dipakai buat nyaring tabel warna
-- currency tunggal seperti punya CubeTier.
local function IsBodyTierColorShape(t)
    local total, matched = 0, 0
    for k, v in pairs(t) do
        total = total + 1
        if type(k) ~= "string" or type(v) ~= "string" or not v:match("^#%x%x%x%x%x%x$") then
            return false
        end
        if LocalPlayer.stats:FindFirstChild(k) then
            matched = matched + 1
        end
    end
    return total >= 2 and matched == total
end

-- Cara #1 (paling presisi): telusuri upvalue fungsi yang terhubung LANGSUNG ke
-- sinyal BodyTier.Changed -- ini jaminan tabelnya persis punya LocalScript BodyTier.
-- Cara #2 (fallback): scan getgc() global kalau Cara #1 gagal (executor gak
-- dukung getconnections/getupvalues). Predicate-nya SAMA PERSIS (sudah termasuk
-- filter distinct currency), jadi konsisten di kedua jalur.
local function findBodyTierCostTable()
    local bodyTierStat = LocalPlayer.stats:FindFirstChild("BodyTier")
    if bodyTierStat then
        for _, fn in ipairs(GetConnectedFunctions(bodyTierStat.Changed)) do
            local found = FindTableInUpvalues(fn, IsBodyTierCostShape)
            if found then return found end
        end
    end

    for _, obj in pairs(getgc(true)) do
        if type(obj) == "table" then
            local ok, isShape = pcall(IsBodyTierCostShape, obj)
            if ok and isShape then
                return obj
            end
        end
    end
    return nil
end

local function findBodyTierColorTable()
    local bodyTierStat = LocalPlayer.stats:FindFirstChild("BodyTier")
    if bodyTierStat then
        for _, fn in ipairs(GetConnectedFunctions(bodyTierStat.Changed)) do
            local found = FindTableInUpvalues(fn, IsBodyTierColorShape)
            if found then return found end
        end
    end

    for _, obj in pairs(getgc(true)) do
        if type(obj) == "table" then
            local ok, isShape = pcall(IsBodyTierColorShape, obj)
            if ok and isShape then
                return obj
            end
        end
    end
    return nil
end

-- Nama cache dibedakan lagi dari versi sebelumnya, biar gak kebawa cache lama yang salah
local function getBodyTierCostTable()
    local cached = _G["BodyTierCostTable_v3"]
    if cached then return cached end
    local found = findBodyTierCostTable()
    if found then _G["BodyTierCostTable_v3"] = found end
    return found or {}
end

local function getBodyTierColorTable()
    local cached = _G["BodyTierColorTable_v3"]
    if cached then return cached end
    local found = findBodyTierColorTable()
    if found then _G["BodyTierColorTable_v3"] = found end
    return found or {}
end

local BodyTierCosts = getBodyTierCostTable()
local BodyTierColors = getBodyTierColorTable()

-- Bikin nama currency (Strength/Speed/Power/dst) jadi gradient sesuai warna
-- yang ditemukan di BodyTierColors (fallback putih kalau warnanya gak ketemu)
local function GetBodyTierColoredCurrency(currencyName)
    local hex = BodyTierColors[currencyName] or "#FFFFFF"
    local ok, base = pcall(Color3.fromHex, hex)
    if not ok then base = Color3.new(1, 1, 1) end
    return GetRuneGradientTag(base, currencyName)
end

-- Boost per level Body Tier ada di path:
-- Board.Container.Container["<level>"].boost.Text (huruf kecil, beda dari RuneForge)
local function GetBodyTierBoostContainer()
    return GetBoardRight("BodyTierBoost", function()
        return LocalPlayer.PlayerGui.Features.BodyTier.Board.Container.Container
    end)
end

local function GetBodyTierBoostText(level)
    local container = GetBodyTierBoostContainer()
    if not container then return nil end
    local ok, levelFrame = pcall(function() return container:FindFirstChild(tostring(level)) end)
    if not ok or not levelFrame then return nil end
    local boostLabel = levelFrame:FindFirstChild("boosts") or levelFrame:FindFirstChild("boosts", true)
    if not boostLabel then return nil end
    local text = levelFrame:FindFirstChild("number", true).Text .. " : " .. boostLabel.Text
    return (text ~= "" and text) or nil
end

-- Gabungkan semua boost yang sudah dimiliki (tier 1..currentTier) jadi satu baris teks
local function BuildBodyTierOwnedBoostsText(currentTier)
    local owned = {}
    for i = 1, currentTier do
        local text = GetBodyTierBoostText(i)
        if text then
            table.insert(owned, text)
        end
    end
    return #owned > 0 and ("\n" .. table.concat(owned, "\n")) or "-"
end

AutoBodyTierToggle = BoardsMain:Toggle({
    Title = "Body Tier",
    Flag = "AutoFarm_BodyTier_Cfg",
    Callback = function(val)
        Config.Upgraders.AutoBodyTier = val
        if val then
            StartManagedLoop("AutoBodyTier", 1, function()
                return Config.Upgraders.AutoBodyTier
            end, function()
                local currentTier = LocalPlayer.stats.BodyTier.Value
                local costData = BodyTierCosts[currentTier + 1]
                if not costData then return end
                local costStr, currencyName = costData[1], costData[2]
                local statObj = GetStatValueObj(currencyName)
                if statObj and EternityNum.meeq(statObj.Value, EternityNum.fromString(costStr)) then
                    pcall(function()
                        ReplicatedStorage.Remotes.Features.BodyTier:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoBodyTier")
        end
    end
})
FM_Add("Power", AutoBodyTierToggle)

StartStatusLoop("Status_BodyTier", 1, function()
    if not AutoBodyTierToggle then return end
    local currentTier = LocalPlayer.stats.BodyTier.Value
    local ownedBoosts = BuildBodyTierOwnedBoostsText(currentTier)
    local costData = BodyTierCosts[currentTier + 1]
    if not costData then
        SafeSetDesc(AutoBodyTierToggle, string.format("MAXED\nOwned Boost: %s", ownedBoosts))
        return
    end
    local costStr, currencyName = costData[1], costData[2]
    local statObj = GetStatValueObj(currencyName)
    local statValue = statObj and statObj.Value or 0
    local canBuy = EternityNum.meeq(statValue, EternityNum.fromString(costStr))
    local icon = canBuy and "🟢" or "🔴"
    local coloredCurrency = GetBodyTierColoredCurrency(currencyName)
    local nextBoostText = GetBodyTierBoostText(currentTier + 1)
    local nextBoostLine = nextBoostText and nextBoostText or "-"
    SafeSetDesc(AutoBodyTierToggle, string.format(
        "%s Cost: %s %s\n%s: %s\nOwned Boost: %s\n%s",
        icon, safeManagerText(costStr, "stats"), coloredCurrency, coloredCurrency, safeManagerText(statValue, "stats"),
        ownedBoosts, nextBoostLine
    ))
end)

-- =====================================================
-- AUTO SHARD UPGRADE (Toggle per Upgrade)
-- =====================================================

local shardToggles = {}
local shardGroup = nil
local shardCountInGroup = 0
ShardsUpgradeRemote = ReplicatedStorage.Remotes.Features.ShardUpgrade
-- Urutkan key upgrade (berdasarkan angka di nama)
local shardUpgradeKeys = {}
for k in pairs(Modules.ShardsUpgrades.Upgrades) do
    table.insert(shardUpgradeKeys, k)
end
table.sort(shardUpgradeKeys, function(a, b)
    local numA = tonumber(a:match("%d+")) or 0
    local numB = tonumber(b:match("%d+")) or 0
    return numA < numB
end)

-- Fungsi ambil nilai item dari folder
local function GetShardItemValue(folderType, itemName)
    local folder
    if folderType == "Shards" then
        folder = LocalPlayer.Shards
    elseif folderType == "others" then
        folder = LocalPlayer.others
    else
        return 0
    end
    if folder then
        local obj = folder:FindFirstChild(itemName)
        return tonumber(obj.Value) or 0
    end
    return 0
end

-- Fungsi cek affordability
local function CanAffordShardUpgrade(costList)
    for _, costItem in ipairs(costList) do
        local amountNeeded = costItem[1]
        local folderType = costItem[2]
        local itemName = costItem[3] or folderType
        local owned = GetShardItemValue(folderType, itemName)
        if owned < amountNeeded then
            return false
        end
    end
    return true
end

-- Buat toggle untuk setiap upgrade
for _, upgradeName in ipairs(shardUpgradeKeys) do
    local upgradeData = Modules.ShardsUpgrades.Upgrades[upgradeName]
    if shardCountInGroup % 2 == 0 then
        shardGroup = BoardsMain:Group({})
        FM_Add("Shards", shardGroup)
    end

    local toggle = shardGroup:Toggle({
        Title = upgradeName,
        Flag = "ShardUpg_" .. upgradeName,
        Value = false,
        Callback = function(val)
            Config.Upgraders["AutoShard_" .. upgradeName] = val
            if val then
                StartManagedLoop("AutoShard_" .. upgradeName, 0.5, function()
                    return Config.Upgraders["AutoShard_" .. upgradeName] == true
                end, function()
                    local levelObj = LocalPlayer.Shards:FindFirstChild(upgradeName)
                    local level = levelObj and levelObj.Value or 0
                    local maxLevel = #upgradeData.Cost
                    if level >= maxLevel then return end

                    local costList = upgradeData.Cost[level + 1]
                    if not costList then return end

                    if CanAffordShardUpgrade(costList) then
                        pcall(function()
                            ShardsUpgradeRemote:FireServer(upgradeName)
                        end)
                    end
                end)
            else
                StopManagedLoop("AutoShard_" .. upgradeName)
            end
        end
    })

    shardToggles[upgradeName] = toggle
    shardCountInGroup = shardCountInGroup + 1
end

local ShardCostDisplayNames = {
    Upg1 = "Basic Shards",
    Upg2 = "Elemental Shards",
    Upg3 = "Gym Shards",
    Upg4 = "Noob Shards",
    Upg5 = "Scrap Shards",
    Upg6 = "Brain Shards",
}
-- Status update untuk semua toggle shard
StartStatusLoop("Status_ShardUpgrades", 0.5, function()
    for upgradeName, toggle in pairs(shardToggles) do
        local levelObj = LocalPlayer.Shards:FindFirstChild(upgradeName)
        local level = levelObj and levelObj.Value or 0
        local upgradeData = Modules.ShardsUpgrades.Upgrades[upgradeName]
        local maxLevel = #upgradeData.Cost

        local title = ShardCostDisplayNames[upgradeName]
        local descLines = {}

        if level >= maxLevel then
            title = title .. " (MAX)"
            table.insert(descLines, "MAXED")
            toggle:Disable()
        else
            local costList = upgradeData.Cost[level + 1]
            local canBuy = true
            local costStrings = {}

            for _, costItem in ipairs(costList) do
                local amountNeeded = costItem[1]
                local folderType = costItem[2]
                local itemName = costItem[3] or folderType
                local owned = GetShardItemValue(folderType, itemName)
                if owned < amountNeeded then canBuy = false end
                local color = canBuy and "#00ff00" or "#ff0000"
                table.insert(costStrings, string.format('<font color="%s">%s/%s %s</font>',
                    color,
                    safeManagerText(owned,"stats"),
                    safeManagerText(amountNeeded,"stats"),
                    itemName))
            end

            table.insert(descLines, "Level: " .. level .. "/" .. maxLevel)
            for _, costStr in ipairs(costStrings) do
                table.insert(descLines, costStr)
            end

            toggle:Enable()
        end

        -- 🆕 Tampilkan Boost (seperti client)
        local boostLines = {}
        local boostLevel = level >= maxLevel and level or (level + 1)
        boostLevel = math.max(1, math.min(10, boostLevel))
        for _, boost in ipairs(upgradeData.Boosts or {}) do
            local base = boost[1]
            local statName = boost[2]
            local boostValue = base ^ boostLevel
            local color = Modules.ShardsUpgrades.FontColors and Modules.ShardsUpgrades.FontColors[statName]
            local statColored = color and string.format('<font color="%s">%s</font>', color, statName) or statName
            table.insert(boostLines, string.format("x%s %s", safeManagerText(boostValue,"stats"), statColored))
        end
        if #boostLines > 0 then
            table.insert(descLines, 1, "Boost: " .. table.concat(boostLines, " | ")) -- letakkan di atas setelah title
        end

        SafeSetTitle(toggle, title)
        SafeSetDesc(toggle, table.concat(descLines, "\n"))
    end
end)
SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings-2" })
ConfigNameInput = SettingsTab:Input({
    Title = "Config Name",
    Placeholder = ConfigName,
    Value = ConfigName,
    Flag = "ConfigName_Input",
    Callback = function(txt)
        ConfigName = NormalizeConfigName(txt)
        SaveLastConfigName()
    end
})
SettingsTab:Button({
    Title = "Save Config", Icon = "save",
    Callback = function()
        ConfigName = NormalizeConfigName(ConfigName)
        SaveLastConfigName()
        if Window.ConfigManager then
            pcall(function()
                local cfg = GetOrCreateConfig()
                cfg:Save()
            end)
        end
        Notify("Success", "Saved!", "check")
    end
})
SettingsTab:Button({
    Title = "Load Config", Icon = "upload",
    Callback = function()
        ConfigName = NormalizeConfigName(ConfigName)
        SaveLastConfigName()
        if Window.ConfigManager then
            pcall(function()
                local cfg = GetOrCreateConfig()
                IsLoadingConfig = true
                cfg:Load()
            end)
            FinishConfigLoad(1)
        end
        Notify("Success", "Loaded!", "check")
    end
})
SettingsTab:Button({
    Title = "Delete Config", Icon = "trash",
    Callback = function()
        if Window.ConfigManager then
            pcall(function() Window.ConfigManager:DeleteConfig(ConfigName) end)
        end
        Notify("Success", "Deleted!", "trash")
    end
})
SettingsTab:Button({
    Title = "Rejoin Server", Icon = "rotate-cw",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end
})
FM_OnChange("Automation")
Window:SelectTab(BoardsMain.Index)

task.spawn(function()
    local CM = Window.ConfigManager
    if not CM then return end

    pcall(function()
        ConfigName = NormalizeConfigName(ConfigName)
        if ConfigNameInput and ConfigNameInput.Set then
            ConfigNameInput:Set(ConfigName)
        end

        local cfg = GetOrCreateConfig()
        IsLoadingConfig = true
        cfg:Load()
    end)
    FinishConfigLoad(1)

    while not Window.Destroyed do
        task.wait(10)
        if not IsLoadingConfig then
            pcall(function()
                local cfg = GetOrCreateConfig()
                if cfg then
                    SaveLastConfigName()
                    cfg:Save()
                end
            end)
        end
    end
    DisconnectAll()
end)
