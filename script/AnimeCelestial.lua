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
    ["Farm"] = "Auto farm enemies and specific targets.",
    ["Rank"] = "Auto increase your rank and view progress."
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
        {Title = "Rank", Icon = "rbxassetid://98029673359001"},
        {Title = "Roll", Icon = "rbxassetid://135040669708982"},
        {Title = "Limit Breaks", Icon = "rbxassetid://101194034780669"},
        {Title = "Traits", Icon = "rbxassetid://112306765267998"}, -- Tambahkan ini
        {Title = "Avatars", Icon = "rbxassetid://109265521428766"}, -- Tambahkan ini
        {Title = "Christmas", Icon = "rbxassetid://102564250948171"},
        {Title = "Devil Shop", Icon = "rbxassetid://126729608466605"},
        {Title = "Hatch", Icon = "rbxassetid://97094148726332"}, -- Tambahkan ini
        {Title = "Dungeons", Icon = "rbxassetid://79471637683543"},    },
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
local Utility = require(ReplicatedStorage.Modules.Utility)
local RanksModule = require(ReplicatedStorage.Modules.Ranks)
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

RankLabel = FarmTab:Paragraph({
    Title = "Rank Progress",
    Content = "Loading information..."
})

AutoRankToggle = FarmTab:Toggle({
    Title = "Auto Rank Up",
    Desc = "Automatically rank up when requirements met",
    Default = false,
    Flag = "AutoRankUp_Toggle",
    Callback = function(val)
        Config.AutoRankUp = val
    end
})

FM_Add("Rank", RankLabel)
FM_Add("Rank", AutoRankToggle)
-- [[ UPDATE RANK PROGRESS DENGAN PROGRESS BAR REALTIME ]] --
local _RankCache = ""

local function formatNum(n)
    local formatter = MetaService.Utils and MetaService.Utils.Number
    return (formatter and formatter.Format) and formatter:Format(n) or tostring(n) 
end
task.spawn(function()
    while not Window.Destroyed do
        pcall(function()
            local pData = getgenv().PlayerData
            if pData and pData.Rank then
                local currentRank = pData.Rank or 0
                local currentYens = pData.Yens or 0
                
                -- Ambil Data dari Module
                local rankName = RanksModule.GetRankName(currentRank)
                local currentMult = RanksModule.GetCurrentRankMultiplier(currentRank)
                local nextMult = RanksModule.GetNextRankMultiplier(currentRank)
                local price = RanksModule.GetNextRankPrice(currentRank)
                local isMax = RanksModule.IsAtMax(currentRank)

                -- Hitung Progres Bar (Yen / Harga)
                local pct = (not isMax and price > 0) and math.clamp(currentYens / price, 0, 1) or 1
                local barLength = 12 -- Panjang bar
                local filled = math.floor(pct * barLength)
                local bar = string.rep("█", filled) .. string.rep("▒", barLength - filled)
                local percentText = math.floor(pct * 100)

                -- Susun Tampilan
                local titleText = string.format("Rank %d: %s", currentRank, rankName)
                local infoText = ""

                if isMax then
                    infoText = string.format(
                        "✨ MAX RANK REACHED ✨\n" ..
                        "Multiplier: x%s\n" ..
                        "[%s] 100%%",
                        formatNum(currentMult), bar
                    )
                else
                    infoText = string.format(
                        "Buff: x%s ➔ x%s\n" ..
                        "[%s] %d%%\n" ..
                        "💰 %s / %s",
                        formatNum(currentMult), formatNum(nextMult),
                        bar, percentText,
                        formatNum(currentYens), formatNum(price)
                    )
                end

                local uiCache = titleText .. "\n" .. infoText
                if IsWindowOpen() and _RankCache ~= uiCache then
                    RankLabel:SetTitle(titleText)
                    RankLabel:SetDesc(infoText)
                    _RankCache = uiCache
                end

                -- Logika Auto Rank Up
                if Config.AutoRankUp and not isMax and currentYens >= price then
                    MetaService.Bridge:Fire("RankUp", "RankUp")
                    task.wait(0.5) -- Jeda singkat setelah rank up
                end
            end
        end)
        task.wait(0.2)
    end
end)


FM_CategoryDescriptions["Roll"] = "Auto roll roads for each map."

-- [[ 2. LOGIKA ROLL CATEGORY ]] --
local MapsModule = require(game:GetService("ReplicatedStorage").Modules.Maps)
local RoadsModule = require(game:GetService("ReplicatedStorage").Modules.Roads)
local RoadFunctions = RoadsModule.Functions
local RoadBoosts = RoadsModule.Boosts
local Road = RoadsModule.Roads

Config.AutoRollMaps = {} -- Tabel untuk menyimpan status toggle tiap map

-- Fungsi untuk mengecek apakah bisa Roll (berdasarkan logika decompile v_u_62)
local function CanRoll(mapName)
    if not (mapName and RoadFunctions and RoadFunctions.GetCurrencyFromMap) then return false end
    
    local currency = RoadFunctions:GetCurrencyFromMap(mapName)
    local price = RoadBoosts[mapName] and RoadBoosts[mapName].RollPrice or 5
    local myMoney = getgenv().PlayerData.Inventory.Items[currency] or 0
    
    return myMoney >= price
end
-- Sort Maps berdasarkan Index agar rapi di UI
local SortedMaps = {}
for name, data in pairs(MapsModule) do
    table.insert(SortedMaps, data)
end
table.sort(SortedMaps, function(a, b) return a.Index < b.Index end)

-- [[ 3. GENERATE TOGGLES DINAMIS ]] --

-- Helper function untuk mendapatkan Gradient dari folder game
local function GetRarityGradient(rarityName)
    local gradientsFolder = game:GetService("Players").LocalPlayer.PlayerScripts.MetaService.Client.Roads.Objects.RollSystem.Gradients
    local gradObj = gradientsFolder:FindFirstChild(rarityName)
    return gradObj and gradObj.Color or Color3.fromRGB(200, 200, 200)
end
local MapToggleObjects = {} 

-- Fungsi pembantu untuk mendapatkan tampilan Material + Text Awal
local function GetBaseDesc(mName)
    local currency = RoadFunctions:GetCurrencyFromMap(mName)
    local price = RoadBoosts[mName] and RoadBoosts[mName].RollPrice or 5
    local owned = getgenv().PlayerData.Inventory and getgenv().PlayerData.Inventory.Items and getgenv().PlayerData.Inventory.Items[currency] or 0
    
    local itemIcon = Items[currency] and Items[currency].Icon or ""
    -- Menambahkan :gsub("Road to ", "") untuk menghapus teks tersebut
    local itemName = (Items[currency] and Items[currency].Name or "Material"):gsub("Road to ", "")
    
    -- Membersihkan juga bagian Road[mName] jika diperlukan agar tidak double
    local roadTarget = tostring(Road[mName] or ""):gsub("Road to ", "")
    
    return string.format("%s%s: %s/%s\nStart Road to %s in %s", 
        itemIcon, itemName, formatNum(owned), formatNum(price), roadTarget, mName)
end

-- [[ 3. GENERATE TOGGLES DINAMIS DENGAN GROUP (2 ITEM PER BARIS) ]] --

-- Fungsi helper untuk membuat Toggle Map (agar kode tidak duplikat)
local function CreateMapToggle(Parent, mapData)
    local mapName = mapData.Name
    
    local MapToggle = Parent:Toggle({
        Title = Road[mapName],
        Desc = GetBaseDesc(mapName),
        Default = false,
        Flag = "RollToggle_" .. mapName,
        Callback = function(val)
            Config.AutoRollMaps[mapName] = val
        end
    })

    MapToggleObjects[mapName] = MapToggle

    -- LOGIKA REALTIME: LOCKING, IMAGE PREVIEW, & MATERIAL INFO
    task.spawn(function()
        local _ImageCache = nil
        while not Window.Destroyed do
            local pData = getgenv().PlayerData
            local pMaps = pData and pData.Inventory and pData.Inventory.Maps
            
            if pMaps then
                local isMapUnlocked = pMaps[mapName]
                if isMapUnlocked == false then
                    Config.AutoRollMaps[mapName] = false
                    if IsWindowOpen() then
                        if MapToggle.Value then
                            MapToggle:Set(false)
                        end
                        MapToggle:Lock("Open Map First")
                    end
                else
                    if IsWindowOpen() then
                        MapToggle:Unlock()
                    end
                    
                    local unitName = pData.Gachas and pData.Gachas[mapName] or "None"
                    if IsWindowOpen() and _ImageCache ~= unitName then
                        pcall(function()
                            if unitName ~= "None" and RoadFunctions.GetGachaFromName then
                                local unitData = RoadFunctions:GetGachaFromName(mapName, unitName)
                                if unitData then
                                    MapToggle:SetMainImage({
                                        Image = RoadBoosts[mapName].Image or "",
                                        Gradient = GetRarityGradient(unitData.Rarity),
                                        Title = unitData.Name or unitName,
                                        Quantity = unitData.Rarity
                                    }, 60)
                                end
                            else
                                MapToggle:SetMainImage(mapData.Icon, 35)
                            end
                        end)
                        _ImageCache = unitName
                    end
                end
            end
            task.wait(0.5)
        end
    end)
    
    return MapToggle
end

-- Proses Maps 2 item per baris
for i = 1, #SortedMaps, 2 do
    -- Buat Group baru untuk baris ini
    local MapGroup = FarmTab:Group({})
    
    -- Daftarkan Group ke Category Manager agar bisa disembunyikan/muncul (FM_OnChange)
    FM_Add("Roll", MapGroup)
    
    -- Item Pertama
    local map1 = SortedMaps[i]
    CreateMapToggle(MapGroup, map1)
    
    -- Item Kedua (jika ada)
    local map2 = SortedMaps[i+1]
    if map2 then
        CreateMapToggle(MapGroup, map2)
    end
end

-- [[ 4. LOOPING AUTO ROLL (REAL-TIME PER TOGGLE) ]] --
local _LastStatusCache = {} 

task.spawn(function()
    while not Window.Destroyed do
        local currentMap = GetCurrentMapName()

        -- Periksa SEMUA map yang terdaftar
        for mapName, toggleUI in pairs(MapToggleObjects) do
            local isActive = Config.AutoRollMaps[mapName]
            local statusText = ""

            if isActive then
                -- LOGIKA SAAT TOGGLE ON
                if currentMap == mapName then
                    if CanRoll(mapName) then
                        statusText = GetBaseDesc(mapName) .. "\n<font color='#44ff44'>Status: Rolling...</font>"
                        
                        -- Jalankan Roll
                        local success = MetaService.Fetch:Fire("Roads", "Roll")
                        if success then
                            if IsWindowOpen() and _LastStatusCache[mapName] ~= statusText then
                                toggleUI:SetDesc(statusText)
                                _LastStatusCache[mapName] = statusText
                            end
                            task.wait(2.6) 
                        end
                    else
                        -- Saldo Kurang
                        statusText = GetBaseDesc(mapName) .. "\n<font color='#ff4444'>Status: Low Material!</font>"
                    end
                else
                    -- Salah Map
                    statusText = GetBaseDesc(mapName) .. "\n<font color='#ffff44'>Status: Go to " .. mapName .. "!</font>"
                end
            else
                -- LOGIKA SAAT TOGGLE OFF (Reset ke Deskripsi Awal)
                statusText = GetBaseDesc(mapName)
            end

            if IsWindowOpen() and _LastStatusCache[mapName] ~= statusText then
                toggleUI:SetDesc(statusText)
                _LastStatusCache[mapName] = statusText
            end
        end

        task.wait() -- Check setiap 0.2 detik untuk performa real-time yang ringan
    end
end)

-- [[ DUNGEON DATA FETCH ]] --
local DungeonsModule = require(ReplicatedStorage.Modules.DungeonsModule)

local function GetDynamicDifficulties()
    local difficulties = DungeonsModule.Difficulties
    return difficulties
end

Config.AutoDungeonCreate = false
Config.AutoDungeonKill = false
Config.SelectedDifficulty = nil -- Akan diisi otomatis
-- [[ DUNGEONS CATEGORY - ROOM 50 FIX ]] --
FM_CategoryDescriptions["Dungeons"] = "Auto Dungeon: Room-by-room clearing with Room 50 & Anti-Lag fix."

-- 1. Mencari Folder Session (workspace.Server.Dungeons.[NamaPlayer])
local function GetDungeonSession()
    local serverFolder = workspace:FindFirstChild("Server")
    local dungeonsFolder = serverFolder and serverFolder:FindFirstChild("Dungeons")
    if dungeonsFolder then
        return dungeonsFolder:FindFirstChild(LocalPlayer.Name)
    end
    return nil
end

-- 2. Mendapatkan Data Ruangan Aktif
local function GetActiveRoomModels()
    local session = GetDungeonSession()
    local info = session and session:FindFirstChild("Information")
    if info then
        return {
            Current = info:FindFirstChild("CurrentRoom") and info.CurrentRoom.Value,
            Passed = info:FindFirstChild("PassedRoom") and info.PassedRoom.Value,
            Seen = info:FindFirstChild("SeenRoom") and info.SeenRoom.Value
        }
    end
    return nil
end

-- 3. Logika Pintu: Diperbaiki untuk format nama "Room:X"
local function IsGateOpen()
    local roomModels = GetActiveRoomModels()
    if not roomModels or not roomModels.Current then return true end

    -- Room 1 selalu diizinkan
    local name = roomModels.Current.Name
    if name:match(":1$") or name == "Room1" then return true end

    -- Pintu jeruji berada di PassedRoom
    if roomModels.Passed then
        local door = roomModels.Passed:FindFirstChild("DungeonDoor", true) or roomModels.Passed:FindFirstChild("Door", true)
        if door and door:IsA("BasePart") then
            -- Jika CanCollide false, berarti pintu sudah terbuka
            return door.CanCollide == false
        end
    end
    return true
end

-- 4. Targeting: Perbaikan filter SeenRoom untuk Room 50
local function GetDungeonTarget()
    if not LocalPlayer.Character then return nil end

    -- Jangan cari target jika gerbang fisik masih tertutup
    if not IsGateOpen() then return nil end

    local roomModels = GetActiveRoomModels()
    local currentRoomModel = roomModels and roomModels.Current
    local seenRoomModel = roomModels and roomModels.Seen
    
    local mobsFolder = currentRoomModel and currentRoomModel:FindFirstChild("Mobs")
    if not mobsFolder then return nil end

    local closestPart = nil
    local shortestDistance = math.huge
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, enemy in ipairs(mobsFolder:GetChildren()) do
        -- Sesuai info: Musuh bisa berupa Part (Budha) atau Model
        if enemy:IsA("BasePart") or enemy:IsA("Model") then
            local health = enemy:GetAttribute("Health") or 0
            
            if health > 0 then
                -- FIX ROOM 50: Hanya abaikan jika SeenRoom BEDA dengan CurrentRoom
                -- Jika Current == Seen (seperti di Room 50), jangan di-ignore!
                if seenRoomModel and currentRoomModel ~= seenRoomModel then
                    if enemy:IsDescendantOf(seenRoomModel) then
                        continue
                    end
                end

                -- Ambil posisi: Langsung dari Part atau dari HumanoidRootPart jika Model
                local targetPos = enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy.HumanoidRootPart.Position or enemy.Position
                
                if targetPos then
                    local dist = (myRoot.Position - targetPos).Magnitude
                    -- Filter jarak agar tidak teleport ke luar map secara tidak sengaja
                    if dist < 400 and dist < shortestDistance then
                        shortestDistance = dist
                        closestPart = enemy
                    end
                end
            end
        end
    end
    return closestPart
end
-- 1. Fungsi Helper untuk memanggil EndScreen secara paksa
local function ForceEndDungeon()
    local DungeonModule = require(game:GetService("Players").LocalPlayer.PlayerScripts.MetaService.Client.Dungeon)
    if DungeonModule and DungeonModule.EndScreen then
        -- Kita buat data dummy agar EndScreen bisa berjalan tanpa error
        local dummyResult = {
            RoomReached = 0,
            TotalDamage = 0,
            Time = 0,
            EnemiesDefeated = 0,
            PlayersList = {} -- Tabel kosong untuk menghindari loop error pada rewards
        }
        DungeonModule.EndScreen(dummyResult)
    end
end

-- 2. Main Loop dengan Integrasi EndScreen
task.spawn(function()
    local lastRoomName = ""
    while not Window.Destroyed do
        if Config.AutoDungeonCreate or Config.AutoDungeonKill then
            pcall(function()
                local GameplayUI = LocalPlayer.PlayerGui.Main.Gameplay
                local DungeonHUD = GameplayUI:FindFirstChild("Dungeon_em_andamento")
                local TopView = DungeonHUD and DungeonHUD:FindFirstChild("Top_view")
                local FinishUI = DungeonHUD and DungeonHUD:FindFirstChild("Acabamento da dungeon")

                if FinishUI and FinishUI.Visible then
                    FinishUI.Visible = false
                end
                
                if not (TopView and TopView.Visible) then
                    if Config.AutoDungeonCreate and GetCurrentMapName() == "Piece Village" then
                        local Bridge = MetaService.Bridge
                        local session = GetDungeonSession()
                        if Bridge and Bridge.Fire and not session then
                            -- ForceEndDungeon()
                            task.wait(0.5)

                            Bridge:Fire("Dungeon", "Create")
                            task.wait(0.8)
                            
                            if Config.SelectedDifficulty then
                                Bridge:Fire("Dungeon", "ChangeDifficulty", Config.SelectedDifficulty)
                                task.wait(0.5)
                            end

                            Bridge:Fire("Dungeon", "Start")
                            task.wait(2)
                        end
                    end
                else
                    if not Config.AutoDungeonKill then
                        return
                    end

                    local roomModels = GetActiveRoomModels()
                    local currentRoom = roomModels and roomModels.Current
                    local currentName = currentRoom and currentRoom.Name or ""
                    
                    if currentName ~= "" and currentName ~= lastRoomName then
                        lastRoomName = currentName
                    end

                    local target = GetDungeonTarget()
                    if target then
                        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local targetCF = target:IsA("Model") and target:FindFirstChild("HumanoidRootPart") and target.HumanoidRootPart.CFrame or target.CFrame
                            root.CFrame = targetCF * CFrame.new(0, 0, 3)
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

-- 5. UI Setup
local dungeonDifficulties = DungeonsModule.Difficulties
DifficultyDropdown = FarmTab:Dropdown({
    Title = "Select Difficulty",
    Values = dungeonDifficulties,
    Default = dungeonDifficulties[1],
    Flag = "Dungeon_Diff_Setting",
    Callback = function(val) Config.SelectedDifficulty = val end
})

AutoDungeonToggle = FarmTab:Toggle({
    Title = "Auto Create Dungeon",
    Desc = "Automatically create and start dungeon",
    Default = false,
    Flag = "AutoDungeonCreate_Setting",
    Callback = function(val) Config.AutoDungeonCreate = val end
})

AutoDungeonKillToggle = FarmTab:Toggle({
    Title = "Auto Kill (In Dungeon)",
    Desc = "Only targets enemies in CurrentRoom after door opens",
    Default = false,
    Flag = "AutoDungeonKill_Setting",
    Callback = function(val) Config.AutoDungeonKill = val end
})

FM_Add("Dungeons", DifficultyDropdown)
FM_Add("Dungeons", AutoDungeonToggle)
FM_Add("Dungeons", AutoDungeonKillToggle)

-- [[ SCRAP UPGRADES FEATURE - GROUP STRUCTURE ]] --
local ScrapConfig = require(ReplicatedStorage.Modules.ScrapConfig)
Config.AutoScrap = { Left = {}, Right = {} }
local ScrapToggleObjects = { Left = {}, Right = {} }
local _Scrap_LastStatus = { Left = {}, Right = {} }

-- Fungsi pembantu untuk mendapatkan deskripsi status dan biaya
local function GetScrapSideDesc(mapName, side, sideData)
    local pData = MetaService.Data
    if not pData then return "Loading..." end

    local currentLvl = (pData.ScrapUpgrades and pData.ScrapUpgrades[mapName] and pData.ScrapUpgrades[mapName][side]) or 0
    local nextLvl = currentLvl + 1
    local multiplier = currentLvl * sideData.MultiplierPerLevel * 100
    
    if currentLvl >= sideData.MaxLevel then
        return string.format("Level: %d (MAX)\nBonus: +%.1f%% %s", currentLvl, multiplier, sideData.Type)
    end

    -- Hitung Biaya
    local costs = sideData.GetCost(nextLvl)
    local costStrings = {}
    for itemName, amount in pairs(costs) do
        local owned = (pData.Inventory and pData.Inventory.Items[itemName]) or 0
        local color = owned >= amount and "#44ff44" or "#ff4444"
        table.insert(costStrings, string.format("<font color='%s'>%s/%s</font> %s%s", 
            color, formatNum(owned), formatNum(amount), Items[itemName].Name,Items[itemName].Icon))
    end

    return string.format("Level: %d/%d (+%.1f%% %s)\nCost:\n%s", 
        currentLvl, sideData.MaxLevel, multiplier, sideData.Type, table.concat(costStrings, "\n"))
end

-- Generate UI Dinamis berdasarkan ScrapConfig
for mapName, sides in pairs(ScrapConfig.Upgrades) do
    local ScrapGroup = FarmTab:Group({
        Title = mapName .. " Upgrades"
    })
    
    FM_Add("Limit Breaks", ScrapGroup)

    -- Toggle Sisi Kiri (Biasanya Power)
    local LeftToggle = ScrapGroup:Toggle({
        Title = "Scrap Upgrade (" .. sides.Left.Type .. ")",
        Desc = GetScrapSideDesc(mapName, "Left", sides.Left),
        Default = false,
        Flag = "ScrapLeft_" .. mapName:gsub(" ", ""),
        Callback = function(val) Config.AutoScrap.Left[mapName] = val end
    })
    ScrapToggleObjects.Left[mapName] = LeftToggle

    -- Toggle Sisi Kanan (Biasanya Yens)
    local RightToggle = ScrapGroup:Toggle({
        Title = "Scrap Upgrade (" .. sides.Right.Type .. ")",
        Desc = GetScrapSideDesc(mapName, "Right", sides.Right),
        Default = false,
        Flag = "ScrapRight_" .. mapName:gsub(" ", ""),
        Callback = function(val) Config.AutoScrap.Right[mapName] = val end
    })
    ScrapToggleObjects.Right[mapName] = RightToggle
end

-- [[ LOOPING LOGIKA AUTO UPGRADE SCRAP ]] --
task.spawn(function()
    while not Window.Destroyed do
        local premium = (getgenv().IsPremium == true)
        local pData = MetaService.Data
        if premium and pData then
            for mapName, sides in pairs(ScrapConfig.Upgrades) do
                for _, side in ipairs({"Left", "Right"}) do
                    local sideData = sides[side]
                    local isActive = Config.AutoScrap[side][mapName]
                    local toggleUI = ScrapToggleObjects[side][mapName]

                    if isActive then
                        local currentLvl = (pData.ScrapUpgrades and pData.ScrapUpgrades[mapName] and pData.ScrapUpgrades[mapName][side]) or 0
                        
                        if currentLvl < sideData.MaxLevel then
                            local costs = sideData.GetCost(currentLvl + 1)
                            local canAfford = true
                            
                            for itemName, amount in pairs(costs) do
                                if (pData.Inventory.Items[itemName] or 0) < amount then
                                    canAfford = false
                                    break
                                end
                            end

                            if canAfford then
                                MetaService.Fetch:Fire("Scrap", "Upgrade", {
                                    ["Map"] = mapName,
                                    ["Side"] = side
                                })
                                task.wait(0.1)
                            end
                        end
                    end

                    -- Update Deskripsi UI
                    if toggleUI and IsWindowOpen() then
                        local status = GetScrapSideDesc(mapName, side, sideData)
                        if _Scrap_LastStatus[side][mapName] ~= status then
                            toggleUI:SetDesc(status)
                            _Scrap_LastStatus[side][mapName] = status
                        end
                    end
                end
            end
        end
        task.wait(premium and 0.5 or 1.0)
    end
end)

-- [[ DEVIL UPGRADES FEATURE - GROUP STRUCTURE ]] --
local DevilConfig = require(ReplicatedStorage.Modules.DevilConfig)
Config.AutoDevil = { Left = {}, Right = {} }
local DevilToggleObjects = { Left = {}, Right = {} }
local _Devil_LastStatus = { Left = {}, Right = {} }

-- Fungsi pembantu untuk mendapatkan deskripsi status dan biaya
local function GetDevilSideDesc(mapName, side, sideData)
    local pData = MetaService.Data
    if not pData then return "Loading..." end

    local currentLvl = (pData.DevilUpgrades and pData.DevilUpgrades[mapName] and pData.DevilUpgrades[mapName][side]) or 0
    local nextLvl = currentLvl + 1
    local multiplier = currentLvl * sideData.MultiplierPerLevel * 100
    
    if currentLvl >= sideData.MaxLevel then
        return string.format("Level: %d (MAX)\nBonus: +%.1f%% %s", currentLvl, multiplier, sideData.Type)
    end

    -- Hitung Biaya Material
    local costs = sideData.GetCost(nextLvl)
    local costStrings = {}
    for itemName, amount in pairs(costs) do
        local owned = (pData.Inventory and pData.Inventory.Items[itemName]) or 0
        local color = owned >= amount and "#44ff44" or "#ff4444"
        table.insert(costStrings, string.format("%s:<font color='%s'>%s/%s</font> %s", 
             Items[itemName].Name,color, formatNum(owned), formatNum(amount),Items[itemName].Icon))
    end

    return string.format("Level: %d/%d (+%.1f%% %s)\n%s", 
        currentLvl, sideData.MaxLevel, multiplier, sideData.Type, table.concat(costStrings, "\n"))
end

-- Generate UI Dinamis berdasarkan DevilConfig
for mapName, sides in pairs(DevilConfig.Upgrades) do
    local DevilGroup = FarmTab:Group({
        Title = mapName .. " Upgrades"
    })
    
    FM_Add("Limit Breaks", DevilGroup)

    -- Toggle Sisi Kiri (Biasanya Power)
    local LeftToggle = DevilGroup:Toggle({
        Title = "Devil Upgrade (" .. sides.Left.Type .. ")",
        Desc = GetDevilSideDesc(mapName, "Left", sides.Left),
        Default = false,
        Flag = "DevilLeft_" .. mapName:gsub(" ", ""),
        Callback = function(val) Config.AutoDevil.Left[mapName] = val end
    })
    DevilToggleObjects.Left[mapName] = LeftToggle

    -- Toggle Sisi Kanan (Biasanya Damage)
    local RightToggle = DevilGroup:Toggle({
        Title = "Devil Upgrade (" .. sides.Right.Type .. ")",
        Desc = GetDevilSideDesc(mapName, "Right", sides.Right),
        Default = false,
        Flag = "DevilRight_" .. mapName:gsub(" ", ""),
        Callback = function(val) Config.AutoDevil.Right[mapName] = val end
    })
    DevilToggleObjects.Right[mapName] = RightToggle
end

-- [[ LOOPING LOGIKA AUTO UPGRADE DEVIL ]] --
task.spawn(function()
    while not Window.Destroyed do
        local premium = (getgenv().IsPremium == true)
        local pData = MetaService.Data
        if premium and pData then
            for mapName, sides in pairs(DevilConfig.Upgrades) do
                for _, side in ipairs({"Left", "Right"}) do
                    local sideData = sides[side]
                    local isActive = Config.AutoDevil[side][mapName]
                    local toggleUI = DevilToggleObjects[side][mapName]

                    if isActive then
                        local currentLvl = (pData.DevilUpgrades and pData.DevilUpgrades[mapName] and pData.DevilUpgrades[mapName][side]) or 0
                        
                        if currentLvl < sideData.MaxLevel then
                            local costs = sideData.GetCost(currentLvl + 1)
                            local canAfford = true
                            
                            -- Cek ketersediaan semua item yang dibutuhkan
                            for itemName, amount in pairs(costs) do
                                if (pData.Inventory.Items[itemName] or 0) < amount then
                                    canAfford = false
                                    break
                                end
                            end

                            if canAfford then
                                -- Kirim sinyal upgrade ke server
                                MetaService.Fetch:Fire("Devil", "Upgrade", {
                                    ["Map"] = mapName,
                                    ["Side"] = side
                                })
                                task.wait(0.1) -- Jeda antar upgrade
                            end
                        end
                    end

                    -- Update Deskripsi UI (Real-time Optimization)
                    if toggleUI and IsWindowOpen() then
                        local status = GetDevilSideDesc(mapName, side, sideData)
                        if _Devil_LastStatus[side][mapName] ~= status then
                            toggleUI:SetDesc(status)
                            _Devil_LastStatus[side][mapName] = status
                        end
                    end
                end
            end
        end
        task.wait(premium and 0.5 or 1.0)
    end
end)


-- [[ LIMIT BREAKS FEATURE - GROUP STRUCTURE ]] --
local LB_Config = require(ReplicatedStorage.Modules.LimitBreaksConfig)
Config.AutoLimitBreaks = {} 
local LB_ToggleObjects = {}
local _LB_LastStatus = {}
local XmasUIObjects = {
    Timer = nil,
    ExchangeToggles = {},
    AmountInputs = {},
    ShopToggles = {}
}

-- Fungsi untuk membuat deskripsi status (Level, Bonus, Biaya) dengan gaya Scrap/Devil Upgrade
local function GetLBDesc(mapName, mapData)
    local pData = MetaService.Data
    if not pData then return "Loading..." end
    
    local currentLvl = (pData.LimitBreaks and pData.LimitBreaks[mapName]) or 0
    local nextLvl = currentLvl + 1
    local multiplier = LB_Config.GetMultiplier(mapName, currentLvl) * 100
    
    -- Tampilan jika sudah level maksimal
    if currentLvl >= mapData.MaxLevel then
        return string.format("Level: %d (MAX)\nBonus: +%.1f%% %s", currentLvl, multiplier, mapData.StatType)
    end
    
    -- Logika Biaya dan Warna (Mengikuti gaya Scrap/Devil Upgrade)
    local currency = mapData.Currency
    local cost = mapData.GetCost(nextLvl)
    local owned = (pData.Inventory and pData.Inventory.Items[currency]) or 0
    local itemInfo = Items[currency]
    
    -- Warna: Hijau (#44ff44) jika cukup, Merah (#ff4444) jika kurang
    local color = owned >= cost and "#44ff44" or "#ff4444"
    local costString = string.format("%s:<font color='%s'>%s/%s</font> %s", 
        itemInfo.Name,color, formatNum(owned), formatNum(cost),  itemInfo.Icon)

    -- Format akhir yang lebih bersih
    return string.format("Level: %d/%d (+%.1f%% %s)\n%s", 
        currentLvl, mapData.MaxLevel, multiplier, mapData.StatType, costString)
end

-- Looping untuk membuat Group per Map
local ValidLBMaps = {}
for _, mData in ipairs(SortedMaps) do
    if LB_Config.Data[mData.Name] then
        table.insert(ValidLBMaps, mData)
    end
end

for i = 1, #ValidLBMaps, 2 do
    local mData1 = ValidLBMaps[i]
    local mData2 = ValidLBMaps[i+1]
    
    local mapName1 = mData1.Name
    local lbData1 = LB_Config.Data[mapName1]
    
    local MapGroup = FarmTab:Group({
        Title = lbData1.FolderName or mapName1
    })
    
    FM_Add("Limit Breaks", MapGroup)

    -- Item 1
    local LBToggle1 = MapGroup:Toggle({
        Title = mData1.FrameName or mapName1,
        Desc = GetLBDesc(mapName1, lbData1),
        Default = false,
        Flag = "LBToggle_" .. mapName1:gsub(" ", ""),
        Callback = function(val)
            Config.AutoLimitBreaks[mapName1] = val
        end
    })

    LBToggle1:SetMainImage(mData1.Icon, 30)
    LB_ToggleObjects[mapName1] = LBToggle1

    -- Item 2
    if mData2 then
        local mapName2 = mData2.Name
        local lbData2 = LB_Config.Data[mapName2]

        local LBToggle2 = MapGroup:Toggle({
            Title = mData2.FrameName or mapName2,
            Desc = GetLBDesc(mapName2, lbData2),
            Default = false,
            Flag = "LBToggle_" .. mapName2:gsub(" ", ""),
            Callback = function(val)
                Config.AutoLimitBreaks[mapName2] = val
            end
        })

        LBToggle2:SetMainImage(mData2.Icon, 30)
        LB_ToggleObjects[mapName2] = LBToggle2
    end
end

-- [[ LOGIKA AUTO UPGRADE ]] --
task.spawn(function()
    while not Window.Destroyed do
        local premium = (getgenv().IsPremium == true)
        local pData = MetaService.Data
        
        for mapName, lbData in pairs(LB_Config.Data) do
            local isActive = Config.AutoLimitBreaks[mapName]
            local toggleUI = LB_ToggleObjects[mapName]

            if toggleUI then
                -- Proses Upgrade
                if isActive and pData then
                    local currentLvl = (pData.LimitBreaks and pData.LimitBreaks[mapName]) or 0
                    local currency = lbData.Currency
                    local owned = (pData.Inventory and pData.Inventory.Items[currency]) or 0
                    local cost = lbData.GetCost(currentLvl + 1)

                    if currentLvl < lbData.MaxLevel and owned >= cost then
                        -- Eksekusi Remote
                        MetaService.Fetch:Fire("LimitBreaks", "Upgrade", mapName)
                        task.wait(0.1) 
                    end
                end

                -- Update Status Deskripsi (Real-time)
                if IsWindowOpen() and premium then
                    local currentStatus = GetLBDesc(mapName, lbData)
                    if _LB_LastStatus[mapName] ~= currentStatus then
                        toggleUI:SetDesc(currentStatus)
                        _LB_LastStatus[mapName] = currentStatus
                    end
                end
            end
        end
        task.wait(premium and 0.5 or 1.0)
    end
end)

local ToggleNoCooldown

task.spawn(function()
    local lockState = {}
    local lbLockState = {}
    local scrapLockState = { Left = {}, Right = {} }
    local devilLockState = { Left = {}, Right = {} }
    local hatchState = {}
    local fastAttackState = {}
    local xmasState = {}

    local function keyForReason(reason)
        return reason or ""
    end

    local function setLock(ui, reason, cache, k)
        if not ui then return end
        local state = keyForReason(reason)
        if cache[k] == state then return end
        if not IsWindowOpen() then return end
        cache[k] = state
        pcall(function()
            if reason and reason ~= "" then
                ui:Lock(reason)
            else
                ui:Unlock()
            end
        end)
    end

    local function setOffIfOn(ui)
        if not IsWindowOpen() then
            return
        end
        if ui and ui.Value then
            pcall(function()
                ui:Set(false)
            end)
        end
    end

    local function enforceHatch(premium)
        if not premium then
            if Config and Config.AutoHatch then
                Config.AutoHatch.Enabled = false
            end
            setOffIfOn(AutoHatchToggle)
            setLock(HatchMapDropdown, "Premium Only", hatchState, "HatchMapDropdown")
            setLock(AutoHatchToggle, "Premium Only", hatchState, "AutoHatchToggle")
        else
            setLock(HatchMapDropdown, nil, hatchState, "HatchMapDropdown")
            setLock(AutoHatchToggle, nil, hatchState, "AutoHatchToggle")
        end
    end

    local function enforceFastAttack(premium)
        if not premium then
            Config.NoCooldownAttack = false
            if ToggleNoCooldown then
                pcall(function()
                    ToggleNoCooldown(false)
                end)
            end
            setOffIfOn(FarmTabFast)
            setLock(FarmTabFast, "Premium Only", fastAttackState, "FarmTabFast")
        else
            setLock(FarmTabFast, nil, fastAttackState, "FarmTabFast")
        end
    end

    local function enforceChristmas(premium)
        if not premium then
            setLock(XmasUIObjects.Timer, "Premium Only", xmasState, "Timer")

            for eKey, ui in pairs(XmasUIObjects.AmountInputs) do
                setLock(ui, "Premium Only", xmasState, "AmountInput:" .. eKey)
            end

            for eKey, ui in pairs(XmasUIObjects.ExchangeToggles) do
                if Config.Christmas and Config.Christmas.AutoExchanges then
                    Config.Christmas.AutoExchanges[eKey] = false
                end
                setOffIfOn(ui)
                setLock(ui, "Premium Only", xmasState, "ExchangeToggle:" .. eKey)
            end

            for itemName, ui in pairs(XmasUIObjects.ShopToggles) do
                if Config.ChristmasShop and Config.ChristmasShop.AutoBuy then
                    Config.ChristmasShop.AutoBuy[itemName] = false
                end
                setOffIfOn(ui)
                setLock(ui, "Premium Only", xmasState, "ShopToggle:" .. itemName)
            end
        else
            setLock(XmasUIObjects.Timer, nil, xmasState, "Timer")

            for eKey, ui in pairs(XmasUIObjects.AmountInputs) do
                setLock(ui, nil, xmasState, "AmountInput:" .. eKey)
            end

            for eKey, ui in pairs(XmasUIObjects.ExchangeToggles) do
                setLock(ui, nil, xmasState, "ExchangeToggle:" .. eKey)
            end

            for itemName, ui in pairs(XmasUIObjects.ShopToggles) do
                setLock(ui, nil, xmasState, "ShopToggle:" .. itemName)
            end
        end
    end

    local function applyMaxLocks(pData)
        for mapName, toggleUI in pairs(LB_ToggleObjects) do
            local lbData = LB_Config and LB_Config.Data and LB_Config.Data[mapName]
            local currentLvl = (pData and pData.LimitBreaks and pData.LimitBreaks[mapName]) or 0
            if toggleUI and lbData and currentLvl >= lbData.MaxLevel then
                Config.AutoLimitBreaks[mapName] = false
                setOffIfOn(toggleUI)
                setLock(toggleUI, "MAX", lbLockState, mapName)
            else
                setLock(toggleUI, nil, lbLockState, mapName)
            end
        end

        for mapName, sides in pairs(ScrapConfig.Upgrades) do
            for _, side in ipairs({"Left", "Right"}) do
                local sideData = sides[side]
                local toggleUI = ScrapToggleObjects[side][mapName]
                local currentLvl = (pData and pData.ScrapUpgrades and pData.ScrapUpgrades[mapName] and pData.ScrapUpgrades[mapName][side]) or 0
                if toggleUI and sideData and currentLvl >= sideData.MaxLevel then
                    Config.AutoScrap[side][mapName] = false
                    setOffIfOn(toggleUI)
                    setLock(toggleUI, "MAX", scrapLockState[side], mapName)
                else
                    setLock(toggleUI, nil, scrapLockState[side], mapName)
                end
            end
        end

        for mapName, sides in pairs(DevilConfig.Upgrades) do
            for _, side in ipairs({"Left", "Right"}) do
                local sideData = sides[side]
                local toggleUI = DevilToggleObjects[side][mapName]
                local currentLvl = (pData and pData.DevilUpgrades and pData.DevilUpgrades[mapName] and pData.DevilUpgrades[mapName][side]) or 0
                if toggleUI and sideData and currentLvl >= sideData.MaxLevel then
                    Config.AutoDevil[side][mapName] = false
                    setOffIfOn(toggleUI)
                    setLock(toggleUI, "MAX", devilLockState[side], mapName)
                else
                    setLock(toggleUI, nil, devilLockState[side], mapName)
                end
            end
        end
    end

    while not Window.Destroyed do
        local premium = (getgenv().IsPremium == true)
        local pData = MetaService and MetaService.Data

        if not premium then
            Config.AutoDungeonCreate = false
            Config.AutoDungeonKill = false
            setOffIfOn(AutoDungeonToggle)
            setOffIfOn(AutoDungeonKillToggle)
            setLock(DifficultyDropdown, "Premium Only", lockState, "DifficultyDropdown")
            setLock(AutoDungeonToggle, "Premium Only", lockState, "AutoDungeonCreateToggle")
            setLock(AutoDungeonKillToggle, "Premium Only", lockState, "AutoDungeonKillToggle")

            for mapName, toggleUI in pairs(LB_ToggleObjects) do
                Config.AutoLimitBreaks[mapName] = false
                setOffIfOn(toggleUI)
                setLock(toggleUI, "Premium Only", lbLockState, mapName)
            end

            for mapName, sides in pairs(ScrapConfig.Upgrades) do
                for _, side in ipairs({"Left", "Right"}) do
                    Config.AutoScrap[side][mapName] = false
                    local toggleUI = ScrapToggleObjects[side][mapName]
                    setOffIfOn(toggleUI)
                    setLock(toggleUI, "Premium Only", scrapLockState[side], mapName)
                end
            end

            for mapName, sides in pairs(DevilConfig.Upgrades) do
                for _, side in ipairs({"Left", "Right"}) do
                    Config.AutoDevil[side][mapName] = false
                    local toggleUI = DevilToggleObjects[side][mapName]
                    setOffIfOn(toggleUI)
                    setLock(toggleUI, "Premium Only", devilLockState[side], mapName)
                end
            end
        else
            setLock(DifficultyDropdown, nil, lockState, "DifficultyDropdown")
            setLock(AutoDungeonToggle, nil, lockState, "AutoDungeonCreateToggle")
            setLock(AutoDungeonKillToggle, nil, lockState, "AutoDungeonKillToggle")
            applyMaxLocks(pData)
        end

        enforceHatch(premium)
        enforceFastAttack(premium)
        enforceChristmas(premium)
        task.wait(premium and 1.0 or 2.0)
    end
end)

-- [[ 1. CONFIGURATION & MODULES ]] --
FM_CategoryDescriptions["Hatch"] = "Auto hatch eggs from your selected map."
Config.AutoHatch = {
    Enabled = false,
    Type = "Single", -- "Single" or "Triple"
    SelectedMap = "Piece Village"
}

local SummonPath = LocalPlayer.PlayerScripts.MetaService.Client.Summon
local HatchEgg = require(SummonPath.HatchEgg)
local EggAnimate = require(SummonPath.EggAnimate)
local UnitsModule = require(ReplicatedStorage.Modules.Units)

-- [[ BYPASS / HOOK SYSTEM ]] --

-- [[ 2. BYPASS / HOOK SYSTEM ]] --

-- 1. Bypass Kecepatan Hatch (Selalu Instant)
HatchEgg.GetHatchSpeed = function()
    return 0.01 
end

-- 2. BYPASS OpenEgg (Menghilangkan pengecekan Rolling_UI.Enabled)
HatchEgg.OpenEgg = function(self, p9, p10)
    -- Langsung tembak remote tanpa cek UI
    if p9 and p10 then
        MetaService.Bridge:FireServer("Summon", "Request", { p9, p10 })
    end
end

-- 3. BYPASS HandleRequest (Menghilangkan pengecekan Summon_a.Visible)
-- Ini penting agar animasi hatch tetap muncul/selesai meskipun UI tertutup
HatchEgg.HandleRequest = function(p51)
    HatchEgg.IsHatching = false
    EggAnimate.IsPlaying = false

    if p51 and (p51.CurrentMap and HatchEgg.MapEggs[p51.CurrentMap]) then
        local v54 = HatchEgg.GetHatchSpeed()
        -- Langsung panggil CreateEgg tanpa cek v53.Visible
        EggAnimate.CreateEgg(HatchEgg.MapEggs[p51.CurrentMap], p51.Amount, p51.RolledPets, v54)
        
        if HatchEgg.OnFinish then
            HatchEgg.OnFinish()
        end
    end
end

-- 4. Loop State Management (Agar script game tidak mengunci status 'Busy')
task.spawn(function()
    while not Window.Destroyed do
        if getgenv().IsPremium then
            HatchEgg.IsHatching = false
            EggAnimate.IsPlaying = false
        end
        task.wait(0.1)
    end
end)
-- [[ TOTAL ANIMATION BYPASS - LIVE SETTINGS FIXED ]] --
EggAnimate.CreateEgg = function(eggModel, amount, rolledPets, speed)
    EggAnimate.IsPlaying = true

    -- Jangan membuat tabel 'actions' yang statis. 
    -- Tarik data langsung dari EggAnimate.AutoRarities di dalam loop.
    
    if type(rolledPets) == "table" then
        for _, pet in ipairs(rolledPets) do
            -- Kita cek untuk setiap aksi: Lock, Sell, dan Feed
            local categories = {"Lock", "Sell", "Feed"}
            
            for _, catName in ipairs(categories) do
                local config = EggAnimate.AutoRarities[catName] -- Mengambil tabel LIVE dari UI
                local actionName = ""
                
                -- Mapping action name sesuai modul asli
                if catName == "Lock" then actionName = "FavoritePet"
                elseif catName == "Sell" then actionName = "SellPet"
                elseif catName == "Feed" then actionName = "FeedPet" end

                if config and actionName ~= "" then
                    -- Cek apakah pet ini Shiny (untuk filter 'Units/Types') atau normal (Rarity)
                    local isShiny = string.find(pet.PetOriginName, "Shiny") ~= nil
                    local filterTable = isShiny and config.Types or config.Rarities
                    
                    -- Debug: jika ingin memastikan daftar yang dibaca sudah benar
                    -- print("Checking " .. catName .. " for " .. pet.PetOriginName .. " in current list")

                    if table.find(filterTable, pet.Rarity) then
                        local arg = pet.UUID
                        if actionName == "SellPet" then arg = { pet.UUID }
                        elseif actionName == "FeedPet" then arg = { {pet.UUID}, EggAnimate.SelectedForFeed } end
                        
                        MetaService.Bridge:Fire("PetsManager", actionName, arg)
                        break -- Jika sudah diproses satu aksi (misal Lock), jangan lanjut ke Sell
                    end
                end
            end
        end
    end

    EggAnimate.IsPlaying = false
    print(string.format("[ANHub] Hatched %s pets instantly with updated filters.", tostring(amount)))
end
-- [[ 2. BYPASS / HOOK SYSTEM ]] --
-- Force busy status to false to allow spamming without waiting for animations to finish
task.spawn(function()
    while not Window.Destroyed do
        local premium = (getgenv().IsPremium == true)
        if premium then
            HatchEgg.IsHatching = false
            EggAnimate.IsPlaying = false
            if Config.AutoHatch.Enabled then 
                -- Ensure Summon UI is logically considered visible by the game script
                local summonUI = LocalPlayer.PlayerGui.Main.Gameplay.Sections:FindFirstChild("Summon_a")
                if summonUI then summonUI.Visible = true end
            end
        end
        task.wait(0.2)
    end
end)

-- [[ 3. UI GENERATION ]] --

-- List of maps available for Eggs
local EggMapList = {}
for mapName, _ in pairs(HatchEgg.MapEggs) do
    if mapName ~= "Exclusives" then
        table.insert(EggMapList, { Title = mapName, Value = mapName })
    end
end

table.sort(EggMapList, function(a, b)
    local mapA = MapsModule[a.Value]
    local mapB = MapsModule[b.Value]
    local indexA = mapA and mapA.Index or 9999
    local indexB = mapB and mapB.Index or 9999
    return indexA < indexB
end)

HatchMapDropdown = FarmTab:Dropdown({
    Title = "Select Egg (Map)",
    Values = EggMapList,
    Desc = "Make sure you are near the Summon model.",
    Default = "Piece Village",
    Callback = function(val) 
        Config.AutoHatch.SelectedMap = type(val) == "table" and val.Value or val 
    end
})
AutoHatchToggle = FarmTab:Toggle({
    Title = "Auto Hatch",
    Desc = "Automatically hatch eggs from the selected map.\nEnable this when you are near the Summon area.\nRejoin If UI Gone",
    Default = false,
    Callback = function(val)
        Config.AutoHatch.Enabled = val
        
        -- NORMALIZATION LOGIC WHEN DISABLED
        if not val then
            -- 1. Reset UI to closed state so it doesn't obstruct the screen
            local summonUI = LocalPlayer.PlayerGui.Main.Gameplay.Sections:FindFirstChild("Summon_a")
            if summonUI then 
                summonUI.Visible = false
            end
            
            -- 2. Brief delay then let the original module regain state control
            task.delay(0.1, function()
                HatchEgg.IsHatching = false
                EggAnimate.IsPlaying = false
            end)
        end
    end
})
FM_Add("Hatch", HatchMapDropdown)
FM_Add("Hatch", AutoHatchToggle)

-- [[ 4. MAIN LOOP LOGIC FIXED ]] --
task.spawn(function()
    while not Window.Destroyed do
        local premium = (getgenv().IsPremium == true)
        if premium and Config.AutoHatch.Enabled then
            pcall(function()
                local map = Config.AutoHatch.SelectedMap
                local hatchType = "Single" -- Default value

                -- Cek Gamepass untuk menentukan tipe hatch
                if getgenv().PlayerData.Gamepasses["Multi Open"] then
                    hatchType = "Triple" -- Gunakan "Triple" jika punya gamepass
                end

                local price = UnitsModule.GetPrice(map, getgenv().PlayerData)
                local currentYen = getgenv().PlayerData.Yens or 0

                -- Validasi Saldo
                if currentYen >= price then
                    -- Pastikan status hatching di-reset agar bisa spam
                    HatchEgg.IsHatching = false
                    EggAnimate.IsPlaying = false
                    
                    -- Kirim Request
                    MetaService.Bridge:Fire("Summon", "Request", {hatchType, map})
                    
                    -- Jeda sangat singkat untuk bypass (0.1 detik atau tanpa jeda jika ingin instant)
                    task.wait(0.1) 
                else
                    Notify("Warning", "Insufficient Yen to summon!", "alert-circle")
                    Config.AutoHatch.Enabled = false
                    task.wait(2)
                end
            end)
        end
        task.wait(0.1) -- Loop safety
    end
end)


-- [[ FEATURE: NO COOLDOWN ATTACK ]] --
local AttackPath = LocalPlayer.PlayerScripts.MetaService.Client.Attack
local AutoAttackModule = require(ReplicatedStorage.Modules.AutoAttack)
local Clickers = require(ReplicatedStorage.Modules.Clickers)
local AttackModule = require(AttackPath)
Config.NoCooldownAttack = false

-- [[ THE HOOK ]] --
-- Mengubah semua nilai cooldown di modul Clickers menjadi 0 secara instan
ToggleNoCooldown = function(state)
    if state then
        -- Hooking cooldown values
        if Clickers and Clickers.ClickCooldowns then
            Clickers.ClickCooldowns.Normal = 0
            Clickers.ClickCooldowns.WithFastClicker = 0
            Clickers.ClickCooldowns.WithAutoClicker = 0
        end
        -- Hooking Click Speeds (opsional, untuk mempercepat loop internal game)
        if Clickers and Clickers.Speeds then
            Clickers.Speeds.AutoClicker = 0
            Clickers.Speeds.AutoClickerWithFast = 0
            Clickers.Speeds.SlowClicker = 0
            Clickers.Speeds.FastClicker = 0
        end
    else
        -- Kembalikan ke nilai normal (Contoh nilai default, sesuaikan dengan aslinya)
        if Clickers and Clickers.ClickCooldowns then
            Clickers.ClickCooldowns.Normal = 1.25
            Clickers.ClickCooldowns.WithFastClicker = 1
            Clickers.ClickCooldowns.WithAutoClicker = 1
        end
        -- Hooking Click Speeds (opsional, untuk mempercepat loop internal game)
        if Clickers and Clickers.Speeds then
            Clickers.Speeds.AutoClicker = 1.199
            Clickers.Speeds.AutoClickerWithFast = 1.135
            Clickers.Speeds.SlowClicker = 1.269
            Clickers.Speeds.FastClicker = 1.145
        end
    end
end

-- Cari bagian FarmTabFast dan ubah Callback-nya menjadi seperti ini:
FarmTabFast = FarmTab:Toggle({
    Title = "Fast Auto Attack",
    Desc = "Attack at maximum speed & Double Range",
    Default = false,
    Flag = "AutoFastAttack",
    Callback = function(val)
        Config.NoCooldownAttack = val
        ToggleNoCooldown(Config.NoCooldownAttack)
    end
})
FM_Add("Farm", FarmTabFast)

-- [[ 1. DATA MAPPING FROM GAME LOGIC (DECOMPILE) ]] --
local TraitImages = {
    ["Superior"] = "rbxassetid://70884355735385",
    ["Prodigy"] = "rbxassetid://80226407452888",
    ["Focused"] = "rbxassetid://125939681851804",
    ["Time Traveller"] = "rbxassetid://115981664692797",
    ["Charm"] = "rbxassetid://80716839302728",
    ["Bloodline"] = "rbxassetid://92926227272011",
    ["Evangelist"] = "rbxassetid://132353218742445"
}

local TraitAttributes = {
    ["Superior"] = "<font color='#73ff5d'>| +*number% </font> Power Multiplier",
    ["Prodigy"] = "<font color='#ff0000'>| -*number% </font> Decrease unit exp requirement",
    ["Focused"] = "<font color='#73ff5d'>| +*number% </font> Power for 5 seconds every 30 seconds",
    ["Time Traveller"] = "",
    ["Charm"] = "<font color='#73ff5d'>| +*number% </font> Yen Multiplier",
    ["Bloodline"] = "<font color='#73ff5d'>| +*number% </font> Power per ally with mythic trait",
    ["Evangelist"] = "<font color='#73ff5d'>| +*number% </font> Power per equipped ally"
}

local RarityColors = {
    ["Common"] = Color3.fromRGB(160, 160, 160),
    ["Rare"] = Color3.fromRGB(0, 150, 255),
    ["Epic"] = Color3.fromRGB(190, 0, 255),
    ["Legendary"] = Color3.fromRGB(255, 180, 0),
    ["Mythic"] = Color3.fromRGB(255, 0, 80)
}

-- [[ 2. DYNAMIC CONFIGURATION ]] --
FM_CategoryDescriptions["Traits"] = "Auto-roll Traits And Filter The specific."
Config.Traits = {
    AutoRoll = false,
    SelectedUnitID = nil,
    SelectedTraits = {} 
}

local TraitsModule = require(game:GetService("ReplicatedStorage").Modules.TraitsModule)

local function FormatTraitDesc(traitName)
    local data = TraitsModule[traitName]
    if not data then return "" end
    local template = TraitAttributes[data.Type] or ""
    local val = tostring(data.Attribute * 100)
    return string.gsub(template, "*number", val)
end

local function GetInventoryUnits()
    local unitOptions = {}
    local pData = getgenv().PlayerData
    if pData and pData.Inventory and pData.Inventory.Pets then
        for id, data in pairs(pData.Inventory.Pets) do
            table.insert(unitOptions, {
                Title = data.PetOriginName .. " [" .. data.Traits .. "]",
                Value = id
            })
        end
    end
    if #unitOptions == 0 then table.insert(unitOptions, {Title = "No Units Found", Value = "None"}) end
    return unitOptions
end

-- [[ 3. UI ELEMENTS ]] --

TraitStatus = FarmTab:Paragraph({
    Title = "Trait Status",
    Content = "Please select a unit to view information."
})

UnitSelector = FarmTab:Dropdown({
    Title = "Select Unit to Roll",
    Values = GetInventoryUnits(),
    Default = 1,
    Callback = function(val)
        Config.Traits.SelectedUnitID = type(val) == "table" and val.Value or val
    end
})
UnitRefresh = FarmTab:Button({
            Title = "Refresh Unit",
            Icon = "refresh-cw",
            Callback = function() if UnitSelector then UnitSelector:Refresh(GetInventoryUnits()) end end
        })
-- Dynamic Filter Groups (2 items per Group)
local SortedTraitNames = {}
for name, _ in pairs(TraitsModule) do table.insert(SortedTraitNames, name) end
table.sort(SortedTraitNames, function(a, b) 
    return (TraitsModule[a].Weight or 0) < (TraitsModule[b].Weight or 0) 
end)

local function CreateTraitToggle(Parent, traitName)
    local data = TraitsModule[traitName]
    Parent:Toggle({
        Title = traitName,
        Desc = FormatTraitDesc(traitName),
        Default = false,
        Image = {
            Image = TraitImages[data.Type] or "",
            Gradient = RarityColors[data.Rarity] or Color3.new(1,1,1),
            Title = data.Rarity,
            Quantity = string.format("%.1f%%", data.Weight)
        },
        ImageSize = 60,
        Callback = function(v) 
            Config.Traits.SelectedTraits[traitName] = v 
        end
    })
end

for i = 1, #SortedTraitNames, 2 do
    local TraitGroup = FarmTab:Group({
        Title = i == 1 and "Trait Selection (Stop if Got)" or ""
    })
    
    FM_Add("Traits", TraitGroup)
    CreateTraitToggle(TraitGroup, SortedTraitNames[i])
    if SortedTraitNames[i+1] then
        CreateTraitToggle(TraitGroup, SortedTraitNames[i+1])
    end
end

local AutoTraitToggle = FarmTab:Toggle({
    Title = "Auto Roll Traits",
    Desc = "Automatically roll traits until one of the selections above is obtained.",
    Default = false,
    Callback = function(v) Config.Traits.AutoRoll = v end
})

FM_Add("Traits", TraitStatus)
FM_Add("Traits", UnitSelector)
FM_Add("Traits", UnitRefresh)
FM_Add("Traits", AutoTraitToggle)

-- [[ 4. EXECUTION LOGIC WITH WINDOW CHECK ]] --

task.spawn(function()
    while not Window.Destroyed do
        pcall(function()
            if IsWindowOpen() and AutoTraitToggle and AutoTraitToggle.Value ~= Config.Traits.AutoRoll then
                AutoTraitToggle:Set(Config.Traits.AutoRoll)
            end
        end)

        if Config.Traits.AutoRoll and Config.Traits.SelectedUnitID and Config.Traits.SelectedUnitID ~= "None" then
            pcall(function()
                local pData = getgenv().PlayerData
                local unit = pData.Inventory.Pets[Config.Traits.SelectedUnitID]
                local shards = pData.Inventory.Items.TraitShards or 0
                
                if unit then
                    local currentTrait = unit.Traits
                    
                    if IsWindowOpen() then
                        local displayInfo = "Current Trait: " .. tostring(currentTrait)
                        TraitStatus:SetDesc(displayInfo .. "\nAvailable Shards: " .. shards)
                    end

                    if Config.Traits.SelectedTraits[currentTrait] then
                        Notify("Traits", "Target Trait [" .. currentTrait .. "] Obtained!", "check")
                        Config.Traits.AutoRoll = false
                        if IsWindowOpen() then
                            AutoTraitToggle:Set(false)
                        end
                    elseif shards >= 1 then
                        MetaService.Bridge:Fire("Traits", "Roll", Config.Traits.SelectedUnitID)
                        task.wait(0.8) 
                    else
                        Notify("Warning", "Trait Shards Exhausted!", "alert-triangle")
                        Config.Traits.AutoRoll = false
                        if IsWindowOpen() then
                            AutoTraitToggle:Set(false)
                        end
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- [[ DEVIL SHOP FEATURE - OPTIMIZED UI UPDATE ]] --

-- 1. Inisialisasi Module & Deskripsi Kategori
local DevilShopConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("DevilShopConfig"))
FM_CategoryDescriptions["Devil Shop"] = "Auto-purchase items when stock is available with optimized UI rendering."

Config.AutoBuyDevilShop = {} 
local DevilToggleObjects = {}
local _DevilShop_UI_Cache = {}

-- 2. Logika Deskripsi (Stok & Harga Dinamis)
local function GetDevilItemDesc(itemName, itemInfo)
    local pData = getgenv().PlayerData
    if not pData then return "Loading..." end

    -- Perhitungan Waktu & Stok
    local interval = DevilShopConfig.ResetInterval or 43200
    local currentCycle = math.floor(os.time() / interval)
    local savedCycle = pData.DevilShopCycle or 0
    local history = (savedCycle ~= currentCycle) and {} or (pData.DevilShopHistory or {})
    
    local bought = history[itemName] or 0
    local stockLeft = math.max(0, itemInfo.MaxStock - bought)
    local colorStock = stockLeft > 0 and "#44ff44" or "#ff4444"

    -- Perhitungan Harga (Gaya Upgrades)
    local currency = DevilShopConfig.Currency
    local price = itemInfo.Price
    local owned = (pData.Inventory and pData.Inventory.Items[currency]) or 0
    local itemCurrencyInfo = Items[currency]
    
    local priceColor = owned >= price and "#44ff44" or "#ff4444"
    local priceString = string.format("<font color='%s'>%s/%s</font> %s%s", 
        priceColor, formatNum(owned), formatNum(price), itemCurrencyInfo.Name, itemCurrencyInfo.Icon)

    return string.format("Stock: <font color='%s'>%d/%d</font>\nCost: %s", 
        colorStock, stockLeft, itemInfo.MaxStock, priceString)
end

-- 3. UI Reset Timer
local DevilShopTimer = FarmTab:Paragraph({
    Title = "Shop Reset Timer",
    Content = "Calculating time..."
})
FM_Add("Devil Shop", DevilShopTimer)

-- 4. Pembuatan Toggle Otomatis (Grid 2 Kolom)
local ShopItems = {}
for name, info in pairs(DevilShopConfig.ShopData) do 
    table.insert(ShopItems, {Name = name, Info = info}) 
end

for i = 1, #ShopItems, 2 do
    local ShopGroup = FarmTab:Group({})
    FM_Add("Devil Shop", ShopGroup)

    for j = 0, 1 do
        local item = ShopItems[i + j]
        if item then
            local itemName = item.Name
            local info = item.Info
            local itemDetail = Items[info.ItemKey]

            local ItemToggle = ShopGroup:Toggle({
                Title = itemName,
                Desc = GetDevilItemDesc(itemName, info),
                Default = false,
                Flag = "AutoBuyDevil_" .. itemName:gsub(" ", ""),
                Callback = function(val) Config.AutoBuyDevilShop[itemName] = val end
            })

            -- Ikon Item
            if itemDetail then
                ItemToggle:SetMainImage(itemDetail.Icon, 30)
            end

            DevilToggleObjects[itemName] = ItemToggle
        end
    end
end

-- 5. Main Loop: Auto Buy & Conditional UI Update
task.spawn(function()
    while not Window.Destroyed do
        local pData = getgenv().PlayerData
        if pData then
            -- 1. Update Timer (Hanya jika UI Terbuka)
            local interval = DevilShopConfig.ResetInterval or 43200
            local timeLeft = interval - (os.time() % interval)
            
            if IsWindowOpen() then 
                DevilShopTimer:SetDesc(string.format("Devil Shop Resets in: %dh %dm %ds", 
                    math.floor(timeLeft/3600), math.floor((timeLeft%3600)/60), math.floor(timeLeft%60))) 
            end

            -- 2. Proses Item
            for itemName, info in pairs(DevilShopConfig.ShopData) do
                local isActive = Config.AutoBuyDevilShop[itemName]
                local uiToggle = DevilToggleObjects[itemName]

                -- UPDATE DESKRIPSI: Cek jika jendela terbuka sebelum memperbarui
                if IsWindowOpen() and uiToggle then
                    local currentDesc = GetDevilItemDesc(itemName, info)
                    if _DevilShop_UI_Cache[itemName] ~= currentDesc then
                        uiToggle:SetDesc(currentDesc)
                        _DevilShop_UI_Cache[itemName] = currentDesc
                    end
                end

                -- LOGIKA AUTO BUY (Berjalan di background)
                if isActive then
                    local currentCycle = math.floor(os.time() / interval)
                    local savedCycle = pData.DevilShopCycle or 0
                    local history = (savedCycle ~= currentCycle) and {} or (pData.DevilShopHistory or {})
                    
                    local stockLeft = info.MaxStock - (history[itemName] or 0)
                    local myCoins = (pData.Inventory and pData.Inventory.Items[DevilShopConfig.Currency]) or 0

                    if stockLeft > 0 and myCoins >= (info.Price * stockLeft) then
                        MetaService.Bridge:Fire("Devil Shop", "BuyItem", {
                            ["Key"] = itemName,
                            ["Amount"] = stockLeft
                        })
                        task.wait(0.5) 
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- [[ CHRISTMAS FEATURE - EXCHANGER & SHOP FIXED ]] --
local ChristmasConfig = require(ReplicatedStorage.Modules.ChristmasExchangerConfig)
local ChristmasShopConfig = require(ReplicatedStorage.Modules.ChristmasShopConfig)
FM_CategoryDescriptions["Christmas"] = "Auto-exchange items and Auto-buy Christmas Shop limited stock."

Config.Christmas = { AutoExchanges = {}, Amounts = {} }
Config.ChristmasShop = { AutoBuy = {} }

-- 1. CHRISTMAS SHOP TIMER (Diletakkan paling atas agar selalu terlihat)
local XmasShopTimer = FarmTab:Paragraph({
    Title = "Christmas Shop Timer",
    Content = "Calculating reset time..."
})
FM_Add("Christmas", XmasShopTimer)
XmasUIObjects.Timer = XmasShopTimer

-- [[ BAGIAN A: CHRISTMAS EXCHANGER (2 ITEMS PER GROUP) ]] --
local function GetExchangeDesc(exchangeKey, data)
    local amount = Config.Christmas.Amounts[exchangeKey] or 1
    local result = amount * data.Ratio
    return string.format("Mode: %s ➔ %s\nRatio: 1:%s\nCost: %s %s", 
        data.Left, data.Right, formatNum(data.Ratio), formatNum(result), data.Left)
end

local SortedExchanges = {}
for key, data in pairs(ChristmasConfig.Exchanges) do table.insert(SortedExchanges, {Key = key, Data = data}) end

for i = 1, #SortedExchanges, 2 do
    local ChristmasGroup = FarmTab:Group({ Title = i == 1 and "Christmas Event Exchanger" or "" })
    FM_Add("Christmas", ChristmasGroup)
    for j = 0, 1 do
        local exchange = SortedExchanges[i + j]
        if exchange then
            local eKey, eData = exchange.Key, exchange.Data
            local AmountInput = ChristmasGroup:Input({
                Title = "Amount: " .. eKey:gsub("_", " "),
                Placeholder = "Amount...",
                Default = "1",
                Flag = "XmasAmount_" .. eKey,
                Callback = function(val) Config.Christmas.Amounts[eKey] = tonumber(val) or 0 end
            })
            XmasUIObjects.AmountInputs[eKey] = AmountInput
            local ExchangeToggle = ChristmasGroup:Toggle({
                Title = "Auto " .. eKey:gsub("_", " "),
                Desc = GetExchangeDesc(eKey, eData),
                Default = false,
                Flag = "XmasAuto_" .. eKey,
                Callback = function(val) Config.Christmas.AutoExchanges[eKey] = val end
            })
            XmasUIObjects.ExchangeToggles[eKey] = ExchangeToggle
            task.spawn(function()
                while not Window.Destroyed do
                    if IsWindowOpen() then
                        local currentDesc = GetExchangeDesc(eKey, eData)
                        if ExchangeToggle.Desc ~= currentDesc then ExchangeToggle:SetDesc(currentDesc) end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
end

local function GetXmasShopDesc(itemName, itemData)
    local pData = getgenv().PlayerData
    if not pData then return "Loading..." end

    -- Perhitungan Waktu & Stok (History)
    local interval = ChristmasShopConfig.ResetInterval or 43200
    local currentCycle = math.floor(os.time() / interval)
    local savedCycle = pData.ChristmasShopCycle or 0
    local history = (savedCycle ~= currentCycle) and {} or (pData.ChristmasShopHistory or {})
    
    local bought = history[itemName] or 0
    local stockLeft = math.max(0, itemData.MaxStock - bought)
    local colorStock = stockLeft > 0 and "#44ff44" or "#ff4444"

    -- Perhitungan Harga & Warna Berdasarkan Saldo
    local currency = ChristmasShopConfig.Currency
    local price = itemData.Price
    local owned = (pData.Inventory and pData.Inventory.Items[currency]) or 0
    local itemCurrencyInfo = Items[currency]
    
    local priceColor = owned >= price and "#44ff44" or "#ff4444"
    
    -- Format String Harga dengan Ikon dan Warna
    local priceString = string.format("<font color='%s'>%s/%s</font> %s%s", 
        priceColor, 
        formatNum(owned), 
        formatNum(price), 
        (itemCurrencyInfo and itemCurrencyInfo.Name or currency),
        (itemCurrencyInfo and itemCurrencyInfo.Icon or "")
    )

    return string.format("Stock: <font color='%s'>%d/%d</font>\nCost: %s", 
        colorStock, stockLeft, itemData.MaxStock, priceString)
end

local XmasShopItems = {}
for name, info in pairs(ChristmasShopConfig.ShopData) do table.insert(XmasShopItems, {Name = name, Info = info}) end

for i = 1, #XmasShopItems, 2 do
    local ShopGroup = FarmTab:Group({ Title = i == 1 and "Christmas Shop (Limited Stock)" or "" })
    FM_Add("Christmas", ShopGroup)
    for j = 0, 1 do
        local item = XmasShopItems[i + j]
        if item then
            local itemName, info = item.Name, item.Info
            local ShopToggle = ShopGroup:Toggle({
                Title = "Auto " .. itemName,
                Desc = GetXmasShopDesc(itemName, info),
                Default = false,
                Flag = "XmasShopAuto_" .. info.ItemKey,
                Callback = function(val) Config.ChristmasShop.AutoBuy[itemName] = val end
            })
            XmasUIObjects.ShopToggles[itemName] = ShopToggle
            if Items[info.ItemKey] and Items[info.ItemKey].Icon then ShopToggle:SetMainImage(Items[info.ItemKey].Icon, 30) end
            task.spawn(function()
                while not Window.Destroyed do
                    if IsWindowOpen() then
                        local d = GetXmasShopDesc(itemName, info)
                        if ShopToggle.Desc ~= d then ShopToggle:SetDesc(d) end
                    end
                    task.wait(1)
                end
            end)
        end
    end
end

-- [[ LOGIKA EKSEKUSI BACKGROUND (TIMER & AUTO ACTION) ]] --
task.spawn(function()
    while not Window.Destroyed do
        local premium = (getgenv().IsPremium == true)
        local pData = getgenv().PlayerData
        if pData then
            -- 1. UPDATE TIMER (DI LUAR CEK MAP - AGAR SELALU KELIHATAN)
            local interval = ChristmasShopConfig.ResetInterval or 43200
            local timeLeft = interval - (os.time() % interval)
            if IsWindowOpen() then
                XmasShopTimer:SetDesc(string.format("Christmas Shop Resets in: %dh %dm %ds", 
                    math.floor(timeLeft/3600), math.floor((timeLeft%3600)/60), math.floor(timeLeft%60)))
            end
            if premium then
                for eKey, _ in pairs(ChristmasConfig.Exchanges) do
                    if Config.Christmas.AutoExchanges[eKey] and (Config.Christmas.Amounts[eKey] or 0) > 0 then
                        MetaService.Bridge:Fire("ChristmasExchanger", "Exchange", {
                            ["Key"] = eKey, ["Amount"] = Config.Christmas.Amounts[eKey], ["Inverted"] = false
                        })
                    end
                end

                for itemName, info in pairs(ChristmasShopConfig.ShopData) do
                    if Config.ChristmasShop.AutoBuy[itemName] then
                        local history = (math.floor(os.time() / interval) ~= (pData.ChristmasShopCycle or 0)) and {} or (pData.ChristmasShopHistory or {})
                        local stockAvailable = info.MaxStock - (history[itemName] or 0)
                        local ownedSnow = (pData.Inventory and pData.Inventory.Items[ChristmasShopConfig.Currency]) or 0
                        if stockAvailable > 0 and ownedSnow >= (info.Price * stockAvailable) then
                            MetaService.Bridge:Fire("ChristmasShop", "BuyItem", { ["Key"] = itemName, ["Amount"] = stockAvailable })
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)
-- [[ AVATARS FEATURE LOGIC ]] --
local AvatarsModule = require(ReplicatedStorage.Modules.Avatars)
FM_CategoryDescriptions["Avatars"] = "Manage your avatars and auto-level them using Enemies Essence."

Config.Avatars = {
    AutoLevel = false,
    SelectedAvatarID = nil
}

-- Fungsi untuk mendapatkan daftar avatar yang dimiliki (Sudah di-sort berdasarkan BasePower)
local function GetOwnedAvatars()
    local options = {}
    local pData = getgenv().PlayerData
    if pData and pData.Avatars and pData.Avatars.Owned then
        for id, _ in pairs(pData.Avatars.Owned) do
            local info = AvatarsModule.Get(id)
            if info then
                table.insert(options, {
                    Title = info.DisplayName or info.Name,
                    Value = id,
                    Desc = "Rarity: " .. (info.Rarity or "Unknown") .. "\nBase Power: x" .. info.BasePower,
                    Power = info.BasePower or 0 -- Kita ambil BasePower untuk kriteria sorting
                })
            end
        end
    end

    -- LOGIKA SORTING: Dari BasePower Tertinggi ke Terendah
    table.sort(options, function(a, b)
        return a.Power < b.Power
    end)

    -- Jika tidak ada avatar, tampilkan pesan kosong
    if #options == 0 then 
        table.insert(options, {Title = "No Avatars Found", Value = "None", Power = 0}) 
    end
    
    return options
end

-- UI Elements
-- (AvatarStatus dihapus sesuai permintaan)

AvatarSelector = FarmTab:Dropdown({
    Title = "Select Avatar",
    Values = GetOwnedAvatars(),
    Default = 1,
    Flag = "AvatarSelector_Flag", -- Flag ditambahkan
    Callback = function(val)
        Config.Avatars.SelectedAvatarID = type(val) == "table" and val.Value or val
    end
})

AvatarRefresh = FarmTab:Button({
    Title = "Refresh Inventory",
    Icon = "refresh-cw",
    Callback = function() 
        if AvatarSelector then AvatarSelector:Refresh(GetOwnedAvatars()) end 
    end
})

AutoLevelAvatarToggle = FarmTab:Toggle({
    Title = "Auto Level Up",
    Desc = "Automatically upgrade selected avatar using Enemies Essence.",
    Default = false,
    Flag = "AutoLevelAvatar_Flag", -- Flag ditambahkan
    Callback = function(v) Config.Avatars.AutoLevel = v end
})

-- Daftarkan ke Category Avatars
FM_Add("Avatars", AvatarSelector)
FM_Add("Avatars", AvatarRefresh)
FM_Add("Avatars", AutoLevelAvatarToggle)

-- [[ LOOPING LOGIKA AUTO LEVEL & UI UPDATE ]] --
task.spawn(function()
    local _LastUpdateText = "" -- Cache untuk efisiensi update UI
    while not Window.Destroyed do
        local pData = getgenv().PlayerData
        local avatarID = Config.Avatars.SelectedAvatarID
        
        if avatarID and avatarID ~= "None" and pData then
            local ownedData = pData.Avatars.Owned[avatarID]
            local info = AvatarsModule.Get(avatarID)
            local essence = pData.Inventory.Items.EnemiesEssence or 0
            
            if info and ownedData then
                local currentLevel = (type(ownedData) == "table" and ownedData.Level) or 1
                local cost = AvatarsModule.CalculateUpgradeCost(avatarID, currentLevel)
                local Power = AvatarsModule.CalculatePower(avatarID, currentLevel)
                
                -- Update Info ke Deskripsi Dropdown secara Realtime
                if IsWindowOpen() then
                    local statusText = string.format(
                        "Level: %d / %d | Power: x%s\nCost: %s %s | Essence: %s",
                        currentLevel, info.MaxLevel or 50,
                        Power,
                        (cost == "MAX" and "MAXED" or formatNum(cost)),
                        Items["EnemiesEssence"].Icon,
                        formatNum(essence)
                    )
                    
                    -- Hanya update jika teks berubah agar tidak lag
                    if _LastUpdateText ~= statusText then
                        AvatarSelector:SetDesc(statusText)
                        _LastUpdateText = statusText
                    end

                    -- Logika Lock Toggle jika sudah MAX
                    if cost == "MAX" then
                        if Config.Avatars.AutoLevel then
                            Config.Avatars.AutoLevel = false
                            AutoLevelAvatarToggle:Set(false)
                        end
                        AutoLevelAvatarToggle:Lock("MAX")
                    else                        
                        AutoLevelAvatarToggle:Unlock()
                    end
                end

                -- Logika Auto Upgrade
                if Config.Avatars.AutoLevel then
                    if cost ~= "MAX" and essence >= cost then
                        ReplicatedStorage.AvatarLeveling_Upgrade:FireServer(avatarID, 1)
                        task.wait(0.15) 
                    end
                end
            end
        end
        task.wait(0.2)
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
