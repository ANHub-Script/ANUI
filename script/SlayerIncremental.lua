if game.PlaceId ~= 122821966131621 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Slayer Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local character = LocalPlayer.Character
local rootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
humanoid.WalkSpeed = 100  -- nilai default biasanya 16

local FolderPath = "ANUI/SlayerIncremental"
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local LastConfigFile = FolderPath .. "/LastConfig.txt"
local IsPremium = false
local ValidKeys = {"ANHUB-2025"}
local Config = {}
local ConfigName = "ANConfig"
local IsLoadingConfig = false
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
    Title = "AN Hub - Slayer Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "SlayerIncremental",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Slayer Incremental" }),
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

-- =====================================================
-- IMPORT MODULE
-- =====================================================
local UpgradeMod = require(ReplicatedStorage.Modules.UpgradeMod)
local SkillTreeMod = require(ReplicatedStorage.Modules.SkillTreeMod)
local UpgradeTreeMod = require(ReplicatedStorage.Modules.UpgradeTreeMod)
local GeneratorMod = require(ReplicatedStorage.Modules.GeneratorMod)
local GameHandler = require(ReplicatedStorage.Modules.GameHandler)
local ClassMod = require(ReplicatedStorage.Modules.ClassMod)
local Milestones = require(ReplicatedStorage.Modules.Milestones)
local Boosts = require(ReplicatedStorage.Modules.Boosts)
local Short = require(ReplicatedStorage.Modules.Short)
local RichText = require(ReplicatedStorage.RichText)
local DeltaNum = require(ReplicatedStorage.DeltaNum)
local PlayerFolder = LocalPlayer:WaitForChild("PlayerFolder")
local RuneFolder = PlayerFolder:WaitForChild("RuneFolder")
local ChallengeFolder = PlayerFolder:WaitForChild("ChallengeFolder")
local OreFolder = PlayerFolder:WaitForChild("OreFolder")
local UpgradeFolder = PlayerFolder:WaitForChild("UpgradeFolder")
local DataFolder = PlayerFolder:WaitForChild("DataFolder")
local BuyUpgradeRemote = ReplicatedStorage.Events.BuyUpgrade
local BuyTreeUpgradeRemote = ReplicatedStorage.Events.BuyTreeUpgrade
local ResetRemote = ReplicatedStorage.Events.Reset
local BuySkillTreeUpgRemote = ReplicatedStorage.Events.BuySkillTreeUpg
-- === AUTO COLLECT SETUP ===
local CollectionRemotes = ReplicatedStorage.CollectionRemotes
local CollectItemRemote = CollectionRemotes.CollectItem
local ClientCollectibles = workspace:FindFirstChild("ClientCollectibles")
local autoMiningTargets = PlayerFolder:WaitForChild("AutoMiningOreTargets", 10)
local dataFolder = PlayerFolder:WaitForChild("DataFolder", 10)

local autoMiningToggled = DataFolder:WaitForChild("AutoMiningToggled", 10)
local autoOreMining = DataFolder:WaitForChild("AutoOreMining", 10)
local oreMiningBundle = DataFolder:WaitForChild("OreMiningBundle", 10)
local MiningConfig = require(ReplicatedStorage.Modules.MiningConfig)

if not CollectItemRemote then
    warn("CollectItem remote tidak ditemukan – Auto Collect tidak bisa aktif.")
end
local MainSection = Window:Section({
    Title = "Main Feature",
    Opened = true
})
-- [[ MAIN TAB ]] --
BoardUpgrades = MainSection:Tab({
    Title = "Board Upgrades",
    SidebarProfile = false
})
Options = {}
-- Categories = {}
UpgradeType = {
    "Power",
    "Essence",
    "Damage",
    "RuneBulk",
    "RuneLuck",
    "RuneClone",
    "PlayerXp",
    "PlrXp",
    "Level",
    "GoldenPoints",
    "GoldGain",
    "GoldChance",
    "Magma",
    "Lava",
    "PlasmaPoints",
    "SpiritOrbs",
    "AuraLuck",
    "Snowflakes",
    "Ice",
    "OreDamage",
    "OreRespawn",
    "OreGain",
    "Shards",
    "ShardGain",
    "ShardChance",
    "Cash",
    "CRuneBulk",
    "CRuneLuck",
    "CRuneClone",
    "AntiMatter",
    "Credits",
    "FishingCredits",
    "FishLuck",
    "Chi",
    "Mana"
}
DungeonRankType = {"F-","F","F+","E-","E","E+","D-","D","D+","C-","C","C+","B-","B","B+","A-","A","A+","S-","S","S+","SS-","SS","SS+","SSS-","SSS","SSS+"}
UpgradeData = {}
OptionDefault = ""
-- =====================================================
-- AUTOMATION UPGRADES (TOGGLE + AUTO BUY)
-- =====================================================
local AutomationList = {
    { Name = "Overkill", StageReq = 45, CostStr = "5e17", ValueName = "Overkill", IsInt = false },
    { Name = "AutoBuyPower", StageReq = 70, CostStr = "2.5e26", ValueName = "AutoBuyPower", IsInt = false },
    { Name = "AutoEssence", StageReq = 85, BaseCost = "5.25e29", Growth = 1.45, MaxLevel = 100, ValueName = "AutoEssence", IsInt = true },
    { Name = "AutoBuyEssence", StageReq = 125, CostStr = "1e44", ValueName = "AutoBuyEssence", IsInt = false },
    { Name = "AutoBuyGoldenPoints", StageReq = 145, CostStr = "1.5e52", ValueName = "AutoBuyGoldenPoints", IsInt = false },
    { Name = "AutoGainLava", StageReq = 220, CostStr = "2.5e80", ValueName = "AutoGainLava", IsInt = false },
    { Name = "AutoBuyMagma", StageReq = 250, CostStr = "5e90", ValueName = "AutoBuyMagma", IsInt = false },
    { Name = "AutoBuyLava", StageReq = 290, CostStr = "1e105", ValueName = "AutoBuyLava", IsInt = false },
    { Name = "AutoSnow", StageReq = 295, BaseCost = "1e108", Growth = 3, MaxLevel = 200, ValueName = "AutoSnow", IsInt = true },
    { Name = "AutoBuyPlasma", StageReq = 410, CostStr = "7.5e151", ValueName = "AutoBuyPlasma", IsInt = false },
    { Name = "AutoBuySnowflakes", StageReq = 475, CostStr = "1e170", ValueName = "AutoBuySnowflakes", IsInt = false },
    { Name = "AutoBuyMagmaTree", StageReq = 565, CostStr = "1e203", ValueName = "AutoBuyMagmaTree", IsInt = false },
    { Name = "AutoBuyCash", StageReq = 625, CostStr = "7.5e226", ValueName = "AutoBuyCash", IsInt = false },
    { Name = "AutoGainIce", StageReq = 675, CostStr = "2.5e246", ValueName = "AutoGainIce", IsInt = false },
    { Name = "AutoBuyIce", StageReq = 735, CostStr = "1.25e270", ValueName = "AutoBuyIce", IsInt = false },
    { Name = "OverkillEvo", StageReq = 835, CostStr = "1e306", ValueName = "OverkillEvo", IsInt = false },
}

-- Tambahkan kategori Automation ke Options dan Categories
table.insert(Options, { Title = "Automation" })
Categories["Automation"] = {}
local automationToggles = {}
local autoGroup = nil
local autoCount = 0
local function canBuyTreeNode(treeName, nodeName)
    local upgradeDef = UpgradeTreeMod.GetUpgrade(treeName, nodeName)
    if not upgradeDef then return false end

    local levelValue = UpgradeFolder:FindFirstChild(treeName .. nodeName)
    local currentLevel = levelValue and levelValue.Value or 0
    if currentLevel >= upgradeDef.Cap then return false end

    local classVal = DataFolder.Class.Value
    local dungeonRankVal = DataFolder.DungeonRank.Value

    -- Syarat khusus
    if upgradeDef.PreviousUpgReq == "Class" and classVal < 9 then return false end
    if upgradeDef.PreviousUpgReq == "ClassNext" and classVal < 10 then return false end
    if upgradeDef.PreviousUpgReq == "DungeonRank" and dungeonRankVal < 6 then return false end
    if upgradeDef.PreviousUpgReq == "ClassLate" and classVal < 19 then return false end

    -- Syarat upgrade sebelumnya
    if upgradeDef.PreviousUpgReq and upgradeDef.PreviousUpgReq ~= "None"
        and upgradeDef.PreviousUpgReq ~= "Class"
        and upgradeDef.PreviousUpgReq ~= "ClassNext"
        and upgradeDef.PreviousUpgReq ~= "DungeonRank"
        and upgradeDef.PreviousUpgReq ~= "ClassLate" then
        local preReq = UpgradeFolder:FindFirstChild(treeName .. upgradeDef.PreviousUpgReq)
        if not preReq or preReq.Value < 1 then return false end
    end

    -- Biaya
    local treeInfo = UpgradeTreeMod.GetUpgTypeInfo(treeName)
    if not treeInfo then return false end
    local currencyAmount = DataFolder:FindFirstChild(treeInfo.StatReq)
    if not currencyAmount then return false end

    local cost = upgradeDef.Cost(currentLevel)
    return DeltaNum.new(currencyAmount.Value) >= cost
end

-- Fungsi untuk membeli semua node yang memenuhi syarat di semua tree
local function autoBuyAllTrees()
    local trees = workspace:WaitForChild("UpgradeTree")
    for _, tree in ipairs(trees:GetChildren()) do
        local treeName = tree.Name
        for _, node in ipairs(tree:GetChildren()) do
            local nodeName = node.Name
            if canBuyTreeNode(treeName, nodeName) then
                BuyTreeUpgradeRemote:FireServer(treeName, nodeName)
            end
        end
    end
end

local BoardSection = BoardUpgrades:Section({
    Title = "Magma Tree Section",
})

local SkillTreeSection = BoardUpgrades:Section({
    Title = "Aura Tree Section",
})


-- Pastikan ContentFrame bisa diakses (dari SkillTree GUI)
local SkillTreeGui = LocalPlayer.PlayerGui:WaitForChild("SkillTree", 10)  -- sesuaikan nama
local UpgradeTreeFrame = SkillTreeGui and SkillTreeGui:WaitForChild("UpgradeTreeFrame", 5)
local ContentFrame = UpgradeTreeFrame:WaitForChild("ContentFrame")
-- Helper untuk cek apakah sebuah upgrade di Skill Tree bisa dibeli (berdasarkan nama upgrade)
local function canBuySkillTreeUpgrade(upgradeName)
    local upgradeValue = UpgradeFolder:FindFirstChild(upgradeName)
    if not upgradeValue then return false end

    local displayData = SkillTreeMod.GetDisplayData(UpgradeFolder, DataFolder, upgradeName)
    if not displayData then return false end

    -- Cek cap
    if upgradeValue.Value >= displayData.Cap then return false end

    -- Cek prasyarat (PreviousUpgReq)
    if displayData.PreviousUpgReq then
        local prevValue = UpgradeFolder:FindFirstChild(displayData.PreviousUpgReq)
        if not prevValue or prevValue.Value < 1 then return false end
    end

    -- Cek biaya
    local currencyAmount = DataFolder:FindFirstChild(displayData.StatReq)
    if not currencyAmount then return false end
    local amount = DeltaNum.new(currencyAmount.Value)
    local cost = DeltaNum.new(displayData.Cost)   -- Cost sudah dalam bentuk angka/Deltanum dari GetDisplayData
    return amount >= cost
end

-- Fungsi untuk membeli satu upgrade yang tersedia (yang paling pertama)
local function autoBuySkillTree()
    for _, button in ipairs(ContentFrame:GetChildren()) do
        if button:IsA("ImageButton") and canBuySkillTreeUpgrade(button.Name) then
            BuySkillTreeUpgRemote:FireServer(button)
            break  -- beli satu per satu
        end
    end
end
-- Helper untuk memformat boost sesuai displayType
local function formatBoost(boost, displayType)
    if GameHandler and GameHandler.types and GameHandler.types[displayType] then
        return GameHandler.types[displayType](boost)
    end
    -- fallback jika GameHandler.types tidak tersedia
    if displayType == "bool" then
        return boost == 1 and "Unlocked" or "Locked"
    elseif displayType == "+" then
        return "+" .. tostring(boost)
    elseif displayType == "-" then
        return "-" .. tostring(boost)
    else
        return "x" .. tostring(boost)
    end
end
local function getSkillTreeStatusLines()
    local lines = {}
    if not ContentFrame then return lines end
    local upgradeFolder = PlayerFolder:WaitForChild("UpgradeFolder")
    local dataFolder = PlayerFolder:WaitForChild("DataFolder")
    for _, button in ipairs(ContentFrame:GetChildren()) do
        if button:IsA("ImageButton") then
            local name = button.Name
            local displayData = SkillTreeMod.GetDisplayData(upgradeFolder, dataFolder, name)
            if not displayData then continue end
            local levelVal = upgradeFolder:FindFirstChild(name)
            local level = levelVal and levelVal.Value or 0
            local cap = displayData.Cap
            local info = string.format("%s%s(%s/%s)",displayData.InfoText,button.Icon.Image,level,cap)
            local costStr = ""
            local status = ""
            local boostStr = ""

            -- Hitung boost hanya jika level > 0 (sudah unlocked/max)
            if level > 0 and displayData.Boost ~= nil then
                local displayType = displayData.DisplayType or "x"
                boostStr = GameHandler.Format(displayData.Boost, displayType)
            end
            costStr = string.format("%s%s:%s",UpgradeTreeFrame[string.sub(displayData.StatReq, 1, -2).."Main"].Icon.Image,displayData.CostText,DeltaNum.new(displayData.Cost):shortSuffix())

            if level >= cap then
                status = "✅"
                costStr = "Maxed"
            elseif level > 0 then
                status = "🔓"
            else
                local prevReq = displayData.PreviousUpgReq
                if prevReq then
                    local prevVal = upgradeFolder:FindFirstChild(prevReq)
                    if prevVal and prevVal.Value >= 1 then
                        status = "🔒"
                    else
                        -- ⛔ Locked, jangan ditampilkan
                        continue
                    end
                else
                    status = "🔒"
                end
            end

            -- Susun baris
            local lineParts = {}
            if info ~= "" then table.insert(lineParts, info) end
            if boostStr ~= "" then table.insert(lineParts, "Boost: " .. boostStr) end
            if level < cap then
                table.insert(lineParts, costStr)
            else
                table.insert(lineParts, costStr) -- "Maxed"
            end
            table.insert(lines, status .. table.concat(lineParts, " | "))
        end
    end
    return lines
end
if ContentFrame then
    local autoSkillToggle = SkillTreeSection:Toggle({
        Title = "Auto Skill Tree",
        Flag = "Automation_AutoSkillTree",
        Callback = function(val)
            if val then
                StartManagedLoop("AutoAutomation_SkillTree", 0.5, function()
                    return true
                end, function()
                    autoBuySkillTree()
                end)
            else
                StopManagedLoop("AutoAutomation_SkillTree")
            end
        end
    })
    FM_Add("Automation", autoSkillToggle)

    automationToggles["AutoSkillTree"] = autoSkillToggle

    -- Status loop untuk menampilkan info
    StartStatusLoop("Status_AutoSkillTree", 2, function()
        if automationToggles["AutoSkillTree"] then
            local toggle = automationToggles["AutoSkillTree"]
            local desc = ""
            local ok, err = pcall(function()
                local lines = getSkillTreeStatusLines()
                local summary = ""
                desc = summary .. table.concat(lines, "\n")
            end)
            if not ok then
                desc = "Error: " .. tostring(err)
            end
            SafeSetTitle(toggle, "Auto Skill Tree")
            SafeSetDesc(toggle, desc)
        end
    end)
else
    warn("Auto Skill Tree: ContentFrame tidak ditemukan")
end
-- Tambahkan toggle ke grup Automation (grup terakhir yang masih aktif)
-- Pastikan autoGroup masih merujuk ke grup terakhir yang dibuat
local autoTreeToggle = BoardSection:Toggle({
    Title = "Auto Upgrade Tree",
    Flag = "Automation_AutoTree",
    Callback = function(val)
        if val then
            StartManagedLoop("AutoAutomation_Tree", 2, function()
                return true
            end, function()
                autoBuyAllTrees()
            end)
        else
            StopManagedLoop("AutoAutomation_Tree")
        end
    end
})
FM_Add("Automation", BoardSection)
FM_Add("Automation", SkillTreeSection)
FM_Add("Automation", autoTreeToggle)
-- Simpan referensi untuk update status
automationToggles["AutoTree"] = autoTreeToggle
-- =====================================================
-- AUTO CHALLENGES (RemoteFunction via ChallengeAction)
-- =====================================================
local ChallengeDefinitions = require(ReplicatedStorage.ChallengeDefinitions)
local ChallengeModule = require(ReplicatedStorage.ChallengeModule)
local ChallengeActionRemote = ReplicatedStorage.Events:WaitForChild("ChallengeAction")

if not ChallengeActionRemote then
    warn("Auto Challenges: ChallengeAction remote tidak ditemukan!")
else
    local lastState = nil

    local function refreshState()
        local ok, result = pcall(function()
            return ChallengeActionRemote:InvokeServer("State")
        end)
        if ok and result and result.State then
            lastState = result.State
            return lastState
        end
        return nil
    end

    local function getState()
        if not lastState then
            return refreshState()
        end
        return lastState
    end

    local function getNextChallengeToStart(state)
        for _, ch in ipairs(state.Challenges) do
            if ch.Unlocked and not ch.Completed and not ch.Active and not ch.Paused and ch.CanStart then
                return ch
            end
        end
        return nil
    end

    local function getActiveChallenge(state)
        for _, ch in ipairs(state.Challenges) do
            if ch.Active then
                return ch
            end
        end
        return nil
    end

    local autoChallengeToggle = BoardUpgrades:Toggle({
        Title = "Auto Challenges",
        Flag = "Automation_AutoChallenge",
        Callback = function(val)
            if val then
                StartManagedLoop("AutoAutomation_Challenges", 2, function()
                    return true
                end, function()
                    local ok, err = pcall(function()
                        local state = getState()
                        if not state then return end

                        -- 1. Selesaikan challenge aktif yang sudah memenuhi goal
                        for _, ch in ipairs(state.Challenges) do
                            if ch.Active and ch.GoalComplete then
                                ChallengeActionRemote:InvokeServer("Complete", ch.Id)
                                refreshState()
                                return
                            end
                        end

                        -- 2. Jika tidak ada yang aktif, cek paused
                        if not state.ActiveChallenge then
                            for _, ch in ipairs(state.Challenges) do
                                if ch.Paused and ch.Visible then
                                    ChallengeActionRemote:InvokeServer("Start", ch.Id)
                                    refreshState()
                                    return
                                end
                            end

                            -- 3. Mulai baru
                            for _, ch in ipairs(state.Challenges) do
                                if ch.Visible and not ch.Completed and not ch.Active and not ch.Paused and ch.CanStart then
                                    ChallengeActionRemote:InvokeServer("Start", ch.Id)
                                    refreshState()
                                    return
                                end
                            end
                        end
                    end)
                    if not ok then
                        warn("AutoChallenge error: " .. tostring(err))
                    end
                end)
            else
                StopManagedLoop("AutoAutomation_Challenges")
                -- Pause challenge aktif saat toggle dimatikan
                local state = getState()
                if state and state.Challenges then
                    -- Cari challenge yang benar-benar aktif
                    local activeId = nil
                    for _, ch in ipairs(state.Challenges) do
                        if ch.Active then
                            activeId = ch.Id
                            break
                        end
                    end
                    if activeId then
                        local ok, result = pcall(function()
                            return ChallengeActionRemote:InvokeServer("Pause", activeId)
                        end)
                        if ok then
                            refreshState()
                        else
                            warn("Gagal pause challenge: " .. tostring(result))
                        end
                    end
                end
            end
        end
    })
    
    FM_Add("Automation", autoChallengeToggle)

    automationToggles["AutoChallenge"] = autoChallengeToggle

    -- Helper: ambil debuff langsung dari ChallengeDefinitions (sumber yang sama dengan client)
local function getDebuffText(challengeId)
    local def = ChallengeDefinitions.GetChallenge(challengeId)
    if not def then return nil end
    local lines = ChallengeDefinitions.GetDebuffDisplayLines(def)
    if lines and #lines > 0 then
        return table.concat(lines, "\n")
    end
    return nil
end

StartStatusLoop("Status_AutoChallenge", 2, function()
    if automationToggles["AutoChallenge"] then
        local toggle = automationToggles["AutoChallenge"]
        local desc = ""
        local ok, err = pcall(function()
            local state = refreshState()
            if not state then
                desc = "Waiting for data..."
                return
            end

            local completed = state.CompletedChallenges or 0
            local total = #state.Challenges

            local descLines = {}
            table.insert(descLines, string.format("Completed: %d/%d", completed, total))

            -- --- Challenge Aktif ---
            local activeCh
            for _, ch in ipairs(state.Challenges) do
                if ch.Active then
                    activeCh = ch
                    break
                end
            end
            local activeTitle = activeCh and (activeCh.Title or activeCh.Id) or "None"
            table.insert(descLines, "Active: " .. activeTitle)

            if activeCh then
                local taskText = ChallengeDefinitions.GetTaskText(activeCh)
                local rewardText = ChallengeDefinitions.GetRewardText(activeCh)
                local debuffText = getDebuffText(activeCh.Id)  -- ambil dari definisi

                table.insert(descLines, "Task: " .. (taskText ~= "" and taskText or "-"))
                table.insert(descLines, (rewardText ~= "" and rewardText or "-"))
                if debuffText then
                    table.insert(descLines,debuffText)
                end
                table.insert(descLines, activeCh.GoalComplete and "Status: Ready to Complete" or "Status: In Progress")
            end

            -- --- Challenge Paused atau Next ---
            local pausedCh
            for _, ch in ipairs(state.Challenges) do
                if ch.Paused and ch.Visible then
                    pausedCh = ch
                    break
                end
            end
            if pausedCh then
                local taskText = ChallengeDefinitions.GetTaskText(pausedCh)
                local rewardText = ChallengeDefinitions.GetRewardText(pausedCh)
                local debuffText = getDebuffText(pausedCh.Id)

                table.insert(descLines, "--- Paused ---")
                table.insert(descLines, pausedCh.Title or pausedCh.Id)
                table.insert(descLines, "Task: " .. (taskText ~= "" and taskText or "-"))
                table.insert(descLines, (rewardText ~= "" and rewardText or "-"))
                if debuffText then
                    table.insert(descLines, debuffText)
                end
                table.insert(descLines, "Status: Paused")
            else
                local nextCh
                for _, ch in ipairs(state.Challenges) do
                    if ch.Visible and not ch.Completed and not ch.Active and not ch.Paused and ch.CanStart then
                        nextCh = ch
                        break
                    end
                end
                if nextCh then
                    local taskText = ChallengeDefinitions.GetTaskText(nextCh)
                    local rewardText = ChallengeDefinitions.GetRewardText(nextCh)
                    local debuffText = getDebuffText(nextCh.Id)

                    table.insert(descLines, "--- Next ---")
                    table.insert(descLines, nextCh.Title or nextCh.Id)
                    table.insert(descLines, "Task: " .. (taskText ~= "" and taskText or "-"))
                    table.insert(descLines, (rewardText ~= "" and rewardText or "-"))
                    if debuffText then
                        table.insert(descLines,debuffText)
                    end
                    table.insert(descLines, "Status: Ready to Start")
                end
            end

            desc = table.concat(descLines, "\n")
        end)
        if not ok then
            desc = "Error: " .. tostring(err)
        end
        SafeSetTitle(toggle, "Auto Challenges")
        SafeSetDesc(toggle, desc)
    end
end)
end
-- =====================================================
-- AUTO CRIT (Critical Hit Auto‑Claim)
-- =====================================================
local CritOpportunityEvent = ReplicatedStorage.Events:FindFirstChild("CritOpportunity")
local ClaimCritRemote = ReplicatedStorage.Events:FindFirstChild("ClaimCrit")

local autoCritActive = false
local critConnection = nil
local critClaimedCount = 0

local function enableAutoCrit()
    if not CritOpportunityEvent or not ClaimCritRemote then return end
    if critConnection then return end  -- sudah tersambung

    critConnection = CritOpportunityEvent.OnClientEvent:Connect(function(critValue, timeout)
        if not autoCritActive then return end
        -- Klaim critical hit secara otomatis
        local ok, result = pcall(function()
            return ClaimCritRemote:InvokeServer(critValue)
        end)
        if ok then
            critClaimedCount = critClaimedCount + 1
        end
    end)
end
AddConnection(enableAutoCrit)
local function disableAutoCrit()
    if critConnection then
        critConnection:Disconnect()
        critConnection = nil
    end
end

-- Buat grup baru untuk toggle ini (biar rapi di bawah Automation lainnya)
local snowGroup = BoardUpgrades:Group({})
local autoCritToggle = snowGroup:Toggle({
    Title = "Auto Crit",
    Flag = "Automation_AutoCrit",
    Callback = function(val)
        autoCritActive = val
        if val then
            enableAutoCrit()
        else
            disableAutoCrit()
        end
    end
})
-- Simpan referensi untuk status loop
automationToggles["AutoCrit"] = autoCritToggle
-- =====================================================
-- AUTO CLAIM SNOW
-- =====================================================
local SnowOpportunityEvent = ReplicatedStorage.Events:FindFirstChild("SnowOpportunity")
local ClaimSnowRemote = ReplicatedStorage.Events:FindFirstChild("ClaimSnow")

    local autoClaimSnowActive = false
    local snowConnection = nil
    local snowClaimedCount = 0
    local lastSnowAmount = nil

    local function enableAutoClaimSnow()
        if snowConnection then return end
        snowConnection = SnowOpportunityEvent.OnClientEvent:Connect(function(id, duration, amount)
            if not autoClaimSnowActive then return end
            -- Claim secepat mungkin
            local ok, result = pcall(function()
                return ClaimSnowRemote:InvokeServer(id)
            end)
            if ok and result then
                snowClaimedCount = snowClaimedCount + 1
                lastSnowAmount = result
            end
        end)
    end
    AddConnection(snowConnection)

    local function disableAutoClaimSnow()
        if snowConnection then
            snowConnection:Disconnect()
            snowConnection = nil
        end
    end

    local autoSnowToggle = snowGroup:Toggle({
        Title = "Auto Claim Snow",
        Flag = "Automation_AutoSnow",
        Callback = function(val)
            autoClaimSnowActive = val
            if val then
                enableAutoClaimSnow()
            else
                disableAutoClaimSnow()
            end
        end
    })

    automationToggles["AutoSnows"] = autoSnowToggle

FM_Add("Automation", snowGroup)
-- =====================================================
-- AUTO GENERATORS (Upgrade semua generator)
-- =====================================================
local GeneratorsFolder = workspace:WaitForChild("Generators")
local GeneratorEvent = ReplicatedStorage.Events:FindFirstChild("Generators")

if GeneratorEvent then
    local autoGeneratorsToggle = BoardUpgrades:Toggle({
        Title = "Auto Generators",
        Flag = "Automation_AutoGenerators",
        Callback = function(val)
            if val then
                StartManagedLoop("AutoAutomation_Generators", 1, function()
                    return true
                end, function()
                    for _, generator in ipairs(GeneratorsFolder:GetChildren()) do
                        local genName = generator.Name
                        -- Hanya proses generator yang memiliki SurfaceGui (Upgrade button)
                        local surfaceGui = generator:FindFirstChild("SurfaceGui")
                        if not surfaceGui then continue end

                        local req = GeneratorMod.GetGeneratorReq(DataFolder, genName)
                        if not req then continue end

                        -- Cek level saat ini (mungkin tidak ada batas level, selalu bisa di-upgrade)
                        local levelValue = DataFolder:FindFirstChild(genName)
                        -- Tidak ada batas, biaya mungkin meningkat (tapi dari kode asli biaya tetap)
                        -- Kita anggap selalu bisa upgrade selama biaya terpenuhi
                        local cost = req.Cost
                        local statReqName = req.StatReq
                        local statValue = DataFolder:FindFirstChild(statReqName)
                        if not statValue then continue end

                        local amount = DeltaNum.new(statValue.Value)
                        local required = type(cost) == "number" and DeltaNum.new(cost) or cost -- DeltaNum

                        if amount >= required then
                            GeneratorEvent:FireServer(genName)
                        end
                    end
                end)
            else
                StopManagedLoop("AutoAutomation_Generators")
            end
        end
    })
    FM_Add("Automation", autoGeneratorsToggle)

    -- Simpan untuk status update
    automationToggles["AutoGenerators"] = autoGeneratorsToggle
end
for _, auto in ipairs(AutomationList) do
    if autoCount % 2 == 0 then
        autoGroup = BoardUpgrades:Group({})
        FM_Add("Automation", autoGroup)
    end

    local toggleKey = "Automation_" .. auto.Name
    local toggle = autoGroup:Toggle({
        Title = auto.Name,  -- akan diperbarui oleh status loop
        Flag = toggleKey,
        Callback = function(val)
            if val then
                StartManagedLoop("AutoAutomation_" .. auto.Name, 0.5, function()
                    return true
                end, function()
                    -- Cek apakah sudah unlocked
                    local value = DataFolder:FindFirstChild(auto.ValueName)
                    if not value then return end
                    if auto.IsInt then
                        if value.Value >= auto.MaxLevel then return end
                    else
                        if value.Value == true then return end
                    end

                    -- Cek syarat stage
                    if DataFolder.MaxStage.Value < auto.StageReq then return end

                    -- Hitung biaya
                    local cost = nil
                    if auto.IsInt then
                        local level = value.Value
                        cost = DeltaNum.new(auto.BaseCost) * DeltaNum.new(auto.Growth) ^ DeltaNum.new(level)
                    else
                        cost = DeltaNum.new(auto.CostStr)
                    end

                    -- Cek kecukupan Power
                    local powerVal = DataFolder:FindFirstChild("Power")
                    if not powerVal then return end
                    local powerAmount = DeltaNum.new(powerVal.Value)
                    if powerAmount >= cost then
                        -- Kirim pembelian
                        ReplicatedStorage.Events.Automation:FireServer(auto.Name)
                    end
                end)
            else
                StopManagedLoop("AutoAutomation_" .. auto.Name)
            end
        end
    })

    automationToggles[auto.Name] = toggle
    autoCount = autoCount + 1
end
local AutomationScrollingFrame = workspace.Automation.OuterBoard.InnerBoard.SurfaceGui.ScrollingFrame
-- Status loop untuk memperbarui teks automation toggle
StartStatusLoop("Status_AutomationToggles", 1, function()
    for _, auto in ipairs(AutomationList) do
        local toggle = automationToggles[auto.Name]
        if not toggle then continue end

        -- Ambil frame upgrade dari UI client
        local frame = AutomationScrollingFrame:FindFirstChild(auto.Name)
        if not frame then
            -- SafeSetTitle(toggle, auto.Name)
            -- SafeSetDesc(toggle, "Frame not found")
            continue
        end

        -- Ambil label-label yang diisi oleh client (Overkill, AutoBuyPower, dst.)
        local titleLabel = frame:FindFirstChild("Title")
        local boostLabel = frame:FindFirstChild("Boost")
        local costLabel = frame:FindFirstChild("Cost")
        local extraLabel = frame:FindFirstChild("Extra")
        local lockedLabel = frame:FindFirstChild("Locked")

        local title = titleLabel and titleLabel.Text or auto.Name
        local boost = boostLabel and boostLabel.Text or ""
        local cost = costLabel and costLabel.Text or ""
        local extra = extraLabel and extraLabel.Text or ""
        local locked = lockedLabel and lockedLabel.Text or ""

        local value = DataFolder:FindFirstChild(auto.ValueName)
        local level = 0
        local isUnlocked = false
        local maxed = false

        if auto.IsInt then
            if value then
                level = value.Value
                maxed = level >= auto.MaxLevel
                isUnlocked = level > 0  -- sudah memiliki level artinya sudah dibeli
            end
        else
            if value then
                isUnlocked = value.Value == true
                maxed = isUnlocked
            end
        end

        -- Syarat stage
        local stageOk = DataFolder.MaxStage.Value >= auto.StageReq

        -- Hitung biaya berikutnya
        local costStr = "???"
        if not maxed then
            local cost = nil
            if auto.IsInt then
                cost = DeltaNum.new(auto.BaseCost) * DeltaNum.new(auto.Growth) ^ DeltaNum.new(level)
            else
                cost = DeltaNum.new(auto.CostStr)
            end
            costStr = cost:shortSuffix()
        end

        local powerVal = DataFolder:FindFirstChild("Power")
        local powerAmount = powerVal and DeltaNum.new(powerVal.Value) or DeltaNum.new(0)
        SafeSetTitle(toggle, title)

        -- Deskripsi
        local descLines = {}
        -- Status
        if isUnlocked then
            if auto.IsInt then
                table.insert(descLines, boost)
            end
        else
            if not stageOk then
                table.insert(descLines, locked)
            else
                table.insert(descLines, cost)
            end
        end
        table.insert(descLines,extra)
        SafeSetDesc(toggle, table.concat(descLines, "\n"))
    end
    if automationToggles["AutoTree"] then
        local toggle = automationToggles["AutoTree"]
        local trees = workspace:WaitForChild("UpgradeTree")
        local treeLines = {}
        local totalMaxed = 0
        local totalUnlocked = 0
        local totalLocked = 0
        local totalAll = 0

        for _, tree in ipairs(trees:GetChildren()) do
            local treeName = tree.Name
            local treeTotal = 0
            local treeMaxed = 0
            local treeUnlocked = 0
            local treeLocked = 0
            local nodeDescs = {}  -- Simpan deskripsi boost per node yang sudah dibuka

            for _, node in ipairs(tree:GetChildren()) do
                local nodeName = node.Name
                local upgradeDef = UpgradeTreeMod.GetUpgrade(treeName, nodeName)
                if not upgradeDef then continue end

                local levelValue = UpgradeFolder:FindFirstChild(treeName .. nodeName)
                local currentLevel = levelValue and levelValue.Value or 0
                local cap = upgradeDef.Cap

                treeTotal = treeTotal + 1

                if currentLevel >= cap then
                    treeMaxed = treeMaxed + 1
                    -- Node maxed, ambil boost maksimum
                    local boost = upgradeDef.Boost(cap, DataFolder)
                    local infoText = upgradeDef.InfoText or nodeName
                    if upgradeDef.DisplayType == "bool" then
                        table.insert(nodeDescs, infoText .. " [Unlocked]")
                    elseif upgradeDef.DisplayType == "+" then
                        table.insert(nodeDescs, infoText .. " [+" .. DeltaNum(boost):shortSuffix() .. "]")
                    elseif upgradeDef.DisplayType == "-" then
                        table.insert(nodeDescs, infoText .. " [-" .. DeltaNum(boost):shortSuffix() .. "]")
                    else
                        table.insert(nodeDescs, infoText .. " [x" .. DeltaNum(boost):shortSuffix() .. "]")
                    end
                elseif currentLevel > 0 then
                    treeUnlocked = treeUnlocked + 1
                    -- Node unlocked, tampilkan boost saat ini
                    local boost = upgradeDef.Boost(currentLevel, DataFolder)
                    local infoText = upgradeDef.InfoText or nodeName
                    if upgradeDef.DisplayType == "bool" then
                        table.insert(nodeDescs, infoText .. " [Unlocked]")
                    elseif upgradeDef.DisplayType == "+" then
                        table.insert(nodeDescs, infoText .. " [+" .. DeltaNum(boost):shortSuffix() .. "]")
                    elseif upgradeDef.DisplayType == "-" then
                        table.insert(nodeDescs, infoText .. " [-" .. DeltaNum(boost):shortSuffix() .. "]")
                    else
                        table.insert(nodeDescs, infoText .. " [x" .. DeltaNum(boost):shortSuffix() .. "]")
                    end
                else
                    -- Belum dibeli
                    local canUnlock = false
                    if upgradeDef.PreviousUpgReq == "None" then
                        canUnlock = true
                    elseif upgradeDef.PreviousUpgReq == "Class" then
                        canUnlock = DataFolder.Class.Value >= 9
                    elseif upgradeDef.PreviousUpgReq == "ClassNext" then
                        canUnlock = DataFolder.Class.Value >= 10
                    elseif upgradeDef.PreviousUpgReq == "DungeonRank" then
                        canUnlock = DataFolder.DungeonRank.Value >= 6
                    elseif upgradeDef.PreviousUpgReq == "ClassLate" then
                        canUnlock = DataFolder.Class.Value >= 19
                    else
                        local preReq = UpgradeFolder:FindFirstChild(treeName .. upgradeDef.PreviousUpgReq)
                        canUnlock = preReq and preReq.Value >= 1
                    end
                    if canUnlock then
                        treeLocked = treeLocked + 1   -- bisa dibeli tapi belum dibeli
                    else
                        treeLocked = treeLocked + 1   -- masih terkunci oleh prasyarat
                    end
                end
            end

            totalMaxed = totalMaxed + treeMaxed
            totalUnlocked = totalUnlocked + treeUnlocked
            totalLocked = totalLocked + treeLocked
            totalAll = totalAll + treeTotal

            if treeTotal > 0 then
                local line = string.format("%s: %d/%d maxed, %d unlocked",
                    treeName, treeMaxed, treeTotal, treeUnlocked)
                if #nodeDescs > 0 then
                    line = line .. "\n" .. table.concat(nodeDescs, "\n")
                end
                table.insert(treeLines, line)
            end
        end

        SafeSetTitle(toggle, "Auto Upgrade Tree")
        local desc
        if totalAll == 0 then
            desc = "No trees available"
        else
            desc = string.format("Total: %d nodes\nMaxed: %d | Unlocked: %d | Locked: %d\n%s",
                totalAll, totalMaxed, totalUnlocked, totalLocked,
                table.concat(treeLines, "\n"))
        end
        SafeSetDesc(toggle, desc)
    end
        -- Update status Auto Crit
    if automationToggles["AutoCrit"] then
        local toggle = automationToggles["AutoCrit"]
        SafeSetTitle(toggle, "Auto Crit")
        local desc
        if autoCritActive then
            desc = string.format("✅ Active\nCrits claimed: %d", critClaimedCount)
        else
            desc = "❌ Inactive"
        end
        SafeSetDesc(toggle, desc)
    end

        if automationToggles["AutoSnows"] then
            local toggle = automationToggles["AutoSnows"]
            local desc = ""
            if autoClaimSnowActive then
                desc = string.format("✅ Active\nSnow claimed: %d", snowClaimedCount)
                if lastSnowAmount then
                    desc = desc .. "\nLast: +" .. tostring(lastSnowAmount) .. " Snowflakes"
                end
            else
                desc = "❌ Inactive"
            end
            SafeSetDesc(toggle, desc)
        end
    
        -- Update status Auto Generators
    if automationToggles["AutoGenerators"] then
        local toggle = automationToggles["AutoGenerators"]
        local ok, err = pcall(function()
            local lines = {}
            local totalGen = 0
            local affordableCount = 0
            local dummyDataFolder = {
                Class = {
                    Value = 11
                }
            }
            if PlayerFolder.DataFolder.Class.Value >= 11 then
                toggle:Unlock()
                for _, generator in ipairs(GeneratorsFolder:GetChildren()) do
                    local genName = generator.Name
                    local surfaceGui = generator:FindFirstChild("SurfaceGui")
                    if surfaceGui then
                        local line = string.format("%s %s\n%s\n%s\n%s",
                            RichText(surfaceGui.Frame.Title.TextColor3,surfaceGui.Frame.Title.Text,nil,1),
                            RichText(surfaceGui.Frame.Level.TextColor3,surfaceGui.Frame.Level.Text,nil,1),
                            RichText(surfaceGui.Frame.Multi.TextColor3,surfaceGui.Frame.Multi.Text,nil,1),
                            RichText(surfaceGui.Frame.Gain.TextColor3,surfaceGui.Frame.Gain.Text,nil,1),
                            RichText(surfaceGui.Frame.Cost.TextColor3,surfaceGui.Frame.Cost.Text,nil,1)
                            )
                        table.insert(lines, line)
                    end
                end
                SafeSetDesc(toggle, table.concat(lines, "\n"))
            else
                Yuhu = ClassMod.GetClasses(dummyDataFolder, false)
                toggle:Lock(string.format("Need Class %s",RichText(Yuhu.Color, Yuhu.Text, nil, 1)))
                SafeSetDesc(toggle, "No generators available")
            end
            SafeSetTitle(toggle, "Plasma Generators")
        end)
        if not ok then
            SafeSetTitle(toggle, "Auto Generators")
            SafeSetDesc(toggle, "Status error: " .. tostring(err))
        end
    end
end)
-- =====================================================
-- BUAT TOGGLE UNTUK SETIAP UPGRADE
-- =====================================================
local upgradeToggles = {}   -- simpan toggle per key "boardName_upgradeName"
for _, key in ipairs(UpgradeType) do
    for _, board in ipairs(workspace.Upgrades:GetChildren()) do
        local boardName = board.Name  -- misal "EssenceUpgrades"
        local boardInfo = UpgradeMod.GetUpgTypeInfo(boardName)
        if not boardInfo then continue end

        local statReq = boardInfo.StatReq
        if statReq ~= key then continue end

        local name = boardInfo.CostText
        if OptionDefault == "" then OptionDefault = name end
        if Categories[name] then continue end
        Categories[name] = {}

        -- Masukkan ke Options (jika diperlukan)
        table.insert(Options, { Title = name })

        -- Buat entry di UpgradeData untuk board ini (array kosong)
        UpgradeData[boardName] = {}

        -- Loop semua anak di ScrollingFrame untuk mencari ImageLabel
        local scrollingFrame = board:WaitForChild("OuterBoard"):WaitForChild("InnerBoard"):WaitForChild("SurfaceGui"):WaitForChild("ScrollingFrame")
        local currentGroup = nil
        local countInGroup = 0
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("ImageLabel") then
                local data = UpgradeMod.GetDisplayData(UpgradeFolder, boardName, child.Name)
                local currency = data.StatReq
                local displayCategory = name
                if countInGroup % 2 == 0 then
                    currentGroup = BoardUpgrades:Group({})
                    FM_Add(displayCategory, currentGroup)
                end
                local toggleKey = boardName .. "_" .. child.Name
                local toggle = currentGroup:Toggle({
                    Title = data.TitleText,
                    Image = child.ImageLabel.Image,
                    Flag = toggleKey,
                    Callback = function(val)
                        if val then
                            StartManagedLoop("AutoUpg_" .. toggleKey, 0.1, function()
                                return true
                            end,
                            function()
                                local levelValue = UpgradeFolder:FindFirstChild(boardName .. child.Name)
                                if not levelValue then return end
                                local level = levelValue.Value
                                local upgradeDef = UpgradeMod.GetUpgrade(boardName, child.Name)
                                if not upgradeDef then return end
                                local cap = upgradeDef.Cap
                                if level >= cap then return end
                                local currencyAmount = DataFolder:FindFirstChild(currency)
                                if not currencyAmount then return end
                                local amount = DeltaNum.new(currencyAmount.Value)
                                local cost = upgradeDef.Cost(level)
                                if amount >= cost then
                                    BuyUpgradeRemote:FireServer(boardName, child.Name, true)
                                end
                            end)
                        else
                            StopManagedLoop("AutoUpg_" .. toggleKey)
                        end
                        end
                    })
                upgradeToggles[toggleKey] = {
                    Toggle = toggle,
                    Name = child.Name,
                    Board = boardName,
                }
                countInGroup = countInGroup + 1
                table.insert(UpgradeData[boardName], data)



            end
        end
    end
end
-- =====================================================
-- LOOP STATUS UNTUK MEMPERBARUI TEKS TOGGLE
-- =====================================================
StartStatusLoop("Status_UpgradeToggles", 0.5, function()
    for _, toggle in pairs(upgradeToggles) do
        local boardName = toggle.Board
        local upgradeName = toggle.Name
        local upgradeDef = UpgradeMod.GetUpgrade(boardName, upgradeName)
        if not upgradeDef then continue end

        local levelValue = UpgradeFolder:FindFirstChild(boardName .. upgradeName)
        local level = levelValue and levelValue.Value or 0
        local cap = upgradeDef.Cap
        local isMax = level >= cap


        local data = UpgradeMod.GetDisplayData(UpgradeFolder, boardName, upgradeName)
        local currency = data.StatReq
        local currencyValue = DataFolder:FindFirstChild(currency)
        local currencyAmount = currencyValue and DeltaNum.new(currencyValue.Value) or DeltaNum.new(0)
        local cost = upgradeDef.Cost(level)
        local canAfford = currencyAmount >= cost

        -- Judul: Nama upgrade (level/cap)
        local title = data.TitleText
        SafeSetTitle(toggle.Toggle, title)
        -- if data.Requirement then
        --     local folder = PlayerFolder:FindFirstChild(data.Requirement.FolderType)
        --     local stat = folder and folder:FindFirstChild(data.Requirement.StatType)
        --     if not stat or stat.Value < data.Requirement.Amount then
        --         if data.Requirement.StatType == "DungeonRank" then
        --             toggle.Toggle:Lock(string.format("Need Slayer Rank %s - %s",DungeonRankType[data.Requirement.Amount],DungeonRankType[27]),"geist:logo-discord")
        --             toggle.Toggle:SetLockedIcon("geist:logo-discord", 30, Color3.fromRGB(255, 100, 100), 0)
        --         else
        --             toggle.Toggle:Lock(string.format("Need %s >= %s",splitCamelCase(data.Requirement.StatType),data.Requirement.Amount))
        --         end
        --     else
        --         toggle.Toggle:Unlock()
        --     end
        -- else
        --     toggle.Toggle:Unlock()
        -- end
        -- Deskripsi: biaya, boost
        local descLines = {}
        local currentBoost = upgradeDef.Boost(level, upgradeDef)
        local nextBoost = nil
        if not isMax then
            nextBoost = upgradeDef.Boost(level + 1, upgradeDef)
        end
        local boostStr = ""
        local v99 = upgradeDef.InfoText or ""
        local v100 = currentBoost
        local v101 = nextBoost
        local v102 = GameHandler.Format(v100, upgradeDef.DisplayType)
        local v103 = GameHandler.Format(v101, upgradeDef.DisplayType)
        local v104 = v101 == v100 and " " or " > "
        if v103 == "Maxed" then
            -- toggle.Toggle:Disable()
            boostStr = v102 .. (v99 == "" and "" or ("" .. v99 or "")) .. " [Maxed]"
        else
            -- toggle.Toggle:Enable()
            boostStr = v102 .. v104 .. v103 .. (v99 == "" and "" or ("" .. v99 or ""))
        end

        table.insert(descLines, boostStr)

        if not isMax then
            local costStr = cost:shortSuffix()
            local amountStr = currencyAmount:shortSuffix()
            local color = canAfford and "#00ff00" or "#ff0000"
            table.insert(descLines, string.format('<font color="%s">Cost: %s / %s %s</font>', color, amountStr, costStr, currency))
        end

        SafeSetDesc(toggle.Toggle, table.concat(descLines, "\n"))
    end
end)
FM_CategorySelector = BoardUpgrades:Category({
    Default = "Automation",
    Options = Options,
    Callback = FM_OnChange
})
if FM_CategorySelector.ElementFrame then
    FM_CategorySelector.ElementFrame.Parent = BoardUpgrades.UIElements.ContainerFrameCanvas
    FM_CategorySelector.ElementFrame.Position = UDim2.new(0, 0, 0, BoardUpgrades.UIElements.ContainerFrame.Position.Y.Offset)
    local catSize = FM_CategorySelector.ElementFrame.Size.Y.Offset
    BoardUpgrades.UIElements.ContainerFrame.Position = UDim2.new(0, 0, 0, BoardUpgrades.UIElements.ContainerFrame.Position.Y.Offset + catSize)
    BoardUpgrades.UIElements.ContainerFrame.Size = UDim2.new(1, 0, 1, BoardUpgrades.UIElements.ContainerFrame.Size.Y.Offset - catSize)
    local pad = BoardUpgrades.UIElements.ContainerFrame:FindFirstChildOfClass("UIPadding")
    if pad then
        pad.PaddingTop = UDim.new(0, 5)
    end
end
-- Pastikan folder item sudah ada
local ClientCollectibles = workspace:WaitForChild("ClientCollectibles")

local CollectAreas = {
    "Ground",
    "Lava",
    "Tundra",
    "Japanese",
}

AutoCollectTab = MainSection:Tab({
    Title = "Auto Collect",
    SidebarProfile = false
})

local autoCollectGroup = nil
local countInGroup = 0
local autoCollectToggles = {}

local areaSpawnParts = {
    Ground = workspace:WaitForChild("partspart"),
    Lava = workspace:WaitForChild("partspart2"),
    Tundra = workspace:WaitForChild("partspart3"),
    Japanese = workspace:WaitForChild("partspart4"),
}

local function getAreaForPosition(pos)
    for areaName, spawnPart in pairs(areaSpawnParts) do
        if spawnPart then
            local relPos = spawnPart.CFrame:PointToObjectSpace(pos)
            local halfSize = spawnPart.Size / 2
            if math.abs(relPos.X) <= halfSize.X and math.abs(relPos.Z) <= halfSize.Z then
                return areaName
            end
        end
    end
    return nil
end

local TweenService = game:GetService("TweenService")

local function walkToCollectArea(areaName)
    if not rootPart or not humanoid then return end

    local startPos = rootPart.Position

    -- Cari satu item pertama di area yang ditentukan dan jaraknya > 3 stud
    local targetPos = nil
    for _, item in ipairs(ClientCollectibles:GetChildren()) do
        if item:IsA("Model") and item.PrimaryPart then
            pos = item.PrimaryPart.Position
        elseif item:IsA("BasePart") then  -- mencakup MeshPart, Part, dll.
            pos = item.Position
        end
        if pos and getAreaForPosition(pos) == areaName then
            local distance = (pos - startPos).Magnitude
            if distance > 3 then
                targetPos = pos
                break   -- ambil satu item saja per panggilan
            end
        end
    end

    if not targetPos then
        return  -- tidak ada item yang perlu didekati
    end

    -- Titik tujuan (sedikit di atas item agar karakter berdiri di dekatnya)
    local walkPosition = targetPos + Vector3.new(0, 3, 0)

    -- Jika masih agak jauh, perintahkan karakter untuk berjalan
    local distanceToTarget = (walkPosition - rootPart.Position).Magnitude
    if distanceToTarget > 2 then
        humanoid:MoveTo(walkPosition)
    end
end

-- Buat toggle untuk setiap area
for _, areaName in ipairs(CollectAreas) do
    if countInGroup % 2 == 0 then
        autoCollectGroup = AutoCollectTab:Group({})
    end
    local toggle = autoCollectGroup:Toggle({
        Title = "Collect " .. areaName,
        Flag = "AutoCollectTP_" .. areaName,
        Callback = function(val)
            if val then
                StartManagedLoop("AutoCollectTP_" .. areaName, 0.5, function()
                    return true
                end, function()
                    walkToCollectArea(areaName)
                end)
            else
                StopManagedLoop("AutoCollectTP_" .. areaName)
            end
        end
    })
    countInGroup = countInGroup + 1
    autoCollectToggles[areaName] = toggle
end
-- =====================================================
-- 10. SETTINGS TAB
-- =====================================================
local RuneFolder = PlayerFolder:WaitForChild("RuneFolder")
local ChallengeFolder = PlayerFolder:WaitForChild("ChallengeFolder")
local OreFolder = PlayerFolder:WaitForChild("OreFolder")
local autoResetToggles = {}

-- Cooldown lokal (detik) setelah pengiriman reset
local RESET_COOLDOWN = 3
local lastResetSent = {}   -- [gainName] = os.clock()
-- =====================================================
-- AUTO RESET TAB
-- =====================================================
local AutoResetTab = MainSection:Tab({
    Title = "Reset Layers",
    SidebarProfile = false
})


-- =====================================================
-- AUTO CLASS UP (di dalam Auto Reset Tab)
-- =====================================================
local function checkClassUpRequirement()
    local classInfo = ClassMod.GetClassInfo(DataFolder, false) -- info kelas saat ini
    if not classInfo then return false end
    if DataFolder.Class.Value >= ClassMod.GetMaxClass() then return false end -- sudah max
    local statVal = DataFolder:FindFirstChild(classInfo.StatReq)
    if not statVal then return false end
    return DeltaNum.new(statVal.Value) >= classInfo.Req
end

local ClassUI = workspace:WaitForChild("Classes"):WaitForChild("SurfaceGui"):WaitForChild("Frame")
local function getClassUpStatusText()
    local lines = {}
    if not ClassUI then
        return "Class UI not found"
    end

    -- Nama kelas saat ini & berikutnya
    local currentLabel = ClassUI:FindFirstChild("CurrentClass")
    local nextLabel = ClassUI:FindFirstChild("NextClass")
    if currentLabel then
        table.insert(lines, "Current: " .. RichText(currentLabel.TextColor3, currentLabel.Text, nil, 1))
    end

    -- Current Boosts
    local currentFrame = ClassUI:FindFirstChild("Current")
    if currentFrame then
        local boosts = {}
        for _, child in ipairs(currentFrame:GetChildren()) do
            if child:IsA("TextLabel") and child.Visible then
                table.insert(boosts, child.Text)
            end
        end
        if #boosts > 0 then
            table.insert(lines, "Current Boosts: " .. table.concat(boosts, ", "))
        end
    end
    if nextLabel then
        table.insert(lines, "Next: " .. RichText(nextLabel.TextColor3, nextLabel.Text, nil, 1))
    end
    -- Next Boosts
    local nextFrame = ClassUI:FindFirstChild("Next")
    if nextFrame then
        local boosts = {}
        for _, child in ipairs(nextFrame:GetChildren()) do
            if child:IsA("TextLabel") and child.Visible then
                table.insert(boosts, child.Text)
            end
        end
        if #boosts > 0 then
            table.insert(lines, "Next Boosts: " .. table.concat(boosts, ", "))
        end
    end

    -- Requirement & Resets
    local reqLabel = ClassUI:FindFirstChild("Requirement")
    local resetsLabel = ClassUI:FindFirstChild("Resets")
    if reqLabel then
        table.insert(lines, reqLabel.Text)
    end
    if resetsLabel and resetsLabel.Text ~= "" then
        table.insert(lines, "Resets: " .. resetsLabel.Text)
    end
    if DataFolder.Class.Value >= ClassMod.GetMaxClass() then
        table.insert(lines, "✅ Max Class Reached")
    end

    return table.concat(lines, "\n")
end

local autoClassUpToggle = AutoResetTab:Toggle({
    Title = GetIcon(71473052940756) .. "Classes"..GetIcon(71473052940756),
    Flag = "AutoReset_ClassUp",
    Callback = function(val)
        if val then
            StartManagedLoop("AutoReset_ClassUp", 0.5, function()
                return true
            end, function()
                -- Cooldown lokal
                local now = os.clock()
                local last = lastResetSent["ClassUp"] or 0
                if now - last < RESET_COOLDOWN then return end

                if checkClassUpRequirement() then
                    lastResetSent["ClassUp"] = now
                    ReplicatedStorage.Events.Reset:FireServer("ClassUp")
                end
            end)
        else
            StopManagedLoop("AutoReset_ClassUp")
        end
    end
})

-- =====================================================
-- AUTO DUNGEON RANK
-- =====================================================
local SlayerRankGrades = {
    "F-", "F", "F+", "E-", "E", "E+", "D-", "D", "D+", "C-", "C", "C+",
    "B-", "B", "B+", "A-", "A", "A+", "S-", "S", "S+", "SS-", "SS", "SS+",
    "SSS-", "SSS", "SSS+"
}
DungeonRankMainUI = Workspace.DungeonRank.SurfaceGui.DungeonRankMain

local function checkDungeonRankRequirement()
    if DataFolder.DungeonRank.Value >= Milestones.GetMaxDRank() then return false end
    local req = Milestones.GetReqs(DataFolder.DungeonRank.Value)
    if not req then return false end
    local statVal = DataFolder:FindFirstChild(req.StatReq)
    if not statVal then return false end
    return DeltaNum.new(statVal.Value) >= req.Req
end

local function getDungeonRankStatusText()
    local lines = {}
    local currentRank = DataFolder.DungeonRank.Value
    local maxRank = Milestones.GetMaxDRank()
    local grade = SlayerRankGrades[currentRank] or "Unranked"
    DungeonRankCurrent = DungeonRankMainUI.Current

    table.insert(lines, string.format("Rank: %s",grade))
    local req = Milestones.GetReqs(currentRank)
    if not req then
        table.insert(lines, "❌ Requirement data missing")
        return table.concat(lines, "\n")
    end

    -- Requirement
    local reqAmount = req.Req and req.Req:shortSuffix() or "?"
    local reqStat = req.StatReq or "?"
    table.insert(lines, string.format("Next :%s\n%s", DungeonRankCurrent[currentRank].Title.Text,DungeonRankCurrent[currentRank].Requirement.Text))
    table.insert(lines, DungeonRankCurrent[currentRank].Unlocks.Text)
    table.insert(lines, DungeonRankMainUI.ResetInfo.Text)
    return table.concat(lines, "\n")
end

local autoDungeonRankToggle = AutoResetTab:Toggle({
    Title = GetIcon(78095055197133).."Slayer Rank"..GetIcon(78095055197133),
    Flag = "AutoSlayerRank",
    Callback = function(val)
        if val then
            StartManagedLoop("AutoReset_DungeonRank", 0.5, function()
                return true
            end, function()
                local now = os.clock()
                local last = lastResetSent["DungeonRank"] or 0
                if now - last < RESET_COOLDOWN then return end

                -- Cek challenge "StrengthTrial4" (seperti di client)
                if ChallengeFolder.ActiveChallenge.Value == "StrengthTrial4" then return end

                if checkDungeonRankRequirement() then
                    lastResetSent["DungeonRank"] = now
                    ResetRemote:FireServer("DungeonRank")
                end
            end)
        else
            StopManagedLoop("AutoReset_DungeonRank")
        end
    end
})

-- Fungsi bantu: dapatkan teks status untuk ditampilkan di toggle
local function getResetStatusText(gainName)
    local req = GameHandler.GetStatReq(gainName, DataFolder, OreFolder)
    if not req then
        return "Invalid Gain"
    end

    local lines = {}

    -- Ambil teks Requirement dan Info dari UI yang sudah di-set oleh SetDisplays
    local gainObj = workspace.Gains:FindFirstChild(gainName)
    if gainObj then
        local frame = gainObj:FindFirstChild("SurfaceGui") and gainObj.SurfaceGui:FindFirstChild("Frame")
        if frame then
            local reqLabel = frame:FindFirstChild("Requirement")
            local infoLabel = frame:FindFirstChild("Info")
            local GainLabel = frame:FindFirstChild("Gain")
            if reqLabel and reqLabel.Text and reqLabel.Text ~= "" then
                table.insert(lines, reqLabel.Text)
            end
            if infoLabel and infoLabel.Text and infoLabel.Text ~= "" then
                table.insert(lines, infoLabel.Text)
            end
            if GainLabel and GainLabel.Text and GainLabel.Text ~= "" then
                table.insert(lines, GainLabel.Text)
            end
        end
    end

    local meetsReq = false

    -- Cek syarat utama
    if req.Req == "Ores" then
        local totalOres = GameHandler.GetTotalOres(OreFolder) or 0
        meetsReq = totalOres >= req.Amount
    else
        local statVal = DataFolder:FindFirstChild(req.Req)
        if statVal then
            local amount = DeltaNum.new(statVal.Value)
            local required = type(req.Amount) == "number" and DeltaNum.new(req.Amount) or DeltaNum.new(tostring(req.Amount))
            meetsReq = amount >= required
        else
            meetsReq = false
        end
    end

    -- Syarat tambahan untuk Mana (Chi >= 1)
    if gainName == "Mana" then
        local chiVal = DataFolder:FindFirstChild("Chi")
        if chiVal then
            if DeltaNum.new(chiVal.Value) < DeltaNum.new(1) then
                meetsReq = false
            end
        else
            meetsReq = false
        end
    end

    -- -- Hitung gain jika syarat terpenuhi (meniru SetGains)
    -- if meetsReq then
    --     local gainF = req.GainF
    --     local boost = DeltaNum.new(1)   -- default multiplier

    --     if gainName == "Essence" then
    --         boost = Boosts.GetEssenceBoost(UpgradeFolder, DataFolder, RuneFolder)
    --     elseif gainName == "Lava" then
    --         boost = Boosts.GetLavaBoost(UpgradeFolder, DataFolder, RuneFolder)
    --     elseif gainName == "Ice" then
    --         boost = Boosts.GetIceBoost(UpgradeFolder, DataFolder, RuneFolder, ChallengeFolder)
    --     elseif gainName == "Mana" then
    --         boost = Boosts.GetManaBoost(UpgradeFolder, DataFolder, RuneFolder, ChallengeFolder)
    --     elseif gainName == "AntiMatter" then
    --         boost = Boosts.GetAntimatterBoost(UpgradeFolder, DataFolder, RuneFolder, ChallengeFolder)
    --     end

    --     local totalGain = DeltaNum.new(gainF) * boost
    --     table.insert(lines, string.format("Gain: %s %s", totalGain:shortSuffix(), gainName))
    -- else
    --     table.insert(lines, string.format("Gain: 0 %s", gainName))
    -- end

    -- Cooldown lokal (mencegah spam)
    local last = lastResetSent[gainName] or 0
    local remainingCooldown = RESET_COOLDOWN - (os.clock() - last)
    if remainingCooldown > 0 then
        table.insert(lines, string.format("Local CD: %.1fs", remainingCooldown))
    end

    -- Cooldown spesifik Lava
    if gainName == "Lava" then
        local dungeonRank = DataFolder.DungeonRank.Value
        local magma33 = UpgradeFolder:FindFirstChild("MagmaUpgrade33")
        local magma33val = magma33 and magma33.Value or 0
        local baseCooldown = (dungeonRank >= 8 and 25 - magma33val or 100)
        local lastResetVal = DataFolder:FindFirstChild("LastLavaReset")
        local lastReset = lastResetVal and lastResetVal.Value or 0
        local lavaRemaining = baseCooldown - lastReset
        if lavaRemaining > 0 then
            table.insert(lines, string.format("Lava CD: %ds", lavaRemaining))
        end
    end

    return table.concat(lines, "\n")
end
-- Buat toggle untuk setiap Gains yang ada
for _, gainObj in ipairs(workspace.Gains:GetChildren()) do
    local gainName = gainObj.Name   -- "Essence", "Lava", "Ice", "Mana", "AntiMatter"
    local surfaceGui = gainObj:FindFirstChild("SurfaceGui")
    if not surfaceGui then continue end

    local frame = surfaceGui:FindFirstChild("Frame")
    if not frame then continue end

    -- Contoh mengambil IconPlaceholder (jika ada di dalam frame)
    local iconPlaceholder = frame:FindFirstChild("IconPlaceholder")
    local iconImage = iconPlaceholder and iconPlaceholder.Image or ""

    -- Pastikan gain memiliki data syarat yang valid
    local testReq = GameHandler.GetStatReq(gainName, DataFolder, OreFolder)
    if not testReq then continue end
    if autoCount % 2 == 0 then
        autoGroup = AutoResetTab:Group({})
    end

    local toggle = autoGroup:Toggle({
        Title = string.format("%s%s%s", iconImage, gainName, iconImage),  -- bisa disesuaikan
        Flag = "AutoReset_" .. gainName,
        Callback = function(val)
            if val then
                StartManagedLoop("AutoReset_" .. gainName, 0.5, function()
                    return true
                end, function()
                    if not checkResetRequirement(gainName) then return end
                    local now = os.clock()
                    local last = lastResetSent[gainName] or 0
                    if now - last < RESET_COOLDOWN then return end

                    lastResetSent[gainName] = now
                    ReplicatedStorage.Events.Reset:FireServer(gainName)
                end)
            else
                StopManagedLoop("AutoReset_" .. gainName)
            end
        end
    })
    autoCount = autoCount + 1

    autoResetToggles[gainName] = toggle
end

-- Fungsi pengecekan syarat yang digunakan oleh loop
function checkResetRequirement(gainName)
    local req = GameHandler.GetStatReq(gainName, DataFolder, OreFolder)
    if not req then return false end

    if req.Req == "Ores" then
        local totalOres = GameHandler.GetTotalOres(OreFolder)
        return totalOres and totalOres >= req.Amount
    else
        local statVal = DataFolder:FindFirstChild(req.Req)
        if not statVal then return false end
        local amount = DeltaNum.new(statVal.Value)
        local required = type(req.Amount) == "number" and DeltaNum.new(req.Amount) or DeltaNum.new(tostring(req.Amount))
        if amount < required then return false end
    end

    -- Syarat tambahan Mana
    if gainName == "Mana" then
        local chiVal = DataFolder:FindFirstChild("Chi")
        if not chiVal or DeltaNum.new(chiVal.Value) < DeltaNum.new(1) then
            return false
        end
    end

    return true
end
StartStatusLoop("Status_AutoReset", 1, function()
    -- Update semua toggle reset biasa
    for gainName, toggle in pairs(autoResetToggles) do
        SafeSetDesc(toggle, getResetStatusText(gainName))
    end
    -- Update toggle Class Up
    if autoClassUpToggle then
        SafeSetDesc(autoClassUpToggle, getClassUpStatusText())
    end
    -- Update toggle Dungeon Rank (TAMBAHKAN BAGIAN INI)
    -- if autoDungeonRankToggle then
    --     SafeSetTitle(autoDungeonRankToggle, "Auto Slayer Rank")
    --     SafeSetDesc(autoDungeonRankToggle, getDungeonRankStatusText())
    -- end

-- Masukkan ke status loop yang sudah ada (misal Status_AutoReset)
-- Pastikan di dalam StartStatusLoop ada:
if autoDungeonRankToggle then
    SafeSetDesc(autoDungeonRankToggle, getDungeonRankStatusText())
end
end)


-- =====================================================
-- AUTO MINING (BUILT-IN SYSTEM)
-- =====================================================


-- Ambil remote & folder ore
local MiningRemotes = ReplicatedStorage:WaitForChild("MiningRemotes")
local SellOreRemote = MiningRemotes:WaitForChild("SellOre")
local oreFolder = PlayerFolder:WaitForChild("OreFolder")
local BuyPickaxeRemote = MiningRemotes:WaitForChild("BuyPickaxe")
-- [[ MAIN TAB ]] --
CaveTab = MainSection:Tab({
    Title = "Cave World",
    SidebarProfile = false
})
local MiningSection = CaveTab:Section({
    Title = "Auto Mining Ore",
})

-- Config
Config.AutoMiningMaster = false
Config.AutoMiningAutoSelect = true
Config.AutoMiningOres = {}

-- Master toggle
local autoMiningMasterToggle = MiningSection:Toggle({
    Title = "Enable Auto Mining",
    Flag = "AutoMiningMaster",
    Value = false,
    Callback = function(val)
        Config.AutoMiningMaster = val
        if autoMiningToggled then autoMiningToggled.Value = val end
        if autoOreMining then autoOreMining.Value = val end
        if oreMiningBundle then oreMiningBundle.Value = val end
    end
})

-- Toggle auto select best ore (Auto bool)
local autoSelectBool = autoMiningTargets and autoMiningTargets:FindFirstChild("Auto")
Config.AutoMiningAutoSelect = autoSelectBool and autoSelectBool.Value or true

local autoSelectToggle = MiningSection:Toggle({
    Title = "Auto Select Best Ore",
    Flag = "AutoMiningAutoSelect",
    Value = Config.AutoMiningAutoSelect,
    Callback = function(val)
        Config.AutoMiningAutoSelect = val
        if autoSelectBool then autoSelectBool.Value = val end
    end
})

-- Toggle per ore (hanya berlaku saat Auto Select = false)
local miningOreGroup = nil
local miningOreCount = 0

if autoMiningTargets then
    for _, child in ipairs(autoMiningTargets:GetChildren()) do
        if child:IsA("BoolValue") and child.Name ~= "Auto" then
            if miningOreCount % 2 == 0 then
                miningOreGroup = MiningSection:Group({})
            end

            local oreName = child.Name
            Config.AutoMiningOres[oreName] = child.Value

            local toggle = miningOreGroup:Toggle({
                Title = oreName,
                Flag = "AutoMiningOre_" .. oreName,
                Value = child.Value,
                Callback = function(val)
                    Config.AutoMiningOres[oreName] = val
                    child.Value = val
                end
            })
            miningOreCount = miningOreCount + 1
        end
    end
end

-- Status loop
StartStatusLoop("Status_AutoMiningBuiltIn", 1, function()
    if not autoMiningMasterToggle then return end

    local inCave = LocalPlayer:GetAttribute("InCaveZone") == true
    local masterOn = autoMiningToggled and autoMiningToggled.Value or false
    local autoOre = autoOreMining and autoOreMining.Value or false
    local bundle = oreMiningBundle and oreMiningBundle.Value or false
    local autoSelect = autoSelectBool and autoSelectBool.Value or false
    local active = masterOn and (autoOre or bundle) and inCave

    local descLines = {}
    table.insert(descLines, string.format("In Cave: %s", inCave and "✅" or "❌"))
    table.insert(descLines, string.format("Master: %s", masterOn and "✅" or "❌"))
    table.insert(descLines, string.format("Auto Ore Mining: %s", autoOre and "✅" or "❌"))
    table.insert(descLines, string.format("Ore Bundle: %s", bundle and "✅" or "❌"))
    table.insert(descLines, string.format("Auto Select Best: %s", autoSelect and "✅" or "❌"))
    table.insert(descLines, string.format("Active: %s", active and '<font color="#00ff00">YES</font>' or '<font color="#ff5555">NO</font>'))

    SafeSetDesc(autoMiningMasterToggle, table.concat(descLines, "\n"))
end)
-- =====================================================
-- AUTO SELL (Dropler Incremental)
-- =====================================================
local AutoSellSection = CaveTab:Section({
    Title = "Ores & Pickaxe",
})
Config.AutoBuyPickaxe = false

-- Ambil data PickaxeTier & Cash
local pickaxeTierValue = DataFolder:WaitForChild("PickaxeTier")
local cashValue = DataFolder:WaitForChild("Cash")  -- pastikan nama stat cash benar

local autoBuyPickaxeToggle = AutoSellSection:Toggle({
    Title = "Auto Buy Pickaxe",
    Flag = "AutoBuyPickaxe",
    Value = false,
    Callback = function(val)
        Config.AutoBuyPickaxe = val
        if val then
            StartManagedLoop("AutoBuyPickaxe", 1, function()
                return Config.AutoBuyPickaxe
            end, function()
                local tier = pickaxeTierValue and tonumber(pickaxeTierValue.Value) or 0
                local maxTier = MiningConfig.MaxTier and MiningConfig.MaxTier() or 0

                if tier >= maxTier then
                    return -- sudah max
                end

                local nextPickaxe = MiningConfig.GetPickaxe(tier + 1)
                if nextPickaxe and cashValue then
                    local cash = cashValue.Value or 0
                    local price = nextPickaxe.Price

                    if DeltaNum.new(cash) >= DeltaNum.new(price) then
                        BuyPickaxeRemote:FireServer()
                    end
                end
            end)
        else
            StopManagedLoop("AutoBuyPickaxe")
        end
    end
})

-- Status loop untuk Auto Buy Pickaxe
StartStatusLoop("Status_AutoBuyPickaxe", 1, function()
    if not autoBuyPickaxeToggle then return end

    local tier = pickaxeTierValue and tonumber(pickaxeTierValue.Value) or 0
    local maxTier = MiningConfig.MaxTier and MiningConfig.MaxTier() or 0

    local descLines = {}
    table.insert(descLines, string.format("Tier: %d / %d", tier, maxTier))

    if tier >= maxTier then
        table.insert(descLines, '<font color="#ffff00">Max Pickaxe</font>')
    else
        local nextPickaxe = MiningConfig.GetPickaxe(tier + 1)
        if nextPickaxe then
            local cash = cashValue and cashValue.Value or 0
            local price = nextPickaxe.Price
            local canBuy = DeltaNum.new(cash) >= DeltaNum.new(price)
            local color = canBuy and "#00ff00" or "#ff5555"

            table.insert(descLines, string.format("Next: %s", nextPickaxe.DisplayName or "Unknown"))
            table.insert(descLines, string.format("Price: %s", MiningConfig.FormatCash(price)))
            table.insert(descLines, string.format('Cash: <font color="%s">%s</font>', color, MiningConfig.FormatCash(cash)))
            table.insert(descLines, string.format('<font color="%s">%s</font>', color, canBuy and "✅ Can buy" or "❌ Not enough"))
        else
            table.insert(descLines, "No next pickaxe data")
        end
    end

    if Config.AutoBuyPickaxe then
        table.insert(descLines, '<font color="#00ff00">Auto Buy: ON</font>')
    else
        table.insert(descLines, '<font color="#ff5555">Auto Buy: OFF</font>')
    end

    SafeSetDesc(autoBuyPickaxeToggle, table.concat(descLines, "\n"))
end)
local function HasAnyOre()
    for _, oreName in ipairs(MiningConfig.OreOrder) do
        local oreValue = oreFolder:FindFirstChild(oreName)
        if oreValue and tonumber(oreValue.Value) > 0 then
            return true
        end
    end
    return false
end
Config.AutoSellEnabled = false
Config.AutoSellSelectedOres = {}  -- table berisi nama ore yang dipilih

-- Buat daftar ore untuk dropdown
local sellOreValues = {}
for _, oreName in ipairs(MiningConfig.OreOrder) do
    table.insert(sellOreValues, oreName)
end

-- Dropdown multi-select untuk memilih ore
local sellDropdown = AutoSellSection:Dropdown({
    Title = "Select Ores",
    Multi = true,
    Values = sellOreValues,
    AllowNone = true,
    ImageSize = UDim2.fromOffset(20, 20),
    ImagePadding = 6,
    Flag = "AutoSellOres",
    Callback = function(selectedItem)
        if IsLoadingConfig then
            return
        end
        -- Normalisasi: selectedItem bisa string (jika single) atau table (jika multi)
        local normalized = {}
        if selectedItem then
            if typeof(selectedItem) == "table" then
                for _, v in pairs(selectedItem) do
                    normalized[#normalized + 1] = v
                end
            else
                normalized[#normalized + 1] = selectedItem
            end
        end
        Config.AutoSellSelectedOres = normalized
    end
})

-- Toggle utama Auto Sell
local autoSellToggle = AutoSellSection:Toggle({
    Title = "Auto Sell",
    Flag = "AutoSellEnabled",
    Value = false,
    Callback = function(val)
        Config.AutoSellEnabled = val
        if val then
            StartManagedLoop("AutoSell", 2, function()
                return Config.AutoSellEnabled
            end, function()
                local selected = Config.AutoSellSelectedOres or {}

                if #selected == 0 then
                    -- Mode Sell All: hanya kirim jika ada ore
                    if HasAnyOre() then
                        SellOreRemote:FireServer(nil)
                    end
                else
                    -- Mode selected: kirim hanya untuk ore yang jumlahnya > 0
                    for _, oreName in ipairs(selected) do
                        local oreValue = oreFolder:FindFirstChild(oreName)
                        if oreValue and tonumber(oreValue.Value) > 0 then
                            SellOreRemote:FireServer(oreName, 100)
                        end
                    end
                end
            end)
        else
            StopManagedLoop("AutoSell")
        end
    end
})

-- Status loop
StartStatusLoop("Status_AutoSell", 1, function()
    if not autoSellToggle then return end

    local selected = Config.AutoSellSelectedOres or {}
    local descLines = {}

    if Config.AutoSellEnabled then
        table.insert(descLines, '<font color="#00ff00">Auto Sell: ON</font>')
    else
        table.insert(descLines, '<font color="#ff5555">Auto Sell: OFF</font>')
    end

    if #selected == 0 then
        table.insert(descLines, "Selected: All (no specific ore)")
    else
        table.insert(descLines, "Selected: " .. table.concat(selected, ", "))
    end

    -- Tampilkan inventory
    table.insert(descLines, "Inventory:")
    local totalOre = 0
    for _, oreName in ipairs(MiningConfig.OreOrder) do
        local oreValue = oreFolder:FindFirstChild(oreName)
        local count = oreValue and tonumber(oreValue.Value) or 0
        if count > 0 then
            totalOre = totalOre + 1
            table.insert(descLines, string.format("• %s: %s", oreName, DeltaNum.new(count):shortSuffix()))
        end
    end
    if totalOre == 0 then
        table.insert(descLines, "No ores in inventory")
    end

    SafeSetDesc(autoSellToggle, table.concat(descLines, "\n"))
end)

-- =====================================================
-- AUTO MINER RANK (Slayer Incremental)
-- =====================================================
local MinerRanksMod = require(ReplicatedStorage.Modules.MinerRanks)

local function canRankUpMinerRank()
    if not DataFolder or not DataFolder:FindFirstChild("MinerRank") then return false end
    local minerRankVal = DataFolder.MinerRank.Value
    local maxRank = MinerRanksMod.GetMaxMinerRank()
    if minerRankVal >= maxRank then return false end

    local info = MinerRanksMod.GetRankInfo(DataFolder, false)
    if not info then return false end

    local statVal = DataFolder:FindFirstChild(info.StatReq)
    if not statVal then return false end

    return DeltaNum.new(statVal.Value) >= info.Req
end

-- Helper untuk memformat boost seperti client MinerRank
local function getBoostDisplay(rankInfo)
    local boosts = {}
    if not rankInfo then return boosts end

    for statName, boostValue in pairs(rankInfo.Boosts or {}) do
        local val = DeltaNum.new(boostValue)
        if val and val > DeltaNum.new(1) then
            local prefix = (statName == "OreRespawn") and "/" or "x"
            local statRichText = GameHandler.GetTextColor(statName) or statName
            boosts[#boosts + 1] = string.format("%s%s %s", prefix, val:shortSuffix(), statRichText)
        end
    end

    if rankInfo.SpecialText and rankInfo.SpecialText ~= "" then
        boosts[#boosts + 1] = rankInfo.SpecialText
    end
    if rankInfo.GlobalText and rankInfo.GlobalText ~= "" then
        boosts[#boosts + 1] = rankInfo.GlobalText
    end

    return boosts
end

local function getMinerRankStatusText()
    local lines = {}
    local minerRankVal = DataFolder.MinerRank.Value
    local maxRank = MinerRanksMod.GetMaxMinerRank()

    local currentRank = MinerRanksMod.GetRanks(DataFolder, false)
    local nextRank = MinerRanksMod.GetRanks(DataFolder, true)
    if currentRank then
        table.insert(lines, string.format("Current: %s", currentRank.Text))
    end
    if nextRank then
        table.insert(lines, string.format("Next: %s", nextRank.Text))
    end

    if minerRankVal < maxRank then
        local info = MinerRanksMod.GetRankInfo(DataFolder, false)
        if info then
            local cashVal = DataFolder:FindFirstChild(info.StatReq)
            local cashAmount = cashVal and DeltaNum.new(cashVal.Value) or DeltaNum.new(0)
            local can = cashAmount >= info.Req
            local color = can and "#00ff00" or "#ff5555"
            table.insert(lines, string.format(
                'Requirement: <font color="%s">%s</font> / %s %s',
                color,
                cashAmount:shortSuffix(),
                info.Req:shortSuffix(),
                info.StatReq
            ))
            if info.ResetText then
                table.insert(lines, "Resets: " .. info.ResetText)
            end
        end
    else
        table.insert(lines, "✅ Max Miner Rank")
    end

    -- Current boosts (tampilkan seperti UI client)
    local currentInfo = MinerRanksMod.GetRankInfo(DataFolder, false)
    liness = {}
    if currentInfo then
        local currentBoosts = getBoostDisplay(currentInfo)
        if #currentBoosts > 0 then
            table.insert(lines, "Current Boosts:")
            for _, boostLine in ipairs(currentBoosts) do
                table.insert(liness, boostLine)
            end
        end
    end
    table.insert(lines,table.concat(liness, ", "))

    -- Next boosts
    liness = {}
    if minerRankVal < maxRank then
        local nextInfo = MinerRanksMod.GetRankInfo(DataFolder, true)
        if nextInfo then
            local nextBoosts = getBoostDisplay(nextInfo)
            if #nextBoosts > 0 then
                table.insert(lines, "Next Boosts:")
                for _, boostLine in ipairs(nextBoosts) do
                    table.insert(liness,boostLine)
                end
            end
        end
    end
    table.insert(lines,table.concat(liness, ", "))

    return table.concat(lines, "\n")
end

local autoMinerRankToggle = CaveTab:Toggle({
    Title = "Auto Miner Rank",
    Flag = "AutoMinerRank",
    Callback = function(val)
        if val then
            StartManagedLoop("AutoReset_MinerRank", 0.5, function()
                return true
            end, function()
                local now = os.clock()
                local last = lastResetSent["MinerRank"] or 0
                if now - last < RESET_COOLDOWN then return end

                if canRankUpMinerRank() then
                    lastResetSent["MinerRank"] = now
                    ResetRemote:FireServer("MinerRank")
                end
            end)
        else
            StopManagedLoop("AutoReset_MinerRank")
        end
    end
})
-- Status loop
StartStatusLoop("Status_MinerRanlk", 1, function()
    if autoMinerRankToggle then
        SafeSetDesc(autoMinerRankToggle, getMinerRankStatusText())
    end
end)


SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings-2" })
SettingsTab:Section({ Title = "Config Manager", Icon = "save", Opened = true })
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
Window:SelectTab(BoardUpgrades.Index)

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
