-- if game.PlaceId ~= 81897457567012 then return end
repeat task.wait() until game:IsLoaded()

loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading3.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local FolderPath = "ANUI/AnimeAll"
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

-- [[ 1. INIT MODULES ]] --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Utils = Shared:WaitForChild("Utils")
local Info = Shared:WaitForChild("Info")

local RanksInfo = require(Info.RanksInfo)
local NumberFormatter = require(Utils.NumberFormatter)
local RemoteEvents = require(Utils.RemoteEvents)
local EnemiesInfo = require(Info.EnemiesInfo)
local RaritiesInfo = require(Info.RaritiesInfo)
local Resources = require(Info.Resources)
local VisualDrops = require(Utils.VisualDrops)
local CurrencyInfo = require(Info.CurrencyInfo)

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
            Callback = function() setclipboard("https://discord.gg/RvT7Av93nr") Notify("Discord", "Invite link copied!", "geist:logo-discord") end
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
    Title = "AN Hub - Anime All",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeAll",
    Size = UDim2.fromOffset(580, 460),
    KeySystem = {
        Enabled = not IsPremium,
        Title = "ANHub Access",
        Description = "Free Key: ANHUB-2025",
        Key = ValidKeys,
        URL = "https://discord.gg/RvT7Av93nr",
        Note = "Premium Users are auto-verified!",
        SaveKey = true
    }
})

task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
Window:Tab({
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime All" }),
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
    ["Farm"] = "Auto Farm Select Enemies",
    ["Rank Up"] = "Auto Rank Up"
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
        Desc = "Anime CeAll"
    }),
    SidebarProfile = false
});

-- Pembuatan Selector Kategori
FM_CategorySelector = FarmTab:Category({
    Title = "Select Category",
    Default = "Farm",
    Options = {
        {Title = "Farm", Icon = "rbxassetid://80464955872244"},
        {Title = "Rank Up", Icon = "rbxassetid://96484660789564"},
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
-- Tampilan Status Rank
local RankStatusUI = FarmTab:Paragraph({
    Title = "Rank Info",
    Desc = "Loading Rank Data...",
    Image = "rbxassetid://96484660789564",
    ImageSize = 40
})
FM_Add("Rank Up", RankStatusUI)

-- Toggle Auto Rank Up
local RankToggle = FarmTab:Toggle({
    Title = "Auto Rank Up",
    Desc = "Otomatis naik Rank saat Power mencukupi.",
    Flag = "AutoRankUp_Cfg",
    Callback = function(val)
        Config.AutoRankUp = val
    end
})
FM_Add("Rank Up", RankToggle)

-- [[ 3. LOGIC FUNCTION ]] --
local LastRankUpdate = 0

local function UpdateRankUpLogic()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    
    -- Ambil data Attribute Pemain
    local currentRank = LocalPlayer:GetAttribute("CurrentRank") or 1
    local currentPower = LocalPlayer:GetAttribute("Power") or 0
    
    -- Ambil data dari Module RanksInfo
    local nextRankData = RanksInfo[currentRank + 1]
    local currentRankData = RanksInfo[currentRank] or RanksInfo[#RanksInfo]

    if nextRankData then
        -- === LOGIKA FORMATTER ASLI ===
        local cost = nextRankData.Amount
        local boostNow = currentRankData.Boost or 1
        local boostNext = nextRankData.Boost or 1
        
        -- Update UI setiap 0.5 detik
        if tick() - LastRankUpdate > 0.5 then
            -- MENGGUNAKAN MODULE ASLI GAME: FormatWithSuffix
            local costStr = NumberFormatter.FormatWithSuffix(cost)
            local powerStr = NumberFormatter.FormatWithSuffix(currentPower)
            local boostNowStr = NumberFormatter.FormatWithSuffix(boostNow)
            local boostNextStr = NumberFormatter.FormatWithSuffix(boostNext)
            
            local color = (currentPower >= cost) and "#00ff00" or "#ff0000"
            
            -- Visual Bar
            local pct = math.clamp(currentPower / cost, 0, 1)
            local barLength = 10
            local filled = math.floor(pct * barLength)
            local bar = string.rep("█", filled) .. string.rep("▒", barLength - filled)
            
            local desc = string.format(
                "Rank: %d -> %d\n" ..
                "Boost: %sx -> <font color='#00aaff'>%sx</font>\n" ..
                "Power: <font color='%s'>%s</font> / %s\n" ..
                "[%s] %d%%",
                currentRank, currentRank + 1,
                boostNowStr, boostNextStr,
                color, powerStr, costStr,
                bar, math.floor(pct * 100)
            )
            
            RankStatusUI:SetTitle("Current Rank: " .. currentRank)
            RankStatusUI:SetDesc(desc)
            LastRankUpdate = tick()
        end

        -- Eksekusi Auto Rank Up
        if Config.AutoRankUp and currentPower >= cost then
            RemoteEvents.RankUpEvent:FireServer()
        end
    else
        -- Jika Max Rank
        if tick() - LastRankUpdate > 0.5 then
            RankStatusUI:SetTitle("Rank Maxed")
            RankStatusUI:SetDesc("<font color='#ffff00'>Max Rank Reached!</font>")
            LastRankUpdate = tick()
        end
        
        if Config.AutoRankUp then
            RankToggle:Set(false)
            Config.AutoRankUp = false
            if Notify then Notify("Rank Up", "Max Rank Reached.", "check") end
        end
    end
end

-- [[ 4. START LOOP ]] --
task.spawn(function()
    while true do
        task.wait(0.2)
        if Window and not Window.Destroyed then
            -- Bungkus pcall agar jika module game error, script tidak stop total
            pcall(UpdateRankUpLogic)
        else
            break
        end
    end
end)
-- ==================================================================
-- [END] FITUR RANK UP
-- ==================================================================
-- Normalisasi Pilihan Dropdown
local function NormalizeEnemySelection(selection)
    if selection == nil then return nil end
    local results = {}
    local function add(v)
        if v and v ~= "" then table.insert(results, tostring(v)) end
    end
    if type(selection) == "table" then
        if selection.Value then add(selection.Value)
        else
            for _, item in ipairs(selection) do
                add(type(item) == "table" and item.Value or item)
            end
        end
    else
        add(selection)
    end
    return #results > 0 and results or nil
end

-- Generate Tampilan Kartu Drop (Termasuk Money & Item)
local function GenerateDropCards(dropsTable, moneyAmount)
    local rewardCards = {}
    
    -- 1. Tampilkan Money (Souls) sebagai Item Drop
    if moneyAmount and moneyAmount > 0 then
        -- Ambil data visual Money dari CurrencyInfo
        local moneyData = CurrencyInfo["Money"]
        if moneyData then
            table.insert(rewardCards, {
                Image = "rbxassetid://" .. (moneyData.Image or ""),
                Gradient = moneyData.Gradient.Color, -- Gradient Money dari Module
                Quantity = NumberFormatter.FormatWithSuffix(moneyAmount),
                Title = moneyData.Key or "Souls"
            })
        end
    end

    -- 2. Tampilkan Item Drops Lainnya
    if dropsTable then
        for _, dropData in ipairs(dropsTable) do
            local DropD = Resources[dropData.Indice]
            if DropD then
                if dropData.Chance < 100 then
                    table.insert(rewardCards, {
                        Image = "rbxassetid://" .. (DropD.Image or ""),
                        Gradient = RaritiesInfo[DropD.Rarity].Gradient.Color, -- Gradient Rarity dari Module Game
                        Quantity = string.format("%s-%s", dropData.Min,dropData.Max),
                        Rate = string.format("%s%%", dropData.Chance),
                        Title = DropD.Name or "Unknown"
                    })
                else
                    table.insert(rewardCards, {
                        Image = "rbxassetid://" .. (DropD.Image or ""),
                        Gradient = RaritiesInfo[DropD.Rarity].Gradient.Color, -- Gradient Rarity dari Module Game
                        Quantity = string.format("%s-%s", dropData.Min,dropData.Max),
                        Title = DropD.Name or "Unknown"
                    })
                end
            end
        end
    end
    
    return rewardCards
end

-- Refresh List Musuh (Sorted by HP & Rarity Name)
local function RefreshEnemyList()
    local uiList = {}
    
    -- Loop data EnemiesInfo
    for worldId, worldEnemies in pairs(EnemiesInfo) do
        if type(worldEnemies) == "table" and worldId ~= "Global" then
            for enemyId, data in pairs(worldEnemies) do
                if data.Name and data.Health then
                    -- [LOGIC MODULAR]
                    -- 1. Ambil Variant Index (Default 1 jika nil)
                    local variantIndex = data.Variant or 1
                    
                    -- 2. Ambil Nama Rarity dari Module RaritiesInfo
                    -- Kita akses table RaritiesInfo menggunakan index variant
                    local rarityName = "Bosses"
                    if RaritiesInfo and RaritiesInfo[variantIndex] and variantIndex < 6 then
                        rarityName = RaritiesInfo[variantIndex].Name
                    end
                    
                    -- Generate Drop Images (Money + Items)
                    -- local dropImages = {}
                    local dropImages = GenerateDropCards(data.Drops, data.Money)
                    
                    -- Format Angka HP & Money
                    local hpText = NumberFormatter.FormatWithSuffix(data.Health)

                    table.insert(uiList, {
                        -- Judul: "Nama Musuh (Nama Rarity)"
                        Title = string.format("%s (%s)", data.Name, rarityName),
                        
                        Value = data.Name, 
                        Desc = string.format("HP: %s", hpText),
                        Images = dropImages,
                        
                        -- Simpan HP Asli untuk Sorting
                        _SortHP = data.Health 
                    })
                end
            end
        end
    end
    
    -- Sorting HP Terkecil -> Terbesar
    table.sort(uiList, function(a, b) 
        return (a._SortHP or 0) < (b._SortHP or 0) 
    end)
    
    return uiList
end

-- [[ 3. UI ELEMENTS (Kategori: Farm) ]] --

local CurrentEnemyCache = RefreshEnemyList()

-- Dropdown
local EnemyDropdown = FarmTab:Dropdown({
    Title = "Select Enemy",
    Multi = true,
    Values = CurrentEnemyCache,
    AllowNone = true,
    ImageSize = UDim2.fromOffset(20, 20),
    ImagePadding = 6,
    Flag = "TargetEnemies_Farm_Cfg",
    Callback = function(selectedItem)
        local normalized = NormalizeEnemySelection(selectedItem)
        Config.SelectedEnemy = normalized
    end
})
FM_Add("Farm", EnemyDropdown)

-- Toggle Auto Farm
local FarmToggle = FarmTab:Toggle({
    Title = "Enable Auto Farm",
    Desc = "Teleport and attack selected enemies.",
    Flag = "AutoFarm_Main_Cfg",
    Callback = function(val)
        Config.AutoFarm = val
    end
})
FM_Add("Farm", FarmToggle)

-- [[ 5. LOGIC ENGINE (ONE-BY-ONE / BERGANTIAN SETELAH MATI) ]] --

local CurrentTargetIndex = 0 -- Mulai dari 0 agar loop pertama langsung ke 1
local LockedTarget = nil     -- Variable untuk menyimpan musuh yang sedang dihajar

task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    
    while true do
        task.wait() -- Loop speed
        
        if Config.AutoFarm and not Window.Destroyed then
            local selectedList = Config.SelectedEnemy
            local LocalPlayer = Players.LocalPlayer
            local Character = LocalPlayer.Character
            
            -- Pastikan Karakter Hidup
            if Character and Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 then
                local hrp = Character.HumanoidRootPart
                local myPos = hrp.Position
                
                -- [[ LOGIKA GANTI TARGET ]] --
                -- Cek apakah kita perlu mencari target baru?
                -- Target baru dicari jika: Belum punya target ATAU Target yang lama sudah mati/hilang
                local needNewTarget = false
                
                if not LockedTarget then 
                    needNewTarget = true
                elseif not LockedTarget.Parent then 
                    needNewTarget = true -- Musuh hilang dari workspace
                elseif LockedTarget:GetAttribute("IsDead") then 
                    needNewTarget = true -- Musuh mati (Attribute IsDead)
                elseif LockedTarget:FindFirstChild("Humanoid") and LockedTarget.Humanoid.Health <= 0 then
                    needNewTarget = true -- Musuh mati (HP 0)
                end
                
                if needNewTarget and selectedList and #selectedList > 0 then
                    -- 1. Pindah ke Index Musuh Berikutnya
                    CurrentTargetIndex = CurrentTargetIndex + 1
                    
                    -- Jika sudah sampai akhir list, balik lagi ke awal (Looping)
                    if CurrentTargetIndex > #selectedList then
                        CurrentTargetIndex = 1
                    end
                    
                    -- 2. Cari Musuh dengan Nama Tersebut
                    local nameToFind = selectedList[CurrentTargetIndex]
                    local EnemiesFolder = Workspace:FindFirstChild("Enemies") 
                    local CharacterFolder = EnemiesFolder and EnemiesFolder:FindFirstChild("Character")
                    
                    if CharacterFolder then
                        local foundNew = nil
                        local minDist = math.huge
                        
                        -- Cari musuh terdekat yang namanya SESUAI GILIRAN
                        for _, enemy in ipairs(CharacterFolder:GetChildren()) do
                            local enemyName = enemy:GetAttribute("EnemyName") or enemy.Name
                            
                            -- Hanya ambil jika namanya sama dengan giliran saat ini
                            if enemyName == nameToFind then
                                if enemy:FindFirstChild("HumanoidRootPart") and (not enemy:GetAttribute("IsDead")) then
                                    local dist = (enemy.HumanoidRootPart.Position - myPos).Magnitude
                                    if dist < minDist then
                                        minDist = dist
                                        foundNew = enemy
                                    end
                                end
                            end
                        end
                        
                        -- Set Target Baru (Bisa nil jika musuh jenis itu tidak ada di map)
                        LockedTarget = foundNew
                    end
                end
                
                -- [[ LOGIKA SERANGAN ]] --
                -- Jika punya target yang valid, serang dia
                if LockedTarget and LockedTarget:FindFirstChild("HumanoidRootPart") then
                    local tRoot = LockedTarget.HumanoidRootPart
                    local tPos = tRoot.Position
                    local distToTarget = (tPos - myPos).Magnitude
                    
                    if distToTarget > 10 then
                        -- Teleport Jauh (Belakang Musuh)
                        local attackCFrame = tRoot.CFrame * CFrame.new(0, 0, 5)
                        local lookAtPos = Vector3.new(tPos.X, attackCFrame.Y, tPos.Z)
                        
                        hrp.CFrame = CFrame.lookAt(attackCFrame.Position, lookAtPos)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    else
                        -- Diam Jarak Dekat (Hadap Musuh)
                        local lookAtPos = Vector3.new(tPos.X, myPos.Y, tPos.Z)
                        hrp.CFrame = CFrame.lookAt(myPos, lookAtPos)
                    end
                else
                    -- Jika LockedTarget nil (misal musuh giliran ini gak ada di map),
                    -- Script akan loop lagi ke atas -> needNewTarget = true -> Lanjut ke Index berikutnya.
                    -- Jadi dia bakal skip otomatis musuh yang gak ada.
                end
            end
        end
    end
end)

-- ==================================================================
-- [END] FITUR FARM
-- ==================================================================
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
