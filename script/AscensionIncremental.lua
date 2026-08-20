--[[
    ================================================================
     AN HUB  •  Ascension Incremental
     Author : Aditya Nugraha
    ----------------------------------------------------------------
     Struktur file:
       1. Bootstrap ............ guard, loading UI, services
       2. Config Manager ....... simpan/muat nama config
       3. Profile & Window ..... pembuatan window + key system
       4. Feature Manager (FM) . kategori & visibilitas element
       5. Helpers .............. Safe setters + Managed Loop engine
       6. Data Tables .......... BaseUpgrade / BaseColorIcon
       7. Shared Dependencies .. modules, remotes, services
       8. Feature Defaults ..... nilai default Config.Auto* (satu tempat)
       9. Features ............. Auto Ascension, Board, Voltage,
                                 Rune, Click, Tier, Skills, Sword,
                                 Balloon, Tree, Sacrifice, SP, Sand,
                                 Elemental Rank, Fire, Altar, Forge,
                                 Cactus
      10. Settings Tab ......... config save/load/delete + rejoin
    ================================================================
--]]

-- =====================================================
-- 1. BOOTSTRAP
-- =====================================================
if game.PlaceId ~= 88887739603194 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Ascension Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FolderPath = "ANUI/AscensionIncremental"
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local LastConfigFile = FolderPath .. "/LastConfig.txt"
local IsPremium = false
local ValidKeys = {"ANHUB-2025"}
local MapDBFile = "Map_Database.json"
local Config = {}
local ConfigName = "ANConfig"
local IsLoadingConfig = false
local ConfigNameInput
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

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


task.spawn(function()
    repeat task.wait() until game:GetService("Players").LocalPlayer
    local LP = game:GetService("Players").LocalPlayer
    LP:SetAttribute("AFKModeEnabled", false)

    LP.Idled:Connect(function()
        LP:SetAttribute("AFKModeEnabled", false)
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)
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

    return Window.ConfigManager:CreateConfig(ConfigName)
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
    Title = "AN Hub - Ascension Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "TapIncremental",
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

task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
Window:Tab({
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Ascension Incremental" }),
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
        Notify("Welcome!", "Premium Access Verified. Enjoy!", "crown")
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
local FM_Categories = {}
local FM_CategoryDescriptions = {
    ["Skills"] = "Auto Upgrade Skills Tree",
}

local function FM_GetElementFrame(elem)
    return rawget(elem, "ElementFrame") or (elem.UIElements and elem.UIElements.Main) or rawget(elem, "GroupFrame")
end

local function FM_UpdateTabProfile(selected)
    local desc = FM_CategoryDescriptions[selected] or ""
    local containers = {}
    if MainTabs and MainTabs.UIElements then
        table.insert(containers, MainTabs.UIElements.ContainerFrameCanvas)
        table.insert(containers, MainTabs.UIElements.ContainerFrame)
    end
    for _, cf in ipairs(containers) do
        if cf then
            local header = cf:FindFirstChild("ProfileHeader")
            if header then
                local tc = header:FindFirstChild("TextContainer")
                if tc then
                    for _, child in ipairs(tc:GetChildren()) do
                        if child:IsA("TextLabel") then
                            if child.LayoutOrder == 1 then child.Text = selected end
                            if child.LayoutOrder == 2 then child.Text = desc end
                        end
                    end
                end
            end
        end
    end
end

local function FM_Add(cat, elem)
    if not FM_Categories[cat] then FM_Categories[cat] = {} end
    table.insert(FM_Categories[cat], elem)
    local frame = FM_GetElementFrame(elem)
    if frame then frame.Visible = false end
    return elem
end

local function FM_OnChange(selected)
    for name, elems in pairs(FM_Categories) do
        local vis = (name == selected)
        for _, e in ipairs(elems) do
            local f = FM_GetElementFrame(e)
            if f then f.Visible = vis end
        end
    end
    pcall(function() FM_UpdateTabProfile(selected) end)
end

-- [[ MAIN TAB ]] --
MainTabs = Window:Tab({
    Title = "Main Feature",
    Icon = "swords",
    Profile = MakeProfile({
        Avatar = GameIconURL,
        Title = "Main Feature",
        Desc = "Ascension Incremental"
    }),
    SidebarProfile = false
});

-- Pembuatan Selector Kategori
FM_CategorySelector = MainTabs:Category({
    Title = "Select Category",
    Default = "Board Upgrades",
    Options = {
        {Title = "Board Upgrades", Icon = GetIcon(140301175399848)},
        {Title = "Events", Icon = LocalPlayer.PlayerGui:WaitForChild("HUD", 10):WaitForChild("StatsDisplay"):WaitForChild("Content"):FindFirstChild("Click").ImageLabel.Image},
        {Title = "Convert", Icon = GetIcon(101595095661272)},
        {Title = "Mobs", Icon = GetIcon(106633178741884)},
        {Title = "Rune", Icon = GetIcon(135230701981041)},
    },
    Callback = FM_OnChange
})

if FM_CategorySelector.ElementFrame then 
    FM_CategorySelector.ElementFrame.Parent = MainTabs.UIElements.ContainerFrameCanvas 
    FM_CategorySelector.ElementFrame.Position = UDim2.new(0, 0, 0, MainTabs.UIElements.ContainerFrame.Position.Y.Offset)
    
    local catSize = FM_CategorySelector.ElementFrame.Size.Y.Offset
    MainTabs.UIElements.ContainerFrame.Position = UDim2.new(0, 0, 0, MainTabs.UIElements.ContainerFrame.Position.Y.Offset + catSize)
    MainTabs.UIElements.ContainerFrame.Size = UDim2.new(1, 0, 1, MainTabs.UIElements.ContainerFrame.Size.Y.Offset - catSize)
    
    local pad = MainTabs.UIElements.ContainerFrame:FindFirstChildOfClass("UIPadding")
    if pad then pad.PaddingTop = UDim.new(0, 5) end
end

-- =====================================================
-- 5. HELPERS  (Safe setters + Managed Loop engine)
-- =====================================================
local function splitCamelCase(str)
    local result = {}
    
    for i = 1, #str do
        local char = str:sub(i, i) -- Ambil 1 karakter saat ini
        
        if i > 1 then
            local prevChar = str:sub(i-1, i-1)
            local nextChar = str:sub(i+1, i+1)
            
            local isUpper = char:match("%u")   -- Apakah huruf besar?
            local prevIsLower = prevChar:match("%l") -- Sebelumnya huruf kecil?
            local prevIsUpper = prevChar:match("%u") -- Sebelumnya huruf besar?
            local nextIsLower = nextChar:match("%l") -- Sesudahnya huruf kecil?
            
            if isUpper then
                -- Aturan 1: Kapital setelah huruf kecil (contoh: TestText)
                if prevIsLower then
                    table.insert(result, " ")
                -- Aturan 2: Kapital di tengah akronim (contoh: HTMLParser)
                elseif prevIsUpper and nextIsLower then
                    table.insert(result, " ")
                end
            end
        end
        
        table.insert(result, char)
    end
    
    return table.concat(result)
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

local BaseUpgrade = {
        ["Upgrades1"] = {
            ["StatName"] = "Flux",
            ["Color"] = "#d0ff00"
        },
        ["Upgrades2"] = {
            ["StatName"] = "Voltage",
            ["Color"] = "#ff0004"
        },
        ["Upgrades3"] = {
            ["StatName"] = "Shards",
            ["Color"] = "#fb8aff"
        },
        ["Upgrades4"] = {
            ["StatName"] = "Plasma",
            ["Color"] = "#6600ff"
        },
        ["Upgrades5"] = {
            ["StatName"] = "Cactus",
            ["Color"] = "#12b500"
        },
        ["Upgrades6"] = {
            ["StatName"] = "Sand",
            ["Color"] = "#dcff3d"
        },
        ["Upgrades7"] = {
            ["StatName"] = "Fire",
            ["Color"] = "#ff0000"
        },
        ["Upgrades8"] = {
            ["StatName"] = "Magma",
            ["Color"] = "#ff7900"
        },
        ["Upgrades9"] = {
            ["StatName"] = "Click",
            ["Color"] = "#a4a4a4"
        },
        ["Upgrades10"] = {
            ["StatName"] = "Balloon",
            ["Color"] = "#0b72ff"
        },
        ["Upgrades11"] = {
            ["StatName"] = "Diamonds",
            ["Color"] = "#0061db"
        },
        ["Upgrades12"] = {
            ["StatName"] = "Minerals",
            ["Color"] = "#0061db"
        },
        ["Upgrades13"] = {
            ["StatName"] = "Stars",
            ["Color"] = "#0061db"
        },
        ["Upgrades14"] = {
            ["StatName"] = "SpaceStone",
            ["Color"] = "#0061db"
        }
    }
local BaseColorIcon = {
    ["Flux"] = "#d0ff00",
    ["Points"] = "#000000",
    ["Voltage"] = "#ff0004",
    ["Shards"] = "#fb8aff",
    ["Plasma"] = "#6600ff",
    ["Cactus"] = "#12b500",
    ["Sand"] = "#dcff3d",
    ["Fire"] = "#ff0000",
    ["Magma"] = "#ff7900",
    ["Click"] = "#a4a4a4",
    ["Balloon"] = "#0b72ff",
    ["Diamonds"] = "#0061db",
    ["Minerals"] = "#0061db",
}
-- =====================================================
-- 7. SHARED DEPENDENCIES  (modules, remotes, services, folders)
-- =====================================================

-- Game modules
local OmegaNum             = require(ReplicatedStorage.Modules.OmegaNum)
local AscensionModule      = require(ReplicatedStorage.Modules.AscensionModule)
local UpgradeTreeConfig    = require(ReplicatedStorage.Modules.UpgradeTreeConfig)  -- untuk GetAscensionSynergyMultiplier
local UpgradeConfig        = require(ReplicatedStorage.Modules.UpgradeConfig)
local RuneData             = require(ReplicatedStorage.Modules.RuneData)
local EventTierData        = require(ReplicatedStorage.Modules.EventTierData)
local SkillTreeData        = require(ReplicatedStorage.SkillTreeData)
local SwordConfig          = require(ReplicatedStorage.Modules.SwordConfig)
local SPUpgradeConfig      = require(ReplicatedStorage.Modules.SPUpgradeConfig)
local ElementalRankConfig  = require(ReplicatedStorage.Modules.ElementalRankConfig)
local WinterCore           = require(ReplicatedStorage.Modules.WinterCore)

-- Remotes
local Remotes              = ReplicatedStorage.Remotes
local AscendEvent          = Remotes.AscendEvent
local UpgradeRequestRemote = Remotes.UpgradeRequest
local ConvertEvent         = Remotes.ConvertEvent
local RollRuneEvent        = Remotes.RollRuneEvent
local HudClickRemote       = Remotes.HudClick
local TierRequest          = Remotes.TierRequest
local PurchaseSkill        = Remotes.PurchaseSkill
local UpgradeSwordRequest  = Remotes.UpgradeSwordRequest
local BalloonRequest       = Remotes.BalloonRequest
local UpgradeTreeRequest   = Remotes.UpgradeTreeRequest
local SacrificeRequest     = Remotes.SacrificeRequest
local SPUpgradeRequest     = Remotes.SPUpgradeRequest
local SandRequest          = Remotes.SandRequest
local ElementalRankRequest = Remotes.ElementalRankRequest
local FireClick            = Remotes.FireClick
local AltarRoll            = Remotes.AltarRoll
local DepositCore          = Remotes.DepositCore
local ForgeDepositRequest  = Remotes.ForgeDepositRequest
local CollectCactus        = Remotes.CollectCactus

-- Services
local TweenService = game:GetService("TweenService")

-- Shared player-data folders/values
local StatsFolder      = LocalPlayer:WaitForChild("StatsFolder")
local AscensionStats   = LocalPlayer:WaitForChild("AscensionStats")
local Ascension        = AscensionStats:WaitForChild("Ascension")
local Upgrades         = LocalPlayer:WaitForChild("Upgrades")
local Resets           = LocalPlayer:WaitForChild("Resets")
local ElementalRank    = Resets:WaitForChild("ElementalRank")
local EventStatsFolder = LocalPlayer:FindFirstChild("EventStatsFolder")
local Shop             = LocalPlayer:FindFirstChild("Shop")
local Multis           = LocalPlayer:WaitForChild("Multis")

-- Referensi Upgrade36 untuk boost Rune Bulk
local UpgradeTree = LocalPlayer:WaitForChild("UpgradeTree", 15)
local Upgrade36 = nil
if UpgradeTree then
    Upgrade36 = UpgradeTree:WaitForChild("Upgrade36", 15)
end

local function OmegaConverter(Value)
    local v20 = OmegaNum.toOmega(Value)
    local v21 = OmegaNum.short
    if type(v21) == "function" then
        return OmegaNum.short(v20)
    else
        local v22 = OmegaNum.toDisplay
        if type(v22) == "function" then
            return OmegaNum.toDisplay(v20)
        else
            return OmegaNum.toString(v20)
        end
    end
end

-- =====================================================
-- 8. FEATURE DEFAULTS (CONFIG)
-- -----------------------------------------------------
-- Semua nilai default fitur dikumpulkan di satu tempat agar mudah diatur.
-- Interval dalam detik; mengubahnya di sini menyetel kecepatan loop fitur
-- terkait saat diaktifkan (loop membaca nilai ini ketika toggle dinyalakan).
-- =====================================================
Config.AutoAscend        = { Enabled = false, MaxLevel = 0 }              -- MaxLevel 0 = tanpa batas
Config.AutoVoltage       = { Enabled = false }
Config.AutoClick         = { Enabled = false, Interval = 0.01 }           -- kecepatan klik (detik)
Config.AutoTier          = { Enabled = false, Interval = 1 }              -- cek tiap 1 detik (hindari spam)
Config.AutoSkills        = { Enabled = false, Interval = 0.5 }
Config.AutoSword         = { Enabled = false, Interval = 0.5 }
Config.AutoBalloon       = { Enabled = false, Interval = 1 }
Config.AutoUpgradeTree   = { Enabled = false, Interval = 1 }
Config.AutoSacrifice     = { Enabled = false, Interval = 1 }
Config.AutoSPUpgrade     = { Enabled = false, Interval = 1 }
Config.AutoSand          = { Enabled = false, Interval = 1 }
Config.AutoElementalRank = { Enabled = false, Interval = 1 }
Config.AutoFireClick     = { Enabled = false, Interval = 0.5 }
Config.AutoAltarRoll     = { Enabled = false, Interval = 1 }              -- animasi roll ~2.4 detik
Config.AutoDepositCore   = { Enabled = false, Interval = 5, Mode = "Stats" }  -- Mode: "Stats" | "Runes" | "Both"
Config.AutoForgeDeposit  = { Enabled = false, Interval = 3 }
Config.AutoCollectCactus = { Enabled = false, Interval = 0.5, TweenTime = 0.3, MaxDistance = 100 }

-- =====================================================
-- 9. FEATURES
-- =====================================================

-- =====================================================
-- AUTO ASCENSION (Ascension Incremental) + BOOST INFO
-- =====================================================

-- Fungsi untuk mendapatkan level ascension saat ini dan biaya
local function getAscensionInfo()
    local ascObj = AscensionStats:FindFirstChild("Ascension")
    local pointsObj = StatsFolder:FindFirstChild("Points")
    if not ascObj or not pointsObj then
        return nil, nil, nil
    end
    local ascLevel = tonumber(ascObj.Value) or 0
    local pointsStr = pointsObj.Value
    local points = OmegaNum.fromString(pointsStr)
    local cost = AscensionModule.getCost(ascLevel)
    return ascLevel, points, cost
end

-- Fungsi untuk mendapatkan teks boost yang akan ditampilkan
local function getBoostText(ascLevel)
    local boosts = {}
    
    -- Points multiplier (selalu ada)
    local pointsMult = AscensionModule.getPointsMultiplier(ascLevel)
    local pointsDisplay = OmegaNum.short(OmegaNum.toOmega(pointsMult))
    if pointsDisplay:sub(-1):lower() ~= "x" then pointsDisplay = pointsDisplay .. "x" end
    table.insert(boosts, string.format("<font color=\"%s\">POINTS %s </font>", BaseColorIcon["Points"], pointsDisplay))
    
    -- Flux multiplier (mulai level 8)
    if ascLevel >= 8 then
        local fluxMult = AscensionModule.getFluxMultiplier(ascLevel)
        local fluxDisplay = OmegaNum.short(fluxMult)
        if fluxDisplay:sub(-1):lower() ~= "x" then fluxDisplay = fluxDisplay .. "x" end
        table.insert(boosts, string.format("<font color=\"%s\">Flux %s </font>", BaseColorIcon["Flux"], fluxDisplay))
    end
    
    -- Voltage multiplier (mulai level 21)
    if ascLevel >= 21 then
        local voltMult = AscensionModule.getVoltageMultiplier(ascLevel)
        local voltDisplay = OmegaNum.short(voltMult)
        if voltDisplay:sub(-1):lower() ~= "x" then voltDisplay = voltDisplay .. "x" end
        table.insert(boosts, string.format("<font color=\"%s\">Voltage %s </font>", BaseColorIcon["Voltage"], voltDisplay))
    end
    
    -- Rune Bulk (jika Upgrade36 sudah dibeli)
    if Upgrade36 and (tonumber(Upgrade36.Value) or 0) >= 1 then
        local runeMult = UpgradeTreeConfig.GetAscensionSynergyMultiplier(ascLevel)
        local runeDisplay = OmegaNum.short(runeMult)
        if runeDisplay:sub(-1):lower() ~= "x" then runeDisplay = runeDisplay .. "x" end
        table.insert(boosts, "RUNE BULK " .. runeDisplay)
    end
    
    -- Particles Bonus (mulai level 70, cek ParticlesBonus > 1)
    if ascLevel >= 70 then
        local particlesBonus = AscensionStats:FindFirstChild("ParticlesBonus")
        if particlesBonus then
            local val = tonumber(particlesBonus.Value) or 1
            if val > 1 then
                table.insert(boosts, "PARTICLES " .. tostring(val) .. "x")
            end
        end
    end
    
    -- Cactus Bonus (mulai level 250, cek CactusBonus > 1)
    if ascLevel >= 250 then
        local cactusBonus = AscensionStats:FindFirstChild("CactusBonus")
        if cactusBonus then
            local val = tonumber(cactusBonus.Value) or 1
            if val > 1 then
                table.insert(boosts, "CACTUS " .. tostring(val) .. "x")
            end
        end
    end
    
    return table.concat(boosts, " | ")
end

-- Fungsi auto ascend (dipanggil oleh loop)
local function tryAutoAscend()
    if not Config.AutoAscend.Enabled then return end

    local ascLevel, points, cost = getAscensionInfo()
    if not ascLevel then return end

    local maxLevel = Config.AutoAscend.MaxLevel
    if maxLevel > 0 and ascLevel >= maxLevel then return end

    -- Jika points cukup (points >= cost), kirim event
    if OmegaNum.meeq(points, cost) then
        AscendEvent:FireServer()
    end
end

-- Buat grup UI untuk Auto Ascension
local ascGroup = MainTabs:Group({})
FM_Add("Convert", ascGroup)  -- atau "AutoFarm", sesuaikan

-- Toggle Auto Ascension
local ascToggle = ascGroup:Toggle({
    Title = "🌟 Auto Ascension",
    Flag = "AutoAscension_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoAscend.Enabled = val
        if val then
            -- Mulai loop pengecekan
            StartManagedLoop("AutoAscension", 0.5, function() return Config.AutoAscend.Enabled end, tryAutoAscend)
        else
            StopManagedLoop("AutoAscension")
        end
    end
})

-- Update deskripsi toggle dengan info lengkap (biaya + boost)
StartStatusLoop("Status_AutoAscension", 0.5, function()
    local ascLevel, points, cost = getAscensionInfo()
    if not ascLevel then
        SafeSetDesc(ascToggle, "Memuat data...")
        return
    end

    local maxLevel = Config.AutoAscend.MaxLevel
    local costText = OmegaNum.short(cost)
    local pointsText = OmegaNum.short(points)
    local canBuy = OmegaNum.meeq(points, cost)

    -- Bangun deskripsi
    local desc = string.format("Ascension: %d", ascLevel)
    if maxLevel > 0 then
        desc = desc .. string.format("/%d", maxLevel)
    end
    desc = desc .. string.format("\nCost: %s/%s POINTS",pointsText, costText)

    -- Cek batas
    if maxLevel > 0 and ascLevel >= maxLevel then
        desc = desc .. "\n🔒 MAXED (User Limit)"
        SafeSetDesc(ascToggle, desc)
        return
    elseif ascLevel >= 315 then  -- milestone tertinggi
        desc = desc .. "\n🔒 MAXED (Game Limit)"
        SafeSetDesc(ascToggle, desc)
        return
    end

    -- Tambahkan informasi boost
    local boostText = getBoostText(ascLevel)
    if boostText ~= "" then
        desc = desc .. "\n\nBoost:\n" .. boostText
    end

    SafeSetDesc(ascToggle, desc)
end)
-- =====================================================
-- AUTO UPGRADE BOARD (Board Visibility seperti Client)
-- =====================================================

-- Cek apakah sebuah board (berdasarkan CostStat) sudah terlihat
local function isBoardVisible(costStat)
    local ascLevel = tonumber(Ascension.Value) or 0
    local elementalRankObj = Resets and Resets:FindFirstChild("ElementalRank")
    local elementalRank = elementalRankObj and tonumber(elementalRankObj.Value) or 0
    local plasmaObj = StatsFolder:FindFirstChild("Plasma")
    local plasmaValue = plasmaObj and plasmaObj.Value
    if not plasmaValue then
        plasmaValue = OmegaNum.fromNumber(0)
    end
    local plasmaOmega = OmegaNum.stron(tostring(plasmaValue)) or OmegaNum.fromNumber(0)
    local upgrade11Obj = Upgrades and Upgrades:FindFirstChild("Upgrade11")
    local upgrade12Obj = Upgrades and Upgrades:FindFirstChild("Upgrade12")
    local upgrade15TreeObj = UpgradeTree and UpgradeTree:FindFirstChild("Upgrade15")

    local upgrade11Level = upgrade11Obj and (tonumber(upgrade11Obj.Value) or 0) or 0
    local upgrade12Level = upgrade12Obj and (tonumber(upgrade12Obj.Value) or 0) or 0
    local upgrade15TreeLevel = upgrade15TreeObj and (tonumber(upgrade15TreeObj.Value) or 0) or 0

    if costStat == "Flux" then
        return ascLevel >= 1
    elseif costStat == "Voltage" then
        return ascLevel >= 15
    elseif costStat == "Shards" then
        return ascLevel >= 25
    elseif costStat == "Plasma" then
        return OmegaNum.meeq(plasmaOmega, OmegaNum.fromNumber(1))
            or upgrade11Level >= 1
            or upgrade12Level >= 1
            or upgrade15TreeLevel >= 1
    elseif costStat == "Cactus" then
        return ascLevel >= 5
    elseif costStat == "Sand" then
        return elementalRank >= 2
    elseif costStat == "Fire" then
        return elementalRank >= 6
    elseif costStat == "Magma" then
        return elementalRank >= 9
    elseif costStat == "Click" or costStat == "Balloon" or costStat == "Diamonds" then
        return ascLevel >= 5
    end
    return false
end

-- Fungsi cek unlock upgrade (termasuk board visibility)
local function isBoardUpgradeUnlocked(upgradeId, upgradeData)
    -- Syarat dari data upgrade
    local ascLevel = tonumber(Ascension.Value) or 0
    if upgradeData.UnlockAscension and ascLevel < upgradeData.UnlockAscension then
        return false
    end
    if upgradeData.UnlockImpact then
        local impact = Resets and Resets:FindFirstChild("Impact")
        if not impact or (tonumber(impact.Value) or 0) < upgradeData.UnlockImpact then
            return false
        end
    end
    if upgradeData.UnlockElementalRank then
        local er = Resets and Resets:FindFirstChild("ElementalRank")
        if not er or (tonumber(er.Value) or 0) < upgradeData.UnlockElementalRank then
            return false
        end
    end
    if upgradeData.UnlockTreeUpgrade then
        if not UpgradeTree then return false end
        local treeUp = UpgradeTree:FindFirstChild(upgradeData.UnlockTreeUpgrade)
        if not treeUp or (tonumber(treeUp.Value) or 0) < 1 then
            return false
        end
    end

    -- Syarat papan (board) harus terlihat
    local costStat = upgradeData.CostStat
    if not isBoardVisible(costStat) then
        return false
    end

    return true
end

-- Max level dinamis
local function getBoardMaxLevel(upgradeId)
    return UpgradeConfig.GetMaxLevel(upgradeId, tonumber(Ascension.Value) or 0)
end

-- Fungsi beli satu upgrade
local function tryBuyUpgrade(upgradeId, upgradeData)
    if not Upgrades then return end
    -- if not isBoardUpgradeUnlocked(upgradeId, upgradeData) then return end

    local upgradeValueObj = Upgrades:FindFirstChild(upgradeId)
    if not upgradeValueObj then return end

    local currentLevel = upgradeValueObj.Value
    local maxLevel = getBoardMaxLevel(upgradeId)
    if currentLevel >= maxLevel then return end

    local cost = UpgradeConfig.GetPriceAtLevel(upgradeId, currentLevel)
    if not cost then return end

    local costStatName = upgradeData.CostStat
    local costStatObj = StatsFolder:FindFirstChild(costStatName)
        or (EventStatsFolder and EventStatsFolder:FindFirstChild(costStatName))
        or (Shop and Shop:FindFirstChild(costStatName))
    if not costStatObj then return end

    if OmegaNum.meeq(costStatObj.Value, cost) then
        UpgradeRequestRemote:InvokeServer(upgradeId, true)  -- true = Max
    end
end

-- Config
Config.AutoUpgradeBoards = Config.AutoUpgradeBoards or {}

-- Tabel toggle
local BoardToggles = {}
DataBoardToggles = {}
-- Grup UI untuk semua toggle board
local currentGroup = nil
local countInGroup = 0

-- Buat toggle per upgrade
local AllBoardUpgrades = {}
for upgradeId, data in pairs(UpgradeConfig.Upgrades) do
    table.insert(AllBoardUpgrades, { id = upgradeId, data = data })
end
table.sort(AllBoardUpgrades, function(a, b)
    local numA = tonumber(string.match(a.id, "%d+")) or 0
    local numB = tonumber(string.match(b.id, "%d+")) or 0
    return numA < numB
end)
-- Urutkan key berdasarkan nomor upgrade
local sortedBaseKeys = {}
for k in pairs(BaseUpgrade) do
    table.insert(sortedBaseKeys, k)
end
table.sort(sortedBaseKeys, function(a, b)
    local numA = tonumber(string.match(a, "%d+")) or 0
    local numB = tonumber(string.match(b, "%d+")) or 0
    return numA < numB
end)

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
local function toTitleCase(str)
    -- %a = huruf pertama, %w'* = sisa huruf/angka/tanda petik dalam kata
    local hasil = str:gsub("(%a)([%w']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
    return hasil
end

local function Color3ToHex(color)
    return string.format("%02X%02X%02X",
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
countInGroup = 0
for _, entryName in ipairs(AllBoardUpgrades) do
    Data = Workspace.Upgrades:FindFirstChild(entryName.id,true)
    upgradeData = UpgradeConfig.Upgrades[entryName.id]
    ColorsTitle = nil
    for _, a in pairs(Data.UpgradeNameText:GetChildren()) do
        if a:IsA("UIGradient") then
            ColorsTitle = a
            break
        end
    end
    if countInGroup % 2 == 0 then
        currentGroup = MainTabs:Group({})
        FM_Add("Board Upgrades", currentGroup)
    end
    local toggle = currentGroup:Toggle({
        Title = string.format("%s %s",Data.UpgradeNameText.Text,Data.LevelText.Text),
        Image = Data.ImageLabel.Image,
        Flag = Data.Name .. "_" .. Data.UpgradeNameText.Text,
        Callback = function(val)
            Config.AutoUpgradeBoards[entryName.id] = val
            if val then
                StartManagedLoop(entryName.id, 0.2,
                    function()
                        if Config.AutoUpgradeBoards[entryName.id] then
                            local data = UpgradeConfig.Upgrades[entryName.id]
                            if data then tryBuyUpgrade(entryName.id, data) end
                        end
                    end
                )
            else
                StopManagedLoop(entryName.id)
            end
        end
    })
    BoardToggles[entryName.id] = toggle
    local boardData = {Name = GetRuneGradientTag(GetColorFromSequence(ColorsTitle.Color,0.5),Data.UpgradeNameText.Text), Image = Icon}
    DataBoardToggles[entryName.id] = boardData
    countInGroup = countInGroup + 1
end

StartStatusLoop("Status_AutoBoardUpgrades", 0.5, function()
    for upgradeId, toggle in pairs(BoardToggles) do
        if not toggle then continue end
        local upgradeData = UpgradeConfig.Upgrades[upgradeId]
        if not upgradeData then continue end

        -- local unlocked = isBoardUpgradeUnlocked(upgradeId, upgradeData)
        -- if not unlocked then
        --     toggle:Lock("🔒 Locked")
        --     -- tetap lanjutkan agar title/desc terupdate jika perlu
        -- else
        --     toggle:Unlock()
        -- end

        local upgradeValueObj = Upgrades and Upgrades:FindFirstChild(upgradeId)
        local currentLevel = upgradeValueObj and upgradeValueObj.Value or 0
        local maxLevel = getBoardMaxLevel(upgradeId)
        local costStatName = upgradeData.CostStat
        local displayName = DataBoardToggles[upgradeId] and DataBoardToggles[upgradeId].Name or upgradeId

        -- Title
        local titleText = string.format("%s (%d/%d)", displayName, currentLevel, maxLevel)
        if currentLevel >= maxLevel then
            titleText = string.format("%s [MAX]", titleText)
        end

        -- Cost
        local cost = UpgradeConfig.GetPriceAtLevel(upgradeId, currentLevel)
        local costText = cost and OmegaNum.short(cost) or "?"
        local costStatObj = StatsFolder:FindFirstChild(costStatName)
            or (EventStatsFolder and EventStatsFolder:FindFirstChild(costStatName))
            or (Shop and Shop:FindFirstChild(costStatName))
        local currentResourceText = "?"
        local canAfford = false
        if costStatObj and cost then
            currentResourceText = OmegaNum.short(costStatObj.Value) -- atau OmegaConverter jika ada
            canAfford = OmegaNum.meeq(costStatObj.Value, cost)
        end
        local color = canAfford and "#00ff00" or "#ff0000"

        -- Multiplier
        local isMax = currentLevel >= maxLevel
        local multiplierText = ""

        -- Fungsi bantu format multiplier sesuai tipe stat
        local function formatMultiplier(val)
            local targetStat = upgradeData.TargetStat
            local absoluteStats = { MaxSpawn = true, CollectionRange = true }
            if absoluteStats[targetStat] then
                local num = OmegaNum.toNumber(OmegaNum.toOmega(val))
                return string.format("+%g", num - 1)
            else
                return OmegaNum.short(val) .. "x"
            end
        end

        -- Desc
        local imageTag = DataBoardToggles[upgradeId] and DataBoardToggles[upgradeId].Image or ""
        local descText

        if isMax then
            local currentMult = UpgradeConfig.GetIncrementMultiplier(upgradeId, currentLevel)
            multiplierText = formatMultiplier(currentMult)
            descText = string.format('%s',multiplierText)
            toggle:Disable()
        else
            local currentMult = UpgradeConfig.GetIncrementMultiplier(upgradeId, currentLevel)
            local nextMult = UpgradeConfig.GetIncrementMultiplier(upgradeId, currentLevel + 1)
            multiplierText = string.format("%s → %s", formatMultiplier(currentMult), formatMultiplier(nextMult))
            descText = string.format('%s<font color="%s">%s: %s/%s</font>\n%s',imageTag,color,costStatName,currentResourceText,costText,multiplierText)
            toggle:Enable()
        end

        SafeSetTitle(toggle, titleText)
        SafeSetDesc(toggle, descText)
    end
end)

-- =====================================================
-- AUTO VOLTAGE (Convert)
-- =====================================================

-- Referensi
local VoltageMulti = Multis:WaitForChild("VoltageMulti")
local Flux = StatsFolder:WaitForChild("Flux")
local Points = StatsFolder:WaitForChild("Points") -- pastikan tidak bentrok jika sudah ada

-- Config
-- Fungsi Kalkulasi
local function calculateVoltageGain()
    local pointsVal = Points.Value
    local fluxVal = Flux.Value
    local voltMulti = VoltageMulti.Value

    if typeof(pointsVal) ~= "table" then pointsVal = OmegaNum.fromString(tostring(pointsVal)) end
    if typeof(fluxVal) ~= "table" then fluxVal = OmegaNum.fromString(tostring(fluxVal)) end
    if typeof(voltMulti) ~= "table" then voltMulti = OmegaNum.fromString(tostring(voltMulti)) end

    local MIN_POINTS = OmegaNum.fromString("5e12")
    local MIN_FLUX = OmegaNum.fromString("100000")

    local canConvert = OmegaNum.meeq(pointsVal, MIN_POINTS) and OmegaNum.meeq(fluxVal, MIN_FLUX)

    local gainText, requirementText
    if canConvert then
        local pointParts = OmegaNum.max(OmegaNum.fromNumber(1), OmegaNum.floor(OmegaNum.div(pointsVal, MIN_POINTS)))
        local fluxParts = OmegaNum.max(OmegaNum.fromNumber(1), OmegaNum.floor(OmegaNum.div(fluxVal, MIN_FLUX)))
        local logPoint = math.log10(OmegaNum.toNumber(pointParts))
        local logFlux = math.log10(OmegaNum.toNumber(fluxParts))
        local baseGain = math.max(1, math.floor((logPoint + logFlux) * 15 + 1))
        local totalVoltage = OmegaNum.mul(OmegaNum.fromNumber(baseGain), voltMulti)
        gainText = string.format("GAIN: %s VOLTAGE", OmegaNum.short(totalVoltage))
    else
        gainText = nil
    end
    requirementText = string.format("Need: 5e12 Points & 100k Flux")

    return {
        canConvert = canConvert,
        gainText = gainText,
        requirementText = requirementText,
        pointsShort = OmegaNum.short(pointsVal),
        fluxShort = OmegaNum.short(fluxVal)
    }
end

-- Toggle
local voltageToggle = MainTabs:Toggle({
    Title = "Convert Voltage",
    Image = LocalPlayer.PlayerGui:WaitForChild("HUD", 10):WaitForChild("StatsDisplay"):WaitForChild("Content"):FindFirstChild("Voltage").ImageLabel.Image,
    Flag = "AutoVoltage_Enabled",
    Callback = function(val)
        Config.AutoVoltage.Enabled = val
        if val then
            StartManagedLoop("AutoVoltage",1, function()
                return Config.AutoVoltage.Enabled
            end, function()
                local ascLevel = tonumber(Ascension.Value) or 0
                if ascLevel < 15 then return end
                local info = calculateVoltageGain()
                if info.canConvert then
                    ConvertEvent:FireServer()
                end
            end)
        else
            StopManagedLoop("AutoVoltage")
        end
    end
})
FM_Add("Convert",voltageToggle)

StartStatusLoop("Status_AutoVoltage", 0.5, function()
    local ascLevel = tonumber(Ascension.Value) or 0
    if ascLevel < 15 then
        voltageToggle:Lock("🔒 Unlocks at Ascension 15")
    else
        voltageToggle:Unlock()
    end

    local info = calculateVoltageGain()

    -- Title: tambah "(Ready)" jika siap
    local title = "Convert Voltage"
    if info.canConvert then
        title = title .. " (Ready)"
    end
    SafeSetTitle(voltageToggle, title)

    -- Deskripsi bergaya client
    local descLines = {}
    if info.canConvert then
        -- Jika cukup: tampilkan GAIN dengan warna hijau
        table.insert(descLines, string.format('<font color="#00ff00">%s</font>', info.gainText))
    else
        -- Jika belum: tampilkan requirement dengan warna merah
        table.insert(descLines, string.format('<font color="#ff0000">%s</font>', info.requirementText))
    end

    -- Tambahkan informasi resource saat ini sebagai progres (opsional, menambah estetik)
    table.insert(descLines, string.format('<font color="#aaaaaa">Points: %s / 5T</font>', info.pointsShort))
    table.insert(descLines, string.format('<font color="#aaaaaa">Flux: %s / 100k</font>', info.fluxShort))

    local desc = table.concat(descLines, "\n")
    SafeSetDesc(voltageToggle, desc)
end)

local RuneStats = LocalPlayer:WaitForChild("RuneStats", 60)
local RunesOpened = LocalPlayer:WaitForChild("Runes"):WaitForChild("RunesOpened")

-- Syarat unlock rune (sebelumnya sudah ada, dipertahankan)
local RuneUnlockRequirements = {
    ["BasicRune"] = { Type = "Ascension", Value = 11 },
    ["EssentialRune"] = { Type = "UpgradeTree", Node = "Upgrade9", Value = 1 },
    ["DesertRune"] = { Type = "Upgrades", Node = "Upgrade29", Value = 1 },
    ["MagmaRune"] = { Type = "Upgrades", Node = "Upgrade34", Value = 1 },
}

local function isRuneUnlocked(runeName)
    local req = RuneUnlockRequirements[runeName]
    if not req then return true end
    if req.Type == "Ascension" then
        return (tonumber(Ascension.Value) or 0) >= req.Value
    elseif req.Type == "UpgradeTree" then
        local folder = UpgradeTree or LocalPlayer:WaitForChild("UpgradeTree", 15)
        if folder then
            local node = folder:FindFirstChild(req.Node)
            return node and (tonumber(node.Value) or 0) >= req.Value
        end
        return false
    elseif req.Type == "Upgrades" then
        local folder = Upgrades or LocalPlayer:WaitForChild("Upgrades", 15)
        if folder then
            local node = folder:FindFirstChild(req.Node)
            return node and (tonumber(node.Value) or 0) >= req.Value
        end
        return false
    end
    return true
end

local function getUnlockText(runeName)
    local req = RuneUnlockRequirements[runeName]
    if not req then return "" end
    if req.Type == "Ascension" then
        return "Ascension " .. req.Value
    elseif req.Type == "UpgradeTree" then
        return req.Node .. " Lv.1"
    elseif req.Type == "Upgrades" then
        return req.Node .. " Lv.1"
    end
    return ""
end

-- =====================================================
-- AUTO RUNE (Roll)
-- =====================================================

local RuneToggles = {}
local runeGroup = nil
local runeCountInGroup = 0

local function createRuneToggle(runeName)
    if RuneToggles[runeName] then return end
    if runeCountInGroup % 2 == 0 then
        runeGroup = MainTabs:Group({})
        FM_Add("Rune", runeGroup)
    end

    local toggle = runeGroup:Toggle({
        Title = runeName,
        Image = GetIcon(135230701981041), -- ikon bisa diganti sesuai rune
        Flag = "AutoRune_" .. runeName,
        Value = false,
        Callback = function(val)
            if val then
                StartManagedLoop("AutoRune_" .. runeName, 0.01, function()
                    return true
                end, function()
                    if isRuneUnlocked(runeName) then
                        pcall(function()
                            RollRuneEvent:FireServer(runeName)
                        end)
                    end
                end)
            else
                StopManagedLoop("AutoRune_" .. runeName)
            end
        end
    })
    RuneToggles[runeName] = toggle
    runeCountInGroup = runeCountInGroup + 1
end

-- Proses board yang ada
local RunesFolder = workspace:WaitForChild("Runes", 60)
if RunesFolder then
    for _, board in ipairs(RunesFolder:GetChildren()) do
        createRuneToggle(board.Name)
    end
    RunesFolder.ChildAdded:Connect(function(board)
        task.wait(0.1)
        createRuneToggle(board.Name)
    end)
end

-- Fungsi untuk memperbarui deskripsi satu toggle (DIPANGGIL OLEH LISTENER)
local function updateRuneToggleDesc(runeName)
    local toggle = RuneToggles[runeName]
    if not toggle then return end

    local unlocked = isRuneUnlocked(runeName)
    if not unlocked then
        toggle:Lock("🔒 Locked")
        SafeSetTitle(toggle, runeName)
        SafeSetDesc(toggle, "Requires " .. getUnlockText(runeName))
        return
    end

    toggle:Unlock()
    local runeData = RuneData[runeName]
    local descLines = {}
    local title = runeName

    if runeData and runeData.Stages and RunesOpened then
        local openedObj = RunesOpened:FindFirstChild(runeName)
        local opened = 0
        if openedObj then
            -- Gunakan OmegaNum untuk konsistensi (seperti client)
            local ok, val = pcall(OmegaNum.toOmega, openedObj.Value)
            if ok then
                opened = OmegaNum.toNumber(val)
            else
                opened = tonumber(openedObj.Value) or 0
            end
        end

        local stages = runeData.Stages
        local currentStageName = "STAGE I"
        local nextReq = nil
        local luckBoost, bulkBoost, speedBoost, cloneBoost = 1, 1, 1, 0

        -- Loop stages (sama dengan client)
        for _, stage in ipairs(stages) do
            if stage.Req > opened then
                nextReq = stage.Req
                break
            end
            currentStageName = stage.Name
            local isEvent = (runeName == "EventRune")
            local luckKey = isEvent and "EventRuneLuck" or "RuneLuck"
            local bulkKey = isEvent and "EventRuneBulk" or "RuneBulk"
            local speedKey = isEvent and "EventRuneSpeed" or "RuneSpeed"
            if stage.Boosts[luckKey] then luckBoost = stage.Boosts[luckKey] end
            if stage.Boosts[bulkKey] then bulkBoost = stage.Boosts[bulkKey] end
            if stage.Boosts[speedKey] then speedBoost = stage.Boosts[speedKey] end
            if not isEvent and stage.Boosts["RuneClone"] then cloneBoost = stage.Boosts["RuneClone"] end
        end

        -- Tampilkan stage
        table.insert(descLines, "Stage: " .. currentStageName)
        if nextReq then
            table.insert(descLines, string.format("Progress: %s / %s",
                OmegaNum.short(OmegaNum.fromNumber(opened)),
                OmegaNum.short(OmegaNum.fromNumber(nextReq))))
        else
            table.insert(descLines, "Progress: " .. OmegaNum.short(OmegaNum.fromNumber(opened)) .. " (MAXED)")
        end

        -- Boosts
        local boosts = {}
        if luckBoost > 1 then table.insert(boosts, "Luck: " .. luckBoost .. "x") end
        if bulkBoost > 1 then table.insert(boosts, "Bulk: " .. bulkBoost .. "x") end
        if speedBoost > 1 then table.insert(boosts, "Speed: " .. speedBoost .. "x") end
        if cloneBoost > 0 then table.insert(boosts, "Clone: +" .. cloneBoost) end
        if #boosts > 0 then
            table.insert(descLines, "Boosts:\n" .. table.concat(boosts, "\t"))
        else
            table.insert(descLines, "Boosts: None")
        end

        -- RPS (real-time dari RuneStats)
        if RuneStats then
            local isEvent = runeName == "EventRune"
            local baseSpeedObj = isEvent and RuneStats:FindFirstChild("EventRuneSpeed") or RuneStats:FindFirstChild("RuneSpeed")
            local baseBulkObj = isEvent and RuneStats:FindFirstChild("EventRuneBulk") or RuneStats:FindFirstChild("RuneBulk")
            local baseCloneObj = isEvent and nil or RuneStats:FindFirstChild("RuneClone")
            local baseSpeed = baseSpeedObj and tonumber(baseSpeedObj.Value) or 1
            local baseBulk = baseBulkObj and tonumber(baseBulkObj.Value) or 1
            local baseClone = baseCloneObj and tonumber(baseCloneObj.Value) or 0
            local effectiveSpeed = baseSpeed * speedBoost
            local effectiveBulk = baseBulk * bulkBoost
            local totalClone = baseClone + cloneBoost
            local rps = math.floor(effectiveBulk * (1 + totalClone) * effectiveSpeed)
            table.insert(descLines, string.format("RPS: %s", OmegaNum.short(OmegaNum.fromNumber(rps))))
        end
    else
        descLines = { "Data not available" }
    end

    SafeSetTitle(toggle, title)
    SafeSetDesc(toggle, table.concat(descLines, "\n"))
end

-- ======================= LISTENER AGAR DINAMIS =======================
-- Setiap kali RunesOpened berubah, langsung perbarui toggle terkait
if RunesOpened then
    for _, obj in ipairs(RunesOpened:GetChildren()) do
        if obj:IsA("IntValue") and RuneToggles[obj.Name] then
            obj.Changed:Connect(function()
                updateRuneToggleDesc(obj.Name)
            end)
        end
    end
    RunesOpened.ChildAdded:Connect(function(obj)
        if obj:IsA("IntValue") and RuneToggles[obj.Name] then
            obj.Changed:Connect(function()
                updateRuneToggleDesc(obj.Name)
            end)
            updateRuneToggleDesc(obj.Name)
        end
    end)
end

-- Setiap kali RuneStats berubah, perbarui semua toggle (karena RPS berubah)
if RuneStats then
    local statNames = {"RuneSpeed", "RuneBulk", "RuneLuck", "RuneClone",
                       "EventRuneSpeed", "EventRuneBulk", "EventRuneLuck"}
    for _, statName in ipairs(statNames) do
        local statObj = RuneStats:FindFirstChild(statName)
        if statObj then
            statObj.Changed:Connect(function()
                for runeName in pairs(RuneToggles) do
                    updateRuneToggleDesc(runeName)
                end
            end)
        end
    end
end

-- Fallback loop periodik (jaga-jaga)
StartStatusLoop("Status_AutoRune", 1.0, function()
    for runeName in pairs(RuneToggles) do
        updateRuneToggleDesc(runeName)
    end
end)

-- =====================================================
-- AUTO CLICK (Farm)
-- =====================================================
local autoClickToggle = MainTabs:Toggle({
    Title = "Auto Click",
    Image = LocalPlayer.PlayerGui:WaitForChild("HUD", 10):WaitForChild("StatsDisplay"):WaitForChild("Content"):FindFirstChild("Click").ImageLabel.Image,
    Flag = "AutoClick_Enabled",
    Callback = function(val)
        Config.AutoClick.Enabled = val
        if val then
            StartManagedLoop("AutoClick", Config.AutoClick.Interval, function()
                return Config.AutoClick.Enabled
            end, function()
                pcall(function()
                    HudClickRemote:FireServer()
                end)
            end)
        else
            StopManagedLoop("AutoClick")
        end
    end
})
FM_Add("Events", autoClickToggle)

-- Status update
StartStatusLoop("Status_AutoClick", 0.5, function()
    local active = Config.AutoClick.Enabled
    local title = "Auto Click"
    SafeSetTitle(autoClickToggle, title)
    local desc = active and string.format("Clicking every %.3fs", Config.AutoClick.Interval) or "Idle"
    SafeSetDesc(autoClickToggle, desc)
end)

-- =====================================================
-- AUTO TIER (Event)
-- =====================================================
local EventTier = Resets:WaitForChild("EventTier", 15)                 -- nilai tier saat ini

local autoTierToggle = MainTabs:Toggle({
    Title = "📈 Auto Tier Up",
    Flag = "AutoTier_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoTier.Enabled = val
        if val then
            StartManagedLoop("AutoTier", Config.AutoTier.Interval, function()
                return Config.AutoTier.Enabled
            end, function()
                if not EventTier or not EventTierData then return end
                local currentTier = tonumber(EventTier.Value) or 0
                local nextTierData = EventTierData.Tiers[currentTier + 1]
                if not nextTierData then return end -- sudah tier maksimal

                -- Biaya
                local cost = nextTierData.Cost
                if typeof(cost) ~= "table" then
                    cost = OmegaNum.fromString(tostring(cost))
                end

                -- Resource yang dibutuhkan (Click atau Balloon)
                local costStat = nextTierData.CostStat
                local statObj = EventStatsFolder and EventStatsFolder:FindFirstChild(costStat)
                if not statObj then return end

                local currentResource = statObj.Value
                if typeof(currentResource) ~= "table" then
                    currentResource = OmegaNum.fromString(tostring(currentResource))
                end

                -- Jika cukup, beli
                if OmegaNum.meeq(currentResource, cost) then
                    pcall(function()
                        TierRequest:InvokeServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoTier")
        end
    end
})

FM_Add("Events", autoTierToggle)
-- Status Update
StartStatusLoop("Status_AutoTier", 1, function()
    if not autoTierToggle then return end
    if not EventTier or not EventTierData then
        SafeSetTitle(autoTierToggle, "📈 Auto Tier Up")
        SafeSetDesc(autoTierToggle, "Data not ready")
        return
    end

    local currentTier = tonumber(EventTier.Value) or 0
    local nextTierData = EventTierData.Tiers[currentTier + 1]

    if not nextTierData then
        SafeSetTitle(autoTierToggle, "📈 Auto Tier Up (MAX)")
        SafeSetDesc(autoTierToggle, "All tiers purchased")
        return
    end

    local cost = nextTierData.Cost
    if typeof(cost) ~= "table" then cost = OmegaNum.fromString(tostring(cost)) end
    local costStat = nextTierData.CostStat
    local statObj = EventStatsFolder and EventStatsFolder:FindFirstChild(costStat)
    local resourceText = "?"
    local canAfford = false
    if statObj then
        local val = statObj.Value
        if typeof(val) ~= "table" then val = OmegaNum.fromString(tostring(val)) end
        resourceText = OmegaNum.short(val)
        canAfford = OmegaNum.meeq(val, cost)
    end

    local color = canAfford and "#00ff00" or "#ff0000"
    local title = "📈 Auto Tier Up"
    if canAfford then title = title .. " (Ready)" end

    SafeSetTitle(autoTierToggle, title)
    local desc = string.format(
        '<font color="%s">Tier %d → %d</font>\nCost: %s %s (Have: %s)',
        color, currentTier, currentTier + 1,
        OmegaNum.short(cost), costStat, resourceText
    )
    SafeSetDesc(autoTierToggle, desc)
end)

-- =====================================================
-- AUTO SKILLS (Skill Tree)
-- =====================================================
local autoSkillToggle = MainTabs:Toggle({
    Title = "Auto Purchase Skills",
    Flag = "AutoSkills_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoSkills.Enabled = val
        if val then
            StartManagedLoop("AutoSkills", Config.AutoSkills.Interval, function()
                return Config.AutoSkills.Enabled
            end, function()
                local skillFolder = LocalPlayer:FindFirstChild("SkillTree")
                if not skillFolder or not SkillTreeData then return end

                -- Level skill saat ini
                local levels = {}
                for _, obj in ipairs(skillFolder:GetChildren()) do
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        levels[obj.Name] = tonumber(obj.Value) or 0
                    end
                end

                -- Resource Click
                local clickObj = EventStatsFolder and EventStatsFolder:FindFirstChild("Click")
                local clickVal = nil
                if clickObj then
                    local raw = clickObj.Value
                    clickVal = typeof(raw) == "table" and raw or OmegaNum.fromString(tostring(raw))
                end

                for _, node in ipairs(SkillTreeData.Nodes) do
                    local id = node.id
                    local lvl = levels[id] or 0
                    local max = node.maxLevel or 10
                    local prereqMet = not node.prerequisite or (levels[node.prerequisite] or 0) >= 1
                    if prereqMet and lvl < max then
                        local cost = SkillTreeData.GetPriceAtLevel(node, lvl)
                        if clickVal and OmegaNum.meeq(clickVal, cost) then
                            pcall(function()
                                PurchaseSkill:FireServer(id)
                            end)
                        end
                    end
                end
            end)
        else
            StopManagedLoop("AutoSkills")
        end
    end
})
FM_Add("Events", autoSkillToggle)

StartStatusLoop("Status_AutoSkills", 1, function()
    if not autoSkillToggle or not SkillTreeData then
        SafeSetTitle(autoSkillToggle, "🧠 Auto Purchase Skills")
        SafeSetDesc(autoSkillToggle, "Loading...")
        return
    end

    local skillFolder = LocalPlayer:FindFirstChild("SkillTree")
    local levels = {}
    if skillFolder then
        for _, obj in ipairs(skillFolder:GetChildren()) do
            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                levels[obj.Name] = tonumber(obj.Value) or 0
            end
        end
    end

    local clickObj = EventStatsFolder and EventStatsFolder:FindFirstChild("Click")
    local clickVal = nil
    if clickObj then
        local raw = clickObj.Value
        clickVal = typeof(raw) == "table" and raw or OmegaNum.fromString(tostring(raw))
    end

    local boughtCount = 0
    local affordableSkills = {}  -- simpan displayName

    for _, node in ipairs(SkillTreeData.Nodes) do
        local lvl = levels[node.id] or 0
        local max = node.maxLevel or 10
        local prereqMet = not node.prerequisite or (levels[node.prerequisite] or 0) >= 1

        if lvl > 0 then
            boughtCount = boughtCount + 1
        end

        if prereqMet and lvl < max then
            local cost = SkillTreeData.GetPriceAtLevel(node, lvl)
            if clickVal and OmegaNum.meeq(clickVal, cost) then
                table.insert(affordableSkills, node.displayName)
            end
        end
    end

    local title = "🧠 Auto Purchase Skills"
    if Config.AutoSkills.Enabled then
        title = title .. " (ON)"
    end
    SafeSetTitle(autoSkillToggle, title)

    local desc = string.format("Bought: %d | Affordable: %d", boughtCount, #affordableSkills)
    if #affordableSkills > 0 then
        -- Batasi daftar yang ditampilkan maksimal 5 skill
        local maxShow = 5
        local skillList = {}
        for i = 1, math.min(#affordableSkills, maxShow) do
            table.insert(skillList, affordableSkills[i])
        end
        local listText = table.concat(skillList, ", ")
        if #affordableSkills > maxShow then
            listText = listText .. string.format(" +%d more", #affordableSkills - maxShow)
        end
        desc = desc .. "\n" .. listText
    else
        desc = desc .. "\nNo affordable skills"
    end

    SafeSetDesc(autoSkillToggle, desc)
end)
-- =====================================================
-- AUTO UPGRADE SWORD (Mobs)
-- =====================================================
local MobStats = LocalPlayer:WaitForChild("MobStats", 60)
local SwordValue = MobStats and MobStats:WaitForChild("Sword", 15) -- IntValue level pedang
local SwordSection = MainTabs:Section({
    Title = "Auto Sword Upgrade",
    Opened = true,
    TextXAlignment = "Center"
})
FM_Add("Mobs", SwordSection)

local swordGroup = SwordSection:Group({})
FM_Add("Mobs", swordGroup)

local autoSwordToggle = swordGroup:Toggle({
    Title = "⚔️ Auto Upgrade Sword",
    Flag = "AutoSword_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoSword.Enabled = val
        if val then
            StartManagedLoop("AutoSword", Config.AutoSword.Interval, function()
                return Config.AutoSword.Enabled
            end, function()
                if not SwordValue or not SwordConfig then return end
                local ascensionOk = false
                if AscensionStats then
                    local asc = AscensionStats:FindFirstChild("Ascension")
                    if asc and (tonumber(asc.Value) or 0) >= 25 then
                        ascensionOk = true
                    end
                end
                if not ascensionOk then return end

                local currentSwordIdx = tonumber(SwordValue.Value) or 0
                -- Jika 0 berarti belum punya pedang, target selanjutnya = 1
                local nextIdx = currentSwordIdx + 1
                if nextIdx > #SwordConfig.Swords then return end -- sudah maksimal

                local nextSword = SwordConfig.Swords[nextIdx]
                -- Cek RequiredUpgrade
                if nextSword.RequiredUpgrade then
                    local upgradeTree = LocalPlayer:FindFirstChild("UpgradeTree")
                    if upgradeTree then
                        local reqNode = upgradeTree:FindFirstChild(nextSword.RequiredUpgrade)
                        if not reqNode or (tonumber(reqNode.Value) or 0) < 1 then
                            return -- syarat belum terpenuhi
                        end
                    end
                end

                -- Cek biaya Shards
                local shardsObj = StatsFolder:FindFirstChild("Shards")
                if not shardsObj then return end
                local shardsVal = shardsObj.Value
                local cost = nextSword.Cost
                if typeof(shardsVal) ~= "table" then shardsVal = OmegaNum.fromString(tostring(shardsVal)) end
                if typeof(cost) ~= "table" then cost = OmegaNum.fromString(tostring(cost)) end
                if OmegaNum.meeq(shardsVal, cost) then
                    pcall(function()
                        UpgradeSwordRequest:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoSword")
        end
    end
})

StartStatusLoop("Status_AutoSword", 1, function()
    if not autoSwordToggle or not SwordConfig or not SwordValue then
        SafeSetTitle(autoSwordToggle, "⚔️ Auto Upgrade Sword")
        SafeSetDesc(autoSwordToggle, "Loading...")
        return
    end

    local ascensionOk = false
    if AscensionStats then
        local asc = AscensionStats:FindFirstChild("Ascension")
        if asc and (tonumber(asc.Value) or 0) >= 25 then
            ascensionOk = true
        end
    end

    if not ascensionOk then
        autoSwordToggle:Lock("🔒 Requires Ascension 25+")
        SafeSetTitle(autoSwordToggle, "⚔️ Auto Upgrade Sword")
        SafeSetDesc(autoSwordToggle, "Ascension 25 required")
        return
    else
        autoSwordToggle:Unlock()
    end

    local currentIdx = tonumber(SwordValue.Value) or 0
    local nextIdx = currentIdx + 1
    local currentSword = currentIdx > 0 and SwordConfig.Swords[currentIdx] or nil
    local nextSword = nextIdx <= #SwordConfig.Swords and SwordConfig.Swords[nextIdx] or nil

    local title = "⚔️ Auto Upgrade Sword"
    if Config.AutoSword.Enabled then
        title = title .. " (ON)"
    end
    SafeSetTitle(autoSwordToggle, title)

    local descLines = {}

    -- Current sword info
    if currentSword then
        table.insert(descLines, string.format("Current: %s", currentSword.Name))
        table.insert(descLines, string.format("DAMAGE %.1fx | SPEED %.1fx | SHARDS %.1fx",
            currentSword.Boosts.Damage, currentSword.Boosts.Speed, currentSword.Boosts.Shards))
    else
        table.insert(descLines, "Current: None")
    end

    -- Next sword info
    if nextSword then
        table.insert(descLines, string.format("Next: %s", nextSword.Name))
        table.insert(descLines, string.format("DAMAGE %.1fx | SPEED %.1fx | SHARDS %.1fx",
            nextSword.Boosts.Damage, nextSword.Boosts.Speed, nextSword.Boosts.Shards))

        -- Required upgrade check dengan DisplayName dari UpgradeTreeConfig
        if nextSword.RequiredUpgrade then
            local upgradeTree = LocalPlayer:FindFirstChild("UpgradeTree")
            local reqMet = false
            local reqLevel = 0
            if upgradeTree then
                local reqNode = upgradeTree:FindFirstChild(nextSword.RequiredUpgrade)
                if reqNode then
                    reqLevel = tonumber(reqNode.Value) or 0
                    if reqLevel >= 1 then
                        reqMet = true
                    end
                end
            end
            -- Nama jelas upgrade
            local displayName = nextSword.RequiredUpgrade
            if UpgradeTreeConfig and UpgradeTreeConfig.Upgrades and UpgradeTreeConfig.Upgrades[nextSword.RequiredUpgrade] then
                displayName = UpgradeTreeConfig.Upgrades[nextSword.RequiredUpgrade].DisplayName or displayName
            end
            local reqText
            if reqMet then
                reqText = string.format("%s ✅", displayName)
            else
                reqText = string.format("%s (Lv. %d/1) ❌", displayName, reqLevel)
            end
            table.insert(descLines, "Requires: " .. reqText)
        end

        -- Cost
        local shardsObj = StatsFolder:FindFirstChild("Shards")
        if shardsObj then
            local raw = shardsObj.Value
            local shards = typeof(raw) == "table" and raw or OmegaNum.fromString(tostring(raw))
            local cost = OmegaNum.fromString(tostring(nextSword.Cost))
            local canAfford = OmegaNum.meeq(shards, cost)
            local color = canAfford and "#00ff00" or "#ff0000"
            table.insert(descLines, string.format('<font color="%s">Shards: %s / %s</font>',
                color, OmegaNum.short(shards), OmegaNum.short(cost)))
        end
    else
        table.insert(descLines, "Next: MAXED")
    end

    SafeSetDesc(autoSwordToggle, table.concat(descLines, "\n"))
end)

-- =====================================================
-- AUTO BALLOON (Farm)
-- =====================================================
local autoBalloonToggle = MainTabs:Toggle({
    Title = "🎈 Auto Balloon",
    Flag = "AutoBalloon_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoBalloon.Enabled = val
        if val then
            StartManagedLoop("AutoBalloon", Config.AutoBalloon.Interval, function()
                return Config.AutoBalloon.Enabled
            end, function()
                if not EventStatsFolder then return end
                local clickObj = EventStatsFolder:FindFirstChild("Click")
                if not clickObj then return end
                local clickVal = clickObj.Value
                if typeof(clickVal) ~= "table" then
                    clickVal = OmegaNum.fromString(tostring(clickVal))
                end
                local threshold = OmegaNum.fromString("1e27")
                if OmegaNum.meeq(clickVal, threshold) then
                    pcall(function()
                        BalloonRequest:InvokeServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoBalloon")
        end
    end
})

FM_Add("Events", autoBalloonToggle)
-- Status Update
StartStatusLoop("Status_AutoBalloon", 1, function()
    if not autoBalloonToggle or not EventStatsFolder then
        SafeSetTitle(autoBalloonToggle, "🎈 Auto Balloon")
        SafeSetDesc(autoBalloonToggle, "Loading...")
        return
    end

    local clickObj = EventStatsFolder:FindFirstChild("Click")
    local clickVal = nil
    if clickObj then
        local raw = clickObj.Value
        clickVal = typeof(raw) == "table" and raw or OmegaNum.fromString(tostring(raw))
    end

    local threshold = OmegaNum.fromString("1e27")
    local canConvert = clickVal and OmegaNum.meeq(clickVal, threshold)
    local clickDisplay = clickVal and OmegaNum.short(clickVal) or "0"

    -- Ambil BalloonMulti (final, sudah termasuk Tier dll.)
    local balloonMulti = 1
    local multis = LocalPlayer:FindFirstChild("Multis")
    if multis then
        local bm = multis:FindFirstChild("BalloonMulti")
        if bm then
            balloonMulti = tonumber(bm.Value) or 1
        end
    end

    -- Hitung gain persis seperti calcBalloonGain
    local gainText = "0"
    if canConvert and clickVal then
        local log10Val = OmegaNum.toNumber(OmegaNum.log10(clickVal))
        local exponent = log10Val - 27
        local intermediate = math.pow(8, exponent) * balloonMulti
        intermediate = math.max(1, intermediate)  -- minimal 1
        local gain = intermediate * 100
        gain = math.floor(gain)  -- bulatkan ke bawah 2 desimal
        gainText = OmegaNum.short(OmegaNum.fromNumber(gain))
    end

    local title = "🎈 Auto Balloon"
    if Config.AutoBalloon.Enabled then
        title = title .. " (ON)"
    end
    SafeSetTitle(autoBalloonToggle, title)

    local color = canConvert and "#00ff00" or "#ff0000"
    local desc = string.format(
        '<font color="%s">Click: %s / 1e27</font>\nGain: %s Balloons\nMultiplier: %.2fx',
        color, clickDisplay, gainText, balloonMulti
    )
    SafeSetDesc(autoBalloonToggle, desc)
end)

-- =====================================================
-- AUTO UPGRADE TREE
-- =====================================================
local autoUpgradeTreeToggle = MainTabs:Toggle({
    Title = "🌳 Auto Upgrade Tree",
    Flag = "AutoUpgradeTree_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoUpgradeTree.Enabled = val
        if val then
            StartManagedLoop("AutoUpgradeTree", Config.AutoUpgradeTree.Interval, function()
                return Config.AutoUpgradeTree.Enabled
            end, function()
                if not UpgradeTreeConfig or not LocalPlayer.UpgradeTree then return end
                local treeFolder = LocalPlayer:WaitForChild("UpgradeTree", 15)
                if not treeFolder then return end

                for upgradeId, upgradeData in pairs(UpgradeTreeConfig.Upgrades) do
                    -- Cek apakah upgrade ini unlocked
                    if not UpgradeTreeConfig.IsUnlocked(upgradeId, treeFolder, LocalPlayer) then
                        continue
                    end

                    local levelValue = treeFolder:FindFirstChild(upgradeId)
                    local currentLevel = levelValue and tonumber(levelValue.Value) or 0
                    local maxLevel = upgradeData.MaxLevel or 10
                    if currentLevel >= maxLevel then continue end

                    -- Biaya
                    local cost = UpgradeTreeConfig.GetPriceAtLevel(upgradeId, currentLevel)
                    if not cost then continue end

                    -- Resource yang dibutuhkan
                    local costStatName = upgradeData.CostStat or "Particles"
                    local resourceObj = StatsFolder:FindFirstChild(costStatName)
                        or (EventStatsFolder and EventStatsFolder:FindFirstChild(costStatName))
                        or (Shop and Shop:FindFirstChild(costStatName))
                    if not resourceObj then continue end

                    local resourceVal = resourceObj.Value
                    if typeof(resourceVal) ~= "table" then
                        resourceVal = OmegaNum.fromString(tostring(resourceVal))
                    end
                    if typeof(cost) ~= "table" then
                        cost = OmegaNum.fromString(tostring(cost))
                    end

                    if OmegaNum.meeq(resourceVal, cost) then
                        pcall(function()
                            UpgradeTreeRequest:InvokeServer(upgradeId, false) -- false = beli 1x
                        end)
                    end
                end
            end)
        else
            StopManagedLoop("AutoUpgradeTree")
        end
    end
})
FM_Add("Mobs", autoUpgradeTreeToggle)
-- Status Update
StartStatusLoop("Status_AutoUpgradeTree", 1, function()
    if not autoUpgradeTreeToggle or not UpgradeTreeConfig then
        SafeSetTitle(autoUpgradeTreeToggle, "🌳 Auto Upgrade Tree")
        SafeSetDesc(autoUpgradeTreeToggle, "Loading...")
        return
    end

    local treeFolder = LocalPlayer:WaitForChild("UpgradeTree", 15)
    if not treeFolder then
        SafeSetDesc(autoUpgradeTreeToggle, "UpgradeTree data not ready")
        return
    end

    local affordableCount = 0
    local unlockedCount = 0
    for upgradeId, upgradeData in pairs(UpgradeTreeConfig.Upgrades) do
        if not UpgradeTreeConfig.IsUnlocked(upgradeId, treeFolder, LocalPlayer) then
            continue
        end

        unlockedCount = unlockedCount + 1
        local levelValue = treeFolder:FindFirstChild(upgradeId)
        local currentLevel = levelValue and tonumber(levelValue.Value) or 0
        local maxLevel = upgradeData.MaxLevel or 10
        if currentLevel >= maxLevel then
            continue
        end

        local cost = UpgradeTreeConfig.GetPriceAtLevel(upgradeId, currentLevel)
        if not cost then continue end

        local costStatName = upgradeData.CostStat or "Particles"
        local resourceObj = StatsFolder:FindFirstChild(costStatName)
            or (EventStatsFolder and EventStatsFolder:FindFirstChild(costStatName))
            or (Shop and Shop:FindFirstChild(costStatName))
        if not resourceObj then continue end

        local resourceVal = resourceObj.Value
        if typeof(resourceVal) ~= "table" then resourceVal = OmegaNum.fromString(tostring(resourceVal)) end
        if typeof(cost) ~= "table" then cost = OmegaNum.fromString(tostring(cost)) end

        if OmegaNum.meeq(resourceVal, cost) then
            affordableCount = affordableCount + 1
        end
    end

    local title = "🌳 Auto Upgrade Tree"
    if Config.AutoUpgradeTree.Enabled then
        title = title .. " (ON)"
    end
    SafeSetTitle(autoUpgradeTreeToggle, title)

    local desc = string.format("Unlocked: %d | Affordable: %d", unlockedCount, affordableCount)
    if affordableCount > 0 then
        desc = desc .. "\nBuying cheapest available..."
    end
    SafeSetDesc(autoUpgradeTreeToggle, desc)
end)

-- =====================================================
-- AUTO SACRIFICE
-- =====================================================
local SPMulti = LocalPlayer:WaitForChild("Multis"):WaitForChild("SPMulti")
local autoSacrificeToggle = MainTabs:Toggle({
    Title = "🔥 Auto Sacrifice",
    Flag = "AutoSacrifice_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoSacrifice.Enabled = val
        if val then
            StartManagedLoop("AutoSacrifice", Config.AutoSacrifice.Interval, function()
                return Config.AutoSacrifice.Enabled
            end, function()
                local ascLevel = tonumber(Ascension.Value) or 0
                if ascLevel >= 100 then
                    pcall(function()
                        SacrificeRequest:InvokeServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoSacrifice")
        end
    end
})

FM_Add("Convert", autoSacrificeToggle)
-- Status Update
StartStatusLoop("Status_AutoSacrifice", 1, function()
    if not autoSacrificeToggle or not Ascension or not SPMulti then
        SafeSetTitle(autoSacrificeToggle, "🔥 Auto Sacrifice")
        SafeSetDesc(autoSacrificeToggle, "Loading...")
        return
    end

    local ascLevel = tonumber(Ascension.Value) or 0
    local canSacrifice = ascLevel >= 100
    local gainSP = 0

    if canSacrifice then
        local base = math.floor((ascLevel - 100) / 10) + 1
        local multi = 1
        local ok, rawMulti = pcall(function() return SPMulti.Value end)
        if ok and rawMulti ~= nil then
            local ok2, num = pcall(OmegaNum.toNumber, OmegaNum.toOmega(rawMulti))
            if ok2 then multi = math.max(1, num) end
        end
        gainSP = math.floor(base * multi)
        gainSP = math.max(1, gainSP)
    end

    local title = "🔥 Auto Sacrifice"
    if Config.AutoSacrifice.Enabled then
        title = title .. " (ON)"
    end
    SafeSetTitle(autoSacrificeToggle, title)

    local desc
    if canSacrifice then
        desc = string.format(
            '<font color="#00ff00">Gain: %d SACRIFICE POINTS</font>',
            gainSP
        )
    else
        desc = '<font color="#ff0000">Need Ascension 100</font>'
    end

    SafeSetDesc(autoSacrificeToggle, desc)
end)

-- =====================================================
-- AUTO SP UPGRADE
-- =====================================================
local UpgradesSP = LocalPlayer:WaitForChild("UpgradesSP", 15)
local SP = StatsFolder:WaitForChild("SP")  -- StatsFolder sudah ada
local autoSPToggle = MainTabs:Toggle({
    Title = "⭐ Auto SP Upgrade",
    Flag = "AutoSPUpgrade_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoSPUpgrade.Enabled = val
        if val then
            StartManagedLoop("AutoSPUpgrade", Config.AutoSPUpgrade.Interval, function()
                return Config.AutoSPUpgrade.Enabled
            end, function()
                if not UpgradesSP or not SPUpgradeConfig then return end
                local spVal = SP.Value
                if typeof(spVal) ~= "table" then spVal = OmegaNum.fromString(tostring(spVal)) end

                -- Urutan prioritas upgrade (1..11)
                local order = {"UpgradeSP1","UpgradeSP2","UpgradeSP3","UpgradeSP4","UpgradeSP5",
                               "UpgradeSP6","UpgradeSP7","UpgradeSP8","UpgradeSP9","UpgradeSP10","UpgradeSP11"}

                for _, upgId in ipairs(order) do
                    local data = SPUpgradeConfig.Upgrades[upgId]
                    if not data then continue end
                    local lvlObj = UpgradesSP:FindFirstChild(upgId)
                    local lvl = lvlObj and lvlObj.Value or 0
                    local max = SPUpgradeConfig.GetMaxLevel(upgId)
                    if lvl >= max then continue end

                    -- Prasyarat (dari v_u_31 client)
                    local prereq = {
                        UpgradeSP2 = "UpgradeSP1", UpgradeSP3 = "UpgradeSP2",
                        UpgradeSP4 = "UpgradeSP3", UpgradeSP5 = "UpgradeSP4",
                        UpgradeSP6 = "UpgradeSP1", UpgradeSP7 = "UpgradeSP6",
                        UpgradeSP8 = "UpgradeSP7", UpgradeSP9 = "UpgradeSP1",
                        UpgradeSP10 = "UpgradeSP9", UpgradeSP11 = "UpgradeSP1"
                    }
                    local reqId = prereq[upgId]
                    if reqId then
                        local reqObj = UpgradesSP:FindFirstChild(reqId)
                        if not reqObj or reqObj.Value < 1 then continue end
                    end

                    -- Biaya
                    local cost = SPUpgradeConfig.GetPriceAtLevel(upgId, lvl)
                    if not cost then continue end
                    if typeof(cost) ~= "table" then cost = OmegaNum.fromString(tostring(cost)) end

                    -- Beberapa upgrade pakai resource alternatif
                    local altCostStat = {
                        UpgradeSP9 = "Flux",
                        UpgradeSP10 = "Voltage"
                    }
                    if altCostStat[upgId] then
                        local statObj = StatsFolder:FindFirstChild(altCostStat[upgId])
                        if statObj then
                            local resVal = statObj.Value
                            if typeof(resVal) ~= "table" then resVal = OmegaNum.fromString(tostring(resVal)) end
                            if OmegaNum.meeq(resVal, cost) then
                                pcall(function() SPUpgradeRequest:InvokeServer(upgId) end)
                                break
                            end
                        end
                    else
                        if OmegaNum.meeq(spVal, cost) then
                            pcall(function() SPUpgradeRequest:InvokeServer(upgId) end)
                            break
                        end
                    end
                end
            end)
        else
            StopManagedLoop("AutoSPUpgrade")
        end
    end
})

FM_Add("Convert", autoSPToggle)
-- Status update
StartStatusLoop("Status_AutoSPUpgrade", 1, function()
    if not autoSPToggle or not UpgradesSP or not SPUpgradeConfig then
        SafeSetTitle(autoSPToggle, "⭐ Auto SP Upgrade")
        SafeSetDesc(autoSPToggle, "Loading...")
        return
    end

    local spVal = SP.Value
    if typeof(spVal) ~= "table" then spVal = OmegaNum.fromString(tostring(spVal)) end
    local spDisplay = OmegaNum.short(spVal)

    local affordableCount = 0
    local boughtCount = 0
    local order = {"UpgradeSP1","UpgradeSP2","UpgradeSP3","UpgradeSP4","UpgradeSP5",
                   "UpgradeSP6","UpgradeSP7","UpgradeSP8","UpgradeSP9","UpgradeSP10","UpgradeSP11"}
    for _, upgId in ipairs(order) do
        local data = SPUpgradeConfig.Upgrades[upgId]
        if data then
            local lvlObj = UpgradesSP:FindFirstChild(upgId)
            local lvl = lvlObj and lvlObj.Value or 0
            if lvl > 0 then boughtCount = boughtCount + 1 end
            local max = SPUpgradeConfig.GetMaxLevel(upgId)
            if lvl < max then
                local cost = SPUpgradeConfig.GetPriceAtLevel(upgId, lvl)
                if cost then
                    if typeof(cost) ~= "table" then cost = OmegaNum.fromString(tostring(cost)) end
                    local canBuy = false
                    local altCostStat = { UpgradeSP9 = "Flux", UpgradeSP10 = "Voltage" }
                    if altCostStat[upgId] then
                        local statObj = StatsFolder:FindFirstChild(altCostStat[upgId])
                        if statObj then
                            local resVal = statObj.Value
                            if typeof(resVal) ~= "table" then resVal = OmegaNum.fromString(tostring(resVal)) end
                            canBuy = OmegaNum.meeq(resVal, cost)
                        end
                    else
                        canBuy = OmegaNum.meeq(spVal, cost)
                    end
                    if canBuy then affordableCount = affordableCount + 1 end
                end
            end
        end
    end

    local title = "⭐ Auto SP Upgrade"
    if Config.AutoSPUpgrade.Enabled then title = title .. " (ON)" end
    SafeSetTitle(autoSPToggle, title)
    SafeSetDesc(autoSPToggle, string.format("SP: %s | Bought: %d | Affordable: %d", spDisplay, boughtCount, affordableCount))
end)

-- =====================================================
-- AUTO SAND
-- =====================================================
local SandMulti = Multis:WaitForChild("SandMulti")
local Cactus = StatsFolder:WaitForChild("Cactus")
local autoSandToggle = MainTabs:Toggle({
    Title = "🏜️ Auto Sand",
    Flag = "AutoSand_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoSand.Enabled = val
        if val then
            StartManagedLoop("AutoSand", Config.AutoSand.Interval, function()
                return Config.AutoSand.Enabled
            end, function()
                if not ElementalRank or not Cactus then return end
                local rank = tonumber(ElementalRank.Value) or 0
                if rank < 2 then return end
                local cactusVal = Cactus.Value
                if typeof(cactusVal) ~= "table" then cactusVal = OmegaNum.fromString(tostring(cactusVal)) end
                local threshold = OmegaNum.fromString("1e6")
                if OmegaNum.meeq(cactusVal, threshold) then
                    pcall(function()
                        SandRequest:InvokeServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoSand")
        end
    end
})
FM_Add("Convert", autoSandToggle)

-- Status update
StartStatusLoop("Status_AutoSand", 1, function()
    if not autoSandToggle or not Cactus or not SandMulti or not ElementalRank then
        SafeSetTitle(autoSandToggle, "🏜️ Auto Sand")
        SafeSetDesc(autoSandToggle, "Loading...")
        return
    end

    local rank = tonumber(ElementalRank.Value) or 0
    if rank < 2 then
        SafeSetTitle(autoSandToggle, "🏜️ Auto Sand")
        SafeSetDesc(autoSandToggle, "🔒 Requires ElementalRank 2+")
        autoSandToggle:Lock("ElementalRank 2+")
        return
    else
        autoSandToggle:Unlock()
    end

    local cactusVal = Cactus.Value
    if typeof(cactusVal) ~= "table" then cactusVal = OmegaNum.fromString(tostring(cactusVal)) end
    local threshold = OmegaNum.fromString("1e6")
    local canConvert = OmegaNum.meeq(cactusVal, threshold)

    local title = "🏜️ Auto Sand"
    if Config.AutoSand.Enabled then
        title = title .. " (ON)"
    end
    SafeSetTitle(autoSandToggle, title)

    if not canConvert then
        SafeSetDesc(autoSandToggle, '<font color="#ff0000">Requires 1M Cactus</font>')
        return
    end

    -- Hitung gain persis seperti calcSandGain
    local log10Val = OmegaNum.toNumber(OmegaNum.log10(cactusVal))  -- float
    local exponent = log10Val - 6
    local base = math.pow(exponent, 1.3) * 4
    local multi = 1
    -- Ambil SandMulti dengan aman seperti client (pcall toOmega lalu toNumber)
    local ok, rawMulti = pcall(function() return SandMulti.Value end)
    if ok and rawMulti ~= nil then
        local ok2, num = pcall(OmegaNum.toNumber, OmegaNum.toOmega(rawMulti))
        if ok2 then multi = math.max(1, num) end
    end
    local gain = math.max(1, base) * multi
    gain = math.max(1, gain) * 100
    gain = math.floor(gain) / 100
    local gainText = OmegaNum.short(OmegaNum.fromNumber(gain))

    SafeSetDesc(autoSandToggle, string.format('<font color="#dcff3d">Gain: %s SAND</font>', gainText))
end)

-- =====================================================
-- AUTO ELEMENTAL RANK
-- =====================================================
local function meetsElementalRankRequirements(rank)
    local rankData = ElementalRankConfig.Ranks[rank]
    if not rankData then return false end
    for _, req in ipairs(rankData.Requirements) do
        local folder = LocalPlayer:FindFirstChild(req.Folder)
        if folder then
            folder = folder:FindFirstChild(req.Stat)
        end
        if not folder then return false end
        local val = folder.Value
        local required = req.Amount
        if typeof(val) ~= "table" then val = OmegaNum.fromString(tostring(val)) end
        if typeof(required) ~= "table" then required = OmegaNum.fromString(tostring(required)) end
        if OmegaNum.cmp(val, required) < 0 then
            return false
        end
    end
    return true
end

local autoERToggle = MainTabs:Toggle({
    Title = "⚡ Auto Elemental Rank",
    Flag = "AutoElementalRank_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoElementalRank.Enabled = val
        if val then
            StartManagedLoop("AutoElementalRank", Config.AutoElementalRank.Interval, function()
                return Config.AutoElementalRank.Enabled
            end, function()
                if not ElementalRank or not ElementalRankConfig then return end
                local currentRank = tonumber(ElementalRank.Value) or 0
                local nextRank = currentRank + 1
                local maxRank = 0
                for r in pairs(ElementalRankConfig.Ranks) do
                    if r > maxRank then maxRank = r end
                end
                if nextRank > maxRank then return end

                if meetsElementalRankRequirements(nextRank) then
                    pcall(function()
                        ElementalRankRequest:InvokeServer(nextRank)
                    end)
                end
            end)
        else
            StopManagedLoop("AutoElementalRank")
        end
    end
})

FM_Add("Convert", autoERToggle)
-- Status Update
StartStatusLoop("Status_AutoElementalRank", 1, function()
    if not autoERToggle or not ElementalRank or not ElementalRankConfig then
        SafeSetTitle(autoERToggle, "⚡ Auto Elemental Rank")
        SafeSetDesc(autoERToggle, "Loading...")
        return
    end

    -- Angka romawi lokal (sama dengan client)
    local romanNumerals = {"I","II","III","IV","V","VI","VII","VIII","IX","X"}

    local currentRank = tonumber(ElementalRank.Value) or 0
    local maxRank = 0
    for r in pairs(ElementalRankConfig.Ranks) do
        if r > maxRank then maxRank = r end
    end

    local title = "⚡ Auto Elemental Rank"
    if Config.AutoElementalRank.Enabled then title = title .. " (ON)" end
    SafeSetTitle(autoERToggle, title)

    -- Jika sudah max rank
    if currentRank >= maxRank then
        local descLines = {}
        table.insert(descLines, "RANK " .. (romanNumerals[currentRank] or tostring(currentRank)))
        local rankData = ElementalRankConfig.Ranks[currentRank]
        if rankData then
            for _, boost in ipairs(rankData.Boosts) do
                local statName = boost.Stat == "MaxRoll" and "ROLL" or string.upper(boost.Stat):gsub("MULTI", "")
                local multStr = tostring(boost.Multiplier)
                local ok, val = pcall(OmegaNum.toOmega, multStr)
                if ok and val then multStr = OmegaNum.short(val) end
                table.insert(descLines, statName .. " " .. multStr .. "x")
            end
        end
        SafeSetDesc(autoERToggle, table.concat(descLines, "\n"))
        return
    end

    -- Belum max rank
    local nextRank = currentRank + 1
    local currentRankData = ElementalRankConfig.Ranks[currentRank]
    local nextRankData = ElementalRankConfig.Ranks[nextRank]
    local canRankUp = meetsElementalRankRequirements(nextRank)

    local descLines = {}

    -- Baris 1: Rank
    local currentRankStr = currentRank == 0 and "RANK 0" or "RANK " .. (romanNumerals[currentRank] or tostring(currentRank))
    local nextRankStr = "RANK " .. (romanNumerals[nextRank] or tostring(nextRank))
    table.insert(descLines, currentRankStr .. " → " .. nextRankStr)

    -- Baris 2: Status
    local statusColor = canRankUp and "#00ff00" or "#ff0000"
    local statusText = canRankUp and "READY" or "NOT READY"
    table.insert(descLines, string.format('<font color="%s">%s</font>', statusColor, statusText))

    -- Boosts
    if nextRankData then
        for _, boost in ipairs(nextRankData.Boosts) do
            local statName = boost.Stat == "MaxRoll" and "ROLL" or string.upper(boost.Stat):gsub("MULTI", "")
            -- Cari multiplier saat ini
            local curMult = "1"
            if currentRank > 0 and currentRankData then
                for _, curBoost in ipairs(currentRankData.Boosts) do
                    if curBoost.Stat == boost.Stat then
                        curMult = curBoost.Multiplier
                        break
                    end
                end
            end
            -- Format angka
            local curMultStr = tostring(curMult)
            local ok, val = pcall(OmegaNum.toOmega, curMultStr)
            if ok and val then curMultStr = OmegaNum.short(val) end
            local nextMultStr = tostring(boost.Multiplier)
            local ok2, val2 = pcall(OmegaNum.toOmega, nextMultStr)
            if ok2 and val2 then nextMultStr = OmegaNum.short(val2) end
            table.insert(descLines, statName .. " " .. curMultStr .. "x → " .. statName .. " " .. nextMultStr .. "x")
        end

        -- Unlock spesial
        local unlocks = {
            [2] = "UNLOCKS SAND",
            [4] = "UNLOCKS SNOW",
            [5] = "UNLOCKS ALTAR",
            [6] = "UNLOCKS FIRE",
            [9] = "UNLOCKS FORGE",
            [12] = "UNLOCKS AUTO FIRE CLICK"
        }
        if unlocks[nextRank] then
            table.insert(descLines, unlocks[nextRank])
        end

        -- Syarat
        local reqTexts = {}
        for _, req in ipairs(nextRankData.Requirements) do
            local amount = req.Amount
            if typeof(amount) ~= "table" then amount = OmegaNum.fromString(tostring(amount)) end
            local shortAmt = OmegaNum.short(amount)
            table.insert(reqTexts, shortAmt .. " " .. string.upper(req.Stat))
        end
        if #reqTexts > 0 then
            table.insert(descLines, "Req: " .. table.concat(reqTexts, " | "))
        end
    end

    SafeSetDesc(autoERToggle, table.concat(descLines, "\n"))
end)

-- =====================================================
-- AUTO FIRE CLICK
-- =====================================================
local FireClicker = LocalPlayer:WaitForChild("FireClicker", 15)
local FireCurrentAmount = FireClicker and FireClicker:WaitForChild("CurrentAmount", 10)
local FireMaxCapacity = FireClicker and FireClicker:WaitForChild("MaxCapacity", 10)
local autoFireToggle = MainTabs:Toggle({
    Title = "🔥 Auto Fire Click",
    Flag = "AutoFireClick_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoFireClick.Enabled = val
        if val then
            StartManagedLoop("AutoFireClick", Config.AutoFireClick.Interval, function()
                return Config.AutoFireClick.Enabled
            end, function()
                if not ElementalRank or not FireCurrentAmount or not FireMaxCapacity then return end
                local rank = tonumber(ElementalRank.Value) or 0
                if rank < 6 then return end
                local current = tonumber(FireCurrentAmount.Value) or 0
                local maxCap = tonumber(FireMaxCapacity.Value) or 5
                if current < maxCap then
                    pcall(function()
                        FireClick:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoFireClick")
        end
    end
})

FM_Add("Mobs", autoFireToggle)
-- Status Update
StartStatusLoop("Status_AutoFireClick", 1, function()
    if not autoFireToggle or not ElementalRank or not FireCurrentAmount or not FireMaxCapacity then
        SafeSetTitle(autoFireToggle, "🔥 Auto Fire Click")
        SafeSetDesc(autoFireToggle, "Loading...")
        return
    end

    local rank = tonumber(ElementalRank.Value) or 0
    if rank < 6 then
        SafeSetTitle(autoFireToggle, "🔥 Auto Fire Click")
        SafeSetDesc(autoFireToggle, "🔒 Requires ElementalRank 6+")
        autoFireToggle:Lock("ElementalRank 6+")
        return
    else
        autoFireToggle:Unlock()
    end

    local current = tonumber(FireCurrentAmount.Value) or 0
    local maxCap = tonumber(FireMaxCapacity.Value) or 5
    local canClick = current < maxCap
    local title = "🔥 Auto Fire Click"
    if Config.AutoFireClick.Enabled then title = title .. " (ON)" end
    SafeSetTitle(autoFireToggle, title)
    SafeSetDesc(autoFireToggle, string.format("Progress: %d / %d", current, maxCap))
end)

-- =====================================================
-- AUTO ALTAR ROLL + DEPOSIT CORE
-- =====================================================
local Altar = LocalPlayer:WaitForChild("Altar", 60)
local CurrentXp = Altar and Altar:WaitForChild("CurrentXp", 10)
local DepositedXpStats = Altar and Altar:WaitForChild("DepositedXpStats", 10)
local DepositedXpRunes = Altar and Altar:WaitForChild("DepositedXpRunes", 10)
local autoAltarRollToggle = MainTabs:Toggle({
    Title = "🎲 Auto Altar Roll",
    Flag = "AutoAltarRoll_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoAltarRoll.Enabled = val
        if val then
            StartManagedLoop("AutoAltarRoll", Config.AutoAltarRoll.Interval, function()
                return Config.AutoAltarRoll.Enabled
            end, function()
                if not ElementalRank then return end
                local rank = tonumber(ElementalRank.Value) or 0
                if rank < 5 then return end
                pcall(function()
                    AltarRoll:InvokeServer()
                end)
            end)
        else
            StopManagedLoop("AutoAltarRoll")
        end
    end
})

FM_Add("Mobs", autoAltarRollToggle)
-- Status Altar Roll
StartStatusLoop("Status_AutoAltarRoll", 1, function()
    if not autoAltarRollToggle or not ElementalRank then
        SafeSetTitle(autoAltarRollToggle, "🎲 Auto Altar Roll")
        SafeSetDesc(autoAltarRollToggle, "Loading...")
        return
    end
    local rank = tonumber(ElementalRank.Value) or 0
    if rank < 5 then
        SafeSetTitle(autoAltarRollToggle, "🎲 Auto Altar Roll")
        SafeSetDesc(autoAltarRollToggle, "🔒 Requires ElementalRank 5+")
        autoAltarRollToggle:Lock("ElementalRank 5+")
        return
    else
        autoAltarRollToggle:Unlock()
    end
    local title = "🎲 Auto Altar Roll"
    if Config.AutoAltarRoll.Enabled then title = title .. " (ON)" end
    SafeSetTitle(autoAltarRollToggle, title)
    SafeSetDesc(autoAltarRollToggle, "Rolling every " .. Config.AutoAltarRoll.Interval .. "s")
end)

local autoDepositStatsToggle = MainTabs:Toggle({
    Title = "📊 Auto Deposit Stats",
    Flag = "AutoDepositStats_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoDepositStats = val
        if val then
            StartManagedLoop("AutoDepositStats", 5, function()
                return Config.AutoDepositStats
            end, function()
                if not CurrentXp then return end
                local xp = tonumber(CurrentXp.Value) or 0
                if xp > 0 then
                    pcall(function() DepositCore:InvokeServer("Stats") end)
                end
            end)
        else
            StopManagedLoop("AutoDepositStats")
        end
    end
})

FM_Add("Mobs", autoDepositStatsToggle)
StartStatusLoop("Status_AutoDepositStats", 1, function()
    if not autoDepositStatsToggle or not WinterCore or not DepositedXpStats or not CurrentXp then
        SafeSetTitle(autoDepositStatsToggle, "📊 Auto Deposit Stats")
        SafeSetDesc(autoDepositStatsToggle, "Loading...")
        return
    end
    local statsLevel = WinterCore.getLevel(WinterCore.StatsCore, tostring(DepositedXpStats.Value))
    local xp = tonumber(CurrentXp.Value) or 0
    local title = "📊 Auto Deposit Stats"
    if Config.AutoDepositStats then title = title .. " (ON)" end
    SafeSetTitle(autoDepositStatsToggle, title)
    SafeSetDesc(autoDepositStatsToggle, string.format("Fragments: %d | Stats Core Lv. %d", xp, statsLevel))
end)


local autoDepositRunesToggle = MainTabs:Toggle({
    Title = "🔮 Auto Deposit Runes",
    Flag = "AutoDepositRunes_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoDepositRunes = val
        if val then
            StartManagedLoop("AutoDepositRunes", 5, function()
                return Config.AutoDepositRunes
            end, function()
                if not CurrentXp then return end
                local xp = tonumber(CurrentXp.Value) or 0
                if xp > 0 then
                    pcall(function() DepositCore:InvokeServer("Runes") end)
                end
            end)
        else
            StopManagedLoop("AutoDepositRunes")
        end
    end
})

FM_Add("Mobs", autoDepositRunesToggle)
StartStatusLoop("Status_AutoDepositRunes", 1, function()
    if not autoDepositRunesToggle or not WinterCore or not DepositedXpRunes or not CurrentXp then
        SafeSetTitle(autoDepositRunesToggle, "🔮 Auto Deposit Runes")
        SafeSetDesc(autoDepositRunesToggle, "Loading...")
        return
    end
    local runesLevel = WinterCore.getLevel(WinterCore.RuneCore, tostring(DepositedXpRunes.Value))
    local xp = tonumber(CurrentXp.Value) or 0
    local title = "🔮 Auto Deposit Runes"
    if Config.AutoDepositRunes then title = title .. " (ON)" end
    SafeSetTitle(autoDepositRunesToggle, title)
    SafeSetDesc(autoDepositRunesToggle, string.format("Fragments: %d | Runes Core Lv. %d", xp, runesLevel))
end)

-- =====================================================
-- AUTO FORGE DEPOSIT
-- =====================================================
local Fire = StatsFolder:WaitForChild("Fire")  -- StatsFolder sudah ada
local DepositedFire = FireClicker:WaitForChild("DepositedFire")  -- FireClicker sudah ada
local MagmaMulti = Multis:WaitForChild("MagmaMulti")  -- Multis sudah ada
local autoForgeToggle = MainTabs:Toggle({
    Title = "🔨 Auto Forge Deposit",
    Flag = "AutoForgeDeposit_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoForgeDeposit.Enabled = val
        if val then
            StartManagedLoop("AutoForgeDeposit", Config.AutoForgeDeposit.Interval, function()
                return Config.AutoForgeDeposit.Enabled
            end, function()
                if not ElementalRank or not Fire then return end
                local rank = tonumber(ElementalRank.Value) or 0
                if rank < 9 then return end
                local fireVal = Fire.Value
                if typeof(fireVal) ~= "table" then fireVal = OmegaNum.fromString(tostring(fireVal)) end
                if OmegaNum.meeq(fireVal, OmegaNum.fromNumber(1)) then
                    pcall(function()
                        ForgeDepositRequest:InvokeServer(OmegaNum.toString(fireVal))
                    end)
                end
            end)
        else
            StopManagedLoop("AutoForgeDeposit")
        end
    end
})

FM_Add("Mobs", autoForgeToggle)
-- Status Update
StartStatusLoop("Status_AutoForgeDeposit", 1, function()
    if not autoForgeToggle or not ElementalRank or not Fire or not DepositedFire then
        SafeSetTitle(autoForgeToggle, "🔨 Auto Forge Deposit")
        SafeSetDesc(autoForgeToggle, "Loading...")
        return
    end

    local rank = tonumber(ElementalRank.Value) or 0
    if rank < 9 then
        SafeSetTitle(autoForgeToggle, "🔨 Auto Forge Deposit")
        SafeSetDesc(autoForgeToggle, "🔒 Requires ElementalRank 9+")
        autoForgeToggle:Lock("ElementalRank 9+")
        return
    else
        autoForgeToggle:Unlock()
    end

    local fireVal = Fire.Value
    if typeof(fireVal) ~= "table" then fireVal = OmegaNum.fromString(tostring(fireVal)) end
    local depositedVal = DepositedFire.Value
    if typeof(depositedVal) ~= "table" then depositedVal = OmegaNum.fromString(tostring(depositedVal)) end

    local title = "🔨 Auto Forge Deposit"
    if Config.AutoForgeDeposit.Enabled then title = title .. " (ON)" end
    SafeSetTitle(autoForgeToggle, title)

    local descLines = {}
    table.insert(descLines, string.format("Fire: %s", OmegaNum.short(fireVal)))
    table.insert(descLines, string.format("Deposited: %s", OmegaNum.short(depositedVal)))

    -- Hitung MPS (Magma per Second) jika deposited >= 1e18
    local threshold = OmegaNum.fromString("1e18")
    if OmegaNum.meeq(depositedVal, threshold) then
        local depositedNum = OmegaNum.toNumber(OmegaNum.toOmega(depositedVal))
        local thresholdNum = OmegaNum.toNumber(OmegaNum.toOmega(threshold))
        local level = math.log10(depositedNum) - math.log10(thresholdNum)
        if level >= 0 then
            local multi = 1
            if MagmaMulti then
                local rawMulti = MagmaMulti.Value
                if typeof(rawMulti) ~= "table" then rawMulti = OmegaNum.fromString(tostring(rawMulti)) end
                multi = OmegaNum.toNumber(OmegaNum.toOmega(rawMulti))
            end
            local mps = math.pow(level + 1, 1.5) * 5 * multi
            table.insert(descLines, string.format("MPS: %s Magma/s", OmegaNum.short(OmegaNum.fromNumber(mps))))
        end
    else
        table.insert(descLines, "MPS: 0 (Need 1e18+ Deposited)")
    end

    SafeSetDesc(autoForgeToggle, table.concat(descLines, "\n"))
end)

local CactusFolder = workspace:WaitForChild("Collect", 60)   -- folder tempat kaktus muncul
local CollectionStats = LocalPlayer:WaitForChild("CollectionStats", 60)
local CollectionRange = CollectionStats and CollectionStats:WaitForChild("CollectionRange", 10)

-- =====================================================
-- AUTO COLLECT CACTUS (Farm) – versi Tween
-- =====================================================
local CactusSection = MainTabs:Section({
    Title = "Auto Collect Cactus",
    Opened = true,
    TextXAlignment = "Center"
})
FM_Add("Mobs", CactusSection)

local cactusGroup = CactusSection:Group({})
FM_Add("Mobs", cactusGroup)

-- Variabel untuk antrian dan state tween
local cactusQueue = {}          -- antrian kaktus yang akan dikumpulkan
local isMoving = false          -- apakah sedang dalam proses tween
local collectedCache = {}       -- cache kaktus yang sudah dikirim (hindari ganda)

-- Bersihkan cache ketika kaktus hilang
if CactusFolder then
    CactusFolder.ChildRemoved:Connect(function(cactus)
        collectedCache[cactus] = nil
        -- hapus dari antrian jika ada
        for i, q in ipairs(cactusQueue) do
            if q == cactus then
                table.remove(cactusQueue, i)
                break
            end
        end
    end)
end

local function processQueue()
    if isMoving then return end
    if #cactusQueue == 0 then return end
    local cactus = table.remove(cactusQueue, 1)
    if not cactus or not cactus.Parent then return end -- sudah hilang

    local mainPart = cactus:FindFirstChild("MainPart")
    if not mainPart then return end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart

    -- Cek jarak (opsional, bisa disesuaikan)
    local targetPos = mainPart.Position
    local distance = (hrp.Position - targetPos).Magnitude
    if distance > Config.AutoCollectCactus.MaxDistance then
        -- terlalu jauh, lewati
        processQueue() -- proses berikutnya
        return
    end

    isMoving = true
    local tweenInfo = TweenInfo.new(Config.AutoCollectCactus.TweenTime, Enum.EasingStyle.Linear)
    local goal = { CFrame = CFrame.new(targetPos) }
    local tween = TweenService:Create(hrp, tweenInfo, goal)
    tween:Play()
    tween.Completed:Connect(function()
        isMoving = false
        if cactus and cactus.Parent then
            -- kirim event pengumpulan
            pcall(function()
                CollectCactus:FireServer(cactus)
            end)
            collectedCache[cactus] = true
        end
        -- lanjutkan antrian
        processQueue()
    end)
end

-- Loop pengisian antrian
local autoCactusToggle = cactusGroup:Toggle({
    Title = "🌵 Auto Collect Cactus (Tween)",
    Flag = "AutoCollectCactus_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoCollectCactus.Enabled = val
        if val then
            StartManagedLoop("AutoCollectCactus_FillQueue", Config.AutoCollectCactus.Interval, function()
                return Config.AutoCollectCactus.Enabled
            end, function()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                local hrp = character.HumanoidRootPart
                for _, cactus in ipairs(CactusFolder:GetChildren()) do
                    if cactus.Name == "Cactus" 
                        and cactus:GetAttribute("Owner") == LocalPlayer.UserId 
                        and not collectedCache[cactus] 
                        and cactus:FindFirstChild("MainPart") then
                        -- cek jarak agar tidak memasukkan kaktus terlalu jauh
                        local dist = (hrp.Position - cactus.MainPart.Position).Magnitude
                        if dist <= Config.AutoCollectCactus.MaxDistance then
                            -- cegah duplikat di antrian
                            local alreadyQueued = false
                            for _, q in ipairs(cactusQueue) do
                                if q == cactus then alreadyQueued = true break end
                            end
                            if not alreadyQueued then
                                table.insert(cactusQueue, cactus)
                            end
                        end
                    end
                end
                -- mulai proses antrian jika tidak sedang bergerak
                processQueue()
            end)
        else
            StopManagedLoop("AutoCollectCactus_FillQueue")
            cactusQueue = {}
            if isMoving then
                isMoving = false
            end
        end
    end
})

-- Status update
StartStatusLoop("Status_AutoCollectCactus", 1, function()
    if not autoCactusToggle or not CactusFolder then
        SafeSetTitle(autoCactusToggle, "🌵 Auto Collect Cactus (Tween)")
        SafeSetDesc(autoCactusToggle, "Loading...")
        return
    end

    local totalOwned = 0
    local inQueue = #cactusQueue
    for _, cactus in ipairs(CactusFolder:GetChildren()) do
        if cactus.Name == "Cactus" and cactus:GetAttribute("Owner") == LocalPlayer.UserId then
            totalOwned = totalOwned + 1
        end
    end

    local title = "🌵 Auto Collect Cactus (Tween)"
    if Config.AutoCollectCactus.Enabled then
        title = title .. " (ON)"
    end
    SafeSetTitle(autoCactusToggle, title)
    SafeSetDesc(autoCactusToggle, string.format("Owned: %d | Queue: %d | Moving: %s", totalOwned, inQueue, isMoving and "Yes" or "No"))
end)

-- =====================================================
-- 10. SETTINGS TAB
-- =====================================================
SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings-2" });
SettingsTab:Section({ Title = "Config Manager", Icon = "save", Opened = true });
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
FM_OnChange("Board Upgrades")
Window:SelectTab(MainTabs.Index);

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
end)
