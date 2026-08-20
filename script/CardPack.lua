-- if game.PlaceId ~= 122821966131621 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "CardPack Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local character = LocalPlayer.Character
local rootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
humanoid.WalkSpeed = 100  -- nilai default biasanya 16

local FolderPath = "ANUI/CardPackIncremental"
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
    Title = "AN Hub - CardPack Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "CardPackIncremental",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "CardPack Incremental" }),
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

-- [[ MAIN TAB ]] --
MainTabs = Window:Tab({
    Title = "Main Feature",
    Icon = "swords",
    SidebarProfile = false
});
FM_CategorySelector = MainTabs:Category({
    Default = "Upgrades",
    Options = {
        {
            Title = "Upgrades",
            Icon = GetIcon(119354071521072)
        },
        {
            Title = "Ranks & Skill",
            Icon = GetIcon(95897397101705)
        },
        {
            Title = "Volcano Prestige",
            Icon = GetIcon(133808671848277)
        },
        {
            Title = "Gem Fuzer",
            Icon = GetIcon(70375022001342)
        },
        {
            Title = "Shop",
            Icon = GetIcon(93714887478354)
        }
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
    if pad then
        pad.PaddingTop = UDim.new(0, 5)
    end
end
--- MODULES

local DataPlayer = LocalPlayer.Data
local Abbreviator = require(ReplicatedStorage.Modules.Abbreviator)
local UpgradesModule = require(ReplicatedStorage.Modules.Upgrades)
local BuyUpgradeMax = ReplicatedStorage.Remotes.BuyUpgradeMax
local UpgradeLevels = LocalPlayer:WaitForChild("Upgrades")
local RanksModule = require(ReplicatedStorage.Modules.Ranks)
local ShortModule = require(ReplicatedStorage.Modules.Short)
local TechTreeModule = require(ReplicatedStorage.Modules.TechTree)
local RankUpRemote = ReplicatedStorage.Remotes.RankUp
local VolcanoPrestigeRemote = ReplicatedStorage.Remotes.VolcanoPrestige
local DataRanks = DataPlayer:WaitForChild("Ranks")
local Coins = LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Coins")
local TechTreeFolder = LocalPlayer:WaitForChild("TechTree")
local BuyTechNode = ReplicatedStorage.Remotes.BuyTechNode
local GemFuzerModule = require(ReplicatedStorage.Modules.GemFuzer)

local GemFuzerEarn = ReplicatedStorage.Remotes.GemFuzerEarn
local GemFuzerBuy = ReplicatedStorage.Remotes.GemFuzerBuy
local GemFuzerCurrency = DataPlayer:WaitForChild(GemFuzerModule.Currency)
local GemFuzerFolder = LocalPlayer:WaitForChild(GemFuzerModule.FolderName)
local DiceShopModule = require(ReplicatedStorage.Modules.DiceShop)
local PurchaseDice = ReplicatedStorage.Remotes.PurchaseDice
local DiceLevel = DataPlayer:WaitForChild("DiceLevel")
local DiceShopFolder = LocalPlayer:WaitForChild("DiceShop")
local DiceShopGui = LocalPlayer.PlayerGui:FindFirstChild("DiceShop", true)
local DiceOptionsUI = DiceShopGui:FindFirstChild("Options")
local RelicsModule = require(ReplicatedStorage.Modules.Relics)       -- jika perlu untuk data
local RelicLuckModule = require(ReplicatedStorage.Modules.RelicLuck) -- untuk speed/luck
local RollDice = ReplicatedStorage.Remotes.RollDice
local ItemsFolder = LocalPlayer:WaitForChild("Items")
local ItemsModule = require(ReplicatedStorage.Modules.Items)
local BuyAllItems = ReplicatedStorage.Remotes.BuyAllItems
local SellFruit = ReplicatedStorage.Remotes.SellFruit
local ItemShopFolder = LocalPlayer:WaitForChild("ItemShop")
local ItemSections = require(ReplicatedStorage.Modules.ItemSections)
UpgradeGroup = nil
countInGroup = 0
UpgradeToggle = {}
-- Definisikan urutan currency (sesuaikan jika perlu)
local currencyOrder = {
    FarmCoins = 7,
    Coins = 1,
    Gems = 2,
    VolcanoCoins = 4,
    VolcanoPrestige = 5,
    CrystalCoins = 6,
    Tokens = 3,
}

-- Kumpulkan nama upgrade yang valid
local upgradeNames = {}
for name, data in pairs(UpgradesModule) do
    if data.Data and data.Currency ~= "Tokens" then
        table.insert(upgradeNames, name)
    end
end

-- Urutkan berdasarkan Currency, lalu nama jika currency sama
table.sort(upgradeNames, function(a, b)
    local ca = UpgradesModule[a].Currency
    local cb = UpgradesModule[b].Currency
    local ia = currencyOrder[ca] or 99
    local ib = currencyOrder[cb] or 99
    if ia == ib then
        return a < b  -- urutkan alfabetis nama jika currency sama
    end
    return ia < ib
end)

-- Loop dengan ipairs agar urutan terjaga
for _, upgradeName in ipairs(upgradeNames) do
    local upgradeData = UpgradesModule[upgradeName]
    if countInGroup % 2 == 0 then
        UpgradeGroup = MainTabs:Group({})
        FM_Add("Upgrades", UpgradeGroup)
    end
    local UpgradeImage = game:FindFirstChild(upgradeName, true)
    local Image = UpgradeImage:FindFirstChild("UpgradeImage", true) or UpgradeImage:FindFirstChild("ImageLabel", true)
    local toggle = UpgradeGroup:Toggle({
        Title = upgradeData.Name,
        Image = Image and Image.Image or GetIcon(121461921293243),
        Flag = "AutoUpgrade_" .. upgradeName,
        Value = false,
        Callback = function(val)
            if val then
                StartManagedLoop("AutoUpgrade_" .. upgradeName, 0.5, function()
                    return true
                end,
                function()
                    local lvlObj = UpgradeLevels:FindFirstChild(upgradeName, true)
                    local level = lvlObj and lvlObj.Value or 0
                    local maxLevel = #upgradeData.Data
                    if level >= maxLevel then return end
                    local nextData = upgradeData.Data[level + 1]
                    if not nextData then return end
                    local CurrencyAmount = (upgradeData.Currency ~= "Coins") and DataPlayer:WaitForChild(upgradeData.Currency).Value or Coins.Value
                    if CurrencyAmount >= nextData.Cost then
                        pcall(function()
                            BuyUpgradeMax:FireServer(upgradeName)
                        end)
                    end
                end)
            else
                StopManagedLoop("AutoUpgrade_" .. upgradeName)
            end
        end
    })
    UpgradeToggle[upgradeName] = {
        toggle = toggle,
        upgradeData = upgradeData,
        currency = upgradeData.Currency
    }
    countInGroup = countInGroup + 1
end
-- Status update untuk semua toggle upgrade
StartStatusLoop("Status_AllUpgrades", 0.5, function()
    for upgradeName, info in pairs(UpgradeToggle) do
        local toggle = info.toggle
        local upgradeData = info.upgradeData
        local currency = info.currency
        local lvlObj = UpgradeLevels:FindFirstChild(upgradeName, true)
        local level = lvlObj and lvlObj.Value or 0
        local data = upgradeData.Data
        local maxLevel = #data

        local title = string.format("%s (%d/%d)", upgradeData.Name, level, maxLevel)
        SafeSetTitle(toggle, title)

        local lines = {}

        -- Fungsi format reward seperti client
        local function rewardText(lvl)
            if lvl < 1 then
                return (upgradeData.Prefix or "") .. 0 + (upgradeData.Base or upgradeData.BaseValue or 0) .. (upgradeData.Suffix or "")
            end
            local reward = data[lvl] and data[lvl].Reward or 0
            return (upgradeData.Prefix or "") .. reward .. (upgradeData.Suffix or "")
        end
        local nextData = data[level + 1]

        local currentReward = rewardText(level)
        local nextReward = rewardText(level + 1)
        if not nextData then
            table.insert(lines, string.format("Boost: %s", currentReward))
        else
            table.insert(lines, string.format("Boost: %s → %s", currentReward, nextReward))
        end
        if nextData then
            local costText
            local currentCurrency = (upgradeData.Currency ~= "Coins") and DataPlayer:WaitForChild(upgradeData.Currency).Value or Coins.Value
            costText = Abbreviator.en(nextData.Cost)
            currentCurrency = Abbreviator.en(currentCurrency)
            table.insert(lines, string.format("%s %s/%s", GetIcon(UpgradesModule.CurrencyImages[currency]),currentCurrency, costText))
        end
        SafeSetDesc(toggle, table.concat(lines, "\n"))
    end
end)
-- =====================================================
-- AUTO RANK UP
-- =====================================================
Config.AutoRankUp = {
    Enabled = false,
    Interval = 2  -- cek tiap 2 detik
}

local function getRankPrice(rankData)
    local techEffects = {}
    if TechTreeFolder then
        for _, child in ipairs(TechTreeFolder:GetChildren()) do
            techEffects[child.Name] = true
        end
    end
    local discount = TechTreeModule.GetBestEffect(techEffects, "RanksDiscount", 0)
    local price = rankData.Price
    if discount > 0 then
        price = math.floor(price * (1 - discount / 100))
    end
    return price
end

local autoRankUpToggle = MainTabs:Toggle({
    Title = "Rank Up",
    Image = GetIcon(95897397101705),
    Flag = "AutoRankUp_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoRankUp.Enabled = val
        if val then
            StartManagedLoop("AutoRankUp", Config.AutoRankUp.Interval, function()
                return Config.AutoRankUp.Enabled
            end, function()
                local currentRank = DataRanks.Value
                local nextRankData = RanksModule[currentRank + 1]
                if not nextRankData then return end -- sudah max

                local price = getRankPrice(nextRankData)
                if Coins.Value >= price then
                    pcall(function()
                        RankUpRemote:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoRankUp")
        end
    end
})
FM_Add("Ranks & Skill", autoRankUpToggle) -- sesuaikan kategori

-- Status Update
StartStatusLoop("Status_AutoRankUp", 1, function()
    if not autoRankUpToggle then return end

    local currentRank = DataRanks.Value
    local currentData = RanksModule[currentRank] or RanksModule[0]
    local nextRankData = RanksModule[currentRank + 1]
    -- if not nextRankData then
    --     SafeSetDesc(autoRankUpToggle, "Max Rank reached!")
    --     return
    -- end

    local price = getRankPrice(nextRankData)
    local canAfford = Coins.Value >= price
    local priceStr = Abbreviator.en and Abbreviator.en(math.floor(price))
    local coinsStr = Abbreviator.en and Abbreviator.en(math.floor(Coins.Value))
    local desc = string.format("Current Rank:\n%s%s\n%sLuck: %s%% | %sCoins: %s%%",currentData.Image,currentData.Tier,GetIcon(76712627440806),currentData.Luck,GetIcon(80629016413430),currentData.Coins)
    if nextRankData then
        desc = string.format("%s\nNext Rank:\n%s%s\n%sLuck: %s%% | %sCoins: %s%%\n%s/%s",desc,nextRankData.Image,nextRankData.Tier,GetIcon(76712627440806),nextRankData.Luck,GetIcon(80629016413430),nextRankData.Coins,coinsStr,priceStr)
    end
    SafeSetDesc(autoRankUpToggle, desc)
end)

local function getPending()
    local tech = {}
    for _, child in ipairs(TechTreeFolder:GetChildren()) do
        tech[child.Name] = true
    end
    local mult = TechTreeModule.GetBestEffect(tech, "VolcanoPrestigesMultiplier", 1)
    local coins = DataPlayer:WaitForChild("VolcanoCoins").Value
    local pending = math.floor(math.max(coins, 0) / 500) * mult
    return pending
end
Config.AutoVolcanoPrestige = {
    Enabled = false,
    Interval = 5  -- cek tiap 2 detik
}
-- ExSlider = MainTabs:Slider({
--     Title = "Coldown Prestige",
--     Desc = "Coldown Per Sec",
--     Min = 0,
--     Max = 360,
--     Default = 1,
--     Flag = "SliderVolcanoPrestige",
--     Callback = function(v)
--         Config.AutoVolcanoPrestige.Interval = v -- Mengubah 100 menjadi 1.0 (float)
--     end
-- })
-- FM_Add("Volcano Prestige", ExSlider)
local PrestigeToggle = MainTabs:Toggle({
    Title = "Prestige",
    Image = GetIcon(133808671848277),
    Flag = "AutoVolcanoPrestige_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoVolcanoPrestige.Enabled = val
        if val then
            StartManagedLoop("AutoVolcanoPrestige", Config.AutoVolcanoPrestige.Interval, function()
                return Config.AutoVolcanoPrestige.Enabled
            end, function()
                local pending = getPending()
                if pending >= 1 then
                    pcall(function()
                        VolcanoPrestigeRemote:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoVolcanoPrestige")
        end
    end
})
FM_Add("Volcano Prestige", PrestigeToggle)
StartStatusLoop("Status_AutoVolcanoPrestige", 1, function()
    if not PrestigeToggle then return end

    local pending = getPending()
    volcanoui = workspace:FindFirstChild("VolcanoPrestige",true)
    VolcanoDesc = volcanoui:FindFirstChild("Description",true).Text
    volcanoPresImage = GetIcon(138080027566646)
    volcanoImage = GetIcon(121461921293243)

    local pendingText = Abbreviator.en and Abbreviator.en(math.floor(pending))
    local coinsText = Abbreviator.en and Abbreviator.en(math.floor(DataPlayer:WaitForChild("VolcanoCoins").Value))

    local desc = string.format(
        "%s\n%s +%s\nRequirement:%s %s/500",
        VolcanoDesc,
        volcanoPresImage,
        pendingText,
        volcanoImage,
        coinsText
    )
    SafeSetDesc(PrestigeToggle, desc)
end)
Config.AutoTechNode = {
    Enabled = false,
    Interval = 1
}
local autoTechNodeToggle = MainTabs:Toggle({
    Title = "🌳 Auto Buy Skill Tree",
    Flag = "AutoTechNode_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoTechNode.Enabled = val
        if val then
            StartManagedLoop("AutoTechNode", Config.AutoTechNode.Interval, function()
                return Config.AutoTechNode.Enabled
            end, function()
                if not TechTreeModule or not TechTreeModule.Nodes then return end

                -- Daftar node yang sudah dimiliki
                local owned = {}
                for _, child in ipairs(TechTreeFolder:GetChildren()) do
                    owned[child.Name] = true
                end

                -- Kumpulkan node yang bisa dibeli
                local affordableNodes = {}
                for nodeName, nodeData in pairs(TechTreeModule.Nodes) do
                    if not owned[nodeName] then
                        -- Cek prasyarat
                        local prereq = nodeData.Requires
                        if not prereq or owned[prereq] then
                            local treeName = TechTreeModule.TreeOf(nodeName)
                            local treeData = treeName and TechTreeModule.Trees[treeName]
                            if treeData then
                                local currencyObj = DataPlayer:FindFirstChild(treeData.Currency)
                                local currencyValue = currencyObj and currencyObj.Value or 0
                                if currencyValue >= nodeData.Price then
                                    table.insert(affordableNodes, nodeName)
                                end
                            end
                        end
                    end
                end

                -- Beli satu per satu dengan jeda singkat
                for _, nodeName in ipairs(affordableNodes) do
                    pcall(function()
                        BuyTechNode:FireServer(nodeName)
                    end)
                    task.wait(0.2)
                end
            end)
        else
            StopManagedLoop("AutoTechNode")
        end
    end
})
FM_Add("Ranks & Skill", autoTechNodeToggle)
local function countOwned()
    local c = 0
    for _, _ in ipairs(TechTreeFolder:GetChildren()) do c = c + 1 end
    return c
end
StartStatusLoop("Status_AutoTechNode", 1, function()
    if not autoTechNodeToggle or not TechTreeModule or not TechTreeModule.Nodes then
        SafeSetTitle(autoTechNodeToggle, "🌳 Auto Buy Skill Tree")
        SafeSetDesc(autoTechNodeToggle, "Loading...")
        return
    end

    local owned = {}
    for _, child in ipairs(TechTreeFolder:GetChildren()) do
        owned[child.Name] = true
    end

    local affordableCount = 0
    local totalCount = 0

    for nodeName, nodeData in pairs(TechTreeModule.Nodes) do
        totalCount = totalCount + 1
        if not owned[nodeName] then
            local prereq = nodeData.Requires
            if not prereq or owned[prereq] then
                local treeName = TechTreeModule.TreeOf(nodeName)
                local treeData = treeName and TechTreeModule.Trees[treeName]
                if treeData then
                    local currencyObj = DataPlayer:FindFirstChild(treeData.Currency)
                    local currencyValue = currencyObj and currencyObj.Value or 0
                    if currencyValue >= nodeData.Price then
                        affordableCount = affordableCount + 1
                    end
                end
            end
        end
    end

    local title = "🌳 Auto Buy Skill Tree"
    if Config.AutoTechNode.Enabled then title = title .. " (ON)" end
    SafeSetTitle(autoTechNodeToggle, title)
    SafeSetDesc(autoTechNodeToggle, string.format(
        "Affordable: %d | Owned: %d | Total: %d",
        affordableCount,
        countOwned(),  -- ini butuh helper
        totalCount
    ))
end)
-- =====================================================
-- AUTO GEM FUZER (Earn + Buy)
-- =====================================================
Config.AutoGemFuzer = { Enabled = false }

local autoGemFuzerToggle = MainTabs:Toggle({
    Title = "Earning & Upgrade Gem Fuzer",
    Image = GetIcon(70375022001342),
    Flag = "AutoGemFuzer_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoGemFuzer.Enabled = val
        if val then
            -- Loop earn
            StartManagedLoop("AutoGemFuzer_Earn", 0.5, function()
                return Config.AutoGemFuzer.Enabled
            end, function()
                for _, child in ipairs(GemFuzerFolder:GetChildren()) do
                    local countObj = child:FindFirstChild("Count")
                    if countObj and countObj.Value > 0 then
                        pcall(function()
                            GemFuzerEarn:FireServer(child.Name)
                        end)
                    end
                end
            end)

            -- Loop buy
            StartManagedLoop("AutoGemFuzer_Buy", 1, function()
                return Config.AutoGemFuzer.Enabled
            end, function()
                local currencyAmount = GemFuzerCurrency.Value
                local sorted = GemFuzerModule.Sorted()

                for _, fuzer in ipairs(sorted) do
                    local key = fuzer.Key
                    local folderObj = GemFuzerFolder:FindFirstChild(key)
                    local count = 0
                    if folderObj then
                        local countObj = folderObj:FindFirstChild("Count")
                        count = countObj and countObj.Value or 0
                    end

                    local cost
                    if not GemFuzerModule.IsMaxed(count) then
                        cost = GemFuzerModule.GetCost(key, count)
                    end

                    if cost and cost <= currencyAmount then
                        pcall(function()
                            GemFuzerBuy:FireServer(key)
                        end)
                        -- hanya beli satu per loop agar tidak boros
                        task.wait(0.2)
                    end
                end
            end)
        else
            StopManagedLoop("AutoGemFuzer_Earn")
            StopManagedLoop("AutoGemFuzer_Buy")
        end
    end
})
FM_Add("Gem Fuzer", autoGemFuzerToggle)

-- Status tunggal gabungan
local sortedFuzers = GemFuzerModule.Sorted()
local gemMultiplier = function()
    local m = LocalPlayer:GetAttribute(GemFuzerModule.MultiplierAttribute)
    if type(m) ~= "number" or m <= 0 then return 1 end
    return m
end

StartStatusLoop("Status_AutoGemFuzer", 1, function()
    if not autoGemFuzerToggle then return end

    local currencyAmount = GemFuzerCurrency.Value
    local currencyStr = Abbreviator.en(math.floor(currencyAmount))
    local multiplier = gemMultiplier()
    local ownedCount = 0
    local affordableCount = 0
    local nextAffordable = nil
    local lines = {}

    -- Bagian owned & earnings
    for _, fuzer in ipairs(sortedFuzers) do
        local key = fuzer.Key
        local folderObj = GemFuzerFolder:FindFirstChild(key)
        local count = 0
        if folderObj then
            local countObj = folderObj:FindFirstChild("Count")
            count = countObj and countObj.Value or 0
        end

        if count > 0 then
            ownedCount = ownedCount + 1
            local displayName = fuzer.Info.Name or key
            local rateText
            if GemFuzerModule.IsAuto(count) then
                rateText = Abbreviator.en(math.floor(GemFuzerModule.GetRate(key, count, multiplier))) .. "/s"
            else
                rateText = "+" .. Abbreviator.en(math.floor(GemFuzerModule.GetEarnings(key, count, multiplier)))
            end
            table.insert(lines, string.format("%s%s: %s", fuzer.Info.Image, displayName, rateText))
        end

        -- Bagian affordable buy
        local cost
        if not GemFuzerModule.IsMaxed(count) then
            cost = GemFuzerModule.GetCost(key, count)
        end
        if cost and cost <= currencyAmount then
            affordableCount = affordableCount + 1
            if not nextAffordable then
                nextAffordable = {
                    name = fuzer.Info.Name or key,
                    cost = cost
                }
            end
        end
    end

    if ownedCount == 0 then
        table.insert(lines, "No fuzers owned")
    end
    table.insert(lines, GetIcon(70375022001342) .. "Gem Fuzer: " .. currencyStr)

    SafeSetTitle(autoGemFuzerToggle, "Earning & Upgrade Gem Fuzer")
    SafeSetDesc(autoGemFuzerToggle, table.concat(lines, "\n"))
end)
-- =====================================================
-- AUTO BUY DICE SHOP
-- =====================================================
Config.AutoBuyDice = { Enabled = false }

local autoBuyDiceToggle = MainTabs:Toggle({
    Title = "🎲 Buy Dice",
    Flag = "AutoBuyDice_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoBuyDice.Enabled = val
        if val then
            StartManagedLoop("AutoBuyDice", 1, function()
                return Config.AutoBuyDice.Enabled
            end, function()
                if not DiceOptionsUI then return end
                local currencyAmount = DataPlayer:WaitForChild(DiceShopModule.Currency).Value
                local level = DiceLevel.Value

                for _, option in ipairs(DiceOptionsUI:GetChildren()) do
                    if option:IsA("GuiObject") then
                        local itemName = option.Name
                        local itemData = DiceShopModule.Get(itemName)
                        if itemData then
                            if level >= itemData.Level then
                                local stockObj = DiceShopFolder:FindFirstChild(itemData.Stock)
                                local stock = stockObj and stockObj.Value or 0
                                if stock > 0 and currencyAmount >= itemData.Price then
                                    pcall(function()
                                        PurchaseDice:FireServer(itemName)
                                    end)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end
                end
            end)
        else
            StopManagedLoop("AutoBuyDice")
        end
    end
})
FM_Add("Shop", autoBuyDiceToggle)
StartStatusLoop("Status_AutoBuyDice", 1, function()
    if not autoBuyDiceToggle then return end

    local currencyAmount = DataPlayer:WaitForChild(DiceShopModule.Currency).Value
    local level = DiceLevel.Value
    local affordableCount = 0
    local totalItems = 0

    if DiceOptionsUI then
        for _, option in ipairs(DiceOptionsUI:GetChildren()) do
            if option:IsA("GuiObject") then
                local itemData = DiceShopModule.Get(option.Name)
                if itemData then
                    totalItems = totalItems + 1
                    if level >= itemData.Level then
                        local stockObj = DiceShopFolder:FindFirstChild(itemData.Stock)
                        local stock = stockObj and stockObj.Value or 0
                        if stock > 0 and currencyAmount >= itemData.Price then
                            affordableCount = affordableCount + 1
                        end
                    end
                end
            end
        end
    end
    SafeSetDesc(autoBuyDiceToggle, string.format(
        "Level: %d | Affordable: %d/%d items",
        level, affordableCount, totalItems
    ))
end)

-- =====================================================
-- AUTO ROLL SEMUA DICE
-- =====================================================
Config.AutoRollAllDice = {
    Enabled = false,
    Interval = 0.01  -- cek tiap 1 detik
}
DiceItem = {
    ["Dice"] = "Dice",
    ["Ice Dice"] = "Ice Dice",
    ["Fire Dice"] = "Fire Dice",
    ["Insane Dice"] = "Insane Dice",
}
local autoRollAllDiceToggle = MainTabs:Toggle({
    Title = "🎲 Roll Dice",
    Flag = "AutoRollAllDice_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoRollAllDice.Enabled = val
        if val then
            StartManagedLoop("AutoRollAllDice", Config.AutoRollAllDice.Interval, function()
                return Config.AutoRollAllDice.Enabled
            end, function()
                game:GetService("ReplicatedStorage").Remotes.Roll:FireServer()
                for _, diceObj in ipairs(ItemsFolder:GetChildren()) do
                    if diceObj.Value > 0 and DiceItem[diceObj.Name] then
                        pcall(function()
                            RollDice:FireServer(diceObj.Name)
                        end)
                        task.wait(0.1) -- jeda kecil agar tidak membanjiri server
                    end
                end
            end)
        else
            StopManagedLoop("AutoRollAllDice")
        end
    end
})
FM_Add("Shop", autoRollAllDiceToggle)
StartStatusLoop("Status_AutoRollAllDice", 1, function()
    if not autoRollAllDiceToggle then return end

    local totalDice = 0
    local diceList = {}

    for _, diceObj in ipairs(ItemsFolder:GetChildren()) do
        local count = diceObj.Value
        if count > 0 and DiceItem[diceObj.Name]  then
            totalDice = totalDice + count
            table.insert(diceList, string.format("%s: x%d", diceObj.Name, count))
        end
    end

    local desc
    if totalDice > 0 then
        desc = string.format("Total Dice: %d\n%s", totalDice, table.concat(diceList, "\n"))
    else
        desc = "Total Dice: 0"
    end
    SafeSetDesc(autoRollAllDiceToggle, desc)
end)
-- =====================================================
-- AUTO BUY ALL & USE ALL (Shop)
-- =====================================================
Config.AutoBuyUseAll = {
    Enabled = false,
    Interval = 3  -- cek tiap 3 detik
}

local autoBuyUseAllToggle = MainTabs:Toggle({
    Title = "Buy & Use All Potion",
    Image = GetIcon(93714887478354),
    Flag = "AutoBuyUseAll_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoBuyUseAll.Enabled = val
        if val then
            StartManagedLoop("AutoBuyUseAll", Config.AutoBuyUseAll.Interval, function()
                return Config.AutoBuyUseAll.Enabled
            end, function()
                -- Bagian 1: Beli semua jika ada stok
                local hasStock = false
                for _, child in ipairs(ItemShopFolder:GetChildren()) do
                    if child:IsA("Folder") and string.match(child.Name, "^Slot%d+$") then
                        local stockObj = child:FindFirstChild("Stock")
                        if stockObj and stockObj.Value > 0 then
                            hasStock = true
                            break
                        end
                    end
                end
                if hasStock then
                    pcall(function()
                        BuyAllItems:FireServer()
                    end)
                end

                -- Bagian 2: Gunakan semua item non‑relic yang dimiliki
                local usedCount = 0
                for _, itemObj in ipairs(ItemsFolder:GetChildren()) do
                    if itemObj:IsA("NumberValue") and itemObj.Value > 0 then
                        local itemName = itemObj.Name
                        -- Hanya gunakan item yang bukan relic (Slot == nil)
                        local slot = ItemSections.Slot(itemName)
                        if not slot then
                            pcall(function()
                                UseItem:FireServer(itemName, "Use1")
                            end)
                            usedCount = usedCount + 1
                            task.wait(0.1) -- jeda kecil
                            if usedCount >= 5 then break end -- batasi per siklus
                        end
                    end
                end
            end)
        else
            StopManagedLoop("AutoBuyUseAll")
        end
    end
})
FM_Add("Shop", autoBuyUseAllToggle)
StartStatusLoop("Status_AutoBuyUseAll", 1, function()
    if not autoBuyUseAllToggle then return end

    -- Info stok
    local slotCount = 0
    local totalStock = 0
    for _, child in ipairs(ItemShopFolder:GetChildren()) do
        if child:IsA("Folder") and string.match(child.Name, "^Slot%d+$") then
            slotCount = slotCount + 1
            local stockObj = child:FindFirstChild("Stock")
            if stockObj then totalStock = totalStock + stockObj.Value end
        end
    end

    -- Info item yang bisa digunakan (non‑relic)
    local usableItems = 0
    local totalItems = 0
    for _, itemObj in ipairs(ItemsFolder:GetChildren()) do
        if itemObj:IsA("NumberValue") and itemObj.Value > 0 then
            totalItems = totalItems + 1
            local itemName = itemObj.Name
            if not ItemSections.Slot(itemName) then
                usableItems = usableItems + 1
            end
        end
    end

    local restockRemaining = 600 - (os.time() % 600)
    local restockText = restockRemaining >= 60
        and string.format("%d:%02d", math.floor(restockRemaining/60), restockRemaining % 60)
        or restockRemaining .. "s"

    SafeSetDesc(autoBuyUseAllToggle, string.format(
        "Coins: %s\nStok: %d (Slot: %d)\nItem bisa dipakai: %d/%d\nRestock: %s",
        Abbreviator.en(Coins.Value),
        totalStock,
        slotCount,
        usableItems,
        totalItems,
        restockText
    ))
end)

-- =====================================================
-- AUTO PURCHASE SEED (Shop)
-- =====================================================
local SeedShopModule = require(ReplicatedStorage.Modules.SeedShop)
local PlantsModule = require(ReplicatedStorage.Modules.Plants)
local PurchaseSeed = ReplicatedStorage.Remotes.PurchaseSeed
local SeedShopFolder = LocalPlayer:WaitForChild(SeedShopModule.Folder)
local SeedShopCurrency = DataPlayer:WaitForChild(SeedShopModule.Currency)
local SeedShopLevel = DataPlayer:WaitForChild(SeedShopModule.LevelStat)
local SeedShopItems = LocalPlayer:WaitForChild("Items")
local PlotFolder = LocalPlayer:WaitForChild(PlantsModule.PlotFolder)

-- Cari UI SeedShop (mirip DiceShopGui)
local SeedShopGui = LocalPlayer.PlayerGui:FindFirstChild("SeedShop", true) or workspace:FindFirstChild("SeedShop", true)
local SeedOptionsUI = SeedShopGui and SeedShopGui:FindFirstChild("Options")

local function IsStranded()
    local cheapestName, cheapestData = SeedShopModule.Cheapest()
    if not cheapestName then return false end
    if SeedShopCurrency.Value >= cheapestData.Price then return false end

    for _, seedInfo in ipairs(SeedShopModule.Sorted()) do
        local itemObj = SeedShopItems:FindFirstChild(seedInfo.Info.Item)
        if itemObj and itemObj.Value > 0 then return false end
    end

    for _, plant in pairs(PlantsModule.List) do
        if plant.Fruit then
            local fruitObj = SeedShopItems:FindFirstChild(plant.Fruit)
            if fruitObj and fruitObj.Value > 0 then return false end
        end
    end

    for _, plotObj in ipairs(PlotFolder:GetChildren()) do
        if plotObj:IsA("StringValue") and plotObj.Value ~= "" then return false end
    end

    return true
end

Config.AutoPurchaseSeed = { Enabled = false }

local autoPurchaseSeedToggle = MainTabs:Toggle({
    Title = "🌱 Auto Buy Seed",
    Flag = "AutoPurchaseSeed_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoPurchaseSeed.Enabled = val
        if val then
            StartManagedLoop("AutoPurchaseSeed", 1, function()
                return Config.AutoPurchaseSeed.Enabled
            end, function()
                if not SeedOptionsUI then return end

                local currency = SeedShopCurrency.Value
                local level = SeedShopLevel.Value
                local cheapestName, _ = SeedShopModule.Cheapest()

                -- Jika stranded, beli seed termurah gratis (stock harus ada)
                if cheapestName and IsStranded() then
                    local seedData = SeedShopModule.Get(cheapestName)
                    if seedData then
                        local stockObj = SeedShopFolder:WaitForChild(seedData.Stock, 5)
                        if stockObj and stockObj.Value > 0 then
                            pcall(function()
                                PurchaseSeed:FireServer(cheapestName)
                            end)
                        end
                    end
                    return
                end

                -- Iterasi semua option di UI (sama seperti Dice Shop)
                for _, option in ipairs(SeedOptionsUI:GetChildren()) do
                    if option:IsA("GuiObject") then
                        local seedName = option.Name
                        local seedData = SeedShopModule.Get(seedName)
                        if seedData then
                            if level >= seedData.Level then
                                local stockObj = SeedShopFolder:WaitForChild(seedData.Stock, 5)
                                if stockObj and stockObj.Value > 0 and currency >= seedData.Price then
                                    pcall(function()
                                        PurchaseSeed:FireServer(seedName)
                                    end)
                                    task.wait(0.2)
                                    break -- satu per siklus
                                end
                            end
                        end
                    end
                end
            end)
        else
            StopManagedLoop("AutoPurchaseSeed")
        end
    end
})
FM_Add("Shop", autoPurchaseSeedToggle)

StartStatusLoop("Status_AutoPurchaseSeed", 1, function()
    if not autoPurchaseSeedToggle then return end

    local level = SeedShopLevel.Value
    local currency = SeedShopCurrency.Value
    local totalStock = 0
    local affordableCount = 0
    local totalSlots = 0
    local stranded = IsStranded()

    if SeedOptionsUI then
        for _, option in ipairs(SeedOptionsUI:GetChildren()) do
            if option:IsA("GuiObject") then
                local seedData = SeedShopModule.Get(option.Name)
                if seedData then
                    totalSlots = totalSlots + 1
                    local stockObj = SeedShopFolder:WaitForChild(seedData.Stock, 5)
                    if stockObj then
                        totalStock = totalStock + stockObj.Value
                    end
                    if level >= seedData.Level and stockObj and stockObj.Value > 0 and currency >= seedData.Price then
                        affordableCount = affordableCount + 1
                    end
                end
            end
        end
    end

    SafeSetDesc(autoPurchaseSeedToggle, string.format(
        "Level: %d\nAffordable: %d/%d",
        level,
        affordableCount,
        totalSlots
    ))
end)

local PlantsModule = require(ReplicatedStorage.Modules.Plants)
local PlantSeed = ReplicatedStorage.Remotes.PlantSeed
local CollectPlant = ReplicatedStorage.Remotes.CollectPlant
local PlotFolder = LocalPlayer:WaitForChild(PlantsModule.PlotFolder)
local PlotParent = workspace:WaitForChild(PlantsModule.PlotParent)
local function GetMaxPlantSlots()
    local upgName = "MorePlantSlots"
    local upgData = UpgradesModule and UpgradesModule[upgName]
    local lvlObj = UpgradeLevels:FindFirstChild(upgName)
    local lvl = lvlObj and lvlObj.Value or 0

    local defaultSlots = (upgData and upgData.BaseValue) or 3
    if upgData and upgData.Data then
        if lvl > 0 and upgData.Data[lvl] then
            return upgData.Data[lvl].Reward
        elseif lvl == 0 then
            return defaultSlots
        end
    end
    return defaultSlots
end
local function GetOpenPlots()
    local plots = {}
    for _, plot in ipairs(PlotParent:GetChildren()) do
        if plot:IsA("BasePart") then
            local plotName = plot.Name
            local match = plotName:match("^Plant(%d+)$")
            if match then
                local index = tonumber(match)
                local valueObj = PlotFolder:FindFirstChild(plotName)
                if valueObj and valueObj:IsA("StringValue") then
                    table.insert(plots, {
                        Index = index,
                        Name = plotName,
                        PlantedValue = valueObj.Value,
                        Empty = (valueObj.Value == "")
                    })
                end
            end
        end
    end
    table.sort(plots, function(a, b) return a.Index < b.Index end)
    return plots
end
Config.AutoPlantSeed = { Enabled = false, Interval = 2 }

local autoPlantSeedToggle = MainTabs:Toggle({
    Title = "🌱 Auto Plant Seed",
    Flag = "AutoPlantSeed_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoPlantSeed.Enabled = val
        if val then
            StartManagedLoop("AutoPlantSeed", Config.AutoPlantSeed.Interval, function()
                return Config.AutoPlantSeed.Enabled
            end, function()
                -- Cari benih yang dimiliki
                local seedName = nil
                for _, seedInfo in ipairs(SeedShopModule.Sorted()) do
                    local itemName = seedInfo.Info.Item
                    local itemObj = ItemsFolder:FindFirstChild(itemName)
                    if itemObj and itemObj.Value > 0 then
                        seedName = itemName
                        break
                    end
                end
                if not seedName then return end

                -- Cari plot kosong pertama yang terbuka
                local maxSlots = GetMaxPlantSlots()
                local targetPlot = nil
                for _, plot in ipairs(GetOpenPlots()) do
                    if plot.Index <= maxSlots and plot.Empty then
                        targetPlot = plot.Name
                        break
                    end
                end
                if not targetPlot then return end

                pcall(function()
                    PlantSeed:FireServer(seedName, targetPlot)
                end)
            end)
        else
            StopManagedLoop("AutoPlantSeed")
        end
    end
})
FM_Add("Shop", autoPlantSeedToggle)
Config.AutoCollectPlant = { Enabled = false, Interval = 1 }

local autoCollectPlantToggle = MainTabs:Toggle({
    Title = "🍎 Auto Collect Plant",
    Flag = "AutoCollectPlant_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoCollectPlant.Enabled = val
        if val then
            StartManagedLoop("AutoCollectPlant", Config.AutoCollectPlant.Interval, function()
                return Config.AutoCollectPlant.Enabled
            end, function()
                local now = workspace:GetServerTimeNow()

                for _, plot in ipairs(GetOpenPlots()) do
                    if not plot.Empty then
                        local finishObj = PlotFolder:FindFirstChild(plot.Name .. "Finish")
                        if finishObj and finishObj.Value > 0 and finishObj.Value <= now then
                            pcall(function()
                                CollectPlant:FireServer(plot.Name)
                            end)
                            task.wait(0.1)
                        end
                    end
                end
            end)
        else
            StopManagedLoop("AutoCollectPlant")
        end
    end
})
FM_Add("Shop", autoCollectPlantToggle)
StartStatusLoop("Status_AutoPlant", 1, function()
    if autoPlantSeedToggle then
        local seedCount = 0
        for _, seedInfo in ipairs(SeedShopModule.Sorted()) do
            local itemObj = ItemsFolder:FindFirstChild(seedInfo.Info.Item)
            if itemObj then seedCount = seedCount + itemObj.Value end
        end
        local emptyPlots = 0
        local maxSlots = GetMaxPlantSlots()
        for _, plot in ipairs(GetOpenPlots()) do
            if plot.Index <= maxSlots and plot.Empty then
                emptyPlots = emptyPlots + 1
            end
        end
        local title = "🌱 Auto Plant Seed"
        if Config.AutoPlantSeed.Enabled then title = title .. " (ON)" end
        SafeSetTitle(autoPlantSeedToggle, title)
        SafeSetDesc(autoPlantSeedToggle, string.format("Seeds: %d\nEmpty plots: %d", seedCount, emptyPlots))
    end

    if autoCollectPlantToggle then
        local ready = 0
        local now = workspace:GetServerTimeNow()
        for _, plot in ipairs(GetOpenPlots()) do
            if not plot.Empty then
                local finishObj = PlotFolder:FindFirstChild(plot.Name .. "Finish")
                if finishObj and finishObj.Value > 0 and finishObj.Value <= now then
                    ready = ready + 1
                end
            end
        end
        SafeSetDesc(autoCollectPlantToggle, string.format("Ready to collect: %d", ready))
    end
end)
-- =====================================================
-- AUTO SELL FRUIT ALL
-- =====================================================
Config.AutoSellFruitAll = { Enabled = false, Interval = 2 }

local autoSellFruitAllToggle = MainTabs:Toggle({
    Title = "Sell Fruit",
    Flag = "AutoSellFruitAll_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoSellFruitAll.Enabled = val
        if val then
            StartManagedLoop("AutoSellFruitAll", Config.AutoSellFruitAll.Interval, function()
                return Config.AutoSellFruitAll.Enabled
            end, function()
                for _, itemObj in ipairs(ItemsFolder:GetChildren()) do
                    if itemObj.Value > 0 and PlantsModule.Get(itemObj.Name) then
                        pcall(function()
                            SellFruit:FireServer("All")
                        end)
                        break
                    end
                end
            end)
        else
            StopManagedLoop("AutoSellFruitAll")
        end
    end
})
FM_Add("Shop", autoSellFruitAllToggle)

StartStatusLoop("Status_AutoSellFruitAll", 1, function()
    if not autoSellFruitAllToggle then return end

    local fruitCount = 0
    local totalValue = 0
    dataFruit = {}
    for _, itemObj in ipairs(ItemsFolder:GetChildren()) do
        if itemObj.Value > 0 and PlantsModule.Get(itemObj.Name) then
            Fruit = ItemsModule[itemObj.Name]
            table.insert(dataFruit, string.format("%s%s (x%s)",Fruit.Image,itemObj.Name,itemObj.Value))
            fruitCount = fruitCount + 1
            totalValue = totalValue + (Fruit.Value * itemObj.Value)
        end
    end
    desc = string.format(
        "Fruit: %d\n%s\n%sFarm Coins Get: %s",
        fruitCount,
        table.concat(dataFruit, "\n"),
        GetIcon(122294855217410),
        Abbreviator.en(totalValue)
    )

    SafeSetDesc(autoSellFruitAllToggle, desc)
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
FM_OnChange("Upgrades")
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
