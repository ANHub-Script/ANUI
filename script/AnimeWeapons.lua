if game.PlaceId ~= 79189799490564 then
    return
end

repeat
    task.wait()
until game:IsLoaded()
-- [[ 1. INITIALIZATION & SERVICE SYNC ]] --
local game_G = getrenv()._G
local shared = getrenv().shared

-- Mengambil service langsung dari memori game agar performa maksimal
local RF = game_G.RF or game:GetService("ReplicatedFirst")
local RS = game_G.RS or game:GetService("ReplicatedStorage")
ReplicatedFirst = RF
local RC = game_G.RC or game:GetService("RunService")

-- Pastikan game sudah selesai loading modul penting
repeat task.wait() until shared.Essential and shared.Reply

-- Referensi lokal ke modul game
local Essential = shared.Essential
EnergyUpgrade = shared.EnergyUpgrade
HunterUpgrade = shared.Hunter
Materials = shared.Materials
UnlocksPrices = shared.Unlocks
YenUpgrades = shared.YenUpgrades
YenUpgrades2 = shared.YenUpgrades2
TokenUpgrades = shared.TokenUpgrades
RankUp = shared.RankUp
AvatarLevels = shared.AvatarLevels
LevelUp = shared.LevelUp
MegaBoss = shared.MegaBoss
MegaBossUpgradeConfig = MegaBoss.Upgrades
Enchantments = shared.Enchantments
RarityPower = shared.RarityPower
AvatarCurses = shared.AvatarCurses
Utils = shared.Utils
Reply = shared.Reply
HiddenQuests = shared.HiddenQuests.List
Potions = shared.Potions
Accessories = shared.Accessories
Enemies = shared.Enemies
Weapons = shared.Weapons
RelicsConfig = shared.Relics
CapitalsUpgradesConfig = shared.CapitalsUpgrades
AchievementsConfig = shared.Achievements
TimeRewardsConfig = shared.TimeRewards
UpgradeModules = {
    DemonArt = shared.DemonArt,
    MagicEyes = shared.MagicEyes,
}

Players = game:GetService("Players")
Workspace = game:GetService("Workspace")
HttpService = game:GetService("HttpService")
RunService = game:GetService("RunService")
VirtualUser = game:GetService("VirtualUser")
LocalPlayer = Players.LocalPlayer
-- if LocalPlayer.UserId == 9891690208 then
--     return
-- end
FolderPath = "ANUI/AnimeWeapons"
ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
ZoneDBFile = "Zone_Database.json"
Reliable = RS:WaitForChild("Reply"):WaitForChild("Reliable")
UnReliable = RS:WaitForChild("Reply"):WaitForChild("Unreliable")
ConfigsPath = RS.Scripts.Configs
YenUpgrade2ToggleUI = {}
RarityPowerUI = {}

hrp = nil
humanoid = nil
LastZone = nil
CurrentZoneName = ""
CurrentZoneEnemiesCache = {}
IsLoadingConfig = false
MeteorState = {
    IsActive = false,
    Zone = nil,
    Position = nil,
    LandTime = 0
}
MegaBossState = {
    IsActive = false,
    TargetZone = nil,
    ReturnZone = nil,
    BossDeadCheck = 0,
    PendingTargetZone = nil,
    PendingZoneDisplayName = nil,
    PendingReceivedAt = 0
}
IsTeleporting = false
RollConfigs = {}
AllRollTypes = {}
ChanceModules = {}
ChanceSortedNames = {}
UpgradeSortedNames = {}
CombinedToggleUI = {}
Config = {
    AutoUpgradeMagicEyes = false,
    SelectedEnemy = nil,
    ZoneConfigurations = {},
    AutoGamemode = false,
    TargetDungeon = {},
    TargetRaid = {},
    TargetCapitalRaid = {},
    AutoLeave_CapitalRaid = 1000,
    TargetMagicRaid = {},
    AutoLeave_MagicRaid = 500,
    TargetDefense = {},
    TargetSorcerersDefense = {},
    TargetPirateTower = {},
    TargetShadowGate = {},
    TargetWave = 500,
    AutoEquipVaultMode = nil,
    AutoEquipVaultFarm = nil,
    AutoAvatarLevelUp = false,
    AutoJoinDefense = false,
    AutoJoinRaid = false,
    AutoRollHeroStats = false,
    HeroesStats_LockStats = "",
    AutoLeave = false,
    AutoLeave_Dungeon = 50,
    AutoLeave_Raid = 500,
    AutoLeave_Defense = 200,
    AutoLeave_PirateTower = 500,
    AutoLeave_ShadowGate = 500
}
EnemyDropdown = nil
RankProgressUI = nil
RollToggleUI = {}
YenUpgradeToggleUI = {}
TokenUpgradeToggleUI = {}
ZoneDisplayToID = {}
getgenv().PlayerData = nil
getgenv().EnemiesData = nil

loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()
local function JSONPretty(val, indent)
    indent = indent or 0;
    local valType = typeof(val); -- Menggunakan typeof untuk deteksi Instance
    
    if valType == "table" then
        local s = "{\n";
        for k, v in pairs(val) do
            local formattedKey = typeof(k) == "number" and tostring(k) or "\"" .. tostring(k) .. "\"";
            s = s .. string.rep("    ", indent + 1) .. formattedKey .. ": " .. tostring(JSONPretty(v, indent + 1)) .. ",\n";
        end;
        return s .. string.rep("    ", indent) .. "}";
    elseif valType == "string" then
        return "\"" .. val .. "\"";
    elseif valType == "Instance" then
        -- PERBAIKAN: Jika objek adalah Instance, ambil jalur lengkapnya (Hierarchy)
        return "\"" .. val:GetFullName() .. "\""; 
    elseif valType == "function" then
        local info = debug.getinfo(val)
        return "\"function: " .. tostring(info.source) .. " | Line: " .. tostring(info.linedefined) .. "\"";
    else
        -- Untuk tipe data lain seperti boolean, number, atau RBXScriptConnection
        local result = tostring(val)
        if valType == "number" or valType == "boolean" then
            return result
        else
            return "\"" .. result .. "\""
        end
    end;
end;
function HookTimerVariable()
    task.spawn(function()
        local targetFound = false
        
        while not targetFound do
            local gcList = getgc() 

            for _, func in pairs(gcList) do
                if type(func) == "function" and islclosure(func) then
                    local info = debug.getinfo(func)

                    if info.source and string.find(info.source, "AutoReconnect.c") then
                        
                        local upvalues = debug.getupvalues(func)
                        for index, value in pairs(upvalues) do

                            if type(value) == "number" then
                                targetFound = true

                                local connection
                                connection = RunService.Heartbeat:Connect(function()
                                    if func then
                                        debug.setupvalue(func, index, 0)
                                    else
                                        if connection then connection:Disconnect() end
                                    end
                                end)
                            end

                            if typeof(value) == "Instance" and (value:IsA("TextLabel") or value:IsA("Frame")) then
                                value.Visible = false
                                value:GetPropertyChangedSignal("Visible"):Connect(function()
                                    value.Visible = false
                                end)
                            end
                        end
                    end
                end
            end
            
            if targetFound then break end
            task.wait(2)
        end
    end)
end
HookTimerVariable()
function GetNextTime(startTimes)
    if not startTimes or #startTimes == 0 then return nil end
    local currentMin = os.date("*t").min
    
    local minDiff = 999
    
    for _, startMin in ipairs(startTimes) do
        local diff = startMin - currentMin
        if diff < 0 then diff = diff + 60 end
        if diff < minDiff then minDiff = diff end
    end
    return minDiff
end
pcall(function()
    local ZoneCfg = require(RS.Scripts.Configs.Zones)
    for id, data in pairs(ZoneCfg) do
        if data.Name then
            ZoneDisplayToID[data.Name] = id
        end
    end
end)
function SecureWipe()
    if not isfile or (not delfile) or (not readfile) or (not listfiles) then
        return
    end
    
    local currentTime = os.time()
    local isExpired = false

    if isfile(ExpiryFile) then
        local savedTime = tonumber(readfile(ExpiryFile)) or 0
        if currentTime > savedTime then
            isExpired = true
        end
    elseif isfolder(FolderPath) then
        isExpired = true
    end

    if isExpired then
        if isfile(ExpiryFile) then
            delfile(ExpiryFile)
        end

        local PossiblePaths = { FolderPath }
        local UserId = tostring(LocalPlayer.UserId)
        
        for _, path in pairs(PossiblePaths) do
            if isfolder(path) then
                for _, file in pairs(listfiles(path)) do
                    if string.find(file, ".key") or string.find(file, ".json") or string.find(file, UserId) then
                        pcall(function()
                            delfile(file)
                        end)
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
SecureWipe()

if not isfolder("ANUI") then makefolder("ANUI") end
if not isfolder(FolderPath) then makefolder(FolderPath) end

MainController = nil
if Reply and Reply.Connect then
    local Listeners = debug.getupvalue(Reply.Connect, 1)

    if type(Listeners) ~= "table" or not Listeners["Data Sync Setup"] then
        for _, uv in pairs(debug.getupvalues(Reply.Connect)) do
            if type(uv) == "table" and uv["Data Sync Setup"] then
                Listeners = uv
                break
            end
        end
    end

    if Listeners and Listeners["Data Sync Setup"] then
        for func, _ in pairs(Listeners["Data Sync Setup"]) do
            if type(func) == "function" then
                local upvals = debug.getupvalues(func)
                for _, val in pairs(upvals) do
                    if type(val) == "table" and rawget(val, "Data") and rawget(val, "SyncChanged") then
                        MainController = val
                        break
                    end
                end
            end
            if MainController then break end
        end
    end
end
if MainController then
    getgenv().EnemiesData = MainController.Enemies
end
-- [[ SYNCHRONIZED WATER BYPASS - FIX READONLY ]] --
task.spawn(function()
    local originalTo
    originalTo = hookfunction(shared.Reply.To, function(...)
        local args = {...}
        if args[1] == "Return Teleport" then
            return
        end
        if args[1] == "Auto Reconnect" then
            return
        end
        return originalTo(...)
    end)
end)

-- [1] Load Config Tambahan (Zone & Enemies) untuk Display Name
ZonesConfig = ZonesConfig or {}

pcall(function()
    local ZonesMod = RS.Scripts.Configs.Zones
    if ZonesMod then ZonesConfig = require(ZonesMod) end
end)

-- Helper: Get Display Name for Enemy
function GetEnemyDisplayName(enemyId)
    if Enemies and Enemies[enemyId] and Enemies[enemyId].Display then
        return Enemies[enemyId].Display
    end
    return enemyId -- Fallback ke ID jika tidak ketemu
end

-- Helper: Get Zone Display Name
function GetZoneDisplayName(zoneId)
    if ZonesConfig and ZonesConfig[zoneId] then
        return ZonesConfig[zoneId].Name or zoneId
    end
    return zoneId
end

function DiscoverRollTypes()
    local set = {}
    local cfgRoot = ConfigsPath
    if not cfgRoot then return end
    
    local rollsFolder = cfgRoot:FindFirstChild("RollGachas")
    if rollsFolder then
        for _, child in pairs(rollsFolder:GetChildren()) do
            if child:IsA("ModuleScript") then
                set[child.Name] = true
            end
        end
    end
    
    local upgradesFolder = cfgRoot:FindFirstChild("RollGachaUpgrades")
    if upgradesFolder then
        for _, child in pairs(upgradesFolder:GetChildren()) do
            if child:IsA("ModuleScript") then
                set[child.Name] = true
            end
        end
    end
    
    AllRollTypes = {}
    for name, _ in pairs(set) do
        table.insert(AllRollTypes, name)
    end
    table.sort(AllRollTypes)
end
DiscoverRollTypes()

function ScanPlayerData()
    if (getgenv()).PlayerData then
        return
    end
    (getgenv()).PlayerData = MainController.Data
end
task.spawn(ScanPlayerData)

function GetIcon(id)
    return string.format("rbxassetid://%s", id)
end

task.spawn(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

function LoadZoneDB()
    local path = FolderPath .. "/" .. ZoneDBFile
    if not isfile(path) then return end
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if success and type(result) == "table" then
        Config.ZoneConfigurations = result
    end
end

function NormalizeEnemySelection(selection)
    if selection == nil then return nil end
    local results = {}
    local seen = {}
    local function add(v)
        if v == nil then return end
        v = tostring(v)
        if v == "" then return end
        if seen[v] then return end
        seen[v] = true
        table.insert(results, v)
    end
    if type(selection) == "table" then
        if selection.Value ~= nil or selection.Title ~= nil then
            add(selection.Value or selection.Title)
        else
            for _, item in ipairs(selection) do
                if type(item) == "table" then
                    add(item.Value or item.Title)
                else
                    add(item)
                end
            end
        end
    else
        add(selection)
    end
    if #results == 0 then return nil end
    return results
end

function EnemySelectionHas(list, value)
    if not list or not value then return false end
    for _, v in ipairs(list) do
        if v == value then return true end
    end
    return false
end

function BuildEnemyDropdownSelection(valuesList, options)
    if not valuesList or not options then return nil end
    local selectedSet = {}
    for _, v in ipairs(valuesList) do
        selectedSet[v] = true
    end
    local selectedItems = {}
    for _, opt in ipairs(options) do
        if type(opt) == "table" and selectedSet[opt.Value] then
            table.insert(selectedItems, opt)
        end
    end
    if #selectedItems == 0 then return nil end
    return selectedItems
end

function SaveZoneConfig(zone, selectedItem)
    if not zone or zone == "" or zone == "Unknown" then return end
    local valuesList = NormalizeEnemySelection(selectedItem)
    if not valuesList then
        Config.SelectedEnemy = nil
        Config.ZoneConfigurations[zone] = nil
    else
        Config.SelectedEnemy = valuesList
        Config.ZoneConfigurations[zone] = { Values = valuesList }
    end

    if not isfolder(FolderPath) then
        makefolder(FolderPath)
    end
    if writefile and HttpService then
        pcall(function()
            writefile(FolderPath .. "/" .. ZoneDBFile, HttpService:JSONEncode(Config.ZoneConfigurations))
        end)
    end
end
LoadZoneDB()

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
if not IsPremium then return end
UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v=" .. math.random()))()

Window = UI:CreateWindow({
    Title = "ANHub - Anime Weapon",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeWeapons",
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 220,
    HideSearchBar = true,
    KeySystem = {
        -- Fitur Auto-Fill/Bypass: Jika Premium, Enabled = false (langsung masuk)
        Enabled = not IsPremium, 
        Title = "ANHub Access",
        Description = "Free Key: ANHUB-2025",
        Key = ValidKeys,
        URL = "https://discord.gg/RvT7Av93nr",
        Note = "Premium Users are auto-verified!",
        SaveKey = true
    }
})

function GetAvatarTokenIcon()
    local tokenKey = AvatarLevels.Token or "AvatarToken"
    local config = Materials[tokenKey]
    if config and config.Template then
        return GetIcon(config.Template)
    end
end

function LoadRollData(rollType)
    local success, module = pcall(function()
        return require(ConfigsPath.RollGachas[rollType])
    end)
    
    if not success or not module then
        success, module = pcall(function()
            return require(ConfigsPath.RollGachaUpgrades[rollType])
        end)
    end

    if success and module then
        RollConfigs[rollType] = {
            Display = module.Display,
            Cost = module.Cost or 1,
            MaterialKey = (module.Material or module.UpgradeMaterial) or (rollType .. "Token"),
            ImageId = module.ImageId,
            List = module.List
        }
    end
end

for _, rollType in ipairs(AllRollTypes) do
    LoadRollData(rollType)
end

function GetRollIconAsset(rollType)
    local defaultIcon = "rbxassetid://84366761557806"
    local config = RollConfigs[rollType]    
    local pData = getgenv().PlayerData
    if pData and pData.Vault and pData.Vault[rollType] and config and config.List then
        for i = #config.List, 1, -1 do
            if pData.Vault[rollType][tostring(i)] == true then
                local itemData = config.List[i]
                if itemData and itemData.Template then
                    return GetIcon(itemData.Template)
                end
            end
        end
    end
    if config and config.ImageId then
        return GetIcon(config.ImageId)
    end    
    return defaultIcon
end

_GradientCache = {}
function GetGameGradient(rarityName)
    if _GradientCache[rarityName] then return _GradientCache[rarityName] end
    
    local rf = ReplicatedFirst
    local success, gradientObj = pcall(function()
        return rf.Assets.Gradients.Rarity:FindFirstChild(rarityName)
    end)
    
    if success and gradientObj then 
        _GradientCache[rarityName] = gradientObj.Color
        return gradientObj.Color 
    end
end

function GenerateCardRewards(chanceRewardData)
    local rewardCards = {}
    if not chanceRewardData then return rewardCards end

    local rawCards = {}

    for rewardKey, chanceVal in pairs(chanceRewardData) do
        local cleanKey = string.gsub(rewardKey, "%.", "/") 
        local parts = string.split(cleanKey, "/")
        
        local category = parts[1]
        local itemId = parts[2]
        
        local itemData = nil
        if category == "Materials" and Materials[itemId] then
            itemData = Materials[itemId]
        elseif category == "Weapons" and Weapons[itemId] then
            itemData = Weapons[itemId]
        elseif category == "Accessories" and Accessories[itemId] then
            itemData = Accessories[itemId]
        elseif category == "Potions" and Potions[itemId] then
            itemData = Potions[itemId]
        end

        if itemData then
            local imgId = itemData.Template
            if imgId then
                if not tostring(imgId):find("rbxassetid://") then
                    imgId = GetIcon(imgId)
                else
                    imgId = tostring(imgId)
                end
                
                local rarity = itemData.Rarity or "Common"
                local itemName = itemData.Display or itemId
                local chanceStr = "Rate:" .. tostring(chanceVal) .. "%"

                table.insert(rawCards, {
                    Image = imgId,
                    Gradient = GetGameGradient(rarity),
                    Quantity = chanceStr,
                    Title = itemName,
                    
                    ChanceValue = chanceVal,
                    ItemId = itemId,
                    Category = category
                })
            end
        end
    end

    table.sort(rawCards, function(a, b)
        if a.ChanceValue ~= b.ChanceValue then return a.ChanceValue > b.ChanceValue end
        if a.ItemId ~= b.ItemId then return a.ItemId < b.ItemId end
        return a.Category < b.Category
    end)
    
    for _, card in ipairs(rawCards) do
        table.insert(rewardCards, {
            Image = card.Image,
            Gradient = card.Gradient,
            Quantity = card.Quantity,
            Title = card.Title
        })
    end

    return rewardCards
end

function RefreshEnemyData()
    local uiList = {}
    local rawEnemies = getgenv().EnemiesData

    if rawEnemies and CurrentZoneName and CurrentZoneName ~= "" and CurrentZoneName ~= "Unknown" then
        
        local liveEnemiesSnapshot = {}
        for k, v in pairs(rawEnemies) do
            liveEnemiesSnapshot[k] = v
        end

        local added = {}
        local processCount = 0 
        
        for uid, enemyObj in pairs(liveEnemiesSnapshot) do
            processCount = processCount + 1
            if processCount % 10 == 0 then 
                task.wait()
            end

            if rawEnemies[uid] then 
                if enemyObj.Config and enemyObj.Data and (enemyObj.Data.Class == "Islands" or enemyObj.Data.Class == "MegaBoss") then
                    
                    local displayName = enemyObj.Config.Display or "Unknown"
                    
                    if not added[displayName] then
                        added[displayName] = true
                        
                        local diff = "Normal"
                        if enemyObj.DifficultConfig and enemyObj.DifficultConfig.Display then
                            diff = enemyObj.DifficultConfig.Display
                        elseif enemyObj.Config.Difficult then
                            diff = enemyObj.Config.Difficult
                        end
                        
                        if enemyObj.Data.Class == "MegaBoss" then diff = "Mega Boss" end

                        local maxHp = 0
                        if enemyObj.Data.MaxHealth then maxHp = enemyObj.Data.MaxHealth
                        elseif enemyObj.Data.Class == "MegaBoss" and MegaBoss.BossConfig then maxHp = MegaBoss.BossConfig.MaxHealth
                        elseif enemyObj.Config.MaxHealth then maxHp = enemyObj.Config.MaxHealth end

                        local rewards = {}
                        if enemyObj.Data.Class == "MegaBoss" and MegaBoss then
                            if MegaBoss.ChanceRewards then for k, v in pairs(MegaBoss.ChanceRewards) do rewards[k] = v end end
                            if MegaBoss.Rewards then for _, itemStr in ipairs(MegaBoss.Rewards) do rewards[itemStr] = 100 end end
                        else
                            if enemyObj.Config.ChanceReward then for k, v in pairs(enemyObj.Config.ChanceReward) do rewards[k] = v end end
                            rewards["Materials.AvatarToken"] = 5
                        end
                        
                        local rewardImages = GenerateCardRewards(rewards)

                        table.insert(uiList, {
                            Title = displayName .. " (" .. diff .. ")",
                            Value = displayName,
                            Desc = "HP: " .. Utils.ToText(maxHp),
                            HP = maxHp,
                            Images = rewardImages
                        })
                    end
                end
            end
        end
    end
    
    table.sort(uiList, function(a, b) return a.HP < b.HP end)
    CurrentZoneEnemiesCache = uiList
    return uiList
end
getgenv().Controller = MainController

task.delay(1.0, function()
    Window:CollapseSidebar()
end)

task.delay(3.0, function()
    Window:ExpandSidebar()
end)

function Notify(title, content, icon)
    task.spawn(function()
        pcall(function()
            if UI and UI.Notify then
                UI:Notify({ Title = title, Content = content, Icon = icon, Duration = 3 })
            end
        end)
    end)
end
GameIconURL = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150"
BaseProfile = {
    Banner = "rbxassetid://124762019485618", Avatar = "rbxassetid://84366761557806", Status = true,
    Badges = {
        {
            Icon = "geist:logo-discord", Title = "Discord", Desc = "Join ANHUB Discord",
            Callback = function() setclipboard("https://discord.gg/RvT7Av93nr") Notify("Discord", "Invite link copied to clipboard!", "geist:logo-discord") end
        },
        {
            Icon = "youtube", Desc = "Subscribe to YouTube",
            Callback = function() setclipboard("https://www.youtube.com/@ANHubRoblox") Notify("YouTube", "Channel link copied!", "youtube") end
        }
    }
}

function MakeProfile(data)
    local p = table.clone(BaseProfile)
    for k, v in pairs(data or {}) do p[k] = v end
    return p
end

Window:Tab({
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Weapons",
    Badges = {
        {
            Icon = "geist:logo-discord", Desc = "Join ANHUB Discord",
            Callback = function() setclipboard("https://discord.gg/RvT7Av93nr") Notify("Discord", "Invite link copied to clipboard!", "geist:logo-discord") end
        },
        {
            Icon = "youtube", Desc = "Subscribe to YouTube",
            Callback = function() setclipboard("https://www.youtube.com/@ANHubRoblox") Notify("YouTube", "Channel link copied!", "youtube") end
        }
    } }),
    SidebarProfile = true
})

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

if not isfile(ExpiryFile) then
    writefile(ExpiryFile, tostring(os.time() + 86400));
end;

Window:OnDestroy(function()
    if CurrentZoneName ~= "" and Config.SelectedEnemy then
        SaveZoneConfig(CurrentZoneName, Config.SelectedEnemy);
    end;
end);
LocalPlayer.CharacterAdded:Connect(function(char)
    hrp = char:WaitForChild("HumanoidRootPart");
    humanoid = char:WaitForChild("Humanoid");
end);
pcall(function()
    if LocalPlayer.Character then
        hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
        humanoid = LocalPlayer.Character:FindFirstChild("Humanoid");
    end;
end);
local LastAutoSettingCheck = 0 -- Variabel penanda waktu (Debounce)

function MaintainAutoStatus()
    while not Window.Destroyed do
        -- Hanya jalankan jika Auto Farm atau Auto Gamemode aktif
        if Config.AutoFarm or Config.AutoDungeon then
            
            -- [OPTIMASI PENTING] 
            -- Gunakan selisih waktu (os.time) agar logic ini hanya jalan setiap 2 detik.
            -- Ini mencegah spam remote event jika server sedang lag mengupdate data player.
            if (os.time() - LastAutoSettingCheck) > 2 then
                
                local Data = (getgenv()).PlayerData;
                
                if Data and Data.Settings and Reply and Reply.To then

                    -- 2. Cek Setting Auto Attack
                    if Data.Settings.AutoAttack == false then
                        pcall(function()
                            Reply.To("Settings","AutoAttack",true);
                        end);
                    end;
                end;
                
                -- Update waktu terakhir pengecekan ke waktu sekarang
                LastAutoSettingCheck = os.time()
            end;
        end;
        
        -- Loop tetap menunggu 1 detik agar tidak memberatkan thread,
        -- tapi logic berat di atas sudah ditahan oleh if (os.time...)
        task.wait(1);
    end;
end;
task.spawn(MaintainAutoStatus);
function isPlayerInZone(zone)
    local chars = zone:FindFirstChild("Characters");
    if chars and chars:FindFirstChild(LocalPlayer.Name) then
        return true;
    end;
    return false;
end;
function GetCurrentMapStatus()
    local pData = getgenv().PlayerData
    
    if pData and pData.Attributes then
        local serverZone = pData.Attributes.Zone
        
        if serverZone and serverZone ~= "" then
            return serverZone
        end
    end

    return "Unknown"
end
function CheckIsFightingZone()
    local mapName = GetCurrentMapStatus()
    -- Tambahkan IgnitionRaid ke dalam list keywords
    local fightingKeywords = {"Dungeon", "Raid", "Defense", "SorcerersDefense", "PirateTower", "ShadowGate", "CapitalRaid", "MagicRaid", "SkullRaid", "IgnitionRaid", "SlimeRaid"} 

    for _, keyword in ipairs(fightingKeywords) do
        if string.find(mapName, keyword) then 
            return true
        end
    end
    return false
end

function GetPartPosition(obj)
    if typeof(obj) == "Instance" then
        if obj:IsA("Model") then
            return obj:GetPivot().Position
        elseif obj:IsA("BasePart") then
            return obj.Position
        end
    end
    return nil
end
function GetDistance(a, b)
    local pa = GetPartPosition(a)
    local pb = GetPartPosition(b)
    if pa and pb then
        return (pa - pb).Magnitude
    end
    return math.huge
end
function LogicAutoFarm()
    local currentTargetObj = nil
    local cycleIndex = 1
    local lastSelectionSignature = ""
    -- Variabel Cooldown Hit (Berdasarkan Click.c)
    local lastHitTick = 0
    local hitCooldown = 0.005
    
    while Config.AutoFarm do
        if Window.Destroyed then break end
        
        local selectedList = NormalizeEnemySelection(Config.SelectedEnemy) or {}
        local selectionSignature = ""
        
        if #selectedList > 0 then
            selectionSignature = table.concat(selectedList, "\n")
        end

        if selectionSignature ~= lastSelectionSignature then
            lastSelectionSignature = selectionSignature
            cycleIndex = 1
        end

        -- [LOGIKA TARGETING & TELEPORTASI LAMA ANDA]
        if currentTargetObj and currentTargetObj.Config and not MegaBossState.IsActive then
            local selected = Config.SelectedEnemy
            local currentName = currentTargetObj.Config.Display
            local keep = false
            
            if type(selected) == "table" then
                keep = EnemySelectionHas(selected, currentName)
            else
                keep = (selected == currentName)
            end

            if not keep then
                currentTargetObj = nil
            end
        end

        if Config.AutoMegaBoss and MegaBossState.IsActive then
            local currentMap = GetCurrentMapStatus()
            
            if currentMap == MegaBossState.TargetZone then
                local bossFound = nil
                local liveEnemies = getgenv().EnemiesData
                
                if liveEnemies then
                    for _, enemy in pairs(liveEnemies) do
                        if enemy.Alive and enemy.Data and enemy.Data.Class == "MegaBoss" then
                            bossFound = enemy
                            break
                        end
                    end
                end

                if bossFound then
                    currentTargetObj = bossFound
                    MegaBossState.BossDeadCheck = 0
                else
                    MegaBossState.BossDeadCheck = MegaBossState.BossDeadCheck + 1
                    if MegaBossState.BossDeadCheck > 50 then 
                        Notify("Mega Boss", "Boss Defeated Returning...", "corner-up-left")
                        MegaBossState.IsActive = false
                        currentTargetObj = nil
                        
                        if MegaBossState.ReturnZone and MegaBossState.ReturnZone ~= currentMap then
                            if Reply and Reply.To then
                                pcall(function() 
                                    Reply.To("Zone Teleport", MegaBossState.ReturnZone) 
                                end)
                            end
                            MegaBossState.ReturnZone = nil
                        end
                    end
                end
            else
                currentTargetObj = nil
                task.wait()
                continue 
            end
        end
        
        if not hrp or not hrp.Parent or not humanoid or humanoid.Health <= 0 then
            currentTargetObj = nil 
            local char = LocalPlayer.Character
            if char then
                hrp = char:FindFirstChild("HumanoidRootPart")
                humanoid = char:FindFirstChild("Humanoid")
            end
            task.wait()
            continue
        end

        local isTargetStillAlive = false
        local deadTargetName = nil
        
        if currentTargetObj then
            if currentTargetObj.Alive and currentTargetObj.Root and currentTargetObj.Root.Parent then
                local data = currentTargetObj.Data
                local hp = (data and data.Health) or 0
                if hp > 0 then
                    isTargetStillAlive = true
                end
            end
        end

        if not isTargetStillAlive then
            if currentTargetObj and currentTargetObj.Config and currentTargetObj.Config.Display then
                deadTargetName = currentTargetObj.Config.Display
            end
            
            currentTargetObj = nil
            
            if deadTargetName and (not MegaBossState.IsActive) and #selectedList > 1 then
                local deadIndex = nil
                for i, v in ipairs(selectedList) do
                    if v == deadTargetName then
                        deadIndex = i
                        break
                    end
                end
                
                if deadIndex then
                    cycleIndex = (deadIndex % #selectedList) + 1
                else
                    cycleIndex = (cycleIndex % #selectedList) + 1
                end
            end
        end

        if not currentTargetObj and not MegaBossState.IsActive then
            local liveData = getgenv().EnemiesData
            if liveData and #selectedList > 0 then
                local myPos = hrp.Position
                local potentialTarget = nil
                
                local function findNearestByName(name)
                    if not name or name == "" then return nil end
                    local minDistance = math.huge
                    local best = nil
                    
                    for _, enemyObj in pairs(liveData) do
                        if enemyObj.Alive and enemyObj.Data and enemyObj.Config then
                            if enemyObj.Config.Display == name and (enemyObj.Data.Class == "Islands" or enemyObj.Data.Class == "MegaBoss") then
                                local hp = enemyObj.Data.Health or 0
                                if hp > 0 and enemyObj.Root then
                                    local enemyPos = enemyObj.Root.Position
                                    local dist = (myPos - enemyPos).Magnitude
                                    if dist < minDistance then
                                        minDistance = dist
                                        best = enemyObj
                                    end
                                end
                            end
                        end
                    end
                    return best
                end

                if #selectedList == 1 then
                    potentialTarget = findNearestByName(selectedList[1])
                else
                    if cycleIndex < 1 or cycleIndex > #selectedList then
                        cycleIndex = 1
                    end
                    
                    for _ = 1, #selectedList do
                        potentialTarget = findNearestByName(selectedList[cycleIndex])
                        if potentialTarget then
                            break
                        end
                        cycleIndex = (cycleIndex % #selectedList) + 1
                    end
                end

                if potentialTarget then
                    currentTargetObj = potentialTarget
                end
            end
        end

        if currentTargetObj and currentTargetObj.Root then
            pcall(function()
                local enemyRoot = currentTargetObj.Root
                local enemyPos = enemyRoot.Position
                local enemyLook = enemyRoot.CFrame.LookVector
                local enemyScale = 1
                
                if currentTargetObj.DifficultConfig and currentTargetObj.DifficultConfig.Scale then
                    enemyScale = currentTargetObj.DifficultConfig.Scale
                elseif currentTargetObj.Config and currentTargetObj.Config.Scale then
                    enemyScale = currentTargetObj.Config.Scale
                end

                local baseHipHeight = 3.0 
                local feetY = enemyPos.Y - (baseHipHeight * enemyScale)
                local myTargetY = feetY + baseHipHeight
                local dirVector = Vector3.new(enemyLook.X, 0, enemyLook.Z).Unit 
                local attackPos = enemyPos + (dirVector * 5)
                local finalPos = Vector3.new(attackPos.X, myTargetY, attackPos.Z)
                local lookAtPos = Vector3.new(enemyPos.X, myTargetY, enemyPos.Z)
                
                hrp.CFrame = CFrame.lookAt(finalPos, lookAtPos)
                
                if hrp.AssemblyLinearVelocity.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end)
        end
        
        local pData = getgenv().PlayerData
        local liveEnemies = getgenv().EnemiesData
        local Controller = getgenv().Controller -- arg1 pada decompile
        
        if pData and liveEnemies and shared.Reply and shared.Multiplier and Controller then
            local inRangeEnemies = {}
            
            -- 1. Scan semua musuh yang berada dalam radius (Jalur Area)
            for _, enemy in pairs(liveEnemies) do
                if enemy.Alive and enemy.Root then
                    local magnitude = (hrp.Position - enemy.Root.Position).Magnitude
                    -- Logika Decompile: Jarak <= Max(Range Musuh, Attack Area Player)
                    local attackArea = Controller.AttackArea or 0
                    local enemyRange = (enemy.Config and enemy.Config.Range) or 0
                    
                    if math.max(enemyRange, attackArea) >= magnitude then
                        table.insert(inRangeEnemies, {
                            Enemy = enemy,
                            Distance = magnitude
                        })
                    end
                end
            end

            -- 2. Sort berdasarkan yang terdekat (Agar Hit tepat sasaran)
            table.sort(inRangeEnemies, function(a, b) 
                return a.Distance < b.Distance 
            end)

            -- 3. Ambil UID sesuai batas MaxAttackTargets
            local targetsToSend = {}
            local maxTargets = shared.Multiplier.Total.MaxAttackTargets(pData)
            
            for i = 1, math.min(maxTargets, #inRangeEnemies) do
                table.insert(targetsToSend, inRangeEnemies[i].Enemy.Uid)
            end

            -- 4. Kirim serangan jika ada target dalam area
            if #targetsToSend > 0 and LocalPlayer.UserId == 5465738868 then
                Reply.UnTo("Hit", targetsToSend)
                lastHitTick = now -- Catatan: Pastikan variabel 'now' didefinisikan di lingkungan Anda
            end
        end

        task.wait() 
    end
end

-- [[ ONE-TIME PERMANENT BYPASS ]] --
task.spawn(function()
    if LocalPlayer.UserId == 5465738868 then
        local debounceFunc = nil
        local clickFunc = nil

        -- Scan GC hanya sampai ketemu target
        for _, f in pairs(getgc()) do
            if type(f) == "function" and islclosure(f) then
                local info = debug.getinfo(f)
                
                -- Bypass Debounce.c
                if info.source and string.find(info.source, "Debounce.c") then
                    debounceFunc = f
                end
                
                -- Bypass Click.c
                if info.source and string.find(info.source, "Click.c") then
                    clickFunc = f
                end
            end
            if debounceFunc and clickFunc then break end
        end

        if debounceFunc then
            -- Hooking: Memaksa fungsi debounce selalu mengembalikan 'false' (tidak cooldown)
            local oldDb = debounceFunc
            hookfunction(debounceFunc, function() return false end)
        end

        if clickFunc then
            -- Mengunci upvalue timestamp di Click.c agar selalu 0 menggunakan Heartbeat
            -- Ini sangat ringan karena tidak melakukan scan memori lagi
            local upvals = debug.getupvalues(clickFunc)
            for i, v in pairs(upvals) do
                if type(v) == "number" then
                    game:GetService("RunService").Heartbeat:Connect(function()
                        debug.setupvalue(clickFunc, i, 0)
                    end)
                    break
                end
            end
            warn("ANHub: Click.c upvalue locked (Infinite Speed)")
        end
    end
end)
task.spawn(function()
    while not Window.Destroyed do
        local anyRollActive = false
        local pData = (getgenv()).PlayerData
        
        if pData and pData.Materials then
            for _, rollType in ipairs(AllRollTypes) do
                if Config["AutoRoll" .. rollType] then
                    anyRollActive = true
                    
                    local config = RollConfigs[rollType]
                    local cost = (config.Cost or 10) * (pData.Gamepasses.Vip and 0.8 or 1)
                    local tokenKey = config and config.MaterialKey or (rollType .. "Token")
                    local currentCount = pData.Materials[tokenKey] or 0
                    
                    if currentCount >= cost and pData.Unlocked[rollType] then
                        if Reply and Reply.To then
                            pcall(function()
                                Reply.To("Crate Roll Start",rollType,false)
                            end)
                        end
                        task.wait(1.5)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    while Window and not Window.Destroyed do
        local isRolling = false
        if AllRollTypes then
            for _, rollType in ipairs(AllRollTypes) do
                if Config["AutoRoll" .. rollType] then
                    isRolling = true
                    break
                end
            end
        end

        if isRolling then
            pcall(function()
                local rollsUI = PlayerGui:FindFirstChild("Rolls")
                if rollsUI then
                    rollsUI.Enabled = false
                    rollsUI.Parent = nil
                end
                
                local crateUI = PlayerGui:FindFirstChild("Crate")
                if crateUI then
                    crateUI.Enabled = false
                    crateUI.Parent = nil
                end
            end)

            local screenUI = PlayerGui:FindFirstChild("Screen")
            if screenUI and not screenUI.Enabled then
                screenUI.Enabled = true
            end

            local topbarUI = PlayerGui:FindFirstChild("TopbarStandard")
            if topbarUI and not topbarUI.Enabled then
                topbarUI.Enabled = true
            end
        end
        
        task.wait(0.1)
    end
end)
InfoTab = Window:Tab({
    Title = "Info",
    Icon = "info"
});
s, tUrl = pcall(function()
    return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150);
end);
PlayerParagraph = InfoTab:Paragraph({
    Title = LocalPlayer.DisplayName,
    Desc = "User ID: " .. tostring(LocalPlayer.UserId) .. "\nKey Valid: Verifying...",
    Image = s and tUrl or "rbxassetid://84366761557806",
    ImageSize = 48,
    Buttons = {
        {
            Title = "Copy HWID",
            Icon = "copy",
            Callback = function()
                setclipboard(tostring(gethwid and gethwid() or LocalPlayer.UserId));
            end
        }
    }
});
task.spawn(function()
    while not Window.Destroyed do
        local success, result = pcall(function()
            if isfile(ExpiryFile) then
                return tonumber(readfile(ExpiryFile)) or 0;
            end;
            return 0;
        end);
        local statusText = "Checking...";
        if success and result > 0 then
            local diff = result - os.time();
            if diff > 0 then
                local h = math.floor(diff / 3600);
                local m = math.floor(diff % 3600 / 60);
                statusText = string.format("%02dh %02dm", h, m);
            else
                statusText = "EXPIRED";
            end;
        else
            statusText = "No Timer";
        end;
        if PlayerParagraph and PlayerParagraph.SetDesc then
            pcall(function()
                PlayerParagraph:SetDesc("User ID: " .. tostring(LocalPlayer.UserId) .. "\nKey Valid: " .. statusText);
            end);
        end;
        task.wait(1);
    end;
end);
CommunitySection = InfoTab:Section({
    Title = "Community",
    Icon = "users",
    Opened = true
});
DiscordInfo = InfoTab:Paragraph({
    Title = "Loading...",
    Desc = "...",
    Image = "rbxassetid://84366761557806",
    ImageSize = 42,
    Buttons = {
        {
            Title = "Copy Discord",
            Icon = "copy",
            Callback = function()
                setclipboard("https://discord.gg/RvT7Av93nr");
            end
        }
    }
});
task.spawn(function()
    local API = "https://discord.com/api/v10/invites/RvT7Av93nr?with_counts=true&with_expiration=true";
    local s, r = pcall(function()
        return HttpService:JSONDecode((UI.Creator.Request({
            Url = API,
            Method = "GET"
        })).Body);
    end);
    if s and r and r.guild then
        DiscordInfo:SetTitle(r.guild.name);
        DiscordInfo:SetDesc("Members: " .. r.approximate_member_count .. "\nOnline: " .. r.approximate_presence_count);
    else
        DiscordInfo:SetTitle("Discord Error");
        DiscordInfo:SetDesc("Failed to fetch info.");
    end;
end);

FarmTab = Window:Tab({
    Title = "Main Feature",
    Icon = "swords",
        Profile = MakeProfile({
            Avatar = GameIconURL,
            Title = "Main Feature",
            Desc = "Anime Weapons"
        }),
        
        SidebarProfile = false
});

FM_Categories = {}
FM_CategoryDescriptions = {
    ["Farm"] = "Auto farm enemies per zone and specific targets",
    ["GameModes"] = "Auto Join & Farm Dungeons/Raids by Time",
    ["Relics"] = "Auto Equip And Upgrade Your Relics",
    ["Vault"] = "Auto Equipped Best Vault for battle/lobby",
    ["Avatar Level"] = "Upgrade Avatar Level, view stats and costs",
    ["Heroes Stats"] = "Reroll Heroes Stats, view stats and costs",
    ["Rarity Powers"] = "Auto Upgrade and Evolve your rarity power stats",
    ["Avatar Curses"] = "Add Extra Stats To Your Avatar",
    ["Ascension"] = "You can exchange all your level progress to obtain boosts.",
    ["Enchantments"] = "Add Stats Enchantments To Your Weapon.",
    ["Weapon Reforging"] = "Reforge Tier 3 weapons to get +50% Mastery Boost (1 Hour process)",
    ["Exchange"] = "Exchange materials, preview tokens and calculate amounts",
    ["Rolls"] = "Auto roll various gachas and monitor material stock",
    ["Upgrade: Yen"] = "Upgrade Yen buff along with cost and effects",
    ["Upgrade: Token"] = "Upgrade Token buff with shards",
    ["Mega Boss"] = "Upgrade MegaBoss buff with shards",
    ["Rankup"] = "Rank progress, requirements, and bonuses",
    ["Trainers"] = "Trainer settings and enhancement",
    ["Crafts"] = "Auto craft/upgrade items and equipment"
}
function FM_GetElementFrame(elem)
    local f = rawget(elem, "ElementFrame") or (elem.UIElements and elem.UIElements.Main) or rawget(elem, "GroupFrame")
    return f
end
function FM_Add(cat, elem)
    if not FM_Categories[cat] then FM_Categories[cat] = {} end
    table.insert(FM_Categories[cat], elem)
    local frame = FM_GetElementFrame(elem)
    if frame then frame.Visible = false end
    return elem
end
function FM_UpdateTabProfile(selected)
    local desc = FM_CategoryDescriptions[selected] or ""
    local containers = {}
    if FarmTab and FarmTab.UIElements then
        table.insert(containers, FarmTab.UIElements.ContainerFrameCanvas)
        table.insert(containers, FarmTab.UIElements.ContainerFrame)
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
function FM_OnChange(selected)
    for name, elems in pairs(FM_Categories) do
        local vis = (name == selected)
        for _, e in ipairs(elems) do
            local f = FM_GetElementFrame(e)
            if f then f.Visible = vis end
        end
    end
    pcall(function()
        FM_UpdateTabProfile(selected)
    end)
end
FM_Category = FarmTab:Category({
    Title = "Select Category",
    Default = "Farm",
    Options = {
        {Title="Farm", Icon=GetIcon(72039606576980)},
        {Title="GameModes", Icon=GetIcon(109634928579023)},
        {Title="Mega Boss", Icon=GetIcon(73239911812292)},
        {Title="Vault", Icon=GetIcon(90798559571883)},
        {Title="Relics", Icon=GetIcon(88061784222994)}, -- TAMBAHKAN INI
        {Title="Energy & Hunter", Icon=GetIcon(92370510867554)},
        {Title="Rarity Powers", Icon=GetIcon(110938344194362)},-- Tambahkan ini ke dalam FM_Category Options
        {Title="Avatar Curses", Icon=GetIcon(140684736911247)}, -- Gunakan icon yang sesuai
        {Title="Avatar Level", Icon=GetAvatarTokenIcon()}, -- Biarkan ini dynamic
        {Title="Heroes Stats", Icon=GetIcon(127892390350003)},-- Tambahkan di dalam FM_Category Options
        {Title="Ascension", Icon=GetIcon(84524784941090)},
        {Title="Enchantments", Icon=GetIcon(136460822046355)},
        {Title="Weapon Reforging", Icon=GetIcon(76533888574769)},
        {Title="Exchange", Icon=GetIcon(101595095661272)},
        {Title="Rolls", Icon=GetIcon(128047949460588)},
        {Title="Upgrade: Yen", Icon=GetIcon(139379806755218)},
        {Title="Upgrade: Token", Icon=GetIcon(124644932563791)},
        {Title="Upgrade: Capital", Icon=GetIcon(133067980243922)},
        {Title="Rankup", Icon=GetIcon(111262536381336)},
        {Title="Trainers", Icon=GetIcon(92875014242960)},
        {Title="Secret Quests", Icon=GetIcon(98394716892889)},
        {Title="Misc", Icon=GetIcon(128660194699457)},
        {Title="Crafts", Icon=GetIcon(132575095676543)}
    },
    Callback = FM_OnChange
})

if FM_Category.ElementFrame then 
    FM_Category.ElementFrame.Parent = FarmTab.UIElements.ContainerFrameCanvas 
    FM_Category.ElementFrame.Position = UDim2.new(0,0,0, FarmTab.UIElements.ContainerFrame.Position.Y.Offset)
    
    local catSize = FM_Category.ElementFrame.Size.Y.Offset
    FarmTab.UIElements.ContainerFrame.Position = UDim2.new(0,0,0, FarmTab.UIElements.ContainerFrame.Position.Y.Offset + catSize)
    FarmTab.UIElements.ContainerFrame.Size = UDim2.new(1, 0, 1, FarmTab.UIElements.ContainerFrame.Size.Y.Offset - catSize)
    
    local pad = FarmTab.UIElements.ContainerFrame:FindFirstChildOfClass("UIPadding")
    if pad then pad.PaddingTop = UDim.new(0, 5) end
end
FarmTab:Space({Columns=1})

EnemyDropdown = FarmTab:Dropdown({
    Title = "Select Enemy",
    Multi = true,
    Values = {},
    AllowNone = true,
    ImageSize = UDim2.fromOffset(20, 20),
    ImagePadding = 6,
    Flag = "TargetEnemies_Cfg",
    Callback = function(selectedItem)
        if IsLoadingConfig then
            return;
        end;
        local normalized = NormalizeEnemySelection(selectedItem)
        Config.SelectedEnemy = normalized
        SaveZoneConfig(CurrentZoneName, normalized);
    end
});
FM_Add("Farm", EnemyDropdown);

EnemyDropdownNeedsRefresh = true
function EnemyDropdown_SetPendingValues(values)
    CurrentZoneEnemiesCache = values or {}
    if EnemyDropdown then
        EnemyDropdown.Values = CurrentZoneEnemiesCache
    end
    EnemyDropdownNeedsRefresh = true
end

function EnemyDropdown_SetValueOnlyFromConfig()
    if not EnemyDropdown then return end
    local selectedList = NormalizeEnemySelection(Config.SelectedEnemy) or {}
    local selectedItems = BuildEnemyDropdownSelection(selectedList, CurrentZoneEnemiesCache) or {}
    EnemyDropdown.Value = selectedItems
    if EnemyDropdown.Display then
        pcall(function() EnemyDropdown.Display() end)
    end
end

function EnemyDropdown_ApplyPendingRefresh()
    if not EnemyDropdownNeedsRefresh then return end
    if not EnemyDropdown then return end
    local selectedList = NormalizeEnemySelection(Config.SelectedEnemy) or {}
    local selectedItems = BuildEnemyDropdownSelection(selectedList, CurrentZoneEnemiesCache) or {}
    EnemyDropdown.Value = selectedItems
    if EnemyDropdown.Refresh then
        EnemyDropdown:Refresh(CurrentZoneEnemiesCache)
    end
    EnemyDropdownNeedsRefresh = false
end

do
    local menu = EnemyDropdown and EnemyDropdown.DropdownMenu
    local oldMenuOpen = menu and menu.Open
    if oldMenuOpen then
        menu.Open = function(self, ...)
            if EnemyDropdown and not EnemyDropdown.Opened then
                pcall(EnemyDropdown_ApplyPendingRefresh)
            end
            return oldMenuOpen(self, ...)
        end
    end
end

RefreshBtn = FarmTab:Button({
    Title = "Refresh List",
    Icon = "refresh-cw",
    Callback = function()
        EnemyDropdown:Refresh(RefreshEnemyData());
    end
});
FM_Add("Farm", RefreshBtn);
FarmToggle = FarmTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm_Cfg",
    Callback = function(val)
        Config.AutoFarm = val;
        if val then
            task.spawn(LogicAutoFarm);
        end;
    end
});
FM_Add("Farm", FarmToggle);
-- [[ INSERT THIS CODE BELOW MegaBossToggle ]] --

MeteorToggle = FarmTab:Toggle({
    Title = "Meteor Event",
    Desc = "Auto Teleport to Zone & Teleport to Kill Mobs Get Hit Meteor.",
    Flag = "AutoMeteor_Cfg",
    Callback = function(val)
        Config.AutoMeteor = val
    end
})

-- [[ LOAD QUESTS CONFIG ]] --
QuestsConfig = nil
pcall(function()
    QuestsConfig = shared.Quests
end)
-- [[ TAMBAHAN UI FARM ]] --
AutoQuestToggle = FarmTab:Toggle({
    Title = "Auto Accept & Claim Quests",
    Desc = "Automatically accepts and claims zone quests.",
    Flag = "AutoQuest_Cfg",
    Callback = function(val)
        Config.AutoQuest = val
    end
})
FM_Add("Farm", AutoQuestToggle)
if LocalPlayer.UserId ~= 9891690208 then
    FM_Add("Farm", MeteorToggle) -- Kita gabung di kategori Mega Boss atau buat Group baru jika mau
end

function LogicGamemodes()
    local wasInGamemode = false;
    local currentTargetObj = nil;
    local hasTeleportedToBossInRaid = false;
    
    local hrp = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))

    while Config.AutoDungeon do
        if Window.Destroyed then break end;
        
        if not hrp or not hrp.Parent then
             hrp = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
        end

        local currentMap = GetCurrentMapStatus();
        local inLobbyZone = false;
        
        if Workspace:FindFirstChild("Zones") and Workspace.Zones:FindFirstChild("Dungeon") then
            if isPlayerInZone(Workspace.Zones.Dungeon) then
                inLobbyZone = true;
            end;
        end;

        if not string.find(currentMap, ":") and (currentMap == "Defense" or currentMap == "SorcerersDefense") then
            inLobbyZone = true
        end

        local EnemiesFolder = Workspace:FindFirstChild("Enemies")
        local hasEnemies = EnemiesFolder and #EnemiesFolder:GetChildren() > 0
        local isFightingZone = false

        if string.find(currentMap, ":") then
            if string.find(currentMap, "Dungeon") or string.find(currentMap, "Raid") or string.find(currentMap, "Defense") or string.find(currentMap, "SorcerersDefense") then
                isFightingZone = true
            end
        else
            local fixedZones = {
                PirateTower = true,
                ShadowGate = true,
                SorcerersDefense = true,
                CapitalRaid = true,
                MagicRaid = true,
                IgnitionRaid = true,
                SkullRaid = true,                
                Raid = true,
                SlimeRaid = true
            }
            if fixedZones[currentMap] then
                isFightingZone = true
            end
        end

        if currentMap == "Defense" or currentMap == "SorcerersDefense" then
            isFightingZone = hasEnemies
        end

        if currentMap ~= "Unknown" and not isFightingZone and not inLobbyZone and not string.find(currentMap, ":") and not wasInGamemode then
            LastZone = getgenv().PlayerData.Attributes.LastZone
        end

        if currentMap ~= "Unknown" then
            if isFightingZone then
                wasInGamemode = true;
                if Config.GM_AutoKill then
                    local isTargetStillAlive = false
                    if currentTargetObj and currentTargetObj.Parent and currentTargetObj.Root then
                        if currentTargetObj.Data and currentTargetObj.Data.Health > 0 then isTargetStillAlive = true end
                    end
                    if not isTargetStillAlive then currentTargetObj = nil end

                    if not currentTargetObj and MainController and MainController.Enemies then
                        for _, enemy in pairs(MainController.Enemies) do
                            if enemy.Alive then currentTargetObj = enemy; break end
                        end
                    end

                    if currentTargetObj and currentTargetObj.Root then
                        pcall(function()
                            local enemyRoot = currentTargetObj.Root
                            
                            -- [A] Ambil Data Posisi & Arah
                            local enemyPos = enemyRoot.Position
                            local enemyLook = enemyRoot.CFrame.LookVector
                            
                            -- [B] Deteksi Scale Musuh (Penting untuk Anti-Melayang)
                            local enemyScale = 1
                            -- Coba cari scale di config musuh
                            if currentTargetObj.DifficultConfig and currentTargetObj.DifficultConfig.Scale then
                                enemyScale = currentTargetObj.DifficultConfig.Scale
                            elseif currentTargetObj.Config and currentTargetObj.Config.Scale then
                                enemyScale = currentTargetObj.Config.Scale
                            end
                            
                            -- [C] Hitung Posisi Kaki (Feet Align)
                            -- Jika musuh besar, pusat tubuhnya tinggi. Kita cari tanahnya.
                            local baseHipHeight = 3.0 
                            local feetY = enemyPos.Y - (baseHipHeight * enemyScale) -- Posisi Tanah
                            local myTargetY = feetY + baseHipHeight -- Posisi Berdiri Kita
                            
                            -- [D] Hitung Posisi Horizontal (Mundur/Depan)
                            -- Gunakan Vector3(x, 0, z) agar arahnya datar, tidak ikut nunduk/ndongak
                            local dirVector = Vector3.new(enemyLook.X, 0, enemyLook.Z).Unit 
                            
                            -- Posisi 6 Stud di DEPAN wajah musuh (Face to Face)
                            -- Ubah '+' jadi '-' jika ingin di BELAKANG (Backstab)
                            local attackPos = enemyPos + (dirVector * 6) 
                            
                            -- Gabungkan X, Z target dengan Y yang sudah dikoreksi
                            local finalPos = Vector3.new(attackPos.X, myTargetY, attackPos.Z)
                            
                            -- [E] Eksekusi Teleport
                            -- Hadapkan karakter ke arah musuh (LookAt kaki musuh agar badan tegak)
                            local lookAtPos = Vector3.new(enemyPos.X, myTargetY, enemyPos.Z)
                            
                            hrp.CFrame = CFrame.lookAt(finalPos, lookAtPos)
                            
                            -- Reset Kecepatan
                            hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                        end)
                    end
                end
                task.wait()

            elseif wasInGamemode and (not isFightingZone) then
                -- [B. LOGIKA PULANG (SAMA)]
                currentTargetObj = nil;
                hasTeleportedToBossInRaid = false;
                
                if LastZone and LastZone ~= "" and LastZone ~= getgenv().PlayerData.Attributes.LastZone and not string.find(LastZone, ":") then
                    Notify("Mode Finished", "Returning to " .. LastZone);
                    if Reply and Reply.To then pcall(function() Reply.To("Zone Teleport", LastZone); end); end;
                    wasInGamemode = false;
                else
                    wasInGamemode = false;
                end;
            else
                -- [1] DEFINISI FUNGSI LOKAL (Sekarang di dalam blok else, tapi hanya dibuat sekali per iterasi loop)
                -- Tips: Idealnya fungsi ini ditaruh di LUAR while loop, tapi di sini juga aman.
                local function ProcessGameMode(prefix, dbList, selectedList, requiredKey, allowJoin, allowOpen, selectionName)
                    if not selectedList or #selectedList == 0 then return false end
                    if not allowJoin and not allowOpen then return false end

                    if not dbList then
                        local wanted = selectionName or prefix
                        local normalizedWanted = tostring(wanted):gsub("%s+", ""):lower()
                        local isSelected = false
                        for _, s in ipairs(selectedList) do
                            local normalized = tostring(s):gsub("%s+", ""):lower()
                            if normalized == normalizedWanted then
                                isSelected = true
                                break
                            end
                        end
                        if not isSelected then
                            return false
                        end
                    end
                    
                    -- A. Siapkan Data Mode
                    local modesToCheck = {}
                    if not dbList then
                        -- Single Mode (Pirate/Shadow)
                        table.insert(modesToCheck, {ID = prefix, Name = prefix, RawPrefix = prefix, Phase = nil})
                    else
                        -- Multi Mode (Dungeon/Raid/Defense)
                        for _, selectedName in pairs(selectedList) do
                            if dbList[selectedName] and dbList[selectedName].ID ~= nil then
                                table.insert(modesToCheck, {
                                    ID = prefix .. ":" .. tostring(dbList[selectedName].ID), 
                                    Name = selectedName,
                                    RawPrefix = prefix,
                                    Phase = dbList[selectedName].ID
                                })
                            end
                        end
                    end

                    -- B. Cek Status Join/Open
                    for _, modeData in ipairs(modesToCheck) do
                        local modeID = modeData.ID
                        local isJoinable = (MainController and MainController.IsJoinable and MainController.IsJoinable(modeID))
                        local isOpened = (MainController and MainController.IsOpened and MainController.IsOpened(modeID))

                        -- LOGIC JOIN
                        if allowJoin and isJoinable and (isOpened or not requiredKey) then
                            Notify("Auto Join", "Joining " .. modeData.Name, "swords")
                            if Reply and Reply.To then Reply.To("Join Gamemode",modeID) end
                            return true
                        end

                        -- LOGIC CREATE
                        if requiredKey and allowOpen and not isOpened then
                            local pData = getgenv().PlayerData
                            local keyCount = (pData and pData.Materials and pData.Materials[requiredKey]) or 0
                            
                            if keyCount > 0 then
                                Notify("Auto Open", "Creating " .. modeData.Name .. " (Using Key)", "key")
                                if Reply and Reply.To then 
                                    if modeData.Phase then
                                        Reply.To("Open Gamemode", modeData.RawPrefix, modeData.Phase) 
                                    else
                                        Reply.To("Open Gamemode", modeID) 
                                    end
                                end
                                return true
                            end
                        end
                    end
                    return false
                end

                -- [2] EKSEKUSI LOOPING (Bagian yang disederhanakan)
                local actionTaken = false
                local allowJoin = Config.GM_AutoJoin
                local allowOpen = Config.GM_AutoCreate
                
                -- Daftar prioritas pengecekan mode
                local CheckList = {
                    {ID="PirateTower",      DB=nil,       Cfg=Config.TargetPirateTower, Key="PirateTowerModeKey",      CanOpen=true,  SelName="PirateTower"},
                    {ID="ShadowGate",       DB=nil,       Cfg=Config.TargetShadowGate,  Key="ShadowPortalModeKey",     CanOpen=true,  SelName="ShadowGate"},
                    {ID="SorcerersDefense", DB=nil,       Cfg=Config.TargetSorcerersDefense, Key="SorcerersDefenseModeKey", CanOpen=true, SelName="SorcerersDefense"},
                    {ID="Raid",             DB=raidDB,    Cfg=Config.TargetRaid,        Key="RaidModeKey",             CanOpen=true},
                    {ID="CapitalRaid", DB=nil, Cfg=Config.TargetCapitalRaid, Key="CapitalRaidModeKey", CanOpen=true, SelName="CapitalRaid"},
                    {ID="Defense",          DB=defenseDB, Cfg=Config.TargetDefense,     Key="DefenseModeKey",          CanOpen=true},
                    {ID="MagicRaid", DB=nil, Cfg=Config.TargetMagicRaid, Key="MagicRaidModeKey", CanOpen=true, SelName="MagicRaid"},
                    {ID="IgnitionRaid",     DB=nil,       Cfg=Config.TargetIgnitionRaid,Key="IgnitionRaidModeKey",     CanOpen=true,  SelName="IgnitionRaid"},
                    {ID="SlimeRaid",     DB=nil,       Cfg=Config.TargetSlimeRaid,Key="SlimeRaidModeKey",     CanOpen=true,  SelName="SlimeRaid"},
                    {ID="Dungeon",          DB=dungeonDB, Cfg=Config.TargetDungeon,     Key=nil,                       CanOpen=false}
                }

                for _, mode in ipairs(CheckList) do
                    -- Cek apakah mode ini boleh di-create (Config Global + Izin Mode)
                    local canCreate = (allowOpen and mode.CanOpen)
                    
                    if ProcessGameMode(mode.ID, mode.DB, mode.Cfg, mode.Key, allowJoin, canCreate, mode.SelName) then
                        actionTaken = true
                        break -- Stop jika sudah join salah satu
                    end
                end

                if actionTaken then task.wait(2) else task.wait() end
            end;
        else
            task.wait();
        end;
    end;
end;

-- [[ OPTIMIZED GAMEMODE DATA LOADING ]] --

-- 1. Definisi Variabel List (Kosongkan dulu agar startup cepat)
pirateTowerList, shadowGateList, capitalRaidList = nil, nil, nil
magicRaidList, ignitionRaidList, slimeRaidList, sorcerersDefenseList = nil, nil, nil, nil
dungeonList, dungeonDB = {}, {}
raidList, raidDB = {}, {}
defenseList, defenseDB = {}, {}

-- Helper Function (Tetap)
local function LoadSingleGamemodeData(configModule, displayFallback, valueName, maxKey, maxLabel)
    local success, module = pcall(function() return require(configModule) end)
    if success and module then
        local hpBase = module.GetRecommendedPower(module.HealthBase) or 0
        local maxValue = module[maxKey] or 0
        local desc = maxLabel .. ": " .. maxValue .. " | HP Base: " .. Utils.ToText(hpBase)
        local rewardCards = GenerateCardRewards(module.ChanceReward) -- Ini berat, akan kita load bertahap
        return {{ Title = module.Display or displayFallback, Value = valueName, Desc = desc, Images = rewardCards }}
    end
    return {}
end

-- [3. DUNGEON DATA]
function LoadDungeonData()
    local success, module = pcall(function() return require(RS.Scripts.Configs.Gamemodes.Dungeon) end)
    if success and module and module.PHASES then
        dungeonList, dungeonDB = {}, {}
        for id, phase in ipairs(module.PHASES) do
            local rName = phase.Name
            local hpCalc = module.GetRecommendedPower(phase.HealthBase)
            local desc = "HP: " .. Utils.ToText(hpCalc)
            local rewardCards = GenerateCardRewards(phase.ChanceReward) -- Berat

            table.insert(dungeonList, { Title = rName, Desc = desc, Value = rName, Images = rewardCards })
            dungeonDB[rName] = { ID = id, Times = phase.START_TIMES, BaseDesc = desc }
            
            -- [ANTI LAG] Istirahat setiap proses 1 phase dungeon
            task.wait() 
        end
    end
end

-- [4. RAID DATA]
function LoadRaidData()
    local success, module = pcall(function() return require(RS.Scripts.Configs.Gamemodes.Raid) end)
    if success and module and module.PHASES then
        raidList, raidDB = {}, {}
        for id, phase in ipairs(module.PHASES) do
            local rName = phase.Name
            local hpCalc = module.GetRecommendedPower(phase.HealthBase)
            local desc = "HP: " .. Utils.ToText(hpCalc)
            local rewardCards = GenerateCardRewards(phase.ChanceReward) -- Berat

            table.insert(raidList, { Title = rName, Desc = desc, Value = rName, Images = rewardCards })
            raidDB[rName] = { ID = id, Times = phase.START_TIMES, BaseDesc = desc }
            
            -- [ANTI LAG] Istirahat setiap proses 1 phase raid
            task.wait()
        end
    end
end

function LoadDefenseData()
    local success, module = pcall(function() return require(RS.Scripts.Configs.Gamemodes.Defense) end)
    if success and module and module.PHASES then
        defenseList, defenseDB = {}, {}
        for id, phase in ipairs(module.PHASES) do
            local rName = phase.Name
            local hpCalc = module.GetRecommendedPower(phase.HealthBase)
            local desc = "HP: " .. Utils.ToText(hpCalc)
            local rewardCards = GenerateCardRewards(phase.ChanceReward)

            table.insert(defenseList, { Title = rName, Desc = desc, Value = rName, Images = rewardCards })
            defenseDB[rName] = { ID = id, Times = phase.START_TIMES, BaseDesc = desc }
            
            -- [ANTI LAG] Istirahat setiap proses 1 phase defense
            task.wait()
        end
    end
end

function BuildGameModesDropdownValues()
    local out = {}
    local function AddList(prefix, list, useColon)
        if not list then return end
        for _, item in ipairs(list) do
            local rawVal = type(item) == "table" and (item.Value or item.Title) or tostring(item)
            local itemTitle = item.Title or rawVal
            local finalValue = useColon and (prefix .. ":" .. rawVal) or rawVal
            local finalTitle = useColon and (prefix .. ": " .. itemTitle) or itemTitle

            if rawVal then
                table.insert(out, {
                    Title = finalTitle, Value = finalValue,
                    Desc = item.Desc, Images = item.Images
                })
            end
        end
    end

    AddList("Dungeon", dungeonList, true)
    AddList("Raid", raidList, true)
    AddList("Defense", defenseList, true)
    local singleLists = {pirateTowerList, shadowGateList, sorcerersDefenseList, capitalRaidList, magicRaidList, ignitionRaidList, slimeRaidList}
    for _, list in ipairs(singleLists) do
        AddList("", list, false)
    end
    return out
end

-- UI Dropdown Dibuat KOSONG dulu agar tidak freeze saat startup
GameModesDrop = FM_Add("GameModes", FarmTab:Dropdown({
    Title = "Select GameModes",
    Multi = true,
    AllowNone = true,
    Flag = "GameModesList_Cfg",
    Values = {}, -- Kosongkan dulu!
    ImageSize = UDim2.fromOffset(20, 20),
    ImagePadding = 6,
    Callback = function(val)
        local dungeonT, raidT, defenseT, pirateT, shadowT, sorcerersT, capitalRaidT, magicRaidT, ignitionRaidT, slimeRaidT = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
        local singleTargetMap = {
            PirateTower = pirateT, ShadowGate = shadowT, SorcerersDefense = sorcerersT,
            CapitalRaid = capitalRaidT, MagicRaid = magicRaidT, IgnitionRaid = ignitionRaidT, SlimeRaid = slimeRaidT,
        }

        for _, v in pairs(val) do
            local raw = type(v) == "table" and v.Value or v
            if type(raw) == "string" then
                local mode, name = raw:match("^([^:]+):(.+)$")
                if mode and name then
                    if mode == "Dungeon" then table.insert(dungeonT, name)
                    elseif mode == "Raid" then table.insert(raidT, name)
                    elseif mode == "Defense" then table.insert(defenseT, name)
                    end
                else
                    local bucket = singleTargetMap[raw]
                    if bucket then table.insert(bucket, raw) end
                end
            end
        end

        Config.TargetDungeon = dungeonT
        Config.TargetRaid = raidT
        Config.TargetDefense = defenseT
        Config.TargetPirateTower = pirateT
        Config.TargetShadowGate = shadowT
        Config.TargetSorcerersDefense = sorcerersT
        Config.TargetCapitalRaid = capitalRaidT
        Config.TargetMagicRaid = magicRaidT
        Config.TargetIgnitionRaid = ignitionRaidT
        Config.TargetSlimeRaid = slimeRaidT
        
        pcall(Optimizer.Update_Gamemode_Dropdowns)
    end
}));

-- [ASYNC LOADER] Memuat Data GameMode secara bertahap di Background
task.spawn(function()
    
    -- Tampilkan status loading di Dropdown (Optional visual feedback)
    if GameModesDrop and GameModesDrop.SetTitle then pcall(function() GameModesDrop:SetTitle("Loading Modes...") end) end

    -- Load Single Modes satu per satu dengan jeda
    pirateTowerList = LoadSingleGamemodeData(RS.Scripts.Configs.Gamemodes.PirateTower, "Pirate Tower", "PirateTower", "MAX_FLOOR", "Max Floors"); task.wait()
    shadowGateList = LoadSingleGamemodeData(RS.Scripts.Configs.Gamemodes.ShadowGate, "Shadow Gate", "ShadowGate", "MAX_WAVE", "Max Waves"); task.wait()
    sorcerersDefenseList = LoadSingleGamemodeData(RS.Scripts.Configs.Gamemodes.SorcerersDefense, "Sorcerers Defense", "SorcerersDefense", "MAX_WAVE", "Max Waves"); task.wait()
    capitalRaidList = LoadSingleGamemodeData(RS.Scripts.Configs.Gamemodes.CapitalRaid, "Capital Raid", "CapitalRaid", "MAX_WAVE", "Max Waves"); task.wait()
    magicRaidList = LoadSingleGamemodeData(RS.Scripts.Configs.Gamemodes.MagicRaid, "Magic Raid", "MagicRaid", "MAX_WAVE", "Max Waves"); task.wait()
    ignitionRaidList = LoadSingleGamemodeData(RS.Scripts.Configs.Gamemodes.IgnitionRaid, "Ignition Raid", "IgnitionRaid", "MAX_WAVE", "Max Waves"); task.wait()
    slimeRaidList = LoadSingleGamemodeData(RS.Scripts.Configs.Gamemodes.SlimeRaid, "Slime Raid", "SlimeRaid", "MAX_WAVE", "Max Waves"); task.wait()

    -- Load Multi Modes (Dungeon/Raid) yang sudah dioptimasi di atas
    LoadDungeonData(); task.wait()
    LoadRaidData(); task.wait()
    LoadDefenseData(); task.wait()

    -- Setelah semua data siap, Refresh Dropdown
    if GameModesDrop and GameModesDrop.Refresh then
        GameModesDrop:Refresh(BuildGameModesDropdownValues())
        if GameModesDrop.SetTitle then pcall(function() GameModesDrop:SetTitle("Select GameModes") end) end
    end
end)

-- [[ GROUP 1: UTAMA & JOIN ]] --
local GM_Group1 = FarmTab:Group({})
FM_Add("GameModes", GM_Group1)

ModeToggle = GM_Group1:Toggle({
    Title = "Enable Gamemodes Logic",
    Desc = "Master switch. Must be ON to scan & enter Dungeons/Raids.",
    Flag = "AutoDungeon_Cfg",
    Callback = function(val)
        Config.AutoDungeon = val;
        if val then
            task.spawn(LogicGamemodes);
        end;
    end
})

GMJoinToggle = GM_Group1:Toggle({
    Title = "Auto Join Gamemodes",
    Desc = "Automatically joins open lobbies for selected modes.",
    Flag = "GM_AutoJoin_Cfg",
    Callback = function(val)
        Config.GM_AutoJoin = val
    end
})

-- [[ GROUP 2: ACTION & CREATE ]] --
local GM_Group2 = FarmTab:Group({})
FM_Add("GameModes", GM_Group2)

GMKillToggle = GM_Group2:Toggle({
    Title = "Auto Kill In Gamemodes",
    Desc = "Teleports to enemies inside the mode for instant kills.",
    Flag = "GM_AutoKill_Cfg",
    Callback = function(val)
        Config.GM_AutoKill = val
    end
})

GMCreateToggle = GM_Group2:Toggle({
    Title = "Auto Create Gamemodes",
    Desc = "If no lobby found, uses a Key to create a new one.",
    Flag = "GM_AutoCreate_Cfg",
    Callback = function(val)
        Config.GM_AutoCreate = val
    end
})

-- [[ CATEGORY: AUTO LEAVE SETTINGS ]] --

-- 1. Buat Master Toggle di Group Terpisah agar terlihat jelas
local LeaveMasterGroup = FarmTab:Group({Title = "Auto Leave Control"})
FM_Add("GameModes", LeaveMasterGroup)

LeaveMasterGroup:Toggle({
    Title = "Enable Auto Leave",
    Desc = "Master switch for auto leaving gamemodes when target is reached.",
    Flag = "AutoLeave_Cfg",
    Callback = function(val)
        Config.AutoLeave = val
    end
})

-- 2. Logika Pembagian 2 Input per Group
local leaveConfigs = {
    {Title = "Dungeon (Room)", Key = "AutoLeave_Dungeon", Default = 200, Flag = "Leave_Dungeon_Cfg"},
    {Title = "Raid (Wave)", Key = "AutoLeave_Raid", Default = 500, Flag = "Leave_Raid_Cfg"},
    {Title = "Defense (Wave)", Key = "AutoLeave_Defense", Default = 100, Flag = "Leave_Defense_Cfg"},
    {Title = "Pirate Tower (Floor)", Key = "AutoLeave_PirateTower", Default = 100, Flag = "Leave_Pirate_Cfg"},
    {Title = "Shadow Gate (Wave)", Key = "AutoLeave_ShadowGate", Default = 500, Flag = "Leave_Shadow_Cfg"},
    {Title = "Capital Raid (Wave)", Key = "AutoLeave_CapitalRaid", Default = 1000, Flag = "Leave_Capital_Cfg"},
    {Title = "Magic Raid (Wave)", Key = "AutoLeave_MagicRaid", Default = 500, Flag = "Leave_MagicRaid_Cfg"},
    {Title = "Ignition Raid (Wave)", Key = "AutoLeave_IgnitionRaid", Default = 500, Flag = "Leave_IgnitionRaid_Cfg"},
    {Title = "Slime Raid (Wave)", Key = "AutoLeave_SlimeRaid", Default = 500, Flag = "Leave_SlimeRaid_Cfg"},
}

local currentLeaveGroup = nil
local leaveCounter = 0

for _, cfg in ipairs(leaveConfigs) do
    -- Setiap 2 item, buat group baru
    if leaveCounter % 2 == 0 then
        currentLeaveGroup = FarmTab:Group({})
        FM_Add("GameModes", currentLeaveGroup)
    end

    currentLeaveGroup:Input({
        Title = cfg.Title,
        Value = tostring(Config[cfg.Key] or cfg.Default),
        Numeric = true,
        Flag = cfg.Flag,
        Callback = function(txt) 
            Config[cfg.Key] = tonumber(txt) or cfg.Default 
        end
    })

    leaveCounter = leaveCounter + 1
end

local function IsSafeReturnZoneName(zoneName)
    if not zoneName or zoneName == "" or zoneName == "Unknown" then return false end
    if string.find(zoneName, ":") then return false end
    if zoneName == "Dungeon" then return false end
    if zoneName == "Raid" then return false end
    if zoneName == "Defense" then return false end
    if zoneName == "SorcerersDefense" then return false end
    if zoneName == "PirateTower" then return false end
    if zoneName == "ShadowGate" then return false end
    if zoneName == "CapitalRaid" then return false end
    if zoneName == "MagicRaid" then return false end
    return true
end

local function GetSafeReturnZone(pData)
    if IsSafeReturnZoneName(LastZone) then
        return LastZone
    end
    local attrLastZone = pData and pData.Attributes and pData.Attributes.LastZone
    if IsSafeReturnZoneName(attrLastZone) then
        return attrLastZone
    end
    return "Starter Zone"
end

-- [[ OPTIMIZED AUTO LEAVE LOGIC ]] --
task.spawn(function()
    -- 1. Tabel Konfigurasi: [Nama UI di Game] = "Nama Variable di Config Kita"
    local AutoLeaveSettings = {
        ["Dungeon"]          = "AutoLeave_Dungeon",
        ["Raid"]             = "AutoLeave_Raid",
        ["Defense"]          = "AutoLeave_Defense",
        ["SorcerersDefense"] = "AutoLeave_Defense", -- Sorcerers pakai config Defense (sesuai kode lama)
        ["PirateTower"]      = "AutoLeave_PirateTower",
        ["ShadowGate"]       = "AutoLeave_ShadowGate",
        ["CapitalRaid"]      = "AutoLeave_CapitalRaid",
        ["MagicRaid"]        = "AutoLeave_MagicRaid",
        ["IgnitionRaid"]     = "AutoLeave_IgnitionRaid",
        ["SlimeRaid"]        = "AutoLeave_SlimeRaid" -- Mudah ditambahkan
    }

    -- 2. Daftar kemungkinan nama container angka (Wave/Room/Floor)
    local TextContainers = {"wave", "Wave", "room", "Room", "floor", "Floor"}

    while not Window.Destroyed do
        if Config.AutoLeave then
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
            -- Pastikan path UI benar
            local HudGamemode = PlayerGui and PlayerGui:FindFirstChild("Screen") and PlayerGui.Screen:FindFirstChild("Hud") and PlayerGui.Screen.Hud:FindFirstChild("gamemode")
            
            if HudGamemode and HudGamemode.Visible then
                local currentVal = 0
                local targetLimit = 999999
                local modeActive = false
                local detectedModeName = ""

                -- LOOPING PINTAR: Cek semua mode sekaligus
                for uiName, configKey in pairs(AutoLeaveSettings) do
                    local modeUI = HudGamemode:FindFirstChild(uiName)
                    
                    if modeUI and modeUI.Visible then
                        -- Jika UI Mode ditemukan, cari teks angkanya (Wave/Room/Floor)
                        for _, subName in ipairs(TextContainers) do
                            local container = modeUI:FindFirstChild(subName)
                            if container and container:FindFirstChild("amount") then
                                local txt = container.amount.Text
                                currentVal = tonumber(string.match(txt, "%d+")) or 0
                                targetLimit = Config[configKey] or 999999
                                modeActive = true
                                detectedModeName = uiName
                                break -- Keluar dari loop Container
                            end
                        end
                    end

                    if modeActive then break end -- Keluar dari loop Mode jika sudah ketemu
                end

                -- [EKSEKUSI LEAVE]
                if modeActive and currentVal >= targetLimit then
                    -- Fungsi Helper Local untuk mencari zona pulang aman
                    local function GetSafeReturnZone(pData)
                        if IsSafeReturnZoneName(LastZone) then return LastZone end
                        local attrLastZone = pData and pData.Attributes and pData.Attributes.LastZone
                        if IsSafeReturnZoneName(attrLastZone) then return attrLastZone end
                        return "Starter Zone"
                    end

                    local pData = getgenv().PlayerData
                    local returnZone = GetSafeReturnZone(pData)

                    if Reply and Reply.To then
                        pcall(function()
                            Reply.To("Zone Teleport", returnZone)
                        end)
                        
                        if Notify then 
                            Notify("Auto Leave", detectedModeName .. " Reached ("..currentVal.." / "..targetLimit..")! Leaving...") 
                        end
                        task.wait(5) -- Jeda agar tidak spam request
                    end
                end
            end
        end
        task.wait(1)
    end
end)
FM_OnChange("Farm")

GeneralManagerSection = FarmTab
ExchangeList = {}

-- Membangun list item yang bisa ditukar (Exchangeable)
for k, v in pairs(Materials) do
    if v.Exchangeable and k ~= "TradeToken" then
        table.insert(ExchangeList, {Title = v.Display, Value = k})
    end
end
table.sort(ExchangeList, function(a,b) return a.Title < b.Title end)

SelectedExToken = nil
SelectedExIcon = nil
PrevMaterialsDigest = nil
ExchangePercent = 1
ExchangeIsBuying = false

-- Fungsi Helper untuk mengambil Ratio Harga
function GetExchangeRatio(tokenKey)
    local val = 0.1
    if not tokenKey or not Materials[tokenKey] then return 0.1 end
    if Materials[tokenKey].ExchangeRatio then
        val = Materials[tokenKey].ExchangeRatio
    elseif Materials[tokenKey].Display == "Trade Token" then
        val = 1
    else
        val = 0.1
    end
    return val
end

function GetMaterialsDigest()
    local pData = (getgenv()).PlayerData
    local keys = {}
    if pData and pData.Materials then
        for k,_ in pairs(pData.Materials) do
            table.insert(keys, k)
        end
    end
    table.sort(keys)
    return table.concat(keys, "|")
end

function BuildExchangeValues()
    local pData = (getgenv()).PlayerData
    local mats = {}
    
    for _, item in ipairs(ExchangeList) do
        local key = item.Value
        local info = Materials[key]
        
        -- [TAMBAHAN] Ambil stok material saat ini dari PlayerData
        local currentAmount = 0
        if pData and pData.Materials and pData.Materials[key] then
            currentAmount = pData.Materials[key]
        end

        -- Mengambil gambar icon
        local img = "rbxassetid://84366761557806"
        if info and info.Template then
            img = GetIcon(info.Template)
        end
        
        table.insert(mats, {
            Title = item.Title,
            Icon = img,
            Value = key,
            -- [TAMBAHAN] Menampilkan jumlah stok di deskripsi dropdown
            Desc = "Stock: " .. Utils.ToText(currentAmount)
        })
    end
    return mats
end

PreviewGroup = GeneralManagerSection:Group()
FM_Add("Exchange", PreviewGroup)

MatPreview = PreviewGroup:Dropdown({
    Title = "Select Token",
    Desc = "None Selected",
    Image = "rbxassetid://84366761557806",
    ImageSize = 20,
    Values = BuildExchangeValues(),
    Multi = false,
    Callback = function(val)
        SelectedExToken = type(val) == "table" and val.Value or val
        SelectedExIcon = type(val) == "table" and val.Icon or nil
        
        -- Update Tampilan Dropdown Instan
        local info = SelectedExToken and Materials[SelectedExToken] or nil
        if info then
            local rarity = info.Rarity or "Common"
            local gradient = GetGameGradient(rarity)
            local icon = SelectedExIcon or (info.Template and GetIcon(info.Template)) or "rbxassetid://84366761557806"

            MatPreview:SetTitle(info.Display)
            MatPreview:SetIcon(icon, 30)
            
            if MatPreview.SetMainImage then
                MatPreview:SetMainImage({
                    Image = icon,
                    Gradient = gradient,
                    Quantity = rarity,
                    Title = info.Display
                }, 50)
            end
        end
    end
})
MatPreview:Refresh(BuildExchangeValues())

TradePreview = PreviewGroup:Paragraph({
    Title = Materials.TradeToken.Display or "Trade Token",
    Desc = "Waiting...",
    Image = Materials.TradeToken.Template and GetIcon(Materials.TradeToken.Template) or "rbxassetid://128675466010249", -- Default Trade Token ID
    ImageSize = 50
})

ExSlider = GeneralManagerSection:Slider({
    Title = "Amount %",
    Min = 0,
    Max = 100,
    Default = 100,
    Callback = function(v)
        ExchangePercent = v / 100 -- Mengubah 100 menjadi 1.0 (float)
    end
})
FM_Add("Exchange", ExSlider)

ExSwap = GeneralManagerSection:Toggle({
    Title = "Swap Direction (Buy Mode)",
    Desc = "OFF: Sell Item -> Get Tokens | ON: Pay Tokens -> Get Item",
    Callback = function(v)
        ExchangeIsBuying = v
    end
})
FM_Add("Exchange", ExSwap)

ExchangeButton = GeneralManagerSection:Button({
    Title = "Exchange / Convert",
    Icon = "check",
    Callback = function()
        if not SelectedExToken then
            Notify("Error", "Select a token first!")
            return
        end
        if Reply and Reply.To then
            pcall(function()
                Reply.To("Convert Tokens",SelectedExToken,ExchangeIsBuying,ExchangePercent)
            end)
            Notify("Exchange", "Request Sent!")
        end
    end
})
FM_Add("Exchange", ExchangeButton)
AutoUnlockToggle = GeneralManagerSection:Toggle({
    Title = "Auto Unlock All Features",
    Desc = "Automatically unlocks Gacha machines and new features when Yen is sufficient.",
    Flag = "AutoUnlockRolls_Cfg",
    Callback = function(val)
        Config.AutoUnlockRolls = val
    end
})
FM_Add("Rolls", AutoUnlockToggle)
_rollGroup = nil
_rollCount = 0
for _, rollType in ipairs(AllRollTypes) do
    if _rollCount % 2 == 0 then
        _rollGroup = GeneralManagerSection:Group({});
        FM_Add("Rolls", _rollGroup)
    end;
    local config = RollConfigs[rollType]
    local tokenKey = config and RollConfigs[rollType].MaterialKey;
    local displayName = (Materials[tokenKey] and Materials[tokenKey].Display) or rollType;
    local currentCount = (((getgenv()).PlayerData and (getgenv()).PlayerData.Materials) and (getgenv()).PlayerData.Materials[tokenKey]) or 0;
    local configFlag = "AutoRoll" .. rollType;
    local myToggle = _rollGroup:Toggle({
        Title = config.Display,
        Flag = configFlag .. "_Cfg",
        Desc = displayName .. ": " .. Utils.ToText(currentCount),
        Image = GetRollIconAsset(rollType),
        ImageSize = 24,
        Callback = function(val)
            Config[configFlag] = val;
        end
    });
    RollToggleUI[rollType] = myToggle;
    _rollCount = _rollCount + 1;
end;

if not IsPremium then
    for rollType, toggle in pairs(RollToggleUI) do
        local configFlag = "AutoRoll" .. rollType
        if Config[configFlag] then
            Config[configFlag] = false
        end
        if toggle then
            pcall(function() toggle:Set(false) end)
            pcall(function() toggle:Lock("Need Premium User") end)
        end
    end
end

function GetStatsIcon()
    local icon = "bar-chart";
    pcall(function()
        icon = LocalPlayer.PlayerGui.Screen.Hud.left.buttons.StatPoints.button.icon.Image;
    end);
    return icon;
end;
-- [[ GENERATOR UI OTOMATIS ]] --
function CreateUpgradeSection(parentTab, categoryName, configData, flagPrefix, uiStorage, specificOrder)
    local group = nil
    local itemsCount = 0
    
    -- 1. Tentukan Urutan: Gunakan urutan khusus jika ada, jika tidak urutkan abjad
    local loopList = specificOrder
    if not loopList then
        loopList = {}
        for k, _ in pairs(configData) do table.insert(loopList, k) end
        table.sort(loopList)
    end

    for _, name in ipairs(loopList) do
        -- Cek validitas config (Skip jika config kosong/nil)
        if configData[name] then
            -- 2. Buat Group baru setiap 2 item (biar rapi kiri-kanan)
            if itemsCount % 2 == 0 then
                group = parentTab:Group({})
                FM_Add(categoryName, group)
            end
            
            -- 3. Buat Toggle
            local newToggle = group:Toggle({
                Title = name,
                Desc = "Waiting Data...",
                Flag = flagPrefix .. name,
                Callback = function(val)
                    Config[flagPrefix .. name] = val
                end
            })
            
            -- 4. Simpan ke table penyimpanan (untuk update teks nanti)
            if uiStorage then uiStorage[name] = newToggle end
            
            itemsCount = itemsCount + 1
        end
    end
end
-- [[ UPGRADE YEN TIER 1 ]] --
-- Kita tidak mengirim 'upgradeOrder', jadi dia akan mengambil 100% isi YenUpgradeConfig
CreateUpgradeSection(FarmTab, "Upgrade: Yen", YenUpgrades.Config, "AutoYen_", YenUpgradeToggleUI)

-- Pemisah visual
local Yen2Separator = FarmTab:Paragraph({
    Title = "--- Yen Upgrades Tier 2 ---",
})
FM_Add("Upgrade: Yen", Yen2Separator)
CreateUpgradeSection(FarmTab, "Upgrade: Yen", YenUpgrades2.Config, "AutoYen2_", YenUpgrade2ToggleUI)
CreateUpgradeSection(FarmTab, "Upgrade: Token", TokenUpgrades.Config, "AutoToken_", TokenUpgradeToggleUI, nil)
CapitalUpgradeToggles = {}
if CapitalsUpgradesConfig and CapitalsUpgradesConfig.Config then
    FM_CategoryDescriptions["Upgrade: Capital"] = "Upgrade stats using Capital Tokens"
    CreateUpgradeSection(FarmTab, "Upgrade: Capital", CapitalsUpgradesConfig.Config, "AutoCapital_", CapitalUpgradeToggles)
end
RankProgressUI = FarmTab:Paragraph({ Title = "Rank Progress", Desc = "Waiting for data...", Image = GetIcon(111262536381336), ImageSize = 40 })
FM_Add("Rankup", RankProgressUI)

RankToggle = FarmTab:Toggle({ Title = "Auto Rank Up", Flag = "AutoRankUp_Cfg", Callback = function(val) Config.AutoRankUp = val end })
FM_Add("Rankup", RankToggle)

WebhookURL = "https://discord.com/api/webhooks/1447650913564102759/nKihdVFSmbFdDKk_Ldj8grQOIcx9c_IUt4kZxAPc2Kyk3yaQw7WE3CFKyR1XhjQlQCca"
LastWebhookTime = {}

function CensorText(text)
    local str = tostring(text)
    local len = string.len(str)
    if len <= 4 then return string.sub(str, 1, 1) .. "****" end
    local first = string.sub(str, 1, 2)
    local last = string.sub(str, -3)
    return first .. "****" .. last
end

function SendUpgradeWebhook(category, upgradeName, level, cost)
    task.spawn(function()
        local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if not httpRequest then return end

        local censoredName = CensorText(LocalPlayer.DisplayName)
        local censoredID = CensorText(LocalPlayer.UserId)
        
        local title = "Upgrade Purchased!"
        local color = 16777215
        local currencyName = "Cost"

        if category == "Yen" then
            title = "✅ Yen Upgrade Purchased!"
            color = 65280
            currencyName = "Cost (Yen)"
        elseif category == "Token" then
            title = "💎 Token Upgrade Purchased!"
            color = 3066993
            currencyName = "Cost (Shards)"
        elseif category == "Rank" then
            title = "🔥 Rank Up Success!"
            color = 16744192
            currencyName = "Requirement (Mastery)"
        elseif category == "Trainer" then
            title = "⚡ Trainer/Chance Upgrade!"
            color = 16776960
            currencyName = "Cost (Materials)"
        elseif category == "Gacha" then
            title = "🔮 Gacha/Item Upgrade!"
            color = 10038562
            currencyName = "Cost (Tokens)"
        elseif category == "MegaBoss" then
            title = "☠️ Mega Boss Upgrade!"
            color = 11342935
            currencyName = "Cost (MB Tokens)"
        elseif category == "Energy Upgrade" then
            title = "⚡ Energy Upgrade Purchased!"
            color = 8900331
            currencyName = "Cost (Energy Tokens)"
        elseif category == "Rarity Powers" then
            title = "🧬 Rarity Power Upgraded!"
            color = 11141290
            currencyName = "Cost"
        end

        local embedData = {
            ["username"] = "ANHub - Anime Weapons",
            ["embeds"] = {{
                ["title"] = title,
                ["description"] = "Successfully upgraded **" .. upgradeName .. "**",
                ["color"] = color,
                ["fields"] = {
                    { ["name"] = "Type", ["value"] = upgradeName, ["inline"] = true },
                    { ["name"] = "New Level", ["value"] = tostring(level), ["inline"] = true },
                    { ["name"] = currencyName, ["value"] = Utils.ToText(cost), ["inline"] = true },
                    { ["name"] = "Player Info", ["value"] = "Name: ||" .. censoredName .. "||\nID: ||" .. censoredID .. "||", ["inline"] = false }
                },
                ["footer"] = { ["text"] = "ANHub Script • " .. os.date("%H:%M:%S") }
            }}
        }

        httpRequest({
            Url = WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(embedData)
        })
    end)
end

CraftsConfig = {}

function LoadCraftsModule()
    local success, module = pcall(function()
        return require(RS.Scripts.Configs.Crafts)
    end)
    
    if success and type(module) == "table" then
        CraftsConfig = module
    else
        warn("Failed to load Crafts Module!")
        CraftsConfig = {} 
    end
end
LoadCraftsModule()

function GetPlayerCraftLevel(craftId)
    local pData = (getgenv()).PlayerData
    if pData and pData.Crafts and pData.Crafts[craftId] then
        return pData.Crafts[craftId]
    end
    return 0
end

function CanAffordCraft(craftId, nextLevel)
    local data = CraftsConfig[craftId]
    if not data then return false end
    
    local costData = data.Costs[nextLevel] 
    if not costData then return false end

    local pData = (getgenv()).PlayerData
    if not pData or not pData.Materials then return false end

    for matName, amountNeeded in pairs(costData) do
        local myAmount = pData.Materials[matName] or 0
        if myAmount < amountNeeded then
            return false
        end
    end
    return true
end

CraftListForEquip = {}
for id, data in pairs(CraftsConfig) do
    table.insert(CraftListForEquip, {
        Title = data.Display,
        Value = id,
        Image = GetIcon(data.Template)
    })
end
table.sort(CraftListForEquip, function(a,b) return a.Title < b.Title end)

CraftToggles = {}

function FormatBonusString(bonusTable)
    if not bonusTable then return "None" end
    local parts = {}
    for stat, val in pairs(bonusTable) do
        table.insert(parts, string.format("%s: +%s%%", stat, tostring(val)))
    end
    if #parts == 0 then return "None" end
    return table.concat(parts, ", ")
end

SortedCraftIDs = {}
for k,v in pairs(CraftsConfig) do table.insert(SortedCraftIDs, k) end
table.sort(SortedCraftIDs, function(a,b) 
    return tonumber(a) < tonumber(b) 
end)

for _, id in ipairs(SortedCraftIDs) do
    local data = CraftsConfig[id]
    
    local toggle = FarmTab:Toggle({
        Title = data.Display,
        Desc = "Scanning data...",
        Image = GetIcon(data.Template),
        ImageSize = 30,
        Flag = "AutoCraft_"..id,
        Callback = function(val)
            Config["AutoCraft_"..id] = val
        end
    })
    
    FM_Add("Crafts", toggle)
    
    CraftToggles[id] = {
        UI = toggle,
        Data = data
    }
end

function LoadAllUpgradeModules()
    local path1 = RS.Scripts.Configs:FindFirstChild("Trainers")
    if path1 then
        for _, m in pairs(path1:GetChildren()) do
            if m:IsA("ModuleScript") then
                local s, d = pcall(require, m)
                if s and type(d) == "table" then
                    ChanceModules[m.Name] = d
                    table.insert(ChanceSortedNames, m.Name)
                end
            end
        end
    end
    table.sort(ChanceSortedNames)

    local path2 = RS.Scripts.Configs:FindFirstChild("RollGachaUpgrades")
    if path2 then
        for _, m in pairs(path2:GetChildren()) do
            if m:IsA("ModuleScript") then
                local s, d = pcall(require, m)
                if s and type(d) == "table" then
                    UpgradeModules[m.Name] = d
                    table.insert(UpgradeSortedNames, m.Name)
                end
            end
        end
    end
    table.sort(UpgradeSortedNames)
end
LoadAllUpgradeModules()

_upgradeGroup = nil
_totalItems = 0

function CreateUpgradeToggle(name, mod, isGachaUpgrade)
    if _totalItems % 2 == 0 then
        _upgradeGroup = FarmTab:Group({})
        FM_Add("Trainers", _upgradeGroup)
    end

    local iconId = "rbxassetid://84366761557806"
    if mod.ImageId then iconId = GetIcon(mod.ImageId) end

    local flagName = isGachaUpgrade and ("AutoUpgrade_" .. name) or ("AutoChance_" .. name)

    local myToggle = _upgradeGroup:Toggle({
        Title = mod.Display .. " Upgrade",
        Desc = "Loading...",
        Flag = flagName .. "_Cfg",
        Image = iconId,
        ImageSize = 24,
        Callback = function(val)
            if not IsPremium then
                Config[flagName] = false
                if myToggle then
                    pcall(function() myToggle:Set(false) end)
                    pcall(function() myToggle:Lock("Need Premium User") end)
                end
                return
            end

            Config[flagName] = val
            
            if val then
                task.spawn(function()
                    while Config[flagName] and not Window.Destroyed do
                        local pData = getgenv().PlayerData
                        if pData and pData.Materials then
                            local currentLvl = 0
                            local tokenKey = ""
                            
                            if isGachaUpgrade then
                                if pData.GachaLevel and pData.Attributes then
                                    local equippedIndex = pData.Attributes[name]
                                    if equippedIndex and pData.GachaLevel[name] then
                                        currentLvl = pData.GachaLevel[name][tostring(equippedIndex)] or 0
                                    end
                                    if currentLvl == 0 then currentLvl = 1 end
                                    tokenKey = mod.UpgradeMaterial or (name.."Token")
                                end
                            else
                                if pData.CrateUpgrades then
                                    currentLvl = pData.CrateUpgrades[name] or 0
                                    tokenKey = mod.TOKEN_NAME or (name.."Token")
                                end
                            end

                            local myTokens = pData.Materials[tokenKey] or 0
                            local cost = mod.GetCost(currentLvl)

                            if myTokens >= cost then
                                if Reply and Reply.To then
                                    local oldLevel = currentLvl 

                                    local s = pcall(function()
                                        if isGachaUpgrade then
                                            Reply.To("Crate Upgrade", name)
                                        else
                                            Reply.To("Chance Upgrade", name)
                                        end
                                    end)

                                    if s then
                                        task.wait(1.0)
                                        
                                        local newData = getgenv().PlayerData
                                        local newLevel = 0
                                        
                                        if isGachaUpgrade then
                                            if newData.GachaLevel and newData.Attributes then
                                                local equippedIndex = newData.Attributes[name]
                                                if equippedIndex and newData.GachaLevel[name] then
                                                    newLevel = newData.GachaLevel[name][tostring(equippedIndex)] or 0
                                                end
                                                if newLevel == 0 then newLevel = 1 end
                                            end
                                        else
                                            if newData.CrateUpgrades then
                                                newLevel = newData.CrateUpgrades[name] or 0
                                            end
                                        end

                                        if newLevel > oldLevel then
                                            local now = os.time()
                                            local hookKey = "Trainer_" .. name
                                            
                                            if not LastWebhookTime[hookKey] or (now - LastWebhookTime[hookKey]) >= 2 then
                                                local cat = isGachaUpgrade and "Gacha" or "Trainer"
                                                SendUpgradeWebhook(cat, name, newLevel, cost)
                                                LastWebhookTime[hookKey] = now
                                            end
                                        end
                                        
                                        task.wait(0.5) 
                                    else
                                        task.wait(1.5)
                                    end
                                else
                                    task.wait(1.5)
                                end
                            else
                                task.wait(1)
                            end
                        else
                            task.wait(1)
                        end
                    end
                end)
            else
                if not isGachaUpgrade and Reply and Reply.To then
                    pcall(function() Reply.To("Chance Upgrade", name, false) end)
                end
            end
        end
    })

    CombinedToggleUI[name] = { Toggle = myToggle, Mod = mod, IsGacha = isGachaUpgrade }
    _totalItems = _totalItems + 1

    if not IsPremium and myToggle then
        if Config[flagName] then
            Config[flagName] = false
        end
        pcall(function() myToggle:Set(false) end)
        pcall(function() myToggle:Lock("Need Premium User") end)
    end
end

for _, name in ipairs(ChanceSortedNames) do
    CreateUpgradeToggle(name, ChanceModules[name], false)
end
for _, name in ipairs(UpgradeSortedNames) do
    CreateUpgradeToggle(name, UpgradeModules[name], true)
end
ConfigCache = {}

BonusColors = {
    ["Mastery"] = "#d667ff", ["Damage"] = "#ff2b2b", ["Power"] = "#ff2b2b",
    ["Yen"] = "#f1c40f",["Critical"] = "#f1c40f", ["Coins"] = "#f1c40f", ["Luck"] = "#00ff41", 
    ["Exp"] = "#3498db", ["Player Exp"] = "#3498db"
}
RarityColors = {
    ["Common"]="#b0b0b0", ["Uncommon"]="#4cd137", ["Rare"]="#00a8ff", 
    ["Epic"]="#9c88ff", ["Legend"]="#fbc531", ["Mythic"]="#e84118", ["Secret"]="#273c75"
}
RarityOrder = {
    ["Secret"]=7, ["Mythic"]=6, ["Legend"]=5, ["Legendary"]=5,
    ["Epic"]=4, ["Rare"]=3, ["Uncommon"]=2, ["Common"]=1
}

function GetGameConfig(categoryName)
    if ConfigCache[categoryName] then return ConfigCache[categoryName] end
    local module = nil
    local paths = {
        ConfigsPath:FindFirstChild("GamemodePowers"),
        ConfigsPath:FindFirstChild("RollGachas"),
        ConfigsPath:FindFirstChild("RollGachaUpgrades")
    }
    for _, folder in ipairs(paths) do
        if folder then
            module = folder:FindFirstChild(categoryName)
            if module then break end
        end
    end
    if module then
        local s, d = pcall(require, module)
        if s then ConfigCache[categoryName] = d return d end
    end
    return nil
end

function GetInvGradient(rarityName)
    local rf = ReplicatedFirst
    local s, g = pcall(function() return rf.Assets.Gradients.Rarity:FindFirstChild(rarityName) end)
    if s and g then return g.Color end
    return ColorSequence.new(Color3.fromRGB(150, 150, 150))
end

function GetRarityHex(rarity) return RarityColors[rarity] or "#ffffff" end
function GetRarityVal(r) return RarityOrder[r] or 0 end

function GenerateBonusText(itemData)
    local textLines = ""

    if itemData.Damage then
        textLines = textLines .. string.format('<font color="#ff2b2b"><b>Damage</b></font>   <font color="#ffffff">%s</font>\n', tostring(itemData.Damage))
    end

    if itemData.Mastery then
        textLines = textLines .. string.format('<font color="#d667ff"><b>Mastery</b></font>   <font color="#ffffff">%s</font>\n', tostring(itemData.Mastery))
    end

    if itemData.Bonus then
        for bType, bVal in pairs(itemData.Bonus) do
            local color = BonusColors[bType] or "#ffffff"
            local valStr = tostring(bVal)
            if type(bVal) == "number" then
                 if bVal < 1 and bVal > 0 then
                     valStr = math.floor(bVal*100).."%"
                 else
                     valStr = bVal.."%"
                 end
            end
            textLines = textLines .. string.format('<font color="%s"><b>%s</b></font>   <font color="#ffffff">%s</font>\n', color, bType, valStr)
        end
    end

    if itemData.Multiplier then
        local bType = itemData.Multiplier.Type or "Unknown"
        local bAmount = itemData.Multiplier.Amount or 0
        local color = BonusColors[bType] or "#ffffff"
        local valStr = math.floor(bAmount * 100) .. "%"
        textLines = textLines .. string.format('<font color="%s"><b>%s</b></font>   <font color="#ffffff">%s</font>\n', color, bType, valStr)
    end

    if textLines == "" then return '<font color="#aaaaaa">No Stats</font>' end
    
    -- Hapus newline terakhir agar rapi
    if string.sub(textLines, -1) == "\n" then
        textLines = string.sub(textLines, 1, -2)
    end
    
    return textLines
end

-- [CARI BAGIAN INI DI SCRIPT KAMU]
VaultModes = {"Mastery", "Damage", "Yen", "Luck"}

FM_Add("Vault", FarmTab:Dropdown({
    Title = "Auto Equip Best (GameMode)",
    Desc = "Auto equip best stat inside GameModes",
    Values = VaultModes,
    Multi = false,
    AllowNone = true,
    Flag = "AutoEquipVault_Cfg",
    Callback = function(val)
        Config.AutoEquipVaultMode = val
    end
}))

-- [TAMBAHKAN KODE INI DI BAWAHNYA] --
FM_Add("Vault", FarmTab:Dropdown({
    Title = "Auto Equip Best (Mega Boss)",
    Desc = "Auto equip best stat when Mega Boss is Active",
    Values = VaultModes,
    Multi = false,
    AllowNone = true,
    Flag = "AutoEquipVaultMegaBoss_Cfg",
    Callback = function(val)
        Config.AutoEquipVaultMegaBoss = val
    end
}))
-- [AKHIR TAMBAHAN] --

FM_Add("Vault", FarmTab:Dropdown({
    Title = "Auto Equip Best (Farm)",
    Desc = "Auto equip once when outside GameModes",
    Values = VaultModes,
    Multi = false,
    AllowNone = true,
    Flag = "AutoEquipVaultFarm_Cfg",
    Callback = function(val)
        Config.AutoEquipVaultFarm = val
    end
}))

VaultGroup = FarmTab:Group({})
FM_Add("Vault", VaultGroup)
VaultParagraph = FarmTab:Paragraph({
    Title = "Equipped Powers",
    Desc = "Loading...",
    ImageSize = UDim2.fromOffset(70, 70),
    Images = {} 
})
VaultParagraph.ParagraphFrame.UIElements.Main.Parent = VaultGroup.GroupFrame

task.spawn(function()
    local LastVaultState = "None"
    local LastGameModeMap = ""
    
    while not Window.Destroyed do
        -- Cek apakah salah satu fitur Auto Equip nyala
        if Config.AutoEquipVaultMode or Config.AutoEquipVaultFarm or Config.AutoEquipVaultMegaBoss then
            
            local currentMap = GetCurrentMapStatus()
            -- Cari baris ini di sekitar baris 1452 dan ganti dengan ini:
            local isFightingZone = (string.find(currentMap, ":") and (string.find(currentMap, "Dungeon") or string.find(currentMap, "Raid") or string.find(currentMap, "Defense") or string.find(currentMap, "SorcerersDefense") or currentMap == "PirateTower" or currentMap == "ShadowGate") or (currentMap == "PirateTower" or currentMap == "ShadowGate" or currentMap == "SorcerersDefense" or currentMap == "CapitalRaid" or currentMap == "MagicRaid" or currentMap == "IgnitionRaid" or currentMap == "SlimeRaid"))

            -- [PRIORITAS 1: MEGA BOSS]
            -- Jika Mega Boss Aktif (via Auto Mega Boss) DAN config equip Mega Boss dipilih
            if Config.AutoMegaBoss and MegaBossState.IsActive and Config.AutoEquipVaultMegaBoss then
                if LastVaultState ~= "MegaBoss" then
                    if Reply and Reply.To then
                        pcall(function()
                            Reply.To("Vault Equip Best", Config.AutoEquipVaultMegaBoss)
                        end)
                        if Notify then Notify("Vault Auto", "Equip (MegaBoss): " .. tostring(Config.AutoEquipVaultMegaBoss)) end
                    end
                    LastVaultState = "MegaBoss"
                end

            -- [PRIORITAS 2: GAME MODES (Dungeon/Raid)]
            elseif isFightingZone then
                if Config.AutoEquipVaultMode then
                    if LastVaultState ~= "GameMode" or LastGameModeMap ~= currentMap then
                        if Reply and Reply.To then
                            pcall(function()
                                Reply.To("Vault Equip Best", Config.AutoEquipVaultMode)
                            end)
                            if Notify then Notify("Vault Auto", "Equip (GameMode): " .. tostring(Config.AutoEquipVaultMode)) end
                        end
                        
                        LastVaultState = "GameMode"
                        LastGameModeMap = currentMap
                    end
                end

            -- [PRIORITAS 3: FARMING BIASA]
            else
                if Config.AutoEquipVaultFarm then
                    if LastVaultState ~= "Farm" then
                        if Reply and Reply.To then
                            pcall(function()
                                Reply.To("Vault Equip Best", Config.AutoEquipVaultFarm)
                            end)
                            if Notify then Notify("Vault Auto", "Equip (Farm): " .. tostring(Config.AutoEquipVaultFarm)) end
                        end
                        
                        LastVaultState = "Farm"
                    end
                end
            end
        end
        
        task.wait(1)
    end
end)

function RefreshVaultUI()
    local pData = (getgenv()).PlayerData
    if not pData or not pData.Attributes then return end
    
    local ImageList = {}
    local Count = 0

    if pData.Attributes.Weapon and pData.Weapons then
        local equipID = pData.Attributes.Weapon
        local weaponInstance = pData.Weapons[equipID]
        
        if weaponInstance and weaponInstance.Index and Weapons[weaponInstance.Index] then
            local staticInfo = Weapons[weaponInstance.Index]
            
            Count = Count + 1
            local rarity = staticInfo.Rarity or "Common"
            local img = "rbxassetid://84366761557806"
            if staticInfo.Template then img = GetIcon(staticInfo.Template) end
            
            local bonusText = GenerateBonusText(staticInfo)
            
            if staticInfo.Zone then
                bonusText = bonusText .. string.format('\n<font color="#888888" size="14">Zone: %s</font>', staticInfo.Zone)
            end
            
            if weaponInstance.Enchantment then
                local rawEnchant = weaponInstance.Enchantment
                local niceEnchant = rawEnchant
                
                if Enchantments and Enchantments.Table then
                    local parts = string.split(rawEnchant, "_")
                    if #parts == 2 then
                        local eType = parts[1]
                        local eTier = tonumber(parts[2])
                        local roman = {"I", "II", "III", "IV", "V"}
                        if Enchantments.Table[eType] then
                            local typeDisplay = Enchantments.Table[eType].Display or eType
                            local tierDisplay = roman[eTier] or eTier
                            niceEnchant = string.format("%s %s", typeDisplay, tierDisplay)
                            
                            if Enchantments.Table[eType].List and Enchantments.Table[eType].List[eTier] then
                                local tierData = Enchantments.Table[eType].List[eTier]
                                local desc = Enchantments.Table[eType].Description
                                if desc and tierData.Bonus then
                                    pcall(function()
                                        local formattedDesc = desc:format(tierData.Bonus)
                                        niceEnchant = niceEnchant .. "\n<font size='14' color='#aaaaaa'>(" .. formattedDesc .. ")</font>"
                                    end)
                                end
                            end
                        end
                    end
                end
                bonusText = bonusText .. "\n\n<font color='#ffaa00'><b>Enchantment:</b></font>\n" .. niceEnchant
            end
            
            local rarityHex = GetRarityHex(rarity)

            local function OnClick()
                Window:Dialog({
                    Title = staticInfo.Display,
                    Icon = img,
                    Content = string.format('<font size="18" color="%s"><b>%s</b></font>\n\n%s', rarityHex, rarity, bonusText),
                    Buttons = {{Title="Close", Variant="Secondary"}}
                })
            end

            table.insert(ImageList, {
                Title = staticInfo.Display,
                Quantity = "Weapon",
                Image = img,
                Gradient = GetInvGradient(rarity),
                _Sort = GetRarityVal(rarity) + 200,
                Callback = OnClick
            })
        end
    end

    -- [2] DATA ACCESSORY
    if pData.Attributes.Accessory and pData.Attributes.Accessory ~= "None" then
        local accID = pData.Attributes.Accessory
        local info = Accessories[accID]
        if info then
            Count = Count + 1
            local rarity = info.Rarity or "Common"
            local img = "rbxassetid://84366761557806"
            if info.Template then img = GetIcon(info.Template) end
            
            local bonusText = GenerateBonusText(info)
            local rarityHex = GetRarityHex(rarity)

            local function OnClick()
                 Window:Dialog({
                    Title = info.Display,
                    Icon = img,
                    Content = string.format('<font size="18" color="%s"><b>%s</b></font>\n\n%s', rarityHex, rarity, bonusText),
                    Buttons = {{Title="Close", Variant="Secondary"}}
                })
            end

            table.insert(ImageList, {
                Title = info.Display,
                Quantity = "Accessory",
                Image = img,
                Gradient = GetInvGradient(rarity),
                _Sort = GetRarityVal(rarity) + 100, 
                Callback = OnClick
            })
        end
    end

    -- [3] DATA VAULT (PASSIVES)
    if pData.Vault then
        for catName, _ in pairs(pData.Vault) do
            local equippedID = pData.Attributes[catName]
            if equippedID then
                local config = GetGameConfig(catName)
                local itemData = config and config.List and config.List[tonumber(equippedID)]
                
                if itemData then
                    Count = Count + 1
                    local rarity = itemData.Rarity or "Common"
                    local img = "rbxassetid://84366761557806"
                    if itemData.Template then img = GetIcon(itemData.Template) end
                    
                    local bonusText = GenerateBonusText(itemData)
                    local rarityHex = GetRarityHex(rarity)
                    
                    local function OnClick()
                        Window:Dialog({
                            Title = itemData.Display or catName,
                            Icon = img,
                            Content = string.format('<font size="18" color="%s"><b>%s</b></font>\n\n%s', rarityHex, rarity, bonusText),
                            Buttons = {{Title="Close", Variant="Secondary"}}
                        })
                    end

                    table.insert(ImageList, {
                        Title = itemData.Display,
                        Quantity = catName,
                        Image = img,
                        Gradient = GetInvGradient(rarity),
                        _Sort = GetRarityVal(rarity),
                        Callback = OnClick
                    })
                end
            end
        end
    end

    table.sort(ImageList, function(a,b) return a._Sort > b._Sort end)

    if VaultParagraph and VaultParagraph.ParagraphFrame then
        VaultParagraph.ParagraphFrame:Destroy()
    end
    
    VaultParagraph = FarmTab:Paragraph({
        Title = "Equipped Vault List",
        Desc = "Click Image for details.",
        ImageSize = UDim2.fromOffset(70, 70),
        Images = ImageList
    })
    
    if VaultGroup and VaultGroup.GroupFrame then
        VaultParagraph.ParagraphFrame.UIElements.Main.Parent = VaultGroup.GroupFrame
    end
end

-- [SISTEM FILTER MAP MEGA BOSS]
local MegaBossZoneOptions = {}
-- Mengambil data dari ZonesConfig yang kamu berikan
for id, data in pairs(ZonesConfig) do
    if id ~= "Dungeon" then -- Biasanya Dungeon tidak ada Mega Boss, bisa di-skip
        table.insert(MegaBossZoneOptions, {
            Title = data.Name or id,
            Order = data.Order,
            Value = id
        })
    end
end
table.sort(MegaBossZoneOptions, function(a, b) return a.Order < b.Order end)

MegaBossFilterDrop = FM_Add("Mega Boss", FarmTab:Dropdown({
    Title = "Mega Boss Map Filter",
    Desc = "Select the maps you want to SKIP (Ignore)",
    Multi = true,
    AllowNone = true,
    Values = MegaBossZoneOptions,
    Flag = "MegaBossFilter_Cfg",
    Callback = function(val)
        Config.MegaBossFilter = val -- Stores the table of selected zone IDs
    end
}))

MegaBossToggle = FarmTab:Toggle({
    Title = "Auto Farm Mega Boss",
    Desc = "Auto teleport to Mega Boss when spawned (Chat Detection). Pauses other tasks.",
    Flag = "AutoMegaBoss_Cfg",
    Callback = function(val)
        Config.AutoMegaBoss = val
        if not val then
            MegaBossState.IsActive = false
            MegaBossState.ReturnZone = nil
        end
    end
})
FM_Add("Mega Boss", MegaBossToggle)
MegaBossToggles = {}
if MegaBossUpgradeConfig then
    CreateUpgradeSection(FarmTab, "Mega Boss", MegaBossUpgradeConfig, "AutoMegaBossUp_", MegaBossToggles, nil)
end

if not IsPremium then
    pcall(function() MegaBossFilterDrop:Lock("Need Premium User") end)
    if MegaBossToggle then
        Config.AutoMegaBoss = false
        pcall(function() MegaBossToggle:Set(false) end)
        pcall(function() MegaBossToggle:Lock("Need Premium User") end)
    end
    for name, toggle in pairs(MegaBossToggles) do
        local k = "AutoMegaBossUp_" .. name
        if Config[k] then
            Config[k] = false
        end
        if toggle then
            pcall(function() toggle:Set(false) end)
            pcall(function() toggle:Lock("Need Premium User") end)
        end
    end
end

AvatarStatusPara = FarmTab:Paragraph({
    Title = "Avatar Level Status",
    Desc = "Waiting for Player Data...",
})
FM_Add("Avatar Level", AvatarStatusPara)

ManualUpgradeGroup = FarmTab:Group({Title = "Manual Upgrade"})
FM_Add("Avatar Level", ManualUpgradeGroup)

ManualUpgradeGroup:Button({
    Title = "Level Up (Single)",
    Desc = "Send server request to upgrade the current avatar by 1 level.",
    Icon = "arrow-up",
    Callback = function()
        if Reply and Reply.To then
            pcall(function()
                local pData = (getgenv()).PlayerData
                local currentAvatar = pData and pData.Attributes and pData.Attributes.Avatar
                local avatarDisplayName = currentAvatar
                
                if currentAvatar and Enemies and Enemies[currentAvatar] and Enemies[currentAvatar].Display then
                    avatarDisplayName = Enemies[currentAvatar].Display
                end

                Reply.To("Avatar Upgrade") 
                Notify("Avatar", string.format("Sending 'Avatar Upgrade' request for %s.", avatarDisplayName))
            end)
        end
    end
})
ManualUpgradeGroup:Button({
    Title = "Level Up (MAX)",
    Desc = "Send server request to upgrade the current avatar to Max Level.",
    Icon = "chevrons-up",
    Callback = function()
        if Reply and Reply.To then
            pcall(function()
                local pData = (getgenv()).PlayerData
                local currentAvatar = pData and pData.Attributes and pData.Attributes.Avatar
                local avatarDisplayName = currentAvatar

                if currentAvatar and Enemies and Enemies[currentAvatar] and Enemies[currentAvatar].Display then
                    avatarDisplayName = Enemies[currentAvatar].Display
                end
                
                Reply.To("Avatar Max Upgrade")
                Notify("Avatar", string.format("Sending 'Avatar Max Upgrade' request for %s.", avatarDisplayName))
            end)
        end
    end
})

AvatarLevelToggle = FarmTab:Toggle({
    Title = "Auto Avatar Level Up",
    Flag = "AutoAvatarLevelUp_Cfg",
    Callback = function(val)
        Config.AutoAvatarLevelUp = val
    end
})
FM_Add("Avatar Level", AvatarLevelToggle)


function SendAvatarUpgradeWebhook(avatarDisplayName, newLevel, maxLevel, buffPercentage)
    task.spawn(function()
        local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if not httpRequest then return end

        local censoredName = CensorText(LocalPlayer.DisplayName)
        local censoredID = CensorText(LocalPlayer.UserId)
        
        local embedData = {
            ["username"] = "ANHub - Anime Weapons",
            ["embeds"] = {{
                ["title"] = "🟢 Avatar Level Up Success!",
                ["description"] = string.format("Upgrade Avatar **%s** success!", avatarDisplayName),
                ["color"] = 10038562,
                ["fields"] = {
                    { ["name"] = "Avatar", ["value"] = avatarDisplayName, ["inline"] = true },
                    { ["name"] = "New Level", ["value"] = string.format("Lv. **%d** / %d", newLevel, maxLevel), ["inline"] = true },
                    { ["name"] = "Total Buff", ["value"] = string.format("+%.1f%%", buffPercentage), ["inline"] = true },
                    { ["name"] = "Player Info", ["value"] = "Name: ||" .. censoredName .. "||\nID: ||" .. censoredID .. "||", ["inline"] = false }
                },
                ["footer"] = { ["text"] = "ANHub Script • " .. os.date("%H:%M:%S") }
            }}
        }

        httpRequest({
            Url = WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(embedData)
        })
    end)
end

HeroesStatsModule = nil
HeroesConfigModule = nil
RarityMap = {}
RarityIndexMap = {}
RarityOptions = {}
ValidStatsList = {}

function LoadHeroesStatsData()
    local successStats, moduleStats = pcall(function()
        return shared.HeroesStats
    end)
    if successStats and moduleStats then
        HeroesStatsModule = moduleStats
        
        for statKey, _ in pairs(moduleStats.ValidStats) do
            table.insert(ValidStatsList, statKey)
        end
        table.sort(ValidStatsList) 

        if moduleStats.Stats then
            for index, data in ipairs(moduleStats.Stats) do
                local displayName = data.Display
                RarityMap[displayName] = index
                RarityIndexMap[index] = displayName
                table.insert(RarityOptions, displayName)
            end
            table.sort(RarityOptions, function(a, b) 
                return RarityMap[a] > RarityMap[b] 
            end)
        end
    else
        warn("Gagal load HeroesStats Module Game!")
    end

    local successHero, moduleHero = pcall(function()
        return shared.Heroes
    end)
    if successHero and moduleHero then
        HeroesConfigModule = moduleHero
    else
        warn("Gagal load Heroes Config Module Game! Nama hero mungkin tidak tampil.")
    end
end
LoadHeroesStatsData()

-- Helper Warna Dinamis berdasarkan kekuatan (Index)
function GetModularColor(index)
    local maxIndex = #RarityOptions
    local ratio = math.clamp(index / maxIndex, 0, 1)
    return Color3.fromHSV((1 - ratio) * 0.15, 0.8, 1):ToHex()
end

-- Menghitung persentase buff
function GetClassBuffPercentage(statName, statIndex)
    if not HeroesStatsModule or not HeroesStatsModule.Stats[statIndex] then return "" end
    
    local statData = HeroesStatsModule.Stats[statIndex]
    local boostValue = statData[statName]
    
    if type(boostValue) == "number" then
        return string.format("+%s%%", math.round(boostValue * 100))
    end
    return ""
end

AscUI = {} 
-- [[ CATEGORY: ASCENSION ]] --
do
    -- Paragraph Status Utama
    AscUI.Status = FarmTab:Paragraph({
        Title = "Ascension Status",
        Desc = "Waiting for data...",
        ImageSize = UDim2.fromOffset(50, 50)
    })
    FM_Add("Ascension", AscUI.Status)

    -- Daftar status yang ingin di-auto
    local statList = {"Mastery", "Damage", "Luck", "Yen"}
    Config.AutoStat = {}
    
    -- Logika Pembagian 2 Item per Group
    local currentStatGroup = nil
    for i, statName in ipairs(statList) do
        -- Membuat group baru setiap indeks ganjil (1, 3, dst)
        if (i - 1) % 2 == 0 then
            currentStatGroup = FarmTab:Group({
                Title = (i == 1 and "Auto Distribute Stats" or "") 
            })
            FM_Add("Ascension", currentStatGroup)
        end
        
        currentStatGroup:Toggle({
            Title = "Auto " .. statName,
            Desc = "Auto Distribute Stats points on " .. statName,
            Flag = "AutoStat_" .. statName,
            Callback = function(val)
                Config.AutoStat[statName] = val
            end
        })
    end

    -- Toggle Master untuk Auto Ascend
    AscUI.AutoToggle = FarmTab:Toggle({
        Title = "Auto Ascend",
        Desc = "Automatically ascend when Level Cap is reached.",
        Flag = "AutoAscend_Cfg",
        Callback = function(val)
            Config.AutoAscend = val
        end
    })
    FM_Add("Ascension", AscUI.AutoToggle)
end

EnchUI = {}

if not Config.WeaponSpecificEnchants then
    Config.WeaponSpecificEnchants = {}
end

function GetCurrentWeaponFilters(weaponID)
    if not Config.WeaponSpecificEnchants[weaponID] then
        Config.WeaponSpecificEnchants[weaponID] = {}
    end
    return Config.WeaponSpecificEnchants[weaponID]
end

do
    local EnchControlGroup = FarmTab:Group({Title = "Enchant Controller"})
    FM_Add("Enchantments", EnchControlGroup)

    EnchUI.MasterToggle = EnchControlGroup:Toggle({
        Title = "Loading Weapon...",
        Desc = "Waiting Data...", 
        Flag = "Enchant_Master_Toggle",
        Image = "sparkles",
        ImageSize = 30,
        Callback = function(val)
            Config.Enchant_Master_Toggle = val
            
            if val then
                task.spawn(function()                    
                    while Config.Enchant_Master_Toggle and not Window.Destroyed do
                        local pData = (getgenv()).PlayerData
                        
                        if pData and pData.Attributes and pData.Weapons and pData.Materials and Reply and Reply.To then
                            local currentEquipID = pData.Attributes.Weapon
                            local weaponData = pData.Weapons[currentEquipID]

                            if weaponData and weaponData.Enchantment then
                                local currentEnchantID = weaponData.Enchantment

                                local myFilters = Config.WeaponSpecificEnchants[currentEquipID] or {}

                                local isFilterActive = next(myFilters) ~= nil 

                                if isFilterActive and myFilters[currentEnchantID] == true then
                                    Config.Enchant_Master_Toggle = false
                                    EnchUI.MasterToggle:Set(false)
                                    break 
                                end
                            end

                            local tokenKey = (Enchantments and Enchantments.TokenName) or "EnchantmentToken"
                            local tokenCost = (Enchantments and Enchantments.TokenCost) or 10
                            local myTokens = pData.Materials[tokenKey] or 0
                            
                            if myTokens >= tokenCost then
                                pcall(function()
                                    Reply.To("Enchantments Roll") 
                                end)
                            else
                                if Notify then Notify("Enchantments", "Out of Tokens") end
                                Config.Enchant_Master_Toggle = false
                                EnchUI.MasterToggle:Set(false)
                                break
                            end
                        end
                        task.wait(1.2) -- Delay aman (jangan terlalu cepat agar tidak lag/ban)
                    end
                end)
            end
        end
    })

    -- [3] FILTER SETTINGS (DYNAMIC DROPDOWN)
    local EnchFilterGroup = FarmTab:Group({Title = "Target Settings (Specific per Weapon)"})
    FM_Add("Enchantments", EnchFilterGroup)

    local DropdownValues = {}

    -- Membangun list opsi enchant
    if Enchantments and Enchantments.Table then
        local RomanNumerals = {"I", "II", "III", "IV", "V"} 

        for typeName, typeData in pairs(Enchantments.Table) do
            if typeData.List then
                for tierIndex, tierData in ipairs(typeData.List) do
                    local configId = string.format("%s_%d", typeName, tierIndex)
                    local roman = RomanNumerals[tierIndex] or tostring(tierIndex)
                    local displayName = string.format("%s %s", typeData.Display, roman)
                    local iconId = GetIcon(tierData.Template)
                    
                    local bonusDesc = "Bonus"
                    pcall(function() bonusDesc = typeData.Description:format(tierData.Bonus) end)

                    table.insert(DropdownValues, {
                        Title = displayName,
                        Desc = bonusDesc,
                        Value = configId,
                        Icon = iconId
                    })
                end
            end
        end
        table.sort(DropdownValues, function(a,b) return a.Title < b.Title end)

        EnchUI.FilterDropdown = EnchFilterGroup:Dropdown({
            Title = "Select Target Enchantments",
            Desc = "Select enchantments to STOP rolling for the CURRENT equipped weapon.",
            Multi = true,
            AllowNone = true,
            Values = DropdownValues,
            Flag = "EnchantFilterDropdown",
            Callback = function(selectedValues)
                local pData = (getgenv()).PlayerData
                if pData and pData.Attributes then
                    local currentEquipID = pData.Attributes.Weapon
                    if currentEquipID then
                        Config.WeaponSpecificEnchants[currentEquipID] = {}
                        
                        for _, val in pairs(selectedValues) do
                            local id = type(val) == "table" and val.Value or val
                            Config.WeaponSpecificEnchants[currentEquipID][id] = true
                        end
                    end
                end
            end
        })
    else
        EnchFilterGroup:Paragraph({Title="Error", Desc="Failed to load Enchantments Config"})
    end
end

-- [[ CATEGORY: WEAPON REFORGING ]] --
function RefreshReforgeDropdown()
    local pData = getgenv().PlayerData
    local list = {}
    if pData and pData.Weapons then
        for uid, wData in pairs(pData.Weapons) do
            -- Logika decompile: Harus Tier 3, tidak Locked, tidak Reforged
            if wData.Tier == 3 and not wData.Locked and not wData.Reforged then
                local staticInfo = Weapons[wData.Index]
                if staticInfo then
                    table.insert(list, {
                        Title = staticInfo.Display or uid,
                        Value = uid,
                        Desc = "Mastery: " .. (staticInfo.Mastery or 0),
                        Icon = GetIcon(staticInfo.Template)
                    })
                end
            end
        end
    end
    return list
end

-- Paragraph Status
ReforgeStatusPara = FarmTab:Paragraph({
    Title = "Reforge Status",
    Desc = "Select a Tier 3 weapon to see details.",
})
FM_Add("Weapon Reforging", ReforgeStatusPara)

-- Dropdown Pemilihan Senjata Utama
ReforgeMainDrop = FarmTab:Dropdown({
    Title = "Select Main Weapon",
    Desc = "Only Tier 3 weapons are shown.",
    Values = RefreshReforgeDropdown(),
    Multi = false,
    Flag = "ReforgeMain_Cfg",
    Callback = function(val)
        Config.SelectedReforgeMainUID = type(val) == "table" and val.Value or val
    end
})
FM_Add("Weapon Reforging", ReforgeMainDrop)

-- Toggle Auto Reforge
ReforgeToggle = FarmTab:Toggle({
    Title = "Auto Reforge & Claim",
    Desc = "Auto start process (1 Hour) and auto claim results.",
    Flag = "AutoReforge_Cfg",
    Callback = function(val)
        Config.AutoReforge = val
    end
})
FM_Add("Weapon Reforging", ReforgeToggle)

-- [SISTEM LOCK PREMIUM] --
if not IsPremium then
    ReforgeMainDrop:Lock("Need Premium User")
    ReforgeToggle:Lock("Need Premium User")
end
SelectedHeroUID = nil 

HeroSelectDrop = FarmTab:Dropdown({
    Title = "Select Hero to Manage",
    Desc = "Select which equipped hero to view and roll.",
    Values = {}, 
    Multi = false,
    Flag = "HeroSelect_Dropdown",
    Callback = function(val)
        SelectedHeroUID = (type(val) == "table" and val.Value) or val
        
        if HeroStatsInfo then
            HeroStatsInfo:SetTitle("Updating...")
            HeroStatsInfo:SetDesc("Fetching data for selected hero...")
        end

        -- [FIX] TAMBAHKAN BAGIAN INI:
        -- Paksa kosongkan cache agar Optimizer segera menimpa tulisan "Fetching..."
        if Optimizer and Optimizer.Cache then
            Optimizer.Cache.LastHeroDesc = nil 
            Optimizer.Cache.LastHeroTitle = nil
        end
    end
})
FM_Add("Heroes Stats", HeroSelectDrop)

HeroStatsInfo = FarmTab:Paragraph({
    Title = "Equipped Hero Stats",
    Desc = "Waiting for data..."
})
FM_Add("Heroes Stats", HeroStatsInfo)

TargetLockTier = "S"
if #RarityOptions > 0 then TargetLockTier = RarityOptions[1] end

if #RarityOptions > 0 then
    local LockDropdown = FarmTab:Dropdown({
        Title = "Auto Lock Minimum Tier",
        Desc = "Select the minimum Rarity to keep. (Applies to SELECTED Hero)",
        Values = RarityOptions,
        Default = TargetLockTier,
        Flag = "AutoLockTier_Cfg",
        Callback = function(val)
            TargetLockTier = val
            
            local pData = (getgenv()).PlayerData
            if not pData or not HeroesStatsModule or not Reply or not SelectedHeroUID then return end
            
            local newTargetIndex = RarityMap[TargetLockTier] or 999
            
            if pData.Heroes and pData.Heroes[SelectedHeroUID] then
                local currentStats = pData.Heroes[SelectedHeroUID].Stats or {}
                local lockedStats = pData.LockedHeroesStats or {}
                
                for _, statName in ipairs(ValidStatsList) do
                    local currentIndex = currentStats[statName] or 1
                    local isLocked = lockedStats[statName] == true
                    
                    if isLocked and currentIndex < newTargetIndex then
                        Reply.To("Lock Hero Stats", statName)
                        task.wait(0.1)
                    end
                end
            end
        end
    })
    FM_Add("Heroes Stats", LockDropdown)
else
    local ErrorParagraph = FarmTab:Paragraph({Title="Error", Desc="Could not load rarity list from game."})
    FM_Add("Heroes Stats", ErrorParagraph)
end

EnableLockToggle = FarmTab:Toggle({
    Title = "Enable Auto Lock",
    Desc = "Auto lock stats meeting target tier on Selected Hero.",
    Flag = "EnableAutoLock_Cfg",
    Callback = function(val)
        Config.EnableAutoLock = val
    end
})
FM_Add("Heroes Stats", EnableLockToggle)

AutoRollToggle = FarmTab:Toggle({
    Title = "Auto Roll Stats",
    Desc = "Rolls the Selected Hero if stats are unlocked.",
    Flag = "AutoRollHeroStats_Cfg",
    Callback = function(val)
        Config.AutoRollHeroStats = val
    end
})
FM_Add("Heroes Stats", AutoRollToggle)

-- [[ CATEGORY: RARITY POWERS ]] --
local RP_Group = nil
local RP_Count = 0

-- Kita ambil list dari RarityPower.List
for powerName, powerData in pairs(RarityPower.List) do
    if RP_Count % 2 == 0 then
        RP_Group = FarmTab:Group({Title = (RP_Count == 0 and "Auto Rarity Upgrades" or "")})
        FM_Add("Rarity Powers", RP_Group)
    end

    local toggle = RP_Group:Toggle({
        Title = powerName .. " Power",
        Desc = "Loading data...",
        Image = GetIcon(powerData.Template),
        ImageSize = 28,
        Flag = "AutoRarityPower_" .. powerName,
        Callback = function(val)
            Config["AutoRarityPower_" .. powerName] = val
        end
    })

    RarityPowerUI[powerName] = toggle
    if not IsPremium then
        Config["AutoRarityPower_" .. powerName] = false
        pcall(function() toggle:Set(false) end)
        pcall(function() toggle:Lock("Need Premium User") end)
    else
        if toggle.Locked then
            pcall(function() toggle:Unlock() end)
        end
    end
    RP_Count = RP_Count + 1
end

-- [[ CATEGORY: AVATAR CURSES ]]

-- Paragraf Utama untuk Viewport dan Detail Status
CurseStatusPara = FarmTab:Paragraph({
    Title = "Avatar Curse Status",
    Desc = "Equip an avatar to see current curse details.",
})
FM_Add("Avatar Curses", CurseStatusPara)

-- Membangun opsi dropdown dengan info Buff & Debuff
local curseOptions = {}
for i, v in ipairs(AvatarCurses.Table) do
    local buffs = {}
    local debuffs = {}

    for stat, val in pairs(v.Buff) do
        table.insert(buffs, string.format("<font color='rgb(165, 255, 149)'>+%s%% %s</font>", tostring(val), tostring(stat)))
    end
    
    for stat, val in pairs(v.Debuff) do
        table.insert(debuffs, string.format("<font color='rgb(255, 152, 152)'>-%s%% %s</font>", tostring(val), tostring(stat)))
    end

    local descParts = {}
    if #buffs > 0 then
        table.insert(descParts, "<b>Buff:</b> " .. table.concat(buffs, ", "))
    end
    if #debuffs > 0 then
        table.insert(descParts, "<b>Debuff:</b> " .. table.concat(debuffs, ", "))
    end
    local detailDesc = #descParts > 0 and table.concat(descParts, "\n") or "No effects."

    table.insert(curseOptions, {
        Title = string.format("%s (%s)", v.Display, v.Rarity),
        Desc = detailDesc, -- Menampilkan info status di bawah nama kutukan
        Value = i 
    })
end

CurseFilterDrop = FarmTab:Dropdown({
    Title = "Select Target Curses",
    Desc = "Auto Roll will STOP when you get one of the selected curses.",
    Values = curseOptions,
    Multi = true,
    AllowNone = true,
    Flag = "TargetCurses_Cfg",
    Callback = function(val)
        -- Simpan hanya nilai 'Value' saja ke dalam tabel Config
        local targets = {}
        if type(val) == "table" then
            for _, item in pairs(val) do
                local id = type(item) == "table" and item.Value or item
                if id then table.insert(targets, tonumber(id)) end
            end
        end
        Config.TargetCursesFilter = targets 
    end
})
FM_Add("Avatar Curses", CurseFilterDrop)

CurseAutoToggle = FarmTab:Toggle({
    Title = "Enable Auto Roll Curses",
    Desc = "Loading material info...", -- Akan diupdate otomatis oleh Optimizer
    Flag = "AutoRollCurse_Cfg",
    Callback = function(val) 
        Config.AutoRollCurse = val 
    end
})
FM_Add("Avatar Curses", CurseAutoToggle)

if not IsPremium then
    Config.AutoRollCurse = false
    pcall(function() CurseAutoToggle:Set(false) end)
    pcall(function() CurseAutoToggle:Lock("Need Premium User") end)
    pcall(function() CurseFilterDrop:Lock("Need Premium User") end)
end

FM_CategoryDescriptions["Energy & Hunter"] = "Upgrade your Mastery Buff using Energy Tokens"
-- [[ CATEGORY: ENERGY UPGRADE ]] --

-- Inisialisasi UI
EnergyUpgradeToggle = FarmTab:Toggle({
    Title = "Auto Energy Upgrade",
    Desc = "Scanning data...",
    Image = GetIcon(137070555439430),
    ImageSize = 30,
    Flag = "AutoEnergyUpgrade_Cfg",
    Callback = function(val)
        Config.AutoEnergyUpgrade = val
    end
})
FM_Add("Energy & Hunter", EnergyUpgradeToggle)
if not IsPremium then
    Config.AutoEnergyUpgrade = false
    pcall(function() EnergyUpgradeToggle:Set(false) end)
    pcall(function() EnergyUpgradeToggle:Lock("Need Premium User") end)
end
-- [[ HUNTER UPGRADE UI ]] --
HunterUpgradeToggle = FarmTab:Toggle({
    Title = "Auto Hunter Upgrade",
    Desc = "Scanning data...",
    Image = "rbxassetid://91774759519522", -- Default icon, akan terupdate otomatis
    ImageSize = 30,
    Flag = "AutoHunterUpgrade_Cfg",
    Callback = function(val)
        Config.AutoHunterUpgrade = val
    end
})

if LocalPlayer.UserId ~= 9891690208 then
    FM_Add("Energy & Hunter", HunterUpgradeToggle)
end

if not IsPremium then
    Config.AutoHunterUpgrade = false
    pcall(function() HunterUpgradeToggle:Set(false) end)
    pcall(function() HunterUpgradeToggle:Lock("Need Premium User") end)
end
-- [[ CATEGORY: RELICS (FINAL FIX + AUTO EQUIP) ]] --

-- [BARU] Dropdown Auto Equip
local RelicEquipValues = {}
if RelicsConfig then
    for id, data in pairs(RelicsConfig) do
        table.insert(RelicEquipValues, {
            Title = data.Display,
            Value = tostring(id), -- ID harus String agar cocok dengan remote
            Icon = GetIcon(data.Template)
        })
    end
    table.sort(RelicEquipValues, function(a,b) return a.Title < b.Title end)
end

RelicEquipDrop = FarmTab:Dropdown({
    Title = "Auto Equip Relic",
    Desc = "Select a Relic to auto-equip if owned.",
    Values = RelicEquipValues,
    AllowNone = true,
    Flag = "AutoEquipRelic_Target",
    Callback = function(val)
        -- Simpan Value murni (ID String)
        Config.AutoEquipRelicTarget = (type(val) == "table" and val.Value) or val
    end
})
FM_Add("Relics", RelicEquipDrop)

-- Toggle Generator
RelicToggles = {} 

if RelicsConfig then
    local SortedRelics = {}
    for id, data in pairs(RelicsConfig) do
        table.insert(SortedRelics, {ID = tostring(id), Data = data})
    end
    table.sort(SortedRelics, function(a, b) 
        return tonumber(a.ID) < tonumber(b.ID) 
    end)

    for _, item in ipairs(SortedRelics) do
        local id = item.ID
        local data = item.Data
        
        local toggle = FarmTab:Toggle({
            Title = data.Display,
            Desc = "Waiting for Game Data...", 
            Image = GetIcon(data.Template), 
            ImageSize = 40, 
            Flag = "AutoRelic_" .. id,
            Callback = function(val)
                Config["AutoRelic_" .. id] = val
            end
        })
        
        FM_Add("Relics", toggle)
        
        RelicToggles[id] = {
            UI = toggle,
            Data = data
        }
    end
end

if not IsPremium then
    -- Kunci Dropdown Equip
    pcall(function() RelicEquipDrop:Lock("Need Premium User") end)
    
    for id, info in pairs(RelicToggles) do
        Config["AutoRelic_" .. id] = false
        pcall(function() info.UI:Lock("Need Premium User") end)
        pcall(function() info.UI:Set(false) end)
    end
end
-- [[ CATEGORY: TITLES (MISC) ]] --
TitleToggle = FarmTab:Toggle({
    Title = "Auto Buy Title",
    Desc = "Loading Title Data...",
    Flag = "AutoTitle_Cfg",
    Callback = function(val)
        Config.AutoTitle = val
    end
})
FM_Add("Misc", TitleToggle)
-- [[ CATEGORY: ACHIEVEMENTS ]] --
-- Status Dashboard
AchStatusPara = FarmTab:Paragraph({
    Title = "Achievement Status",
    Desc = "Scanning data...",
    Image = GetIcon(128660194699457), -- Icon Achievement
    ImageSize = 40
})
FM_Add("Misc", AchStatusPara)

-- Toggle Auto Claim
AchAutoClaim = FarmTab:Toggle({
    Title = "Auto Claim Achievements",
    Desc = "Automatically collects rewards for completed achievements.",
    Flag = "AutoClaimAch_Cfg",
    Callback = function(val)
        Config.AutoClaimAchievements = val
    end
})
FM_Add("Misc", AchAutoClaim)
-- [[ TAMBAHAN UNTUK UI ACHIEVEMENTS ]] --

-- Toggle Auto Time Rewards
TimeRewardToggle = FarmTab:Toggle({
    Title = "Auto Claim Time Rewards",
    Desc = "Auto claim Daily & Weekly login rewards.",
    Flag = "AutoTimeReward_Cfg",
    Callback = function(val)
        Config.AutoTimeRewards = val
    end
})
FM_Add("Misc", TimeRewardToggle)
FM_Add("Misc",FarmTab:Toggle({
    Title = "Auto Fuse Weapons",
    Flag = "AutoFuse_Cfg",
    Callback = function(val)
        Config.AutoFuse = val;
        if val then
            task.spawn(function()
                while Config.AutoFuse do
                    if Window.Destroyed then
                        break;
                    end;
                    if Reply and Reply.To then
                        pcall(function()
                            Reply.To("Weapon Fuse All");
                        end);
                    end;
                    task.wait(10);
                end;
            end);
        end;
    end
}))
SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings-2"
});
SettingsTab:Button({
    Title = "Copy PlayerData to Clipboard",
    Icon = "copy",
    Callback = function()
        local data = getgenv().PlayerData -- Mengambil data dari variabel global 
        if data then
            setclipboard(JSONPretty(getgenv().PlayerData, 1))
        end
    end
})
ConfigSection = SettingsTab:Section({
    Title = "Config Manager",
    Icon = "save",
    Opened = true
});
ConfigName = "ANConfig";
SettingsTab:Input({
    Title = "Config Name",
    Placeholder = "ANConfig",
    Flag = "ConfigName_Input",
    Callback = function(txt)
        ConfigName = txt;
    end
});
SettingsTab:Button({
    Title = "Save Config",
    Icon = "save",
    Callback = function()
        (Window.ConfigManager:CreateConfig(ConfigName)):Save();
        if CurrentZoneName ~= "" and Config.SelectedEnemy then
            SaveZoneConfig(CurrentZoneName, Config.SelectedEnemy);
        end;
        Window:Notify({
            Title = "Success",
            Content = "Saved!",
            Icon = "check"
        });
    end
});
SettingsTab:Button({
    Title = "Load Config",
    Icon = "upload",
    Callback = function()
        local cfg = Window.ConfigManager:GetConfig(ConfigName);
        LoadZoneDB();
        if cfg then
            cfg:Load();
            Window:Notify({
                Title = "Success",
                Content = "Loaded!",
                Icon = "check"
            });
        end;
    end
});
SettingsTab:Button({
    Title = "Delete Config",
    Icon = "trash",
    Callback = function()
        Window.ConfigManager:DeleteConfig(ConfigName);
        Window:Notify({
            Title = "Success",
            Content = "Deleted!",
            Icon = "trash"
        });
    end
});
SecuritySection = SettingsTab:Section({
    Title = "Game Security",
    Icon = "shield",
    Opened = true
});
SettingsTab:Paragraph({
    Title = "Game Auto Reconnect",
    Desc = "Status: FROZEN by ANHub\nBypass is running automatically."
});

if Reliable then
    Reliable.OnClientEvent:Connect(function(msg, args)
        if msg == "Do Teleport" and type(args) == "table" then
            local targetZoneName = args[1];
            IsTeleporting = true;
            IsLoadingConfig = true;
            CurrentZoneName = targetZoneName;
            Config.SelectedEnemy = nil;
            if EnemyDropdown then
                EnemyDropdown.Value = {}
                if EnemyDropdown.Display then
                    pcall(function() EnemyDropdown.Display() end)
                end
            end
            EnemyDropdownNeedsRefresh = true
            task.spawn(function()
                local freshEnemies = RefreshEnemyData();
                EnemyDropdown_SetPendingValues(freshEnemies)
                pcall(function()
                    if EnemyDropdown and EnemyDropdown.SetTitle then EnemyDropdown:SetTitle("Select Enemy") end
                end)
                local savedEntry = Config.ZoneConfigurations[targetZoneName];
                if savedEntry then
                    local valuesList = nil
                    if type(savedEntry) == "table" then
                        if type(savedEntry.Values) == "table" then
                            valuesList = savedEntry.Values
                        elseif savedEntry.Value then
                            valuesList = { savedEntry.Value }
                        end
                    end
                    if valuesList then
                        Config.SelectedEnemy = valuesList
                    end
                end;
                EnemyDropdown_SetValueOnlyFromConfig()
                IsLoadingConfig = false;
                IsTeleporting = false;
            end);
        end
    end)
end
-- [CHAT LISTENER: TEXT CHAT SERVICE (FIXED & OPTIMIZED)]
task.spawn(function()
    local TCS = game:GetService("TextChatService")
    local ChatConnection = nil -- Variabel untuk menyimpan koneksi

    ChatConnection = TCS.MessageReceived:Connect(function(msgObj)
        if Window.Destroyed then -- Safety check
            if ChatConnection then ChatConnection:Disconnect() end
            return 
        end

        if not Config.AutoMegaBoss then return end
        if not msgObj or not msgObj.Text then return end
        
        local zoneDisplayName = string.match(msgObj.Text, "Mega Boss Spawned at (.-)!")
        
        if zoneDisplayName then
            local targetZoneID = ZoneDisplayToID[zoneDisplayName]
            
            if targetZoneID then
                -- [LOGIKA FILTER MAP BARU]
                if Config.MegaBossFilter and #Config.MegaBossFilter > 0 then
                    local isFiltered = false
                    for _, filteredID in ipairs(Config.MegaBossFilter) do
                        if targetZoneID == filteredID.Value then
                            isFiltered = true
                            break
                        end
                    end

                    if isFiltered then
                        return -- Berhenti di sini, tidak lanjut teleport
                    end
                end
                -- [AKHIR LOGIKA FILTER]

                if CheckIsFightingZone() then
                    MegaBossState.PendingTargetZone = targetZoneID
                    MegaBossState.PendingZoneDisplayName = zoneDisplayName
                    MegaBossState.PendingReceivedAt = os.time()
                    return
                end

                local pData = getgenv().PlayerData
                local currentZone = pData and pData.Attributes and pData.Attributes.Zone
                if targetZoneID ~= currentZone and not Reliable then
                    MegaBossState.PendingTargetZone = targetZoneID
                    MegaBossState.PendingZoneDisplayName = zoneDisplayName
                    MegaBossState.PendingReceivedAt = os.time()
                    return
                end

                if not MegaBossState.IsActive then
                    MegaBossState.ReturnZone = GetCurrentMapStatus()
                end

                MegaBossState.TargetZone = targetZoneID
                MegaBossState.IsActive = true
                MegaBossState.BossDeadCheck = 0
                MegaBossState.PendingTargetZone = nil
                MegaBossState.PendingZoneDisplayName = nil
                MegaBossState.PendingReceivedAt = 0
                
                if Notify then Notify("Mega Boss", "Spawned at " .. zoneDisplayName .. "! Teleporting...") end
                
                if Reliable and targetZoneID ~= currentZone then
                    pcall(function() Reply.To("Zone Teleport", targetZoneID) end)
                end
            end
        end
    end)

    -- [CLEANUP MONITOR]
    -- Loop ini akan menunggu sampai Window.Destroyed == true
    -- Saat itu terjadi, koneksi Chat akan diputus agar tidak menumpuk (memory leak)
    repeat
        task.wait(1) -- Cek setiap 1 detik (cukup, tidak perlu terlalu cepat)
    until Window.Destroyed

    if ChatConnection then
        ChatConnection:Disconnect()
        ChatConnection = nil
    end
end)

task.spawn(function()
    while not Window.Destroyed do
        task.wait(0.5)

        if not Config.AutoMegaBoss then
            MegaBossState.PendingTargetZone = nil
            MegaBossState.PendingZoneDisplayName = nil
            MegaBossState.PendingReceivedAt = 0
        else
            local pendingZone = MegaBossState.PendingTargetZone
            if pendingZone and not MegaBossState.IsActive and not IsTeleporting and not CheckIsFightingZone() then
                local pData = getgenv().PlayerData
                local currentZone = pData and pData.Attributes and pData.Attributes.Zone
                if pendingZone ~= currentZone and not Reliable then
                    continue
                end

                if not MegaBossState.IsActive then
                    MegaBossState.ReturnZone = GetCurrentMapStatus()
                end

                MegaBossState.TargetZone = pendingZone
                MegaBossState.IsActive = true
                MegaBossState.BossDeadCheck = 0

                local displayName = MegaBossState.PendingZoneDisplayName or tostring(pendingZone)
                if Notify then Notify("Mega Boss", "Spawned at " .. displayName .. "! Teleporting...") end

                if Reliable and pendingZone ~= currentZone then
                    pcall(function() Reply.To("Zone Teleport", pendingZone) end)
                end

                MegaBossState.PendingTargetZone = nil
                MegaBossState.PendingZoneDisplayName = nil
                MegaBossState.PendingReceivedAt = 0
            end
        end
    end
end)

-- [OPTIMIZED ZONE DETECTION LOOP]
task.spawn(function()
    local prevZone = ""
    
    while not Window.Destroyed do
        task.wait() -- Cek setiap 1 detik (0.5 terlalu cepat dan bikin berat)
        
        if not IsTeleporting then
            local detectedZone = GetCurrentMapStatus()
            
            -- Hanya update jika zone BENAR-BENAR berubah
            if detectedZone and detectedZone ~= "Unknown" and detectedZone ~= prevZone then
                
                prevZone = detectedZone
                CurrentZoneName = detectedZone
                Config.SelectedEnemy = nil
                if EnemyDropdown then
                    EnemyDropdown.Value = {}
                    if EnemyDropdown.Display then
                        pcall(function() EnemyDropdown.Display() end)
                    end
                end
                EnemyDropdownNeedsRefresh = true
                
                -- Reset dropdown sementara (Visual feedback)
                if EnemyDropdown and EnemyDropdown.SetTitle then
                    pcall(function() EnemyDropdown:SetTitle("Loading Enemies...") end)
                end
                
                IsLoadingConfig = true
                
                -- Jalankan refresh data di thread terpisah agar Main Loop tidak macet
                task.spawn(function()
                    -- Proses ini sekarang aman karena sudah ada "task.wait" di dalam RefreshEnemyData
                    local freshEnemies = RefreshEnemyData()
                    EnemyDropdown_SetPendingValues(freshEnemies)
                    
                    -- Update Dropdown UI
                    pcall(function()
                        if EnemyDropdown then
                            -- Kembalikan Judul
                            if EnemyDropdown.SetTitle then EnemyDropdown:SetTitle("Select Enemy") end
                        end
                    end)
                    
                    -- Auto Select Enemy Terakhir (Saved Config)
                    task.wait(0.2)
                    local savedEntry = Config.ZoneConfigurations[detectedZone]
                    if savedEntry then
                        local valuesList = nil
                        if type(savedEntry) == "table" then
                            if type(savedEntry.Values) == "table" then
                                valuesList = savedEntry.Values
                            elseif savedEntry.Value then
                                valuesList = { savedEntry.Value }
                            end
                        end
                        if valuesList then
                            Config.SelectedEnemy = valuesList
                        end
                    end
                    EnemyDropdown_SetValueOnlyFromConfig()
                    
                    IsLoadingConfig = false
                end)
            end
        end
    end
end)
task.spawn(function()
    task.wait(1.5);
    local DefaultConfig = "ANConfig";
    local CM = Window.ConfigManager;

    if not isfolder((FolderPath .. "/config")) then
        makefolder(FolderPath .. "/config");
    end;
    pcall(function()
        if isfile(FolderPath .. "/config/" .. DefaultConfig .. ".json") then
            local cfg = CM:GetConfig(DefaultConfig) or CM:CreateConfig(DefaultConfig);
            cfg:Load();
            LoadZoneDB();
        else
            CM:CreateConfig(DefaultConfig);
        end;
    end);
    while not Window.Destroyed do
        task.wait(10);
        pcall(function()
            local cfg = Window.ConfigManager:GetConfig(DefaultConfig);
            if cfg then
                cfg:Save();
            else
                (CM:CreateConfig(DefaultConfig)):Save();
            end;
        end);
        if CurrentZoneName ~= "" and Config.SelectedEnemy then
            SaveZoneConfig(CurrentZoneName, Config.SelectedEnemy);
        end;
    end;
end);

-- Kita gunakan Table "Optimizer" agar tidak memakan batas limit local variable Lua (Limit 200)
Optimizer = { 
    Cache = {
        Roll = {},
        Craft = {},
        Upgrade = {},
        VaultHash = "",
        VaultWasVisible = false,
        EnchantState = "",
        LastAvatarID = nil
    }
}
function Optimizer.Update_Gamemode_Dropdowns()
    -- Update setiap 1 detik
    local now = os.time()
    if Optimizer.Cache.LastGamemodeUpdate and (now - Optimizer.Cache.LastGamemodeUpdate) < 1 then
        return
    end
    Optimizer.Cache.LastGamemodeUpdate = now

    -- [BAGIAN 2] Update Deskripsi UTAMA (Format 2 Item Per Baris)
    local summaryItems = {} 
    
    local function AddSummary(list, db, shortName)
        if not list then return end
        for _, name in pairs(list) do
            local status = ""
            if db and db[name] and db[name].Times then
                local t = GetNextTime(db[name].Times)
                if t <= 0 or t >= 60 then 
                    status = "(<font color='#00ff00'>OPEN</font>)" 
                else 
                    status = "(<font color='#ffaa00'>"..t.."m</font>)" 
                end
            else
                status = "" 
            end
            
            -- Simpan string item ke tabel
            local str = string.format("• %s %s %s", shortName, name, status)
            table.insert(summaryItems, str)
        end
    end

    -- Masukkan semua pilihan
    AddSummary(Config.TargetDungeon, dungeonDB, "Dgn")
    AddSummary(Config.TargetRaid, raidDB, "Raid")
    AddSummary(Config.TargetDefense, defenseDB, "Def")
    
    if Config.TargetPirateTower and #Config.TargetPirateTower > 0 then
        table.insert(summaryItems, "• Pirate Tower")
    end
    if Config.TargetShadowGate and #Config.TargetShadowGate > 0 then
        table.insert(summaryItems, "• Shadow Gate")
    end
    if Config.TargetSorcerersDefense and #Config.TargetSorcerersDefense > 0 then
        table.insert(summaryItems, "• Sorcerers Defense")
    end
    -- TAMBAHKAN INI AGAR MUNCUL DI DESKRIPSI UI
    if Config.TargetCapitalRaid and #Config.TargetCapitalRaid > 0 then
        table.insert(summaryItems, "• Capital Raid")
    end
    if Config.TargetMagicRaid and #Config.TargetMagicRaid > 0 then
            table.insert(summaryItems, "• Magic Raid")
    end
    if Config.TargetIgnitionRaid and #Config.TargetIgnitionRaid > 0 then
        table.insert(summaryItems, "• Ignition Raid")
    end
    if Config.TargetSlimeRaid and #Config.TargetSlimeRaid > 0 then
        table.insert(summaryItems, "• Slime Raid")
    end

    -- [LOGIKA FORMAT BARU DISINI]
    pcall(function()
        if #summaryItems > 0 then
            local finalString = ""
            
            for i, itemStr in ipairs(summaryItems) do
                finalString = finalString .. itemStr
                
                -- Jika bukan item terakhir, kita tentukan pemisahnya
                if i < #summaryItems then
                    -- Cek apakah indeks GENAP (habis dibagi 2) -> Ganti Baris
                    if i % 2 == 0 then
                        finalString = finalString .. "\n"
                    else
                        -- Jika indeks GANJIL -> Beri Jarak Spasi (untuk item sebelahnya)
                        finalString = finalString .. "   " 
                    end
                end
            end
            if Optimizer.Cache.LastGamemodeDesc ~= finalString then
                GameModesDrop:SetDesc(finalString)
                Optimizer.Cache.LastGamemodeDesc = finalString
            end
        else
            local defaultTxt = "Select GameModes to view live status."
            if Optimizer.Cache.LastGamemodeDesc ~= defaultTxt then
                GameModesDrop:SetDesc(defaultTxt)
                Optimizer.Cache.LastGamemodeDesc = defaultTxt
            end
        end
    end)
end

function Optimizer.Update_Ascension_Logic(pData)
    -- Pastikan data atribut dan modul LevelUp tersedia
    if not pData.Attributes or not LevelUp then return end
    
    local currentLevel = pData.Attributes.Level or 1
    local currentAsc = pData.Attributes.Ascension or 0
    
    -- Mengambil batas maksimal level dan ascension dari konfigurasi
    local maxLevel = LevelUp.GetMaxLevel(currentAsc)
    local maxAscensionLimit = LevelUp.MAX_ASCENSION or #LevelUp.AscensionXpBoost

    -- 1. SISTEM CACHE UI
    if AscUI and AscUI.Status then
        local currentExpBonus = LevelUp.GetExpWithBonus(10, pData)
        local expMultiplier = currentExpBonus / 10
        local pct = math.clamp(currentLevel / maxLevel, 0, 1)
        local bar = string.rep("█", math.floor(pct * 10)) .. string.rep("▒", 10 - math.floor(pct * 10))
        
        -- Menandai jika sudah mencapai batas maksimal ascension
        local ascText = tostring(currentAsc)
        if currentAsc >= maxAscensionLimit then
            ascText = ascText .. " (MAX)"
        end

        -- Menyusun string deskripsi baru
        local newDesc = string.format(
            "Current Ascension: %s\nLevel: %d / %d\n[%s] %d%%\n<b>Exp Multiplier: x%.2f</b>",
            ascText, currentLevel, maxLevel, bar, math.floor(pct * 100), expMultiplier
        )
        
        -- Cek Cache: Hanya jalankan SetDesc jika teks berubah
        if Optimizer.Cache.LastAscensionDesc ~= newDesc then
            AscUI.Status:SetDesc(newDesc)
            Optimizer.Cache.LastAscensionDesc = newDesc -- Simpan ke cache
        end
    end

    -- [FEATURE] Auto Distribute Stat Point
    local availablePoints = LevelUp.CountPoints(pData)
    if availablePoints > 0 then
        for statName, isEnabled in pairs(Config.AutoStat) do
            if isEnabled then
                -- Menyesuaikan dengan remote di LevelUpStats.c
                -- Pastikan StatPointAmount di set (misal 1 atau 10) agar tidak lambat
                if Reliable then
                    pcall(function()
                        -- Kita kirim request distribusi ke server
                        Reply.To("Distribute Stat Point", statName)
                    end)
                end
            end
        end
    end

    -- 2. LOGIKA AUTO ASCEND DENGAN CEK LIMIT
    -- Mencegah pengiriman remote jika sudah mencapai MAX_ASCENSION
    if Config.AutoAscend and currentLevel >= maxLevel and currentAsc < maxAscensionLimit then
        if Reliable then
            local now = os.time()
            -- Debounce 5 detik untuk mencegah spam server
            if not Optimizer.Cache.LastAscendTime or (now - Optimizer.Cache.LastAscendTime) > 5 then
                pcall(function()
                    Reply.To("Ascend")
                    if Notify then Notify("Ascension", "Auto Ascending...") end
                end)
                Optimizer.Cache.LastAscendTime = now
            end
        end
    end
end

function Optimizer.Update_Enchantments_Logic(pData)
    -- Update Visual UI Saja
    if EnchUI.MasterToggle then
        if pData.Materials and pData.Attributes and pData.Weapons then
            
            -- [1] DATA WEAPON & TOKEN
            local tokenKey = (Enchantments and Enchantments.TokenName) or "EnchantmentToken"
            local tokenCost = (Enchantments and Enchantments.TokenCost) or 10
            local myTokens = pData.Materials[tokenKey] or 0
            
            local currentEquipID = pData.Attributes.Weapon
            local weaponInstance = pData.Weapons[currentEquipID]
            
            -- Ambil nama cantik weapon & icon
            local weaponDisplayName = currentEquipID or "Unknown"
            local weaponIcon = "sparkles"
            local weaponRarity = "Common" 
            
            if weaponInstance and weaponInstance.Index then
                local configID = weaponInstance.Index
                if Weapons and Weapons[configID] then
                    local staticData = Weapons[configID]
                    if staticData.Display then weaponDisplayName = staticData.Display end
                    if staticData.Template then weaponIcon = GetIcon(staticData.Template) end
                    if staticData.Rarity then weaponRarity = staticData.Rarity end
                end
            end

            local enchantText = "None"
            if weaponInstance and weaponInstance.Enchantment then
                local rawID = weaponInstance.Enchantment
                local parts = string.split(rawID, "_")
                if #parts == 2 and Enchantments and Enchantments.Table then
                    local eType = parts[1]
                    local eTier = tonumber(parts[2])
                    local roman = {"I", "II", "III", "IV", "V"}
                    if Enchantments.Table[eType] then
                        local typeInfo = Enchantments.Table[eType]
                        enchantText = string.format("%s %s", typeInfo.Display, (roman[eTier] or eTier))
                    end
                end
            end
            
            -- [2] UPDATE MAIN TOGGLE UI (OPTIMIZED SPLIT CACHE)
            
            -- A. LOGIC TEKS (Sering berubah karena Token & Enchant)
            -- Hash ini mencakup Token, jadi Title & Desc akan update setiap roll.
            local textStateHash = string.format("%s|%s|%s", weaponDisplayName, myTokens, enchantText)
            
            if Optimizer.Cache.EnchantTextState ~= textStateHash then
                EnchUI.MasterToggle:SetTitle(string.format("%s [%s]", weaponDisplayName, enchantText))
                
                local tkInfo = Materials[tokenKey]
                local tkName = tkInfo and tkInfo.Display or "Tokens"
                local tkIcon = tkInfo and GetIcon(tkInfo.Template) or ""
                
                EnchUI.MasterToggle:SetDesc(string.format("%s%s %s/%s", tkIcon, tkName, Utils.ToText(tokenCost), Utils.ToText(myTokens)))
                
                Optimizer.Cache.EnchantTextState = textStateHash
            end

            -- B. LOGIC GAMBAR (Jarang berubah, HANYA saat ganti senjata)
            -- Hash ini HANYA mencakup Nama Senjata. Token TIDAK dimasukkan.
            -- Jadi SetMainImage TIDAK akan jalan saat nge-roll (FPS Aman).
            local imageStateHash = weaponDisplayName .. weaponIcon
            
            if Optimizer.Cache.EnchantImageState ~= imageStateHash then
                if EnchUI.MasterToggle.SetMainImage then
                    EnchUI.MasterToggle:SetMainImage({
                        Image = weaponIcon,
                        Title = weaponDisplayName,
                        Quantity = weaponRarity, 
                        Gradient = GetGameGradient(weaponRarity) 
                    }, 50)
                end
                Optimizer.Cache.EnchantImageState = imageStateHash
            end

            -- [3] AUTO REFRESH DROPDOWN SAAT GANTI SENJATA
            if Optimizer.Cache.LastEquippedWeapon ~= currentEquipID then
                Optimizer.Cache.LastEquippedWeapon = currentEquipID
                
                if Config.WeaponSpecificEnchants and Config.WeaponSpecificEnchants[currentEquipID] then
                    local savedFilters = Config.WeaponSpecificEnchants[currentEquipID]
                    local valueList = {}
                    for k, v in pairs(savedFilters) do
                        if v then table.insert(valueList, k) end
                    end
                    
                    if EnchUI.FilterDropdown and EnchUI.FilterDropdown.Select then
                        pcall(function() EnchUI.FilterDropdown:Select(valueList) end)
                    end
                else
                    if EnchUI.FilterDropdown and EnchUI.FilterDropdown.Select then
                        pcall(function() EnchUI.FilterDropdown:Select({}) end)
                    end
                end
            end

        end
    end
end

function Optimizer.Update_Reforge_Logic(pData)
    if not pData then return end
    local reforgeData = pData.Reforging 
    local cache = Optimizer.Cache
    
    -- [[ 1. LOGIKA REFRESH DROPDOWN OTOMATIS ]] --
    -- Kita buat "fingerprint" sederhana berdasarkan jumlah senjata Tier 3
    local tier3Count = 0
    if pData.Weapons then
        for _, w in pairs(pData.Weapons) do
            if w.Tier == 3 and not w.Locked and not w.Reforged then
                tier3Count = tier3Count + 1
            end
        end
    end

    -- Jika jumlah senjata Tier 3 berubah, refresh list di Dropdown
    if cache.LastTier3Count ~= tier3Count then
        if ReforgeMainDrop and ReforgeMainDrop.Refresh then
            ReforgeMainDrop:Refresh(RefreshReforgeDropdown())
        end
        cache.LastTier3Count = tier3Count
    end

    -- [[ 2. LOGIKA VISUAL STATUS ]] --
    if reforgeData then
        local timePassed = os.time() - reforgeData.Timestamp
        local timeLeft = 3600 - timePassed 
        
        if timeLeft > 0 then
            local timeStr = Utils.ToText(timeLeft) -- Gunakan formatter yang tersedia di script Anda
            -- Jika tidak ada formatter waktu khusus, gunakan math sederhana:
            local m = math.floor(timeLeft / 60)
            local s = timeLeft % 60
            local displayTime = string.format("%02d:%02d", m, s)
            
            local pct = math.clamp(timePassed / 3600, 0, 1)
            local bar = string.rep("█", math.floor(pct * 10)) .. string.rep("▒", 10 - math.floor(pct * 10))
            
            local desc = string.format("Status: <font color='#ffaa00'>FORGING</font>\nTime: %s\n[%s] %d%%", displayTime, bar, math.floor(pct * 100))
            if cache.LastReforgeText ~= desc then
                ReforgeStatusPara:SetDesc(desc)
                cache.LastReforgeText = desc
            end
        else
            if cache.LastReforgeText ~= "Ready" then
                ReforgeStatusPara:SetDesc("Status: <font color='#00ff00'>READY TO CLAIM</font>\nClick Claim or wait for Auto.")
                cache.LastReforgeText = "Ready"
            end
            
            if Config.AutoReforge and Reliable then
                Reply.To("Reforge Claim") 
                Notify("Reforge", "Weapon Claimed! +50% Mastery Boost applied.")
            end
        end
    else
        -- Jika tidak ada proses reforge yang berjalan
        local idleDesc = "Status: <font color='#aaaaaa'>IDLE</font>\nSelect a Tier 3 weapon and enable Auto."
        if cache.LastReforgeText ~= idleDesc then
            ReforgeStatusPara:SetDesc(idleDesc)
            cache.LastReforgeText = idleDesc
        end

        -- Auto Start Logic
        if Config.AutoReforge and Config.SelectedReforgeMainUID then
            local mainUID = Config.SelectedReforgeMainUID
            local mainData = pData.Weapons and pData.Weapons[mainUID]
            
            if mainData and not mainData.Locked and not mainData.Reforged then
                local materials = {}
                for uid, wData in pairs(pData.Weapons) do
                    if uid ~= mainUID and wData.Index == mainData.Index and wData.Tier == 3 and not wData.Locked and not wData.Reforged then
                        table.insert(materials, uid)
                        if #materials == 2 then break end
                    end
                end
                
                if #materials == 2 and Reliable then
                    Reply.To("Reforge Start", mainUID, materials)
                    Notify("Reforge", "Process Started (1 Hour)")
                end
            end
        end
    end
end

function Optimizer.Update_Exchange_Logic(pData)
    -- [1] AUTO UPDATE DESKRIPSI (STOK) TIAP ITEM DI DALAM LIST DROPDOWN
    for _, item in ipairs(ExchangeList) do
        local key = item.Value
        local currentAmount = (pData and pData.Materials and pData.Materials[key]) or 0
        local newListItemDesc = "Stock: " .. Utils.ToText(currentAmount)
        
        local cacheKey = "ExItemStock_" .. key
        if Optimizer.Cache[cacheKey] ~= newListItemDesc then
            MatPreview:Edit(item.Title, { Desc = newListItemDesc })
            Optimizer.Cache[cacheKey] = newListItemDesc
        end
    end

    -- [2] LOGIKA KALKULASI EXCHANGE
    local tradeTokenCount = (pData.Materials and pData.Materials["TradeToken"]) or 0
    local materialCount = (SelectedExToken and pData.Materials and pData.Materials[SelectedExToken]) or 0
    local ratio = GetExchangeRatio(SelectedExToken)
    local inputDisplay, outputDisplay = 0, 0

    -- Variabel penampung teks untuk di-cache
    local matDescText = "None Selected"
    local tradeDescText = "Waiting..."

    if SelectedExToken then
        if ExchangeIsBuying then
            local maxCanBuy = math.floor(tradeTokenCount / ratio)
            outputDisplay = math.floor(maxCanBuy * ExchangePercent)
            inputDisplay = outputDisplay * ratio
            if ratio < 500 then outputDisplay = outputDisplay/10 end
            matDescText = string.format("Stock: %s | +%s (Buy)", Utils.ToText(materialCount), Utils.ToText(outputDisplay))
            tradeDescText = string.format("Stock: %s | -%s (Pay)", Utils.ToText(tradeTokenCount), Utils.ToText(inputDisplay))
        else
            inputDisplay = math.floor(materialCount * ExchangePercent)
            outputDisplay = inputDisplay * ratio
            matDescText = string.format("Stock: %s | -%s (Sell)", Utils.ToText(materialCount), Utils.ToText(inputDisplay))
            tradeDescText = string.format("Stock: %s | +%s (Get)", Utils.ToText(tradeTokenCount), Utils.ToText(outputDisplay))
        end
        
        -- [3] CACHE UNTUK SetMainImage (HEADER)
        local info = Materials[SelectedExToken]
        if info and MatPreview.SetMainImage then
            local img = SelectedExIcon or (info.Template and GetIcon(info.Template)) or ""
            local rarity = info.Rarity or "Common"
            local title = info.Display or ""
            
            -- Buat hash unik untuk mendeteksi perubahan gambar/rarity/judul
            local imageHash = string.format("ExMainImg_%s_%s_%s", img, rarity, title)
            
            if Optimizer.Cache.LastExMainImageHash ~= imageHash then
                MatPreview:SetMainImage({ 
                    Image = img, 
                    Gradient = GetGameGradient(rarity), 
                    Quantity = rarity, 
                    Title = title 
                }, 50)
                Optimizer.Cache.LastExMainImageHash = imageHash
            end
        end
    else
        -- Reset UI jika tidak ada token terpilih
        matDescText = "None Selected"
        tradeDescText = "Waiting..."
        
        if Optimizer.Cache.LastExMainImageHash ~= "None" then
            MatPreview:SetTitle("Select Token")
            MatPreview:SetMainImage(nil) -- Menghapus gambar
            Optimizer.Cache.LastExMainImageHash = "None"
        end
    end

    -- [4] CACHE UNTUK SetDesc PADA HEADER
    if Optimizer.Cache.LastMatExDesc ~= matDescText then
        MatPreview:SetDesc(matDescText)
        Optimizer.Cache.LastMatExDesc = matDescText
    end

    if Optimizer.Cache.LastTradeExDesc ~= tradeDescText then
        TradePreview:SetDesc(tradeDescText)
        Optimizer.Cache.LastTradeExDesc = tradeDescText
    end
end

function Optimizer.Update_Roll_Logic(pData)
    if not IsPremium then
        for rollType, toggle in pairs(RollToggleUI) do
            local k = "AutoRoll" .. rollType
            if Config[k] then
                Config[k] = false
            end
            if toggle then
                pcall(function() toggle:Set(false) end)
                pcall(function() toggle:Lock("Need Premium User") end)
            end
        end
        return
    end

    if not pData.Vault then return end
    
    for rollType, toggle in pairs(RollToggleUI) do
        local config = RollConfigs[rollType]
        if not config then continue end -- Lewati jika config tidak ada

        local tokenKey = config.MaterialKey or (rollType .. "Token")
        local currentCount = (pData.Materials and pData.Materials[tokenKey]) or 0
        
        -- 1. Cari Index Tertinggi yang dimiliki di Vault
        local foundBestIndex = 0
        if pData.Vault[rollType] then
            for k, v in pairs(pData.Vault[rollType]) do
                local idx = tonumber(k)
                -- Pastikan v == true (berarti item tersebut dimiliki)
                if v == true and idx and idx > foundBestIndex then 
                    foundBestIndex = idx 
                end
            end
        end

        -- 2. Tentukan Data Visual (Image, Rarity, Name) berdasarkan Index Tertinggi
        local currentImage = GetIcon(84366761557806) -- Default Icon
        local currentRarity = nil
        local currentItemName = rollType
        
        if foundBestIndex > 0 and config.List and config.List[foundBestIndex] then
            local itemData = config.List[foundBestIndex]
            if itemData then
                if itemData.Template then currentImage = GetIcon(itemData.Template) end
                currentRarity = itemData.Rarity
                currentItemName = itemData.Display or rollType
            end
        elseif config.ImageId then
            currentImage = GetIcon(config.ImageId)
        end
        
        -- 3. Update Deskripsi (Jumlah Token)
        local lastState = Optimizer.Cache.Roll[rollType] or {}
        if lastState.Count ~= currentCount then
            local matInfo = Materials[tokenKey]
            local matDisplay = matInfo and matInfo.Display or tokenKey
            local matIcon = (matInfo and matInfo.Template) and GetIcon(matInfo.Template) or ""
            
            pcall(function() 
                toggle:SetDesc(string.format("%s%s: %s", matIcon, matDisplay, Utils.ToText(currentCount))) 
            end)
        end
        
        local needsMainImageUpdate = (lastState.Image ~= currentImage)
            or (lastState.Rarity ~= currentRarity)
            or (lastState.ItemName ~= currentItemName)
            or (lastState.PendingMainImage ~= nil)

        if toggle.SetMainImage then
            if needsMainImageUpdate then
                local anulabel = currentRarity and "(" .. currentRarity .. ")" or ""
                pcall(function()
                    toggle:SetTitle(string.format("%s %s",config.Display,anulabel))
                end)
                pcall(function()
                    local rarityLabel = currentRarity
                    if rarityLabel then
                        toggle:SetMainImage({
                            Image = currentImage,
                            Title = currentItemName,
                            Gradient = GetGameGradient(rarityLabel)
                        }, 50)
                    end
                end)
                lastState.Image = currentImage
                lastState.Rarity = currentRarity
                lastState.ItemName = currentItemName
                lastState.PendingMainImage = nil
            end
        elseif needsMainImageUpdate then
            lastState.PendingMainImage = {
                Image = currentImage,
                Rarity = currentRarity,
                ItemName = currentItemName
            }
        end

        lastState.Count = currentCount
        Optimizer.Cache.Roll[rollType] = lastState

        -- 5. Logika Auto Lock jika sudah MAX
        local isMaxed = (config.List and #config.List > 0 and foundBestIndex >= #config.List)
        if isMaxed and not lastState.IsMaxed then
            pcall(function() 
                toggle:Lock("Maximum Tier Reached")
                toggle:SetTitle(rollType .. " [MAX]") 
                if Config["AutoRoll" .. rollType] then 
                    Config["AutoRoll" .. rollType] = false
                    toggle:Set(false) 
                end 
            end)
            local c = Optimizer.Cache.Roll[rollType] or {}
            c.IsMaxed = true
            Optimizer.Cache.Roll[rollType] = c
        end
    end
end

function Optimizer.Update_Craft_Logic(pData)
    for id, info in pairs(CraftToggles) do
        local data, toggle = info.Data, info.UI
        local currentLvl = (pData.Crafts and pData.Crafts[id]) or 0
        local maxLvl, nextLvl = data.MaxLevel, currentLvl + 1
        
        local newTitle, newDesc, isMaxed = "", "", false
        local curBonusStr = FormatBonusString(data.Bonuses and data.Bonuses[currentLvl])

        if currentLvl >= maxLvl then
            isMaxed = true; newTitle = data.Display .. " [MAX]"; newDesc = string.format("<b>Max Level Reached</b>\n\nActive Bonus:\n%s", curBonusStr)
        else
            local nextBonusStr = FormatBonusString(data.Bonuses and data.Bonuses[nextLvl])
            local costStr = "None"
            if data.Costs[nextLvl] then
                local parts = {}
                for matName, reqAmt in pairs(data.Costs[nextLvl]) do
                    local myAmt = pData.Materials[matName] or 0
                    local dName, dIcon = matName, ""
                    if Materials[matName] then dName = Materials[matName].Display; if Materials[matName].Template then dIcon = GetIcon(Materials[matName].Template) end end
                    table.insert(parts, string.format("%s%s %s/%s", dIcon, dName, Utils.ToText(reqAmt), Utils.ToText(myAmt)))
                end
                costStr = table.concat(parts, "\n")
            end
            newTitle = string.format("%s [Lv %d -> %d]", data.Display, currentLvl, nextLvl)
            newDesc = string.format("%s\n\nCurrent [Lv %d]: %s\nNext [Lv %d]: %s", costStr, currentLvl, curBonusStr, nextLvl, nextBonusStr)
        end

        local lastState = Optimizer.Cache.Craft[id] or {}
        if lastState.Title ~= newTitle then toggle:SetTitle(newTitle) end
        if lastState.Desc ~= newDesc then toggle:SetDesc(newDesc) end
        if isMaxed and not lastState.IsMaxed and toggle.SetMainImage then toggle:SetMainImage({ Image = GetIcon(data.Template), Quantity = "MAX", Title = data.Display, Gradient = GetGameGradient(data.Rarity) }, 50) end
        if lastState.Title ~= newTitle or lastState.Desc ~= newDesc or lastState.IsMaxed ~= isMaxed then Optimizer.Cache.Craft[id] = { Title = newTitle, Desc = newDesc, IsMaxed = isMaxed } end
        
        if isMaxed and Config["AutoCraft_"..id] then Config["AutoCraft_"..id] = false; toggle:Set(false) end
        
        if Config["AutoCraft_"..id] and not isMaxed and CanAffordCraft(id, nextLvl) then
            if Reliable then 
                local s = pcall(function() Reply.To("Upgrade Craft", tostring(id)) end) 
                if s then 
                    local now, hk = os.time(), "Craft_"..id
                    if not LastWebhookTime[hk] or (now - LastWebhookTime[hk]) >= 3 then SendUpgradeWebhook("Trainer", "Craft: "..data.Display, nextLvl, 0); LastWebhookTime[hk] = now end
                end
            end
        end
    end
end

function Optimizer.Update_Trainer_Logic(pData)
    for name, data in pairs(CombinedToggleUI) do
        -- Gunakan pcall di dalam loop agar jika satu trainer error, yang lain tetap jalan
        pcall(function()
            local toggle, mod, isGacha = data.Toggle, data.Mod, data.IsGacha
            local currentLvl, tokenKey = 0, ""
            local itemName, currentImage, currentRarity = (mod.Display or name), "rbxassetid://84366761557806", "Common"

            if isGacha then
                if pData.Attributes and pData.GachaLevel and pData.Attributes[name] then
                    local equippedIndex = pData.Attributes[name]
                    if mod.List and mod.List[equippedIndex] then
                        local iData = mod.List[equippedIndex]
                        itemName, currentRarity = iData.Display, iData.Rarity
                        if iData.Template then currentImage = GetIcon(iData.Template) end
                    end
                    currentLvl = pData.GachaLevel[name][tostring(equippedIndex)] or 0
                end
                if currentLvl == 0 then currentLvl = 1 end
                tokenKey = mod.UpgradeMaterial or (name.."Token")
            else
                -- Cek apakah nama index sesuai (Wise vs WiseTrainer)
                currentLvl = pData.CrateUpgrades[name] or pData.CrateUpgrades[name:gsub("Trainer", "")] or 0
                if mod.ImageId then currentImage = GetIcon(mod.ImageId) end
                tokenKey = mod.TOKEN_NAME or (name.."Token")
            end

            -- Pastikan fungsi GetCost tersedia sebelum dipanggil
            local cost = (mod.GetCost and mod.GetCost(currentLvl)) or 0
            local maxLvl = (mod.MAX_LEVEL or mod.MaxLevel or 100)
            local currentMat = pData.Materials[tokenKey] or 0
            local matInfo = Materials[tokenKey]
            local matDisplay = string.format("%s%s", (matInfo and matInfo.Template and GetIcon(matInfo.Template) or ""), (matInfo and matInfo.Display or tokenKey))

            local newTitle, newDesc, isMaxed = "", "", false
            if currentLvl >= maxLvl then
                isMaxed = true; newTitle = itemName .. " [MAX]"; newDesc = "Max Level Reached"
            else
                local chanceVal = (mod.GetChance and mod.GetChance(currentLvl)) or 0
                local chanceTxt = chanceVal > 0 and (" | Chance: " .. (math.floor(chanceVal * 10) / 10) .. "%") or ""
                newTitle = string.format("%s [%d/%d]", name, currentLvl, maxLvl)
                newDesc = string.format("Cost: %s%s\n%s: %s", Utils.ToText(cost), chanceTxt, matDisplay, Utils.ToText(currentMat))
            end

            local cache = Optimizer.Cache.Upgrade[name] or {}
            if cache.Title ~= newTitle then toggle:SetTitle(newTitle) end
            if cache.Desc ~= newDesc then toggle:SetDesc(newDesc) end
            
            if isMaxed and not cache.IsMaxed then 
                toggle:Lock("Already Maxed")
                local k = isGacha and ("AutoUpgrade_"..name) or ("AutoChance_"..name)
                Config[k] = false
                toggle:Set(false) 
            end
            
            Optimizer.Cache.Upgrade[name] = { Title = newTitle, Desc = newDesc, IsMaxed = isMaxed, Image = currentImage, Rarity = currentRarity }
        end)
    end
end

function Optimizer.Update_Vault_Logic(pData)
    -- Fungsi Helper untuk membuat "Sidik Jari" data saat ini
    local function GetVaultSnapshot(pd)
        if not pd.Attributes then return "" end
        local s = {}
        
        -- 1. Masukkan data Vault (Luck, Yen, dll) ke dalam sidik jari
        if pd.Vault then
            for c, _ in pairs(pd.Vault) do 
                if pd.Attributes[c] then s[c] = pd.Attributes[c] end 
            end
        end
        
        -- 2. Masukkan data Accessory
        if pd.Attributes.Accessory then s["Accessory"] = pd.Attributes.Accessory end

        -- 3. Masukkan data WEAPON (Sangat penting agar UI update saat ganti senjata)
        if pd.Attributes.Weapon then s["Weapon"] = pd.Attributes.Weapon end

        return HttpService:JSONEncode(s)
    end
    
    -- Cek apakah Tab Vault sedang terbuka di layar
    local IsVisible = VaultGroup and VaultGroup.GroupFrame and VaultGroup.GroupFrame.Visible
    
    -- Kita HANYA mengecek perubahan data dan merender ulang UI JIKA tab sedang terbuka
    if IsVisible then
        -- Ambil sidik jari (Hash) equipment saat ini
        local CurrentHash = GetVaultSnapshot(pData)
        
        -- Cek apakah sidik jari berubah? (Apakah ada equipment yang baru saja diganti?)
        -- Jika ADA perubahan, kita simpan hash baru dan buat ulang UI-nya.
        -- Jika TIDAK ADA perubahan, kita biarkan saja (tidak perlu buang memori merender ulang).
        if CurrentHash ~= Optimizer.Cache.VaultHash then 
            Optimizer.Cache.VaultHash = CurrentHash 
            
            -- Bungkus dengan task.spawn agar fungsi RefreshVaultUI (yang memanggil Paragraph.lua)
            -- berjalan di background thread dan tidak membuat layar game freeze
            task.spawn(function()
                RefreshVaultUI()
            end)
        end
    end
end

function Optimizer.Update_Avatar_Logic(pData)
    if not pData.AvatarLevels or not AvatarLevels then return end
    
    local currentAvatar = pData.Attributes.Avatar
    local isAvatarSelected = currentAvatar and currentAvatar ~= "" and currentAvatar ~= "None"

    -- [1. LOGIKA VIEWPORT]
    if isAvatarSelected then
        if Optimizer.Cache.LastAvatarID ~= currentAvatar then
            Optimizer.Cache.LastAvatarID = currentAvatar
            local modelPath = ReplicatedFirst:WaitForChild("Assets"):WaitForChild("Enemies"):FindFirstChild(currentAvatar)
            
            if AvatarStatusPara and modelPath then
                local modelClone = modelPath:Clone()
                local orientation, size = modelClone:GetBoundingBox()
                modelClone:PivotTo(CFrame.new(-orientation.Position)) 
                AvatarStatusPara:SetViewport(modelClone)
                
                local vp = AvatarStatusPara.ViewportFrame
                if vp and vp.CurrentCamera then
                    local dist = size.Magnitude * 0.8 
                    vp.CurrentCamera.CFrame = CFrame.lookAt(Vector3.new(0, 0.2, -dist), Vector3.new(0, 0, 0))
                end
            end
        end
    else
        if Optimizer.Cache.LastAvatarID ~= nil then
            Optimizer.Cache.LastAvatarID = nil
            if AvatarStatusPara and AvatarStatusPara.ViewportFrame then
                AvatarStatusPara.ViewportFrame:Destroy()
                AvatarStatusPara.ViewportFrame = nil
            end
        end
    end

    -- [2. UPDATE VISUAL TEKS (TITLE & DESC)]
    if pData.Attributes and pData.Materials then
        local avatarDisplayName = currentAvatar
        local tokenKey = AvatarLevels.Token or "AvatarToken"
        local currentLevel = pData.AvatarLevels[currentAvatar] or 0
        
        -- MENGGUNAKAN GETMAXLEVEL DINAMIS
        local maxLevel = isAvatarSelected and AvatarLevels.GetMaxLevel(currentAvatar) or 100
        local myTokens = pData.Materials[tokenKey] or 0
        
        local newTitle = "No Avatar Selected"
        local newDesc = "Select an avatar in the game's interface to begin."

        if isAvatarSelected then
            if Enemies[currentAvatar] then
                avatarDisplayName = Enemies[currentAvatar].Display
            end

            local nextLevel = currentLevel + 1
            local isMaxed = currentLevel >= maxLevel
            local currentBuff = AvatarLevels.GetBuff(currentLevel)
            local nextBuff = isMaxed and currentBuff or AvatarLevels.GetBuff(nextLevel)
            local cost = isMaxed and 0 or AvatarLevels.GetCost(currentLevel)
            local tokenDisplayName = Materials[tokenKey].Display or tokenKey
            
            local tokenIcon = GetAvatarTokenIcon() or ""
            newTitle = string.format("%s (Lv. %d / %d)", avatarDisplayName, currentLevel, maxLevel)
            
            if isMaxed then
                newDesc = string.format(
                    "<b>STATUS: MAX LEVEL</b>\n\n" ..
                    "Total Buff: <font color='#00ff00'>+%s%% Mastery</font>\n" ..
                    "%s%s %s", 
                    Utils.ToText(currentBuff), tokenIcon,tokenDisplayName, Utils.ToText(myTokens, 0)
                )
                
                if AvatarLevelToggle and not AvatarLevelToggle.Locked then
                    AvatarLevelToggle:Lock("MAX")
                    Config.AutoAvatarLevelUp = false
                    AvatarLevelToggle:Set(false)
                end
            else
                -- MENAMPILKAN HARGA DAN BUFF
                newDesc = string.format(
                    "<b>Current Buff: <font color='#00ff00'>+%s%%</font></b>\n" ..
                    "Next Buff: <font color='#00aaff'>+%s%%</font>\n\n" ..
                    "Upgrade Cost: <font color='#ffaa00'>%s</font> %s%s\n" ..
                    "Your Balance: %s",
                    Utils.ToText(currentBuff),
                    Utils.ToText(nextBuff),
                    Utils.ToText(cost, 0), tokenIcon,tokenDisplayName,
                    Utils.ToText(myTokens, 0)
                )
                
                if AvatarLevelToggle and AvatarLevelToggle.Locked then
                    AvatarLevelToggle:Unlock()
                end
            end
        end

        if AvatarStatusPara then
            if Optimizer.Cache.LastAvatarTitle ~= newTitle then
                AvatarStatusPara:SetTitle(newTitle)
                Optimizer.Cache.LastAvatarTitle = newTitle
            end
            if Optimizer.Cache.LastAvatarDesc ~= newDesc then
                AvatarStatusPara:SetDesc(newDesc)
                Optimizer.Cache.LastAvatarDesc = newDesc
            end
        end
    end

    -- [3. LOGIKA AUTO UPGRADE]
    if Config.AutoAvatarLevelUp and isAvatarSelected then
        local currentLevel = pData.AvatarLevels[currentAvatar] or 0
        local maxLevel = AvatarLevels.GetMaxLevel(currentAvatar)
        local tokenKey = AvatarLevels.Token or "AvatarToken"
        
        if currentLevel < maxLevel then
            local cost = AvatarLevels.GetCost(currentLevel)
            if (pData.Materials[tokenKey] or 0) >= cost then
                if Reliable then
                    pcall(function() Reply.To("Avatar Upgrade") end)
                end
            end
        end
    end
end
function Optimizer.Update_Heroes_Logic(pData)
    if not HeroesStatsModule or not Reliable or not pData.EquippedHeroes or not pData.Heroes then return end
    
    -- Init Cache Variables
    if not Optimizer.Cache.LastHeroRollTime then Optimizer.Cache.LastHeroRollTime = 0 end
    if Optimizer.Cache.EquippedHeroesHash == nil then Optimizer.Cache.EquippedHeroesHash = "Init" end
    -- [BARU]: Sistem retry untuk menembus 'delay render' dari UI Library
    if Optimizer.Cache.HeroRetryCount == nil then Optimizer.Cache.HeroRetryCount = 0 end

    local activeHeroesList = {}
    local hashParts = {} 
    
    for uid, isEquipped in pairs(pData.EquippedHeroes) do 
        if isEquipped == true and pData.Heroes[uid] then 
            local hData = pData.Heroes[uid]
            local hName = "Unknown"
            local hRarity = "Common"
            local damageDisplay = "0%"
            
            if HeroesConfigModule and hData.Index and HeroesConfigModule[hData.Index] then
                local cfg = HeroesConfigModule[hData.Index]
                hName = cfg.Display or hName
                hRarity = cfg.Rarity or hRarity
                
                local baseDamage = cfg.Damage or 0
                local damageStatIndex = (hData.Stats and hData.Stats.Damage) or 1
                
                local buffMultiplier = 1
                if HeroesStatsModule.GetBuff then
                    pcall(function()
                        buffMultiplier = HeroesStatsModule.GetBuff("Damage", damageStatIndex)
                    end)
                end
                
                local finalDamage = baseDamage * 100 * buffMultiplier
                damageDisplay = Utils.ToText(finalDamage, 3) .. "%"
            end
            
            local displayTitle = string.format("%s [%s]", hName, hRarity)

            table.insert(activeHeroesList, {
                Title = displayTitle,
                Value = uid,
                Desc = "Damage: " .. damageDisplay
            })
            
            -- [PERBAIKAN]: Hash sekarang memasukkan nilai Damage. 
            -- Jika server telat ngirim status Damage, Hash akan berubah dan UI dipaksa Refresh.
            table.insert(hashParts, uid .. "|" .. damageDisplay)
        end 
    end
    
    table.sort(hashParts)
    local currentHash = table.concat(hashParts, ",")
    
    local hasHeroData = #activeHeroesList > 0
    
    -- [PERBAIKAN UTAMA]: 
    -- 1. Refresh jika Hash berubah
    -- 2. ATAU paksa refresh beberapa kali (Retry) di awal jika data ada tapi UI mungkin belum siap merender
    if currentHash ~= Optimizer.Cache.EquippedHeroesHash or (hasHeroData and Optimizer.Cache.HeroRetryCount < 3) then
        table.sort(activeHeroesList, function(a,b) return a.Title < b.Title end)
        
        if HeroSelectDrop then
            if HeroSelectDrop.Refresh then
                HeroSelectDrop:Refresh(activeHeroesList)
            end
            -- [KUNCI]: Sinkronisasi manual list Values ke memory Dropdown UI
            HeroSelectDrop.Values = activeHeroesList 
        end
        
        if not SelectedHeroUID and hasHeroData then
            SelectedHeroUID = activeHeroesList[1].Value
            if HeroSelectDrop and HeroSelectDrop.Select then
                pcall(function() HeroSelectDrop:Select(SelectedHeroUID) end)
            end
        end
        
        Optimizer.Cache.EquippedHeroesHash = currentHash
        
        -- Tambah counter retry agar tidak spam selamanya
        if hasHeroData then
            Optimizer.Cache.HeroRetryCount = Optimizer.Cache.HeroRetryCount + 1
        end
    end

    -- [3] TAMPILKAN STATS & VIEWPORT HERO YANG DIPILIH
    local isValidSelection = false
    if SelectedHeroUID and pData.EquippedHeroes[SelectedHeroUID] == true then
        isValidSelection = true
    else
        if hasHeroData then
            SelectedHeroUID = activeHeroesList[1].Value
            isValidSelection = true
            if HeroSelectDrop and HeroSelectDrop.Select then 
                pcall(function() HeroSelectDrop:Select(SelectedHeroUID) end) 
            end
        end
    end

    if isValidSelection and SelectedHeroUID then
        local hData = pData.Heroes[SelectedHeroUID]
        local hStats = hData.Stats or {}
        local lStats = pData.LockedHeroesStats or {}
        
        local hName = "Unknown Hero"
        local hRarity = "Common"
        local hDamageStr = "0%"

        if HeroesConfigModule and hData.Index and HeroesConfigModule[hData.Index] then
            local cfg = HeroesConfigModule[hData.Index]
            hName = cfg.Display or hName
            hRarity = cfg.Rarity or hRarity
            
            local baseDamage = cfg.Damage or 0
            local damageStatIndex = hStats.Damage or 1
            local buffMultiplier = 1
            if HeroesStatsModule.GetBuff then
                pcall(function() buffMultiplier = HeroesStatsModule.GetBuff("Damage", damageStatIndex) end)
            end
            hDamageStr = Utils.ToText(baseDamage * 100 * buffMultiplier, 3) .. "%"
        end

        if Optimizer.Cache.LastHeroUID ~= SelectedHeroUID then
            Optimizer.Cache.LastHeroUID = SelectedHeroUID
            
            local modelPath = ReplicatedFirst:WaitForChild("Assets"):WaitForChild("Heroes"):FindFirstChild(hData.Index)
            
            if HeroStatsInfo and modelPath then
                local modelClone = modelPath:Clone()
                local orientation, size = modelClone:GetBoundingBox()
                
                modelClone:PivotTo(CFrame.new(-orientation.Position)) 
                HeroStatsInfo:SetViewport(modelClone)
                
                local vp = HeroStatsInfo.ViewportFrame
                if vp and vp.CurrentCamera then
                    local dist = size.Magnitude * 0.8 
                    vp.CurrentCamera.CFrame = CFrame.lookAt(
                        Vector3.new(0, 0.2, -dist), 
                        Vector3.new(0, 0, 0)        
                    )
                end
            end
        end
        
        local lines = ""
        for _, sName in ipairs(ValidStatsList) do
            local sIdx = hStats[sName] or 1
            local sColor = GetModularColor(sIdx)
            local sRankName = RarityIndexMap[sIdx] or "?"
            local sBuff = GetClassBuffPercentage(sName, sIdx)
            local sLockStatus = (lStats[sName] and "🔒" or "🔓")
            
            lines = lines .. string.format('<font color="#%s"><b>[%s]</b></font> %s (%s): %s\n', sColor, sRankName, sName, sBuff, sLockStatus)
        end
        
        local myShards = pData.Materials.HeroesStats or 0
        local shardsStr = Utils.ToText(myShards)
        lines = lines .. string.format('\n<font color="#00ffff"><b>Hero Shards:</b></font> %s', shardsStr)
        
        local newTitle = string.format("%s [%s] - %s DMG", hName, hRarity, hDamageStr)
        
        if Optimizer.Cache.LastHeroTitle ~= newTitle then
            HeroStatsInfo:SetTitle(newTitle)
            Optimizer.Cache.LastHeroTitle = newTitle
        end

        if Optimizer.Cache.LastHeroDesc ~= lines then
            HeroStatsInfo:SetDesc(lines)
            Optimizer.Cache.LastHeroDesc = lines
        end
        
        if Config.EnableAutoLock then
            local targetIdx = RarityMap[TargetLockTier] or 999
            for _, sName in ipairs(ValidStatsList) do
                local currentIdx = hStats[sName] or 1
                if currentIdx >= targetIdx and not lStats[sName] then
                    pcall(function()
                        Reply.To("Lock Hero Stats", sName)
                    end)
                end
            end
        end

        if Config.AutoRollHeroStats then
            local currency = pData.Materials.HeroesStats or 0
            local allTargetsLocked = true
            local targetIdx = RarityMap[TargetLockTier] or 999
            
            for _, sName in ipairs(ValidStatsList) do
                local currentIdx = hStats[sName] or 1
                if currentIdx >= targetIdx and not lStats[sName] then
                    allTargetsLocked = false
                    break
                end
            end

            if allTargetsLocked and currency > 10 then
                if (os.time() - Optimizer.Cache.LastHeroRollTime) >= 1.5 then
                    local anyUnlocked = false
                    for _, sName in ipairs(ValidStatsList) do 
                        if not lStats[sName] then anyUnlocked = true; break end 
                    end
                    
                    if anyUnlocked then
                        Reply.To("Roll Hero Stats", SelectedHeroUID, false)
                        Optimizer.Cache.LastHeroRollTime = os.time()
                    end
                end
            end
        end
    else
        if Optimizer.Cache.LastHeroUID ~= nil then
            Optimizer.Cache.LastHeroUID = nil
            if HeroStatsInfo and HeroStatsInfo.ViewportFrame then
                HeroStatsInfo.ViewportFrame:Destroy()
                HeroStatsInfo.ViewportFrame = nil
            end
        end
        HeroStatsInfo:SetTitle("No Hero Selected")
        HeroStatsInfo:SetDesc("Please equip a hero and select it from the dropdown.")
    end
end

function Optimizer.Update_MegaBoss_Logic(pData)
    -- Pastikan config & module terload
    if not MegaBossUpgradeConfig or not MegaBoss then return end

    if not IsPremium then
        if MegaBossFilterDrop then
            pcall(function() MegaBossFilterDrop:Lock("Need Premium User") end)
        end
        if MegaBossToggle then
            Config.AutoMegaBoss = false
            pcall(function() MegaBossToggle:Set(false) end)
            pcall(function() MegaBossToggle:Lock("Need Premium User") end)
        end
        for name, toggle in pairs(MegaBossToggles) do
            local k = "AutoMegaBossUp_" .. name
            if Config[k] then
                Config[k] = false
            end
            if toggle then
                pcall(function() toggle:Set(false) end)
                pcall(function() toggle:Lock("Need Premium User") end)
            end
        end
        return
    end
    
    -- Ambil Data Player
    local myUpgrades = pData.MegaBossUpgrades or {}
    local tokenName = MegaBoss.TokenName or "MegaBossToken" --
    local myTokens = pData.Materials[tokenName] or 0
    
    -- Ambil Template Icon Token untuk Display (Optional)
    local tokenIcon = ""
    if Materials[tokenName] and Materials[tokenName].Template then
        tokenIcon = GetIcon(Materials[tokenName].Template)
        tokenName = Materials[tokenName].Display
    end

    for name, cfg in pairs(MegaBossUpgradeConfig) do
        local currentLvl = myUpgrades[name] or 0
        local maxLvl = cfg.MaxLevel or 20 --
        
        -- Hitung Cost & Buff menggunakan Fungsi dari Module
        local cost = 0
        if MegaBoss.GetUpgradeCost then
            cost = MegaBoss.GetUpgradeCost(currentLvl, name) -- Rumus: 5 + 5 * Level
        end
        
        local currentBuff = 0
        if MegaBoss.GetUpgradeBuff then
            currentBuff = MegaBoss.GetUpgradeBuff(name, currentLvl) -- Rumus: Level * BonusPerLevel
        end

        -- Update Visual UI
        local toggle = MegaBossToggles[name]
        if toggle then
            local newTitle = ""
            local newDesc = ""
            local isMaxed = currentLvl >= maxLvl

            if isMaxed then
                newTitle = name .. " [MAX]"
                newDesc = string.format("<b>Maxed</b>\nBuff: +%s%%", Utils.ToText(currentBuff))
                if not toggle.Locked then 
                    toggle:Lock("Already Maxed") 
                    Config["AutoMegaBossUp_" .. name] = false
                    toggle:Set(false)
                end
            else
                newTitle = string.format("%s [%d/%d]", name, currentLvl, maxLvl)
                newDesc = string.format("%s%s %s/%s\nBuff: +%s%%", 
                    tokenIcon,tokenName, Utils.ToText(cost), Utils.ToText(myTokens), Utils.ToText(currentBuff))
                if toggle.Locked then toggle:Unlock() end
            end

            -- Update Cache Text agar tidak spam update UI
            local cacheKey = "MB_"..name
            local cacheData = Optimizer.Cache.Upgrade[cacheKey] or {}
            
            if cacheData.Title ~= newTitle then toggle:SetTitle(newTitle) end
            if cacheData.Desc ~= newDesc then toggle:SetDesc(newDesc) end
            
            Optimizer.Cache.Upgrade[cacheKey] = { Title = newTitle, Desc = newDesc }
        end

        -- Logic Auto Upgrade
        if Config["AutoMegaBossUp_" .. name] and not (currentLvl >= maxLvl) then
            if myTokens >= cost then
                if Reliable then
                    pcall(function()
                        -- Remote Event sesuai Decompile
                        Reply.To("Mega Boss Upgrade", name)
                    end)
                    
                local now = os.time()
                local hookKey = "MB_Upgrade_" .. name
                    if not LastWebhookTime[hookKey] or (now - LastWebhookTime[hookKey]) >= 2 then
                        SendUpgradeWebhook("MegaBoss", name, currentLvl + 1, cost)
                        LastWebhookTime[hookKey] = now
                    end
                end
            end
        end
    end
end

_UIDescCache = {} 

-- [[ HELPER LOGIKA UPGRADE UMUM (OPTIMIZED) ]] --
function Optimizer.GenericUpgradeLogic(configList, currentLevels, upgradeModule, toggleList, configPrefix, remoteName, currencyVal, currencyIcon)
    if not currentLevels then return end
    
    for name, cfg in pairs(configList) do
        local lvl = currentLevels[name] or 0
        local toggle = toggleList[name]
        
        -- Ambil Max Level (Default 999 jika tidak ada di config)
        local max = cfg.MaxLevel or 999
        
        -- Hitung Cost satu kali di awal loop agar efisien
        local cost = 0
        if upgradeModule.GetUpgradeCost then
            cost = upgradeModule.GetUpgradeCost(lvl, name)
        end
        
        -- 1. UPDATE TAMPILAN UI
        if toggle then
            local newTitle = ""
            local newDesc = ""
            
            -- [LOGIKA PENYUSUNAN TEXT]
            if lvl >= max then
                newTitle = name .. " [" .. lvl .. "/" .. max .. "]"
                
                local buff = 0
                if upgradeModule.GetUpgradeBuff then
                    buff = upgradeModule.GetUpgradeBuff(name, lvl)
                end
                newDesc = string.format("<b>Maxed</b>\nBuff: +%s%%", Utils.ToText(buff))
            else
                newTitle = name .. " [" .. lvl .. "/" .. max .. "]"
                
                local buff = 0
                if upgradeModule.GetUpgradeBuff then
                    buff = upgradeModule.GetUpgradeBuff(name, lvl)
                end
                
                -- Format: Icon Cost | Cur: Value \n Buff: +%
                newDesc = string.format("%s Cost: %s/%s\nBuff: +%s%%", 
                    currencyIcon, Utils.ToText(cost), Utils.ToText(currencyVal), Utils.ToText(buff))
                
                -- Buka kunci jika belum Max
                if toggle.Locked then toggle:Unlock() end
            end
            
            -- [OPTIMASI UTAMA: CACHE CHECK]
            -- Kita buat kunci unik untuk setiap elemen UI
            local titleCacheKey = configPrefix .. name .. "_Title"
            local descCacheKey = configPrefix .. name .. "_Desc"
            
            -- Cek apakah Title berubah? Jika TIDAK, jangan update.
            if _UIDescCache[titleCacheKey] ~= newTitle then
                toggle:SetTitle(newTitle)
                _UIDescCache[titleCacheKey] = newTitle
            end

            -- Cek apakah Description berubah? Jika TIDAK, jangan update.
            -- Ini yang paling sering menyebabkan lag karena teksnya panjang & berwarna.
            if _UIDescCache[descCacheKey] ~= newDesc then
                toggle:SetDesc(newDesc)
                _UIDescCache[descCacheKey] = newDesc
            end
        end

        -- 2. LOGIKA AUTO BUY
        if Config[configPrefix .. name] and lvl < max then
            if currencyVal >= cost then
                if Reliable then
                    pcall(function() Reply.To(remoteName, name) end)
                end
            end
        end
    end
end

function Optimizer.Update_Main_Data_Logic(pData)
    local cRank, cMastery = (pData.Attributes.Rank or 0), (pData.Attributes.Mastery or 0)
    local req, cBuff, nBuff = RankUp.GetRequirement(cRank), RankUp.GetBuff(cRank), RankUp.GetBuff(cRank+1)
    
    if RankProgressUI then
        local pct = req>0 and math.clamp(cMastery/req,0,1) or 0
        local bar = string.rep("█", math.floor(pct*10)) .. string.rep("▒", 10-math.floor(pct*10))
        local bt = (cRank>=RankUp.MAX) and ("Buff: "..Utils.ToText(cBuff).."% (MAX)") or ("Buff: "..Utils.ToText(cBuff).."% >> "..Utils.ToText(nBuff).."%")
        local finalDesc = string.format("%s\n[%s] %d%%\n%s / %s", bt, bar, math.floor(pct*100), Utils.ToText(cMastery), Utils.ToText(req))
        
        if _UIDescCache["Rank"] ~= finalDesc then
            RankProgressUI:SetTitle("Rank "..cRank.."/"..RankUp.MAX)
            RankProgressUI:SetDesc(finalDesc)
            _UIDescCache["Rank"] = finalDesc
        end
    end
    
    if Config.AutoRankUp and cMastery >= req and cRank < RankUp.MAX then
         if Reliable then pcall(function() Reply.To("RankUp") end) end
    end

    -- [LOGIKA BARU YANG LEBIH PENDEK]
    
    -- 1. Jalankan Logika Yen
    if pData.YenUpgrades then
        Optimizer.GenericUpgradeLogic(
            YenUpgrades.Config,        -- Config
            pData.YenUpgrades,       -- Data Level Player
            YenUpgrades,               -- Module Game
            YenUpgradeToggleUI,      -- UI Toggle Kita
            "AutoYen_",              -- Prefix Config
            "Yen Upgrade",           -- Nama Remote
            (pData.Attributes.Yen or 0), -- Jumlah Uang
            GetIcon(139379806755218)     -- Icon Yen
        )
    end

    -- 2. Jalankan Logika Token
    if pData.TokenUpgrades then
        -- Siapkan Icon Token
        local tKey = "UpgradeToken"
        local tIcon = ""
        if Materials[tKey] and Materials[tKey].Template then 
            tIcon = GetIcon(Materials[tKey].Template) 
        end
        
        Optimizer.GenericUpgradeLogic(
            TokenUpgrades.Config, 
            pData.TokenUpgrades, 
            TokenUpgrades, 
            TokenUpgradeToggleUI, 
            "AutoToken_", 
            "Token Upgrade", 
            (pData.Materials[tKey] or 0), -- Jumlah Token
            tIcon
        )
    end

    -- 3. Jalankan Logika Capital Upgrades
    if pData.CapitalsUpgrades and CapitalsUpgradesConfig then
        -- Ambil Icon Token Capital
        local cKey = "UpgradeCapitalToken"
        local cIcon = ""
        if Materials[cKey] and Materials[cKey].Template then 
            cIcon = GetIcon(Materials[cKey].Template) 
        end
        
        Optimizer.GenericUpgradeLogic(
            CapitalsUpgradesConfig.Config,  -- Config List
            pData.CapitalsUpgrades,         -- Data Level Player
            CapitalsUpgradesConfig,         -- Module (untuk hitung cost/buff)
            CapitalUpgradeToggles,          -- UI Toggle Kita
            "AutoCapital_",                 -- Prefix Config
            "Capitals Upgrade",             -- Nama Remote Event (Sesuai Decompile)
            (pData.Materials[cKey] or 0),   -- Jumlah Token Player
            cIcon                           -- Icon Token
        )
    end
end

-- ============================================================================
-- [SECRET QUESTS UI - REVISED SINGLE PARAGRAPH]
-- ============================================================================

-- [UBAHAN BARU] Satu Paragraf Besar untuk menampung semua list
HQ_MainStatusUI = FarmTab:Paragraph({
    Title = "Hidden Quests List",
    Desc = "Scanning Quests Data...",
})
FM_Add("Secret Quests", HQ_MainStatusUI)

HQ_Group = FarmTab:Toggle({
    Title = "Auto Complete Hidden Quests",
    Desc = "Auto Take, Farm Target & Claim Rewards.",
    Flag = "AutoHiddenQuests_Cfg",
    Callback = function(val) Config.AutoHiddenQuests = val end
})
FM_Add("Secret Quests", HQ_Group)

function Optimizer.Update_HiddenQuests_Logic(pData)
    if CheckIsFightingZone() then return end
    if Config.AutoMegaBoss and MegaBossState.IsActive then return end
    if not HiddenQuests or not pData.HiddenQuests then return end
    if not pData.Quests then pData.Quests = {} end 
    
    local isAuto = Config.AutoHiddenQuests
    local hasActionTaken = false 
    
    -- Table untuk menampung baris-baris teks UI
    local uiReportLines = {} 

    for id, questData in ipairs(HiddenQuests) do
        local strID = tostring(id)
        local myStage = pData.HiddenQuests[strID] or 0 
        local currentStageIndex = myStage + 1
        local questInfo = questData.Quests[currentStageIndex]
        
        local qKey = "HiddenQuests_" .. strID
        local serverQuestData = pData.Quests[qKey]
        
        -- UI Vars
        local statusColor = "#aaaaaa"
        local statusText = "Unknown"
        local detailText = ""
        local targetToFarm = nil
        local displayTargetName = "Unknown"
        
        -- [LOGIKA STATUS UI]
        if not questInfo then
            -- [COMPLETED]
            statusColor = "#00ff00" -- Hijau
            statusText = "COMPLETED"
            
            local bonusList = {}
            if questData.Bonuses then
                for stat, val in pairs(questData.Bonuses) do
                    local statColor = "#ffffff" -- Default Putih
                    
                    -- [PEWARNAAN STATS]
                    if stat == "Damage" then
                        statColor = "#ff2b2b" -- Merah
                    elseif stat == "Mastery" then
                        statColor = "#d667ff" -- Ungu
                    elseif stat == "Yen" or stat == "Coins" then
                        statColor = "#f1c40f" -- Kuning (Optional pelengkap)
                    end
                    
                    -- Format: <Warna>NamaStat</Warna>: +Val%
                    table.insert(bonusList, string.format("<font color='%s'>%s</font>: +%s%%", statColor, stat, tostring(val)))
                end
            end
            
            if #bonusList > 0 then
                -- Langsung list bonus (Tanpa tulisan Rewards:)
                detailText = table.concat(bonusList, ", ")
            else
                detailText = "All stages finished."
            end

        else
            -- [QUEST AKTIF]
            if questInfo.Target then
                if questInfo.Event == "EnemyDefeated" then
                    displayTargetName = GetEnemyDisplayName(questInfo.Target)
                else
                    displayTargetName = questInfo.Target
                end
            elseif questInfo.Description then
                displayTargetName = questInfo.Description
            end
            
            local reqAmount = questInfo.Required or 1
            local currentAmount = (serverQuestData and serverQuestData.Progress) or 0
            targetToFarm = questInfo.Target 
            
            if not serverQuestData then
                statusColor = "#ffff00" -- Kuning
                statusText = "READY"
                detailText = "Click Auto to Start"
            elseif serverQuestData.Status == "Completed" or currentAmount >= reqAmount then
                statusColor = "#00aaff" -- Biru
                statusText = "CLAIMING"
                detailText = "Done! Claiming..."
            else
                statusColor = "#ffaa00" -- Oranye
                statusText = "FARMING"
                detailText = string.format("%s: %s/%s", displayTargetName, Utils.ToText(currentAmount), Utils.ToText(reqAmount))
            end
        end
        
        -- [FORMAT TEXT REVISI]
        local questTitle = questData.Display or ("Quest " .. id)
        
        -- Format Baru:
        -- 1. NamaQuest (STATUS)
        --    Detail/Bonus...
        local line = string.format("<b>%d. %s</b> (<font color='%s'>%s</font>)\n   %s", 
            id, questTitle, statusColor, statusText, detailText)
            
        table.insert(uiReportLines, line)

        -- [LOGIKA OTOMASI (AUTO) - TETAP SAMA]
        if isAuto and questInfo and not hasActionTaken then
            if serverQuestData and ((serverQuestData.Status == "Completed") or (serverQuestData.Progress and serverQuestData.Progress >= questInfo.Required)) then
                if Reliable then
                    pcall(function() Reply.To("Update HiddenQuests", strID) end)
                    Notify("Hidden Quest", "Claiming Stage " .. currentStageIndex)
                    hasActionTaken = true
                end
            elseif not serverQuestData then
                if Reliable then
                    pcall(function() Reply.To("Update HiddenQuests", strID) end)
                    Notify("Hidden Quest", "Starting Stage " .. currentStageIndex)
                    hasActionTaken = true 
                end
            elseif serverQuestData.Status == "Progress" and questInfo.Event == "EnemyDefeated" and targetToFarm then
                local currentMap = GetCurrentMapStatus()
                if currentMap ~= "Unknown" and currentMap ~= questData.Zone then
                    if not IsTeleporting then
                        if Reliable then
                            pcall(function() Reply.To("Zone Teleport", questData.Zone) end)
                            IsTeleporting = true
                            hasActionTaken = true
                            task.spawn(function() task.wait(4); IsTeleporting = false end)
                        end
                    end
                elseif currentMap == questData.Zone then
                    local selected = Config.SelectedEnemy
                    local needsChange = true
                    if type(selected) == "table" then
                        needsChange = (#selected ~= 1) or (selected[1] ~= displayTargetName)
                    else
                        needsChange = (selected ~= displayTargetName)
                    end
                    if needsChange then
                        Config.SelectedEnemy = { displayTargetName }
                        Config.AutoFarm = true 
                        EnemyDropdown_SetValueOnlyFromConfig()
                        EnemyDropdownNeedsRefresh = true
                    end
                    hasActionTaken = true 
                end
            end
        end
    end

    -- [UPDATE UI UTAMA]
    if HQ_MainStatusUI then
        local finalString = table.concat(uiReportLines, "\n")
        
        -- Cek apakah string baru BEDA dengan yang lama
        if Optimizer.Cache.LastHiddenQuestString ~= finalString then
            pcall(function() HQ_MainStatusUI:SetDesc(finalString) end)
            Optimizer.Cache.LastHiddenQuestString = finalString -- Simpan ke cache
        end
    end
end

function Optimizer.Update_RarityPower_Logic(pData)
    if not pData.RarityPowers or not Reliable then return end

    if not IsPremium then
        for powerName, toggle in pairs(RarityPowerUI) do
            if Config["AutoRarityPower_" .. powerName] then
                Config["AutoRarityPower_" .. powerName] = false
            end
            if toggle then
                pcall(function() toggle:Set(false) end)
                pcall(function() toggle:Lock("Need Premium User") end)
            end
        end
        return
    end

    for powerName, toggle in pairs(RarityPowerUI) do
        local powerConfig = RarityPower.List[powerName]
        local totalLevel = pData.RarityPowers[powerName] or 0
        
        -- Mengambil Rarity, Level di Rarity tersebut, dan Max Level Rarity tersebut
        local rIdx, curLvl, maxLvl = RarityPower.GetRarityFromLevel(powerName, totalLevel)
        local rarityData = powerConfig.List[rIdx]
        
        if rarityData then
            local isMaxRarity = (rIdx == #powerConfig.List)
            local isAtMaxLevel = (curLvl >= maxLvl)
            local canEvolve = isAtMaxLevel and not isMaxRarity
            
            -- 1. HITUNG BONUS STAT
            local bonusValue = RarityPower.GetBuff(totalLevel)
            local bonusType = powerConfig.BonusType or "Power" -- Contoh: Damage, Mastery
            
            -- 2. IDENTIFIKASI MATA UANG & ICON
            local tokenKey = rarityData.TokenName
            local materialData = Materials[tokenKey]
            local tokenIcon = materialData and materialData.Template and GetIcon(materialData.Template) or ""
            local tokenDisplayName = materialData and materialData.Display or tokenKey

            -- 3. HITUNG BIAYA
            local cost = 0
            local actionName = "Upgrade"
            if canEvolve then
                cost = RarityPower.GetEvolveCost(powerName, rIdx)
                actionName = "Evolve"
            else
                cost = RarityPower.GetLevelUpCost(curLvl + 1)
            end

            -- 4. UPDATE VISUAL UI
            if toggle then
                local myTokenAmount = pData.Materials[tokenKey] or 0
                local statusColor = canEvolve and "#aa00ff" or "#07ffa4"
                
                -- Format Deskripsi: Bonus Stat + Status + Biaya dengan Icon
                local newDesc = string.format(
                    "Bonus %s: <font color='#f1c40f'>+%s%%</font>\n" ..
                    "Status: <font color='%s'><b>%s</b></font> (%s)\n" ..
                    "Level: %d/%d\n" ..
                    "Cost: %s/%s %s",
                    bonusType, Utils.ToText(bonusValue),
                    statusColor, actionName, rarityData.Name,
                    curLvl, maxLvl, Utils.ToText(cost), Utils.ToText(myTokenAmount),
                    tokenIcon
                )

                if Optimizer.Cache["RP_"..powerName] ~= newDesc then
                    toggle:SetDesc(newDesc)
                    
                    -- Update Gambar Utama Toggle sesuai Rarity
                    if toggle.SetMainImage then
                        toggle:SetMainImage({
                            Image = GetIcon(powerConfig.Template),
                            Quantity = rarityData.Name,
                            Title = powerName,
                            Gradient = GetGameGradient(rarityData.Name)
                        }, 60)
                    end
                    Optimizer.Cache["RP_"..powerName] = newDesc
                end
            end

            -- 5. EKSEKUSI OTOMATIS
            if Config["AutoRarityPower_" .. powerName] and not (isMaxRarity and isAtMaxLevel) then
                local myToken = pData.Materials[tokenKey] or 0
                if myToken >= (cost or 0) then
                    pcall(function()
                        -- Remote sesuai decompile
                        Reply.To("Upgrade Rarity Power", powerName)
                    end)
                    local now = os.time()
                    local hookKey = "RarityPower_" .. powerName
                    if not LastWebhookTime[hookKey] or (now - LastWebhookTime[hookKey]) >= 5 then
                        SendUpgradeWebhook("Rarity Powers", powerName .. " (" .. actionName .. ")", totalLevel + 1, cost)
                        LastWebhookTime[hookKey] = now
                    end
                    task.wait(0.5)
                end
            end
        end
    end
end
function Optimizer.Update_AvatarCurse_Logic(pData)
    if not pData.AvatarCurses or not pData.Attributes or not AvatarCurses then return end
    
    local currentAvatar = pData.Attributes.Avatar
    local isAvatarActive = currentAvatar and currentAvatar ~= "" and currentAvatar ~= "None"
    
    -- [1] LOGIKA VIEWPORT (3D PREVIEW)
    if isAvatarActive then
        if Optimizer.Cache.LastCurseAvatarID ~= currentAvatar then
            Optimizer.Cache.LastCurseAvatarID = currentAvatar
            local modelPath = ReplicatedFirst.Assets.Enemies:FindFirstChild(currentAvatar)
            
            if CurseStatusPara and modelPath then
                local modelClone = modelPath:Clone()
                local orientation, size = modelClone:GetBoundingBox()
                modelClone:PivotTo(CFrame.new(-orientation.Position)) 
                CurseStatusPara:SetViewport(modelClone)
                
                local vp = CurseStatusPara.ViewportFrame
                if vp and vp.CurrentCamera then
                    local dist = size.Magnitude * 0.8 
                    vp.CurrentCamera.CFrame = CFrame.lookAt(Vector3.new(0, 0.2, -dist), Vector3.new(0, 0, 0))
                end
            end
        end
    else
        if Optimizer.Cache.LastCurseAvatarID ~= nil then
            Optimizer.Cache.LastCurseAvatarID = nil
            if CurseStatusPara.ViewportFrame then CurseStatusPara.ViewportFrame:Destroy() end
        end
    end

    -- [2] UPDATE TEKS STATUS KUTUKAN (PARAGRAPH)
    -- Ambil indeks kutukan dan pastikan dikonversi ke Number agar valid saat mencari di Table
    local curseRawIndex = pData.AvatarCurses[currentAvatar]
    local curseIndex = tonumber(curseRawIndex) or 0
    local curseData = AvatarCurses.Table[curseIndex]
    
    local rarity = curseData and curseData.Rarity or "Common"
    local curseTitle = curseData and curseData.Display or "No Curse"
    
    local statusLines = {}
    if curseData then
        -- Buffs (Hijau: RGB 165, 255, 149)
        if curseData.Buff then
            for stat, val in pairs(curseData.Buff) do
                table.insert(statusLines, string.format("<font color='rgb(165, 255, 149)'>+%s%% %s</font>", tostring(val), tostring(stat)))
            end
        end
        -- Debuffs (Pink: RGB 255, 152, 152)
        if curseData.Debuff then
            for stat, val in pairs(curseData.Debuff) do
                table.insert(statusLines, string.format("<font color='rgb(255, 152, 152)'>-%s%% %s</font>", tostring(val), tostring(stat)))
            end
        end
    end

    local finalParaDesc = #statusLines > 0 and table.concat(statusLines, "\n") or "No active effects."
    
    -- Cache Hash ditingkatkan dengan menyertakan Nama Avatar agar saat ganti avatar UI langsung update
    local currentVisualHash = tostring(currentAvatar) .. curseTitle .. finalParaDesc
    
    if Optimizer.Cache.LastCurseTextHash ~= currentVisualHash then
        CurseStatusPara:SetTitle(curseTitle .. " [" .. rarity .. "]")
        CurseStatusPara:SetDesc(finalParaDesc)
        
        if CurseStatusPara.SetMainImage then
            CurseStatusPara:SetMainImage({
                Image = GetIcon(84366761557806),
                Gradient = GetGameGradient(rarity),
                Title = curseTitle,
                Quantity = rarity
            }, 50)
        end
        Optimizer.Cache.LastCurseTextHash = currentVisualHash
    end

    -- [3] UPDATE DESKRIPSI TOGGLE (INFO MATERIAL & BIAYA)
    if CurseAutoToggle then
        local tokenKey = AvatarCurses.TokenName
        local matInfo = Materials[tokenKey]
        
        local multi = pData.Gamepasses.Vip and 0.8 or 1
        local cost = AvatarCurses.TokenCost * multi
        local owned = pData.Materials[tokenKey] or 0
        
        local matIcon = (matInfo and matInfo.Template) and GetIcon(matInfo.Template) or ""
        local matName = matInfo and matInfo.Display or tokenKey
        
        local toggleDesc = string.format("%s %s: %s / %s", 
            matIcon, matName, Utils.ToText(cost), Utils.ToText(owned))
        
        if Optimizer.Cache.LastCurseToggleDesc ~= toggleDesc then
            CurseAutoToggle:SetDesc(toggleDesc)
            Optimizer.Cache.LastCurseToggleDesc = toggleDesc
        end
    end

    -- [4] EKSEKUSI AUTO ROLL (LOGIKA FILTER PERBAIKAN)
    if Config.AutoRollCurse and isAvatarActive then
        local isTargetReached = false
        if Config.TargetCursesFilter and #Config.TargetCursesFilter > 0 then
            for _, target in pairs(Config.TargetCursesFilter) do
                local targetIdx = tonumber(type(target) == "table" and target.Value or target)
                if curseIndex == targetIdx then
                    isTargetReached = true
                    break
                end
            end
        end

        if isTargetReached then
            Config.AutoRollCurse = false
            if CurseAutoToggle then CurseAutoToggle:Set(false) end
            Notify("Avatar Curse", "Target reached! Auto roll stopped.", "check")
        else
            local multi = pData.Gamepasses.Vip and 0.8 or 1
            local cost = AvatarCurses.TokenCost * multi
            local owned = pData.Materials[AvatarCurses.TokenName] or 0
            
            if owned >= cost and Reliable then
                Reply.To("Avatar Curse Roll")
                task.wait(1)
            end
        end
    end
end

function Optimizer.Update_EnergyUpgrade_Logic(pData)
    -- Pastikan module terload dan user adalah Premium
    if not EnergyUpgrade or not IsPremium then
        if Config.AutoEnergyUpgrade then Config.AutoEnergyUpgrade = false end
        if EnergyUpgradeToggle then
            pcall(function() 
                EnergyUpgradeToggle:Set(false)
                if not IsPremium then EnergyUpgradeToggle:Lock("Need Premium User") end
            end)
        end
        return
    end

    -- Ambil Data dari PlayerData
    -- Berdasarkan decompile, index level biasanya sama dengan nama sistemnya
    local currentLvl = pData.EnergyUpgrade or 0 
    
    -- Ambil Data Langsung dari Module (Modular)
    local maxLvl = EnergyUpgrade.MAX
    local tokenKey = EnergyUpgrade.TOKEN_NAME
    local displayName = EnergyUpgrade.Display
    local imageId = EnergyUpgrade.ImageId
    
    -- Ambil Kalkulasi dari Fungsi Module
    local cost = EnergyUpgrade.GetEvolveCost(EnergyUpgrade, currentLvl)
    local bonusText = EnergyUpgrade.GetDisplayBonus(currentLvl)
    
    local myTokens = pData.Materials and pData.Materials[tokenKey] or 0
    local matInfo = Materials[tokenKey]
    local matIcon = matInfo and matInfo.Template and GetIcon(matInfo.Template) or ""
    local matName = matInfo and matInfo.Display or tokenKey

    local isMaxed = currentLvl >= maxLvl
    local newTitle = ""
    local newDesc = ""

    if isMaxed then
        newTitle = displayName .. " [MAX]"
        newDesc = string.format("<b>Maximum Level Reached</b>\nTotal Buff: <font color='#d667ff'>%s</font>", bonusText)
        
        if not EnergyUpgradeToggle.Locked then
            EnergyUpgradeToggle:Lock("Max level reached")
            Config.AutoEnergyUpgrade = false
            EnergyUpgradeToggle:Set(false)
        end
    else
        newTitle = string.format("%s [%d/%d]", displayName, currentLvl, maxLvl)
        newDesc = string.format(
            "Current Bonus: <font color='#d667ff'>%s</font>\n" ..
            "%s%s %s / %s",
            bonusText,
            matIcon, matName, Utils.ToText(cost), Utils.ToText(myTokens)
        )
        
        if EnergyUpgradeToggle.Locked then EnergyUpgradeToggle:Unlock() end
    end

    -- Update UI dengan Cache (Optimasi Performa)
    local cacheKey = "EnergyUp_Modular_Status"
    if Optimizer.Cache[cacheKey] ~= newDesc then
        EnergyUpgradeToggle:SetTitle(newTitle)
        EnergyUpgradeToggle:SetDesc(newDesc)
        
        if EnergyUpgradeToggle.SetMainImage then
            EnergyUpgradeToggle:SetMainImage({
                Image = GetIcon(imageId),
                Quantity = "Lv." .. currentLvl,
                Title = displayName,
                Gradient = GetGameGradient("Rare") 
            }, 60)
        end
        Optimizer.Cache[cacheKey] = newDesc
    end

    -- Logika Eksekusi Auto Upgrade
    if Config.AutoEnergyUpgrade and not isMaxed then
        if myTokens >= cost then
            if Reliable then
                pcall(function()
                    -- Mengirim remote sesuai instruksi decompile Interface.c
                    Reply.To("Evolve EnergyUpgrade")
                end)
                
                -- Anti-spam delay
                task.wait(0.5) 
            end
        end
    end
end
function Optimizer.Update_HunterUpgrade_Logic(pData)
    -- Pastikan module terload dan user adalah Premium
    if not HunterUpgrade or not IsPremium then
        if Config.AutoHunterUpgrade then Config.AutoHunterUpgrade = false end
        if HunterUpgradeToggle then
            pcall(function() 
                HunterUpgradeToggle:Set(false)
                if not IsPremium then HunterUpgradeToggle:Lock("Need Premium User") end
            end)
        end
        return
    end

    -- Ambil Data dari PlayerData (Biasanya HunterUpgrade atau Hunter)
    local currentLvl = pData.HunterUpgrade or pData.Hunter or 0 
    
    -- Ambil Data Langsung dari Module (Modular)
    local maxLvl = HunterUpgrade.MAX or 100
    local tokenKey = HunterUpgrade.TOKEN_NAME or "HunterToken"
    local displayName = HunterUpgrade.Display or "Hunter Upgrade"
    local imageId = HunterUpgrade.ImageId or 84366761557806
    
    -- Ambil Kalkulasi dari Fungsi Module
    local cost = 0
    if HunterUpgrade.GetEvolveCost then cost = HunterUpgrade.GetEvolveCost(HunterUpgrade, currentLvl)
    elseif HunterUpgrade.GetCost then cost = HunterUpgrade.GetCost(currentLvl) end

    local bonusText = ""
    if HunterUpgrade.GetDisplayBonus then bonusText = HunterUpgrade.GetDisplayBonus(currentLvl)
    elseif HunterUpgrade.GetBuff then bonusText = tostring(HunterUpgrade.GetBuff(currentLvl)) end
    
    local myTokens = pData.Materials and pData.Materials[tokenKey] or 0
    local matInfo = Materials[tokenKey]
    local matIcon = matInfo and matInfo.Template and GetIcon(matInfo.Template) or ""
    local matName = matInfo and matInfo.Display or tokenKey

    local isMaxed = currentLvl >= maxLvl
    local newTitle = ""
    local newDesc = ""

    if isMaxed then
        newTitle = displayName .. " [MAX]"
        newDesc = string.format("<b>Maximum Level Reached</b>\nTotal Buff: <font color='#d667ff'>%s</font>", bonusText)
        
        if not HunterUpgradeToggle.Locked then
            HunterUpgradeToggle:Lock("Max level reached")
            Config.AutoHunterUpgrade = false
            HunterUpgradeToggle:Set(false)
        end
    else
        newTitle = string.format("%s [%d/%d]", displayName, currentLvl, maxLvl)
        newDesc = string.format(
            "Current Bonus: <font color='#d667ff'>%s</font>\n" ..
            "%s%s %s / %s",
            bonusText,
            matIcon, matName, Utils.ToText(cost), Utils.ToText(myTokens)
        )
        
        if HunterUpgradeToggle.Locked then HunterUpgradeToggle:Unlock() end
    end

    -- Update UI dengan Cache
    local cacheKey = "HunterUp_Modular_Status"
    if Optimizer.Cache[cacheKey] ~= newDesc then
        HunterUpgradeToggle:SetTitle(newTitle)
        HunterUpgradeToggle:SetDesc(newDesc)
        
        if HunterUpgradeToggle.SetMainImage then
            HunterUpgradeToggle:SetMainImage({
                Image = GetIcon(imageId),
                Quantity = "Lv." .. currentLvl,
                Title = displayName,
                Gradient = GetGameGradient("Rare") 
            }, 60)
        end
        Optimizer.Cache[cacheKey] = newDesc
    end

    -- Logika Eksekusi Auto Upgrade
    if Config.AutoHunterUpgrade and not isMaxed then
        if myTokens >= cost then
            if Reliable then
                pcall(function()
                    -- Remote sesuai dengan instruksi Anda
                    Reply.To("Evolve Hunter")
                end)
            end
        end
    end
end
function Optimizer.Update_AutoUnlock_Logic(pData)
    -- Pastikan fitur aktif dan data dasar tersedia 
    if not Config.AutoUnlockRolls or not Reliable or not pData.Attributes or not pData.Unlocked then return end

    local currentYen = pData.Attributes.Yen or 0 --

    -- Melakukan looping berdasarkan data yang diambil dari modul game
    for itemName, cost in pairs(UnlocksPrices) do
        -- 1. Lewati jika fitur bersifat Quest
        if type(cost) == "string" and cost == "Quest" then continue end

        -- 2. Cek apakah saldo Yen Anda mencukupi
        if currentYen >= cost then
            local isLocked = false
            
            -- Cek di tabel Unlocked (untuk YenUpgrades2, Mages, dll)
            if not pData.Unlocked[itemName] then
                isLocked = true
            end

            -- 3. Eksekusi jika terdeteksi masih terkunci
            if isLocked then
                pcall(function()
                    -- Mengirim remote "Try Unlock" dengan argumen tabel nama fitur
                    Reply.To("Try Unlock", itemName)
                end)
                break 
            end
        end
    end
end
-- Tambahkan fungsi ini ke dalam tabel Optimizer
function Optimizer.Update_YenUpgrade2_Logic(pData)
    -- Memastikan data YenUpgrades2 ada di PlayerData
    if pData.YenUpgrades2 then
        local yenIcon = GetIcon(139379806755218) -- Menggunakan icon Yen yang sama
        
        -- Memanggil fungsi helper generic yang sudah ada di baris 782 skrip Anda
        Optimizer.GenericUpgradeLogic(
            YenUpgrades2.Config,   -- List Config Tier 2
            pData.YenUpgrades2,          -- Data Level Player Tier 2
            YenUpgrades2,           -- Module Tier 2 (untuk hitung cost/buff)
            YenUpgrade2ToggleUI,         -- UI Toggle Tier 2
            "AutoYen2_",                 -- Prefix Flag Config
            "Yen Upgrade 2",             -- Nama Remote Event sesuai decompile
            (pData.Attributes.Yen or 0), -- Jumlah Yen player saat ini
            yenIcon                      -- Icon Yen
        )
    end
end
function Optimizer.Update_Relics_Logic(pData)
    -- [FIX] Pastikan data valid
    if not RelicsConfig or not pData then return end
    
    local RelicsOwned = pData.Relics or {}
    local QuestsData = pData.Quests or {}
    local MaterialsOwned = pData.Materials or {}
    local EquippedRelics = pData.EquippedRelics or {} 
    
    -- Helper Format Bonus
    local function FormatBonus(bTable)
        if not bTable then return "None" end
        local parts = {}
        for k, v in pairs(bTable) do
            local valStr = (Utils and Utils.ToText) and Utils.ToText(v) or tostring(v)
            table.insert(parts, string.format("%s: +%s%%", k, valStr))
        end
        return table.concat(parts, ", ")
    end

    for id, info in pairs(RelicToggles) do
        local toggle = info.UI
        local data = info.Data
        local strID = tostring(id) 
        
        local currentLvl = RelicsOwned[strID] 
        local maxLvl = data.MaxLevel or 10
        local rarity = data.Rarity or "Common"
        
        -- Warna Teks HTML untuk Deskripsi
        local rColor = "#ffffff"
        if rarity == "Celestial" then rColor = "#00ffff"      -- Cyan
        elseif rarity == "Legend" then rColor = "#ffaa00"     -- Emas
        elseif rarity == "Epic" then rColor = "#aa00ff"       -- Ungu
        elseif rarity == "Rare" then rColor = "#00aaff"       -- Biru
        elseif rarity == "Uncommon" then rColor = "#00ff00"   -- Hijau
        end
        
        local newTitle = ""
        local newDesc = ""
        local isMaxed = false
        local isOwned = (currentLvl ~= nil)
        
        -- Variabel untuk SetMainImage
        local imageQuantityText = rarity -- Default: Menampilkan Rarity (misal: "Legendary")
        
        -- [STATUS 1: QUEST MODE]
        if not isOwned then
            local questKey = "Relic_" .. strID
            local myQuest = QuestsData[questKey]
            local req = data.Quest and data.Quest.Required or 1
            local prog = (myQuest and myQuest.Progress) or 0
            
            local pct = math.clamp(prog / req, 0, 1)
            local pctTxt = math.floor(pct * 100) .. "%"
            
            newTitle = string.format("%s [<font color='%s'>%s</font>]", data.Display, rColor, rarity)
            
            local firstBonus = FormatBonus(data.Bonuses and data.Bonuses[1])
            
            if not myQuest then
                newDesc = string.format("Status: <font color='#ff4444'>Not Started</font>\nTarget: %s\nReward: <font color='#00aaff'>%s</font>", data.Quest.Description or "?", firstBonus)
                imageQuantityText = "LOCKED"
            elseif prog >= req then
                newDesc = string.format("Progress: <font color='#00ff00'>100%%</font> (COMPLETED)\nStatus: <font color='#00ff00'>CLAIM READY!</font>")
                imageQuantityText = "CLAIM!"
            else
                newDesc = string.format("Target: %s\nProgress: <font color='#00aaff'>%s</font> (%s / %s)\nStatus: Farming...",data.Quest.Description, pctTxt, prog, req)
                imageQuantityText = pctTxt -- Menampilkan Persen di gambar
            end
            
            if Config["AutoRelic_" .. strID] and Reliable then
                local now = os.time()
                if not Optimizer.Cache["RelicQuest_"..strID] or (now - Optimizer.Cache["RelicQuest_"..strID]) > 2 then
                    if not myQuest or (prog >= req) then
                        Reply.To("Start Relics Quest", strID)
                        Optimizer.Cache["RelicQuest_"..strID] = now
                    end
                end
            end

        -- [STATUS 2: UPGRADE MODE]
        else
            local currentBonusStr = FormatBonus(data.Bonuses and data.Bonuses[currentLvl])
            local isEquipped = (EquippedRelics[strID] == true)
            local equipStatus = isEquipped and " <font color='#00ff00'>[EQUIPPED]</font>" or ""
            
            -- Update Label Gambar jika Equip/Max
            if isEquipped then imageQuantityText = "EQUIPPED" end

            if currentLvl >= maxLvl then
                isMaxed = true
                if not isEquipped then imageQuantityText = "MAX" end -- Prioritas Equip label
                
                newTitle = string.format("%s [MAX]%s", data.Display, equipStatus)
                newDesc = string.format("<font color='%s'>%s</font>\n<b>Max Level Reached</b>\n\nActive Bonus:\n<font color='#00ff00'>%s</font>", rColor, rarity, currentBonusStr)
            else
                newTitle = string.format("%s [Lv %d]%s", data.Display, currentLvl, equipStatus)
                local nextLvl = currentLvl + 1
                local nextBonusStr = FormatBonus(data.Bonuses and data.Bonuses[nextLvl])
                local costData = data.Costs and data.Costs[currentLvl]
                local costStrLines = {}
                local canAfford = true
                
                if costData then
                    for matName, amount in pairs(costData) do
                        local myMat = MaterialsOwned[matName] or 0
                        local matDisplay = matName
                        if Materials[matName] then matDisplay = Materials[matName].Display end
                        local color = (myMat >= amount) and "#ffffff" or "#ff4444"
                        table.insert(costStrLines, string.format("• %s<font color='%s'>%s: %s/%s</font>", GetIcon(Materials[matName].Template), color, matDisplay, Utils.ToText(amount), Utils.ToText(myMat)))
                        if myMat < amount then canAfford = false end
                    end
                else
                    table.insert(costStrLines, "Free / No Cost")
                end
                
                newDesc = string.format("<font color='%s'>%s</font>\nCurrent: <font color='#00ff00'>%s</font>\nNext: <font color='#00aaff'>%s</font>\n\n<b>Upgrade Cost:</b>\n%s", rColor, rarity, currentBonusStr, nextBonusStr, table.concat(costStrLines, "\n"))
                
                if Config["AutoRelic_" .. strID] and canAfford and Reliable then
                    local now = os.time()
                    if not Optimizer.Cache["RelicUp_"..strID] or (now - Optimizer.Cache["RelicUp_"..strID]) > 1 then
                        Reply.To("Upgrade Relics", strID)
                        Optimizer.Cache["RelicUp_"..strID] = now
                    end
                end
            end
        end
        
        -- [[ VISUAL UPDATE & CACHE ]] --
        local cacheKey = "RelicUI_" .. strID
        local cacheData = Optimizer.Cache[cacheKey] or {}
        
        -- 1. Update Teks Judul & Deskripsi
        if cacheData.Title ~= newTitle then toggle:SetTitle(newTitle) end
        if cacheData.Desc ~= newDesc then toggle:SetDesc(newDesc) end
        
        -- 2. Update SetMainImage (Gradient & Icon)
        -- Kita buat "VisualHash" agar tidak spam update image (bikin kedip/lag)
        local currentVisualHash = string.format("%s|%s", rarity, imageQuantityText)
        
        if cacheData.VisualHash ~= currentVisualHash then
            if toggle.SetMainImage then
                toggle:SetMainImage({
                    Image = GetIcon(data.Template), -- Icon Item
                    Gradient = GetGameGradient(rarity), -- Gradient Rarity (Legend/Epic/dll)
                }, 60)
            end
            cacheData.VisualHash = currentVisualHash
        end
        
        -- 3. Lock jika MAX dan user ingin mematikan auto
        if isMaxed and not cacheData.IsMaxed then
            toggle:Lock("Maxed")
            Config["AutoRelic_" .. strID] = false
            toggle:Set(false)
        end
        
        Optimizer.Cache[cacheKey] = {
            Title = newTitle, 
            Desc = newDesc, 
            IsMaxed = isMaxed, 
            VisualHash = currentVisualHash
        }
    end

    -- [AUTO EQUIP LOGIC]
    local targetEquipID = Config.AutoEquipRelicTarget
    if targetEquipID then
        targetEquipID = tostring(targetEquipID)
        if RelicsOwned[targetEquipID] then
            if not EquippedRelics[targetEquipID] then
                if Reliable then
                    local now = os.time()
                    if not Optimizer.Cache.LastRelicEquip or (now - Optimizer.Cache.LastRelicEquip) > 3 then
                        pcall(function() Reply.To("Equip Relics", targetEquipID) end)
                        if Notify then 
                            local rName = (RelicsConfig[targetEquipID] and RelicsConfig[targetEquipID].Display) or targetEquipID
                            Notify("Relics", "Auto Equipping: " .. rName, "shield")
                        end
                        Optimizer.Cache.LastRelicEquip = now
                    end
                end
            end
        end
    end
end
function Optimizer.Update_Achievements_Logic(pData)
    if not AchievementsConfig or not pData then return end
    
    -- Struktur Data Game:
    -- pData.Achievements["ID_Stage"] = true (Jika sudah diklaim)
    local myAchievements = pData.Achievements or {}
    
    local claimableQueue = {} -- Tabel penampung ID yang siap klaim
    local totalClaimable = 0
    local totalCompleted = 0
    local pendingDesc = {}
    
    -- Loop semua Achievement di Config
    for id, achData in pairs(AchievementsConfig) do
        -- Loop semua Stage di dalam Achievement tersebut
        if achData.List then
            for stageIdx, stageData in ipairs(achData.List) do
                local key = tostring(id) .. "_" .. tostring(stageIdx)
                
                -- Cek apakah SUDAH diklaim?
                if myAchievements[key] then
                    totalCompleted = totalCompleted + 1
                else
                    -- Jika BELUM, cek apakah Progress sudah 100% (>= 1)
                    local progress = 0
                    local success, err = pcall(function()
                        -- Menggunakan fungsi Progress asli dari game
                        if achData.Progress then
                            progress = achData.Progress(pData, stageData.Requirement)
                        end
                    end)
                    
                    if success and progress >= 1 then
                        -- Masukkan ke antrian klaim (Batching)
                        if not claimableQueue[tostring(id)] then
                            claimableQueue[tostring(id)] = {}
                        end
                        table.insert(claimableQueue[tostring(id)], stageIdx)
                        
                        totalClaimable = totalClaimable + 1
                        
                        -- Ambil nama untuk display (Cuma ambil 3 teratas biar ga spam teks)
                        if totalClaimable <= 3 then
                            table.insert(pendingDesc, "• " .. achData.Display .. " (Lv " .. stageIdx .. ")")
                        end
                    end
                end
            end
        end
    end
    
    -- Update UI Status
    if AchStatusPara then
        local statusText = ""
        if totalClaimable > 0 then
            statusText = string.format("<b>%d Rewards Available!</b>\n%s", totalClaimable, table.concat(pendingDesc, "\n"))
            if totalClaimable > 3 then statusText = statusText .. "\n...and more" end
        else
            statusText = string.format("All caught up!\nTotal Completed: %d", totalCompleted)
        end
        
        if Optimizer.Cache.LastAchDesc ~= statusText then
            AchStatusPara:SetDesc(statusText)
            Optimizer.Cache.LastAchDesc = statusText
        end
    end
    
    -- Eksekusi Auto Claim (Batch Send)
    if Config.AutoClaimAchievements and totalClaimable > 0 and Reliable then
        local now = os.time()
        -- Delay 3 detik agar tidak spam remote setiap frame
        if not Optimizer.Cache.LastAchClaim or (now - Optimizer.Cache.LastAchClaim) > 3 then
            pcall(function()
                -- Mengirim format tabel persis seperti decompiler: {[ID] = {Stage1, Stage2}}
                Reply.To("Collect Achievements", claimableQueue)
            end)
            Optimizer.Cache.LastAchClaim = now
        end
    end
end
function Optimizer.Update_TimeRewards_Logic(pData)
    if not TimeRewardsConfig or not pData then return end
    
    local DailyData = pData.DailyRewards or {}
    local WeeklyData = pData.WeeklyRewards or {}
    local Attr = pData.Attributes or {}
    local myDailyTime = Attr.DailyTime or 0
    local myWeeklyDay = Attr.WeeklyDay or 1
    
    -- [[ 1. CEK DAILY REWARDS ]] --
    local dailyToClaim = {}
    if TimeRewardsConfig.Daily then
        for id, info in pairs(TimeRewardsConfig.Daily) do
            local key = tostring(id)
            -- Cek apakah belum diklaim DAN waktu cukup
            if not DailyData[key] and (info.Timer - myDailyTime <= 0) then
                table.insert(dailyToClaim, id)
            end
        end
    end
    
    -- [[ 2. CEK WEEKLY REWARDS ]] --
    local weeklyToClaim = {}
    if TimeRewardsConfig.Weekly then
        for id, info in pairs(TimeRewardsConfig.Weekly) do
            local key = tostring(id)
            -- Cek apakah belum diklaim DAN hari cukup
            if not WeeklyData[key] and (id <= myWeeklyDay) then
                table.insert(weeklyToClaim, id)
            end
        end
    end
    
    -- [[ EKSEKUSI AUTO CLAIM ]] --
    if Config.AutoTimeRewards and Reliable then
        local now = os.time()
        -- Delay 5 detik biar aman
        if not Optimizer.Cache.LastTimeReward or (now - Optimizer.Cache.LastTimeReward) > 5 then
            local claimed = false
            
            if #dailyToClaim > 0 then
                pcall(function()
                    Reply.To("Collect Time Reward List", "Daily", dailyToClaim)
                end)
                if Notify then Notify("Rewards", "Claimed " .. #dailyToClaim .. " Daily Rewards!", "gift") end
                claimed = true
            end
            
            if #weeklyToClaim > 0 then
                pcall(function()
                    Reply.To("Collect Time Reward List", "Weekly", weeklyToClaim)
                end)
                if Notify then Notify("Rewards", "Claimed " .. #weeklyToClaim .. " Weekly Rewards!", "gift") end
                claimed = true
            end
            
            if claimed then
                Optimizer.Cache.LastTimeReward = now
            end
        end
    end
end
-- [[ METEOR EVENT LOGIC: ENEMY HUNTER ONLY ]] --
-- [[ METEOR EVENT LOGIC: SMART PRIORITY (NO GLITCH) ]] --
task.spawn(function()
    repeat task.wait() until shared.Reply and getgenv().EnemiesData

    local LastZoneBeforeMeteor = nil
    local IncandescentTargets = {} -- Daftar Target Prioritas
    
    -- Fungsi Pembantu: Cek apakah sedang ada target aktif
    local function HasActiveTarget()
        for uid, _ in pairs(IncandescentTargets) do
            return true -- Jika ketemu satu aja, berarti sedang sibuk
        end
        return false
    end

    -- 1. [TRACKING] DAFTAR TARGET
    shared.Reply.Connect("Enemy Incandescent", function(uid, isActive)
        if isActive then
            IncandescentTargets[uid] = true
        else
            IncandescentTargets[uid] = nil
        end
    end)

    shared.Reply.Connect("Enemy Die", function(uid)
        if IncandescentTargets[uid] then
            IncandescentTargets[uid] = nil
        end
    end)

    shared.Reply.Connect("Enemies Changed", function()
        IncandescentTargets = {}
    end)

    -- 2. [ACTION] LOOP PEMBURU (PRIORITAS TERTINGGI)
    task.spawn(function()
        while not Window.Destroyed do
            if Config.AutoMeteor then
                local enemiesData = getgenv().EnemiesData
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local humanoid = char and char:FindFirstChild("Humanoid")

                if hrp and humanoid and humanoid.Health > 0 then
                    -- Cari Target
                    local targetUID = nil
                    for uid, _ in pairs(IncandescentTargets) do
                        if enemiesData[uid] and enemiesData[uid].Alive then
                            targetUID = uid
                            break
                        else
                            IncandescentTargets[uid] = nil
                        end
                    end

                    local targetEnemy = targetUID and enemiesData[targetUID]

                    -- Kejar Target
                    if targetEnemy and targetEnemy.Root then
                        pcall(function()
                            local enemyRoot = targetEnemy.Root
                            local enemyPos = enemyRoot.Position
                            local enemyLook = enemyRoot.CFrame.LookVector
                            
                            local enemyScale = 1
                            if targetEnemy.DifficultConfig and targetEnemy.DifficultConfig.Scale then
                                enemyScale = targetEnemy.DifficultConfig.Scale
                            elseif targetEnemy.Config and targetEnemy.Config.Scale then
                                enemyScale = targetEnemy.Config.Scale
                            end

                            local baseHipHeight = 3.0 
                            local feetY = enemyPos.Y - (baseHipHeight * enemyScale)
                            local myTargetY = feetY + baseHipHeight
                            
                            local dirVector = Vector3.new(enemyLook.X, 0, enemyLook.Z).Unit 
                            local attackPos = enemyPos + (dirVector * 5) 
                            
                            local finalPos = Vector3.new(attackPos.X, myTargetY, attackPos.Z)
                            local lookAtPos = Vector3.new(enemyPos.X, myTargetY, enemyPos.Z)
                            
                            hrp.CFrame = CFrame.lookAt(finalPos, lookAtPos)
                            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                            if Reply and Reply.UnTo then
                                Reply.UnTo("Hit", {targetUID})
                            end
                        end)
                    end
                end
            end
            task.wait() 
        end
    end)

    -- 3. [EVENT] PINDAH MAP
    shared.Reply.Connect("Meteor Shower Started", function(zoneName)
        if Config.AutoMeteor then
            local currentMap = GetCurrentMapStatus()
            if currentMap ~= zoneName then
                if currentMap ~= "Unknown" and currentMap ~= "" then
                    LastZoneBeforeMeteor = currentMap
                end
                if Notify then Notify("Meteor", "Event started! OTW " .. zoneName, "zap") end
                if Reply and Reply.To then Reply.To("Zone Teleport", zoneName) end
            end
        end
    end)

    -- 4. [EVENT] METEOR SPAWN (DENGAN CEK PRIORITAS)
    shared.Reply.Connect("Meteor Spawn", function(impactPosition, zoneName)
        if Config.AutoMeteor then
            local fallDuration = shared.MeteorEvent and shared.MeteorEvent.METEOR_FALL_DURATION or 5
            
            -- Tunggu Durasi Jatuh
            task.wait(fallDuration)

            -- [[ BAGIAN PENTING: CEK PRIORITAS ]] --
            -- Sebelum teleport ke batu, cek dulu: Apakah ada musuh Incandescent?
            if HasActiveTarget() then
                -- Jika ada musuh, JANGAN teleport ke batu. 
                -- Biarkan Loop Pemburu (No. 2) yang mengurus pergerakan.
                return 
            end

            -- Jika TIDAK ADA musuh, baru kita teleport ke batu (Standby)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if root and impactPosition then
                root.CFrame = CFrame.new(impactPosition + Vector3.new(0, 5, 0))
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                task.wait(0.5) 
            end
        end
    end)

    -- 5. [EVENT] SELESAI
    shared.Reply.Connect("Meteor Shower Ended", function(zoneName)
        IncandescentTargets = {}
        if Config.AutoMeteor and LastZoneBeforeMeteor then
            if Notify then Notify("Meteor", "Event Ended. Returning...", "corner-up-left") end
            if Reply and Reply.To then Reply.To("Zone Teleport", LastZoneBeforeMeteor) end
            LastZoneBeforeMeteor = nil
        end
    end)
end)

function Optimizer.Update_ZoneQuest_Logic(pData)
    -- Pastikan Config aktif dan data pemain ada
    if not Config.AutoQuest or not pData then return end
    
    local Attr = pData.Attributes or {}
    local currentZone = Attr.Zone
    
    -- Pastikan kita ada di zona yang valid
    if not currentZone or not QuestsConfig[currentZone] then return end
    
    -- Cek status Quest saat ini
    -- Key format di data: "ZoneQuest_ZoneName" (Contoh: "ZoneQuest_Zone1")
    local questKey = "ZoneQuest_" .. currentZone
    local activeQuest = pData.Quests[questKey]
    
    local shouldInteract = false
    local statusText = ""
    
    if not activeQuest then
        -- KONDISI 1: Belum punya misi -> TERIMA (ACCEPT)
        -- Cek apakah sudah tamat semua misi di zona ini?
        local currentQuestIndex = (pData.ZoneQuests and pData.ZoneQuests[currentZone]) or 1
        local questList = QuestsConfig[currentZone].Quests
        
        if questList and questList[currentQuestIndex] then
            shouldInteract = true
            statusText = "Accepting New Quest..."
        end
        
    elseif activeQuest.Status == "Completed" then
        -- KONDISI 2: Misi Selesai -> KLAIM (CLAIM)
        shouldInteract = true
        statusText = "Claiming Reward..."
    end
    
    -- Eksekusi Remote (Hanya jika perlu interaksi)
    if shouldInteract and Reliable then
        pcall(function()
            Reply.To("Update Quest", "Zone")
        end)
    end
end

function Optimizer.Update_Titles_Logic(pData)
    local titleConfig = shared.Title
    if not titleConfig or not pData or not pData.Attributes then return end

    local currentIdx = pData.Attributes.Title or 0
    local currentYen = pData.Attributes.Yen or 0
    local maxIdx = #titleConfig

    local newTitleUI = "Title"
    local newDescUI = ""
    local isMaxed = false
    
    local targetNameForGradient = ""
    local targetColorSequence = nil

    -- [TRIK RAHASIA] Membuat Gradient Text untuk RichText HTML
    local function GetGradientText(text, colorData)
        if not text then return "Unknown" end
        if not colorData then return text end
        
        if typeof(colorData) == "ColorSequence" then
            local result = ""
            local len = string.len(text)
            if len == 0 then return "" end
            
            for i = 1, len do
                local char = string.sub(text, i, i)
                -- Abaikan spasi agar kalkulasi gradasi lebih akurat pada huruf
                if char == " " then
                    result = result .. char
                else
                    -- Hitung posisi huruf (0 sampai 1)
                    local alpha = (len > 1) and ((i - 1) / (len - 1)) or 0
                    local targetColor = colorData.Keypoints[1].Value
                    
                    -- Cari warna yang tepat di posisi alpha tersebut
                    for j = 1, #colorData.Keypoints - 1 do
                        local kp1 = colorData.Keypoints[j]
                        local kp2 = colorData.Keypoints[j + 1]
                        if alpha >= kp1.Time and alpha <= kp2.Time then
                            local percent = (alpha - kp1.Time) / (kp2.Time - kp1.Time)
                            targetColor = kp1.Value:Lerp(kp2.Value, percent)
                            break
                        end
                    end
                    
                    if alpha >= 1 then 
                        targetColor = colorData.Keypoints[#colorData.Keypoints].Value 
                    end
                    
                    -- Bungkus huruf dengan warna Hex hasil kalkulasi
                    result = result .. string.format("<font color='#%s'>%s</font>", targetColor:ToHex(), char)
                end
            end
            return result
            
        elseif typeof(colorData) == "Color3" then
            return string.format("<font color='#%s'>%s</font>", colorData:ToHex(), text)
        end
        
        return text
    end

    -- [FUNGSI HELPER] Format Bonus dengan Warna Kustom
    local function FormatBonus(bTable)
        if not bTable then return "<font color='#aaaaaa'>None</font>" end
        local parts = {}
        
        local customColors = {
            ["Mastery"] = "#d667ff", -- Ungu
            ["Yen"]     = "#f1c40f", -- Kuning
            ["Damage"]  = "#ff2b2b"  -- Merah
        }
        
        for k, v in pairs(bTable) do
            local cColor = customColors[k] or "#ffffff"
            table.insert(parts, string.format("<font color='%s'>%s: +%s%%</font>", cColor, k, Utils.ToText(v)))
        end
        return table.concat(parts, " | ")
    end

    if currentIdx >= maxIdx then
        -- KONDISI 1: SUDAH MAX TITLE
        isMaxed = true
        local currData = titleConfig[currentIdx]
        local currName = currData and currData.Display or "Maxed"
        
        -- Aplikasikan Trik Gradient Teks!
        local currNameGrad = GetGradientText(currName, currData and currData.Color)
        local currBonus = currData and FormatBonus(currData.Bonus) or "<font color='#aaaaaa'>None</font>"
        
        targetNameForGradient = currName
        targetColorSequence = currData and currData.Color
        
        newTitleUI = "Auto Buy Title [MAX]"
        newDescUI = string.format(
            "Current Title: <b>%s</b>\n" ..
            "Active Bonus: %s", 
            currNameGrad, currBonus
        )
    else
        -- KONDISI 2: BELUM MAX (BISA BELI NEXT TITLE)
        local currData = currentIdx > 0 and titleConfig[currentIdx] or nil
        local currName = currData and currData.Display or "None"
        local currNameGrad = GetGradientText(currName, currData and currData.Color)
        local currBonus = currData and FormatBonus(currData.Bonus) or "<font color='#aaaaaa'>None</font>"
        
        local nextIdx = currentIdx + 1
        local nextData = titleConfig[nextIdx]
        local nextName = nextData.Display or "Unknown"
        local nextNameGrad = GetGradientText(nextName, nextData.Color)
        
        local cost = nextData.Price or 0
        local nextBonus = FormatBonus(nextData.Bonus)

        targetNameForGradient = nextName
        targetColorSequence = nextData.Color

        local colorCost = (currentYen >= cost) and "#ffffff" or "#ff4444"
        local yenIcon = GetIcon(139379806755218)

        newDescUI = string.format(
            "Current: <b>%s</b>\n" ..
            "Active Bonus: %s\n\n" ..
            "Next: <b>%s</b>\n" ..
            "Next Bonus: %s\n\n" ..
            "Cost: %s<font color='%s'>%s/%s</font>", 
            currNameGrad, currBonus, nextNameGrad, nextBonus, yenIcon, colorCost, Utils.ToText(cost),Utils.ToText(currentYen)
        )

        -- LOGIKA AUTO BUY
        if Config.AutoTitle and currentYen >= cost and Reliable then
            pcall(function() Reply.To("BuyTitle", nextIdx) end)
        end
    end

    -- [UPDATE UI VISUAL] --
    if TitleToggle then
        local cKey = "TitleUIState"
        local cacheData = Optimizer.Cache[cKey] or {}
        
        if cacheData.Title ~= newTitleUI then TitleToggle:SetTitle(newTitleUI) end
        if cacheData.Desc ~= newDescUI then TitleToggle:SetDesc(newDescUI) end
        
        Optimizer.Cache[cKey] = {
            Title = newTitleUI, 
            Desc = newDescUI, 
            IsMaxed = isMaxed
        }
    end
end
-- MAIN GLOBAL LOOP TRIGGER
-- // OPTIMIZED MAIN LOOP //
task.spawn(function()
    local heavyTaskTick = 0
    
    while not Window.Destroyed do
        local pData = (getgenv()).PlayerData
        
        -- Cek apakah player sedang loading/teleport (Character ada di workspace?)
        local Char = LocalPlayer.Character
        local Root = Char and Char:FindFirstChild("HumanoidRootPart")
        
        if not pData then 
            ScanPlayerData() 
        elseif Root then -- Hanya jalan jika Karakter sudah spawn (tidak lagi loading zone)
            
            -- [TUGAS RINGAN] Update UI (Jalan setiap 0.5 - 1 detik)
            -- Ini aman dijalankan sering-sering karena hanya baca data memory
            pcall(Optimizer.Update_Main_Data_Logic, pData)
            pcall(Optimizer.Update_YenUpgrade2_Logic, pData)
            pcall(Optimizer.Update_Ascension_Logic, pData)
            pcall(Optimizer.Update_Enchantments_Logic, pData)
            pcall(Optimizer.Update_Reforge_Logic,pData)
            pcall(Optimizer.Update_Exchange_Logic, pData)
            pcall(Optimizer.Update_AutoUnlock_Logic, pData)
            pcall(Optimizer.Update_Roll_Logic, pData)
            pcall(Optimizer.Update_Craft_Logic, pData)
            pcall(Optimizer.Update_Trainer_Logic, pData)
            pcall(Optimizer.Update_Vault_Logic, pData)
            pcall(Optimizer.Update_Avatar_Logic, pData)
            pcall(Optimizer.Update_Heroes_Logic, pData)
            pcall(Optimizer.Update_MegaBoss_Logic, pData)
            pcall(Optimizer.Update_Gamemode_Dropdowns)
            pcall(Optimizer.Update_RarityPower_Logic, pData)
            pcall(Optimizer.Update_AvatarCurse_Logic, pData)
            pcall(Optimizer.Update_EnergyUpgrade_Logic, pData)
            pcall(Optimizer.Update_HunterUpgrade_Logic, pData)
            pcall(Optimizer.Update_Relics_Logic, pData)
            pcall(Optimizer.Update_Achievements_Logic, pData)
            pcall(Optimizer.Update_TimeRewards_Logic, pData)
            pcall(Optimizer.Update_ZoneQuest_Logic, pData)
            pcall(Optimizer.Update_Titles_Logic, pData)
            heavyTaskTick = heavyTaskTick + 1
            if heavyTaskTick >= 6 then -- 6 x 0.5 detik = 3 Detik
                pcall(Optimizer.Update_HiddenQuests_Logic, pData)
                heavyTaskTick = 0
            end
            
        end
        task.wait(0.05) -- Throttle Global
    end
end)
Window:SelectTab(FarmTab.Index);
