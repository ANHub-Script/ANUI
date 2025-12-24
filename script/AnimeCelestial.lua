if game.PlaceId ~= 104470677863797 then return end
repeat task.wait() until game:IsLoaded()

loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading3.lua"))()

-- [[ Services & Dasar ]] --
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
Workspace = game:GetService("Workspace")
ReplicatedStorage = game:GetService("ReplicatedStorage")
ReplicatedFirst = game:GetService("ReplicatedFirst")
HttpService = game:GetService("HttpService")
RunService = game:GetService("RunService")
VirtualUser = game:GetService("VirtualUser")
FolderPath = "ANUI/AnimeFrontiers"
ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local IsPremium = false
local ValidKeys = {"ANHUB-2025"}
MapDBFile = "Map_Database.json"
Config = {
    SelectedEnemy = nil,
    MapConfigurations = {},
    AutoFarm = false
}
ConfigName = "ANConfig"
CurrentMapEnemiesCache = {}
IsLoadingConfig = false
IsLoadingMapSelection = false
-- [[ Fungsi Notify ]] --
function Notify(title, content, icon)
    task.spawn(function()
        pcall(function()
            if UI and UI.Notify then
                UI:Notify({ Title = title, Content = content, Icon = icon, Duration = 3 })
            end
        end)
    end)
end

-- [[ SISTEM PROFILE ]] --
GameIconURL = string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", game.GameId)
BaseProfile = {
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



-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    local vu = VirtualUser
    if not vu then
        return
    end
    pcall(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end)

function MakeProfile(data)
    local p = table.clone(BaseProfile)
    for k, v in pairs(data or {}) do p[k] = v end
    return p
end

function SecureWipe()
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

function LoadKeySystemData()
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

-- [[ Inisialisasi Window ]] --
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

-- Sidebar Animation
task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
Window:Tab({
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Celestial" }),
    SidebarProfile = true
})

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

-- [[ LOGIKA CATEGORY MANAGER ]] --
FM_Categories = {}
FM_CategoryDescriptions = {
    ["Farm"] = "Auto farm enemies and specific targets.",
    ["Rank"] = "Auto increase your rank and view progress."
    -- ["Hatch"] = "Auto open eggs and manage pets/heroes."
}

function FM_GetElementFrame(elem)
    return rawget(elem, "ElementFrame") or (elem.UIElements and elem.UIElements.Main) or rawget(elem, "GroupFrame")
end

-- Fungsi Update Profile Header (Kembali Ditambahkan)
function FM_UpdateTabProfile(selected)
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

function FM_Add(cat, elem)
    if not FM_Categories[cat] then FM_Categories[cat] = {} end
    table.insert(FM_Categories[cat], elem)
    local frame = FM_GetElementFrame(elem)
    if frame then frame.Visible = false end
    return elem
end

function FM_OnChange(selected)
    for name, elems in pairs(FM_Categories) do
        local vis = (name == selected)
        for _, e in ipairs(elems) do
            local f = FM_GetElementFrame(e)
            if f then f.Visible = vis end
        end
    end
    -- Panggil update profile saat ganti kategori
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
        {Title = "Roll", Icon = "rbxassetid://139336076943135"},
        {Title = "Limit Breaks", Icon = "rbxassetid://101194034780669"},
        {Title = "Dungeons", Icon = "rbxassetid://84653254384417"}
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
local Utility = require(ReplicatedStorage.Modules.Utility)
local RanksModule = require(ReplicatedStorage.Modules.Ranks)
task.spawn(function()
    while not Window.Destroyed do
        getgenv().PlayerData = MetaService.Data
        getgenv().EnemiesData = MetaService.Cache.Enemies
        task.wait()
    end
end)
function GetCurrentMapName()
    local PlayerData = getgenv().PlayerData
    if PlayerData and PlayerData.Map and PlayerData.Map ~= "" then
        return PlayerData.Map
    end
    return "Unknown"
end
function LoadMapDB()
    local path = FolderPath .. "/" .. MapDBFile
    if not isfile or not isfile(path) then return end
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if success and type(result) == "table" then
        Config.MapConfigurations = result
    end
end
function SaveMapConfig(mapName, selectedItem)
    if not mapName or mapName == "" or mapName == "Unknown" then return end
    if not selectedItem then return end
    local val = type(selectedItem) == "table" and selectedItem.Value or selectedItem
    local title = type(selectedItem) == "table" and selectedItem.Title or selectedItem
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
    Config.SelectedEnemy = val
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
function ApplySavedEnemyForMap(mapName, enemiesList)
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
        Config.SelectedEnemy = foundEnemyTable.Value
        pcall(function()
            if EnemyDropdown and EnemyDropdown.Select then
                -- KIRIM FULL TABLE agar library ANUI bisa mencocokkan Title visualnya
                EnemyDropdown:Select(foundEnemyTable) 
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
local function GetClosestEnemy()
    local targetName = Config.SelectedEnemy
    if not targetName or not getgenv().EnemiesData or not LocalPlayer.Character then return nil, nil end

    local closestPart = nil
    local closestID = nil -- Tambahkan ini untuk melacak ID
    local shortestDistance = math.huge
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil end

    for id, data in pairs(getgenv().EnemiesData) do
        local nameMatch = (data.Info and data.Info.Name == targetName or data.Name == targetName)
        
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

function GetEnemiesForCurrentMap()
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
    Multi = false,
    Flag = "SelectedEnemy_Flag",
    Callback = function(Value)
        -- Jika Value adalah tabel (hasil dari Select(foundEnemyTable))
        local isTable = type(Value) == "table"
        local selectedTarget = isTable and Value.Value or Value
        Config.SelectedEnemy = selectedTarget
        
        if selectedTarget and selectedTarget ~= "None" then
            if not IsLoadingMapSelection then
                SaveMapConfig(GetCurrentMapName(), Config.SelectedEnemy)
            end
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
            if EnemyFarm and EnemyFarm.Value then
                AutoFarmInternalChange = true
                pcall(function()
                    EnemyFarm:Set(false)
                end)
                AutoFarmInternalChange = false
            end
        else
            if AutoFarmWanted and not Config.AutoFarm then
                Config.AutoFarm = true
                if EnemyFarm and not EnemyFarm.Value then
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
        if Config.AutoFarm and Config.SelectedEnemy then
            local isTargetValid = false
            local targetPart = nil
            
            -- 1. Validasi Target Saat Ini
            if currentTargetID and getgenv().EnemiesData[currentTargetID] then
                local data = getgenv().EnemiesData[currentTargetID]
                local enemyName = data.Info and data.Info.Name or data.Name
                
                -- Syarat Valid: ID ada, HP > 0, Nama sesuai, dan Model ada
                if data.Object and data.Object:GetAttribute("Health") > 0 and enemyName == Config.SelectedEnemy then
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
                local newTargetPart, newTargetID = GetClosestEnemy()
                
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
    while not Window.Destroyed do
        local currentMap = GetCurrentMapName()
        
        -- Deteksi Perubahan Map
        if currentMap and currentMap ~= lastMap and currentMap ~= "Unknown" then
            lastMap = currentMap
            
            -- [1] RESET TOTAL: Hapus target lama seketika agar tidak menyerang musuh map sebelumnya
            Config.SelectedEnemy = nil
            currentTargetID = nil
            if EnemyDropdown and EnemyDropdown.Select then
                EnemyDropdown:Select(nil)
            end

            -- [2] RETRY LOGIC: Tunggu sampai musuh di map baru benar-benar muncul di MetaService
            local newList = GetEnemiesForCurrentMap()

            CurrentMapEnemiesCache = newList
            
            -- [3] Refresh UI & Terapkan Config
            LoadMapDB() 
            if EnemyDropdown and EnemyDropdown.Refresh then
                EnemyDropdown:Refresh(newList)
            end
            
            -- Panggil fungsi apply untuk memilih musuh otomatis
            ApplySavedEnemyForMap(currentMap, newList)
            currentTargetID = Config.SelectedEnemy
        end
        task.wait()
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
local _RankCache = "" -- Untuk mencegah flickering/update berlebih jika data tidak berubah

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

                -- Update UI hanya jika ada perubahan (Realtime Optimization)
                if _RankCache ~= infoText then
                    RankLabel:SetTitle(titleText)
                    RankLabel:SetDesc(infoText)
                    _RankCache = infoText
                end

                -- Logika Auto Rank Up
                if Config.AutoRankUp and not isMax and currentYens >= price then
                    MetaService.Bridge:Fire("RankUp", "RankUp")
                    task.wait(0.5) -- Jeda singkat setelah rank up
                end
            end
        end)
        task.wait() -- Update setiap 0.2 detik agar terasa sangat realtime
    end
end)

-- [[ 1. UPDATE SELECTOR KATEGORI ]] --
-- Cari FM_CategorySelector kamu dan tambahkan "Roll" ke Options:
-- {Title = "Roll", Icon = "rbxassetid://139336076943135"}

FM_CategoryDescriptions["Roll"] = "Auto roll roads for each map."

-- [[ 2. LOGIKA ROLL CATEGORY ]] --
local MapsModule = require(game:GetService("ReplicatedStorage").Modules.Maps)
local RoadsModule = require(game:GetService("ReplicatedStorage").Modules.Roads)
local RoadFunctions = RoadsModule.Functions
local RoadBoosts = RoadsModule.Boosts
local Road = RoadsModule.Roads

Config.AutoRollMaps = {} -- Tabel untuk menyimpan status toggle tiap map

-- Fungsi untuk mengecek apakah bisa Roll (berdasarkan logika decompile v_u_62)
function CanRoll(mapName)
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
        local _ImageCache = nil -- Cache per toggle
        while not Window.Destroyed do
            local pData = getgenv().PlayerData
            local pMaps = pData and pData.Inventory and pData.Inventory.Maps
            
            if pMaps then
                local isMapUnlocked = pMaps[mapName]
                if isMapUnlocked == false then
                    if MapToggle.Value then MapToggle:Set(false) end
                    MapToggle:Lock("Open Map First")
                else
                    MapToggle:Unlock()
                    
                    local unitName = pData.Gachas and pData.Gachas[mapName] or "None"
                    if _ImageCache ~= unitName then
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
                            -- Update UI sebelum menunggu animasi agar responsif
                            if _LastStatusCache[mapName] ~= statusText then
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

            -- UPDATE UI: Hanya jika ada perubahan data/status (Optimasi)
            if _LastStatusCache[mapName] ~= statusText then
                toggleUI:SetDesc(statusText)
                _LastStatusCache[mapName] = statusText
            end
        end

        task.wait() -- Check setiap 0.2 detik untuk performa real-time yang ringan
    end
end)

-- [[ DUNGEON DATA FETCH ]] --
local DungeonsModule = require(ReplicatedStorage.Modules.DungeonsModule)

function GetDynamicDifficulties()
    local difficulties = DungeonsModule.Difficulties
    return difficulties
end

Config.AutoDungeon = false
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
function GetDungeonTarget()
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
        if Config.AutoDungeon then
            pcall(function()
                local GameplayUI = LocalPlayer.PlayerGui.Main.Gameplay
                local DungeonHUD = GameplayUI:FindFirstChild("Dungeon_em_andamento")
                local TopView = DungeonHUD and DungeonHUD:FindFirstChild("Top_view")
                local FinishUI = DungeonHUD and DungeonHUD:FindFirstChild("Acabamento da dungeon")

                -- Jika Dungeon selesai, berhenti teleport
                if FinishUI and FinishUI.Visible then
                    FinishUI.Visible = false
                end
                
                -- B. Jika Berada di Lobi (Dungeon Belum Start)
                if not (TopView and TopView.Visible) then
                    if GetCurrentMapName() == "Piece Village" then
                        local Bridge = MetaService.Bridge
                        local session = GetDungeonSession()
                        if Bridge and Bridge.Fire and not session then
                            
                            -- RESET TOTAL: Memanggil EndScreen sebelum Create
                            -- Ini memastikan musik reset, koneksi diputus, dan lobi bersih
                            ForceEndDungeon()
                            task.wait(1.5) -- Jeda agar efek transisi EndScreen selesai

                            -- Create Dungeon
                            Bridge:Fire("Dungeon", "Create")
                            task.wait(0.8)
                            
                            -- Pilih Difficulty
                            if Config.SelectedDifficulty then
                                Bridge:Fire("Dungeon", "ChangeDifficulty", Config.SelectedDifficulty)
                                task.wait(0.5)
                            end

                            -- Start Dungeon
                            Bridge:Fire("Dungeon", "Start")
                            task.wait(2)
                        end
                    end
                else
                    -- C. Logika Farming di Dalam Dungeon
                    local roomModels = GetActiveRoomModels()
                    local currentRoom = roomModels and roomModels.Current
                    local currentName = currentRoom and currentRoom.Name or ""
                    
                    if currentName ~= "" and currentName ~= lastRoomName then
                        task.wait(0.6)
                        lastRoomName = currentName
                    end

                    local target = GetDungeonTarget()
                    if target then
                        local root = LocalPlayer.Character.HumanoidRootPart
                        local targetCF = target:IsA("Model") and target.HumanoidRootPart.CFrame or target.CFrame
                        root.CFrame = targetCF * CFrame.new(0, 0, 3)
                    end
                end
            end)
        end
        task.wait(0.1)
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
    Title = "Auto Dungeon",
    Desc = "Only targets enemies in CurrentRoom after door opens",
    Default = false,
    Flag = "AutoDungeon_Setting",
    Callback = function(val) Config.AutoDungeon = val end
})

FM_Add("Dungeons", DifficultyDropdown)
FM_Add("Dungeons", AutoDungeonToggle)

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
        local pData = MetaService.Data
        if pData then
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
                    if toggleUI then
                        local status = GetScrapSideDesc(mapName, side, sideData)
                        if not Window.Closed then
                            toggleUI:SetDesc(status)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
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
        table.insert(costStrings, string.format("<font color='%s'>%s/%s</font> %s%s", 
            color, formatNum(owned), formatNum(amount), Items[itemName].Name,Items[itemName].Icon))
    end

    return string.format("Level: %d/%d (+%.1f%% %s)\nCost:\n%s", 
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
        local pData = MetaService.Data
        if pData then
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
                    if toggleUI then
                        local status = GetDevilSideDesc(mapName, side, sideData)
                        if not Window.Closed then
                            toggleUI:SetDesc(status)
                        end
                    end
                end
            end
        end
        task.wait(0.5) -- Delay loop agar tidak membebani CPU
    end
end)


-- [[ LIMIT BREAKS FEATURE - GROUP STRUCTURE ]] --
local LB_Config = require(ReplicatedStorage.Modules.LimitBreaksConfig)
Config.AutoLimitBreaks = {} 
local LB_ToggleObjects = {}
local _LB_LastStatus = {}

-- Fungsi untuk membuat deskripsi status (Level, Bonus, Biaya)
local function GetLBDesc(mapName, mapData)
    local pData = MetaService.Data
    if not pData then return "Loading..." end
    
    local currentLvl = (pData.LimitBreaks and pData.LimitBreaks[mapName]) or 0
    local currency = mapData.Currency
    local owned = (pData.Inventory and pData.Inventory.Items[currency]) or 0
    local cost = mapData.GetCost(currentLvl + 1)
    local multiplier = LB_Config.GetMultiplier(mapName, currentLvl) * 100
    
    if currentLvl >= mapData.MaxLevel then
        return string.format("Level: %d (MAX)\nBonus: +%.1f%% %s", currentLvl, multiplier, mapData.StatType)
    end
    
    return string.format("Level: %d/%d (+%.1f%% %s)\n%s%s %s/%s", 
        currentLvl, mapData.MaxLevel, multiplier, mapData.StatType, Items[currency].Icon,Items[currency].Name,
        formatNum(owned), formatNum(cost))
end

-- Looping untuk membuat Group per Map
for _, mData in ipairs(SortedMaps) do
    local mapName = mData.Name
    local lbData = LB_Config.Data[mapName]

    -- Hanya buat Group jika map tersebut ada dalam konfigurasi Limit Break
    if lbData then
        -- Membuat Group (Satu baris per map)
        local MapGroup = FarmTab:Group({
            Title = lbData.FolderName or mapName
        })
        
        -- Daftarkan Group ke Category Manager agar bisa difilter
        FM_Add("Limit Breaks", MapGroup)

        -- Tambahkan Toggle ke dalam Group tersebut
        local LBToggle = MapGroup:Toggle({
            Title = mData.FrameName or mapName,
            Desc = GetLBDesc(mapName, lbData),
            Default = false,
            Flag = "LBToggle_" .. mapName:gsub(" ", ""),
            Callback = function(val)
                Config.AutoLimitBreaks[mapName] = val
            end
        })

        -- Berikan Icon Map agar serupa dengan kategori Roll
        LBToggle:SetMainImage(mData.Icon, 30)
        
        LB_ToggleObjects[mapName] = LBToggle
    end
end

-- [[ LOGIKA AUTO UPGRADE ]] --
task.spawn(function()
    while not Window.Destroyed do
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
                local currentStatus = GetLBDesc(mapName, lbData)
                if not Window.Closed then
                    toggleUI:SetDesc(currentStatus)
                end
            end
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while not Window.Destroyed do
        local premium = (getgenv().IsPremium == true)
        local pData = MetaService and MetaService.Data
        
        if not premium then
            Config.AutoDungeon = false
            if AutoDungeonToggle and AutoDungeonToggle.Value then
                pcall(function()
                    AutoDungeonToggle:Set(false)
                end)
            end
            
            if DifficultyDropdown then
                pcall(function()
                    DifficultyDropdown:Lock("Premium Only")
                end)
            end
            if AutoDungeonToggle then
                pcall(function()
                    AutoDungeonToggle:Lock("Premium Only")
                end)
            end
            
            for mapName, toggleUI in pairs(LB_ToggleObjects) do
                Config.AutoLimitBreaks[mapName] = false
                if toggleUI and toggleUI.Value then
                    pcall(function()
                        toggleUI:Set(false)
                    end)
                end
                if toggleUI then
                    pcall(function()
                        toggleUI:Lock("Premium Only")
                    end)
                end
            end
            
            for mapName, sides in pairs(ScrapConfig.Upgrades) do
                for _, side in ipairs({"Left", "Right"}) do
                    Config.AutoScrap[side][mapName] = false
                    local toggleUI = ScrapToggleObjects[side][mapName]
                    if toggleUI and toggleUI.Value then
                        pcall(function()
                            toggleUI:Set(false)
                        end)
                    end
                    if toggleUI then
                        pcall(function()
                            toggleUI:Lock("Premium Only")
                        end)
                    end
                end
            end
            
            for mapName, sides in pairs(DevilConfig.Upgrades) do
                for _, side in ipairs({"Left", "Right"}) do
                    Config.AutoDevil[side][mapName] = false
                    local toggleUI = DevilToggleObjects[side][mapName]
                    if toggleUI and toggleUI.Value then
                        pcall(function()
                            toggleUI:Set(false)
                        end)
                    end
                    if toggleUI then
                        pcall(function()
                            toggleUI:Lock("Premium Only")
                        end)
                    end
                end
            end
        else
            if DifficultyDropdown then
                pcall(function()
                    DifficultyDropdown:Unlock()
                end)
            end
            if AutoDungeonToggle then
                pcall(function()
                    AutoDungeonToggle:Unlock()
                end)
            end
            
            for mapName, toggleUI in pairs(LB_ToggleObjects) do
                local lbData = LB_Config and LB_Config.Data and LB_Config.Data[mapName]
                local currentLvl = (pData and pData.LimitBreaks and pData.LimitBreaks[mapName]) or 0
                if toggleUI then
                    if lbData and currentLvl >= lbData.MaxLevel then
                        Config.AutoLimitBreaks[mapName] = false
                        if toggleUI.Value then
                            pcall(function()
                                toggleUI:Set(false)
                            end)
                        end
                        pcall(function()
                            toggleUI:Lock("MAX")
                        end)
                    else
                        pcall(function()
                            toggleUI:Unlock()
                        end)
                    end
                end
            end
            
            for mapName, sides in pairs(ScrapConfig.Upgrades) do
                for _, side in ipairs({"Left", "Right"}) do
                    local sideData = sides[side]
                    local toggleUI = ScrapToggleObjects[side][mapName]
                    local currentLvl = (pData and pData.ScrapUpgrades and pData.ScrapUpgrades[mapName] and pData.ScrapUpgrades[mapName][side]) or 0
                    if toggleUI then
                        if sideData and currentLvl >= sideData.MaxLevel then
                            Config.AutoScrap[side][mapName] = false
                            if toggleUI.Value then
                                pcall(function()
                                    toggleUI:Set(false)
                                end)
                            end
                            pcall(function()
                                toggleUI:Lock("MAX")
                            end)
                        else
                            pcall(function()
                                toggleUI:Unlock()
                            end)
                        end
                    end
                end
            end
            
            for mapName, sides in pairs(DevilConfig.Upgrades) do
                for _, side in ipairs({"Left", "Right"}) do
                    local sideData = sides[side]
                    local toggleUI = DevilToggleObjects[side][mapName]
                    local currentLvl = (pData and pData.DevilUpgrades and pData.DevilUpgrades[mapName] and pData.DevilUpgrades[mapName][side]) or 0
                    if toggleUI then
                        if sideData and currentLvl >= sideData.MaxLevel then
                            Config.AutoDevil[side][mapName] = false
                            if toggleUI.Value then
                                pcall(function()
                                    toggleUI:Set(false)
                                end)
                            end
                            pcall(function()
                                toggleUI:Lock("MAX")
                            end)
                        else
                            pcall(function()
                                toggleUI:Unlock()
                            end)
                        end
                    end
                end
            end
        end
        
        task.wait(0.5)
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
