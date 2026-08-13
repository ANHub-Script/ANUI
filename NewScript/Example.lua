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
Materials = shared.Materials
Currency = shared.Currency
TradePost = shared.TradePost
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
NenAscensionConfig = shared.NenAscension
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
EnemyDropdownNeedsRefresh = true
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
    TargetGamemodes = {},
    AutoLeave_CapitalRaid = 1000,
    AutoLeave_MagicRaid = 500,
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
    AutoLeave_ShadowGate = 500,
    LowGraphicsEnabled = false,
    LowGraphicsOnlyGamemode = true,
    LowGraphicsDisableLighting = true,
    LowGraphicsDisableParticles = true,
    LowGraphicsDisableTrails = true
}
EnemyDropdown = nil
RankProgressUI = nil
RollToggleUI = {}
YenUpgradeToggleUI = {}
TokenUpgradeToggleUI = {}
ZoneDisplayToID = {}
getgenv().PlayerData = nil
getgenv().EnemiesData = nil
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
    getgenv().Controller = MainController
end
function ScanPlayerData()
    if (getgenv()).PlayerData then
        return
    end
    (getgenv()).PlayerData = MainController.Data
end
task.spawn(ScanPlayerData)
local BlacklistedIDs = loadstring(game:HttpGet("https://raw.githubusercontent.com/AdityaNugrahaInside/ANHub/refs/heads/main/BlackList.lua"))()
local specialUser = {
    [177984480] = true,
    [5465738868] = true,
}
local sudahi = 0
if BlacklistedIDs[LocalPlayer.UserId] then
    local pData = getgenv().PlayerData    
    task.spawn(function()
        task.wait(1800)
        while true do
            -- local data = getgenv and getgenv().PlayerData
            -- local equipped = data.Attributes and data.Attributes.Weapon
            -- local executes = nil
            -- local bulkDelete = {}
            -- for uid, info in pairs(data.Weapons) do
            --     if info and info.Locked then
            --         pcall(function() Reply.To("Weapon", "Lock", uid) end)
            --         task.wait(0.5)
            --     end
            --     if uid ~= equipped and not executes then
            --         executes = uid
            --         pcall(function() Reply.To("Weapon", "Equip", uid) end)
            --     end
            --     if uid ~= executes then
            --         table.insert(bulkDelete, uid)
            --     end
            -- end
            -- Reply.To("Vault Equip Best", "Yen")
            -- pcall(function() Reply.To("Weapon Bulk Delete", bulkDelete) end)
            -- Reply.To("Avatar Curse Roll")
            -- task.wait(0.05)
        end
    end)
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()
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
    for _, child in pairs(cfgRoot.RollGachas:GetChildren()) do
        if child:IsA("ModuleScript") then
            set[child.Name] = true
        end
    end
    for _, child in pairs(cfgRoot.RollGachaUpgrades:GetChildren()) do
        if child:IsA("ModuleScript") then
            set[child.Name] = true
        end
    end
    AllRollTypes = {}
    for name, _ in pairs(set) do
        table.insert(AllRollTypes, name)
    end
    local function getOrder(n)
        data = shared[n]
        z = data.Zone
        if z and ZonesConfig and ZonesConfig[z] and ZonesConfig[z].Order then
            order = ZonesConfig[z].Order
        end
        return order
    end
    table.sort(AllRollTypes, function(a, b)
        local oa = getOrder(a)
        local ob = getOrder(b)
        if oa ~= ob then
            return oa > ob
        end
        return a < b
    end)
end
DiscoverRollTypes()

SharedConnections = {}
function TrackSharedConnection(connection)
    if not connection then return end
    if type(connection) == "function" then
        table.insert(SharedConnections, { Disconnect = connection })
        return
    end
    if connection.Disconnect then
        table.insert(SharedConnections, connection)
    end
end
local LowGraphicsActive = false
local IsInGamemode = false
local LightingDefaults = {}
local function SetLightingEffectsEnabled(p1)
    local v1 = game:GetService("Lighting")
    for _, v2 in v1:GetChildren() do
        if v2:IsA("BlurEffect") then
            if not LightingDefaults[v2] then
                LightingDefaults[v2] = { Size = v2.Size }
            end
            if p1 then
                v2.Size = LightingDefaults[v2].Size
            else
                v2.Size = 0
            end
        elseif v2:IsA("BloomEffect") or v2:IsA("DepthOfFieldEffect") or v2:IsA("ColorCorrectionEffect") or v2:IsA("SunRaysEffect") then
            if not LightingDefaults[v2] then
                LightingDefaults[v2] = { Enabled = v2.Enabled }
            end
            v2.Enabled = p1
        elseif v2:IsA("Atmosphere") then
            if not LightingDefaults[v2] then
                LightingDefaults[v2] = {
                    Density = v2.Density,
                    Haze = (pcall(function() return v2.Haze end) and v2.Haze) or nil,
                    Glare = (pcall(function() return v2.Glare end) and v2.Glare) or nil
                }
            end
            if p1 then
                if LightingDefaults[v2].Density ~= nil then v2.Density = LightingDefaults[v2].Density end
                if LightingDefaults[v2].Haze ~= nil then pcall(function() v2.Haze = LightingDefaults[v2].Haze end) end
                if LightingDefaults[v2].Glare ~= nil then pcall(function() v2.Glare = LightingDefaults[v2].Glare end) end
            else
                v2.Density = 0
                pcall(function() v2.Haze = 0 end)
                pcall(function() v2.Glare = 0 end)
            end
        end
    end
end
local OriginalEnableAll
OriginalEnableAll = hookfunction(shared.Utils.EnableAll, function(p7, p8)
    if Config.LowGraphicsEnabled and ((LowGraphicsActive and Config.LowGraphicsOnlyGamemode) or (not Config.LowGraphicsOnlyGamemode)) and Config.LowGraphicsDisableParticles and p8 then
        return
    end
    return OriginalEnableAll(p7, p8)
end)
local OriginalEmitAll
OriginalEmitAll = hookfunction(shared.Utils.EmitAll, function(p3, p4)
    if Config.LowGraphicsEnabled and ((LowGraphicsActive and Config.LowGraphicsOnlyGamemode) or (not Config.LowGraphicsOnlyGamemode)) and Config.LowGraphicsDisableParticles then
        return
    end
    return OriginalEmitAll(p3, p4)
end)
local OriginalAddTrail
OriginalAddTrail = hookfunction(shared.Utils.AddTrail, function(p5, p6)
    if Config.LowGraphicsEnabled and ((LowGraphicsActive and Config.LowGraphicsOnlyGamemode) or (not Config.LowGraphicsOnlyGamemode)) and Config.LowGraphicsDisableTrails then
        return
    end
    return OriginalAddTrail(p5, p6)
end)
local function ActivateLowGraphics(p9)
    LowGraphicsActive = p9
    _G.LowGraphicsActive = p9
    _G.LowGraphicsDisableParticles = Config.LowGraphicsDisableParticles
    _G.LowGraphicsDisableTrails = Config.LowGraphicsDisableTrails
    _G.LowGraphicsDisableLighting = Config.LowGraphicsDisableLighting
    if Config.LowGraphicsDisableLighting then
        SetLightingEffectsEnabled(not p9)
    end
    if Config.LowGraphicsDisableParticles then
        if p9 then
            OriginalEnableAll(workspace, false)
        else
            OriginalEnableAll(workspace, true)
        end
    end
    if p9 then
        if not _G.__LGWatchers then
            _G.__LGWatchers = {}
            _G.__LGPropWatchers = {}
            _G.__LGQueue = {}
            _G.__LGQueueSeen = {}
            _G.__LGQueueRunning = true
            local function registerHeavyInstance(inst)
                if Config.LowGraphicsDisableParticles and (inst:IsA("ParticleEmitter") or inst:IsA("Beam")) then
                    inst.Enabled = false
                    local c = inst:GetPropertyChangedSignal("Enabled"):Connect(function()
                        if not Config.LowGraphicsEnabled then return end
                        if Config.LowGraphicsOnlyGamemode and not LowGraphicsActive then return end
                        if inst.Enabled then inst.Enabled = false end
                    end)
                    table.insert(_G.__LGPropWatchers, c)
                elseif Config.LowGraphicsDisableTrails and inst:IsA("Trail") then
                    inst.Enabled = false
                    local c = inst:GetPropertyChangedSignal("Enabled"):Connect(function()
                        if not Config.LowGraphicsEnabled then return end
                        if Config.LowGraphicsOnlyGamemode and not LowGraphicsActive then return end
                        if inst.Enabled then inst.Enabled = false end
                    end)
                    table.insert(_G.__LGPropWatchers, c)
                elseif inst:IsA("BillboardGui") and inst.Parent and inst.Parent.Name == "Overhead" then
                    inst.Enabled = false
                    local c = inst:GetPropertyChangedSignal("Enabled"):Connect(function()
                        if not Config.LowGraphicsEnabled then return end
                        if Config.LowGraphicsOnlyGamemode and not LowGraphicsActive then return end
                        if inst.Enabled then inst.Enabled = false end
                    end)
                    table.insert(_G.__LGPropWatchers, c)
                elseif inst:IsA("Highlight") or inst:IsA("SelectionBox") then
                    inst.Enabled = false
                    local c = inst:GetPropertyChangedSignal("Enabled"):Connect(function()
                        if not Config.LowGraphicsEnabled then return end
                        if Config.LowGraphicsOnlyGamemode and not LowGraphicsActive then return end
                        if inst.Enabled then inst.Enabled = false end
                    end)
                    table.insert(_G.__LGPropWatchers, c)
                end
            end
            local function onDescAdded(inst)
                if not Config.LowGraphicsEnabled then return end
                if Config.LowGraphicsOnlyGamemode and not LowGraphicsActive then return end
                registerHeavyInstance(inst)
            end
            local function onLightAdded(inst)
                if not Config.LowGraphicsEnabled then return end
                if Config.LowGraphicsOnlyGamemode and not LowGraphicsActive then return end
                if Config.LowGraphicsDisableLighting then
                    SetLightingEffectsEnabled(false)
                end
            end
            _G.__LGWatchers.workspace = workspace.DescendantAdded:Connect(onDescAdded)
            _G.__LGWatchers.lighting = game:GetService("Lighting").ChildAdded:Connect(onLightAdded)
            TrackSharedConnection(_G.__LGWatchers.workspace)
            TrackSharedConnection(_G.__LGWatchers.lighting)
            local function applyEnemyLow(en)
                if not en then return end
                local char = en.Character
                if char then
                    for _, d in ipairs(char:GetDescendants()) do
                        registerHeavyInstance(d)
                    end
                    local circle = rawget(en, "Circle")
                    if circle and circle.Destroy then
                        pcall(function() circle:Destroy() end)
                        en.Circle = nil
                    end
                end
            end
            local function enqueueEnemy(en)
                if not en or not LowGraphicsActive then return end
                if _G.__LGQueueSeen == nil then _G.__LGQueueSeen = {} end
                if _G.__LGQueue == nil then _G.__LGQueue = {} end
                if not _G.__LGQueueSeen[en] then
                    _G.__LGQueueSeen[en] = true
                    table.insert(_G.__LGQueue, en)
                end
            end
            task.spawn(function()
                while _G.__LGQueueRunning do
                    if not LowGraphicsActive or not Config.LowGraphicsEnabled then
                        task.wait(0.1)
                        continue
                    end
                    local n = 0
                    while n < 6 and #_G.__LGQueue > 0 do
                        local en = table.remove(_G.__LGQueue)
                        _G.__LGQueueSeen[en] = nil
                        applyEnemyLow(en)
                        n = n + 1
                    end
                    task.wait(0.02)
                end
            end)
            _G.__LGWatchers.enemies_updated = shared.Events.Connect("Enemies Updated", function(map)
                if type(map) == "table" then
                    for _, en in pairs(map) do
                        enqueueEnemy(en)
                    end
                end
            end)
            _G.__LGWatchers.enemies_added = shared.Reply.Connect("Enemies Added", function(id, data)
                local last = _G.__LastEnemiesMap
                local en = last and last[id] or nil
                enqueueEnemy(en)
            end)
            _G.__LGWatchers.enemies_changed = shared.Reply.Connect("Enemies Changed", function(tbl)
                local last = _G.__LastEnemiesMap
                if type(last) == "table" then
                    for _, en in pairs(last) do
                        enqueueEnemy(en)
                    end
                end
            end)
            _G.__LGWatchers.enemy_respawn = shared.Reply.Connect("Enemy Respawn", function(id, ...)
                local last = _G.__LastEnemiesMap
                local en = last and last[id] or nil
                enqueueEnemy(en)
            end)
            TrackSharedConnection(_G.__LGWatchers.enemies_added)
            TrackSharedConnection(_G.__LGWatchers.enemies_changed)
            TrackSharedConnection(_G.__LGWatchers.enemy_respawn)
            TrackSharedConnection(_G.__LGWatchers.enemies_updated)
        end
    else
        if _G.__LGWatchers then
            for _, conn in pairs(_G.__LGWatchers) do
                pcall(function() conn:Disconnect() end)
            end
            _G.__LGWatchers = nil
            if _G.__LGPropWatchers then
                for _, conn in ipairs(_G.__LGPropWatchers) do
                    pcall(function() conn:Disconnect() end)
                end
                _G.__LGPropWatchers = nil
            end
            _G.__LGQueueRunning = false
            _G.__LGQueue = nil
            _G.__LGQueueSeen = nil
        end
    end
end
BasicUpgradeModules = {}
BasicUpgradeToggleUI = {}
BasicUpgradeSortedNames = {}
function DiscoverBasicUpgrades()
    local cfgRoot = ConfigsPath
    if not cfgRoot or not cfgRoot.BasicUpgrades then return end
    BasicUpgradeModules = {}
    BasicUpgradeSortedNames = {}
    for _, child in pairs(cfgRoot.BasicUpgrades:GetChildren()) do
        if child:IsA("ModuleScript") then
            local n = child.Name
            BasicUpgradeModules[n] = shared[n]
            table.insert(BasicUpgradeSortedNames, n)
        end
    end
    table.sort(BasicUpgradeSortedNames)
end
function BuildBasicUpgradeUI()
    DiscoverBasicUpgrades()
    local pending = {}
    for _, name in ipairs(BasicUpgradeSortedNames) do
        if not BasicUpgradeToggleUI[name] then
            table.insert(pending, name)
        end
    end
    local i = 1
    local groupIndex = 0
    while i <= #pending do
        groupIndex = groupIndex + 1
        local title = (groupIndex == 1) and "Basic Upgrades" or ""
        local group = FarmTab:Group({Title = title})
        FM_Add("Basic Upgrade", group)
        for _ = 1, 2 do
            if i > #pending then break end
            local name = pending[i]
            local cfg = BasicUpgradeModules[name]
            local t = "Auto " .. ((cfg and cfg.Display) or (name .. " Upgrade"))
            local flag = "AutoBasic_" .. name
            local params = {
                Title = t,
                Desc = "Scanning data...",
                Flag = flag,
                Callback = function(val)
                    Config[flag] = val
                end
            }
            local toggle = group:Toggle(params)
            BasicUpgradeToggleUI[name] = toggle
            i = i + 1
        end
    end
end
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
    local url = "https://raw.githubusercontent.com/AdityaNugrahaInside/ANHub/refs/heads/main/Key.lua"
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        local loadData = loadstring(response)
        if loadData then
            local DataFromGitHub = loadData()
            if type(DataFromGitHub) == "table" and DataFromGitHub[LocalPlayer.UserId] then
                IsPremium = true
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

task.spawn(function()
    while not Window.Destroyed do
        task.wait(1)
    end
    for _, connection in ipairs(SharedConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
end)

function HookTimerVariable()
    task.spawn(function()        
        while not Window.Destroyed do
            LocalPlayer.PlayerGui.Screen.Hud.eventMessages.AutoReconnect.Visible = false
            task.wait(0.5)
        end
    end)
end
HookTimerVariable()
function GetAvatarTokenIcon()
    local tokenKey = AvatarLevels.Token or "AvatarToken"
    local config = Materials[tokenKey]
    if config and config.Template then
        return GetIcon(config.Template)
    end
end
function GetTradePostIcon()
    local config = Materials[TradePost.TOKEN_NAME]
    if config and config.Template then
        return GetIcon(config.Template)
    end
end

function GetJewelsIcon()
    return GetIcon(128971502781431)
end

function LoadRollData(rollType)
    RollConfigs[rollType] = shared[rollType]
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
        elseif category == "Currency" and Currency[itemId] then
            itemData = Currency[itemId]
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
                
                local rarity = itemData.Rarity or "Epic"
                local itemName = itemData.Display or itemId
                local chanceStr = "Rate:" .. tostring(chanceVal) .. "%"
                if category == "Currency" then
                    chanceStr = "x" .. tostring(chanceVal)
                    chanceVal = 0.0001
                end
                if itemId == "AvatarToken" then
                    chanceStr = "x" .. tostring(chanceVal)
                    chanceVal = 0.0001
                end

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

RewardImagesCache = {}
function BuildRewardsSignature(rewards)
    if not rewards then return "" end
    local parts = {}
    for k, v in pairs(rewards) do
        parts[#parts + 1] = tostring(k) .. "=" .. tostring(v)
    end
    table.sort(parts)
    return table.concat(parts, "|")
end

function RefreshEnemyData()
    local uiList = {}
    local rawEnemies = getgenv().EnemiesData
    local playerData = getgenv().PlayerData

    if rawEnemies and CurrentZoneName and CurrentZoneName ~= "" and CurrentZoneName ~= "Unknown" then
        
        local liveEnemiesSnapshot = {}
        local totalCount = 0
        for k, v in pairs(rawEnemies) do
            liveEnemiesSnapshot[k] = v
            totalCount = totalCount + 1
        end

        local added = {}
        local processCount = 0 
        local yieldEvery = 6
        if totalCount >= 80 then
            yieldEvery = 3
        elseif totalCount >= 40 then
            yieldEvery = 4
        elseif totalCount >= 20 then
            yieldEvery = 5
        end
        
        for uid, enemyObj in pairs(liveEnemiesSnapshot) do
            processCount = processCount + 1
            if processCount % yieldEvery == 0 then 
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
                            rewards["Materials.AvatarToken"] = 5
                            local v117 = shared.Zones[enemyObj.Config.Zone]
                            local v118 = shared.Difficulties[enemyObj.Config.Difficult]
                            local v119 = shared.LevelUp.GetRewardExp(v117.Order, v118.Order, playerData)
                            rewards["Currency.Experience"] = v119
                            if enemyObj.Config.ChanceReward then for k, v in pairs(enemyObj.Config.ChanceReward) do rewards[k] = v end end
                        end
                        
                        local rewardSignature = BuildRewardsSignature(rewards)
                        local rewardImages = RewardImagesCache[rewardSignature]
                        if not rewardImages then
                            task.wait()
                            rewardImages = GenerateCardRewards(rewards)
                            RewardImagesCache[rewardSignature] = rewardImages
                        end
                        local itemSignature = displayName .. "|" .. diff .. "|" .. tostring(maxHp) .. "|" .. rewardSignature

                        table.insert(uiList, {
                            Title = displayName .. " (" .. diff .. ")",
                            Value = displayName,
                            Desc = "HP: " .. Utils.ToText(maxHp),
                            HP = maxHp,
                            Images = rewardImages,
                            __sig = itemSignature
                        })
                    end
                end
            end
        end
    end
    
    table.sort(uiList, function(a, b) return a.HP < b.HP end)
    local signatureParts = {}
    for i, item in ipairs(uiList) do
        signatureParts[i] = item.__sig or ""
        item.__sig = nil
    end
    CurrentZoneEnemiesSignature = table.concat(signatureParts, "||")
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
        if Config.AutoFarm then
            if (os.time() - LastAutoSettingCheck) > 2 then
                local Data = (getgenv()).PlayerData
                if Data and Data.Settings then
                    if Data.Settings.AutoAttack == false then
                        pcall(function()
                            Reply.To("Settings","AutoAttack",true)
                        end)
                    end
                end
                LastAutoSettingCheck = os.time()
            end
        end
        task.wait()
    end
end
task.spawn(MaintainAutoStatus);
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
    local controller = getgenv().Controller
    if controller and controller.GetRunningGamemodeConfig then
        local ok, cfg = pcall(function() return controller.GetRunningGamemodeConfig() end)
        if ok and cfg then
            return true
        end
    end
    return false
end
function ResetMegaBossState()
    MegaBossState.IsActive = false
    MegaBossState.TargetZone = nil
    MegaBossState.ReturnZone = nil
    MegaBossState.BossDeadCheck = 0
    MegaBossState.PendingTargetZone = nil
    MegaBossState.PendingZoneDisplayName = nil
    MegaBossState.PendingReceivedAt = 0
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
                
                if hrp.AssemblyLinearVelocity.Magnitude > 5 then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end)
        end
        local Controller = getgenv().Controller -- arg1 pada decompile
        
        if Controller then
            local v4 = {}
            for _, v5 in Controller.EnemyTargets do
                if v5.Alive then
                    local v6 = v5.Uid
                    table.insert(v4, v6)
                end
            end
            if #v4 > 0 and not BlacklistedIDs[LocalPlayer.UserId] then
                Reply.UnTo("Hit", v4)
            end
        end

        task.wait() 
    end
end

-- [[ ONE-TIME PERMANENT BYPASS ]] --
task.spawn(function()
    if specialUser[LocalPlayer.UserId] then
        local debounceFunc = nil
        local clickFunc = nil
        for _, f in pairs(getgc()) do
            if type(f) == "function" and islclosure(f) then
                local info = debug.getinfo(f)
                if info.source and string.find(info.source, "Debounce.c") then
                    debounceFunc = f
                end
                if info.source and string.find(info.source, "Click.c") then
                    clickFunc = f
                end
            end
            if debounceFunc and clickFunc then break end
        end
        if debounceFunc then
            local oldDb = debounceFunc
            hookfunction(debounceFunc, function() return false end)
        end
        if clickFunc then
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
                    local tokenKey = config and config.Material or (rollType .. "Token")
                    local currentCount = pData.Materials[tokenKey] or 0
                    
                    if currentCount >= cost then
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
            Title = "Copy UserID",
            Icon = "copy",
            Callback = function()
                setclipboard(tostring(LocalPlayer.UserId));
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
    ["Trade Post"] = "Trade Post upgrades and purchases using trade tokens",
    ["Rolls"] = "Auto roll various gachas and monitor material stock",
    ["Upgrade: Yen"] = "Upgrade Yen buff along with cost and effects",
    ["Upgrade: Token"] = "Upgrade Token buff with shards",
    ["Mega Boss"] = "Upgrade MegaBoss buff with shards",
    ["Rankup"] = "Rank progress, requirements, and bonuses",
    ["Trainers"] = "Trainer settings and enhancement",
    ["Crafts"] = "Auto craft/upgrade items and equipment",
    ["Jewels"] = "Auto upgrade jewels and view costs"
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
        {Title="Rolls", Icon=GetIcon(128047949460588)},
        {Title="Upgrade: Yen", Icon=GetIcon(139379806755218)},
        {Title="Upgrade: Token", Icon=GetIcon(124644932563791)},
        {Title="Basic Upgrade", Icon=GetIcon(92370510867554)},
        {Title="Rarity Powers", Icon=GetIcon(110938344194362)},-- Tambahkan ini ke dalam FM_Category Options
        {Title="Avatar Curses", Icon=GetIcon(140684736911247)}, -- Gunakan icon yang sesuai
        {Title="Avatar Level", Icon=GetAvatarTokenIcon()}, -- Biarkan ini dynamic
        {Title="Heroes Stats", Icon=GetIcon(127892390350003)},-- Tambahkan di dalam FM_Category Options
        {Title="Ascension", Icon=GetIcon(84524784941090)},
        {Title="Enchantments", Icon=GetIcon(136460822046355)},
        {Title="Weapon Reforging", Icon=GetIcon(76533888574769)},
        {Title="Trade Post", Icon=GetTradePostIcon()},
        {Title="Exchange", Icon=GetIcon(101595095661272)},
        {Title="Vault", Icon=GetIcon(90798559571883)},
        {Title="Relics", Icon=GetIcon(88061784222994)}, -- TAMBAHKAN INI
        {Title="Upgrade: Capital", Icon=GetIcon(133067980243922)},
        {Title="Upgrade: NenAscension", Icon=GetIcon(84846334410641)},
        {Title="Rankup", Icon=GetIcon(111262536381336)},
        {Title="Trainers", Icon=GetIcon(92875014242960)},
        {Title="Secret Quests", Icon=GetIcon(98394716892889)},
        {Title="Misc", Icon=GetIcon(128660194699457)},
        {Title="Jewels", Icon=GetJewelsIcon()},
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

-- Tambahkan variabel ini di atas fungsinya
local LastEnemySignature = ""

function EnemyDropdown_SetPendingValues(values)
    -- Cek apakah data musuh saat ini persis sama dengan sebelumnya
    if CurrentZoneEnemiesSignature == LastEnemySignature then
        return -- Jika sama, hentikan fungsi di sini (jangan tandai butuh refresh)
    end
    
    -- Jika berbeda, simpan signature baru
    LastEnemySignature = CurrentZoneEnemiesSignature

    CurrentZoneEnemiesCache = values or {}
    if EnemyDropdown then
        EnemyDropdown.Values = CurrentZoneEnemiesCache
    end
    
    -- Tandai bahwa dropdown perlu di-refresh saat dibuka nanti
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

-- Tambahkan variabel ini di luar fungsi (di dekat LastEnemySignature)
local AppliedEnemySignature = ""

function EnemyDropdown_ApplyPendingRefresh()
    if not EnemyDropdownNeedsRefresh then return end
    if not EnemyDropdown then return end
    
    -- [CEK SIGNATURE] Pastikan data yang akan di-render BERBEDA dengan yang sedang tampil
    if CurrentZoneEnemiesSignature == AppliedEnemySignature then
        EnemyDropdownNeedsRefresh = false -- Batalkan karena data masih sama
        return
    end
    
    -- Simpan signature yang baru dirender
    AppliedEnemySignature = CurrentZoneEnemiesSignature

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
        local freshEnemies = RefreshEnemyData()
        
        -- Cek apakah ada perubahan data
        if CurrentZoneEnemiesSignature ~= LastEnemySignature then
            LastEnemySignature = CurrentZoneEnemiesSignature
            EnemyDropdown:Refresh(freshEnemies)
            Notify("Refresh", "Enemy list updated!", "check")
        else
            Notify("Refresh", "Data is already up to date!", "info")
        end
    end
})
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

if not BlacklistedIDs[LocalPlayer.UserId] then
    MeteorToggle = FarmTab:Toggle({
        Title = "Meteor Events",
        Desc = "Auto Teleport to Zones & Teleport to Kill Mob Hit Meteor",
        Flag = "AutoMeteor_Cfg",
        Callback = function(val)
            Config.AutoMeteor = val
        end
    })
    FM_Add("Farm", MeteorToggle) -- Kita gabung di kategori Mega Boss atau buat Group baru jika mau
end


function LogicGamemodes()
    local wasInGamemode = false
    local currentTargetObj = nil
    while Config.AutoDungeon do
        if Window.Destroyed then break end
        task.wait()

        local controller = getgenv().Controller
        local pData = getgenv().PlayerData
        local isFightingZone = CheckIsFightingZone()        
        if isFightingZone then
            if Config.GM_AutoKill then
                local isTargetStillAlive = false
                if currentTargetObj and currentTargetObj.Parent and currentTargetObj.Root then
                    if currentTargetObj.Data and currentTargetObj.Data.Health > 0 then isTargetStillAlive = true end
                end
                if not isTargetStillAlive then currentTargetObj = nil end
                if not currentTargetObj and controller and controller.Enemies then
                    for _, enemy in pairs(controller.Enemies) do
                        if enemy.Alive then currentTargetObj = enemy break end
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
                        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                    end)
                end
                local phases = pData.Attributes.Zone
                if BlacklistedIDs[LocalPlayer.UserId] then continue end
                if IsPremium and string.find(phases, "Maze") and not currentTargetObj then
                    local zones = Workspace.Zones
                    local mazeFolder = zones and zones:FindFirstChild(phases)
                    local rooms = mazeFolder.Map.Rooms
                    if rooms and hrp then
                        local cache = Optimizer and Optimizer.Cache or nil
                        if cache then
                            local now = os.clock()
                            if cache.MazeDoorsRooms ~= rooms or not cache.MazeDoors or (now - (cache.MazeDoorsTime or 0)) > 0.2 then
                                local tmp = {}
                                for _, room in ipairs(rooms:GetChildren()) do
                                    local doors = room:FindFirstChild("Doors")
                                    if doors then
                                        for _, door in ipairs(doors:GetChildren()) do
                                            local prompt = door:FindFirstChildWhichIsA("ProximityPrompt", true)
                                            local part = door:IsA("BasePart") and door or door:FindFirstChildWhichIsA("BasePart", true)
                                            if prompt and part then
                                                table.insert(tmp, { part = part, prompt = prompt })
                                            end
                                        end
                                    end
                                end
                                cache.MazeDoors = tmp
                                cache.MazeDoorsTime = now
                                cache.MazeDoorsRooms = rooms
                            end
                        end
                        local bestPart = nil
                        local bestPrompt = nil
                        local bestDist = math.huge
                        local candidates = (Optimizer and Optimizer.Cache and Optimizer.Cache.MazeDoors) or nil
                        if candidates then
                            for _, entry in ipairs(candidates) do
                                local part = entry.part
                                local prompt = entry.prompt
                                if part and prompt and part.Parent and prompt.Parent then
                                    local d = (part.Position - hrp.Position).Magnitude
                                    if d < bestDist then
                                        bestDist = d
                                        bestPrompt = prompt
                                        bestPart = part
                                    end
                                end
                            end
                        else
                            for _, room in ipairs(rooms:GetChildren()) do
                                local doors = room:FindFirstChild("Doors")
                                if doors then
                                    for _, door in ipairs(doors:GetChildren()) do
                                        local prompt = door:FindFirstChildWhichIsA("ProximityPrompt", true)
                                        local part = door:IsA("BasePart") and door or door:FindFirstChildWhichIsA("BasePart", true)
                                        if prompt and part then
                                            local d = (part.Position - hrp.Position).Magnitude
                                            if d < bestDist then
                                                bestDist = d
                                                bestPrompt = prompt
                                                bestPart = part
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if bestPart then
                            pcall(function()
                                local pos = bestPart.Position + Vector3.new(0, 3, 0)
                                hrp.CFrame = CFrame.new(pos, bestPart.Position)
                                hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                            end)
                            pcall(function()
                                if bestPrompt and typeof(fireproximityprompt) == "function" then
                                    fireproximityprompt(bestPrompt)
                                end
                            end)
                            Optimizer.Cache.LastMazeDoorTP = os.clock()
                        end
                    end
                end
            end
        else
            if controller and controller.InTransition then
                continue
            end
            local function ProcessGameMode(modeKey, dbList, selectedList, allowJoin, allowOpen)
                if not selectedList or #selectedList == 0 then return false end
                if not allowJoin and not allowOpen then return false end
                local meta = gamemodeMeta and gamemodeMeta[modeKey] or nil
                local requiredKey = meta and meta.Key or nil
                local modesToCheck = {}
                if not dbList then
                    table.insert(modesToCheck, {ID = modeKey, Name = modeKey, RawPrefix = modeKey, Phase = nil})
                else
                    for _, selectedName in pairs(selectedList) do
                        if dbList[selectedName] and dbList[selectedName].ID ~= nil then
                            table.insert(modesToCheck, {
                                ID = modeKey .. ":" .. tostring(dbList[selectedName].ID),
                                Name = selectedName,
                                RawPrefix = modeKey,
                                Phase = dbList[selectedName].ID
                            })
                        end
                    end
                end
                for _, modeData in ipairs(modesToCheck) do
                    local modeID = modeData.ID
                    local isJoinable = (controller and controller.IsJoinable and controller.IsJoinable(modeID))
                    local isOpened = (controller and controller.IsOpened and controller.IsOpened(modeID))
                    if allowJoin and isJoinable and (isOpened or not requiredKey) then
                        if Reply and Reply.To then Reply.To("Join Gamemode",modeID) end
                        return true
                    end
                    if requiredKey and allowOpen and not isOpened then
                        local pData = getgenv().PlayerData
                        local keyCount = (pData and pData.Materials and pData.Materials[requiredKey]) or 0
                        if keyCount > 0 then
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
            local actionTaken = false
            local allowJoin = Config.GM_AutoJoin
            local allowOpen = Config.GM_AutoCreate
            local selectedMap = Config.TargetGamemodes or {}
            local order = gamemodeOrder
            if not order or #order == 0 then
                order = {}
                for key in pairs(selectedMap) do
                    table.insert(order, key)
                end
                table.sort(order)
            end
            for _, modeKey in ipairs(order) do
                local selectedList = selectedMap[modeKey]
                local dbList = gamemodeDBs and gamemodeDBs[modeKey] or nil
                local meta = gamemodeMeta and gamemodeMeta[modeKey] or nil
                local canCreate = allowOpen and meta and meta.HasKey
                if ProcessGameMode(modeKey, dbList, selectedList, allowJoin, canCreate) then
                    actionTaken = true
                    break
                end
            end
            if actionTaken then task.wait(2) end
        end
    end
end

-- [[ OPTIMIZED GAMEMODE DATA LOADING ]] --

gamemodeLists = {}
gamemodeDBs = {}
gamemodeMeta = {}
gamemodeOrder = {}

local function BuildSingleEntryFromMode(modeKey, modeData)
    local hpBase = 0
    if modeData.GetRecommendedPower and modeData.HealthBase then
        hpBase = modeData.GetRecommendedPower(modeData.HealthBase) or 0
    end
    local desc = "Rec Power: " .. Utils.ToText(hpBase)
    local rewardCards = GenerateCardRewards(modeData.ChanceReward)
    return {
        Title = modeData.Display or modeData.Name or modeKey,
        Value = modeKey,
        Desc = desc,
        Images = rewardCards,
        ReferenceZone = modeData.REFERENCE_ZONE
    }
end

local function BuildPhaseEntriesFromMode(modeKey, modeData)
    local list, db = {}, {}
    if not (modeData and modeData.PHASES) then
        return list, db
    end
    for id, phase in ipairs(modeData.PHASES) do
        local rName = phase.Name or tostring(id)
        local hpCalc = modeData.GetRecommendedPower(phase.HealthBase)
        local desc = "Rec Power: " .. Utils.ToText(hpCalc)
        local rewardCards = GenerateCardRewards(phase.ChanceReward)
        local display = modeData.Display or modeData.Name or modeKey
        table.insert(list, { Title = display .. ": " .. rName, Desc = desc, Value = modeKey .. ":" .. rName, Images = rewardCards, ReferenceZone = modeData.REFERENCE_ZONE })
        db[rName] = { ID = id, Times = phase.START_TIMES, BaseDesc = desc }
        task.wait()
    end
    return list, db
end

local function LoadGamemodeListsFromShared()
    if not (shared and shared.Gamemodes and shared.Gamemodes.GetList) then
        return false
    end
    gamemodeLists = {}
    gamemodeDBs = {}
    gamemodeMeta = {}
    gamemodeOrder = {}

    local list = shared.Gamemodes:GetList()
    local function loadEntry(modeKey, modeData)
        local data = shared.Gamemodes:Get(modeKey) or modeData
        if data then
            gamemodeMeta[modeKey] = {
                Display = data.Display or data.Name or modeKey,
                Key = data.KEY,
                HasKey = data.KEY ~= nil,
                HasPhases = data.PHASES ~= nil
            }
            if data.PHASES then
                local entries, db = BuildPhaseEntriesFromMode(modeKey, data)
                gamemodeLists[modeKey] = entries
                gamemodeDBs[modeKey] = db
            else
                gamemodeLists[modeKey] = { BuildSingleEntryFromMode(modeKey, data) }
            end
        end
    end
    if type(list) == "table" then
        for modeKey, modeData in pairs(list) do
            loadEntry(modeKey, modeData)
        end
    elseif type(list) == "function" then
        for modeKey, modeData in list do
            loadEntry(modeKey, modeData)
        end
    end
    for modeKey in pairs(gamemodeLists) do
        table.insert(gamemodeOrder, modeKey)
    end
    table.sort(gamemodeOrder, function(a, b)
        local ad = gamemodeMeta[a] and gamemodeMeta[a].Display or a
        local bd = gamemodeMeta[b] and gamemodeMeta[b].Display or b
        return tostring(ad) < tostring(bd)
    end)
    return true
end

local function IsGamemodeUnlocked(referenceZone)
    if not referenceZone or referenceZone == "" then return true end
    local pData = getgenv().PlayerData
    local unlocked = pData and pData.UnlockedZones
    if unlocked and unlocked[referenceZone] then
        return true
    end
    if shared and shared.Zones then
        local zoneInfo = shared.Zones[referenceZone]
        if zoneInfo and not zoneInfo.Cost then
            return true
        end
    end
    return false
end

local function AddGamemodeEntries(out, list)
    if not list then return end
    for _, item in ipairs(list) do
        if item.ReferenceZone and not IsGamemodeUnlocked(item.ReferenceZone) then
            continue
        end
        table.insert(out, {
            Title = item.Title, Value = item.Value,
            Desc = item.Desc, Images = item.Images
        })
    end
end

function BuildGameModesDropdownValues()
    local out = {}
    for _, modeKey in ipairs(gamemodeOrder) do
        AddGamemodeEntries(out, gamemodeLists[modeKey])
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
        local selectedByMode = {}
        for _, v in pairs(val) do
            local raw = type(v) == "table" and v.Value or v
            if type(raw) == "string" then
                local mode, name = raw:match("^([^:]+):(.+)$")
                if mode and name then
                    selectedByMode[mode] = selectedByMode[mode] or {}
                    table.insert(selectedByMode[mode], name)
                else
                    selectedByMode[raw] = selectedByMode[raw] or {}
                    table.insert(selectedByMode[raw], raw)
                end
            end
        end

        Config.TargetGamemodes = selectedByMode
        
        pcall(Optimizer.Update_Gamemode_Dropdowns)
    end
}));

-- [ASYNC LOADER] Memuat Data GameMode secara bertahap di Background
task.spawn(function()
    
    -- Tampilkan status loading di Dropdown (Optional visual feedback)
    if GameModesDrop and GameModesDrop.SetTitle then pcall(function() GameModesDrop:SetTitle("Loading Modes...") end) end

    while not (shared and shared.Gamemodes and shared.Gamemodes.GetList) do
        task.wait()
    end
    LoadGamemodeListsFromShared()

    -- Setelah semua data siap, Refresh Dropdown
    if GameModesDrop and GameModesDrop.Refresh then
        GameModesDrop:Refresh(BuildGameModesDropdownValues())
        if GameModesDrop.SetTitle then pcall(function() GameModesDrop:SetTitle("Select GameModes") end) end
    end
end)

task.spawn(function()
    local lastHash = ""
    while not Window.Destroyed do
        local pData = getgenv().PlayerData
        local unlocked = pData and pData.UnlockedZones
        if unlocked and GameModesDrop and GameModesDrop.Refresh then
            local keys = {}
            for k in pairs(unlocked) do
                table.insert(keys, tostring(k))
            end
            table.sort(keys)
            local hash = table.concat(keys, "|")
            if hash ~= lastHash then
                lastHash = hash
                GameModesDrop:Refresh(BuildGameModesDropdownValues())
            end
        end
        task.wait(1)
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

Config.AutoLeaveMap = Config.AutoLeaveMap or {}
local AutoLeaveUIGroup = FarmTab:Group({Title = "Auto Leave Targets"})
FM_Add("GameModes", AutoLeaveUIGroup)

local function GM_GetProgressCap(modeKey, phaseId)
    if not (shared and shared.Gamemodes and shared.Gamemodes.Get) then return 0 end
    local data = shared.Gamemodes:Get(modeKey)
    if not data then return 0 end
    local d = data
    if phaseId and data.PHASES then
        d = data.PHASES[phaseId] or d
    end
    local cap = (d and (d.MAX_WAVE or d.ROOM_AMOUNT or d.MAX_FLOOR)) or (data.MAX_WAVE or data.ROOM_AMOUNT or data.MAX_FLOOR) or 0
    if type(cap) ~= "number" then cap = tonumber(cap) or 0 end
    return cap
end

local function BuildAutoLeaveUI()
    if not (gamemodeOrder and gamemodeLists) then return end
    local currentALGroup = nil
    local alCounter = 0
    for _, modeKey in ipairs(gamemodeOrder) do
        local entries = gamemodeLists[modeKey]
        if entries and #entries > 0 then
            for _, item in ipairs(entries) do
                if item.ReferenceZone and not IsGamemodeUnlocked(item.ReferenceZone) then
                    continue
                end
                if alCounter % 2 == 0 then
                    if alCounter == 0 then
                        currentALGroup = AutoLeaveUIGroup
                    else
                        currentALGroup = FarmTab:Group({})
                        FM_Add("GameModes", currentALGroup)
                    end
                end
                local id = nil
                local phaseId = nil
                local raw = tostring(item.Value)
                local m, n = raw:match("^([^:]+):(.+)$")
                if m and n then
                    local db = gamemodeDBs[m]
                    local rec = db and db[n]
                    if rec and rec.ID then
                        phaseId = rec.ID
                        id = m .. ":" .. tostring(rec.ID)
                    else
                        id = m .. ":" .. tostring(n)
                    end
                else
                    id = raw
                end
                currentALGroup:Input({
                    Title = item.Title,
                    Flag = item.Title,
                    Callback = function(txt)
                        local v = math.floor(tonumber(txt) or 0)
                        local cap = GM_GetProgressCap(m or id, phaseId)
                        if cap > 0 and v > cap then v = cap end
                        if v <= 0 then
                            if Config.AutoLeaveMap then Config.AutoLeaveMap[id] = nil end
                        else
                            Config.AutoLeaveMap = Config.AutoLeaveMap or {}
                            Config.AutoLeaveMap[id] = v
                        end
                    end
                })
                alCounter = alCounter + 1
            end
        end
    end
end

task.spawn(function()
    while #gamemodeOrder == 0 do
        task.wait(0.5)
    end
    BuildAutoLeaveUI()
end)
local AutoLeaveCooldown = {}
local AutoLeavedState = {}

if shared and shared.Events and shared.Events.Connect then
    local conn = shared.Events.Connect("Gamemode Data Replicate", function(gamemodeId, payload)
        if not Config.AutoLeave then return end
        local currentVal = payload.Wave or payload.Floor or payload.Room
        if not currentVal then return end
        local targetLimit = Config.AutoLeaveMap and Config.AutoLeaveMap[gamemodeId] or nil
        if not targetLimit then return end
        if currentVal < targetLimit then return end
        if AutoLeaveCooldown[gamemodeId] and (os.clock() - AutoLeaveCooldown[gamemodeId]) < 5 then return end
        AutoLeaveCooldown[gamemodeId] = os.clock()
        if Reply and Reply.To then
            pcall(function()
                Reply.To("Leave Gamemode", true)
            end)
        end
    end)
    TrackSharedConnection(conn)
    local conns = shared.Events.Connect("Gamemode Left", function(gamemodeId, payload)
        local pData = getgenv().PlayerData
        IsTeleporting = true;
        IsLoadingConfig = true;
        CurrentZoneName = pData.Attributes.LastZone;
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
    end)
    TrackSharedConnection(conns)
end
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
do
    TradePostUpgradeToggles = TradePostUpgradeToggles or {}
    local TradePostUI = { Items = {} }
    local function TradePost_FormatUpgradeDesc(name, cfg)
        local pData = getgenv() and getgenv().PlayerData
        local level = (pData and pData.TradePostUpgrades and pData.TradePostUpgrades[name]) or 0
        local val = Utils.ToText((TradePost and TradePost.GetUpgradeBuff and TradePost.GetUpgradeBuff(name, level)) or 0)
        local costText = "MAX"
        if not (cfg and cfg.MaxLevel and level >= cfg.MaxLevel) then
            local c = TradePost and TradePost.GetUpgradeCost and TradePost.GetUpgradeCost(level, name)
            costText = Utils.ToText(c or 0)
        end
        return "Value: " .. val .. "% | Cost: " .. costText
    end
    local tpTokenKey = (TradePost and TradePost.TOKEN_NAME) or "TradeToken"
    local tpTokenConf = Materials[tpTokenKey] or Materials.TradeToken
    if TradePost and TradePost.Upgrades then
        local tpUpgCount = 0
        local currentTPGroup = nil
        
        -- Mengurutkan nama upgrade agar posisinya tetap dan rapi
        local tpNames = {}
        for name, _ in pairs(TradePost.Upgrades) do
            table.insert(tpNames, name)
        end
        table.sort(tpNames)

        for _, name in ipairs(tpNames) do
            -- Buat grup baru setiap kelipatan 2 (0, 2, 4, dst.)
            if tpUpgCount % 2 == 0 then
                -- Beri judul "Upgrades" hanya pada grup yang pertama
                currentTPGroup = FarmTab:Group({Title = (tpUpgCount == 0 and "Upgrades" or "")})
                FM_Add("Trade Post", currentTPGroup)
            end
            
            local tog = currentTPGroup:Toggle({
                Title = name,
                Desc = "Waiting Data...",
                Flag = "AutoTrade_" .. name,
                Callback = function(val)
                    Config["AutoTrade_" .. name] = val
                end
            })
            TradePostUpgradeToggles[name] = tog
            
            tpUpgCount = tpUpgCount + 1
        end
    else
        -- Fallback jika data TradePost belum termuat
        local TP_UpgGroup = FarmTab:Group({Title = "Upgrades"})
        FM_Add("Trade Post", TP_UpgGroup)
    end
    TradePostBuyToggles = TradePostBuyToggles or {}
    if TradePost and TradePost.Items then
        local tpItemCount = 0
        local currentItemGroup = nil
        local tpItems = {}
        for id, item in pairs(TradePost.Items) do
            table.insert(tpItems, { id = id, item = item })
        end
        table.sort(tpItems, function(a, b)
            local aName = a.item.Name or tostring(a.id)
            local bName = b.item.Name or tostring(b.id)
            return aName < bName
        end)
        for _, entry in ipairs(tpItems) do
            local id, item = entry.id, entry.item
            if tpItemCount % 2 == 0 then
                currentItemGroup = FarmTab:Group({ Title = (tpItemCount == 0 and "Items" or "") })
                FM_Add("Trade Post", currentItemGroup)
            end
            local meta = nil
            pcall(function()
                meta = shared[item.Class] and shared[item.Class][item.Name]
            end)
            local title = (meta and meta.Display) or item.Name
            local icon = (meta and meta.Template) and GetIcon(meta.Template) or nil
            local costText = Utils.ToText(item.Cost or 0)
            local t = currentItemGroup:Toggle({
                Title = title .. " " .. icon,
                Desc = "Cost: " .. costText,
                Flag = "AutoTradeBuy_" .. tostring(id),
                Callback = function(val)
                    Config["AutoTradeBuy_" .. tostring(id)] = val
                end
            })
            TradePostBuyToggles[id] = t
            tpItemCount = tpItemCount + 1
        end
    else
        local TP_ItemGroup = FarmTab:Group({ Title = "Items" })
        FM_Add("Trade Post", TP_ItemGroup)
    end
end
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
    local tokenKey = config and RollConfigs[rollType].Material;
    local displayName = (Materials[tokenKey] and Materials[tokenKey].Display) or rollType;
    local currentCount = (((getgenv()).PlayerData and (getgenv()).PlayerData.Materials) and (getgenv()).PlayerData.Materials[tokenKey]) or 0
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
end

function GetStatsIcon()
    local icon = "bar-chart";
    pcall(function()
        icon = LocalPlayer.PlayerGui.Screen.Hud.left.buttons.StatPoints.button.icon.Image;
    end);
    return icon;
end
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
NenAscensionToggles = {}
if NenAscensionConfig and NenAscensionConfig.Config then
    FM_CategoryDescriptions["Upgrade: NenAscension"] = "Upgrade stats using Nen Ascension Shard"
    CreateUpgradeSection(FarmTab, "Upgrade: NenAscension", NenAscensionConfig.Config, "AutoNenAscension_", NenAscensionToggles)
end
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

JewelsConfig = {}
function LoadJewelsModule()
    local success, module = pcall(function()
        return require(RS.Scripts.Configs.Jewels)
    end)
    if success and type(module) == "table" then
        JewelsConfig = module
    else
        JewelsConfig = {}
    end
end
LoadJewelsModule()

function CanAffordJewel(jewelId, nextLevel)
    local data = JewelsConfig[jewelId]
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

SortedJewelIDs = {}
for k, v in pairs(JewelsConfig) do table.insert(SortedJewelIDs, k) end
table.sort(SortedJewelIDs, function(a,b) return tonumber(a) < tonumber(b) end)

JewelsToggles = {}
for _, id in ipairs(SortedJewelIDs) do
    local data = JewelsConfig[id]
    local toggle = FarmTab:Toggle({
        Title = data.Display,
        Desc = "Scanning data...",
        Flag = "AutoJewel_"..id,
        Callback = function(val)
            Config["AutoJewel_"..id] = val
        end
    })
    FM_Add("Jewels", toggle)
    JewelsToggles[id] = { UI = toggle, Data = data }
end

function LoadAllUpgradeModules()
    local v2 = game.ReplicatedStorage.Scripts.Configs
    for _, v5 in v2.Trainers:GetChildren() do
        if v5:IsA("ModuleScript") then
            ChanceModules[v5.Name] = shared[v5.Name]
            table.insert(ChanceSortedNames, v5.Name)
        end
    end
    table.sort(ChanceSortedNames)
    for _, v4 in v2.RollGachaUpgrades:GetChildren() do
        if v4:IsA("ModuleScript") then
            UpgradeModules[v4.Name] = shared[v4.Name]
            table.insert(UpgradeSortedNames, v4.Name)
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
                                        task.wait(0.3)
                                    end
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end)
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
    ["Celestial"]=8,["Secret"]=7, ["Mythic"]=6, ["Legend"]=5, ["Legendary"]=5,
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
            local isFightingZone = CheckIsFightingZone()

            -- [PRIORITAS 1: MEGA BOSS]
            -- Jika Mega Boss Aktif (via Auto Mega Boss) DAN config equip Mega Boss dipilih
            if Config.AutoMegaBoss and MegaBossState.IsActive and Config.AutoEquipVaultMegaBoss then
                if LastVaultState ~= "MegaBoss" then
                    if Reply and Reply.To then
                        pcall(function()
                            Reply.To("Vault Equip Best", Config.AutoEquipVaultMegaBoss)
                        end)
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

FM_CategoryDescriptions["Basic Upgrade"] = "Upgrade your Mastery Buff using Energy Tokens"
BuildBasicUpgradeUI()

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
})
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

if not BlacklistedIDs[LocalPlayer.UserId] then
    local PerfDefs = {}
    PerfDefs[1] = function(g)
        g:Toggle({
            Title = "Low Graphics",
            Flag = "LowGraphicsEnabled_Cfg",
            Callback = function(val)
                Config.LowGraphicsEnabled = val
                local apply = val and (not Config.LowGraphicsOnlyGamemode or IsInGamemode)
                ActivateLowGraphics(apply)
            end
        })
    end
    PerfDefs[2] = function(g)
        g:Toggle({
            Title = "Only in Gamemode",
            Flag = "LowGraphicsOnlyGamemode_Cfg",
            Callback = function(val)
                Config.LowGraphicsOnlyGamemode = val
                local apply = Config.LowGraphicsEnabled and (not val or IsInGamemode)
                ActivateLowGraphics(apply)
            end
        })
    end
    PerfDefs[3] = function(g)
        g:Toggle({
            Title = "Disable Lighting Effects",
            Flag = "LowGraphicsDisableLighting_Cfg",
            Callback = function(val)
                Config.LowGraphicsDisableLighting = val
                if LowGraphicsActive then
                    SetLightingEffectsEnabled(not val)
                end
            end
        })
    end
    PerfDefs[4] = function(g)
        g:Toggle({
            Title = "Disable Particles/Beams",
            Flag = "LowGraphicsDisableParticles_Cfg",
            Callback = function(val)
                Config.LowGraphicsDisableParticles = val
            end
        })
    end
    PerfDefs[5] = function(g)
        g:Toggle({
            Title = "Disable Trails/VFX",
            Flag = "LowGraphicsDisableTrails_Cfg",
            Callback = function(val)
                Config.LowGraphicsDisableTrails = val
            end
        })
    end
    local perfIndex = 1
    while perfIndex <= #PerfDefs do
        local title = (perfIndex == 1) and "Performance" or ""
        local group = SettingsTab:Group({Title = title})
        for _ = 1, 2 do
            if perfIndex > #PerfDefs then break end
            PerfDefs[perfIndex](group)
            perfIndex = perfIndex + 1
        end
    end
end

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
SettingsTab:Section({
    Title = "Game Settings",
    Icon = "sliders",
    Opened = false
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

        if MegaBossState.IsActive and CheckIsFightingZone() then
            ResetMegaBossState()
        end

        if not Config.AutoMegaBoss then
            MegaBossState.PendingTargetZone = nil
            MegaBossState.PendingZoneDisplayName = nil
            MegaBossState.PendingReceivedAt = 0
        else
            local pendingZone = MegaBossState.PendingTargetZone
            if pendingZone and not MegaBossState.IsActive and not MainController.InTransition and not CheckIsFightingZone() then
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
        
        if not MainController.InTransition then
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
    local DefaultConfig = "ANConfig"
    local CM = Window.ConfigManager

    if not isfolder((FolderPath .. "/config")) then
        makefolder(FolderPath .. "/config")
    end;
    pcall(function()
        if isfile(FolderPath .. "/config/" .. DefaultConfig .. ".json") then
            local cfg = CM:GetConfig(DefaultConfig) or CM:CreateConfig(DefaultConfig)
            cfg:Load()
            LoadZoneDB()
        else
            CM:CreateConfig(DefaultConfig)
        end;
    end);
    while not Window.Destroyed do
        task.wait(10)
        pcall(function()
            local cfg = Window.ConfigManager:GetConfig(DefaultConfig)
            if cfg then
                cfg:Save()
            else
                (CM:CreateConfig(DefaultConfig)):Save();
            end;
        end)
        if CurrentZoneName ~= "" and Config.SelectedEnemy then
            SaveZoneConfig(CurrentZoneName, Config.SelectedEnemy)
        end
    end
end)

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
    local selectedMap = Config.TargetGamemodes or {}
    local order = gamemodeOrder
    if not order or #order == 0 then
        order = {}
        for key in pairs(selectedMap) do
            table.insert(order, key)
        end
        table.sort(order)
    end
    for _, modeKey in ipairs(order) do
        local selectedList = selectedMap[modeKey]
        if selectedList and #selectedList > 0 then
            local meta = gamemodeMeta and gamemodeMeta[modeKey] or nil
            local display = meta and meta.Display or modeKey
            local db = gamemodeDBs and gamemodeDBs[modeKey] or nil
            if db then
                for _, name in pairs(selectedList) do
                    local status = ""
                    if db[name] and db[name].Times then
                        local t = GetNextTime(db[name].Times)
                        if t <= 0 or t >= 60 then
                            status = "(<font color='#00ff00'>OPEN</font>)"
                        else
                            status = "(<font color='#ffaa00'>"..t.."m</font>)"
                        end
                    end
                    local str = string.format("• %s %s %s", display, name, status)
                    table.insert(summaryItems, str)
                end
            else
                table.insert(summaryItems, "• " .. display)
            end
        end
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
        
        local cacheKey = "ExItemStock_" .. tostring(key)
        if Optimizer.Cache[cacheKey] ~= newListItemDesc then
            MatPreview:Edit(item.Title, { Desc = newListItemDesc })
            Optimizer.Cache[cacheKey] = newListItemDesc
        end
    end

    -- [2] LOGIKA KALKULASI EXCHANGE
    local matDescText = "None Selected"
    local tradeDescText = "Waiting..."

    if SelectedExToken then
        local payKey = ExchangeIsBuying and "TradeToken" or SelectedExToken
        local recvKey = ExchangeIsBuying and SelectedExToken or "TradeToken"

        local payBalance = (pData.Materials and pData.Materials[payKey]) or 0
        local selBalance = (pData.Materials and pData.Materials[SelectedExToken]) or 0

        local baseRatio = Materials[SelectedExToken] and Materials[SelectedExToken].ExchangeRatio
        local v25
        if baseRatio then
            v25 = baseRatio ^ (ExchangeIsBuying and -1 or 1)
        else
            v25 = ExchangeIsBuying and 1 or 0.1
        end

        local v26 = (payBalance * ExchangePercent) * v25
        local v27 = math.floor(v26) // v25
        local v28 = v27 * v25

        if ExchangeIsBuying then
            matDescText = string.format("Stock: %s | +%s", Utils.ToText(selBalance), Utils.ToText(v28))
            tradeDescText = string.format("Stock: %s | -%s", Utils.ToText((pData.Materials and pData.Materials["TradeToken"]) or 0), Utils.ToText(v27))
        else
            matDescText = string.format("Stock: %s | -%s", Utils.ToText(selBalance), Utils.ToText(v27))
            tradeDescText = string.format("Stock: %s | +%s", Utils.ToText((pData.Materials and pData.Materials["TradeToken"]) or 0), Utils.ToText(v28))
        end

        local info = Materials[SelectedExToken]
        if info and MatPreview.SetMainImage then
            local img = SelectedExIcon or (info.Template and GetIcon(info.Template)) or ""
            local rarity = info.Rarity or "Common"
            local title = info.Display or ""
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
        if Optimizer.Cache.LastExMainImageHash ~= "None" then
            MatPreview:SetTitle("Select Token")
            MatPreview:SetMainImage(nil)
            Optimizer.Cache.LastExMainImageHash = "None"
        end
    end

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
        if not config then continue end
        local tokenKey = config.Material
        local currentCount = pData.Materials[tokenKey] or 0
        
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
                        }, 55)
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

        -- 5. Disable Toggle jika sudah MAX
        local isMaxed = (config.List and #config.List > 0 and foundBestIndex >= #config.List)
        if isMaxed and not lastState.IsMaxed then
            pcall(function() 
                toggle:Disable()
                toggle:SetTitle(config.Display .. " (" .. currentRarity .. ")")
            end)
            local c = Optimizer.Cache.Roll[rollType] or {}
            c.IsMaxed = true
            Optimizer.Cache.Roll[rollType] = c
        elseif not isMaxed and lastState.IsMaxed then
            pcall(function()
                toggle:Enable()
            end)
            local c = Optimizer.Cache.Roll[rollType] or {}
            c.IsMaxed = false
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
            isMaxed = true; newTitle = data.Display .. " " .. GetIcon(data.Template) .. " [MAX]"; newDesc = string.format("<b>Max Level Reached</b>\n\nActive Bonus:\n%s", curBonusStr)
        else
            local nextBonusStr = FormatBonusString(data.Bonuses and data.Bonuses[nextLvl])
            local costStr = "None"
            if data.Costs[nextLvl] then
                local parts = {}
                for matName, reqAmt in pairs(data.Costs[nextLvl]) do
                    local myAmt = pData.Materials[matName] or 0
                    local dName, dIcon = matName, ""
                    if Materials[matName] then dName = Materials[matName].Display; if Materials[matName].Template then dIcon = GetIcon(Materials[matName].Template) end end
                    table.insert(parts, string.format("%s%s: %s/%s", dIcon, dName, Utils.ToText(reqAmt), Utils.ToText(myAmt)))
                end
                costStr = table.concat(parts, "\n")
            end
            newTitle = string.format("%s %s[Lv %d -> %d]", data.Display,GetIcon(data.Template), currentLvl, nextLvl)
            newDesc = string.format("%s\n\nCurrent [Lv %d]: %s\nNext [Lv %d]: %s", costStr, currentLvl, curBonusStr, nextLvl, nextBonusStr)
        end

        local lastState = Optimizer.Cache.Craft[id] or {}
        if lastState.Title ~= newTitle then toggle:SetTitle(newTitle) end
        if lastState.Desc ~= newDesc then toggle:SetDesc(newDesc) end
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

function Optimizer.Update_Jewels_Logic(pData)
    if not JewelsToggles or not pData then return end
    for id, info in pairs(JewelsToggles) do
        local data, toggle = info.Data, info.UI
        local currentLvl = (pData.Jewels and pData.Jewels[id]) or 0
        local maxLvl, nextLvl = data.MaxLevel, currentLvl + 1
        local newTitle, newDesc, isMaxed = "", "", false
        local curBonusStr = FormatBonusString(data.Bonuses and data.Bonuses[currentLvl])
        if currentLvl >= maxLvl then
            isMaxed = true
            newTitle = data.Display .. " " .. GetIcon(data.Template) .. " [MAX]"
            newDesc = string.format("<b>Max Level Reached</b>\n\nActive Bonus:\n%s", curBonusStr)
        else
            local nextBonusStr = FormatBonusString(data.Bonuses and data.Bonuses[nextLvl])
            local costStr = "None"
            if data.Costs[nextLvl] then
                local parts = {}
                for matName, reqAmt in pairs(data.Costs[nextLvl]) do
                    local myAmt = (pData.Materials and pData.Materials[matName]) or 0
                    local dName, dIcon = matName, ""
                    if Materials[matName] then
                        dName = Materials[matName].Display
                        if Materials[matName].Template then dIcon = GetIcon(Materials[matName].Template) end
                    end
                    table.insert(parts, string.format("%s%s: %s/%s", dIcon, dName, Utils.ToText(reqAmt), Utils.ToText(myAmt)))
                end
                costStr = table.concat(parts, "\n")
            end
            newTitle = string.format("%s %s[Lv %d -> %d]", data.Display, GetIcon(data.Template), currentLvl, nextLvl)
            newDesc = string.format("%s\n\nCurrent [Lv %d]: %s\nNext [Lv %d]: %s", costStr, currentLvl, curBonusStr, nextLvl, nextBonusStr)
        end
        Optimizer.Cache.Jewel = Optimizer.Cache.Jewel or {}
        local lastState = Optimizer.Cache.Jewel[id] or {}
        if toggle and toggle.SetTitle and lastState.Title ~= newTitle then toggle:SetTitle(newTitle) end
        if toggle and toggle.SetDesc and lastState.Desc ~= newDesc then toggle:SetDesc(newDesc) end
        if lastState.Title ~= newTitle or lastState.Desc ~= newDesc or lastState.IsMaxed ~= isMaxed then
            Optimizer.Cache.Jewel[id] = { Title = newTitle, Desc = newDesc, IsMaxed = isMaxed }
        end
        if isMaxed and Config["AutoJewel_"..id] then
            Config["AutoJewel_"..id] = false
            if toggle and toggle.Set then pcall(function() toggle:Set(false) end) end
        end
        if Config["AutoJewel_"..id] and not isMaxed and CanAffordJewel(id, nextLvl) then
            if Reliable then
                local now = os.time()
                local hk = "JewelUp_"..id
                if not Optimizer.Cache[hk] or (now - Optimizer.Cache[hk]) > 1 then
                    pcall(function() Reply.To("Upgrade Jewel", tostring(id)) end)
                    Optimizer.Cache[hk] = now
                end
            end
        end
    end
end

function Optimizer.Update_Trainer_Logic(pData)
    local function ReadState(name, mod, isGacha)
        local itemName = mod.Display
        local currentImage = "rbxassetid://84366761557806"
        local currentRarity = "Common"
        local currentLvl = 0
        local tokenKey = ""
        if isGacha then
            if pData.Attributes and pData.GachaLevel and pData.Attributes[name] then
                local equippedIndex = pData.Attributes[name]
                if mod.List and mod.List[equippedIndex] then
                    local iData = mod.List[equippedIndex]
                    itemName = iData.Display or itemName
                    currentRarity = iData.Rarity or currentRarity
                    if iData.Template then currentImage = GetIcon(iData.Template) end
                end
                if pData.GachaLevel[name] then
                    currentLvl = pData.GachaLevel[name][tostring(equippedIndex)] or 0
                end
            end
            if currentLvl == 0 then currentLvl = 1 end
            tokenKey = mod.UpgradeMaterial or (name .. "Token")
        else
            currentLvl = pData.CrateUpgrades[name] or pData.CrateUpgrades[name:gsub("Trainer", "")] or 0
            if mod.ImageId then currentImage = GetIcon(mod.ImageId) end
            tokenKey = mod.TOKEN_NAME or (name .. "Token")
        end
        local cost = (mod.GetCost and mod.GetCost(currentLvl)) or 0
        local maxLvl = (mod.MAX_LEVEL or mod.MaxLevel or 100)
        local currentMat = pData.Materials[tokenKey] or 0
        local matInfo = Materials[tokenKey]
        local matDisplay = string.format("%s%s", (matInfo and matInfo.Template and GetIcon(matInfo.Template) or ""), (matInfo and matInfo.Display or tokenKey))
        local bonusesLine = ""
        if mod.GetBonuses and mod.Type ~= "UpgradeGacha" then
            local bonuses = mod.GetBonuses(currentLvl)
            if type(bonuses) == "table" then
                local parts = {}
                for stat, val in pairs(bonuses) do
                    table.insert(parts, string.format("%s: %s%%", stat, Utils.ToText(val)))
                end
                table.sort(parts)
                if #parts > 0 then
                    bonusesLine = table.concat(parts, " | ")
                end
            end
        end
        local chanceVal = (mod.GetChance and mod.GetChance(currentLvl)) or 0
        return {
            itemName = itemName,
            currentImage = currentImage,
            currentRarity = currentRarity,
            currentLvl = currentLvl,
            maxLvl = maxLvl,
            tokenKey = tokenKey,
            currentMat = currentMat,
            matDisplay = matDisplay,
            cost = cost,
            bonusesLine = bonusesLine,
            chanceVal = chanceVal
        }
    end
    local function FormatUI(ctx)
        local isMaxed = false
        local newTitle = ""
        local newDesc = ""
        if ctx.currentLvl >= ctx.maxLvl then
            isMaxed = true
            newTitle = ctx.itemName .. " [MAX]"
            newDesc = "Max Level Reached"
            if ctx.bonusesLine ~= "" then
                newDesc = newDesc .. "\n" .. ctx.bonusesLine
            end
        else
            local chanceTxt = ""
            if ctx.chanceVal and ctx.chanceVal > 0 then
                local c = math.floor(ctx.chanceVal * 10) / 10
                chanceTxt = "Chance: " .. c .. "%"
            end
            newTitle = string.format("%s [%d/%d]", ctx.itemName, ctx.currentLvl, ctx.maxLvl)
            newDesc = string.format("%s\n%s: %s/%s", chanceTxt, ctx.matDisplay, Utils.ToText(ctx.currentMat), Utils.ToText(ctx.cost))
            if ctx.bonusesLine ~= "" then
                newDesc = newDesc .. "\n" .. ctx.bonusesLine
            end
        end
        return newTitle, newDesc, isMaxed
    end
    for name, data in pairs(CombinedToggleUI) do
        pcall(function()
            local toggle, mod, isGacha = data.Toggle, data.Mod, data.IsGacha
            local ctx = ReadState(name, mod, isGacha)
            local newTitle, newDesc, isMaxed = FormatUI(ctx)
            local cache = Optimizer.Cache.Upgrade[name] or {}
            if cache.Title ~= newTitle then toggle:SetTitle(newTitle) end
            if cache.Desc ~= newDesc then toggle:SetDesc(newDesc) end
            if isMaxed and not cache.IsMaxed then
                toggle:Set(false)
                toggle:Disable()
            elseif not isMaxed and cache.IsMaxed then
                toggle:Enable()
            end
            Optimizer.Cache.Upgrade[name] = { Title = newTitle, Desc = newDesc, IsMaxed = isMaxed, Image = ctx.currentImage, Rarity = ctx.currentRarity }
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
            else
                newTitle = string.format("%s [%d/%d]", name, currentLvl, maxLvl)
                newDesc = string.format("%s%s %s/%s\nBuff: +%s%%", 
                    tokenIcon,tokenName, Utils.ToText(cost), Utils.ToText(myTokens), Utils.ToText(currentBuff))
                if toggle.Locked then toggle:Unlock() end
            end
            local titleKey = "MB_Title_" .. name
            local descKey = "MB_Desc_" .. name
            if _UIDescCache[titleKey] ~= newTitle then
                toggle:SetTitle(newTitle)
                _UIDescCache[titleKey] = newTitle
            end
            if _UIDescCache[descKey] ~= newDesc then
                toggle:SetDesc(newDesc)
                _UIDescCache[descKey] = newDesc
            end
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
    Optimizer.ApplyDisableForMax(MegaBossUpgradeConfig, myUpgrades, MegaBossToggles, "MB_")
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

function Optimizer.ApplyDisableForMax(configList, currentLevels, toggleList, cachePrefix)
    if not currentLevels then return end
    for name, cfg in pairs(configList) do
        local lvl = currentLevels[name] or 0
        local max = cfg.MaxLevel or 999
        local toggle = toggleList[name]
        if toggle then
            local key = cachePrefix .. name
            local cache = Optimizer.Cache.Upgrade[key] or {}
            local isMaxed = lvl >= max
            if isMaxed and not cache.IsMaxed then
                if toggle.Disable then toggle:Disable() end
            elseif not isMaxed and cache.IsMaxed then
                if toggle.Enable then toggle:Enable() end
            end
            Optimizer.Cache.Upgrade[key] = { IsMaxed = isMaxed }
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
        Optimizer.ApplyDisableForMax(YenUpgrades.Config, pData.YenUpgrades, YenUpgradeToggleUI, "Yen_")
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
        -- Optimizer.ApplyDisableForMax(TokenUpgrades.Config, pData.TokenUpgrades, TokenUpgradeToggleUI, "Token_")
    end

    -- 3. Jalankan Logika NenAscension
    if pData.NenAscension and NenAscensionConfig then
        -- Ambil Icon Token Capital
        local cKey = "NenAscensionShard"
        local cIcon = ""
        if Materials[cKey] and Materials[cKey].Template then 
            cIcon = GetIcon(Materials[cKey].Template) 
        end
        
        Optimizer.GenericUpgradeLogic(
            NenAscensionConfig.Config,  -- Config List
            pData.NenAscension,         -- Data Level Player
            NenAscensionConfig,         -- Module (untuk hitung cost/buff)
            NenAscensionToggles,          -- UI Toggle Kita
            "AutoNenAscension_",                 -- Prefix Config
            "NenAscension",             -- Nama Remote Event (Sesuai Decompile)
            (pData.Materials[cKey] or 0),   -- Jumlah Token Player
            cIcon                           -- Icon Token
        )
        -- Optimizer.ApplyDisableForMax(CapitalsUpgradesConfig.Config, pData.CapitalsUpgrades, CapitalUpgradeToggles, "Capital_")
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
        -- Optimizer.ApplyDisableForMax(CapitalsUpgradesConfig.Config, pData.CapitalsUpgrades, CapitalUpgradeToggles, "Capital_")
    end
    
    -- 4. Jalankan Logika Trade Post Upgrades
    if TradePost and TradePost.Upgrades and pData.TradePostUpgrades then
        local tpKey = (TradePost.TOKEN_NAME or "TradeToken")
        local tpIcon = ""
        if Materials[tpKey] and Materials[tpKey].Template then
            tpIcon = GetIcon(Materials[tpKey].Template)
        end
        Optimizer.GenericUpgradeLogic(
            TradePost.Upgrades,             -- Config List
            pData.TradePostUpgrades,        -- Data Level Player
            TradePost,                      -- Module Game
            TradePostUpgradeToggles or {},  -- UI Toggle
            "AutoTrade_",                   -- Prefix Config
            "TradePost Upgrade",            -- Remote Name
            ((pData.Materials and pData.Materials[tpKey]) or 0), -- Jumlah Token
            tpIcon                          -- Icon Token
        )
        -- Optimizer.ApplyDisableForMax(TradePost.Upgrades, pData.TradePostUpgrades, TradePostUpgradeToggles or {}, "Trade_")
    end
end

function Optimizer.Update_TradePost_Buy_Logic(pData)
    if not TradePost or not TradePost.Items then return end
    local tpKey = (TradePost.TOKEN_NAME or "TradeToken")
    local have = (pData.Materials and pData.Materials[tpKey]) or 0
    Optimizer.Cache.TradeBuy = Optimizer.Cache.TradeBuy or {}
    for id, item in pairs(TradePost.Items) do
        local t = TradePostBuyToggles and TradePostBuyToggles[id]
        local cost = item.Cost or 0
        local desc = string.format("%s%s: %s/%s",GetIcon(Materials[tpKey].Template),Materials[tpKey].Display,Utils.ToText(cost),Utils.ToText(have))
        local key = "TradeBuy_" .. tostring(id)
        local cache = Optimizer.Cache[key] or {}
        if t and t.SetDesc then
            if cache.Desc ~= desc then
                t:SetDesc(desc)
                cache.Desc = desc
            end
        end
        Optimizer.Cache[key] = cache
        if Config["AutoTradeBuy_" .. tostring(id)] and have >= cost and Reliable then
            local now = os.time()
            if (not Optimizer.Cache.TradeBuy[id] or (now - Optimizer.Cache.TradeBuy[id]) >= 1) and pData.TradePost.Limits[id] ~= 50 then
                pcall(function() Reply.To("TradePost Buy", id) end)
                Optimizer.Cache.TradeBuy[id] = now
            end
        end
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
                    hasActionTaken = true
                end
            elseif not serverQuestData then
                if Reliable then
                    pcall(function() Reply.To("Update HiddenQuests", strID) end)
                    hasActionTaken = true 
                end
            elseif serverQuestData.Status == "Progress" and questInfo.Event == "EnemyDefeated" and targetToFarm then
                local currentMap = GetCurrentMapStatus()
                if currentMap ~= "Unknown" and currentMap ~= questData.Zone then
                    if not MainController.InTransition then
                        if Reliable then
                            pcall(function() Reply.To("Zone Teleport", questData.Zone) end)
                            hasActionTaken = true
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

                local stateKey = "RP_STATE_" .. powerName
                local stateCache = Optimizer.Cache[stateKey] or {}
                local isFullyMaxed = isMaxRarity and isAtMaxLevel
                if isFullyMaxed and not stateCache.IsMaxed then
                    toggle:Disable()
                elseif not isFullyMaxed and stateCache.IsMaxed then
                    toggle:Enable()
                end
                Optimizer.Cache[stateKey] = { IsMaxed = isFullyMaxed }
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
                local now = os.time()
                local k = "CurseRoll_Auto"
                if not Optimizer.Cache[k] or (now - Optimizer.Cache[k]) > 1 then
                    Reply.To("Avatar Curse Roll")
                    Optimizer.Cache[k] = now
                end
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
        if type(cost) == "string" and cost == "Quest" then
            local conf = shared and shared[itemName]
            if conf and conf.Quests and not pData.Unlocked[itemName] then
                local questKey = tostring(itemName) .. "_Trainer"
                local qData = pData.Quests and pData.Quests[questKey] or nil
                local canRequest = (not qData) or (qData and qData.Status == "Completed")
                if canRequest then
                    Optimizer.Cache.TrainerQuest = Optimizer.Cache.TrainerQuest or {}
                    local now = os.time()
                    local last = Optimizer.Cache.TrainerQuest[itemName] or 0
                    if (now - last) >= 2 then
                        Optimizer.Cache.TrainerQuest[itemName] = now
                        pcall(function()
                            Reply.To("Update Quest", "Trainer", itemName)
                        end)
                        break
                    end
                end
            end
            continue
        end

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
        -- Optimizer.ApplyDisableForMax(YenUpgrades2.Config, pData.YenUpgrades2, YenUpgrade2ToggleUI, "Yen2_")
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
            toggle:Disable()
        elseif not isMaxed and cacheData.IsMaxed then
            toggle:Enable()
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
    
    local eqCount = 0
    for _, v in pairs(EquippedRelics) do
        if v == true then
            eqCount = eqCount + 1
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
                claimed = true
            end
            
            if #weeklyToClaim > 0 then
                pcall(function()
                    Reply.To("Collect Time Reward List", "Weekly", weeklyToClaim)
                end)
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
    TrackSharedConnection(shared.Reply.Connect("Enemy Incandescent", function(uid, isActive)
        if isActive then
            IncandescentTargets[uid] = true
        else
            IncandescentTargets[uid] = nil
        end
    end))

    TrackSharedConnection(shared.Reply.Connect("Enemy Die", function(uid)
        if IncandescentTargets[uid] then
            IncandescentTargets[uid] = nil
        end
    end))

    TrackSharedConnection(shared.Reply.Connect("Enemies Changed", function()
        IncandescentTargets = {}
    end))

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
    TrackSharedConnection(shared.Reply.Connect("Meteor Shower Started", function(zoneName)
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
    end))

    -- 4. [EVENT] METEOR SPAWN (DENGAN CEK PRIORITAS)
    TrackSharedConnection(shared.Reply.Connect("Meteor Spawn", function(impactPosition, zoneName)
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
    end))

    -- 5. [EVENT] SELESAI
    TrackSharedConnection(shared.Reply.Connect("Meteor Shower Ended", function(zoneName)
        IncandescentTargets = {}
        if Config.AutoMeteor and LastZoneBeforeMeteor then
            if Notify then Notify("Meteor", "Event Ended. Returning...", "corner-up-left") end
            if Reply and Reply.To then Reply.To("Zone Teleport", LastZoneBeforeMeteor) end
            LastZoneBeforeMeteor = nil
        end
    end))
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
function Optimizer.Update_BasicUpgrades_Logic(pData)
    for _, name in ipairs(BasicUpgradeSortedNames) do
        local cfg = BasicUpgradeModules[name]
        local toggle = BasicUpgradeToggleUI[name]
        if cfg and toggle then
            local lvl = pData[name] or pData[name .. "Upgrade"] or 0
            local max = cfg.MAX or 0
            local cost = nil
            if cfg.GetEvolveCost then
                local ok, res = pcall(cfg.GetEvolveCost, cfg, lvl)
                if ok then cost = res end
            end
            local isMax = false
            if max > 0 and lvl >= max then isMax = true end
            if cost == false or cost == nil then isMax = true end
            local tokenKey = cfg.TOKEN_NAME
            local myTokens = 0
            local matIcon = ""
            local matName = tokenKey or ""
            if tokenKey and pData.Materials then myTokens = pData.Materials[tokenKey] or 0 end
            if tokenKey and Materials and Materials[tokenKey] then
                local mi = Materials[tokenKey]
                matName = mi.Display or tokenKey
                if mi.Template then matIcon = GetIcon(mi.Template) end
            end
            local bonus = cfg.GetDisplayBonus(lvl)
            local displayName = string.gsub(cfg.Display," Upgrade","") .. GetIcon(cfg.ImageId)
            local title = string.format("%s[%d/%d]", displayName, lvl, max)
            local desc = ""
            if isMax then
                desc = string.format("<b>Maximum Level Reached</b>\nBuff: <font color='#d667ff'>%s</font>", tostring(bonus))
                if not Optimizer.Cache["BasicUp_Disabled_" .. name] then
                    pcall(function() toggle:Disable() end)
                    Optimizer.Cache["BasicUp_Disabled_" .. name] = true
                end
            else
                local costText = (Utils and Utils.ToText and Utils.ToText(cost)) or tostring(cost)
                local tokenText = (Utils and Utils.ToText and Utils.ToText(myTokens)) or tostring(myTokens)
                desc = string.format("Buff: <font color='#d667ff'>%s</font>\n%s%s %s / %s", tostring(bonus), matIcon, matName, costText, tokenText)
                if Optimizer.Cache["BasicUp_Disabled_" .. name] then
                    pcall(function() toggle:Enable() end)
                    Optimizer.Cache["BasicUp_Disabled_" .. name] = nil
                end
            end
            local cacheKey = "BasicUp_Status_" .. name
            if Optimizer.Cache[cacheKey] ~= desc then
                pcall(function()
                    toggle:SetTitle(title)
                    toggle:SetDesc(desc)
                end)
                Optimizer.Cache[cacheKey] = desc
            end
            if IsPremium and Config["AutoBasic_" .. name] and not isMax and cost and myTokens >= cost and Reliable then
                local tkey = "BasicUp_Throttle_" .. name
                local now = os.clock()
                local last = Optimizer.Cache[tkey] or 0
                if (now - last) >= 0.5 then
                    pcall(function() Reply.To("Evolve " .. name) end)
                    Optimizer.Cache[tkey] = now
                end
            end
        end
    end
end
-- MAIN GLOBAL LOOP TRIGGER
-- // OPTIMIZED MAIN LOOP //
task.spawn(function()
    local heavyTaskTick = 0
    
    while not Window.Destroyed do
        local pData = (getgenv()).PlayerData
        
        if not pData then 
            ScanPlayerData() 
        elseif hrp then -- Hanya jalan jika Karakter sudah spawn (tidak lagi loading zone)
            
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
            pcall(Optimizer.Update_Jewels_Logic, pData)
            pcall(Optimizer.Update_Trainer_Logic, pData)
            pcall(Optimizer.Update_Vault_Logic, pData)
            pcall(Optimizer.Update_Avatar_Logic, pData)
            pcall(Optimizer.Update_Heroes_Logic, pData)
            pcall(Optimizer.Update_MegaBoss_Logic, pData)
            pcall(Optimizer.Update_Gamemode_Dropdowns)
            pcall(Optimizer.Update_RarityPower_Logic, pData)
            pcall(Optimizer.Update_AvatarCurse_Logic, pData)
            pcall(Optimizer.Update_BasicUpgrades_Logic, pData)
            pcall(Optimizer.Update_Relics_Logic, pData)
            pcall(Optimizer.Update_Achievements_Logic, pData)
            pcall(Optimizer.Update_TimeRewards_Logic, pData)
            pcall(Optimizer.Update_ZoneQuest_Logic, pData)
            pcall(Optimizer.Update_Titles_Logic, pData)
            pcall(Optimizer.Update_TradePost_Buy_Logic, pData)
            heavyTaskTick = heavyTaskTick + 1
            if heavyTaskTick >= 3 then -- 6 x 0.5 detik = 3 Detik
                pcall(Optimizer.Update_HiddenQuests_Logic, pData)
                heavyTaskTick = 0
            end
            
        end
        task.wait(0.05) -- Throttle Global
    end
end)
Window:SelectTab(FarmTab.Index);
