-- if game.PlaceId ~= 88887739603194 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Freedy Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FolderPath = "ANUI/FreedyIncremental"
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
    Title = "AN Hub - Freedy Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "FreedyIncremental",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Freedy Incremental" }),
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

-- [[ MAIN TAB ]] --
MainTabs = Window:Tab({
    Title = "Main Feature",
    Icon = "swords",
    SidebarProfile = false
});

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
-- ============================================================================
-- IMPORT MODULE
-- ============================================================================


local ConvertConfig = require(ReplicatedStorage.Configs.ConvertConfig)
local UpgradeTreeConfig = require(ReplicatedStorage.Configs.UpgradeTreeConfig)
local UpgradeConfig = require(ReplicatedStorage.Configs.UpgradeConfig)
local PrestigeConfig = require(ReplicatedStorage.Configs.PrestigeConfig)
local ProducerConfig = require(ReplicatedStorage.Configs.ProducerConfig)
local CurrencyConfig = require(ReplicatedStorage.Configs.CurrencyConfig)
local UpgradeFormulas = require(ReplicatedStorage.Modules.UpgradeFormulas)
local CurrencyReader = require(ReplicatedStorage.Modules.CurrencyReader)
local Notifications = require(ReplicatedStorage.Modules.Notifications)
local UpgradeEffects = require(ReplicatedStorage.Modules.UpgradeEffects)
local SettingsService = require(ReplicatedStorage.Modules.SettingsService)
local BigNumber = require(ReplicatedStorage.Modules.BigNumber)
local UpgradeTypes = require(ReplicatedStorage.Modules.UpgradeTypes)
local Events = ReplicatedStorage:WaitForChild("Events")
local UpgradeBuy = Events:WaitForChild("UpgradeBuy")
local UpgradeState = Events:WaitForChild("UpgradeState")
local ProducerState = Events:WaitForChild("ProducerState")
local UpgradeProducer = Events:WaitForChild("UpgradeProducer")
local UpgradeGet = Events:WaitForChild("UpgradeGet")
local PrestigeRemote = Events:WaitForChild("PrestigeRemote")
local PurchaseProducer = Events:WaitForChild("PurchaseProducer")
local RebirthRemote = Events:WaitForChild("RebirthRemote")
local UpgradeTreeBuy = Events:WaitForChild("UpgradeTreeBuy")
local ConvertRemote = Events:WaitForChild("ConvertRemote")
local UpgradeTreeState = Events:WaitForChild("UpgradeTreeState")

local DataFolder = LocalPlayer.Data
local PrestigeProgress = DataFolder.PrestigeProgress
local PrestigeLevel = DataFolder.PrestigeLevel
local PrestigeGoal = DataFolder.PrestigeGoal
-- ============================================================================
-- 1. TOMBOL KATEGORI (HORIZONTAL SCROLL)
-- ============================================================================
MainCategory = {}
BillboardUpgradeData = {}
-- =====================================================
-- 10. SETTINGS TAB
-- =====================================================
-- Terima data level upgrade dari server
AddConnection(UpgradeState.OnClientEvent:Connect(function(data)
    BillboardUpgradeData = data or {}
end))


-- Ambil data awal
task.spawn(function()
    for i = 1, 6 do
        if i > 1 then task.wait(math.min(i, 5)) end
        local ok, result = pcall(function()
            return UpgradeGet:InvokeServer()
        end)
        if ok and type(result) == "table" then
            BillboardUpgradeData = result
            break
        end
    end
end)

local function getCurrencyUpgrades(currencyId)
    return UpgradeConfig.Upgrades[currencyId] or {}
end

local function getUpgradeLevel(currencyId, upgradeId)
    local currencyData = BillboardUpgradeData[currencyId]
    if not currencyData then return 0 end
    local upgradeData = currencyData[upgradeId]
    if not upgradeData then return 0 end
    return upgradeData.level or 0
end

local function isUpgradeUnlocked(currencyId, upgradeId)
    local currencyData = BillboardUpgradeData[currencyId]
    if not currencyData then return false end
    local upgradeData = currencyData[upgradeId]
    if not upgradeData then return false end
    return upgradeData.unlocked == true
end

local function getCurrencyDisplayName(currencyId)
    local cfg = CurrencyConfig.Get(currencyId)
    return cfg and cfg.DisplayName or currencyId
end
-- =====================================================
-- AUTO UPGRADE BILLBOARD (per Currency)
-- =====================================================
local billboardToggles = {}      -- simpan toggle per currencyId
local billboardConfig = {}       -- simpan config per currencyId
local billboardGroup = nil
local billboardCountInGroup = 0
Categories = {
    Producer = {},
}
Options = {
    {
        Title = "Producer",
        Icon = GetIcon(84846334410641)
    },
    {
        Title = "Reset Layers",
        Icon = GetIcon(84846334410641)
    }
}

for _, id in ipairs(CurrencyConfig.List) do
    if id == "Currency7" then continue end
    Categories[getCurrencyDisplayName(id) .. " Upgrade"] = {}
    table.insert(Options, {
        Title = getCurrencyDisplayName(id) .. " Upgrade",
        Icon = CurrencyConfig.Get(id).ImageAssetId
    })
end
local function getAvailableCurrencies()
    local currencies = {}
    for _, model in ipairs(workspace:GetChildren()) do
        if model:IsA("Model") and model.Name == "CurrencyBillboardPart" then
            local currencyId = model:GetAttribute("CurrencyId")
            if currencyId and CurrencyConfig.Exists(currencyId) then
                table.insert(currencies, currencyId)
            end
        end
    end
    return currencies
end
FM_CategoryDescriptions = {}
function FM_GetElementFrame(elem)
    return rawget(elem, "ElementFrame") or elem.UIElements and elem.UIElements.Main or rawget(elem, "GroupFrame")
end
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

FM_CategorySelector = MainTabs:Category({
    Default = "Producer",
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
local availableCurrencies = getAvailableCurrencies()
for _, currencyId in ipairs(availableCurrencies) do
    local displayName = getCurrencyDisplayName(currencyId)
    local upgrades = getCurrencyUpgrades(currencyId)
    local currentGroup = nil
    local countInGroup = 0

    for _, upgrade in ipairs(upgrades) do
        if countInGroup % 2 == 0 then
            currentGroup = MainTabs:Group({})
            FM_Add(displayName .. " Upgrade", currentGroup)
        end

        local toggle = currentGroup:Toggle({
            Title = upgrade.name,
            Image = upgrade.image,
            Flag = upgrade.name .. upgrade.id,
            Callback = function(val)
                if val then
                    StartManagedLoop("AutoUpg_" .. currencyId .. "_" .. upgrade.id, 0.5, function()
                        return true
                    end, function()
                        if not isUpgradeUnlocked(currencyId, upgrade.id) then return end
                        local lvl = getUpgradeLevel(currencyId, upgrade.id)
                        local maxLevel = upgrade.maxLevel and upgrade.maxLevel > 0 and upgrade.maxLevel or math.huge
                        if lvl >= maxLevel then return end
                        local currencyAmount = CurrencyReader.Get(LocalPlayer, currencyId)
                        local price = UpgradeFormulas.Price(upgrade, lvl)
                        if price <= currencyAmount then
                            pcall(function()
                                UpgradeBuy:FireServer(currencyId, upgrade.id, "max")
                            end)
                        end
                    end)
                else
                    StopManagedLoop("AutoUpg_" .. currencyId .. "_" .. upgrade.id)
                end
            end
        })
        -- FM_Add(displayName, toggle)
        billboardToggles[currencyId .. "_" .. upgrade.id] = toggle
        countInGroup = countInGroup + 1
    end
end

StartStatusLoop("Status_AutoBillboard", 1, function()
    for key, toggle in pairs(billboardToggles) do
        local currencyId, upgradeId = key:match("^(.-)_(.*)$")
        if not currencyId or not upgradeId then continue end

        -- Cek status unlock
        local unlocked = isUpgradeUnlocked(currencyId, upgradeId)
        if not unlocked then
            toggle:Lock("Locked")
        elseif toggle.Locked then
            toggle:Unlock()
        else
        end

        -- Lanjutkan update normal jika unlocked
        local upgrades = getCurrencyUpgrades(currencyId)
        local upgrade = nil
        for _, upg in ipairs(upgrades) do
            if upg.id == upgradeId then upgrade = upg break end
        end
        if not upgrade then continue end
        local displayName = getCurrencyDisplayName(currencyId)
        local level = getUpgradeLevel(currencyId, upgradeId)
        local maxLevel = upgrade.maxLevel and upgrade.maxLevel > 0 and upgrade.maxLevel or math.huge
        local currencyAmount = CurrencyReader.Get(LocalPlayer, currencyId)
        local price = UpgradeFormulas.Price(upgrade, level)
        local canAfford = price <= currencyAmount
        local isMax = level >= maxLevel
        local Descupgrade = string.format("%s%s",upgrade.desc,"\n" .. (upgrade.optionalDesc or ""))
        local DescCur = ""

        local title = string.format("%s (%d/%s)",upgrade.name,level, maxLevel)

        -- 🆕 Hitung multiplier saat ini dan berikutnya (seperti client fmtVal)
        local function fmtVal(upg, lvl)
            local val = UpgradeFormulas.Value(upg, lvl)
            local displayType = UpgradeEffects[upg.type] and UpgradeEffects[upg.type].display
            if displayType == "seconds" then
                local s = string.format("%.1f", val):gsub("0+$", ""):gsub("%.$", "")
                return "-" .. s .. " sec"
            elseif displayType == "multiplier" then
                local s = string.format("%.2f", UpgradeFormulas.Multiplier(upg, lvl)):gsub("0+$", ""):gsub("%.$", "")
                return s .. "x"
            else
                return string.format("+%d%%", math.floor(val * 100 + 0.5))
            end
        end

        local currentMultiplier = fmtVal(upgrade, level)
        local nextMultiplier = nil
        if not isMax then
            nextMultiplier = fmtVal(upgrade, level + 1)
        end

        local descLines = {}
        table.insert(descLines, Descupgrade)
        if not isMax then
            local priceStr = price:ToString()
            local currencyAmountStr = currencyAmount:ToString()
            if priceStr:len() > 12 then priceStr = priceStr:sub(1,12).."..." end
            if currencyAmountStr:len() > 12 then currencyAmountStr = currencyAmountStr:sub(1,12).."..." end
            if canAfford then
                DescCur = string.format('%s<font color="#00ff00">%s/%s</font>',CurrencyConfig.Get(currencyId).ImageAssetId,currencyAmountStr,priceStr)
            else
                DescCur = string.format('%s<font color="#ff0000">%s/%s</font>',CurrencyConfig.Get(currencyId).ImageAssetId,currencyAmountStr,priceStr)
            end
            table.insert(descLines, DescCur)
            table.insert(descLines, string.format("Boost: %s → %s", currentMultiplier, nextMultiplier))
        else
            table.insert(descLines, string.format("Boost: %s", currentMultiplier))
        end
        SafeSetTitle(toggle, title)
        SafeSetDesc(toggle, table.concat(descLines, "\n"))
    end
end)
Config.AutoProducer = {
    Enabled = false,
    Interval = 1  -- cek setiap 1 detik
}
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

local ProducerData = {}  -- menyimpan data terbaru semua producer
AddConnection(ProducerState.OnClientEvent:Connect(function(data)
    ProducerData[data.order] = data
end))

-- =====================================================
-- AUTO UPGRADE PRODUCER
-- =====================================================
local autoProducerToggle = MainTabs:Toggle({
    Title = "Auto Upgrade Producer",
    Flag = "AutoProducer_Enabled",
    Callback = function(val)
        Config.AutoProducer.Enabled = val
        if val then
            StartManagedLoop("AutoProducer", Config.AutoProducer.Interval, function()
                return Config.AutoProducer.Enabled
            end, function()
                -- Ambil jumlah Pizza (Currency1)
                local pizzaAmount = CurrencyReader.Get(LocalPlayer, "Currency1")
                if not pizzaAmount then return end

                -- Iterasi semua producer yang datanya sudah diterima
                for order, data in pairs(ProducerData) do
                    if data.upgradeCost then
                        local cost = data.upgradeCost
                        if type(cost) == "table" then
                            cost = BigNumber.Unpack(cost)
                        else
                            cost = BigNumber.fromNumber(cost or 0)
                        end
                        if cost <= pizzaAmount then
                            pcall(function()
                                UpgradeProducer:FireServer(order, "max")
                            end)
                        end
                    end
                end
            end)
        else
            StopManagedLoop("AutoProducer")
        end
    end
})
FM_Add("Producer", autoProducerToggle)
StartStatusLoop("Status_AutoProducer", 1, function()
    if not autoProducerToggle then return end

    local pizzaAmount = CurrencyReader.Get(LocalPlayer, "Currency1")
    local totalProducers = 0
    local affordableCount = 0
    local totalIncomePerTick = BigNumber.fromNumber(0)
    local Description = ""

    for _, data in pairs(ProducerData) do
        totalProducers = totalProducers + 1

        -- Hitung affordable
        if data.upgradeCost then
            local cost = data.upgradeCost
            if type(cost) == "table" then
                cost = BigNumber.Unpack(cost)
            else
                cost = BigNumber.fromNumber(cost or 0)
            end
            if cost <= pizzaAmount then
                affordableCount = affordableCount + 1
            end
        end

        -- Akumulasi income per tick
        if data.income then
            local inc = data.income
            local incBN
            if type(inc) == "table" then
                incBN = BigNumber.Unpack(inc)
            else
                incBN = BigNumber.fromNumber(inc or 0)
            end
            Description = string.format("%s%s Level %s +%s/tick\n",Description,ProducerConfig.Order[data.order],data.level,incBN:ToString())
        end
    end
    local pizzaStr = pizzaAmount and pizzaAmount:ToString() or "0"
    if pizzaStr:len() > 12 then pizzaStr = pizzaStr:sub(1,12) .. "..." end
    local desc = string.format(
        "%s%sPizza: %s\nAffordable: %d/%d",Description,CurrencyConfig.Get("Currency1").ImageAssetId,
        pizzaStr, affordableCount, totalProducers
    )
    SafeSetDesc(autoProducerToggle, desc)
end)
Config.AutoPurchaseProducer = {
    Enabled = false,
    Interval = 1  -- cek setiap 2 detik
}
-- =====================================================
-- AUTO PURCHASE PRODUCER (Producer)
-- =====================================================
local autoPurchaseProducerToggle = MainTabs:Toggle({
    Title = "Auto Buy Producer",
    Flag = "AutoPurchaseProducer_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoPurchaseProducer.Enabled = val
        if val then
            StartManagedLoop("AutoPurchaseProducer", Config.AutoPurchaseProducer.Interval, function()
                return Config.AutoPurchaseProducer.Enabled
            end, function()
                local owned = LocalPlayer:GetAttribute("ProducerOwnedCount") or 0
                local nextOrder = owned + 1
                -- Pastikan masih ada producer yang bisa dibeli
                if not ProducerConfig.Order[nextOrder] then return end

                local cost = ProducerConfig.UnlockCost(nextOrder)
                if not cost then return end  -- seharusnya tidak terjadi

                local pizzaAmount = CurrencyReader.Get(LocalPlayer, "Currency1")
                if pizzaAmount and cost <= pizzaAmount then
                    pcall(function()
                        PurchaseProducer:FireServer(nextOrder)
                    end)
                end
            end)
        else
            StopManagedLoop("AutoPurchaseProducer")
        end
    end
})
FM_Add("Producer", autoPurchaseProducerToggle)
StartStatusLoop("Status_AutoPurchaseProducer", 1, function()
    if not autoPurchaseProducerToggle then return end

    local owned = LocalPlayer:GetAttribute("ProducerOwnedCount") or 0
    local nextOrder = owned + 1
    local maxProducers = ProducerConfig.Count or 0
    local pizzaAmount = CurrencyReader.Get(LocalPlayer, "Currency1")
    local pizzaStr = pizzaAmount and pizzaAmount:ToString() or "0"
    if pizzaStr:len() > 12 then pizzaStr = pizzaStr:sub(1,12) .. "..." end

    if not ProducerConfig.Order[nextOrder] then
        SafeSetDesc(autoPurchaseProducerToggle, "All producers purchased!")
        return
    end

    local cost = ProducerConfig.UnlockCost(nextOrder)
    -- Objek BigNumber, gunakan metodenya langsung
    local costStr = cost and (cost:IsPositive() and cost:ToString() or "FREE") or "???"
    if costStr:len() > 12 then costStr = costStr:sub(1,12) .. "..." end
    local canBuy = cost and cost <= pizzaAmount

    local desc = string.format(
        "Owned: %d/%d\nNext: %s %s\n%sPizza: %s",
        owned, maxProducers,
        ProducerConfig.Order[nextOrder] or "???",
        costStr,CurrencyConfig.Get("Currency1").ImageAssetId,
        pizzaStr
    )
    SafeSetDesc(autoPurchaseProducerToggle, desc)
end)

Config.AutoPrestige = {
    Enabled = false,
    Interval = 2  -- cek setiap 2 detik
}
-- =====================================================
-- AUTO PRESTIGE (Producer)
-- =====================================================
local autoPrestigeToggle = MainTabs:Toggle({
    Title = "Auto Prestige",
    Image = GetIcon(106947873185915),
    Flag = "AutoPrestige_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoPrestige.Enabled = val
        if val then
            StartManagedLoop("AutoPrestige", Config.AutoPrestige.Interval, function()
                return Config.AutoPrestige.Enabled
            end, function()
                if not PrestigeProgress or not PrestigeLevel then return end
                local progress = PrestigeProgress.Value
                local level = PrestigeLevel.Value or 1
                local maxLevel = PrestigeConfig.MaxLevel
                if level >= maxLevel then return end
                if progress and progress >= 1 then
                    pcall(function()
                        PrestigeRemote:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoPrestige")
        end
    end
})
FM_Add("Reset Layers", autoPrestigeToggle)
StartStatusLoop("Status_AutoPrestige", 1, function()
    local level = PrestigeLevel.Value or 1
    local maxLevel = PrestigeConfig.MaxLevel
    local isMax = level >= maxLevel
    local progress = PrestigeProgress.Value or 0
    local goalText = "?"
    if PrestigeGoal and PrestigeGoal.Value then
        goalText = PrestigeGoal.Value
    elseif PrestigeConfig.Goal then
        goalText = PrestigeConfig.Goal(level + 1):ToString()
    end

    if isMax then
        SafeSetDesc(autoPrestigeToggle, "Max Prestige reached!")
        return
    end

    local progressPercent = math.floor(progress * 100)
    local desc = string.format(
        "Prestige %d → %d\nProgress: %d%%\nReq: %s %s",
        level, level + 1,
        progressPercent,
        goalText,
        PrestigeConfig.Label or ""
    )
    SafeSetDesc(autoPrestigeToggle, desc)
end)
Config.AutoRebirth = {
    Enabled = false,
    Interval = 2
}
-- =====================================================
-- AUTO REBIRTH (Producer)
-- =====================================================
local autoRebirthToggle = MainTabs:Toggle({
    Title = "Rebirth",
    Image = GetIcon(106972850120558),
    Flag = "AutoRebirth_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoRebirth.Enabled = val
        if val then
            StartManagedLoop("AutoRebirth", Config.AutoRebirth.Interval, function()
                return Config.AutoRebirth.Enabled
            end, function()
                local pizzaAmount = CurrencyReader.Get(LocalPlayer, "Currency1")
                local rebirthCost = BigNumber.new(1, 4)  -- 10,000 Pizza
                if pizzaAmount and pizzaAmount >= rebirthCost then
                    pcall(function()
                        RebirthRemote:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoRebirth")
        end
    end
})
FM_Add("Reset Layers", autoRebirthToggle)

StartStatusLoop("Status_AutoRebirth", 1, function()
    if not autoRebirthToggle then return end

    local pizzaAmount = CurrencyReader.Get(LocalPlayer, "Currency1")
    local rebirthCost = BigNumber.new(1, 4)  -- 10,000 Pizza
    local rebirthAmount = CurrencyReader.Get(LocalPlayer, "Currency2")
    
    local pizzaStr = pizzaAmount and pizzaAmount:ToString() or "0"
    if pizzaStr:len() > 12 then pizzaStr = pizzaStr:sub(1, 12) .. "..." end
    
    local rebirthStr = rebirthAmount and rebirthAmount:ToString() or "0"
    if rebirthStr:len() > 12 then rebirthStr = rebirthStr:sub(1, 12) .. "..." end

    local canRebirth = pizzaAmount and pizzaAmount >= rebirthCost
    local gainRebirth = pizzaAmount and (pizzaAmount / rebirthCost):ToString(0) or "0"
    local PizzaImage = CurrencyConfig.Get("Currency1").ImageAssetId

    local desc = string.format(
        "%s Pizza: %s\n%sRebirth: %s\nCost: 10,000 %sPizza\nGain: +%s %sRebirth",
        PizzaImage,pizzaStr,GetIcon(106972850120558),
        rebirthStr,
        PizzaImage,
        gainRebirth,GetIcon(106972850120558)
    )
    SafeSetDesc(autoRebirthToggle, desc)
end)

Config.AutoUpgradeTree = {
    Enabled = false,
    Interval = 0.5  -- cek setiap 1 detik
}
-- Ambil data tree dengan retry agresif
local TreeData = {}

-- Coba ambil dari memori dulu (sekali)
local function tryGetTreeDataFromMemory()
    -- for _, v in pairs(getgc(true)) do
    --     if type(v) == "table" then
    --         for treeName, treeData in pairs(v) do
    --             if type(treeData) == "table" and treeData.nodes and treeData.currency ~= nil then
    --                 return v
    --             end
    --         end
    --     end
    -- end
    return nil
end


-- Setelah itu, dengarkan perubahan dari server
AddConnection(UpgradeTreeState.OnClientEvent:Connect(function(data)
    TreeData = data or {}
end))
-- =====================================================
-- AUTO UPGRADE TREE (Producer)
-- =====================================================
local autoTreeToggle = MainTabs:Toggle({
    Title = "Upgrade Tree",
    Image = GetIcon(123931345240300),
    Flag = "AutoUpgradeTree_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoUpgradeTree.Enabled = val
        if val then
            StartManagedLoop("AutoUpgradeTree", Config.AutoUpgradeTree.Interval, function()
                return Config.AutoUpgradeTree.Enabled
            end, function()
                -- Jika data masih kosong, coba sekali lagi dari memori (opsional)
                if not next(TreeData) then
                    local mem = tryGetTreeDataFromMemory()
                    if mem then TreeData = mem end
                end
                if not next(TreeData) then return end

                for treeName, skills in pairs(UpgradeTreeConfig.Order or {}) do
                    local treeState = TreeData[treeName]
                    if treeState and treeState.available then
                        local currencyId = treeState.currency
                        local currencyAmount = CurrencyReader.Get(LocalPlayer, currencyId)
                        if not currencyAmount then continue end

                        for _, skillData in ipairs(skills) do
                            local skillId = skillData.id
                            local nodeState = treeState.nodes and treeState.nodes[skillId]
                            if nodeState and nodeState.unlocked and not nodeState.maxed then
                                local costBN
                                if nodeState.cost then
                                    costBN = BigNumber.new(nodeState.cost.m, nodeState.cost.e)
                                else
                                    local cfgCost = skillData.cost
                                    if cfgCost then
                                        if cfgCost.m then
                                            costBN = BigNumber.new(cfgCost.m, cfgCost.e)
                                        elseif type(cfgCost) == "table" and #cfgCost > 0 then
                                            local lvl = math.min((nodeState.level or 0) + 1, #cfgCost)
                                            costBN = BigNumber.fromNumber(cfgCost[lvl])
                                        end
                                    end
                                end
                                if costBN and costBN <= currencyAmount then
                                    pcall(function()
                                        UpgradeTreeBuy:FireServer(treeName, skillId)
                                    end)
                                end
                            end
                        end
                    end
                end
            end)
        else
            StopManagedLoop("AutoUpgradeTree")
        end
    end
})
FM_Add("Producer", autoTreeToggle)

StartStatusLoop("Status_AutoUpgradeTree", 1, function()
    if not autoTreeToggle then return end
    if not next(TreeData) then
        SafeSetDesc(autoTreeToggle, "Waiting for tree data...\n(Requires Prestige?)")
        return
    end

    local totalSkills = 0
    local affordableCount = 0
    local activeTree = nil
    local activeCurrency = nil
    local activeCurrencyAmount = nil

    for treeName, skills in pairs(UpgradeTreeConfig.Order or {}) do
        local treeState = TreeData[treeName]
        if treeState and treeState.available then
            activeTree = treeName
            activeCurrency = treeState.currency
            activeCurrencyAmount = CurrencyReader.Get(LocalPlayer, activeCurrency)
            local nodes = treeState.nodes or {}
            for _, skillData in ipairs(skills) do
                local skillId = skillData.id
                local nodeState = nodes[skillId]
                if nodeState and nodeState.unlocked then
                    totalSkills = totalSkills + 1
                    if not nodeState.maxed then
                        local costBN
                        if nodeState.cost then
                            costBN = BigNumber.new(nodeState.cost.m, nodeState.cost.e)
                        else
                            local cfgCost = skillData.cost
                            if cfgCost then
                                if cfgCost.m then
                                    costBN = BigNumber.new(cfgCost.m, cfgCost.e)
                                elseif type(cfgCost) == "table" and #cfgCost > 0 then
                                    local lvl = math.min((nodeState.level or 0) + 1, #cfgCost)
                                    costBN = BigNumber.fromNumber(cfgCost[lvl])
                                end
                            end
                        end
                        if costBN and activeCurrencyAmount and costBN <= activeCurrencyAmount then
                            affordableCount = affordableCount + 1
                        end
                    end
                end
            end
        end
    end

    if not activeTree then
        SafeSetDesc(autoTreeToggle, "No active tree available")
        return
    end

    local currencyStr = activeCurrencyAmount and activeCurrencyAmount:ToString() or "0"
    if currencyStr:len() > 12 then currencyStr = currencyStr:sub(1,12).."..." end

    SafeSetDesc(autoTreeToggle, string.format(
        "Affordable: %d/%d skills",affordableCount, totalSkills))
end)
-- =====================================================
-- AUTO CONVERT PHANTOM (Producer)
-- =====================================================
local autoConvertPhantomToggle = MainTabs:Toggle({
    Title = "Convert Phantom",
    Image = GetIcon(90029295839079),
    Flag = "AutoConvertPhantom_Enabled",
    Value = false,
    Callback = function(val)
        Config.AutoConvertPhantom = val
        if val then
            StartManagedLoop("AutoConvertPhantom", 2, function()
                return Config.AutoConvertPhantom
            end, function()
                local shadowAmount = CurrencyReader.Get(LocalPlayer, "Currency4")
                local costPer = BigNumber.new(4.203, 4) -- 42,030 Shadow
                if shadowAmount and shadowAmount >= costPer then
                    pcall(function()
                        ConvertRemote:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoConvertPhantom")
        end
    end
})
FM_Add("Reset Layers", autoConvertPhantomToggle)

StartStatusLoop("Status_AutoConvertPhantom", 1, function()
    if not autoConvertPhantomToggle then return end

    local shadowAmount = CurrencyReader.Get(LocalPlayer, "Currency4")
    local phantomAmount = CurrencyReader.Get(LocalPlayer, "Currency5")
    local costPer = BigNumber.new(4.203, 4)
    local canConvert = shadowAmount and shadowAmount >= costPer
    local phantomMulti = 1
    local dataFolder = LocalPlayer:FindFirstChild("Data")
    if dataFolder then
        local pm = dataFolder:FindFirstChild("PhantomMulti")
        if pm then phantomMulti = pm.Value or 1 end
    end
    local gain = shadowAmount and (shadowAmount / costPer * BigNumber.fromNumber(phantomMulti)):ToString(0) or "0"

    local desc = string.format(
        "%sShadow: %s\n%sPhantom: %s\nCost: 42.03K %sShadow\nGain: +%s %sPhantom",
        GetIcon(101789141410290),
        shadowAmount and shadowAmount:ToString() or "0",
        GetIcon(90029295839079),
        phantomAmount and phantomAmount:ToString() or "0",
        GetIcon(101789141410290),
        gain,
        GetIcon(90029295839079)
    )
    SafeSetDesc(autoConvertPhantomToggle, desc)
end)
-- =====================================================
-- 10. SETTINGS TAB
-- =====================================================

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
FM_OnChange("Producer")
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
    DisconnectAll()
end)
