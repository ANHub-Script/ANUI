-- if game.PlaceId ~= 122821966131621 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Bubble Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local character = LocalPlayer.Character
local rootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
humanoid.WalkSpeed = 30  -- nilai default biasanya 16

local FolderPath = "ANUI/BubbleIncremental"
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
    Title = "AN Hub - Bubble Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "BubbleIncremental",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Bubble Incremental" }),
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
    local valType = typeof(val)
    
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
        return "\"" .. val:GetFullName() .. "\"" 
    elseif valType == "function" then
        local info = debug.getinfo(val)
        return "\"function: " .. tostring(info.source) .. " | Line: " .. tostring(info.linedefined) .. "\""
    else
        local result = tostring(val)
        if valType == "number" or valType == "boolean" then
            return result
        else
            return "\"" .. result .. "\""
        end
    end
end


-- [[ MAIN TAB ]] --
MainTabs = Window:Tab({
    Title = "Main Feature",
    Icon = "swords",
    SidebarProfile = false
})
FM_CategorySelector = MainTabs:Category({
    Default = "Bubble",
    Options = {
    {Title = "Bubble", Icon = GetIcon(134897736649093)},
    {Title = "Rebirth", Icon = GetIcon(77855012263464)},
    {Title = "Pearl", Icon = GetIcon(123485270163655)},
    {Title = "Gems", Icon = GetIcon(99134347373347)},
    {Title = "QuestPoint", Icon = GetIcon(81321001337471)},
    {Title = "AncientBubble", Icon = GetIcon(93058066960794)},
    {Title = "AncientPearl", Icon = GetIcon(104612017437892)},
    {Title = "InfinityBubble", Icon = GetIcon(93423747597464)},
    {Title = "Token", Icon = GetIcon(93522116426480)},
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

local function Color3ToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
end

-- Bikin teks rune jadi gradient (terang -> warna asli -> gelap) dari 1 warna dasar
-- Memakai tag <gradient=...> yang didukung WindUI di Title/Desc
local function GradientTag(color, text)
    local light = Color3.new(
        color.R + (1 - color.R) * 0.6,
        color.G + (1 - color.G) * 0.6,
        color.B + (1 - color.B) * 0.6
    )
    local dark = Color3.new(color.R * 0.55, color.G * 0.55, color.B * 0.55)
    return string.format("<gradient=%s,%s,%s>%s</gradient>",
        Color3ToHex(light), Color3ToHex(color), Color3ToHex(dark), text)
end
Config.Upgraders = {}
--- LOAD MODULES 
UpgradeConfig = require(ReplicatedStorage.Systems.UpgradeSystem.UpgradeConfig)
Networker = require(ReplicatedStorage.Packages.DataService.Networker)

-- Modul pendukung
DataServiceClient = require(ReplicatedStorage.Packages.DataService).client
UpgradeUtil = require(ReplicatedStorage.Systems.UpgradeSystem.UpgradeUtil)
NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
PlayerStatCache = require(ReplicatedStorage.Modules.PlayerStatCache)
Networker = require(ReplicatedStorage.Packages.DataService.Networker)
RebirthUtil = require(ReplicatedStorage.Systems.RebirthSystem.RebirthUtil)
RebirthConfig = require(ReplicatedStorage.Systems.RebirthSystem.RebirthConfig)
CollectionService = game:GetService("CollectionService")
-- Networker untuk rebirth
getgenv().Networkers = getgenv().Networkers or {}

local function GetNetworker(tag, serviceModule)
    if not getgenv().Networkers[tag] then
        if serviceModule and serviceModule.networker then
            getgenv().Networkers[tag] = serviceModule.networker
        else
            getgenv().Networkers[tag] = Networker.client.new(tag, serviceModule)
        end
    end
    return getgenv().Networkers[tag]
end
-- Contoh pakai:
RebirthNetworker = GetNetworker("RebirthService", require(ReplicatedStorage.Systems.RebirthSystem.RebirthServiceClient))
UpgradeNetworker = GetNetworker("UpgradeService", require(ReplicatedStorage.Systems.UpgradeSystem.UpgradeServiceClient))
-- Helper untuk format angka ala UpgradeServiceClient
local function FormatBoardEffect(value, isMultiplier)
    if value:moreEquals(NumberUtil.FromString("100")) or (value - value:floor()):lessThan(NumberUtil.FromString("0.0001")) then
        value = value:floor()
    end
    local str = value:toString("suffix")
    if isMultiplier then
        return "x" .. str
    else
        return str
    end
end

-- Pastikan data siap
DataServiceClient:waitForData()
-- ==================== AUTO REBIRTH ====================
-- Load modul rebirth
task.spawn(function()
    while not Window.Destroyed do
    task.wait(0.01)
    local Event = game:GetService("ReplicatedStorage").Packages.DataService.Networker._remotes.BubbleDome.RemoteEvent
    Event:FireServer(
        "CollectBubbles",
        {
            SilverBubble = 10,
            RainbowBubble = 10,
            CursedBubble = 10,
            EmeraldBubble = 10,
            GoldBubble = 10,
            Bubble = 10
        }
    )
end
end)
-- Ambil RebirthId dari board yang ada (fallback ke "Rebirth")
local rebirthId = "Rebirth"
for _, board in ipairs(CollectionService:GetTagged("RebirthBoard")) do
    local id = board:GetAttribute("RebirthId")
    if id then
        rebirthId = id
        break
    end
end

local rebirthConfig = RebirthUtil.GetConfig(rebirthId)
if rebirthConfig then
    -- Buat group khusus rebirth
    local rebirthGroup = MainTabs:Group({})

    -- Toggle Auto Rebirth
    local autoRebirthToggle = rebirthGroup:Toggle({
        Title = "Rebirth",
        Image = "rbxassetid://77855012263464", -- bisa diganti icon Rebirth
        Flag = "AutoRebirth_" .. rebirthId,
        Value = false,
        Callback = function(val)
            Config.AutoRebirth = val
            if val then
                StartManagedLoop("AutoRebirth_" .. rebirthId, 1,
                    function()
                        return Config.AutoRebirth == true
                    end,
                    function()
                        -- Ambil currency yang akan dikonversi
                        local currencyStr = DataServiceClient:get({ "Currency", rebirthConfig.Conversion.From }) or "0"
                        local currencyNum = NumberUtil.FromString(currencyStr)

                        -- Ambil multiplier
                        local multStr = PlayerStatCache.GetStat(LocalPlayer, "RebirthMultiplier") or "1"
                        local multNum = NumberUtil.FromString(multStr)

                        -- Hitung reward
                        local reward = RebirthUtil.CalculateRebirthReward(rebirthId, currencyNum, multNum)

                        -- Jika reward > 0, lakukan rebirth
                        if reward:moreThan(0) then
                            RebirthNetworker:fire("RequestRebirth", rebirthId)
                        end
                    end)
            else
                StopManagedLoop("AutoRebirth_" .. rebirthId)
            end
        end
    })
    FM_Add("Rebirth",autoRebirthToggle)

    -- Fungsi update deskripsi toggle
    local function UpdateRebirthDescription()
        local currencyStr = DataServiceClient:get({ "Currency", rebirthConfig.Conversion.From }) or "0"
        local currencyNum = NumberUtil.FromString(currencyStr)

        local multStr = PlayerStatCache.GetStat(LocalPlayer, "RebirthMultiplier") or "1"
        local multNum = NumberUtil.FromString(multStr)

        local reward = RebirthUtil.CalculateRebirthReward(rebirthId, currencyNum, multNum)
        local rewardStr = reward:toString("suffix")

        local desc = string.format(
            "Convert %s %s -> %s %s | Reward: +%s %s",
            rebirthConfig.Conversion.Rate,
            rebirthConfig.Conversion.From,
            multNum:toString("suffix"),
            rebirthConfig.Conversion.To,
            rewardStr,
            rebirthConfig.Conversion.To
        )

        SafeSetDesc(autoRebirthToggle, desc)
    end

    -- Update langsung + loop setiap 1 detik
    UpdateRebirthDescription()
    StartStatusLoop("AutoRebirth_Desc_" .. rebirthId, 1, UpdateRebirthDescription)
end

local function GetSortedUpgradesByCurrency(config)
    -- Urutan currency yang diinginkan (sesuaikan dengan kategori UI)
    local currencyOrder = {
        "Bubble", "Rebirth", "Pearl", "Gems", "QuestPoint",
        "AncientBubble", "AncientPearl", "InfinityBubble", "Token"
    }

    local grouped = {} -- [currency] = { {CategoryName, UpgradeKey, Data, Order}, ... }

    -- Kumpulkan semua upgrade dari semua kategori
    for categoryName, upgrades in pairs(config) do
        for upgradeKey, upgradeData in pairs(upgrades) do
            local currency = upgradeData.Currency
            if not grouped[currency] then
                grouped[currency] = {}
            end
            table.insert(grouped[currency], {
                CategoryName = categoryName,
                UpgradeKey = upgradeKey,
                Data = upgradeData,
                Order = upgradeData.Order or 0
            })
        end
    end

    -- Urutkan upgrade di dalam tiap currency berdasarkan Order
    for currency, list in pairs(grouped) do
        table.sort(list, function(a, b)
            return a.Order < b.Order
        end)
    end

    -- Susun daftar currency sesuai urutan yang diinginkan
    local sortedCurrencies = {}
    for _, currency in ipairs(currencyOrder) do
        if grouped[currency] then
            table.insert(sortedCurrencies, currency)
        end
    end

    -- Tambahkan currency yang tidak ada di currencyOrder (fallback)
    for currency in pairs(grouped) do
        if not table.find(currencyOrder, currency) then
            table.insert(sortedCurrencies, currency)
        end
    end

    -- Jika masih ada yang belum terurut, urutkan berdasarkan posisi di currencyOrder
    table.sort(sortedCurrencies, function(a, b)
        local ia = table.find(currencyOrder, a) or math.huge
        local ib = table.find(currencyOrder, b) or math.huge
        if ia == ib then
            return a < b
        end
        return ia < ib
    end)

    return grouped, sortedCurrencies
end
local groupSize = 2
local currentGroup = nil
local countInGroup = 0
local currentGroupCategory = nil

local groupedByCurrency, sortedCurrencies = GetSortedUpgradesByCurrency(UpgradeConfig)
local v_u_25 = {
    ["Bubble"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://134897736649093",
        ["SignTextGradientStart"] = nil,
        ["BoardColor"] = Color3.fromRGB(0, 255, 255),
        ["TemplateStroke"] = Color3.fromRGB(0, 100, 200),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(0, 77, 89), Color3.fromRGB(0, 36, 36)),
        ["TextGradientStart"] = Color3.fromRGB(119, 248, 255),
        ["NameGradientStart"] = Color3.fromRGB(0, 170, 255),
        ["NameStroke"] = Color3.fromRGB(0, 45, 110),
        ["SignTextGradientStart"] = Color3.fromRGB(0, 153, 255)
    },
    ["Rebirth"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://77855012263464",
        ["SignTextGradientStart"] = nil,
        ["BoardColor"] = Color3.fromRGB(255, 85, 85),
        ["TemplateStroke"] = Color3.fromRGB(200, 50, 50),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(40, 10, 10), Color3.fromRGB(20, 0, 0)),
        ["TextGradientStart"] = Color3.fromRGB(255, 100, 100),
        ["NameGradientStart"] = Color3.fromRGB(255, 124, 126),
        ["NameStroke"] = Color3.fromRGB(100, 15, 15),
        ["SignTextGradientStart"] = Color3.fromRGB(255, 29, 29)
    },
    ["Pearl"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://123485270163655",
        ["SignTextGradientStart"] = nil,
        ["BoardColor"] = Color3.fromRGB(255, 170, 255),
        ["TemplateStroke"] = Color3.fromRGB(200, 100, 200),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(30, 10, 30), Color3.fromRGB(15, 0, 15)),
        ["TextGradientStart"] = Color3.fromRGB(255, 150, 255),
        ["NameGradientStart"] = Color3.fromRGB(255, 67, 180),
        ["NameStroke"] = Color3.fromRGB(100, 10, 60),
        ["SignTextGradientStart"] = Color3.fromRGB(243, 82, 255)
    },
    ["Gems"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://99134347373347",
        ["SignTextGradientStart"] = nil,
        ["BoardColor"] = Color3.fromRGB(255, 0, 255),
        ["TemplateStroke"] = Color3.fromRGB(141, 22, 139),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(115, 0, 84), Color3.fromRGB(65, 0, 46)),
        ["TextGradientStart"] = Color3.fromRGB(255, 0, 195),
        ["NameGradientStart"] = Color3.fromRGB(255, 0, 255),
        ["NameStroke"] = Color3.fromRGB(70, 0, 70),
        ["SignTextGradientStart"] = Color3.fromRGB(255, 0, 195)
    },
    ["Token"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://93522116426480",
        ["SignTextGradientStart"] = nil,
        ["BoardColor"] = Color3.fromRGB(255, 215, 0),
        ["TemplateStroke"] = Color3.fromRGB(180, 150, 0),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(90, 75, 0), Color3.fromRGB(45, 35, 0)),
        ["TextGradientStart"] = Color3.fromRGB(255, 235, 100),
        ["NameGradientStart"] = Color3.fromRGB(255, 225, 0),
        ["NameStroke"] = Color3.fromRGB(120, 100, 0),
        ["SignTextGradientStart"] = Color3.fromRGB(255, 215, 0)
    },
    ["Token2"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://93522116426480",
        ["SignTextGradientStart"] = nil,
        ["BoardColor"] = Color3.fromRGB(255, 215, 0),
        ["TemplateStroke"] = Color3.fromRGB(180, 150, 0),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(90, 75, 0), Color3.fromRGB(45, 35, 0)),
        ["TextGradientStart"] = Color3.fromRGB(255, 235, 100),
        ["NameGradientStart"] = Color3.fromRGB(255, 225, 0),
        ["NameStroke"] = Color3.fromRGB(120, 100, 0),
        ["SignTextGradientStart"] = Color3.fromRGB(255, 215, 0)
    },
    ["QuestPoint"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://81321001337471",
        ["SignTextGradientStart"] = nil,
        ["BoardColor"] = Color3.fromRGB(255, 179, 0),
        ["TemplateStroke"] = Color3.fromRGB(200, 156, 44),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(180, 40, 0), Color3.fromRGB(60, 10, 0)),
        ["TextGradientStart"] = Color3.fromRGB(255, 241, 92),
        ["NameGradientStart"] = Color3.fromRGB(255, 85, 0),
        ["NameStroke"] = Color3.fromRGB(102, 34, 0),
        ["SignTextGradientStart"] = Color3.fromRGB(255, 85, 0)
    },
    ["AncientBubble"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://93058066960794",
        ["SignTextGradientStart"] = nil,
        ["SignTitle"] = "Ancient Bubble Upgrades",
        ["BoardColor"] = Color3.fromRGB(0, 255, 204),
        ["TemplateStroke"] = Color3.fromRGB(0, 153, 122),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(0, 51, 41), Color3.fromRGB(0, 20, 16)),
        ["TextGradientStart"] = Color3.fromRGB(153, 255, 230),
        ["NameGradientStart"] = Color3.fromRGB(0, 255, 204),
        ["NameStroke"] = Color3.fromRGB(0, 76, 61),
        ["SignTextGradientStart"] = Color3.fromRGB(0, 255, 204)
    },
    ["AncientPearl"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://104612017437892",
        ["SignTextGradientStart"] = nil,
        ["SignTitle"] = "Ancient Pearl Upgrades",
        ["BoardColor"] = Color3.fromRGB(166, 0, 255),
        ["TemplateStroke"] = Color3.fromRGB(100, 0, 153),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(33, 0, 51), Color3.fromRGB(10, 0, 15)),
        ["TextGradientStart"] = Color3.fromRGB(217, 128, 255),
        ["NameGradientStart"] = Color3.fromRGB(187, 51, 255),
        ["NameStroke"] = Color3.fromRGB(51, 0, 76),
        ["SignTextGradientStart"] = Color3.fromRGB(187, 51, 255)
    },
    ["World1Infinity"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://93423747597464",
        ["SignTextGradientStart"] = nil,
        ["SignTitle"] = "World 1 Infinity",
        ["BoardColor"] = Color3.fromRGB(200, 255, 255),
        ["TemplateStroke"] = Color3.fromRGB(0, 150, 255),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(0, 50, 80), Color3.fromRGB(0, 20, 40)),
        ["TextGradientStart"] = Color3.fromRGB(255, 255, 255),
        ["NameGradientStart"] = Color3.fromRGB(150, 255, 255),
        ["NameStroke"] = Color3.fromRGB(0, 50, 100),
        ["SignTextGradientStart"] = Color3.fromRGB(150, 255, 255)
    },
    ["World2Infinity"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://93423747597464",
        ["SignTextGradientStart"] = nil,
        ["SignTitle"] = "World 2 Infinity",
        ["BoardColor"] = Color3.fromRGB(255, 200, 255),
        ["TemplateStroke"] = Color3.fromRGB(200, 0, 150),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(80, 0, 50), Color3.fromRGB(40, 0, 20)),
        ["TextGradientStart"] = Color3.fromRGB(255, 255, 255),
        ["NameGradientStart"] = Color3.fromRGB(255, 150, 255),
        ["NameStroke"] = Color3.fromRGB(100, 0, 50),
        ["SignTextGradientStart"] = Color3.fromRGB(255, 150, 255)
    },
    ["World3Infinity"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://93423747597464",
        ["SignTextGradientStart"] = nil,
        ["SignTitle"] = "World 3 Infinity",
        ["BoardColor"] = Color3.fromRGB(255, 255, 200),
        ["TemplateStroke"] = Color3.fromRGB(200, 150, 0),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(80, 50, 0), Color3.fromRGB(40, 20, 0)),
        ["TextGradientStart"] = Color3.fromRGB(255, 255, 255),
        ["NameGradientStart"] = Color3.fromRGB(255, 255, 150),
        ["NameStroke"] = Color3.fromRGB(100, 50, 0),
        ["SignTextGradientStart"] = Color3.fromRGB(255, 255, 150)
    },
    ["World4Infinity"] = {
        ["BoardColor"] = nil,
        ["TemplateStroke"] = nil,
        ["TemplateGradient"] = nil,
        ["TextGradientStart"] = nil,
        ["NameGradientStart"] = nil,
        ["NameStroke"] = nil,
        ["SignIcon"] = "rbxassetid://93423747597464",
        ["SignTextGradientStart"] = nil,
        ["SignTitle"] = "World 4 Infinity",
        ["BoardColor"] = Color3.fromRGB(255, 225, 225),
        ["TemplateStroke"] = Color3.fromRGB(255, 50, 50),
        ["TemplateGradient"] = ColorSequence.new(Color3.fromRGB(70, 10, 15), Color3.fromRGB(30, 0, 5)),
        ["TextGradientStart"] = Color3.fromRGB(255, 255, 255),
        ["NameGradientStart"] = Color3.fromRGB(255, 85, 85),
        ["NameStroke"] = Color3.fromRGB(80, 0, 10),
        ["SignTextGradientStart"] = Color3.fromRGB(255, 85, 85)
    }
}
for _, currency in ipairs(sortedCurrencies) do
    local upgrades = groupedByCurrency[currency]

    for _, entry in ipairs(upgrades) do
        local categoryName = entry.CategoryName
        local upgradeKey = entry.UpgradeKey
        local Data = entry.Data

        -- Flag unik: gunakan category + upgradeKey agar tidak bentrok
        local flag = "AutoBoard_" .. categoryName .. "_" .. upgradeKey
        local targetCategory = Data.Currency

        if countInGroup % groupSize == 0 or currentGroupCategory ~= targetCategory then
            currentGroup = MainTabs:Group({})
            FM_Add(targetCategory, currentGroup)
            currentGroupCategory = targetCategory
            countInGroup = 0
        end

        local toggle = currentGroup:Toggle({
            Title = Data.Name,
            Image = Data.Icon,
            Flag = flag,
            Value = false,
            Callback = function(val)
                Config.Upgraders[flag] = val
                if val then
                    StartManagedLoop(flag, 1,
                        function()
                            return Config.Upgraders[flag] == true
                        end,
                        function()
                            local flagKey = "AutoBoard_" .. categoryName .. "_" .. upgradeKey

                            -- Ambil level saat ini
                            local level = DataServiceClient:get({ "Upgrades", categoryName, upgradeKey }) or 0

                            -- Jika sudah max, hentikan loop
                            if UpgradeUtil.IsMaxed(categoryName, upgradeKey, level) then
                                return
                            end

                            -- Ambil base price dari PlayerStatCache (string)
                            local basePriceStr = PlayerStatCache.GetStat(LocalPlayer, categoryName .. "UpgradePrice") or "1"
                            local basePriceNum = NumberUtil.FromString(basePriceStr)

                            -- Hitung cost untuk level berikutnya
                            local cost = UpgradeUtil.GetCostAtLevel(categoryName, upgradeKey, level, basePriceNum)

                            -- Ambil currency player
                            local currencyType = Data.Currency
                            local currencyAmountStr
                            if currencyType == "Token" then
                                currencyAmountStr = tostring(DataServiceClient:get("Token") or 0)
                            else
                                currencyAmountStr = DataServiceClient:get({ "Currency", currencyType }) or "0"
                            end

                            local currencyNum = NumberUtil.FromString(currencyAmountStr):round()

                            -- Jika cukup, beli 1x
                            if currencyNum:moreEquals(cost) then
                                UpgradeNetworker:fire("PurchaseUpgrade", categoryName, upgradeKey, "Max")
                            end
                        end
                    )
                else
                    StopManagedLoop(flag)
                end
            end
        })
        countInGroup = countInGroup + 1
        -- === FUNGSI UPDATE DESKRIPSI ===
        local function UpdateDescription()
            -- Ambil level saat ini
            local level = DataServiceClient:get({ "Upgrades", categoryName, upgradeKey }) or 0
            SafeSetTitle(toggle,string.format("%s (%s/%s)",GradientTag(v_u_25[categoryName].TextGradientStart,Data.Name),level,Data.MaxLevel))

            -- Ambil base price dari PlayerStatCache, lalu konversi ke NumberUtil
            local basePriceStr = PlayerStatCache.GetStat(LocalPlayer, categoryName .. "UpgradePrice") or "1"
            local basePriceNum = NumberUtil.FromString(basePriceStr)

            -- Hitung biaya & efek
            local cost = UpgradeUtil.GetCostAtLevel(categoryName, upgradeKey, level, basePriceNum)
            local effect = UpgradeUtil.GetEffectAtLevel(categoryName, upgradeKey, level)

            -- Cek tipe multiplier
            local isMult = UpgradeUtil.GetModifierType(categoryName, upgradeKey) == "Multiplier"

            -- Format deskripsi
            local costStr = cost:toString("suffix")
            local effectStr = FormatBoardEffect(effect, isMult)

            SafeSetDesc(toggle, string.format("%s\nCost: %s %s%s\nBoost: %s",Data.Description, costStr,Data.Currency,v_u_25[categoryName].SignIcon, effectStr))
        end

        -- Update setiap 1 detik selama window hidup
        StartStatusLoop(flag .. "_desc", 1, UpdateDescription)
    end
end
SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings-2" })
ConfigNameInput = SettingsTab:Input({
    Title = "<gradient=FF0080,7928CA>Load</gradient> Config Name",
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
FM_OnChange("Bubble")
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
