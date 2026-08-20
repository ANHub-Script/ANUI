if game.PlaceId ~= 121777131192481 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Magnet Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local character = LocalPlayer.Character
local rootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
humanoid.WalkSpeed = 50  -- nilai default biasanya 16

local FolderPath = "ANUI/MagnetIncremental"
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
    Title = "AN Hub - Magnet Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "MagnetIncremental",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Magnet Incremental" }),
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
ManagedLoops = {}
local Connections = {}  -- simpan semua koneksi yang akan diputus saat Window hancur

function AddConnection(connection)
    table.insert(Connections, connection)
    return connection
end

function DisconnectAll()
    for _, conn in ipairs(Connections) do
        pcall(function() conn:Disconnect() end)
    end
    Connections = {}
end
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

FM_CategoryDescriptions = {}
function FM_GetElementFrame(elem)
    return rawget(elem, "ElementFrame") or elem.UIElements and elem.UIElements.Main or rawget(elem, "GroupFrame")
end
Categories = {}
function FM_Add(cat, elem)
    if not Categories[cat] then
        Categories[cat] = {}
    end
    table.insert(Categories[cat], elem)
    local frame = FM_GetElementFrame(elem)
    if frame then
        frame.Visible = false
    end
    return elem
end
function FM_OnChange(selected)
    for name, elems in pairs(Categories) do
        local vis = name == selected
        for _, e in ipairs(elems) do
            local f = FM_GetElementFrame(e)
            if f then
                f.Visible = vis
            end
        end
    end
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
-- local bridgeCache = nil

-- for _, obj in pairs(getgc(true)) do
--     if type(obj) == "table" then
--         for k, v in pairs(obj) do
--             -- cari tabel yang memiliki value berupa table dengan _name == k
--             if type(k) == "string" and type(v) == "table" and rawget(v, "_name") == k then
--                 bridgeCache = obj
--                 break
--             end
--         end
--     end
-- end

-- setclipboard(JSONPretty(bridgeCache,1))
local function requireModule(folder,configs)
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("ModuleScript") then
            configs[child.Name] = require(child)
        end
    end
end
local function requireRemote(folder,configs)
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or child:IsA("BindableEvent") then
            configs[child.Name] = child
        end
    end
end
---- REQUIRE MODULE ---
StatModule = require(ReplicatedStorage.List.StatModule)
Framework = require(ReplicatedStorage.Framework)
BridgeNet = Framework.BridgeNet
DataService = Framework.DataService.client
BigNum = Framework.BigNum
UpgradeBoards = require(ReplicatedStorage.List.UpgradeBoards)
RichText = require(ReplicatedStorage.Packages.RichText)
UpgradeTree = require(ReplicatedStorage.List.UpgradeTree)
SkillTreeList = require(ReplicatedStorage.List.SkillTree)
TweenService = game:GetService("TweenService")
----
---- REMOTE HANDLER ---
BuyUpgradeBridge = BridgeNet.ReferenceBridge("BuyUpgrade")
PurchaseUpgradeNodeBridge = BridgeNet.ReferenceBridge("PurchaseUpgradeNode")
UpgradeSkillBridge = BridgeNet.ReferenceBridge("UpgradeSkill")
-- TierUPBridge = BridgeNet.ReferenceBridge("TierUPButton")
----
local Options = {}
table.insert(Options,{Title = "Automation",Icon = GetIcon(131036042070680)})
-- Ambil Stats dari modul
local Stats = StatModule.Stats

-- Buat array sementara untuk sorting
local temp = {}
for statName, statData in pairs(Stats) do
    -- if statData.Order < 0 then continue end
    table.insert(temp, {
        Name = statName,
        Icon = statData.Icon,
        Order = statData.Order
    })
end

-- Urutkan berdasarkan Order dari terkecil (ascending)
table.sort(temp, function(a, b)
    return a.Order < b.Order
end)

-- Isi Options dengan nama stat yang sudah terurut
for _, entry in ipairs(temp) do
    table.insert(Options, {
        Title = entry.Name,
        Icon = entry.Icon
    })
end

-- [[ MAIN TAB ]] --
MainTabs = Window:Tab({
    Title = "Main Feature",
    Icon = "swords",
    SidebarProfile = false
});

FM_CategorySelector = MainTabs:Category({
    Default = "Automation",
    Options = Options,
    Callback = FM_OnChange
})
if FM_CategorySelector.ElementFrame then
    FM_CategorySelector.ElementFrame.Parent = MainTabs.UIElements.ContainerFrameCanvas
    FM_CategorySelector.ElementFrame.Position = UDim2.new(0, 0, 0, MainTabs.UIElements.ContainerFrame.Position.Y.Offset)
    local catSize = FM_CategorySelector.ElementFrame.Size.Y.Offset
    MainTabs.UIElements.ContainerFrame.Position = UDim2.new(0, 0, 0, MainTabs.UIElements.ContainerFrame.Position.Y.Offset + catSize)
    MainTabs.UIElements.ContainerFrame.Size = UDim2.new(1, 0, 1, MainTabs.UIElements.ContainerFrame.Size.Y.Offset - catSize)
    local pad = MainTabs.UIElements.ContainerFrame:FindFirstChildOfClass("UIPadding")
    if pad then
        pad.PaddingTop = UDim.new(0, 5)
    end
end

-- =====================================================
-- AUTO MOVE TO RANDOM BLOCKID PART (1 Toggle)
-- =====================================================

local currentBlockTween = nil
local currentTargetBlock = nil

-- Fungsi mengambil semua Part yang punya Attribute BlockID
local function getAllBlockParts()
    local parts = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj:GetAttribute("BlockID") ~= nil then
            table.insert(parts, obj)
        end
    end
    return parts
end

-- Fungsi memilih part random dari daftar
local function getRandomBlockPart()
    local parts = getAllBlockParts()
    if #parts == 0 then
        return nil
    end
    return parts[math.random(1, #parts)]
end

local autoBlockMoveToggle = MainTabs:Toggle({
    Title = "Auto Move to Random BlockID",
    Flag = "AutoMoveBlockID_Random_Cfg",
    Value = false,
    Callback = function(val)
        if val then
            StartManagedLoop("AutoMoveBlockID_Random", 1, function()
                return true
            end, function()
                local character = LocalPlayer.Character
                if not character then return end

                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end

                -- Jika belum ada target atau sudah dekat, pilih target random baru
                if not currentTargetBlock then
                    currentTargetBlock = getRandomBlockPart()
                else
                    local dist = (currentTargetBlock.Position - rootPart.Position).Magnitude
                    if dist < 5 then
                        -- Sudah sampai, pilih part random lain
                        currentTargetBlock = getRandomBlockPart()
                    end
                end

                if not currentTargetBlock then return end

                local targetPos = currentTargetBlock.Position + Vector3.new(0, 3, 0)
                local targetCFrame = CFrame.new(targetPos)

                -- Batalkan tween sebelumnya jika masih berjalan
                if currentBlockTween then
                    currentBlockTween:Cancel()
                end

                currentBlockTween = TweenService:Create(
                    rootPart,
                    TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                    { CFrame = targetCFrame }
                )
                currentBlockTween:Play()
            end)
        else
            StopManagedLoop("AutoMoveBlockID_Random")
            if currentBlockTween then
                currentBlockTween:Cancel()
                currentBlockTween = nil
            end
            currentTargetBlock = nil
        end
    end
})
FM_Add("Automation",autoBlockMoveToggle)

-- Status toggle
StartStatusLoop("Status_AutoMoveBlockID_Random", 1, function()
    if not autoBlockMoveToggle then return end

    local totalParts = #getAllBlockParts()
    local desc = string.format("Total BlockID Parts: %d", totalParts)

    if currentTargetBlock then
        desc = desc .. string.format("\nTarget: %s", currentTargetBlock.Name)
    end

    SafeSetTitle(autoBlockMoveToggle, "Auto Move to Random BlockID")
    SafeSetDesc(autoBlockMoveToggle, desc)
end)

-- =====================================================
-- AUTO UPGRADE SEMUA BOARD
-- Sort: StatName -> Board -> Order
-- Group: 2 toggle per group
-- =====================================================
local allUpgrades = UpgradeBoards.GetAllUpgrades()

-- Fungsi natural sort untuk nama board
local function naturalBoardCompare(a, b)
    local function pad(s)
        return (s:gsub("%d+", function(num)
            return string.rep("0", 10 - #num) .. num
        end)):lower()
    end
    return pad(a) < pad(b)
end
local function GetUpgradeBoostText(upgradeData, level)
    -- Jika upgrade punya GetBoostText, gunakan itu
    if upgradeData.GetBoostText then
        return upgradeData.GetBoostText(level)
    end

    -- Kalau tidak, hitung boost lalu format
    local boostValue = upgradeData.GetBoost(level)
    local boostText = BigNum.toSuffix(boostValue)
    local prefix = upgradeData.BoostPrefix or ""
    local suffix = upgradeData.Suffix or ""
    local boostName = upgradeData.BoostName or ""

    return string.format("%s%s%s %s", prefix, boostText, suffix, boostName)
end
-- Kumpulkan upgrade berdasarkan StatName
local statGroups = {}

for upgradeName, upgradeData in pairs(allUpgrades) do
    local board = UpgradeBoards.GetUpgradeBoard(upgradeData.BoardID)
    local statName = board and board.StatName or "Unknown"

    if not statGroups[statName] then
        statGroups[statName] = {}
    end

    table.insert(statGroups[statName], {
        Name = upgradeName,
        Data = upgradeData,
        StatName = statName,
        Board = board,
        BoardID = upgradeData.BoardID
    })
end

-- Urutkan nama Stat berdasarkan Order di StatModule
local statOrderMap = {}
for statName, statData in pairs(StatModule.Stats) do
    statOrderMap[statName] = statData.Order or 999
end

local sortedStatNames = {}
for statName in pairs(statGroups) do
    table.insert(sortedStatNames, statName)
end

table.sort(sortedStatNames, function(a, b)
    local orderA = statOrderMap[a] or 999
    local orderB = statOrderMap[b] or 999
    if orderA ~= orderB then
        return orderA < orderB
    end
    return a < b
end)

-- Urutkan upgrade di dalam setiap StatName: Board natural, lalu Order
for statName, upgrades in pairs(statGroups) do
    table.sort(upgrades, function(a, b)
        local boardA = a.BoardID
        local boardB = b.BoardID
        if boardA ~= boardB then
            return naturalBoardCompare(boardA, boardB)
        end
        local orderA = a.Data.Order or 999
        local orderB = b.Data.Order or 999
        return orderA < orderB
    end)
end

-- Buat UI: per StatName, buat group berisi 2 toggle
for _, statName in ipairs(sortedStatNames) do
    local upgrades = statGroups[statName]
    local countInStat = 0
    local upgradeGroup = nil

    for _, entry in ipairs(upgrades) do
        local upgradeName = entry.Name
        local upgradeData = entry.Data

        -- Buat group baru setiap 2 toggle
        if countInStat % 2 == 0 then
            upgradeGroup = MainTabs:Group({})  -- group tanpa judul
            FM_Add(statName,upgradeGroup)
        end

        local toggle = upgradeGroup:Toggle({
            Flag = "AutoUpg_" .. upgradeName,
            Image = upgradeData.Image,
            Value = false,
            Callback = function(val)
                if val then
                    StartManagedLoop("AutoUpg_" .. upgradeName, 0.5, function()
                        return true
                    end, function()
                        -- Pastikan data sudah ada
                        local playerData = DataService:get()
                        if not playerData or not playerData.Upgrades then
                            return
                        end

                        local level = playerData.Upgrades[upgradeName] or 0
                        local maxLevel = upgradeData.Max and upgradeData.Max(playerData) or 0
                        if level >= maxLevel then return end

                        local cost = upgradeData.GetCost(level)
                        local currencyAmount = DataService:get(upgradeData.CostPath)

                        if currencyAmount and BigNum.gte(currencyAmount, cost) then
                            pcall(function()
                                BuyUpgradeBridge:Fire(upgradeName)
                            end)
                        end
                    end)
                else
                    StopManagedLoop("AutoUpg_" .. upgradeName)
                end
            end
        })

        -- Update status toggle
        StartStatusLoop("Status_AutoUpg_" .. upgradeName, 1, function()
            local playerData = DataService:get()
            local level = playerData.Upgrades and playerData.Upgrades[upgradeName] or 0
            local maxLevel = upgradeData.Max and upgradeData.Max(playerData) or 0
            local cost = upgradeData.GetCost(level)
            local currencyAmount = DataService:get(upgradeData.CostPath)

            -- Ambil Title
            local plainTitle, richTitle = upgradeData.Title()
            local boostText = GetUpgradeBoostText(upgradeData, level)

            SafeSetTitle(toggle, richTitle)

            local descLines = {}
            table.insert(descLines, "Level: " .. tostring(level) .. "/" .. tostring(maxLevel))
            table.insert(descLines, boostText)

            if currencyAmount and cost then
                local canAfford = BigNum.gte(currencyAmount, cost)
                local color = canAfford and "#00ff00" or "#ff0000"
                biaya = string.format(
                    '<font color="%s">%s / %s</font>',
                    color,
                    BigNum.toSuffix(currencyAmount),BigNum.toSuffix(cost)
                )
                if level < maxLevel then 
                    CostText = ("COST: %* %*"):format(biaya, (RichText.ToRich(StatModule.Stats[statName].Color, string.upper(statName))))
                    table.insert(descLines, CostText)
                end
            end

            SafeSetDesc(toggle, table.concat(descLines, "\n"))
        end)

        countInStat = countInStat + 1
    end
end

-- =====================================================
-- AUTO UPGRADE TREE (1 Toggle, cek currency & requirements)
-- =====================================================
local autoUpgradeTreeToggle = MainTabs:Toggle({
    Title = "Upgrade Tree",
    Flag = "AutoUpgradeTree_Cfg",
    Value = false,
    Callback = function(val)
        if val then
            StartManagedLoop("AutoUpgradeTree", 0.5, function()
                return true
            end, function()
                local playerData = DataService:get()
                local nodes = UpgradeTree.GetAllNodes()

                for nodeID, nodeData in pairs(nodes) do
                    local level = playerData.UpgradeTree[nodeID] or 0
                    local maxLevel = nodeData.Max and nodeData.Max(playerData) or 1
                    if level >= maxLevel then
                        continue
                    end

                    -- Cek UpgradeRequirements
                    local reqOk = true
                    if nodeData.UpgradeRequirements then
                        for _, reqID in ipairs(nodeData.UpgradeRequirements) do
                            if (playerData.UpgradeTree[reqID] or 0) <= 0 then
                                reqOk = false
                                break
                            end
                        end
                    end
                    if not reqOk then
                        continue
                    end

                    -- Cek CustomReq
                    if nodeData.CustomReq then
                        local customOk = nodeData.CustomReq(playerData)
                        if not customOk then
                            continue
                        end
                    end

                    -- Cek currency
                    local currency = nodeData.Currency
                    local currencyAmount = DataService:get({ "PlayerData", currency })
                    local price = nodeData.Price(level)

                    if currencyAmount and BigNum.gte(currencyAmount, price) then
                        -- Beli 1 node, lalu break untuk menunggu update data
                        pcall(function()
                            PurchaseUpgradeNodeBridge:Fire(nodeID)
                        end)
                        break
                    end
                end
            end)
        else
            StopManagedLoop("AutoUpgradeTree")
        end
    end
})
FM_Add("Matter",autoUpgradeTreeToggle)
-- Status deskripsi toggle
StartStatusLoop("Status_AutoUpgradeTree", 1, function()
    if not autoUpgradeTreeToggle then return end

    local playerData = DataService:get()
    local affordableCount = 0
    local totalNodes = 0

    for nodeID, nodeData in pairs(UpgradeTree.GetAllNodes()) do
        totalNodes = totalNodes + 1
        local level = playerData.UpgradeTree[nodeID] or 0
        local maxLevel = nodeData.Max and nodeData.Max(playerData) or 1
        if level < maxLevel then
            local currencyAmount = DataService:get({ "PlayerData", nodeData.Currency })
            local price = nodeData.Price(level)
            if currencyAmount and BigNum.gte(currencyAmount, price) then
                affordableCount = affordableCount + 1
            end
        end
    end
    SafeSetDesc(autoUpgradeTreeToggle, string.format(
        "Affordable: %d/%d nodes",
        affordableCount,
        totalNodes
    ))
end)

-- =====================================================
-- AUTO SKILL TREE (1 Toggle, cek gems & requirements)
-- =====================================================
-- Ambil semua skill dari folder List.SkillTree
local allSkills = {}
for _, child in ipairs(ReplicatedStorage.List.SkillTree:GetChildren()) do
    if child:IsA("ModuleScript") then
        local skillID = child.Name
        local skillData = require(child)
        table.insert(allSkills, {
            ID = skillID,
            Data = skillData
        })
    end
end

-- Urutkan berdasarkan nama skill
table.sort(allSkills, function(a, b)
    return a.Data.Name < b.Data.Name
end)

-- Toggle Auto Skill
local autoSkillToggle = MainTabs:Toggle({
    Title = "Upgrade Skills",
    Flag = "AutoSkills_Cfg",
    Value = false,
    Callback = function(val)
        if val then
            StartManagedLoop("AutoSkills", 0.5, function()
                return true
            end, function()
                local playerData = DataService:get()
                local gems = playerData.PlayerData and playerData.PlayerData.Gems
                if not gems then return end

                for _, skill in ipairs(allSkills) do
                    local skillID = skill.ID
                    local skillData = skill.Data

                    local current = playerData.SkillTree and playerData.SkillTree[skillID]
                    if not current or not current.Unlocked then
                        continue
                    end

                    local level = current.Level or 0
                    local maxLevel = skillData.Max
                    if level >= maxLevel then
                        continue
                    end

                    -- Cek Requirements jika ada
                    local reqOk = true
                    if skillData.Requirements then
                        for _, req in ipairs(skillData.Requirements) do
                            local val = DataService:get(req.Path)
                            if not Framework.CompareValue(val, req.Value) then
                                reqOk = false
                                break
                            end
                        end
                    end
                    if not reqOk then
                        continue
                    end

                    -- Cek harga
                    local cost = skillData.Cost(level)
                    if BigNum.gte(gems, cost) then
                        pcall(function()
                            UpgradeSkillBridge:Fire(skillID)
                        end)
                        break -- beli satu skill per loop, tunggu update
                    end
                end
            end)
        else
            StopManagedLoop("AutoSkills")
        end
    end
})
FM_Add("Gems",autoSkillToggle)

-- Status deskripsi toggle
StartStatusLoop("Status_AutoSkills", 1, function()
    if not autoSkillToggle then return end

    local playerData = DataService:get()
    local lines = {}

    for _, skill in ipairs(allSkills) do
        local current = playerData.SkillTree and playerData.SkillTree[skill.ID]
        if current and current.Unlocked then
            local level = current.Level or 0
            local maxLevel = skill.Data.Max

            -- Hitung boost
            local boostText = ""
            if skill.Data.Boost then
                local boost = skill.Data.Boost(level)
                if skill.Data.BoostPrefix then
                    boostText = skill.Data.BoostPrefix .. BigNum.toSuffix(boost)
                else
                    boostText = BigNum.toSuffix(boost)
                end
            end

            -- Format status
            local status
            if level >= maxLevel then
                status = "MAX"
            else
                status = string.format("%d/%d", level, maxLevel)
            end

            -- Tambahkan ke deskripsi
            table.insert(lines, string.format(
                "%s %s | Boost: %s",
                skill.Data.Name,status,
                boostText))
        end
    end
    SafeSetDesc(autoSkillToggle, table.concat(lines, "\n\n"))
end)
SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings-2" })
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
FM_OnChange("Automation")
Window:SelectTab(MainTabs.Index)

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
