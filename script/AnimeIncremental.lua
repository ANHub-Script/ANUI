if game.PlaceId ~= 75776571537058 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Anime Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local FolderPath = "ANUI/AnimeIncremental"
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local LastConfigFile = FolderPath .. "/LastConfig.txt"
local IsPremium = false
local ValidKeys = {"ANHUB-2025"}
local MapDBFile = "Map_Database.json"
local Config = {
    SelectedEnemy = nil,
    MapConfigurations = {},
    Upgraders = {},
    AutoFarm = {
        Enabled = false,
        World = "Naruto",
        Platform = "2",
        OrbIndex = "nearest",
        Mode = "Teleport",
        TweenSpeed = 0.5,
        HeightOffset = 5,
        CollectInterval = 0.1,
        MinDistance = 5,
    }
}
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

-- Load modul
local DataService = require(ReplicatedStorage.Packages.DataService).client
local Upgrades = require(ReplicatedStorage.Shared.Modules.Game.Upgrades)
local UpgradeUtility = require(ReplicatedStorage.Shared.Controllers.UpgradeService.UpgradeUtility)
local SkillTrees = require(ReplicatedStorage.Shared.Modules.Game.SkillTrees)
local Currencies = require(ReplicatedStorage.Shared.Modules.Game.Currencies)
local ShinobiRankUtils = require(ReplicatedStorage.Shared.Controllers.ShinobiRankService.ShinobiRankUtils)
local RebirthUtils = require(ReplicatedStorage.Shared.Controllers.RebirthService.RebirthUtils)
local AllRemotes = ReplicatedStorage.Packages._Index["leifstout_networker@0.3.1"].networker._remotes
-- Remote untuk Rebirth
local RebirthRemote =  AllRemotes.RebirthService.RemoteEvent
local Worlds = require(ReplicatedStorage.Shared.Modules.Game.Worlds)
local AdventureController = require(ReplicatedStorage.Shared.Controllers.AdventureService.AdventureController)
-- Tambahkan setelah RebirthUtils
local OtsutsukiAscensionUtils = require(ReplicatedStorage.Shared.Controllers.OtsutsukiAscensionService.OtsutsukiAscensionUtils)

-- Remote untuk Ascension (tambahkan setelah RebirthRemote)
local AscendRemote = AllRemotes.OtsutsukiAscensionService.RemoteEvent
-- Remote untuk Card Pack
local CondensedEnergy = require(ReplicatedStorage.Shared.Modules.Game.CondensedEnergy)

-- Remote untuk Condensed Energy
local CondensedRemote = AllRemotes.CondensedEnergyService.RemoteEvent
-- Remote untuk Rank Up
local RankUpRemote = AllRemotes.ShinobiRankService.RemoteEvent
-- Remote function untuk upgrade
local UpgradeRemote = AllRemotes.UpgradeService.RemoteFunction

-- Tunggu data siap
DataService:waitForData()

-- =====================================================
-- [OPTIMASI] FUNGSI CANAFFORDNEXTUPGRADE - Terima playerData sebagai parameter
-- =====================================================
local function canAffordNextUpgrade(upgradeName, currencyName, playerData)
    local currentLevel = playerData.Upgrades and playerData.Upgrades[upgradeName] or 0
    local currencyAmount = playerData.Currencies and playerData.Currencies[currencyName]
    
    if currencyAmount then
        return UpgradeUtility.CanAffordNextUpgrade(
            upgradeName, 
            currentLevel, 
            currencyAmount, 
            playerData
        )
    else
        return false
    end
end

-- =====================================================
-- [OPTIMASI] FUNGSI UNTUK MENDAPATKAN JUMLAH PEMBELIAN - Terima playerData
-- =====================================================
local function getBuyAmount(upgradeName, currencyName, playerData)
    local def = Upgrades.GetUpgrade(upgradeName)
    if not def then return 0 end
    
    local currentLevel = playerData.Upgrades and playerData.Upgrades[upgradeName] or 0
    local maxLevel = Upgrades.GetMaxLevel(upgradeName, playerData)
    local remaining = maxLevel - currentLevel
    
    if remaining <= 0 then return 0 end
    
    local currencyAmount = playerData.Currencies and playerData.Currencies[currencyName]
    
    if currencyAmount then
        local maxBuyable = UpgradeUtility.GetMaxUpgrades(
            upgradeName, 
            currentLevel, 
            currencyAmount, 
            playerData
        )
        return math.min(maxBuyable, 10)
    end
    
    return 0
end

-- =====================================================
-- [OPTIMASI] FUNGSI UNTUK MENDAPATKAN DAFTAR UPGRADE - Terima playerData
-- =====================================================
local function getUnlockedUpgradesForCurrency(currencyName, playerData)
    local unlockedUpgrades = {}
    local allUpgrades = Upgrades.GetUpgradeNamesForCurrency(currencyName)
    
    for _, upgradeName in ipairs(allUpgrades) do
        local tree, node = SkillTrees.GetTreeForUpgrade(upgradeName)
        
        if tree and node then
            if SkillTrees.IsNodeUnlocked(tree.Id, node.Id, playerData) then
                local level = playerData.Upgrades and playerData.Upgrades[upgradeName] or 0
                unlockedUpgrades[upgradeName] = {
                    name = upgradeName,
                    level = level,
                    treeId = tree.Id,
                    nodeId = node.Id
                }
            end
        else
            if Upgrades.CanPurchase(upgradeName, playerData) then
                local level = playerData.Upgrades and playerData.Upgrades[upgradeName] or 0
                unlockedUpgrades[upgradeName] = {
                    name = upgradeName,
                    level = level,
                    treeId = nil,
                    nodeId = nil
                }
            end
        end
    end
    
    return unlockedUpgrades
end

-- =====================================================
-- FUNGSI UNTUK MENGURUTKAN UPGRADE BERDASARKAN PRIORITAS
-- =====================================================
local function getUpgradePriority(upgradeName, upgradeInfo)
    local def = Upgrades.GetUpgrade(upgradeName)
    if not def then return 999 end
    
    local priority = 0
    
    if upgradeInfo.level == 0 then
        priority = priority - 1000
    end
    
    priority = priority + (upgradeInfo.level or 0) * 100
    
    return priority
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
        -- {
        --     Icon = "geist:logo-discord", Title = "Discord", Desc = "Join ANHUB Discord",
        --     Callback = function() setclipboard("https://discord.gg/bUkCZvmrpH") Notify("Discord", "Invite link copied!", "geist:logo-discord") end
        -- },
        {
            Icon = "youtube",Title = "Youtube", Desc = "Subscribe to YouTube",
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
    Title = "AN Hub - Anime Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeIncremental",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Incremental" }),
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
    ["Upgrades"] = "Auto Upgrade Section All Ingame",
    ["Progressions"] = "Auto Rankup,Prestige,Sacrifice,Condensed Energy Converter",
    ["Auto Farm"] = "Auto Farm Orbs (Teleport/Tween)",
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
        Desc = "Anime CeIncremental"
    }),
    SidebarProfile = false
});

-- Pembuatan Selector Kategori
FM_CategorySelector = MainTabs:Category({
    Title = "Select Category",
    Default = "Skills",
    Options = {
        {Title = "Skills", Icon = GetIcon(101379910235879)},
        {Title = "Upgrades", Icon = GetIcon(131036042070680)},        
        {Title="Progressions", Icon=GetIcon(111262536381336)},
        {Title="Auto Farm", Icon=GetIcon(93057502485000)},
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
-- [OPTIMASI] FUNGSI AUTO UPGRADE GENERIK - DataService:get() dipanggil SEKALI
-- =====================================================
local function autoUpgradeCurrency(currencyName)
    DataService:waitForData()
    local playerData = DataService:get()   -- ✅ Ambil SEKALI di sini
    if not playerData then return false end
    
    local currencyData = playerData.Currencies and playerData.Currencies[currencyName]
    if not currencyData then return false end
    
    local unlockedUpgrades = getUnlockedUpgradesForCurrency(currencyName, playerData)
    if next(unlockedUpgrades) == nil then return false end
    
    local sortedUpgrades = {}
    for upgradeName, info in pairs(unlockedUpgrades) do
        table.insert(sortedUpgrades, {
            name = upgradeName,
            info = info,
            priority = getUpgradePriority(upgradeName, info)
        })
    end
    table.sort(sortedUpgrades, function(a, b) return a.priority < b.priority end)
    
    for _, upgradeData in ipairs(sortedUpgrades) do
        local upgradeName = upgradeData.name
        local upgradeInfo = upgradeData.info
        local def = Upgrades.GetUpgrade(upgradeName)
        if not def then continue end
        
        local currentLevel = upgradeInfo.level
        local maxLevel = Upgrades.GetMaxLevel(upgradeName, playerData)
        if currentLevel >= maxLevel then continue end
        
        if canAffordNextUpgrade(upgradeName, currencyName, playerData) then
            local buyAmount = getBuyAmount(upgradeName, currencyName, playerData)
            if buyAmount > 0 then
                local totalCost = UpgradeUtility.GetTotalPrice(upgradeName, currentLevel, buyAmount)
                
                local nodeInfo = ""
                if upgradeInfo.treeId then
                    nodeInfo = string.format(" [%s.%s]", upgradeInfo.treeId, upgradeInfo.nodeId)
                end
                local success, err = 
                    pcall(function()
                    local result = UpgradeRemote:InvokeServer("AttemptUpgrade", upgradeName, buyAmount)
                end)
                
                if success then return true end
            end
        end
    end
    return false
end

-- =====================================================
-- [OPTIMASI] FUNGSI STATUS UPGRADE - Terima playerData dari luar
-- =====================================================
local function showUpgradeStatus(currencyName, uiElement, playerData)
    if not playerData then return end
    
    local currencyData = playerData.Currencies and playerData.Currencies[currencyName]
    local CurIcon = Currencies.GetCurrencies()[currencyName].ImageId
    local ownedCurrency = currencyData and string.format("%.2f", currencyData[1] or 0) or "0"
    local unlockedUpgrades = getUnlockedUpgradesForCurrency(currencyName, playerData)
    local allUpgrades = Upgrades.GetUpgradeNamesForCurrency(currencyName)
    
    local skillList = {}
    for _, info in ipairs(allUpgrades) do
        local infos = Upgrades.GetUpgrade(info)
        if infos then
            local levelData = unlockedUpgrades[info]
            local level = 0
            local maxLevel = infos.MaxLevel or 0
            if levelData ~= nil then level = levelData.level end
            
            table.insert(skillList, {
                name = infos.Name,
                Image = infos.Image,
                level = level,
                maxLevel = maxLevel,
                isUnlocked = levelData ~= nil
            })
        end
    end
    
    local InfoSkill = ""
    for i = 1, #skillList, 2 do
        local left = skillList[i]
        local right = skillList[i + 1]
        local leftLockIcon = left.isUnlocked and "" or "🔒 "
        local leftText = string.format("%-65s", string.format("%s%s%s: %d/%d", 
            leftLockIcon, left.Image, left.name, left.level, left.maxLevel))
        local rightText = ""
        if right then
            local rightLockIcon = right.isUnlocked and "" or "🔒 "
            rightText = string.format("%-30s", string.format("%s%s%s: %d/%d", 
                rightLockIcon, right.Image, right.name, right.level, right.maxLevel))
        end
        InfoSkill = InfoSkill .. leftText .. rightText .. "\n"
    end
    
    if uiElement then uiElement:SetDesc(InfoSkill) end
end

-- =====================================================
-- [OPTIMASI] SEMUA LOGIC LOOP - Delay dinamis
-- =====================================================
local SkillTreesUpgraders
local function LogicPerkPointsUpgraders()
    while Config.Upgraders.SkillTrees do
        if Window.Destroyed then break end
        local success = autoUpgradeCurrency("PerkPoints")
        task.wait(success and 1 or 3)
    end
end
SkillTreesUpgraders = MainTabs:Toggle({
    Title = GetIcon(101379910235879).."Auto Upgrade Skills",
    Flag = "Upgraders_Skills_Cfg",
    Callback = function(val)
        Config.Upgraders.SkillTrees = val;
        if val then task.spawn(LogicPerkPointsUpgraders); end;
    end
});
FM_Add("Skills", SkillTreesUpgraders);

local ChakraUpgrade
local function LogicChakraUpgraders()
    while Config.Upgraders.ChakraUpgrades do
        if Window.Destroyed then break end
        local success = autoUpgradeCurrency("Chakra")
        task.wait(success and 1 or 3)
    end
end
ChakraUpgrade = MainTabs:Toggle({
    Title = GetIcon(136033923709542).."Auto Upgrade Chakra",
    Flag = "Upgraders_Chakra_Cfg",
    Callback = function(val)
        Config.Upgraders.ChakraUpgrades = val;
        if val then task.spawn(LogicChakraUpgraders); end;
    end
});
FM_Add("Upgrades", ChakraUpgrade);

local PrestigeUpgrade
local function LogicPrestigeUpgraders()
    while Config.Upgraders.PrestigeUpgrades do
        if Window.Destroyed then break end
        local success = autoUpgradeCurrency("PrestigePoints")
        task.wait(success and 1 or 3)
    end
end
PrestigeUpgrade = MainTabs:Toggle({
    Title = GetIcon(131036042070680).." Auto Upgrade Prestige",
    Flag = "Upgraders_Prestige_Cfg",
    Callback = function(val)
        Config.Upgraders.PrestigeUpgrades = val;
        if val then task.spawn(LogicPrestigeUpgraders); end;
    end
});
FM_Add("Upgrades", PrestigeUpgrade);

local NatureUpgrade
local function LogicNatureUpgraders()
    while Config.Upgraders.NatureUpgrades do
        if Window.Destroyed then break end
        local success = autoUpgradeCurrency("NatureEnergy")
        task.wait(success and 1 or 3)
    end
end
NatureUpgrade = MainTabs:Toggle({
    Title = GetIcon(93057502485000).." Auto Upgrade Nature",
    Flag = "Upgraders_Nature_Cfg",
    Callback = function(val)
        Config.Upgraders.NatureUpgrades = val;
        if val then task.spawn(LogicNatureUpgraders); end;
    end
});
FM_Add("Upgrades", NatureUpgrade);

local CondensedUpgrade
local function LogicCondensedUpgraders()
    while Config.Upgraders.CondensedUpgrades do
        if Window.Destroyed then break end
        local success = autoUpgradeCurrency("CondensedEnergy")
        task.wait(success and 1 or 3)
    end
end
CondensedUpgrade = MainTabs:Toggle({
    Title = GetIcon(98305919280015).." Auto Upgrade Condensed",
    Flag = "Upgraders_Condensed_Cfg",
    Callback = function(val)
        Config.Upgraders.CondensedUpgrades = val;
        if val then task.spawn(LogicCondensedUpgraders); end;
    end
});
FM_Add("Upgrades", CondensedUpgrade);

local MeditationUpgrade
local function LogicMeditationUpgraders()
    while Config.Upgraders.MeditationUpgrades do
        if Window.Destroyed then break end
        local success = autoUpgradeCurrency("Meditation")
        task.wait(success and 1 or 3)
    end
end
MeditationUpgrade = MainTabs:Toggle({
    Title = GetIcon(114566721374989).." Auto Upgrade Meditation",
    Flag = "Upgraders_Meditation_Cfg",
    Callback = function(val)
        Config.Upgraders.MeditationUpgrades = val;
        if val then task.spawn(LogicMeditationUpgraders); end;
    end
});
FM_Add("Upgrades", MeditationUpgrade);

local HourglassUpgrade
local function LogicHourglassUpgraders()
    while Config.Upgraders.HourglassUpgrades do
        if Window.Destroyed then break end
        local success = autoUpgradeCurrency("HourglassFragments")
        task.wait(success and 1 or 3)
    end
end
HourglassUpgrade = MainTabs:Toggle({
    Title = GetIcon(132066419448551) .. "⏳ Auto Upgrade Daily",
    Flag = "Upgraders_Hourglass_Cfg",
    Callback = function(val)
        Config.Upgraders.HourglassUpgrades = val;
        if val then task.spawn(LogicHourglassUpgraders); end;
    end
});
FM_Add("Upgrades", HourglassUpgrade);

local AdventureUpgrade
local function LogicAdventureUpgraders()
    while Config.Upgraders.AdventureUpgrades do
        if Window.Destroyed then break end
        local success = autoUpgradeCurrency("AdventureCoins")
        task.wait(success and 1 or 3)
    end
end
AdventureUpgrade = MainTabs:Toggle({
    Title = GetIcon(121857577660012).." Auto Upgrade Adventure",
    Flag = "Upgraders_Adventure_Cfg",
    Callback = function(val)
        Config.Upgraders.AdventureUpgrades = val;
        if val then task.spawn(LogicAdventureUpgraders); end;
    end
});
FM_Add("Upgrades", AdventureUpgrade);

local SacrificeUpgrade
local function LogicSacrificeUpgraders()
    while Config.Upgraders.SacrificeUpgrades do
        if Window.Destroyed then break end
        local success = autoUpgradeCurrency("SacrificePoints")
        task.wait(success and 1 or 3)
    end
end
SacrificeUpgrade = MainTabs:Toggle({
    Title = GetIcon(82223595547404).." Auto Upgrade Sacrifice",
    Flag = "Upgraders_Sacrifice_Cfg",
    Callback = function(val)
        Config.Upgraders.SacrificeUpgrades = val;
        if val then task.spawn(LogicSacrificeUpgraders); end;
    end
});
FM_Add("Upgrades", SacrificeUpgrade);

local SoulsUpgrade
local function LogicSoulsUpgraders()
    while Config.Upgraders.SoulsUpgrades do
        if Window.Destroyed then break end
        local success = autoUpgradeCurrency("Souls")
        task.wait(success and 1 or 3)
    end
end
SoulsUpgrade = MainTabs:Toggle({
    Title = GetIcon(129247438462514).." Auto Upgrade Souls",
    Flag = "Upgraders_Souls_Cfg",
    Callback = function(val)
        Config.Upgraders.SoulsUpgrades = val;
        if val then task.spawn(LogicSoulsUpgraders); end;
    end
});
FM_Add("Upgrades", SoulsUpgrade);

local BijuuUpgrade
local function LogicBijuuUpgraders()
    while Config.Upgraders.BijuuUpgrades do
        if Window.Destroyed then break end
        local success = autoUpgradeCurrency("BijuuChakra")
        task.wait(success and 1 or 3)
    end
end
BijuuUpgrade = MainTabs:Toggle({
    Title = GetIcon(76082497465002).." Auto Upgrade Bijuu",
    Flag = "Upgraders_Bijuu_Cfg",
    Callback = function(val)
        Config.Upgraders.BijuuUpgrades = val;
        if val then task.spawn(LogicBijuuUpgraders); end;
    end
});
FM_Add("Upgrades", BijuuUpgrade);

-- =====================================================
-- [OPTIMASI] FUNGSI AUTO RANK UP - DataService:get() sekali
-- =====================================================
local function autoRankUp()
    DataService:waitForData()
    local playerData = DataService:get()
    
    local currentRankId = playerData.ShinobiRank or 1
    local maxRank = ShinobiRankUtils.GetMaxRank()
    if currentRankId >= maxRank then return false, "MAX RANK" end
    
    local nextRank = ShinobiRankUtils.GetNextRank(currentRankId)
    if not nextRank then return false, "MAX RANK" end
    
    local canRank, progress = ShinobiRankUtils.CanRankUp(playerData, nextRank)
    if canRank then
        pcall(function() RankUpRemote:FireServer("AttemptRankUp") end)
        return true, "RANK UP!"
    end
    return false, "Requirements not met"
end

-- [OPTIMASI] showRankUpStatus - Terima playerData
local function showRankUpStatus(uiElement, playerData)
    if not playerData then return end
    
    local currentRankId = playerData.ShinobiRank or 1
    local currentRankName = ShinobiRankUtils.GetRankNameById(currentRankId)
    local maxRank = ShinobiRankUtils.GetMaxRank()
    
    local infoText = string.format("🏆 Current Rank: %s (ID: %d/%d)\n\n", currentRankName, currentRankId, maxRank)
    
    if currentRankId < maxRank then
        local nextRank = ShinobiRankUtils.GetNextRank(currentRankId)
        if nextRank then
            local nextRankName = ShinobiRankUtils.GetRankNameById(currentRankId + 1)
            infoText = infoText .. string.format("📈 Next Rank: %s\n", nextRankName)
            infoText = infoText .. string.format("🎁 Reward: +%d PerkPoints\n", ShinobiRankUtils.GetStartingPerkPoints(nextRank))
            
            local canRank, progress = ShinobiRankUtils.CanRankUp(playerData, nextRank)
            infoText = infoText .. "\n📋 Requirements:\n"
            
            for _, req in ipairs(progress) do
                local met = req.Met
                local icon = met and "✅" or "❌"
                local currentVal = req.Current
                local requiredVal = req.Required
                
                local currentStr = tostring(currentVal)
                local requiredStr = tostring(requiredVal)
                if type(currentVal) == "table" and currentVal.GetSuffix then
                    currentStr = currentVal:GetSuffix()
                    requiredStr = requiredVal:GetSuffix()
                end
                
                local reqNum = tonumber(tostring(requiredVal)) or 1
                local curNum = tonumber(tostring(currentVal)) or 0
                local progressPercent = 0
                if reqNum > 0 and curNum > 0 then progressPercent = math.min(100, (curNum / reqNum) * 100)
                elseif met then progressPercent = 100 end
                
                local barFilled = math.floor(progressPercent / 10)
                local bar = string.rep("█", barFilled) .. string.rep("░", 10 - barFilled)
                infoText = infoText .. string.format("  %s %s [%s] %d%%\n", icon, req.Name, bar, math.floor(progressPercent))
            end
        end
    end
    
    if uiElement then uiElement:SetDesc(infoText) end
end

local RankUpToggle
local function LogicAutoRankUp()
    while Config.Upgraders.AutoRankUp do
        if Window.Destroyed then break end
        local success, msg = autoRankUp()
        task.wait(success and 2 or 5)
    end
end
RankUpToggle = MainTabs:Toggle({
    Title = GetIcon(111262536381336).." Auto Rank Up",
    Flag = "Upgraders_RankUp_Cfg",
    Callback = function(val)
        Config.Upgraders.AutoRankUp = val;
        if val then task.spawn(LogicAutoRankUp); end;
    end
});
FM_Add("Progressions", RankUpToggle);

-- =====================================================
-- [OPTIMASI] FUNGSI AUTO REBIRTH - DataService:get() sekali
-- =====================================================
local function autoRebirth(rebirthType)
    DataService:waitForData()
    local playerData = DataService:get()
    
    local rebirthDef = RebirthUtils.GetRebirth(rebirthType)
    if not rebirthDef then return false, "Invalid rebirth type" end
    
    local canRebirth, progress = RebirthUtils.CanRebirth(playerData, rebirthType)
    if canRebirth then
        pcall(function() RebirthRemote:FireServer("AttemptRebirth", rebirthType) end)
        return true, "REBIRTH DONE!"
    end
    return false, "Requirements not met"
end

-- [OPTIMASI] showRebirthStatus - Terima playerData
local function showRebirthStatus(rebirthType, uiElement, playerData)
    if not playerData then return end
    
    local rebirthDef = RebirthUtils.GetRebirth(rebirthType)
    if not rebirthDef then return end
    
    local infoText = ""
    local count = RebirthUtils.GetRebirthCount(playerData, rebirthType)
    local icon = rebirthType == "Prestige" and "⭐" or GetIcon(110938344194362)
    infoText = infoText .. string.format("%s %s Rebirth\nTotal: %d times\n\n", icon, rebirthDef.Name, count)
    infoText = infoText .. string.format("📝 %s\n\n", rebirthDef.Description)
    
    local canRebirth, progress = RebirthUtils.CanRebirth(playerData, rebirthType)
    infoText = infoText .. "📋 Requirements:\n"
    
    for _, req in ipairs(progress) do
        local met = req.Met
        local iconStatus = met and "✅" or "❌"
        local currentVal = req.Current
        local requiredVal = req.Required
        
        local currentNum = tonumber(tostring(currentVal)) or 0
        local requiredNum = tonumber(tostring(requiredVal)) or 1
        
        local progressPercent = 0
        if requiredNum > 0 and currentNum > 0 then progressPercent = math.min(100, (currentNum / requiredNum) * 100)
        elseif met then progressPercent = 100 end
        
        local barFilled = math.floor(progressPercent / 10)
        local bar = string.rep("█", barFilled) .. string.rep("░", 10 - barFilled)
        infoText = infoText .. string.format("  %s %s [%s] %d%%\n", iconStatus, req.Name, bar, math.floor(progressPercent))
    end
    
    local rewardAmount = RebirthUtils.GetRewardAmount(playerData, rebirthDef)
    local rewardStr = tostring(rewardAmount)
    infoText = infoText .. string.format("\n🎁 Reward: +%s %s\n", rewardStr, rebirthDef.Reward.Currency)
    infoText = infoText .. "\n" .. string.rep("─", 30) .. "\n"
    infoText = infoText .. (canRebirth and "🟢 READY TO REBIRTH!\n" or "🔴 Requirements not met\n")
    
    if uiElement then uiElement:SetDesc(infoText) end
end

local PrestigeRebirthToggle
local function LogicAutoPrestige()
    while Config.Upgraders.AutoPrestige do
        if Window.Destroyed then break end
        local success, msg = autoRebirth("Prestige")
        task.wait(success and 2 or 3)
    end
end
PrestigeRebirthToggle = MainTabs:Toggle({
    Title = "⭐ Auto Prestige",
    Flag = "Upgraders_PrestigeRebirth_Cfg",
    Callback = function(val)
        Config.Upgraders.AutoPrestige = val;
        if val then task.spawn(LogicAutoPrestige); end;
    end
});
FM_Add("Progressions", PrestigeRebirthToggle);

local SacrificeRebirthToggle
local function LogicAutoSacrifice()
    while Config.Upgraders.AutoSacrifice do
        if Window.Destroyed then break end
        local success, msg = autoRebirth("Sacrifice")
        task.wait(success and 2 or 3)
    end
end
SacrificeRebirthToggle = MainTabs:Toggle({
    Title = GetIcon(110938344194362) .. "Auto Sacrifice",
    Flag = "Upgraders_SacrificeRebirth_Cfg",
    Callback = function(val)
        Config.Upgraders.AutoSacrifice = val;
        if val then task.spawn(LogicAutoSacrifice); end;
    end
});
FM_Add("Progressions", SacrificeRebirthToggle);

-- =====================================================
-- [OPTIMASI] FUNGSI AUTO CONDENSED ENERGY
-- =====================================================
local function autoCondensedEnergy()
    pcall(function() CondensedRemote:FireServer("ConvertMax") end)
end

-- [OPTIMASI] showCondensedStatus - Terima playerData
local function showCondensedStatus(uiElement, playerData)
    if not playerData then return end
    
    local natureData = playerData.Currencies and playerData.Currencies[CondensedEnergy.SourceCurrency]
    local rate = CondensedEnergy.Rate
    
    local function formatCurrency(data)
        if type(data) == "table" and data[1] ~= nil then
            local mantissa = data[1] or 0
            local exponent = data[2] or 0
            if exponent == 0 then return string.format("%.2f", mantissa)
            else return string.format("%.2fe%d", mantissa, exponent) end
        elseif type(data) == "number" then return string.format("%.2f", data)
        else return "0" end
    end
    
    local function getRawValue(data)
        if type(data) == "table" and data[1] ~= nil then return (data[1] or 0) * math.pow(10, data[2] or 0)
        elseif type(data) == "number" then return data else return 0 end
    end
    
    local natureRaw = getRawValue(natureData)
    local convertible = CondensedEnergy.GetConvertibleAmount(natureData)
    local convertibleNum = tonumber(tostring(convertible)) or 0
    
    local infoText = "⚡ Condensed Energy Converter\n" .. string.rep("─", 40) .. "\n\n"
    infoText = infoText .. string.format("📊 Conversion Rate: %d NatureEnergy → 1 CondensedEnergy\n\n", rate)
    
    if convertibleNum > 0 then
        infoText = infoText .. "🟢 READY TO CONVERT!\n"
    else
        local needed = math.max(0, rate - natureRaw)
        infoText = infoText .. string.format("🔴 Need %s more NatureEnergy\n", formatCurrency({needed, 0}))
    end
    
    if uiElement then uiElement:SetDesc(infoText) end
end

local CondensedConvertToggle
local function LogicAutoCondensed()
    while Config.Upgraders.AutoCondensed do
        if Window.Destroyed then break end
        local success, msg = autoCondensedEnergy()
        task.wait(success and 1 or 2)
    end
end
CondensedConvertToggle = MainTabs:Toggle({
    Title = "⚡ Auto Condensed Energy",
    Flag = "Upgraders_CondensedConvert_Cfg",
    Callback = function(val)
        Config.Upgraders.AutoCondensed = val;
        if val then task.spawn(LogicAutoCondensed); end;
    end
});
FM_Add("Progressions", CondensedConvertToggle);

-- CardPackToggle tidak diaktifkan, jadi skip logic loop
-- =====================================================
-- [OPTIMASI] FUNGSI AUTO ADVENTURE - Networker dibuat SEKALI di luar loop
-- =====================================================
local AdventureRemote =  AllRemotes.AdventureService.RemoteEvent -- ✅ Buat SATU KALI saja

-- [OPTIMASI] Fungsi cek adventure dengan cooldown anti-spam
local AdventureBossCooldown = 0
local AdventureStageCooldown = 0
local AdventureAutoCooldown = 0

local function autoAdventure()
    DataService:waitForData()
    local playerData = DataService:get()
    
    local shinobiRank = playerData.ShinobiRank or 1
    if shinobiRank < 3 then return false, "Need Chuunin rank" end
    AdventureRemote:FireServer("SetAutoEnabled", true)
    
    local adventureData = playerData.Adventure
    if not adventureData then return false, "No adventure data" end
    
    local bossReady = adventureData.BossReady or false
    local autoEnabled = adventureData.AutoEnabled or false
    local stage = adventureData.Stage or 1
    local highestStage = adventureData.HighestStage or 1

    if bossReady then
        pcall(function() AdventureRemote:FireServer("StartBoss") end)
        return true, "Boss started"
    end
    
    return false, "Waiting for progress"
end

-- =====================================================
-- [OPTIMASI] FUNGSI STATUS ADVENTURE - Tetap menerima playerData dari luar
-- =====================================================
local function showAdventureStatus(uiElement, playerData)
    if not playerData then return end
    
    local infoText = "⚔️ Adventure Status\n"
    infoText = infoText .. string.rep("─", 40) .. "\n\n"
    
    local shinobiRank = playerData.ShinobiRank or 1
    
    if shinobiRank < 3 then
        infoText = infoText .. "🔒 Adventure locked!\n"
        infoText = infoText .. "Need: Shinobi Rank Chuunin (3)\n"
        infoText = infoText .. string.format("Current: Rank %d\n", shinobiRank)
        if uiElement then uiElement:SetDesc(infoText) end
        return
    end
    
    local adventureData = playerData.Adventure
    if not adventureData then
        infoText = infoText .. "No adventure data available.\n"
        if uiElement then uiElement:SetDesc(infoText) end
        return
    end
    
    local stage = adventureData.Stage or 1
    local highestStage = adventureData.HighestStage or 1
    local killsThisStage = adventureData.KillsThisStage or 0
    local killsRequired = adventureData.KillsRequired or 10
    local bossReady = adventureData.BossReady or false
    local autoEnabled = adventureData.AutoEnabled or false
    local totalKills = adventureData.TotalKills or 0
    
    -- Stage Info
    infoText = infoText .. string.format("📊 Stage: %d / %d\n", stage, highestStage)
    
    -- Progress Bar Kills
    local killPct = 0
    if killsRequired > 0 then killPct = math.min(100, (killsThisStage / killsRequired) * 100) end
    local killBarFilled = math.floor(killPct / 10)
    local killBar = string.rep("█", killBarFilled) .. string.rep("░", 10 - killBarFilled)
    infoText = infoText .. string.format("🎯 Kills: [%s] %d/%d (%d%%)\n\n", 
        killBar, killsThisStage, killsRequired, math.floor(killPct))
    
    -- Boss Status
    infoText = infoText .. "👑 Boss Status: "
    if bossReady then
        infoText = infoText .. "READY!\n"
    else
        infoText = infoText .. "Locked\n"
    end
    
    -- Auto Status
    infoText = infoText .. "🤖 Auto Mode: "
    if autoEnabled then
        infoText = infoText .. "ON ✅\n"
    else
        infoText = infoText .. "OFF ❌\n"
    end
    
    -- Enemy Info (jika ada)
    local enemy = adventureData.Enemy
    if enemy then
        infoText = infoText .. "\n👤 Current Enemy:\n"
        infoText = infoText .. string.format("  Name: %s\n", enemy.Name or "Unknown")
        infoText = infoText .. string.format("  Rarity: %s\n", enemy.Rarity or "Common")
        if enemy.IsBoss then
            infoText = infoText .. "  ⚡ BOSS FIGHT!\n"
        end
    end
    
    -- Total Kills
    infoText = infoText .. string.format("\n💀 Total Kills: %d\n", totalKills)
    
    -- Status
    infoText = infoText .. "\n" .. string.rep("─", 40) .. "\n"
    if bossReady then
        infoText = infoText .. "🟢 BOSS READY - Starting fight!\n"
    elseif autoEnabled then
        infoText = infoText .. "🟡 Auto mode active - Grinding...\n"
    else
        infoText = infoText .. "🔴 Enable auto for AFK grinding\n"
    end
    
    if uiElement then uiElement:SetDesc(infoText) end
end

-- =====================================================
-- [OPTIMASI] ADVENTURE - AUTO ADVENTURE + BOSS (LOOP UTAMA)
-- =====================================================
local AdventureAutoToggle

local function LogicAutoAdventure()
    AdventureAutoCooldown = os.clock()
    
    while Config.Upgraders.AutoAdventure do
        if Window.Destroyed then break end
        
        -- ✅ Panggil fungsi autoAdventure yang sudah dioptimasi
        local success, msg = autoAdventure()
        
        -- [OPTIMASI] Delay dinamis berdasarkan hasil
        if success then
            -- Jika ada aksi, tunggu sebentar lalu cek lagi
            if msg == "Boss started" then
                task.wait(2) -- Boss fight butuh waktu lebih lama
            elseif msg == "Auto enabled" then
                task.wait(3) -- Tunggu auto benar-benar aktif
            else
                task.wait(1)
            end
        else
            -- Tidak ada yang bisa dilakukan, tunggu lebih lama
            task.wait(2)
        end
    end
end

AdventureAutoToggle = MainTabs:Toggle({
    Title = "⚔️ Auto Adventure + Boss",
    Flag = "Upgraders_AdventureAuto_Cfg",
    Callback = function(val)
        Config.Upgraders.AutoAdventure = val;
        if val then
            task.spawn(LogicAutoAdventure);
        end;
    end
});
FM_Add("Progressions", AdventureAutoToggle);

-- =====================================================
-- [OPTIMASI] FUNGSI AUTO ASCENSION
-- =====================================================
local function autoAscend()
    DataService:waitForData()
    local playerData = DataService:get()
    
    local currentAscId = OtsutsukiAscensionUtils.NormalizeAscensionId(playerData.OtsutsukiAscension or 0)
    local maxAsc = OtsutsukiAscensionUtils.GetMaxAscension()
    
    if currentAscId >= maxAsc then return false, "MAX ASCENSION" end
    
    local nextAsc = OtsutsukiAscensionUtils.GetNextAscension(currentAscId)
    if not nextAsc then return false, "MAX ASCENSION" end
    
    local canAscend = OtsutsukiAscensionUtils.CanAscend(playerData, nextAsc)
    
    if canAscend then
        pcall(function() AscendRemote:FireServer("AttemptAscend") end)
        return true, "ASCENDED!"
    end
    return false, "Requirements not met"
end

-- [OPTIMASI] showAscensionStatus - Terima playerData
local function showAscensionStatus(uiElement, playerData)
    if not playerData then return end
    
    local currentAscId = OtsutsukiAscensionUtils.NormalizeAscensionId(playerData.OtsutsukiAscension or 0)
    local currentAscName = OtsutsukiAscensionUtils.GetNameById(currentAscId)
    local maxAsc = OtsutsukiAscensionUtils.GetMaxAscension()
    
    local infoText = GetIcon(84524784941090) .. "Otsutsuki Ascension\n"
    infoText = infoText .. string.rep("─", 40) .. "\n\n"
    infoText = infoText .. string.format("🏆 Current: %s (%d/%d)\n\n", currentAscName, currentAscId, maxAsc)
    
    if currentAscId >= maxAsc then
        infoText = infoText .. "✅ MAX ASCENSION ACHIEVED!\n"
    else
        local nextAsc = OtsutsukiAscensionUtils.GetNextAscension(currentAscId)
        if nextAsc then
            local nextAscName = OtsutsukiAscensionUtils.GetNameById(currentAscId + 1)
            infoText = infoText .. string.format("📈 Next: %s\n", nextAscName)
            infoText = infoText .. string.format("📊 Level Required: %d\n\n", nextAsc.LevelRequirement)
            
            -- Requirements Progress
            local progress = OtsutsukiAscensionUtils.GetRequirementProgress(playerData, nextAsc)
            infoText = infoText .. "📋 Requirements:\n"
            
            local allMet = true
            for _, req in ipairs(progress) do
                local met = req.Met
                local icon = met and "✅" or "❌"
                local curNum = tonumber(tostring(req.Current)) or 0
                local reqNum = tonumber(tostring(req.Required)) or 1
                
                local pct = 0
                if reqNum > 0 and curNum > 0 then
                    pct = math.min(100, (curNum / reqNum) * 100)
                elseif met then
                    pct = 100
                end
                local bar = string.rep("█", math.floor(pct / 10)) .. string.rep("░", 10 - math.floor(pct / 10))
                infoText = infoText .. string.format("  %s %s [%s] %d%%\n", icon, req.Name, bar, math.floor(pct))
                if not met then allMet = false end
            end
            
            -- Effects Preview
            local effects = OtsutsukiAscensionUtils.GetEffects(nextAsc)
            if effects then
                infoText = infoText .. "\n⚡ Effects:\n"
                for _, effect in ipairs(effects) do
                    local op = effect.Operation == "Multiply" and "x" or "+"
                    infoText = infoText .. string.format("  • %s: %s%s\n", effect.Stat, op, tostring(effect.Value))
                end
            end
            
            -- Eye Luck
            local eyeLuck = OtsutsukiAscensionUtils.GetEyeLuckMultiplier(currentAscId + 1)
            infoText = infoText .. string.format("  • Eye Luck: x%s\n", tostring(eyeLuck))
            
            -- Status
            infoText = infoText .. "\n" .. string.rep("─", 40) .. "\n"
            if allMet then
                infoText = infoText .. "🟢 READY TO ASCEND!\n"
            else
                infoText = infoText .. "🔴 Requirements not met\n"
            end
        end
    end
    
    if uiElement then uiElement:SetDesc(infoText) end
end

-- =====================================================
-- TOGGLE: AUTO ASCENSION
-- =====================================================
local AscendToggle

local function LogicAutoAscend()
    while Config.Upgraders.AutoAscend do
        if Window.Destroyed then break end
        local success, msg = autoAscend()
        task.wait(success and 2 or 5)
    end
end

AscendToggle = MainTabs:Toggle({
    Title = GetIcon(84524784941090) .. "Auto Ascension",
    Flag = "Upgraders_Ascend_Cfg",
    Callback = function(val)
        Config.Upgraders.AutoAscend = val
        if val then task.spawn(LogicAutoAscend) end
    end
})
FM_Add("Progressions", AscendToggle)

local AutoFarm_LastTeleportPosition = nil
local AutoFarm_SamePositionCount = 0
local AutoFarm_CurrentOrbIndex = 1

local function AutoFarm_ResetState()
    AutoFarm_LastTeleportPosition = nil
    AutoFarm_SamePositionCount = 0
    AutoFarm_CurrentOrbIndex = 1
end

local function AutoFarm_GetOrbFolder()
    local worldsFolder = Workspace:FindFirstChild("Worlds")
    if not worldsFolder then return nil end
    local worldFolder = worldsFolder:FindFirstChild(tostring(Config.AutoFarm.World))
    if not worldFolder then return nil end
    local platformsFolder = worldFolder:FindFirstChild("Platforms")
    if not platformsFolder then return nil end
    local platformFolder = platformsFolder:FindFirstChild(tostring(Config.AutoFarm.Platform))
    if not platformFolder then return nil end
    return platformFolder:FindFirstChild("Orbs")
end

local function AutoFarm_GetAllOrbs()
    local orbs = {}
    local orbFolder = AutoFarm_GetOrbFolder()
    if not orbFolder then return orbs end
    for _, child in ipairs(orbFolder:GetChildren()) do
        if child:IsA("BasePart") or child:IsA("Model") then
            table.insert(orbs, child)
        end
    end
    return orbs
end

local function AutoFarm_GetOrbPosition(orb)
    if orb:IsA("BasePart") then
        return orb.Position
    end
    if orb:IsA("Model") then
        local primaryPart = orb.PrimaryPart
        if primaryPart then
            return primaryPart.Position
        end
    end
    return nil
end

local function AutoFarm_GetHRP()
    local character = LocalPlayer.Character
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

local function AutoFarm_IsTooClose(newPosition)
    if not AutoFarm_LastTeleportPosition then
        return false
    end
    local minDist = tonumber(Config.AutoFarm.MinDistance) or 5
    return (newPosition - AutoFarm_LastTeleportPosition).Magnitude < minDist
end

local function AutoFarm_GetNextOrbIndex(totalOrbs)
    local mode = Config.AutoFarm.OrbIndex
    if mode == "nearest" then
        return "nearest"
    end
    if mode == "random" then
        return math.random(1, totalOrbs)
    end
    if mode == "sequential" then
        local idx = AutoFarm_CurrentOrbIndex
        AutoFarm_CurrentOrbIndex = AutoFarm_CurrentOrbIndex + 1
        if AutoFarm_CurrentOrbIndex > totalOrbs then
            AutoFarm_CurrentOrbIndex = 1
        end
        return idx
    end
    local numeric = tonumber(mode)
    if numeric then
        return math.clamp(math.floor(numeric), 1, totalOrbs)
    end
    return "nearest"
end

local function AutoFarm_MoveToCFrame(targetCFrame)
    local hrp = AutoFarm_GetHRP()
    if not hrp then return false end
    if Config.AutoFarm.Mode == "Tween" then
        local speed = tonumber(Config.AutoFarm.TweenSpeed) or 0.5
        local tweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()
        return true
    end
    hrp.CFrame = targetCFrame
    return true
end

local function AutoFarm_TeleportToOrb()
    local orbs = AutoFarm_GetAllOrbs()
    if #orbs == 0 then return false end

    local orbIndex = AutoFarm_GetNextOrbIndex(#orbs)
    local targetOrb

    if orbIndex == "nearest" then
        local hrp = AutoFarm_GetHRP()
        if not hrp then return false end
        local playerPos = hrp.Position
        local nearestDist = math.huge
        for _, orb in ipairs(orbs) do
            local orbPos = AutoFarm_GetOrbPosition(orb)
            if orbPos then
                local dist = (orbPos - playerPos).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    targetOrb = orb
                end
            end
        end
    else
        targetOrb = orbs[orbIndex]
    end

    if not targetOrb then return false end
    local targetPos = AutoFarm_GetOrbPosition(targetOrb)
    if not targetPos then return false end

    local hrp = AutoFarm_GetHRP()
    if not hrp then return false end
    local currentPos = hrp.Position
    local minDist = tonumber(Config.AutoFarm.MinDistance) or 5
    local distToTarget = (targetPos - currentPos).Magnitude
    if distToTarget < minDist then
        return false
    end

    if AutoFarm_IsTooClose(targetPos) then
        AutoFarm_SamePositionCount = AutoFarm_SamePositionCount + 1
        if AutoFarm_SamePositionCount >= 3 then
            targetOrb = orbs[math.random(1, #orbs)]
            targetPos = AutoFarm_GetOrbPosition(targetOrb)
            AutoFarm_SamePositionCount = 0
            if not targetPos then return false end
        else
            return false
        end
    else
        AutoFarm_SamePositionCount = 0
    end

    local height = tonumber(Config.AutoFarm.HeightOffset) or 5
    local targetCFrame = CFrame.new(targetPos + Vector3.new(0, height, 0))
    local ok = AutoFarm_MoveToCFrame(targetCFrame)
    if ok then
        AutoFarm_LastTeleportPosition = targetPos
    end
    return ok
end

local function LogicAutoFarm()
    AutoFarm_ResetState()
    while Config.AutoFarm.Enabled do
        if Window.Destroyed then break end
        pcall(function()
            AutoFarm_TeleportToOrb()
        end)
        local interval = tonumber(Config.AutoFarm.CollectInterval) or 0.1
        task.wait(math.max(interval, 0.05))
    end
end

local AutoFarmPlatformInput = MainTabs:Input({
    Title = "Platform",
    Desc = "The platform 1 to farm outer orbs\nThe platform 2 to farm inner orbs",
    Placeholder = tostring(Config.AutoFarm.Platform),
    Value = tostring(Config.AutoFarm.Platform),
    Flag = "AutoFarm_Platform",
    Callback = function(txt)
        if typeof(txt) == "string" and txt ~= "" then
            Config.AutoFarm.Platform = txt
        end
    end
})
FM_Add("Auto Farm", AutoFarmPlatformInput)

local AutoFarmModeDropdown = MainTabs:Dropdown({
    Title = "Move Mode",
    Values = {"Teleport", "Tween"},
    Value = tostring(Config.AutoFarm.Mode),
    Flag = "AutoFarm_Mode",
    Callback = function(option)
        local v = typeof(option) == "table" and option.Title or option
        if v == "Teleport" or v == "Tween" then
            Config.AutoFarm.Mode = v
        end
    end
})
FM_Add("Auto Farm", AutoFarmModeDropdown)

local AutoFarmOrbDropdown = MainTabs:Dropdown({
    Title = "Orb Target",
    Values = {"nearest", "random", "sequential"},
    Value = tostring(Config.AutoFarm.OrbIndex),
    Flag = "AutoFarm_OrbIndex",
    Callback = function(option)
        local v = typeof(option) == "table" and option.Title or option
        if v == "nearest" or v == "random" or v == "sequential" then
            Config.AutoFarm.OrbIndex = v
        end
    end
})
FM_Add("Auto Farm", AutoFarmOrbDropdown)

local AutoFarmTweenSpeedInput = MainTabs:Input({
    Title = "Tween Speed",
    Placeholder = tostring(Config.AutoFarm.TweenSpeed),
    Value = tostring(Config.AutoFarm.TweenSpeed),
    Flag = "AutoFarm_TweenSpeed",
    Callback = function(txt)
        local n = tonumber(txt)
        if n then
            Config.AutoFarm.TweenSpeed = n
        end
    end
})
FM_Add("Auto Farm", AutoFarmTweenSpeedInput)

local AutoFarmToggle = MainTabs:Toggle({
    Title = GetIcon(93057502485000) .. "Auto Farm Orbs",
    Flag = "AutoFarm_Enabled",
    Callback = function(val)
        Config.AutoFarm.Enabled = val
        if val then
            Notify("Auto Farm", "Started", "play")
            task.spawn(LogicAutoFarm)
        else
            Notify("Auto Farm", "Stopped", "square")
        end
    end
})
FM_Add("Auto Farm", AutoFarmToggle)
-- =====================================================
-- [OPTIMASI BESAR] UPDATE STATUS UI - Ambil DataService:get() SEKALI per 2 detik
-- =====================================================
task.spawn(function()
    while not Window.Destroyed do
        DataService:waitForData()
        local playerData = DataService:get()   -- ✅ Ambil SEKALI untuk semua status
        
        if SkillTreesUpgraders then showUpgradeStatus("PerkPoints", SkillTreesUpgraders, playerData) end
        if ChakraUpgrade then showUpgradeStatus("Chakra", ChakraUpgrade, playerData) end
        if PrestigeUpgrade then showUpgradeStatus("PrestigePoints", PrestigeUpgrade, playerData) end
        if NatureUpgrade then showUpgradeStatus("NatureEnergy", NatureUpgrade, playerData) end
        if CondensedUpgrade then showUpgradeStatus("CondensedEnergy", CondensedUpgrade, playerData) end
        if MeditationUpgrade then showUpgradeStatus("Meditation", MeditationUpgrade, playerData) end
        if HourglassUpgrade then showUpgradeStatus("HourglassFragments", HourglassUpgrade, playerData) end
        if AdventureUpgrade then showUpgradeStatus("AdventureCoins", AdventureUpgrade, playerData) end
        if SacrificeUpgrade then showUpgradeStatus("SacrificePoints", SacrificeUpgrade, playerData) end
        if SoulsUpgrade then showUpgradeStatus("Souls", SoulsUpgrade, playerData) end
        if BijuuUpgrade then showUpgradeStatus("BijuuChakra", BijuuUpgrade, playerData) end
        if RankUpToggle then showRankUpStatus(RankUpToggle, playerData) end
        if PrestigeRebirthToggle then showRebirthStatus("Prestige", PrestigeRebirthToggle, playerData) end
        if SacrificeRebirthToggle then showRebirthStatus("Sacrifice", SacrificeRebirthToggle, playerData) end
        if CondensedConvertToggle then showCondensedStatus(CondensedConvertToggle, playerData) end
        if AdventureAutoToggle then showAdventureStatus(AdventureAutoToggle, playerData) end
        if AscendToggle then showAscensionStatus(AscendToggle, playerData) end

        task.wait(2)  -- ✅ Interval 2 detik (sebelumnya 0.5)
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

FM_OnChange("Skills")
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
