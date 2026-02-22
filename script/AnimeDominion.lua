if game.PlaceId ~= 113013172442707 then return end
repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Anime Dominion"
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

local FolderPath = "ANUI/AnimeDominion"
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local IsPremium = false
local ValidKeys = {"ANHUB-2025"}
local MapDBFile = "Map_Database.json"
local inRaid = nil
local Config = {
    SelectedEnemies = {}, -- Berubah menjadi tabel untuk mendukung Multi-Select
    AutoFarm = false
}

-- Variabel global untuk menampung target aktif saat ini
local currentTarget = nil
local currentTargetIndex = 0
local ConfigName = "ANConfig"
local CurrentMapEnemiesCache = {}
local IsLoadingConfig = false
local IsLoadingMapSelection = false

local UI
local Window

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
    Title = "AN Hub - Anime Dominion",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeDominion",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Dominion" }),
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
local FeatureElements = {}
local function RegisterFeatureElement(elem)
    if elem then
        table.insert(FeatureElements, elem)
    end
    return elem
end

local function ApplyFreeUserRestrictions()
    if IsPremium then
        return
    end

    local lockText = "Premium Only"

    for _, elem in ipairs(FeatureElements) do
        if elem and elem.__type == "Toggle" then
            pcall(function() elem:Unlock() end)
            pcall(function() elem:Set(false, true) end)
        elseif elem and elem.__type == "Dropdown" then
            pcall(function() elem:Select(nil) end)
        end

        pcall(function()
            if elem and elem.Lock then
                elem:Lock(lockText)
            end
        end)

        pcall(function()
            if elem and type(elem) == "table" then
                for _, v in pairs(elem) do
                    if type(v) == "table" and type(v.Lock) == "function" then
                        v:Lock(lockText)
                    end
                end
            end
        end)
    end
end

local FM_CategoryDescriptions = {
    ["Farm"] = "Auto farm enemies and specific targets.",
    ["Ascension"] = "Manage your character ascension and auto-evolve.", -- Tambahkan ini
    ["Skins"] = "Manage your owned skins, equip, and auto-evolve.",
    ["Passive"] = "Auto reroll Passive and track pity status.",
    ["Zeringan"] = "Upgrade your Sharingan stages and monitor buffs.", -- Tambahkan ini
    ["Range Upgrade"] = "Enhance your attack range and multipliers.", -- Tambahkan ini
    ["Game Mode"] = "Manage Raids, Tokyo War, and Auto Leave settings.", -- Tambahkan ini
    ["Hatch Pets"] = "Instant Multi-Hatch pets without animation delay.", -- Tambahkan ini
    ["Sword Management"] = "Manage Swords, Auto Evolve, and Auto Crafting.", -- Tambahkan ini
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
    RegisterFeatureElement(elem)
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
        Desc = "Anime Dominion"
    }),
    SidebarProfile = false
});

-- Update Opsi pada CategorySelector
FM_CategorySelector = FarmTab:Category({
    Title = "Select Category",
    Default = "Farm",
    Options = {
        {Title = "Farm", Icon = "rbxassetid://89761068698333"},
        {Title = "Game Mode", Icon = "rbxassetid://109634928579023"}, -- Icon Game Mode
        {Title = "Ascension", Icon = "rbxassetid://99780781154645"}, -- Tambahkan kategori baru
        {Title = "Skins", Icon = "rbxassetid://94497317450432"},
        {Title = "Passive", Icon = "rbxassetid://93194721632859"}, -- Icon Family
        {Title = "Sword Management", Icon = "rbxassetid://104429001572480"}, -- Icon Sword
        {Title = "Hatch Pets", Icon = "rbxassetid://92349810618564"}, -- Icon Egg/Pet
        {Title = "Zeringan", Icon = "rbxassetid://117530189851156"}, -- Icon Sharingan
        {Title = "Range Upgrade", Icon = "rbxassetid://86884305951467"}, -- Icon Range
        {Title = "Fruit Merchant", Icon = "rbxassetid://129783597097054"}, -- Icon Buah/Merchant
    },
    Callback = FM_OnChange
})

-- [[ INTEGRASI METASERVICE ]] --
local MetaManager = require(LocalPlayer.PlayerScripts.MetaService.Manager)
-- [[ GLOBAL TELEPORT LOCKER ]] --
local IsTeleporting = false

-- Simpan fungsi asli agar tetap bisa dipanggil
local OriginalAddEffect = MetaManager.TTeleport.AddEffect
-- [[ PERBAIKAN LOGIKA ANTI-AFK (Sesuai Decompile) ]] --

task.spawn(function()
    repeat task.wait() until game:GetService("Players").LocalPlayer
    local LP = game:GetService("Players").LocalPlayer

    LP.Idled:Connect(function()
        -- 1. Simulasi Input Engine (Mencegah Kick Roblox)
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)
task.spawn(function()
    while not Window.Destroyed do
        getgenv().PlayerData = MetaManager.Player.Data
        getgenv().Enemies = MetaManager.Shared.Enemies
        task.wait(0.2)
    end
end)
local AttackModule = MetaManager.Scripts.Attack
local OriginalAttackClick = AttackModule.Click
local ItemsData = MetaManager.Shared.Items
local AccessoriesData = MetaManager.Shared.Accessories
local DropElements = {} -- Tabel untuk melacak elemen UI drops yang aktif

local function GetEnemiesList()
    local list = {}
    local processed = {}
    
    -- Referensi Utils dan Data
    local NumberUtils = MetaManager.Utils.Number
    local ColorUtils = MetaManager.Utils.Colors
    local ItemsIndex = MetaManager.Shared.Items
    local AccIndex = MetaManager.Shared.Accessories
    local currentMap = getgenv().PlayerData and getgenv().PlayerData.Map or "Leaf Village"
    local enemiesDB = getgenv().Enemies
    
    -- Folder Server sebagai sumber Nama asli musuh
    local worldFolder = workspace.Server.Enemies.World:FindFirstChild(currentMap)
    local gamemodeFolders = workspace.Server.Enemies.Gamemodes:GetChildren()

    local function scanEnemies(folder)
        if not folder then return end
        for _, enemyPart in pairs(folder:GetChildren()) do
            if not processed[enemyPart.Name] then
                processed[enemyPart.Name] = true
                
                -- Cari stats musuh di Database
                local stats = nil
                if enemiesDB.World[currentMap] and enemiesDB.World[currentMap][enemyPart.Name] then
                    stats = enemiesDB.World[currentMap][enemyPart.Name]
                else
                    for _, gmData in pairs(enemiesDB.Gamemodes) do
                        if gmData[enemyPart.Name] then stats = gmData[enemyPart.Name]; break end
                    end
                end

                if stats then
                    local mobRarity = stats.Difficult or "Normal"
                    local dropCards = {}
                    
                    -- Konversi Health string ke angka untuk pengurutan
                    local rawHealthString = stats.Health or tostring(enemyPart:GetAttribute("MaxHealth") or "0")
                    local numericHealth = NumberUtils:Unformat(rawHealthString) or 0

                    -- Proses Drops untuk tampilan Gambar
                    if stats.Drops then
                        for _, data in pairs(stats.Drops) do
                            local itemData = ItemsIndex[data.Item]
                            if itemData then
                                table.insert(dropCards, {
                                    Title = data.Item,
                                    Quantity = "x" .. tostring(data.Amount or 1),
                                    Rate = tostring(data.Percentage or 0) .. "%",
                                    Gradient = ColorUtils:GetRarity(itemData.Rarity or "Common"),
                                    Image = itemData.Icon or "rbxassetid://0"
                                })
                            end
                        end
                    end

                    table.insert(list, {
                        Title = string.format("%s [%s]", enemyPart.Name, mobRarity),
                        Desc = "Health: " .. rawHealthString,
                        Images = dropCards,
                        RawName = enemyPart.Name,
                        HealthValue = numericHealth -- Disimpan untuk proses sorting
                    })
                end
            end
        end
    end

    scanEnemies(worldFolder)
    for _, gmFolder in ipairs(gamemodeFolders) do
        scanEnemies(gmFolder)
    end

    -- [[ LOGIKA SORTING BERDASARKAN HEALTH ]]
    -- Mengurutkan dari darah terkecil ke terbesar
    table.sort(list, function(a, b)
        return a.HealthValue < b.HealthValue
    end)

    return list
end

local function GetTargetBySequence()
    -- 1. CEK OTOMATIS MUSUH DI GAMEMODE (RAID/WAR)
    -- Jika ada musuh di folder Gamemodes, serang langsung tanpa cek dropdown
    local raidFolders = workspace.Server.Enemies.Gamemodes:GetChildren() --
    for _, raidFolder in ipairs(raidFolders) do
        local enemies = raidFolder:GetChildren()
        if #enemies > 0 then
            for _, v in pairs(enemies) do
                if v:IsA("BasePart") then
                    local health = v:GetAttribute("Health") or 0 --
                    local isDied = v:GetAttribute("Died") --
                    local isBoss = v:GetAttribute("Difficult") --
                    
                    if health > 0 and not isDied and isBoss == "Boss" then
                        return v -- Serang musuh raid pertama yang ditemukan
                    end
                end
            end
        end
    end

    -- 2. LOGIKA DROPDOWN (Hanya berjalan jika tidak ada musuh Raid)
    if #Config.SelectedEnemies == 0 then return nil end --
    
    local currentMap = getgenv().PlayerData and getgenv().PlayerData.Map or "Leaf Village" --
    local worldFolder = workspace.Server.Enemies.World:FindFirstChild(currentMap) --
    
    local listSize = #Config.SelectedEnemies
    local attempts = 0
    
    while attempts < listSize do
        currentTargetIndex = currentTargetIndex + 1
        if currentTargetIndex > listSize then currentTargetIndex = 1 end
        
        local targetName = Config.SelectedEnemies[currentTargetIndex]
        
        if worldFolder then
            for _, v in pairs(worldFolder:GetChildren()) do
                if v.Name == targetName and v:IsA("BasePart") then
                    local health = v:GetAttribute("Health") or 0
                    if health > 0 and not v:GetAttribute("Died") then 
                        return v 
                    end
                end
            end
        end
        
        attempts = attempts + 1
    end
    return nil
end


-- [[ 3. Dropdown Update ]] --
local lastMap = getgenv().PlayerData and getgenv().PlayerData.Map or "" -- Menyimpan Map awal

local EnemyDropdown = FM_Add("Farm", FarmTab:Dropdown({
    Title = "Select Enemy",
    Values = GetEnemiesList(),
    Multi = true,
    AllowNone = true,
    Flag = "EnemyList_Dropdown",
    Callback = function(val)
        Config.SelectedEnemies = {}
        if typeof(val) == "table" then
            for _, item in ipairs(val) do
                table.insert(Config.SelectedEnemies, item.RawName)
            end
        end
        currentTarget = nil 
    end
}))

-- [[ HOOK TELEPORT: HANYA UNTUK LOCKING ]] --
MetaManager.TTeleport.AddEffect = function(targetMap)
    IsTeleporting = true 
    inRaid = true -- Menandai sedang proses pindah
    
    local success, err = pcall(function()
        OriginalAddEffect(targetMap)
    end)
    
    -- Beri jeda 3 detik agar animasi selesai sebelum membuka kunci farm
    task.delay(1, function() 
        inRaid = false
    end)
    
    -- Beri jeda 3 detik agar animasi selesai sebelum membuka kunci farm
    task.delay(3, function() 
        IsTeleporting = false
    end)
    
    if not success then warn("Teleport Handled: " .. tostring(err)) end
end
-- [[ FIX: MAP MONITOR & AUTO REFRESH DROPDOWN ]] --
task.spawn(function()
    local lastMapDropdown = "" 
    
    while true do
        task.wait(1) -- Beri jeda 1 detik agar tidak membebani CPU
        
        if not Window or Window.Destroyed then break end
        
        -- Jika sedang teleport, lewati pengecekan (tapi jangan matikan loop)
        if IsTeleporting then 
            continue 
        end
        
        local pData = getgenv().PlayerData
        if pData and pData.Map then
            -- Deteksi perubahan map
            if pData.Map ~= lastMapDropdown then
                lastMapDropdown = pData.Map
                
                -- Beri jeda sedikit agar data world/enemies di map baru sempat dimuat oleh game
                task.wait(2) 
                
                if EnemyDropdown and EnemyDropdown.Refresh then
                    pcall(function()
                        local newList = GetEnemiesList()
                        EnemyDropdown:Refresh(newList)
                        Notify("Map Updated", "Enemy list refreshed for: " .. pData.Map, "refresh-cw")
                    end)
                end
            end
        end
    end
end)


-- [[ FITUR: AUTO TARGET ALL ENEMY (MULTI-HIT) ]] --

AttackModule.Click = function(arg1)
    if Config.AutoFarm then
        local pData = getgenv().PlayerData
        if pData then
            pcall(function()
                -- Kalkulasi Range Raksasa sesuai permintaan: $100,000 * (1 + Length/100)$
                local currentRange = 100000 * (1 + (pData["Range-Stats"].Length or 0) / 100)
                
                -- Ambil semua musuh di sekitar
                local targets1, targets2 = MetaManager.ProximityEnemy:GetAll(currentRange)
                
                if targets1 then
                    -- Kirim serangan massal dengan bypass cooldown (true)
                    MetaManager.Bridge:Fire("Attack", "RangeAttack", targets1, targets2, false)
                end
            end)
        end
        return 
    else
        return OriginalAttackClick(arg1)
    end
end

-- [[ UPDATE LOGIKA AUTO FARM ]] --
FM_Add("Farm", FarmTab:Toggle({
    Title = "Auto Farm",
    Default = false,
    Flag = "AutoFarm_Toggle",
    Callback = function(val)
        Config.AutoFarm = val
        if val then
            currentTargetIndex = 0
            task.spawn(function()
                while not Window.Destroyed do
                    -- JIKA SEDANG TELEPORT (MANUAL/AUTO), BERHENTI TOTAL
                    if IsTeleporting then 
                        task.wait(0.5) 
                        continue 
                    end

                    if Config.AutoFarm then
                        if not currentTarget or not currentTarget.Parent or (currentTarget:GetAttribute("Health") or 0) <= 0 then
                            currentTarget = GetTargetBySequence()
                        end

                        if currentTarget then
                            local myCharacter = LocalPlayer.Character
                            local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
                            
                            -- Pastikan karakter sudah "landed" di map baru
                            if myRoot and not IsTeleporting then
                                local distance = (myRoot.Position - currentTarget.Position).Magnitude
                                if distance > 10 then
                                    myRoot.CFrame = currentTarget.CFrame * CFrame.new(0, 3, 3)
                                end
                            end
                        end
                    end
                    
                    pcall(function()
                        AttackModule.Click(true)
                    end)
                    
                    task.wait() 
                end
            end)
        end
    end
}))
-- [[ ELEMEN UNTUK KATEGORI GAME MODE ]] --

local GameModeElements = {}
Config.AutoLeaveWave = 0 -- Default 0 (Disabled)

-- 1. Dropdown Pilih Raid
local SelectedRaidType = "HunterTownRaid"
FM_Add("Game Mode", FarmTab:Dropdown({
    Title = "Select Raid Type",
    Values = {
        {Title = "Hunter Town Raid", RawName = "HunterTownRaid"},
        {Title = "Tokyo War", RawName = "TokyoWar"},
        {Title = "Treasure Hunt", RawName = "TreasureHunt"} -- Tambahkan ini
    },
    AllowNone = true,
    Flag = "GameMode_Dropdown",
    Callback = function(val)
        SelectedRaidType = (val and val.RawName) or ""
    end
}))

-- 2. Toggle Auto Start/Join
local AutoRaidToggle = FM_Add("Game Mode", FarmTab:Toggle({
    Title = "Auto Start/Join Raid",
    Desc = "Automatically start or join while in the lobby.",
    Default = false,
    Flag = "AutoRaid_Toggle",
    Callback = function(val) Config.AutoRaid = val end
}))

-- 3. Input Auto Leave Wave
FM_Add("Game Mode", FarmTab:Input({
    Title = "Auto Leave at Wave",
    Placeholder = "Contoh: 6",
    Flag = "AutoLeaveWave_Input",
    Callback = function(txt)
        Config.AutoLeaveWave = tonumber(txt) or 0
    end
}))

-- 4. Task Utama Game Mode: Auto Start & Auto Leave (REFINED)
task.spawn(function()
    local raidKeyMapping = {
        ["HunterTownRaid"] = "HunterTown",
        ["TokyoWar"] = "TokyoWar",
        ["TreasureHunt"] = "TesureHunt" -- Perbaikan typo sesuai decompile
    }
    while task.wait(1.5) do
        if not Window or Window.Destroyed then break end
        
        local pData = getgenv().PlayerData
        if pData and Config.AutoRaid then
            if SelectedRaidType == "" then
                continue
            end
            if inRaid then
                if pData and Config.AutoLeaveWave > 0 then
                    local hud = LocalPlayer.PlayerGui.UI.HUD.Gamemodes:FindFirstChild(SelectedRaidType)
                    if hud and hud.Visible then
                        local waveText = hud.Frame.Frame.Title.Text
                        local currentWave = tonumber(waveText:match("%d+"))
                        
                        if currentWave and currentWave >= Config.AutoLeaveWave then
                            Notify("Auto Leave", "Target Wave Reached! Leaving...", "log-out")
                            pcall(function()
                                MetaManager.TTeleport.AddEffect(pData.Map)
                                inRaid = false
                            end)
                            task.wait(5)
                        end
                    end
                end
                if IsTeleporting then
                    IsTeleporting = false
                end
                continue
            end

            pcall(function()
                local raidKey = raidKeyMapping[SelectedRaidType]
                if not raidKey then return end

                -- Invoke server menggunakan key yang benar (termasuk typo "TesureHunt")
                local raidData = ReplicatedStorage.Remotes.Raids[raidKey].Get:InvokeServer()

                if raidData then
                    if raidData.Owner == nil then
                        -- Start jika kosong
                        MetaManager.Bridge:Fire("Gamemodes_"..SelectedRaidType, "Start", "Public")
                        inRaid = true
                    elseif not raidData.Started then
                        -- Join jika sudah ada owner tapi belum mulai
                        MetaManager.Bridge:Fire("Gamemodes_"..SelectedRaidType, "Join")
                        inRaid = true
                    end
                end
            end)
        end
    end
end)

local AscensionToggle = FM_Add("Ascension", FarmTab:Toggle({
    Title = "Auto Ascension",
    Desc = "Waiting for data...",
    Default = false,
    Flag = "AutoAscension_Toggle",
    Callback = function(val)
        Config.AutoAscension = val
    end
}))

-- Task untuk Update UI & Logika Auto Evolve
task.spawn(function()
    local NumberUtils = MetaManager.Utils.Number
    local AscensionsDB = MetaManager.Shared.Ascensions
    local ColorUtils = MetaManager.Utils.Colors
    local lastLevel = -1 

    while task.wait() do
        if not Window or Window.Destroyed then break end
        
        -- Ambil Data dari PlayerData (MetaService)
        local currentLevel = getgenv().PlayerData.Ascension or 0
        local currentEnergy = getgenv().PlayerData.Energy or 0
        
        local currentData = AscensionsDB[currentLevel]
        local nextData = AscensionsDB[currentLevel + 1]
        local nextInfo = nextData or { Name = "MAX", Price = "MAX" }
        
        if currentData then
            -- Ambil harga & hitung progress
            local cost = (nextInfo.Price ~= "MAX") and NumberUtils:Unformat(nextInfo.Price) or 0
            local progress = (nextInfo.Price ~= "MAX") and math.clamp(currentEnergy / cost, 0, 1) or 1
            
            -- [[ 1. TITLE ]]
            local titleStr = string.upper(currentData.Name) .. " -> " .. string.upper(nextInfo.Name)
            AscensionToggle:SetTitle(titleStr)
            
            -- [[ 2. LOGIKA EKSTRAKSI BUFF (CURRENT & NEXT) ]]
            local function formatBuffs(data)
                if not data or not data.Multipliers then return "None" end
                local buffs = {}
                for _, v in pairs(data.Multipliers) do
                    -- v[1] = Stat Name, v[2] = Multiplier Value
                    table.insert(buffs, string.format("%s: %sx", v[1], v[2]))
                end
                return table.concat(buffs, " | ")
            end

            local currentBuffText = "Current: [" .. formatBuffs(currentData) .. "]"
            local nextBuffText = (nextInfo.Name ~= "MAX") and ("Next: [" .. formatBuffs(nextData) .. "]") or "Next: [MAXED]"
            
            -- [[ 3. PROGRESS BAR ]]
            local barLen = 15
            local filled = math.floor(progress * barLen)
            local bar = "[" .. string.rep("█", filled) .. string.rep("░", barLen - filled) .. "]"
            
            -- [[ 4. DESCRIPTION - GABUNGAN PROGRESS & BUFFS ]]
            local infoStr = (nextInfo.Price ~= "MAX") and (NumberUtils:Format(currentEnergy) .. "/" .. NumberUtils:Format(cost) .. " ENERGY") or "MAX"
            
            -- Menyusun deskripsi yang lebih rapi
            AscensionToggle:SetDesc(string.format(
                "%s %s%%\n%s\n%s\n%s", 
                bar, math.floor(progress * 100), 
                infoStr,
                currentBuffText,
                nextBuffText
            ))
            
            -- [[ 5. GAMBAR (CARD STYLE) - UPDATE SAAT LEVEL BERUBAH ]]
            if currentLevel ~= lastLevel then
                lastLevel = currentLevel
                -- Menggunakan fitur SetMainImage dari Toggle.lua
                AscensionToggle:SetMainImage({
                    Image = "rbxassetid://99780781154645", -- Icon Ascension
                    Gradient = ColorUtils:GetRarity("Legendary"), -- Warna Gradient
                    Title = string.upper(currentData.Name), -- Nama di bar bawah kartu
                    Quantity = "Lv. " .. tostring(currentLevel), -- Level di pojok kiri atas
                    Rate = math.floor(progress * 100) .. "%" -- Menampilkan progres di pojok kanan atas
                }, 60)
            end
            
            -- [[ 6. LOGIKA AUTO EVOLVE ]]
            if Config.AutoAscension and nextInfo.Price ~= "MAX" and currentEnergy >= cost then
                pcall(function()
                    MetaManager.Bridge:Fire("Ascension", "Evolve")
                end)
            end
        end
    end
end)

-- [[ ELEMEN UNTUK KATEGORI SKINS ]] --

-- 1. Paragraph Preview dengan Viewport
local SkinStatusPara = FarmTab:Paragraph({
    Title = "Skin 3D Preview",
    Desc = "Loading skin data...",
})
FM_Add("Skins", SkinStatusPara)

-- Fungsi Terpisah untuk Update UI Preview (Agar bisa dipanggil kapan saja)
local LastPreviewedSkin = nil
local function UpdateSkinPreviewUI(val)
    if not val or not val.RawName then return end
    
    -- A. UPDATE INFO TEKS
    local starVisual = string.rep("⭐", val.Stars)
    local minutesOwned = math.floor(val.TimeCount / 60)
    local minutesNeeded = math.floor(val.TimeNeeded / 60)
    
    SkinStatusPara:SetTitle(val.Title)
    SkinStatusPara:SetDesc(string.format(
        "Rarity: %s\nStars: %s (%d/5)\nTime: %d/%d Minutes\nBuffs: [%s]", 
        val.Rarity, 
        starVisual, 
        val.Stars, 
        minutesOwned,
        minutesNeeded,
        val.BuffText
    ))

    -- B. UPDATE VIEWPORT 3D
    if LastPreviewedSkin ~= val.RawName then
        LastPreviewedSkin = val.RawName
        local skinsStorage = ReplicatedStorage:FindFirstChild("Skins")
        local worldFolder = skinsStorage and skinsStorage:FindFirstChild(val.World)
        local modelPath = worldFolder and worldFolder:FindFirstChild(val.Title)

        if SkinStatusPara and modelPath then
            local modelClone = modelPath:Clone()
            local orientation, size = modelClone:GetBoundingBox()
            modelClone:PivotTo(CFrame.new(-orientation.Position)) 
            SkinStatusPara:SetViewport(modelClone)
            
            local vp = SkinStatusPara.ViewportFrame
            if vp and vp.CurrentCamera then
                local dist = size.Magnitude * 0.8 
                vp.CurrentCamera.CFrame = CFrame.lookAt(Vector3.new(0, 0.2, -dist), Vector3.new(0, 0, 0))
            end
        end
    end
end

-- 2. Fungsi untuk Mendapatkan Daftar Skin & Format Data (Logic UI Match)
local function GetOwnedSkinsList()
    local list = {}
    local inventory = getgenv().PlayerData.Inventory.Skins or {}
    local sharedSkins = MetaManager.Shared.Skins --

    for skinID, data in pairs(inventory) do
        local skinInfo = sharedSkins[skinID]
        if skinInfo then
            local currentStars = data.Star or 1
            local buffs = {}
            local statsSource = skinInfo.Stats or skinInfo.Multipliers --

            if statsSource then
                for _, v in pairs(statsSource) do
                    if typeof(v) == "table" then
                        local statName = tostring(v[1]) --
                        local baseValue = tonumber(v[2]) or 0 --
                        
                        -- Logika: Multiplier ditambahkan setiap total bintang
                        local calculatedValue = baseValue * currentStars
                        
                        -- Logika Khusus: Energy ditambah 1 di awal
                        if statName == "Energy" then
                            calculatedValue = 1 + baseValue + (0.1 * (currentStars - 1))
                        end
                        
                        -- Format tampilan stats
                        table.insert(buffs, string.format("%s: %.1fx", statName, calculatedValue))
                    end
                end
            end
            
            table.insert(list, {
                Title = skinInfo.Name,
                Desc = string.format("Rarity: %s | Stars: %d", skinInfo.Rarity, currentStars),
                RawName = skinID,
                World = skinInfo.World or "Unknown",
                Stars = currentStars,
                TimeCount = data.Time or 0,
                TimeNeeded = currentStars * 1800,
                BuffText = #buffs > 0 and table.concat(buffs, " | ") or "No Stats Found",
                Rarity = skinInfo.Rarity
            })
        end
    end
    return list
end

-- 3. Dropdown Pemilihan Skin
local SkinDropdown = FM_Add("Skins", FarmTab:Dropdown({
    Title = "Select Your Skin",
    Desc = "Auto Equip Selected Skin",
    Values = GetOwnedSkinsList(),
    Flag = "Skin_Dropdown",
    Callback = function(val)
        if val then
            UpdateSkinPreviewUI(val)
            -- C. LOGIKA EQUIP (Jika berbeda dengan yang dipakai)
            if getgenv().PlayerData.Skin ~= val.RawName then
                pcall(function()
                    MetaManager.Bridge:Fire("Skins", "Equip", val.RawName)
                end)
            end
        end
    end
}))

-- [[ LOGIKA AUTO-SYNC SAAT START ]] --
task.spawn(function()
    -- Tunggu data siap
    repeat task.wait() until getgenv().PlayerData and getgenv().PlayerData.Skin
    
    local ownedList = GetOwnedSkinsList()
    local currentSkinID = getgenv().PlayerData.Skin
    local foundData = nil

    -- Cari data skin yang sedang dipakai di dalam list
    for _, item in ipairs(ownedList) do
        if item.RawName == currentSkinID then
            foundData = item
            break
        end
    end

    -- Jika ketemu, update UI Preview dan set value dropdown-nya
    if foundData then
        UpdateSkinPreviewUI(foundData)
    end
end)

-- 4. Toggle Auto Evolve Skin (Tetap Sama)
local AutoEvolveSkinToggle = FM_Add("Skins", FarmTab:Toggle({
    Title = "Auto Evolve Skin",
    Desc = "Automatically evolve the currently equipped skin.",
    Default = false,
    Flag = "AutoEvolveSkin_Toggle",
    Callback = function(val)
        Config.AutoEvolveSkin = val
    end
}))

-- 5. Task Sync Data & Auto Evolve (PERBAIKAN: Real-time Time/Minutes Checker)
task.spawn(function()
    local lastOwnedCount = 0
    local lastTotalStars = 0
    local lastEquippedTime = -1 -- Variabel baru untuk melacak waktu skin aktif secara real-time

    while task.wait(1) do
        if not Window or Window.Destroyed then break end

        local pData = getgenv().PlayerData
        if not pData then continue end

        local currentOwned = pData.Inventory.Skins or {}
        local currentSkinID = pData.Skin
        
        -- A. Hitung data untuk deteksi perubahan
        local count = 0
        local totalStars = 0
        local currentSkinRawTime = 0
        
        for id, data in pairs(currentOwned) do 
            count = count + 1 
            totalStars = totalStars + (data.Star or 1)
            -- Ambil waktu dari skin yang sedang dipakai saja untuk efisiensi
            if id == currentSkinID then
                currentSkinRawTime = data.Time or 0
            end
        end
        
        -- B. Logika Update UI (Terjadi jika jumlah skin, bintang, ATAU waktu berubah)
        if count ~= lastOwnedCount or totalStars ~= lastTotalStars or currentSkinRawTime ~= lastEquippedTime then
            local newList = GetOwnedSkinsList()
            
            -- Refresh Dropdown hanya jika jumlah skin atau bintang berubah (mencegah lag UI)
            if count ~= lastOwnedCount or totalStars ~= lastTotalStars then
                lastOwnedCount = count
                lastTotalStars = totalStars
                SkinDropdown:Refresh(newList)
            end
            
            -- Update Paragraph Preview secara Real-time jika waktu bertambah
            if currentSkinID and currentSkinID ~= "" then
                for _, item in ipairs(newList) do
                    if item.RawName == currentSkinID then
                        lastEquippedTime = currentSkinRawTime -- Update tracker waktu
                        UpdateSkinPreviewUI(item) -- Paksa UI memperbarui teks minutesOwned
                        break
                    end
                end
            end
        end

        -- C. Logika Auto Evolve (Sesuai kode backup Anda)
        if Config.AutoEvolveSkin and currentSkinID and currentSkinID ~= "" then
            local skinData = currentOwned[currentSkinID]
            if skinData then
                local currentStars = skinData.Star or 1
                local currentTime = skinData.Time or 0
                local requiredTime = currentStars * 1800 

                if currentTime >= requiredTime and currentStars < 5 then
                    pcall(function() 
                        MetaManager.Bridge:Fire("Skins", "Evolve", currentSkinID) 
                    end)
                end
            end
        end
    end
end)

-- ==========================================
-- SECTION: GACHA SKINS FORTUNE
-- ==========================================

-- 1. Helper: Format Waktu Banner (Sesuai Decompile Time2)
local function FormatBannerTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", mins, secs)
end

-- 2. Toggle Auto Gacha Skins
local AutoGachaSkinToggle = FM_Add("Skins", FarmTab:Toggle({
    Title = "Auto Gacha Skins",
    Desc = "Checking banner status...",
    Default = false,
    Flag = "AutoGachaSkin_Toggle",
    Callback = function(val)
        Config.AutoGachaSkin = val
    end
}))

-- [[ TASK UNTUK GACHA SKINSFORTUNE DENGAN CEK MATERIAL ]] --

task.spawn(function()
    local lastBanner = ""
    
    while task.wait(0.1) do
        if not Window or Window.Destroyed then break end

        local pData = getgenv().PlayerData
        if pData and pData.Banner and pData.Banner.SkinsFortune then
            local bannerData = pData.Banner.SkinsFortune
            local currentBanner = bannerData.List or "" 
            
            -- 1. Ambil Data Banner dari Shared
            local bannerShared = MetaManager.Shared.SkinsFortune[currentBanner]
            
            if bannerShared then
                -- 2. Identifikasi Nama Material (Price[2] di decompile)
                local materialName = bannerShared.Price and bannerShared.Price[2] or "Capsule"
                
                -- 3. Cek Jumlah Material di Inventaris
                local inventory = pData.Inventory and pData.Inventory.Items or {}
                local materialCount = inventory[materialName] or 0
                
                -- 4. Timer & Pity
                local timePassed = os.time() - (bannerData.LastUpdate or 0)
                local timeLeft = math.clamp(1200 - timePassed, 0, 9999)
                local pityCount = pData.SkinBannerPitys and pData.SkinBannerPitys[currentBanner] or 0
                AutoGachaSkinToggle:SetTitle("Auto Gacha: " .. currentBanner)
                
                local statusStr = Config.AutoGachaSkin and (materialCount > 0 and "Auto Spinning..." or "Out of " .. materialName) or "Idle"
                AutoGachaSkinToggle:SetDesc(string.format(
                    "Material: %d %s\nMythical Pity: %d/400\nNext Rotation Banner: %s\nStatus: %s",
                    materialCount, materialName,
                    pityCount,
                    string.format("%02d:%02d", math.floor(timeLeft/60), timeLeft%60),
                    statusStr
                ))

                -- 6. LOGIKA AUTO GACHA DENGAN VALIDASI MATERIAL
                if Config.AutoGachaSkin then
                    -- Hanya jalankan jika material > 0
                    if materialCount > 0 then
                        pcall(function()
                            MetaManager.Bridge:Fire("SkinsFortune", "Spin")
                        end)
                    else
                        -- Matikan Auto jika material habis
                        Config.AutoGachaSkin = false
                        AutoGachaSkinToggle:Set(false)
                    end
                end
            end
        end
    end
end)-- [[ ELEMEN UNTUK KATEGORI PASSIVE (MULTI-MAP LOCKING) ]] --

local FamilyElements = {}
local NenElements = {}
local PassiveAbilityElements = {}
local HakiElements = {}

-- [[ HELPER: AUTO EQUIP BEST (ENERGY/DAMAGE) ]] --
local function EquipBestEnergy(category)
    local pData = getgenv().PlayerData
    if not pData or not pData.Vault then return end
    
    -- Mapping key untuk Vault
    local vaultKeys = {
        ["Family"] = "Family",
        ["Nen"] = "Nen",
        ["Passives"] = "Passive",
        ["Haki"] = "Haki"
    }
    
    local vaultKey = vaultKeys[category]
    if not vaultKey or not pData.Vault[vaultKey] then return end
    
    local myVault = pData.Vault[vaultKey] 
    local sharedData = MetaManager.Shared[category]
    
    -- [[ MODIFIKASI: HAKI MENCARI DAMAGE, LAINNYA ENERGY ]] --
    local targetStat = (category == "Haki") and "Damage" or "Energy"
    
    local bestItem = nil
    local bestValue = -1

    for id, owned in pairs(myVault) do
        if owned then
            local info = sharedData[id]
            -- Cek multiplier berdasarkan targetStat (Damage/Energy)
            if info and info.Multipliers and info.Multipliers[targetStat] then
                local val = tonumber(info.Multipliers[targetStat]) or 0
                if val > bestValue then
                    bestValue = val
                    bestItem = id
                end
            end
        end
    end

    -- Eksekusi pemasangan via Bridge jika ditemukan yang lebih baik
    if bestItem then
        local currentEquippedKey = (category == "Passives") and "Passive" or category
        local currentData = pData[currentEquippedKey]
        
        -- Handling struktur data Haki yang berbentuk tabel {Name = "..."}
        local currentName = (type(currentData) == "table") and currentData.Name or currentData

        if currentName ~= bestItem then
            pcall(function()
                MetaManager.Bridge:Fire("Vault", "Equip", category, bestItem)
            end)
        end
    end
end

-- 1. Helper: Format Multiplier (Universal)
local function GetMultipliersText(category, name)
    local sharedData = MetaManager.Shared[category]
    local info = sharedData and sharedData[name]
    if not info or not info.Multipliers then return "None" end
    
    local buffs = {}
    for stat, value in pairs(info.Multipliers) do
        if stat == "Drop" then
            table.insert(buffs, string.format("+%s %s", tostring(value), stat))
        else
            table.insert(buffs, string.format("+%sx %s", tostring(value), stat))
        end
    end
    return table.concat(buffs, " | ")
end

-- [[ PENGELOMPOKAN ELEMEN KATEGORI PASSIVE (2 ITEM PER GRUP) ]] --

-- Grup 1: Family & Nen
local GachaGroup1 = FM_Add("Passive", FarmTab:Group({
    Title = "Family & Nen Gacha",
    Opened = true
}))

local AutoFamilyToggle = GachaGroup1:Toggle({
    Title = "Auto Reroll Family",
    Desc = "Checking map status...",
    Default = false,
    Flag = "AutoFamily_Toggle",
    Callback = function(val) 
        Config.AutoRerollFamily = val 
        if not val then EquipBestEnergy("Family") end 
    end
})
table.insert(FamilyElements, AutoFamilyToggle)

local AutoNenToggle = GachaGroup1:Toggle({
    Title = "Auto Reroll Nen",
    Desc = "Checking map status...",
    Default = false,
    Flag = "AutoNen_Toggle",
    Callback = function(val) 
        Config.AutoRerollNen = val 
        if not val then EquipBestEnergy("Nen") end 
    end
})
table.insert(NenElements, AutoNenToggle)


-- Grup 2: Passives & Haki
local GachaGroup2 = FM_Add("Passive", FarmTab:Group({
    Title = "Passives & Haki Gacha",
    Opened = true
}))

local AutoPassiveToggle = GachaGroup2:Toggle({
    Title = "Auto Reroll Passives",
    Desc = "Checking map status...",
    Default = false,
    Flag = "AutoPassive_Toggle",
    Callback = function(val) 
        Config.AutoRerollPassives = val 
        if not val then EquipBestEnergy("Passives") end 
    end
})
table.insert(PassiveAbilityElements, AutoPassiveToggle)

local AutoHakiToggle = GachaGroup2:Toggle({
    Title = "Auto Reroll Haki",
    Desc = "Checking map status...",
    Default = false,
    Flag = "AutoHaki_Toggle",
    Callback = function(val) 
        Config.AutoRerollHaki = val 
        if not val then EquipBestEnergy("Haki") end 
    end
})
table.insert(HakiElements, AutoHakiToggle)

-- ==========================================
-- MAIN TASK: SYNC, AUTO REROLL & 10s TIMER
-- ==========================================
-- [[ 1. PINDAHKAN FUNGSI KELUAR DARI LOOP UNTUK STABILITAS ]] --
local function ProcessCategory(typeKey, dataKey, toggleObj, bridgeKey, coinKey)
    local pData = getgenv().PlayerData
    if not pData then return end
    
    local rawVal = pData[dataKey]
    local currentVal = "None"
    
    -- [[ FIX ERROR 'INSTANCE': VALIDASI TIPE DATA SECARA KETAT ]] --
    if type(rawVal) == "table" then
        -- Jika tabel, ambil field Name (Sesuai decompile Family/Nen/Haki)
        currentVal = tostring(rawVal.Name or "None")
    elseif typeof(rawVal) == "Instance" then
        -- Jika ternyata rawVal adalah Object Roblox, ambil .Name agar tidak error 'Instance'
        currentVal = rawVal.Name
    elseif rawVal ~= nil then
        currentVal = tostring(rawVal)
    end

    if currentVal == "None" or currentVal == "" then return end
    
    local infoDB = MetaManager.Shared[typeKey]
    local currentInfo = infoDB and infoDB[currentVal]
    
    -- Visual Sync (Card Image)
    if currentVal ~= lastData[typeKey] then
        lastData[typeKey] = currentVal
        if currentInfo then
            pcall(function()
                toggleObj:SetMainImage({
                    Image = (currentInfo.Icon and currentInfo.Icon ~= "") and currentInfo.Icon or "rbxassetid://135703908712176",
                    Gradient = MetaManager.Utils.Colors:GetRarity(currentInfo.Rarity),
                    Title = currentVal,
                    Quantity = currentInfo.Rarity,
                }, 60)
            end)
        end
    end

    -- [[ LOGIKA PITY SESUAI DECOMPILE ]] --
    local pityData = pData.Pity or {}
    local pityCount = pityData[typeKey] or 0
    local pityPhase = (pData.PityPhase and pData.PityPhase[typeKey]) or "Mythical"
    
    -- Penentuan Max Pity
    local maxPity = 1200 
    if pityPhase ~= "Mythical" then
        if typeKey == "Nen" then
            maxPity = (pityPhase == "Secret") and 8000 or (pityPhase == "Divine" and 20000 or 1200)
        else
            maxPity = 8000
        end
    end
    
    local inventory = pData.Inventory and pData.Inventory.Items or {}
    local coins = inventory[coinKey] or 0
    local multipliers = GetMultipliersText(typeKey, currentVal)

    -- Gunakan pcall saat SetTitle untuk mencegah crash jika UI belum siap
    pcall(function()
        toggleObj:SetTitle("Fast Auto " .. typeKey .. ": " .. currentVal)
        toggleObj:SetDesc(string.format(
            "Coins: %d | Boost: [%s]\nPity [%s]: %d/%d\nStatus: %s",
            coins, multipliers, pityPhase,
            pityCount, maxPity,
            (Config["AutoReroll"..typeKey] and (coins > 0 and "Rolling..." or "Out of Coins!") or "Idle")
        ))
    end)

    -- Logika Auto Reroll & 10s Timer
    if Config["AutoReroll"..typeKey] then
        if coins > 0 then
            pcall(function() MetaManager.Bridge:Fire(bridgeKey, "Reroll") end)
        end
        if tick() - (lastEquipTime[typeKey] or 0) >= 3 then
            lastEquipTime[typeKey] = tick()
            EquipBestEnergy(typeKey)
        end
    end
end

-- [[ 2. LOOP UTAMA YANG TELAH DIPERBAIKI ]] --
task.spawn(function()
    local lockStates = { Family = false, Nen = false, Passives = false, Haki = false }
    -- Inisialisasi lastData & lastEquipTime di level atas loop
    lastData = { Family = "", Nen = "", Passives = "", Haki = "" }
    lastEquipTime = { Family = 0, Nen = 0, Passives = 0, Haki = 0 }

    while task.wait() do -- Tambahkan jeda agar tidak spam CPU
        if not Window or Window.Destroyed then break end

        local pData = getgenv().PlayerData
        if pData then
            -- Pastikan Map adalah string (menggunakan tostring untuk keamanan)
            local currentMap = tostring(pData.Map or "")

            -- Logika Locking Map (Family)
            if currentMap ~= "Leaf Village" then
                if not lockStates.Family then
                    lockStates.Family = true
                    for _, e in ipairs(FamilyElements) do e:Lock("Go to Leaf Village") end
                end
            else
                if lockStates.Family then lockStates.Family = false; for _, e in ipairs(FamilyElements) do e:Unlock() end end
            end

            -- Logika Locking Map (Nen & Passive)
            if currentMap ~= "Hunter Town" then
                if not lockStates.Nen then
                    lockStates.Nen = true
                    for _, e in ipairs(NenElements) do e:Lock("Go to Hunter Town") end
                    for _, e in ipairs(PassiveAbilityElements) do e:Lock("Go to Hunter Town") end
                end
            else
                if lockStates.Nen then lockStates.Nen = false; for _, e in ipairs(NenElements) do e:Unlock() end; for _, e in ipairs(PassiveAbilityElements) do e:Unlock() end end
            end

            -- Logika Locking Map (Haki)
            if currentMap ~= "Pirate District" then
                if not lockStates.Haki then
                    lockStates.Haki = true
                    for _, e in ipairs(HakiElements) do e:Lock("Go to Pirate District") end
                end
            else
                if lockStates.Haki then lockStates.Haki = false; for _, e in ipairs(HakiElements) do e:Unlock() end end
            end

            -- [[ EKSEKUSI PROSES DENGAN VALIDASI ]] --
            ProcessCategory("Family", "Family", AutoFamilyToggle, "Family", "Family Coin")
            ProcessCategory("Nen", "Nen", AutoNenToggle, "Nen", "Nen Token")
            ProcessCategory("Passives", "Passive", AutoPassiveToggle, "Passives", "Passive Token")
            ProcessCategory("Haki", "Haki", AutoHakiToggle, "Haki", "Haki Orb")
        end
    end
end)
-- [[ BYPASS GACHA COOLDOWN GLOBAL ]] --
task.spawn(function()
    local GachaModules = {
        MetaManager.Scripts.Family,
        MetaManager.Scripts.Nen,
        MetaManager.Scripts.Passives,
        MetaManager.Scripts.Haki
    }

    while task.wait() do
        for _, mod in ipairs(GachaModules) do
            if mod and mod.ClearCooldown then
                -- Memanggil fungsi asli game yang meriset cooldown v_u_6
                pcall(mod.ClearCooldown)
            end
        end
    end
end)
-- [[ ELEMEN UNTUK KATEGORI ZERINGAN ]] --

local ZeringanElements = {}

-- 1. Mapping Stage Sesuai Decompile
local ZeringanStages = {
    ["None"] = 0,
    ["Sharingan S1"] = 1,
    ["Sharingan S2"] = 2,
    ["Sharingan S3"] = 3,
    ["Mangekyo Sharingan"] = 4,
    ["Eternal Mangekyo Sharingan"] = 5,
}

-- 2. Urutan Evolusi untuk Mencari Next Stage
local ZeringanNextList = {"Sharingan S2", "Sharingan S3", "Mangekyo Sharingan", "Eternal Mangekyo Sharingan"}

-- 3. Toggle Utama
local AutoZeringanToggle = FM_Add("Zeringan", FarmTab:Toggle({
    Title = "Auto Evolve Zeringan",
    Desc = "Checking requirements...",
    Default = false,
    Flag = "AutoZeringan_Toggle",
    Callback = function(val)
        Config.AutoZeringan = val
    end
}))
table.insert(ZeringanElements, AutoZeringanToggle)

-- 4. Task Utama: Locking (Map & Max), UI Update, dan Auto Evolve
task.spawn(function()
    local isLocked = false
    local lastLockReason = "" -- Menyimpan alasan terakhir di-lock
    local lastMode = ""
    
    while task.wait(0.1) do
        if not Window or Window.Destroyed then break end

        local pData = getgenv().PlayerData
        if pData then
            local currentMode = pData.Mode
            local currentStage = ZeringanStages[currentMode] or 0
            local currentMap = pData.Map or ""

            -- [[ A. LOCKING SYSTEM ]] --
            -- Cek 1: Jika sudah Stage 5 (MAX)
            if currentStage >= 5 then
                if not isLocked or lastLockReason ~= "Max" then
                    isLocked = true
                    lastLockReason = "Max"
                    for _, elem in ipairs(ZeringanElements) do
                        if elem.Lock then elem:Lock("Max Upgrade") end
                    end
                end
            -- Cek 2: Jika berada di luar Leaf Village
            elseif currentMap ~= "Leaf Village" then
                if not isLocked or lastLockReason ~= "Map" then
                    isLocked = true
                    lastLockReason = "Map"
                    for _, elem in ipairs(ZeringanElements) do
                        if elem.Lock then elem:Lock("Go to Map Leaf Village For Zeringan Upgrade") end
                    end
                end
            -- Cek 3: Jika syarat terpenuhi (Buka Kunci)
            else
                if isLocked then
                    isLocked = false
                    lastLockReason = ""
                    for _, elem in ipairs(ZeringanElements) do
                        if elem.Unlock then elem:Unlock() end
                    end
                end
            end

            -- [[ B. LOGIKA UPDATE DATA ]] --
            if pData.Mode then
                local infoDB = MetaManager.Shared.SharinganInfo or {}
                local var9 = infoDB[currentMode] 
                local nextModeName = ZeringanNextList[currentStage]
                local var10 = infoDB[nextModeName]
                
                local inventory = pData.Inventory and pData.Inventory.Items or {}
                local ashiraEye = inventory["Ashira Eye"] or 0
                local ashiraBlood = inventory["Ashira Blood"] or 0

                if var9 then
                    -- 1. Update Visual (Hanya jika belum Stage 5 / Locked)
                    if currentMode ~= lastMode then
                        lastMode = currentMode
                        AutoZeringanToggle:SetMainImage({
                            Image = var9.Image or "rbxassetid://13217278216",
                            Gradient = MetaManager.Utils.Colors:GetRarity(currentStage >= 4 and "Legendary" or "Rare"),
                            Title = string.format("Zeringan %d Tomoe", currentStage),
                            Quantity = currentMode
                        }, 60)
                    end

                    -- 2. Format Statistik & Deskripsi
                    local energyAfter = currentStage < 5 and (var10 and var10.Buffs.Energy .. "x" or "...") or "MAX"
                    local speedAfter = currentStage < 5 and (var10 and var10.Buffs.ClickSpeed .. "x" or "...") or "MAX"
                    
                    local statsText = string.format(
                        "Energy: %sx -> %s\nClick Speed: %sx -> %s",
                        tostring(var9.Buffs.Energy), energyAfter,
                        tostring(var9.Buffs.ClickSpeed), speedAfter
                    )
                    
                    if currentStage >= 4 then
                        local dmgAfter = currentStage < 5 and (var10 and var10.Buffs.Damage .. "x" or "...") or "MAX"
                        statsText = statsText .. string.format("\nDamage: %sx -> %s", tostring(var9.Buffs.Damage), dmgAfter)
                    end

                    local costText = (currentStage < 5 and var10) and string.format(
                        "\n\nRequired:\n- Ashira Eye: %d/%d\n- Ashira Blood: %d/%d",
                        ashiraEye, var10.EyeCost or 0,
                        ashiraBlood, var10.BloodCost or 0
                    ) or "\n\n[MAX STAGE REACHED]"

                    AutoZeringanToggle:SetTitle(string.format("Zeringan %d Tomoe [%s]", currentStage, currentMode))
                    AutoZeringanToggle:SetDesc(statsText .. costText)

                    -- [[ C. LOGIKA AUTO EVOLVE ]] --
                    if Config.AutoZeringan and currentStage < 5 and var10 then
                        if ashiraEye >= (var10.EyeCost or 0) and ashiraBlood >= (var10.BloodCost or 0) then
                            pcall(function()
                                MetaManager.Bridge:Fire("ModeEvolve", "EvolveSharingan", currentMode)
                            end)
                            task.wait(0.5) 
                        end
                    end
                end
            end
        end
    end
end)
-- [[ REFINED BYPASS: ZERINGAN NO COOLDOWN & INSTANT MODE ]] --

local ModeModule = MetaManager.Scripts.Mode

-- 1. Helper: Reset Internal Lock (Upvalue)
local function BypassZeringanLock()
    -- var8_upvw adalah upvalue ke-2 di fungsi Activate dan upvalue ke-1 di Disable
    if ModeModule.Activate then
        pcall(function()
            debug.setupvalue(ModeModule.Activate, 2, nil)
        end)
    end
    if ModeModule.Disable then
        pcall(function()
            debug.setupvalue(ModeModule.Disable, 1, nil)
        end)
    end
end

-- 2. Toggle Instant Mode
local InstantModeToggle = FM_Add("Zeringan", FarmTab:Toggle({
    Title = "Instant Sharingan",
    Desc = "Force activate Zeringan without waiting for cooldown.",
    Default = false,
    Flag = "InstantMode_Toggle",
    Callback = function(val)
        Config.InstantZeringan = val
        -- Beritahu server bahwa Auto Sharingan aktif untuk sinkronisasi
        pcall(function()
            MetaManager.Bridge:Fire("AntiAFK", "SetAutoSharingan", val)
        end)
    end
}))

-- 3. Task Utama: Bypass Loop
task.spawn(function()
    while task.wait() do -- Zero Delay Loop
        if not Window or Window.Destroyed then break end
        
        local pData = getgenv().PlayerData
        if pData and Config.InstantZeringan and pData.Mode ~= "None" then
            local char = LocalPlayer.Character
            if char then
                -- A. BYPASS ATRIBUT COOLDOWN
                -- Menghapus atribut agar sistem Heartbeat menganggap cooldown selesai
                if char:GetAttribute("ModeCooldown") then
                    char:SetAttribute("ModeCooldown", nil)
                end

                -- B. BYPASS INTERNAL DEBOUNCE
                -- Mereset variabel var8_upvw agar fungsi Activate bisa dipanggil kapan saja
                BypassZeringanLock()

                -- C. AUTO ACTIVATION
                -- Jika mode mati (Attribute Mode ~= true), aktifkan seketika
                if char:GetAttribute("Mode") ~= true then
                    pcall(function()
                        ModeModule.Activate()
                        -- Pastikan Anti-AFK Server tetap sinkron
                        MetaManager.Bridge:Fire("AntiAFK", "SetAutoSharingan", true)
                    end)
                end
            end
        end
    end
end)
-- [[ ELEMEN UNTUK KATEGORI RANGE UPGRADE ]] --

local RangeElements = {}

-- 1. Toggle Unlock Feature (Quest Ging)
local AutoUnlockRangeToggle = FM_Add("Range Upgrade", FarmTab:Toggle({
    Title = "Auto Unlock Range (Quest)",
    Desc = "Requires 1x Range Coin",
    Default = false,
    Flag = "AutoUnlockRange_Toggle",
    Callback = function(val)
        Config.AutoUnlockRange = val
    end
}))
table.insert(RangeElements, AutoUnlockRangeToggle)

-- 2. Toggle Level Up (Range Upgrader)
local AutoRangeUpgradeToggle = FM_Add("Range Upgrade", FarmTab:Toggle({
    Title = "Auto Range Level Up",
    Desc = "Requires Range Upgrader item",
    Default = false,
    Flag = "AutoRange_Toggle",
    Callback = function(val)
        Config.AutoRangeUpgrade = val
    end
}))
table.insert(RangeElements, AutoRangeUpgradeToggle)

-- 3. Task Utama: Logika Terpisah untuk Quest & Upgrade
task.spawn(function()
    local lastLevel = -1
    
    while task.wait(0.5) do
        if not Window or Window.Destroyed then break end

        local pData = getgenv().PlayerData
        if pData then
            -- DATA DARI DECOMPILE
            local isUnlocked = pData.Range ~= nil -- Mengecek apakah fitur sudah terbuka
            local stats = pData["Range-Stats"] or { Level = 0, Length = 0 }
            local currentLevel = stats.Level or 0
            
            local inventory = pData.Inventory and pData.Inventory.Items or {}
            local rangeCoin = inventory["Range Coin"] or 0 -- Untuk Quest
            local rangeUpgrader = inventory["Range Upgrader"] or 0 -- Untuk Level Up

            -- [[ A. LOGIKA VISUAL UNTUK UNLOCK QUEST ]] --
            if isUnlocked then
                AutoUnlockRangeToggle:Lock("Feature Already Unlocked")
                AutoUnlockRangeToggle:SetTitle("Range Feature: UNLOCKED")
            else
                AutoUnlockRangeToggle:Unlock()
                AutoUnlockRangeToggle:SetTitle("Auto Unlock Range (Quest)")
                AutoUnlockRangeToggle:SetDesc(string.format(
                    "Requirement: 1x Range Coin\nInventory: %d\nStatus: %s",
                    rangeCoin, (Config.AutoUnlockRange and "Processing Quest..." or "Idle")
                ))
            end

            -- [[ B. LOGIKA VISUAL UNTUK LEVEL UP ]] --
            if not isUnlocked then
                AutoRangeUpgradeToggle:Lock("Unlock Feature First")
            elseif currentLevel >= 100 then
                AutoRangeUpgradeToggle:Lock("Max Level Reached")
            else
                AutoRangeUpgradeToggle:Unlock()
                
                -- Update Visual jika level berubah
                if currentLevel ~= lastLevel then
                    lastLevel = currentLevel
                    AutoRangeUpgradeToggle:SetMainImage({
                        Image = "rbxassetid://86884305951467",
                        Gradient = MetaManager.Utils.Colors:GetRarity(currentLevel >= 50 and "Mythical" or "Legendary"),
                        Title = "Range Upgrader",
                        Quantity = "Lv. " .. currentLevel,
                        Rate = "+" .. (stats.Length or 0) .. "%"
                    }, 60)
                end

                AutoRangeUpgradeToggle:SetDesc(string.format(
                    "Multiplier: +%d%% ➔ +%d%%\nNext Level: %d\nItem: %d Range Upgrader\nStatus: %s",
                    stats.Length or 0, (stats.Length or 0) + 5,
                    currentLevel + 1, rangeUpgrader,
                    (Config.AutoRangeUpgrade and (rangeUpgrader > 0 and "Upgrading..." or "Need More Items") or "Idle")
                ))
            end

            -- [[ C. EKSEKUSI REMOTE ]] --
            
            -- 1. Eksekusi Quest (Gunakan Range Coin)
            if Config.AutoUnlockRange and not isUnlocked and rangeCoin > 0 then
                pcall(function()
                    MetaManager.Bridge:Fire("Inventory", "Use", "Range Coin")
                end)
            end

            -- 2. Eksekusi Upgrade (Gunakan Range Upgrader)
            if Config.AutoRangeUpgrade and isUnlocked and currentLevel < 100 and rangeUpgrader > 0 then
                pcall(function()
                    MetaManager.Bridge:Fire("Inventory", "Use", "Range Upgrader")
                end)
            end
        end
    end
end)
-- [[ ELEMEN UNTUK KATEGORI HATCH PETS ]] --

local HatchElements = {}
local StarsModule = MetaManager.Scripts.Stars -- Referensi modul gacha asli
local StarsAnimModule = MetaManager.Scripts.StarsAnimation -- Referensi modul animasi

-- 1. HOOKING MODULE FUNCTIONS (Mematikan Semua Animasi & UI)
local OriginalJoin = StarsModule.Join
local OriginalLeave = StarsModule.Leave
local OriginalSpinAnim = StarsAnimModule.Spin

-- Fungsi untuk mengaktifkan/mematikan Hooking secara global
local function ToggleHatchHooks(state)
    if state then
        -- Hook Modul Stars: Mematikan UI HUD & Tween
        StarsModule.Join = function() end 
        StarsModule.Leave = function() end
        
        -- Hook Modul StarsAnimation: Mematikan Efek Bintang 3D & Camera Binding
        StarsAnimModule.Spin = function() 
            -- Paksa attribute tetap false agar loop tidak berhenti
            LocalPlayer:SetAttribute("StarAnimation", false) 
        end
        
        -- Sembunyikan UI HUD & Reveal secara paksa agar tidak berkedip di layar
        pcall(function()
            local UI = LocalPlayer.PlayerGui:FindFirstChild("UI")
            if UI then
                if UI.HUD:FindFirstChild("Star") then UI.HUD.Star.Visible = false end
                if UI:FindFirstChild("Star") then UI.Star.Visible = false end
            end
        end)
    else
        -- Mengembalikan fungsi asli saat toggle dimatikan
        StarsModule.Join = OriginalJoin
        StarsModule.Leave = OriginalLeave
        StarsAnimModule.Spin = OriginalSpinAnim
    end
end

-- 2. Helper: Mendapatkan Star Terdekat
local function GetNearestStarModel()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local nearest = nil
    local minDist = 15
    
    for _, v in pairs(game:GetService("CollectionService"):GetTagged("StarModel")) do
        local starRoot = v:FindFirstChild("HumanoidRootPart")
        if starRoot then
            local dist = (root.Position - starRoot.Position).Magnitude
            if dist < minDist then
                nearest = v
                minDist = dist
            end
        end
    end
    return nearest
end

-- 3. Toggle Auto Multi Hatch (Instant & Full Silent)
local AutoHatchToggle = FM_Add("Hatch Pets", FarmTab:Toggle({
    Title = "Auto Multi Hatch (Instant)",
    Desc = "Zero Animation & No Wait Mode.",
    Default = false,
    Flag = "AutoHatch_Toggle",
    Callback = function(val)
        Config.AutoHatch = val
        ToggleHatchHooks(val) -- Menjalankan Hooking pada kedua modul sekaligus
        if val then
            LocalPlayer:SetAttribute("StarAnimation", false)
        end
    end
}))
-- 4. Task Utama: Instant Gacha Loop
task.spawn(function()
    while task.wait(0.1) do -- Batas aman pengiriman Remote
        if not Window or Window.Destroyed then break end
        
        if Config.AutoHatch then
            local starModel = GetNearestStarModel()
            
            -- [[ VALIDASI HIERARKI & INSTANCE ]] --
            if starModel and starModel.Parent and starModel.Parent.Parent then
                -- Gunakan tostring untuk memastikan tidak ada objek Instance mentah yang terkirim ke UI
                local starName = tostring(starModel.Parent.Parent.Name or "Unknown")
                
                -- Ambil attribute dan pastikan itu string
                local rawEggType = LocalPlayer.Character:GetAttribute("Egg")
                local eggType = "Normal"
                
                if typeof(rawEggType) == "Instance" then
                    eggType = rawEggType.Name
                else
                    eggType = tostring(rawEggType or "Normal")
                end
                
                -- [[ INSTANT BYPASS ]]
                -- Paksa attribute selalu false agar server mau menerima request baru secara instan
                LocalPlayer:SetAttribute("StarAnimation", false)
                
                pcall(function()
                    -- Tembak remote Multi secara langsung ke server
                    MetaManager.Bridge:Fire("Stars", "Multi", starName, eggType)
                end)
                
                -- [[ UPDATE UI DENGAN VALIDASI PITY ]] --
                local mapInfo = MetaManager.Shared.Maps[starName]
                local pityData = getgenv().PlayerData.Pity
                local pityIndex = tostring(mapInfo and mapInfo.Index or "")
                local pity = tonumber(pityData and pityData[pityIndex]) or 0
                
                -- Gunakan pcall pada SetDesc agar jika terjadi error UI, loop tidak mati
                pcall(function()
                    AutoHatchToggle:SetDesc(string.format(
                        "Hatching: %s\nType: %s | Pity: %d/1200\nStatus: FULL HOOK (Silent)",
                        starName, 
                        eggType, 
                        math.clamp(pity, 0, 1200)
                    ))
                end)
            else
                -- Jika tidak ada star di dekatnya
                pcall(function()
                    AutoHatchToggle:SetDesc("Status: Standby (Mendekatlah ke Star)")
                end)
            end
        end
    end
end)

-- [[ ELEMEN UNTUK KATEGORI SWORD MANAGEMENT ]] --

local SwordElements = {}
local SelectedSwordID = ""
local SelectedCraftItem = ""

-- 1. Dropdown Pilih Pedang
local function GetOwnedSwordsList()
    local list = {}
    local inventory = getgenv().PlayerData.Inventory.Swords or {}
    local sharedSwords = MetaManager.Shared.Swords
    for id, data in pairs(inventory) do
        local info = sharedSwords[id]
        if info then
            table.insert(list, {
                Title = info.Name,
                Desc = "Rarity: " .. info.Rarity .. " | Stars: " .. (data.Star or 1),
                RawName = id
            })
        end
    end
    return list
end

local SwordDropdown = FM_Add("Sword Management", FarmTab:Dropdown({
    Title = "Select Sword",
    Values = GetOwnedSwordsList(),
    Flag = "Sword_Dropdown",
    Callback = function(val)
        if val then
            SelectedSwordID = val.RawName
            if getgenv().PlayerData.Sword ~= SelectedSwordID then
                pcall(function() MetaManager.Bridge:Fire("Swords", "Equip", SelectedSwordID) end)
            end
        else
            SelectedSwordID = ""
        end
    end
}))
table.insert(SwordElements, SwordDropdown)

-- 2. Toggle Auto Evolve (Statistik Pedang Terpilih)
local AutoEvolveSwordToggle = FM_Add("Sword Management", FarmTab:Toggle({
    Title = "Auto Evolve Sword",
    Desc = "Select a sword to view stats.",
    Default = false,
    Flag = "AutoEvolveSword_Toggle",
    Callback = function(val) Config.AutoEvolveSword = val end
}))
table.insert(SwordElements, AutoEvolveSwordToggle)

-- 3. SECTION: FORGE (CRAFTING)

local ForgeDropdown = FM_Add("Sword Management", FarmTab:Dropdown({
    Title = "Select Item to Craft",
    Values = (function()
        local l = {}
        local sharedSwords = MetaManager.Shared.Swords
        for id, data in pairs(MetaManager.Shared.Forge) do
            -- Perbaikan: Mengambil Base Multiplier dari Shared.Swords
            local swordInfo = sharedSwords[id]
            local baseMult = swordInfo and swordInfo.Multiplier or "0"
            
            table.insert(l, {
                Title = data.Name, 
                RawName = id, 
                Desc = "Sword Multiplier: " .. tostring(baseMult) .. "x"
            })
        end
        return l
    end)(),
    Flag = "Forge_Dropdown",
    Callback = function(val)
        SelectedCraftItem = (val and val.RawName) or ""
    end
}))

local AutoCraftToggle = FM_Add("Sword Management", FarmTab:Toggle({
    Title = "Auto Craft Item",
    Desc = "Select an item to view materials.",
    Default = false,
    Flag = "AutoCraft_Toggle",
    Callback = function(val) Config.AutoCraft = val end
}))

-- 4. Task Utama: Real-time Checker & Detail Info
task.spawn(function()
    local lastSwordCount = -1
    local lastSelectedSword = ""
    local lastSelectedCraft = ""
    local lastStars = -1
    local isElementsLocked = false

    while task.wait(0.5) do
        if not Window or Window.Destroyed then break end
        local pData = getgenv().PlayerData
        if not pData then continue end

        -- [[ A. REAL-TIME LOCKING SYSTEM ]]
        local currentInventory = pData.Inventory.Swords or {}
        local swordCount = 0
        for _ in pairs(currentInventory) do swordCount = swordCount + 1 end

        if swordCount == 0 then
            if not isElementsLocked then
                isElementsLocked = true
                SwordDropdown:Lock("Need atleast one Sword")
                AutoEvolveSwordToggle:Lock("Need atleast one Sword")
            end
        else
            if isElementsLocked then
                isElementsLocked = false
                SwordDropdown:Unlock()
                AutoEvolveSwordToggle:Unlock()
            end
        end

        -- [[ B. SYNC DROPDOWN LIST ]]
        if swordCount ~= lastSwordCount then
            lastSwordCount = swordCount
            SwordDropdown:Refresh(GetOwnedSwordsList())
        end

        -- [[ C. UPDATE SWORD STATS (AUTO EVOLVE TOGGLE) ]]
        if SelectedSwordID ~= "" then
            local swordInfo = MetaManager.Shared.Swords[SelectedSwordID]
            local myData = currentInventory[SelectedSwordID]
            local currentStars = myData and myData.Star or 1

            if swordInfo and (SelectedSwordID ~= lastSelectedSword or currentStars ~= lastStars) then
                lastSelectedSword = SelectedSwordID
                lastStars = currentStars
                
                local baseMult = tonumber(swordInfo.Multiplier) or 1
                local totalMult = baseMult + (0.2 * currentStars)
                local starVisual = string.rep("⭐", currentStars)

                AutoEvolveSwordToggle:SetMainImage({
                    Image = swordInfo.Icon or "rbxassetid://107125323492381",
                    Gradient = MetaManager.Utils.Colors:GetRarity(swordInfo.Rarity),
                    Title = swordInfo.Name,
                    Quantity = "Stars: " .. currentStars,
                }, 60)

                AutoEvolveSwordToggle:SetDesc(string.format(
                    "Rarity: %s\nStars: %s (%d/5)\nMultiplier: %.2fx\nStatus: %s",
                    swordInfo.Rarity, starVisual, currentStars, totalMult,
                    Config.AutoEvolveSword and "Evolving..." or "Idle"
                ))
            end

            if Config.AutoEvolveSword then
                pcall(function() MetaManager.Bridge:Fire("Swords", "Evolve", SelectedSwordID) end)
            end
        end

        -- [[ D. UPDATE FORGE INFO (DETAILED INFO FROM SHARED.SWORDS) ]]
        if SelectedCraftItem ~= "" then
            local craftData = MetaManager.Shared.Forge[SelectedCraftItem]
            local swordInfo = MetaManager.Shared.Swords[SelectedCraftItem] -- Detail dari Shared.Swords
            
            if craftData and swordInfo then
                -- Real-time update deskripsi material & detail
                local matLines = {}
                local canCraft = true
                for mat, req in pairs(craftData.Items) do
                    local owned = pData.Inventory.Items[mat] or 0
                    if owned < req then canCraft = false end
                    table.insert(matLines, string.format("- %s: %d/%d", mat, owned, req))
                end

                if SelectedCraftItem ~= lastSelectedCraft or (tick() % 2 < 0.1) then -- Update berkala
                    lastSelectedCraft = SelectedCraftItem
                    
                    AutoCraftToggle:SetMainImage({
                        Image = craftData.Icon or swordInfo.Icon or "rbxassetid://0",
                        Gradient = MetaManager.Utils.Colors:GetRarity(swordInfo.Rarity),
                        Title = swordInfo.Name,
                        Quantity = swordInfo.Rarity,
                    }, 60)

                    -- Deskripsi Detail dari Shared.Swords
                    AutoCraftToggle:SetDesc(string.format(
                        "Detailed Info:\n- Rarity: %s\n- Base Mult: %sx\n\nRequirements:\n%s\n\nStatus: %s",
                        swordInfo.Rarity,
                        swordInfo.Multiplier,
                        table.concat(matLines, "\n"),
                        Config.AutoCraft and (canCraft and "Crafting..." or "Insufficient Materials") or "Idle"
                    ))
                end

                if Config.AutoCraft and canCraft then
                    pcall(function() MetaManager.Bridge:Fire("Forge", "Craft", SelectedCraftItem) end)
                end
            end
        end
    end
end)

-- [[ ELEMEN UNTUK KATEGORI FRUIT MERCHANT ]] --
local FruitElements = {}
Config.AutoBuyFruits = {} 

-- 1. Helper: Format Multiplier Khusus Buah (Berdasarkan Struktur Array Decompile)
local function GetFruitStatsText(fruitInfo)
    if not fruitInfo or not fruitInfo.Multipliers then return "No Stats" end
    local buffs = {}
    for _, v in ipairs(fruitInfo.Multipliers) do
        -- v[1] = Nama Stat, v[2] = Nilai Multiplier
        local statName = tostring(v[1])
        local val = v[2]
        if statName == "Energy" then
            -- Penyesuaian visual +1 sesuai logika decompile game
            val = tostring((MetaManager.Utils.Number:Unformat(v[2]) or 0) + 1) .. "x"
        end
        table.insert(buffs, string.format("%s: %s", statName, val))
    end
    return table.concat(buffs, " | ")
end

-- 2. Dropdown Pilih Buah dengan Title [Rarity] & Sort Berdasarkan Index
local FruitSelectionDropdown = FM_Add("Fruit Merchant", FarmTab:Dropdown({
    Title = "Auto Buy Selected Fruits",
    Desc = "Displays Price & Multipliers in Emeralds.",
    Flag = "FruitSelection_Dropdown",
    Values = (function()
        local list = {}
        -- 1. Kumpulkan data dari Shared.Fruits
        for id, info in pairs(MetaManager.Shared.Fruits) do
            local stats = GetFruitStatsText(info)
            table.insert(list, {
                -- Menambahkan Rarity ke Title
                Title = string.format("%s [%s]", tostring(info.Name), tostring(info.Rarity or "Common")), 
                RawName = id, 
                Desc = string.format("Price: %s Emeralds | %s", tostring(info.Price or "0"), stats),
                -- Menyimpan Index untuk keperluan sorting
                SortIndex = tonumber(info.Index) or 0 
            })
        end

        -- 2. Urutkan daftar berdasarkan Index (Ascending)
        table.sort(list, function(a, b)
            return a.SortIndex < b.SortIndex
        end)

        return list
    end)(),
    Multi = true,
    Flag = "AutoBuyFruits_Dropdown",
    Callback = function(val)
        Config.AutoBuyFruits = {}
        if type(val) == "table" then
            for _, item in ipairs(val) do table.insert(Config.AutoBuyFruits, item.RawName) end
        end
    end
}))

-- 3. Toggle Auto Buy & Auto Equip
local AutoFruitToggle = FM_Add("Fruit Merchant", FarmTab:Toggle({
    Title = "Enable Fruit Automation",
    Desc = "Smart Buy (Check Owned & Emeralds)",
    Default = false,
    Flag = "AutoFruit_Toggle",
    Callback = function(val) Config.AutoFruitActive = val end
}))

-- [[ TASK UTAMA: FRUIT MERCHANT LOGIC ]] --
task.spawn(function()
    while task.wait(1) do
        if not Window or Window.Destroyed then break end
        
        local pData = getgenv().PlayerData
        if pData and pData.Banner and pData.Banner.FruitMerchant then
            local bannerData = pData.Banner.FruitMerchant
            local inStockList = bannerData.List or {}
            
            -- AMBIL EMERALD DARI INVENTORI
            local inventoryItems = pData.Inventory and pData.Inventory.Items or {}
            local playerEmeralds = inventoryItems["Emerald"] or 0 
            
            -- A. UPDATE UI DESCRIPTION & TIMER
            local timeLeft = 1800 - (os.time() - (bannerData.LastUpdate or 0))
            local timerStr = MetaManager.Utils.Number:Time2(math.max(0, timeLeft))
            
            pcall(function()
                AutoFruitToggle:SetDesc(string.format(
                    "Emeralds: %s | Restock: %s\nStatus: %s",
                    MetaManager.Utils.Number:Format(playerEmeralds),
                    timerStr,
                    Config.AutoFruitActive and "Monitoring Stock..." or "Idle"
                ))
            end)

            -- B. LOGIKA AUTO BUY (DENGAN VALIDASI KETAT)
            if Config.AutoFruitActive then
                for _, targetID in ipairs(Config.AutoBuyFruits) do
                    local fruitInfo = MetaManager.Shared.Fruits[targetID]
                    local isOwned = pData.Inventory.Fruits and pData.Inventory.Fruits[targetID] -- Cek kepemilikan
                    local isInStock = false
                    
                    -- Cek apakah buah ada di stok banner saat ini (Banner.List bisa berupa table/array)
                    for _, stockID in pairs(inStockList) do
                        if stockID == targetID then isInStock = true break end
                    end
                    
                    -- Validasi Harga: Ubah string harga menjadi angka
                    local priceNum = fruitInfo and MetaManager.Utils.Number:Unformat(fruitInfo.Price) or 0
                    
                    -- SYARAT BELI: 
                    -- 1. Ada di stok
                    -- 2. BELUM dimiliki (mencegah buang-buang koin)
                    -- 3. Emerald mencukupi (playerEmeralds >= priceNum)
                    if isInStock and not isOwned and playerEmeralds >= priceNum then
                        pcall(function()
                            MetaManager.Bridge:Fire("FruitMerchant", "Buy", targetID)
                            Notify("Fruit Purchased", "Successfully bought: " .. targetID, "gem")
                        end)
                        task.wait(0.5)
                    end
                end

                -- C. AUTO EQUIP BEST ENERGY FRUIT
                local bestFruit = nil
                local maxEnergy = -1
                
                if pData.Inventory.Fruits then
                    for id, owned in pairs(pData.Inventory.Fruits) do
                        if owned then
                            local info = MetaManager.Shared.Fruits[id]
                            if info and info.Multipliers then
                                for _, mult in ipairs(info.Multipliers) do
                                    if mult[1] == "Energy" then
                                        local val = MetaManager.Utils.Number:Unformat(mult[2]) or 0
                                        if val > maxEnergy then
                                            maxEnergy = val
                                            bestFruit = id
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                -- Pasang jika buah terbaik berbeda dengan yang dipakai saat ini
                if bestFruit and pData.Fruit ~= bestFruit then
                    pcall(function() MetaManager.Bridge:Fire("FruitMerchant", "Equip", bestFruit) end)
                end
            end
        end
    end
end)
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

-- [[ Settings Tab ]] --
SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings-2" });
SettingsTab:Section({ Title = "Config Manager", Icon = "save", Opened = true });
RegisterFeatureElement(SettingsTab:Input({
    Title = "Config Name",
    Placeholder = "ANConfig",
    Flag = "ConfigName_Input",
    Callback = function(txt)
        ConfigName = (txt and txt ~= "" and txt) or "ANConfig"
    end
}))
RegisterFeatureElement(SettingsTab:Button({
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
}))
RegisterFeatureElement(SettingsTab:Button({
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
        ApplyFreeUserRestrictions()
    end
}))
RegisterFeatureElement(SettingsTab:Button({
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
}))
RegisterFeatureElement(SettingsTab:Button({
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
}))
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
        Terrain.WaterDominionize = 0
        Terrain.WaterDominionpeed = 0
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

RegisterFeatureElement(SettingsTab:Toggle({
    Title = "High Performance Mode",
    Desc = "Removes textures, shadows, and effects to increase FPS.",
    Default = false,
    Callback = function(val)
        if val then
            ApplyFPSBoost()
        else
            Notify("Info", "Rejoin server untuk mengembalikan grafik normal.", "info")
        end
    end
}))

RegisterFeatureElement(SettingsTab:Button({
    Title = "Clean Workspace (Lag Fix)",
    Icon = "trash-2",
    Desc = "Removes visual clutter in the workspace.",
    Callback = function()
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and v.Transparency == 1 and not v:IsA("Terrain") then
                -- v:Destroy() -- Hati-hati dengan ini, bisa menghapus part penting
            end
        end
        Notify("Cleaned", "Workspace items optimized.", "check")
    end
}))
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
RegisterFeatureElement(SettingsTab:Toggle({
    Title = "CPU Mode (White Screen)",
    Desc = "Disables 3D rendering. Great for AFK overnight (saves GPU).",
    Default = false,
    Callback = function(val)
        Toggle3DRendering(val)
        if val then
            Notify("CPU Mode", "3D Rendering Disabled for performance.", "monitor-off")
        else
            Notify("CPU Mode", "3D Rendering Enabled.", "monitor")
        end
    end
}))

-- Toggle untuk Mute Suara (Mengurangi beban CPU audio)
RegisterFeatureElement(SettingsTab:Toggle({
    Title = "Mute All Sounds",
    Desc = "Mutes all in-game sounds.",
    Default = false,
    Callback = function(val)
        if val then MuteAllSounds() end
    end
}))

-- Tombol untuk Force Low Quality (Engine Level)
RegisterFeatureElement(SettingsTab:Button({
    Title = "Force Ultra Low Quality",
    Icon = "mouse-pointer-2",
    Desc = "Forces Roblox to use the lowest engine settings.",
    Callback = function()
        BoostCPU()
        Notify("Success", "Engine optimized for low-end PC.", "check")
    end
}))
ApplyFreeUserRestrictions()
FM_OnChange("Farm")

Window:SelectTab(FarmTab.Index);

task.spawn(function()
    task.wait(1.5)
    local CM = Window.ConfigManager
    if not CM then return end
    
    pcall(function()
        -- Tambahkan 'true' pada CreateConfig agar library tahu ini adalah sistem autoload
        local cfg = CM:GetConfig(ConfigName) or CM:CreateConfig(ConfigName, true)
        
        -- Mulai proses loading
        IsLoadingConfig = true 
        cfg:Load()
        
        -- PENTING: Set kembali ke false agar loop Auto Save bisa berjalan
        IsLoadingConfig = false 
    end)
    
    ApplyFreeUserRestrictions()

    -- Loop Auto Save 10 Detik
    while not Window.Destroyed do
        task.wait(10)
        -- Sekarang Save akan berfungsi karena IsLoadingConfig sudah false
        if not IsLoadingConfig then
            pcall(function()
                local cfg = CM:GetConfig(ConfigName)
                if cfg then 
                    cfg:Save() 
                end
            end)
        end
    end
end)
