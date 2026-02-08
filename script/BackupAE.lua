if game.PlaceId ~= 90462358603255 then return end
repeat task.wait() until game:IsLoaded()

getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Anime Eternal"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local IsPremium = false

local ValidKeys = {"ANHUB-2025"}
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
if not IsPremium then return end
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()
local username = LocalPlayer.Name
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local FolderPath = "ANUI/AnimeEternal"
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local MapDBFile = "Map_Database.json"
-- Tambahkan ini di bagian variabel Config Anda
local Config = {
    SelectedEnemy = nil,
    SelectedDungeon = {}, -- Gunakan tabel kosong karena Multi = true
    SelectedRaid = nil,    -- Tetap nil karena single select
    AutoEnter = false,
    SelectedEnemy = nil,
    MapConfigurations = {},
    AutoFarm = false,
    AutoRankUp = false,
    AutoUnlockAll = false,
    AutoGachaPet = false,
    SelectedStar = nil,
    AutoProgression = {},
    AutoRoll = {},
    AutoLevelingItems = {},
    AutoLevelingProgItems = {}
}
local ConfigName = "ANConfig"
local CurrentMapEnemiesCache = {}
local IsLoadingConfig = false
local IsLoadingMapSelection = false
local IsInDungeonEvent = false
local IsTransitioning = false
local LocationChanging = false
local LocalUsername = LocalPlayer.Name -- Menggunakan username kamu
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

UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v=" .. math.random()))()

Window = UI:CreateWindow({
    Title = "AN Hub - Anime Eternal",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeEternal",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Eternal" }),
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
        Desc = "Anime Eternal"
    }),
    SidebarProfile = false
});

-- Pembuatan Selector Kategori
FM_CategorySelector = FarmTab:Category({
    Title = "Select Category",
    Default = "Farm",
    Options = {
        {Title = "Farm", Icon = "sword"},
        {Title = "Rank Up", Icon = "rbxassetid://89121312061972"}, -- Tambahkan ini
        {Title = "Roll", Icon = "rbxassetid://15602591315"}, -- Tambahkan ini
        {Title = "Gacha Pet", Icon = "rbxassetid://15625074556"}, -- Tambahkan iniProgression
        {Title = "Progression", Icon = "rbxassetid://17378852767"}, -- Tambahkan ini
        {Title = "Leveling Items", Icon = "rbxassetid://122732639067510"}, -- Tambahkan ini
        {Title = "Leveling Prog Items", Icon = "rbxassetid://103501763167478"}, -- Tambahkan ini
        {Title = "Upgrade Chance", Icon = "rbxassetid://129764606489391"}, -- Tambahkan ini
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
-- [[ 1. INITIALIZATION: DYNAMIC FETCH ]] --
local ReplicaController = require(game:GetService("ReplicatedStorage").Common.ReplicatedService.ReplicaController)
local SharedData = require(game:GetService("ReplicatedStorage").Common.Shared_Data)
-- Requirement Module untuk format angka (v_u_51)
local NumberFormatter = require(game:GetService("ReplicatedStorage").Common.NumberFormatter) 
local getupvalues = debug.getupvalues or getupvalues

-- Inisialisasi tabel Optimizer agar tidak error "index nil"
local Optimizer = { 
    Cache = {} 
}
local PlayerReplica = nil
local GeneralReplica = nil
local WorldMap = nil
local function SyncData()
    local replicas = nil
    for _, v in pairs(getupvalues(ReplicaController.GetReplicaById)) do
        if type(v) == "table" and v[2] then replicas = v break end
    end
    
    if replicas then
        for _, replica in pairs(replicas) do
            if replica.Class:find("_Data") then 
                PlayerReplica = replica 
            elseif replica.Class == "General" then 
                GeneralReplica = replica 
            end
        end
        WorldMap = GeneralReplica.Data.Enums.World_Maps
    end
end
SyncData()
-- Listener untuk Masuk/Keluar Dungeon
-- Listener untuk Masuk/Keluar Dungeon
ReplicatedStorage.Events.To_Client.OnClientEvent:Connect(function(data)
    if type(data) == "table" and data.Action == "Dungeon" and data.Type == "Outlines" then
        local wasInDungeon = IsInDungeonEvent
        
        -- Cek status dungeon
        if data.Players and table.find(data.Players, LocalUsername) then
            IsInDungeonEvent = true
        else
            IsInDungeonEvent = false
        end

        -- Jika terjadi transisi (Masuk atau Keluar)
        if wasInDungeon ~= IsInDungeonEvent then
            IsTransitioning = true
            
            -- RESET DROPDOWN: Hapus pilihan musuh sebelum jeda selesai
            if EnemyDropdown then
                EnemyDropdown:Set(nil) 
                Config.SelectedEnemy = nil
            end
            
            -- Jeda 1 detik agar tidak auto farm saat loading
            task.delay(1, function() 
                IsTransitioning = false 
            end)
        end
    end
end)

-- Listener untuk Perubahan Lokasi (Replica_ReplicaSetValue)
-- Menangani Log Arg 2: {"Players", "username", "Location"}
ReplicatedStorage.ReplicaRemoteEvents.Replica_ReplicaSetValue.OnClientEvent:Connect(function(id, path, value)
    if type(path) == "table" and path[1] == "Players" and path[2] == LocalUsername and path[3] == "Location" then
        LocationChanging = true
        LastMapName = "NONE" -- Paksa refresh list monster
        
        -- Jeda agar tidak memukul musuh di map sebelumnya
        task.delay(1, function() LocationChanging = false end)
    end
end)
ReplicatedStorage.Events.To_Server:FireServer({Value = state,Path = { "Settings", "AFK_MODE" },Action = "Settings"})
-- Fungsi helper untuk mengecek apakah pemain sedang berada di dalam match dungeon
local function IsInsideDungeon()
    local dungeonFolder = workspace:FindFirstChild("Dungeons")
    if dungeonFolder then
        for _, dungeon in pairs(dungeonFolder:GetChildren()) do
            -- Jika folder dungeon memiliki isi (seperti Starting_Room), pemain sedang di dalam
            if #dungeon:GetChildren() > 0 then return true end
        end
    end
    return false
end
-- Fungsi untuk mengambil saldo item apa pun (Energy, Token, Coins, dll) secara akurat
local function GetBalance(pData, itemName)
    if not PlayerReplica or not GeneralReplica or not pData.Inventory then return 0 end
    
    -- 1. Cari ID asli item dari database General (ID 2)
    local itemsDb = GeneralReplica.Data.Items
    local itemInfo = itemsDb[itemName] -- Mengambil info (misal: "Energy" -> ID 3)
    
    -- 2. Ambil ID unik (actualId)
    local actualId = itemInfo and tostring(itemInfo.Id) or tostring(itemName)
    
    -- 3. Ambil dari inventory player menggunakan ID tersebut
    local inv = pData.Inventory.Items
    return inv[actualId] and inv[actualId].Amount or 0
end

local SortedGachas = {}
local GachaToggles = {} -- Untuk menyimpan referensi UI Toggle agar bisa diupdate teksnya
local GachaUI_Created = false -- Flag agar UI hanya dibuat satu kali

local function UpdateSortedGachas()
    if not GeneralReplica or not GeneralReplica.Data.Gachas then return end
    local newList = {}
    for name, data in pairs(GeneralReplica.Data.Gachas) do
        table.insert(newList, data)
    end
    -- Sortir berdasarkan MapId (Map 1 paling atas)
    table.sort(newList, function(a, b) return (a.MapId or 0) < (b.MapId or 0) end)
    SortedGachas = newList
end
-- [[ RANK UP CATEGORY UI ]] --
RankProgressUI = FarmTab:Paragraph({ 
    Title = "Rank Progress", 
    Desc = "Waiting for data...", 
    Image = "rbxassetid://89121312061972", -- Icon Rank Up
    ImageSize = 40 
})
FM_Add("Rank Up", RankProgressUI)

FM_Add("Rank Up", FarmTab:Toggle({
    Title = "Auto Rank Up",
    Desc = "Otomatis naik rank saat Power (Energy) mencukupi.",
    Flag = "AutoRankUp_Cfg",
    Callback = function(val) 
        Config.AutoRankUp = val 
    end
}))

function Optimizer.Update_RankUp_Logic(pData)
    if not PlayerReplica or not GeneralReplica or not RankProgressUI then return end

    local success, err = pcall(function()
        local upgrades = pData.InGame.Upgrades.List
        local currentRank = upgrades.Rank_Up and upgrades.Rank_Up.Rank or 0
        local genUpgrades = GeneralReplica.Data.Upgrades
        local rankDef = genUpgrades.Rank_Up and genUpgrades.Rank_Up.List.Rank

        if rankDef and rankDef.Levels then
            local nextLevel = rankDef.Levels[currentRank + 1]
            
            if nextLevel then
                local price = nextLevel.Price[1]
                local reqAmount = math.abs(price.Amount) 
                local currencyName = price.Id -- "Energy"
                
                -- AMBIL SALDO MENGGUNAKAN HELPER
                local currentPower = GetBalance(pData, currencyName)

                -- AMBIL DATA BUFF DARI TABEL 'Stats' (Bukan Price)
                local currentBuffVal = 0
                if currentRank > 0 and rankDef.Levels[currentRank] then
                    local stats = rankDef.Levels[currentRank].Stats
                    currentBuffVal = stats and stats[1] and stats[1].Value or 0
                end

                local pct = math.clamp(currentPower / reqAmount, 0, 1)
                local bar = string.rep("█", math.floor(pct * 15)) .. string.rep("▒", 15 - math.floor(pct * 15))

                local powerStr = NumberFormatter:Format(currentPower)
                local reqStr = NumberFormatter:Format(reqAmount)
                local buffStr = NumberFormatter:Format(currentBuffVal) 
                
                local finalDesc = string.format(
                    "<b>Current Buff: +%s Energy Multiplier</b>\n" ..
                    "[%s] %d%%\n" ..
                    "Power: <font color='#00ff00'>%s</font> / %s",
                    buffStr, bar, math.floor(pct * 100), powerStr, reqStr
                )

                if Optimizer.Cache.LastRankDisplay ~= finalDesc then
                    RankProgressUI:SetTitle("Rank " .. currentRank)
                    RankProgressUI:SetDesc(finalDesc)
                    Optimizer.Cache.LastRankDisplay = finalDesc
                end

                if Config.AutoRankUp and currentPower >= reqAmount then
                    ReplicatedStorage.Events.To_Server:FireServer({
                        ["Upgrading_Name"] = "Rank",
                        ["Action"] = "_Upgrades",
                        ["Upgrade_Name"] = "Rank_Up"
                    })
                    task.wait(3) 
                end
            end
        end
    end)
    if not success then warn("[Rank Error]: " .. tostring(err)) end
end

-- Toggle Auto Prestige
local PrestigeToggle = FarmTab:Toggle({
    Title = "Auto Prestige",
    Desc = "Loading prestige data...",
    Flag = "AutoPrestige_Cfg",
    Image = "rbxassetid://75778712196470", -- Icon Rank Up
    ImageSize = 40 ,
    Callback = function(val)
        Config.AutoPrestige = val
    end
})
FM_Add("Rank Up", PrestigeToggle)
function Optimizer.Update_Prestige_Logic(pData)
    if not GeneralReplica or not pData.InGame or not pData.Stats then return end

    pcall(function()
        local prestigeData = GeneralReplica.Data.Player_Prestige
        -- Mengambil level saat ini dari Statistics
        local currentLevel = pData.InGame.Statistics and pData.InGame.Statistics.Resources_Level or 0
        
        -- [[ DETEKSI PRESTIGE SAAT INI DARI STATS.ALL ]] --
        local currentPrestige = 0
        for _, stat in ipairs(pData.Stats.All) do
            -- Mencari string "[Prestige] X" di kolom Category
            local pNum = stat.Category and stat.Category:match("%[Prestige%] (%d+)")
            if pNum then
                currentPrestige = math.max(currentPrestige, tonumber(pNum))
            end
        end
        
        local nextPrestigeID = currentPrestige + 1
        local nextPrestigeDef = prestigeData[nextPrestigeID]
        
        if nextPrestigeDef then
            local reqLevel = nextPrestigeDef.Required_Level
            local canPrestige = currentLevel >= reqLevel
            
            -- [[ UPDATE UI DESCRIPTION ]] --
            local statusColor = canPrestige and "#00ff00" or "#ff0000"
            local prestigeDesc = string.format("Current: %d -> Next: %d\nReq Level: <font color='%s'>%d / %d</font>", 
                currentPrestige, nextPrestigeID, statusColor, currentLevel, reqLevel)
            
            if Optimizer.Cache["Prestige_Desc"] ~= prestigeDesc then
                -- Pastikan PrestigeToggle adalah variabel global/cache dari pembuatan UI
                PrestigeToggle:SetDesc(prestigeDesc)
                Optimizer.Cache["Prestige_Desc"] = prestigeDesc
            end

            -- [[ EXECUTE PRESTIGE ]] --
            if Config.AutoPrestige and canPrestige then
                ReplicatedStorage.Events.To_Server:FireServer({Action = "Level_Up_Prestige"})
                -- Reset cache agar UI terupdate setelah level kembali ke 1
                Optimizer.Cache["Prestige_Desc"] = nil
                task.wait(1) 
            end
        else
            -- Jika sudah mencapai Prestige tertinggi (Id 10)
            if Optimizer.Cache["Prestige_Desc"] ~= "MAX PRESTIGE" then
                PrestigeToggle:SetDesc("<font color='#ffff00'>MAX PRESTIGE REACHED (ID 10)</font>")
                Optimizer.Cache["Prestige_Desc"] = "MAX PRESTIGE"
                if Config.AutoPrestige then PrestigeToggle:Set(false) end
            end
        end
    end)
end

local function CreateGachaUI()
    if GachaUI_Created then return end
    
    -- Pastikan data sudah tersedia sebelum memproses
    if not GeneralReplica or not GeneralReplica.Data.Gachas or not GeneralReplica.Data.Pity then 
        return 
    end
    
    UpdateSortedGachas()
    
    local rollCounter = 0
    local currentRollGroup = nil
    local generalPityTable = GeneralReplica.Data.Pity

    for _, gInfo in ipairs(SortedGachas) do
        local gName = gInfo.Name
        
        -- [[ FILTER: CEK APAKAH GACHA MEMPUNYAI DATA PITY ]]
        local hasPity = false
        
        -- 1. Cek apakah Pity_Names ada dan merupakan tabel yang tidak kosong
        if gInfo.Pity_Names and type(gInfo.Pity_Names) == "table" and #gInfo.Pity_Names > 0 then
            -- 2. Cek apakah minimal salah satu nama pity ada di database Pity (ID 2)
            for _, pName in ipairs(gInfo.Pity_Names) do
                if generalPityTable[pName] then
                    hasPity = true
                    break -- Sudah ketemu satu, cukup
                end
            end
        end

        -- Jika tidak punya pity, lewati mesin gacha ini
        if not hasPity then continue end

        -- [[ PEMBUATAN UI ]]
        if rollCounter % 2 == 0 then
            currentRollGroup = FarmTab:Group({})
            FM_Add("Roll", currentRollGroup)
        end
        
        local gIcon = gInfo.ImageId or "rbxassetid://128047949460588"

        local toggle = currentRollGroup:Toggle({
            Title = gName:gsub("_", " "), 
            Desc = "Loading balance...",
            Image = gIcon,
            ImageSize = 24,
            Flag = "Gacha_"..gName,
            Callback = function(val)
                Config.AutoRoll[gName] = val
            end
        })

        GachaToggles[gName] = toggle
        rollCounter = rollCounter + 1
    end
    
    GachaUI_Created = true
end
-- Helper: Konversi Color3 ke Hex untuk Font Color
local function ColorToHex(c3)
    return string.format("#%02X%02X%02X", math.floor(c3.R * 255), math.floor(c3.G * 255), math.floor(c3.B * 255))
end

-- Helper: Mengambil warna dari Chance_Rarity Asset game (1-9)
local function GetRarityColor(rarityID)
    local rarityStr = tostring(rarityID)
    local assets = ReplicatedStorage:FindFirstChild("Assets")
    local chanceRarity = assets and assets:FindFirstChild("Chance_Rarity")
    local rarityObj = chanceRarity and chanceRarity:FindFirstChild(rarityStr)
    
    if rarityObj then
        -- Untuk 7, 8, 9 yang memiliki UIGradient
        local gradient = rarityObj:FindFirstChildOfClass("UIGradient")
        if gradient then
            return ColorToHex(gradient.Color.Keypoints[1].Value)
        end
        -- Untuk 1-6 yang menggunakan ImageColor3
        if rarityObj:IsA("ImageLabel") or rarityObj:IsA("Decal") then
            return ColorToHex(rarityObj.ImageColor3)
        end
    end
    return "#aaaaaa" -- Default Abu-abu
end
function Optimizer.Update_Roll_Logic(pData)
    if not GachaUI_Created and GeneralReplica then
        CreateGachaUI()
        return
    end

    if not GeneralReplica or not pData.Inventory or not pData.InGame then return end

    pcall(function()
        local inventory = pData.Inventory.Items
        local playerPityTable = pData.InGame.Statistics or {} 
        local generalPityTable = GeneralReplica.Data.Pity
        local powerIndex = nil
        
        local PityRarityNames = {
            [1] = "Common", [2] = "Uncommon", [3] = "Rare",
            [4] = "Epic", [5] = "Legend", [6] = "Mythical",
            [7] = "Phantom", [8] = "Supreme", [9] = "Exotic"
        }

        for gName, toggle in pairs(GachaToggles) do
            local gInfo = GeneralReplica.Data.Gachas[gName]
            if not gInfo then continue end
            if gInfo.Name == "Stands" then
                powerIndex = pData.InGame.Index.Stands.Unlocked
            elseif gInfo.Name == "Titans" then
                powerIndex = pData.InGame.Index.Titans.Unlocked
            elseif gInfo.Name == "Swords" then
                powerIndex = pData.InGame.Index.Weapons.Unlocked
            else
                powerIndex = pData.InGame.Index.Powers.Unlocked
            end

            -- [[ LOGIKA MAP LOCK ]]
            local mapIdStr = tostring(gInfo.MapId or 1)
            local isMapUnlocked = pData.InGame.Unlocked.Maps[mapIdStr]

            if not isMapUnlocked and gInfo.MapId ~= 1 then
                if not Optimizer.Cache["MapLock_"..gName] then
                    toggle:Lock("Need Map: ".. WorldMap[gInfo.MapId].Name:gsub("_", " "))
                    Optimizer.Cache["MapLock_"..gName] = true
                end
            else
                if Optimizer.Cache["MapLock_"..gName] then
                    toggle:Unlock()
                    Optimizer.Cache["MapLock_"..gName] = nil
                end
            end

            -- [[ LOGIKA INDEX & AUTO LOCK PERBAIKAN ]]
            local discoveredCount = 0
            local totalRewards = gInfo.Rewards and #gInfo.Rewards or 0
            local hasBestRarity = false
            local highestRarityFound = 0
            local maxRarityInGacha = 0 -- Variabel baru untuk menampung rarity tertinggi mesin ini

            if gInfo.Rewards then
                -- 1. Scan dulu untuk mencari Rarity tertinggi yang tersedia di gacha ini
                for _, reward in ipairs(gInfo.Rewards) do
                    local itemData = GeneralReplica.Data.Items[reward.Id]
                    if itemData and itemData.Rarity then
                        if itemData.Rarity > maxRarityInGacha then
                            maxRarityInGacha = itemData.Rarity
                        end
                    end
                end

                -- 2. Cek item mana saja yang sudah di-unlock
                for _, reward in ipairs(gInfo.Rewards) do
                    local itemData = GeneralReplica.Data.Items[reward.Id]
                    if itemData and itemData.Id then
                        local isUnlocked = powerIndex[tostring(itemData.Id)]
                        if isUnlocked then
                            discoveredCount = discoveredCount + 1
                            
                            -- Cek jika item yang di-unlock adalah Rarity tertinggi di gacha tersebut
                            if itemData.Rarity and itemData.Rarity >= maxRarityInGacha then
                                hasBestRarity = true
                                if itemData.Rarity > highestRarityFound then
                                    highestRarityFound = itemData.Rarity
                                end
                            end
                        end
                    end
                end
            end

            -- SEKARANG LOCK JIKA: Index Lengkap ATAU Sudah dapat Rarity tertinggi (maxRarityInGacha)
            if (discoveredCount == totalRewards and totalRewards > 0) or hasBestRarity then
                if Optimizer.Cache["Lock_"..gName] ~= true then
                    toggle:Set(false) 
                    local lockReason = hasBestRarity and "Got Max: " .. (PityRarityNames[highestRarityFound] or "Best") or "Index Complete"
                    toggle:Lock(lockReason) 
                    Optimizer.Cache["Lock_"..gName] = true
                end
            end

            -- [[ LOGIKA HARGA & SALDO ]]
            local cost = math.abs(gInfo.Price.Amount) 
            local tokenName = gInfo.Price.Id
            local currentBalance = GetBalance(pData, tokenName)

            local balanceColor = (currentBalance >= cost) and "#00ff00" or "#ff0000"
            local cleanMatName = tokenName:gsub("_", " "):gsub("Token", "")
            local balanceLine = string.format("%s: <font color='%s'>%s / %s</font>", 
                cleanMatName, balanceColor, NumberFormatter:Format(cost), NumberFormatter:Format(currentBalance))

            -- [[ LOGIKA PITY DISPLAY ]]
            local pityLine = ""
            if gInfo.Pity_Names then
                local foundActive = false
                for i, pName in ipairs(gInfo.Pity_Names) do
                    local pDef = generalPityTable[pName]
                    local pProgress = playerPityTable["Gachas_"..gName]
                    
                    if pDef then
                        local targetRoll = math.abs(pDef.List[1].Amount)
                        local currentRoll = pProgress or 0
                        local rarityID = pDef.List[1].Rarity
                        local rarityLabel = PityRarityNames[rarityID] or ("Pity " .. i)
                        local rarityColor = GetRarityColor(rarityID)

                        if currentRoll < targetRoll then
                            pityLine = string.format("\n<font color='%s'>%s: %s / %s</font>", 
                                rarityColor, rarityLabel, NumberFormatter:Format(currentRoll), NumberFormatter:Format(targetRoll))
                            foundActive = true
                            break 
                        end
                    end
                end
                
                if not foundActive and #gInfo.Pity_Names > 0 then
                    local lastID = generalPityTable[gInfo.Pity_Names[#gInfo.Pity_Names]].List[1].Rarity
                    pityLine = string.format("\n<font color='%s'>%s: READY</font>", GetRarityColor(lastID), PityRarityNames[lastID] or "MAX")
                end
            end

            -- [[ UPDATE UI DESC ]]
            local newDesc = balanceLine .. pityLine
            if Optimizer.Cache["Roll_"..gName] ~= newDesc then
                toggle:SetDesc(newDesc)
                Optimizer.Cache["Roll_"..gName] = newDesc
            end

            -- [[ EXECUTE ROLL ]]
            if Config.AutoRoll[gName] and currentBalance >= cost and not Optimizer.Cache["Lock_"..gName] then
                ReplicatedStorage.Events.To_Server:FireServer({
                    ["Open_Amount"] = 100,
                    ["Action"] = "_Gacha_Activate",
                    ["Name"] = gName
                })
            end
        end
    end)
end
-- [[ DATA MAPPING & UI REFERENCES ]] --
local RarityMapping = {
    [1] = "Common", [2] = "Uncommon", [3] = "Rare",
    [4] = "Epic", [5] = "Legend", [6] = "Mythical",
    [7] = "Phantom", [8] = "Supreme", [9] = "Exotic"
}

local AutoDeleteToggles = {} -- Menyimpan referensi toggle rarity 1-9
local IsSyncingAutoDelete = false -- Flag agar sync tidak men-trigger FireServer

-- [[ FUNGSI PEMBANTU: SYNC DATA ]] --
local function SyncAutoDeleteWithGame(starName)
    if not starName or not PlayerReplica then return end
    local pData = PlayerReplica.Data
    local starInfo = GeneralReplica.Data.Stars[starName]
    if not pData or not starInfo or not starInfo.Rewards then return end

    local autoDeleteSettings = pData.Settings.AutoDelete.Stars or {}
    
    IsSyncingAutoDelete = true -- Kunci callback
    
    -- Cek setiap rarity dari 1 sampai 9
    for rLevel = 1, 9 do
        local toggle = AutoDeleteToggles[rLevel]
        if toggle then
            local stateFound = false
            -- Scan semua pet di mesin ini yang rarity-nya cocok
            for _, reward in ipairs(starInfo.Rewards) do
                local itemData = GeneralReplica.Data.Items[reward.Id]
                if itemData and itemData.Rarity == rLevel then
                    local idStr = tostring(itemData.Id)
                    local rarStr = tostring(rLevel)
                    if autoDeleteSettings[idStr] and autoDeleteSettings[idStr][rarStr] == true then
                        stateFound = true
                        break
                    end
                end
            end
            toggle:Set(stateFound) -- Update posisi toggle di UI
        end
    end
    
    IsSyncingAutoDelete = false -- Lepas kunci
end

-- [[ UI CATEGORY: GACHA PET ]] --
local MainGachaGroup = FarmTab:Group({ Title = "Gacha Pet Settings" })
FM_Add("Gacha Pet", MainGachaGroup)

local StarToggle = MainGachaGroup:Toggle({
    Title = "Auto Roll Star",
    Desc = "Select a star to see details.",
    Flag = "StarToggle_Cfg",
    Callback = function(val)
        Config.AutoGachaPet = val
    end
})

-- Filter Star Options
local starOptions = {}
for starName, _ in pairs(GeneralReplica.Data.Stars) do
    if not starName:find("Exclusive") then
        -- Ambil string-nya saja tanpa menghiraukan jumlah penggantian
        local idString = starName:gsub("%D", "") 
        local idNumber = tonumber(idString)

        -- Gunakan nilainya untuk mengakses tabel
        if idNumber then
            local result = WorldMap[idNumber].Name:gsub("_", " ")
            table.insert(starOptions, {Title = result,Value = starName})
        end
    end
end
table.sort(starOptions, function(a, b) 
    local numA = tonumber(a.Value:match("%d+")) or 0
    local numB = tonumber(b.Value:match("%d+")) or 0
    
    return numA < numB
end)

local StarDropdown = MainGachaGroup:Dropdown({
    Title = "Select Star Machine",
    Values = starOptions,
    Flag = "StarDropdown_cfg",
    Callback = function(val)
        Config.SelectedStar = val.Value
        -- Reset cache agar UI terupdate seketika untuk mesin baru
        Optimizer.Cache["GachaPet_Current"] = nil 
        
        -- Sinkronisasi pengaturan auto delete untuk mesin yang baru dipilih
        SyncAutoDeleteWithGame(val.Value)
    end
})

-- [[ PEMBUATAN TOGGLE AUTO DELETE (2 PER GROUP) ]] --
for i = 1, 9, 2 do
    local group = FarmTab:Group({ Title = "Auto Delete List" })
    FM_Add("Gacha Pet", group)
    
    for j = 0, 1 do
        local rLevel = i + j
        if rLevel > 9 then break end
        
        local rName = RarityMapping[rLevel]
        AutoDeleteToggles[rLevel] = group:Toggle({
            Title = "Delete " .. rName,
            Desc = "Toggle filter for " .. rName .. " pets.",
            Callback = function(state)
                -- Jangan jalankan remote jika sedang proses sinkronisasi dropdown
                if IsSyncingAutoDelete or not Config.SelectedStar then return end
                
                local starInfo = GeneralReplica.Data.Stars[Config.SelectedStar]
                if not starInfo then return end

                for _, reward in ipairs(starInfo.Rewards) do
                    local itemData = GeneralReplica.Data.Items[reward.Id]
                    if itemData and itemData.Rarity == rLevel then
                        ReplicatedStorage.Events.To_Server:FireServer({
                                Value = state,
                                Path = { "Settings", "AutoDelete", "Stars", tostring(itemData.Id), tostring(rLevel) },
                                Action = "Settings"
                        })
                    end
                end
            end
        })
    end
end

function Optimizer.Update_Gacha_Pet_Logic(pData)
    -- Jika toggle mati atau mesin belum dipilih, jangan lanjut
    if not Config.AutoGachaPet or not Config.SelectedStar then return end
    
    local starName = Config.SelectedStar
    local starInfo = GeneralReplica.Data.Stars[starName]
    
    -- Validasi apakah data mesin ada di database game
    if not starInfo then return end

    pcall(function()
        local playerStats = pData.InGame.Statistics or {}
        local generalPityTable = GeneralReplica.Data.Pity
        local petIndex = pData.InGame.Index.Pets.Unlocked
        
        -- 1. Hitung progres Index Pets pada mesin yang dipilih
        local discoveredCount = 0
        local totalInMachine = #starInfo.Rewards
        for _, reward in ipairs(starInfo.Rewards) do
            if petIndex[tostring(reward.Id)] then 
                discoveredCount = discoveredCount + 1 
            end
        end

        -- 2. Ambil data harga dan saldo
        local cost = math.abs(starInfo.Price.Amount)
        local currency = starInfo.Price.Id
        local currentBalance = GetBalance(pData, currency)
        local balColor = (currentBalance >= cost) and "#00ff00" or "#ff0000"
        
        -- 3. Susun tampilan Deskripsi UI
        local balLine = string.format("%s: <font color='%s'>%s / %s</font>", 
            currency, balColor, NumberFormatter:Format(cost), NumberFormatter:Format(currentBalance))
        local indexLine = string.format("\nIndex: <font color='#ffffff'>%d/%d</font>", discoveredCount, totalInMachine)

        local pityLine = ""
        if starInfo.Pity_Names then
            -- Ambil progres roll khusus untuk mesin star ini
            local currentTotalRolls = playerStats["Stars_"..starName] or 0
            local foundActive = false
            
            for i, pName in ipairs(starInfo.Pity_Names) do
                local pDef = generalPityTable[pName]
                if pDef then
                    local targetRoll = math.abs(pDef.List[1].Amount)
                    local rarityID = pDef.List[1].Rarity
                    
                    -- Tampilkan Pity yang paling mendekati (belum tercapai)
                    if currentTotalRolls < targetRoll then
                        pityLine = string.format("\n<font color='%s'>%s: %s / %s</font>", 
                            GetRarityColor(rarityID), RarityMapping[rarityID] or "Pity", 
                            NumberFormatter:Format(currentTotalRolls), NumberFormatter:Format(targetRoll))
                        foundActive = true 
                        break 
                    end
                end
            end
            
            -- Jika semua pity sudah tercapai (Ready)
            if not foundActive and #starInfo.Pity_Names > 0 then
                local lastPityName = starInfo.Pity_Names[#starInfo.Pity_Names]
                local lastID = generalPityTable[lastPityName].List[1].Rarity
                pityLine = string.format("\n<font color='%s'>%s: READY</font>", 
                    GetRarityColor(lastID), RarityMapping[lastID] or "MAX")
            end
        end

        -- 4. Update UI hanya jika ada perubahan data
        local finalDesc = balLine .. indexLine .. pityLine
        if Optimizer.Cache["GachaPet_Current"] ~= finalDesc then
            StarToggle:SetDesc(finalDesc)
            Optimizer.Cache["GachaPet_Current"] = finalDesc
        end

        -- 5. Eksekusi Gacha (FireServer)
        -- Pastikan Config masih aktif sebelum menembak remote
        if Config.AutoGachaPet and currentBalance >= cost then
            ReplicatedStorage.Events.To_Server:FireServer({
                ["Open_Amount"] = 1000, -- Gunakan jumlah roll maksimal yang diizinkan game
                ["Action"] = "_Stars",
                ["Name"] = starName
            })
        end
    end)
end

local ProgressionToggles = {}

local function CreateProgressionUI()
    if not GeneralReplica or not GeneralReplica.Data.Progression then return end
    
    local allUpgrades = {}
    for benchName, benchData in pairs(GeneralReplica.Data.Progression) do
        for upgradeName, upgradeData in pairs(benchData.List) do
            table.insert(allUpgrades, {
                Bench = benchName,
                Upgrade = upgradeName,
                Info = upgradeData,
                MapId = benchData.MapId or 0, -- Ambil MapId untuk sorting
                Display = benchName:gsub("_", " ")
            })
        end
    end

    -- [[ SORTING BERDASARKAN MAPID ]] --
    table.sort(allUpgrades, function(a, b)
        if a.MapId ~= b.MapId then
            return a.MapId < b.MapId -- Urutkan dari Map 1, 2, dst.
        end
        return (a.Info.Index or 0) < (b.Info.Index or 0) -- Jika Map sama, urutkan berdasarkan Index
    end)

    local currentGroup = nil
    for i, data in ipairs(allUpgrades) do
        -- Grouping: 2 Item per Group
        if (i - 1) % 2 == 0 then
            currentGroup = FarmTab:Group({ Title = "Progression: Map " .. data.MapId })
            FM_Add("Progression", currentGroup)
        end

        local cfgKey = data.Bench .. "|" .. data.Upgrade
        ProgressionToggles[cfgKey] = currentGroup:Toggle({
            Title = data.Display,
            Desc = "Waiting for sync...",
            Image = data.Info.ImageId or "rbxassetid://127280201815856",
            ImageSize = 24,
            Flag = "Prog_"..cfgKey,
            Callback = function(val)
                Config.AutoProgression[cfgKey] = val
            end
        })
    end
end

CreateProgressionUI()
function Optimizer.Update_Progression_Logic(pData)
    if not GeneralReplica or not pData.InGame or not pData.InGame.Progression then return end

    pcall(function()
        local playerProg = pData.InGame.Progression
        local genProg = GeneralReplica.Data.Progression

        for cfgKey, toggle in pairs(ProgressionToggles) do
            local benchName, upgradeName = cfgKey:match("^(.-)|(.-)$")
            local benchData = genProg[benchName]
            local mapIdStr = tostring(benchData.MapId or 0)
            local isMapUnlocked = pData.InGame.Unlocked.Maps[mapIdStr]

            if not isMapUnlocked and (benchData.MapId ~= 1) then
                if not Optimizer.Cache["MapLockProg_"..cfgKey] then
                    toggle:Lock("Need Unlock Map: ".. WorldMap[benchData.MapId].Name:gsub("_", " "))
                    Optimizer.Cache["MapLockProg_"..cfgKey] = true
                end
            else
                if Optimizer.Cache["MapLockProg_"..cfgKey] then
                    toggle:Unlock()
                    Optimizer.Cache["MapLockProg_"..cfgKey] = nil
                end
            end
            local upgInfo = benchData and benchData.List[upgradeName]
            if not upgInfo then continue end

            -- 1. AMBIL LEVEL & MAX LEVEL
            local currentLevel = (playerProg[benchName] and playerProg[benchName][upgradeName]) or 0
            local maxLevel = upgInfo.Max_Levels or 100

            -- 2. HITUNG HARGA DINAMIS (Include Price_Increase)
            local priceTable = upgInfo.Price and upgInfo.Price[1]
            if not priceTable then continue end
            
            local baseAmount = math.abs(priceTable.Amount)
            local priceIncrease = upgInfo.Price_Increase or 0
            local currentCost = baseAmount

            -- Logika Perhitungan Harga Game
            if upgInfo.Price_Compound then
                -- Eksponensial: Base * (1 + Increase)^Level
                currentCost = baseAmount * ((1 + priceIncrease) ^ currentLevel)
            else
                -- Linear: Base * (1 + (Increase * Level))
                currentCost = baseAmount * (1 + (priceIncrease * currentLevel))
            end

            local currency = priceTable.Id
            local currentBalance = GetBalance(pData, currency)

            -- 3. FORMAT BUFF (x = Multiply, % = Percent)
            local buffsReceived = {}
            if upgInfo.Stats then
                for _, stat in ipairs(upgInfo.Stats) do
                    local totalStatValue = currentLevel * (stat.Value or 0)
                    local formattedStat = ""
                    
                    if stat.Multiply then
                        formattedStat = string.format("x%.2f", totalStatValue) -- Contoh: x1.50
                    elseif stat.Percent then
                        formattedStat = string.format("+%.1f%%", totalStatValue * 100) -- Contoh: +15.0%
                    else
                        formattedStat = "+" .. NumberFormatter:Format(totalStatValue)
                    end
                    
                    local statName = stat.Main_Stat or stat.Name or "Stat"
                    table.insert(buffsReceived, string.format("<font color='#00aaff'>%s %s</font>", formattedStat, statName:gsub("_", " ")))
                end
            end
            local buffLine = #buffsReceived > 0 and ("\nBuff: " .. table.concat(buffsReceived, " | ")) or ""

            -- 4. UPDATE UI DESC
            local balColor = (currentBalance >= currentCost) and "#00ff00" or "#ff0000"
            local balanceLine = string.format("%s: <font color='%s'>%s/%s</font>", 
                currency:gsub("_", " "), balColor, NumberFormatter:Format(currentCost), NumberFormatter:Format(currentBalance))
            
            local levelLine = string.format("\nLevel: <font color='#ffffff'>%d / %d</font>", currentLevel, maxLevel)
            local finalDesc = balanceLine .. levelLine .. buffLine
            
            if currentLevel >= maxLevel then
                finalDesc = "<font color='#ffff00'>STATUS: MAXED</font>" .. levelLine .. buffLine
                if Config.AutoProgression[cfgKey] then toggle:Set(false) end
            end

            if Optimizer.Cache["ProgUI_"..cfgKey] ~= (finalDesc .. tostring(currentLevel)) then
                toggle:SetDesc(finalDesc)
                Optimizer.Cache["ProgUI_"..cfgKey] = (finalDesc .. tostring(currentLevel))
            end

            -- 5. EKSEKUSI
            if Config.AutoProgression[cfgKey] and currentLevel < maxLevel and currentBalance >= currentCost then
                ReplicatedStorage.Events.To_Server:FireServer({
                    Bench_Name = benchName,
                    Action = "_Progression",
                    Upgrade_Name = upgradeName
                })
            end
        end
    end)
end

local LevelingToggles = {}

local function CreateLevelingItemsUI()
    local LevelingData = GeneralReplica and GeneralReplica.Data and GeneralReplica.Data.Leveling_Items
    if not LevelingData then return end
    
    -- Kita masukkan ke tabel untuk disorting berdasarkan MapId agar rapi
    local bList = {}
    for internalName, data in pairs(LevelingData) do
        table.insert(bList, {
            Key = internalName, -- Ini adalah 'Name' unik (contoh: '3rd_Gen_Leveling')
            Data = data,
            MapId = data.MapId or 0
        })
    end

    -- Sort berdasarkan MapId (Logika yang sama dengan Progression)
    table.sort(bList, function(a, b) return a.MapId < b.MapId end)

    local currentGroup = nil
    for i, bench in ipairs(bList) do
        -- Membuat grup UI baru setiap 2 item (mengikuti style AnimeEternal)
        if (i - 1) % 2 == 0 then
            currentGroup = FarmTab:Group({ Title = "Leveling Upgrades: Map " .. bench.MapId })
            FM_Add("Leveling Items", currentGroup)
        end

        -- Judul Toggle menggunakan 'Key' agar Anda bisa membedakan 1st Gen, 2nd Gen, dll.
        LevelingToggles[bench.Key] = currentGroup:Toggle({
            Title = bench.Key:gsub("_", " "), 
            Desc = "Status: Checking...",
            Image = bench.Data.ImageId or "rbxassetid://122732639067510",
            ImageSize = 24,
            Flag = "LvlItem_"..bench.Key,
            Callback = function(val)
                Config.AutoLevelingItems[bench.Key] = val
            end
        })
    end
end
CreateLevelingItemsUI()
function Optimizer.Update_Leveling_Items_Logic(pData)
    if not GeneralReplica or not pData.Inventory or not pData.InGame then return end

    local levelingDb = GeneralReplica.Data.Leveling_Items
    local inventoryItems = pData.Inventory.Items
    local equippedSettings = pData.Inventory.Settings.Equipped

    for internalKey, toggle in pairs(LevelingToggles) do
        local benchData = levelingDb[internalKey]
        if not benchData then continue end

        -- [[ 1. MAP LOCK CHECK ]] --
        local mapIdStr = tostring(benchData.MapId or 0)
        local isMapUnlocked = pData.InGame.Unlocked.Maps[mapIdStr]

        if not isMapUnlocked and (benchData.MapId ~= 1) then
            if not Optimizer.Cache["MapLockLvlItem_"..internalKey] then
                toggle:Lock("Need Unlock Map: ".. (WorldMap[benchData.MapId] and WorldMap[benchData.MapId].Name:gsub("_", " ") or "Unknown"))
                Optimizer.Cache["MapLockLvlItem_"..internalKey] = true
            end
            continue
        else
            if Optimizer.Cache["MapLockLvlItem_"..internalKey] then
                toggle:Unlock()
                Optimizer.Cache["MapLockLvlItem_"..internalKey] = nil
            end
        end

        -- [[ 2. IDENTIFIKASI EQUIPPED UNIQUE ID ]] --
        local equippedUniqueId = nil

        -- --- TAHAP 1: PENCARIAN VIA METADATA (.U) ---
        for uId, item in pairs(inventoryItems) do
            if item.Equipped == true and item.U then
                local categoryFolder = item.U[benchData.Bench_Category]
                if categoryFolder and categoryFolder.List then
                    local slotData = categoryFolder.List[benchData.Slot]
                    if slotData and slotData.Name == benchData.Name then
                        equippedUniqueId = uId
                        break 
                    end
                end
            end
        end

        -- --- TAHAP 2: FALLBACK VIA EQUIPPED SETTINGS (Jika Tahap 1 Gagal) ---
        if not equippedUniqueId then
            if benchData.Category == "Avatars" then
                equippedUniqueId = equippedSettings.Avatars and equippedSettings.Avatars.Equipped
            elseif equippedSettings.Powers and equippedSettings.Powers.List then
                local rawType = benchData.Item_Type and benchData.Item_Type[1] or ""
                local formattedType = rawType:gsub(" ", "_")
                equippedUniqueId = equippedSettings.Powers.List[formattedType]
            end
        end

        -- [[ 3. VALIDASI AKHIR DATA ITEM ]] --
        local itemData = equippedUniqueId and inventoryItems[equippedUniqueId]

        if not itemData then
            if Optimizer.Cache["LvlUI_"..internalKey] ~= "NotEquipped" then
                toggle:SetDesc("<font color='#ffaa00'>Item Not Equipped</font>")
                Optimizer.Cache["LvlUI_"..internalKey] = "NotEquipped"
            end
            continue
        end

        -- [[ 4. LOGIKA LEVELING ]] --
        pcall(function()
            local currentLevel = 0
            local folderU = itemData.U
            
            -- Ambil level dari metadata (jalur dinamis sesuai Bench_Category)
            if folderU and folderU[benchData.Bench_Category] then
                local slotData = folderU[benchData.Bench_Category].List[benchData.Slot]
                if slotData then
                    currentLevel = slotData.Level or 0
                end
            end

            local currentBuffText = "\nBuff: "
            local currentConfig = benchData.List[currentLevel]
            if currentConfig and currentConfig.Stats then
                for _, stat in pairs(currentConfig.Stats) do
                    totalStatValue = string.format("x%.2f", stat.Value)
                    local val = stat.Multiply and totalStatValue
                    currentBuffText = currentBuffText .. string.format("<font color='#55aaff'>%s %s</font>\n", tostring(val), stat.Main_Stat)
                end
            end

            local nextLevel = currentLevel + 1
            local nextLevelConfig = benchData.List[nextLevel] 

            if nextLevelConfig then
                local price = nextLevelConfig.Price
                local reqAmount = math.abs(price.Amount)
                local currencyId = price.Id
                local myBalance = GetBalance(pData, currencyId)

                local canAfford = myBalance >= reqAmount
                local balColor = canAfford and "#00ff00" or "#ff0000"
                
                local desc = string.format(
                    "Level: <font color='#ffffff'>%d/%d</font>%s\n<font color='%s'>%s: %s/%s </font>", 
                    currentLevel, #benchData.List, currentBuffText, balColor, 
                    currencyId:gsub("_", " "), NumberFormatter:Format(myBalance), NumberFormatter:Format(reqAmount)
                )
                
                if Optimizer.Cache["LvlUI_"..internalKey] ~= desc then
                    toggle:SetDesc(desc)
                    Optimizer.Cache["LvlUI_"..internalKey] = desc
                end

                -- Eksekusi Remote
                if Config.AutoLevelingItems[internalKey] and canAfford then
                    ReplicatedStorage.Events.To_Server:FireServer({
                        ["UniqueId"] = equippedUniqueId,
                        ["Action"] = "Leveling_Items",
                        ["Bench_Name"] = internalKey
                    })
                end
            else
                -- Max Level
                local descMax = string.format("Level: <font color='#ffff00'>%d/%d (MAX)</font>%s", currentLevel,#benchData.List, currentBuffText)
                if Optimizer.Cache["LvlUI_"..internalKey] ~= descMax then
                    toggle:SetDesc(descMax)
                    Optimizer.Cache["LvlUI_"..internalKey] = descMax
                end
            end
        end)
    end
end
local LevelingProgToggles = {}

local function CreateLevelingProgItemsUI()
    local LevelingProgData = GeneralReplica and GeneralReplica.Data and GeneralReplica.Data.Prog_Lv_Items
    if not LevelingProgData then return end
    
    local bList = {}
    for internalName, data in pairs(LevelingProgData) do
        -- [[ FILTER EVENT ITEMS ]] --
        local lowerName = internalName:lower()
        -- if lowerName:find("halloween") or lowerName:find("ghost") or lowerName:find("christmas") then
        --     continue -- Lewati item jika mengandung kata filter
        -- end

        table.insert(bList, {
            Key = internalName,
            Data = data,
            MapId = data.MapId or 0
        })
    end

    -- Urutkan berdasarkan MapId agar rapi
    table.sort(bList, function(a, b) return a.MapId < b.MapId end)

    local currentGroup = nil
    for i, bench in ipairs(bList) do
        -- Membuat grup UI setiap 2 item
        if (i - 1) % 2 == 0 then
            currentGroup = FarmTab:Group({ Title = "LevelingProg Upgrades: Map " .. bench.MapId })
            FM_Add("Leveling Prog Items", currentGroup)
        end

        LevelingProgToggles[bench.Key] = currentGroup:Toggle({
            Title = bench.Key:gsub("_", " "), 
            Desc = "Status: Checking...",
            Image = bench.Data.ImageId or "rbxassetid://122732639067510",
            ImageSize = 24,
            Flag = "LvlItem_"..bench.Key,
            Callback = function(val)
                Config.AutoLevelingProgItems[bench.Key] = val
            end
        })
    end
end
CreateLevelingProgItemsUI()
function Optimizer.Update_Prog_Lv_Items_Logic(pData)
    if not GeneralReplica or not pData.Inventory or not pData.InGame then return end

    local levelingProgDb = GeneralReplica.Data.Prog_Lv_Items
    local inventoryItems = pData.Inventory.Items
    local equippedSettings = pData.Inventory.Settings.Equipped

    for internalKey, toggle in pairs(LevelingProgToggles) do
        local benchData = levelingProgDb[internalKey]
        if not benchData then continue end

        -- [[ 1. MAP LOCK CHECK ]] --
        local mapIdStr = tostring(benchData.MapId or 0)
        local isMapUnlocked = pData.InGame.Unlocked.Maps[mapIdStr]

        if not isMapUnlocked and (benchData.MapId ~= 1) then
            if not Optimizer.Cache["MapLockProgItem_"..internalKey] then
                toggle:Lock("Unlock Map: ".. (WorldMap[benchData.MapId] and WorldMap[benchData.MapId].Name:gsub("_", " ") or "Unknown"))
                Optimizer.Cache["MapLockProgItem_"..internalKey] = true
            end
            continue
        else
            if Optimizer.Cache["MapLockProgItem_"..internalKey] then
                toggle:Unlock()
                Optimizer.Cache["MapLockProgItem_"..internalKey] = nil
            end
        end

        -- [[ 2. IDENTIFIKASI EQUIPPED UNIQUE ID (DUAL-CHECK) ]] --
        local equippedUniqueId = nil

        -- --- TAHAP 1: PENCARIAN VIA METADATA (.U) ---
        for uId, item in pairs(inventoryItems) do
            if item.Equipped == true and item.U then
                local categoryFolder = item.U[benchData.Bench_Category]
                if categoryFolder and categoryFolder.List then
                    local slotData = categoryFolder.List[benchData.Slot]
                    -- Contoh: Cek apakah item.U.Prog_Lv_Items.List.Level.Name == "Zanpakuto_Leveling"
                    if slotData and slotData.Name == benchData.Name then
                        equippedUniqueId = uId
                        break 
                    end
                end
            end
        end

        -- --- TAHAP 2: FALLBACK VIA EQUIPPED SETTINGS (Jika Tahap 1 Gagal) ---
        if not equippedUniqueId then
            -- Kebanyakan Prog_Lv masuk ke kategori Powers (Zanpakuto, Geass, PirateCrew)
            if equippedSettings.Powers and equippedSettings.Powers.List then
                local rawType = benchData.Item_Type and benchData.Item_Type[1] or ""
                local formattedType = rawType:gsub(" ", "_")
                equippedUniqueId = equippedSettings.Powers.List[formattedType]
            end
        end

        if not equippedUniqueId then
            local rawType2 = internalKey:gsub("_Leveling", "")
            equippedUniqueId = pData.Inventory.Settings.Equipped.Powers.List[rawType2]
        end

        -- [[ 3. VALIDASI AKHIR DATA ITEM ]] --
        local itemData = equippedUniqueId and inventoryItems[equippedUniqueId]

        if not itemData then
            if Optimizer.Cache["LvlProgUI_"..internalKey] ~= "None" then
                toggle:SetDesc("<font color='#ffaa00'>Item Not Equipped</font>")
                Optimizer.Cache["LvlProgUI_"..internalKey] = "None"
            end
        end

        -- [[ 4. LOGIKA LEVELING KHUSUS PROG_LV ]] --
        pcall(function()
            local levelDef = benchData.List.Level
            if not levelDef then return end

            -- Ambil level saat ini dari metadata item yang ditemukan
            local currentLevel = 0
            if itemData.U and itemData.U[benchData.Bench_Category] then
                local slotData = itemData.U[benchData.Bench_Category].List[benchData.Slot]
                if slotData then
                    currentLevel = slotData.Level or 0
                end
            end

            local currentBuffText = "\nBuff: "
            local currentConfig = levelDef
            if currentConfig and currentConfig.Stats then
                for _, stat in pairs(currentConfig.Stats) do
                    totalStatValue = string.format("x%.2f", currentLevel * (stat.Value or 0))
                    local val = stat.Multiply and totalStatValue
                    currentBuffText = currentBuffText .. string.format("<font color='#55aaff'>%s %s</font>\n", tostring(val), stat.Main_Stat:gsub("_"," "))
                end
            end

            local maxLevel = levelDef.Max_Levels or 100

            if currentLevel < maxLevel then
                -- Kalkulasi Harga Sesuai Aturan Database Prog_Lv
                local priceInfo = levelDef.Price[1]
                local baseAmount = math.abs(priceInfo.Amount)
                local inc = levelDef.Price_Increase or 0
                
                -- Rumus: base * ((1 + inc) ^ level) jika compound, atau base * (1 + (inc * level))
                local currentCost = levelDef.Price_Compound 
                    and (baseAmount * ((1 + inc) ^ currentLevel)) 
                    or (baseAmount * (1 + (inc * currentLevel)))

                local myBalance = GetBalance(pData, priceInfo.Id)
                local canAfford = myBalance >= currentCost
                local balColor = canAfford and "#00ff00" or "#ff0000"
                
                local desc = string.format(
                    "Level: <font color='#ffffff'>%d/%d</font>%s\n<font color='%s'>%s: %s/%s</font>", 
                    currentLevel, maxLevel,currentBuffText, balColor, 
                    priceInfo.Id:gsub("_", " "), NumberFormatter:Format(myBalance), NumberFormatter:Format(currentCost)
                )
                
                if Optimizer.Cache["LvlProgUI_"..internalKey] ~= desc then
                    toggle:SetDesc(desc)
                    Optimizer.Cache["LvlProgUI_"..internalKey] = desc
                end

                -- Eksekusi Remote
                if Config.AutoLevelingProgItems[internalKey] and canAfford then
                    ReplicatedStorage.Events.To_Server:FireServer({
                        ["UniqueId"] = equippedUniqueId,
                        ["Action"] = "Prog_Lv_Items",
                        ["Bench_Name"] = internalKey,
                        ["Upgrade_Name"] = benchData.Slot -- Biasanya "Level"
                    })
                end
            else
                -- Max Level
                local descMax = string.format("Level: <font color='#ffff00'>%d/%d (MAX)</font>%s", currentLevel,maxLevel,currentBuffText)
                if Optimizer.Cache["LvlProgUI_"..internalKey] ~= descMax then
                    toggle:SetDesc(descMax)
                    Optimizer.Cache["LvlProgUI_"..internalKey] = descMax
                end
            end
        end)
    end
end
-- [[ 1. VARIABLES & UI REFERENCES ]] --
local EnemyDropdown = nil 
local LastMapName = "NONE" -- Menggunakan "NONE" agar sinkronisasi awal selalu terpicu

-- [[ 2. FARM CATEGORY UI ]] --
local FarmGroup = FarmTab:Group({ Title = "Dynamic Map Farming" })
FM_Add("Farm", FarmGroup)

-- Toggle Auto Farm
FarmGroup:Toggle({
    Title = "Auto Farm Enemy",
    Flag = "AutoFarm_Cfg",
    Callback = function(val)
        Config.AutoFarm = val
    end
})


-- Dropdown Select Enemy
EnemyDropdown = FarmGroup:Dropdown({
    Title = "Select Enemy",
    Values = {},
    AllowNone = true, -- Ini memungkinkan pilihan kosong
    Flag = "EnemyDropdown_Cfg",
    Callback = function(val)
        -- Jika val adalah tabel dan memiliki Value, maka set musuh
        if type(val) == "table" and val.Value then
            Config.SelectedEnemy = val.Value
        else
            -- Jika tidak memilih apa pun (Clear), set jadi nil
            Config.SelectedEnemy = nil
        end
    end
})
-- Toggle untuk Auto Kill Aura (Tanpa Dropdown)
FM_Add("Farm", FarmTab:Toggle({
    Title = "Active Kill Aura",
    Flag = "AutoKillAura_Cfg",
    Callback = function(val)
        Config.AutoKillAura = val
    end
}))
-- Pastikan MouseModule sudah di-require di bagian atas script Anda
local MouseModule = require(ReplicatedStorage.Common.Utility.Mouse_Module)

function Optimizer.Update_KillAura_Logic(data)
    -- Berjalan hanya jika Toggle Kill Aura aktif
    if Config.AutoKillAura then
        -- Get_Monsters_InRange tanpa parameter akan mengambil semua monster yang terdeteksi
        local nearbyMonsters = MouseModule.Get_Monsters_InRange(100)
        local args = nil
        
        if nearbyMonsters and #nearbyMonsters > 1 then
            -- Ambil data monster yang paling dekat (index 1)
            local targetData = nearbyMonsters[2]
            local monsterModel = targetData.Character
            local args = {
                {
                    Id = monsterModel.Name,
                    Action = "_Mouse_Click"
                }
            }
            ReplicatedStorage.Events.To_Server:FireServer(unpack(args))
        end
    end
end
-- [[ 3. LOGIKA FILTERING DINAMIS (VERIFIED FOR ANUI) ]] --
function Optimizer.RefreshMonsterList(pData)
    -- 1. Validasi keberadaan data
    if not pData or not pData.InGame or not pData.InGame.Info then return end
    if not GeneralReplica or not GeneralReplica.Data or not WorldMap then return end
    local currentMapName = pData.InGame.Info.Map 
    
    -- 2. Cek apakah perlu refresh
    if LastMapName == currentMapName then return end

    -- 3. Cari MapId
    local currentMapId = nil
    for id, data in pairs(WorldMap) do
        if data.Name == currentMapName then
            currentMapId = id
            break
        end
    end

    -- 4. Filter Monster
    local filteredOptions = {}
    local monsters = GeneralReplica.Data.Monsters
    
    if monsters then
        local tempMonsters = {}
        for _, mData in pairs(monsters) do
            if mData.MapId == currentMapId and mData.Id ~= _ then
                table.insert(tempMonsters, mData)
            end
        end

        -- Urutkan berdasarkan Rarity
        table.sort(tempMonsters, function(a, b) 
            return (a.Rarity or 0) < (b.Rarity or 0) 
        end)

        -- Susun tabel untuk Dropdown ANUI
        for _, mData in ipairs(tempMonsters) do
            table.insert(filteredOptions, {
                Title = tostring(mData.Name) .. " (Rank " .. tostring(mData.Rank or "?") .. ")",
                Value = { Name = mData.Name, Id = mData.Id },
                Icon = mData.ImageId
            })
        end
    end

    -- 5. Update UI menggunakan SetValues
    if #filteredOptions > 0 then
        LastMapName = currentMapName 
        -- Memanggil SetValues pada instance element Dropdown
        EnemyDropdown:Refresh(filteredOptions)
    else
        EnemyDropdown:SetValues({ {Title = "Searching Monsters...", Value = nil} })
    end
end
function Optimizer.Update_Farm_Logic(pData)
    -- 1. Refresh list musuh di Dropdown
    Optimizer.RefreshMonsterList(pData)

    -- 2. Cek apakah Auto Farm aktif
    if not Config.AutoFarm then return end

    -- Deteksi status
    local inDungeon = IsInsideDungeon(pData)
    local isEnemySelected = Config.SelectedEnemy and type(Config.SelectedEnemy) == "table" and Config.SelectedEnemy.Name ~= nil and Config.SelectedEnemy.Name ~= ""

    -- PROTEKSI: Jika tidak di Dungeon DAN tidak ada musuh dipilih, BERHENTI
    if not inDungeon and not isEnemySelected then 
        return 
    end

    local character = game.Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local targetMonster = nil
    
    if inDungeon and not isEnemySelected then
        -- === LOGIKA DUNGEON ===
        local mapMonsterIds = {}
        local currentMapName = pData.InGame.Info.Map
        local currentMapId = nil
        
        for id, data in pairs(WorldMap) do
            if data.Name == currentMapName then currentMapId = id break end
        end

        -- Isi daftar pengecualian jika Map ID ditemukan
        if currentMapId then
            for _, mData in pairs(GeneralReplica.Data.Monsters) do
                if mData.MapId == currentMapId then 
                    mapMonsterIds[tostring(mData.Name)] = true 
                end
            end
        end

        local debrisMonsters = workspace:FindFirstChild("Debris") and workspace.Debris:FindFirstChild("Monsters")
        if debrisMonsters then
            for _, monster in pairs(debrisMonsters:GetChildren()) do
                if monster:IsA("Model") and monster.PrimaryPart then
                    local monsterTitle = monster:GetAttribute("Title") or ""
                    -- Nyerang apapun yang BUKAN musuh map normal
                    if not mapMonsterIds[tostring(monsterTitle)] then
                        targetMonster = monster
                        break
                    end
                end
            end
        end
    elseif isEnemySelected then
        -- === LOGIKA MAP NORMAL ===
        local debrisMonsters = workspace:FindFirstChild("Debris") and workspace.Debris:FindFirstChild("Monsters")
        if debrisMonsters then
            for _, monster in pairs(debrisMonsters:GetChildren()) do
                if monster:IsA("Model") and monster.PrimaryPart then
                    if monster:GetAttribute("Title") == Config.SelectedEnemy.Name then
                        targetMonster = monster
                        break 
                    end
                end
            end
        end

        -- Cari di Island Pads jika di Debris tidak ada
        if not targetMonster then
            local currentMapId = nil
            local currentMapName = pData.InGame.Info.Map
            for id, data in pairs(WorldMap) do
                if data.Name == currentMapName then currentMapId = id break end
            end
            if currentMapId then
                local islandFolderName = currentMapId .. ". " .. WorldMap[currentMapId].Name:gsub("_", " ")
                local padFolder = workspace.Islands:FindFirstChild(islandFolderName) and workspace.Islands[islandFolderName]:FindFirstChild("Pads")
                if padFolder then
                    for _, monsterPart in pairs(padFolder:GetChildren()) do
                        if monsterPart:GetAttribute("Ids") == tonumber(Config.SelectedEnemy.Id) then
                            targetMonster = monsterPart
                            break
                        end
                    end
                end
            end
        end
    end

    -- 3. EKSEKUSI TELEPORT
    if targetMonster then
        local targetPos = targetMonster:IsA("Model") and targetMonster.PrimaryPart.Position or targetMonster.Position
        local distance = (rootPart.Position - targetPos).Magnitude
        
        if distance > 10 then
            local targetCFrame = targetMonster:IsA("Model") and targetMonster.PrimaryPart.CFrame or targetMonster.CFrame
            rootPart.CFrame = targetCFrame * CFrame.new(0, 0, 5)
        end
    end
end
-- [[ GAME MODE CATEGORY ]] --
local GameModeGroup = FarmTab:Group({ Title = "Game Mode / Dungeons" })
FM_Add("Farm", GameModeGroup)

-- Toggle Auto Enter
FM_Add("Farm", FarmTab:Toggle({
    Title = "Auto Game Mode",
    Flag = "AutoEnter_Cfg",
    Callback = function(val)
        Config.AutoEnter = val
    end
}))

-- Prosedur Pemisahan Data
local DungeonList = {}
local RaidList = {}

if GeneralReplica and GeneralReplica.Data and GeneralReplica.Data.Dungeons then
    for dName, dData in pairs(GeneralReplica.Data.Dungeons) do
        local item = {
            Title = dData.Name:gsub("_", " ") .. "(" .. dData.MapId .. ")",
            Id = dData.Id,
            Value = dData.Name,
            Icon = dData.ImageId
        }
        if dData.Price and not dName:find("Test") then
            table.insert(RaidList, item)
        elseif not dData.Price and not dName:find("Test") and not dName:find("Only_Forward") and not dName:find("Staight") and not dName:find("Normal") then
            table.insert(DungeonList, item)
        end
    end

    -- Sortir alfabetis agar rapi
    local function sortByTitle(a, b) return a.Id < b.Id end
    table.sort(DungeonList, sortByTitle)
    table.sort(RaidList, sortByTitle)
end

-- Dropdown 1: Dungeon (Free / Test)
GameModeGroup:Dropdown({
    Title = "Select Dungeon",
    Values = DungeonList,
    Multi = true, -- Mengirimkan list/daftar
    AllowNone = true,
    Flag = "Dungeon_cfg",
    Callback = function(val)
        Config.SelectedDungeon = val -- Menyimpan list pilihan
    end
})

-- Dropdown 2: Raid (Paid / Keys)
GameModeGroup:Dropdown({
    Title = "Select Raid (Requires Key)",
    Values = RaidList,
    AllowNone = true,
    Flag = "Raid_cfg",
    Callback = function(val)
        -- Simpan string val.Value jika ada, jika tidak set nil
        Config.SelectedRaid = (type(val) == "table" and val.Value) or nil
    end
})

-- Fungsi helper untuk membersihkan tag RichText dan mengambil teks murni
local function GetCleanStatus(text)
    if not text then return "" end
    return text:gsub("<.-%>", ""):lower() 
end

function Optimizer.Update_GameMode_Logic(pData)
    if not Config.AutoEnter then return end
    
    -- 1. CEK STATUS: Jangan kirim remote jika sudah di dalam match
    if IsInsideDungeon() then return end

    -- 2. LOGIKA PENGECEKAN TARGET
    local function TryJoin(modeName)
        local data = GeneralReplica.Data.Dungeons[modeName]
        if not data then return false end

        -- Ambil status murni (kecil semua)
        local status = GetCleanStatus(data.Portal_Text)

        -- PERBAIKAN: Boleh masuk jika status mengandung 'open' atau 'closing'
        local isAvailable = string.find(status, "open") or string.find(status, "closing")
        if not isAvailable then return false end

        -- CEK SALDO (Jika ada harga tiket)
        local canEnter = true
        if data.Price then
            local reqAmount = math.abs(data.Price.Amount)
            if GetBalance(pData, data.Price.Id) < reqAmount then
                canEnter = false
            end
        end

        if canEnter then
            game:GetService("ReplicatedStorage").Events.To_Server:FireServer({
                Action = "_Enter_Dungeon",
                Name = modeName
            })
            task.wait(2) -- Jeda proteksi agar tidak spam
            return true 
        end
        return false
    end

    -- PRIORITAS 1: Cek Raid
    if Config.SelectedRaid then
        if TryJoin(Config.SelectedRaid) then return end
    end

    -- PRIORITAS 2: Cek semua Dungeon yang dipilih (Sesuai nama variabel dropdown Anda)
    local selected = Config.SelectedDungeon 
    if type(selected) == "table" and #selected > 0 then
        for _, item in ipairs(selected) do
            local dungeonName = type(item) == "table" and item.Value or item
            if TryJoin(dungeonName) then 
                break 
            end
        end
    end
end

local UpgradeChanceToggles = {}

local function CreateUpgradeChanceUI()
    local UpgradeData = GeneralReplica and GeneralReplica.Data and GeneralReplica.Data.Upgrades
    if not UpgradeData then return end
    
    local uList = {}
    for mainKey, data in pairs(UpgradeData) do
        -- Filter berdasarkan UI_Name == "Upgrade_Chance"
        if data.UI_Name == "Upgrade_Chance" then
            table.insert(uList, {
                MainKey = mainKey,
                Data = data,
                MapId = data.MapId or 0
            })
        end
    end

    -- Sort berdasarkan MapId
    table.sort(uList, function(a, b) return a.MapId < b.MapId end)

    local currentGroup = nil
    for i, upg in ipairs(uList) do
        if (i - 1) % 2 == 0 then
            currentGroup = FarmTab:Group({ Title = "Upgrade Chance: Map " .. upg.MapId })
            FM_Add("Upgrade Chance", currentGroup)
        end

        -- Karena struktur datanya memiliki .List (seperti Wind_Spirit_Progression.List.Wind_Spirit)
        for subKey, subData in pairs(upg.Data.List) do
            local cfgKey = upg.MainKey .. "|" .. subKey
            UpgradeChanceToggles[cfgKey] = currentGroup:Toggle({
                Title = subKey:gsub("_", " "),
                Desc = "Checking...",
                Image = subData.ImageId or "rbxassetid://10850280457",
                ImageSize = 24,
                Flag = "UpgChance_"..cfgKey,
                Callback = function(val)
                    Config.AutoProgression[cfgKey] = val -- Menggunakan tabel config yang sama atau buat baru
                end
            })
        end
    end
end

CreateUpgradeChanceUI()
function Optimizer.Update_Upgrade_Chance_Logic(pData)
    if not GeneralReplica or not pData.InGame or not pData.InGame.Upgrades then return end
    
    local upgradeGenDb = GeneralReplica.Data.Upgrades
    local playerUpgList = pData.InGame.Upgrades.List

    for cfgKey, toggle in pairs(UpgradeChanceToggles) do
        local mainKey, subKey = cfgKey:match("^(.-)|(.-)$")
        local genMainData = upgradeGenDb[mainKey]
        local genSubData = genMainData and genMainData.List[subKey]
        
        if not genSubData then continue end

        -- [[ 1. MAP LOCK CHECK ]] --
        local mapIdStr = tostring(genMainData.MapId or 0)
        local isMapUnlocked = pData.InGame.Unlocked.Maps[mapIdStr]

        if not isMapUnlocked and (genMainData.MapId ~= 1) then
            if not Optimizer.Cache["MapLockUpgChance_"..cfgKey] then
                toggle:Lock("Need Map: ".. (WorldMap[genMainData.MapId] and WorldMap[genMainData.MapId].Name:gsub("_", " ") or "Unknown"))
                Optimizer.Cache["MapLockUpgChance_"..cfgKey] = true
            end
            continue
        else
            if Optimizer.Cache["MapLockUpgChance_"..cfgKey] then
                toggle:Unlock()
                Optimizer.Cache["MapLockUpgChance_"..cfgKey] = nil
            end
        end

        -- [[ 2. GET CURRENT LEVEL & STATS HELPER ]] --
        local currentLevel = (playerUpgList[mainKey] and playerUpgList[mainKey][subKey]) or 0
        local maxLevel = genSubData.Max_Levels or #genSubData.Levels

        -- Fungsi pembantu untuk mengambil teks Buff
        local function GetStatBuffText(lvl)
            local dataAtLevel = genSubData.Levels[lvl]
            if dataAtLevel and dataAtLevel.Stats then
                local buffs = {}
                for _, stat in ipairs(dataAtLevel.Stats) do
                    table.insert(buffs, string.format("<font color='#00aaff'>+%s %s</font>", tostring(stat.Value), stat.Name:gsub("_", " ")))
                end
                return "\nBuff: " .. table.concat(buffs, " | ")
            end
            return ""
        end
        
        pcall(function()
            if currentLevel < maxLevel then
                -- [[ LOGIKA SAAT BELUM MAX ]] --
                local nextLevel = currentLevel + 1
                local nextLevelData = genSubData.Levels[nextLevel]

                if nextLevelData then
                    local priceInfo = nextLevelData.Price[1]
                    local reqAmount = math.abs(priceInfo.Amount)
                    local myBalance = GetBalance(pData, priceInfo.Id)
                    
                    local chance = (nextLevelData.Success_Chance or 0) * 100
                    local buffText = GetStatBuffText(nextLevel) -- Buff untuk level selanjutnya

                    local canAfford = myBalance >= reqAmount
                    local balColor = canAfford and "#00ff00" or "#ff0000"
                    
                    local desc = string.format(
                        "Level: <font color='#ffffff'>%d/%d</font>%s\nChance: <font color='#ffff00'>%d%%</font>\n<font color='%s'>%s: %s/%s</font>",
                        currentLevel, maxLevel, buffText, chance, balColor,
                        priceInfo.Id:gsub("_", " "), NumberFormatter:Format(myBalance), NumberFormatter:Format(reqAmount)
                    )

                    if Optimizer.Cache["UpgChanceUI_"..cfgKey] ~= desc then
                        toggle:SetDesc(desc)
                        Optimizer.Cache["UpgChanceUI_"..cfgKey] = desc
                    end

                    -- EXECUTE
                    if Config.AutoProgression[cfgKey] and canAfford then
                        ReplicatedStorage.Events.To_Server:FireServer({
                            Upgrading_Name = subKey,
                            Action = "_Upgrades",
                            Upgrade_Name = mainKey
                        })
                        task.wait(0.5) 
                    end
                end
            else
                -- [[ LOGIKA SAAT SUDAH MAX (Biar Enak Dipandang) ]] --
                local maxBuffText = GetStatBuffText(maxLevel) -- Mengambil buff dari level tertinggi
                local descMax = string.format(
                    "Level: <font color='#ffff00'>%d/%d (MAX)</font>%s", 
                    currentLevel, maxLevel, maxBuffText
                )

                if Optimizer.Cache["UpgChanceUI_"..cfgKey] ~= descMax then
                    toggle:SetDesc(descMax)
                    Optimizer.Cache["UpgChanceUI_"..cfgKey] = descMax
                    -- Matikan toggle otomatis jika sudah max
                    if Config.AutoProgression[cfgKey] then toggle:Set(false) end
                end
            end
        end)
    end
end
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

-- [[ MAIN DATA UPDATE LOOP ]] --
task.spawn(function()
    while true do
        task.wait(0.05) -- Update setiap 0.5 detik (Real-time)
        
        -- Pastikan Window masih ada
        if not IsWindowAlive() then break end

        -- Ambil PlayerData dari Global Variable atau Sync
        local pData = PlayerReplica and PlayerReplica.Data
        
        if pData then
            pcall(Optimizer.Update_RankUp_Logic, pData)
            pcall(Optimizer.Update_Roll_Logic, pData)
            pcall(Optimizer.Update_Gacha_Pet_Logic, pData)
            pcall(Optimizer.Update_Progression_Logic, pData) -- Tambahkan baris ini
            pcall(Optimizer.Update_Prestige_Logic, pData)
            pcall(Optimizer.Update_Leveling_Items_Logic, pData)
            pcall(Optimizer.Update_Prog_Lv_Items_Logic, pData)
            pcall(Optimizer.Update_Upgrade_Chance_Logic, pData) -- Tambahkan baris ini
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(0.05) -- Update setiap 0.5 detik (Real-time)
        
        -- Pastikan Window masih ada
        if not IsWindowAlive() then break end

        -- Ambil PlayerData dari Global Variable atau Sync
        local pData = PlayerReplica and PlayerReplica.Data
        
        if pData then
            -- Jalankan logika Rank Up secara otomatis
            pcall(Optimizer.Update_GameMode_Logic, pData)
            pcall(Optimizer.Update_Farm_Logic, pData)
        end
    end
end)
task.spawn(function()
    while true do
        task.wait() -- Update setiap 0.5 detik (Real-time)
        
        -- Pastikan Window masih ada
        if not IsWindowAlive() then break end

        -- Ambil PlayerData dari Global Variable atau Sync
        local pData = PlayerReplica and PlayerReplica.Data
        
        if pData then
            pcall(Optimizer.Update_KillAura_Logic,pData)
        end
    end
end)
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
        IsLoadingConfig = false
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
        end
    end
end)
