if game.PlaceId ~= 111764332453471 then return end


repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Souls Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local character = LocalPlayer.Character
local rootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
humanoid.WalkSpeed = 100  -- nilai default biasanya 16

local FolderPath = "ANUI/SoulsIncremental"
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
local IdledScript = LocalPlayer:WaitForChild("PlayerScripts", 10):FindFirstChild("Idled")
if IdledScript then
    IdledScript:Destroy()
end
local oldTeleport
oldTeleport = hookfunction(TeleportService.Teleport, function(...)
    -- Cegah teleport otomatis
    return nil
end)

-- Untuk fitur Rejoin manual, gunakan oldTeleport secara langsung
local function ManualRejoin()
    oldTeleport(TeleportService, game.PlaceId, LocalPlayer)
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
            Callback = function() setclipboard("https://discord.gg/qN47S3mKZA") Notify("Discord", "Invite link copied!", "geist:logo-discord") end
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
    Title = "AN Hub - Souls Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "SoulsIncremental",
    Size = UDim2.fromOffset(580, 460),
    KeySystem = {
        Note = "Generate a key for this device. Valid for 24 hours.",
        SaveKey = true,
        API = {
            {
                Type = "github",
                Owner = "ANHub-Script",
                Repo = "ANUI",
                Branch = "main",
                DBPath = "db/keys.json",
                URL = "https://anhub-script.github.io/ANUI/getkey/",
                Secret = "jURQEh2kW7ahRuEqbaoJyWHas0dAd2Z8",
            },
        },
    },
})
Window:Tab({
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Souls Incremental" }),
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
    Window:Tag({
        Title = "v" .. UI.Version,
        Icon = "github",
        Color = Color3.fromHex("#1c1c1c")
    });
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

function AddConnection(connection)
    return Window:AddConnection(connection)
end

function DisconnectAll()
    return Window:DisconnectAll()
end

function StopManagedLoop(key)
    return Window:StopLoop(key)
end

function StartManagedLoop(key, interval, predicate, callback)
    return Window:ManagedLoop(key, interval, predicate, callback)
end

function IsWindowReady()
    return Window:IsReady()
end

function StartStatusLoop(key, interval, callback)
    return Window:StatusLoop(key, interval, callback)
end

BoardsUpgradeCategory = nil
function FM_Add(cat, elem,data)
    if not data then return elem end
    return data:Add(cat, elem)
end
local function GetIconCurrency(Currency)
    local screen
    if Currency == "Shards" or Currency == "Tier" or Currency == "Converter" or Currency == "Merchant" or Currency == "Challenges" then
        Screen = LocalPlayer.PlayerGui.Interface:FindFirstChild("Teleport",true):FindFirstChild(Currency,true)
    else
        Screen = LocalPlayer.PlayerGui.Interface.HUD.Right:FindFirstChild(Currency,true)        
    end
    if Screen then
        local Icon
        if Currency == "Shards" or Currency == "Tier" or Currency == "Converter" or Currency == "Merchant" or Currency == "Challenges" then
            Icon = Screen
        else
            Icon = Screen:FindFirstChild("Icon",true)
        end
        if Icon then
            return Icon.Image
        end
    end
    return GetIcon(98866142472743)
end

-- Require modul
DataServiceModule = require(ReplicatedStorage.Packages.DataService)
DataService = DataServiceModule.client
Utilities = require(ReplicatedStorage.Modules.Shared.Utilities)
UpgradesModule = require(ReplicatedStorage.Modules.Shared.Upgrades)
EternityNum = require(ReplicatedStorage.Modules.Shared.EternityNum)
ResetLayersModule = require(ReplicatedStorage.Modules.Shared.ResetLayers)
SummerTiersModule = require(ReplicatedStorage.Modules.Shared.Events.SummerTiers)
TiersModule = require(ReplicatedStorage.Modules.Shared.Tiers)
UpgradeTreesModule = require(ReplicatedStorage.Modules.Shared.UpgradeTrees)
UpgradeTreeRemote = ReplicatedStorage.Remotes.UpgradeTree
ResetLayerRemote = ReplicatedStorage.Remotes.ResetLayer
SummerTierUpRemote = ReplicatedStorage.Remotes.Events.SummerTierUp
TierUpRemote = ReplicatedStorage.Remotes.TierUp
-- Fungsi bantu (sudah Anda punya)
local function Color3ToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
end

-- Fungsi baru: membuat tag gradient dari ColorSequence
local function GetGradientTagFromSequence(colorSequence, text,allow)
    local keypoints = colorSequence.Keypoints
    if #keypoints == 0 then
        return text -- fallback
    end

    -- Urutkan keypoints berdasarkan waktu (biasanya sudah urut, tapi amankan)
    table.sort(keypoints, function(a, b) return a.Time < b.Time end)

    -- Buat string hex untuk setiap keypoint
    local hexColors = {}
    for _, kp in ipairs(keypoints) do
        table.insert(hexColors, Color3ToHex(kp.Value))
        if allow then
            continue
        end
        break
    end

    -- Gabungkan dengan koma
    local gradientString = table.concat(hexColors, ",")
    return string.format("<gradient=%s>%s</gradient>", gradientString, text)
end
-- Remote
UpgradeRemote = ReplicatedStorage.Remotes.Upgrade
Options = {}
-- Daftar kategori dari client __init
local categories = {
    "Souls", "Awaken", "Purify", "Level", "Heat", "Gems", "Shards",
    "Fish", "Pearls", "Coins", "Water", "Milkshaker"
}
for _, category in ipairs(categories) do
    for upgradeName, upgradeDef in pairs(UpgradesModule.upgrades) do
        if string.match(upgradeName, "^" .. category .. "_") then
            table.insert(Options, {Title = category,Icon = GetIconCurrency(upgradeDef.statPath[#upgradeDef.statPath])})
            break
        end
    end
end
-- [[ MAIN TAB ]] --
MenuMain = Window:Section({
    Title = "Menu",
    Opened = true,
})
BoardUpgrades = MenuMain:Tab({
    Title = "Board Upgrades",
})
-- Sticky di atas konten + manajemen tampil/sembunyi elemen: semua diurus library
BoardsUpgradeCategory = BoardUpgrades:Category({
    Default = "Souls",
    Options = Options,
})

-- =====================================================
-- AUTO UPGRADE (DataService Game)
-- =====================================================
Config.AutoUpgrade = {}   -- key: upgradeName -> boolean


local function getPlayerState()
    local ok, state = pcall(function()
        return DataService:get()
    end)
    if ok and state then
        return state
    end
    return nil
end

-- Helper format angka
local function formatNum(value)
    if type(value) == "number" then
        return EternityNum.toSuffix(EternityNum.convert(value), 1)
    else
        return EternityNum.toSuffix(value, 1)
    end
end

-- Tunggu DataService siap
local function waitForDataService()
    for _ = 1, 20 do
        if getPlayerState() then
            return true
        end
        task.wait(0.5)
    end
    return false
end
waitForDataService()

-- Simpan referensi toggle
local autoUpgradeRefs = {}

-- Bangun UI per kategori
for _, category in ipairs(categories) do
    local upgradesInCategory = {}

    for upgradeName, upgradeDef in pairs(UpgradesModule.upgrades) do
        if string.match(upgradeName, "^" .. category .. "_") then
            table.insert(upgradesInCategory, {
                Name = upgradeName,
                Def = upgradeDef,
            })
        end
    end

    if #upgradesInCategory > 0 then
        -- Urutkan berdasarkan order
        table.sort(upgradesInCategory, function(a, b)
            return (a.Def.order or 999) < (b.Def.order or 999)
        end)

        local group = nil
        local count = 0

        for _, entry in ipairs(upgradesInCategory) do
            local upgradeName = entry.Name
            local upgradeDef = entry.Def

            if count % 2 == 0 then
                group = BoardUpgrades:Group({})
                FM_Add(category,group,BoardsUpgradeCategory)
            end
            count += 1

            Config.AutoUpgrade[upgradeName] = false

            local toggle = group:Toggle({
                Title = upgradeDef.title,
                Image = upgradeDef.icon,
                Flag = "AutoUpg_"..category .. upgradeName,
                Value = false,
                Callback = function(val)
                    Config.AutoUpgrade[upgradeName] = val
                    if val then
                        StartManagedLoop("AutoUpg_" .. upgradeName, 0.1, function()
                            return Config.AutoUpgrade[upgradeName] == true
                        end, function()
                            local state = getPlayerState()
                            if not state then return end

                            local level = DataService:get({"Upgrades", upgradeName})
                            local capInfo = upgradeDef.cap(state)
                            if not capInfo then return end

                            local maxLevel = capInfo.isCap and capInfo.actualCap or math.huge
                            if capInfo.isCap and level >= maxLevel then return end

                            local visible = true
                            if upgradeDef.visible then
                                visible = upgradeDef.visible(state)
                            end
                            if not visible then return end

                            local currencyPath = upgradeDef.statPath
                            if not currencyPath then return end
                            local currency = DataService:get(currencyPath)

                            local cost = upgradeDef.cost(state)
                            if EternityNum.meeq(EternityNum.convert(currency), EternityNum.convert(cost)) then
                                UpgradeRemote:FireServer(upgradeName, true) -- max
                            end
                        end)
                    else
                        StopManagedLoop("AutoUpg_" .. upgradeName)
                    end
                end
            })
            StartStatusLoop("Status_AutoUpg_" .. upgradeName, 0.05, function()
                local state = getPlayerState()
                if not state then
                    SafeSetDesc(toggle, "Waiting data...")
                    return
                end

                local level = DataService:get({"Upgrades", upgradeName})
                local capInfo = upgradeDef.cap(state)
                local maxLevel = capInfo and capInfo.isCap and capInfo.actualCap or nil
                local isMaxed = capInfo and capInfo.isCap and level >= maxLevel

                local descLines = {}

                if maxLevel then
                    table.insert(descLines, string.format("Level %d/%d", level, maxLevel))
                else
                    table.insert(descLines, string.format("Level %d", level))
                end

                if upgradeDef.boostText then
                    table.insert(descLines, "Boost: " .. upgradeDef.boostText(state, isMaxed))
                end

                if not isMaxed and upgradeDef.costText then
                    table.insert(descLines, upgradeDef.costText(state) .. GetIconCurrency(upgradeDef.statPath[#upgradeDef.statPath]))
                end

                SafeSetDesc(toggle, table.concat(descLines, "\n"))
            end)
        end
    end
end

Options = {}
-- Daftar reset layer

-- Require modul
local resetLayerCategories = { "Awaken", "Purify", "Milkshaker" }

for _, category in ipairs(resetLayerCategories) do
    local layerData = ResetLayersModule.resetLayers[category]
    table.insert(Options, {Title = string.format("{%s}%s",GetIconCurrency(layerData.currencyGainName:gsub(" ","")),category)})
end
table.insert(Options, {Title = string.format("{%s}Tier",GetIconCurrency("Tier"))})
table.insert(Options, {Title = string.format("{%s}Challenges",GetIconCurrency("Challenges"))})
table.insert(Options, {Title = string.format("{%s}Jungle",GetIcon(92707543047232))})
table.insert(Options, {Title = string.format("{%s}Converter",GetIconCurrency("Converter"))})
table.insert(Options, {Title = string.format("{%s}Merchant",GetIconCurrency("Merchant"))})
table.insert(Options, {Title = string.format("{%s}Fishing",GetIcon(92035047118407))})
ResetLayers = MenuMain:Tab({
    Title = "Multi Feature",
})
-- Sticky di atas konten + manajemen tampil/sembunyi elemen: semua diurus library
ResetLayersCategory = ResetLayers:Category({
    Default = "Awaken",
    Options = Options,
})

-- =====================================================
-- AUTO RESET LAYER (DataService Game)
-- =====================================================
Config.AutoResetLayer = {}

-- Simpan referensi toggle
local autoResetRefs = {}
for _, category in ipairs(resetLayerCategories) do
    local layerData = ResetLayersModule.resetLayers[category]
    if layerData then
        Config.AutoResetLayer[category] = false

        local toggle = ResetLayers:Toggle({
            Title = category,
            Image = GetIconCurrency(layerData.currencyGainName:gsub(" ","")),
            Flag = "AutoResetLayer_" .. category,
            Value = false,
            Callback = function(val)
                Config.AutoResetLayer[category] = val
                if val then
                    StartManagedLoop("AutoResetLayer_" .. category, 1, function()
                        return Config.AutoResetLayer[category] == true
                    end, function()
                        local state = getPlayerState()
                        if not state then return end

                        if layerData.canAfford(state) then
                            ResetLayerRemote:FireServer(category)
                        end
                    end)
                else
                    StopManagedLoop("AutoResetLayer_" .. category)
                end
            end
        })
        FM_Add(category,toggle,ResetLayersCategory)
        autoResetRefs[category] = {
            toggle = toggle,
            data = layerData,
        }
    end
end

-- Status loop
StartStatusLoop("Status_AutoResetLayer", 1, function()
    local state = getPlayerState()
    if not state then
        for _, ref in pairs(autoResetRefs) do
            SafeSetDesc(ref.toggle, "Waiting data...")
        end
        return
    end

    for category, ref in pairs(autoResetRefs) do
        local toggle = ref.toggle
        local data = ref.data

        local descLines = {}
        local buttonText = data.affordStatusText(state)
        table.insert(descLines, "Status: " .. buttonText)

        if data.gainText then
            table.insert(descLines, "Gain: " .. data.gainText(state) .. GetIconCurrency(data.currencyGainName:gsub(" ","")))
        end

        SafeSetDesc(toggle, table.concat(descLines, "\n"))
    end
end)

-- =====================================================
-- AUTO CHALLENGES (Per Challenge Toggle)
-- =====================================================
Config.AutoChallenge = {}   -- key: challengeName -> boolean

-- Require modul & service
local ChallengesModule = require(ReplicatedStorage.Modules.Shared.ChallengeService.Challenges)

local ChallengeRemote = ReplicatedStorage.Remotes.Challenge
-- Cek fitur terbuka (Tier >= 5)
local function isUnlocked(state)
    return (state.Tier or 0) >= 5
end

-- Ambil nilai dari path (bisa string atau table)
local function getValueFromPath(path)
    if not path then return 0 end
    return DataService:get(path) or 0
end

-- Dapatkan progress requirement challenge berikutnya
local function getRequirementProgress(state, challengeName)
    if not state or not state.Challenge then return nil end

    local level = state.Challenge.Levels and state.Challenge.Levels[challengeName] or 0
    local challengeData = ChallengesModule.challenges[challengeName]
    if not challengeData then return nil end

    local maxLevel = #challengeData.levels
    if level >= maxLevel then
        return { Level = level, MaxLevel = maxLevel, IsMaxed = true }
    end

    local nextLevelData = challengeData.levels[level + 1]
    if not nextLevelData then
        return { Level = level, MaxLevel = maxLevel, IsMaxed = true }
    end

    local req = nextLevelData.requirement
    local current = getValueFromPath(req.stat)
    local amount = req.amount

    return {
        Level = level,
        NextLevel = level + 1,
        MaxLevel = maxLevel,
        Current = current,
        Amount = amount,
        Requirement = req,
        NextLevelData = nextLevelData,
        IsMaxed = false,
    }
end

-- Cek apakah challenge aktif sudah selesai (requirement terpenuhi atau waktu habis)
local function isActiveChallengeComplete(state, challengeName)
    local active = state.Challenge and state.Challenge.Active
    if active ~= challengeName then return false end

    local info = getRequirementProgress(state, challengeName)
    if not info or info.IsMaxed then return true end

    local current = EternityNum.convert(info.Current)
    local amount = EternityNum.convert(info.Amount)
    if EternityNum.meeq(current, amount) then return true end

    local endTime = state.Challenge.EndTime
    if endTime and endTime > 0 and os.time() >= endTime then return true end

    return false
end

-- Format angka
local function fmt(val)
    return EternityNum.toSuffix(EternityNum.convert(val), 1)
end

-- Susun daftar challenge terurut
local challengesList = {}
for name, data in pairs(ChallengesModule.challenges) do
    table.insert(challengesList, { Name = name, Data = data })
end
table.sort(challengesList, function(a, b)
    return (a.Data.layoutOrder or 999) < (b.Data.layoutOrder or 999)
end)

-- Simpan referensi toggle
local autoChallengeRefs = {}

-- Buat toggle per challenge
for _, entry in ipairs(challengesList) do
    local challengeName = entry.Name

    Config.AutoChallenge[challengeName] = false

    local toggle = ResetLayers:Toggle({
        Title = challengeName,
        Flag = "AutoChallenge_" .. challengeName,
        Value = false,
        Callback = function(val)
            Config.AutoChallenge[challengeName] = val
            if val then
                StartManagedLoop("AutoChallenge_" .. challengeName, 1, function()
                    return Config.AutoChallenge[challengeName] == true
                end, function()
                    local state = getPlayerState()
                    if not state or not isUnlocked(state) then return end

                    local info = getRequirementProgress(state, challengeName)
                    if not info or info.IsMaxed then return end

                    local active = state.Challenge and state.Challenge.Active
                    if active == challengeName then
                        -- Challenge ini aktif, cek apakah selesai
                        if isActiveChallengeComplete(state, challengeName) then
                            ChallengeRemote:FireServer(challengeName)
                        end
                    elseif active == nil or active == "" then
                        -- Tidak ada challenge aktif, mulai challenge ini
                        ChallengeRemote:FireServer(challengeName)
                    end
                    -- Jika challenge lain aktif, tunggu
                end)
            else
                StopManagedLoop("AutoChallenge_" .. challengeName)
            end
        end
    })
    FM_Add("Challenges",toggle,ResetLayersCategory)

    autoChallengeRefs[challengeName] = {
        toggle = toggle,
        name = challengeName,
        data = entry.Data,
    }
end

-- Status loop untuk setiap challenge (independen)
for challengeName, ref in pairs(autoChallengeRefs) do
    StartStatusLoop("Status_AutoChallenge_" .. challengeName, 1, function()
        local toggle = ref.toggle
        local state = getPlayerState()
        if not state then
            SafeSetDesc(toggle, "Waiting data...")
            return
        end

        local info = getRequirementProgress(state, challengeName)
        if not info then
            SafeSetDesc(toggle, "Data not available")
            return
        end

        local activeName = state.Challenge and state.Challenge.Active
        local statusText
        if info.IsMaxed then
            statusText = "Maxed"
        elseif activeName == challengeName then
            if isActiveChallengeComplete(state, challengeName) then
                statusText = "Active (Ready to End)"
            else
                statusText = "Active"
            end
        elseif activeName == nil or activeName == "" then
            statusText = "Ready"
        else
            statusText = "Waiting (Other Challenge Active)"
        end

        local lines = {}
        table.insert(lines, string.format("Stage: %d/%d", info.Level, info.MaxLevel))

        if not info.IsMaxed then
            table.insert(lines, string.format("Progress: %s / %s", fmt(info.Current), fmt(info.Amount)))
        end

        -- Tampilkan timer jika aktif
        if activeName == challengeName and state.Challenge.EndTime and state.Challenge.EndTime > 0 then
            local timeLeft = state.Challenge.EndTime - os.time()
            if timeLeft > 0 then
                table.insert(lines, string.format("Time Left: %s", Utilities.Short.time(timeLeft)))
            else
                table.insert(lines, "Time Left: 0:00")
            end
        end

        table.insert(lines, "Status: " .. statusText)

        -- Tampilkan reward/debuff singkat
        local currentLevelData = info.NextLevelData
        if currentLevelData then
            if currentLevelData.rewards then
                local rewardParts = {}
                for statName, mod in pairs(currentLevelData.rewards) do
                    local symbol = mod.type == "Multiplier" and "x" or (mod.type == "Power" and "^" or (mod.type == "Divide" and "/" or "+"))
                    table.insert(rewardParts, string.format("%s%s %s", symbol, mod.value, statName))
                end
                if #rewardParts > 0 then
                    table.insert(lines, "Rewards: " .. table.concat(rewardParts, ", "))
                end
            end
            if currentLevelData.debuffs and #currentLevelData.debuffs > 0 then
                local debuffParts = {}
                for _, mod in ipairs(currentLevelData.debuffs) do
                    local symbol = mod.type == "Multiplier" and "x" or (mod.type == "Power" and "^" or (mod.type == "Divide" and "/" or "+"))
                    table.insert(debuffParts, string.format("%s%s %s", symbol, mod.value, mod.stat))
                end
                table.insert(lines, "Debuffs: " .. table.concat(debuffParts, ", "))
            end
        end

        SafeSetDesc(toggle, table.concat(lines, "\n"))
    end)
end
-- =====================================================
-- AUTO SUMMER TIER (DataService Game)
-- =====================================================
Config.AutoSummerTier = false

-- Require modul & service
-- Cek apakah bisa tier up
local function canTierUp(state)
    if not state then return false end
    local currentTier = state.SummerTier or 0
    local nextTierData = SummerTiersModule.tiers[currentTier + 1]
    if not nextTierData then return false end

    local statName = nextTierData.statPath[#nextTierData.statPath]
    local statValue = state[statName] or 0
    return EternityNum.meeq(EternityNum.convert(statValue), EternityNum.convert(nextTierData.requirement))
end

-- Toggle Auto Summer Tier
local autoSummerToggle = ResetLayers:Toggle({
    Title = "Summer Tier Up",
    Flag = "AutoSummerTier",
    Value = false,
    Callback = function(val)
        Config.AutoSummerTier = val
        if val then
            StartManagedLoop("AutoSummerTier", 1, function()
                return Config.AutoSummerTier
            end, function()
                local state = getPlayerState()
                if state and canTierUp(state) then
                    SummerTierUpRemote:FireServer()
                end
            end)
        else
            StopManagedLoop("AutoSummerTier")
        end
    end
})
FM_Add("Milkshaker",autoSummerToggle,ResetLayersCategory)
-- Status loop
-- Status loop
StartStatusLoop("Status_AutoSummerTier", 1, function()
    if not autoSummerToggle then return end

    local state = getPlayerState()
    if not state then
        SafeSetDesc(autoSummerToggle, "Waiting data...")
        return
    end

    local currentTier = state.SummerTier or 0
    local maxTier = #SummerTiersModule.tiers
    local lines = {}
    table.insert(lines, string.format("Current Tier: %d / %d", currentTier, maxTier))

    -- =============================================
    -- OWNED BOOSTS (dari tier 1 sampai tier saat ini)
    -- =============================================
    if currentTier > 0 then
        local ownedBoostStrings = {}
        local ownedUnlockStrings = {}

        -- Loop semua tier yang sudah dilewati
        for tierIdx = 1, currentTier do
            local tierData = SummerTiersModule.tiers[tierIdx]
            if tierData then
                if tierData.unlocks then
                    for _, unlock in ipairs(tierData.unlocks) do
                        table.insert(ownedUnlockStrings, unlock)
                    end
                end
                if tierData.boosts then
                    for _, boost in ipairs(tierData.boosts) do
                        table.insert(ownedBoostStrings, string.format("%s%s %s", boost[3], EternityNum.toSuffix(EternityNum.convert(boost[2]), 1), boost[1]))
                    end
                end
            end
        end

        if #ownedUnlockStrings > 0 then
            table.insert(lines, "Owned Unlocks: " .. table.concat(ownedUnlockStrings, ", "))
        end
        if #ownedBoostStrings > 0 then
            table.insert(lines, "Owned Boosts: " .. table.concat(ownedBoostStrings, ", "))
        elseif #ownedUnlockStrings == 0 then
            table.insert(lines, "Owned Boosts: None")
        end
    end

    -- =============================================
    -- NEXT TIER INFO
    -- =============================================
    local nextTierData = SummerTiersModule.tiers[currentTier + 1]
    if nextTierData then
        table.insert(lines, " ")
        table.insert(lines, "--- Next Tier ---")
        local statName = nextTierData.statPath[#nextTierData.statPath]
        local statValue = state[statName] or 0
        local requirement = nextTierData.requirement
        local color = canTierUp(state) and "#00ff00" or "#ff5555"

        table.insert(lines, string.format("Next Requirement: %s %s", statName, EternityNum.toSuffix(EternityNum.convert(requirement), 1)))
        table.insert(lines, string.format("Have: %s %s%s", EternityNum.toSuffix(EternityNum.convert(statValue), 1),statName,GetIconCurrency(statName)))

        if nextTierData.unlocks then
            local unlockStrings = {}
            for _, unlock in ipairs(nextTierData.unlocks) do
                table.insert(unlockStrings, unlock)
            end
            table.insert(lines, "Unlocks: " .. table.concat(unlockStrings, ", "))
        end

        if nextTierData.boosts then
            local nextBoostStrings = {}
            for _, boost in ipairs(nextTierData.boosts) do
                table.insert(nextBoostStrings, string.format("%s%s %s", boost[3], EternityNum.toSuffix(EternityNum.convert(boost[2]), 1), boost[1]))
            end
            table.insert(lines, "Next Boosts: " .. table.concat(nextBoostStrings, ", "))
        end
    else
        table.insert(lines, "✅ MAXED")
    end

    SafeSetDesc(autoSummerToggle, table.concat(lines, "\n"))
end)

-- =====================================================
-- AUTO TIER (DataService Game)
-- =====================================================
Config.AutoTier = false

-- Require modul & service

-- Cek apakah fitur tier terbuka (sama seperti client)
local function isTierFeatureUnlocked(state)
    if not state then return false end
    return (state.Tier or 0) >= 1 or (state.HourglassMilestone or 0) >= 10
end

-- Cek apakah bisa tier up
local function canTierUp(state)
    if not state then return false end
    if not isTierFeatureUnlocked(state) then return false end

    local currentTier = state.Tier or 0
    local nextTierData = TiersModule.tiers[currentTier + 1]
    if not nextTierData then return false end

    local statName = nextTierData.statPath[#nextTierData.statPath]
    local statValue = state[statName] or 0
    return EternityNum.meeq(EternityNum.convert(statValue), EternityNum.convert(nextTierData.requirement))
end

-- Format boost
local function formatTierBoost(boost)
    -- boost = { "Stat", value, operator }
    local statName = boost[1]
    local value = boost[2]
    local operator = boost[3] or "x"
    local colorRGB = Utilities.FindRGBColorByStatName(statName)
    local formattedValue = EternityNum.toSuffix(EternityNum.convert(value), 1)
    return string.format("%s%s <font color=\"rgb(%s)\">%s</font>", operator, formattedValue, colorRGB, statName)
end

-- Format semua boosts dalam satu baris
local function formatBoosts(boostList)
    local parts = {}
    for _, boost in ipairs(boostList) do
        table.insert(parts, formatTierBoost(boost))
    end
    return table.concat(parts, ", ")
end

-- Toggle Auto Tier
local autoTierToggle = ResetLayers:Toggle({
    Title = "Tier",
    Image = GetIconCurrency("Tier"),
    Flag = "AutoTier",
    Value = false,
    Callback = function(val)
        Config.AutoTier = val
        if val then
            StartManagedLoop("AutoTier", 1, function()
                return Config.AutoTier
            end, function()
                local state = getPlayerState()
                if state and canTierUp(state) then
                    TierUpRemote:FireServer()
                end
            end)
        else
            StopManagedLoop("AutoTier")
        end
    end
})
FM_Add("Tier",autoTierToggle,ResetLayersCategory)
-- Status loop
StartStatusLoop("Status_AutoTier", 1, function()
    if not autoTierToggle then return end

    local state = getPlayerState()
    if not state then
        SafeSetDesc(autoTierToggle, "Waiting data...")
        return
    end

    local currentTier = state.Tier or 0
    local maxTier = #TiersModule.tiers
    local lines = {}
    table.insert(lines, string.format("Current Tier: %d / %d", currentTier, maxTier))

    -- Feature locked?
    if not isTierFeatureUnlocked(state) then
        table.insert(lines, "Feature Locked (Need Tier 1 or Hourglass Milestone 10)")
    end

    -- Owned Boosts (dari tier 1 sampai tier saat ini)
    if currentTier > 0 then
        local ownedBoostList = {}
        local ownedUnlockList = {}
        for tierIdx = 1, currentTier do
            local tierData = TiersModule.tiers[tierIdx]
            if tierData then
                if tierData.unlocks then
                    for _, unlock in ipairs(tierData.unlocks) do
                        table.insert(ownedUnlockList, unlock)
                    end
                end
                if tierData.boosts then
                    for _, boost in ipairs(tierData.boosts) do
                        table.insert(ownedBoostList, boost)
                    end
                end
            end
        end
        if #ownedUnlockList > 0 then
            table.insert(lines, "Owned Unlocks: " .. table.concat(ownedUnlockList, ", "))
        end
        if #ownedBoostList > 0 then
            table.insert(lines, "Owned Boosts: " .. formatBoosts(ownedBoostList))
        end
    end

    -- Next tier info
    local nextTierData = TiersModule.tiers[currentTier + 1]
    if nextTierData then
        table.insert(lines, " ")
        table.insert(lines, "--- Next Tier ---")
        local statName = nextTierData.statPath[#nextTierData.statPath]
        local statValue = state[statName] or 0
        local requirement = nextTierData.requirement
        local color = canTierUp(state) and "#00ff00" or "#ff5555"

        table.insert(lines, string.format("Requirement: %s %s", EternityNum.toSuffix(EternityNum.convert(requirement), 1), statName))
        table.insert(lines, string.format("Have: %s", EternityNum.toSuffix(EternityNum.convert(statValue), 1)))

        if nextTierData.unlocks then
            table.insert(lines, "Unlocks: " .. table.concat(nextTierData.unlocks, ", "))
        end
        if nextTierData.boosts then
            table.insert(lines, "Next Boosts: " .. formatBoosts(nextTierData.boosts))
        end

        -- Rune chance
        local runeChance = TiersModule.getRunesChanceToKeep(currentTier)
        table.insert(lines, string.format("Runes Kept: 1 in %s", EternityNum.toSuffix(EternityNum.convert(runeChance), 1)))
    else
        table.insert(lines, "✅ MAXED")
    end

    SafeSetDesc(autoTierToggle, table.concat(lines, "\n"))
end)

-- =====================================================
-- AUTO UPGRADE TREE (Satu Toggle Semua Node)
-- =====================================================
Config.AutoUpgradeTree = false

-- Require modul

-- Cek parent unlock
local function checkParentsUnlocked(treeName, nodeData)
    if not nodeData.parents or #nodeData.parents == 0 then
        return true
    end
    for _, parentName in ipairs(nodeData.parents) do
        local parentLevel = DataService:get({ "UpgradeTrees", treeName, parentName }) or 0
        if parentLevel == 0 then
            return false
        end
    end
    return true
end

-- Ambil level node
local function getNodeLevel(treeName, nodeName)
    return DataService:get({ "UpgradeTrees", treeName, nodeName }) or 0
end

-- Ambil nilai currency
local function getCurrencyValue(currencyPath)
    return DataService:get(currencyPath) or 0
end

-- Cek bisa beli node
local function canBuyNode(treeName, nodeName, nodeData, state)
    local level = getNodeLevel(treeName, nodeName)
    if level >= nodeData.maxLevel then return false end
    if not checkParentsUnlocked(treeName, nodeData) then return false end

    local currencyPath = nodeData.currencyPath
    if not currencyPath then return false end

    local currency = getCurrencyValue(currencyPath)
    local cost = nodeData.cost(level)
    return EternityNum.meeq(EternityNum.convert(currency), EternityNum.convert(cost))
end

-- Format boost
local function formatBoostText(nodeData, level, state)
    local boostLines = {}
    if nodeData.boosts then
        for statName, boostDef in pairs(nodeData.boosts) do
            local val = boostDef.formula(level)
            local formattedVal = Utilities.Short.formatNumber(state, val)
            local colorRGB = Utilities.FindRGBColorByStatName(statName)
            local operator = boostDef.operator or "x"
            boostLines[#boostLines + 1] = string.format("%s%s <font color=\"rgb(%s)\">%s</font>", operator, formattedVal, colorRGB, statName)
        end
    end
    return #boostLines > 0 and table.concat(boostLines, ", ") or "No Boosts"
end

-- Format cost
local function formatCostText(nodeData, level, state)
    if nodeData.costText then
        return nodeData.costText(state, level)
    end
    local cost = nodeData.cost(level)
    local currencyName = nodeData.currencyPath and nodeData.currencyPath[#nodeData.currencyPath] or "?"
    return string.format("%s %s", Utilities.Short.formatNumber(state, cost), currencyName)
end

-- Toggle Auto Upgrade Tree
local autoTreeToggle = ResetLayers:Toggle({
    Title = "Upgrade Tree",
    Flag = "AutoUpgradeTree",
    Value = false,
    Callback = function(val)
        Config.AutoUpgradeTree = val
        if val then
            StartManagedLoop("AutoUpgradeTree", 0.5, function()
                return Config.AutoUpgradeTree
            end, function()
                local state = getPlayerState()
                if not state then return end

                -- Kumpulkan semua node yang bisa dibeli
                local buyableNodes = {}

                for treeName, treeData in pairs(UpgradeTreesModule.trees) do
                    if treeData and treeData.nodes then
                        for nodeName, nodeData in pairs(treeData.nodes) do
                            if canBuyNode(treeName, nodeName, nodeData, state) then
                                local level = getNodeLevel(treeName, nodeName)
                                local cost = nodeData.cost(level)

                                table.insert(buyableNodes, {
                                    treeName = treeName,
                                    nodeName = nodeName,
                                    nodeData = nodeData,
                                    cost = cost,
                                    level = level,
                                })
                            end
                        end
                    end
                end

                if #buyableNodes > 0 then
                    -- Urutkan dari harga terkecil
                    table.sort(buyableNodes, function(a, b)
                        return EternityNum.cmp(a.cost, b.cost) < 0
                    end)

                    -- Beli node termurah
                    local chosen = buyableNodes[1]
                    UpgradeTreeRemote:FireServer(chosen.treeName, chosen.nodeName)
                end
            end)
        else
            StopManagedLoop("AutoUpgradeTree")
        end
    end
})
FM_Add("Jungle",autoTreeToggle,ResetLayersCategory)
-- Status loop
StartStatusLoop("Status_AutoUpgradeTree", 0.5, function()
    if not autoTreeToggle then return end

    local state = getPlayerState()
    if not state then
        SafeSetDesc(autoTreeToggle, "Waiting data...")
        return
    end

    local lines = {}

    for treeName, treeData in pairs(UpgradeTreesModule.trees) do
        if treeData and treeData.nodes then
            local ownedNodes = {}
            local nextNodesData = {}

            -- Kumpulkan node owned & next
            for nodeName, nodeData in pairs(treeData.nodes) do
                local level = getNodeLevel(treeName, nodeName)
                local maxLevel = nodeData.maxLevel or 1
                local parentsUnlocked = checkParentsUnlocked(treeName, nodeData)
                local currencyName = nodeData.currencyPath and nodeData.currencyPath[#nodeData.currencyPath] or "?"

                -- Node yang sudah dimiliki (level > 0)
                if level > 0 then
                    local boostText = formatBoostText(nodeData, level, state)
                    local line = string.format("• %s (Lv.%d/%d)", nodeData.title or nodeName, level, maxLevel)
                    if boostText ~= "No Boosts" then
                        if level >= maxLevel then
                            line = line .. " | " .. boostText
                        else
                            line = line .. " | " .. formatCostText(nodeData, level, state) .. GetIconCurrency(currencyName) .. "| " .. boostText
                        end
                    end
                    table.insert(ownedNodes, line)
                -- Node yang belum dimiliki & parents unlocked
                elseif parentsUnlocked then
                    local cost = nodeData.cost(level)
                    table.insert(nextNodesData, {
                        nodeName = nodeName,
                        nodeData = nodeData,
                        level = level,
                        maxLevel = maxLevel,
                        cost = cost,
                    })
                end
            end

            -- Urutkan next nodes berdasarkan cost terkecil
            table.sort(nextNodesData, function(a, b)
                return EternityNum.cmp(a.cost, b.cost) < 0
            end)

            local nextNodes = {}
            for _, entry in ipairs(nextNodesData) do
                local nodeData = entry.nodeData
                local level = entry.level
                local maxLevel = entry.maxLevel
                local cost = entry.cost

                local costText = formatCostText(nodeData, level, state)
                local currencyName = nodeData.currencyPath and nodeData.currencyPath[#nodeData.currencyPath] or "?"
                local currencyValue = getCurrencyValue(nodeData.currencyPath)
                local canAfford = EternityNum.meeq(EternityNum.convert(currencyValue), EternityNum.convert(cost))
                local color = canAfford and "#00ff00" or "#ff5555"
                local boostText = formatBoostText(nodeData, level, state)

                local line = string.format(
                    '• %s (Lv.%d/%d) | %s%s',
                    nodeData.title or entry.nodeName,
                    level,
                    maxLevel,
                    costText,GetIconCurrency(currencyName)
                )
                if boostText ~= "No Boosts" then
                    line = line .. " | " .. boostText
                end
                table.insert(nextNodes, line)
            end
            -- table.insert(lines, string.format("[%s]", treeName))

            if #ownedNodes > 0 then
                table.insert(lines, "Owned Nodes:")
                for _, line in ipairs(ownedNodes) do
                    table.insert(lines, line)
                end
            else
                table.insert(lines, "Owned Nodes: None")
            end

            if #nextNodes > 0 then
                table.insert(lines, "Unlock Nodes:")
                for _, line in ipairs(nextNodes) do
                    table.insert(lines, line)
                end
            else
                table.insert(lines, "Next Nodes: Maxed / All Owned")
            end
        end
    end

    SafeSetDesc(autoTreeToggle, table.concat(lines, "\n"))
end)
-- =====================================================
-- MANUAL CONVERTER BUTTONS
-- =====================================================
-- Require modul & remote
ConverterModule = require(ReplicatedStorage.Modules.Shared.Converter)
ConverterRemote = ReplicatedStorage.Remotes.Converter

-- Helper cek unlock
local function isConverterUnlocked(state)
    if not state or not state.UpgradeTrees or not state.UpgradeTrees.Jungle then
        return false
    end
    return (state.UpgradeTrees.Jungle.ANewBeginning or 0) >= 1
end
-- Simpan referensi tombol untuk update deskripsi
local exchangeButtons = {}

-- Daftar stat yang bisa dikonversi (sesuai client)
local converterStats = { "Souls", "Wisps", "Essence", "Heat" }

-- Buat tombol per stat
count = 0
for _, statName in ipairs(converterStats) do
    if count % 2 == 0 then
        group = ResetLayers:Group({})
        FM_Add("Converter",group,ResetLayersCategory)
    end
    count += 1
    local btn = group:Button({
        Title = GetIconCurrency(statName) .. statName .. GetIconCurrency(statName),
        Icon = "",
        Callback = function()
            local state = getPlayerState()
            exchangeButtons[statName]:Highlight()
            if state and isConverterUnlocked(state) then
                ConverterRemote:FireServer(statName)
            end
        end
    })
    exchangeButtons[statName] = btn
end

-- Tombol Exchange All
local exchangeAllBtn
exchangeAllBtn = ResetLayers:Button({
    Title = "All",
    Icon = "",
    Callback = function()
        local state = getPlayerState()
        exchangeAllBtn:Highlight()
        if state and isConverterUnlocked(state) then
            ConverterRemote:FireServer()
        end
    end
})
FM_Add("Converter",exchangeAllBtn,ResetLayersCategory)

-- Status loop hanya untuk update tampilan tombol, TIDAK mengeksekusi apa pun
StartStatusLoop("Status_ConverterButtons", 1, function()
    local state = getPlayerState()
    if not state then
        for _, btn in pairs(exchangeButtons) do
            SafeSetDesc(btn, "Waiting data...")
        end
        SafeSetDesc(exchangeAllBtn, "Waiting data...")
        return
    end

    if not isConverterUnlocked(state) then
        for _, btn in pairs(exchangeButtons) do
            SafeSetDesc(btn, "Locked (Need A New Beginning)")
        end
        SafeSetDesc(exchangeAllBtn, "Locked (Need A New Beginning)")
        return
    end

    -- Update deskripsi tombol per stat
    for statName, btn in pairs(exchangeButtons) do
        local amount = state[statName] or 0
        local rateFunc = ConverterModule["get" .. statName .. "ConversionRate"]
        if rateFunc then
            local rate = rateFunc(state)
            local desc = string.format("%s%s: %s -> %s Convergence%s",
                GetIconCurrency(statName),
                statName,
                EternityNum.toSuffix(EternityNum.convert(amount), 1),
                EternityNum.toSuffix(EternityNum.convert(rate), 1),
                GetIconCurrency("Convergence")
            )
            SafeSetDesc(btn, desc)
        else
            SafeSetDesc(btn, "Conversion rate unavailable")
        end
    end

    -- Update deskripsi tombol Exchange All
    local finalAmount = ConverterModule.getExchangeAllFinalAmount(state)
    local bonus = ConverterModule.getExchangeAllBonus(state)
    local desc = string.format("Total: %s Convergence%s (x%s Bonus)",
        EternityNum.toSuffix(EternityNum.convert(finalAmount), 1),
        GetIconCurrency("Convergence"),
        EternityNum.toSuffix(EternityNum.convert(bonus), 1)
    )
    SafeSetDesc(exchangeAllBtn, desc)
end)

-- =====================================================
-- AUTO MERCHANT (DataService Game)
-- =====================================================
Config.AutoMerchant = false

-- Require modul & remote
ItemsModule = require(ReplicatedStorage.Modules.Shared.Items)
MerchantModule = require(ReplicatedStorage.Modules.Shared.Merchant)
MerchantRemote = ReplicatedStorage.Remotes.Merchant

-- Cache stock
local merchantStock = {}
local merchantRefreshTime = 0
local merchantStockFetchedAt = 0

-- Helper fetch stock
local function fetchMerchantStock()
    local ok, stock, refreshTime = pcall(function()
        return MerchantRemote:InvokeServer("FetchData")
    end)
    if ok and stock then
        merchantStock = stock
        merchantRefreshTime = refreshTime or 0
        merchantStockFetchedAt = os.clock()
        return true
    end
    return false
end

-- Cek apakah slot bisa dibeli
local function canPurchaseSlot(slot, state)
    if (state.Tier or 0) < 2 then return false end
    if not slot then return false end

    local purchasesUsed = state.MerchantSession and state.MerchantSession.Purchases or 0
    local maxPurchases = MerchantModule.getMaxPurchasesPerInterval(state)

    if slot.CurrentPurchased >= slot.MaxStock then return false end
    if purchasesUsed >= maxPurchases then return false end

    local currencyPath = slot.PriceStatPath
    if not currencyPath then return false end
    local currencyValue = DataService:get(currencyPath)
    if currencyValue == nil then return false end

    return EternityNum.meeq(EternityNum.convert(currencyValue), EternityNum.convert(slot.Price))
end
-- Toggle Auto Merchant
local autoMerchantToggle = ResetLayers:Toggle({
    Title = "Auto Merchant",
    Flag = "AutoMerchant",
    Value = false,
    Callback = function(val)
        Config.AutoMerchant = val
        if val then
            StartManagedLoop("AutoMerchant", 1, function()
                return Config.AutoMerchant
            end, function()
                local state = getPlayerState()
                if not state then return end

                -- Refresh stock setiap 5 detik atau jika belum ada
                if os.clock() - merchantStockFetchedAt > 5 or #merchantStock == 0 then
                    fetchMerchantStock()
                end

                if #merchantStock == 0 then return end

                -- Kumpulkan slot yang bisa dibeli
                local buyable = {}
                for _, slot in ipairs(merchantStock) do
                    if canPurchaseSlot(slot, state) then
                        table.insert(buyable, slot)
                    end
                end

                if #buyable == 0 then return end

                -- Pilih harga termurah
                table.sort(buyable, function(a, b)
                    return EternityNum.cmp(EternityNum.convert(a.Price), EternityNum.convert(b.Price)) < 0
                end)

                local target = buyable[1]
                local ok, err = MerchantRemote:InvokeServer("PurchaseItem", target.SlotIndex)
                if ok then
                    target.CurrentPurchased += 1
                end
            end)
        else
            StopManagedLoop("AutoMerchant")
        end
    end
})
FM_Add("Merchant",autoMerchantToggle,ResetLayersCategory)

-- Status loop
StartStatusLoop("Status_AutoMerchant", 1, function()
    if not autoMerchantToggle then return end

    local state = getPlayerState()
    if not state then
        SafeSetDesc(autoMerchantToggle, "Waiting data...")
        return
    end

    -- Fetch stock jika belum ada atau sudah 5 detik
    if os.clock() - merchantStockFetchedAt > 5 or #merchantStock == 0 then
        fetchMerchantStock()
    end

    local lines = {}

    if (state.Tier or 0) < 2 then
        table.insert(lines, "Locked (Need Tier 2)")
    else
        local maxPurchases = MerchantModule.getMaxPurchasesPerInterval(state)
        local used = state.MerchantSession and state.MerchantSession.Purchases or 0
        table.insert(lines, string.format("Purchases Left: %d/%d", maxPurchases - used, maxPurchases))

        if merchantRefreshTime > 0 then
            table.insert(lines, string.format("Stock Refresh In: %s", Utilities.Short.time(merchantRefreshTime)))
        else
            table.insert(lines, "Stock Refresh In: ...")
        end

        table.insert(lines, " ")
        if #merchantStock == 0 then
            table.insert(lines, "No stock data.")
        else
            for _, slot in ipairs(merchantStock) do
                local item = ItemsModule.items[slot.ItemName]
                local itemTitle = item and item.title or slot.ItemName
                local stockLeft = slot.MaxStock - slot.CurrentPurchased
                local priceStr = Utilities.Short.formatNumber(state, slot.Price)
                local currencyName = slot.PriceStatPath[#slot.PriceStatPath]

                local status
                if slot.CurrentPurchased >= slot.MaxStock then
                    status = "Sold Out"
                elseif used >= maxPurchases then
                    status = "Limit Reached"
                elseif not EternityNum.meeq(EternityNum.convert(DataService:get(slot.PriceStatPath)), EternityNum.convert(slot.Price)) then
                    status = "Can't Afford"
                else
                    status = "Ready"
                end

                local line = string.format(
                    "Slot%d: +%d %s | %s %s | Stock: %d/%d | %s",
                    slot.SlotIndex,
                    slot.Amount,
                    itemTitle,
                    priceStr,
                    currencyName,
                    stockLeft,
                    slot.MaxStock,
                    status
                )
                table.insert(lines, line)
            end
        end
    end

    SafeSetDesc(autoMerchantToggle, table.concat(lines, "\n"))
end)

-- =====================================================
-- AUTO SELL FISHES (Sell All)
-- =====================================================
Config.AutoSellFishes = false

-- Require modul & service
local FishingModule = require(ReplicatedStorage.Modules.Shared.Fishing)
local SellFishRemote = ReplicatedStorage.Remotes.SellFish

-- Helper dapatkan semua ikan yang dimiliki beserta nilai jual
local function getSellableFishDetails(state)
    local details = {}
    local totalValue = EternityNum.convert(0)

    for fishName, fishData in pairs(FishingModule.fishes) do
        local amount = state.Fishes and state.Fishes[fishName] or 0
        if amount > 0 then
            local sellValue = FishingModule.calculateFishSellValue(state, fishName) or EternityNum.convert(0)
            local locked = state.Locks and state.Locks[fishName] == true
            table.insert(details, {
                Name = fishName,
                Amount = amount,
                SellValue = sellValue,
                Locked = locked,
                Rarity = fishData.rarity,
            })
            if not locked then
                totalValue = EternityNum.add(totalValue, sellValue)
            end
        end
    end

    table.sort(details, function(a, b)
        return (FishingModule.raritiesOrder[a.Rarity] or 99) < (FishingModule.raritiesOrder[b.Rarity] or 99)
    end)

    return details, totalValue
end
-- Toggle Auto Sell All
local autoSellFishToggle = ResetLayers:Toggle({
    Title = "Sell Fish",
    Flag = "AutoSellFishes",
    Value = false,
    Callback = function(val)
        Config.AutoSellFishes = val
        if val then
            StartManagedLoop("AutoSellFishes", 10, function()
                return Config.AutoSellFishes
            end, function()
                -- Cek apakah ada ikan yang bisa dijual
                local state = getPlayerState()
                if not state then return end

                local details, totalValue = getSellableFishDetails(state)
                if EternityNum.me(totalValue, EternityNum.convert(0)) then
                    SellFishRemote:FireServer(nil, true) -- sell all
                end
            end)
        else
            StopManagedLoop("AutoSellFishes")
        end
    end
})
FM_Add("Fishing",autoSellFishToggle,ResetLayersCategory)
-- Status loop
StartStatusLoop("Status_AutoSellFishes", 1, function()
    if not autoSellFishToggle then return end

    local state = getPlayerState()
    if not state then
        SafeSetDesc(autoSellFishToggle, "Waiting data...")
        return
    end

    local details, totalValue = getSellableFishDetails(state)
    local lines = {}
    local NewButton = {}

    if #details == 0 then
        table.insert(lines, "No fishes to sell")
    else
        table.insert(lines, "Click Sell On Specific Fish For Manual Sell Or Active the toggle for Auto Sell All")
        SellFishes = LocalPlayer.PlayerGui.Interface.Frames:FindFirstChild("SellFishes",true)
        for _, fish in ipairs(details) do
            FishGradient = SellFishes:FindFirstChild(fish.Name,true):FindFirstChild(fish.Rarity,true).Color
            local Coloring = GetGradientTagFromSequence(FishGradient, fish.Name)
            local lockStatus = fish.Locked and " [Locked]" or ""
            FishName = fish.Name:gsub(" ","")
            NewButton[FishName] = {
                Color = Color3.fromHex("#305dff"),
                Callback = function()
                    SellFishRemote:FireServer(fish.Name)
                end,
            }
            table.insert(lines, string.format("• %s (x%d) - $%s%s <button=%s>Sell</button>",
                Coloring,
                fish.Amount,
                EternityNum.toSuffix(fish.SellValue, 1),
                lockStatus,
                FishName
            ))

        end
        table.insert(lines, string.format("Total Sell Value: $%s", EternityNum.toSuffix(totalValue, 1)))
    end
    autoSellFishToggle:SetButtons(NewButton)
    SafeSetDesc(autoSellFishToggle, table.concat(lines, "\n"))
end)
-- =====================================================
-- AUTO COLLECT SOULS (MoveTo)
-- =====================================================
local AutoSoulTab = Window:Tab({
    Title = "Automation",
})

Config.AutoCollectSouls = false
-- Referensi folder spawner soul player
local SoulsMainFolder = workspace:WaitForChild("Main", 10):WaitForChild("Souls", 10)
local localSoulFolder = SoulsMainFolder and SoulsMainFolder:FindFirstChild(LocalPlayer.Name)

local function getSouls()
    if not localSoulFolder then return {} end
    local souls = {}
    for _, obj in ipairs(localSoulFolder:GetChildren()) do
        if obj:IsA("BasePart") then
            table.insert(souls, obj)
        elseif obj:IsA("Model") then
            local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if primary then
                table.insert(souls, primary)
            end
        end
    end
    return souls
end

-- Sekarang getNearestSoul bisa mengabaikan soul tertentu (ignoreSoul)
local function getNearestSoul(position, souls, ignoreSoul)
    local nearest = nil
    local nearestDist = math.huge
    for _, soul in ipairs(souls) do
        if soul and soul.Parent and soul ~= ignoreSoul then
            local dist = (soul.Position - position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = soul
            end
        end
    end
    return nearest, nearestDist
end

local currentTarget = nil
local currentTargetSetAt = 0
local lastRootPos = nil

-- Toggle Auto Collect Souls
local autoSoulToggle = AutoSoulTab:Toggle({
    Title = "Auto Collect Souls",
    Flag = "AutoCollectSouls",
    Value = false,
    Callback = function(val)
        Config.AutoCollectSouls = val
        if val then
            StartManagedLoop("AutoCollectSouls", 0.3, function()
                return Config.AutoCollectSouls
            end, function()
                local character = LocalPlayer.Character
                if not character then return end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart")
                if not humanoid or not root then return end

                local souls = getSouls()
                if #souls == 0 then
                    currentTarget = nil
                    humanoid:Move(Vector3.new(0, 0, 0), false)
                    return
                end

                local now = os.clock()

                -- Reset jika target sudah tidak ada
                if currentTarget and not currentTarget.Parent then
                    currentTarget = nil
                end

                -- Pilih target baru jika belum ada
                if not currentTarget then
                    local nearest, _ = getNearestSoul(root.Position, souls, nil)
                    if nearest then
                        currentTarget = nearest
                        currentTargetSetAt = now
                        lastRootPos = root.Position
                    end
                else
                    -- Deteksi stuck: jika sudah 2 detik dan posisi tidak berubah banyak, cari target lain
                    if now - currentTargetSetAt >= 2 then
                        local movedDist = (root.Position - (lastRootPos or root.Position)).Magnitude
                        if movedDist < 0.5 then
                            -- Cari Soul terdekat selain currentTarget
                            local newNearest, _ = getNearestSoul(root.Position, souls, currentTarget)
                            if newNearest then
                                currentTarget = newNearest
                                currentTargetSetAt = now
                                lastRootPos = root.Position
                            else
                                -- Tidak ada target lain, pertahankan target sekarang
                                currentTargetSetAt = now
                                lastRootPos = root.Position
                            end
                        else
                            -- Sudah bergerak, reset timer
                            currentTargetSetAt = now
                            lastRootPos = root.Position
                        end
                    else
                        -- Belum 2 detik, update posisi terakhir
                        lastRootPos = root.Position
                    end
                end

                if currentTarget then
                    humanoid:MoveTo(currentTarget.Position)
                else
                    humanoid:Move(Vector3.new(0, 0, 0), false)
                end
            end)
        else
            StopManagedLoop("AutoCollectSouls")
            currentTarget = nil
        end
    end
})

-- Status loop
StartStatusLoop("Status_AutoCollectSouls", 1, function()
    if not autoSoulToggle then return end
    humanoid.WalkSpeed = 100

    local souls = getSouls()
    local lines = {}
    table.insert(lines, string.format("Auto Collect: %s", Config.AutoCollectSouls and "ON" or "OFF"))
    table.insert(lines, string.format("Souls Available: %d", #souls))

    if currentTarget and currentTarget.Parent then
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local dist = root and (root.Position - currentTarget.Position).Magnitude or 0
        table.insert(lines, string.format("Target: %s", currentTarget.Parent.Name or currentTarget.Name))
        table.insert(lines, string.format("Distance: %.1f studs", dist))

        local stuckTime = os.clock() - currentTargetSetAt
        table.insert(lines, string.format("Target Time: %.1f / 2.0s", stuckTime))
    else
        table.insert(lines, "No target")
    end

    SafeSetDesc(autoSoulToggle, table.concat(lines, "\n"))
end)

BoardsUpgradeCategory:Select("Souls")
Window:SelectTab(BoardUpgrades.Index)

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
