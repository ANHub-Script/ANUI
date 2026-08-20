if game.PlaceId ~= 70960300100792 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Dropler Incremental"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local character = LocalPlayer.Character
local rootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
humanoid.WalkSpeed = 100  -- nilai default biasanya 16

local FolderPath = "ANUI/DroplerIncremental"
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
    Title = "AN Hub - Dropler Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "DroplerIncremental",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Dropler Incremental" }),
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
local function Color3ToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
end
local Framework = require(ReplicatedStorage.Framework)
local UpgradesData = require(ReplicatedStorage.Modules.Shared.Upgrades)
local BigNum = require(ReplicatedStorage.Modules.Shared.BigNum)
local AscensionData = require(ReplicatedStorage.Modules.Shared.Ascension)
local Features = require(ReplicatedStorage.Modules.Shared.Features)
local Merchant = require(ReplicatedStorage.Modules.Shared.Merchant)
local Boosts = require(ReplicatedStorage.Modules.Shared.Boosts)
local Suffix = require(ReplicatedStorage.Modules.Shared.Suffix)
local Requirements = require(ReplicatedStorage.Modules.Shared.Requirements)
local StatInformation = require(ReplicatedStorage.Modules.Shared.StatInformation)
local UpgradeTreeData = require(ReplicatedStorage.Modules.Shared.UpgradeTree)
local Multipliers = require(ReplicatedStorage.Modules.Shared.Multipliers)
local DailyData = require(ReplicatedStorage.Modules.Shared.DailyUpgrades)
local SacrificeData = require(ReplicatedStorage.Modules.Shared.Sacrifice)
local PrestigeData = require(ReplicatedStorage.Modules.Shared.Prestige)
local ReadingUpgradesData = require(ReplicatedStorage.Modules.Shared.ReadingUpgrades)
local ShrineStats = require(ReplicatedStorage.Modules.Shared.ShrineStats)
local GalacticData = require(ReplicatedStorage.Modules.Shared.Galactic)
local Energy = require(ReplicatedStorage.Modules.Shared.Energy)
-- Tunggu data pemain termuat
Framework.Stat.WaitForLoad(LocalPlayer)
Config.AutoUpgraders = {}
local dataFolder = Framework.Stat.GetDataFolder(LocalPlayer)
task.spawn(function()
    while true do
        task.wait(0.05)
        Framework.Network.Fire("DropperClick", upgradeId)
        Framework.Stat.Get(LocalPlayer, "AutoClickerGamepass").Value = true
        Framework.Stat.Get(LocalPlayer, "ExtraCashTier").Value = 8
        -- Framework.Stat.Get(LocalPlayer, "ExtraBonesTier").Value = 8
        -- Framework.Stat.Get(LocalPlayer, "ExtraBronzeTier").Value = 8
        -- Framework.Stat.Get(LocalPlayer, "ExtraCoinsTier").Value = 8
        -- Framework.Stat.Get(LocalPlayer, "ExtraEnergyTier").Value = 8
        -- Framework.Stat.Get(LocalPlayer, "ExtraPaperTier").Value = 8
        -- Framework.Stat.Get(LocalPlayer, "ExtraRocksTier").Value = 8
        -- Framework.Stat.Get(LocalPlayer, "ExtraWoodTier").Value = 8
        -- Framework.Stat.Get(LocalPlayer, "ExtraDiamondsTier").Value = 8
        Framework.Stat.Get(LocalPlayer, "AutoCollectionGamepass").Value = true
        Framework.Stat.Get(LocalPlayer, "FasterCoinSpeedGamepass").Value = true
        Framework.Stat.Get(LocalPlayer, "MoreClickSpeedGamepass").Value = true
        Framework.Stat.Get(LocalPlayer, "MoreWalkspeedGamepass").Value = true
        Framework.Stat.Get(LocalPlayer, "MoreXPGamepass").Value = true
    end
end)
-- [[ MAIN TAB ]] --
MainTabs = Window:Tab({
    Title = "Main Feature",
    Icon = "swords",
    SidebarProfile = false
})
Options = {}
function GetIconCurrency(upgradeData)
    Icon = StatInformation[upgradeData]
    if Icon then
        return Icon.Icon
    end
    return "rbxassetid://138354470464864"
end
table.insert(Options,{Title = "Shrine",Icon = GetIcon(88061784222994)})
table.insert(Options,{Title = "Automation",Icon = GetIcon(131036042070680)})
table.insert(Options,{Title = "Reading Points",Icon = GetIconCurrency("ReadingPoints")})
table.insert(Options,{Title = "Power",Icon = GetIconCurrency("Power")})
table.insert(Options,{Title = "Wood",Icon = GetIconCurrency("Wood")})
table.insert(Options,{Title = "Energy",Icon = GetIconCurrency("Energy")})
for currencyName, currencyData in pairs(UpgradesData) do
    table.insert(Options,{Title = currencyData.Display,Icon = GetIconCurrency(currencyData.Currency)})
end
-- Urutkan berdasarkan Title
table.sort(Options, function(a, b)
    return a.Title < b.Title
end)
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

-- Fungsi untuk menghasilkan teks reward tier
local function getRewardTextForTier(DataType,tier)
    local rewards = DataType.Text[tier]
    if not rewards then return nil end
    local lines = {}
    for _, reward in ipairs(rewards) do
        local text
        if reward.Type == "Function" then
            text = reward.Text(LocalPlayer)
        else
            text = reward.Text
        end
        table.insert(lines, text)
    end
    return lines
end
-- =====================================================
-- AUTO UPGRADE (Dropler Incremental – Framework)
-- =====================================================

local upgradeGroup = nil
local upgradeCount = 0
local toggleRegistry = {}
local function isRbxAssetLink(icon)
    return type(icon) == "string" and icon:sub(1, 13) == "rbxassetid://"
end
currentGroupCategory = nil
-- Iterasi SEMUA currency & upgrade yang ada di UpgradesData
for currencyName, currencyData in pairs(UpgradesData) do
    if type(currencyData) == "table" and type(currencyData.Upgrades) == "table" then
        for upgradeId, upgradeData in pairs(currencyData.Upgrades) do
            local targetCategory = currencyData.Display
            if upgradeCount % 2 == 0 or currentGroupCategory ~= targetCategory then
                upgradeGroup = MainTabs:Group({})
                FM_Add(targetCategory, upgradeGroup)
                currentGroupCategory = targetCategory
                upgradeCount = 0
            end

            local fullKey = currencyName .. "_" .. upgradeId

            local toggle = upgradeGroup:Toggle({
                Title = upgradeData.Display or upgradeId,
                Flag = "AutoUpg_" .. fullKey,
                Value = false,
                Callback = function(val)
                    Config.AutoUpgraders[fullKey] = val
                    if val then
                        StartManagedLoop("AutoUpg_" .. fullKey, 0.5, function()
                            return Config.AutoUpgraders[fullKey] == true
                        end, function()
                            -- Data stat diambil saat loop berjalan, bukan saat pembuatan toggle
                            local levelObj = Framework.Stat.Get(LocalPlayer, upgradeId)
                            local currencyObj = Framework.Stat.Get(LocalPlayer, currencyName)
                            if not (levelObj and currencyObj) then return end

                            local level = levelObj.Value or 0
                            local cur = currencyObj.Value or 0
                            local cap = upgradeData.Cap(dataFolder)
                            if level >= cap then return end

                            local info = upgradeData.Info(level)
                            local price = info.Price

                            if BigNum.gte(cur, price) then
                                Framework.Network.Fire("Upgrade", currencyName, upgradeId, true)
                            end
                        end)
                    else
                        StopManagedLoop("AutoUpg_" .. fullKey)
                    end
                end
            })

            toggleRegistry[fullKey] = toggle
            upgradeCount = upgradeCount + 1
        end
    end
end

-- Status loop tetap sama, hanya menampilkan data yang tersedia
StartStatusLoop("Status_AutoUpgrades", 0.5, function()
    for fullKey, toggle in pairs(toggleRegistry) do
        local currencyName, upgradeId = fullKey:match("^(.-)_(.*)$")
        if not currencyName or not upgradeId then continue end

        local currencyData = UpgradesData[currencyName]
        local upgradeData = currencyData and currencyData.Upgrades[upgradeId]
        if not upgradeData then continue end
        Icon = nil
        if isRbxAssetLink(upgradeData.Icon) then
            Icon = upgradeData.Icon
        else
            Icon = StatInformation[upgradeData.Icon].Icon
        end
        SafeSetMainImage(toggle,Icon,30)

        local levelObj = Framework.Stat.Get(LocalPlayer, upgradeId)
        local currencyObj = Framework.Stat.Get(LocalPlayer, currencyName)

        -- Jika data stat belum tersedia, tampilkan status "Loading..."
        if not (levelObj and currencyObj) then
            SafeSetTitle(toggle, upgradeData.Display or upgradeId)
            SafeSetDesc(toggle, "Loading...")
            continue
        end

        local level = levelObj.Value or 0
        local cur = currencyObj.Value or 0
        local cap = upgradeData.Cap(dataFolder)
        local info = upgradeData.Info(level)
        local info2 = upgradeData.Info(level+1)
        local price = info.Price
        local isMax = level >= cap
        local canAfford = not isMax and BigNum.gte(cur, price)

        local title = string.format("%s (%d/%d)", upgradeData.Display or upgradeId, level, cap)
        SafeSetTitle(toggle, title)

        local descLines = {}
        if isMax then
            table.insert(descLines,string.format(upgradeData.Format, Suffix.short(info.Reward)))
        else
            table.insert(descLines,string.format(upgradeData.Format, Suffix.short(info.Reward)) .. " > " .. string.format(upgradeData.Format, Suffix.short(info2.Reward)))
            table.insert(descLines, ("Costs %* <font color=\"#%*\">%*</font>"):format(Suffix.short(price), StatInformation[currencyData.Currency].Colour:ToHex(), currencyData.Display))
        end
        SafeSetDesc(toggle, table.concat(descLines, "\n"))
    end
end)

-- Tunggu data pemain termuat
Framework.Stat.WaitForLoad(LocalPlayer)

-- Helper untuk mengambil nilai stat dengan aman
local function GetStatValue(name)
    local obj = Framework.Stat.Get(LocalPlayer, name)
    return obj and obj.Value or 0
end

-- Daftar fitur reset layer (semua logika sama)
local resetFeatures = {
    {
        Name = "Rebirth",
        RequirementStat = Requirements.Rebirth.Stat,
        RequirementAmount = Requirements.Rebirth.Amount,
        RewardStat = "RebirthPoints",
        Remote = "Rebirth",
        GetConversion = function() return Multipliers.GetRebirthConversion(LocalPlayer) end,
        GetMultiplier = function() return Multipliers.GetRebirthPointsMultiplier(LocalPlayer) end,
    },
    {
        Name = "Bronze Rebirth",
        RequirementStat = Requirements.BronzeRebirth.Stat,
        RequirementAmount = Requirements.BronzeRebirth.Amount,
        RewardStat = "BronzeRebirthPoints",
        Remote = "BronzeRebirth",
        GetConversion = function() return Multipliers.GetBronzeRebirthConversion(LocalPlayer) end,
        GetMultiplier = function() return Multipliers.GetBronzeRebirthPointsMultiplier(LocalPlayer) end,
    },
    {
        Name = "Logging",
        RequirementStat = Requirements.Logging.Stat,
        RequirementAmount = Requirements.Logging.Amount,
        RewardStat = "Paper",
        Remote = "Logging",
        GetConversion = function() return Multipliers.GetLoggingConversion(LocalPlayer) end,
        GetMultiplier = function() return Multipliers.GetPaperMultiplier(LocalPlayer) end,
    },
    {
        Name = "Crystalize",
        RequirementStat = Requirements.Crystalize.Stat,
        RequirementAmount = Requirements.Crystalize.Amount,
        RewardStat = "Crystals",
        Remote = "Crystalize",
        GetConversion = function() return Multipliers.GetCrystalizeConversion(LocalPlayer) end,
        GetMultiplier = function() return Multipliers.GetCrystalsMultiplier(LocalPlayer) end,
    },
    {
        Name = "Diamond",
        RequirementStat = Requirements.Diamonds.Stat,
        RequirementAmount = Requirements.Diamonds.Amount,
        RewardStat = "Diamonds",
        Remote = "Diamond",
        GetConversion = function() return Multipliers.GetDiamondsConversion(LocalPlayer) end,
        GetMultiplier = function() return Multipliers.GetDiamondsMultiplier(LocalPlayer) end,
    },
    {
        Name = "Fire",
        RequirementStat = Requirements.Fire.Stat,
        RequirementAmount = Requirements.Fire.Amount,
        RewardStat = "Fire",
        Remote = "Fire",
        GetConversion = function() return Multipliers.GetFireConversion(LocalPlayer) end,
        GetMultiplier = function() return Multipliers.GetFireMultiplier(LocalPlayer) end,
    },
}

local resetToggles = {}
local resetGroup = nil
local resetCountInGroup = 0

local function getSacrificeInfo()
    local sacrificeLevelObj = Framework.Stat.Get(LocalPlayer, "Sacrifice")
    local highestFightingLevelObj = Framework.Stat.Get(LocalPlayer, "HighestFightingLevel")
    if not (sacrificeLevelObj and highestFightingLevelObj) then
        return nil
    end
    local sacrificeLevel = sacrificeLevelObj.Value or 0
    local highestFightingLevel = highestFightingLevelObj.Value or 0
    local maxSacrifice = SacrificeData.Max
    local priceIndex = math.min(sacrificeLevel, maxSacrifice - 1)
    local price = SacrificeData.Prices[priceIndex]
    local unlocked = Features.Sacrifice.Unlocked(LocalPlayer)
    local canSacrifice = unlocked and sacrificeLevel < maxSacrifice and BigNum.gte(highestFightingLevel, price)
    local isMax = sacrificeLevel >= maxSacrifice

    return {
        sacrificeLevel = sacrificeLevel,
        highestFightingLevel = highestFightingLevel,
        maxSacrifice = maxSacrifice,
        price = price,
        unlocked = unlocked,
        canSacrifice = canSacrifice,
        isMax = isMax,
    }
end
local ResetLayers = MainTabs:Section({
    Title = "Sacrifice",
})
FM_Add("Automation", ResetLayers)  -- sesuaikan kategori
local autoSacrificeToggle = ResetLayers:Toggle({
    Title = GetIconCurrency("Sacrifice") .. "Sacrifice" .. GetIconCurrency("Sacrifice"),
    Flag = "AutoSacrifice",
    Value = false,
    Callback = function(val)
        Config.AutoSacrifice = val
        if val then
            StartManagedLoop("AutoSacrifice", 2, function()
                return Config.AutoSacrifice
            end, function()
                local info = getSacrificeInfo()
                if info and info.canSacrifice then
                    Framework.Network.Fire("Sacrifice")
                end
            end)
        else
            StopManagedLoop("AutoSacrifice")
        end
    end
})
FM_Add("Automation", autoSacrificeToggle)  -- sesuaikan kategori

-- Status dengan deskripsi lengkap (semua tier rewards)
StartStatusLoop("Status_AutoSacrifice", 1, function()
    if not autoSacrificeToggle then return end

    local info = getSacrificeInfo()
    if not info then
        SafeSetDesc(autoSacrificeToggle, "Loading...")
        return
    end

    local descLines = {}

    if not info.unlocked then
        table.insert(descLines, '<font color="#888888">Locked</font>')
    elseif info.isMax then
        table.insert(descLines, '<font color="#ffff00">Max Sacrifice</font>')
        table.insert(descLines, "Boosts:")
        -- Tampilkan semua rewards dari tier 1 sampai max
        for tier = 1, info.maxSacrifice do
            local tierRewards = getRewardTextForTier(SacrificeData,tier)
            if tierRewards then
                for _, rewardText in ipairs(tierRewards) do
                    table.insert(descLines,rewardText)
                end
            end
        end
    else
        -- Status affordability
        if info.canSacrifice then
            table.insert(descLines, '<font color="#00ff00">Sacrifice</font>')
        else
            table.insert(descLines, string.format(
                '<font color="#ff5555">Mob Level %s Required</font>',
                Suffix.short(info.price)
            ))
        end

        -- Level & Highest Fighting Level
        table.insert(descLines, string.format(
            'Sacrifice: <font color="#%s">%d / %d</font>',
            StatInformation.Sacrifice.Colour:ToHex(),
            info.sacrificeLevel,
            info.maxSacrifice
        ))
        table.insert(descLines, string.format(
            'Highest Fighting Level: %s',
            Suffix.short(info.highestFightingLevel)
        ))

        -- Tampilkan rewards dari tier 1 sampai tier saat ini
        if info.sacrificeLevel > 0 then
            table.insert(descLines, "Boosts:")
            for tier = 1, info.sacrificeLevel do
                local tierRewards = getRewardTextForTier(SacrificeData,tier)
                if tierRewards then
                    for _, rewardText in ipairs(tierRewards) do
                        table.insert(descLines,rewardText)
                    end
                end
            end
        end

        -- Tampilkan rewards tier berikutnya
        local nextTier = info.sacrificeLevel + 1
        local nextRewards = getRewardTextForTier(SacrificeData,nextTier)
        if nextRewards then
            table.insert(descLines, " ")
            table.insert(descLines, "Next Boosts:")
            table.insert(descLines, string.format("Tier %d:", nextTier))
            for _, rewardText in ipairs(nextRewards) do
                table.insert(descLines,rewardText)
            end
        end
    end

    SafeSetDesc(autoSacrificeToggle, table.concat(descLines, "\n"))
end)


local ResetLayers = MainTabs:Section({
    Title = "Prestige & Ascension",
})
FM_Add("Automation", ResetLayers)
Config.AutoPrestige = false
-- Helper generik untuk Prestige & Ascension (keduanya pakai Cash)
local function getResetLayerInfo(statName, dataModule, featureName)
    local levelObj = Framework.Stat.Get(LocalPlayer, statName)
    local cashObj = Framework.Stat.Get(LocalPlayer, "Cash")
    if not (levelObj and cashObj) then
        return nil
    end
    local level = levelObj.Value or 0
    local cash = cashObj.Value or 0
    local maxLevel = dataModule.Max
    local priceIndex = math.min(level, maxLevel - 1)
    local price = dataModule.Prices[priceIndex]
    local unlocked = Features[featureName] and Features[featureName].Unlocked(LocalPlayer) or false
    local canBuy = unlocked and level < maxLevel and BigNum.gte(cash, price)
    local isMax = level >= maxLevel

    return {
        level = level,
        cash = cash,
        maxLevel = maxLevel,
        price = price,
        unlocked = unlocked,
        canBuy = canBuy,
        isMax = isMax,
    }
end
-- Buat deskripsi lengkap (status + owned rewards + next rewards)
local function buildLayerDescription(info, dataModule, statName, rewardColorHex)
    local descLines = {}

    if not info.unlocked then
        table.insert(descLines, '<font color="#888888">Locked</font>')
    elseif info.isMax then
        table.insert(descLines, '<font color="#ffff00">Max ' .. statName .. '</font>')
        table.insert(descLines, "Boosts:")
        -- Tampilkan semua rewards
        for tier = 1, info.maxLevel do
            local tierRewards = getRewardTextForTier(dataModule, tier)
            if tierRewards then
                for _, rewardText in ipairs(tierRewards) do
                    table.insert(descLines,rewardText)
                end
            end
        end
    else
        -- Status affordability
        if info.canBuy then
            table.insert(descLines, '<font color="#00ff00">' .. statName .. '</font>')
        else
            table.insert(descLines, string.format(
                '<font color="#ff5555">%s / %s Cash</font>',
                Suffix.short(info.cash),
                Suffix.short(info.price)
            ))
        end

        -- Level & Cash
        table.insert(descLines, string.format(
            statName .. ': <font color="#%s">%d / %d</font>',
            rewardColorHex,
            info.level,
            info.maxLevel
        ))
        table.insert(descLines, string.format(
            'Cash: <font color="#%s">%s</font>',
            StatInformation.Cash.Colour:ToHex(),
            Suffix.short(info.cash)
        ))

        -- Owned rewards (tier 1 sampai saat ini)
        if info.level > 0 then
            table.insert(descLines, "Boosts:")
            for tier = 1, info.level do
                local tierRewards = getRewardTextForTier(dataModule, tier)
                if tierRewards then
                    for _, rewardText in ipairs(tierRewards) do
                        table.insert(descLines,rewardText)
                    end
                end
            end
        end

        -- Next rewards
        local nextTier = info.level + 1
        local nextRewards = getRewardTextForTier(dataModule, nextTier)
        if nextRewards then
            table.insert(descLines, "Next Boosts:")
            for _, rewardText in ipairs(nextRewards) do
                table.insert(descLines,rewardText)
            end
        end
    end

    return table.concat(descLines, "\n")
end
local autoPrestigeToggle = ResetLayers:Toggle({
    Title = GetIconCurrency("Prestige") .. "Prestige" .. GetIconCurrency("Prestige"),
    Flag = "AutoPrestige",
    Value = false,
    Callback = function(val)
        Config.AutoPrestige = val
        if val then
            StartManagedLoop("AutoPrestige", 1, function()
                return Config.AutoPrestige
            end, function()
                local info = getResetLayerInfo("Prestige", PrestigeData, "Prestige")
                if info and info.canBuy then
                    Framework.Network.Fire("Prestige")
                end
            end)
        else
            StopManagedLoop("AutoPrestige")
        end
    end
})
FM_Add("Automation", autoPrestigeToggle)

Config.AutoAscension = false
local autoAscensionToggle = ResetLayers:Toggle({
    Title = GetIconCurrency("Ascension") .. "Ascension" .. GetIconCurrency("Ascension"),
    Flag = "AutoAscension",
    Value = false,
    Callback = function(val)
        Config.AutoAscension = val
        if val then
            StartManagedLoop("AutoAscension", 1, function()
                return Config.AutoAscension
            end, function()
                local info = getResetLayerInfo("Ascension", AscensionData, "Ascension")
                if info and info.canBuy then
                    Framework.Network.Fire("Ascend")
                end
            end)
        else
            StopManagedLoop("AutoAscension")
        end
    end
})
FM_Add("Automation", autoAscensionToggle)

-- Status loop gabungan untuk Prestige & Ascension
StartStatusLoop("Status_AutoPrestigeAscension", 1, function()
    -- Prestige
    if autoPrestigeToggle then
        local info = getResetLayerInfo("Prestige", PrestigeData, "Prestige")
        if info then
            SafeSetDesc(autoPrestigeToggle, buildLayerDescription(info, PrestigeData, "Prestige", StatInformation.Prestige.Colour:ToHex()))
        else
            SafeSetDesc(autoPrestigeToggle, "Loading...")
        end
    end

    -- Ascension
    if autoAscensionToggle then
        local info = getResetLayerInfo("Ascension", AscensionData, "Ascension")
        if info then
            SafeSetDesc(autoAscensionToggle, buildLayerDescription(info, AscensionData, "Ascension", StatInformation.Ascension.Colour:ToHex()))
        else
            SafeSetDesc(autoAscensionToggle, "Loading...")
        end
    end
end)
-- =====================================================
-- AUTO GALACTIC RESET (Dropler Incremental)
-- =====================================================
Config.AutoGalactic = false

-- Helper untuk mendapatkan info Galactic
local function getGalacticInfo()
    local levelObj = Framework.Stat.Get(LocalPlayer, "Galactic")
    local bronzeObj = Framework.Stat.Get(LocalPlayer, GalacticData.Currency) -- GalacticData.Currency biasanya "Bronze"
    if not (levelObj and bronzeObj) then
        return nil
    end
    local level = levelObj.Value or 0
    local bronze = bronzeObj.Value or 0
    local maxLevel = GalacticData.Max
    local priceIndex = math.min(level, maxLevel - 1)
    local price = GalacticData.Prices[priceIndex]
    local unlocked = Features.Galactic and Features.Galactic.Unlocked(LocalPlayer) or false
    local canBuy = unlocked and level < maxLevel and BigNum.gte(bronze, price)
    local isMax = level >= maxLevel

    return {
        level = level,
        bronze = bronze,
        maxLevel = maxLevel,
        price = price,
        unlocked = unlocked,
        canBuy = canBuy,
        isMax = isMax,
    }
end

-- Toggle Auto Galactic
local autoGalacticToggle = ResetLayers:Toggle({
    Title = "Galactic",
    Image = GetIconCurrency("Galactic"), -- Ikon dari StatInformation.Galactic
    Flag = "AutoGalactic",
    Value = false,
    Callback = function(val)
        Config.AutoGalactic = val
        if val then
            StartManagedLoop("AutoGalactic", 1, function()
                return Config.AutoGalactic
            end, function()
                local info = getGalacticInfo()
                if info and info.canBuy then
                    Framework.Network.Fire("Galactic")
                end
            end)
        else
            StopManagedLoop("AutoGalactic")
        end
    end
})
FM_Add("Automation", autoGalacticToggle)

-- Status loop untuk Auto Galactic
StartStatusLoop("Status_AutoGalactic", 1, function()
    if not autoGalacticToggle then return end

    local info = getGalacticInfo()
    if not info then
        SafeSetDesc(autoGalacticToggle, "Loading...")
        return
    end

    local descLines = {}
    if not info.unlocked then
        table.insert(descLines, '<font color="#888888">Locked</font>')
    elseif info.isMax then
        table.insert(descLines, '<font color="#ffff00">Max Galactic</font>')
        table.insert(descLines, "Boosts:")
        for tier = 1, info.maxLevel do
            local tierRewards = getRewardTextForTier(GalacticData, tier)
            if tierRewards then
                for _, rewardText in ipairs(tierRewards) do
                    table.insert(descLines, rewardText)
                end
            end
        end
    else
        if info.canBuy then
            table.insert(descLines, '<font color="#00ff00">Galactic</font>')
        else
            table.insert(descLines, string.format(
                '<font color="#ff5555">Bronze %s Required</font>',
                Suffix.short(info.price)
            ))
        end

        table.insert(descLines, string.format(
            'Galactic: <font color="#%s">%d / %d</font>',
            StatInformation.Galactic.Colour:ToHex(),
            info.level,
            info.maxLevel
        ))
        table.insert(descLines, string.format(
            'Bronze: <font color="#%s">%s</font>',
            StatInformation.Bronze.Colour:ToHex(),
            Suffix.short(info.bronze)
        ))

        -- Tampilkan rewards yang sudah dimiliki
        if info.level > 0 then
            table.insert(descLines, "Boosts:")
            for tier = 1, info.level do
                local tierRewards = getRewardTextForTier(GalacticData, tier)
                if tierRewards then
                    for _, rewardText in ipairs(tierRewards) do
                        table.insert(descLines, rewardText)
                    end
                end
            end
        end

        -- Tampilkan rewards tier berikutnya
        local nextTier = info.level + 1
        local nextRewards = getRewardTextForTier(GalacticData, nextTier)
        if nextRewards then
            table.insert(descLines, "Next Boosts:")
            for _, rewardText in ipairs(nextRewards) do
                table.insert(descLines, rewardText)
            end
        end
    end

    SafeSetDesc(autoGalacticToggle, table.concat(descLines, "\n"))
end)
local ResetLayers = MainTabs:Section({
    Title = "Reset Layers & Reading Book",
})
FM_Add("Automation", ResetLayers)

-- Buat toggle untuk setiap reset layer
for _, feature in ipairs(resetFeatures) do
    if resetCountInGroup % 2 == 0 then
        resetGroup = ResetLayers:Group({})
        FM_Add("Automation", resetGroup)
    end

    local toggle = resetGroup:Toggle({
        Title = feature.Name,
        Image = GetIconCurrency(feature.RewardStat),
        Flag = "AutoResets_" .. feature.Name:gsub("%s+",""),
        Value = false,
        Callback = function(val)
            Config.AutoUpgraders[feature.Name] = val
            if val then
                StartManagedLoop("AutoReset_" .. feature.Name, 1, function()
                    return Config.AutoUpgraders[feature.Name] == true
                end, function()
                    local reqStat = GetStatValue(feature.RequirementStat)
                    if BigNum.gte(reqStat, feature.RequirementAmount) then
                        Framework.Network.Fire(feature.Remote)
                    end
                end)
            else
                StopManagedLoop("AutoReset_" .. feature.Name)
            end
        end
    })
    resetToggles[feature.Name] = toggle
    resetCountInGroup = resetCountInGroup + 1
end

-- Status update untuk reset layers
StartStatusLoop("Status_AutoResetLayers", 1, function()
    for _, feature in ipairs(resetFeatures) do
        local toggle = resetToggles[feature.Name]
        if not toggle then continue end

        local reqStat = GetStatValue(feature.RequirementStat)
        local reqAmount = feature.RequirementAmount
        local rewardStat = GetStatValue(feature.RewardStat)
        local gain = BigNum.mul(feature.GetConversion(), feature.GetMultiplier())
        local can = BigNum.gte(reqStat, reqAmount)

        local reqColor = StatInformation[feature.RequirementStat] and StatInformation[feature.RequirementStat].Colour:ToHex() or "#FFFFFF"
        local rewardColor = StatInformation[feature.RewardStat] and StatInformation[feature.RewardStat].Colour:ToHex() or "#FFFFFF"

        local descLines = {}
        table.insert(descLines, string.format('Requirement: <font color="#%s">%s</font> %s', reqColor, splitCamelCase(feature.RequirementStat),
            Suffix.short(reqAmount)))
        if can then
            table.insert(descLines, string.format('<font color="#%s">%s: %s (+%s)</font>',
                rewardColor, splitCamelCase(feature.RewardStat), Suffix.short(rewardStat), Suffix.short(gain)))
        else
            table.insert(descLines, string.format('<font color="#%s">%s: %s</font>',
                rewardColor, splitCamelCase(feature.RewardStat), Suffix.short(rewardStat)))
        end
        SafeSetDesc(toggle, table.concat(descLines, "\n"))
    end
end)

-- =====================================================
-- AUTO BUY BOOKS (Reading)
-- =====================================================
local readingToggle = ResetLayers:Toggle({
    Title = "Auto Buy Books",
    Image = GetIconCurrency("ReadingPoints"),
    Flag = "AutoBuyBooks",
    Value = false,
    Callback = function(val)
        Config.AutoUpgraders["Books"] = val
        if val then
            StartManagedLoop("AutoBuyBooks", 1, function()
                return Config.AutoUpgraders["Books"] == true
            end, function()
                local books = GetStatValue("Books")
                if books >= Requirements.Books.Max then return end
                local coins = GetStatValue(Requirements.Books.Stat)
                local cost = Requirements.Books.Amount(LocalPlayer)
                if BigNum.gte(coins, cost) then
                    Framework.Network.Fire("BuyBook", true) -- beli max
                end
            end)
        else
            StopManagedLoop("AutoBuyBooks")
        end
    end
})
FM_Add("Automation", readingToggle)

-- Status Auto Buy Books
StartStatusLoop("Status_AutoBooks", 1, function()
    if not readingToggle then return end

    local books = GetStatValue("Books")
    local coins = GetStatValue(Requirements.Books.Stat)
    local cost = Requirements.Books.Amount(LocalPlayer)
    local canBuy = BigNum.gte(coins, cost) and books < Requirements.Books.Max

    local color = canBuy and "#00ff00" or "#ff0000"
    local booksColor = StatInformation.Books and StatInformation.Books.Colour:ToHex() or "#FFFFFF"
    local coinsColor = StatInformation.Coins and StatInformation.Coins.Colour:ToHex() or "#FFFFFF"

    local descLines = {}
    table.insert(descLines, string.format('Books: <font color="#%s">%s</font>', booksColor, Suffix.short(books)))
    table.insert(descLines, string.format('Coins: <font color="#%s">%s</font> / <font color="#%s">%s</font>',
        coinsColor, Suffix.short(coins), coinsColor, Suffix.short(cost)))
    table.insert(descLines, string.format('<font color="%s">%s</font>', color, canBuy and "✅ Can buy" or "❌ Cannot buy"))
    SafeSetDesc(readingToggle, table.concat(descLines, "\n"))
end)

-- =====================================================
-- AUTO UPGRADE TREE (SATU TOGGLE UTAMA)
-- =====================================================

local UpgradeTreeSection = MainTabs:Section({
    Title = "Upgrade Tree",
})
Config.AutoUpgraders["UpgradeTreeMaster"] = false

local autoTreeMasterToggle = UpgradeTreeSection:Toggle({
    Title = "🌳 Auto Upgrade Tree",
    Flag = "AutoTreeMaster",
    Value = false,
    Callback = function(val)
        Config.AutoUpgraders["UpgradeTreeMaster"] = val
        if val then
            StartManagedLoop("AutoTreeMaster", 0.5, function()
                return Config.AutoUpgraders["UpgradeTreeMaster"] == true
            end, function()
                -- Iterasi semua node di UpgradeTreeData
                for upgradeId, upgradeData in pairs(UpgradeTreeData) do
                    local levelObj = Framework.Stat.Get(LocalPlayer, upgradeId)
                    local currencyObj = Framework.Stat.Get(LocalPlayer, upgradeData.Currency)
                    if not (levelObj and currencyObj) then
                        continue
                    end

                    local level = levelObj.Value or 0
                    local cap = upgradeData.Cap(dataFolder)
                    if level >= cap then
                        continue -- sudah max
                    end

                    -- Cek unlock
                    if not upgradeData.Unlocked(dataFolder) and level < 1 then
                        continue
                    end

                    local price = upgradeData.Price(LocalPlayer)
                    if BigNum.gte(currencyObj.Value, price) then
                        Framework.Network.Fire("TreeUpgrade", upgradeId)
                    end
                end
            end)
        else
            StopManagedLoop("AutoTreeMaster")
        end
    end
})
FM_Add("Automation", UpgradeTreeSection)
FM_Add("Automation", autoTreeMasterToggle)

-- Status loop dengan daftar upgrade yang sudah dimiliki
StartStatusLoop("Status_AutoTreeMaster", 1, function()
    if not autoTreeMasterToggle then return end

    local affordableCount = 0
    local maxedCount = 0
    local totalCount = 0
    local ownedLines = {}          -- untuk menampung baris upgrade yang sudah dimiliki

    for upgradeId, upgradeData in pairs(UpgradeTreeData) do
        totalCount = totalCount + 1
        local levelObj = Framework.Stat.Get(LocalPlayer, upgradeId)
        local currencyObj = Framework.Stat.Get(LocalPlayer, upgradeData.Currency)
        if not (levelObj and currencyObj) then continue end

        local level = levelObj.Value or 0
        local cap = upgradeData.Cap(dataFolder)

        -- Jika sudah dimiliki (level >= 1), tambahkan ke daftar
        if level >= 1 then
            local rewardText = upgradeData.RewardDisplay or "No Reward"
            local line = string.format("• %s: %s", upgradeData.Display or upgradeId, rewardText)
            table.insert(ownedLines, line)
        end

        if level >= cap then
            maxedCount = maxedCount + 1
        else
            local price = upgradeData.Price(LocalPlayer)
            if BigNum.gte(currencyObj.Value, price) then
                affordableCount = affordableCount + 1
            end
        end
    end

    -- Susun deskripsi
    local descLines = {}
    table.insert(descLines, string.format("Maxed: %d / %d", maxedCount, totalCount))

    if #ownedLines > 0 then
        table.insert(descLines, "Owned Upgrades:")
        -- Batasi maksimal 8 baris agar tidak terlalu panjang
        local maxShow = 8
        for i = 1, math.min(#ownedLines, #ownedLines) do
            table.insert(descLines, ownedLines[i])
        end
    else
        table.insert(descLines, "No upgrades owned yet")
    end

    SafeSetDesc(autoTreeMasterToggle, table.concat(descLines, "\n"))
end)

-- =====================================================
-- AUTO DAILY UPGRADE (Dropler Incremental)
-- =====================================================
Config.AutoDailyUpgrade = false

-- Toggle utama
local autoDailyToggle = UpgradeTreeSection:Toggle({
    Title = "Daily Upgrade",
    Flag = "AutoDailyUpgrade",
    Value = false,
    Callback = function(val)
        Config.AutoDailyUpgrade = val
        if val then
            StartManagedLoop("AutoDailyUpgrade", 0.5, function()
                return Config.AutoDailyUpgrade
            end, function()
                Framework.Stat.WaitForLoad(LocalPlayer)
                local dataFolder = Framework.Stat.GetDataFolder(LocalPlayer)

                local dailyFolder = workspace:FindFirstChild("MapEssentials") and workspace.MapEssentials:FindFirstChild("DailyUpgrades")
                if not dailyFolder then return end

                local currencyObj = Framework.Stat.Get(LocalPlayer, DailyData.Currency)
                if not currencyObj then return end

                for _, node in ipairs(dailyFolder:GetChildren()) do
                    local upgradeData = DailyData.Upgrades[node.Name]
                    if not upgradeData then continue end

                    local levelObj = Framework.Stat.Get(LocalPlayer, node.Name)
                    if not levelObj then continue end

                    local level = levelObj.Value or 0
                    local cap = upgradeData.Cap or 1
                    if level >= cap then continue end

                    if not upgradeData.Unlocked(dataFolder) then continue end

                    local info = upgradeData.Info(level)
                    local price = info.Price

                    if BigNum.gte(currencyObj.Value, price) then
                        Framework.Network.Fire("DailyUpgrade", node.Name)
                    end
                end
            end)
        else
            StopManagedLoop("AutoDailyUpgrade")
        end
    end
})
FM_Add("Automation", autoDailyToggle)

-- Status update dengan Display & harga
StartStatusLoop("Status_AutoDailyUpgrade", 1, function()
    if not autoDailyToggle then return end

    local dailyFolder = workspace:FindFirstChild("MapEssentials") and workspace.MapEssentials:FindFirstChild("DailyUpgrades")
    if not dailyFolder then
        SafeSetDesc(autoDailyToggle, "Daily nodes not found")
        return
    end

    local dataFolder = Framework.Stat.GetDataFolder(LocalPlayer)
    local currencyObj = Framework.Stat.Get(LocalPlayer, DailyData.Currency)
    local currency = currencyObj and currencyObj.Value or 0

    local lines = {}
    local totalAffordable = 0
    local totalMaxed = 0
    local totalLocked = 0

    for _, node in ipairs(dailyFolder:GetChildren()) do
        local upgradeData = DailyData.Upgrades[node.Name]
        if not upgradeData then continue end

        local levelObj = Framework.Stat.Get(LocalPlayer, node.Name)
        local level = levelObj and levelObj.Value or 0
        local cap = upgradeData.Cap or 1
        local unlocked = upgradeData.Unlocked(dataFolder)

        if not unlocked then
            totalLocked = totalLocked + 1
            table.insert(lines, string.format('<font color="#888888">• %s (Locked)</font>', upgradeData.Display or node.Name))
            continue
        end

        if level >= cap then
            totalMaxed = totalMaxed + 1
            table.insert(lines, string.format('<font color="#ffff00">• %s (MAX)</font>', upgradeData.Display or node.Name))
        else
            local info = upgradeData.Info(level)
            local price = info.Price
            local can = BigNum.gte(currency, price)
            if can then totalAffordable = totalAffordable + 1 end
            local color = can and "#00ff00" or "#ff0000"
            table.insert(lines, string.format('<font color="%s">• %s (Lv.%d/%d) - %s %s</font>',
                color,
                upgradeData.Display or node.Name,
                level,
                cap,
                Suffix.short(price),
                DailyData.Currency
            ))
        end
    end

    table.insert(lines, 1, string.format("Affordable: %d | Maxed: %d | Locked: %d", totalAffordable, totalMaxed, totalLocked))
    SafeSetDesc(autoDailyToggle, table.concat(lines, "\n"))
end)

-- Urutkan upgrade berdasarkan Rank (opsional)
local sortedReadingUpgrades = {}
Config.AutoReadingUpgrades = {}

for upgradeId, upgradeData in pairs(ReadingUpgradesData.Upgrades) do
    table.insert(sortedReadingUpgrades, { id = upgradeId, data = upgradeData })
end
table.sort(sortedReadingUpgrades, function(a, b)
    return (a.data.Rank or 999) < (b.data.Rank or 999)
end)

local readingGroup = nil
local readingCount = 0
local readingToggles = {}

-- Buat toggle untuk setiap upgrade
for _, entry in ipairs(sortedReadingUpgrades) do
    local upgradeId = entry.id
    local upgradeData = entry.data

    if readingCount % 2 == 0 then
        readingGroup = MainTabs:Group({})
        FM_Add("Reading Points", readingGroup)
    end

    local toggle = readingGroup:Toggle({
        Title = upgradeData.Display or upgradeId,
        Flag = "AutoReading_" .. upgradeId,
        Value = false,
        Callback = function(val)
            Config.AutoReadingUpgrades[upgradeId] = val
            if val then
                StartManagedLoop("AutoReading_" .. upgradeId, 0.5, function()
                    return Config.AutoReadingUpgrades[upgradeId] == true
                end, function()
                    -- Ambil objek stat
                    local readingPointsObj = Framework.Stat.Get(LocalPlayer, ReadingUpgradesData.Currency)
                    if not readingPointsObj then return end

                    local readingPoints = readingPointsObj.Value or 0
                    local reward = upgradeData.Reward(LocalPlayer)
                    local cap = upgradeData.Cap(dataFolder)

                    -- Cek unlock & syarat beli
                    if upgradeData.Unlocked(dataFolder) and BigNum.lt(reward, cap) and BigNum.gte(readingPoints, 1) then
                        Framework.Network.Fire("DepositUpgrade", upgradeId)
                    end
                end)
            else
                StopManagedLoop("AutoReading_" .. upgradeId)
            end
        end
    })

    readingToggles[upgradeId] = toggle
    readingCount = readingCount + 1
end

-- Status loop untuk semua toggle reading
StartStatusLoop("Status_AutoReadingUpgrades", 0.5, function()
    for upgradeId, toggle in pairs(readingToggles) do
        if not toggle then continue end

        local upgradeData = ReadingUpgradesData.Upgrades[upgradeId]
        if not upgradeData then continue end

        local readingPointsObj = Framework.Stat.Get(LocalPlayer, ReadingUpgradesData.Currency)
        local readingPoints = readingPointsObj and readingPointsObj.Value or 0

        local unlocked = upgradeData.Unlocked(dataFolder)
        local reward = upgradeData.Reward(LocalPlayer)
        local cap = upgradeData.Cap(dataFolder)
        local isMax = BigNum.gte(reward, cap)
        local canBuy = unlocked and not isMax and BigNum.gte(readingPoints, 1)

        -- Judul
        local title = upgradeData.Display or upgradeId
        if isMax then title = title .. " (MAX)" end
        SafeSetTitle(toggle, title)

        -- Deskripsi
        local descLines = {}
        if not unlocked then
            table.insert(descLines, "🔒 Locked")
        elseif isMax then
            table.insert(descLines, string.format("Boost: %s (MAX)", Suffix.short(cap)))
        else
            local color = canBuy and "#00ff00" or "#ff0000"
            table.insert(descLines, string.format("Reading Points: %s", Suffix.short(readingPoints)))
            table.insert(descLines, string.format("Boost: %s → %s",
                Suffix.short(reward), Suffix.short(cap)))
            table.insert(descLines, string.format('<font color="%s">%s</font>',
                color, canBuy and "✅ Bisa dibeli" or "❌ Tidak cukup points"))
        end

        SafeSetDesc(toggle, table.concat(descLines, "\n"))
    end
end)
-- =====================================================
-- AUTO COLLECT PART (Dropler Incremental)
-- =====================================================
Config.AutoCollectPart = false

local CollectRemote = ReplicatedStorage.Remotes.CollectPart
local SpawnedFolder = workspace:WaitForChild("MapEssentials"):WaitForChild("Spawned")

-- Cache item yang sudah dikirim agar tidak dobel
local collectedCache = {}

-- Bersihkan cache saat item hilang dari folder
SpawnedFolder.ChildRemoved:Connect(function(item)
    collectedCache[item] = nil
end)

local autoCollectToggle = MainTabs:Toggle({
    Title = "Auto Collect Coins",
    Flag = "AutoCollectPart",
    Value = false,
    Callback = function(val)
        Config.AutoCollectPart = val
        if val then
            StartManagedLoop("AutoCollectPart", 0.3, function()
                return Config.AutoCollectPart
            end, function()
                for _, item in ipairs(SpawnedFolder:GetChildren()) do
                    if not collectedCache[item] and not item:GetAttribute("PickedUp") then
                        collectedCache[item] = true
                        pcall(function()
                            CollectRemote:FireServer(item.Name, true) -- true = auto collect
                        end)
                    end
                end
            end)
        else
            StopManagedLoop("AutoCollectPart")
        end
    end
})
FM_Add("Coins", autoCollectToggle)
Config.AutoPowerDeposit = false

local autoPowerDepositToggle = MainTabs:Toggle({
    Title = "Auto Power Deposit",
    Flag = "AutoPowerDeposit",
    Value = false,
    Callback = function(val)
        Config.AutoPowerDeposit = val
        if val then
            StartManagedLoop("AutoPowerDeposit", 2, function()
                return Config.AutoPowerDeposit
            end, function()
                local Framework = require(ReplicatedStorage.Framework)
                Framework.Stat.WaitForLoad(LocalPlayer)
                local depositStat = Framework.Stat.Get(LocalPlayer, "PowerDeposit")
                if depositStat and not depositStat.Value then
                    Framework.Network.Fire("Power")
                end
            end)
        else
            Framework.Stat.Get(LocalPlayer, "PowerDeposit").Value = false
            StopManagedLoop("AutoPowerDeposit")
        end
    end
})
FM_Add("Power", autoPowerDepositToggle)
-- Status update dengan deskripsi seperti client
StartStatusLoop("Status_AutoPowerDeposit", 1, function()
    if not autoPowerDepositToggle then return end

    local powerStat = Framework.Stat.Get(LocalPlayer, "Power")
    local depositStat = Framework.Stat.Get(LocalPlayer, "PowerDeposit")

    local powerIncome = Multipliers.GetPowerIncome(LocalPlayer)
    local powerBoost = Multipliers.GetPowerBoost(LocalPlayer)
    local powerValue = powerStat.Value
    local isDeposit = depositStat.Value == true

    local descLines = {}
    table.insert(descLines, string.format('+%s <font color="#%s">Power</font>/s',
        Suffix.short(powerIncome), powerColor))
    table.insert(descLines, string.format('<font color="#%s">Power</font>: %s',
        powerColor, Suffix.short(powerValue)))
    table.insert(descLines, string.format('Boost: x%s <font color="#%s">Energy</font>',
        Suffix.short(powerBoost), energyColor))
    table.insert(descLines, isDeposit and "Deposit: ON ✅" or "Deposit: OFF ❌")

    SafeSetDesc(autoPowerDepositToggle, table.concat(descLines, "\n"))
end)

-- =====================================================
-- AUTO MERCHANT (Beli Semua Slot yang Mampu)
-- =====================================================
Config.AutoMerchantAll = false
-- Toggle utama
local autoMerchantToggle = MainTabs:Toggle({
    Title = "Merchant",
    Flag = "AutoMerchantAll",
    Value = false,
    Callback = function(val)
        Config.AutoMerchantAll = val
        if val then
            StartManagedLoop("AutoMerchantAll", 1, function()
                return Config.AutoMerchantAll
            end, function()
                local cashObj = Framework.Stat.Get(LocalPlayer, "Cash")
                if not cashObj then return end
                local cash = cashObj.Value or 0

                for slot = 1, 3 do
                    local slotKey = "Slot" .. slot
                    local stockObj = Framework.Stat.Get(LocalPlayer, slotKey .. "Stock")
                    local boostObj = Framework.Stat.Get(LocalPlayer, slotKey .. "Boost")
                    if not (stockObj and boostObj) then continue end

                    local stock = stockObj.Value or 0
                    if stock < 1 then continue end

                    local boostValue = boostObj.Value
                    local price = Merchant.BoostCost[boostValue]
                    if price and BigNum.gte(cash, price) then
                        Framework.Network.Fire("Merchant", "Buy", slotKey)
                    end
                end
            end)
        else
            StopManagedLoop("AutoMerchantAll")
        end
    end
})
FM_Add("Automation", autoMerchantToggle) -- sesuaikan kategori

-- Status loop
StartStatusLoop("Status_AutoMerchantAll", 1, function()
    if not autoMerchantToggle then return end

    local cashObj = Framework.Stat.Get(LocalPlayer, "Cash")
    local cash = cashObj and cashObj.Value or 0

    local affordableCount = 0
    local slotLines = {}
    for slot = 1, 3 do
        local slotKey = "Slot" .. slot
        local stockObj = Framework.Stat.Get(LocalPlayer, slotKey .. "Stock")
        local boostObj = Framework.Stat.Get(LocalPlayer, slotKey .. "Boost")
        if not (stockObj and boostObj) then continue end

        local stock = stockObj.Value or 0
        if stock < 1 then
            table.insert(slotLines, string.format("Slot %d: SOLD OUT", slot))
            continue
        end

        local boostValue = boostObj.Value
        local price = Merchant.BoostCost[boostValue]
        local canBuy = price and BigNum.gte(cash, price)
        if canBuy then affordableCount = affordableCount + 1 end

        local itemName = Boosts[boostValue] and Boosts[boostValue].Display or "Unknown"
        local color = canBuy and "#00ff00" or "#ff0000"
        table.insert(slotLines, string.format('<font color="%s">Slot %d: %s (%s Cash)</font>',
            color, slot, itemName, Suffix.short(price)))
    end

    local descLines = {}
    table.insert(descLines, string.format("Cash: %s", Suffix.short(cash)))
    table.insert(descLines, string.format("Affordable Slots: %d/3", affordableCount))
    table.insert(descLines, " ") -- baris kosong
    for _, line in ipairs(slotLines) do
        table.insert(descLines, line)
    end

    SafeSetDesc(autoMerchantToggle, table.concat(descLines, "\n"))
end)

Config.AutoFighting = false

local autoFightingToggle = MainTabs:Toggle({
    Title = "⚔️ Auto Fighting",
    Flag = "AutoFighting",
    Value = false,
    Callback = function(val)
        Config.AutoFighting = val
        if val then
            StartManagedLoop("AutoFighting", 0.2, function()
                return Config.AutoFighting
            end, function()
                Framework.Stat.WaitForLoad(LocalPlayer)

                if not Features.Fighting.Unlocked(LocalPlayer) then return end
                Framework.Network.Fire("FightingState", true)
                Framework.Network.Fire("MobAttackMlt")
            end)
        else
            StopManagedLoop("AutoFighting")
        end
    end
})
FM_Add("Bones", autoFightingToggle) -- sesuaikan kategori

StartStatusLoop("Status_AutoFighting", 1, function()
    if not autoFightingToggle then return end
    local Framework = require(ReplicatedStorage.Framework)
    local levelObj = Framework.Stat.Get(LocalPlayer, "FightingLevel")
    local healthObj = Framework.Stat.Get(LocalPlayer, "EnemyHealth")
    local killsObj = Framework.Stat.Get(LocalPlayer, "EnemiesKilled")
    local level = levelObj and levelObj.Value or 0
    local health = healthObj and healthObj.Value or 0
    local kills = killsObj and killsObj.Value or 0
    SafeSetDesc(autoFightingToggle, string.format(
        "Level: %d\nHP: %s\nKills: %s",
        level, Suffix.short(health), Suffix.short(kills)
    ))
end)
Config.AutoTree = false

local autoTreeToggle = MainTabs:Toggle({
    Title = "Auto Chop Tree",
    Flag = "AutoTree",
    Value = false,
    Callback = function(val)
        Config.AutoTree = val
        if val then
            StartManagedLoop("AutoTree", 0.2, function()
                return Config.AutoTree
            end, function()
                Framework.Network.Fire("TreeHit")
            end)
        else
            StopManagedLoop("AutoTree")
        end
    end
})
FM_Add("Wood", autoTreeToggle) -- sesuaikan kategori

StartStatusLoop("Status_AutoTree", 1, function()
    if not autoTreeToggle then return end
    local treeHits = Framework.Stat.Get(LocalPlayer, "TreeHits")
    local hits = treeHits and treeHits.Value or 0
    SafeSetDesc(autoTreeToggle, string.format("Tree Hits: %s", Suffix.short(hits)))
end)

Config.AutoShrine = {}
-- =====================================================
-- AUTO SHRINE (Dropler Incremental)
-- =====================================================
local autoShrineToggles = {}
local shrineGroup = nil
local shrineCount = 0

-- Loop setiap stat yang terdaftar di ShrineStats
for _, shrineData in pairs(ShrineStats) do
    if shrineData.Stat then
        local statName = shrineData.Stat
        local displayName = shrineData.Display or statName

        -- Buat group baru setiap 2 toggle agar rapi
        if shrineCount % 2 == 0 then
            shrineGroup = MainTabs:Group({})
            FM_Add("Shrine", shrineGroup)
        end

        local toggle = shrineGroup:Toggle({
            Title = displayName,
            Flag = "AutoShrine_" .. statName,
            Value = false,
            Callback = function(val)
                Config.AutoShrine[statName] = val
                if val then
                    StartManagedLoop("AutoShrine_" .. statName, 2, function()
                        return Config.AutoShrine[statName] == true
                    end, function()
                        -- Deposit semua stat ini ke Shrine
                        Framework.Network.Fire("ShrineDeposit", statName, true)
                    end)
                else
                    StopManagedLoop("AutoShrine_" .. statName)
                end
            end
        })

        autoShrineToggles[statName] = toggle
        shrineCount = shrineCount + 1
    end
end

-- Status update untuk setiap toggle Shrine
StartStatusLoop("Status_AutoShrine", 1, function()
    for statName, toggle in pairs(autoShrineToggles) do
        if not toggle then continue end

        -- Cari data stat untuk mendapatkan warna
        local shrineData = nil
        for _, data in pairs(ShrineStats) do
            if data.Stat == statName then
                shrineData = data
                break
            end
        end
        if not shrineData then continue end

        local statObj = Framework.Stat.Get(LocalPlayer, statName)
        local statValue = statObj and statObj.Value or 0
        local colorHex = shrineData.Color and shrineData.Color:ToHex() or "#FFFFFF"

        -- Judul toggle
        local title = shrineData.Display or statName
        if Config.AutoShrine[statName] then
            title = title .. " (ON)"
        end
        SafeSetTitle(toggle, title)

        -- Deskripsi menampilkan multiplier stat saat ini
        local desc = string.format(
            'Multiplier: <font color="#%s">x%s</font>',
            colorHex,
            Suffix.short(statValue)
        )
        SafeSetDesc(toggle, desc)
    end
end)
-- =====================================================
-- AUTO EQUIP ALL ENERGY (Dropler Incremental)
-- =====================================================
local autoEquipEnergyToggle = MainTabs:Toggle({
    Title = "Auto Equip All Energy",
    Flag = "AutoEquipAllEnergy",
    Value = false,
    Callback = function(val)
        Config.AutoEquipAllEnergy = val
        if val then
            StartManagedLoop("AutoEquipAllEnergy", 2, function()
                return Config.AutoEquipAllEnergy
            end, function()
                -- Cek fitur Energy terbuka
                if Features.Energy and Features.Energy.Unlocked(LocalPlayer) then
                    local maxEquips = Multipliers.GetEnergyMaxEquips(LocalPlayer)
                    local equippedObj = Framework.Stat.Get(LocalPlayer, "EnergyEquips")
                    local equipped = equippedObj and equippedObj.Value or 0

                    -- Hanya kirim jika:
                    -- 1. maxEquips >= 6 (syarat dari UI client)
                    -- 2. equipped < maxEquips (tombol menunjukkan "Equip", bukan "Unequip")
                    if equipped < maxEquips then
                        Framework.Network.Fire("EquipAllEnergy")
                    end
                end
            end)
        else
            StopManagedLoop("AutoEquipAllEnergy")
        end
    end
})
FM_Add("Energy", autoEquipEnergyToggle)
StartStatusLoop("Status_AutoEquipAllEnergy", 1, function()
    if not autoEquipEnergyToggle then return end

    local maxEquips = Multipliers.GetEnergyMaxEquips(LocalPlayer)
    local equippedObj = Framework.Stat.Get(LocalPlayer, "EnergyEquips")
    local equipped = equippedObj and equippedObj.Value or 0
    local energyIncome = Multipliers.GetEnergyIncome(LocalPlayer)

    local descLines = {}
    table.insert(descLines, string.format("+%s <font color=\"#%s\">Energy</font>/s",
        Suffix.short(energyIncome), StatInformation.Energy.Colour:ToHex()))
    table.insert(descLines, string.format("Equipped: %d / %d", equipped, maxEquips))

    SafeSetDesc(autoEquipEnergyToggle, table.concat(descLines, "\n"))
end)
-- =====================================================
-- AUTO CRAFTING (Dropler Incremental)
-- =====================================================
local Crafting = require(ReplicatedStorage.Modules.Shared.Crafting)
local autoCraftToggles = {}
local craftingGroup = nil
local craftingCount = 0
Config.AutoCrafting = {}
-- Helper untuk menghitung jumlah yang bisa di-craft
local function getCraftableAmount(craftData)
    local minAmount = nil
    for costStat, costValue in pairs(craftData.Cost) do
        local statObj = Framework.Stat.Get(LocalPlayer, costStat)
        if not statObj then return nil end
        local statValue = statObj.Value or 0
        local canCraft = BigNum.floor(BigNum.roundMantissa(BigNum.div(statValue, tostring(costValue)), 12))
        if minAmount then
            minAmount = BigNum.min(minAmount, canCraft)
        else
            minAmount = canCraft
        end
    end
    return minAmount
end

-- Buat array berisi item crafting yang diurutkan berdasarkan Order
local sortedCraftingItems = {}
for itemName, craftData in pairs(Crafting) do
    table.insert(sortedCraftingItems, {
        Name = itemName,
        Data = craftData,
        Order = craftData.Order or 999 -- default jika tidak ada Order
    })
end
table.sort(sortedCraftingItems, function(a, b)
    return a.Order < b.Order
end)

-- Loop item crafting yang sudah diurutkan
for _, entry in ipairs(sortedCraftingItems) do
    local itemName = entry.Name
    local craftData = entry.Data
    local toggle = MainTabs:Toggle({
        Title = itemName,
        Image = GetIconCurrency(craftData.StatName),
        Flag = "AutoCraft_" .. itemName,
        Value = false,
        Callback = function(val)
            Config.AutoCrafting[itemName] = val
            if val then
                StartManagedLoop("AutoCraft_" .. itemName, 2, function()
                    return Config.AutoCrafting[itemName] == true
                end, function()
                    local canCraft = getCraftableAmount(craftData)
                    if canCraft and BigNum.gte(canCraft, "1") then
                        Framework.Network.Fire("Craft", itemName, true) -- craft max
                    end
                end)
            else
                StopManagedLoop("AutoCraft_" .. itemName)
            end
        end
    })
    FM_Add("Rocks", toggle)

    autoCraftToggles[itemName] = toggle
end

-- Status loop untuk menampilkan detail crafting
StartStatusLoop("Status_AutoCrafting", 1, function()
    for itemName, toggle in pairs(autoCraftToggles) do
        if not toggle then continue end

        local craftData = Crafting[itemName]
        if not craftData then continue end

        -- Stat hasil
        local resultStatObj = Framework.Stat.Get(LocalPlayer, craftData.StatName)
        local resultValue = resultStatObj and resultStatObj.Value or 0
        local resultColor = StatInformation[craftData.StatName] and StatInformation[craftData.StatName].Colour:ToHex() or "#FFFFFF"

        -- Jumlah yang bisa di-craft
        local canCraft = getCraftableAmount(craftData)

        -- Judul toggle
        local title = itemName
        if Config.AutoCrafting[itemName] then title = title .. " (ON)" end
        SafeSetTitle(toggle, title)

        -- Deskripsi
        local descLines = {}
        table.insert(descLines, string.format(
            '<font color="#%s">%s</font> (%s)',
            resultColor,
            craftData.StatName,
            Suffix.short(resultValue)
        ))

        if canCraft then
            local colorCan = BigNum.gte(canCraft, "1") and "#00ff00" or "#ff5555"
            table.insert(descLines, string.format(
                'Craftable: <font color="%s">%s</font>',
                colorCan,
                Suffix.short(canCraft)
            ))
        else
            table.insert(descLines, '<font color="#ff5555">Craftable: 0</font>')
        end

        table.insert(descLines, "Cost:")
        for costStat, costValue in pairs(craftData.Cost) do
            local costStatObj = Framework.Stat.Get(LocalPlayer, costStat)
            local costHave = costStatObj and costStatObj.Value or 0
            local costColor = StatInformation[costStat] and StatInformation[costStat].Colour:ToHex() or "#FFFFFF"
            local enough = BigNum.gte(costHave, costValue)
            local enoughColor = enough and "#ffffff" or "#ff5555"
            table.insert(descLines, string.format(
                '• <font color="#%s">%s</font>: <font color="%s">%s</font> / %s',
                costColor, costStat, enoughColor, Suffix.short(costHave), Suffix.short(costValue)
            ))
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
