if game.PlaceId ~= 105716258039711 then
    return
end
repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Anime Advanced"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()
-- ============================================================================
-- [SERVICES]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService('VirtualUser')
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

-- [VARS & CHARACTER]
-- ============================================================================
-- [GLOBAL VARIABLES & STATE]
-- ============================================================================
-- 1. Character & Core
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    character = newChar
    hrp = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
end)

-- 2. Game State & Configs
local attackRangePart 
local distance = 10000
local attackRange 
local isUpdatingUI = false 
local isTransitioning = false 

-- 3. Feature Flags & Lists
local targetList = {}
local nameList = {} 
local isFarm1 = false

local selectedBosses = {}
local isAutoBoss = false 
local isGlobalBossActive = false 
local savedPreviousMap = nil
local isBossRotationActive = false
local MapList = {"None"}
local BossListData = {}

local waveTrial = 0
local targetWaveTrial = 500
local trialList = {{name = "TrialEasy", time = 15}}
local isTrial = false

local waveRaid = 0
local targetWaveRaid = 50
local isRaid = false
local raidJoinList = {{name = "Raid", time = 0}} 

local SelectedGamemodeName = "TrialEasy"
local ActiveEventsFromChat = {} 
local UI_GM = { WaveInput = nil, AutoToggle = nil, KeyToggle = nil, InfoLabel = nil }
UI_GM.IgnoreEnemyDD = nil -- Tambahkan ini di dekat variable UI_GM lainnya
local GM_DropdownList = {}

local GlobalGachaSources = {} 
local powerList = {}        
local PowerToggles = {}
local selectedGachaSwordSID = nil
local SwordPassiveTargets = {} 
local FormattedTalentTargets = {}

local wu_SelectedMap = "Current Map"
local WU_MapConfig = {} 
local targetStar = "None"
local isRankUp = false

local UI = {} 
local DifficultyRank = {["Very Easy"]=1, ["Easy"]=2, ["Medium"]=3, ["Hard"]=4, ["Insane"]=5, ["Boss"]=6, ["Godlike"]=7}
local lastCachedMap = nil

-- 4. Databases (Empty Init)
GlobalBossDB = {}
GlobalHeroesExpeditionDB = {}
GlobalGradientDB = {}
GlobalRankDB = {}
GlobalMapDB = {}
GlobalWorldUpgradeDB = {}
GlobalUpgradeSystemsDB = {}
CharacterIcons = {}
GlobalItemDB = {}
GlobalAvatarDB = {}
GlobalSwordDB = {}
GlobalGamemodeDB = {}
GlobalPetsDB = {}
GlobalArtefactsDB = {}
GlobalAccessoriesDB = {}
GlobalHeroSwordsDB = {}
GlobalHeroAccessoriesDB = {}
GlobalHeroAmuletsDB = {}
GlobalMountsDB = {}
GlobalMerchantDB = {}
GlobalGachaUpgradeDB = {}
GamemodeSettings = {}
GlobalRunesDB = {}
SelectedRuneSlot = "Rune"
SelectedRuneToAct = "Damage Rune"
isAutoPrestige = false
AutoPrestigeDelay = 0.5

-- [DATABASE SUPREME BOSSES]
GlobalSupremeBossDB = {}
local selectedSupremeBoss = nil
local selectedSupremeDiff = "Easy"
local isAutoSupreme = false


-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- [HOOK SYSTEM: DISABLE GACHA ANIMATION]
task.spawn(function()
    local success, err = pcall(function()
        local GachaScriptPath = PlayerScripts:WaitForChild("Omni"):WaitForChild("Scripts"):WaitForChild("Interface"):WaitForChild("Scripts"):WaitForChild("Gacha")
        local GachaModule = require(GachaScriptPath)
        getgenv().OldDisplayRewards = getgenv().OldDisplayRewards or GachaModule.DisplayRewards

        GachaModule.DisplayRewards = function(...)
            return nil
        end
    end)
    
    if not success then
        warn("Failed to Hook Gacha Animation: " .. tostring(err))
    end
end)

-- [CONFIG PATHS]
local FolderPath = "ANUI/AnimeAdvanced"
local ConfigPath = FolderPath .. "/config"
local SelectionsFile = FolderPath .. "/MapSelections.json"
local ConfigName = "AN_AnimeAdvanced"

if not isfolder("ANUI") then makefolder("ANUI") end
if not isfolder(FolderPath) then makefolder(FolderPath) end
if not isfolder(ConfigPath) then makefolder(ConfigPath) end

-- [DATA SYSTEM: MAP SELECTION]
local MapSelections = {}

-- Load Data Map Selections
if isfile(SelectionsFile) then
    local success, result = pcall(function() return HttpService:JSONDecode(readfile(SelectionsFile)) end)
    if success and type(result) == "table" then MapSelections = result end
end

local function SaveMapSelection(mapName, enemyValue)
    if not mapName or isUpdatingUI or isTransitioning then return end
    MapSelections[mapName] = enemyValue
    writefile(SelectionsFile, HttpService:JSONEncode(MapSelections))
end

-- Variabel Global untuk Validasi
local IsPremium = false
local ValidKeys = {"ANHUB-2025"} -- Key default untuk Free User

function LoadKeySystemData()
    local url = "https://raw.githubusercontent.com/AdityaNugrahaInside/ANHub/refs/heads/main/Key.txt"
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        for line in response:gmatch("[^\r\n]+") do
            -- Memisahkan ID dan Key (Format: UserId:MD5Key)
            local parts = string.split(line, ":")
            if #parts >= 2 then
                local userid_in_file = string.gsub(parts[1], "%s+", "") -- Hapus spasi jika ada
                local key_in_file = string.gsub(parts[2], "%s+", "")
                
                table.insert(ValidKeys, key_in_file)
                
                -- Deteksi jika player adalah pemilik ID Premium
                if userid_in_file == tostring(LocalPlayer.UserId) then
                    IsPremium = true
                end
            end
        end
    end
end

-- Jalankan pengecekan data
LoadKeySystemData()
-- [HELPER: DATA SCAN]
local OmniRef = require(ReplicatedStorage.Omni)
local NumberUtils = require(ReplicatedStorage.Libs.Utils.Scripts.Number)
local function ScanPlayerData()
    if OmniRef and OmniRef.Data then
        getgenv().PlayerData = OmniRef.Data
    end
    if OmniRef and OmniRef.Enemies then
        getgenv().EnemiesData = OmniRef.Enemies
    end
end


-- [WEBHOOK CONFIG]
local MyWebhookURL = "https://discord.com/api/webhooks/1446933055741628507/a1Xq1qieJSyuAC27ZDIQYeN_NQ-zyRgomRTtZ2lZMLs4eF0ICi4jwKF4uIgv1-r5eENY"

-- Helper Webhook Global
local function SendWebhook(title, description, color)
    if not MyWebhookURL or MyWebhookURL == "" then return end
    
    local data = {
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = description,
            ["color"] = color,
            ["footer"] = {
                ["text"] = "ANHub - Anime Advanced | " .. os.date("%X")
            }
        }}
    }

    local jsonData = HttpService:JSONEncode(data)
    local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

    if httpRequest then
        task.spawn(function()
            pcall(function()
                httpRequest({
                    Url = MyWebhookURL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = jsonData
                })
            end)
        end)
    end
end

-- [UI LIBRARY]
local l = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
-- local l = require("d:/Roblox/A/WindUI/src/Init.lua")
local Window = l:CreateWindow({
    Title = "AN Hub Anime Advanced",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeAdvanced",
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 220,
    HideSearchBar = true,
    ToggleKey = Enum.KeyCode.RightControl,
    KeySystem = {
        -- Fitur Auto-Fill/Bypass: Jika Premium, Enabled = false (langsung masuk)
        Enabled = not IsPremium, 
        Title = "ANHub Access",
        Description = "Free Key: ANHUB-2025",
        Key = ValidKeys,
        URL = "https://discord.gg/bUkCZvmrpH",
        Note = "Premium Users are auto-verified!",
        SaveKey = true
    }
})

-- Sidebar Animation
task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)

task.spawn(function()
    while not Window.Destroyed do
        ScanPlayerData()
        task.wait()
    end
end)
local function Notify(title, content, icon)
    if l then l:Notify({ Title = title, Content = content, Icon = icon, Duration = 3 }) end
end

-- ============================================================================
--  GAME LOGIC VARIABLES (Moved to Global Header)
-- ============================================================================

-- [FIX] Manual Bypass untuk Map Event yang tidak ada di data
local function IsMapUnlocked(mapName)
    -- Jika mapName adalah Christmas atau Global, anggap selalu terbuka
    if not mapName or mapName == "Global" or mapName == "Christmas Event 2025" then 
        return true 
    end
    
    local pData = getgenv().PlayerData
    if pData and pData.Maps then
        if pData.Maps[mapName] ~= nil then
            return true
        end
    end
    return false
end

local function LoadGameData()
    local RS = ReplicatedStorage
    
    -- [HELPER] Fungsi aman untuk load module berdasarkan path string (Contoh: "Shared.Maps")
    local function RequireModule(pathString)
        local currentObj = RS
        for segment in string.gmatch(pathString, "[^%.]+") do
            currentObj = currentObj:FindFirstChild(segment)
            if not currentObj then return {} end
        end
        
        if currentObj:IsA("ModuleScript") then
            local success, result = pcall(require, currentObj)
            return success and result or {}
        end
        return {}
    end

    -- [HELPER] Fungsi untuk load semua module dalam sebuah FOLDER (Contoh: "Shared.WorldUpgrades")
    local function RequireFolder(pathString)
        local resultTable = {}
        local currentObj = RS
        for segment in string.gmatch(pathString, "[^%.]+") do
            currentObj = currentObj:FindFirstChild(segment)
            if not currentObj then return {} end
        end

        for _, module in pairs(currentObj:GetChildren()) do
            if module:IsA("ModuleScript") then
                local success, data = pcall(require, module)
                if success and type(data) == "table" then
                    -- Simpan berdasarkan nama Module dan nama internal (jika ada)
                    resultTable[module.Name] = data
                    if data.Name then resultTable[data.Name] = data end
                end
            end
        end
        return resultTable
    end

    -- ========================================================================
    -- [KONFIGURASI MODUL] Sinkronisasi dengan Modul Info Game
    -- ========================================================================
    
    -- 1. Load Single Modules (Sesuai Path decompile Info.lua)
    GlobalMapDB              = RequireModule("Shared.Maps")
    GlobalGamemodeDB         = RequireModule("Shared.Gamemodes")
    GlobalPetsDB             = RequireModule("Shared.Pets")
    GlobalArtefactsDB        = RequireModule("Shared.Artefacts")
    GlobalAvatarDB           = RequireModule("Shared.Avatars")
    GlobalSwordDB            = RequireModule("Shared.Swords")
    GlobalItemDB             = RequireModule("Shared.Items")
    GlobalAccessoriesDB      = RequireModule("Shared.Accessories")
    GlobalHeroSwordsDB       = RequireModule("Shared.HeroSwords")
    GlobalHeroAccessoriesDB  = RequireModule("Shared.HeroAccessories")
    GlobalHeroAmuletsDB      = RequireModule("Shared.HeroAmulets")
    GlobalMountsDB           = RequireModule("Shared.Mounts")
    
    -- Database Tambahan Script
    GlobalBossDB             = RequireModule("Shared.Enemies.Global Bosses")
    GlobalHeroesExpeditionDB = RequireModule("Shared.HeroesExpedition")
    GlobalGradientDB         = RequireModule("Libs.Utils.Scripts.Colors")
    GlobalRankDB             = RequireModule("Shared.Ranks")
    CharacterIcons           = RequireModule("Shared.CharacterIcons")
    GlobalRunesDB            = RequireModule("Shared.Runes")

    -- 2. Load Folder Modules (Sistem Dinamis)
    GlobalWorldUpgradeDB     = RequireFolder("Shared.WorldUpgrades")
    GlobalUpgradeSystemsDB   = RequireFolder("Shared.Upgrade.Systems")
    GlobalMerchantDB         = RequireFolder("Shared.Merchant")
    GlobalGachaUpgradeDB     = RequireFolder("Shared.GachaUpgrade.Systems")

    -- ========================================================================
    -- [DATA CLEANUP]
    -- ========================================================================
    
    -- Filter Boss: Hanya ambil boss yang memiliki data Map valid
    local CleanBosses = {}
    for bossName, data in pairs(GlobalBossDB) do
        if data.Map then CleanBosses[bossName] = data end
    end
    GlobalBossDB = CleanBosses

    print("[ANHub] All Game Data Loaded Perfectly!")
end

LoadGameData()
-- [INTEGRASI INFO MODULE LENGKAP]
local function GetItemInfo(typeStr, nameStr)
    -- 1. Handling Currency & Multiplier
    if typeStr == "Currency" or typeStr == "Currencies" or typeStr == "Multiplier" or typeStr == "Multipliers" then
        local CurrencyDB = {
            ["Power"] = { ["Name"] = "Power", ["Rarity"] = "Common", ["Icon"] = "rbxassetid://137105971556389" },
            ["Coins"] = { ["Name"] = "Coins", ["Rarity"] = "Common", ["Icon"] = "rbxassetid://77876827884240" },
            ["Damage"] = { ["Name"] = "Damage", ["Rarity"] = "Common", ["Icon"] = "rbxassetid://78687483459513" },
            ["Player Exp"] = { ["Name"] = "Player Exp", ["Rarity"] = "Common", ["Icon"] = "rbxassetid://111765295313322" },
            ["PaidGems"] = { ["Name"] = "Paid Gems", ["Rarity"] = "Mythical", ["Icon"] = "rbxassetid://124637281361340" },
            ["FreeGems"] = { ["Name"] = "Free Gems", ["Rarity"] = "Mythical", ["Icon"] = "rbxassetid://124637281361340" },
            ["XMAS Souls"] = { ["Name"] = "XMAS Souls", ["Rarity"] = "Common", ["Icon"] = "rbxassetid://104279826665293" },
            ["XMASDamage"] = { ["Name"] = "XMAS Damage", ["Rarity"] = "Common", ["Icon"] = "rbxassetid://78687483459513" },
            ["XMAS Stars"] = { ["Name"] = "XMAS Stars", ["Rarity"] = "Common", ["Icon"] = "rbxassetid://87872332890336" }
        }
        return CurrencyDB[nameStr]

    -- 2. Handling Berbagai Tipe Item (Sesuai Struktur decompile Info.lua)
    elseif typeStr == "Item" or typeStr == "Items" then
        return GlobalItemDB[nameStr]
    elseif typeStr == "HeroAccessory" or typeStr == "HeroAccessories" then
        return GlobalHeroAccessoriesDB[nameStr]
    elseif typeStr == "HeroSword" or typeStr == "HeroSwords" then
        return GlobalHeroSwordsDB[nameStr]
    elseif typeStr == "HeroAmulet" or typeStr == "HeroAmulets" then
        return GlobalHeroAmuletsDB[nameStr]
    elseif typeStr == "Avatar" or typeStr == "Avatars" then
        return GlobalAvatarDB[nameStr]
    elseif typeStr == "Sword" or typeStr == "Swords" then
        return GlobalSwordDB[nameStr]
    elseif typeStr == "Pet" or typeStr == "Pets" then
        return GlobalPetsDB[nameStr]
    elseif typeStr == "Artefact" or typeStr == "Artefacts" then
        -- Artefacts biasanya tersimpan di dalam .List
        return GlobalArtefactsDB.List and GlobalArtefactsDB.List[nameStr] or GlobalArtefactsDB[nameStr]
    elseif typeStr == "Mount" or typeStr == "Mounts" then
        return GlobalMountsDB[nameStr]
    end

    return nil
end
-- Load Database Game
local function LoadGachaSources()
    local SourcesFolder = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Gacha"):WaitForChild("Sources")
    if SourcesFolder then
        for _, module in pairs(SourcesFolder:GetChildren()) do
            if module:IsA("ModuleScript") then
                local s, r = pcall(function() return require(module) end)
                if s and type(r) == "table" then
                    GlobalGachaSources[module.Name] = r
                end
            end
        end
    end
end
LoadGachaSources()

-- Helper: Ambil List Pedang (UPDATED: Added Gradient Support)
local function GetGachaSwordList()
    local list = {}
    local pData = getgenv().PlayerData
    if pData and pData.SwordsEquipped and pData.Swords then
        for sid, _ in pairs(pData.SwordsEquipped) do
            local swordData = pData.Swords[sid]
            if swordData then
                local name = swordData.Name
                local currentPassive = swordData.Passive or "None"
                local rarity = swordData.Rarity or "Common"
                
                local iconId = "rbxassetid://84366761557806"
                if GlobalSwordDB and GlobalSwordDB[name] then iconId = GlobalSwordDB[name].Icon end

                -- [BARU] Generate Gradient berdasarkan Rarity untuk Card UI
                local gradientObj = nil
                if GlobalGradientDB and GlobalGradientDB.GetRarityColor then
                    local colors = GlobalGradientDB:GetRarityColor(rarity)
                    if colors and colors.Base and colors.Wave then
                         gradientObj = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, colors.Base),
                            ColorSequenceKeypoint.new(1, colors.Wave)
                        }
                    end
                end

                table.insert(list, {
                    Title = string.format("%s [%s]", name, currentPassive),
                    Desc = "Rarity: " .. rarity,
                    Value = sid, 
                    Icon = iconId,
                    Gradient = gradientObj -- Data Gradient ditambahkan ke list
                })
            end
        end
        table.sort(list, function(a,b) return a.Title < b.Title end)
    end
    return list
end

-- Helper: Ambil List Passive (Index)
local function GetSwordPassiveIndexList()
    local list = {}
    local sourceDB = GlobalGachaSources["Sword Passives"] -- Plural 's'
    
    if sourceDB then
        for name, data in pairs(sourceDB) do
            local perksVal = data.Perks or 0
            local statsDesc = string.format("Perks: x%s", tostring(perksVal))
            
            local gradientObj = nil
            if GlobalGradientDB and GlobalGradientDB.GetRarityColor then
                local colors = GlobalGradientDB:GetRarityColor(data.Rarity or "Common")
                if colors and colors.Base and colors.Wave then
                     gradientObj = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, colors.Base),
                        ColorSequenceKeypoint.new(1, colors.Wave)
                    }
                end
            end
            
            table.insert(list, {
                Title = name, Desc = statsDesc, Value = name,
                Icon = data.Icon, Gradient = gradientObj,
                Index = data.Index or 999
            })
        end
        table.sort(list, function(a,b) return a.Index < b.Index end)
    end
    return list
end

-- Loader Daftar Gacha dengan Sortir Berdasarkan RollMethod
local function LoadDynamicGachaList()
    table.clear(powerList) 
    local MachinesFolder = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Gacha"):WaitForChild("Machines")
    if MachinesFolder then
        for _, module in pairs(MachinesFolder:GetChildren()) do
            if module:IsA("ModuleScript") then
                local success, data = pcall(function() return require(module) end)
                if success and type(data) == "table" and data.Item then
                    local writableData = {}
                    for k, v in pairs(data) do writableData[k] = v end
                    
                    writableData.auto = false
                    writableData.allow = true
                    writableData.Map = data.Map or "Global"
                    writableData.IsTalent = (data.Name == "Talents")
                    -- Pastikan RollMethod tercatat, jika nil beri string kosong
                    writableData.RollMethod = data.RollMethod or "" 
                    
                    table.insert(powerList, writableData)
                end
            end
        end
    end

    -- [LOGIKA SORTIR BARU]
    table.sort(powerList, function(a, b)
        local aNormal = (a.RollMethod == "Normal")
        local bNormal = (b.RollMethod == "Normal")

        -- Jika satu Normal dan satunya tidak, dahulukan yang Normal
        if aNormal ~= bNormal then
            return aNormal -- Mengembalikan true jika 'a' adalah Normal
        end

        -- Jika sama-sama Normal atau sama-sama bukan, urutkan berdasarkan Nama (A-Z)
        return a.Name < b.Name
    end)
end
task.spawn(LoadDynamicGachaList)

-- World Upgrades Vars
wu_SelectedMap = "Current Map"
-- Cari baris ini dan ganti:
local WU_MapConfig = {} 

local function GetWUConfig(mapName)
    if not WU_MapConfig[mapName] then
        WU_MapConfig[mapName] = {} -- Sekarang menyimpan [UpgradeName] = true/false
    end
    return WU_MapConfig[mapName]
end

-- Stronger
targetStar = "None"
isRankUp = false

-- Range Checker
task.spawn(function()
    while not Window.Destroyed do
        attackRangePart = workspace:FindFirstChild("Cache") and workspace.Cache:FindFirstChild("Area")
        if attackRangePart then attackRange = attackRangePart.Size.X/2 end
        task.wait(1)
    end
end)

local function getPosition(obj)
    if obj:IsA("Model") then return obj:GetPivot().Position
    elseif obj:IsA("BasePart") then return obj.Position end
    return nil
end

local function getDistance(obj1, obj2)
    local pos1 = getPosition(obj1)
    local pos2 = getPosition(obj2)
    if pos1 and pos2 then return (pos1 - pos2).Magnitude end
    return 999999
end

-- ============================================================================
--  DATA LOADER & HELPERS (UPDATED)
-- ============================================================================
-- Load Module Internal Game


-- Wrapper untuk mengubah String (contoh: "1.5K") menjadi Angka (1500)
-- Menggunakan fungsi .Unformat dari game
local function ParseAbbreviated(str)
    if type(str) == "number" then return str end
    if not str then return 0 end
    -- Arg1 nil karena fungsi aslinya: function(arg1, arg2)
    return NumberUtils.Unformat(nil, str) 
end

-- Wrapper untuk mengubah Angka (1500) menjadi String (contoh: "1.5K")
-- Menggunakan fungsi .Format dari game
local function FormatNumber(n)
    if not n then return "0" end
    -- Arg1 nil karena fungsi aslinya: function(arg1, arg2)
    return NumberUtils.Format(nil, n)
end

-- ============================================================================
--  ENEMY LIST & AUTO SELECT (FARMING) [LAG FIXED]
-- ============================================================================
-- UI, DifficultyRank, lastCachedMap moved to Header

local function resetEnemiesList()
    isUpdatingUI = true
    
    -- Pastikan PlayerData terupdate
    if not getgenv().PlayerData or not getgenv().PlayerData.Map then ScanPlayerData() end
    local PlayerData = getgenv().PlayerData
    if PlayerData and PlayerData.Map == nil then
        ScanPlayerData()
        PlayerData = getgenv().PlayerData
    end

    local currentNames = {}
    local nameSet = {}
    local CurrentMapName = PlayerData.Map or "Unknown"

    if PlayerData and PlayerData.Map then
        local success, AllEnemiesDB = pcall(function() return require(ReplicatedStorage.Shared.Enemies) end)

        if success and AllEnemiesDB and AllEnemiesDB[CurrentMapName] then
            local MapEnemies = AllEnemiesDB[CurrentMapName]
            for enemyName, enemyData in pairs(MapEnemies) do
                if type(enemyName) == "string" and enemyName ~= "" and not nameSet[enemyName] then
                    nameSet[enemyName] = true
                    local diff = enemyData.Difficult or "Unknown"
                    local hp = enemyData.Health or "?"
                    local rank = DifficultyRank[diff] or 99
                    
                    local iconAsset = CharacterIcons[enemyName] or nil
                    local processedDrops = {}
                    if enemyData.Drops then processedDrops = table.clone(enemyData.Drops) end
                    local dropIcons = {}

                    for _, drop in ipairs(processedDrops) do
                        if drop.Item then
                            local iconFound = nil
                            local ResultItem = nil
                            if drop.Type == "Avatar" then
                                local avatarData = GlobalAvatarDB[drop.Item]
                                ResultItem = avatarData
                                if avatarData then iconFound = avatarData.Icon end
                            elseif drop.Type == "Sword" then
                                local swordData = GlobalSwordDB[drop.Item]
                                ResultItem = swordData
                                if swordData then iconFound = swordData.Icon end
                            else
                                local itemData = GlobalItemDB[drop.Item]
                                ResultItem = itemData
                                if itemData then iconFound = itemData.Icon end
                            end
                            if iconFound and ResultItem then
                                local Colors
                                local DropCount
                                -- [FIX] GlobalGradientDB.GetRarityColor requires 2 arguments (self, rarity) to access upvalues correctly
                                if GlobalGradientDB and GlobalGradientDB.GetRarityColor then
                                     Colors = GlobalGradientDB:GetRarityColor(ResultItem.Rarity)
                                end
                                
                                if Colors and type(Colors) == "table" and Colors.Base and Colors.Wave then
                                    if drop.Minimum == drop.Maximum then
                                        DropCount = drop.Minimum .. "x"
                                    else
                                        DropCount = drop.Minimum .. "x-" .. FormatNumber(drop.Maximum) .. "x"
                                    end
                                    table.insert(dropIcons, {
                                        Card = true,
                                        Rate = drop.Chance .. "%",
                                        Title = drop.Item,
                                        Quantity = DropCount,
                                        Image = iconFound,
                                        Gradient = ColorSequence.new{
                                            ColorSequenceKeypoint.new(0, Colors.Base),
                                            ColorSequenceKeypoint.new(1, Colors.Wave)
                                        }
                                    })
                                end
                            end
                        end
                    end
                    -- [TAMBAHAN BARU] Hitung Gradient Berdasarkan Difficulty
                    local rarityMap = {
                        [1] = "Common", [2] = "Uncommon", [3] = "Rare", 
                        [4] = "Epic", [5] = "Legendary", [6] = "Mythical", [7] = "Scarlet"
                    }
                    -- Mapping Rank (1-7) ke nama Rarity game
                    local rarityStr = rarityMap[rank] or "Common"
                    local enemyGradient = nil

                    if GlobalGradientDB and GlobalGradientDB.GetRarityColor then
                         -- Mengambil warna dari database game
                         local eColors = GlobalGradientDB:GetRarityColor(rarityStr)
                         if eColors and eColors.Base and eColors.Wave then
                             enemyGradient = ColorSequence.new{
                                ColorSequenceKeypoint.new(0, eColors.Base),
                                ColorSequenceKeypoint.new(1, eColors.Wave)
                            }
                         end
                    end

                    local descStr = "HP: " .. tostring(hp)
                    table.insert(currentNames, {
                        Title = enemyName .. " [" .. diff .. "]",
                        Desc = descStr,
                        Value = enemyName, 
                        Rank = rank,
                        Icon = iconAsset,
                        Images = dropIcons,
                        Gradient = enemyGradient -- <--- Tambahkan ini!
                    })
                end
            end
        else
            ScanPlayerData() 
        end
        
        table.sort(currentNames, function(a, b)
            if a.Rank == b.Rank then return a.Value < b.Value end
            return a.Rank < b.Rank 
        end)
        
        table.clear(nameList)
        for _, v in ipairs(currentNames) do table.insert(nameList, v) end
        
        -- [FIX PERMANEN: DIRECT VALUE SETTING]
        -- Kita set targetnya DULUAN sebelum Refresh, jadi tidak perlu panggil Select()
        if UI.EnemyDD then
            task.spawn(function()
                local savedEnemy = MapSelections[CurrentMapName]
                local foundItems = {}
                if type(savedEnemy) == "string" then
                    for _, item in ipairs(nameList) do
                        if item.Value == savedEnemy then
                            table.insert(foundItems, item)
                            break
                        end
                    end
                elseif type(savedEnemy) == "table" then
                    for _, name in ipairs(savedEnemy) do
                        for _, item in ipairs(nameList) do
                            if item.Value == name then
                                table.insert(foundItems, item)
                                break
                            end
                        end
                    end
                end

                table.clear(targetList)

                if #foundItems > 0 then
                    for _, item in ipairs(foundItems) do
                        table.insert(targetList, item.Value)
                    end

                    local mainItem = foundItems[1]
                    UI.EnemyDD.Value = foundItems
                    Notify("System", "Auto-Selected: " .. mainItem.Value, "check")

                    if mainItem.Icon then
                        UI.EnemyDD:SetValueImage(mainItem.Icon)
                        UI.EnemyDD:SetDesc(mainItem.Value)
                    end
                else
                    UI.EnemyDD.Value = {}
                    UI.EnemyDD:SetValueImage("rbxassetid://84366761557806")
                    UI.EnemyDD:SetMainImage("rbxassetid://84366761557806")
                end

                pcall(function() 
                    UI.EnemyDD:Refresh(nameList) 
                end)
            end)
        end
    end
    task.wait(0.2)
    isUpdatingUI = false
end
-- ============================================================================
--  BRIDGENET & TELEPORT SYSTEM
-- ============================================================================
local function SmartTeleport(mapName)
    if not mapName or mapName == "None" then return end
    if getgenv().PlayerData and getgenv().PlayerData.Map == mapName then return end

    isTransitioning = true
    ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{"Player", "Teleport", "Teleport", mapName, n = 4}, "\2"})
    
    repeat task.wait(0.5) until not isTransitioning
    task.wait(1.5) 
end

ReplicatedStorage.BridgeNet2.dataRemoteEvent.OnClientEvent:Connect(function(data)
    local events = data["\2"]
    if not events then return end
    for _, event in ipairs(events) do
        if event[1] == "General" and event[2] == "Transition" and event[3] == "Teleport" then isTransitioning = true end
        if event[1] == "Player" and event[2] == "Data" and event[3] == "MassUpdate" then
            local uData = event[4]
            if uData then
                if uData.Map then
                    if not getgenv().PlayerData then getgenv().PlayerData = {} end
                    getgenv().PlayerData.Map = uData.Map
                    task.spawn(function() task.wait(0.5) resetEnemiesList() end)
                    isTransitioning = false
                end
            end
        end
    end
end)

-- ============================================================================
--  FARMING LOGIC (ANTI-FLOAT FIX + LEG DETECTION)
-- ============================================================================

-- Helper: Cek apakah kita sedang di Map Gamemode (Versi Dinamis)
local function IsInGamemode()
    local cm = getgenv().PlayerData and getgenv().PlayerData.Map
    -- Cek apakah map saat ini ada di dalam database GlobalGamemodeDB
    if cm and GlobalGamemodeDB[cm] then
        return true
    end
    return false
end


local function LoadSupremeBossData()
    local path = ReplicatedStorage:WaitForChild("Shared"):FindFirstChild("SupremeBosses")
    if path then
        for _, module in pairs(path:GetChildren()) do
            if module:IsA("ModuleScript") then
                local success, data = pcall(require, module)
                if success then
                    GlobalSupremeBossDB[module.Name] = data
                end
            end
        end
    end
end
LoadSupremeBossData()

-- [HELPER] Cek ketersediaan material Supreme Boss
local function HasSupremeMaterials()
    if not selectedSupremeBoss or not GlobalSupremeBossDB[selectedSupremeBoss] then return false end
    
    local pData = getgenv().PlayerData
    local data = GlobalSupremeBossDB[selectedSupremeBoss]
    local diffData = data.Difficulties[selectedSupremeDiff]
    
    if pData and diffData then
        local priceItem = data.Price.Item
        local myBalance = (pData.Items and pData.Items[priceItem]) or 0
        return myBalance >= diffData.Price
    end
    return false
end

-- [HELPER] Pengecekan Status Boss & Material yang Aman
local function GetSupremeStatus()
    local pData = getgenv().PlayerData
    if not isAutoSupreme or not pData or not selectedSupremeBoss then return false, false end
    
    -- 1. Pengecekan Path Folder secara Aman (Mencegah Error nil)
    local server = workspace:FindFirstChild("Server")
    local enemies = server and server:FindFirstChild("Enemies")
    local gamemodes = enemies and enemies:FindFirstChild("Gamemodes")
    local supremeFolder = gamemodes and gamemodes:FindFirstChild("SupremeBosses")
    
    -- Boss dianggap hidup jika folder ada DAN ada model musuh di dalamnya
    local isBossAlive = false
    if supremeFolder then
        local children = supremeFolder:GetChildren()
        if #children > 0 then
            isBossAlive = true
        end
    end
    
    -- 2. Pengecekan Material
    local hasMaterials = false
    local data = GlobalSupremeBossDB[selectedSupremeBoss]
    local diffData = data and data.Difficulties[selectedSupremeDiff]
    if data and diffData then
        local priceItem = data.Price.Item
        local myBalance = (pData.Items and pData.Items[priceItem]) or 0
        hasMaterials = myBalance >= diffData.Price
    end
    
    return isBossAlive, hasMaterials
end
-- ============================================================================
--  FARMING LOGIC (SERVER SIDE PARTS + CFRAME) [UPDATED: ANTI-FLOAT]
-- ============================================================================

local function FarmServerEnemies()
    local pData = getgenv().PlayerData
    local currentMap = pData and pData.Map
    
    if not currentMap or not hrp or #targetList == 0 then return end
    
    local WorldFolder = workspace:FindFirstChild("Server") and workspace.Server:FindFirstChild("Enemies") and workspace.Server.Enemies:FindFirstChild("World")
    if not WorldFolder then return end

    local MapFolder = WorldFolder:FindFirstChild(currentMap)
    if not MapFolder then return end

    local ATTACK_DISTANCE = 5 

    for _, mob in pairs(MapFolder:GetChildren()) do
        local isTarget = false
        for _, name in ipairs(targetList) do
            if mob.Name == name then
                isTarget = true
                break
            end
        end
        if isTarget then
            local myHip = humanoid.HipHeight
            if myHip < 1.5 then myHip = 2 end
            local myHeightFromGround = myHip + (hrp.Size.Y / 2)

            while not Window.Destroyed do
                if (mob:GetAttribute("Health") or 0) <= 0 then
                    break 
                end
                
                if not isFarm1 or isGlobalBossActive or isTransitioning or IsInGamemode() then break end
                if not hrp or not humanoid or humanoid.Health <= 0 then break end

                local targetCFrame = nil
                if mob:IsA("BasePart") then
                    targetCFrame = mob.CFrame
                elseif mob:IsA("Model") then
                    targetCFrame = mob:GetPivot()
                end

                if targetCFrame then
                    local enemyFloorY = targetCFrame.Y 
                    
                    if mob:IsA("BasePart") then
                        enemyFloorY = targetCFrame.Y - (mob.Size.Y / 2)
                    elseif mob:IsA("Model") then
                        local leg = mob:FindFirstChild("Left Leg") or mob:FindFirstChild("Right Leg") or 
                                    mob:FindFirstChild("LeftFoot") or mob:FindFirstChild("RightFoot") or
                                    mob:FindFirstChild("LeftLowerLeg") or mob:FindFirstChild("RightLowerLeg")
                        if leg then
                            enemyFloorY = leg.Position.Y - (leg.Size.Y / 2)
                        else
                            local _, size = mob:GetBoundingBox()
                            enemyFloorY = targetCFrame.Y - (size.Y / 2)
                        end
                    end

                    local finalY = enemyFloorY + myHeightFromGround

                    local backPos = targetCFrame * CFrame.new(0, 0, ATTACK_DISTANCE)
                    
                    local attackPos = Vector3.new(backPos.X, finalY, backPos.Z)
                    
                    local lookAtPos = Vector3.new(targetCFrame.X, finalY, targetCFrame.Z)
                    
                    hrp.CFrame = CFrame.new(attackPos, lookAtPos)
                end
                
                task.wait()
            end
        end
    end
end


-- [HELPER] Fungsi untuk mendapatkan folder target berdasarkan Map
local function GetTargetFolder(mapName)
    if not mapName then return nil end
    
    -- Path dasar: workspace.Server.Enemies.Gamemodes
    local server = workspace:FindFirstChild("Server")
    local enemies = server and server:FindFirstChild("Enemies")
    local gamemodes = enemies and enemies:FindFirstChild("Gamemodes")
    
    if gamemodes then
        return gamemodes:FindFirstChild(mapName)
    end
    return nil
end

local function IsSwordsmanActive()
    local folder = GetTargetFolder("SwordsmanInvasion")
    if folder then
        local settings = GamemodeSettings["SwordsmanInvasion"]
        local filterName = settings.IgnoreEnemy
        
        local validCount = 0
        for _, enemy in pairs(folder:GetChildren()) do
            if enemy.Name ~= filterName then -- Gunakan variable
                validCount = validCount + 1
            end
        end
        
        return settings and settings.Active and validCount > 0
    end
    return false
end
-- Loop Utama Eksekusi Farm
task.spawn(function()
    while not Window.Destroyed do
        -- Cari baris ini:
        local isBossStillThere, canSpawnNew = GetSupremeStatus()
        local shouldFocusSupreme = isAutoSupreme and (isBossStillThere or canSpawnNew)

        -- Ganti baris pengecekan isFarm1 menjadi:
        if isFarm1 and not isGlobalBossActive and not isTransitioning and not IsInGamemode() and not IsSwordsmanActive() and not shouldFocusSupreme then
            FarmServerEnemies()
        end
        task.wait(0.1)
    end
end)

-- ============================================================================
--  CHAT LISTENER (BOSS HUNT & DROP WEBHOOK CLEANER)
-- ============================================================================
-- [CHAT EVENT SYSTEM]

-- Helper: Membersihkan format teks (HTML tags) dari chat
local function CleanRichText(str)
    return string.gsub(str, "<[^>]+>", "")
end

local function SendChatDropWebhook(finalText)
    SendWebhook("🎁 Item/Pet Drop Notification", finalText, 16763904)
end

-- ============================================================================
--  GAMEMODES LOGIC (FINAL: KEY PRIORITY + CHAT BROADCAST + ANTI-FLOAT)
-- ============================================================================

-- [HELPER] Kirim Signal Gamemode
local function FireGamemode(modeName, action)
    if ReplicatedStorage:FindFirstChild("BridgeNet2") then
        ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
            {"Gamemodes", modeName, action, n = 3}, 
            "\2"
        })
    end
end

-- [HELPER BARU] Cek Wave Saat Ini (Universal Scanner)
-- Fungsi ini otomatis mencari UI Gamemode apapun yang sedang muncul di layar
local function GetCurrentWave()
    local pGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    local hud = pGui and pGui:FindFirstChild("Interface") and pGui.Interface:FindFirstChild("HUD")
    
    -- Cek Folder Gamemodes
    local container = hud and hud:FindFirstChild("Gamemodes")
    if not container then return 0 end

    -- Loop semua anak folder Gamemodes
    for _, frame in pairs(container:GetChildren()) do
        if frame:IsA("Frame") and frame.Visible then
            -- Cek apakah ada TextLabel Wave di dalamnya
            local bg = frame:FindFirstChild("Background")
            local waveLbl = bg and bg:FindFirstChild("Wave")
            
            if waveLbl and waveLbl:IsA("TextLabel") then
                -- Ambil angka dari teks (misal "Wave 36" -> 36)
                local num = tonumber(string.match(waveLbl.Text, "%d+"))
                if num then 
                    return num 
                end
            end
        end
    end
    
    return 0 -- Kembalikan 0 jika tidak ada UI wave yang muncul
end

-- [KONFIGURASI JARAK & OFFSET]
local ATTACK_DISTANCE = 5      -- Jarak mundur dari musuh (Z axis)
local HOVER_HEIGHT = 1         -- Tinggi tambahan di atas kepala musuh
local DEAD_CHECK_RADIUS = 5    -- Radius cek kematian di EnemiesData

-- [HELPER] Fungsi untuk mendapatkan CFrame Target (Model/Part)
local function GetTargetCFrame(instance)
    if instance:IsA("BasePart") then
        return instance.CFrame
    elseif instance:IsA("Model") then
        return instance:GetPivot()
    end
    return nil
end

-- [GAMEMODE KILLER - ANTI FLOAT / NAPAK TANAH FIX]
local function GamemodeKiller(stopCheckFunc, overrideMapName)
    -- Inisialisasi
    local currentMap = overrideMapName or (getgenv().PlayerData and getgenv().PlayerData.Map)
    local serverFolder = GetTargetFolder(currentMap)

    if not serverFolder then 
        task.wait(1)
        return 
    end

    while not Window.Destroyed do
        if not stopCheckFunc() or isTransitioning then break end

        -- Optimasi: Cek jumlah anak folder sebelum loop
        local children = serverFolder:GetChildren()
        
        if #children == 0 then
            task.wait(0.5) 
        else
            local foundTarget = false

            for _, enemyObj in ipairs(children) do
                if not stopCheckFunc() then break end
                local settings = GamemodeSettings["SwordsmanInvasion"]
                if currentMap == "SwordsmanInvasion" and settings and enemyObj.Name == settings.IgnoreEnemy then
                    continue
                end

                if enemyObj and enemyObj.Parent then
                    -- Ambil Target CFrame (Pusat Badan Musuh)
                    local targetCFrame = GetTargetCFrame(enemyObj)
                    
                    if targetCFrame then 
                        foundTarget = true

                        -- [LOGIKA BARU: POSISI Y (TINGGI)]
                        -- Hitung tinggi badan kita (Jarak dari tanah ke pusat badan kita)
                        local myHip = humanoid.HipHeight
                        if myHip < 1.5 then myHip = 2 end -- Default R6/R15 jika 0
                        local myHeightFromGround = myHip + (hrp.Size.Y / 2)

                        -- Loop Attack
                        while enemyObj and enemyObj.Parent and not Window.Destroyed do
                            if not stopCheckFunc() then break end
                            if not hrp or not humanoid or humanoid.Health <= 0 then break end

                            targetCFrame = GetTargetCFrame(enemyObj)
                            if not targetCFrame then break end

                            -- 1. Cari Lantai Musuh (Bukan Pusat Badan)
                            local enemyFloorY = targetCFrame.Y -- Fallback default (dikurangi setengah tinggi badan rata-rata)

                            -- Coba cari kaki musuh untuk akurasi 100%
                            local leg = enemyObj:FindFirstChild("Left Leg") or enemyObj:FindFirstChild("Right Leg") or 
                                        enemyObj:FindFirstChild("LeftFoot") or enemyObj:FindFirstChild("RightFoot") or
                                        enemyObj:FindFirstChild("LeftLowerLeg") or enemyObj:FindFirstChild("RightLowerLeg")
                            
                            if leg then
                                -- Posisi Kaki - Setengah Tinggi Kaki = Lantai Tanah Pas
                                enemyFloorY = leg.Position.Y - (leg.Size.Y / 2)
                            end

                            -- 2. Tentukan Posisi Berdiri Kita (Lantai Musuh + Tinggi Badan Kita)
                            local finalY = enemyFloorY + myHeightFromGround

                            -- 3. Posisi X/Z (Mundur ke belakang musuh)
                            -- Mengambil posisi di belakang musuh sejauh ATTACK_DISTANCE
                            local backPos = targetCFrame * CFrame.new(0, 0, ATTACK_DISTANCE)
                            
                            -- Gabungkan: X/Z Belakang, Y Sesuai Tanah
                            local attackPos = Vector3.new(backPos.X, finalY, backPos.Z)

                            -- 4. Teleport
                            -- Posisi: attackPos
                            -- Hadap: targetCFrame.Position (Agar karakter menghadap musuh)
                            -- Kita kunci Y hadapnya agar kamera tidak mendongak/nunduk berlebihan
                            local lookAtPos = Vector3.new(targetCFrame.X, finalY, targetCFrame.Z)
                            hrp.CFrame = CFrame.new(attackPos, lookAtPos)

                            -- Cek Mati
                            local isDead = false
                            if (enemyObj:GetAttribute("Health") or 0) <= 0 then
                                isDead = true
                                break 
                            end

                            if isDead then break end
                            task.wait(0.5) 
                        end
                    end
                end
            end            
            task.wait(0.5)
        end
    end
end

-- ============================================================================
--  DYNAMIC GAMEMODE SYSTEM (ENGLISH VERSION)
-- ============================================================================

-- [1] DATA INITIALIZATION
SelectedGamemodeName = "TrialEasy"

-- Load Gamemode Database
local function LoadGamemodeDB()
    local success, result = pcall(function() return require(ReplicatedStorage.Shared.Gamemodes) end)
    if success and type(result) == "table" then
        GlobalGamemodeDB = result
        
        -- Initialize Default Settings
        for modeName, data in pairs(GlobalGamemodeDB) do
            GamemodeSettings[modeName] = {
                Active = false,
                TargetWave = (data.MaxWave or 50),
                UseKey = false, -- Toggle for item trigger
                Priority = (modeName == "TrialEasy") -- Priority for Trial
            }
        end
    end
end
LoadGamemodeDB()

-- Ubah bagian inisialisasi SwordsmanInvasion menjadi seperti ini:
if not GamemodeSettings["SwordsmanInvasion"] then
    GamemodeSettings["SwordsmanInvasion"] = {
        Active = false,
        UseKey = false,
        Priority = false,
        IgnoreEnemy = "" -- Nilai default
    }
end
if not GlobalGamemodeDB["SwordsmanInvasion"] then
    GlobalGamemodeDB["SwordsmanInvasion"] = {
        DisplayName = "Swordsman Invasion",
        MaxWave = 9999
    }
end

-- [SAVE SYSTEM] GAMEMODE CONFIG
local GamemodeConfigFile = FolderPath .. "/GamemodeSettings.json"

local function SaveGMSettings()
    if not isfolder(FolderPath) then makefolder(FolderPath) end
    
    -- Kita bungkus data settings DAN pilihan terakhir dalam satu tabel
    local dataToSave = {
        Settings = GamemodeSettings,
        LastMode = SelectedGamemodeName -- Simpan mode yang sedang dipilih
    }
    
    local success, encoded = pcall(function() return HttpService:JSONEncode(dataToSave) end)
    if success then
        writefile(GamemodeConfigFile, encoded)
    end
end

local function LoadGMSettings()
    if isfile(GamemodeConfigFile) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(GamemodeConfigFile)) end)
        if success and type(decoded) == "table" then
            
            -- Load Settings (Merge)
            -- Cek apakah format lama (langsung tabel settings) atau format baru (ada key .Settings)
            local sourceSettings = decoded.Settings or decoded 

            for mode, settings in pairs(sourceSettings) do
                if GamemodeSettings[mode] then
                    if settings.Active ~= nil then GamemodeSettings[mode].Active = settings.Active end
                    if settings.TargetWave ~= nil then GamemodeSettings[mode].TargetWave = settings.TargetWave end
                    if settings.UseKey ~= nil then GamemodeSettings[mode].UseKey = settings.UseKey end
                end
            end
            
            -- Load Last Selected Mode (Jika ada)
            if decoded.LastMode and GlobalGamemodeDB[decoded.LastMode] then
                SelectedGamemodeName = decoded.LastMode
            end
        end
    end
end

-- Panggil Load SETELAH Database Game dimuat
LoadGMSettings()

-- Helper: Check Time Window (Specific for Trials)
local function IsTimeForTrial(modeName)
    local data = GlobalGamemodeDB[modeName]
    if not data then return false end
    
    local t = os.date("*t")
    local m = t.min
    
    -- Jadwal untuk Trial Easy (Menit 15 & 45)
    if modeName == "TrialEasy" then
        return (m >= 15 and m < 16) or (m >= 45 and m < 46)
    
    -- Jadwal BARU untuk Christmas Trial (Menit 05 & 35)
    elseif modeName == "ChristmasTrial" then
        return (m >= 5 and m < 6) or (m >= 35 and m < 36)
    end
    
    return false
end

local function IsTimeForSwordsman()
    local t = os.date("*t")
    local m = t.min
    local s = t.sec
    if (m == 0 or m == 30) and s < 10 then
        return true, string.format("%02d:%02d", t.hour, m)
    end
    return false, nil
end

local SwordsmanStartTime = nil
local SwordsmanLastTriggerKey = nil

-- [2] MAIN GAMEMODE LOOP (FIXED: DYNAMIC TARGET WAVE & REGISTER OPTIMIZATION)
task.spawn(function()
    while not Window.Destroyed do
        -- Gunakan variabel dari scope luar/tabel untuk menghemat register
        local detectedWave = GetCurrentWave()
        local pData = getgenv().PlayerData
        local currentMap = pData and pData.Map
        local isBusy = isGlobalBossActive or isTransitioning 
        
        for modeName, settings in pairs(GamemodeSettings) do
            -- Hanya proses jika mode aktif dan bukan Swordsman (Swordsman punya loop sendiri)
            if settings.Active and modeName ~= "SwordsmanInvasion" then
                
                -- KONDISI A: SEDANG DI DALAM GAMEMODE (Logic Exit)
                if currentMap == modeName then
                    -- PERBAIKAN: Jangan buat 'local targetWave', langsung panggil settings.TargetWave
                    -- Agar jika UI berubah, nilainya langsung terdeteksi di sini.
                    
                    if detectedWave >= (settings.TargetWave or 0) and detectedWave > 0 then
                        -- Jika savedPreviousMap kosong (misal join manual), set default ke Global
                        if not savedPreviousMap or savedPreviousMap == "None" then
                            savedPreviousMap = "Global"
                        end

                        Notify(modeName, "Target Reached ("..detectedWave..")! Leaving...", "check")
                        isTransitioning = false 
                        SmartTeleport(savedPreviousMap)
                        savedPreviousMap = nil 
                    else
                        -- Jalankan Killer dengan pengecekan dinamis
                        GamemodeKiller(function()
                            -- Cek status langsung dari tabel 'settings' agar selalu up-to-date
                            local liveWave = GetCurrentWave()
                            return settings.Active 
                                and (getgenv().PlayerData.Map == modeName) 
                                and (liveWave < (settings.TargetWave or 999))
                        end)
                    end

                -- KONDISI B: DI LOBBY (SIAP JOIN)
                elseif not isBusy and currentMap ~= "None" and currentMap ~= "Loading" and not IsInGamemode() then
                    -- Logika Join tetap sama...
                    local canJoin = false
                    local joinReason = ""
                    
                    if ActiveEventsFromChat[modeName] then
                        canJoin = true
                        joinReason = "Event Started (Chat)"
                    elseif GlobalGamemodeDB[modeName] and GlobalGamemodeDB[modeName].Item and settings.UseKey then
                        local keyName = GlobalGamemodeDB[modeName].Item
                        if (pData.Items and pData.Items[keyName] or 0) > 0 then 
                            canJoin = true; joinReason = "Item: " .. keyName 
                        end
                    elseif IsTimeForTrial(modeName) then
                        canJoin = true; joinReason = "Time Window"
                    elseif GlobalGamemodeDB[modeName] and not GlobalGamemodeDB[modeName].Item and not GlobalGamemodeDB[modeName].EnterTime then
                        canJoin = true; joinReason = "Auto Join"
                    end

                    if canJoin then
                        if currentMap ~= modeName and currentMap ~= "Trial Lobby" then savedPreviousMap = currentMap end
                        Notify(modeName, "Joining via " .. joinReason, "swords")
                        FireGamemode(modeName, "Join")
                        if ActiveEventsFromChat[modeName] then ActiveEventsFromChat[modeName] = nil end
                        task.wait(5)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    local requiredMap = "World of Aincrad"
    
    -- Helper internal untuk menghitung musuh aktif
    local function GetValidSwordsmanEnemies()
        local folder = GetTargetFolder("SwordsmanInvasion")
        if not folder then return 0 end
        
        local settings = GamemodeSettings["SwordsmanInvasion"]
        local filterName = settings.IgnoreEnemy
        
        local count = 0
        for _, v in ipairs(folder:GetChildren()) do
            if v.Name ~= filterName then -- Gunakan variable
                count = count + 1 
            end
        end
        return count
    end

    while not Window.Destroyed do
        local settings = GamemodeSettings["SwordsmanInvasion"]
        if settings and settings.Active and not isTransitioning and not isGlobalBossActive then
            local pData = getgenv().PlayerData
            local currentMap = pData and pData.Map
            local validEnemies = GetValidSwordsmanEnemies()
            local chatTrigger = ActiveEventsFromChat["SwordsmanInvasion"] -- Cek notifikasi chat

            -- [FASE 1: EKSEKUSI PEMBANTAIAN]
            if validEnemies > 0 then
                if not SwordsmanStartTime then
                    SwordsmanStartTime = os.time()
                end

                -- Teleport ke lokasi invasi jika belum di sana
                if currentMap ~= requiredMap and currentMap ~= "None" and currentMap ~= "Loading" then
                    if not savedPreviousMap or savedPreviousMap == "None" then
                        savedPreviousMap = currentMap
                    end
                    SmartTeleport(requiredMap)
                end

                -- Jalankan pembasmi musuh (GamemodeKiller)
                GamemodeKiller(function()
                    local aliveCount = GetValidSwordsmanEnemies()
                    local elapsed = SwordsmanStartTime and (os.time() - SwordsmanStartTime) or 0
                    return settings.Active and aliveCount > 0 and elapsed < 50 and not isTransitioning
                end, "SwordsmanInvasion")
            end

            -- [FASE 2: LOGIKA PULANG OTOMATIS]
            -- Jika musuh habis (tersisa Kiito) dan posisi di map invasi
            if validEnemies == 0 and currentMap == requiredMap then
                if savedPreviousMap and savedPreviousMap ~= "None" and savedPreviousMap ~= requiredMap then
                    Notify("SwordsmanInvasion", "Invasion cleared, returning home.", "check")
                    isTransitioning = false
                    SmartTeleport(savedPreviousMap)
                    savedPreviousMap = nil -- Reset tujuan pulang agar tidak loop
                end
                SwordsmanStartTime = nil
            end

            -- [FASE 3: DETEKSI PEMICU JOIN (TIME / CHAT)]
            local ok, key = IsTimeForSwordsman() -- Cek jadwal menit 00/30
            
            if (ok or chatTrigger) and currentMap and currentMap ~= "None" and currentMap ~= "Loading" then
                -- Cegah teleportasi berulang untuk pemicu yang sama
                if SwordsmanLastTriggerKey ~= (key or "Chat") then
                    if currentMap ~= requiredMap then
                        savedPreviousMap = currentMap
                        Notify("SwordsmanInvasion", "Joining Invasion via Notification!", "map")
                        SmartTeleport(requiredMap)
                    end
                    SwordsmanLastTriggerKey = (key or "Chat")
                    -- Reset flag chat trigger setelah berhasil digunakan
                    ActiveEventsFromChat["SwordsmanInvasion"] = nil
                end
            elseif not ok and not chatTrigger then
                SwordsmanLastTriggerKey = nil
            end
        else
            SwordsmanStartTime = nil
        end
        task.wait(1) -- Delay 1 detik untuk optimasi CPU
    end
end)

-- [UPDATED GACHA LOGIC WITH DYNAMIC CHECK & BALANCE PROTECTION]
local function changePower(name, value)
    for _, power in pairs(powerList) do
        if power.Name == name then
            power.auto = value
            return
        end
    end
end

task.spawn(function()
    while not Window.Destroyed do
        if isRankUp == true and getgenv().PlayerData and GlobalRankDB then
            local pData = getgenv().PlayerData
            local nextRank = (pData.Rank or 0) + 1
            local nextData = GlobalRankDB[nextRank]
            if nextData then
                local reqPower = ParseAbbreviated(nextData.Power)
                local curPower = pData.Power or 0 
                if curPower >= reqPower then
                    ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{"General", "RankUp", "RankUp", n = 10}, "\2"})
                end
            end
        end
        task.wait(0.5) 
    end
end)

-- [UI INTERFACE]

-- Mengambil Icon Game secara otomatis menggunakan GameId
local GameIconURL = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150"

local BaseProfile = {
    Banner = "rbxassetid://124762019485618", 
    Avatar = "rbxassetid://84366761557806", -- << Bagian ini sudah diganti
    Status = true, 
    Badges = {
        {
            Icon = "geist:logo-discord", 
            Callback = function() 
                setclipboard("https://discord.gg/bUkCZvmrpH") 
                Notify("Discord", "Copied!", "geist:logo-discord") 
            end
        }, 
        {
            Icon = "youtube", 
            Callback = function() 
                setclipboard("https://www.youtube.com/@ANHubRoblox") 
                Notify("YouTube", "Copied!", "youtube") 
            end
        }
    }
}

local function MakeProfile(data) 
    local p = table.clone(BaseProfile); 
    for k,v in pairs(data or {}) do p[k]=v end 
    return p 
end

Window:Tab({Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Advanced" }), SidebarProfile = true})


do
    -- Update Tag berdasarkan status akses
    if IsPremium then
        Window:Tag({
            Title = "Premium User",
            Icon = "crown",
            Color = Color3.fromHex("#FFD700") -- Warna Emas
        })
        Notify("Welcome!", "Premium Access Verified. Enjoy!", "crown")
    else
        Window:Tag({
            Title = "Free User",
            Icon = "user",
            Color = Color3.fromHex("#FFFFFF") -- Warna Putih
        })
    end
end;

local MainTab = Window:Tab({Title = "Main Feature", Icon = "swords", Profile = MakeProfile({Avatar = GameIconURL,Title = "Game Feature", Desc = "Anime Advanced"}), SidebarProfile = false})

local FM_Categories = {}
local function FM_Add(cat, elem)
    if not FM_Categories[cat] then FM_Categories[cat] = {} end
    table.insert(FM_Categories[cat], elem)
    local f = rawget(elem, "ElementFrame") or (elem.UIElements and elem.UIElements.Main) or elem.GroupFrame
    if f then f.Visible = false end
    return elem
end

local function FM_OnChange(selected)
    for name, elems in pairs(FM_Categories) do
        local vis = (name == selected)
        for _, e in ipairs(elems) do
            local f = rawget(e, "ElementFrame") or (e.UIElements and e.UIElements.Main) or e.GroupFrame
            if f then f.Visible = vis end
        end
    end
end

-- Cari bagian ini di script Anda dan tambahkan baris "Enchant"
local FM_Category = MainTab:Category({
    Title = "Select Category", 
    Default = "Farm",
    Options = {
        {Title="Farm", Icon="sword"},
        {Title="Gamemodes", Icon="hourglass"},
        {Title="Bosses", Icon="skull"},
        {Title="Gacha", Icon="dices"},
        {Title="Gacha Upgrade", Icon="dices"},
        {Title="Avatars", Icon="user"},
        {Title="Merchant", Icon="shopping-cart"}, -- Tambahkan ini di FM_Category Options
        {Title="Global Quests", Icon="scroll"},
        {Title="World Upgrade", Icon="globe"},
        {Title="Trial Upgrades", Icon="zap"},
        {Title="Upgrade Rank", Icon="chevrons-up"},
        {Title="Expedition", Icon="compass"},
        {Title="Runes", Icon="hexagon"}, -- <--- TAMBAHKAN INI (Baris Baru)
        {Title="Enchant", Icon="sparkles"},
        {Title="Stronger", Icon="star"}
    },
    Callback = FM_OnChange
})

if FM_Category.ElementFrame then 
    FM_Category.ElementFrame.Parent = MainTab.UIElements.ContainerFrameCanvas 
    FM_Category.ElementFrame.Position = UDim2.new(0,0,0, MainTab.UIElements.ContainerFrame.Position.Y.Offset)
    
    local catSize = FM_Category.ElementFrame.Size.Y.Offset
    MainTab.UIElements.ContainerFrame.Position = UDim2.new(0,0,0, MainTab.UIElements.ContainerFrame.Position.Y.Offset + catSize)
    MainTab.UIElements.ContainerFrame.Size = UDim2.new(1, 0, 1, MainTab.UIElements.ContainerFrame.Size.Y.Offset - catSize)
    
    local pad = MainTab.UIElements.ContainerFrame:FindFirstChildOfClass("UIPadding")
    if pad then pad.PaddingTop = UDim.new(0, 5) end
end
MainTab:Space({Columns=1})
local FarmToggleUI = nil
-- [1. MEMBUAT DROPDOWN]
UI.EnemyDD = MainTab:Dropdown({
    Title = "Select Enemies", 
    Values = nameList, 
    Multi = true,
    AllowNone = true, 
    Value = nil, 
    Flag = "TargetEnemies_Cfg",
    Image = "rbxassetid://84366761557806", 
    ImageSize = 50, 
    Callback = function(v)
        table.clear(targetList)
        local primaryItem = nil

        if type(v) == "table" then
            for _, item in ipairs(v) do
                local name = (type(item) == "table" and (item.Value or item.Title)) or item
                if name then
                    table.insert(targetList, name)
                    if not primaryItem and type(item) == "table" then
                        primaryItem = item
                    end
                end
            end
        elseif v then
            local name = (type(v) == "table" and (v.Value or v.Title)) or v
            if name then
                table.insert(targetList, name)
            end
            if type(v) == "table" then
                primaryItem = v
            end
        end

        if primaryItem then
            if primaryItem.Icon then
                UI.EnemyDD:SetValueImage(primaryItem.Icon)
                if primaryItem.Gradient then
                    UI.EnemyDD:SetMainImage({Image = primaryItem.Icon, Gradient = primaryItem.Gradient}, 50)
                else
                    UI.EnemyDD:SetMainImage(primaryItem.Icon)
                end
            end
            if not isUpdatingUI and not isTransitioning then
                local currentMap = getgenv().PlayerData and getgenv().PlayerData.Map
                if currentMap then
                    SaveMapSelection(currentMap, table.clone(targetList))
                end
            end
        else
            UI.EnemyDD:SetValueImage("rbxassetid://84366761557806")
            UI.EnemyDD:SetMainImage("rbxassetid://84366761557806")
            if not isUpdatingUI and not isTransitioning then
                local currentMap = getgenv().PlayerData and getgenv().PlayerData.Map
                if currentMap then
                    SaveMapSelection(currentMap, {})
                end
            end
        end
    end
})
FM_Add("Farm", UI.EnemyDD)
FarmToggleUI = MainTab:Toggle({
    Title = "Auto Kill Selected", 
    Flag = "Farm1_Cfg", 
    Callback = function(v) 
        isFarm1 = v 
    end
})
FM_Add("Farm", FarmToggleUI)
isAutoFruit = false
-- [ADMIN FEATURE: AUTO FRUIT - PREMIUM ONLY]
local FruitToggle = MainTab:Toggle({
    Title = "Auto Pick Fruits " .. (not IsPremium and "[PREMIUM]" or ""),
    Desc = IsPremium and "Auto Teleport & Pick Fruits (Admin Map Only)" or "🔒 Feature For User Premium!",
    Flag = "AutoFruit_Admin_Cfg",
    Callback = function(v)
        if not IsPremium then
            Notify("Access Denied", "Fitur ini hanya untuk User Premium!", "lock")
            return 
        end
        isAutoFruit = v
    end
})

-- Jika bukan premium, kunci tombolnya agar tidak bisa diklik
if not IsPremium then
    FruitToggle:Lock()
end

FM_Add("Farm", FruitToggle)
-- [REVISED LOGIC: AUTO FRUIT PICKER]
-- [REVISED LOGIC: AUTO FRUIT PICKER]
task.spawn(function()
    while not Window.Destroyed do
        -- Tambahkan 'IsPremium' ke dalam pengecekan IF
        if isAutoFruit and IsPremium then 
            local pData = getgenv().PlayerData
            if pData and pData.Map == "Admin Map" then
                local fruitFolder = workspace:FindFirstChild("Server") 
                    and workspace.Server:FindFirstChild("AdminAbuse") 
                    and workspace.Server.AdminAbuse:FindFirstChild("Fruits")

                if fruitFolder then
                    for _, fruitPart in ipairs(fruitFolder:GetChildren()) do
                        -- Safety check lagi di dalam loop
                        if not isAutoFruit or not IsPremium or pData.Map ~= "Admin Map" then break end
                        
                        if fruitPart:IsA("BasePart") then
                            if hrp then
                                hrp.CFrame = fruitPart.CFrame
                                task.wait(0.2)

                                local prompt = nil
                                for _, child in ipairs(fruitPart:GetDescendants()) do
                                    if child:IsA("ProximityPrompt") then
                                        prompt = child
                                        break
                                    end
                                end
                                
                                if prompt then
                                    prompt.HoldDuration = 0
                                    fireproximityprompt(prompt)
                                    
                                    task.spawn(function()
                                        prompt:InputHoldBegin()
                                        task.wait(0.1)
                                        prompt:InputHoldEnd()
                                    end)
                                    task.wait(0.3)
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)
-- ============================================================================
-- [PATCH FIX] MENGATASI ERROR "missing method SetDesc"
-- ============================================================================
-- Kita menyuntikkan fungsi SetDesc ke dalam internal handler dropdown
if UI.EnemyDD and UI.EnemyDD.DropdownMenu then
    function UI.EnemyDD.DropdownMenu:SetDesc(text)
        -- Teruskan perintah ke objek utama Dropdown
        UI.EnemyDD:SetDesc(text)
    end
end
-- ============================================================================

-- [2. LOOP LIVE ENEMY COUNTER]
task.spawn(function()
    while not Window.Destroyed do
        -- Pastikan Dropdown sudah ada dan Map valid
        if UI.EnemyDD and UI.EnemyDD.Values and getgenv().PlayerData and getgenv().PlayerData.Map then
            local currentMap = getgenv().PlayerData.Map
            
            -- Scan Jumlah Musuh di Workspace (Real-time)
            local enemyCounts = {}
            local worldFolder = workspace:FindFirstChild("Server") 
                and workspace.Server:FindFirstChild("Enemies") 
                and workspace.Server.Enemies:FindFirstChild("World") 
                and workspace.Server.Enemies.World:FindFirstChild(currentMap)
            
            if worldFolder then
                for _, mob in pairs(worldFolder:GetChildren()) do
                    local isAlive = false
                    -- Cek HP (Attribute Health)
                    local hp = mob:GetAttribute("Health")
                    if hp and hp > 0 then
                        isAlive = true
                    elseif not hp then
                        -- Fallback jika attribute Health belum load
                        if mob:IsA("BasePart") then 
                            isAlive = true 
                        elseif mob:IsA("Model") and mob:FindFirstChild("Head") then 
                            isAlive = true
                        end
                    end

                    if isAlive then
                        enemyCounts[mob.Name] = (enemyCounts[mob.Name] or 0) + 1
                    end
                end
            end

            -- Update Deskripsi Dropdown
            for i, itemData in ipairs(UI.EnemyDD.Values) do
                local enemyName = (type(itemData) == "table" and itemData.Value) or itemData
                local liveCount = enemyCounts[enemyName] or 0
                
                -- Ambil Deskripsi Lama untuk mempertahankan info HP
                local currentDesc = (type(itemData) == "table" and itemData.Desc) or ""
                
                -- Ambil bagian HP saja (sebelum tanda "| Alive:")
                local baseHP = string.match(currentDesc, "^(HP:.-) |") or string.match(currentDesc, "^(HP:.-)$") 
                if not baseHP then baseHP = currentDesc end 
                if baseHP == "" then baseHP = "Status: Check" end

                local newDesc = baseHP .. " | Alive: " .. liveCount
                
                -- Edit Dropdown (Hanya jika teks berubah)
                -- OPTIMASI FPS: Cek apakah nilai benar-benar berubah sebelum memanggil fungsi UI
                if currentDesc ~= newDesc then
                    UI.EnemyDD:EditDrop(i, {
                        Desc = newDesc
                    })
                end
            end
        end
        
        task.wait(1) 
    end
end)

-- PATCH OPTIMASI FUNGSI UI (SetDesc, SetTitle, SetMainImage)
-- Kita bungkus fungsi asli dengan pengecekan state (Cache) agar tidak memicu re-render jika data sama
if UI.EnemyDD then
    local oldSetMainImage = UI.EnemyDD.SetMainImage
    local lastMainImage = nil
    
    UI.EnemyDD.SetMainImage = function(self, imageInfo, size)
        -- Jika input sama persis dengan cache, batalkan update
        -- Note: Kita perlu handling tipe data table vs string
        local isSame = false
        if type(imageInfo) == "table" and type(lastMainImage) == "table" then
             if imageInfo.Image == lastMainImage.Image and imageInfo.Gradient == lastMainImage.Gradient then
                 isSame = true
             end
        elseif imageInfo == lastMainImage then
             isSame = true
        end
        
        if isSame then return end -- SKIP UPDATE
        
        lastMainImage = imageInfo
        if oldSetMainImage then oldSetMainImage(self, imageInfo, size) end
    end
    
    local oldSetValueImage = UI.EnemyDD.SetValueImage
    local lastValueImage = nil
    
    UI.EnemyDD.SetValueImage = function(self, img)
        if img == lastValueImage then return end
        lastValueImage = img
        if oldSetValueImage then oldSetValueImage(self, img) end
    end
end

-- BOSSES
MapList = {"None"}
task.spawn(function()
    local added = {}
    for _, data in pairs(GlobalBossDB) do
        local map = data.Map
        if map and not added[map] then
            table.insert(MapList, map)
            added[map] = true
        end
    end
end)

table.clear(BossListData)

-- Loop Boss Database
for name, data in pairs(GlobalBossDB) do
    local bossDropIcons = {}
    
    -- Proses Drops agar tampil sebagai CARD (Ada Gradient, Rate, dll)
    
    -- Ambil Map Index untuk Sorting (Agar rapi per Map)
    local mapIndex = 999
    local mapName = data.Map or "Unknown"
    if GlobalMapDB and GlobalMapDB[mapName] then
        mapIndex = GlobalMapDB[mapName].Index or 999
    end
    local rarityMap = {
        [1] = "Common", [2] = "Uncommon", [3] = "Rare", 
        [4] = "Epic", [5] = "Legendary", [6] = "Mythical", [7] = "Scarlet"
    }
    if data.Drops then
        for _, drop in ipairs(data.Drops) do
            if drop.Item then
                local iconFound = nil
                local ResultItem = nil

                -- 1. Deteksi Tipe Item & Ambil Data Global
                if drop.Type == "Avatar" then
                    local avatarData = GlobalAvatarDB[drop.Item]
                    ResultItem = avatarData
                    if avatarData then iconFound = avatarData.Icon end
                elseif drop.Type == "Sword" then
                    local swordData = GlobalSwordDB[drop.Item]
                    ResultItem = swordData
                    if swordData then iconFound = swordData.Icon end
                else
                    local itemData = GlobalItemDB[drop.Item]
                    ResultItem = itemData
                    if itemData then iconFound = itemData.Icon end
                end

                -- 2. Buat Struktur Card jika Item & Icon ditemukan
                if iconFound and ResultItem then
                    local Colors
                    local DropCount

                    -- Ambil Warna Rarity dari Game
                    if GlobalGradientDB and GlobalGradientDB.GetRarityColor then
                         Colors = GlobalGradientDB:GetRarityColor(ResultItem.Rarity or rarityMap[mapIndex])
                    end

                    -- Format Jumlah Drop (contoh: 1x atau 1x-5x)
                    if drop.Minimum == drop.Maximum then
                        DropCount = drop.Minimum .. "x"
                    else
                        DropCount = drop.Minimum .. "x-" .. FormatNumber(drop.Maximum) .. "x"
                    end

                    -- Masukkan ke Table dengan Format Card UI
                    if Colors and type(Colors) == "table" and Colors.Base and Colors.Wave then
                        table.insert(bossDropIcons, {
                            Card = true,
                            Rate = drop.Chance .. "%",
                            Title = drop.Item,
                            Quantity = DropCount,
                            Image = iconFound,
                            Gradient = ColorSequence.new{
                                ColorSequenceKeypoint.new(0, Colors.Base),
                                ColorSequenceKeypoint.new(1, Colors.Wave)
                            }
                        })
                    else
                        -- Fallback jika gradient gagal load (jarang terjadi)
                        table.insert(bossDropIcons, {
                            Card = true,
                            Rate = drop.Chance .. "%",
                            Title = drop.Item,
                            Quantity = DropCount,
                            Image = iconFound,
                            Gradient = ColorSequence.new(Color3.new(1,1,1)) 
                        })
                    end
                end
            end
        end
    end
    
    -- Ambil Health Value untuk Sorting
    local healthVal = ParseAbbreviated(data.Health or "0")

    table.insert(BossListData, {
        Title = name .. " [" .. (data.Difficult or "Boss") .. "]", 
        Desc = "HP: " .. (data.Health or "?"), 
        Value = name, 
        Icon = CharacterIcons[name] or nil, 
        Images = bossDropIcons, -- Sekarang berisi Data Card, bukan icon string biasa
        -- Data untuk sorting internal
        SortMapIndex = mapIndex,
        SortHealth = healthVal
    })
end

-- Logic Sorting: Urutkan Map (Index) -> Lalu Urutkan Health (Kecil ke Besar)
table.sort(BossListData, function(a,b) 
    if a.SortMapIndex == b.SortMapIndex then
        return a.SortHealth < b.SortHealth
    end
    return a.SortMapIndex < b.SortMapIndex 
end)
-- ============================================================================
--  NEW BOSS LOGIC (SEQUENTIAL ROTATION + 1 MINUTE WAIT)
-- ============================================================================

isBossRotationActive = false

-- Helper Timer
local function GetBossTimer()
    local date = os.date("*t")
    local targetMin = (date.min < 30) and 30 or 60
    local currentSec = (date.min * 60) + date.sec
    local targetSec = targetMin * 60
    
    local diff = targetSec - currentSec
    if diff < 0 then diff = 0 end
    
    local m = math.floor(diff / 60)
    local s = diff % 60
    return string.format("%02d:%02d", m, s)
end
local function KillAllCurrentBosses()
    local EnemiesFolder = workspace:FindFirstChild("Server") and workspace.Server:FindFirstChild("Enemies") and workspace.Server.Enemies.Gamemodes:FindFirstChild("Global Bosses")
    
    if not EnemiesFolder then return false end
    if #selectedBosses == 0 then return false end

    local selectedSet = {}
    for _, name in ipairs(selectedBosses) do selectedSet[name] = true end
    
    local bossesToKill = {}
    for _, mob in pairs(EnemiesFolder:GetChildren()) do
        if selectedSet[mob.Name] then
            -- Cek HP via Attribute
            local hp = mob:GetAttribute("Health") or mob:GetAttribute("MaxHealth") or 0
            if hp > 0 then
                table.insert(bossesToKill, mob)
            end
        end
    end
    
    if #bossesToKill == 0 then return false end
    
    -- Loop semua boss yang ditemukan di map ini
    for _, targetBoss in ipairs(bossesToKill) do
        local bossName = targetBoss.Name
        Notify("Boss Hunt", "Targeting " .. bossName .. "...", "target")
        
        while isAutoBoss and targetBoss and targetBoss.Parent do
            local hp = targetBoss:GetAttribute("Health") or targetBoss:GetAttribute("MaxHealth") or 0
            if hp <= 0 then break end
            if not hrp or not humanoid or humanoid.Health <= 0 then break end

            -- PERBAIKAN: Dukung Model dan BasePart
            local targetCFrame = nil
            if targetBoss:IsA("Model") then
                targetCFrame = targetBoss:GetPivot()
            elseif targetBoss:IsA("BasePart") then
                targetCFrame = targetBoss.CFrame
            end

            if targetCFrame then
                hrp.CFrame = targetCFrame -- Teleport ke boss
            end
            task.wait()
        end
        task.wait(0.5) -- Jeda antar boss
    end
    return true
end

local function ExecuteBossSequence()
    if isBossRotationActive then return end
    isBossRotationActive = true
    isGlobalBossActive = true -- Stop normal farm agar tidak bentrok
    
    -- A. Simpan Map Awal (Home)
    if getgenv().PlayerData and getgenv().PlayerData.Map then 
        savedPreviousMap = getgenv().PlayerData.Map 
    else
        savedPreviousMap = "Global" 
    end
    
    Notify("Boss Hunt", "Starting Boss Rotation...", "map")

    -- B. Loop semua Map dari Boss yang dipilih di Dropdown (HANYA MAPNYA)
    local uniqueMaps = {}
    for _, bossName in ipairs(selectedBosses) do
        local bossData = GlobalBossDB[bossName]
        if bossData and bossData.Map and not uniqueMaps[bossData.Map] then
            uniqueMaps[bossData.Map] = true -- Tandai map sudah di-proses
        end
    end

    for targetMap, _ in pairs(uniqueMaps) do
        if not isAutoBoss then break end -- Stop jika toggle dimatikan manual
        
        -- Cek Map: Jika kita belum di map boss, Teleport dulu
        if getgenv().PlayerData.Map ~= targetMap then
            Notify("Boss Hunt", "Warping to " .. targetMap .. " to hunt all Bosses...", "map")
            SmartTeleport(targetMap)
            task.wait(1.5) -- Tunggu loading sebentar
        end
        
        -- Coba Kill SEMUA Boss di map ini
        KillAllCurrentBosses() 
        task.wait(0.5)
    end
    
    -- C. Kembali ke Map Awal (Home)
    if isAutoBoss and savedPreviousMap and savedPreviousMap ~= "None" then
        if getgenv().PlayerData.Map ~= savedPreviousMap then
            Notify("Boss Hunt", "Rotation Done! Returning to " .. savedPreviousMap, "home")
            SmartTeleport(savedPreviousMap)
        else
             Notify("Boss Hunt", "Rotation Done!", "check")
        end
    end
    
    isBossRotationActive = false
    isGlobalBossActive = false
end

-- [3] LOOP PENGECEKAN WAKTU SPAWN
task.spawn(function()
    local waitingForSpawn = false
    
    while not Window.Destroyed do
        -- Hanya jalan jika Toggle Boss nyala & Sedang tidak rotasi
        if isAutoBoss and not isBossRotationActive and not IsInGamemode() then
            local timerText = GetBossTimer()
            
            -- Trigger: Jika waktu hitung mundur habis (00:00), artinya Boss Spawn
            if timerText == "00:00" and not waitingForSpawn then
                waitingForSpawn = true
                Notify("Boss Hunt", "Boss Spawned! Waiting 10s to ensure spawn...", "clock")
                
                -- [PERMINTAAN ANDA] Tunggu 10 Detik
                local countdown = 10
                repeat
                    if not isAutoBoss then break end
                    countdown = countdown - 1
                    task.wait(1)
                until countdown <= 0
                
                -- Jalankan Sequence Rotasi
                if isAutoBoss then
                    ExecuteBossSequence()
                end
                
                -- Cooldown sebentar agar tidak trigger double
                task.wait(10) 
                waitingForSpawn = false
            end
        end
        task.wait(1)
    end
end)

-- UI Bosses Section
FM_Add("Bosses", MainTab:Toggle({
    Title = "Enable Auto Boss Hunt", 
    Desc = "Turn this ON to auto-detect Bosses from timer.", 
    Flag = "AutoBoss_Master_Cfg", 
    Callback = function(v) 
        isAutoBoss = v 
        if not v then isGlobalBossActive = false end 
    end
}))

-- [2. DROPDOWN BOSS]
local BossDropdown = FM_Add("Bosses", MainTab:Dropdown({
    Title = "Select Boss Targets", 
    Desc = "Loading Timers...", 
    Values = BossListData, 
    Multi = true, 
    AllowNone = true, 
    Flag = "GlobalBoss_Selection", 
    Callback = function(val) 
        selectedBosses = {} 
        if type(val) == "table" then 
            for _, v in ipairs(val) do 
                table.insert(selectedBosses, (type(v)=="table" and v.Value) or v) 
            end 
        else 
            selectedBosses = val 
        end 
    end
}))

FM_Add("Bosses", MainTab:Button({
    Title = "Force Start Rotation", 
    Desc = "Manually start the boss rotation sequence now.", 
    Icon = "swords", 
    Callback = function() 
        if not isAutoBoss then 
            Notify("System", "Please enable Auto Boss Hunt first!", "x")
            return 
        end
        task.spawn(ExecuteBossSequence)
    end
}))

-- [3. REALTIME UPDATE LOOP (UI Only)]
task.spawn(function()
    local lastTimerText = ""
    while not Window.Destroyed do
        if BossDropdown then
            local timerText = GetBossTimer()
            
            -- OPTIMASI FPS: Hanya update Header Utama Dropdown
            -- Kita tidak lagi update 50+ item di dalam dropdown setiap detik karena menyebabkan FPS Drop parah
            if timerText ~= lastTimerText then
                lastTimerText = timerText
                BossDropdown:SetDesc("Next Spawn: " .. timerText .. " (00/30)")
                
                -- OPTIONAL: Update item HANYA jika dropdown sedang dibuka (tapi API WindUI tidak mengekspos state isOpen)
                -- Jadi kita DISABLE update individual item timer demi performa.
                -- User tetap bisa lihat timer di Header Dropdown.
                
                -- for i, bossData in ipairs(BossListData) do
                --     local bossName = bossData.Value
                --     local hpText = "?"
                --     if GlobalBossDB[bossName] then hpText = GlobalBossDB[bossName].Health or "?" end
                --     local newDescString = "HP: " .. hpText .. " | ⏳ " .. timerText
                --     BossDropdown:EditDrop(i, { Desc = newDescString })
                -- end
            end
        end
        task.wait(1)
    end
end)

-- [CHAT LISTENER] Deteksi Event Start (Raid / Eclipse)
TextChatService.MessageReceived:Connect(function(message)
    if Window.Destroyed then return end
    
    local rawText = message.Text
    local cleanText = CleanRichText(rawText)
    -- [DI DALAM TextChatService.MessageReceived]
    if string.find(rawText, "%[GAMEMODE%]") and string.find(rawText, "has started") then
        if string.find(cleanText, "Eclipse Defense") then
            ActiveEventsFromChat["EclipseDefense"] = true
            task.delay(60, function() ActiveEventsFromChat["EclipseDefense"] = nil end)
        end
        if string.find(cleanText, "Raid") then
            ActiveEventsFromChat["Raid"] = true
            task.delay(60, function() ActiveEventsFromChat["Raid"] = nil end)
        end
        -- TAMBAHKAN KODE DI BAWAH INI:
        if string.find(cleanText, "Swordsman Invasion") then
            ActiveEventsFromChat["SwordsmanInvasion"] = true
            task.delay(60, function() ActiveEventsFromChat["SwordsmanInvasion"] = nil end)
        end
    end

    -- 2. FITUR DROP WEBHOOK
    if string.find(cleanText, "You got") then
        local pName = game.Players.LocalPlayer.Name
        local censoredName = "||" .. string.sub(pName, 1, 3) .. string.rep("*", #pName - 3) .. "||"
        local newText = string.gsub(cleanText, "You", censoredName)
        SendChatDropWebhook(newText)
    end

    -- 3. FITUR BOSS HUNT
    if isAutoBoss then
        if string.find(cleanText, "Global Bosses spawned")then
            ExecuteBossSequence()
        end
    end
end)
-- ============================================================================
--  GAMEMODES UI (DYNAMIC ENGLISH - AUTO SAVE & HIDE TOGGLE)
-- ============================================================================

-- UI Reference Variables
-- 1. Generate Dropdown List
table.clear(GM_DropdownList)
for name, _ in pairs(GlobalGamemodeDB) do table.insert(GM_DropdownList, name) end
table.sort(GM_DropdownList)

-- 2. Helper to Update UI
local function UpdateGM_UI(modeName)
    local db = GlobalGamemodeDB[modeName]
    local settings = GamemodeSettings[modeName]
    if not db or not settings then return end
    
    -- Simpan pilihan terakhir setiap kali UI diupdate (saat user ganti dropdown)
    if SelectedGamemodeName ~= modeName then
        SelectedGamemodeName = modeName
        SaveGMSettings() -- Save pilihan user
    end
    
    -- Update Input Wave
    if UI_GM.WaveInput then 
        UI_GM.WaveInput:Set(tostring(settings.TargetWave)) 
    end
    
    -- Update Auto Toggle
    if UI_GM.AutoToggle then 
        UI_GM.AutoToggle:Set(settings.Active)
        UI_GM.AutoToggle:SetTitle("Auto Farm: " .. (db.DisplayName or modeName))
    end
    
    -- Update Key Toggle (Logic Hide)
    if UI_GM.KeyToggle then
        local toggleFrame = UI_GM.KeyToggle.ElementFrame or UI_GM.KeyToggle.GroupFrame
        if db.Item then
            if toggleFrame then toggleFrame.Visible = true end
            UI_GM.KeyToggle:SetTitle("Auto Create Mode " .. modeName)
            UI_GM.KeyToggle:Set(settings.UseKey)
        else
            if toggleFrame then toggleFrame.Visible = false end
            UI_GM.KeyToggle:Set(false) 
        end
    end
    
    -- Update Info
    if UI_GM.InfoLabel then
        local info = "Map: " .. (db.DisplayName or modeName) .. "\n"
        if db.Item then info = info .. "Cost: 1x " .. db.Item .. "\n" end
        if db.MaxWave then info = info .. "Max Wave: " .. db.MaxWave end
        UI_GM.InfoLabel:SetDesc(info)
    end

    if UI_GM.IgnoreEnemyDD then
        local frame = UI_GM.IgnoreEnemyDD.ElementFrame or UI_GM.IgnoreEnemyDD.GroupFrame
        if modeName == "SwordsmanInvasion" then
            frame.Visible = true
            UI_GM.WaveInput.ElementFrame.Visible = false
            UI_GM.IgnoreEnemyDD:Set(settings.IgnoreEnemy)
        else
            frame.Visible = false
            UI_GM.WaveInput.ElementFrame.Visible = true
        end
    end
end

-- 3. UI Elements Construction

-- Main Dropdown
FM_Add("Gamemodes", MainTab:Dropdown({
    Title = "Select Gamemode",
    Values = GM_DropdownList,
    Value = "Raid", -- <--- KUNCI PERBAIKAN: Pakai variabel yang sudah di-load
    Multi = false,
    Callback = function(v)
        UpdateGM_UI(v)
    end
}))

-- Info Box
UI_GM.InfoLabel = FM_Add("Gamemodes", MainTab:Paragraph({Title = "Mode Info", Desc = "Select a mode to view details..."}))

-- Toggle Auto Farm -> Auto Save
UI_GM.AutoToggle = FM_Add("Gamemodes", MainTab:Toggle({
    Title = "Auto Farm",
    Desc = "Enable auto join & farm for this specific mode.",
    Callback = function(v)
        if SelectedGamemodeName and GamemodeSettings[SelectedGamemodeName] then
            GamemodeSettings[SelectedGamemodeName].Active = v
            SaveGMSettings()
        end
    end
}))

-- Input Target Wave -> Auto Save
UI_GM.WaveInput = FM_Add("Gamemodes", MainTab:Input({
    Title = "Target Wave (Exit)",
    Value = GamemodeSettings[SelectedGamemodeName].TargetWave,
    Numeric = true,
    Callback = function(v)
        if SelectedGamemodeName and GamemodeSettings[SelectedGamemodeName] then
            GamemodeSettings[SelectedGamemodeName].TargetWave = tonumber(v)
            SaveGMSettings()
        end
    end
}))

-- Toggle Trigger Item -> Auto Save
UI_GM.KeyToggle = FM_Add("Gamemodes", MainTab:Toggle({
    Title = "Auto Create " .. SelectedGamemodeName,
    Desc = "Allow the script to use Keys/Items Create " .. SelectedGamemodeName,
    Callback = function(v)
        if SelectedGamemodeName and GamemodeSettings[SelectedGamemodeName] then
            GamemodeSettings[SelectedGamemodeName].UseKey = v
            SaveGMSettings()
        end
    end
}))
UI_GM.IgnoreEnemyDD = FM_Add("Gamemodes", MainTab:Dropdown({
    Title = "Ignore Enemy (Don't Kill)",
    Desc = "Select which enemy to ignore during Invasion",
    Values = {"Kiito"}, -- Anda bisa menambah daftar musuh di sini
    Value = "Kiito",
    AllowNone = true,
    Callback = function(v)
        if SelectedGamemodeName == "SwordsmanInvasion" then
            GamemodeSettings["SwordsmanInvasion"].IgnoreEnemy = v
            SaveGMSettings()
        end
    end
}))
-- Initial Update (Penting agar UI langsung sinkron saat start)
UpdateGM_UI("Raid")
-- ============================================================================
--  TRIAL UPGRADES (DYNAMIC SYSTEM - 2 PER GROUP & PERKS INFO)
-- ============================================================================

local TrialUpgradeToggles = {}
local TrialSystemName = "Trial Upgrades" 

-- 1. UI Construction
FM_Add("Trial Upgrades", MainTab:Paragraph({Title = "Trial Upgrades Manager", Desc = "Auto buy upgrades using Tickets"}))

if GlobalUpgradeSystemsDB[TrialSystemName] and GlobalUpgradeSystemsDB[TrialSystemName].List then
    local list = GlobalUpgradeSystemsDB[TrialSystemName].List
    
    local sortedKeys = {}
    for k, v in pairs(list) do table.insert(sortedKeys, {Key = k, Index = v.Index or 99}) end
    table.sort(sortedKeys, function(a,b) return a.Index < b.Index end)

    local currentGroup 

    for i, item in ipairs(sortedKeys) do
        if i % 2 == 1 then
            currentGroup = MainTab:Group({})
            FM_Add("Trial Upgrades", currentGroup)
        end

        local upgradeName = item.Key
        
        local tgl = currentGroup:Toggle({
            Title = upgradeName,
            Desc = "Waiting...",
            Flag = "TrialUp_"..upgradeName, 
            Callback = function(v) 
                TrialUpgradeToggles[upgradeName] = v 
            end
        })
        
        TrialUpgradeToggles[upgradeName .. "_UI"] = tgl
    end
end

-- 2. Loop Logic Auto Upgrade
local function SendTrialUpgradeWebhook(upgradeName, lvl)
    local pName = game.Players.LocalPlayer.Name
    local censoredName = "||" .. string.sub(pName, 1, 3) .. string.rep("*", #pName - 3) .. "||"
    
    local titleText = "⚡ Trial Upgrade Upgraded!"
    local desc = "User: " .. censoredName .. "\n" ..
                 "Upgrade: **" .. upgradeName .. "**\n" ..
                 "New Level: **" .. lvl .. "**"
    
    SendWebhook(titleText, desc, 16776960) -- Warna Kuning
end

task.spawn(function()
    local lastTrialLogs = {} -- Tracker

    while not Window.Destroyed do
        local pData = getgenv().PlayerData
        local sysData = GlobalUpgradeSystemsDB[TrialSystemName]
        
        if pData and sysData and pData.Upgrade then
            local myUpgrades = pData.Upgrade[TrialSystemName] or {}
            
            local priceType = sysData.Price.Type
            local priceName = sysData.Price.Name
            
            local myBalance = 0
            if priceType == "Item" and pData.Items then
                myBalance = pData.Items[priceName] or 0
            elseif pData[priceName] then 
                myBalance = pData[priceName] or 0
            end

            for upgradeName, upgradeInfo in pairs(sysData.List) do
                local toggleState = TrialUpgradeToggles[upgradeName]
                local uiElement = TrialUpgradeToggles[upgradeName .. "_UI"]
                
                local currentLvl = myUpgrades[upgradeName] or 0
                local maxLvl = upgradeInfo.Levels or 999
                
                -- Hitung Harga
                local basePrice = upgradeInfo.Price.Base
                local effectPrice = upgradeInfo.Price.Effect
                local currentPrice = basePrice + (effectPrice * currentLvl)

                -- [BARU] Hitung Perks (Stats)
                local perkDesc = ""
                if upgradeInfo.Perks then
                    for _, p in ipairs(upgradeInfo.Perks) do
                        -- Rumus Stat: BaseAmount + (Effect * (Level - 1))
                        local totalVal = 0
                        if currentLvl > 0 then
                            totalVal = p.Amount + (p.Effect * (currentLvl - 1))
                        end
                        
                        -- Format Teks
                        if p.Type == "Times" then
                            -- 0.1 -> 10%
                            perkDesc = perkDesc .. "+" .. math.floor(totalVal * 100 + 0.5) .. "% " .. p.Name .. "\n"
                        else
                            perkDesc = perkDesc .. "+" .. totalVal .. " " .. p.Name .. "\n"
                        end
                    end
                end

                -- Update UI dengan Info Lengkap
                if uiElement then
                    local balInfo = priceName..": " .. FormatNumber(myBalance)
                    
                    if currentLvl >= maxLvl then
                        uiElement:SetTitle(upgradeName .. " [MAX]")
                        uiElement:SetDesc(perkDesc .. "Level: " .. currentLvl .. " (Maxed)")
                        uiElement:Lock() -- Opsional: Lock jika max
                        uiElement:Set(false)
                    else
                        uiElement:SetTitle(upgradeName)
                        uiElement:SetDesc("Lvl: " .. currentLvl .. " | Cost: " .. FormatNumber(currentPrice) .. "\n" .. perkDesc .. balInfo)
                    end
                end

                -- Eksekusi Buy
                if toggleState and currentLvl < maxLvl then
                    if myBalance >= currentPrice then
                        ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                            {"General", "Upgrade", "Upgrade", TrialSystemName, upgradeName, n = 5}, 
                            "\2"
                        })
                        myBalance = myBalance - currentPrice
                        
                        -- [WEBHOOK LOGIC]
                        local nextLvl = currentLvl + 1
                        if lastTrialLogs[upgradeName] ~= nextLvl then
                            SendTrialUpgradeWebhook(upgradeName, nextLvl)
                            lastTrialLogs[upgradeName] = nextLvl
                        end

                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(0.5) 
    end
end)

local function SendWorldUpgradeWebhook(mapName, typeStr, lvl)
    local pName = game.Players.LocalPlayer.Name
    local censoredName = "||" .. string.sub(pName, 1, 3) .. string.rep("*", #pName - 3) .. "||"
    
    local titleText = "🌍 World Upgrade Upgraded!"
    local desc = "User: " .. censoredName .. "\n" ..
                 "Map: **" .. mapName .. "**\n" ..
                 "Upgrade: **" .. typeStr .. "**\n" ..
                 "New Level: **" .. lvl .. "**"
    
    SendWebhook(titleText, desc, 65280) -- Warna Hijau
end

-- ============================================================================
--  WORLD UPGRADE UI (FIXED: LOCK BUG & AUTO SAVE)
-- ============================================================================

-- [SAVE SYSTEM KHUSUS WORLD UPGRADE]
local WU_ConfigFile = FolderPath .. "/WorldUpgradeSettings.json"

local function SaveWUConfig()
    if not isfolder(FolderPath) then makefolder(FolderPath) end
    local success, encoded = pcall(function() return HttpService:JSONEncode(WU_MapConfig) end)
    if success then writefile(WU_ConfigFile, encoded) end
end

local function LoadWUConfig()
    if isfile(WU_ConfigFile) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(WU_ConfigFile)) end)
        if success and type(decoded) == "table" then WU_MapConfig = decoded end
    end
end
LoadWUConfig()

-- Variable Cache Global untuk World Upgrade (Agar bisa di-reset dari Dropdown)
local wu_cachedDesc = { Power = "", Damage = "", Coins = "" }

-- 1. Generate List Map
local WUMapList = {}
local tempMapSorter = {}
if GlobalMapDB and GlobalWorldUpgradeDB then
    for mapName, mapData in pairs(GlobalMapDB) do
        if GlobalWorldUpgradeDB[mapName] then
            table.insert(tempMapSorter, {Name = mapName, Index = mapData.Index or 999})
        end
    end
    table.sort(tempMapSorter, function(a,b) return a.Index < b.Index end)
    for _, m in ipairs(tempMapSorter) do table.insert(WUMapList, m.Name) end
end

local WU_TogglesContainer = {}

local function ClearWUToggles()
    for _, tgl in pairs(WU_TogglesContainer) do
        pcall(function()
            if tgl.ElementFrame then tgl.ElementFrame:Destroy() end
        end)
    end
    table.clear(WU_TogglesContainer)
end

local WU_MapDropdown = FM_Add("World Upgrade", MainTab:Dropdown({
    Title = "Select Map", 
    Values = WUMapList, 
    Callback = function(v) 
        local selectedVal = (type(v)=="table" and v.Value) or v
        wu_SelectedMap = selectedVal
        
        ClearWUToggles()
        
        local dbUpgrades = GlobalWorldUpgradeDB[selectedVal]
        local pData = OmniRef.Data -- Ambil data player
        
        if dbUpgrades then
            local mapSettings = GetWUConfig(selectedVal)
            local userUpgrades = (pData.WorldUpgrades and pData.WorldUpgrades[selectedVal]) or {}
            
            local sortedUpgrades = {}
            for name, data in pairs(dbUpgrades) do
                if typeof(data) == "table" and data.Index then
                    table.insert(sortedUpgrades, {Name = name, Data = data})
                end
            end
            table.sort(sortedUpgrades, function(a,b) return a.Data.Index < b.Data.Index end)

            for _, item in ipairs(sortedUpgrades) do
                local upName = item.Name
                local upData = item.Data
                
                -- LOGIKA INSTANT UPDATE:
                local currentLvl = userUpgrades[upName] or 0
                local buffValue = 0
                if OmniRef.Utils and OmniRef.Utils.WorldUpgrades then
                    buffValue = OmniRef.Utils.WorldUpgrades:GetBuff(pData, selectedVal, upName)
                end
                local formattedBuff = math.floor(buffValue * 100)
                local instantDesc = "+" .. formattedBuff .. "% Boost | Lvl: " .. currentLvl
                local instantTitle = (upData.Name or upName) .. (currentLvl >= 10 and " [MAX]" or "")

                -- Di dalam loop for _, item in ipairs(sortedUpgrades) do pada WU_MapDropdown
                local tgl = MainTab:Toggle({
                    Title = instantTitle,
                    Desc = instantDesc,
                    Image = upData.Icon or "rbxassetid://116941678612804",
                    Default = mapSettings[upName] or false,
                    Callback = function(state)
                        -- Tambahan proteksi agar tidak bisa beli jika sudah max
                        if (userUpgrades[upName] or 0) >= 10 then return end 
                        mapSettings[upName] = state
                        SaveWUConfig()
                    end
                })

                -- Kunci toggle jika level sudah maksimal saat UI pertama kali dibuat
                if currentLvl >= 10 then
                    tgl:Lock()
                    tgl:Set(false) -- Matikan toggle agar tidak auto-buy lagi
                end

                WU_TogglesContainer[upName] = tgl
                FM_Add("World Upgrade", tgl)
                
                if tgl.ElementFrame then 
                    tgl.ElementFrame.Visible = true 
                end
            end
        end
    end
}))
task.spawn(function()
    local lastWULogs = {}
    local visualCache = {} -- Menyimpan data level terakhir agar UI tidak update terus-menerus

    while not Window.Destroyed do
        local targetMap = wu_SelectedMap
        local pData = OmniRef.Data
        local dbUpgrades = GlobalWorldUpgradeDB[targetMap]

        -- Hanya jalankan jika data valid dan map terpilih bukan 'None'
        if targetMap and targetMap ~= "None" and pData and dbUpgrades then
            local mapConfig = GetWUConfig(targetMap)
            local userUpgrades = (pData.WorldUpgrades and pData.WorldUpgrades[targetMap]) or {}

            for upName, upData in pairs(dbUpgrades) do
                if typeof(upData) == "table" then
                    pcall(function()
                        local currentLvl = userUpgrades[upName] or 0
                        
                        -- [1] LOGIKA AUTO BUY (Hanya berjalan jika toggle diaktifkan)
                        if mapConfig[upName] then
                            local nextLvl = currentLvl + 1
                            local priceStr = upData.Levels[tostring(nextLvl)]
                            
                            if priceStr then
                                local price = ParseAbbreviated(priceStr)
                                local currencyName = upData.Currency or "Coins"
                                local balance = pData[currencyName] or (pData.Items and pData.Items[currencyName]) or 0
                                
                                if balance >= price then
                                    ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                                        {"General", "WorldUpgrades", "Upgrade", targetMap, upName, n = 5}, 
                                        "\2"
                                    })
                                end
                            end
                        end

                        -- [2] OPTIMASI UI (Hanya update jika Level berubah atau UI baru dibuka)
                        local toggleUI = WU_TogglesContainer[upName]
                        if not Window.Closed and toggleUI then
                            -- Membuat Key Cache unik per Map dan per Upgrade
                            local cacheKey = targetMap .. "_" .. upName
                            
                            -- Cek apakah level saat ini berbeda dengan level yang tercatat di cache
                            if visualCache[cacheKey] ~= currentLvl then
                                local buffValue = 0
                                if OmniRef.Utils and OmniRef.Utils.WorldUpgrades then
                                    buffValue = OmniRef.Utils.WorldUpgrades:GetBuff(pData, targetMap, upName)
                                end
                                
                                local formattedBuff = math.floor(buffValue * 100)
                                local newDesc = "+" .. formattedBuff .. "% Boost | Lvl: " .. currentLvl
                                local newTitle = (upData.Name or upName) .. (currentLvl >= 10 and " [MAX]" or "")

                                -- Update UI hanya SEKALI saat level naik
                                toggleUI:SetDesc(newDesc)
                                toggleUI:SetTitle(newTitle)
                                
                                -- Simpan level terbaru ke cache
                                visualCache[cacheKey] = currentLvl
                            end
                        end
                    end)
                end
            end
        end
        task.wait(1) -- Interval pengecekan (bisa dinaikkan ke 1.5 jika masih terasa berat)
    end
end)
-- ============================================================================
--  UPGRADE RANK FEATURE (WITH DISCORD WEBHOOK + CENSORED NAME)
-- ============================================================================

local function SendRankWebhook(oldRank, newRank)
    local pName = game.Players.LocalPlayer.Name
    local censoredName = "||" .. string.sub(pName, 1, 3) .. string.rep("*", #pName - 3) .. "||"
    local desc = "User: " .. censoredName .. "\n\n" .. "**Rank " .. oldRank .. "** ➡️  **Rank " .. newRank .. "**"
    SendWebhook("🎉 Rank Up Successful!", desc, 3447003)
end

-- UI Elements
UI.RankInfo = MainTab:Paragraph({Title = "Rank Info: Loading...", Desc = "Waiting for Player Data...", Image = "rbxassetid://108641720461944"})
FM_Add("Upgrade Rank", UI.RankInfo)
FM_Add("Upgrade Rank", MainTab:Toggle({Title="Auto Rank Up", Flag="RankUp_Cfg", Callback=function(v) isRankUp = v end}))

-- [RANK UP LOOP - FINAL OPTIMIZED]
task.spawn(function()
    local isProcessingRank = false 
    local lastRankDesc = "" -- Cache untuk deskripsi

    while not Window.Destroyed do
        -- [SAFETY] Stop jika script mati
        if Window.Destroyed then break end

        if getgenv().PlayerData and getgenv().PlayerData.Rank and GlobalRankDB then
            local pData = getgenv().PlayerData
            
            local currentRankIdx = pData.Rank
            local nextRankIdx = currentRankIdx + 1
            local currentPower = pData.Power or 0
            
            local currentRankData = GlobalRankDB[currentRankIdx]
            local nextRankData = GlobalRankDB[nextRankIdx]
            
            -- [VISUAL UPDATE] Hanya jalankan kalkulasi Progress Bar jika UI terbuka
            if not Window.Closed and UI.RankInfo then
                if currentRankData and nextRankData then
                    local nextRankPowerReq = ParseAbbreviated(nextRankData.Power)
                    
                    local currentPerkPower = (currentRankData.Perks and currentRankData.Perks.Power) or "0"
                    local nextPerkPower = (nextRankData.Perks and nextRankData.Perks.Power) or "0"
                    
                    -- Hitung Progress Bar (Hanya saat UI dilihat)
                    local progress = 0
                    if nextRankPowerReq > 0 then progress = math.clamp(currentPower / nextRankPowerReq, 0, 1) end
                    local progressPercent = math.floor(progress * 100)
                    local bars = 20
                    local filled = math.floor(progress * bars)
                    local empty = bars - filled
                    local barStr = string.rep("■", filled) .. string.rep("□", empty)
                    
                    -- Susun String Deskripsi
                    local newDesc = string.format("Perks x%s > x%s\n%s %d%%\nPower: %s / %s", currentPerkPower, nextPerkPower, barStr, progressPercent, FormatNumber(currentPower), nextRankData.Power)
                    local newTitle = string.format("Rank %d > Rank %d", currentRankIdx, nextRankIdx)

                    -- Update UI hanya jika teks berubah (Cache Check)
                    if lastRankDesc ~= newDesc then
                        UI.RankInfo:SetTitle(newTitle)
                        UI.RankInfo:SetDesc(newDesc)
                        lastRankDesc = newDesc
                    end
                else
                    if UI.RankInfo.Title ~= "Max Rank Reached" then
                        UI.RankInfo:SetTitle("Max Rank Reached") 
                        UI.RankInfo:SetDesc("You have reached the maximum rank!") 
                    end
                end
            end

            -- [AUTO RANK UP LOGIC] Tetap jalan di background!
            if isRankUp and nextRankData then
                 local nextRankPowerReq = ParseAbbreviated(nextRankData.Power)
                 if currentPower >= nextRankPowerReq and not isProcessingRank then
                    isProcessingRank = true 
                    
                    ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{"General", "RankUp", "RankUp", n = 10}, "\2"})
                    Notify("Rank Up", "Upgrading to Rank " .. nextRankIdx .. "!", "chevrons-up")
                    SendRankWebhook(currentRankIdx, nextRankIdx)
                    
                    task.wait(6) 
                    isProcessingRank = false 
                end
            end
        end
        task.wait(1)
    end
end)

-- ============================================================================
-- [RUNES SYSTEM IMPLEMENTATION]
-- ============================================================================

-- Helper: Get Owned Runes List for Dropdown
local function GetOwnedRunesList()
    local list = {}
    local pData = getgenv().PlayerData
    
    if pData and pData.Runes then
        for name, data in pairs(pData.Runes) do
            local level = data.Level or 0
            
            local iconId = "rbxassetid://84366761557806"
            if GlobalRunesDB and GlobalRunesDB[name] and GlobalRunesDB[name].Icon then
                iconId = GlobalRunesDB[name].Icon
            end
            
            table.insert(list, {
                Title = string.format("%s (Lv %d)", name, level),
                Value = name,
                Icon = iconId
            })
        end
    end
    
    if #list == 0 then
        table.insert(list, {Title = "No Runes Found", Value = "None"})
        return list
    end
    
    table.sort(list, function(a, b) return a.Title < b.Title end)
    return list
end

local function HasEnoughMaterials(runeName, currentLevel)
    local pData = getgenv().PlayerData
    if not pData then return false end
    
    local runeConfig = GlobalRunesDB[runeName]
    if not runeConfig or not runeConfig.Prestige then return false end

    -- [SINKRONISASI GAME]: Ambil syarat untuk level BERIKUTNYA
    local nextLevelStr = tostring(currentLevel + 1)
    local requirements = runeConfig.Prestige[nextLevelStr]
    
    -- Jika tidak ada data level berikutnya, berarti sudah MAX
    if not requirements then return false end

    -- [LOGIKA KETAT]: Cek SEMUA material yang diminta (biasanya 2 jenis)
    for matName, reqAmount in pairs(requirements) do
        -- Ambil jumlah yang dimiliki (Cek di PlayerData atau Items)
        local ownedRaw = pData[matName] or (pData.Items and pData.Items[matName]) or 0
        
        -- Konversi ke angka murni (Gunakan ParseAbbreviated agar "1.5K" tidak jadi nil)
        local numOwned = ParseAbbreviated(ownedRaw)
        local numReq = ParseAbbreviated(reqAmount)

        -- [DEBUG] Hilangkan tanda -- jika ingin melihat proses di F9
        -- print(string.format("[Runes] %s Needs: %d %s | Have: %d", runeName, numReq, matName, numOwned))

        -- Jika satu material saja kurang, langsung gagalkan (return false)
        if numOwned < numReq then
            return false 
        end
    end

    -- Kembalikan true HANYA jika SEMUA material cukup
    return true
end

-- Dropdown: Rune Selection (Auto-Updating)
local RuneEquipDD = MainTab:Dropdown({
    Title = "List Runes",
    Value = "Damage Rune",
    Values = GetOwnedRunesList(),
    Flag = "RuneSelect_Cfg",
    Callback = function(v)
        SelectedRuneToAct = (type(v) == "table" and v.Value) or v
    end
})
FM_Add("Runes", RuneEquipDD)

local PrestigeToggle = MainTab:Toggle({
    Title = "Auto Prestige All Runes",
    Desc = "Automatically prestige all runes if materials are available.",
    Default = isAutoPrestige,
    Flag = "RuneAutoPrestige_Cfg",
    Callback = function(v)
        isAutoPrestige = v
        Notify("Rune System", (v and "Auto Prestige Enabled." or "Auto Prestige Disabled."), "star")
    end
})
FM_Add("Runes", PrestigeToggle)

-- Tambahkan ini di bagian atas script bersama variabel global lainnya
local RuneState = {
    cooldowns = {}
}

task.spawn(function()
    while not Window.Destroyed do
        task.wait(1) -- Scan setiap 1 detik agar tidak lag
        
        local pData = getgenv().PlayerData
        if not isAutoPrestige or not pData or not pData.Runes then continue end

        for runeName, runeData in pairs(pData.Runes) do
            -- Debounce 3 detik agar server tidak spam 'You need more...'
            if not RuneState.cooldowns[runeName] or (os.clock() - RuneState.cooldowns[runeName] > 3) then
                
                local currentLevel = runeData.Level or 0
                
                -- Pengecekan multi-material yang sudah diperbaiki
                if HasEnoughMaterials(runeName, currentLevel) then
                    RuneState.cooldowns[runeName] = os.clock()
                    
                    -- Kirim sinyal Prestige
                    ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                        {"General", "Runes", "Prestige", runeName}, 
                        "\2"
                    })
                    
                    Notify("Runes", "Upgrading " .. runeName .. " to Lv " .. (currentLevel + 1), "star")
                    task.wait(0.3) -- Jeda antar jenis rune
                end
            end
        end
    end
end)

-- ============================================================================
-- [2. UI GENERATOR - 2 PER ITEM LAYOUT (FIXED TALENT POSITION)]
local currentGachaGroup
local GachaSwordDropdown -- Reference untuk update realtime
local TalentPowerData = nil -- Simpan data Talent untuk dirender terpisah
local GridCounter = 0 -- Counter visual untuk grid agar rapi

for i, power in ipairs(powerList) do 
    -- KASUS 1: SWORD PASSIVE (CUSTOM GRID)
    if power.Name == "Sword Passive" then
        -- Header Section
        local SPHeader = MainTab:Paragraph({Title = "Sword Passive System", Desc = "Select Sword & Passive Targets below"})
        FM_Add("Gacha", SPHeader)
        
        -- ROW 1 (Toggle & Refresh Button)
        local Row1 = MainTab:Group({})
        FM_Add("Gacha", Row1)
        
        local spToggle = Row1:Toggle({
            Title = "Auto Roll", 
            Flag = "Power_" .. power.Name,
            Image = power.Icon,
            Callback = function(v) changePower(power.Name, v) end
        })
        PowerToggles[power.Name] = spToggle
        
        -- Forward declare variable untuk dropdown agar bisa direfresh tombol
        local SwordDD 
        
        Row1:Button({
            Title = "Refresh Swords",
            Icon = "refresh-cw",
            Callback = function() if SwordDD then SwordDD:Refresh(GetGachaSwordList()) end end
        })

        -- ROW 2 (Dropdown Sword & Dropdown Target)
        local Row2 = MainTab:Group({})
        FM_Add("Gacha", Row2)

        SwordDD = Row2:Dropdown({
            Title = "Target Sword",
            Values = GetGachaSwordList(),
            Value = nil,
            Flag = "Gacha_SwordSelect",
            Callback = function(v)
                selectedGachaSwordSID = (type(v) == "table" and v.Value) or v
                
                if type(v) ~= "table" then
                    local list = GetGachaSwordList()
                    for _, item in ipairs(list) do
                        if item.Value == selectedGachaSwordSID then v = item break end
                    end
                end

                if type(v) == "table" and v.Icon and SwordDD then
                    if SwordDD.SetValueImage then SwordDD:SetValueImage(v.Icon) end
                    if SwordDD.SetMainImage then
                        if v.Gradient then
                            SwordDD:SetMainImage({Image = v.Icon, Gradient = v.Gradient}, 50)
                        else
                            SwordDD:SetMainImage(v.Icon)
                        end
                    end
                else
                    if SwordDD.SetMainImage then SwordDD:SetMainImage("rbxassetid://84366761557806") end
                    if SwordDD.SetValueImage then SwordDD:SetValueImage("rbxassetid://84366761557806") end
                end

                if PowerToggles["Sword Passive"] then
                      local sName = (type(v) == "table" and v.Title) or "Unknown"
                      PowerToggles["Sword Passive"]:SetDesc("Target: " .. sName)
                end
            end
        })
        GachaSwordDropdown = SwordDD

        Row2:Dropdown({
            Title = "Passive Index",
            Values = GetSwordPassiveIndexList(),
            Multi = true,
            Flag = "Gacha_PassiveTargets",
            Callback = function(values)
                table.clear(SwordPassiveTargets)
                if type(values) == "table" then
                    for _, item in ipairs(values) do
                        local pName = (type(item) == "table" and item.Value) or item
                        SwordPassiveTargets[pName] = true
                    end
                end
            end
        })

    -- KASUS 2: TALENTS (KITA SKIP DARI GRID, SIMPAN DATANYA)
    elseif power.Name == "Talents" then
        TalentPowerData = power
        -- Kita tidak buat UI-nya di sini agar tidak masuk ke group grid biasa

    -- KASUS 3: GACHA BIASA (Standard Grid)
    else
        GridCounter = GridCounter + 1
        
        -- Buat Group Baru setiap 2 item (Berdasarkan GridCounter, bukan index i)
        if GridCounter % 2 == 1 then
            currentGachaGroup = MainTab:Group({})
            FM_Add("Gacha", currentGachaGroup)
        end

        local tgl = currentGachaGroup:Toggle({
            Title = power.Name, 
            Flag = "Power_" .. power.Name,
            Image = power.Icon,
            ImageSize = 24,
            Callback = function(v) changePower(power.Name, v) end
        })
        
        if not IsMapUnlocked(power.Map) then
            if tgl.Lock then 
                 tgl:Lock()
                 power.allow = false
                 tgl:SetDesc("LOCKED: " .. power.Map)
            end
        end
        PowerToggles[power.Name] = tgl
    end
end

-- ============================================================================
--  TALENT GROUP (MANUAL RENDER: TOGGLE + DROPDOWN)
-- ============================================================================
-- [DYNAMIC TALENT TARGET LOADER]
local TalentRankList = {}
local TalentSource = require(game:GetService("ReplicatedStorage").Shared.Gacha.Sources.Talents)

-- Kita ambil data rank dari salah satu kategori (Power) karena semua kategori memiliki rank yang sama
local powerData = TalentSource["Power"]
if powerData and powerData.Ranks then
    local tempRanks = {}
    
    -- Ambil semua nama Rank dan Indexnya
    for rankName, data in pairs(powerData.Ranks) do
        table.insert(tempRanks, {Name = rankName, Index = data.Index})
    end
    
    -- Urutkan berdasarkan Index agar muncul F, E, D ... sampai S
    table.sort(tempRanks, function(a, b)
        return a.Index < b.Index
    end)
    
    -- Masukkan ke list final untuk UI Dropdown
    for _, item in ipairs(tempRanks) do
        table.insert(TalentRankList, item.Name)
    end
end
local TalentGroup = MainTab:Group({Title = "Talent Settings"})
FM_Add("Gacha", TalentGroup)

-- 1. Render Toggle "Auto Talents" di sini (Menggunakan data yang disimpan tadi)
if TalentPowerData then
    local power = TalentPowerData
    local tgl = TalentGroup:Toggle({
        Title = "Auto " .. power.Name,
        Flag = "Power_" .. power.Name,
        Image = power.Icon,
        ImageSize = 24,
        Callback = function(v) changePower(power.Name, v) end
    })
    
    if not IsMapUnlocked(power.Map) then
        if tgl.Lock then 
             tgl:Lock()
             power.allow = false
             tgl:SetDesc("LOCKED: " .. power.Map)
        end
    end
    PowerToggles[power.Name] = tgl
end

-- 2. Render Dropdown Target (Akan muncul tepat di bawah Toggle)
FM_Add("Gacha", TalentGroup:Dropdown({
    Title = "Talent Target",
    Desc = "Select stats to Lock automatically",
    Values = TalentRankList,
    Multi = true,
    Flag = "TalentTargets_Cfg",
    Callback = function(v)
        table.clear(FormattedTalentTargets)
        if type(v) == "table" then
            for _, rankName in ipairs(v) do FormattedTalentTargets[rankName] = true end
        else
            FormattedTalentTargets[v] = true
        end
    end
}))

-- ============================================================================
-- [UPDATED] GACHA LOOP: AUTO ROLL + SCARLET LOCK SYSTEM
-- ============================================================================
task.spawn(function()
    -- [CACHE] Cache untuk mencegah spam update UI
    local gachaDescCache = {} 
    local gachaImageCache = {} 
    -- [TRACKER] Status Lock per Power
    local gachaLockStatus = {} 

    while not Window.Destroyed do
        if Window.Destroyed then break end

        local pData = getgenv().PlayerData
        local isUIOpen = not Window.Closed 

        for _, power in pairs(powerList) do
            
            -- [0. CEK RARITY UNTUK AUTO LOCK]
            local currentRarity = nil
            local currentItemName = nil
            
            -- Ambil Nama Item & Rarity Saat Ini
            if pData then
                if power.Name == "Sword Passive" then
                    if selectedGachaSwordSID and pData.Swords then
                        local sData = pData.Swords[selectedGachaSwordSID]
                        if sData then 
                            currentItemName = sData.Passive 
                            -- Cek Database Global untuk Rarity Passive
                            if GlobalGachaSources["Sword Passives"] and GlobalGachaSources["Sword Passives"][currentItemName] then
                                currentRarity = GlobalGachaSources["Sword Passives"][currentItemName].Rarity
                            end
                        end
                    end
                elseif pData.Gacha and pData.Gacha[power.Name] then
                    currentItemName = pData.Gacha[power.Name].Current
                    -- Cek Database Global untuk Gacha Lain
                    local sourceKey = (power.Name == "Talents" and "Talents") or power.Source or power.Name
                    if GlobalGachaSources[sourceKey] and GlobalGachaSources[sourceKey][currentItemName] then
                         currentRarity = GlobalGachaSources[sourceKey][currentItemName].Rarity
                    end
                end
            end

            -- LOGIKA LOCK / UNLOCK SCARLET
            local toggleUI = PowerToggles[power.Name]
            if toggleUI then
                local baseTitle = (power.Name == "Sword Passive") and "Auto Roll" or power.Name
                
                if currentRarity == "Scarlet" then
                    -- KONDISI: DAPAT SCARLET
                    if not gachaLockStatus[power.Name] then
                        -- Matikan Auto Roll
                        if power.auto then
                            power.auto = false
                            toggleUI:Set(false)
                            Notify("Gacha", "Scarlet Obtained! Stopping.", "star")
                        end
                        
                        -- Kunci UI & Ubah Title
                        toggleUI:Lock()
                        toggleUI:SetTitle(baseTitle .. " [MAX]")
                        toggleUI:SetDesc("Status: Scarlet (Maxed)")
                        
                        gachaLockStatus[power.Name] = true -- Tandai sudah dikunci
                    end
                else
                    -- KONDISI: TIDAK SCARLET (Atau Ganti Pedang)
                    if gachaLockStatus[power.Name] then
                        -- Buka Kunci & Reset Title
                        toggleUI:Unlock()
                        toggleUI:SetTitle(baseTitle)
                        -- Reset Desc Cache agar deskripsi normal muncul kembali
                        gachaDescCache[power.Name] = nil 
                        
                        gachaLockStatus[power.Name] = false -- Tandai sudah dibuka
                    end
                end
            end

            -- ============================================================
            -- [A] VISUAL UPDATE (GAMBAR & GRADIENT)
            -- ============================================================
            if isUIOpen and currentItemName and toggleUI then
                local cacheKey = power.Name .. "_" .. tostring(currentItemName)
                
                if gachaImageCache[power.Name] ~= cacheKey then
                    local sourceName = power.Source or power.Name
                    if power.Name == "Sword Passive" then sourceName = "Sword Passives" end
                    
                    local sourceDB = GlobalGachaSources[sourceName]
                    if sourceDB and sourceDB[currentItemName] then
                        local itemData = sourceDB[currentItemName]
                        local gradientObj = nil
                        
                        if GlobalGradientDB and GlobalGradientDB.GetRarityColor then
                            local rData = GlobalGradientDB:GetRarityColor(itemData.Rarity or "Common")
                            if rData then 
                                gradientObj = ColorSequence.new{
                                    ColorSequenceKeypoint.new(0, rData.Base), 
                                    ColorSequenceKeypoint.new(1, rData.Wave)
                                }
                            end
                        end

                        if gradientObj then
                            toggleUI:SetMainImage({Title = currentItemName, Image = itemData.Icon, Gradient = gradientObj}, 50)
                        else
                            toggleUI:SetMainImage(itemData.Icon)
                        end
                        gachaImageCache[power.Name] = cacheKey
                    end
                end
            end

            -- ============================================================
            -- [B] DROPDOWN VISUAL (SWORD SELECTOR)
            -- ============================================================
            if isUIOpen and power.Name == "Sword Passive" and selectedGachaSwordSID and GachaSwordDropdown then
                local currentSwordData = pData.Swords and pData.Swords[selectedGachaSwordSID]
                if currentSwordData then
                     local sName = currentSwordData.Name
                     local sRarity = currentSwordData.Rarity or "Common"
                     local sKey = "SwordDD_" .. sName .. "_" .. sRarity
                     
                     if gachaImageCache["SwordDropdown"] ~= sKey then
                         local iconId = "rbxassetid://84366761557806"
                         if GlobalSwordDB and GlobalSwordDB[sName] then iconId = GlobalSwordDB[sName].Icon end
                         
                         local gradientObj = nil
                         if GlobalGradientDB and GlobalGradientDB.GetRarityColor then
                             local colors = GlobalGradientDB:GetRarityColor(sRarity)
                             if colors then
                                 gradientObj = ColorSequence.new{ColorSequenceKeypoint.new(0, colors.Base), ColorSequenceKeypoint.new(1, colors.Wave)}
                             end
                         end

                         if gradientObj then
                             GachaSwordDropdown:SetMainImage({Image = iconId, Gradient = gradientObj}, 50)
                         else
                             GachaSwordDropdown:SetMainImage(iconId)
                         end
                         gachaImageCache["SwordDropdown"] = sKey
                     end
                end
            end

            -- ============================================================
            -- [C] AUTO ROLL LOGIC
            -- ============================================================
            if power.auto == true then 
                local currentPrice = power.Price or 0
                local balance = 0
                if pData.Items then balance = pData.Items[power.Item] or 0 end
                
                if power.IsTalent and pData.Gacha.Talents then
                    local lockedCount = 0
                    for _, isLocked in pairs(pData.Gacha.Talents.Locked or {}) do if isLocked then lockedCount = lockedCount + 1 end end
                    currentPrice = currentPrice + lockedCount
                end

                if currentPrice > 0 and balance < currentPrice then
                    -- MODIFIKASI: Jika RollMethod Normal dan BUKAN Talent, biarkan tetap ON
                    if power.RollMethod == "Normal" and not power.IsTalent then
                        -- Cukup diam (skip), jangan kirim FireServer dan jangan matikan Toggle
                    else
                        -- Untuk Gacha lainnya (atau jika itu Talent), tetap matikan toggle jika material habis
                        power.auto = false
                        Notify("Gacha", "Not enough " .. power.Item, "x")
                        if toggleUI then toggleUI:Set(false) end
                    end
                else
                    -- Execute Roll
                    local args = {}
                    local stopRolling = false 
                    
                    if power.Name == "Sword Passive" then
                        if not selectedGachaSwordSID then
                            power.auto = false; stopRolling = true
                            Notify("Gacha", "Select a Sword First!", "x")
                            if toggleUI then toggleUI:Set(false) end
                        else
                            local sData = pData.Swords[selectedGachaSwordSID]
                            if sData and SwordPassiveTargets[sData.Passive] then
                                stopRolling = true; power.auto = false
                                Notify("Gacha", "Target: " .. sData.Passive .. " Obtained!", "check")
                                if toggleUI then toggleUI:Set(false) end
                            else
                                args = {{"General", "Gacha", "Roll", power.Name, selectedGachaSwordSID, SwordPassiveTargets, n = 6}, "\2"}
                            end
                        end
                    elseif power.IsTalent then
                         -- Logic Talent (Sama seperti sebelumnya)
                         local tData = pData.Gacha.Talents
                         local allLocked = true
                         for statName, _ in pairs(tData.Currents or {}) do if not (tData.Locked or {})[statName] then allLocked = false break end end
                         if allLocked then
                            power.auto = false; stopRolling = true
                            Notify("System", "All Talents Locked!", "check")
                            if toggleUI then toggleUI:Set(false) end
                         else
                            args = {{"General", "Gacha", "Roll", power.Name, FormattedTalentTargets, n = 5}, "\2"}
                         end
                    else
                        args = {{"General", "Gacha", "Roll", power.Name, {}, n = 5}, "\2"}
                    end
                    
                    if not stopRolling and #args > 0 then
                        ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer(args)
                    end
                end
            end
            
            -- ============================================================
            -- [D] TEXT DESC UPDATE (Only if not Scarlet Locked)
            -- ============================================================
            if isUIOpen and toggleUI and IsMapUnlocked(power.Map) and not gachaLockStatus[power.Name] then
                local currentPrice = power.Price or 0
                local newDescString = ""

                if power.Name == "Sword Passive" then
                      local tCount = 0
                      for _ in pairs(SwordPassiveTargets) do tCount = tCount + 1 end
                      local currentPassiveTxt = (pData.Swords and pData.Swords[selectedGachaSwordSID] and pData.Swords[selectedGachaSwordSID].Passive) or "None"
                      newDescString = "Price: "..currentPrice.." | Targets: "..tCount.."\nCurrent: "..currentPassiveTxt
                elseif power.IsTalent then
                      local count = 0
                      for _ in pairs(FormattedTalentTargets) do count = count + 1 end
                      newDescString = "Price: "..currentPrice.." | Targets: "..count
                else
                      local bal = (pData.Items and pData.Items[power.Item]) or 0
                      newDescString = GlobalItemDB[power.Item].Icon ..power.Item..": "..FormatNumber(bal) .. "/" .. currentPrice
                end

                if gachaDescCache[power.Name] ~= newDescString then
                    toggleUI:SetDesc(newDescString)
                    gachaDescCache[power.Name] = newDescString 
                end
            end
        end
        task.wait(0.5)
    end
end)

-- ============================================================================
--  STRONGER FEATURE (SMART HATCH + SORTED MAPS + UI HIDE)
-- ============================================================================

-- 1. Generate Daftar Star yang TERURUT (Berdasarkan Index Map)
local StarList = {}
local StarsFolder = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Stars")
local TempStarSorter = {}

for _, module in pairs(StarsFolder:GetChildren()) do
    if module:IsA("ModuleScript") then
        local mapName = module.Name
        local mapIndex = 999 -- Default jika tidak punya index (paling bawah)
        
        -- Cek Index dari Database Map Global
        if GlobalMapDB and GlobalMapDB[mapName] then
            mapIndex = GlobalMapDB[mapName].Index or 999
        end
        
        table.insert(TempStarSorter, {Name = mapName, Index = mapIndex})
    end
end

-- Lakukan Sorting (Index Kecil ke Besar)
table.sort(TempStarSorter, function(a, b)
    return a.Index < b.Index
end)

-- Masukkan ke StarList bersih
for _, data in ipairs(TempStarSorter) do
    table.insert(StarList, data.Name)
end

-- Tambahkan opsi None di paling atas
table.insert(StarList, 1, "None")

-- UI Elements
FM_Add("Stronger", MainTab:Dropdown({
    Title = "Auto Hatch (Star)", 
    Values = StarList, -- List sudah terurut (World 1, World 2, ...)
    Value = "None", 
    Flag = "HatchTarget_Cfg", 
    Callback = function(v) 
        targetStar = (type(v)=="table" and v.Title) or v 
    end
}))

-- Helper: Cari Model Star
local function GetStarModel(starName)
    local CollectionService = game:GetService("CollectionService")
    local stars = CollectionService:GetTagged("StarModel")
    for _, model in pairs(stars) do
        if model.Name == starName or model:GetAttribute("ID") == starName then
            return model
        end
    end
    return nil
end

-- [UI HOOK SYSTEM - FIXED RESTORE]
local StarHookConnection = nil

local function HookStarUI(shouldHook)
    local pGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    local starFrame = pGui and pGui:FindFirstChild("Interface") 
        and pGui.Interface:FindFirstChild("Frames") 
        and pGui.Interface.Frames:FindFirstChild("Star")

    if not starFrame then return end

    if shouldHook then
        -- [AKTIFKAN HIDE]
        if not StarHookConnection then
            starFrame.Visible = false
            starFrame.Position = UDim2.new(2, 0, 2, 0) -- Lempar keluar layar
            
            StarHookConnection = starFrame:GetPropertyChangedSignal("Visible"):Connect(function()
                if starFrame.Visible then
                    starFrame.Visible = false
                    starFrame.Position = UDim2.new(2, 0, 2, 0)
                end
            end)
        end
    else
        -- [MATIKAN HIDE & KEMBALIKAN UI]
        if StarHookConnection then
            StarHookConnection:Disconnect()
            StarHookConnection = nil
            
            -- Reset Manual
            starFrame.Visible = true 
            starFrame.Position = UDim2.fromScale(0.5, 0.5)
            starFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        end
    end
end

-- Loop Logic Auto Hatch
task.spawn(function()
    while not Window.Destroyed do
        local pData = getgenv().PlayerData
        local currentMap = pData and pData.Map
        local isGamemode = IsInGamemode()
        
        -- [KONDISI STOP/PAUSE]
        if targetStar == "None" then
            HookStarUI(false)
        end
        
        -- [KONDISI STOP/PAUSE]
        if (targetStar == "None" or not targetStar) or isGamemode or isGlobalBossActive or isTransitioning then
            task.wait(1) 
            continue 
        end

        -- [KONDISI AKTIF]
        HookStarUI(true) -- Pasang Hook

        -- [LOGIKA MAP TARGET]
        local StarModule = StarsFolder:FindFirstChild(targetStar)
        if StarModule then
            local success, StarData = pcall(require, StarModule)
            if success and StarData and StarData.Map then
                local requiredMap = StarData.Map
                if currentMap ~= requiredMap then
                    SmartTeleport(requiredMap)
                    task.wait(2) 
                    continue 
                end
            end
        end

        -- [LOGIKA HATCHING]
        local starModel = GetStarModel(targetStar)
        
        if starModel then
            local starPos = getPosition(starModel)
            
            if starPos and hrp then
                local dist = (hrp.Position - starPos).Magnitude
                
                if dist <= 15 then
                    ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                        {"General", "Stars", "Open", targetStar, 10000, n = 10}, 
                        "\2"
                    })
                else
                    hrp.CFrame = CFrame.new(starPos + Vector3.new(0, 5, 0))
                    task.wait(0.5) 
                end
            end
        end
        
        task.wait(0.2) 
    end
    
    HookStarUI(false)
end)

-- ============================================================================
--  AVATARS FEATURE (GRADIENT STYLE)
-- ============================================================================

local avatarStatsUI -- Object Dropdown Stats
local avatarVisualUI -- Object Dropdown Visual

-- Helper: Hitung Power Asli
local function GetAvatarTotalPower(avatarName, currentLevel)
    local db = GlobalAvatarDB[avatarName]
    if not db or not db.Perks or not db.Perks.Power then return 0 end
    
    local baseAmountStr = db.Perks.Power.Amount
    local basePower = ParseAbbreviated(tostring(baseAmountStr)) or 0
    
    local level = currentLevel or 1
    local multiplier = 1 + ((level - 1) * 0.1)
    
    return basePower * multiplier
end

-- Helper: Buat Gradient Berdasarkan Rarity
local function CreateGradient(rarity)
    if GlobalGradientDB and GlobalGradientDB.GetRarityColor then
        local colors = GlobalGradientDB:GetRarityColor(rarity or "Common")
        if colors and colors.Base and colors.Wave then
            return ColorSequence.new{
                ColorSequenceKeypoint.new(0, colors.Base),
                ColorSequenceKeypoint.new(1, colors.Wave)
            }
        end
    end
    return nil
end
local function RefreshAvatarList()
    local pData = OmniRef.Data
    local listItems = {}
    
    if pData and pData.Avatars and GlobalAvatarDB and GlobalMapDB then
        -- 1. Kelompokkan Avatar berdasarkan World (Map)
        local avatarsByWorld = {}
        
        for name, data in pairs(pData.Avatars) do
            local globalData = GlobalAvatarDB[name]
            if globalData then
                local worldName = globalData.World or "Unknown"
                
                if not avatarsByWorld[worldName] then
                    avatarsByWorld[worldName] = {}
                end
                
                -- Ambil Base Power asli dari database (Unformat string seperti "1.5K" ke angka)
                local basePowerStr = (globalData.Perks and globalData.Perks.Power and globalData.Perks.Power.Amount) or "0"
                local basePowerNum = NumberUtils.Unformat(nil, tostring(basePowerStr)) or 0
                
                -- Hitung Perks untuk tampilan deskripsi
                local perksCalculated = {}
                for perkName, _ in pairs(globalData.Perks or {}) do
                    local val = OmniRef.Utils.Avatars.Multiplier(perkName, data, pData)
                    if val then perksCalculated[perkName] = val end
                end
                local perksDisplayText = OmniRef.Utils.Gacha.GetPerksText(perksCalculated)

                table.insert(avatarsByWorld[worldName], {
                    Title = name, 
                    Desc = "Lvl " .. (data.Level or 1) .. " | " .. perksDisplayText, 
                    Value = name,
                    Icon = globalData.Icon,
                    Rarity = globalData.Rarity,
                    BasePower = basePowerNum -- Kunci utama untuk sorting kedua
                })
            end
        end

        -- 2. Sortir Daftar Map berdasarkan Index (World 1, World 2, dst)
        local sortedMaps = {}
        for mapName, _ in pairs(avatarsByWorld) do
            local mapIdx = (GlobalMapDB[mapName] and GlobalMapDB[mapName].Index) or 999
            table.insert(sortedMaps, {Name = mapName, Index = mapIdx})
        end
        table.sort(sortedMaps, function(a, b) return a.Index < b.Index end)

        -- 3. Masukkan ke List Akhir & Sortir Base Power di dalam Map tersebut
        for _, mapInfo in ipairs(sortedMaps) do
            local avatarsInMap = avatarsByWorld[mapInfo.Name]
            
            -- Sortir berdasarkan Base Power (Kecil ke Besar)
            table.sort(avatarsInMap, function(a, b) 
                return a.BasePower < b.BasePower 
            end)
            
            for _, avatarItem in ipairs(avatarsInMap) do
                table.insert(listItems, avatarItem)
            end
        end
    end
    avatarStatsUI:Refresh(listItems)
    avatarVisualUI:Refresh(listItems)
end
-- [UI Elements Construction]
local AvatarGroup = MainTab:Group({Title = "Avatar Manager"})
FM_Add("Avatars", AvatarGroup)

-- 1. DROPDOWN EQUIP STATS (GRADIENT ADDED)
avatarStatsUI = MainTab:Dropdown({
    Title = "Equip Stats (Power)",
    Desc = "Select avatar for stats multiplier",
    Values = {}, 
    AllowNone = true,
    Multi = false,
    Flag = "AvatarStats_Select", 
    Image = "rbxassetid://84366761557806", 
    Callback = function(v)
        if v and type(v) == "table" then
            local val = v.Value
            local icon = v.Icon
            local powerTxt = v.TotalPower
            local lvl = v.CurrentLevel
            local rarity = v.Rarity -- Ambil Rarity

            -- [GRADIENT LOGIC]
            local gradientObj = CreateGradient(rarity)

            if icon then
                if gradientObj then
                    -- Set Image dengan Gradient
                    avatarStatsUI:SetMainImage({
                        Image = icon,
                        Gradient = gradientObj
                    },50)
                -- else
                --     -- Fallback jika gradient gagal
                --     avatarStatsUI:SetMainImage(icon)
                end
                avatarStatsUI:SetValueImage(icon)
            end
            
            avatarStatsUI:SetDesc("Active: " .. val .. "\nLvl " .. lvl .. " | Pow: " .. powerTxt .. "x")

            -- Logic Equip Game
            local currentEquipped = getgenv().PlayerData and getgenv().PlayerData.Avatar
            if currentEquipped ~= val then
                ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{"General", "Avatars", "Equip", val, n = 4}, "\2"})
                Notify("Stats", "Equipped: " .. val, "swords")
            end
        else
            -- Reset ke Default
            avatarStatsUI:SetMainImage("rbxassetid://84366761557806")
            avatarStatsUI:SetValueImage("rbxassetid://84366761557806")
            avatarStatsUI:SetDesc("Select avatar for stats multiplier")
        end
    end
})
FM_Add("Avatars", avatarStatsUI)

-- 2. DROPDOWN EQUIP VISUAL (GRADIENT ADDED)
avatarVisualUI = MainTab:Dropdown({
    Title = "Equip Visual (Cosmetic)",
    Desc = "Select avatar for appearance only",
    Values = {}, 
    AllowNone = true,
    Multi = false,
    Flag = "AvatarVisual_Select",
    Image = "rbxassetid://84366761557806", 
    Callback = function(v)
        if v and type(v) == "table" then
            local val = v.Value
            local icon = v.Icon
            local rarity = v.Rarity -- Ambil Rarity

            -- [GRADIENT LOGIC]
            local gradientObj = CreateGradient(rarity)
            
            if icon then
                if gradientObj then
                    avatarVisualUI:SetMainImage({
                        Image = icon,
                        Gradient = gradientObj
                    },50)
                else
                    avatarVisualUI:SetMainImage(icon)
                end
                avatarVisualUI:SetValueImage(icon)
            end
            
            avatarVisualUI:SetDesc("Active Visual: " .. val)

            -- Logic Equip Game
            local currentVisual = getgenv().PlayerData and getgenv().PlayerData.AvatarVisual
            if currentVisual ~= val then
                ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{"General", "Avatars", "Visual", val, n = 4}, "\2"})
                Notify("Visual", "Appearance: " .. val, "eye")
            end
        else
            -- Reset ke Default
            avatarVisualUI:SetMainImage("rbxassetid://84366761557806")
            avatarVisualUI:SetValueImage("rbxassetid://84366761557806")
            avatarVisualUI:SetDesc("Select avatar for appearance only")
        end
    end
})
FM_Add("Avatars", avatarVisualUI)

task.spawn(function()
    local lastAvatarCount = -1

    while not Window.Destroyed do
        local pData = OmniRef.Data
        
        if not Window.Closed and pData and pData.Avatars then
            local currentCount = 0
            for _ in pairs(pData.Avatars) do currentCount = currentCount + 1 end

            -- Jika jumlah avatar berubah, lakukan refresh total untuk mengurutkan ulang
            if currentCount ~= lastAvatarCount then
                RefreshAvatarList()
                lastAvatarCount = currentCount
            else
                -- Jika hanya level yang berubah, cukup update teks deskripsi saja
                for name, data in pairs(pData.Avatars) do
                    local globalData = GlobalAvatarDB[name]
                    if globalData then
                        local perksCalculated = {}
                        for perkName, _ in pairs(globalData.Perks or {}) do
                            local val = OmniRef.Utils.Avatars.Multiplier(perkName, data, pData)
                            if val then perksCalculated[perkName] = val end
                        end

                        local perksDisplayText = OmniRef.Utils.Gacha.GetPerksText(perksCalculated)
                        local newDesc = "Lvl " .. (data.Level or 1) .. " | " .. perksDisplayText

                        if avatarStatsUI then avatarStatsUI:Edit(name, {Desc = newDesc}) end
                        if avatarVisualUI then avatarVisualUI:Edit(name, {Desc = newDesc}) end
                    end
                end
            end
        end
        task.wait(2) -- Interval 2 detik untuk performa stabil
    end
end)

-- ============================================================================
--  GLOBAL QUESTS FEATURE (FINAL FIX: NAMED MAP + NO ERRORS)
-- ============================================================================

local GQ_IsAutoClaim = false
local GQ_IsAutoDo = false
local GQ_StatusLabel = nil

local GlobalQuestDB = {}
local EnemyMapLocationDB = {}

-- [1] LOADERS (FIXED: NO TABLE.KEYS ERROR)

local function LoadGameData_GQ()
    local RS = game:GetService("ReplicatedStorage")
    local Shared = RS:WaitForChild("Shared")
    
    -- A. Load Global Quests
    table.clear(GlobalQuestDB) 
    local gqFolder = Shared:WaitForChild("GlobalQuests")
    for _, module in pairs(gqFolder:GetChildren()) do
        if module:IsA("ModuleScript") then
            local success, data = pcall(require, module)
            if success and type(data) == "table" then
                for questID, questData in pairs(data) do
                    local entry = table.clone(questData)
                    entry.QuestType = module.Name
                    entry.ID = questID
                    GlobalQuestDB[questID] = entry
                end
            end
        end
    end
    
    -- Hitung manual (FIX error attempt to call nil value)
    local qCount = 0
    for _ in pairs(GlobalQuestDB) do qCount = qCount + 1 end
    print("[ANHub] Quests Loaded: " .. qCount)

    -- C. Load Enemy Locations
    table.clear(EnemyMapLocationDB)
    local enemiesFolder = Shared:WaitForChild("Enemies")
    for _, mapModule in pairs(enemiesFolder:GetChildren()) do
        if mapModule:IsA("ModuleScript") then
            local mapName = mapModule.Name
            local success, enemiesData = pcall(require, mapModule)
            if success and type(enemiesData) == "table" then
                for enemyName, _ in pairs(enemiesData) do
                    EnemyMapLocationDB[enemyName] = mapName
                end
            end
        end
    end

    -- Hitung manual (FIX error attempt to call nil value)
    local eCount = 0
    for _ in pairs(EnemyMapLocationDB) do eCount = eCount + 1 end
    print("[ANHub] Enemy Locations Indexed: " .. eCount)
end
LoadGameData_GQ()

-- [2] UI ELEMENTS

-- Toggle Auto Claim
FM_Add("Global Quests", MainTab:Toggle({
    Title = "Auto Claim Quests",
    Desc = "Automatically claim rewards when done.",
    Flag = "GQ_AutoClaim_Cfg",
    Callback = function(v) GQ_IsAutoClaim = v end
}))

-- Variabel untuk mengingat status Auto Farm sebelumnya
local wasFarmActive = false

-- Toggle Auto Do (Farming)
FM_Add("Global Quests", MainTab:Toggle({
    Title = "Auto Do Quests (Sorted)",
    Desc = "Teleport & Farm. Starts from Lowest Map.\n(Disables Normal Auto Farm)",
    Flag = "GQ_AutoDo_Cfg",
    Callback = function(v) 
        GQ_IsAutoDo = v 
        
        if v then
            -- [SAAT DINYALAKAN]
            -- 1. Cek apakah Auto Kill sedang nyala
            if isFarm1 then
                wasFarmActive = true
                
                -- Matikan variabel logic farm
                isFarm1 = false 
                
                -- Update Visual Toggle di UI (Matikan Centang)
                if FarmToggleUI and FarmToggleUI.Set then
                    FarmToggleUI:Set(false) 
                end
                
                Notify("System", "Normal Auto Farm Paused for Quests", "check")
            else
                wasFarmActive = false
            end
        else
            -- [SAAT DIMATIKAN]
            -- 1. Kembalikan status Auto Kill jika dulu nyala
            if wasFarmActive then
                isFarm1 = true -- Nyalakan logic farm
                
                -- Update Visual Toggle di UI (Nyalakan Centang)
                if FarmToggleUI and FarmToggleUI.Set then
                    FarmToggleUI:Set(true)
                end
                
                Notify("System", "Normal Auto Farm Resumed", "check")
            end
            
            -- Reset memori
            wasFarmActive = false
        end
    end
}))

-- Status Display
GQ_StatusLabel = FM_Add("Global Quests", MainTab:Paragraph({
    Title = "Quest Status",
    Desc = "Waiting for data scan...",
    Image = "rbxassetid://116941678612804"
}))

-- ============================================================================
--  AUTO GOBLIN KILLER (INFINITE LOOP)
-- ============================================================================

local isAutoGoblin = false
local GoblinQuestName = "Goblin Killer"

-- Definisi Requirement Manual (Berdasarkan Decompile Shared.Quests.Secondary["Goblin Killer"])
local GoblinQuestReqs = {
    {Name = "Goblin", Amount = 50},
    {Name = "Skull Goblin", Amount = 40},
    {Name = "Toothy Goblin", Amount = 30},
    {Name = "Horned Goblin", Amount = 20}
}

-- 1. UI Toggle
FM_Add("Global Quests", MainTab:Toggle({
    Title = "Auto Goblin Killer (Infinite)",
    Desc = "Auto Accept, Farm & Claim recursively.\n(Map: World of Aincrad)",
    Flag = "AutoGoblin_Cfg",
    Callback = function(v)
        isAutoGoblin = v
        if v then
            -- Matikan Auto Quest lama agar tidak bentrok
            if GQ_IsAutoDo then 
                GQ_IsAutoDo = false 
                Notify("System", "Standard Auto Quest Disabled", "info")
            end
            Notify("Quest", "Starting Goblin Loop...", "swords")
        else
            -- Reset target saat dimatikan
            table.clear(targetList)
            isFarm1 = false -- Matikan auto farm agar char diam
            Notify("Quest", "Goblin Loop Stopped.", "stop-circle")
        end
    end
}))

-- 2. Logic Loop
task.spawn(function()
    while not Window.Destroyed do
        if isAutoGoblin then
            local pData = getgenv().PlayerData
            
            if pData and pData.Quests then
                local currentMap = pData.Map
                
                -- [A] CEK MAP: Harus di World of Aincrad
                if currentMap ~= "World of Aincrad"  then
                    if not isTransitioning and not isGlobalBossActive and not isTransitioning and not IsInGamemode() and not IsSwordsmanActive() then
                        Notify("Quest", "Warping to World of Aincrad...", "map")
                        SmartTeleport("World of Aincrad")
                        task.wait(2)
                    end
                else
                    -- [B] CEK STATUS QUEST
                    local activeQuest = pData.Quests.Active[GoblinQuestName]
                    
                    if not activeQuest then
                        -- KONDISI 1: Quest Belum Diambil -> AMBIL
                        ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                            {"General", "Quests", "Active", GoblinQuestName}, 
                            "\2"
                        })
                        Notify("Quest", "Accepted: " .. GoblinQuestName, "check")
                        task.wait(1.5) -- Delay agar data masuk
                    else
                        -- KONDISI 2: Quest Sedang Aktif -> CEK PROGRESS
                        local currentKills = activeQuest.KilledEnemies or {}
                        local targetMob = nil
                        local isCompleted = true

                        -- Cek mana musuh yang belum selesai
                        for _, req in ipairs(GoblinQuestReqs) do
                            local myCount = currentKills[req.Name] or 0
                            if myCount < req.Amount then
                                isCompleted = false
                                targetMob = req.Name
                                break -- Fokus satu per satu (Priority)
                            end
                        end

                        if isCompleted then
                            -- KONDISI 3: Semua Syarat Penuh -> CLAIM (COMPLETE)
                            ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                                {"General", "Quests", "Complete", GoblinQuestName}, 
                                "\2"
                            })
                            Notify("Quest", "Quest Completed! Re-taking...", "gift")
                            task.wait(1.5) -- Delay sebelum ambil ulang
                        else
                            -- KONDISI 4: Belum Selesai -> FARM TARGET
                            if targetMob then
                                -- Override Target List Script Utama
                                local needUpdate = true
                                if #targetList == 1 and targetList[1] == targetMob then
                                    needUpdate = false
                                end

                                if needUpdate then
                                    table.clear(targetList)
                                    table.insert(targetList, targetMob)
                                    
                                    -- Update UI Dropdown (Visual Only) agar user tau lagi kill apa
                                    if UI.EnemyDD then 
                                        UI.EnemyDD:SetMainImage(CharacterIcons[targetMob] or "rbxassetid://84366761557806")
                                        UI.EnemyDD:SetDesc("Quest Target: " .. targetMob)
                                    end
                                    Notify("Quest", "Hunting: " .. targetMob, "target")
                                end

                                -- Paksa Nyalakan Auto Farm Bawaan
                                if not isFarm1 then
                                    isFarm1 = true
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)
-- [3] MAIN LOGIC LOOP (SHOW MAP NAME)
task.spawn(function()
    while not Window.Destroyed do
        local pData = getgenv().PlayerData
        
        if pData and (pData.KilledEnemies or pData.Avatars) then
            
            local completedCount = 0
            local claimableCount = 0
            local inProgressCount = 0
            
            local ActiveKillQuests = {} 
            local pCompleted = pData.GlobalQuestsCompleted or {}

            -- A. LOOP & FILTER QUESTS
            for qID, qData in pairs(GlobalQuestDB) do
                if pCompleted[qID] then
                    completedCount = completedCount + 1
                else
                    local tasks = qData.Tasks or {}
                    local tasksMet = 0
                    
                    local qEnemyName = tasks[1].EnemyName 
                    local qReqAmount = tasks[1].Amount or 0
                    local qCurrent = 0
                    
                    if qData.QuestType == "Kills" then
                        if pData.KilledEnemies and pData.KilledEnemies.Specific then
                            qCurrent = pData.KilledEnemies.Specific[qEnemyName] or 0
                        end
                    elseif qData.QuestType == "LevelUpAvatar" then
                        if pData.Avatars and pData.Avatars[qEnemyName] then
                            qCurrent = pData.Avatars[qEnemyName].Level or 0
                        end
                    end
                    
                    if qCurrent >= qReqAmount then
                        tasksMet = 1
                    end
                    
                    if tasksMet >= 1 then
                        claimableCount = claimableCount + 1
                        if GQ_IsAutoClaim then
                            ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{"General", "GlobalQuests", "Complete", qID, n = 4}, "\2"})
                            if not pData.GlobalQuestsCompleted then pData.GlobalQuestsCompleted = {} end
                            pData.GlobalQuestsCompleted[qID] = true
                            Notify("Global Quest", "Claimed: " .. (qData.DisplayName or qID), "check")
                            task.wait(1) 
                        end
                    else
                        inProgressCount = inProgressCount + 1
                        
                        -- Insert ke Queue Sorting
                        if qData.QuestType == "Kills" then
                            local mapName = EnemyMapLocationDB[qEnemyName] or "Unknown"
                            local mapIdx = 9999
                            if GlobalMapDB[mapName] then
                                mapIdx = GlobalMapDB[mapName].Index or 9999
                            end

                            table.insert(ActiveKillQuests, {
                                ID = qID,
                                Enemy = qEnemyName,
                                Map = mapName,      -- Ini Nama Mapnya (Contoh: Ninja Village)
                                MapIndex = mapIdx,  -- Ini Indexnya (Contoh: 1)
                                Current = qCurrent,
                                Max = qReqAmount
                            })
                        end
                    end
                end
            end

            -- B. SORTING (Index Terkecil Duluan)
            table.sort(ActiveKillQuests, function(a, b)
                if a.MapIndex == b.MapIndex then
                    return (a.Max - a.Current) < (b.Max - b.Current)
                end
                return a.MapIndex < b.MapIndex 
            end)

            -- C. PILIH TARGET
            local activeTarget = nil
            if #ActiveKillQuests > 0 then
                activeTarget = ActiveKillQuests[1]
            end

            -- D. UPDATE UI STATUS (SHOW MAP NAME)
            if not Window.Closed and GQ_StatusLabel then
                local statusMsg = string.format("✅ Done: %d | 🎁 Claim: %d | 🔄 Active: %d", completedCount, claimableCount, inProgressCount)
                
                if activeTarget then
                    -- [UBAH BAGIAN INI] Menampilkan Nama Map
                    statusMsg = statusMsg .. "\n\n⚔️ Priority Target (" .. activeTarget.Map .. "):"
                    statusMsg = statusMsg .. "\nEnemy: " .. activeTarget.Enemy
                    statusMsg = statusMsg .. "\nProgress: " .. FormatNumber(activeTarget.Current) .. " / " .. FormatNumber(activeTarget.Max)
                else
                    if GQ_IsAutoDo then
                         statusMsg = statusMsg .. "\n\n💤 Auto Quest: No active Kill Quests."
                    else
                         statusMsg = statusMsg .. "\n\n💤 Auto Quest: Off"
                    end
                end
                GQ_StatusLabel:SetDesc(statusMsg)
            end

            -- E. EXECUTE FARMING
            if GQ_IsAutoDo and activeTarget and not IsInGamemode() then
                local targetName = activeTarget.Enemy
                local targetMap = activeTarget.Map
                
                if targetMap and targetMap ~= "Unknown" then
                    local currentMap = pData.Map
                    
                    if currentMap ~= targetMap then
                        if not isTransitioning then
                            Notify("Auto Quest", "Warping to " .. targetMap, "map")
                            SmartTeleport(targetMap)
                        end
                    else
                        local hasTarget = false
                        for _, name in ipairs(targetList) do
                            if name == targetName then
                                hasTarget = true
                                break
                            end
                        end
                        if not hasTarget then
                            table.clear(targetList)
                            table.insert(targetList, targetName)
                        end

                        local WorldFolder = workspace:FindFirstChild("Server") and workspace.Server:FindFirstChild("Enemies") and workspace.Server.Enemies:FindFirstChild("World")
                        local MapFolder = WorldFolder and WorldFolder:FindFirstChild(currentMap)
                        local ATTACK_DISTANCE = 5 
                        
                        if MapFolder and hrp and humanoid and humanoid.Health > 0 then
                            for _, mob in pairs(MapFolder:GetChildren()) do
                                if mob.Name == targetName and (mob:GetAttribute("Health") or 0) > 0 then
                                    local tCFrame = mob:IsA("Model") and mob:GetPivot() or mob.CFrame
                                    if tCFrame then
                                        local enemyFloorY = tCFrame.Y 
                                        if mob:IsA("Model") then
                                            local leg = mob:FindFirstChild("Left Leg") or mob:FindFirstChild("Right Leg") or 
                                                        mob:FindFirstChild("LeftFoot") or mob:FindFirstChild("RightFoot") or
                                                        mob:FindFirstChild("LeftLowerLeg") or mob:FindFirstChild("RightLowerLeg")
                                            if leg then enemyFloorY = leg.Position.Y - (leg.Size.Y / 2)
                                            else local _, size = mob:GetBoundingBox(); enemyFloorY = tCFrame.Y - (size.Y / 2) end
                                        else enemyFloorY = tCFrame.Y - (mob.Size.Y / 2) end

                                        local myHip = humanoid.HipHeight; if myHip < 1.5 then myHip = 2 end 
                                        local finalY = enemyFloorY + myHip + (hrp.Size.Y / 2)

                                        local attackPos = (tCFrame * CFrame.new(0, 0, ATTACK_DISTANCE)).Position
                                        local lookAtPos = Vector3.new(tCFrame.X, finalY, tCFrame.Z)
                                        hrp.CFrame = CFrame.new(Vector3.new(attackPos.X, finalY, attackPos.Z), lookAtPos)
                                        break 
                                    end
                                end
                            end
                        end
                    end
                end
            
            elseif GQ_IsAutoDo and not activeTarget and inProgressCount == 0 then
                GQ_IsAutoDo = false
                Notify("Auto Quest", "All Kill Quests Completed!", "check")
            end
        end
        task.wait()
    end
end)
-- ============================================================================
--  HEROES EXPEDITION FEATURE (SORTED MAPS + WEBHOOK)
-- ============================================================================

local ExpGroup = MainTab:Group({Title = "Expedition Manager"})
FM_Add("Expedition", ExpGroup)

local function SendExpeditionWebhook(status, mapName)
    local pName = game.Players.LocalPlayer.Name
    local censoredName = "||" .. string.sub(pName, 1, 3) .. string.rep("*", #pName - 3) .. "||"
    
    local titleText = "🚀 Expedition Started"
    local embedColor = 16776960
    if status == "Claimed" then
        embedColor = 65280
        titleText = "✅ Expedition Claimed"
    end
    
    local desc = "User: " .. censoredName .. "\nWorld: **" .. (mapName or "Unknown") .. "**"
    SendWebhook(titleText, desc, embedColor)
end

-- Vars
local isAutoExpeditionSmart = false
local selectedExpWorld = "XYZ Metropolis"
local ExpStatusLabel = nil

-- [LOGIKA SORTING MAP BERDASARKAN INDEX]
local ExpWorldList = {}
local TempExpSorter = {}

if GlobalHeroesExpeditionDB then
    for k, v in pairs(GlobalHeroesExpeditionDB) do
        if type(v) == "table" and v.Time then
            -- Ambil Index dari Database Map Global agar urutannya benar
            local mapIndex = 999
            if GlobalMapDB and GlobalMapDB[k] then
                mapIndex = GlobalMapDB[k].Index or 999
            end
            table.insert(TempExpSorter, {Name = k, Index = mapIndex})
        end
    end
    
    -- Urutkan dari Index Kecil (World 1) ke Besar
    table.sort(TempExpSorter, function(a, b)
        return a.Index < b.Index
    end)
    
    -- Masukkan ke list bersih
    for _, data in ipairs(TempExpSorter) do
        table.insert(ExpWorldList, data.Name)
    end
end

-- 2. UI Elements
FM_Add("Expedition", MainTab:Toggle({
    Title = "Auto Expedition (Smart)",
    Desc = "Auto Start, Wait & Claim Rewards",
    Flag = "AutoExp_Smart_Cfg",
    Callback = function(v) isAutoExpeditionSmart = v end
}))

FM_Add("Expedition", MainTab:Dropdown({
    Title = "Select Target World",
    Values = ExpWorldList, -- List sudah terurut
    Value = "XYZ Metropolis",
    Flag = "ExpWorld_Select",
    Callback = function(v) selectedExpWorld = v end
}))

ExpStatusLabel = MainTab:Paragraph({
    Title = "Status: Idle",
    Desc = "Waiting for activation...",
    Image = "rbxassetid://116941678612804" -- Icon Power
})
FM_Add("Expedition", ExpStatusLabel)

-- Helper: Format Waktu (Detik ke MM:SS)
local function FormatTime(seconds)
    if seconds <= 0 then return "Ready!" end
    local m = math.floor(seconds / 60)
    local s = seconds % 60
    return string.format("%02d:%02d", m, s)
end

-- 3. LOGIC LOOP
task.spawn(function()
    local hasNotifiedStart = false

    while not Window.Destroyed do
        if isAutoExpeditionSmart then
            local pData = getgenv().PlayerData
            
            if pData and pData.HeroesExpedition then
                local expData = pData.HeroesExpedition
                local endTime = expData.EndTime
                
                if ExpStatusLabel then
                    if endTime then
                        local timeLeft = endTime - os.time()
                        local currentMapName = expData.World or expData.Map or selectedExpWorld or "Unknown"

                        if timeLeft > 0 then
                            ExpStatusLabel:SetTitle("Status: Exploring...")
                            ExpStatusLabel:SetDesc("Map: " .. currentMapName .. "\nTime Left: " .. FormatTime(timeLeft))
                            hasNotifiedStart = false 
                        else
                            ExpStatusLabel:SetTitle("Status: Finished!")
                            ExpStatusLabel:SetDesc("Collecting Rewards...")
                        end
                    else
                        ExpStatusLabel:SetTitle("Status: Idle / Starting")
                        ExpStatusLabel:SetDesc("Target: " .. (selectedExpWorld or "None"))
                    end
                end

                if endTime then
                    if os.time() >= endTime then
                        ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                            {"General", "HeroesExpedition", "Claim", n = 3}, 
                            "\2"
                        })
                        
                        local mapName = expData.World or expData.Map or "Unknown"
                        Notify("Expedition", "Expedition Claimed!", "check")
                        SendExpeditionWebhook("Claimed", mapName)
                        
                        task.wait(2) 
                    end
                else
                    if selectedExpWorld and selectedExpWorld ~= "None" then
                        if GlobalHeroesExpeditionDB[selectedExpWorld] then
                            ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                                {"General", "HeroesExpedition", "Start", selectedExpWorld, n = 4}, 
                                "\2"
                            })
                            
                            if not hasNotifiedStart then
                                SendExpeditionWebhook("Started", selectedExpWorld)
                                hasNotifiedStart = true
                            end
                            
                            task.wait(2)
                        end
                    end
                end
            end
        else
             if ExpStatusLabel then
                ExpStatusLabel:SetTitle("Status: Disabled")
                ExpStatusLabel:SetDesc("Turn on Toggle to start.")
             end
        end
        task.wait(1)
    end
end)

-- ============================================================================
--  ENCHANTMENT SYSTEM (SMART REFRESH + VISUAL UPDATE + WEBHOOK)
-- ============================================================================

-- [WEBHOOK CONFIG - Reused]


local function SendEnchantWebhook(swordName, oldLvl, newLvl, rarity)
    local pName = game.Players.LocalPlayer.Name
    local censoredName = "||" .. string.sub(pName, 1, 3) .. string.rep("*", #pName - 3) .. "||"
    
    local embedColor = 10181046 -- Ungu (Default Enchant)
    if rarity == "Mythical" then embedColor = 10181046 
    elseif rarity == "Scarlet" then embedColor = 16711680 end

    local desc = "User: " .. censoredName .. "\n" ..
                    "Sword: **" .. swordName .. "**\n" ..
                    "Level: **" .. oldLvl .. "** ➡️ **" .. newLvl .. "**"

    SendWebhook("⚔️ Sword Enchanted!", desc, embedColor)
end

-- 1. Setup Dynamic Database
local EnchantmentDB = {}

local function LoadDynamicEnchantmentDB()
    local success, result = pcall(function()
        return require(ReplicatedStorage.Shared.SwordEnchantments)
    end)
    
    if success and type(result) == "table" then
        EnchantmentDB = result
    end
end

LoadDynamicEnchantmentDB()

-- Variables Logic
local selectedEnchantSID = nil
local isAutoEmpower = false
local EnchantStatusLabel -- Forward declaration
local EnchantDropdown -- Forward declaration

-- Helper: Ambil Daftar Pedang yang Dipakai
local function GetEquippedSwordList()
    local list = {}
    local pData = getgenv().PlayerData
    
    if pData and pData.SwordsEquipped and pData.Swords then
        for sid, _ in pairs(pData.SwordsEquipped) do
            local swordData = pData.Swords[sid]
            if swordData then
                local name = swordData.Name
                local rarity = swordData.Rarity or "Common"
                local enchantInfo = swordData.Enchantment or {}
                local lvl = enchantInfo.Level or 0
                local kills = enchantInfo.Kills or 0
                
                local displayName = string.format("%s (Lvl %d)", name, lvl)
                local descStr = string.format("Rarity: %s | Kills: %s", rarity, FormatNumber(kills))
                
                local iconId = "rbxassetid://84366761557806"
                if GlobalSwordDB and GlobalSwordDB[name] then
                    iconId = GlobalSwordDB[name].Icon
                end

                local gradientObj = nil
                if GlobalGradientDB and GlobalGradientDB.GetRarityColor then
                    local colors = GlobalGradientDB:GetRarityColor(rarity)
                    if colors and colors.Base and colors.Wave then
                        gradientObj = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, colors.Base),
                            ColorSequenceKeypoint.new(1, colors.Wave)
                        }
                    end
                end

                table.insert(list, {
                    Title = displayName,
                    Desc = descStr,
                    Value = sid,
                    Icon = iconId,
                    Gradient = gradientObj,
                    SortLvl = lvl,
                    SortKills = kills
                })
            end
        end
        table.sort(list, function(a,b) return a.SortLvl > b.SortLvl end)
    end
    return list
end

-- 2. UI Elements
EnchantDropdown = FM_Add("Enchant", MainTab:Dropdown({
    Title = "Select Equipped Sword",
    Desc = "Auto refresh based on your equipped swords.",
    Values = GetEquippedSwordList(),
    Value = nil,
    Flag = "Enchant_SwordSelect",
    Callback = function(v)
        local val = (type(v) == "table" and v.Value) or v
        selectedEnchantSID = val
        
        -- [FIX] Jika 'v' hanya Value (dari Config), cari Object lengkapnya agar Gradient muncul
        if type(v) ~= "table" then
            local list = GetEquippedSwordList()
            for _, item in ipairs(list) do
                if item.Value == val then
                    v = item
                    break
                end
            end
        end

        if type(v) == "table" and v.Icon and EnchantDropdown then
             if EnchantDropdown.SetValueImage then EnchantDropdown:SetValueImage(v.Icon) end
             if EnchantDropdown.SetMainImage then
                 if v.Gradient then
                     EnchantDropdown:SetMainImage({Image = v.Icon, Gradient = v.Gradient}, 50)
                 else
                     EnchantDropdown:SetMainImage(v.Icon)
                 end
             end
             EnchantDropdown:SetDesc("Selected: " .. (v.Title or "Unknown"))
        else
             if EnchantDropdown.SetMainImage then EnchantDropdown:SetMainImage("rbxassetid://84366761557806") end
             if EnchantDropdown.SetValueImage then EnchantDropdown:SetValueImage("rbxassetid://84366761557806") end
             EnchantDropdown:SetDesc("Auto refresh based on your equipped swords.")
        end
    end
}))

EnchantStatusLabel = FM_Add("Enchant", MainTab:Paragraph({
    Title = "Status: None",
    Desc = "Select a sword to see enchantment progress.",
}))

FM_Add("Enchant", MainTab:Toggle({
    Title = "Auto Empower (Upgrade)",
    Desc = "Automatically upgrade sword when kills requirement met.",
    Flag = "AutoEmpower_Cfg",
    Callback = function(v) isAutoEmpower = v end
}))

-- [3. LOGIC LOOP ENCHANTMENT - FINAL (OPTIMIZED + LVL 0 LOGIC FIXED + DYNAMIC IMAGE)]
task.spawn(function()
    -- Tracker Data Logika
    local lastSwordDataSignature = ""
    local trackedSwordID = nil
    local lastKnownLevel = -1
    
    -- Tracker Data Visual (Cache)
    local visualCache = {
        ImageKey = "",
        Title = "",
        Desc = "",
        StatusIcon = "" -- Cache baru untuk Icon Label
    }

    while not Window.Destroyed do
        -- [SAFETY] Matikan loop jika UI hancur
        if Window.Destroyed then break end

        local pData = getgenv().PlayerData
        
        -- ============================================================
        -- [A] SMART REFRESH LIST (Dropdown Content)
        -- ============================================================
        if not Window.Closed and EnchantDropdown and EnchantDropdown.Opened and pData and pData.SwordsEquipped then
            local equipKeys = {}
            for k in pairs(pData.SwordsEquipped) do table.insert(equipKeys, k) end
            table.sort(equipKeys)
            
            local currentSig = ""
            for _, sid in ipairs(equipKeys) do
                local sData = pData.Swords[sid]
                if sData then
                    local lvl = (sData.Enchantment and sData.Enchantment.Level) or 0
                    local kills = (sData.Enchantment and sData.Enchantment.Kills) or 0
                    currentSig = currentSig .. sid .. ":" .. lvl .. ":" .. kills .. "|"
                end
            end
            
            if currentSig ~= lastSwordDataSignature then
                lastSwordDataSignature = currentSig
                EnchantDropdown:Refresh(GetEquippedSwordList())
            end
        end

        -- ============================================================
        -- [B] DATA PROCESSING (Background Friendly)
        -- ============================================================
        if selectedEnchantSID and pData and pData.Swords then
            local swordData = pData.Swords[selectedEnchantSID]
            
            if swordData then
                -- Reset tracker jika ganti pedang
                if trackedSwordID ~= selectedEnchantSID then
                    trackedSwordID = selectedEnchantSID
                    lastKnownLevel = (swordData.Enchantment and swordData.Enchantment.Level) or 0
                    
                    -- Reset Visual Cache agar UI langsung update
                    visualCache.ImageKey = ""
                    visualCache.Title = ""
                    visualCache.Desc = ""
                    visualCache.StatusIcon = ""
                end

                local enchantData = swordData.Enchantment or {Kills = 0, Level = 0}
                local currentLevel = enchantData.Level or 0
                local currentKills = enchantData.Kills or 0
                
                -- Webhook Trigger
                if currentLevel > lastKnownLevel then
                    Notify("Enchant", "Sword Level Up! " .. lastKnownLevel .. " -> " .. currentLevel, "chevrons-up")
                    SendEnchantWebhook(swordData.Name, lastKnownLevel, currentLevel, swordData.Rarity)
                    lastKnownLevel = currentLevel
                end
                
                -- ============================================================
                -- [C] VISUAL UPDATE (Rendering Berat)
                -- SYARAT: UI Tidak Minimized (Not Closed)
                -- ============================================================
                if not Window.Closed then
                    
                    -- 1. UPDATE GAMBAR DROPDOWN & GRADIENT (Dengan Caching)
                    if EnchantDropdown and EnchantDropdown.SetMainImage then
                        local sName = swordData.Name
                        local sRarity = swordData.Rarity or "Common"
                        local currentImageKey = sName .. "_" .. sRarity
                        
                        if visualCache.ImageKey ~= currentImageKey then
                            local iconId = "rbxassetid://84366761557806"
                            if GlobalSwordDB and GlobalSwordDB[sName] then iconId = GlobalSwordDB[sName].Icon end
                            
                            local gradientObj = nil
                            if GlobalGradientDB and GlobalGradientDB.GetRarityColor then
                                local colors = GlobalGradientDB:GetRarityColor(sRarity)
                                if colors and colors.Base and colors.Wave then
                                    gradientObj = ColorSequence.new{
                                        ColorSequenceKeypoint.new(0, colors.Base),
                                        ColorSequenceKeypoint.new(1, colors.Wave)
                                    }
                                end
                            end

                            if gradientObj then
                                EnchantDropdown:SetMainImage({Image = iconId, Gradient = gradientObj}, 50)
                            else
                                EnchantDropdown:SetMainImage(iconId)
                            end
                            visualCache.ImageKey = currentImageKey
                        end
                    end

                    -- 2. UPDATE TEKS TITLE & DESC (Level 0 Fix)
                    local nextLevelData = EnchantmentDB[currentLevel + 1]
                    local currentLevelData = EnchantmentDB[currentLevel]
                    
                    local newTitle, newDesc = "", ""
                    
                    -- Helper Format Perks
                    local function GetPerksString(data)
                        local str = ""
                        if data and data.Perks then
                            for k, v in pairs(data.Perks) do
                                local suffix = (k == "Luck") and "" or "%"
                                str = str .. " • " .. k .. ": +" .. v .. suffix .."\n"
                            end
                        end
                        return str
                    end

                    if nextLevelData then
                        -- Hitung Progress
                        local targetKills = ParseAbbreviated(tostring(nextLevelData.Kills))
                        local progress = 0
                        if targetKills > 0 then progress = math.clamp(currentKills / targetKills, 0, 1) end
                        local percent = math.floor(progress * 100)
                        
                        -- [LOGIC TITLE - LEVEL 0 HANDLER]
                        if currentLevel == 0 then
                            newTitle = string.format("Lvl 0 (%d%%)", percent)
                        else
                            local encName = (currentLevelData and currentLevelData.Name) or "Unknown"
                            newTitle = string.format("Lvl %d: %s (%d%%)", currentLevel, encName, percent)
                        end
                        
                        -- Deskripsi Dasar
                        newDesc = string.format("Kills: %s / %s", FormatNumber(currentKills), FormatNumber(targetKills))
                        if currentLevel > 0 then
                             newDesc = newDesc .. "\nNext: " .. (nextLevelData.Name or "Unknown")
                        else
                             newDesc = newDesc .. "\nTarget: " .. (nextLevelData.Name or "Unknown")
                        end
                        
                        -- [LOGIC PERKS - LEVEL 0 HANDLER]
                        local perksHeader = ""
                        local perksSource = nil
                        
                        if currentLevel == 0 then
                            perksHeader = "\n\nNext Perks (Lvl 1):\n"
                            perksSource = nextLevelData
                        else
                            perksHeader = "\n\nCurrent Perks:\n"
                            perksSource = currentLevelData
                        end
                        
                        local perksStr = GetPerksString(perksSource)
                        if perksStr ~= "" then
                            newDesc = newDesc .. perksHeader .. perksStr
                        end
                        
                        -- Logic Auto Empower (Versi Visual)
                        if isAutoEmpower and currentKills >= targetKills then
                            ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                                {"General", "SwordEnchantments", "Empower", selectedEnchantSID, n = 4}, "\2"
                            })
                            task.wait(2)
                        end
                    else
                        -- MAX LEVEL HANDLER
                        newTitle = "MAX LEVEL REACHED"
                        local encName = (currentLevelData and currentLevelData.Name) or "Unknown"
                        newDesc = "Enchantment: " .. encName .. "\nMax Perks Active."
                        
                        local perksStr = GetPerksString(currentLevelData)
                        if perksStr ~= "" then
                            newDesc = newDesc .. "\n\n" .. perksStr
                        end
                    end
                    
                    -- [BARU] UPDATE IMAGE STATUS LABEL BERDASARKAN DATABASE
                    local targetStatusIcon = "rbxassetid://111231588957724" -- Default Fallback
                    
                    -- Logic: Jika Level > 0, pakai icon Level tersebut. Jika 0, pakai icon Level 1 (Target).
                    local iconLevel = (currentLevel > 0) and currentLevel or 1
                    
                    if EnchantmentDB and EnchantmentDB[iconLevel] and EnchantmentDB[iconLevel].Icon then
                        targetStatusIcon = EnchantmentDB[iconLevel].Icon
                    end

                    -- Apply Image Update dengan Cache Check
                    if EnchantStatusLabel and visualCache.StatusIcon ~= targetStatusIcon then
                        EnchantStatusLabel:SetImage(targetStatusIcon)
                        visualCache.StatusIcon = targetStatusIcon
                    end

                    -- Update UI Title
                    if EnchantStatusLabel and visualCache.Title ~= newTitle then
                        EnchantStatusLabel:SetTitle(newTitle)
                        visualCache.Title = newTitle
                    end

                    -- Update UI Description
                    if EnchantStatusLabel and visualCache.Desc ~= newDesc then
                        EnchantStatusLabel:SetDesc(newDesc)
                        visualCache.Desc = newDesc
                    end

                -- ============================================================
                -- [D] BACKUP LOGIC (Saat Minimized)
                -- ============================================================
                elseif isAutoEmpower then
                    visualCache.ImageKey = "" -- Reset cache visual
                    visualCache.StatusIcon = ""
                    
                    local nextLevelData = EnchantmentDB[currentLevel + 1]
                    if nextLevelData then
                         local targetKills = ParseAbbreviated(tostring(nextLevelData.Kills))
                         if currentKills >= targetKills then
                            ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                                {"General", "SwordEnchantments", "Empower", selectedEnchantSID, n = 4}, "\2"
                            })
                            task.wait(2)
                         end
                    end
                end
            else
                selectedEnchantSID = nil
            end
        end
        
        task.wait(1) 
    end
end)
-- [DATABASE & SOURCE LOADER]
GlobalGachaUpgradeDB = {}
GU_ItemSources = {} -- Untuk menyimpan data ikon dari Titles & Winter Legends
GU_ToggleObjects = {}

-- 1. Load Data Source (Titles & Winter Legends)
function LoadGU_Sources()
    -- Masukkan data yang Anda berikan ke dalam satu tabel referensi
    local Titles = require(game:GetService("ReplicatedStorage").Shared.Gacha.Sources.Titles) --
    local WinterLegends = require(game:GetService("ReplicatedStorage").Shared.Gacha.Sources["Winter Legends"]) --
    
    GU_ItemSources["Title"] = Titles
    GU_ItemSources["Winter Legend"] = WinterLegends
end

-- 2. Load Data System Gacha Upgrade
function LoadGachaUpgradeData()
    local RS = game:GetService("ReplicatedStorage")
    local folder = RS.Shared.GachaUpgrade.Systems
    for _, module in pairs(folder:GetChildren()) do
        if module:IsA("ModuleScript") then
            local success, data = pcall(require, module)
            if success then GlobalGachaUpgradeDB[module.Name] = data end
        end
    end
end

LoadGU_Sources()
LoadGachaUpgradeData()
-- ============================================================================
--  GACHA UPGRADE UI GENERATOR (2 ITEMS PER GROUP)
-- ============================================================================

counter = 0

-- Kita buat daftar nama yang terurut agar posisi UI tetap konsisten setiap kali dijalankan
sortedNames = {}
for name, _ in pairs(GlobalGachaUpgradeDB) do table.insert(sortedNames, name) end
table.sort(sortedNames)

for _, sysName in ipairs(sortedNames) do
    sysData = GlobalGachaUpgradeDB[sysName]
    counter = counter + 1

    -- Logika membuat Group baru setiap kelipatan 1 (item ke-1, ke-3, ke-5, dst)
    if counter % 2 == 1 then
        currentGachaUpgradeGroup = MainTab:Group({})
        FM_Add("Gacha Upgrade", currentGachaUpgradeGroup)
    end

    -- Membuat Toggle di dalam Group yang saat ini aktif
    sysToggle = currentGachaUpgradeGroup:Toggle({
        Title = sysName,
        Desc = "Initializing...",
        Flag = "GU_Auto_" .. sysName, -- Tersimpan otomatis ke dalam Config
        Callback = function(v) 
            -- Logika auto-buy akan dijalankan oleh task.spawn utama
        end
    })
    
    -- Simpan objek toggle ke dalam tabel referensi untuk diupdate oleh loop visual
    GU_ToggleObjects[sysName] = sysToggle

    -- Inisialisasi awal gambar utama agar tidak kosong saat baru dibuka
    if sysToggle.SetMainImage then
        sysToggle:SetMainImage(sysData.Icon or "rbxassetid://92311143570283")
    end
end
-- [MAIN LOOP: LOGIKA & VISUAL DENGAN CACHING KETAT]
task.spawn(function()
    local GU_VisualCache = {}

    while not Window.Destroyed do
        local pData = getgenv().PlayerData
        if pData and pData.GachaUpgrade then
            
            for sysName, sysData in pairs(GlobalGachaUpgradeDB) do
                local toggleUI = GU_ToggleObjects[sysName]
                local upgradeConfig = sysData.Upgrade
                
                -- 1. Ambil Data Dasar
                local currentItem = (pData.Gacha and pData.Gacha[sysName] and pData.Gacha[sysName].Current) or "None"
                local currentLevel = (pData.GachaUpgrade[sysName] and pData.GachaUpgrade[sysName][currentItem]) or 0
                
                -- 2. Ambil Data Cost (Material)
                local costItemName = sysData.Price.Name
                local myBalance = (pData.Items and pData.Items[costItemName]) or 0
                local costItemIcon = ""
                if GlobalItemDB and GlobalItemDB[costItemName] then
                    costItemIcon = GlobalItemDB[costItemName].Icon or ""
                end

                -- 3. Kalkulasi Harga & Chance
                local targetPrice = upgradeConfig.Price.Base + (upgradeConfig.Price.Effect * currentLevel)
                local currentChance = math.max(upgradeConfig.Chance.Minimum, upgradeConfig.Chance.Base + (upgradeConfig.Chance.Effect * currentLevel))

                -- 4. LOGIKA UPDATE VISUAL (Hanya jika data berubah)
                if toggleUI and not Window.Closed then
                    local currentDataKey = sysName .. "_" .. currentItem .. "_" .. currentLevel .. "_" .. myBalance
                    
                    if GU_VisualCache[sysName] ~= currentDataKey then
                        -- A. Update SetMainImage
                        local itemSourceData = GU_ItemSources[sysName] and GU_ItemSources[sysName][currentItem]
                        local itemIcon = itemSourceData and itemSourceData.Icon or sysData.Icon
                        local itemRarity = itemSourceData and itemSourceData.Rarity or "Common"
                        
                        local rarityGradient = nil
                        if GlobalGradientDB and GlobalGradientDB.GetRarityColor then
                            local colors = GlobalGradientDB:GetRarityColor(itemRarity)
                            rarityGradient = ColorSequence.new{
                                ColorSequenceKeypoint.new(0, colors.Base),
                                ColorSequenceKeypoint.new(1, colors.Wave)
                            }
                        end

                        -- Tambahkan [MAX] pada judul jika sudah maksimal
                        local displayTitle = currentItem .. (currentLevel >= upgradeConfig.Levels and " [MAX]" or "")

                        toggleUI:SetMainImage({
                            Image = itemIcon,
                            Title = displayTitle,
                            Quantity = "Lvl " .. currentLevel, 
                            Gradient = rarityGradient
                        }, 50)

                        -- B. Update SetDesc
                        local descText = string.format(
                            "Rate: %d%%\n%s%s %s / %s",
                            currentChance,
                            costItemIcon,
                            costItemName,
                            FormatNumber(myBalance),
                            FormatNumber(targetPrice)
                        )
                        toggleUI:SetDesc(descText)

                        if toggleUI.SetQuantity then
                            toggleUI:SetQuantity(currentLevel)
                        end

                        -- [FITUR BARU] AUTO LOCK JIKA MAX LEVEL
                        if currentLevel >= upgradeConfig.Levels then
                            toggleUI:Lock() -- Mengunci toggle agar tidak bisa diklik
                            if toggleUI.Value then 
                                toggleUI:Set(false) -- Matikan status toggle jika masih ON
                            end
                        else
                            toggleUI:Unlock() -- Pastikan terbuka jika level di bawah max
                        end

                        GU_VisualCache[sysName] = currentDataKey
                    end
                end

                -- 5. EKSEKUSI AUTO UPGRADE
                if toggleUI and toggleUI.Value == true and currentLevel < upgradeConfig.Levels then
                    if myBalance >= targetPrice then
                        game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
                            {"General", "GachaUpgrade", "Upgrade", sysName}, 
                            "\2"
                        })
                        task.wait(0.4) 
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- [DATABASE MERCHANT]
GlobalMerchantDB = {}
Merchant_ToggleObjects = {}
Merchant_SelectedName = "Christmas Merchant"

function LoadMerchantData()
    RS = game:GetService("ReplicatedStorage")
    folder = RS:WaitForChild("Shared"):WaitForChild("Merchant")
    
    for _, module in pairs(folder:GetChildren()) do
        if module:IsA("ModuleScript") then
            local success, data = pcall(require, module)
            if success then
                GlobalMerchantDB[module.Name] = data
            end
        end
    end
end
LoadMerchantData()

-- ============================================================================
--  MERCHANT FEATURE (DYNAMIC AUTO BUY)
-- ============================================================================

MerchantList = {}
for name, _ in pairs(GlobalMerchantDB) do
    if name ~= "Merchant" then
        table.insert(MerchantList, name)
    end
end

FM_Add("Merchant", MainTab:Dropdown({
    Title = "Select Merchant",
    Values = MerchantList,
    Value = "Christmas Merchant",
    Callback = function(v) 
        Merchant_SelectedName = v 
        -- Opsional: Tambahkan logika refresh UI di sini jika ingin instan
    end
}))

-- Container untuk Toggle Item Merchant
MerchantItemContainer = {}

-- Fungsi untuk membuat/membersihkan Toggle barang Merchant
function RefreshMerchantUI()
    -- Bersihkan UI lama jika ada (logika serupa ClearWUToggles)
    for _, tgl in pairs(MerchantItemContainer) do
        pcall(function() if tgl.ElementFrame then tgl.ElementFrame:Destroy() end end)
    end
    table.clear(MerchantItemContainer)

    local db = GlobalMerchantDB[Merchant_SelectedName]
    if not db or not db.List then return end

    local currentGroup
    local counter = 0
    
    -- Sortir berdasarkan Index agar urutan rapi
    local sortedItems = {}
    for name, data in pairs(db.List) do
        if name ~= "Merchant" then
            table.insert(sortedItems, {Name = name, Data = data})
        end
    end
    table.sort(sortedItems, function(a, b) return (a.Data.Index or 0) < (b.Data.Index or 0) end)

    for _, item in ipairs(sortedItems) do
        counter = counter + 1
        if counter % 2 == 1 then
            currentGroup = MainTab:Group({})
            FM_Add("Merchant", currentGroup)
        end

        local itemName = item.Name
        local itemData = item.Data

        local tgl = currentGroup:Toggle({
            Title = itemName,
            Desc = "Price: " .. itemData.Price,
            Flag = "Merchant_Auto_" .. Merchant_SelectedName .. "_" .. itemName,
            Callback = function(v) end
        })

        MerchantItemContainer[itemName] = tgl
        
        -- Inisialisasi Visual (Ambil Icon dari Info Utils)
        task.spawn(function()
            local info = OmniRef.Utils.Info:Get(itemData.Type, itemName)
            if info and info.Icon then
                tgl:SetMainImage(info.Icon)
            end
        end)
    end
end

-- Panggil refresh pertama kali
task.spawn(RefreshMerchantUI)

-- [MAIN LOOP: AUTO BUY & VISUAL SYNC DENGAN FORMAT PRICE BARU]
task.spawn(function()
    local Merchant_VisualCache = {}

    while not Window.Destroyed do
        local pData = getgenv().PlayerData
        local dbName = Merchant_SelectedName
        local db = GlobalMerchantDB[dbName]
        
        if pData and db and db.List then
            -- 1. Ambil Info Mata Uang (Menggunakan logika Modul Info Game)
            local priceInfo = GetItemInfo(db.Price.Type, db.Price.Item)
            local currencyIcon = priceInfo and priceInfo.Icon or ""
            local currencyName = db.Price.Item
            
            -- Ambil Saldo
            local myBalance = 0
            if db.Price.Type == "Currency" or db.Price.Type == "Currencies" then
                myBalance = pData[currencyName] or 0
            else
                myBalance = (pData.Items and pData.Items[currencyName]) or 0
            end

            for itemName, itemData in pairs(db.List) do
                local toggleUI = MerchantItemContainer[itemName]
                
                if toggleUI then
                    -- 2. Logika Stok & Batas Beli (v_u_20 logic)
                    local mData = (pData.Merchant and pData.Merchant[dbName]) or {Bought={}, Stock={}}
                    local boughtCount = mData.Bought[itemName] or 0
                    local srvStock = (mData.Stock[itemName] and mData.Stock[itemName].Amount) or 0
                    
                    local remMax = itemData.Max and (itemData.Max - boughtCount) or 999999
                    local remStock = itemData.Stock and (itemData.Stock - srvStock) or 999999
                    local realStock = math.min(remMax, remStock)

                    -- 3. LOGIKA UPDATE VISUAL (Hanya jika data berubah)
                    -- Cache Key unik: Map + Item + Stok + Saldo
                    local cacheKey = dbName .. itemName .. realStock .. myBalance
                    
                    if Merchant_VisualCache[itemName] ~= cacheKey and not Window.Closed then
                        -- Format: <img /> Nama Harga / Material
                        local priceText = string.format(
                            "%s%s %s / %s\nStock: %s",
                            currencyIcon,           -- Gambar harganya
                            currencyName,           -- Namanya
                            itemData.Price,         -- Harganya (String)
                            FormatNumber(myBalance), -- Material saat ini
                            realStock > 0 and realStock or "OUT"
                        )
                        
                        -- Update Deskripsi UI
                        toggleUI:SetDesc(priceText)
                        
                        -- Update Status Kunci (Lock) jika stok habis
                        if realStock <= 0 then
                            toggleUI:Lock()
                            if toggleUI.Value then toggleUI:Set(false) end
                        else
                            toggleUI:Unlock()
                        end
                        
                        Merchant_VisualCache[itemName] = cacheKey
                    end

                    -- 4. Eksekusi Auto Buy (Langsung cek .Value)
                    if toggleUI.Value == true and realStock > 0 then
                        local priceNum = ParseAbbreviated(itemData.Price)
                        if myBalance >= priceNum then
                            game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
                                {"General", "Merchant", "Buy", dbName, itemName, 1}, 
                                "\2"
                            })
                            task.wait(0.5) -- Jeda antar pembelian
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)


-- 3. Info Display (Price & Drops)
local SupremeInfoLabel = FM_Add("Bosses", MainTab:Paragraph({
    Title = "Requirement & Drops",
    Desc = "Select a Boss to see details."
}))
-- ============================================================================
--  SUPREME BOSSES FEATURE
-- ============================================================================
local function UpdateSupremeUI()
    local pData = getgenv().PlayerData
    if not pData or not selectedSupremeBoss or not GlobalSupremeBossDB[selectedSupremeBoss] then return end

    local data = GlobalSupremeBossDB[selectedSupremeBoss]
    local diffData = data.Difficulties[selectedSupremeDiff]
    if not diffData then return end

    local priceItem = data.Price.Item
    local itemInfo = GetItemInfo(data.Price.Type, data.Price.Item)
    local IconItem = (itemInfo and itemInfo.Icon) or ""
    local myBalance = (pData.Items and pData.Items[priceItem]) or 0
    local cost = diffData.Price
    
    local infoText = string.format(
        "Target: %s (%s)\nCost: %s%s %d/%d\nHealth: %s",
        selectedSupremeBoss, selectedSupremeDiff,
        IconItem, priceItem, myBalance, cost, diffData.Health
    )
    
    if SupremeInfoLabel then
        SupremeInfoLabel:SetDesc(infoText)
    end
end

local SupremeBossList = {}
for name, _ in pairs(GlobalSupremeBossDB) do table.insert(SupremeBossList, name) end

-- Dropdown Pilih Boss
FM_Add("Bosses", MainTab:Dropdown({
    Title = "Select Supreme Boss",
    Values = SupremeBossList,
    Flag = "AutoSupremeListDropdown_Cfg",
    Multi = false,
    Callback = function(v) 
        selectedSupremeBoss = v 
        UpdateSupremeUI() -- Tambahkan ini
    end
}))

-- Dropdown Kesulitan
FM_Add("Bosses", MainTab:Dropdown({
    Title = "Supreme Difficulty",
    Values = {"Easy", "Medium", "Hard"},
    Flag = "AutoSupremeDropdown_Cfg",
    Value = "Easy",
    Callback = function(v) 
        selectedSupremeDiff = v 
        UpdateSupremeUI() -- Tambahkan ini
    end
}))
-- Toggle Auto Supreme
FM_Add("Bosses", MainTab:Toggle({
    Title = "Enable Auto Supreme Boss",
    Flag = "AutoSupreme_Cfg",
    Callback = function(v) isAutoSupreme = v end
}))

task.spawn(function()
    local lastInfoUpdate = ""
    while not Window.Destroyed do
        task.wait(1)

        local pData = getgenv().PlayerData
        if not pData or not selectedSupremeBoss or not GlobalSupremeBossDB[selectedSupremeBoss] then continue end

        -- A. Ambil Status Terbaru (Boss Hidup? Material Ada?)
        local isBossAlive, hasMaterials = GetSupremeStatus()
        local data = GlobalSupremeBossDB[selectedSupremeBoss]
        local targetMap = data.Map or "Christmas Event 2025"

        -- Update UI berkala untuk saldo
        if not Window.Closed then UpdateSupremeUI() end

        -- B. Logika Keluar: Jika toggle mati ATAU (boss mati DAN material habis)
        if not isAutoSupreme or (not isBossAlive and not hasMaterials) or IsInGamemode() or IsSwordsmanActive() or isTransitioning or isGlobalBossActive then 
            continue
        end

        -- C. Pengecekan Lokasi Map (Smart Teleport)
        if pData.Map ~= targetMap then
            Notify("Supreme Boss", "Boss active or materials ready! Heading to Map...", "map")
            OmniRef.Signal:Fire("Player", "Teleport", "Teleport", targetMap, selectedSupremeBoss .. " Supreme Boss")
            task.wait(3)
            continue
        end

        -- D. Logika Menyerang
        local server = workspace:FindFirstChild("Server")
        local supremeFolder = server and server.Enemies.Gamemodes:FindFirstChild("SupremeBosses")

        if supremeFolder then
            -- 1. Spawn jika belum ada boss tapi material cukup
            if not isBossAlive and hasMaterials then
                ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                    {"General", "SupremeBosses", "Spawn", selectedSupremeBoss, selectedSupremeDiff, n = 5}, 
                    "\2"
                })
                task.wait(2)
            end

            -- 2. Serang Boss
            for _, bossMob in ipairs(supremeFolder:GetChildren()) do
                while isAutoSupreme and bossMob and bossMob.Parent do
                    local hp = bossMob:GetAttribute("Health") or 0
                    if hp <= 0 then break end
                    
                    local targetCFrame = bossMob:IsA("Model") and bossMob:GetPivot() or bossMob.CFrame
                    if targetCFrame and hrp then
                        hrp.CFrame = targetCFrame * CFrame.new(0, 0, 5)
                    end
                    task.wait()
                end
            end
        end
    end
end)
-- SETTINGS TAB
local SettingsTab = Window:Tab({Title = "Settings", Icon = "settings-2"})
local ConfigSection = SettingsTab:Section({Title = "Config Manager", Icon = "save", Opened = true})
SettingsTab:Input({Title = "Config Name", Placeholder = "AN_AnimeAdvanced", Flag = "ConfigName_Input", Callback = function(txt) ConfigName = txt end})
SettingsTab:Button({Title = "Save Config", Icon = "save", Callback = function() local cfg = Window.ConfigManager:CreateConfig(ConfigName) cfg:Save() Notify("Config", "Saved!", "check") end})
SettingsTab:Button({Title = "Load Config", Icon = "upload", Callback = function() local cfg = Window.ConfigManager:GetConfig(ConfigName) or Window.ConfigManager:CreateConfig(ConfigName); if cfg then cfg:Load(); Notify("Config", "Loaded!", "check") end end})
SettingsTab:Button({Title = "Delete Config", Icon = "trash", Callback = function() Window.ConfigManager:DeleteConfig(ConfigName); Notify("Config", "Deleted!", "trash") end})
SettingsTab:Button({Title = "Reduce Lag / FPS Boost", Icon = "monitor", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/khuyenbd8bb/RobloxKaitun/refs/heads/main/FPS%20Booster.lua"))() Notify("System", "Boosted!", "check") end})

FM_OnChange("Farm")
Window:SelectTab(MainTab.Index)
-- ============================================================================
--  INITIALIZATION
-- ============================================================================
task.spawn(function()
    task.wait(1.5)
    local CM = Window.ConfigManager
    pcall(function()
        if isfile(ConfigPath .. "/" .. ConfigName .. ".json") then
            local cfg = CM:CreateConfig(ConfigName)
            cfg:Load()
            Notify("Config", "Auto-Loaded", "check")
        else
            CM:CreateConfig(ConfigName)
        end
    end)
    resetEnemiesList()
    RefreshAvatarList()
    pcall(function()
        local args = {{{"General", "Settings", "Update", "Auto Rejoin", false, n = 5}, "\2"}}
        ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
    end)
    while not Window.Destroyed do
        task.wait(1)
        pcall(function() local cfg = Window.ConfigManager:GetConfig(ConfigName) if cfg then cfg:Save() end end)
    end
end)