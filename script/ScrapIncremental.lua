-- if game.PlaceId ~= 122821966131621 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Scrap Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local character = LocalPlayer.Character
local rootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
humanoid.WalkSpeed = 30  -- nilai default biasanya 16

local FolderPath = "ANUI/ScrapIncremental"
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
    Title = "AN Hub - Scrap Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "ScrapIncremental",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Scrap Incremental" }),
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

local function Color3ToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
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

local Modules = {}
local Remotes = {}
local upgradeSuffixes = {
    "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No",
    "De", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd",
    "Nod", "Vg", "Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg",
    "Spvg", "Tg", "Utg", "Dtg", "Qatg", "Qitg", "Sxtg", "Octg", "Notg"
}

local function upgradeScale(def, level)
    if def.Type == "BoolUnlock" then
        return level >= 1 and def.UnlockValue or def.Base
    elseif def.Type == "Power" then
        return def.Base * def.Scale ^ level
    elseif def.Type == "Add" then
        return def.Base + def.PerLevel * level
    elseif def.Type == "Subtract" then
        local v = def.Base - def.PerLevel * level
        if def.Min then v = math.max(v, def.Min) end
        return v
    else
        return def.Base
    end
end

local function formatUpgradeNumber(n)
    n = tonumber(n) or 0
    if math.abs(n) < 1000 then return tostring(math.floor(n)) end
    local abs = math.abs(n)
    local idx = math.floor(math.log10(abs) / 3)
    if idx < 1 then idx = 1 end
    local suffix = upgradeSuffixes[idx+1] or ("e" .. idx * 3)
    local scaled = n / 10^(idx * 3)
    return string.format("%.2f%s", scaled, suffix)
end
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
task.spawn(function()
    requireModule(ReplicatedStorage.Config,Modules)
    requireRemote(ReplicatedStorage.Remotes,Remotes)
end)
local UpgradeConfig = Modules.UpgradeConfig
local RebirthConfig = Modules.RebirthConfig
local BuyUpgrade = Remotes.BuyUpgrade

local containers = {
    LocalPlayer:FindFirstChild("Currencies",true),
    LocalPlayer:FindFirstChild("Currencies2",true),
}

local DataCurrency = {} -- tabel untuk menampung Frame

for _, container in ipairs(containers) do
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("Frame") then
            DataCurrency[child.Name] = child
        end
    end
end
Options = {}
local function GetIconCurrency(Currency)
    if Currency == "Gems" then return GetIcon(107554268215169) end
    return DataCurrency[Currency].Image.Image
end
-- [[ MAIN TAB ]] --
MainTabs = Window:Tab({
    Title = "Main Feature",
    Icon = "swords",
    SidebarProfile = false
});

-- Urutan currency sesuai keinginan (sesuaikan jika perlu)
local currencyOrder = {
    "Currency_Scrap",
    "Currency_Battery",
    "Currency_FusionParts",
    "Currency_XPStars",
    "Currency_Parts",
    "Currency_Circuits",
    "Currency_TimeTokens",
    "Currency_Flux",
    "Currency_Cash",
    "Currency_Junk",
    "Currency_Evolutions",
    "Currency_Gems",
}

local function getCurrencyOrder(currency)
    for i, c in ipairs(currencyOrder) do
        if c == currency then return i end
    end
    return #currencyOrder + 1
end
for i, c in ipairs(currencyOrder) do
    Names = c:gsub("Currency_", "")
    table.insert(Options,
        {
            Title = Names,
            Icon = GetIconCurrency(Names)
        })
end
FM_CategorySelector = MainTabs:Category({
    Default = "Scrap",
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
-- AUTO FUSION (Scrap → Fusion Parts)
-- =====================================================
local FusionRemote = Remotes.RequestFusion

local function getPendingFusionParts()
    local scrap = LocalPlayer:GetAttribute("Currency_Scrap")
    scrap = typeof(scrap) == "number" and scrap or 0

    local function getMul(attr)
        local val = LocalPlayer:GetAttribute(attr)
        return typeof(val) == "number" and val or 1
    end

    local multiplier = 1
    multiplier = multiplier * getMul("F3FusionPartsByScrap")
    multiplier = multiplier * getMul("Stat_TierPreviousStatsMultiplier")
    multiplier = multiplier * getMul("Stat_MoreFusionPartsUpgParts")
    multiplier = multiplier * getMul("P3MoreFusionParts")
    multiplier = multiplier * getMul("Stat_RelicFusionPartsMultiplier")
    multiplier = multiplier * getMul("B3FusionParts")
    multiplier = multiplier * getMul("WeatherFusionPartsMulti")
    multiplier = multiplier * getMul("Stat_MoreFusionPartsUPGTokens")
    multiplier = multiplier * getMul("Stat_GemUpgradeFusionParts")

    local baseParts = math.floor(scrap / 3000)
    return math.floor(baseParts * multiplier)
end

Config.AutoFusion = false

local AutoFusionToggle = MainTabs:Toggle({
    Title = "Fusion",
    Image = GetIconCurrency("FusionParts"),
    Flag = "AutoFarm_Fusion_Cfg",
    Value = false,
    Callback = function(val)
        Config.AutoFusion = val
        if val then
            StartManagedLoop("AutoFusion", 2, function()
                return Config.AutoFusion
            end, function()
                if getPendingFusionParts() >= 1 then
                    pcall(function()
                        FusionRemote:FireServer()
                    end)
                end
            end)
        else
            StopManagedLoop("AutoFusion")
        end
    end
})
FM_Add("FusionParts", AutoFusionToggle)  -- atau "Scrap" sesuai preferensi

StartStatusLoop("Status_AutoFusion", 1, function()
    if not AutoFusionToggle then return end

    local scrap = LocalPlayer:GetAttribute("Currency_Scrap")
    scrap = typeof(scrap) == "number" and scrap or 0
    local parts = LocalPlayer:GetAttribute("Currency_FusionParts")
    parts = typeof(parts) == "number" and parts or 0
    local pending = getPendingFusionParts()
    local canFuse = pending >= 1

    local scrapText = formatUpgradeNumber(scrap)
    local partsText = formatUpgradeNumber(parts)
    local pendingText = formatUpgradeNumber(pending)
    FusionGUI = Workspace.WorldObjects.UpgradeStuff.Fusion.UpgradesFrame.FuseUI.UpgDescription
    local icon = canFuse and "🟢" or "🔴"
    local desc = tring.format(
        "%s\n%s Scrap: %s\nFusion Parts: %s (+%s)",FusionGUI.Text,
        icon, scrapText, partsText, pendingText
    )
    SafeSetDesc(AutoFusionToggle, desc)
end)
-- =====================================================
-- AUTO UPGRADES (semua upgrade, diurutkan berdasarkan Currency)
-- =====================================================
local autoUpgradeToggles = {}
local upgradeGroup = nil
local upgradeCount = 0

-- Kumpulkan semua upgrade dalam array
local upgradeList = {}
for upgradeName, upgradeData in pairs(UpgradeConfig.List) do
    table.insert(upgradeList, {
        Name = upgradeName,
        Data = upgradeData,
        Currency = upgradeData.Currency or "Currency_Scrap"
    })
end

-- Urutkan berdasarkan Currency, lalu Price.Base
table.sort(upgradeList, function(a, b)
    local orderA = getCurrencyOrder(a.Currency)
    local orderB = getCurrencyOrder(b.Currency)

    -- 1. Urutkan berdasarkan Currency
    if orderA ~= orderB then
        return orderA < orderB
    end

    -- 2. Jika Currency sama, urutkan berdasarkan Price.Base
    local baseA = 0
    local baseB = 0

    if a.Data.Price then
        baseA = a.Data.Price.Base or 0
    end
    if b.Data.Price then
        baseB = b.Data.Price.Base or 0
    end

    return baseA < baseB
end)
currentGroupCategory = nil
for _, entry in ipairs(upgradeList) do
    local upgradeName = entry.Name
    local upgradeData = entry.Data
    local targetCategory = upgradeData.Currency:gsub("Currency_", "")
    if upgradeCount % 2 == 0 or currentGroupCategory ~= targetCategory then
        upgradeGroup = MainTabs:Group({})
        FM_Add(targetCategory, upgradeGroup)
        currentGroupCategory = targetCategory
        upgradeCount = 0
    end

    local toggle = upgradeGroup:Toggle({
        Flag = "AutoUpg_" .. upgradeName,
        Value = false,
        Callback = function(val)
            if val then
                StartManagedLoop("AutoUpg_" .. upgradeName, 0.5, function()
                    return true
                end, function()
                    local level = LocalPlayer:GetAttribute(upgradeData.Attr) or 0
                    local rebirths = LocalPlayer:GetAttribute("Rebirths") or 0
                    local maxLevel = RebirthConfig.GetUpgradeMax(upgradeName, upgradeData.Max, rebirths)
                    if level >= maxLevel then return end

                    local price = math.floor(upgradeScale(upgradeData.Price, level))
                    local currency = upgradeData.Currency
                    local currencyAmount = LocalPlayer:GetAttribute(currency) or 0

                    if currencyAmount >= price then
                        pcall(function()
                            BuyUpgrade:InvokeServer(upgradeName, true)
                        end)
                    end
                end)
            else
                StopManagedLoop("AutoUpg_" .. upgradeName)
            end
        end
    })

    autoUpgradeToggles[upgradeName] = {
        toggle = toggle,
        upgradeData = upgradeData
    }
    upgradeCount = upgradeCount + 1
end

-- Status update untuk semua toggle
StartStatusLoop("Status_AutoUpgrades", 0.5, function()
    for upgradeName, info in pairs(autoUpgradeToggles) do
        local toggle = info.toggle
        local upgradeData = info.upgradeData

        -- Cari UI upgrade di workspace
        local UpgradeGui = workspace:FindFirstChild(upgradeName, true)
        if not UpgradeGui then continue end

        local level = LocalPlayer:GetAttribute(upgradeData.Attr) or 0
        local rebirths = LocalPlayer:GetAttribute("Rebirths") or 0
        local maxLevel = RebirthConfig.GetUpgradeMax(upgradeName, upgradeData.Max, rebirths)
        local currency = upgradeData.Currency or "Currency_Scrap"
        local currencyAmount = LocalPlayer:GetAttribute(currency) or 0
        local price = math.floor(upgradeScale(upgradeData.Price, level))
        local isMax = level >= maxLevel

        local title = UpgradeGui.Image.Image .. UpgradeGui.UpgName.Text
        SafeSetTitle(toggle, title)

        local descLines = {}
        table.insert(descLines, UpgradeGui.UpgLevel.Text)
        table.insert(descLines, UpgradeGui.UpgDescription.Text)
        table.insert(descLines, UpgradeGui.UpgMulti.Text)
        local canAfford = currencyAmount >= price
        local color = canAfford and "#00ff00" or "#ff0000"
        local priceText = UpgradeGui.UpgPrice.Text
        if not isMax then
            table.insert(descLines, string.format('<font color="%s">%s/%s</font>', color, formatUpgradeNumber(currencyAmount), priceText))
        else
            table.insert(descLines, priceText)
        end
        SafeSetDesc(toggle, table.concat(descLines, "\n"))
    end
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
FM_OnChange("Scrap")
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
