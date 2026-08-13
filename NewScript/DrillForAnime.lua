-- if game.PlaceId ~= 81897457567012 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Drill For Anime"
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

local FolderPath = "ANUI/DrillForAnime"
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local LastConfigFile = FolderPath .. "/LastConfig.txt"
local IsPremium = false
local ValidKeys = {"ANHUB-2025"}
local MapDBFile = "Map_Database.json"
local Config = {
    SelectedEnemy = nil,
    MapConfigurations = {},
    Upgraders = {
    }
}
local ConfigName = "ANConfig"
local CurrentMapEnemiesCache = {}
local IsLoadingConfig = false
local IsLoadingMapSelection = false
local ConfigNameInput

BaseModule = ReplicatedStorage.Modules
DailyRewardsConfig = require(BaseModule.DailyRewardsConfig)
ItemConfigurations = require(BaseModule.ItemConfigurations)
RebirthConfig = require(BaseModule.RebirthConfigurations)
UpgradeConfig = require(BaseModule.UpgradeConfigurations)
NumberFormatter = require(BaseModule.NumberFormatter)
ClaimEvent = ReplicatedStorage.Events.ClaimDailyReward
CooldownSeconds = DailyRewardsConfig.CooldownSeconds
RewardsList = DailyRewardsConfig.Rewards
RequestRebirthEvent = ReplicatedStorage.Events.RequestRebirth
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
    Title = "AN Hub - Drill For Anime",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "DrillForAnime",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Drill For Anime" }),
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
    ["Main Feature"] = "All Basic Feature",
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
    Title = "Main",
    Icon = "swords",
    Profile = MakeProfile({
        Avatar = GameIconURL,
        Title = "Main",
        Desc = "Drill For Anime"
    }),
    SidebarProfile = false
});

-- Pembuatan Selector Kategori
FM_CategorySelector = MainTabs:Category({
    Title = "Select Category",
    Default = "Main Feature",
    Options = {
        {Title = "Main Feature", Icon = GetIcon(140684736911247)},
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

-- ============ DAILY REWARDS AUTO CLAIM ============

local AutoClaimEnabled = false
local LastFireTime = 0  -- mencegah spam claim

-- Helper: ubah data hadiah menjadi teks singkat
local function GetRewardText(reward)
    if reward.Type == "Cash" then
        return "$" .. NumberFormatter.Format(reward.Amount)
    elseif reward.Type == "Item" then
        local itemData = ItemConfigurations.GetItemData(reward.Name)
        local baseName = itemData and itemData.Name or reward.Name
        if reward.Mutation and reward.Mutation ~= "Normal" then
            baseName = string.format("%s%s %s",itemData.ImageId,reward.Mutation,baseName)
        else
            baseName = string.format("%s%s ",itemData.ImageId,baseName)
        end
        return baseName
    end
    return "???"
end

-- Helper: waktu tunggu dalam format pendek
local function FormatTimeLeft(seconds)
    if seconds <= 0 then return "Available" end
    if seconds < 3600 then
        return string.format("%dm %ds", math.floor(seconds/60), math.floor(seconds%60))
    elseif seconds < 86400 then
        local h = math.floor(seconds/3600)
        local m = math.floor((seconds%3600)/60)
        return string.format("%dh %dm", h, m)
    else
        local d = math.ceil(seconds/86400)
        return d .. "d"
    end
end

-- Menghitung string deskripsi lengkap
local function BuildRewardsDesc()
    local currentDay = LocalPlayer:GetAttribute("DR_CurrentDay") or 1
    local lastClaim = LocalPlayer:GetAttribute("DR_LastClaimTime") or 0
    local now = os.time()
    local elapsed = now - lastClaim
    local cooldownRemaining = math.max(0, CooldownSeconds - elapsed)

    local lines = {}
    for i, reward in ipairs(RewardsList) do
        local rewardText = GetRewardText(reward)
        local status = ""
        if i < currentDay then
            status = "✅ Claimed"
        elseif i == currentDay then
            if lastClaim == 0 or elapsed >= CooldownSeconds then
                status = "🎁 Available"
            else
                status = "⏳ " .. FormatTimeLeft(cooldownRemaining)
            end
        else
            local timeToDay = cooldownRemaining + CooldownSeconds * (i - currentDay)
            status = "⏳ " .. FormatTimeLeft(timeToDay)
        end
        table.insert(lines, string.format("Day %d: %s - %s", i, status, rewardText))
    end
    return table.concat(lines, "\n")
end

-- Toggle Auto Claim
local AutoClaimToggle = MainTabs:Toggle({
    Title = "Daily Reward",
    Desc = BuildRewardsDesc(),  -- deskripsi awal
    Flag = "AutoClaimDaily",
    Callback = function(state)
        AutoClaimEnabled = state
        if state then
            -- Langsung klaim jika memungkinkan
            local lastClaim = LocalPlayer:GetAttribute("DR_LastClaimTime") or 0
            if lastClaim == 0 or (os.time() - lastClaim) >= CooldownSeconds then
                ClaimEvent:FireServer()
                LastFireTime = os.time()
            end
        end
    end
})
FM_Add("Main Feature", AutoClaimToggle)
-- Perbarui deskripsi toggle setiap detik
task.spawn(function()
    while not Window.Destroyed do
        if AutoClaimToggle and AutoClaimToggle.SetDesc then
            AutoClaimToggle:SetDesc(BuildRewardsDesc())
        end
        task.wait(1)
    end
end)

-- Loop auto‑claim (berjalan selama toggle aktif)
task.spawn(function()
    while not Window.Destroyed do
        if AutoClaimEnabled then
            local lastClaim = LocalPlayer:GetAttribute("DR_LastClaimTime") or 0
            local now = os.time()
            if lastClaim == 0 or (now - lastClaim) >= CooldownSeconds then
                if now - LastFireTime > 5 then  -- hindari spam
                    ClaimEvent:FireServer()
                    LastFireTime = now
                end
            end
        end
        task.wait(1)
    end
end)

-- ============ AUTO REBIRTH FEATURE ============

local AutoRebirthEnabled = false
local LastRebirthAttempt = 0
local RebirthCooldown = 1 -- detik minimal antar percobaan

-- Fungsi cek apakah sebuah requirement terpenuhi
local function IsRequirementMet(req)
    if req.Type == "Cash" then
        return (LocalPlayer:GetAttribute("Cash") or 0) >= req.Amount
    elseif req.Type == "Power" then
        return (LocalPlayer:GetAttribute("PowerLevel") or 1) >= req.PowerLevel
    elseif req.Type == "Item" then
        -- Cek Backpack
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and tool:GetAttribute("OriginalName") == req.Name then
                    return true
                end
            end
        end
        -- Cek Character
        local character = LocalPlayer.Character
        if character then
            for _, tool in ipairs(character:GetChildren()) do
                if tool:IsA("Tool") and tool:GetAttribute("OriginalName") == req.Name then
                    return true
                end
            end
        end
        -- Cek Plots (workspace.Plots > plot milik player > Floor > Slots)
        local plotsFolder = workspace:FindFirstChild("Plots")
        if plotsFolder then
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                if plot:IsA("Model") and plot:GetAttribute("Owner") == LocalPlayer.UserId then
                    for _, floor in ipairs(plot:GetChildren()) do
                        if floor:IsA("Model") and floor.Name:match("^Floor%d+$") then
                            local slots = floor:FindFirstChild("Slots")
                            if slots then
                                for _, slot in ipairs(slots:GetChildren()) do
                                    if slot:IsA("Model") and slot:GetAttribute("PlacedItem") == req.Name then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return false
    end
    return false
end

-- Menghasilkan teks deskripsi untuk toggle
local function BuildRebirthDescription()
    local currentLvl = LocalPlayer:GetAttribute("RebirthLevel") or 0
    local nextLvl = currentLvl + 1
    local rebirthData = RebirthConfig.Rebirths[nextLvl]
    if not rebirthData then
        return "✅ Maximum Rebirth reached!"
    end

    local lines = {
        string.format("Rebirth %d → %d\n", currentLvl, nextLvl),
        "",
        "🔹 Requirements:\n"
    }

    -- Cek tiap persyaratan
    local allMet = true
    for i, req in ipairs(rebirthData.Requirements) do
        local met = IsRequirementMet(req)
        if not met then allMet = false end
        local icon = met and "✅" or "⬜"
        if req.Type == "Cash" then
            table.insert(lines, string.format("%s $%s Cash", icon, NumberFormatter.Format(req.Amount)))
        elseif req.Type == "Power" then
            local powerName = (UpgradeConfig.Power and UpgradeConfig.Power[req.PowerLevel] and UpgradeConfig.Power[req.PowerLevel].Power) or req.PowerLevel
            table.insert(lines, string.format("%s %s Power", icon, powerName))
        elseif req.Type == "Item" then
            local itemData = ItemConfigurations.GetItemData(req.Name)
            local displayName = itemData and itemData.Name or req.Name
            table.insert(lines, string.format("%s %s%s", icon,itemData.ImageId, displayName))
        end
    end

    -- Hitung reward
    local rewards = {}
    if rebirthData.SlotsAwarded and rebirthData.SlotsAwarded > 0 then
        table.insert(rewards, string.format("+%d Slots", rebirthData.SlotsAwarded))
    end
    if rebirthData.RewardMultiplier and rebirthData.RewardMultiplier > 1 then
        local percent = math.floor((rebirthData.RewardMultiplier - 1) * 100)
        table.insert(rewards, string.format("+%d%% Money", percent))
    end
    -- Floor reward (sama logika client)
    if rebirthData.SlotsAwarded then
        local slotsPerFloor = RebirthConfig.SlotsPerFloor or 10
        local totalSlotsNow = 0
        for lvl = 1, currentLvl do
            local rb = RebirthConfig.Rebirths[lvl]
            if rb and rb.SlotsAwarded then
                totalSlotsNow = totalSlotsNow + rb.SlotsAwarded
            end
        end
        local totalSlotsNext = totalSlotsNow + rebirthData.SlotsAwarded
        local currentFloors = math.ceil(totalSlotsNow / slotsPerFloor)
        local nextFloors = math.ceil(totalSlotsNext / slotsPerFloor)
        local floorDiff = nextFloors - currentFloors
        if floorDiff > 0 then
            table.insert(rewards, string.format("+%d Floor", floorDiff))
        end
    end

    table.insert(lines, "")
    table.insert(lines, "\nRewards:\n")
    for _, rwd in ipairs(rewards) do
        table.insert(lines, "" .. rwd)
    end

    table.insert(lines, "")
    if allMet then
        return table.concat(lines, "\t") .. "\n🎁 Ready to Rebirth!"
    else
        return table.concat(lines, "\t") .. "\n⏳ Requirements not met"
    end
end

-- Toggle Auto Rebirth
local AutoRebirthToggle = MainTabs:Toggle({
    Title = "Auto Rebirth",
    Desc = BuildRebirthDescription(),
    Flag = "AutoRebirth",
    Callback = function(state)
        AutoRebirthEnabled = state
        if state then
            -- Langsung coba rebirth jika memungkinkan
            local currentLvl = LocalPlayer:GetAttribute("RebirthLevel") or 0
            local nextData = RebirthConfig.Rebirths[currentLvl + 1]
            if nextData then
                local allMet = true
                for _, req in ipairs(nextData.Requirements) do
                    if not IsRequirementMet(req) then allMet = false break end
                end
                if allMet then
                    RequestRebirthEvent:FireServer()
                    LastRebirthAttempt = os.time()
                end
            end
        end
    end
})
FM_Add("Main Feature", AutoRebirthToggle)
-- Update deskripsi setiap detik
task.spawn(function()
    while not Window.Destroyed do
        if AutoRebirthToggle and AutoRebirthToggle.SetDesc then
            AutoRebirthToggle:SetDesc(BuildRebirthDescription())
        end
        task.wait(1)
    end
end)

-- Loop auto rebirth (jeda 2 detik agar tidak spam)
task.spawn(function()
    while not Window.Destroyed do
        if AutoRebirthEnabled then
            local currentLvl = LocalPlayer:GetAttribute("RebirthLevel") or 0
            local nextData = RebirthConfig.Rebirths[currentLvl + 1]
            if nextData then
                local allMet = true
                for _, req in ipairs(nextData.Requirements) do
                    if not IsRequirementMet(req) then allMet = false break end
                end
                if allMet then
                    local now = os.time()
                    if now - LastRebirthAttempt >= RebirthCooldown then
                        RequestRebirthEvent:FireServer()
                        LastRebirthAttempt = now
                    end
                end
            end
        end
        task.wait(1) -- cek tiap 2 detik
    end
end)
-- ============ AUTO COMBAT FEATURE (Teleport to Map.Claim) ============
local AutoCombatTab = Window:Tab({ Title = "Auto Combat", Icon = "swords" })
AutoCombatTab:Section({ Title = "Target Filter", Opened = true })

-- Muat modul ItemConfigurations
local ItemConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ItemConfigurations"))

-- State filter
local SelectedItemName = "All Items"
local SelectedMutation = "Any"

-- Event
local EventsFolder = ReplicatedStorage:WaitForChild("Events")
local StartCombatEvent = EventsFolder:FindFirstChild("StartCombat")
local CombatUpdateEvent = EventsFolder:WaitForChild("CombatUpdate")
local CombatEndedEvent = EventsFolder:WaitForChild("CombatEnded")
local CombatMultiplierEvent = EventsFolder:FindFirstChild("CombatMultiplier")

-- Referensi MainGui dan tombol power
local MainGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGui")
local PowerButtons = {
    { btn = MainGui:WaitForChild("X2Power"), mult = 2 },
    { btn = MainGui:WaitForChild("X3Power"), mult = 3 },
    { btn = MainGui:WaitForChild("X4Power"), mult = 4 },
}

-- State auto combat
local AutoCombatEnabled = false
local InCombat = false
local CurrentTargetModel = nil
local TargetCurrentHP = 0
local TargetMaxHP = 0
local TargetName = ""
local LastMultiplier = 0
local MultiplierUsedThisSpawn = false
local TeleportOnWinOnly = false

-- Fungsi membuat daftar nilai dropdown Item
local function BuildItemDropdownValues()
    local vals = {}
    for itemName, itemData in pairs(ItemConfig.Items) do
        local icon = itemData.ImageId or "rbxassetid://84366761557806"
        table.insert(vals, {
            Title = itemName,
            Icon = icon,
            Value = itemName,
            Order = itemData.Order,
            Desc = "Rarity: " .. (itemData.Rarity or "Common")
        })
    end
    table.sort(vals, function(a, b) return a.Order < b.Order end)
    return vals
end

-- Fungsi membuat daftar nilai dropdown Mutation
local function BuildMutationDropdownValues()
    return {
        { Title = "Normal", Value = "Normal", Desc = "Normal version" },
        { Title = "Golden", Value = "Golden", Desc = "Golden version" },
        { Title = "Diamond", Value = "Diamond", Desc = "Diamond version" },
        { Title = "Magma", Value = "Magma", Desc = "Magma version" },
        { Title = "Void", Value = "Void", Desc = "Void version" },
    }
end

-- Dropdown untuk memilih item target
local ItemDropdown = AutoCombatTab:Dropdown({
    Title = "Target Item",
    Desc = "Select item to farm",
    Values = BuildItemDropdownValues(),
    Flag = "AutoFarm_AnimeMutation",
    Multi = false,
    Callback = function(val)
        SelectedItemName = type(val) == "table" and val.Value or val
    end
})

-- Dropdown untuk memilih mutasi
local MutationDropdown = AutoCombatTab:Dropdown({
    Title = "Target Mutation",
    Desc = "Select mutation type",
    Values = BuildMutationDropdownValues(),
    Flag = "AutoFarm_Mutation",
    Multi = false,
    Callback = function(val)
        SelectedMutation = type(val) == "table" and val.Value or val
    end
})

-- Fungsi mencari target combat dengan filter
local function FindCombatTarget()
    local spawnFolder = workspace:FindFirstChild("SpawnedItems")
    if not spawnFolder then return nil end

    for _, model in ipairs(spawnFolder:GetChildren()) do
        if model:IsA("Model") then
            -- Filter berdasarkan item name
            if SelectedItemName ~= "All Items" then
                local originalName = model:GetAttribute("ItemName")
                if originalName ~= SelectedItemName then
                    continue
                end
            end
            -- Filter berdasarkan mutation
            if SelectedMutation ~= "Any" then
                local mutation = model:GetAttribute("Mutation")
                if mutation ~= SelectedMutation then
                    continue
                end
            end
            return model
        end
    end
    return nil
end

-- Teleport ke dekat target
local function TeleportToTarget(targetModel)
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local targetPos = targetModel.PrimaryPart and targetModel.PrimaryPart.Position or targetModel:GetPivot().Position
    hrp.CFrame = CFrame.new(targetPos + Vector3.new(5, 0, 5))
    return true
end

-- Teleport ke area Map.Claim
local function TeleportToClaim()
    local claimArea = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Claim")
    if not claimArea then
        warn("[Auto Combat] workspace.Map.Claim not found!")
        return
    end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetPos
    if claimArea:IsA("BasePart") then
        targetPos = claimArea.Position
    elseif claimArea:IsA("Model") then
        targetPos = claimArea.PrimaryPart and claimArea.PrimaryPart.Position or claimArea:GetPivot().Position
    else
        targetPos = Vector3.zero
    end
    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
end

-- Reset state
local function ResetCombatState()
    InCombat = false
    CurrentTargetModel = nil
    TargetCurrentHP = 0
    TargetMaxHP = 0
    TargetName = ""
    LastMultiplier = 0
    MultiplierUsedThisSpawn = false
end

-- Deskripsi toggle
local function BuildAutoCombatDesc()
    if not AutoCombatEnabled then return "Toggle ON to start auto combat" end
    local lines = {}
    if InCombat then
        lines[#lines+1] = "⚔️ Status: In Combat"
        lines[#lines+1] = string.format("🎯 Target: %s", TargetName)
        lines[#lines+1] = string.format("❤️ HP: %d / %d", TargetCurrentHP, TargetMaxHP)
        lines[#lines+1] = string.format("💥 Last Multiplier: x%d", LastMultiplier)
    else
        lines[#lines+1] = "⏸️ Status: Idle"
        if SelectedItemName ~= "All Items" or SelectedMutation ~= "Any" then
            lines[#lines+1] = string.format("🔍 Filter: %s [%s]", SelectedItemName, SelectedMutation)
        else
            lines[#lines+1] = "🔍 Searching for any target..."
        end
    end
    return table.concat(lines, "\n")
end

-- Cek multiplier yang muncul
local function GetAvailableMultiplier()
    for _, data in ipairs(PowerButtons) do
        if data.btn and data.btn.Visible then
            return data.mult
        end
    end
    return nil
end

-- Mulai combat dengan teleport
local function StartCombatWithTarget(target)
    if not target then return false end
    if not TeleportToTarget(target) then return false end
    task.wait(0.3)
    if StartCombatEvent then
        StartCombatEvent:FireServer(target)
        return true
    end
    return false
end

-- Toggle Auto Combat
local AutoCombatToggle = AutoCombatTab:Toggle({
    Title = "Auto Combat",
    Desc = BuildAutoCombatDesc(),
    Flag = "AutoCombat",
    Callback = function(state)
        AutoCombatEnabled = state
        if state and not InCombat then
            local target = FindCombatTarget()
            if target then StartCombatWithTarget(target) end
        end
        if not state then ResetCombatState() end
    end
})

-- Update deskripsi setiap detik
task.spawn(function()
    while not Window.Destroyed do
        if AutoCombatToggle and AutoCombatToggle.SetDesc then
            AutoCombatToggle:SetDesc(BuildAutoCombatDesc())
        end
        task.wait(1)
    end
end)

-- Simpan koneksi ke variabel
local CombatUpdateConn
local CombatEndedConn

CombatUpdateConn = CombatUpdateEvent.OnClientEvent:Connect(function(msgType, data)
    if not AutoCombatEnabled then return end
    if msgType == "start" then
        InCombat = true
        CurrentTargetModel = data.itemModel
        TargetCurrentHP = data.itemCurrentHP
        TargetMaxHP = data.itemMaxHP
        TargetName = CurrentTargetModel and (CurrentTargetModel:GetAttribute("OriginalName") or CurrentTargetModel.Name) or "Unknown"
        LastMultiplier = 1
        MultiplierUsedThisSpawn = false
    elseif msgType == "playerHit" or msgType == "specialHit" then
        if CurrentTargetModel then
            TargetCurrentHP = data.itemCurrentHP
            TargetMaxHP = data.itemMaxHP
        end
        if msgType == "specialHit" and data.multiplier then
            LastMultiplier = data.multiplier
        end
    end
end)

CombatEndedConn = CombatEndedEvent.OnClientEvent:Connect(function(result)
    if not AutoCombatEnabled then return end
    InCombat = false
    CurrentTargetModel = nil
    MultiplierUsedThisSpawn = false

    TeleportToClaim()
    task.wait(1.5)

    if AutoCombatEnabled and not InCombat then
        local target = FindCombatTarget()
        if target then StartCombatWithTarget(target) end
    end
end)

-- Fungsi cleanup terpusat
local function DisconnectCombatEvents()
    if CombatUpdateConn then
        CombatUpdateConn:Disconnect()
        CombatUpdateConn = nil
    end
    if CombatEndedConn then
        CombatEndedConn:Disconnect()
        CombatEndedConn = nil
    end
end

task.spawn(function()
    repeat
        task.wait(0.5)
    until IsWindowAlive() == false
    DisconnectCombatEvents()
end)

-- Loop auto-start combat (jika idle)
task.spawn(function()
    while not Window.Destroyed do
        if AutoCombatEnabled and not InCombat then
            local target = FindCombatTarget()
            if target then StartCombatWithTarget(target) end
        end
        task.wait(3)
    end
end)

-- Loop auto multiplier
task.spawn(function()
    while not Window.Destroyed do
        if AutoCombatEnabled and InCombat and not MultiplierUsedThisSpawn then
            local mult = GetAvailableMultiplier()
            if mult and CombatMultiplierEvent then
                CombatMultiplierEvent:FireServer(mult)
                LastMultiplier = mult
                MultiplierUsedThisSpawn = true
                for _, data in ipairs(PowerButtons) do
                    if data.mult == mult and data.btn then
                        data.btn.Visible = false
                        break
                    end
                end
            end
        end
        if not GetAvailableMultiplier() then
            MultiplierUsedThisSpawn = false
        end
        task.wait(0.5)
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
FM_OnChange("Main Feature")
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
