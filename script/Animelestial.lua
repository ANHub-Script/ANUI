if game.PlaceId ~= 104470677863797 then return end
repeat task.wait() until game:IsLoaded()

loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading3.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local FolderPath = "ANUI/AnimeFrontiers"
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local IsPremium = false
local ValidKeys = {"ANHUB-2025"}
local MapDBFile = "Map_Database.json"
local Config = {
    SelectedEnemy = nil,
    MapConfigurations = {},
    AutoFarm = false
}
local ConfigName = "ANConfig"
local CurrentMapEnemiesCache = {}
local IsLoadingConfig = false
local IsLoadingMapSelection = false

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
            Callback = function() setclipboard("https://discord.gg/cy6uMRmeZ") Notify("Discord", "Invite link copied!", "geist:logo-discord") end
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
    Title = "AN Hub - Anime Frontiers",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeFrontiers",
    Size = UDim2.fromOffset(580, 460),
    KeySystem = {
        Enabled = not IsPremium,
        Title = "ANHub Access",
        Description = "Free Key: ANHUB-2025",
        Key = ValidKeys,
        URL = "https://discord.gg/cy6uMRmeZ",
        Note = "Premium Users are auto-verified!",
        SaveKey = true
    }
})

task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
Window:Tab({
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Celestial" }),
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

local FM_Categories = {}
local FM_CategoryDescriptions = {
    ["Farm"] = "Auto farm enemies and specific targets."
}

local function FM_GetElementFrame(elem)
    return rawget(elem, "ElementFrame") or (elem.UIElements and elem.UIElements.Main) or rawget(elem, "GroupFrame")
end

local function FM_UpdateTabProfile(selected)
    local desc = FM_CategoryDescriptions[selected] or ""
    local containers = {}
    if FarmTab and FarmTab.UIElements then
        table.insert(containers, FarmTab.UIElements.ContainerFrameCanvas)
        table.insert(containers, FarmTab.UIElements.ContainerFrame)
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

-- [[ FARM TAB ]] --
FarmTab = Window:Tab({
    Title = "Main Feature",
    Icon = "swords",
    Profile = MakeProfile({
        Avatar = GameIconURL,
        Title = "Main Feature",
        Desc = "Anime Celestial"
    }),
    SidebarProfile = false
});

-- Pembuatan Selector Kategori
FM_CategorySelector = FarmTab:Category({
    Title = "Select Category",
    Default = "Farm",
    Options = {
        {Title = "Farm", Icon = "sword"},
    },
    Callback = FM_OnChange
})

-- PERBAIKAN JARAK: Mengatur posisi Category Frame dan Container
if FM_CategorySelector.ElementFrame then 
    FM_CategorySelector.ElementFrame.Parent = FarmTab.UIElements.ContainerFrameCanvas 
    FM_CategorySelector.ElementFrame.Position = UDim2.new(0, 0, 0, FarmTab.UIElements.ContainerFrame.Position.Y.Offset)
    
    local catSize = FM_CategorySelector.ElementFrame.Size.Y.Offset
    FarmTab.UIElements.ContainerFrame.Position = UDim2.new(0, 0, 0, FarmTab.UIElements.ContainerFrame.Position.Y.Offset + catSize)
    FarmTab.UIElements.ContainerFrame.Size = UDim2.new(1, 0, 1, FarmTab.UIElements.ContainerFrame.Size.Y.Offset - catSize)
    
    local pad = FarmTab.UIElements.ContainerFrame:FindFirstChildOfClass("UIPadding")
    if pad then pad.PaddingTop = UDim.new(0, 5) end
end


-- FEATURE 
-- Jalur langsung ke MetaService
local MetaService = require(LocalPlayer.PlayerScripts.MetaService)
task.spawn(function()
    local lastPower = nil -- Variabel untuk menyimpan nilai terakhir
    
    while not Window.Destroyed do
        local data = MetaService.Data
        if data and data.TotalStats then
            getgenv().PlayerData = data
            local currentPower = data.TotalStats["Total Power"]
            
            -- Hanya print jika power berubah
            if currentPower ~= lastPower then
                print("Power Updated: " .. tostring(currentPower))
                lastPower = currentPower
            end
        end
        
        getgenv().EnemiesData = MetaService.Cache.Enemies
        task.wait(10)
    end
end)
local function GetCurrentMapName()
    local PlayerData = getgenv().PlayerData
    if PlayerData and PlayerData.Map and PlayerData.Map ~= "" then
        return PlayerData.Map
    end
    return "Unknown"
end

local function LoadMapDB()
    local path = FolderPath .. "/" .. MapDBFile
    if not isfile or not isfile(path) then return end
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if success and type(result) == "table" then
        Config.MapConfigurations = result
    end
end

local function SaveMapConfig(mapName, selectedItem)
    if not mapName or mapName == "" or mapName == "Unknown" then return end
    if not selectedItem then return end
    local val
    local title
    if typeof(selectedItem) == "table" then
        if selectedItem.Value ~= nil or selectedItem.Title ~= nil then
            val = selectedItem.Value
            title = selectedItem.Title
        else
            local first = selectedItem[1]
            if first == nil then return end
            if typeof(first) == "table" then
                val = first.Value
                title = first.Title
            else
                val = first
                title = first
            end
        end
    else
        val = selectedItem
        title = selectedItem
    end
    if not val or val == "" or val == "None" then return end
    if (not title or title == "") and type(CurrentMapEnemiesCache) == "table" then
        for _, cached in ipairs(CurrentMapEnemiesCache) do
            if cached.Value == val then
                title = cached.Title or title
                break
            end
        end
    end
    local savedEntry = {
        Title = title,
        Value = val
    }
    Config.MapConfigurations[mapName] = savedEntry
    if makefolder and (not isfolder or not isfolder(FolderPath)) then
        pcall(function()
            makefolder(FolderPath)
        end)
    end
    if writefile and HttpService then
        pcall(function()
            writefile(FolderPath .. "/" .. MapDBFile, HttpService:JSONEncode(Config.MapConfigurations))
        end)
    end
end

local function NormalizeEnemySelection(value)
    if value == nil then return nil end

    if typeof(value) == "string" then
        if value == "" or value == "None" then return nil end
        return { value }
    end

    if typeof(value) ~= "table" then return nil end

    if value.Value ~= nil or value.Title ~= nil then
        local v = value.Value or value.Title
        if v == nil or v == "" or v == "None" then return nil end
        return { v }
    end

    local out = {}
    for _, item in ipairs(value) do
        local v
        if typeof(item) == "table" then
            v = item.Value or item.Title
        else
            v = item
        end
        if v and v ~= "" and v ~= "None" then
            table.insert(out, v)
        end
    end
    if #out == 0 then return nil end
    return out
end

local function BuildSelectedEnemySet(selected)
    if selected == nil then return nil end

    if typeof(selected) == "string" then
        if selected == "" or selected == "None" then return nil end
        return { [selected] = true }
    end

    if typeof(selected) ~= "table" then return nil end

    local set = {}
    local count = 0

    for _, item in ipairs(selected) do
        local v
        if typeof(item) == "table" then
            v = item.Value or item.Title
        else
            v = item
        end
        if v and v ~= "" and v ~= "None" and not set[v] then
            set[v] = true
            count += 1
        end
    end

    for k, v in pairs(selected) do
        if typeof(k) == "string" and v == true and not set[k] then
            set[k] = true
            count += 1
        end
    end

    if count == 0 then return nil end
    return set
end

local function ApplySavedEnemyForMap(mapName, enemiesList)
    if not mapName or mapName == "" or mapName == "Unknown" then return end
    
    local savedEntry = Config.MapConfigurations[mapName]
    if not savedEntry or not enemiesList then return end

    IsLoadingMapSelection = true 
    
    local foundEnemyTable = nil
    for _, enemy in ipairs(enemiesList) do
        -- Cocokkan berdasarkan 'Value' (nama asli musuh)
        if enemy.Value == savedEntry.Value then
            foundEnemyTable = enemy
            break
        end
    end
    
    if foundEnemyTable then
        if EnemyDropdown and EnemyDropdown.Multi then
            Config.SelectedEnemy = { foundEnemyTable.Value }
        else
            Config.SelectedEnemy = foundEnemyTable.Value
        end
        pcall(function()
            if IsWindowOpen() and EnemyDropdown and EnemyDropdown.Select then
                if EnemyDropdown.Multi then
                    EnemyDropdown:Select({ foundEnemyTable })
                else
                    EnemyDropdown:Select(foundEnemyTable)
                end
            end
        end)
    else
        Config.SelectedEnemy = nil
    end
    
    -- Beri jeda sedikit agar callback selesai diproses sebelum flag dimatikan
    task.wait(0.2)
    IsLoadingMapSelection = false 
end
local MobDrops = require(ReplicatedStorage.Modules.MobDrops)
local Items = require(ReplicatedStorage.Modules.Items)
local GradientsFolder = game:GetService("ReplicatedStorage").Modules.MobDrops.Gradients

-- Mapping Suffix untuk Sorting HP
local MasterSuffixes = {"", "K", "M", "B", "T", "qd", "Qn", "sx", "Sp", "`O", "N", "de", "UD", "DD", "tdD", "qdD", "QnD", "sxD", "SpD", "OcD", "NvD", "Vgn", "UVg", "DVg", "TVg", "qtV", "QnV", "SeV", "SPG", "OVG", "NVG", "TGN", "UTG", "DTG", "tsTG", "qtTG", "QnTG", "ssTG", "SpTG", "OcTG", "NoAG", "UnAG", "DuAG", "TeAG", "QdAG", "QnAG", "SxAG", "SpAG", "OcAG", "NvAG", "CT", "CT1", "CT2", "CT3", "CT4", "CT5", "CT6", "CT7", "CT8", "CT9", "CT10", "CT11", "CT12", "CT13", "CT14", "CT15", "CT16", "CT17", "CT18", "CT19", "CT20", "CT21", "CT22", "CT23"}
local SuffixMapping = {}
for i, v in ipairs(MasterSuffixes) do SuffixMapping[v] = math.pow(1000, i - 1) end

local function DeformatHealth(str)
    if not str then return 0 end
    local numStr, suffix = tostring(str):match("([%d%.]+)(.*)")
    local num = tonumber(numStr) or 0
    suffix = suffix and suffix:gsub("%s+", "") or ""
    return suffix ~= "" and SuffixMapping[suffix] and (num * SuffixMapping[suffix]) or num
end
local function GetClosestEnemy(selectedSet)
    selectedSet = selectedSet or BuildSelectedEnemySet(Config.SelectedEnemy)
    if not selectedSet or not getgenv().EnemiesData or not LocalPlayer.Character then return nil, nil end

    local closestPart = nil
    local closestID = nil -- Tambahkan ini untuk melacak ID
    local shortestDistance = math.huge
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil end

    for id, data in pairs(getgenv().EnemiesData) do
        local infoName = data.Info and data.Info.Name
        local baseName = data.Name
        local nameMatch = (infoName and selectedSet[infoName] == true) or (baseName and selectedSet[baseName] == true)
        
        if nameMatch then
            local isAlive = false
            
            -- Cek Health dari data.Object
            if data.Object and typeof(data.Object) == "Instance" then
                local currentHealth = data.Object:GetAttribute("Health")
                if currentHealth and currentHealth > 0 then
                    isAlive = true
                end
            end

            if isAlive and data.Model and data.Model:FindFirstChild("HumanoidRootPart") then
                local root = data.Model.HumanoidRootPart
                local dist = (myRoot.Position - root.Position).Magnitude
                
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestPart = root
                    closestID = id -- Simpan ID musuh terdekat
                end
            end
        end
    end
    return closestPart, closestID
end

local function GetEnemiesForCurrentMap()
    local currentNames = {}
    local addedEnemies = {} 
    
    local PlayerData = getgenv().PlayerData
    local CurrentMapName = PlayerData and PlayerData.Map or "Unknown"
    local LiveEnemies = getgenv().EnemiesData or {}

    for _, enemyData in pairs(LiveEnemies) do
        -- Filter Map dan Uniqueness
        if enemyData.Map == CurrentMapName and enemyData.Name and not addedEnemies[enemyData.Name] then
            addedEnemies[enemyData.Name] = true
            
            local enemyName = enemyData.Name
            local info = enemyData.Info or {}
            local enemyHealth = info.Health or "0"
            local enemyRarity = info.Rarity or "Common"
            
            -- Konversi HP ke angka untuk sorting
            local numericHealth = DeformatHealth(enemyHealth)
            
            -- Ambil Gradient
            local enemyColorObj = GradientsFolder:FindFirstChild(enemyRarity)
            local enemyGradient = enemyColorObj and enemyColorObj.Color or nil
            
            -- List Drops
            local dropIcons = {}
            local rawDrops = MobDrops.GetMobDrops(MobDrops, {Name = enemyName})
            
            if rawDrops then
                for itemID, dropInfo in pairs(rawDrops) do
                    local itemDetail = Items[itemID]
                    if itemDetail then
                        local itemColorObj = GradientsFolder:FindFirstChild(itemDetail.Rarity)
                        
                        table.insert(dropIcons, {
                            Card = true,
                            Title = itemDetail.Name,
                            -- Menggunakan string.format untuk persentase
                            Quantity = string.format("%d%%", dropInfo.Chance * 100),
                            Image = itemDetail.Icon,
                            Gradient = itemColorObj and itemColorObj.Color or nil
                        })
                    end
                end
            end

            -- Masukkan ke tabel dropdown
            table.insert(currentNames, {
                -- Menggunakan string.format untuk Title dan Desc
                Title = string.format("%s [%s]", enemyName, enemyRarity),
                Desc = string.format("HP: %s", enemyHealth),
                Value = enemyName,
                Images = dropIcons,
                Gradient = enemyGradient,
                RawHealth = numericHealth 
            })
        end
    end

    -- Handling jika kosong
    if #currentNames == 0 then
        table.insert(currentNames, {Title = "No Enemies In This Map", Value = "None", RawHealth = 0})
    end

    -- SORTING: Dari HP Terendah ke Tertinggi
    table.sort(currentNames, function(a, b) 
        return (a.RawHealth or 0) < (b.RawHealth or 0) 
    end)
    
    return currentNames
end

-- Dropdown Musuh
LoadMapDB()
CurrentMapEnemiesCache = GetEnemiesForCurrentMap()
EnemyDropdown = FarmTab:Dropdown({
    Title = "Select Enemy",
    Values = CurrentMapEnemiesCache,
    Default = 1,
    Multi = true,
    AllowNone = true,
    Flag = "SelectedEnemy_Flag",
    Callback = function(Value)
        local normalized = NormalizeEnemySelection(Value)
        Config.SelectedEnemy = normalized

        if normalized and not IsLoadingMapSelection then
            SaveMapConfig(GetCurrentMapName(), normalized[1])
        end
    end
})

-- Toggle Auto Farm
local AutoFarmWanted = false
local AutoFarmInternalChange = false
EnemyFarm = FarmTab:Toggle({
    Title = "Auto Farm",
    Desc = "Teleport dan serang musuh",
    Default = false,
    Flag = "AutoFarm_Toggle", -- Flag untuk Save/Load
    Callback = function(val)
        if not AutoFarmInternalChange then
            AutoFarmWanted = val
        end
        Config.AutoFarm = val
    end
})
FM_Add("Farm", EnemyDropdown)
FM_Add("Farm", EnemyFarm)

task.spawn(function()
    while not Window.Destroyed do
        local pData = getgenv().PlayerData
        local currentMap = GetCurrentMapName()
        local pMaps = pData and pData.Inventory and pData.Inventory.Maps
        local allowed = false
        if pMaps and currentMap and currentMap ~= "" and currentMap ~= "Unknown" then
            allowed = (pMaps[currentMap] == true)
        end
        if not allowed then
            if Config.AutoFarm then
                Config.AutoFarm = false
            end
            if EnemyFarm and EnemyFarm.Value and IsWindowOpen() then
                AutoFarmInternalChange = true
                pcall(function()
                    EnemyFarm:Set(false)
                end)
                AutoFarmInternalChange = false
            end
        else
            if AutoFarmWanted and not Config.AutoFarm then
                Config.AutoFarm = true
                if EnemyFarm and not EnemyFarm.Value and IsWindowOpen() then
                    AutoFarmInternalChange = true
                    pcall(function()
                        EnemyFarm:Set(true)
                    end)
                    AutoFarmInternalChange = false
                end
            end
        end
        task.wait(0.25)
    end
end)

local currentTargetID = nil 

-- [[ REPLACEMENT LOGIC UNTUK AUTO FARM ]] --
task.spawn(function()
    while not Window.Destroyed do 
        local selectedSet = BuildSelectedEnemySet(Config.SelectedEnemy)
        if Config.AutoFarm and selectedSet then
            local isTargetValid = false
            local targetPart = nil
            
            -- 1. Validasi Target Saat Ini
            if currentTargetID and getgenv().EnemiesData[currentTargetID] then
                local data = getgenv().EnemiesData[currentTargetID]
                local infoName = data.Info and data.Info.Name
                local baseName = data.Name
                
                -- Syarat Valid: ID ada, HP > 0, Nama sesuai, dan Model ada
                local nameOk = (infoName and selectedSet[infoName] == true) or (baseName and selectedSet[baseName] == true)
                if data.Object and data.Object:GetAttribute("Health") > 0 and nameOk then
                    if data.Model and data.Model:FindFirstChild("HumanoidRootPart") then
                        isTargetValid = true
                        targetPart = data.Model.HumanoidRootPart
                    end
                end
            end

            -- 2. Jika Target Valid, Cek Jarak (Teleport jika > 10 Studs)
            if isTargetValid and targetPart then
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local distance = (root.Position - targetPart.Position).Magnitude
                    if distance > 10 then -- LOGIKA JARAK: Jika lebih dari 10 studs
                        root.CFrame = targetPart.CFrame * CFrame.new(0, 0, 3)
                    end
                end
            -- 3. Jika Target Tidak Valid (Mati/Hilang), Cari Target Baru
            else
                local newTargetPart, newTargetID = GetClosestEnemy(selectedSet)
                
                if newTargetPart and newTargetID then
                    currentTargetID = newTargetID 
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- Teleport awal ke target baru
                        root.CFrame = newTargetPart.CFrame * CFrame.new(0, 0, 3)
                    end
                else
                    currentTargetID = nil
                end
            end
        else
            currentTargetID = nil 
        end
        task.wait(0.1) -- Jeda sedikit agar tidak lag namun tetap responsif
    end
end)

-- Perbaikan Loop Map Sync dengan Retry Logic
task.spawn(function()
    local lastMap = nil
    local lastUISyncedMap = nil
    while not Window.Destroyed do
        local currentMap = GetCurrentMapName()

        if currentMap and currentMap ~= lastMap and currentMap ~= "Unknown" then
            lastMap = currentMap

            Config.SelectedEnemy = nil
            currentTargetID = nil

            local newList = GetEnemiesForCurrentMap()
            CurrentMapEnemiesCache = newList

            LoadMapDB()
            ApplySavedEnemyForMap(currentMap, newList)
        end

        if IsWindowOpen() and currentMap and currentMap ~= "Unknown" and currentMap ~= lastUISyncedMap then
            lastUISyncedMap = currentMap

            pcall(function()
                if EnemyDropdown and EnemyDropdown.Select then
                    EnemyDropdown:Select(nil)
                end
                if EnemyDropdown and EnemyDropdown.Refresh then
                    EnemyDropdown:Refresh(CurrentMapEnemiesCache)
                end
            end)

            ApplySavedEnemyForMap(currentMap, CurrentMapEnemiesCache)
        end
        task.wait(1)
    end
end)

-- [[ Settings Tab ]] --
SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings-2" });
SettingsTab:Section({ Title = "Config Manager", Icon = "save", Opened = true });
SettingsTab:Input({
    Title = "Config Name",
    Placeholder = "ANConfig",
    Flag = "ConfigName_Input",
    Callback = function(txt)
        ConfigName = (txt and txt ~= "" and txt) or "ANConfig"
    end
})
SettingsTab:Button({
    Title = "Save Config",
    Icon = "save",
    Callback = function()
        if Window.ConfigManager then
            pcall(function()
                local cfg = Window.ConfigManager:GetConfig(ConfigName) or Window.ConfigManager:CreateConfig(ConfigName)
                cfg:Save()
            end)
        end
        if Config.SelectedEnemy then
            SaveMapConfig(GetCurrentMapName(), Config.SelectedEnemy)
        end
        Notify("Success", "Saved!", "check")
    end
})
SettingsTab:Button({
    Title = "Load Config",
    Icon = "upload",
    Callback = function()
        if Window.ConfigManager then
            local ok = pcall(function()
                local cfg = Window.ConfigManager:GetConfig(ConfigName) or Window.ConfigManager:CreateConfig(ConfigName)
                IsLoadingConfig = true
                cfg:Load()
            end)
            IsLoadingConfig = false
        end
        LoadMapDB()
        ApplySavedEnemyForMap(GetCurrentMapName(), CurrentMapEnemiesCache)
        Notify("Success", "Loaded!", "check")
    end
})
SettingsTab:Button({
    Title = "Delete Config",
    Icon = "trash",
    Callback = function()
        if Window.ConfigManager then
            pcall(function()
                Window.ConfigManager:DeleteConfig(ConfigName)
            end)
        end
        Notify("Success", "Deleted!", "trash")
    end
})
SettingsTab:Button({
    Title = "Rejoin Server",
    Icon = "rotate-cw",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        -- Melakukan teleportasi ulang ke PlaceId yang sama
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end
})
-- [[ PERFORMANCE / FPS BOOST SECTION ]] --
SettingsTab:Section({ Title = "Performance & FPS Boost", Icon = "zap", Opened = false });

local function ApplyFPSBoost()
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    
    -- Lighting & Effects
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    
    for _, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false
        end
    end

    -- Terrain
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
    end

    -- Workspace Objects
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        elseif v:IsA("Explosion") then
            v.Visible = false
        end
    end
    
    Notify("FPS Boost", "Performance settings applied!", "zap")
end

SettingsTab:Toggle({
    Title = "High Performance Mode",
    Desc = "Menghapus tekstur, bayangan, dan efek untuk menaikkan FPS.",
    Default = false,
    Callback = function(val)
        if val then
            ApplyFPSBoost()
        else
            Notify("Info", "Rejoin server untuk mengembalikan grafik normal.", "info")
        end
    end
})

SettingsTab:Button({
    Title = "Clean Workspace (Lag Fix)",
    Icon = "trash-2",
    Desc = "Menghapus sampah visual di workspace.",
    Callback = function()
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and v.Transparency == 1 and not v:IsA("Terrain") then
                -- v:Destroy() -- Hati-hati dengan ini, bisa menghapus part penting
            end
        end
        Notify("Cleaned", "Workspace items optimized.", "check")
    end
})
-- [[ ADVANCED SMOOTHNESS FUNCTIONS ]] --
local function Toggle3DRendering(state)
    -- Benar-benar mematikan render dunia (layar jadi abu-abu/putih)
    -- Ini adalah cara paling efektif untuk menghemat baterai/listrik saat AFK
    game:GetService("RunService"):Set3dRenderingEnabled(not state)
end

local function MuteAllSounds()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Sound") then
            v.Volume = 0
        end
    end
end

local function BoostCPU()
    -- Mengatur kualitas render internal Roblox ke level terendah
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Low
end
-- Toggle untuk mematikan Rendering 3D
SettingsTab:Toggle({
    Title = "CPU Mode (White Screen)",
    Desc = "Mematikan render 3D. Sangat cocok untuk AFK semalaman (Hemat GPU).",
    Default = false,
    Callback = function(val)
        Toggle3DRendering(val)
        if val then
            Notify("CPU Mode", "3D Rendering Disabled for performance.", "monitor-off")
        else
            Notify("CPU Mode", "3D Rendering Enabled.", "monitor")
        end
    end
})

-- Toggle untuk Mute Suara (Mengurangi beban CPU audio)
SettingsTab:Toggle({
    Title = "Mute All Sounds",
    Desc = "Mematikan semua suara di dalam game.",
    Default = false,
    Callback = function(val)
        if val then MuteAllSounds() end
    end
})

-- Tombol untuk Force Low Quality (Engine Level)
SettingsTab:Button({
    Title = "Force Ultra Low Quality",
    Icon = "mouse-pointer-2",
    Desc = "Memaksa engine Roblox menggunakan settingan terendah.",
    Callback = function()
        BoostCPU()
        Notify("Success", "Engine optimized for low-end PC.", "check")
    end
})
FM_OnChange("Farm")

Window:SelectTab(FarmTab.Index);

-- Cari bagian paling bawah script (task.spawn terakhir) dan ganti dengan ini:
task.spawn(function()
    task.wait(1.5)
    local CM = Window.ConfigManager
    if not CM then return end
    
    pcall(function()
        local cfg = CM:GetConfig(ConfigName) or CM:CreateConfig(ConfigName)
        
        -- Mulai proses loading
        IsLoadingConfig = true 
        cfg:Load()
        
        -- BERI JEDA: Memberikan waktu UI untuk mengganti status Toggle secara visual
        task.wait(0.5) 
        
        -- Selesai loading, baru izinkan auto-save bekerja
        IsLoadingConfig = false 
        
        LoadMapDB()
        CurrentMapEnemiesCache = GetEnemiesForCurrentMap()
        ApplySavedEnemyForMap(GetCurrentMapName(), CurrentMapEnemiesCache)
    end)

    -- Loop Auto Save 10 Detik
    while not Window.Destroyed do
        task.wait(10)
        -- Hanya simpan jika tidak sedang dalam proses loading manual
        if not IsLoadingConfig then
            pcall(function()
                local cfg = CM:GetConfig(ConfigName)
                if cfg then cfg:Save() end
            end)
            if Config.SelectedEnemy then
                SaveMapConfig(GetCurrentMapName(), Config.SelectedEnemy)
            end
        end
    end
end)
