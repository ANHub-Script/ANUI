-- if game.PlaceId ~= 81897457567012 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Saiyan Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local FolderPath = "ANUI/SaiyanIncremental"
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local LastConfigFile = FolderPath .. "/LastConfig.txt"
local IsPremium = false
local ValidKeys = {"ANHUB-2025"}
local MapDBFile = "Map_Database.json"
local Config = {
    SelectedEnemy = nil,
    MapConfigurations = {},
    Upgraders = {
    },
    AutoFarm = {
        Enabled = false,
        World = "Naruto",
        Platform = "2",
        OrbIndex = "sequential",
        Mode = "Teleport",
        TweenSpeed = 0.5,
        HeightOffset = 5,
        CollectInterval = 0.1,
        MinDistance = 5,
    }

}
local UpgradesData, UpgradeOwnership, UpgradeLevels, Network, Util, Signal
local StarterPlayer = game:GetService("StarterPlayer")
pcall(function()
    UpgradesData = require(ReplicatedStorage.Modules.Data.UpgradesData)
    UpgradeOwnership = require(ReplicatedStorage.Modules.Utils.UpgradeOwnership)
    UpgradeLevels = require(ReplicatedStorage.Modules.Services.UpgradeLevels)
    Network = require(ReplicatedStorage.Modules.Utils.Network)
    Util = require(StarterPlayer.StarterPlayerScripts.Modules.Util)
    NumberFormatter = require(ReplicatedStorage.Modules.Utils.NumberFormatter)
    Signal = require(ReplicatedStorage.Modules.Utils.Signal)
    Icons = require(ReplicatedStorage.Modules.Data.Icons)
end)

local ConfigName = "ANConfig"
local CurrentMapEnemiesCache = {}
local IsLoadingConfig = false
local IsLoadingMapSelection = false
local ConfigNameInput

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

    return Window.ConfigManager:CreateConfig(ConfigName)
end

local function JSONPretty(val, indent)
    indent = indent or 0;
    local valType = typeof(val);
    
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
        return "\"" .. val:GetFullName() .. "\""; 
    elseif valType == "function" then
        local info = debug.getinfo(val)
        return "\"function: " .. tostring(info.source) .. " | Line: " .. tostring(info.linedefined) .. "\"";
    else
        local result = tostring(val)
        if valType == "number" or valType == "boolean" then
            return result
        else
            return "\"" .. result .. "\""
        end
    end;
end;

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

local function SecureWipe()
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
    elseif isfolder and isfolder(FolderPath) then
        isExpired = true
    end

    if isExpired then
        if isfile(ExpiryFile) then
            delfile(ExpiryFile)
        end

        local possiblePaths = { FolderPath }
        local userId = tostring(LocalPlayer.UserId)
        
        for _, path in pairs(possiblePaths) do
            if isfolder and isfolder(path) then
                for _, file in pairs(listfiles(path)) do
                    if string.find(file, ".key") or string.find(file, ".json") or string.find(file, userId) then
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
    Title = "AN Hub - Saiyan Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "SaiyanIncremental",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Saiyan Incremental" }),
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
    ["Farm"] = "Auto Upgrade Section All Ingame",
    ["Champ Upgrade"] = "Auto Upgrade Champ",
    ["Progressions"] = "Auto Rankup,Prestige,Sacrifice,Condensed Energy Converter",
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
        Desc = "Saiyan Incremental"
    }),
    SidebarProfile = false
});

-- Pembuatan Selector Kategori
FM_CategorySelector = MainTabs:Category({
    Title = "Select Category",
    Default = "Farm",
    Options = {
        {Title = "Farm", Icon = GetIcon(131036042070680)},
        {Title = "Upgrades", Icon = GetIcon(84524784941090)}, -- icon bisa disesuaikan
        {Title = "Champ Upgrade", Icon = GetIcon(128971502781431)}, -- icon bisa disesuaikan
        {Title = "Skills", Icon = GetIcon(133067980243922)},
    },
    Callback = FM_OnChange
})
FM_CategoryDescriptions["Upgrades"] = "Auto Upgrade All Boards"

if FM_CategorySelector.ElementFrame then 
    FM_CategorySelector.ElementFrame.Parent = MainTabs.UIElements.ContainerFrameCanvas 
    FM_CategorySelector.ElementFrame.Position = UDim2.new(0, 0, 0, MainTabs.UIElements.ContainerFrame.Position.Y.Offset)
    
    local catSize = FM_CategorySelector.ElementFrame.Size.Y.Offset
    MainTabs.UIElements.ContainerFrame.Position = UDim2.new(0, 0, 0, MainTabs.UIElements.ContainerFrame.Position.Y.Offset + catSize)
    MainTabs.UIElements.ContainerFrame.Size = UDim2.new(1, 0, 1, MainTabs.UIElements.ContainerFrame.Size.Y.Offset - catSize)
    
    local pad = MainTabs.UIElements.ContainerFrame:FindFirstChildOfClass("UIPadding")
    if pad then pad.PaddingTop = UDim.new(0, 5) end
end
local ManagedLoops = {}

local function ShouldStopManagedLoop()
    return not IsWindowAlive()
end

local function StopManagedLoop(key)
    ManagedLoops[key] = nil
end

local function StopManagedLoopValue(value)
    if not value then
        return
    end

    for key, current in pairs(ManagedLoops) do
        if current == value then
            ManagedLoops[key] = nil
            return
        end
    end
end

local function StartManagedLoop(key, interval, predicate, callback)
    StopManagedLoop(key)

    local token = {}
    ManagedLoops[key] = token

    task.spawn(function()
        while ManagedLoops[key] == token do
            if ShouldStopManagedLoop() then
                ManagedLoops[key] = nil
                break
            end

            local shouldRun = true
            if predicate then
                local ok, result = pcall(predicate)
                shouldRun = ok and result or false
            end

            if shouldRun then
                pcall(callback)
            end

            task.wait(interval)
        end
    end)

    return token
end

local function StopAllManagedLoops()
    for key in pairs(ManagedLoops) do
        ManagedLoops[key] = nil
    end
end
-- =====================================================
-- AUTO FARM SCRAPS (RESOURCE INCREMENTAL) - TWEEN WALKING
-- =====================================================
local TweenService = game:GetService("TweenService")

-- State
local AutoFarm_LastPosition = nil
local AutoFarm_SamePositionCount = 0
local AutoFarm_CurrentScrapIndex = 1
local AutoFarm_CurrentTarget = nil
local AutoFarm_IsWalking = false

function AutoFarm_ResetState()
    AutoFarm_LastPosition = nil
    AutoFarm_SamePositionCount = 0
    AutoFarm_CurrentScrapIndex = 1
    AutoFarm_CurrentTarget = nil
    AutoFarm_IsWalking = false
end

-- Dapatkan karakter
function AutoFarm_GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

function AutoFarm_GetHRP()
    local char = AutoFarm_GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

function AutoFarm_GetHumanoid()
    local char = AutoFarm_GetCharacter()
    return char and char:FindFirstChildWhichIsA("Humanoid")
end

-- Dapatkan semua scraps
function AutoFarm_GetAllScraps()
    local scraps = {}
    local scrapsFolder = Workspace:FindFirstChild("W0WoodPieces")
    if not scrapsFolder then return scraps end
    
    local function collectParts(instance)
        for _, child in ipairs(instance:GetChildren()) do
            if child:IsA("BasePart") and child.Transparency < 1 then
                table.insert(scraps, child)
            elseif child:IsA("Model") or child:IsA("Folder") then
                collectParts(child)  -- turun ke dalam model/folder
            end
        end
    end
    collectParts(scrapsFolder)
    return scraps
end

-- Dapatkan posisi scrap
function AutoFarm_GetScrapPosition(scrap)
    return scrap.Position
end

-- Cek terlalu dekat dengan posisi sebelumnya
function AutoFarm_IsTooClose(newPosition)
    if not AutoFarm_LastPosition then return false end
    local minDist = tonumber(Config.AutoFarm.MinDistance) or 5
    return (newPosition - AutoFarm_LastPosition).Magnitude < minDist
end

-- Dapatkan index scrap berikutnya
function AutoFarm_GetNextScrapIndex(totalScraps)
    local mode = Config.AutoFarm.OrbIndex
    if mode == "nearest" then return "nearest" end
    if mode == "random" then return math.random(1, totalScraps) end
    if mode == "sequential" then
        local idx = AutoFarm_CurrentScrapIndex
        AutoFarm_CurrentScrapIndex = AutoFarm_CurrentScrapIndex + 1
        if AutoFarm_CurrentScrapIndex > totalScraps then
            AutoFarm_CurrentScrapIndex = 1
        end
        return idx
    end
    return "nearest"
end

-- Pindah ke posisi (TELEPORT atau TWEEN WALK)
function AutoFarm_MoveToPosition(targetPosition)
    local humanoid = AutoFarm_GetHumanoid()
    local hrp = AutoFarm_GetHRP()
    if not humanoid or not hrp then return false end
    
    if Config.AutoFarm.Mode == "Teleport" then
        -- Teleport langsung
        local height = tonumber(Config.AutoFarm.HeightOffset) or 5
        hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, height, 0))
        return true
    end
    
    -- Mode Tween = Walking
    -- Hanya update target jika berubah signifikan
    if AutoFarm_CurrentTarget and (AutoFarm_CurrentTarget - targetPosition).Magnitude < 3 then
        return AutoFarm_IsWalking -- Masih berjalan ke target yang sama
    end
    
    AutoFarm_CurrentTarget = targetPosition
    AutoFarm_IsWalking = true
    
    -- Gunakan Humanoid:MoveTo untuk walking animation
    humanoid:MoveTo(targetPosition)
    
    -- Deteksi saat sudah sampai
    task.spawn(function()
        local startTime = os.clock()
        local timeout = 10 -- Maksimal 10 detik
        
        while AutoFarm_IsWalking and (os.clock() - startTime) < timeout do
            if not hrp or not hrp.Parent then
                AutoFarm_IsWalking = false
                break
            end
            
            local dist = (hrp.Position - targetPosition).Magnitude
            if dist < (tonumber(Config.AutoFarm.MinDistance) or 5) then
                AutoFarm_IsWalking = false
                break
            end
            
            -- Cek kalau stuck (posisi tidak berubah)
            if AutoFarm_LastPosition and (hrp.Position - AutoFarm_LastPosition).Magnitude < 0.5 then
                AutoFarm_SamePositionCount = AutoFarm_SamePositionCount + 1
                if AutoFarm_SamePositionCount >= 10 then
                    -- Stuck, lompat kecil
                    hrp.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                    AutoFarm_SamePositionCount = 0
                end
            else
                AutoFarm_SamePositionCount = 0
            end
            
            AutoFarm_LastPosition = hrp.Position
            task.wait(0.2)
        end
        
        AutoFarm_IsWalking = false
    end)
    
    return true
end

-- Main logic
function AutoFarm_TeleportToScrap()
    local scraps = AutoFarm_GetAllScraps()
    if #scraps == 0 then return false end
    
    -- Jika masih berjalan, jangan ganggu
    if Config.AutoFarm.Mode == "Tween" and AutoFarm_IsWalking then
        return true
    end
    
    local scrapIndex = AutoFarm_GetNextScrapIndex(#scraps)
    local targetScrap
    
    if scrapIndex == "nearest" then
        local hrp = AutoFarm_GetHRP()
        if not hrp then return false end
        local playerPos = hrp.Position
        local nearestDist = math.huge
        for _, scrap in ipairs(scraps) do
            local pos = AutoFarm_GetScrapPosition(scrap)
            local dist = (pos - playerPos).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                targetScrap = scrap
            end
        end
    else
        targetScrap = scraps[scrapIndex]
    end
    
    if not targetScrap then return false end
    local targetPos = AutoFarm_GetScrapPosition(targetScrap)
    
    local hrp = AutoFarm_GetHRP()
    if not hrp then return false end
    local minDist = tonumber(Config.AutoFarm.MinDistance) or 5
    
    -- Sudah dekat? Skip
    if (targetPos - hrp.Position).Magnitude < minDist then
        return false
    end
    
    -- Anti-stuck: ganti target jika posisi sama terus
    if Config.AutoFarm.Mode == "Tween" and AutoFarm_IsTooClose(targetPos) then
        AutoFarm_SamePositionCount = AutoFarm_SamePositionCount + 1
        if AutoFarm_SamePositionCount >= 3 then
            targetScrap = scraps[math.random(1, #scraps)]
            targetPos = AutoFarm_GetScrapPosition(targetScrap)
            AutoFarm_SamePositionCount = 0
            if not targetPos then return false end
        else
            return false
        end
    end
    
    return AutoFarm_MoveToPosition(targetPos)
end
-- =====================================================
-- AUTO FARM SCRAPS (HEARTBEAT THREAD)
-- =====================================================
local AutoFarmThread = nil

function startAutoFarmThread()
    local interval = math.max(tonumber(Config.AutoFarm.CollectInterval) or 0.1, 0.05)
    AutoFarmThread = StartManagedLoop("AutoFarmWoodPieces", interval, function()
        return Config.AutoFarm.Enabled
    end, function()
        AutoFarm_TeleportToScrap()
    end)
end
local FarmGroups = MainTabs:Group({})
FarmGroups:Toggle({
    Title = "Scraps",
    Image = GetIcon(126864658174743),
    Flag = "AutoFarm_Enabled",
    Callback = function(val)
        Config.AutoFarm.Enabled = val
        if val then
            AutoFarm_ResetState()
            startAutoFarmThread()
        else
            StopManagedLoop("AutoFarmWoodPieces")
            AutoFarmThread = nil
        end
    end
})
FarmGroups:Toggle({
    Title = "Auto Kame",
    Image = Icons["Chi"],
    Flag = "AutoKame_Enabled",
    Callback = function(val)
        Config.Kame = val
    end
})
FM_Add("Farm", FarmGroups)


FM_Add("Farm", MainTabs:Toggle({
    Title = "Auto Rebirth",
    Image = Icons["Rebirth"],
    Flag = "AutoRebirth_Enabled",
    Callback = function(val)
        Config.Rebirth = val
    end
}))
-- Refresh periodik setiap 2 detik (untuk update harga, level, dll)
task.spawn(function()
    while not Window.Destroyed do
        if Config.Kame then
            local Event = game:GetService("ReplicatedStorage").Modules.Utils.Network["E:W0KameAttempt"]
            Event:FireServer(1.0)
        end
        if Config.Rebirth then
            local Event = game:GetService("ReplicatedStorage").Modules.Utils.Network["F:Rebirth"]
            Event:InvokeServer("Rebirth")
        end
        task.wait(0.5)
    end
end)
FM_Add("Farm", FarmGroups)

-- setclipboard(JSONPretty(Util:GetData(), 1))
-- =====================================================
-- HELPER UPGRADE (SESUAI CLIENT)
-- =====================================================

function getUpgradeData(boardKey, upgradeKey)
    if not UpgradesData or not boardKey then return nil end
    local board = UpgradesData[boardKey]
    if not board then return nil end
    return board[upgradeKey]
end

function getCurrentLevel(boardKey, upgradeKey)
    if not Util then return 0 end
    return Util:GetUpgadesLevel(boardKey, upgradeKey) or 0
end
function getMaxLevel(boardKey, upgradeKey)
    if not Util or not UpgradeLevels then return 1 end
    return UpgradeLevels.GetMaxLevel(Util:GetData(), boardKey, upgradeKey)
end
function getCost(boardKey, upgradeKey, level)
    local board = UpgradesData and UpgradesData[boardKey]
    if board and board.NextPrice and type(board.NextPrice) == "function" then
        return board.NextPrice(upgradeKey, level)
    end
    -- fallback
    local upgData = getUpgradeData(boardKey, upgradeKey)
    if upgData and upgData.StartPrice and upgData.PriceMult then
        return math.floor(upgData.StartPrice * (upgData.PriceMult ^ level))
    end
    return 0
end

function isUpgradeUnlocked(boardKey, upgradeKey)
    if not UpgradeOwnership or not Util then return true end
    local upgData = getUpgradeData(boardKey, upgradeKey)
    if not upgData then return false end
    local lockedBy = upgData.LockedBy
    if not lockedBy then return true end
    return UpgradeOwnership.Owns(Util:GetData(), lockedBy)
end

function getRewardText(boardKey, upgradeKey, level)
    local upgData = getUpgradeData(boardKey, upgradeKey)
    if not upgData then return "" end
    if upgData.RewardText then return upgData.RewardText end
    if upgData.DisplayFunction then
        return upgData.DisplayFunction(level)
    end
    -- fallback: gunakan Display + Boost
    local display = upgData.Display or ""
    local boost = upgData.Boost or 0
    local startBoost = upgData.StartBoost or 0
    local boostType = upgData.BoostType or "+"
    if boostType == "+" then
        return display .. NumberFormatter:Format(startBoost + boost * level)
    elseif boostType == "*" then
        return display .. NumberFormatter:Format(startBoost * (boost ^ level))
    elseif boostType == "/" then
        return display .. NumberFormatter:Format(startBoost / (1 + boost * level))
    end
    return display .. NumberFormatter:Format(startBoost + boost * level)
end

function buyUpgrade(boardKey, upgradeKey, isMax)
    if not Network then return false end
    local success, result = pcall(function()
        return Network:InvokeServer("BuyUpgrade", boardKey, upgradeKey, isMax)
    end)
    return success
end
-- =====================================================
-- UI AUTO UPGRADE (TAB UPGRADES)
-- =====================================================

local UpgradeGroup = nil
local countInGroup = 0

-- Kumpulkan semua board & upgrade dari UpgradesData
local allUpgradeEntries = {}
local UpgradeToggles = {}

for boardKey, boardData in pairs(UpgradesData or {}) do
    if type(boardData) == "table" and boardData.Name then
        for upgKey, upgData in pairs(boardData) do
            if type(upgData) == "table" and upgData.StartPrice and upgData.MaxLevel then
                local flag = "Upgrades_" .. boardKey .. "_" .. upgKey
                if Config.Upgraders[flag] == nil then
                    Config.Upgraders[flag] = false
                end

                table.insert(allUpgradeEntries, {
                    boardKey = boardKey,
                    upgradeKey = upgKey,
                    flag = flag,
                    boardName = boardData.Name,
                    upgName = upgData.Name or upgKey,
                })
            end
        end
    end
end

-- Buat toggle untuk setiap upgrade
for _, entry in ipairs(allUpgradeEntries) do
    UpgradeGData = getUpgradeData(entry.boardKey,entry.upgradeKey)
    local displayTitle = string.format("[%s] %s", entry.boardName, entry.upgName)
    if countInGroup % 2 == 0 then
        UpgradeGroup = MainTabs:Group({})
        FM_Add("Upgrades", UpgradeGroup)   -- tambahkan grup ke tab Upgrades
    end
    local toggle = UpgradeGroup:Toggle({
        Title = displayTitle,
        Image = UpgradeGData.Icon,
        Flag = entry.flag,
        Callback = function(val)
            -- Cegah jika upgrade tidak bisa dibeli
            local boardKey = entry.boardKey
            local upgradeKey = entry.upgradeKey
            local level = getCurrentLevel(boardKey, upgradeKey)
            local maxLevel = getMaxLevel(boardKey, upgradeKey)
            local unlocked = isUpgradeUnlocked(boardKey, upgradeKey)

            if not unlocked or level >= maxLevel then
            else
                Config.Upgraders[entry.flag] = val
                if val then
                    startUpgradeAutoThread()
                end
            end
        end
    })
    UpgradeToggles[entry.flag] = toggle
    entry.toggle = toggle
    countInGroup = countInGroup + 1
end

-- =====================================================
-- UPDATE STATUS TOGGLE (REAL-TIME)
-- =====================================================

function updateUpgradeToggle(entry)
    local boardKey = entry.boardKey
    local upgradeKey = entry.upgradeKey
    local toggle = entry.toggle

    local level = getCurrentLevel(boardKey, upgradeKey)
    local maxLevel = getMaxLevel(boardKey, upgradeKey)
    local unlocked = isUpgradeUnlocked(boardKey, upgradeKey)
    local cost = getCost(boardKey, upgradeKey, level)
    local boardData = UpgradesData and UpgradesData[boardKey]
    local currency = boardData and boardData.Currency or "Unknown"
    local balance = 0
    if Util then
        local data = Util:GetData()
        if data and currency then
            balance = data[currency] or 0
        end
    end

    local canAfford = (balance >= cost)
    local isMaxed = (level >= maxLevel)

    -- Judul
    local title = string.format("%s (%d/%d)", entry.upgName, level, maxLevel)
    local desc = ""

    if not unlocked then
        title = title .. " 🔒"
        desc = "🔒 Locked by: " .. (boardData and boardData[upgradeKey] and boardData[upgradeKey].LockedBy or "Unknown")
    elseif isMaxed then
        title = title .. " (MAX)"
        desc = "✅ Maxed"
    else
        local costText = NumberFormatter:Format(cost)
        local rewardText = getRewardText(boardKey, upgradeKey, level)
        local statusIcon = canAfford and "🟢" or "🔴"
        desc = string.format("%s Cost:%s %s%s\nReward: %s", statusIcon, costText, Icons[currency], currency, rewardText)
    end

    pcall(function() toggle:SetTitle(title) end)
    pcall(function() toggle:SetDesc(desc) end)

    -- GANTI: Jangan panggil toggle:Enable() atau toggle:Disable()
    -- Biarkan toggle selalu interaktif; callback akan menolak klik saat tidak bisa dibeli
    -- (lihat perubahan di pembuatan toggle)
end

function refreshAllUpgrades()
    for _, entry in ipairs(allUpgradeEntries) do
        pcall(function() updateUpgradeToggle(entry) end)
    end
end
-- =====================================================
-- AUTO UPGRADE THREAD (ROUND-ROBIN)
-- =====================================================

local UpgradeAutoThread = nil

function processUpgradeAutoBuy()
    for _, entry in ipairs(allUpgradeEntries) do
        if Config.Upgraders[entry.flag] then
            local boardKey = entry.boardKey
            local upgradeKey = entry.upgradeKey
            local level = getCurrentLevel(boardKey, upgradeKey)
            local maxLevel = getMaxLevel(boardKey, upgradeKey)

            if level < maxLevel and isUpgradeUnlocked(boardKey, upgradeKey) then
                local cost = getCost(boardKey, upgradeKey, level)
                local boardData = UpgradesData and UpgradesData[boardKey]
                local currency = boardData and boardData.Currency or "Unknown"
                local balance = 0
                if Util then
                    local data = Util:GetData()
                    if data and currency then
                        balance = data[currency] or 0
                    end
                end

                if balance >= cost then
                    buyUpgrade(boardKey, upgradeKey, true)
                    -- ✅ Refresh hanya toggle ini
                    pcall(function() updateUpgradeToggle(entry) end)
                    return -- keluar setelah satu pembelian
                end
            end
        end
    end
end

function startUpgradeAutoThread()
    if UpgradeAutoThread then return end
    UpgradeAutoThread = StartManagedLoop("UpgradeAutoBuy", 0.2, function()
        -- Cek apakah ada upgrade yang diaktifkan
        for _, entry in ipairs(allUpgradeEntries) do
            if Config.Upgraders[entry.flag] then
                return true
            end
        end
        return false
    end, processUpgradeAutoBuy)
end

-- Panggil sekali agar thread siap jika ada toggle yang aktif
startUpgradeAutoThread()
-- Refresh saat ada pembelian upgrade (dari client atau server)
if Signal then
    Signal:Connect("BoughtUpgrades", function()
        refreshAllUpgrades()
    end)
end

-- Refresh periodik setiap 2 detik (untuk update harga, level, dll)
task.spawn(function()
    while not Window.Destroyed do
        refreshAllUpgrades()
        task.wait(0.5)
    end
end)

-- =====================================================
-- AUTO BUILD FIRE (CAMPFIRE)
-- =====================================================
local BuildFireToggle = MainTabs:Toggle({
    Title = "Champ Fire",
    Image = Icons["Wood"], -- ganti icon jika perlu
    Flag = "AutoBuildFire",
    Callback = function(val)
        if val then
            StartManagedLoop("AutoBuildFire", 0.5, nil, function()
                -- Cek resource dan panggil remote
                local data = Util:GetData()
                if not data or not data.World0 then return end
                local fireLevel = data.World0.FireLevel or 0

                -- Dapatkan biaya
                local costSuccess, woodCost, _, maxLevel, fishCost, accCost, powerCost = pcall(function()
                    return Network:InvokeServer("W0FireCost")
                end)
                if not costSuccess then return end

                -- Cek apakah sudah max (dari client: jika maxLevel <= fireLevel, maka tombol "MAX")
                if maxLevel and fireLevel >= maxLevel then return end

                -- Cek kecukupan resource
                local canBuild = (data.Wood or 0) >= (woodCost or 0)
                if fishCost and fishCost > 0 then
                    canBuild = canBuild and (data.Fish or 0) >= fishCost
                end
                if accCost and accCost > 0 then
                    canBuild = canBuild and (data.Accuracy or 0) >= accCost
                end
                if powerCost and powerCost > 0 then
                    canBuild = canBuild and (data.Power or 0) >= powerCost
                end

                if canBuild then
                    -- Coba build/upgrade
                    pcall(function()
                        Network:InvokeServer("W0BuildFire")
                    end)
                end
            end)
        else
            StopManagedLoop("AutoBuildFire")
        end
    end
})

FM_Add("Champ Upgrade", BuildFireToggle)   -- atau buat kategori khusus "Campfire"

-- Daftar Permanent Buffs (sesuai client)
local PermanentBuffs = {
    {Level = 10, Name = "Auto Wood Collection"},
    {Level = 15, Name = "Auto Fishing"},
    {Level = 15, Name = "Auto Wood Upgrades"},
    {Level = 25, Name = "Auto Rock Training"},
    {Level = 25, Name = "Auto Fish Upgrades"},
    {Level = 30, Name = "Auto Accuracy Training"},
    {Level = 35, Name = "Auto Accuracy Upgrades"},
}

-- Update deskripsi toggle BuildFire (lengkap dengan buff permanen)
task.spawn(function()
    while not Window.Destroyed do
        local desc = ""
        local data = Util:GetData()
        if data and data.World0 then
            local fireLevel = data.World0.FireLevel or 0
            local ok, woodCost, _, maxLevel, fishCost, accCost, powerCost = pcall(function()
                return Network:InvokeServer("W0FireCost")
            end)

            if ok and maxLevel then
                -- Baris 1: Judul level
                local title = fireLevel <= 0 and "Not built yet" or ("Campfire Level " .. fireLevel)

                -- Baris 2: Buff utama
                local buffText
                if fireLevel <= 0 then
                    buffText = "Boosts your Wood & Fish gain"
                else
                    buffText = "+" .. (fireLevel * 50) .. "% Wood & Fish gain"
                    if fireLevel > 20 then
                        buffText = buffText .. ", +" .. ((fireLevel - 20) * 50) .. "% Power"
                    end
                    if fireLevel > 25 then
                        buffText = buffText .. ", +" .. ((fireLevel - 25) * 50) .. "% Accuracy"
                    end
                end

                -- Baris 3: Biaya (jika belum max)
                local costLine = ""
                if fireLevel < maxLevel then
                    local costParts = {}
                    if woodCost and woodCost > 0 then
                        table.insert(costParts, NumberFormatter:Format(woodCost) .. " " .. Icons["Wood"] .. "Wood")
                    end
                    if fishCost and fishCost > 0 then
                        table.insert(costParts, NumberFormatter:Format(fishCost) .. " " .. Icons["Fish"] .. "Fish")
                    end
                    if accCost and accCost > 0 then
                        table.insert(costParts, NumberFormatter:Format(accCost) .. " " .. Icons["Accuracy"] .. "Accuracy")
                    end
                    if powerCost and powerCost > 0 then
                        table.insert(costParts, NumberFormatter:Format(powerCost) .. " " .. Icons["Power"] .. "Power")
                    end
                    costLine = "Cost: " .. table.concat(costParts, " + ")
                end

                -- Baris 4: Status Build/Upgrade/Locked/MAX
                local statusLine = ""
                if fireLevel >= maxLevel then
                    if maxLevel < 35 then
                        statusLine = 'Buy "Unlock 10 Campfire Levels"\n(Accuracy board)\nStatus: LOCKED'
                    else
                        statusLine = "Status: MAX"
                    end
                else
                    local canBuild = (data.Wood or 0) >= (woodCost or 0)
                    if fishCost and fishCost > 0 then canBuild = canBuild and (data.Fish or 0) >= fishCost end
                    if accCost and accCost > 0 then canBuild = canBuild and (data.Accuracy or 0) >= accCost end
                    if powerCost and powerCost > 0 then canBuild = canBuild and (data.Power or 0) >= powerCost end

                    local action = fireLevel == 0 and "Build" or "Upgrade"
                    statusLine = (canBuild and "🟢 " or "🔴 ") .. action
                end

                -- Baris 5+: Daftar Permanent Buffs
                local buffsList = "🏆 Permanent Buffs:"
                for _, buff in ipairs(PermanentBuffs) do
                    local unlocked = fireLevel >= buff.Level
                    local icon = unlocked and "✅" or "⬜"
                    buffsList = buffsList .. "\n" .. icon .. " Lv" .. buff.Level .. " " .. buff.Name
                end

                -- Gabungkan semua bagian
                desc = title .. "\n" .. buffText
                if costLine ~= "" then
                    desc = desc .. "\n" .. costLine
                end
                desc = desc .. "\n" .. statusLine .. "\n" .. buffsList
            end
        end

        pcall(function()
            BuildFireToggle:SetDesc(desc)
        end)
        task.wait(0.5)
    end
end)

-- =====================================================
-- AUTO BUY SKILL TREE (CLICK DETECTOR)
-- =====================================================

-- Cache konfigurasi
local SkillTreeConfig = nil
local function getSkillTreeConfig()
    if not SkillTreeConfig then
        local ok, result = pcall(function()
            return Network:InvokeServer("W2TreeConfig")
        end)
        if ok and result then
            SkillTreeConfig = result
        end
    end
    return SkillTreeConfig
end

-- Dapatkan node yang bisa dibeli (termurah dulu)
local function getBuyableNodes()
    local cfg = getSkillTreeConfig()
    if not cfg then return {} end

    local data = Util:GetData()
    if not data or not data.World0 or not data.World0.W2 then return {} end
    local owned = data.World0.W2.SkillTree or {}

    local buyable = {}
    for nodeId, nodeCfg in pairs(cfg) do
        if type(nodeCfg) == "table" and nodeCfg.Cost then
            if not owned[tostring(nodeId)] then
                -- Cek prasyarat
                local prereqsMet = true
                if nodeCfg.Prereqs then
                    for _, prereqId in ipairs(nodeCfg.Prereqs) do
                        if not owned[tostring(prereqId)] then
                            prereqsMet = false
                            break
                        end
                    end
                end
                if prereqsMet then
                    local currency = nodeCfg.Currency
                    local balance = data[currency] or 0
                    if balance >= nodeCfg.Cost then
                        table.insert(buyable, {
                            id = nodeId,
                            cost = nodeCfg.Cost,
                            currency = currency,
                            name = nodeCfg.Name or tostring(nodeId),
                        })
                    end
                end
            end
        end
    end

    table.sort(buyable, function(a, b) return a.cost < b.cost end)
    return buyable
end

-- Fungsi beli node (via ClickDetector)workspace.Map_0.Wilderness2.SkillTree.Node1
local function buySkillNode(nodeId)
    local skillTree = workspace:FindFirstChild("Map_0") and workspace.Map_0:FindFirstChild("Wilderness2") and workspace.Map_0.Wilderness2:FindFirstChild("SkillTree")
    if not skillTree then return false end

    for _, nodePart in ipairs(skillTree:GetChildren()) do
        if nodePart.Name == "Node"..nodeId then
            fireclickdetector(nodePart.ClickDetector)
            return true
        end
    end
    return false
end

-- Group & Toggle
local SkillGroup = MainTabs:Group({})
local AutoSkillTreeToggle = SkillGroup:Toggle({
    Title = "Auto Skill Tree",
    Image = GetIcon(84524784941090),
    Flag = "AutoSkillTree",
    Callback = function(val)
        if val then
            StartManagedLoop("AutoSkillTree", 0.5, nil, function()
                local buyable = getBuyableNodes()
                if #buyable > 0 then
                    buySkillNode(buyable[1].id)
                end
            end)
        else
            StopManagedLoop("AutoSkillTree")
        end
    end
})
FM_Add("Skills", SkillGroup)

-- Fungsi hitung tabel
local function countTable(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end
local CurrencyNames = require(ReplicatedStorage.Modules.Data.CurrencyNames)

-- Update deskripsi
task.spawn(function()
    while not Window.Destroyed do
        local desc = ""
        local isActive = AutoSkillTreeToggle.Value
        if isActive then
            local buyable = getBuyableNodes()
            local data = Util:GetData()
            local ownedCount = 0
            if data and data.World0 and data.World0.W2 and data.World0.W2.SkillTree then
                ownedCount = countTable(data.World0.W2.SkillTree)
            end

            desc = "Owned: " .. ownedCount .. " nodes"
            if #buyable > 0 then
                local cheapest = buyable[1]
                local currencyName = cheapest.currency
                if CurrencyNames and CurrencyNames[cheapest.currency] then
                    currencyName = CurrencyNames[cheapest.currency]
                end
                desc = desc .. "\nNext: " .. cheapest.name
                desc = desc .. "\nCost: " .. NumberFormatter:Format(cheapest.cost) .. " " .. currencyName
                desc = desc .. "\n🟢 Ready to buy"
            else
                desc = desc .. "\nNo buyable nodes"
            end
        else
            desc = "Disabled"
        end

        pcall(function()
            AutoSkillTreeToggle:SetDesc(desc)
        end)
        task.wait(1)
    end
end)

-- =====================================================
-- AUTO TRANSFORM (BELI TRANSFORMASI OTOMATIS)
-- =====================================================
local TransformationsData = require(ReplicatedStorage.Modules.Data.TransformationsData)
-- Fungsi mendapatkan transformasi berikutnya yang bisa dibeli
local function getNextTransformation()
    local data = Util:GetData()
    if not data then return nil, nil end
    local owned = data.Transformations or {}
    local list = TransformationsData.List

    -- Cek urutan utama
    for _, name in ipairs(list) do
        if not owned[name] then
            local cfg = TransformationsData[name]
            if not cfg then continue end

            if name == "AdultGoku" then
                local fireLevel = data.World0 and data.World0.FireLevel or 0
                if fireLevel >= 35 then
                    return name, cfg
                else
                    return nil, nil  -- belum bisa lanjut karena api unggun belum level 35
                end
            else
                local amount = cfg.Requirement.Amount
                if (data["Chi"] or 0) >= amount then
                    return name, cfg
                else
                    return nil, nil  -- Chi kurang
                end
            end
        end
    end

    -- Super Saiyan (setelah semua di list dimiliki)
    if not owned["SuperSaiyan"] then
        local cfg = TransformationsData.SuperSaiyan
        if cfg and (data["Chi"] or 0) >= cfg.Requirement.Amount then
            return "SuperSaiyan", cfg
        end
    end
    return nil, nil
end

local AutoTransformToggle = MainTabs:Toggle({
    Title = "Auto Transform",
    Image = GetIcon(84029054656351),   -- ganti icon sesuai keinginan
    Flag = "AutoTransform",
    Callback = function(val)
        if val then
            StartManagedLoop("AutoTransform", 2, nil, function()
                local nextName, _ = getNextTransformation()
                if nextName then
                    pcall(function()
                        Network:InvokeServer("Transform")
                    end)
                end
            end)
        else
            StopManagedLoop("AutoTransform")
        end
    end
})
FM_Add("Skills", AutoTransformToggle)

-- Update deskripsi toggle secara real‑time
task.spawn(function()
    while not Window.Destroyed do
        local desc = ""
        local isActive = AutoTransformToggle.Value

        if isActive then
            local nextName, cfg = getNextTransformation()
            local data = Util:GetData()

            -- Hitung jumlah transformasi yang sudah dimiliki
            local ownedCount = 0
            if data and data.Transformations then
                for _ in pairs(data.Transformations) do ownedCount = ownedCount + 1 end
            end

            desc = "Owned: " .. ownedCount .. " transformations"
            if nextName and cfg then
                desc = desc .. "\nNext: " .. cfg.Name
                if nextName == "AdultGoku" then
                    local fireLevel = data.World0 and data.World0.FireLevel or 0
                    desc = desc .. "\nRequires: Fire Level 35"
                    if fireLevel >= 35 then
                        desc = desc .. " [✔]"
                    else
                        desc = desc .. " [✘] (" .. fireLevel .. "/35)"
                    end
                else
                    local amount = cfg.Requirement.Amount
                    local balance = data["Chi"] or 0
                    desc = desc .. "\nRequires: " .. NumberFormatter:Format(amount) .. " Chi"
                    if balance >= amount then
                        desc = desc .. " [✔]"
                    else
                        desc = desc .. " [✘]"
                    end
                end
                desc = desc .. "\n🟢 Ready to transform"
            else
                desc = desc .. "\nNo transformation available"
            end
        else
            desc = "Disabled"
        end

        pcall(function()
            AutoTransformToggle:SetDesc(desc)
        end)
        task.wait(1)
    end
end)
-- [[ Settings Tab ]] --
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
FM_OnChange("Farm")
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
