if game.PlaceId ~= 136894901443170 then return end
repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Anime Waves"
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

local FolderPath = "ANUI/AnimeWaves"
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local IsPremium = false
local ValidKeys = {"ANHUB-2025"}
local MapDBFile = "Map_Database.json"
local Config = {
    SelectedEnemies = {}, -- Berubah menjadi tabel untuk mendukung Multi-Select
    AutoFarm = false
}

-- Variabel global untuk menampung target aktif saat ini
local currentTarget = nil
local ConfigName = "ANConfig"
local CurrentMapEnemiesCache = {}
local IsLoadingConfig = false
local IsLoadingMapSelection = false

local UI
local Window

local NightXLibrary = require(game:GetService("ReplicatedStorage"):WaitForChild("NightX"):WaitForChild("Library"))
local EnemiesIndex = NightXLibrary.GetIndex("Enemies")
local DropsIndex = NightXLibrary.GetIndex("Drops")
local GachaTargets = NightXLibrary.GetIndex("VaultGachas")
local ItemsIndex = NightXLibrary.GetIndex("Itens")
local RanksIndex = NightXLibrary.GetIndex("Ranks")
local EggsIndex = NightXLibrary.GetIndex("Eggs")
local GameColors = NightXLibrary.GetIndex("Colors").Colors
local AbbreviateService = NightXLibrary.GetService("AbbreviateService")
local Debounce = require(game:GetService("ReplicatedStorage").NightX.Library.Services.DebounceService)
local function GetPlayerTokenAmount(tokenName)
    local itensFolder = LocalPlayer:FindFirstChild("Itens")
    local tokenObj = itensFolder and itensFolder:FindFirstChild(tokenName)
    if tokenObj then
        return tokenObj:GetAttribute("Amount") or 0
    end
    return 0
end
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

    LP.Idled:Connect(function()
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

-- Cara 1: Menimpa fungsi Check agar selalu mengembalikan false (No Debounce)
if IsPremium then
    Debounce.Check = function()
        return false
    end    
    -- [[ GACHA ANIMATION BYPASS / NO ANIMATION ]] --

    task.spawn(function()
        -- 1. Spoof Atribut FastSpin (Bypass logika internal game)
        -- Berdasarkan baris 10 di VaultGachaSetup, game mengecek atribut ini
        local Gamepasses = LocalPlayer:FindFirstChild("Gamepasses")
        if Gamepasses then
            Gamepasses:SetAttribute("FastClick", true)
            Gamepasses:SetAttribute("Lucky", true)
            Gamepasses:SetAttribute("SuperLucky", true)
            Gamepasses:SetAttribute("UltraLucky", true)
            Gamepasses:SetAttribute("FastOpen", true)
            Gamepasses:SetAttribute("FastSpin", true)
        end
    end)
end
UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v=" .. math.random()))()

Window = UI:CreateWindow({
    Title = "AN Hub - Anime Waves",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeWaves",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Waves" }),
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
    ["Rank Up"] = "Auto rank up and progression features.",
    ["Vault Gacha"] = "Auto roll for Races, Stands, Clans, and more.",
    ["Hatch Egg"] = "Auto open eggs with instant hatch support.",
    ["Progress Upgrade"] = "Upgrade your permanent energy or damage multiplier "
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
        Desc = "Anime Waves"
    }),
    SidebarProfile = false
});

FM_CategorySelector = FarmTab:Category({
    Title = "Select Category",
    Default = "Farm",
    Options = {
        {Title = "Farm", Icon = "rbxassetid://89761068698333"},
        {Title = "Rank Up", Icon = "rbxassetid://138853123472984"},
        {Title = "Vault Gacha", Icon = "rbxassetid://132940423305445"},
        {Title = "Hatch Egg", Icon = "rbxassetid://128166775186475"},
        {Title = "Progress Upgrade", Icon = "rbxassetid://133671652413407"}
    },
    Callback = FM_OnChange
})

local ItemRarityColors = {
    Exclusive = ColorSequence.new(Color3.fromRGB(0, 255, 255), Color3.fromRGB(20, 20, 20)),
    Legendary = ColorSequence.new(Color3.fromRGB(255, 215, 0), Color3.fromRGB(20, 20, 20)),
    Epic = ColorSequence.new(Color3.fromRGB(255, 0, 255), Color3.fromRGB(20, 20, 20)),
    Rare = ColorSequence.new(Color3.fromRGB(0, 191, 255), Color3.fromRGB(20, 20, 20)),
    Common = ColorSequence.new(Color3.fromRGB(150, 150, 150), Color3.fromRGB(20, 20, 20))
}

local DifficultyOrder = { Nightmare = 1, Hard = 2, Medium = 3, Easy = 4 }

-- [[ 2. Perbarui Fungsi GetBestTarget ]] --
local function GetBestTarget()
    local enemiesFolder = workspace:FindFirstChild("_Enemies")
    -- Cek apakah folder ada dan ada musuh yang dipilih dalam daftar
    if not enemiesFolder or #Config.SelectedEnemies == 0 then return nil end
    
    local target = nil
    local shortestDist = math.huge
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, v in pairs(enemiesFolder:GetChildren()) do
        -- Cek apakah nama musuh ada di dalam tabel Config.SelectedEnemies
        if table.find(Config.SelectedEnemies, v.Name) and v:FindFirstChild("HumanoidRootPart") then
            local hum = v:FindFirstChildOfClass("Humanoid")
            local attrHP = v:GetAttribute("Health")
            local isAlive = true
            
            if hum and hum.Health <= 0 then isAlive = false
            elseif attrHP and attrHP <= 0 then isAlive = false end
            
            if isAlive then
                local dist = (v.HumanoidRootPart.Position - myRoot.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    target = v
                end
            end
        end
    end
    return target
end

local function GetEnemiesList()
    local list = {}
    local processed = {}
    local enemiesFolder = workspace:FindFirstChild("_Enemies")
    
    if enemiesFolder then
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if not processed[enemy.Name] then
                processed[enemy.Name] = true
                local stats = EnemiesIndex[enemy.Name]
                local drops = DropsIndex[enemy.Name]
                local mobRarity = (stats and stats.Rarity) or "Easy"
                
                local dropCards = {}
                if drops then
                    for itemName, data in pairs(drops) do
                        if itemName ~= "Nothing" then
                            local itemData = ItemsIndex[data.Id]
                            local rarity = (itemData and itemData.Rarity) or "Common"
                            table.insert(dropCards, {
                                Title = itemName,
                                Quantity = data.Amount or "1x",
                                Rate = tostring(data.Percentage or 0) .. "%",
                                Gradient = ItemRarityColors[rarity] or ItemRarityColors.Common,
                                Image = (itemData and itemData.Image) or "rbxassetid://0"
                            })
                        end
                    end
                end

                table.insert(list, {
                    Title = string.format("%s [%s]", enemy.Name, mobRarity),
                    Desc = "Health: " .. (stats and stats.Health or "Unknown"),
                    Images = dropCards,
                    RawName = enemy.Name,
                    Rarity = mobRarity
                })
            end
        end
    end

    table.sort(list, function(a, b)
        return (DifficultyOrder[a.Rarity] or 99) > (DifficultyOrder[b.Rarity] or 99)
    end)
    return list
end

-- [[ 3. Dropdown Select Enemy dengan Auto Refresh ]] --
local EnemyDropdown = FM_Add("Farm", FarmTab:Dropdown({
    Title = "Select Enemy",
    Desc = "Daftar musuh akan otomatis terupdate setiap detik.",
    Values = GetEnemiesList(),
    Multi = true, -- Multi Select Aktif
    AllowNone = true, -- Boleh Kosong Aktif
    Flag = "EnemySelector_Config",
    Callback = function(val)
        Config.SelectedEnemies = {}
        if typeof(val) == "table" then
            for _, item in ipairs(val) do
                table.insert(Config.SelectedEnemies, item.RawName)
            end
        end
        -- Reset target agar langsung ganti ke pilihan terbaru
        currentTarget = nil 
    end
}))

LastEnemiesState = nil
-- LOGIKA REAL-TIME CHECK (Setiap 1 Detik)
task.spawn(function()
    while task.wait(2) do
        -- Berhenti jika UI ditutup/hancur
        if Window.Destroyed then break end
        
        local enemiesFolder = workspace:FindFirstChild("_Enemies")
        if enemiesFolder then
            -- 1. Ambil semua nama musuh unik saat ini untuk perbandingan cepat
            local currentNames = {}
            for _, v in pairs(enemiesFolder:GetChildren()) do
                if not table.find(currentNames, v.Name) then
                    table.insert(currentNames, v.Name)
                end
            end
            table.sort(currentNames) -- Sortir agar urutan selalu konsisten
            
            -- 2. Buat "Fingerprint" string dari daftar nama musuh
            local currentState = table.concat(currentNames, "|")
            
            -- 3. Cek apakah data tidak sama dengan sebelumnya
            if LocalPlayer:GetAttribute("CurrentArea") ~= LastEnemiesState then
                LastEnemiesState = LocalPlayer:GetAttribute("CurrentArea") -- Update state terakhir
                
                -- Ambil data lengkap (Title, Desc, Images) dari GetEnemiesList()
                local freshData = GetEnemiesList() 
                
                -- Lakukan Refresh pada UI Dropdown menggunakan library ANUI
                pcall(function()
                    if EnemyDropdown and EnemyDropdown.Refresh then
                        EnemyDropdown:Refresh(freshData)
                    end
                end)
            end
        end
    end
end)
-- [[ 4. Perbarui Toggle Auto Attack ]] --
FM_Add("Farm", FarmTab:Toggle({
    Title = "Auto Attack Enemies",
    Desc = "Otomatis mengejar target terbaru yang dipilih di dropdown.",
    Default = false,
    Flag = "AutoAttack_Toggle",
    Callback = function(val)
        Config.AutoFarm = val
        if val then
            task.spawn(function()
                while not Window.Destroyed and Config.AutoFarm do
                    task.wait()
                    
                    -- Pastikan ada musuh yang dipilih di dropdown
                    if #Config.SelectedEnemies > 0 then
                        -- Cek apakah target saat ini masih valid dan hidup
                        local isDead = not currentTarget or not currentTarget.Parent or 
                                       (currentTarget:FindFirstChildOfClass("Humanoid") and currentTarget:FindFirstChildOfClass("Humanoid").Health <= 0) or
                                       (currentTarget:GetAttribute("Health") and currentTarget:GetAttribute("Health") <= 0)

                        if isDead then
                            currentTarget = GetBestTarget()
                        end

                        if currentTarget and currentTarget:FindFirstChild("HumanoidRootPart") then
                            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if myRoot then
                                local distance = (myRoot.Position - currentTarget.HumanoidRootPart.Position).Magnitude
                                if distance > 8 then 
                                    myRoot.CFrame = currentTarget.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                                end
                            end
                        end
                    else
                        -- Jika tidak ada yang dipilih (AllowNone), hapus target aktif
                        currentTarget = nil
                    end
                end
            end)
        end
    end
}))

-- [[ ELEMEN UNTUK KATEGORI RANK UP ]] --

local RankUpToggle = FM_Add("Rank Up", FarmTab:Toggle({
    Title = "Auto Rank Up",
    Desc = "Mencari UI Rank...",
    Default = false,
    Flag = "AutoRankUp_Toggle",
    Callback = function(val)
        Config.AutoRankUp = val
    end
}))

-- Task untuk Update UI & Logika Auto Click Rank Up
task.spawn(function()
    -- Path UI berdasarkan hasil decompile RankSetup
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local RankUI = PlayerGui:WaitForChild("Center"):WaitForChild("Ranks")
    local RankButton = RankUI:WaitForChild("Content"):WaitForChild("Up")

    while task.wait(1) do
        if not Window or Window.Destroyed then break end
        
        local currentRank = LocalPlayer:GetAttribute("Rank")
        local currentEnergy = LocalPlayer:GetAttribute("Energy") or 0
        
        if currentRank and RanksIndex[currentRank] then
            local data = RanksIndex[currentRank]
            local cost = data.Cost or 0
            local progress = math.clamp(currentEnergy / cost, 0, 1)
            
            -- Update Visual pada Toggle
            RankUpToggle:SetTitle(string.format("Rank: %s | Energy x%s", currentRank, AbbreviateService:Comma(data.Multiplier - 1)))
            
            local barLen = 15
            local filled = math.floor(progress * barLen)
            local bar = "[" .. string.rep("█", filled) .. string.rep("░", barLen - filled) .. "]"
            RankUpToggle:SetDesc(string.format("%s %s%%\nEnergy: %s / %s", bar, math.floor(progress * 100), AbbreviateService:Comma(currentEnergy), AbbreviateService:Comma(cost)))
            
            -- LOGIKA AUTO CLICK
            if Config.AutoRankUp and currentEnergy >= cost then
                -- Pastikan UI Rank tersedia untuk di-klik
                if RankButton then
                    -- METODE CLICK: Menggunakan firesignal untuk memicu MouseButton1Click
                    -- Ini mensimulasikan pemain mengklik tombol secara manual
                    pcall(function()
                        if firesignal then
                            firesignal(RankButton.MouseButton1Click)
                        else
                            -- Fallback jika executor tidak mendukung firesignal
                            -- Mencoba memicu lewat event internal
                            for _, connection in pairs(getconnections(RankButton.MouseButton1Click)) do
                                connection:Fire()
                            end
                        end
                    end)
                end
            end
        end
    end
end)

-- Inisialisasi Tabel Modular
Config.AutoGacha = {} 

-- [[ 1. SISTEM KONEKSI OTOMATIS ]] --

local function VaultRerollGacha(gachaName)
    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v:IsA("RemoteEvent") then                
            local args = {
                "01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01001110 01101001 01100111 01101000 01110100 01011000 00101110 01001100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01000011 01101111 01101110 01101110 01100101 01100011 01110100 01101001 01101111 01101110 00101110 01110100 01101000 01110010 01100101 01100001 01100100 01011111 01110011 01100101 01100011 01110101 01110010 01101001 01110100 01111001 00111010 00110001 00001010 01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01001110 01101001 01100111 01101000 01110100 01011000 00101110 01001100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01000011 01101111 01101110 01101110 01100101 01100011 01110100 01101001 01101111 01101110 00111010 00110001 00110101 00110110 00100000 01100110 01110101 01101110 01100011 01110100 01101001 01101111 01101110 00100000 01110011 01100101 01101110 01100100 00001010 01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01001110 01101001 01100111 01101000 01110100 01011000 00101110 01001100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01000011 01101100 01101001 01100101 01101110 01110100 00101110 01010110 01100001 01110101 01101100 01110100 01000111 01100001 01100011 01101000 01100001 01010011 01100101 01110100 01110101 01110000 00111010 00110110 00110100 00111001 00001010",
                "System",
                "VaultGacha",
                "Roll",
                gachaName,
                "All"
            }
            v:FireServer(unpack(args))
            -- break
        end
    end
end

-- [[ 2. PENGECEKAN MATERIAL & BIAYA ]] --

local function CanAffordGacha(gachaName)
    local data = GachaTargets[gachaName]
    if not data then return false end
    
    local tokenName = data.CostData -- e.g., "race_token"
    local cost = data.Cost or 5 -- Harga gacha
    
    -- Cek inventory berdasarkan Atribut 'Amount'
    local inventory = LocalPlayer:FindFirstChild("Itens")
    local token = inventory and inventory:FindFirstChild(tokenName)
    local amount = token and token:GetAttribute("Amount") or 0
    
    return amount >= cost
end

-- [[ 3. MODULAR GACHA LOOP DENGAN METODE :SEND ]] --

local function StartModularGacha(gachaName)
    task.spawn(function()        
        while not Window.Destroyed and Config.AutoGacha[gachaName] do
            if CanAffordGacha(gachaName) then
                pcall(function()
                    VaultRerollGacha(gachaName)
                end)
            end
            task.wait(1)
        end
    end)
end

-- [[ 4. DYNAMIC CATEGORY & TOGGLES (SORTED BY MAP & GROUPED) ]] --

-- Inisialisasi Pity Folder
local GachaPitys = LocalPlayer:WaitForChild("GachaPitys", 5)

-- 1. Buat daftar nama gacha untuk disortir
local sortedGachaNames = {}
for name, _ in pairs(GachaTargets) do
    table.insert(sortedGachaNames, name)
end

-- 2. Sortir berdasarkan Map ID agar urutan rapi
table.sort(sortedGachaNames, function(a, b)
    local mapA = GachaTargets[a].Map or 0
    local mapB = GachaTargets[b].Map or 0
    return mapA < mapB
end)

local gachaCounter = 0
local currentGachaGroup = nil

-- 3. Loop menggunakan daftar yang sudah disortir
for _, name in ipairs(sortedGachaNames) do
    local gachaName = name
    local data = GachaTargets[gachaName]
    local tokenName = data.CostData or "Token"
    local costRequirement = data.Cost or 5
    local dataKey = data.Data
    local contentList = data.Content
    local multStyle = data.MultStyle
    local mapId = data.Map or "0"
    local itemInfo = ItemsIndex[tokenName]
    local tokenIcon = itemInfo and itemInfo.Image or "rbxassetid://0"
    local hasSecret = false
    local lastLockReason = nil
    
    -- Pembuatan Group: 2 Toggle per Group
    if gachaCounter % 2 == 0 then
        currentGachaGroup = FM_Add("Vault Gacha", FarmTab:Group({
            Title = "Gacha Collection - Map " .. mapId
        }))
    end
    gachaCounter = gachaCounter + 1

    -- Tambahkan Toggle ke dalam Group aktif
    local GachaToggle = currentGachaGroup:Toggle({
        Title = gachaName,
        Desc = "Loading stats...",
        Default = false,
        Flag = "AutoGacha_" .. gachaName:gsub(" ", ""),
        Callback = function(val)
            if val then
                if not IsPremium then
                    Config.AutoGacha[gachaName] = false
                    pcall(function()
                        GachaToggle:Unlock()
                        GachaToggle:Set(false, false, true)
                        GachaToggle:Lock("Premium Only")
                    end)
                    return
                end
                if hasSecret then
                    Config.AutoGacha[gachaName] = false
                    pcall(function()
                        GachaToggle:Unlock()
                        GachaToggle:Set(false, false, true)
                        GachaToggle:Lock("Already Got Secret")
                    end)
                    return
                end
            end
            Config.AutoGacha[gachaName] = val
            if val then StartModularGacha(gachaName) end
        end
    })

    if not IsPremium then
        Config.AutoGacha[gachaName] = false
        pcall(function()
            GachaToggle:Set(false, false, true)
            GachaToggle:Lock("Premium Only")
        end)
    end

    -- TASK: Real-time Update (Pity Bar, Material, & Equipped Image)
    task.spawn(function()
        local lastEquipped = ""
        while not Window.Destroyed do
            task.wait(1)
            
            -- A. Deteksi Item Terpasang
            local vaultFolder = LocalPlayer:WaitForChild("VaultGachas", 5)
            local equippedFolder = vaultFolder:FindFirstChild(gachaName) or vaultFolder:FindFirstChild(dataKey)
            local equippedName = equippedFolder and equippedFolder:GetAttribute("Equipped") or "None"

            -- B. Ambil Data Rarity
            local rarity = "Common"
            local Multiplier = 0
            hasSecret = false
            if equippedName ~= "None" and contentList then
                for _, content in pairs(contentList) do
                    if tostring(content.Id) == tostring(equippedName) then
                        rarity = content.Rarity or "Common"
                        Multiplier = content.Multiplier or 0
                        hasSecret = rarity == "Secret"
                        break
                    end
                end
            end

            local desiredLockReason = nil
            if not IsPremium then
                desiredLockReason = "Premium Only"
            elseif hasSecret then
                desiredLockReason = "Already Got Secret"
            end

            if desiredLockReason ~= lastLockReason then
                lastLockReason = desiredLockReason
                pcall(function()
                    if desiredLockReason then
                        Config.AutoGacha[gachaName] = false
                        GachaToggle:Unlock()
                        GachaToggle:Set(false, false, true)
                        GachaToggle:Lock(desiredLockReason)
                    else
                        GachaToggle:Unlock()
                    end
                end)
            end

            -- C. Logika Progress Bar Pity Secret (Max 15K)
            local pityAmount = GachaPitys and GachaPitys:GetAttribute(dataKey) or 0
            local pityMax = 15000
            local progress = math.clamp(pityAmount / pityMax, 0, 1)
            local pityPercentage = math.floor(progress * 100)
            -- Ubah barLen menjadi 10 agar lebih pendek
            local barLen = 8 
            local filled = math.floor(progress * barLen)
            local pityBar = string.rep("█", filled) .. string.rep("░", barLen - filled)

            -- D. Update Visual: SetMainImage hanya jika BUKAN 'None'
            if equippedName ~= lastEquipped then
                lastEquipped = equippedName
                
                if equippedName ~= "None" then
                    local officialColor = GameColors[rarity] or GameColors.Common
                    local gradientValue = ColorSequence.new(officialColor, Color3.fromRGB(20, 20, 20))
                    local equippedIcon = ItemsIndex[equippedName] and ItemsIndex[equippedName].Image or tokenIcon
                    
                    GachaToggle:SetMainImage({
                        Image = equippedIcon,
                        Gradient = gradientValue,
                        Quantity = rarity,
                        Title = equippedName
                    }, 60)
                end
            end

            -- E. Update Deskripsi: Pity Bar + Material Check
            local currentAmount = GetPlayerTokenAmount(tokenName)
            local formattedAmount = AbbreviateService:Comma(currentAmount)
            local formattedCost = AbbreviateService:Comma(costRequirement)
            local colorHex = (currentAmount >= costRequirement) and "#00FF00" or "#FF0000"
            
            GachaToggle:SetDesc(string.format(
                "Pity Secret: %s/15K\n[%s] %s%%\n%s %s: <font color=\"%s\">%s / %s</font>\nBoost: %s x%s",
                AbbreviateService:Comma(pityAmount),
                pityBar,
                pityPercentage,
                tostring(tokenIcon),
                itemInfo and itemInfo.Id or "Token",
                colorHex,
                formattedAmount,
                formattedCost,
                multStyle,
                Multiplier
            ))
        end
    end)
end

Config.AutoHatch = {} 
-- 1. Sortir Telur berdasarkan Area
local sortedEggs = {}
for name, data in pairs(EggsIndex) do
    table.insert(sortedEggs, {Name = name, Area = data.Area or 0, Cost = data.Cost})
end
table.sort(sortedEggs, function(a, b) return a.Area < b.Area end)

local function HatchGacha(eggName,hatchType)
    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v:IsA("RemoteEvent") then                
            local args = {
                "01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01001110 01101001 01100111 01101000 01110100 01011000 00101110 01001100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01000011 01101111 01101110 01101110 01100101 01100011 01110100 01101001 01101111 01101110 00101110 01110100 01101000 01110010 01100101 01100001 01100100 01011111 01110011 01100101 01100011 01110101 01110010 01101001 01110100 01111001 00111010 00110001 00001010 01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01001110 01101001 01100111 01101000 01110100 01011000 00101110 01001100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01000011 01101111 01101110 01101110 01100101 01100011 01110100 01101001 01101111 01101110 00111010 00110001 00110101 00110110 00100000 01100110 01110101 01101110 01100011 01110100 01101001 01101111 01101110 00100000 01110011 01100101 01101110 01100100 00001010 01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01001110 01101001 01100111 01101000 01110100 01011000 00101110 01001100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01000011 01101100 01101001 01100101 01101110 01110100 00101110 01000101 01100111 01100111 01010011 01100101 01110100 01110101 01110000 00111010 00110001 00110010 00110101 00100000 01100110 01110101 01101110 01100011 01110100 01101001 01101111 01101110 00100000 01001111 01110000 01100101 01101110 01000101 01100111 01100111 00001010 01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01001110 01101001 01100111 01101000 01110100 01011000 00101110 01001100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01000011 01101100 01101001 01100101 01101110 01110100 00101110 01000101 01100111 01100111 01010011 01100101 01110100 01110101 01110000 00111010 00110011 00110101 00111000 00001010",
                "System",
                "Eggs",
                "Open",
                eggName,
                hatchType
            }
            v:FireServer(unpack(args))
            -- break
        end
    end
end
-- 2. Fungsi Kirim Remote Gacha Telur
local function ExecHatch(eggName, hatchType)
    local eggsFolder = workspace:FindFirstChild("_Eggs")
    local eggModel = eggsFolder and eggsFolder:FindFirstChild(eggName)
    
    if eggModel then
        local magPart = eggModel:WaitForChild("Magnitude", 5)
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        -- Cek Jarak (Wajib < 10 studs sesuai alur asli)
        if magPart and myRoot and (myRoot.Position - magPart.Position).Magnitude < 10 then
            HatchGacha(eggName, hatchType)
        end
    end
end

-- 3. Loop Pembuatan Toggle Telur
local eggCounter = 0
local currentEggGroup = nil

for _, eggData in ipairs(sortedEggs) do
    local name = eggData.Name
    
    -- Grouping 2 per item
    if eggCounter % 2 == 0 then
        currentEggGroup = FM_Add("Hatch Egg", FarmTab:Group({
            Title = "Area " .. eggData.Area .. " Eggs"
        }))
    end
    eggCounter = eggCounter + 1

    local HatchToggle = currentEggGroup:Toggle({
        Title = "Auto " .. name,
        Desc = "Cost: " .. eggData.Cost,
        Default = false,
        Flag = "AutoHatch_" .. name:gsub(" ", ""),
        Callback = function(val)
            Config.AutoHatch[name] = val
            if val then
                task.spawn(function()
                    while not Window.Destroyed and Config.AutoHatch[name] do
                        -- Gunakan mode "Multi" untuk efisiensi
                        ExecHatch(name, "Multi")
                        task.wait() 
                    end
                end)
            end
        end
    })
end

-- [[ 5. MARINE PROGRESSION FEATURE ]] --

local function ProgressUpgrade(Name)
    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v:IsA("RemoteEvent") then                
            local args = {
                "01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01001110 01101001 01100111 01101000 01110100 01011000 00101110 01001100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01000011 01101111 01101110 01101110 01100101 01100011 01110100 01101001 01101111 01101110 00101110 01110100 01101000 01110010 01100101 01100001 01100100 01011111 01110011 01100101 01100011 01110101 01110010 01101001 01110100 01111001 00111010 00110001 00001010 01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01001110 01101001 01100111 01101000 01110100 01011000 00101110 01001100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01000011 01101111 01101110 01101110 01100101 01100011 01110100 01101001 01101111 01101110 00111010 00110001 00110101 00110110 00100000 01100110 01110101 01101110 01100011 01110100 01101001 01101111 01101110 00100000 01110011 01100101 01101110 01100100 00001010 01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01001110 01101001 01100111 01101000 01110100 01011000 00101110 01001100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01000011 01101100 01101001 01100101 01101110 01110100 00101110 01001101 01100001 01110010 01101001 01101110 01100101 01010011 01100101 01110100 01110101 01110000 00111010 00110001 00110000 00111001 00001010",
                "System",
                Name,
                "Upgrade"
            }
            v:FireServer(unpack(args))
            -- break
        end
    end
end

local ProgressUpgrades = {
    {
        DisplayName = "Marine",
        ProgressionName = "MarineProgression",
        TokenName = "marine_token",
        TokenLabel = "Marine Tokens",
        TitleFormat = "Marine Level: %s/%s | Boost: Energy %.2fx",
        Flag = "AutoMarineUpgrade_Toggle",
        ConfigKey = "AutoMarineUpgrade"
    },
    {
        DisplayName = "Pirate",
        ProgressionName = "PirateProgression",
        TokenName = "pirate_token",
        TokenLabel = "Pirate Tokens",
        TitleFormat = "Pirate Level: %s/%s | Boost: Damage %.2fx",
        Flag = "AutoPirateUpgrade_Toggle",
        ConfigKey = "AutoPirateUpgrade"
    },
    {
        DisplayName = "Ninja",
        ProgressionName = "NinjaProgression",
        TokenName = "ninja_token",
        TokenLabel = "Ninja Tokens",
        TitleFormat = "Ninja Level: %s/%s | Boost: Energy %.2fx",
        Flag = "AutoNinjaUpgrade_Toggle",
        ConfigKey = "AutoNinjaUpgrade"
    },
    {
        DisplayName = "Bizarre",
        ProgressionName = "BizarreProgression",
        TokenName = "bizarre_token",
        TokenLabel = "Bizarre Tokens",
        TitleFormat = "Bizarre Level: %s/%s | Boost: Energy %.2fx",
        Flag = "AutoBizarreUpgrade_Toggle",
        ConfigKey = "AutoBizarreUpgrade"
    },
    {
        DisplayName = "Saiyan",
        ProgressionName = "SaiyanProgression",
        TokenName = "saiyan_token",
        TokenLabel = "Saiyan Tokens",
        TitleFormat = "Saiyan Level: %s/%s | Boost: Energy %.2fx",
        Flag = "AutoSaiyanUpgrade_Toggle",
        ConfigKey = "AutoSaiyanUpgrade"
    }
}

local progressUpgradeGroup = nil
for i, def in ipairs(ProgressUpgrades) do
    if (i - 1) % 2 == 0 then
        local nextDef = ProgressUpgrades[i + 1]
        local groupTitle = def.DisplayName .. (nextDef and (" & " .. nextDef.DisplayName) or "") .. " Upgrades"
        progressUpgradeGroup = FM_Add("Progress Upgrade", FarmTab:Group({
            Title = groupTitle
        }))
    end

    local displayName = def.DisplayName
    local progressionName = def.ProgressionName
    local tokenName = def.TokenName
    local tokenLabel = def.TokenLabel
    local titleFormat = def.TitleFormat
    local flag = def.Flag
    local configKey = def.ConfigKey

    local index = NightXLibrary.GetIndex(progressionName)
    local isMaxed = false
    local lastLockReason = nil

    local upgradeToggle = progressUpgradeGroup:Toggle({
        Title = displayName .. " Progress Upgrade",
        Desc = "Loading " .. displayName:lower() .. " stats...",
        Default = false,
        Flag = flag,
        Callback = function(val)
            if val then
                if not IsPremium then
                    Config[configKey] = false
                    pcall(function()
                        upgradeToggle:Unlock()
                        upgradeToggle:Set(false, false, true)
                        upgradeToggle:Lock("Premium Only")
                    end)
                    return
                end
                if isMaxed then
                    Config[configKey] = false
                    pcall(function()
                        upgradeToggle:Unlock()
                        upgradeToggle:Set(false, false, true)
                        upgradeToggle:Lock("Max Level")
                    end)
                    return
                end
            end
            Config[configKey] = val
        end
    })

    if not IsPremium then
        Config[configKey] = false
        pcall(function()
            upgradeToggle:Set(false, false, true)
            upgradeToggle:Lock("Premium Only")
        end)
    end

    task.spawn(function()
        local progFolder = LocalPlayer:WaitForChild(progressionName, 10)
        while task.wait(0.5) do
            if not Window or Window.Destroyed then break end
            if not progFolder then progFolder = LocalPlayer:FindFirstChild(progressionName) continue end

            local currentLevel = progFolder:GetAttribute("Level") or 0
            local currentBoost = progFolder:GetAttribute("Energy") or 1
            local maxLevel = index.Max
            isMaxed = (type(maxLevel) == "number") and (currentLevel >= maxLevel) or false

            local desiredLockReason = nil
            if not IsPremium then
                desiredLockReason = "Premium Only"
            elseif isMaxed then
                desiredLockReason = "Max Level"
            end

            if desiredLockReason ~= lastLockReason then
                lastLockReason = desiredLockReason
                pcall(function()
                    if desiredLockReason then
                        Config[configKey] = false
                        upgradeToggle:Unlock()
                        upgradeToggle:Set(false, false, true)
                        upgradeToggle:Lock(desiredLockReason)
                    else
                        upgradeToggle:Unlock()
                    end
                end)
            end

            local tokenNeeded = math.clamp(math.floor(currentLevel / 10) * 3 + 1, 1, 100)
            local successChance = math.clamp(100 - math.floor(currentLevel / 9) * (index.PercentPer9Upgrades or 0), 1, 100)

            upgradeToggle:SetTitle(string.format(titleFormat, currentLevel, index.Max, currentBoost))

            local myTokens = GetPlayerTokenAmount(tokenName)
            local colorHex = (myTokens >= tokenNeeded) and "#00FF00" or "#FF0000"
            local tokenIcon = ""
            pcall(function()
                tokenIcon = (ItemsIndex[tokenName] and ItemsIndex[tokenName].Image) or ""
            end)

            upgradeToggle:SetDesc(string.format(
                "Success Chance: %s%%\n%s%s: <font color=\"%s\">%s / %s</font>",
                successChance,
                tokenIcon,
                tokenLabel,
                colorHex,
                AbbreviateService:Comma(myTokens),
                tokenNeeded
            ))

            if Config[configKey] and IsPremium and not isMaxed then
                if currentLevel < (index.Max or 999) then
                    if myTokens >= tokenNeeded then
                        ProgressUpgrade(progressionName)
                        task.wait(0.2)
                    end
                else
                    Config[configKey] = false
                    Notify("Max Level", displayName .. " Progression has reached maximum level!", "check")
                end
            end
        end
    end)
end
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
