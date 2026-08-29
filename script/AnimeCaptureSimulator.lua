-- if game.PlaceId ~= 122821966131621 then return end

--[[
    Anime Capture Simulator - Auto Farm & Utility Script
    Refactored for clean architecture and maintainability
--]]

-- ============================================================
-- SERVICES & GLOBAL REFERENCES
-- ============================================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Game-specific services
local RemoteEvents = require(ReplicatedStorage.Shared.Utils.RemoteEvents)
local UIController = require(LocalPlayer.PlayerScripts.Utils.UIController)
local NumberFormatter = require(ReplicatedStorage.Shared.Utils.NumberFormatter)
local ConfigModule = require(ReplicatedStorage.Shared.Config)

-- ============================================================
-- DATA MODULES (Single require, cached globally)
-- ============================================================
local Data = {
    BaseVariantsInfo = require(ReplicatedStorage.Shared.Info.Variants.BaseVariantsInfo),
    EnemiesInfo = require(ReplicatedStorage.Shared.Info.EnemiesInfo),
    WorldsInfo = require(ReplicatedStorage.Shared.Info.WorldsInfo),
    CraftsInfo = require(ReplicatedStorage.Shared.Info.CraftsInfo),
    AvatarsInfo = require(ReplicatedStorage.Shared.Info.AvatarsInfo),
    PetsInfo = require(ReplicatedStorage.Shared.Info.PetsInfo),
    ResourcesInfo = require(ReplicatedStorage.Shared.Info.ResourcesInfo),
    SwordsInfo = require(ReplicatedStorage.Shared.Info.SwordsInfo),
    AccessoriesInfo = require(ReplicatedStorage.Shared.Info.AccessoriesInfo),
    GachasInfo = require(ReplicatedStorage.Shared.Info.GachasInfo),
    RelicsInfo = require(ReplicatedStorage.Shared.Info.RelicsInfo),
    GamepassesInfo = require(ReplicatedStorage.Shared.Info.GamepassesInfo),
    MountsInfo = require(ReplicatedStorage.Shared.Info.Mounts),
    BundlesInfo = require(ReplicatedStorage.Shared.Info.Bundles),
    SwordPassivesInfo = require(ReplicatedStorage.Shared.Info.SwordPassives),
    FightersInfo = require(ReplicatedStorage.Shared.Info.FightersInfo),
    UpgradesInfo = require(ReplicatedStorage.Shared.Info.UpgradesInfo),
    SingleUpgradesInfo = require(ReplicatedStorage.Shared.Info.SingleUpgradesInfo),
    BoostsVisual = require(ReplicatedStorage.Shared.Visual.BoostsVisual),
    RaritiesVisual = require(ReplicatedStorage.Shared.Visual.RaritiesVisual),
}

-- Remote events shortcuts
local CraftAvatarEvent = RemoteEvents.CraftAvatarEvent
local RollGachaBannerEvent = RemoteEvents.RollGachaBannerEvent
local RollGachaEvent = RemoteEvents.RollGachaEvent
local BuySkillNodeEvent = RemoteEvents.BuySkillNodeEvent
local SingleUpgradeEvent = RemoteEvents.SingleUpgradeEvent

-- ============================================================
-- CONSTANTS & CONFIGURATION
-- ============================================================
local CONSTANTS = {
    FOLDER_PATH = "ANUI/AnimeCaptureSimulator",
    EXPIRY_FILE = "ANUI/AnimeCaptureSimulator/ANHub_Key_Timer.txt",
    LAST_CONFIG_FILE = "ANUI/AnimeCaptureSimulator/LastConfig.txt",
    VALID_KEYS = { "ANHUB-2025" },
    DEFAULT_CONFIG_NAME = "ANConfig",
    WINDOW_TITLE = "AN Hub - Anime Capture Simulator",
    WINDOW_SIZE = UDim2.fromOffset(580, 460),
    ICON_ID = "rbxassetid://124221128249471",
    BANNER_ID = "rbxassetid://128566288820219",
    AVATAR_ID = "rbxassetid://124221128249471",
    FARM_INTERVAL = 0.2,         -- 5x per second
    CRAFT_INTERVAL = 1,          -- 1x per second
    GACHA_INTERVAL = 1.5,        -- ~0.67x per second
    UPGRADE_INTERVAL = 1,        -- 1x per second
    TELEPORT_COOLDOWN = 1,
    ATTACK_INTERVAL = 0.001,
    MAX_DISTANCE = 15,
}

-- Anti-AFK
task.spawn(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
local function GetIcon(id)
    return string.format("rbxassetid://%s", id)
end

local _GradientCache = {}
local function GetGameGradient(rarityName)
    if _GradientCache[rarityName] then return _GradientCache[rarityName] end

    local success, gradientObj = pcall(function()
        return Data.RaritiesVisual[rarityName].Gradient
    end)

    if success and gradientObj then
        _GradientCache[rarityName] = gradientObj.Color
        return gradientObj.Color
    end
end

local function Color3ToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
end

local function fmtNum(val)
    return NumberFormatter.FormatToSuffix(val)
end

local function SafeSetDesc(elem, text)
    if not elem then return end
    pcall(function() elem:SetDesc(text) end)
end

local function SafeSetTitle(elem, text)
    if not elem then return end
    pcall(function() elem:SetTitle(text) end)
end

local function SafeSetMainImage(elem, icon, size)
    if not elem then return end
    pcall(function() elem:SetMainImage(icon, size) end)
end

local function Notify(title, content, icon)
    task.spawn(function()
        pcall(function()
            if UI and UI.Notify then
                UI:Notify({ Title = title, Content = content, Icon = icon, Duration = 3 })
            end
        end)
    end)
end

-- ============================================================
-- ENEMY DATA LOADER
-- ============================================================
local function LoadWorldEnemies()
    local worldEnemies = {}
    for worldIndex, worldData in ipairs(Data.WorldsInfo) do
        local enemiesIndice = worldData.EnemiesIndice
        if enemiesIndice and Data.EnemiesInfo[enemiesIndice] then
            local enemyList = Data.EnemiesInfo[enemiesIndice]
            for enemyIndex, enemyData in ipairs(enemyList) do
                table.insert(worldEnemies, {
                    Name = enemyData.Name,
                    WorldIndex = worldIndex,
                    EnemyInd = enemyIndex,
                    Variant = enemyData.Variant,
                    Health = enemyData.Health,
                    CaptureCost = enemyData.CaptureCost,
                    CaptureChance = enemyData.CaptureChance,
                    SellGain = enemyData.SellGain,
                    PetGain = enemyData.PetGain,
                    EXP = enemyData.EXP,
                    Drops = enemyData.Drops,
                    Character = enemyData.Character,
                    WorldName = worldData.Name,
                    EnemiesIndice = enemiesIndice,
                })
            end
        end
    end
    return worldEnemies
end

local WorldEnemies = LoadWorldEnemies()

local function GetEnemyData(name)
    for _, enemy in ipairs(WorldEnemies) do
        if string.format("%s (%s)", enemy.Name, Data.BaseVariantsInfo[enemy.Variant].Name) == name then
            return enemy
        end
    end
    return nil
end

-- Build dropdown entries with drop info
local function BuildEnemyDropdown()
    local EnemyNames = {}
    for _, enemy in ipairs(WorldEnemies) do
        if enemy.Drops then
            local DropsData = {}
            for _, drop in ipairs(enemy.Drops) do
                local key, image, rarity = GetInfo(drop)
                if key then
                    local amount = drop.Amount
                    local quantity = type(amount) == "table"
                        and string.format("%s-%s", amount[1], amount[2])
                        or tostring(amount)
                    table.insert(DropsData, {
                        Card = true,
                        Title = key,
                        Quantity = quantity,
                        Image = GetIcon(image),
                        Gradient = GetGameGradient(rarity),
                        ChanceValue = string.format("%s%%", drop.Chance)
                    })
                end
            end
            table.insert(EnemyNames, {
                Title = string.format("%s (%s)", enemy.Name, Data.BaseVariantsInfo[enemy.Variant].Name),
                Images = DropsData,
            })
        end
    end
    return EnemyNames
end

local EnemyNames = BuildEnemyDropdown()

-- ============================================================
-- ENEMY FINDER UTILITIES
-- ============================================================
local function FindEnemyInstance(enemyName)
    local enemiesData = ReplicatedStorage:FindFirstChild("Enemies")
    if not enemiesData then return nil end

    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end

    local characters = enemiesFolder:FindFirstChild("Character")
    if not characters then return nil end

    for _, dataChild in ipairs(enemiesData:GetChildren()) do
        local nameAttr = dataChild:GetAttribute("Name")
        if string.format("%s (%s)", nameAttr, dataChild:GetAttribute("VariantName")) == enemyName then
            local healthAttr = dataChild:GetAttribute("Health")
            local maxHealthAttr = dataChild:GetAttribute("MaxHealth")
            local deadAttr = dataChild:GetAttribute("Dead")

            if healthAttr and maxHealthAttr and healthAttr > 0 and not deadAttr then
                local visualModel = characters:FindFirstChild(dataChild.Name)
                if visualModel then
                    return visualModel, healthAttr, maxHealthAttr, dataChild
                end
                return nil, healthAttr, maxHealthAttr, dataChild
            end
        end
    end
    return nil
end

-- Check if player is in any gamemode
local function IsInGamemode()
    local Gamemodes = ReplicatedStorage:FindFirstChild("Gamemodes")
    if not Gamemodes then return false, nil, nil end

    for _, gamemodeType in ipairs(Gamemodes:GetChildren()) do
        if gamemodeType.Name ~= "Template" then
            for _, gamemodeInstance in ipairs(gamemodeType:GetChildren()) do
                local PlayersFolder = gamemodeInstance:FindFirstChild("Players")
                if PlayersFolder and PlayersFolder:FindFirstChild(LocalPlayer.Name) then
                    return true, gamemodeType.Name, gamemodeInstance.Name
                end
            end
        end
    end
    return false, nil, nil
end

-- Find enemy in gamemode
local function FindGamemodeEnemyInstance(gamemodeType, gamemodeId)
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end

    local characters = enemiesFolder:FindFirstChild("Character")
    if not characters then return nil end

    local enemiesData = ReplicatedStorage:FindFirstChild("Enemies")
    if not enemiesData then return nil end

    local targetGamemodeId = tonumber(gamemodeId)

    -- Primary: match by GamemodeName + GamemodeInd
    for _, visualModel in ipairs(characters:GetChildren()) do
        local dataChild = enemiesData:FindFirstChild(visualModel.Name)
        if dataChild then
            local healthAttr = dataChild:GetAttribute("Health")
            local maxHealthAttr = dataChild:GetAttribute("MaxHealth")
            local deadAttr = dataChild:GetAttribute("Dead")
            local enemyGamemodeName = dataChild:GetAttribute("GamemodeName")
            local enemyGamemodeInd = dataChild:GetAttribute("GamemodeInd")

            local isCorrectGamemode = false
            if enemyGamemodeName and enemyGamemodeInd then
                local nameMatch = string.lower(tostring(enemyGamemodeName)) == string.lower(tostring(gamemodeType))
                local idMatch = tonumber(enemyGamemodeInd) == targetGamemodeId
                isCorrectGamemode = nameMatch and idMatch
            end

            if isCorrectGamemode and not deadAttr then
                return visualModel, healthAttr, maxHealthAttr, dataChild
            end
        end
    end

    -- Fallback: any alive enemy in current world (especially for Raid)
    local currentWorld = LocalPlayer:GetAttribute("CurrentWorld") or 1
    for _, visualModel in ipairs(characters:GetChildren()) do
        local dataChild = enemiesData:FindFirstChild(visualModel.Name)
        if dataChild then
            local healthAttr = dataChild:GetAttribute("Health")
            local maxHealthAttr = dataChild:GetAttribute("MaxHealth")
            local deadAttr = dataChild:GetAttribute("Dead")
            local enemyWorld = dataChild:GetAttribute("World") or dataChild:GetAttribute("WorldIndex")
            local enemyGamemodeName = dataChild:GetAttribute("GamemodeName")

            if not deadAttr then
                if gamemodeType == "Raid"
                    or (enemyWorld and tonumber(enemyWorld) == currentWorld)
                    or (not enemyGamemodeName and enemyWorld == nil) then
                    return visualModel, healthAttr, maxHealthAttr, dataChild
                end
            end
        end
    end

    return nil
end

-- ============================================================
-- TELEPORT & COMBAT
-- ============================================================
local function TeleportToWorld(worldIndex)
    RemoteEvents.TeleportEvent:FireServer(worldIndex)
end

local function TeleportToEnemy(enemyInstance)
    local character = LocalPlayer.Character
    if not character then return false end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end

    local enemyRoot = enemyInstance:FindFirstChild("HumanoidRootPart")
        or enemyInstance:FindFirstChild("Torso")
        or enemyInstance.PrimaryPart
        or enemyInstance:FindFirstChildWhichIsA("BasePart")

    if enemyRoot then
        rootPart.CFrame = enemyRoot.CFrame * CFrame.new(0, 5, 3)
        return true
    end
    return false
end

local function PerformAttack()
    RemoteEvents.ClickEvent:FireServer()
end

-- ============================================================
-- WORLD UTILITIES
-- ============================================================
local function IsWorldUnlocked(worldIndex)
    local unlockedWorlds = UIController.GetFolderTable("UnlockedWorlds")
    if worldIndex < 3 then return true end
    return unlockedWorlds[tostring(worldIndex)] == true
end

-- ============================================================
-- ITEM INFO RESOLVER (for drops display)
-- ============================================================
local function GetInfo(dropData)
    local handlers = {
        Resource = function(d)
            local info = Data.ResourcesInfo[d.Indice]
            return info and info.Name, info and info.Image, info and info.Rarity
        end,
        Currency = function(d)
            if d.Indice == "EXP" then return "EXP", "120074609358033", 1 end
            if d.Indice == "Money" then return "Gems", "118002116607787", 1 end
        end,
        Sword = function(d)
            local info = Data.SwordsInfo[d.Indice]
            return info and info.Name, info and info.Image, info and info.Rarity
        end,
        Accessory = function(d)
            local info = Data.AccessoriesInfo[d.Indice]
            return info and info.Name, info and info.Image, d.Rarity
        end,
        Relic = function(d)
            local info = Data.RelicsInfo[d.Indice]
            return info and info.Name, info and info.Image, info and info.Rarity
        end,
        Avatar = function(d)
            local info = Data.AvatarsInfo[d.Indice]
            return info and "Av. " .. info.Name, info and info.Character:Clone(), info and info.Rarity
        end,
        Pet = function(d)
            local info = Data.PetsInfo[d.Indice]
            return info and (info.Percentage and "(%) " or "") .. info.Name, info and info.Character:Clone(), info and info.Rarity
        end,
        Fighter = function(d)
            local info = Data.FightersInfo[d.Indice]
            return info and info.Name, info and info.Character:Clone(), info and info.Rarity
        end,
        Enemy = function(d)
            local group = Data.EnemiesInfo[d.Indice]
            local info = group and group[d.SubIndice]
            return info and info.Name, info and info.Character:Clone(), info and info.Variant
        end,
        Gacha = function(d)
            local info = Data.GachasInfo[d.Indice]
            local pool = info and info.Pool[d.SubIndice]
            return pool and pool.Name, pool and (pool.Character and pool.Character:Clone() or pool.Image), pool and pool.Rarity
        end,
        SwordPassive = function(d)
            local info = Data.SwordPassivesInfo.Passives[d.Indice]
            return info and info.Name, info and info.Image, info and info.Rarity
        end,
        Mount = function(d)
            local info = Data.MountsInfo[d.Indice]
            return info and info.Name, info and info.Icon, info and info.Rarity
        end,
        Bundle = function(d)
            local info = Data.BundlesInfo[d.Indice]
            return info and info.Name, info and info.Image, info and info.Rarity
        end,
        Gamepass = function(d)
            local info = Data.GamepassesInfo[d.Indice]
            return info and info.Name, info and info.Image, nil
        end,
    }

    local handler = handlers[dropData.Key]
    if handler then
        return handler(dropData)
    end
    return nil
end

-- ============================================================
-- CONFIGURATION MANAGEMENT
-- ============================================================
local Config = {}
local ConfigName = CONSTANTS.DEFAULT_CONFIG_NAME
local IsLoadingConfig = false
local IsPremium = false
local UI, Window, MainCategory, MainTabs

local function NormalizeConfigName(name)
    if typeof(name) ~= "string" then return CONSTANTS.DEFAULT_CONFIG_NAME end
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    return name ~= "" and name or CONSTANTS.DEFAULT_CONFIG_NAME
end

local function SaveLastConfigName()
    if writefile then
        pcall(function() writefile(CONSTANTS.LAST_CONFIG_FILE, ConfigName) end)
    end
end

local function LoadLastConfigName()
    if readfile and isfile and isfile(CONSTANTS.LAST_CONFIG_FILE) then
        local ok, savedName = pcall(function() return readfile(CONSTANTS.LAST_CONFIG_FILE) end)
        if ok and typeof(savedName) == "string" and savedName ~= "" then
            ConfigName = NormalizeConfigName(savedName)
        end
    end
end

local function GetOrCreateConfig()
    if not Window or not Window.ConfigManager then return nil end
    ConfigName = NormalizeConfigName(ConfigName)
    local cfg = Window.ConfigManager:GetConfig(ConfigName)
    if cfg then cfg:SetAsCurrent(); return cfg end
    return Window.ConfigManager:CreateConfig(ConfigName, true)
end

local function FinishConfigLoad(delaySeconds)
    task.delay(delaySeconds or 1, function() IsLoadingConfig = false end)
end

-- ============================================================
-- UI SETUP
-- ============================================================
LoadLastConfigName()

local function LoadKeySystemData()
    local url = "https://raw.githubusercontent.com/AdityaNugrahaInside/ANHub/refs/heads/main/Key.txt"
    local success, response = pcall(function() return game:HttpGet(url) end)
    if success then
        for line in response:gmatch("[^\r\n]+") do
            local parts = string.split(line, ":")
            if #parts >= 2 then
                local useridInFile = string.gsub(parts[1], "%s+", "")
                local keyInFile = string.gsub(parts[2], "%s+", "")
                table.insert(CONSTANTS.VALID_KEYS, keyInFile)
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

local function MakeProfile(data)
    local base = {
        Banner = CONSTANTS.BANNER_ID,
        Avatar = CONSTANTS.AVATAR_ID,
        Status = true,
        Badges = {
            { Icon = "geist:logo-discord", Title = "Discord", Desc = "Join ANHUB Discord",
                Callback = function() setclipboard("https://discord.gg/qN47S3mKZA"); Notify("Discord", "Invite link copied!", "geist:logo-discord") end },
            { Icon = "youtube", Desc = "Subscribe to YouTube",
                Callback = function() setclipboard("https://www.youtube.com/@ANHubRoblox"); Notify("YouTube", "Channel link copied!", "youtube") end }
        }
    }
    for k, v in pairs(data or {}) do base[k] = v end
    return base
end

if not IsPremium then
    Window = UI:CreateWindow({
        Title = CONSTANTS.WINDOW_TITLE,
        Icon = CONSTANTS.ICON_ID,
        Author = "Aditya Nugraha",
        Folder = "AnimeCaptureSimulator",
        Size = CONSTANTS.WINDOW_SIZE,
        KeySystem = {
            Note = "Generate a key for this device. Valid for 24 hours.",
            SaveKey = true,
            API = {
                { Type = "github", Owner = "ANHub-Script", Repo = "ANUI", Branch = "main",
                  DBPath = "db/keys.json", URL = "https://anhub-script.github.io/ANUI/getkey/",
                  Secret = "ZDDjD3dIOzlMTCWKU2snOK2qgTJc-MFU" },
            },
        },
    })
else
    Window = UI:CreateWindow({
        Title = CONSTANTS.WINDOW_TITLE,
        Icon = "rbxassetid://84366761557806",
        Author = "Aditya Nugraha",
        Folder = "AnimeCaptureSimulator",
        Size = CONSTANTS.WINDOW_SIZE,
    })
end

Window:Tab({
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Capture Simulator" }),
    SidebarProfile = true
})

if IsPremium then
    Window:Tag({ Title = "Premium User", Icon = "crown", Color = Color3.fromHex("#FFD700") })
else
    Window:Tag({ Title = "Free User", Icon = "user", Color = Color3.fromHex("#FFFFFF") })
end

pcall(function()
    if writefile and isfile and (not isfile(CONSTANTS.EXPIRY_FILE)) then
        writefile(CONSTANTS.EXPIRY_FILE, tostring(os.time() + 86400))
    end
end)

-- ============================================================
-- LOOP MANAGEMENT HELPERS
-- ============================================================
local function StartLoop(key, interval, predicate, callback)
    return Window:ManagedLoop(key, interval, predicate, callback)
end

local function StopLoop(key)
    return Window:StopLoop(key)
end

local function StartStatus(key, interval, callback)
    return Window:StatusLoop(key, interval, callback)
end

-- ============================================================
-- MAIN TABS & CATEGORIES
-- ============================================================
MenuMain = Window:Section({ Title = "Menu", Opened = true })
MainTabs = MenuMain:Tab({ Title = "Feature" })

MainCategory = MainTabs:Category({
    Default = "Farm",
    Options = {
        { Title = "Farm", Icon = GetIcon(104669119268299) },
        { Title = "Craft", Icon = GetIcon(84605566944415) },
        { Title = "Gacha", Icon = GetIcon(128047949460588) },
        { Title = "Upgrade", Icon = GetIcon(93670476085226) },
    },
})

MainCategory:Select("Farm")
Window:SelectTab(MainTabs.Index)

-- ============================================================
-- AUTO FARM MODULE
-- ============================================================
local AutoFarmWorld = {
    Enabled = false,
    SelectedEnemy = "Osop",
    CurrentTarget = nil,
    AttackInterval = CONSTANTS.ATTACK_INTERVAL,
    TeleportCooldown = CONSTANTS.TELEPORT_COOLDOWN,
    LastTeleport = 0,
    LastAttack = 0,
    InGamemode = false,
    GamemodeType = nil,
    GamemodeId = nil,
}

local SelectEnemy

local function StartAutoFarmWorld()
    StopLoop("AutoFarmWorld")

    AutoFarmWorld.Enabled = true
    AutoFarmWorld.CurrentTarget = nil
    AutoFarmWorld.LastTeleport = 0
    AutoFarmWorld.LastAttack = 0
    AutoFarmWorld.InGamemode = false
    AutoFarmWorld.GamemodeType = nil
    AutoFarmWorld.GamemodeId = nil

    StartLoop("AutoFarmWorld", CONSTANTS.FARM_INTERVAL,
        function() return AutoFarmWorld.Enabled end,
        function()
            local now = tick()
            local inGamemode, gamemodeType, gamemodeId = IsInGamemode()
            AutoFarmWorld.InGamemode = inGamemode
            AutoFarmWorld.GamemodeType = gamemodeType
            AutoFarmWorld.GamemodeId = gamemodeId

            local enemyInstance, healthAttr, maxHealthAttr, dataChild
            local alive = false
            local enemyData

            if inGamemode then
                -- INSIDE GAMEMODE: Find any alive enemy in the gamemode
                enemyInstance, healthAttr, maxHealthAttr, dataChild = FindGamemodeEnemyInstance(gamemodeType, gamemodeId)
                alive = enemyInstance ~= nil

                if alive and dataChild then
                    local desc = string.format("[GAMEMODE: %s] %s <gradient=%s>%s</gradient>\nHP: %s/%s",
                        gamemodeType,
                        dataChild:GetAttribute("Name"),
                        Color3ToHex(dataChild:GetAttribute("VariantColor")),
                        dataChild:GetAttribute("VariantName"),
                        fmtNum(healthAttr),
                        fmtNum(maxHealthAttr)
                    )
                    SafeSetDesc(SelectEnemy, desc)
                    AutoFarmWorld.CurrentTarget = enemyInstance

                    -- Teleport if too far
                    local character = LocalPlayer.Character
                    if character then
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            local enemyRoot = enemyInstance:FindFirstChild("HumanoidRootPart")
                                or enemyInstance:FindFirstChild("Torso")
                                or enemyInstance.PrimaryPart
                            if enemyRoot and (rootPart.Position - enemyRoot.Position).Magnitude > CONSTANTS.MAX_DISTANCE then
                                if now - AutoFarmWorld.LastTeleport >= AutoFarmWorld.TeleportCooldown then
                                    TeleportToEnemy(enemyInstance)
                                    AutoFarmWorld.LastTeleport = now
                                end
                                return
                            end
                        end
                    end

                    -- Attack
                    if now - AutoFarmWorld.LastAttack >= AutoFarmWorld.AttackInterval then
                        PerformAttack()
                        AutoFarmWorld.LastAttack = now
                    end
                else
                    AutoFarmWorld.CurrentTarget = nil
                    SafeSetDesc(SelectEnemy, string.format("[GAMEMODE: %s] Mencari musuh...", gamemodeType))
                end
            else
                -- OUTSIDE GAMEMODE: Use selected enemy from dropdown
                enemyData = GetEnemyData(AutoFarmWorld.SelectedEnemy)
                if not enemyData then
                    Notify("Farm", "Enemy tidak ditemukan: " .. AutoFarmWorld.SelectedEnemy, "alert-triangle")
                    AutoFarmWorld.Enabled = false
                    return
                end

                enemyInstance, healthAttr, maxHealthAttr, dataChild = FindEnemyInstance(AutoFarmWorld.SelectedEnemy)
                alive = enemyInstance ~= nil

                if alive then
                    local desc = string.format("%s <gradient=%s>%s</gradient>\nCatch Chance: %s%%\nCatch Cost: %s\nSell Gain: %s",
                        dataChild:GetAttribute("Name"),
                        Color3ToHex(dataChild:GetAttribute("VariantColor")),
                        dataChild:GetAttribute("VariantName"),
                        dataChild:GetAttribute("CaptureChance"),
                        fmtNum(dataChild:GetAttribute("CaptureCost")),
                        fmtNum(dataChild:GetAttribute("SellGain"))
                    )
                    SafeSetDesc(SelectEnemy, desc)
                    AutoFarmWorld.CurrentTarget = enemyInstance

                    -- Ensure correct world
                    local currentWorld = LocalPlayer:GetAttribute("CurrentWorld") or 1
                    if currentWorld ~= enemyData.WorldIndex then
                        if now - AutoFarmWorld.LastTeleport >= AutoFarmWorld.TeleportCooldown then
                            TeleportToWorld(enemyData.WorldIndex)
                            AutoFarmWorld.LastTeleport = now
                        end
                        return
                    end

                    -- Teleport if too far
                    local character = LocalPlayer.Character
                    if character then
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            local enemyRoot = enemyInstance:FindFirstChild("HumanoidRootPart")
                                or enemyInstance:FindFirstChild("Torso")
                                or enemyInstance.PrimaryPart
                            if enemyRoot and (rootPart.Position - enemyRoot.Position).Magnitude > CONSTANTS.MAX_DISTANCE then
                                if now - AutoFarmWorld.LastTeleport >= AutoFarmWorld.TeleportCooldown then
                                    TeleportToEnemy(enemyInstance)
                                    AutoFarmWorld.LastTeleport = now
                                end
                                return
                            end
                        end
                    end

                    -- Attack
                    if now - AutoFarmWorld.LastAttack >= AutoFarmWorld.AttackInterval then
                        PerformAttack()
                        AutoFarmWorld.LastAttack = now
                    end
                else
                    AutoFarmWorld.CurrentTarget = nil
                    local currentWorld = LocalPlayer:GetAttribute("CurrentWorld") or 1
                    if currentWorld ~= enemyData.WorldIndex and IsWorldUnlocked(enemyData.WorldIndex) then
                        if now - AutoFarmWorld.LastTeleport >= AutoFarmWorld.TeleportCooldown then
                            TeleportToWorld(enemyData.WorldIndex)
                            AutoFarmWorld.LastTeleport = now
                        end
                    end
                end
            end
        end
    )
end

local function StopAutoFarmWorld()
    AutoFarmWorld.Enabled = false
    StopLoop("AutoFarmWorld")
    AutoFarmWorld.CurrentTarget = nil
end

SelectEnemy = MainTabs:Dropdown({
    Title = "Select Enemy",
    Values = EnemyNames,
    Flag = "Dropdown_SelectEnemy",
    Callback = function(value)
        AutoFarmWorld.SelectedEnemy = value.Title
    end
})

local ToggleFarmEnemy = MainTabs:Toggle({
    Title = "Farm",
    Flag = "Toggle_FarmEnemy",
    Callback = function(state)
        if state then StartAutoFarmWorld() else StopAutoFarmWorld() end
    end
})

MainCategory:Add("Farm", SelectEnemy, ToggleFarmEnemy)

-- ============================================================
-- AUTO CRAFT AVATAR MODULE
-- ============================================================
Config.AutoCraftAvatar = false

local function getFolder(name)
    return LocalPlayer:FindFirstChild(name)
end

local function refreshFolders()
    Resources = getFolder("Resources") or {}
    Swords = getFolder("Swords") or {}
    Accessories = getFolder("Accessories") or {}
    AvatarsIndex = getFolder("AvatarsIndex") or {}
    PetsIndex = getFolder("PetsIndex") or {}
    AccessoriesIndex = getFolder("AccessoriesIndex") or {}
    SwordsIndex = getFolder("SwordsIndex") or {}
    EquippedAccessories = getFolder("EquippedAccessories") or {}
end
refreshFolders()

local function getValueFromInstance(instance)
    if instance:IsA("IntValue") or instance:IsA("NumberValue") then return instance.Value end
    if instance:IsA("BoolValue") then return instance.Value end
    if instance:IsA("StringValue") then return instance.Value end
    return instance
end

local function getChildValue(folder, name)
    if not folder or not folder:IsA("Instance") then return 0 end
    local child = folder:FindFirstChild(tostring(name))
    return child and getValueFromInstance(child) or 0
end

local function countOwnedUnique(folder, indice, key)
    if not folder or not folder:IsA("Instance") then return 0 end
    local count = 0
    for _, itemData in ipairs(folder:GetChildren()) do
        local itemIndice = getChildValue(itemData, "Indice")
        local locked = getChildValue(itemData, "Locked")
        if itemIndice ~= nil and tostring(itemIndice) == tostring(indice) and not locked then
            if key == "Accessory" then
                local accInfo = Data.AccessoriesInfo[tonumber(itemIndice)]
                if not accInfo or getChildValue(EquippedAccessories, accInfo.Type) ~= itemData.Name then
                    count += 1
                end
            else
                local equipped = getChildValue(itemData, "Equipped")
                if not equipped then count += 1 end
            end
        end
    end
    return count
end

local function getOwnedAmount(costData)
    if costData.Key == "Resource" then return getChildValue(Resources, costData.Indice)
    elseif costData.Key == "Sword" then return countOwnedUnique(Swords, costData.Indice, "Sword")
    elseif costData.Key == "Accessory" then return countOwnedUnique(Accessories, costData.Indice, "Accessory")
    elseif costData.Key == "Pet" then return countOwnedUnique(Pets, costData.Indice, "Pet")
    else return 0 end
end

local function isAvatarOwned(indice)
    local child = AvatarsIndex and AvatarsIndex:FindFirstChild(tostring(indice))
    return child and getValueFromInstance(child) == true or false
end

local function canCraftItem(craftData)
    if isAvatarOwned(craftData.Indice) then return false end
    for _, cost in ipairs(craftData.Cost) do
        if getOwnedAmount(cost) < cost.Amount then return false end
    end
    return true
end

local function getCostDisplayName(costData)
    local key, indice = costData.Key, costData.Indice
    if key == "Avatar" then local i = Data.AvatarsInfo[indice]; return i and "Av. " .. i.Name or "Avatar " .. tostring(indice)
    elseif key == "Pet" then local i = Data.PetsInfo[indice]; return i and i.Name or "Pet " .. tostring(indice)
    elseif key == "Resource" then local i = Data.ResourcesInfo[indice]; return i and i.Name or "Resource " .. tostring(indice)
    elseif key == "Sword" then local i = Data.SwordsInfo[indice]; return i and i.Name or "Sword " .. tostring(indice)
    elseif key == "Accessory" then local i = Data.AccessoriesInfo[indice]; return i and i.Name or "Accessory " .. tostring(indice)
    else return key .. " " .. tostring(indice) end
end

local AvatarCraftSection = MainTabs:Section({ Title = "Avatar" })

local autoCraftToggle = AvatarCraftSection:Toggle({
    Title = "Craft Avatar",
    Flag = "AutoCraftAvatar",
    Value = false,
    Callback = function(val)
        Config.AutoCraftAvatar = val
        if val then
            StartLoop("AutoCraftAvatar", CONSTANTS.CRAFT_INTERVAL,
                function() return Config.AutoCraftAvatar end,
                function()
                    for _, world in ipairs(Data.WorldsInfo) do
                        if world.Content then
                            for _, content in ipairs(world.Content) do
                                if content.Key == "Craft" then
                                    local category = Data.CraftsInfo[content.Indice]
                                    if category then
                                        for _, craftData in ipairs(category) do
                                            if canCraftItem(craftData) then
                                                CraftAvatarEvent:FireServer(craftData.Indice)
                                                return
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            )
        else
            StopLoop("AutoCraftAvatar")
        end
    end
})

MainCategory:Add("Craft", AvatarCraftSection, autoCraftToggle)

StartStatus("Status_AutoCraftAvatar", 1, function()
    if not autoCraftToggle then return end
    local lines = {}
    for _, world in ipairs(Data.WorldsInfo) do
        if world.Content then
            local craftContent
            for _, content in ipairs(world.Content) do
                if content.Key == "Craft" then craftContent = content; break end
            end
            if craftContent then
                local category = Data.CraftsInfo[craftContent.Indice]
                if category then
                    table.insert(lines, string.format("[%s]", world.Name))
                    for _, craftData in ipairs(category) do
                        local avatarInfo = Data.AvatarsInfo[craftData.Indice]
                        local avatarName = avatarInfo and avatarInfo.Name or ("Avatar " .. craftData.Indice)
                        if isAvatarOwned(craftData.Indice) then
                            table.insert(lines, string.format("• %s ✅", avatarName))
                        else
                            for _, cost in ipairs(craftData.Cost) do
                                local owned = getOwnedAmount(cost)
                                local color = owned >= cost.Amount and "#00ff00" or "#ff5555"
                                table.insert(lines, string.format('• %s: <font color="%s">%s / %s</font>',
                                    getCostDisplayName(cost), color, fmtNum(owned), fmtNum(cost.Amount)))
                            end
                        end
                    end
                end
            end
        end
    end
    if #lines == 1 then table.insert(lines, "No craftable data") end
    SafeSetDesc(autoCraftToggle, table.concat(lines, "\n"))
end)

-- ============================================================
-- AUTO GACHA MODULE
-- ============================================================
Config.AutoRollGacha = {}

local function getResourceAmount(resourceName)
    local resources = UIController.GetFolderTable("Resources") or {}
    return resources[resourceName] or 0
end

local GachaImageCache = {}

local function SetGachaMainImage(elem, gachaIndex, imageTable, size)
    if not elem then return end
    local cache = GachaImageCache[gachaIndex] or {}
    GachaImageCache[gachaIndex] = cache

    if cache.image == imageTable.Image and cache.title == imageTable.Title
        and cache.gradient == imageTable.Gradient and cache.size == size then
        return
    end

    cache.image, cache.title, cache.gradient, cache.size = imageTable.Image, imageTable.Title, imageTable.Gradient, size
    pcall(function() elem:SetMainImage(imageTable, size) end)
end

local countInGroup, group = 0, nil

for gachaIndex, gachaData in ipairs(Data.GachasInfo) do
    if not gachaData then continue end
    local gachaName = gachaData.Name or ("Gacha " .. gachaIndex)
    Config.AutoRollGacha[gachaIndex] = false

    if countInGroup % 2 == 0 then
        group = MainTabs:Group({})
        MainCategory:Add("Gacha", group)
    end
    countInGroup += 1

    local rollResourceInfo = gachaData.RollCost and gachaData.RollCost.Resource and Data.ResourcesInfo[gachaData.RollCost.Resource]
    local rollResourceImage = rollResourceInfo and rollResourceInfo.Image or nil

    local toggle = group:Toggle({
        Title = gachaName,
        Flag = "AutoRollGacha_" .. gachaIndex,
        Image = GetIcon(rollResourceImage),
        Value = false,
        Callback = function(val)
            Config.AutoRollGacha[gachaIndex] = val
            if val then
                StartLoop("AutoRollGacha_" .. gachaIndex, CONSTANTS.GACHA_INTERVAL,
                    function() return Config.AutoRollGacha[gachaIndex] == true end,
                    function()
                        if not gachaData.RollCost then return end
                        local resourceName = gachaData.RollCost.Resource
                        local baseCost = gachaData.RollCost.Amount or 0
                        local discount = LocalPlayer:GetAttribute("GachaDiscount") or 0
                        local cost = math.floor(baseCost * (1 - discount))
                        local owned = getResourceAmount(resourceName)
                        if owned >= cost and IsWorldUnlocked(gachaData.NecessaryWorld) then
                            if gachaData.IsBanner then RollGachaBannerEvent:FireServer(gachaIndex)
                            else RollGachaEvent:FireServer(gachaIndex) end
                        end
                    end
                )
            else
                StopLoop("AutoRollGacha_" .. gachaIndex)
            end
        end
    })

    StartStatus("Status_AutoRollGacha_" .. gachaIndex, 1, function()
        local resourceName = gachaData.RollCost and gachaData.RollCost.Resource
        local baseCost = gachaData.RollCost and gachaData.RollCost.Amount or 0
        local discount = LocalPlayer:GetAttribute("GachaDiscount") or 0
        local cost = math.floor(baseCost * (1 - discount))
        local owned = resourceName and getResourceAmount(resourceName) or 0
        local resourceInfo = resourceName and Data.ResourcesInfo[resourceName]
        local resourceDisplay = resourceInfo and resourceInfo.Name or resourceName or "?"
        local canRoll = owned >= cost
        local color = canRoll and "#00ff00" or "#ff5555"

        local equippedIndex = (UIController.GetFolderTable("GachasEquipped") or {})[tostring(gachaIndex)]
        local equipText = "Equipped: None"
        local lastTierText = ""

        local lastTierGacha = gachaData.Pool and gachaData.Pool[#gachaData.Pool]
        if lastTierGacha and Data.RaritiesVisual[lastTierGacha.Rarity] then
            lastTierText = string.format("Higher Rarity: <font color=\"#%s\">%s (%s)</font>",
                Color3ToHex(Data.RaritiesVisual[lastTierGacha.Rarity].Color),
                lastTierGacha.Name, Data.RaritiesVisual[lastTierGacha.Rarity].Name)
        end

        if equippedIndex then
            local equippedItem = gachaData.Pool and gachaData.Pool[equippedIndex]
            if equippedItem then
                SetGachaMainImage(toggle, gachaIndex, {
                    Image = GetIcon(equippedItem.Image),
                    Title = equippedItem.Name,
                    Gradient = GetGameGradient(equippedItem.Rarity),
                }, 55)
                equipText = string.format("Equipped: <font color=\"#%s\">%s (%s)</font>",
                    Color3ToHex(Data.RaritiesVisual[equippedItem.Rarity].Color),
                    equippedItem.Name, Data.RaritiesVisual[equippedItem.Rarity].Name)
            else equipText = "Equipped: Unknown" end
        end

        local lines = {
            string.format("Cost: %s/%s %s", fmtNum(owned), fmtNum(cost), resourceDisplay),
            equipText,
            lastTierText
        }
        SafeSetDesc(toggle, table.concat(lines, "\n"))
    end)
end

-- ============================================================
-- AUTO UPGRADE MODULE
-- ============================================================
Config.AutoUpgrade = {}

local function getPlayerResource(categoryData)
    if not categoryData then return 0 end
    if categoryData.CostKey == "Resource" then
        local resources = UIController.GetFolderTable("Resources") or {}
        return resources[tostring(categoryData.CostId)] or 0
    elseif categoryData.CostKey == "Currency" then
        return LocalPlayer:GetAttribute(categoryData.CostId) or 0
    end
    return 0
end

local function getUpgradeLevel(categoryIndex, upgradeIndex)
    local upgrades = UIController.GetFolderTable("Upgrades") or {}
    return (upgrades[tostring(categoryIndex)] or {})[tostring(upgradeIndex)] or 0
end

local AutoUpgradeSection = MainTabs:Section({ Title = "Trial Upgrade" })
MainCategory:Add("Upgrade", AutoUpgradeSection)

local upgradeCountInGroup, upgradeGroup = 0, nil

for categoryIndex, categoryData in ipairs(Data.UpgradesInfo) do
    if not categoryData then continue end
    for upgradeIndex, upgradeDef in ipairs(categoryData.Upgrades) do
        local boostVisual = Data.BoostsVisual[upgradeDef.Boost]
        local displayName = boostVisual and boostVisual.Name or ("Upgrade " .. upgradeIndex)
        local flagKey = "AutoUpg_" .. categoryIndex .. "_" .. upgradeIndex
        Config.AutoUpgrade[flagKey] = false

        if upgradeCountInGroup % 2 == 0 then
            upgradeGroup = AutoUpgradeSection:Group({})
            MainCategory:Add("Upgrade", upgradeGroup)
        end
        upgradeCountInGroup += 1

        local toggle = upgradeGroup:Toggle({
            Title = displayName,
            Image = GetIcon(boostVisual and boostVisual.Image),
            Flag = flagKey,
            Value = false,
            Callback = function(val)
                Config.AutoUpgrade[flagKey] = val
                if val then
                    StartLoop("AutoUpg_" .. categoryIndex .. "_" .. upgradeIndex, CONSTANTS.UPGRADE_INTERVAL,
                        function() return Config.AutoUpgrade[flagKey] == true end,
                        function()
                            local currentLevel = getUpgradeLevel(categoryIndex, upgradeIndex)
                            local maxLevel = upgradeDef.MaxLevel
                            if currentLevel >= maxLevel then return end
                            local playerResource = getPlayerResource(categoryData)
                            local cost = ConfigModule.GET_UPGRADE_COST(upgradeDef.InitialCost, currentLevel)
                            if playerResource >= cost then
                                RemoteEvents.UpgradeLevelsEvent:FireServer(categoryIndex, upgradeIndex)
                            end
                        end
                    )
                else
                    StopLoop("AutoUpg_" .. categoryIndex .. "_" .. upgradeIndex)
                end
            end
        })

        StartStatus("Status_AutoUpg_" .. categoryIndex .. "_" .. upgradeIndex, 1, function()
            local currentLevel = getUpgradeLevel(categoryIndex, upgradeIndex)
            local maxLevel = upgradeDef.MaxLevel
            local playerResource = getPlayerResource(categoryData)
            local cost = (currentLevel < maxLevel) and ConfigModule.GET_UPGRADE_COST(upgradeDef.InitialCost, currentLevel) or nil
            local isMax = currentLevel >= maxLevel

            SafeSetTitle(toggle, string.format("%s (%d/%d)", displayName, currentLevel, maxLevel))
            local lines = {}
            if isMax then
                table.insert(lines, "Status: MAX")
            else
                local color = playerResource >= cost and "#00ff00" or "#ff5555"
                table.insert(lines, string.format("Cost: %s/%s %s",
                    fmtNum(playerResource), fmtNum(cost), Data.ResourcesInfo[categoryData.CostId].Name))
            end
            SafeSetDesc(toggle, table.concat(lines, "\n"))
        end)
    end
end

-- ============================================================
-- AUTO SINGLE UPGRADE MODULE
-- ============================================================
Config.AutoSingleUpgrade = {}

local function getPlayerResourceSingle(resourceName)
    local resources = UIController.GetFolderTable("Resources") or {}
    return resources[resourceName] or 0
end

local function getSingleUpgradeLevel(index)
    local upgrades = UIController.GetFolderTable("SingleUpgrades") or {}
    return upgrades[tostring(index)] or 0
end

local AutoSingleUpgradeSection = MainTabs:Section({ Title = "Single Upgrade" })
MainCategory:Add("Upgrade", AutoSingleUpgradeSection)

local singleUpgCountInGroup, singleUpgGroup = 0, nil

for upgradeIndex, upgradeDef in ipairs(Data.SingleUpgradesInfo) do
    if not upgradeDef then continue end
    local flagKey = "AutoSingleUpg_" .. upgradeIndex
    Config.AutoSingleUpgrade[flagKey] = false

    if singleUpgCountInGroup % 2 == 0 then
        singleUpgGroup = AutoSingleUpgradeSection:Group({})
        MainCategory:Add("Upgrade", singleUpgGroup)
    end
    singleUpgCountInGroup += 1

    local buffVisual = Data.BoostsVisual[upgradeDef.BuffKey]
    local toggle = singleUpgGroup:Toggle({
        Title = buffVisual and buffVisual.Name or upgradeDef.BuffKey or "Buff",
        Image = GetIcon(buffVisual and buffVisual.Image),
        Flag = flagKey,
        Value = false,
        Callback = function(val)
            Config.AutoSingleUpgrade[flagKey] = val
            if val then
                StartLoop("AutoSingleUpg_" .. upgradeIndex, CONSTANTS.UPGRADE_INTERVAL,
                    function() return Config.AutoSingleUpgrade[flagKey] == true end,
                    function()
                        local currentLevel = getSingleUpgradeLevel(upgradeIndex)
                        local maxLevel = upgradeDef.LevelMax
                        if currentLevel >= maxLevel then return end
                        local playerResource = getPlayerResourceSingle(upgradeDef.NecessaryResource)
                        local cost = upgradeDef.GetCost(currentLevel)
                        if playerResource >= cost then
                            SingleUpgradeEvent:FireServer(upgradeIndex)
                        end
                    end
                )
            else
                StopLoop("AutoSingleUpg_" .. upgradeIndex)
            end
        end
    })

    StartStatus("Status_AutoSingleUpg_" .. upgradeIndex, 1, function()
        local currentLevel = getSingleUpgradeLevel(upgradeIndex)
        local maxLevel = upgradeDef.LevelMax
        local playerResource = getPlayerResourceSingle(upgradeDef.NecessaryResource)
        local cost = (currentLevel < maxLevel) and upgradeDef.GetCost(currentLevel) or nil
        local isMax = currentLevel >= maxLevel

        local lines = { string.format("Level: %d/%d", currentLevel, maxLevel) }
        local buffVisual = Data.BoostsVisual[upgradeDef.BuffKey]
        local buffName = buffVisual and buffVisual.Name or upgradeDef.BuffKey or "Buff"
        local buffValue = upgradeDef.IncreaseBuff * currentLevel
        table.insert(lines, string.format("Buff: x%.2f %s", buffValue, buffName))
        if isMax then
            table.insert(lines, "Status: MAX")
        else
            table.insert(lines, string.format("Cost: %s/%s %s",
                fmtNum(playerResource), fmtNum(cost), Data.ResourcesInfo[upgradeDef.NecessaryResource].Name))
        end
        SafeSetDesc(toggle, table.concat(lines, "\n"))
    end)
end

-- ============================================================
-- AUTO SKILL TREE MODULE
-- ============================================================
Config.AutoSkillTreeAll = false

local SkillTreeInfo = require(ReplicatedStorage.Shared.Info.SkillTreeInfo)
local SkillTreeUtils = require(ReplicatedStorage.Shared.Utils.SkillTreeUtils)
local BuySkillNodeEvent = RemoteEvents.BuySkillNodeEvent

local AutoSkillTreeSection = MainTabs:Section({ Title = "Skill Tree" })
MainCategory:Add("Upgrade", AutoSkillTreeSection)

local autoSkillTreeAllToggle = AutoSkillTreeSection:Toggle({
    Title = "Auto Skill Tree (All)",
    Flag = "AutoSkillTreeAll",
    Value = false,
    Callback = function(val)
        Config.AutoSkillTreeAll = val
        if val then
            StartLoop("AutoSkillTreeAll", 1,
                function() return Config.AutoSkillTreeAll end,
                function()
                    local skillTreeData = UIController.GetFolderTable("SkillTree") or {}
                    local resources = UIController.GetFolderTable("Resources") or {}

                    local buyableNodes = {}
                    for treeName, treeData in pairs(SkillTreeInfo) do
                        if treeData and treeData.Nodes then
                            for _, node in ipairs(treeData.Nodes) do
                                if not SkillTreeUtils.IsUnlocked(node, skillTreeData)
                                    and SkillTreeUtils.IsBuyable(treeData, node, skillTreeData)
                                    and SkillTreeUtils.CanAfford(node, resources) then
                                    table.insert(buyableNodes, {
                                        treeName = treeName,
                                        node = node,
                                        cost = SkillTreeUtils.GetCostAmount(node),
                                    })
                                end
                            end
                        end
                    end

                    if #buyableNodes > 0 then
                        table.sort(buyableNodes, function(a, b) return a.cost < b.cost end)
                        BuySkillNodeEvent:FireServer(buyableNodes[1].treeName, buyableNodes[1].node.Id)
                    end
                end
            )
        else
            StopLoop("AutoSkillTreeAll")
        end
    end
})

StartStatus("Status_AutoSkillTreeAll", 1, function()
    if not autoSkillTreeAllToggle then return end
    local skillTreeData = UIController.GetFolderTable("SkillTree") or {}
    local resources = UIController.GetFolderTable("Resources") or {}

    local lines = { string.format("Auto Skill Tree: %s", Config.AutoSkillTreeAll and "ON" or "OFF") }
    local totalBuyable = 0

    for treeName, treeData in pairs(SkillTreeInfo) do
        if treeData and treeData.Nodes then
            for _, node in ipairs(treeData.Nodes) do
                if not SkillTreeUtils.IsUnlocked(node, skillTreeData)
                    and SkillTreeUtils.IsBuyable(treeData, node, skillTreeData)
                    and SkillTreeUtils.CanAfford(node, resources) then
                    totalBuyable += 1
                end
            end
        end
    end

    table.insert(lines, string.format("Buyable Nodes: %d", totalBuyable))
    SafeSetDesc(autoSkillTreeAllToggle, table.concat(lines, "\n"))
end)

-- ============================================================
-- CONFIG AUTO-SAVE LOOP
-- ============================================================
task.spawn(function()
    local CM = Window.ConfigManager
    if not CM then return end

    pcall(function()
        ConfigName = NormalizeConfigName(ConfigName)
        if ConfigNameInput and ConfigNameInput.Set then ConfigNameInput:Set(ConfigName) end
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
                if cfg then SaveLastConfigName(); cfg:Save() end
            end)
        end
    end
    Window:DisconnectAll()
end)