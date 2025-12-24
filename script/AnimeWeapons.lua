if game.PlaceId ~= 79189799490564 then
    return
end

repeat
    task.wait()
until game:IsLoaded()

loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

Players = game:GetService("Players")
Workspace = game:GetService("Workspace")
ReplicatedStorage = game:GetService("ReplicatedStorage")
ReplicatedFirst = game:GetService("ReplicatedFirst")
HttpService = game:GetService("HttpService")
RunService = game:GetService("RunService")
VirtualUser = game:GetService("VirtualUser")
LocalPlayer = Players.LocalPlayer
FolderPath = "ANUI/AnimeWeapons"
ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
ZoneDBFile = "Zone_Database.json"
Reliable = ReplicatedStorage:WaitForChild("Reply"):WaitForChild("Reliable")
UnReliable = ReplicatedStorage:WaitForChild("Reply"):WaitForChild("Unreliable")
ConfigsPath = ReplicatedStorage.Scripts.Configs
UtilsModule = require(ConfigsPath.Utility.Utils)
MaterialsModule = require(ConfigsPath.General.Materials)
YenModule = require(ConfigsPath.Machines.YenUpgrades)
TokenModule = require(ConfigsPath.Machines.TokenUpgrades)
RankModule = require(ConfigsPath.Machines.RankUp)
AvatarLevelsModule = require(ConfigsPath.Machines.AvatarLevels)
LevelUpModule = require(ConfigsPath.General.LevelUp)
MegaBossUpgradeModule = require(ReplicatedStorage.Scripts.Configs.Machines.MegaBoss)
MegaBossUpgradeConfig = MegaBossUpgradeModule.Upgrades
EnchantmentsConfig = require(ReplicatedStorage.Scripts.Configs.Machines.Enchantments)
TradeTokenInfo = MaterialsModule.TradeToken
YenUpgradeConfig = YenModule.Config
TokenUpgradeConfig = TokenModule.Config
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
    BossDeadCheck = 0
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
    TargetDefense = {},
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
function LoadDatabasesAndConfigs()
    local Cfg = ReplicatedStorage.Scripts.Configs
    local MZ = Cfg:FindFirstChild("MultipleZones") or Cfg:FindFirstChild("Multiple Zones")

    -- [A] LIST MODULE TUNGGAL
    -- Script akan mencoba load. Jika GAGAL, otomatis diisi table kosong {}
    local LoadList = {
        {Var = "HiddenQuestsData", Path = Cfg.CustomQuests.HiddenQuests, SubKey = "List"},
        {Var = "MegaBossConfig",   Path = Cfg.Machines.MegaBoss},
        {Var = "PotionsData",      Path = Cfg.General.Potions},
        {Var = "AccessoriesConfig",Path = MZ and MZ:FindFirstChild("Accessories")},
        {Var = "EnemiesConfig",    Path = MZ and MZ:FindFirstChild("Enemies")}
    }

    for _, item in ipairs(LoadList) do
        -- Default value adalah tabel kosong (Anti-Error jika gagal load/path tidak ketemu)
        local loadedContent = {} 

        if item.Path then
            local s, res = pcall(require, item.Path)
            if s and res then
                if item.SubKey and res[item.SubKey] then
                    loadedContent = res[item.SubKey]
                else
                    loadedContent = res
                end
            end
        end
        
        -- Masukkan ke variable global (Entah itu isi Config asli ATAU tabel kosong)
        getfenv()[item.Var] = loadedContent
    end

    -- [B] LIST FOLDER (WEAPONS & UPGRADES)
    -- Kita inisialisasi wadahnya dulu di sini agar bersih
    WeaponsModule = {}
    UpgradeModules = {}

    local function LoadFolder(folderObj, destinationTable, unpackContent)
        if not folderObj then return end
        for _, m in pairs(folderObj:GetChildren()) do
            if m:IsA("ModuleScript") then
                local s, d = pcall(require, m)
                if s and type(d) == "table" then
                    if unpackContent then
                        for k, v in pairs(d) do destinationTable[k] = v end
                    else
                        destinationTable[m.Name] = d
                    end
                end
            end
        end
    end

    -- Jalankan loader folder
    LoadFolder(MZ and MZ:FindFirstChild("Weapons"), WeaponsModule, true)
    LoadFolder(Cfg:FindFirstChild("RollGachaUpgrades"), UpgradeModules, false)
end

LoadDatabasesAndConfigs() -- Jalankan fungsi
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
    local ZoneCfg = require(ReplicatedStorage.Scripts.Configs.Zones)
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
ReplyPath = ReplicatedFirst.Scripts:WaitForChild("Reply.client")
success, ReplyModule = pcall(require, ReplyPath)

if success and ReplyModule and ReplyModule.Connect then
    local Listeners = debug.getupvalue(ReplyModule.Connect, 1)

    if type(Listeners) ~= "table" or not Listeners["Data Sync Setup"] then
        for _, uv in pairs(debug.getupvalues(ReplyModule.Connect)) do
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


-- [1] Load Config Tambahan (Zone & Enemies) untuk Display Name
ZonesConfig = ZonesConfig or {}

pcall(function()
    local ZonesMod = ReplicatedStorage.Scripts.Configs.Zones
    if ZonesMod then ZonesConfig = require(ZonesMod) end
end)

-- Helper: Get Display Name for Enemy
function GetEnemyDisplayName(enemyId)
    if EnemiesConfig and EnemiesConfig[enemyId] and EnemiesConfig[enemyId].Display then
        return EnemiesConfig[enemyId].Display
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

function SaveZoneConfig(zone, selectedItem)
    if not zone or zone == "" or zone == "Unknown" then return end
    if not selectedItem then return end
    
    local val = type(selectedItem) == "table" and selectedItem.Value or selectedItem
    local title = type(selectedItem) == "table" and selectedItem.Title or selectedItem
    
    if not val or val == "" then return end
    
    local savedEntry = {}
    local foundObj = nil
    for _, cached in ipairs(CurrentZoneEnemiesCache) do
        if cached.Value == val then
            foundObj = cached
            break
        end
    end
    
    if foundObj then
        savedEntry = foundObj
    else
        savedEntry = {
            Title = title,
            Value = val,
            Desc = "Saved"
        }
    end
    
    Config.SelectedEnemy = val
    Config.ZoneConfigurations[zone] = savedEntry

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

UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v=" .. math.random()))()

Window = UI:CreateWindow({
    Title = "AN Hub - Anime Weapons",
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
        URL = "https://discord.gg/cy6uMRmeZ",
        Note = "Premium Users are auto-verified!",
        SaveKey = true
    }
})

function GetAvatarTokenIcon()
    local tokenKey = AvatarLevelsModule.Token or "AvatarToken"
    local config = MaterialsModule[tokenKey]
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
        if category == "Materials" and MaterialsModule[itemId] then
            itemData = MaterialsModule[itemId]
        elseif category == "Weapons" and WeaponsModule[itemId] then
            itemData = WeaponsModule[itemId]
        elseif category == "Accessories" and AccessoriesConfig[itemId] then
            itemData = AccessoriesConfig[itemId]
        elseif category == "Potions" and PotionsData[itemId] then
            itemData = PotionsData[itemId]
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
                        elseif enemyObj.Data.Class == "MegaBoss" and MegaBossConfig.BossConfig then maxHp = MegaBossConfig.BossConfig.MaxHealth
                        elseif enemyObj.Config.MaxHealth then maxHp = enemyObj.Config.MaxHealth end

                        local rewards = {}
                        if enemyObj.Data.Class == "MegaBoss" and MegaBossConfig then
                            if MegaBossConfig.ChanceRewards then for k, v in pairs(MegaBossConfig.ChanceRewards) do rewards[k] = v end end
                            if MegaBossConfig.Rewards then for _, itemStr in ipairs(MegaBossConfig.Rewards) do rewards[itemStr] = 100 end end
                        else
                            if enemyObj.Config.ChanceReward then for k, v in pairs(enemyObj.Config.ChanceReward) do rewards[k] = v end end
                            rewards["Materials.AvatarToken"] = 5
                        end
                        
                        local rewardImages = GenerateCardRewards(rewards)

                        table.insert(uiList, {
                            Title = displayName .. " (" .. diff .. ")",
                            Value = displayName,
                            Desc = "HP: " .. UtilsModule.ToText(maxHp),
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
            Callback = function() setclipboard("https://discord.gg/cy6uMRmeZ") Notify("Discord", "Invite link copied to clipboard!", "geist:logo-discord") end
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
            Callback = function() setclipboard("https://discord.gg/cy6uMRmeZ") Notify("Discord", "Invite link copied to clipboard!", "geist:logo-discord") end
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
        if Config.AutoFarm or Config.AutoGamemode then
            
            -- [OPTIMASI PENTING] 
            -- Gunakan selisih waktu (os.time) agar logic ini hanya jalan setiap 2 detik.
            -- Ini mencegah spam remote event jika server sedang lag mengupdate data player.
            if (os.time() - LastAutoSettingCheck) > 2 then
                
                local Data = (getgenv()).PlayerData;
                
                if Data and Data.Settings and Reliable then
                    -- 1. Cek Setting Auto Click
                    if Data.Settings.AutoClick == false then
                        pcall(function()
                            Reliable:FireServer("Settings", {
                                "AutoClick",
                                true
                            });
                        end);
                    end;

                    -- 2. Cek Setting Auto Attack
                    if Data.Settings.AutoAttack == false then
                        pcall(function()
                            Reliable:FireServer("Settings", {
                                "AutoAttack",
                                true
                            });
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
    local fightingKeywords = {"Dungeon", "Raid", "Defense", "PirateTower", "ShadowGate"}

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
    
    while Config.AutoFarm do
        if Window.Destroyed then break end

        if currentTargetObj and currentTargetObj.Config and currentTargetObj.Config.Display ~= Config.SelectedEnemy then
            if not MegaBossState.IsActive then
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
                            if Reliable then
                                pcall(function() Reliable:FireServer("Zone Teleport", { MegaBossState.ReturnZone }) end)
                            end
                            MegaBossState.ReturnZone = nil
                        end
                    end
                end
            else
                currentTargetObj = nil
                task.wait(1)
                continue 
            end
        
        elseif Config.AutoMeteor and MeteorState.IsActive and MeteorState.Position then
            if not CheckIsFightingZone() then
                currentTargetObj = nil 
                task.wait(0.5)
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
            task.wait(1)
            continue
        end

        local isTargetStillAlive = false
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
            currentTargetObj = nil
        end

        if not currentTargetObj and not MegaBossState.IsActive then
            local targetName = Config.SelectedEnemy
            local liveData = getgenv().EnemiesData
            
            if targetName and liveData then
                local minDistance = math.huge
                local myPos = hrp.Position
                local potentialTarget = nil
                
                for uid, enemyObj in pairs(liveData) do
                    if enemyObj.Alive and enemyObj.Data and enemyObj.Config then
                        if enemyObj.Config.Display == targetName and (enemyObj.Data.Class == "Islands" or enemyObj.Data.Class == "MegaBoss") then
                            local hp = enemyObj.Data.Health or 0
                            
                            if hp > 0 and enemyObj.Root then
                                local enemyPos = enemyObj.Root.Position
                                local dist = (myPos - enemyPos).Magnitude
                                
                                if dist < minDistance then
                                    minDistance = dist
                                    potentialTarget = enemyObj
                                end
                            end
                        end
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
                local attackPos = enemyPos + (dirVector * 6)
                
                local finalPos = Vector3.new(attackPos.X, myTargetY, attackPos.Z)
                
                local lookAtPos = Vector3.new(enemyPos.X, myTargetY, enemyPos.Z)
                
                hrp.CFrame = CFrame.lookAt(finalPos, lookAtPos)
                
                if hrp.AssemblyLinearVelocity.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                end
                if LocalPlayer.UserId == 5465738868 then
                    UnReliable:FireServer("Hit", {currentTargetObj.Uid});
                end
            end)
        end
        -- KODE BARU (OPTIMIZED)
        if currentTargetObj then
            task.wait() -- Jika sedang lock musuh, butuh cepat (setiap frame) biar nempel
        else
            task.wait(0.1) -- Jika sedang MENCARI musuh, jangan spam loop. Cukup 10x per detik.
        end
    end
end
 
task.spawn(function()
    while not Window.Destroyed do
        local anyRollActive = false
        local pData = (getgenv()).PlayerData
        
        if pData and pData.Materials then
            for _, rollType in ipairs(AllRollTypes) do
                if Config["AutoRoll" .. rollType] then
                    anyRollActive = true
                    
                    local config = RollConfigs[rollType]
                    local cost = config and config.Cost or 1
                    local tokenKey = config and config.MaterialKey or (rollType .. "Token")
                    local currentCount = pData.Materials[tokenKey] or 0
                    
                    if currentCount >= cost then
                        if Reliable then
                            pcall(function()
                                Reliable:FireServer("Crate Roll Start", {
                                    rollType,
                                    false
                                })
                            end)
                        end
                        task.wait(1.5) 
                    end
                end
            end
        end
        
        if not anyRollActive then
            task.wait(1)
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
                setclipboard("https://discord.gg/cy6uMRmeZ");
            end
        }
    }
});
task.spawn(function()
    local API = "https://discord.com/api/v10/invites/cy6uMRmeZ?with_counts=true&with_expiration=true";
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
    ["Vault"] = "Auto Equipped Best Vault for battle/lobby",
    ["Avatar Level"] = "Upgrade Avatar Level, view stats and costs",
    ["Heroes Stats"] = "Reroll Heroes Stats, view stats and costs",
    ["Ascension"] = "You can exchange all your level progress to obtain boosts.",
    ["Enchantments"] = "Add Stats Enchantments To Your Weapon.",
    ["Weapon Reforging"] = "Reforge Tier 3 weapons to get +50% Mastery Boost (1 Hour process)",
    ["Exchange"] = "Exchange materials, preview tokens and calculate amounts",
    ["Rolls"] = "Auto roll various gachas and monitor material stock",
    ["Upgrade: Yen"] = "Upgrade Yen buff along with cost and effects",
    ["Upgrade: Token"] = "Upgrade Token buff with shards",
    ["Upgrade: Mega Boss"] = "Upgrade MegaBoss buff with shards",
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
        {Title="Secret Quests", Icon=GetIcon(104488852837942)},
        {Title="Vault", Icon=GetIcon(90798559571883)},
        {Title="Avatar Level", Icon=GetAvatarTokenIcon()}, -- Biarkan ini dynamic
        {Title="Heroes Stats", Icon=GetIcon(127892390350003)},-- Tambahkan di dalam FM_Category Options
        {Title="Ascension", Icon=GetIcon(84524784941090)},
        {Title="Enchantments", Icon=GetIcon(104488852837942)},
        {Title="Weapon Reforging", Icon=GetIcon(76533888574769)},
        {Title="Exchange", Icon=GetIcon(101595095661272)},
        {Title="Rolls", Icon=GetIcon(128047949460588)},
        {Title="Upgrade: Yen", Icon=GetIcon(139379806755218)},
        {Title="Upgrade: Token", Icon=GetIcon(124644932563791)},
        {Title="Upgrade: Mega Boss", Icon=GetIcon(73239911812292)},
        {Title="Rankup", Icon=GetIcon(111262536381336)},
        {Title="Trainers", Icon=GetIcon(92875014242960)},
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
    Multi = false,
    Values = {},
    ImageSize = UDim2.fromOffset(20, 20),
    ImagePadding = 6,
    Flag = "TargetEnemies_Cfg",
    Callback = function(selectedItem)
        if IsLoadingConfig then
            return;
        end;
        SaveZoneConfig(CurrentZoneName, selectedItem);
    end
});
FM_Add("Farm", EnemyDropdown);
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

-- [REVISI LOOP METEOR] - Tambahkan Logika Auto Hit
task.spawn(function()
    while not Window.Destroyed do
        if Config.AutoMeteor and MeteorState.IsActive and MeteorState.Position then
            if not CheckIsFightingZone() then
                local currentMap = GetCurrentMapStatus()
                
                if currentMap ~= MeteorState.Zone then
                    -- Teleport ke Zone Meteor
                    if not IsTeleporting then
                        if Reliable then
                            pcall(function() Reliable:FireServer("Zone Teleport", { MeteorState.Zone }) end)
                        end
                        IsTeleporting = true
                        task.wait(3)
                        IsTeleporting = false
                    end
                else
                    -- Sudah di Zone, cek apakah sudah mendarat
                    local timeLeft = MeteorState.LandTime - tick()
                    
                    if timeLeft <= 0 then
                        if hrp then
                            -- Teleport ke posisi meteor
                            local targetPos = MeteorState.Position + Vector3.new(0, 4, 0)
                            if (hrp.Position - targetPos).Magnitude > 5 then
                                hrp.CFrame = CFrame.new(targetPos)
                                hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                            end
                            
                            -- AUTO HIT METEOR (Mencari objek di Terrain)
                            for _, obj in pairs(workspace.Terrain:GetChildren()) do
                                -- Berdasarkan decompile, meteor adalah model/part yang baru muncul
                                if obj:IsA("BasePart") or obj:IsA("Model") then
                                    if (obj:GetPivot().Position - MeteorState.Position).Magnitude < 10 then
                                        -- Kirim Remote Hit (Gunakan Remote yang biasa dipakai farm)
                                        if UnReliable then
                                            UnReliable:FireServer("Hit", {obj}) 
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

MeteorToggle = FarmTab:Toggle({
    Title = "Auto Farm Meteor",
    Desc = "Auto teleport & wait for Meteor Event. Pauses normal farm.",
    Flag = "AutoMeteor_Cfg",
    Callback = function(val)
        Config.AutoMeteor = val
    end
});
FM_Add("Farm", MeteorToggle);
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

        local EnemiesFolder = Workspace:FindFirstChild("Enemies")
        local hasEnemies = EnemiesFolder and #EnemiesFolder:GetChildren() > 0
        local isFightingZone = (string.find(currentMap, ":") and (string.find(currentMap, "Dungeon") or string.find(currentMap, "Raid") or string.find(currentMap, "Defense") or currentMap == "PirateTower" or currentMap == "ShadowGate") or (currentMap == "PirateTower" or currentMap == "ShadowGate" or currentMap == "ChristmasRaid"))
        
        if currentMap == "Raid" then isFightingZone = true 
        elseif currentMap == "Defense" then isFightingZone = hasEnemies
        elseif currentMap == "PirateTower" or currentMap == "ShadowGate" then isFightingZone = true 
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
                
                if LastZone and LastZone ~= "" and LastZone ~= "Unknown" and not string.find(LastZone, ":") then
                    Notify("Mode Finished", "Returning to " .. LastZone);
                    if Reliable then pcall(function() Reliable:FireServer("Zone Teleport", { LastZone }); end); end;
                    wasInGamemode = false; 
                    task.wait(6);
                else
                    wasInGamemode = false;
                end;

            else
                -- [1] DEFINISI FUNGSI LOKAL (Sekarang di dalam blok else, tapi hanya dibuat sekali per iterasi loop)
                -- Tips: Idealnya fungsi ini ditaruh di LUAR while loop, tapi di sini juga aman.
                local function ProcessGameMode(prefix, dbList, selectedList, requiredKey, allowJoin, allowOpen)
                    if not selectedList or #selectedList == 0 then return false end
                    if not allowJoin and not allowOpen then return false end
                    
                    -- A. Siapkan Data Mode
                    local modesToCheck = {}
                    if not dbList then
                        -- Single Mode (Pirate/Shadow)
                        table.insert(modesToCheck, {ID = prefix, Name = prefix, RawPrefix = prefix, Phase = nil})
                    else
                        -- Multi Mode (Dungeon/Raid/Defense)
                        for _, selectedName in pairs(selectedList) do
                            if dbList[selectedName] then
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
                            if Reliable then Reliable:FireServer("Join Gamemode", { modeID }) end
                            return true
                        end

                        -- LOGIC CREATE
                        if requiredKey and allowOpen and not isOpened then
                            local pData = getgenv().PlayerData
                            local keyCount = (pData and pData.Materials and pData.Materials[requiredKey]) or 0
                            
                            if keyCount > 0 then
                                Notify("Auto Open", "Creating " .. modeData.Name .. " (Using Key)", "key")
                                if Reliable then 
                                    if modeData.Phase then
                                        Reliable:FireServer("Open Gamemode", { modeData.RawPrefix, modeData.Phase }) 
                                    else
                                        Reliable:FireServer("Open Gamemode", { modeID }) 
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
                    {ID="ChristmasRaid", DB=nil, Cfg=Config.TargetChristmas, Key="ChristmasModeKey", CanOpen=true},
                    {ID="PirateTower", DB=nil,       Cfg=Config.TargetPirateTower, Key="PirateTowerModeKey", CanOpen=true},
                    {ID="ShadowGate",  DB=nil,       Cfg=Config.TargetShadowGate,  Key="ShadowPortalModeKey",CanOpen=true},
                    {ID="Raid",        DB=raidDB,    Cfg=Config.TargetRaid,        Key="RaidModeKey",        CanOpen=true},
                    {ID="Defense",     DB=defenseDB, Cfg=Config.TargetDefense,     Key="DefenseModeKey",     CanOpen=true},
                    {ID="Dungeon",     DB=dungeonDB, Cfg=Config.TargetDungeon,     Key=nil,                  CanOpen=false}
                }

                for _, mode in ipairs(CheckList) do
                    -- Cek apakah mode ini boleh di-create (Config Global + Izin Mode)
                    local canCreate = (allowOpen and mode.CanOpen)
                    
                    if ProcessGameMode(mode.ID, mode.DB, mode.Cfg, mode.Key, allowJoin, canCreate) then
                        actionTaken = true
                        break -- Stop jika sudah join salah satu
                    end
                end

                if actionTaken then task.wait(5) else task.wait(1) end
            end;
        else
            task.wait(1);
        end;
    end;
end;

pirateTowerList = {}
function LoadPirateTowerData()
    local success, module = pcall(function()
        return require(ReplicatedStorage.Scripts.Configs.Gamemodes.PirateTower);
    end);
    if success and module then
        local hpBase = module.GetRecommendedPower(module.HealthBase) or 0
        local floors = module.MAX_FLOOR or 100
        local desc = "Max Floors: " .. floors .. " | HP Base: " .. UtilsModule.ToText(hpBase);
        local rewardCards = GenerateCardRewards(module.ChanceReward)

        pirateTowerList = {{
            Title = module.Display or "Pirate Tower",
            Value = "PirateTower",
            Desc = desc,
            Images = rewardCards
        }}
    end;
end;
LoadPirateTowerData();

shadowGateList = {}
function LoadShadowGateData()
    local success, module = pcall(function()
        return require(ReplicatedStorage.Scripts.Configs.Gamemodes.ShadowGate);
    end);
    if success and module then
        local hpBase = module.GetRecommendedPower(module.HealthBase) or 0
        local waves = module.MAX_WAVE or 500
        local desc = "Max Waves: " .. waves .. " | HP Base: " .. UtilsModule.ToText(hpBase);
        local rewardCards = GenerateCardRewards(module.ChanceReward)

        shadowGateList = {{
            Title = module.Display or "Shadow Gate",
            Value = "ShadowGate",
            Desc = desc,
            Images = rewardCards
        }}
    end;
end;
LoadShadowGateData();

-- [3. DUNGEON DATA]
function LoadDungeonData()
    local success, module = pcall(function()
        return require(ReplicatedStorage.Scripts.Configs.Gamemodes.Dungeon);
    end);
    if success and module and module.PHASES then
        dungeonList, dungeonDB = {}, {};
        for id, phase in ipairs(module.PHASES) do
            local rName = phase.Name;
            local hpCalc = module.GetRecommendedPower(phase.HealthBase);
            
            local times = phase.START_TIMES or {}
            table.sort(times)
            local desc = "HP: " .. UtilsModule.ToText(hpCalc);
            
            local rewardCards = GenerateCardRewards(phase.ChanceReward)

            table.insert(dungeonList, {
                Title = rName,
                Desc = desc,
                Value = rName,
                Images = rewardCards
            });
            dungeonDB[rName] = {
                ID = id,
                Times = phase.START_TIMES,
                BaseDesc = desc
            };
        end;
    end;
end;
LoadDungeonData();

-- [4. RAID DATA]
function LoadRaidData()
    local success, module = pcall(function()
        return require(ReplicatedStorage.Scripts.Configs.Gamemodes.Raid);
    end);
    if success and module and module.PHASES then
        raidList, raidDB = {}, {};
        for id, phase in ipairs(module.PHASES) do
            local rName = phase.Name;
            local hpCalc = module.GetRecommendedPower(phase.HealthBase);
            
            local times = phase.START_TIMES or {}
            table.sort(times)
            local timeStr = table.concat(times, ", ")
            local desc = "HP: " .. UtilsModule.ToText(hpCalc);
            
            local rewardCards = GenerateCardRewards(phase.ChanceReward)

            table.insert(raidList, {
                Title = rName,
                Desc = desc,
                Value = rName,
                Images = rewardCards
            });
            raidDB[rName] = {
                ID = id,
                Times = phase.START_TIMES,
                BaseDesc = desc
            };
        end;
    end;
end;
LoadRaidData();

function LoadDefenseData()
    local success, module = pcall(function()
        return require(ReplicatedStorage.Scripts.Configs.Gamemodes.Defense);
    end);
    if success and module and module.PHASES then
        defenseList, defenseDB = {}, {};
        for id, phase in ipairs(module.PHASES) do
            local rName = phase.Name;
            local hpCalc = module.GetRecommendedPower(phase.HealthBase);
            
            local times = phase.START_TIMES or {}
            table.sort(times)
            local timeStr = table.concat(times, ", ")
            local desc = "HP: " .. UtilsModule.ToText(hpCalc);

            local rewardCards = GenerateCardRewards(phase.ChanceReward)

            table.insert(defenseList, {
                Title = rName,
                Desc = desc,
                Value = rName,
                Images = rewardCards
            });
            defenseDB[rName] = {
                ID = id,
                Times = phase.START_TIMES,
                BaseDesc = desc
            };
        end;
    end;
end;
LoadDefenseData();
function LoadChristmasData()
    local success, module = pcall(function()
        return require(ReplicatedStorage.Scripts.Configs.Gamemodes.ChristmasRaid)
    end)
    
    if success and module then
        christmasList, christmasDB = {}, {}
        -- Gunakan "Christmas Raid" sebagai kunci tampilan, tapi pastikan ID internal sinkron
        local rName = "Christmas Raid" 
        
        local hpCalc = (module.HealthBase or 0) // 50
        local desc = "HP: " .. UtilsModule.ToText(hpCalc)
        local rewardCards = GenerateCardRewards(module.ChanceReward)

        table.insert(christmasList, {
            Title = rName,
            Desc = desc,
            Value = rName, -- Value ini harus sama dengan kunci di christmasDB
            Images = rewardCards
        })
        
        christmasDB[rName] = {
            ID = nil, -- Dikosongkan agar tidak menambah ":" pada string remote
            Times = module.START_TIMES or {0, 30},
            BaseDesc = desc
        }
    end
end
LoadChristmasData()
function BuildGameModesDropdownValues()
    local out = {}

    -- Helper local function
    local function AddList(prefix, list, useColon)
        if not list then return end
        for _, item in ipairs(list) do
            local rawVal = type(item) == "table" and (item.Value or item.Title) or tostring(item)
            local itemTitle = item.Title or rawVal
            
            -- FORMATTING PENTING:
            -- Jika useColon=true, jadinya "Dungeon:Room 1"
            -- Jika false, jadinya "PirateTower"
            local finalValue = useColon and (prefix .. ":" .. rawVal) or rawVal
            
            -- Title biarkan cantik (pakai spasi)
            local finalTitle = useColon and (prefix .. ": " .. itemTitle) or itemTitle

            if rawVal then
                table.insert(out, {
                    Title = finalTitle,
                    Value = finalValue, -- Value ini yang dipakai key update
                    Desc = item.Desc,
                    Images = item.Images
                })
            end
        end
    end

    -- Panggil dengan logic strict
    AddList("Dungeon", dungeonList, true)
    AddList("Raid", raidList, true)
    AddList("Defense", defenseList, true)
    if IsPremium then
        AddList("Christmas", christmasList, true)
    end
    AddList("", pirateTowerList, false) -- Pirate Tower tidak butuh prefix
    AddList("", shadowGateList, false)  -- Shadow Gate tidak butuh prefix

    return out
end

GameModesDrop = FM_Add("GameModes", FarmTab:Dropdown({
    Title = "Select GameModes",
    Multi = true,
    AllowNone = true,
    Flag = "GameModesList_Cfg",
    Values = BuildGameModesDropdownValues(),
    ImageSize = UDim2.fromOffset(20, 20),
    ImagePadding = 6,
    Callback = function(val)
        local dungeonT, raidT, defenseT, christmasT, pirateT, shadowT = {}, {}, {}, {}, {}, {}

        for _, v in pairs(val) do
            -- Ambil Value murni
            local raw = type(v) == "table" and v.Value or v
            
            if type(raw) == "string" then
                -- Cek format "Mode:Nama"
                local mode, name = raw:match("^([^:]+):(.+)$")
                
                if mode and name then
                    if mode == "Dungeon" then table.insert(dungeonT, name)
                    elseif mode == "Raid" then table.insert(raidT, name)
                    elseif mode == "Defense" then table.insert(defenseT, name)
                    elseif mode == "Christmas" then table.insert(christmasT, name)
                    end
                else
                    -- Handle Single Mode (tanpa titik dua)
                    if raw == "PirateTower" then table.insert(pirateT, "PirateTower")
                    elseif raw == "ShadowGate" then table.insert(shadowT, "ShadowGate")
                    end
                end
            end
        end
        Config.TargetChristmas = christmasT
        Config.TargetDungeon = dungeonT
        Config.TargetRaid = raidT
        Config.TargetDefense = defenseT
        Config.TargetPirateTower = pirateT
        Config.TargetShadowGate = shadowT
        
        -- Kita panggil optimizer manual sekali agar deskripsi langsung berubah saat diklik
        pcall(Optimizer.Update_Gamemode_Dropdowns)
    end
}));

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

LeaveGroup1 = FarmTab:Group({})
FM_Add("GameModes", LeaveGroup1)

LeaveGroup1:Input({
    Title = "Dungeon (Room)",
    Value = tostring(Config.AutoLeave_Dungeon or 50),
    Numeric = true,
    Flag = "Leave_Dungeon_Cfg",
    Callback = function(txt) Config.AutoLeave_Dungeon = tonumber(txt) or 50 end
})

LeaveGroup1:Input({
    Title = "Raid (Wave)",
    Value = tostring(Config.AutoLeave_Raid or 25),
    Numeric = true,
    Flag = "Leave_Raid_Cfg",
    Callback = function(txt) Config.AutoLeave_Raid = tonumber(txt) or 25 end
})

LeaveGroup2 = FarmTab:Group({})
FM_Add("GameModes", LeaveGroup2)

LeaveGroup2:Input({
    Title = "Defense (Wave)",
    Value = tostring(Config.AutoLeave_Defense or 30),
    Numeric = true,
    Flag = "Leave_Defense_Cfg",
    Callback = function(txt) Config.AutoLeave_Defense = tonumber(txt) or 30 end
})

LeaveGroup2:Input({
    Title = "Pirate Tower (Floor)",
    Value = tostring(Config.AutoLeave_PirateTower or 100),
    Numeric = true,
    Flag = "Leave_Pirate_Cfg",
    Callback = function(txt) Config.AutoLeave_PirateTower = tonumber(txt) or 100 end
})

LeaveGroup3 = FarmTab:Group({})
FM_Add("GameModes", LeaveGroup3)

LeaveGroup3:Input({
    Title = "Shadow Gate (Wave)",
    Value = tostring(Config.AutoLeave_ShadowGate or 50),
    Numeric = true,
    Flag = "Leave_Shadow_Cfg",
    Callback = function(txt) Config.AutoLeave_ShadowGate = tonumber(txt) or 50 end
})

LeaveGroup3:Toggle({
    Title = "Enable Auto Leave",
    Desc = "Master switch for auto leaving",
    Flag = "AutoLeave_Cfg",
    Callback = function(val)
        Config.AutoLeave = val
    end
})

task.spawn(function()
    while not Window.Destroyed do
        if Config.AutoLeave then
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
            -- Menggunakan jalur UI yang valid sesuai file Anda: PlayerGui.Screen.Hud.gamemode
            local HudGamemode = PlayerGui and PlayerGui:FindFirstChild("Screen") and PlayerGui.Screen:FindFirstChild("Hud") and PlayerGui.Screen.Hud:FindFirstChild("gamemode")
            
            if HudGamemode and HudGamemode.Visible then
                local currentVal = 0
                local targetLimit = 999999 -- Default tinggi agar tidak leave sembarangan
                local modeActive = false

                -- A. Cek DUNGEON
                local dungeonUI = HudGamemode:FindFirstChild("Dungeon")
                if dungeonUI and dungeonUI.Visible then
                    local txt = dungeonUI.room.amount.Text
                    currentVal = tonumber(string.match(txt, "%d+")) or 0
                    targetLimit = Config.AutoLeave_Dungeon
                    modeActive = true
                end

                -- B. Cek RAID
                if not modeActive then
                    local raidUI = HudGamemode:FindFirstChild("Raid")
                    if raidUI and raidUI.Visible then
                        local txt = raidUI.wave.amount.Text
                        currentVal = tonumber(string.match(txt, "%d+")) or 0
                        targetLimit = Config.AutoLeave_Raid
                        modeActive = true
                    end
                end

                -- C. Cek DEFENSE
                if not modeActive then
                    local defenseUI = HudGamemode:FindFirstChild("Defense")
                    if defenseUI and defenseUI.Visible then
                        local txt = defenseUI.wave.amount.Text
                        currentVal = tonumber(string.match(txt, "%d+")) or 0
                        targetLimit = Config.AutoLeave_Defense
                        modeActive = true
                    end
                end

                -- D. Cek PIRATE TOWER
                if not modeActive then
                    local pirateUI = HudGamemode:FindFirstChild("PirateTower")
                    if pirateUI and pirateUI.Visible then
                        local txt = pirateUI.floor.amount.Text
                        currentVal = tonumber(string.match(txt, "%d+")) or 0
                        targetLimit = Config.AutoLeave_PirateTower
                        modeActive = true
                    end
                end

                -- E. Cek SHADOW GATE
                if not modeActive then
                    local shadowUI = HudGamemode:FindFirstChild("ShadowGate")
                    if shadowUI and shadowUI.Visible then
                        local txt = shadowUI.wave.amount.Text
                        currentVal = tonumber(string.match(txt, "%d+")) or 0
                        targetLimit = Config.AutoLeave_ShadowGate
                        modeActive = true
                    end
                end

                -- [EKSEKUSI LEAVE]
                if modeActive and currentVal >= targetLimit then
                    -- Ambil LastZone yang aman
                    local pData = getgenv().PlayerData
                    local returnZone = (pData and pData.Attributes and pData.Attributes.LastZone) or "Starter Zone"
                    if string.find(returnZone, ":") or returnZone == "Unknown" then returnZone = "Starter Zone" end

                    if Reliable then
                        pcall(function()
                            Reliable:FireServer("Zone Teleport", { returnZone })
                        end)
                        
                        if Notify then 
                            Notify("Auto Leave", "Target Reached ("..currentVal.." / "..targetLimit..")! Leaving...") 
                        end
                        task.wait(5) -- Jeda biar ga spam
                    end
                end
            end
        end
        task.wait(1)
    end
end)
FM_OnChange("Farm")

GeneralTab = Window:Tab({
    Title = "General",
    Icon = "settings"
});

GeneralManagerSection = FarmTab
ExchangeList = {}

-- Membangun list item yang bisa ditukar (Exchangeable)
for k, v in pairs(MaterialsModule) do
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
    if not tokenKey or not MaterialsModule[tokenKey] then return 0.1 end
    if MaterialsModule[tokenKey].ExchangeRatio then
        val = MaterialsModule[tokenKey].ExchangeRatio
    elseif MaterialsModule[tokenKey].Display == "Trade Token" then
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
        local info = MaterialsModule[key]
        
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
            Desc = "Stock: " .. UtilsModule.ToText(currentAmount)
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
        local info = SelectedExToken and MaterialsModule[SelectedExToken] or nil
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
    Title = TradeTokenInfo.Display or "Trade Token",
    Desc = "Waiting...",
    Image = TradeTokenInfo.Template and GetIcon(TradeTokenInfo.Template) or "rbxassetid://128675466010249", -- Default Trade Token ID
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

        -- [LOGIKA REMOTE EVENT SESUAI DECOMPILE]
        -- Decompile: shared.Reply.To("Convert Tokens", var6_upvw, var8_upvw, var9_upvw)
        -- Arg 1: Action Name
        -- Arg 2: Token Key (String)
        -- Arg 3: Is Buying/Swap (Boolean)
        -- Arg 4: Amount Slider (0.0 - 1.0)
        
        local args = {
            "Convert Tokens",
            {
                SelectedExToken,    -- var6_upvw
                ExchangeIsBuying,   -- var8_upvw
                ExchangePercent     -- var9_upvw (Slider value)
            }
        }

        if Reliable then
            pcall(function()
                Reliable:FireServer(unpack(args))
            end)
            Notify("Exchange", "Request Sent!")
        end
    end
})
FM_Add("Exchange", ExchangeButton)

_rollGroup = nil
_rollCount = 0
for _, rollType in ipairs(AllRollTypes) do
    if _rollCount % 2 == 0 then
        _rollGroup = GeneralManagerSection:Group({});
        FM_Add("Rolls", _rollGroup)
    end;
    local tokenKey = (RollConfigs[rollType] and RollConfigs[rollType].MaterialKey) or (rollType .. "Token");
    local displayName = (MaterialsModule[tokenKey] and MaterialsModule[tokenKey].Display) or rollType;
    local currentCount = (((getgenv()).PlayerData and (getgenv()).PlayerData.Materials) and (getgenv()).PlayerData.Materials[tokenKey]) or 0;
    local configFlag = "AutoRoll" .. rollType;
    local myToggle = _rollGroup:Toggle({
        Title = rollType,
        Flag = configFlag .. "_Cfg",
        Desc = displayName .. ": " .. UtilsModule.ToText(currentCount),
        Image = GetRollIconAsset(rollType),
        ImageSize = 24,
        Callback = function(val)
            Config[configFlag] = val;
        end
    });
    RollToggleUI[rollType] = myToggle;
    _rollCount = _rollCount + 1;
end;

GeneralTab:Toggle({
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
                    if Reliable then
                        pcall(function()
                            Reliable:FireServer("Weapon Fuse All");
                        end);
                    end;
                    task.wait(5);
                end;
            end);
        end;
    end
});

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
upgradeOrder = {"Luck", "Damage", "Yen", "Mastery", "Critical"}
CreateUpgradeSection(FarmTab, "Upgrade: Yen", YenUpgradeConfig, "AutoYen_", YenUpgradeToggleUI, upgradeOrder)
if TokenUpgradeConfig then
    CreateUpgradeSection(FarmTab, "Upgrade: Token", TokenUpgradeConfig, "AutoToken_", TokenUpgradeToggleUI, nil)
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
                    { ["name"] = currencyName, ["value"] = UtilsModule.ToText(cost), ["inline"] = true },
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
        return require(ReplicatedStorage.Scripts.Configs.Crafts)
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
    local path1 = ReplicatedStorage.Scripts.Configs:FindFirstChild("Trainers")
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

    local path2 = ReplicatedStorage.Scripts.Configs:FindFirstChild("RollGachaUpgrades")
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
                                if Reliable then
                                    local oldLevel = currentLvl 

                                    local s = pcall(function()
                                        if isGachaUpgrade then
                                            Reliable:FireServer("Crate Upgrade", { name })
                                        else
                                            Reliable:FireServer("Chance Upgrade", {name})
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
                if not isGachaUpgrade and Reliable then
                    pcall(function() Reliable:FireServer("Chance Upgrade", name, false) end)
                end
            end
        end
    })

    CombinedToggleUI[name] = { Toggle = myToggle, Mod = mod, IsGacha = isGachaUpgrade }
    _totalItems = _totalItems + 1
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
    Title = "Auto Equip Best (GameMode or Xmas)",
    Desc = "Auto equip best stat inside GameModes or Xmas Map",
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
            local isFightingZone = (string.find(currentMap, ":") and (string.find(currentMap, "Dungeon") or string.find(currentMap, "Raid") or string.find(currentMap, "Defense") or string.find(currentMap, "Christmas") or currentMap == "PirateTower" or currentMap == "ShadowGate") or (currentMap == "PirateTower" or currentMap == "ShadowGate" or currentMap == "ChristmasRaid" or currentMap == "Christmas"))

            -- [PRIORITAS 1: MEGA BOSS]
            -- Jika Mega Boss Aktif (via Auto Mega Boss) DAN config equip Mega Boss dipilih
            if Config.AutoMegaBoss and MegaBossState.IsActive and Config.AutoEquipVaultMegaBoss then
                if LastVaultState ~= "MegaBoss" then
                    if Reliable then
                        pcall(function()
                            Reliable:FireServer("Vault Equip Best", { Config.AutoEquipVaultMegaBoss })
                        end)
                        if Notify then Notify("Vault Auto", "Equip (MegaBoss): " .. tostring(Config.AutoEquipVaultMegaBoss)) end
                    end
                    LastVaultState = "MegaBoss"
                end

            -- [PRIORITAS 2: GAME MODES (Dungeon/Raid)]
            elseif isFightingZone then
                if Config.AutoEquipVaultMode then
                    if LastVaultState ~= "GameMode" or LastGameModeMap ~= currentMap then
                        if Reliable then
                            pcall(function()
                                Reliable:FireServer("Vault Equip Best", { Config.AutoEquipVaultMode })
                            end)
                            if Notify then Notify("Vault Auto", "Equip (GameMode or Xmas): " .. tostring(Config.AutoEquipVaultMode)) end
                        end
                        
                        LastVaultState = "GameMode"
                        LastGameModeMap = currentMap
                    end
                end

            -- [PRIORITAS 3: FARMING BIASA]
            else
                if Config.AutoEquipVaultFarm then
                    if LastVaultState ~= "Farm" then
                        if Reliable then
                            pcall(function()
                                Reliable:FireServer("Vault Equip Best", { Config.AutoEquipVaultFarm })
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
        
        if weaponInstance and weaponInstance.Index and WeaponsModule[weaponInstance.Index] then
            local staticInfo = WeaponsModule[weaponInstance.Index]
            
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
                
                if EnchantmentsConfig and EnchantmentsConfig.Table then
                    local parts = string.split(rawEnchant, "_")
                    if #parts == 2 then
                        local eType = parts[1]
                        local eTier = tonumber(parts[2])
                        local roman = {"I", "II", "III", "IV", "V"}
                        if EnchantmentsConfig.Table[eType] then
                            local typeDisplay = EnchantmentsConfig.Table[eType].Display or eType
                            local tierDisplay = roman[eTier] or eTier
                            niceEnchant = string.format("%s %s", typeDisplay, tierDisplay)
                            
                            if EnchantmentsConfig.Table[eType].List and EnchantmentsConfig.Table[eType].List[eTier] then
                                local tierData = EnchantmentsConfig.Table[eType].List[eTier]
                                local desc = EnchantmentsConfig.Table[eType].Description
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
        local info = AccessoriesConfig[accID]
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

MegaBossFilterDrop = FM_Add("Upgrade: Mega Boss", FarmTab:Dropdown({
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
FM_Add("Upgrade: Mega Boss", MegaBossToggle)
MegaBossToggles = {}
if MegaBossUpgradeConfig then
    CreateUpgradeSection(FarmTab, "Upgrade: Mega Boss", MegaBossUpgradeConfig, "AutoMegaBossUp_", MegaBossToggles, nil)
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
        if Reliable then
            pcall(function()
                local pData = (getgenv()).PlayerData
                local currentAvatar = pData and pData.Attributes and pData.Attributes.Avatar
                local avatarDisplayName = currentAvatar
                
                if currentAvatar and EnemiesConfig and EnemiesConfig[currentAvatar] and EnemiesConfig[currentAvatar].Display then
                    avatarDisplayName = EnemiesConfig[currentAvatar].Display
                end

                Reliable:FireServer("Avatar Upgrade") 
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
        if Reliable then
            pcall(function()
                local pData = (getgenv()).PlayerData
                local currentAvatar = pData and pData.Attributes and pData.Attributes.Avatar
                local avatarDisplayName = currentAvatar

                if currentAvatar and EnemiesConfig and EnemiesConfig[currentAvatar] and EnemiesConfig[currentAvatar].Display then
                    avatarDisplayName = EnemiesConfig[currentAvatar].Display
                end
                
                Reliable:FireServer("Avatar Max Upgrade")
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
        return require(ReplicatedStorage.Scripts.Configs.MultipleZones.HeroesStats)
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
        return require(ReplicatedStorage.Scripts.Configs.MultipleZones.Heroes)
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
                        
                        if pData and pData.Attributes and pData.Weapons and pData.Materials and Reliable then
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

                            local tokenKey = (EnchantmentsConfig and EnchantmentsConfig.TokenName) or "EnchantmentToken"
                            local tokenCost = (EnchantmentsConfig and EnchantmentsConfig.TokenCost) or 10
                            local myTokens = pData.Materials[tokenKey] or 0
                            
                            if myTokens >= tokenCost then
                                pcall(function()
                                    Reliable:FireServer("Enchantments Roll") 
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
    if EnchantmentsConfig and EnchantmentsConfig.Table then
        local RomanNumerals = {"I", "II", "III", "IV", "V"} 

        for typeName, typeData in pairs(EnchantmentsConfig.Table) do
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
                local staticInfo = WeaponsModule[wData.Index]
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
            if not pData or not HeroesStatsModule or not Reliable or not SelectedHeroUID then return end
            
            local newTargetIndex = RarityMap[TargetLockTier] or 999
            
            if pData.Heroes and pData.Heroes[SelectedHeroUID] then
                local currentStats = pData.Heroes[SelectedHeroUID].Stats or {}
                local lockedStats = pData.LockedHeroesStats or {}
                
                for _, statName in ipairs(ValidStatsList) do
                    local currentIndex = currentStats[statName] or 1
                    local isLocked = lockedStats[statName] == true
                    
                    if isLocked and currentIndex < newTargetIndex then
                        Reliable:FireServer("Lock Hero Stats", {statName})
                        if Notify then Notify("Auto Unlock", "Unlocking " .. statName .. " (Below target)") end
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
SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings-2"
});
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
            if EnemyDropdown and EnemyDropdown.Select then
                pcall(function() EnemyDropdown:Select(nil); end);
            end;
            task.spawn(function()
                local freshEnemies = RefreshEnemyData();
                CurrentZoneEnemiesCache = freshEnemies;
                local savedEntry = Config.ZoneConfigurations[targetZoneName];
                if savedEntry then
                    for _, enemy in ipairs(freshEnemies) do
                        if enemy.Value == savedEntry.Value then
                            Config.SelectedEnemy = enemy.Value;
                            if EnemyDropdown and EnemyDropdown.Set then
                                pcall(function() EnemyDropdown:Set(enemy); end); 
                            elseif EnemyDropdown and EnemyDropdown.Select then
                                pcall(function() EnemyDropdown:Select(enemy.Value); end);
                            end;
                            break;
                        end;
                    end;
                end;
                IsLoadingConfig = false;
                IsTeleporting = false;
            end);
        
        -- [B] Logika Meteor Event (BARU)
        elseif msg == "Meteor Shower Started" then
            -- Server kirim nama Zone sebagai argumen (cek MeteorEvent.c Baris 136)
            local zone = args
            MeteorState.Zone = zone
            MeteorState.IsActive = true
            Notify("Meteor Event", "Shower Started in: " .. tostring(zone))
            
        -- [REVISI LISTENER] - Gunakan tick() untuk presisi
        elseif msg == "Meteor Spawn" then
            local pos = args
            if typeof(pos) == "Vector3" then
                MeteorState.Position = pos
                -- Menggunakan tick() agar sinkron dengan METEOR_FALL_DURATION (5 detik)
                MeteorState.LandTime = tick() + 5 
                MeteorState.IsActive = true
            end

        elseif msg == "Meteor Shower Ended" then
            MeteorState.IsActive = false
            MeteorState.Position = nil
            MeteorState.Zone = nil
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
            if CheckIsFightingZone() then return end

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

                if not MegaBossState.IsActive then
                    MegaBossState.ReturnZone = GetCurrentMapStatus()
                end

                MegaBossState.TargetZone = targetZoneID
                MegaBossState.IsActive = true
                MegaBossState.BossDeadCheck = 0
                
                if Notify then Notify("Mega Boss", "Spawned at " .. zoneDisplayName .. "! Teleporting...") end
                
                if Reliable and targetZoneID ~= getgenv().PlayerData.Attributes.Zone then
                    pcall(function() Reliable:FireServer("Zone Teleport", { targetZoneID }) end)
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

-- [OPTIMIZED ZONE DETECTION LOOP]
task.spawn(function()
    local prevZone = ""
    
    while not Window.Destroyed do
        task.wait(1) -- Cek setiap 1 detik (0.5 terlalu cepat dan bikin berat)
        
        if not IsTeleporting then
            local detectedZone = GetCurrentMapStatus()
            
            -- Hanya update jika zone BENAR-BENAR berubah
            if detectedZone and detectedZone ~= "Unknown" and detectedZone ~= prevZone then
                
                -- [PERBAIKAN 1: WAKTU TUNGGU]
                -- Tunggu 2 detik agar Roblox selesai loading asset map & folder Enemies.
                -- Jika terlalu cepat, folder Enemies masih kosong atau berisi data zone lama.
                task.wait(2.0) 
                
                prevZone = detectedZone
                CurrentZoneName = detectedZone
                Config.SelectedEnemy = nil
                
                -- Reset dropdown sementara (Visual feedback)
                if EnemyDropdown and EnemyDropdown.SetTitle then
                    pcall(function() EnemyDropdown:SetTitle("Loading Enemies...") end)
                end
                
                IsLoadingConfig = true
                
                -- Jalankan refresh data di thread terpisah agar Main Loop tidak macet
                task.spawn(function()
                    -- Proses ini sekarang aman karena sudah ada "task.wait" di dalam RefreshEnemyData
                    local freshEnemies = RefreshEnemyData()
                    CurrentZoneEnemiesCache = freshEnemies
                    
                    -- Update Dropdown UI
                    pcall(function()
                        if EnemyDropdown then
                            -- Kembalikan Judul
                            if EnemyDropdown.SetTitle then EnemyDropdown:SetTitle("Select Enemy") end
                            
                            -- Refresh Isi
                            if EnemyDropdown.Refresh then EnemyDropdown:Refresh(freshEnemies) end
                        end
                    end)
                    
                    -- Auto Select Enemy Terakhir (Saved Config)
                    task.wait(0.2)
                    local savedEntry = Config.ZoneConfigurations[detectedZone]
                    if savedEntry then
                        for _, currentMob in ipairs(freshEnemies) do
                            if currentMob.Value == savedEntry.Value then
                                Config.SelectedEnemy = currentMob.Value
                                pcall(function()
                                    if EnemyDropdown.Set then EnemyDropdown:Set(currentMob)
                                    elseif EnemyDropdown.Select then EnemyDropdown:Select(currentMob.Value) end
                                end)
                                break
                            end
                        end
                    end
                    
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
    AddSummary(Config.TargetChristmas, christmasDB, "Xmas")
    
    if Config.TargetPirateTower and #Config.TargetPirateTower > 0 then
        table.insert(summaryItems, "• Pirate Tower")
    end
    if Config.TargetShadowGate and #Config.TargetShadowGate > 0 then
        table.insert(summaryItems, "• Shadow Gate")
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
    if not pData.Attributes or not LevelUpModule then return end
    
    local currentLevel = pData.Attributes.Level or 1
    local currentAsc = pData.Attributes.Ascension or 0
    
    -- Mengambil batas maksimal level dan ascension dari konfigurasi
    local maxLevel = LevelUpModule.GetMaxLevel(currentAsc)
    local maxAscensionLimit = LevelUpModule.MAX_ASCENSION or #LevelUpModule.AscensionXpBoost

    -- 1. SISTEM CACHE UI
    if not Window.Closed and AscUI and AscUI.Status then
        local currentExpBonus = LevelUpModule.GetExpWithBonus(10, pData)
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
    local availablePoints = LevelUpModule.CountPoints(pData)
    if availablePoints > 0 then
        for statName, isEnabled in pairs(Config.AutoStat) do
            if isEnabled then
                -- Menyesuaikan dengan remote di LevelUpStats.c
                -- Pastikan StatPointAmount di set (misal 1 atau 10) agar tidak lambat
                if Reliable then
                    pcall(function()
                        -- Kita kirim request distribusi ke server
                        Reliable:FireServer("Distribute Stat Point", {statName})
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
                    Reliable:FireServer("Ascend")
                    if Notify then Notify("Ascension", "Auto Ascending...") end
                end)
                Optimizer.Cache.LastAscendTime = now
            end
        end
    end
end

function Optimizer.Update_Enchantments_Logic(pData)
    -- Update Visual UI Saja
    if EnchUI.MasterToggle and not Window.Closed then
        if pData.Materials and pData.Attributes and pData.Weapons then
            
            -- [1] DATA WEAPON & TOKEN
            local tokenKey = (EnchantmentsConfig and EnchantmentsConfig.TokenName) or "EnchantmentToken"
            local tokenCost = (EnchantmentsConfig and EnchantmentsConfig.TokenCost) or 10
            local myTokens = pData.Materials[tokenKey] or 0
            
            local currentEquipID = pData.Attributes.Weapon
            local weaponInstance = pData.Weapons[currentEquipID]
            
            -- Ambil nama cantik weapon & icon
            local weaponDisplayName = currentEquipID or "Unknown"
            local weaponIcon = "sparkles"
            local weaponRarity = "Common" 
            
            if weaponInstance and weaponInstance.Index then
                local configID = weaponInstance.Index
                if WeaponsModule and WeaponsModule[configID] then
                    local staticData = WeaponsModule[configID]
                    if staticData.Display then weaponDisplayName = staticData.Display end
                    if staticData.Template then weaponIcon = GetIcon(staticData.Template) end
                    if staticData.Rarity then weaponRarity = staticData.Rarity end
                end
            end

            local enchantText = "None"
            if weaponInstance and weaponInstance.Enchantment then
                local rawID = weaponInstance.Enchantment
                local parts = string.split(rawID, "_")
                if #parts == 2 and EnchantmentsConfig and EnchantmentsConfig.Table then
                    local eType = parts[1]
                    local eTier = tonumber(parts[2])
                    local roman = {"I", "II", "III", "IV", "V"}
                    if EnchantmentsConfig.Table[eType] then
                        local typeInfo = EnchantmentsConfig.Table[eType]
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
                
                local tkInfo = MaterialsModule[tokenKey]
                local tkName = tkInfo and tkInfo.Display or "Tokens"
                local tkIcon = tkInfo and GetIcon(tkInfo.Template) or ""
                
                EnchUI.MasterToggle:SetDesc(string.format("%s%s %s/%s", tkIcon, tkName, UtilsModule.ToText(tokenCost), UtilsModule.ToText(myTokens)))
                
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
            local timeStr = UtilsModule.ToText(timeLeft) -- Gunakan formatter yang tersedia di script Anda
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
                Reliable:FireServer("Reforge Claim") 
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
                    Reliable:FireServer("Reforge Start", { mainUID, materials })
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
        local newListItemDesc = "Stock: " .. UtilsModule.ToText(currentAmount)
        
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
            matDescText = string.format("Stock: %s | +%s (Buy)", UtilsModule.ToText(materialCount), UtilsModule.ToText(outputDisplay))
            tradeDescText = string.format("Stock: %s | -%s (Pay)", UtilsModule.ToText(tradeTokenCount), UtilsModule.ToText(inputDisplay))
        else
            inputDisplay = math.floor(materialCount * ExchangePercent)
            outputDisplay = inputDisplay * ratio
            matDescText = string.format("Stock: %s | -%s (Sell)", UtilsModule.ToText(materialCount), UtilsModule.ToText(inputDisplay))
            tradeDescText = string.format("Stock: %s | +%s (Get)", UtilsModule.ToText(tradeTokenCount), UtilsModule.ToText(outputDisplay))
        end
        
        -- [3] CACHE UNTUK SetMainImage (HEADER)
        local info = MaterialsModule[SelectedExToken]
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
            local matInfo = MaterialsModule[tokenKey]
            local matDisplay = matInfo and matInfo.Display or tokenKey
            local matIcon = (matInfo and matInfo.Template) and GetIcon(matInfo.Template) or ""
            
            pcall(function() 
                toggle:SetDesc(string.format("%s %s: %s", matIcon, matDisplay, UtilsModule.ToText(currentCount))) 
            end)
        end
        
        -- 4. Update Gambar Utama (SetMainImage) - HANYA jika berubah
        -- Kita tambahkan check 'currentRarity' agar tidak nil
        if (lastState.Image ~= currentImage) or (lastState.Rarity ~= currentRarity) then
            pcall(function() 
                if not Window.Closed and toggle.SetMainImage and currentRarity then 
                    toggle:SetMainImage({ 
                        Image = currentImage, 
                        Quantity = currentRarity, 
                        Title = currentItemName, 
                        Gradient = GetGameGradient(currentRarity) 
                    }, 50) 
                end 
            end)
            -- Simpan state terbaru ke cache
            Optimizer.Cache.Roll[rollType] = { 
                Image = currentImage, 
                Rarity = currentRarity, 
                Count = currentCount, 
                IsMaxed = lastState.IsMaxed 
            }
        else
            -- Jika hanya jumlah token yang berubah, update count saja di cache
            lastState.Count = currentCount
            Optimizer.Cache.Roll[rollType] = lastState
        end

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
                    if MaterialsModule[matName] then dName = MaterialsModule[matName].Display; if MaterialsModule[matName].Template then dIcon = GetIcon(MaterialsModule[matName].Template) end end
                    table.insert(parts, string.format("%s%s %s/%s", dIcon, dName, UtilsModule.ToText(reqAmt), UtilsModule.ToText(myAmt)))
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
                local s = pcall(function() Reliable:FireServer("Upgrade Craft", { tostring(id) }) end) 
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
            currentLvl = (pData.CrateUpgrades and pData.CrateUpgrades[name]) or 0
            if mod.ImageId then currentImage = GetIcon(mod.ImageId) end
            tokenKey = mod.TOKEN_NAME or (name.."Token")
        end

        local cost, maxLvl = mod.GetCost(currentLvl), (mod.MAX_LEVEL or mod.MaxLevel or 100)
        local currentMat = pData.Materials[tokenKey] or 0
        local matInfo = MaterialsModule[tokenKey]
        local matDisplay = string.format("%s%s", (matInfo and matInfo.Template and GetIcon(matInfo.Template) or ""), (matInfo and matInfo.Display or tokenKey))

        local newTitle, newDesc, isMaxed = "", "", false
        if currentLvl >= maxLvl then
            isMaxed = true; newTitle = itemName .. " [MAX]"; newDesc = "Max Level Reached"
        else
            local chanceTxt = (not isGacha and mod.GetChance) and (" | Chance: " .. (math.floor(mod.GetChance(currentLvl) * 10) / 10) .. "%") or ""
            newTitle = string.format("%s [%d/%d]", name, currentLvl, maxLvl)
            newDesc = string.format("Cost: %s%s\n%s: %s", UtilsModule.ToText(cost), chanceTxt, matDisplay, UtilsModule.ToText(currentMat))
        end

        local cache = Optimizer.Cache.Upgrade[name] or {}
        if cache.Title ~= newTitle then toggle:SetTitle(newTitle) end
        if cache.Desc ~= newDesc then toggle:SetDesc(newDesc) end
        if isMaxed and not cache.IsMaxed then toggle:Lock("Already Maxed"); local k = isGacha and ("AutoUpgrade_"..name) or ("AutoChance_"..name); if Config[k] then Config[k] = false; toggle:Set(false) end end
        if isGacha and toggle.SetMainImage and (cache.Image ~= currentImage or cache.Rarity ~= currentRarity) then toggle:SetMainImage({ Image = currentImage, Quantity = currentRarity, Title = itemName, Gradient = GetGameGradient(currentRarity) }, 50) end
        
        Optimizer.Cache.Upgrade[name] = { Title = newTitle, Desc = newDesc, IsMaxed = isMaxed, Image = currentImage, Rarity = currentRarity }
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

        -- 3. [PERBAIKAN] Masukkan data WEAPON
        -- Tanpa baris ini, script tidak tahu kalau senjata berubah
        if pd.Attributes.Weapon then s["Weapon"] = pd.Attributes.Weapon end

        return HttpService:JSONEncode(s)
    end
    
    local IsVisible = VaultGroup and VaultGroup.GroupFrame and VaultGroup.GroupFrame.Visible
    local CurrentHash = GetVaultSnapshot(pData)
    
    -- Cek apakah sidik jari berubah?
    local DataChanged = (CurrentHash ~= Optimizer.Cache.VaultHash)
    
    if DataChanged then 
        Optimizer.Cache.VaultHash = CurrentHash 
    end
    
    -- Refresh UI jika Data Berubah DAN Tab sedang dibuka
    -- ATAU jika Tab baru saja dibuka (VaultWasVisible false -> true)
    if (DataChanged and IsVisible) or (IsVisible and not Optimizer.Cache.VaultWasVisible) then 
        RefreshVaultUI() 
    end
    
    Optimizer.Cache.VaultWasVisible = IsVisible
end

function Optimizer.Update_Avatar_Logic(pData)
    -- Pastikan data tersedia
    if not pData.AvatarLevels or not AvatarLevelsModule then return end
    
    local currentAvatar = pData.Attributes.Avatar
    local isAvatarSelected = currentAvatar and currentAvatar ~= "" and currentAvatar ~= "None"
    -- [1. LOGIKA VIEWPORT (3D PREVIEW)]
    -- Hanya jalankan jika avatar berubah untuk menghemat performa
    if isAvatarSelected then
        if Optimizer.Cache.LastAvatarID ~= currentAvatar then
            Optimizer.Cache.LastAvatarID = currentAvatar
            
            local modelPath = ReplicatedFirst:WaitForChild("Assets"):WaitForChild("Enemies"):FindFirstChild(currentAvatar)
            
            if AvatarStatusPara and modelPath then
                -- 1. Setup Model (Clone agar aslinya tidak pindah)
                local modelClone = modelPath:Clone()
                
                -- Hitung titik tengah model menggunakan Bounding Box
                local orientation, size = modelClone:GetBoundingBox()
                local centerPoint = Vector3.new(0, 0, 0)
                
                -- Pindahkan model agar pusatnya ada di (0,0,0) di dunia Viewport
                modelClone:PivotTo(CFrame.new(-orientation.Position)) 
                
                -- 2. Inisialisasi Viewport (Kirim model ke modul Viewport Anda)
                AvatarStatusPara:SetViewport(modelClone)
                
                -- 3. Setup Kamera Statis
                local vp = AvatarStatusPara.ViewportFrame
                if vp and vp.CurrentCamera then
                    -- Jarak kamera (dist) disesuaikan dengan ukuran model (biar tidak terlalu dekat/jauh)
                    local dist = size.Magnitude * 0.8 
                    
                    -- CFrame.lookAt(PosisiKamera, TitikYangDilihat)
                    -- Kita taruh kamera di depan (Z = -dist) dan sedikit naik (Y = 0.2) agar presisi
                    vp.CurrentCamera.CFrame = CFrame.lookAt(
                        Vector3.new(0, 0.2, -dist), -- Posisi kamera
                        Vector3.new(0, 0, 0)        -- Melihat ke tengah model
                    )
                end
            end
        end
    else
        -- Jika tidak ada avatar dipilih, hapus preview dan reset cache
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
        local tokenKey = AvatarLevelsModule.Token or "AvatarToken"
        local tokenDisplayName = tokenKey
        local currentLevel = pData.AvatarLevels[currentAvatar] or 0
        local maxLevel = AvatarLevelsModule.MaxLevel or 100
        local myTokens = pData.Materials[tokenKey] or 0
        
        local newTitle = "No Avatar Selected"
        local newDesc = "Select an avatar in the game's interface to begin."

        if isAvatarSelected then
            -- Ambil Nama Display Avatar
            if EnemiesConfig and EnemiesConfig[currentAvatar] and EnemiesConfig[currentAvatar].Display then
                avatarDisplayName = EnemiesConfig[currentAvatar].Display
            end

            -- Ambil Nama Display Token
            if MaterialsModule and MaterialsModule[tokenKey] and MaterialsModule[tokenKey].Display then
                tokenDisplayName = MaterialsModule[tokenKey].Display
            end

            local nextLevel = currentLevel + 1
            local isMaxed = currentLevel >= maxLevel
            local currentBuff = AvatarLevelsModule.GetBuff(currentLevel)
            local nextBuff = isMaxed and currentBuff or AvatarLevelsModule.GetBuff(nextLevel)
            local cost = isMaxed and 0 or AvatarLevelsModule.GetCost(currentLevel)
            
            local costStr = UtilsModule.ToText(cost, 0)
            local tokenCountStr = UtilsModule.ToText(myTokens, 0)
            local tokenIcon = GetAvatarTokenIcon() or ""

            newTitle = string.format("%s (Lv. %d / %d)", avatarDisplayName, currentLevel, maxLevel)
            
            if isMaxed then
                newDesc = string.format("<b>MAX Level Reached!</b>\n\nBuff: +%s%%\n%s %s: %s", 
                    UtilsModule.ToText(currentBuff), tokenIcon, tokenDisplayName, tokenCountStr)
                
                -- Matikan Auto jika sudah MAX
                if AvatarLevelToggle and not AvatarLevelToggle.Locked then
                    AvatarLevelToggle:Lock()
                    AvatarLevelToggle:SetTitle("Auto Avatar Level Up [MAX]")
                    Config.AutoAvatarLevelUp = false
                    AvatarLevelToggle:Set(false)
                end
            else
                newDesc = string.format("<b>Current Buff: +%s%%</b>\nNext Buff: +%s%%\n\nCost: %s / %s\n(%s %s)",
                    UtilsModule.ToText(currentBuff), UtilsModule.ToText(nextBuff),
                    costStr, tokenCountStr, tokenIcon, tokenDisplayName)
                
                if AvatarLevelToggle and AvatarLevelToggle.Locked then
                    AvatarLevelToggle:Unlock()
                    AvatarLevelToggle:SetTitle("Auto Avatar Level Up")
                end
            end
        else
            -- Reset UI jika tidak ada avatar
            if AvatarLevelToggle and not AvatarLevelToggle.Locked then
                AvatarLevelToggle:Lock()
                Config.AutoAvatarLevelUp = false
                AvatarLevelToggle:Set(false)
            end
        end

        -- Update ke UI (Hanya jika teks berubah untuk optimasi)
        if not Window.Closed and AvatarStatusPara then
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

    -- [3. LOGIKAL AUTO UPGRADE]
    if Config.AutoAvatarLevelUp and isAvatarSelected then
        local currentLevel = pData.AvatarLevels[currentAvatar] or 0
        local maxLevel = AvatarLevelsModule.MaxLevel or 100
        local tokenKey = AvatarLevelsModule.Token or "AvatarToken"
        local myTokens = pData.Materials[tokenKey] or 0
        
        if currentLevel < maxLevel then
            local cost = AvatarLevelsModule.GetCost(currentLevel)
            if myTokens >= cost then
                if Reliable then
                    pcall(function()
                        Reliable:FireServer("Avatar Upgrade")
                    end)
                    
                    -- Webhook & Notif
                    local avatarName = currentAvatar
                    if EnemiesConfig and EnemiesConfig[currentAvatar] and EnemiesConfig[currentAvatar].Display then
                        avatarName = EnemiesConfig[currentAvatar].Display
                    end
                    
                    Notify("Avatar", string.format("Auto Upgrade: %s to Lv. %d", avatarName, currentLevel + 1))
                    
                    local now = os.time()
                    if not LastWebhookTime["AvatarLevels"] or (now - LastWebhookTime["AvatarLevels"]) >= 10 then
                        SendAvatarUpgradeWebhook(avatarName, currentLevel + 1, maxLevel, AvatarLevelsModule.GetBuff(currentLevel + 1))
                        LastWebhookTime["AvatarLevels"] = now
                    end
                    
                    task.wait(1.5) -- Jeda agar tidak spam server
                end
            end
        end
    end
end

function Optimizer.Update_Heroes_Logic(pData)
    if not HeroesStatsModule or not Reliable or not pData.EquippedHeroes or not pData.Heroes then return end
    
    -- Init Cache Variables
    if not Optimizer.Cache.LastHeroRollTime then Optimizer.Cache.LastHeroRollTime = 0 end
    if not Optimizer.Cache.EquippedHeroesHash then Optimizer.Cache.EquippedHeroesHash = "" end

    -- [1] KUMPULKAN HERO YANG SEDANG DIPAKAI (EQUIPPED)
    local activeHeroesList = {}
    local hashBuilder = "" 
    
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
                damageDisplay = UtilsModule.ToText(finalDamage, 3) .. "%"
            end
            
            local displayTitle = string.format("%s [%s]", hName, hRarity)

            table.insert(activeHeroesList, {
                Title = displayTitle,
                Value = uid,
                Desc = "Damage: " .. damageDisplay
            })
            
            hashBuilder = hashBuilder .. uid
        end 
    end
    
    -- [2] UPDATE DROPDOWN
    if hashBuilder ~= Optimizer.Cache.EquippedHeroesHash then
        table.sort(activeHeroesList, function(a,b) return a.Title < b.Title end)
        
        if HeroSelectDrop and HeroSelectDrop.Refresh then
            HeroSelectDrop:Refresh(activeHeroesList)
        end
        
        if not SelectedHeroUID and #activeHeroesList > 0 then
            SelectedHeroUID = activeHeroesList[1].Value
            if HeroSelectDrop.Select then
                pcall(function() HeroSelectDrop:Select(SelectedHeroUID) end)
            end
        end
        
        Optimizer.Cache.EquippedHeroesHash = hashBuilder
    end

    -- [3] TAMPILKAN STATS & VIEWPORT HERO YANG DIPILIH
    local isValidSelection = false
    if SelectedHeroUID and pData.EquippedHeroes[SelectedHeroUID] == true then
        isValidSelection = true
    else
        if #activeHeroesList > 0 then
            SelectedHeroUID = activeHeroesList[1].Value
            isValidSelection = true
            if HeroSelectDrop.Select then pcall(function() HeroSelectDrop:Select(SelectedHeroUID) end) end
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
            hDamageStr = UtilsModule.ToText(baseDamage * 100 * buffMultiplier, 3) .. "%"
        end

        -- [BARU: LOGIKA VIEWPORT HERO]
        if Optimizer.Cache.LastHeroUID ~= SelectedHeroUID then
            Optimizer.Cache.LastHeroUID = SelectedHeroUID
            
            -- Mencari model hero di folder Assets/Enemies (sesuai letak model avatar Anda)
            local modelPath = ReplicatedFirst:WaitForChild("Assets"):WaitForChild("Heroes"):FindFirstChild(hData.Index)
            
            if HeroStatsInfo and modelPath then
                local modelClone = modelPath:Clone()
                local orientation, size = modelClone:GetBoundingBox()
                
                -- Centering model
                modelClone:PivotTo(CFrame.new(-orientation.Position)) 
                
                -- Set ke Viewport HeroStatsInfo
                HeroStatsInfo:SetViewport(modelClone)
                
                local vp = HeroStatsInfo.ViewportFrame
                if vp and vp.CurrentCamera then
                    local dist = size.Magnitude * 0.8 
                    vp.CurrentCamera.CFrame = CFrame.lookAt(
                        Vector3.new(0, 0.2, -dist), -- Posisi kamera statis depan
                        Vector3.new(0, 0, 0)        -- Melihat ke tengah model
                    )
                end
            end
        end
        
        -- [A] UPDATE VISUAL TEKS
        if not Window.Closed then
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
            local shardsStr = UtilsModule.ToText(myShards)
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
        end
        
        -- TAMBAHKAN BAGIAN INI --
        -- 1. Logika Auto Lock (Berjalan Mandiri)
        if Config.EnableAutoLock then
            local targetIdx = RarityMap[TargetLockTier] or 999
            for _, sName in ipairs(ValidStatsList) do
                local currentIdx = hStats[sName] or 1
                -- Jika Tier Stats saat ini >= Target Tier DAN belum dikunci
                if currentIdx >= targetIdx and not lStats[sName] then
                    pcall(function()
                        Reliable:FireServer("Lock Hero Stats", {sName})
                        if Notify then 
                            Notify("Auto Lock", "Locked " .. sName .. " (Tier " .. (RarityIndexMap[currentIdx] or "?") .. ")", "lock") 
                        end
                    end)
                    task.wait(0.1) -- Jeda singkat agar tidak spam remote
                end
            end
        end

        -- 2. Logika Auto Roll (Hanya jalan jika Auto Roll ON)
        if Config.AutoRollHeroStats then
            local currency = pData.Materials.HeroesStats or 0
            -- Cek apakah semua stats yang >= target sudah terkunci sebelum lanjut roll
            local allTargetsLocked = true
            local targetIdx = RarityMap[TargetLockTier] or 999
            
            for _, sName in ipairs(ValidStatsList) do
                local currentIdx = hStats[sName] or 1
                if currentIdx >= targetIdx and not lStats[sName] then
                    allTargetsLocked = false
                    break
                end
            end

            if allTargetsLocked and currency > 15 then
                if (os.time() - Optimizer.Cache.LastHeroRollTime) >= 1.5 then
                    local anyUnlocked = false
                    for _, sName in ipairs(ValidStatsList) do 
                        if not lStats[sName] then anyUnlocked = true; break end 
                    end
                    
                    if anyUnlocked then
                        Reliable:FireServer("Roll Hero Stats", {SelectedHeroUID, false})
                        Optimizer.Cache.LastHeroRollTime = os.time()
                    end
                end
            end
        end
    else
        -- Jika tidak ada hero dipilih, bersihkan viewport
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
    if not MegaBossUpgradeConfig or not MegaBossUpgradeModule then return end
    
    -- Ambil Data Player
    local myUpgrades = pData.MegaBossUpgrades or {}
    local tokenName = MegaBossUpgradeModule.TokenName or "MegaBossToken" --
    local myTokens = pData.Materials[tokenName] or 0
    
    -- Ambil Template Icon Token untuk Display (Optional)
    local tokenIcon = ""
    if MaterialsModule[tokenName] and MaterialsModule[tokenName].Template then
        tokenIcon = GetIcon(MaterialsModule[tokenName].Template)
        tokenName = MaterialsModule[tokenName].Display
    end

    for name, cfg in pairs(MegaBossUpgradeConfig) do
        local currentLvl = myUpgrades[name] or 0
        local maxLvl = cfg.MaxLevel or 20 --
        
        -- Hitung Cost & Buff menggunakan Fungsi dari Module
        local cost = 0
        if MegaBossUpgradeModule.GetUpgradeCost then
            cost = MegaBossUpgradeModule.GetUpgradeCost(currentLvl, name) -- Rumus: 5 + 5 * Level
        end
        
        local currentBuff = 0
        if MegaBossUpgradeModule.GetUpgradeBuff then
            currentBuff = MegaBossUpgradeModule.GetUpgradeBuff(name, currentLvl) -- Rumus: Level * BonusPerLevel
        end

        -- Update Visual UI
        local toggle = MegaBossToggles[name]
        if toggle and not Window.Closed then
            local newTitle = ""
            local newDesc = ""
            local isMaxed = currentLvl >= maxLvl

            if isMaxed then
                newTitle = name .. " [MAX]"
                newDesc = string.format("<b>Maxed</b>\nBuff: +%s%%", UtilsModule.ToText(currentBuff))
                if not toggle.Locked then 
                    toggle:Lock("Already Maxed") 
                    Config["AutoMegaBossUp_" .. name] = false
                    toggle:Set(false)
                end
            else
                newTitle = string.format("%s [%d/%d]", name, currentLvl, maxLvl)
                newDesc = string.format("%s%s %s/%s\nBuff: +%s%%", 
                    tokenIcon,tokenName, UtilsModule.ToText(cost), UtilsModule.ToText(myTokens), UtilsModule.ToText(currentBuff))
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
                        Reliable:FireServer("Mega Boss Upgrade", {name})
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
        
        -- 1. UPDATE TAMPILAN UI (Hanya jika window terbuka)
        if toggle and not Window.Closed then
            local newTitle = ""
            local newDesc = ""
            
            -- [LOGIKA PENYUSUNAN TEXT]
            if lvl >= max then
                newTitle = name .. " [MAX]"
                
                local buff = 0
                if upgradeModule.GetUpgradeBuff then
                    buff = upgradeModule.GetUpgradeBuff(name, lvl)
                end
                newDesc = string.format("<b>Maxed</b>\nBuff: +%s%%", UtilsModule.ToText(buff))
                
                -- Kunci toggle jika sudah Max (Logic UI State)
                if not toggle.Locked then 
                    toggle:Lock("Already Maxed")
                    Config[configPrefix .. name] = false 
                    toggle:Set(false) 
                end
            else
                newTitle = name .. " [" .. lvl .. "/" .. max .. "]"
                
                local buff = 0
                if upgradeModule.GetUpgradeBuff then
                    buff = upgradeModule.GetUpgradeBuff(name, lvl)
                end
                
                -- Format: Icon Cost | Cur: Value \n Buff: +%
                newDesc = string.format("%s Cost: %s/%s\nBuff: +%s%%", 
                    currencyIcon, UtilsModule.ToText(cost), UtilsModule.ToText(currencyVal), UtilsModule.ToText(buff))
                
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
                    pcall(function() Reliable:FireServer(remoteName, {name}) end)
                end
            end
        end
    end
end

function Optimizer.Update_Main_Data_Logic(pData)
    local cRank, cMastery = (pData.Attributes.Rank or 0), (pData.Attributes.Mastery or 0)
    local req, cBuff, nBuff = RankModule.GetRequirement(cRank), RankModule.GetBuff(cRank), RankModule.GetBuff(cRank+1)
    
    if RankProgressUI and not Window.Closed then
        local pct = req>0 and math.clamp(cMastery/req,0,1) or 0
        local bar = string.rep("█", math.floor(pct*10)) .. string.rep("▒", 10-math.floor(pct*10))
        local bt = (cRank>=RankModule.MAX) and ("Buff: "..UtilsModule.ToText(cBuff).."% (MAX)") or ("Buff: "..UtilsModule.ToText(cBuff).."% >> "..UtilsModule.ToText(nBuff).."%")
        local finalDesc = string.format("%s\n[%s] %d%%\n%s / %s", bt, bar, math.floor(pct*100), UtilsModule.ToText(cMastery), UtilsModule.ToText(req))
        
        if _UIDescCache["Rank"] ~= finalDesc then
            RankProgressUI:SetTitle("Rank "..cRank)
            RankProgressUI:SetDesc(finalDesc)
            _UIDescCache["Rank"] = finalDesc
        end
    end
    
    if Config.AutoRankUp and cMastery >= req and cRank < RankModule.MAX then
         if Reliable then pcall(function() Reliable:FireServer("RankUp") end) end
    end

    -- [LOGIKA BARU YANG LEBIH PENDEK]
    
    -- 1. Jalankan Logika Yen
    if pData.YenUpgrades then
        Optimizer.GenericUpgradeLogic(
            YenUpgradeConfig,        -- Config
            pData.YenUpgrades,       -- Data Level Player
            YenModule,               -- Module Game
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
        if MaterialsModule[tKey] and MaterialsModule[tKey].Template then 
            tIcon = GetIcon(MaterialsModule[tKey].Template) 
        end
        
        Optimizer.GenericUpgradeLogic(
            TokenUpgradeConfig, 
            pData.TokenUpgrades, 
            TokenModule, 
            TokenUpgradeToggleUI, 
            "AutoToken_", 
            "Token Upgrade", 
            (pData.Materials[tKey] or 0), -- Jumlah Token
            tIcon
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
    if not HiddenQuestsData or not pData.HiddenQuests then return end
    if not pData.Quests then pData.Quests = {} end 
    
    local isAuto = Config.AutoHiddenQuests
    local hasActionTaken = false 
    
    -- Table untuk menampung baris-baris teks UI
    local uiReportLines = {} 

    for id, questData in ipairs(HiddenQuestsData) do
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
                detailText = string.format("%s: %s/%s", displayTargetName, UtilsModule.ToText(currentAmount), UtilsModule.ToText(reqAmount))
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
                    pcall(function() Reliable:FireServer("Update HiddenQuests", {strID}) end)
                    Notify("Hidden Quest", "Claiming Stage " .. currentStageIndex)
                    hasActionTaken = true
                end
            elseif not serverQuestData then
                if Reliable then
                    pcall(function() Reliable:FireServer("Update HiddenQuests", {strID}) end)
                    Notify("Hidden Quest", "Starting Stage " .. currentStageIndex)
                    hasActionTaken = true 
                end
            elseif serverQuestData.Status == "Progress" and questInfo.Event == "EnemyDefeated" and targetToFarm then
                local currentMap = GetCurrentMapStatus()
                if currentMap ~= "Unknown" and currentMap ~= questData.Zone then
                    if not IsTeleporting then
                        if Reliable then
                            pcall(function() Reliable:FireServer("Zone Teleport", {questData.Zone}) end)
                            IsTeleporting = true
                            hasActionTaken = true
                            task.spawn(function() task.wait(4); IsTeleporting = false end)
                        end
                    end
                elseif currentMap == questData.Zone then
                    if Config.SelectedEnemy ~= displayTargetName then
                        Config.SelectedEnemy = displayTargetName
                        Config.AutoFarm = true 
                        if EnemyDropdown and EnemyDropdown.Set then
                            pcall(function() EnemyDropdown:Set({Title=displayTargetName, Value=displayTargetName}) end)
                        end
                    end
                    hasActionTaken = true 
                end
            end
        end
    end

    -- [UPDATE UI UTAMA]
    if HQ_MainStatusUI and not Window.Closed then
        local finalString = table.concat(uiReportLines, "\n")
        
        -- Cek apakah string baru BEDA dengan yang lama
        if Optimizer.Cache.LastHiddenQuestString ~= finalString then
            pcall(function() HQ_MainStatusUI:SetDesc(finalString) end)
            Optimizer.Cache.LastHiddenQuestString = finalString -- Simpan ke cache
        end
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
            pcall(Optimizer.Update_Ascension_Logic, pData)
            pcall(Optimizer.Update_Enchantments_Logic, pData)
            pcall(Optimizer.Update_Reforge_Logic,pData)
            pcall(Optimizer.Update_Exchange_Logic, pData)
            pcall(Optimizer.Update_Roll_Logic, pData)
            pcall(Optimizer.Update_Craft_Logic, pData)
            pcall(Optimizer.Update_Trainer_Logic, pData)
            pcall(Optimizer.Update_Vault_Logic, pData)
            pcall(Optimizer.Update_Avatar_Logic, pData)
            pcall(Optimizer.Update_Heroes_Logic, pData)
            pcall(Optimizer.Update_MegaBoss_Logic, pData)
            pcall(Optimizer.Update_Gamemode_Dropdowns)
            heavyTaskTick = heavyTaskTick + 1
            if heavyTaskTick >= 6 then -- 6 x 0.5 detik = 3 Detik
                pcall(Optimizer.Update_HiddenQuests_Logic, pData)
                heavyTaskTick = 0
            end
            
        end
        task.wait(0.5) -- Throttle Global
    end
end)
Window:SelectTab(FarmTab.Index);
