-- if game.PlaceId ~= 81897457567012 then return end

repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Noob Incremental"
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

local FolderPath = "ANUI/NoobIncremental"
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
    Title = "AN Hub - Noob Incremental",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "NoobIncremental",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Noob Incremental" }),
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
UpgradesTab = Window:Tab({
    Title = "Upgrades Feature",
    Icon = GetIcon(110531043066064),
    Profile = MakeProfile({
        Avatar = GameIconURL,
        Title = "Upgrades",
        Desc = "Noob Incremental"
    }),
    SidebarProfile = false
})
-- [[ MAIN TAB ]] --
NoobTab = Window:Tab({
    Title = "Noob Feature",
    Icon = GetIcon(122657115968025),
    Profile = MakeProfile({
        Avatar = GameIconURL,
        Title = "Upgrades",
        Desc = "Noob Incremental"
    }),
    SidebarProfile = false
})
local FM_Categories = {}
FM_CategoryDescriptions = {}
local function FM_GetElementFrame(elem)
    return rawget(elem, "ElementFrame") or (elem.UIElements and elem.UIElements.Main) or rawget(elem, "GroupFrame")
end

local function FM_UpdateTabProfile(selected)
    local desc = FM_CategoryDescriptions[selected] or ""
    local containers = {}
    if UpgradesTab and UpgradesTab.UIElements then
        table.insert(containers, UpgradesTab.UIElements.ContainerFrameCanvas)
        table.insert(containers, UpgradesTab.UIElements.ContainerFrame)
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


-- ============ URUTAN TIPE UPGRADE (SESUAI MODULE) ============
local TypeOrder = {
    "Oof",
    "Rebirth",
    "Fire",
    "Blaze",
    "Cash",
    "Bread",
    "Coin",
    "Gem",
    "Water",
    "Wood",
    "Ice",
    "Planks",
    "HackPoints",
    "Goals",
    "Meat",
    "Bones",
    "Souls",
    "Sand",
    "Stars",
    "SpacePoints",
    "Moon",
    "Planets",
    "Blackholes",
    "AlienCash",
    "Knowledge",
    "Chips"
}
-- =============================================================
-- ============ MEMBANGUN OPSI KATEGORI ============
local Framework = nil
local UpgradesList = nil

local function GetFramework()
    if Framework then return Framework end
    local s, r = pcall(function()
        return require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Client"))
    end)
    if s and r then Framework = r end
    return Framework
end
local categoryOptions = {}

for _, typeName in ipairs(TypeOrder) do
    table.insert(categoryOptions, {
        Title = typeName,
        Icon = GetFramework().Modules.Icons[typeName]  -- bisa kamu ganti icon per tipe nanti
    })
end
-- Fungsi untuk membuat Category Selector di tab manapun
local function CreateCategorySelector(tab, options, defaultTitle, callback)
    local selector = tab:Category({
        Title = defaultTitle or "Select Category",
        Default = options[1] and options[1].Title or nil,
        Options = options,
        Callback = callback or function() end
    })

    -- Atur posisi jika memungkinkan
    if selector.ElementFrame and tab.UIElements then
        local containerCanvas = tab.UIElements.ContainerFrameCanvas
        local containerFrame = tab.UIElements.ContainerFrame

        if containerCanvas and containerFrame then
            selector.ElementFrame.Parent = containerCanvas
            selector.ElementFrame.Position = UDim2.new(0, 0, 0, containerFrame.Position.Y.Offset)

            local catSize = selector.ElementFrame.Size.Y.Offset
            containerFrame.Position = UDim2.new(0, 0, 0, containerFrame.Position.Y.Offset + catSize)
            containerFrame.Size = UDim2.new(1, 0, 1, containerFrame.Size.Y.Offset - catSize)

            local pad = containerFrame:FindFirstChildOfClass("UIPadding")
            if pad then
                pad.PaddingTop = UDim.new(0, 5)
            end
        end
    end

    return selector
end
FM_CategorySelector = CreateCategorySelector(UpgradesTab, categoryOptions, "Select Upgrade Type", FM_OnChange)

local NoobTabOrder = {
    "Oof",
}

local categoryOptions = {}
for _, typeName in ipairs(NoobTabOrder) do
    table.insert(categoryOptions, {
        Title = typeName,
        Icon = GetFramework().Modules.Icons[typeName]  -- bisa kamu ganti icon per tipe nanti
    })
end
FM_CategorySelector = CreateCategorySelector(NoobTab, categoryOptions, "Noob Section", FM_OnChange)

-- ==================== AUTO UPGRADES (Resource Incremental Style) ====================

local function GetUpgradesList()
    if UpgradesList then return UpgradesList end
    local fw = GetFramework()
    if not fw then return nil end
    UpgradesList = fw.Modules.Upgrades.List
    return UpgradesList
end
Config.Upgraders = Config.Upgraders or {}

local NumberLibs = nil
local AllUpgradesOrdered = {}
local UpgradeToggles = {}
local UpgradeWorkerIndex = 1
local groupSize = 2

local ObserverConnections = {}

local function HasEnabledUpgrades()
    for key, _ in pairs(UpgradeToggles) do
        if Config.Upgraders[key] then
            return true
        end
    end
    return false
end

local function BuildUpgradeList()
    local fw = GetFramework()
    if not fw then return end
    NumberLibs = fw.x
    local list = GetUpgradesList()
    if not list then return end

    -- Kosongkan dulu
    AllUpgradesOrdered = {}

    -- Iterasi sesuai TypeOrder
    for _, upgradeType in ipairs(TypeOrder) do
        local upgrades = list[upgradeType]
        if upgrades then
            FM_CategoryDescriptions[upgradeType] = "All Auto Upgrade On "..upgradeType
            -- Kumpulkan dulu dalam array sementara untuk diurutkan
            local typeUpgrades = {}
            for upgradeId, upgDef in pairs(upgrades) do
                table.insert(typeUpgrades, {
                    type = upgradeType,
                    id = upgradeId,
                    data = upgDef
                })
            end
            -- Urutkan berdasarkan order (jika tidak ada, anggap 0)
            table.sort(typeUpgrades, function(a, b)
                local orderA = a.data.order or 0
                local orderB = b.data.order or 0
                return orderA < orderB
            end)
            -- Masukkan ke AllUpgradesOrdered dengan urutan yang sudah benar
            for _, entry in ipairs(typeUpgrades) do
                table.insert(AllUpgradesOrdered, entry)
            end
        end
    end
end

BuildUpgradeList()
local UpgradeLevels = {}
local CurrencyAmounts = {}
local UpgradeTickPending = false

local function GetMaxLevel(upgDef)
    if type(upgDef.max) == "function" then
        local fw = GetFramework()
        return upgDef.max(fw.Player)
    end
    return upgDef.max or 0
end

local function GetCost(upgDef, currentLevel)
    if upgDef.cost then
        return upgDef.cost(currentLevel + 1)
    end
    return nil
end

local function GetBoostText(upgDef, currentLevel, maxLevel)
    local currentBoost = upgDef.boost and upgDef.boost(currentLevel) or 0
    if currentLevel >= maxLevel then
        return NumberLibs.Short(currentBoost)
    else
        local nextBoost = upgDef.boost(currentLevel + 1)
        return NumberLibs.Short(currentBoost) .. " → " .. NumberLibs.Short(nextBoost)
    end
end
-- =====================================================
-- FUNGSI PEMBELIAN OTOMATIS (DIPERBARUI)
-- =====================================================

-- Kumpulkan semua upgrade yang enabled, belum max, dan mampu dibeli
local function GetAffordableUpgrades()
    local candidates = {}
    local fw = GetFramework()
    if not fw then return candidates end

    for _, entry in ipairs(AllUpgradesOrdered) do
        local key = entry.type .. "_" .. entry.id
        if Config.Upgraders[key] then
            
            -- ✅ Periksa apakah upgrade sudah terbuka (unlock)
            if entry.data.unlock then
                -- panggil fungsi unlock dengan parameter player
                local unlocked = entry.data.unlock(fw.Player)
                if not unlocked then
                    -- lewati upgrade yang masih terkunci
                    continue
                end
            end
            
            local currentLevel = UpgradeLevels[key] or 0
            local maxLevel = GetMaxLevel(entry.data)
            if currentLevel < maxLevel then
                local cost = GetCost(entry.data, currentLevel)
                if cost then
                    local currencyAmount = CurrencyAmounts[entry.type] or 0
                    if NumberLibs.eq(currencyAmount, ">=", cost) then
                        table.insert(candidates, {
                            entry = entry,
                            cost = cost
                        })
                    end
                end
            end
        end
    end

    -- Urutkan dari yang termurah
    table.sort(candidates, function(a, b)
        return NumberLibs.eq(a.cost, "<", b.cost)
    end)
    return candidates
end

-- Proses pembelian batch: beli hingga batchSize upgrade termurah
local function ProcessUpgradeBatch(batchSize)
    local candidates = GetAffordableUpgrades()
    local bought = 0
    for _, cand in ipairs(candidates) do
        if bought >= batchSize then break end
        local entry = cand.entry
        pcall(function()
            local fw = GetFramework()
            fw.Fire("UpgradeUpgradeMax", entry.type, entry.id)
        end)
        bought = bought + 1
    end
end

-- Permintaan tick tetap sama, hanya saja ProcessUpgradeBatch sekarang memprioritaskan termurah
function RequestUpgradeTick()
    if Window.Destroyed then return end
    if UpgradeTickPending then return end
    UpgradeTickPending = true
    task.delay(0.08, function()   -- sedikit lebih cepat (0.08 detik)
        UpgradeTickPending = false
        if Window.Destroyed then return end
        if HasEnabledUpgrades() then
            ProcessUpgradeBatch(8)   -- naikkan menjadi 8 pembelian per tick
        end
    end)
end
-- ============ TAMBAHKAN INI SETELAH BuildUpgradeList ============
-- Kumpulkan semua tipe mata uang unik
local CurrencyOrder = {}
do
    local seen = {}
    for _, entry in ipairs(AllUpgradesOrdered) do
        local t = entry.type
        if not seen[t] then
            seen[t] = true
            table.insert(CurrencyOrder, t)
        end
    end
end

-- ============ FUNGSI ObserveAllUpgrades DIPERBARUI ============
local function ObserveAllUpgrades()
    local fw = GetFramework()
    if not fw then return end
    
    -- Observer level upgrade (seperti yang sudah ada)
    for _, entry in ipairs(AllUpgradesOrdered) do
        local key = entry.type .. "_" .. entry.id
        local conn = fw.Observe(function(newVal)
            UpgradeLevels[key] = tonumber(newVal) or 0
            RequestUpgradeTick()
        end, "UPGRADES", entry.type, entry.id)
        if conn then
            table.insert(ObserverConnections, conn)
        end
        UpgradeLevels[key] = tonumber(fw.Value("UPGRADES", entry.type, entry.id)) or 0
    end

    -- ⬇️ INI YANG HARUS DITAMBAHKAN KEMBALI ⬇️
    for _, currency in ipairs(CurrencyOrder) do
        local conn = fw.OnCurrency(currency, "Amount", function(newAmount)
            CurrencyAmounts[currency] = newAmount
            RequestUpgradeTick()
        end)
        if conn then
            table.insert(ObserverConnections, conn)
        end
    end
end

-- Fungsi pembersihan total
local function CleanupAll()
    -- Putuskan semua observer
    for _, conn in ipairs(ObserverConnections) do
        pcall(function()
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            elseif type(conn) == "function" then
                conn()  -- Beberapa observer mengembalikan fungsi disconnect
            end
        end)
    end
    ObserverConnections = {}
    
    -- Hentikan semua loop yang mungkin masih berjalan
    UpgradeTickPending = false
end

-- Daftarkan cleanup saat Window hancur
if Window.Destroyed then
    Window.Destroyed:Connect(CleanupAll)
else
    -- Jika Window.Destroyed adalah properti boolean, kita perlu loop monitor
    task.spawn(function()
        while not Window.Destroyed do task.wait(0.5) end
        CleanupAll()
    end)
end

-- Mulai observer
ObserveAllUpgrades()

-- =====================================================
-- PEMBUATAN TOGGLE (2 per Group) - DIPERBARUI
-- =====================================================
local currentGroup = nil
local countInGroup = 0
local lastType = nil

for _, entry in ipairs(AllUpgradesOrdered) do
    local key = entry.type .. "_" .. entry.id
    local displayName = entry.data.title or entry.id

    -- Jika tipe berubah, reset hitungan grup
    if entry.type ~= lastType then
        countInGroup = 0
        lastType = entry.type
    end

    -- Buat grup baru setiap kelipatan groupSize (2)
    if countInGroup % groupSize == 0 then
        currentGroup = UpgradesTab:Group({})
        -- Tambahkan grup ke kategori sesuai tipe upgrade
        FM_Add(entry.type, currentGroup)
    end

    local toggle = currentGroup:Toggle({
        Title = displayName,
        Flag = "Upgrades_" .. key,
        Callback = function(val)
            Config.Upgraders[key] = val
            if val then
                RequestUpgradeTick()
            end
        end
    })

    if entry.data.icon then
        toggle:SetMainImage(entry.data.icon, 30)
    end

    UpgradeToggles[key] = toggle
    countInGroup = countInGroup + 1
end

-- =====================================================
-- UPDATE STATUS TOGGLE (dengan caching)
-- =====================================================
local LastStatusCache = {}

local function UpdateToggleStatus()
    if Window.Destroyed then return end
    local fw = GetFramework()
    if not fw then return end

    for _, entry in ipairs(AllUpgradesOrdered) do
        local key = entry.type .. "_" .. entry.id
        local toggle = UpgradeToggles[key]
        if not toggle then continue end

        -- ✅ Cek apakah upgrade sudah terbuka (unlock)
        local isUnlocked = true
        if entry.data.unlock then
            isUnlocked = entry.data.unlock(fw.Player)
        end

        if not isUnlocked then
            toggle:Lock("🔒 Locked")
        else
            toggle:Unlock()
        end

        local currentLevel = UpgradeLevels[key] or 0
        local maxLevel = GetMaxLevel(entry.data)
        local isMaxed = currentLevel >= maxLevel

        local cacheKey = string.format("%s_%d_%d", key, currentLevel, maxLevel)
        if LastStatusCache[key] == cacheKey then continue end
        LastStatusCache[key] = cacheKey

        local titleText = entry.data.title or entry.id
        local descText = ""

        if isMaxed then
            titleText = titleText .. " (MAX)"
            descText = "Boost: " .. GetBoostText(entry.data, currentLevel, maxLevel)
            toggle:Disable()
        else
            titleText = string.format("%s (%d/%d)", titleText, currentLevel, maxLevel)
            local cost = GetCost(entry.data, currentLevel)
            local costText = cost and NumberLibs.Short(cost) or "?"
            local currencyAmount = CurrencyAmounts[entry.type] or 0
            local canAfford = cost and NumberLibs.eq(currencyAmount, ">=", cost)
            local icon = isUnlocked and "🟢" or "🔴"
            if isUnlocked then
                if canAfford then
                    icon = "🟢"
                else
                    icon = "🔴"
                end
            else
                icon = "🔴"
            end
            descText = string.format("%s Cost: %s %s\nBoost: %s",
                icon, costText, entry.type,
                GetBoostText(entry.data, currentLevel, maxLevel))
            toggle:Enable()
        end

        pcall(function()
            toggle:SetTitle(titleText)
            toggle:SetDesc(descText)
        end)
    end
end

task.spawn(function()
    while not Window.Destroyed do
        UpdateToggleStatus()
        task.wait(0.05)
    end
end)

-- ==================== AUTO NOOB (Buy & Upgrade) ====================
local NoobsModule = nil
local PrestigesModule = nil

local function GetNoobsModule()
    if NoobsModule then return NoobsModule end
    local fw = GetFramework()
    if fw then
        NoobsModule = fw.Modules.Noobs
        PrestigesModule = fw.Modules.Prestiges
    end
    return NoobsModule
end

GetNoobsModule()

-- Bangun daftar Noob terurut
local NoobOrder = {}
local NoobDataMap = {}
if NoobsModule then
    local temp = {}
    for name, data in pairs(NoobsModule.List) do
        if not data.special then
            table.insert(temp, { name = name, order = data.order, data = data })
        end
    end
    table.sort(temp, function(a, b) return a.order < b.order end)
    for _, entry in ipairs(temp) do
        table.insert(NoobOrder, entry.name)
        NoobDataMap[entry.name] = entry.data
    end
end

-- Konfigurasi
Config.Noobers = Config.Noobers or {}

-- State Noob
local NoobLevels = {}
local NoobUnlocked = {}
local NoobToggles = {}
local NoobObserverConnections = {}
local NoobTickPending = false

-- Previous Noob mapping
local PreviousNoobMap = {}
for i, name in ipairs(NoobOrder) do
    if i > 1 then
        PreviousNoobMap[name] = NoobOrder[i-1]
    else
        PreviousNoobMap[name] = nil
    end
end

-- Helper: cek apakah suatu Noob bisa dibeli (syarat unlock + uang)
local function CanBuyNoob(noobName)
    local data = NoobDataMap[noobName]
    if not data then return false end
    local fw = GetFramework()
    if not fw then return false end

    -- Sudah unlocked? tidak perlu beli lagi
    if NoobUnlocked[noobName] then return false end

    -- Previous Noob harus unlocked (jika ada)
    local prevName = PreviousNoobMap[noobName]
    if prevName and not NoobUnlocked[prevName] then return false end

    -- Syarat tree node
    if data.requireTreeNode then
        local val = fw.Value("UPGRADE_TREES", data.requireTreeNode.tree, data.requireTreeNode.node)
        if (tonumber(val) or 0) < 1 then return false end
    end

    -- Syarat lab node
    if data.requireLabNode then
        local val = fw.Value("LAB_UI_UPGRADE_TREE", data.requireLabNode)
        if (tonumber(val) or 0) < 1 then return false end
    end

    -- Syarat football node
    if data.requireFootballNode then
        local val = fw.Value("FOOTBALL_UI_UPGRADE_TREE", data.requireFootballNode)
        if (tonumber(val) or 0) < 1 then return false end
    end

    -- Syarat prestige
    if data.requirePrestige then
        local val = fw.Value("FEATURES", "PrestigeAmount")
        if (tonumber(val) or 0) < data.requirePrestige then return false end
    end

    -- Uang cukup
    local currency = data.currency or "Oof"
    local cost = data.noobPrice(1)
    local amount = CurrencyAmounts[currency] or 0
    if not NumberLibs.eq(amount, ">=", cost) then return false end

    return true
end

-- Helper: cek apakah Noob bisa di-upgrade
local function CanUpgradeNoob(noobName)
    local data = NoobDataMap[noobName]
    if not data then return false end
    if not NoobUnlocked[noobName] then return false end

    local level = NoobLevels[noobName] or 1
    -- Tidak ada max level, selalu bisa di-upgrade selama uang cukup
    local cost = data.noobPrice and data.noobPrice(level + 1) -- biaya upgrade ke level berikutnya
    if not cost then return false end

    local currency = data.currency or "Oof"
    local amount = CurrencyAmounts[currency] or 0
    return NumberLibs.eq(amount, ">=", cost)
end

-- Auto Buy: beli Noob pertama yang memenuhi syarat
local function TryBuyNoob()
    for _, name in ipairs(NoobOrder) do
        if Config.Noobers[name] and CanBuyNoob(name) then
            local fw = GetFramework()
            fw.Fire("BuyNoob", name)
            return true
        end
    end
    return false
end

-- Auto Upgrade: upgrade Noob (gunakan Max jika bisa)
local function TryUpgradeNoob()
    local fw = GetFramework()
    local playerData = { FEATURES = { PrestigeAmount = tonumber(fw.Value("FEATURES", "PrestigeAmount")) or 0 } }
    local canMax = PrestigesModule and PrestigesModule.isUnlocked(playerData, "BuyMaxNoobs")

    for _, name in ipairs(NoobOrder) do
        if Config.Noobers[name] and CanUpgradeNoob(name) then
            if canMax then
                fw.Fire("UpgradeNoobMax", name)
            else
                fw.Fire("UpgradeNoob", name)
            end
            return true
        end
    end
    return false
end

local function HasEnabledNoobs()
    for _, name in ipairs(NoobOrder) do
        if Config.Noobers[name] then return true end
    end
    return false
end

local function ProcessNoobBatch()
    -- Prioritaskan beli Noob baru dulu, lalu upgrade
    if TryBuyNoob() then return end
    TryUpgradeNoob()
end

function RequestNoobTick()
    if Window.Destroyed then return end
    if NoobTickPending then return end
    NoobTickPending = true
    task.delay(0.08, function()
        NoobTickPending = false
        if Window.Destroyed then return end
        if HasEnabledNoobs() then
            ProcessNoobBatch()
        end
    end)
end

-- Observer untuk Noob
local function ObserveAllNoobs()
    local fw = GetFramework()
    if not fw then return end

    for _, name in ipairs(NoobOrder) do
        -- Unlock
        local conn = fw.Observe(function(newVal)
            NoobUnlocked[name] = newVal
            RequestNoobTick()
        end, "FEATURES", "NOOBS", name, "Unlocked")
        if conn then table.insert(NoobObserverConnections, conn) end
        NoobUnlocked[name] = fw.Value("FEATURES", "NOOBS", name, "Unlocked")

        -- Level
        conn = fw.Observe(function(newVal)
            NoobLevels[name] = tonumber(newVal) or 0
            RequestNoobTick()
        end, "FEATURES", "NOOBS", name, "Level")
        if conn then table.insert(NoobObserverConnections, conn) end
        NoobLevels[name] = tonumber(fw.Value("FEATURES", "NOOBS", name, "Level")) or 0

        -- Previous Noob unlock (jika ada)
        local prev = PreviousNoobMap[name]
        if prev then
            conn = fw.Observe(function(newVal)
                NoobUnlocked[prev] = newVal
                RequestNoobTick()
            end, "FEATURES", "NOOBS", prev, "Unlocked")
            if conn then table.insert(NoobObserverConnections, conn) end
        end
    end

    -- Juga amati perubahan yang mempengaruhi syarat unlock lainnya
    -- Cukup dipicu oleh RequestNoobTick saat ada perubahan (kita panggil dari UpdateToggleStatus juga)
end

ObserveAllNoobs()

-- Tambahkan observer tambahan untuk tree/lab/football/prestige (pakai loop monitor saja)
-- Kita akan memperbarui status setiap 0.5 detik sekaligus mengecek perubahan.

-- Membuat Toggle untuk NoobTab
local noobCurrentGroup = nil
local noobCountInGroup = 0
for _, name in ipairs(NoobOrder) do
    if noobCountInGroup % 2 == 0 then
        noobCurrentGroup = NoobTab:Group({})
        FM_Add("Oof", noobCurrentGroup)   -- kategori "Noobs" khusus
    end

    local toggle = noobCurrentGroup:Toggle({
        Title = name,
        Image = "rbxassetid://122657115968025",
        Flag = "Noobers_" .. name,
        Callback = function(val)
            Config.Noobers[name] = val
            if val then RequestNoobTick() end
        end
    })

    -- Ikon bisa dari Modules.Icons jika ada, atau fallback
    local icon = GetFramework().Modules.Icons[name]
    if icon then toggle:SetMainImage(icon, 30) end

    NoobToggles[name] = toggle
    noobCountInGroup = noobCountInGroup + 1
end

-- Update Status Toggle Noob
local LastNoobStatusCache = {}
local function UpdateNoobToggleStatus()
    if Window.Destroyed then return end
    local fw = GetFramework()
    if not fw then return end

    for _, name in ipairs(NoobOrder) do
        local toggle = NoobToggles[name]
        if not toggle then continue end

        local data = NoobDataMap[name]
        local unlocked = NoobUnlocked[name]
        local level = NoobLevels[name] or 1

        -- Cek apakah bisa dibeli (hanya jika belum unlocked)
        local canBuy = false
        if not unlocked then
            canBuy = CanBuyNoob(name)
        end

        local cacheKey = string.format("%s_%s_%d_%s", name, tostring(unlocked), level, tostring(canBuy))
        if LastNoobStatusCache[name] == cacheKey then continue end
        LastNoobStatusCache[name] = cacheKey

        local titleText = name
        local descText = ""
        local disabled = false

        if not unlocked then
            titleText = titleText .. " (Locked)"
            local cost = data.noobPrice(1)
            local currency = data.currency or "Oof"
            local amount = CurrencyAmounts[currency] or 0
            local iconStatus = canBuy and "🟢" or "🔴"
            descText = string.format("%s Buy: %s %s", iconStatus, NumberLibs.Short(cost), currency)
        else
            titleText = string.format("%s Lv.%d", name, level)
            local upgradeCost = data.noobPrice(level + 1)
            local currency = data.currency or "Oof"
            local amount = CurrencyAmounts[currency] or 0
            local canUpgrade = upgradeCost and NumberLibs.eq(amount, ">=", upgradeCost)
            local iconStatus = canUpgrade and "🟢" or "🔴"
            descText = string.format("%s Upgrade: %s %s\nProduction: %s",
                iconStatus,
                upgradeCost and NumberLibs.Short(upgradeCost) or "?",
                currency,
                NumberLibs.Short(data.oofGeneration and data.oofGeneration(level) or 0))
            toggle:Enable()
            disabled = false
        end

        pcall(function()
            toggle:SetTitle(titleText)
            toggle:SetDesc(descText)
        end)
    end
end

task.spawn(function()
    while not Window.Destroyed do
        UpdateNoobToggleStatus()
        task.wait(0.5)
    end
end)

-- Daftarkan cleanup untuk Noob observer
local function CleanupNoobAll()
    for _, conn in ipairs(NoobObserverConnections) do
        pcall(function()
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            elseif type(conn) == "function" then
                conn()
            end
        end)
    end
    NoobObserverConnections = {}
    NoobTickPending = false
end

-- Gabungkan cleanup dengan yang sudah ada
local OldCleanupAll = CleanupAll
function CleanupAll()
    OldCleanupAll()
    CleanupNoobAll()
end
-- [[ Settings Tab ]] --
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
FM_OnChange("Oof")
Window:SelectTab(UpgradesTab.Index)

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
