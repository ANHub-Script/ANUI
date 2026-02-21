if game.PlaceId ~= 95760142548121 then return end
repeat task.wait() until game:IsLoaded()
getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Anime Spike"
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

local FolderPath = "ANUI/AnimeSpike"
local ExpiryFile = FolderPath .. "/ANHub_Key_Timer.txt"
local IsPremium = false
local ValidKeys = {"ANHUB-2025"}
local Config = {
    SelectedEnemies = {}, -- Berubah menjadi tabel untuk mendukung Multi-Select
    AutoFarm = false
}

-- Variabel global untuk menampung target aktif saat ini
local currentTarget = nil
local ConfigName = "ANHub"
local CurrentMapEnemiesCache = {}
local IsLoadingConfig = false

local UI
local Window

-- Jalur Library yang benar sesuai decompile
-- Tambahkan di bawah variabel Config (Sekitar baris 30)

-- ==========================================
-- MANUAL SERVICE LOCATOR (FIX ERROR)
-- ==========================================
local LibraryModule = ReplicatedStorage:WaitForChild("frame_work"):WaitForChild("library")

local NightXLibrary = {}

-- Bypass get_service: Langsung require ke folder _services
function NightXLibrary.get_service(name)
    return require(LibraryModule:WaitForChild("_services"):WaitForChild(name))
end

-- Bypass get_index: Langsung require ke folder _index
function NightXLibrary.get_index(name)
    return require(LibraryModule:WaitForChild("_index"):WaitForChild(name))
end

-- Bypass get_connection: Langsung ambil dari module connection
function NightXLibrary.get_connection()
    return require(LibraryModule:WaitForChild("connection")).getConnection()
end

-- ==========================================
-- INISIALISASI DATA & SERVICES
-- ==========================================
local Debounce = NightXLibrary.get_service("debounce_service")
local DropsService = NightXLibrary.get_service("drops_service") -- Tambahkan ini
local Connection = NightXLibrary.get_connection()
local AbbreviateService = NightXLibrary.get_service("abbreviate_service")
local GradientFolder = ReplicatedStorage:WaitForChild("_assets"):WaitForChild("_gradients")
local EnemiesIndex = NightXLibrary.get_index("_enemies")
local DropsIndex = NightXLibrary.get_index("_drops")
local ItemsIndex = NightXLibrary.get_index("_items")
local VaultGachasIndex = NightXLibrary.get_index("_vault_gachas")
local AccessoriesIndex = NightXLibrary.get_index("_accessories")
local AscensionData = NightXLibrary.get_index("_ascension")
local IslandsIndex = NightXLibrary.get_index("_islands")
local WeaponsIndex = NightXLibrary.get_index("_weapons")
local MultsIndex = NightXLibrary.get_index("_mults")
-- Fungsi untuk mengecek apakah sedang dalam Minigame
local function IsInMinigame()
    local enemiesFolder = workspace:FindFirstChild("_enemies")
    if enemiesFolder then
        local firstEnemy = enemiesFolder:FindFirstChildOfClass("Model")
        if firstEnemy then
            -- Menambahkan pengecekan atribut _area -200
            if firstEnemy:GetAttribute("Minigame") or firstEnemy:GetAttribute("_area") == -200 then
                return true
            end
        end
    end
    return false
end

-- ==========================================
-- PERBAIKAN FUNGSI GETBESTTARGET
-- ==========================================
local function GetBestTarget()
    local enemiesFolder = workspace:FindFirstChild("_enemies")
    if not enemiesFolder then return nil end
    
    local inMinigame = IsInMinigame()
    -- Jika tidak di minigame dan tidak ada musuh yang dipilih di dropdown, batalkan target
    if not inMinigame and #Config.SelectedEnemies == 0 then return nil end
    
    local target = nil
    local shortestDist = math.huge
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, v in pairs(enemiesFolder:GetChildren()) do
        local enemyArea = v:GetAttribute("_area")
        local isMinigameEnemy = v:GetAttribute("Minigame") or enemyArea == -200
        
        -- LOGIKA FILTER:
        -- 1. Jika di Minigame: Hanya boleh target musuh yang punya atribut Minigame/Area -200
        -- 2. Jika Farm Biasa: Hanya target musuh yang ada di daftar SelectedEnemies (Dropdown)
        local isSelected = false
        if inMinigame then
            isSelected = isMinigameEnemy 
        else
            -- Pastikan musuh bukan musuh minigame saat sedang farm biasa
            isSelected = not isMinigameEnemy and table.find(Config.SelectedEnemies, v.Name)
        end
        
        if isSelected and v:FindFirstChild("HumanoidRootPart") and v:GetAttribute("_id") then
            local currentHP = v:GetAttribute("_h")
            if currentHP and currentHP > 0 then
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
    local enemiesFolder = workspace:FindFirstChild("_enemies")
    
    if enemiesFolder then
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy:GetAttribute("_id") and not processed[enemy.Name] then
                processed[enemy.Name] = true
                
                local stats = EnemiesIndex[enemy.Name]
                if stats then
                    local displayName = stats[1]
                    local mapId = stats[3]
                    
                    local maxHP = enemy:GetAttribute("_m_h") or stats[2]
                    local maxDisplay = AbbreviateService and AbbreviateService:Comma(maxHP) or tostring(maxHP)
                    
                    local dropCards = {}
                    local targetDropData = DropsIndex[enemy.Name]

                    if not targetDropData then
                        for islandKey, islandInfo in pairs(IslandsIndex) do
                            if islandInfo[3] == mapId then
                                targetDropData = DropsIndex[islandKey]
                                if targetDropData then break end
                            end
                        end
                    end
                    
                    if targetDropData then
                        for groupIndex, groupItems in pairs(targetDropData) do
                            if typeof(groupIndex) == "number" and typeof(groupItems) == "table" then
                                for rate, details in pairs(groupItems) do
                                    if typeof(rate) == "number" and typeof(details) == "table" then
                                        local itemId = details[1]
                                        local rawAmount = details[2]
                                        local dropType = details[3]
                                        
                                        local itemInfo = nil
                                        local itemName = "Unknown"
                                        local itemImage = "rbxassetid://0"
                                        
                                        if dropType == "Accessory" or AccessoriesIndex[itemId] then
                                            itemInfo = AccessoriesIndex[itemId]
                                            if itemInfo then
                                                itemName = itemInfo[1]
                                                itemImage = itemInfo["_image"]
                                            end
                                        end
                                        
                                        if not itemInfo then
                                            itemInfo = ItemsIndex[itemId]
                                            if itemInfo then
                                                itemName = itemInfo[1][1]
                                                itemImage = itemInfo["_image"]
                                            end
                                        end
                                        
                                        if itemInfo then
                                            local amountStr = (typeof(rawAmount) == "table") and (rawAmount[1] .. "-" .. rawAmount[2] .. "x") or (tostring(rawAmount or 1) .. "x")
                                            local rarityName = (dropType == "Accessory") and "Legendary" or (itemInfo.Rarity or "Common")
                                            local gradObj = GradientFolder:FindFirstChild(rarityName)

                                            table.insert(dropCards, {
                                                Title = itemName,
                                                Quantity = amountStr,
                                                Rate = rate .. "%",
                                                Gradient = gradObj and gradObj.Color or Color3.fromRGB(0, 162, 255),
                                                Image = itemImage
                                            })
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    table.insert(list, {
                        Title = string.format("%s", displayName),
                        Desc = string.format("HP: %s", maxDisplay),
                        Images = dropCards, 
                        RawName = enemy.Name,
                        Rarity = maxHP
                    })
                end
            end
        end
    end
    table.sort(list, function(a, b) return (a.Rarity or 0) < (b.Rarity or 0) end)
    return list
end

-- Tabel untuk menyimpan daftar RemoteEvent agar tidak mencari ulang
local cachedRemotes = {}

-- Fungsi untuk mengumpulkan RemoteEvent (hanya dijalankan sekali)
local function refreshRemoteCache()
    cachedRemotes = {}
    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v:IsA("RemoteEvent") then
            table.insert(cachedRemotes, v)
        end
    end
end

-- Panggil pertama kali
refreshRemoteCache()

local function SendConnection(...)
    local binaryData = "01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01100110 01110010 01100001 01101101 01100101 01011111 01110111 01101111 01110010 01101011 00101110 01101100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01100011 01101111 01101110 01101110 01100101 01100011 01110100 01101001 01101111 01101110 00101110 01110100 01101000 01110010 01100101 01100001 01100100 01011111 01110011 01100101 01100011 01110101 01110010 01101001 01110100 01111001 00111010 00110001 00001010 01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01100110 01110010 01100001 01101101 01100101 01011111 01110111 01101111 01110010 01101011 00101110 01101100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01100011 01101111 01101110 01101110 01100101 01100011 01110100 01101001 01101111 01101110 00111010 00110001 00110101 00111001 00100000 01100110 01110101 01101110 01100011 01110100 01101001 01101111 01101110 00100000 01110011 01100101 01101110 01100100 00001010 01010010 01100101 01110000 01101100 01101001 01100011 01100001 01110100 01100101 01100100 01010011 01110100 01101111 01110010 01100001 01100111 01100101 00101110 01100110 01110010 01100001 01101101 01100101 01011111 01110111 01101111 01110010 01101011 00101110 01101100 01101001 01100010 01110010 01100001 01110010 01111001 00101110 01011111 01110011 01100101 01110100 01110101 01110000 01110011 00101110 01000011 01001111 01010010 01000101 00101110 01011111 01110011 01100101 01110100 01110101 01110000 01110011 00101110 00110001 00100000 11100010 10000000 10100010 00100000 01101101 01101111 01110110 01100101 00100000 01110011 01100101 01110100 00101110 00110010 00100000 11100010 10000000 10100010 00100000 01101101 01101111 01110101 01110011 01100101 00111010 00110101 00111000 00001010" -- Data biner kamu
    local args = {binaryData, ...}

    if #cachedRemotes > 0 then
        -- Pilih satu RemoteEvent secara acak dari cache
        local randomRemote = cachedRemotes[math.random(1, #cachedRemotes)]
        randomRemote:FireServer(unpack(args))
    end
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

-- setclipboard(JSONPretty(DropsIndex, 1))
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

UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v=" .. math.random()))()

Window = UI:CreateWindow({
    Title = "AN Hub - Anime Spike",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeSpike",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Spike" }),
    SidebarProfile = true
})

local function IsWindowAlive()
    return Window and not Window.Destroyed
end

local function IsWindowOpen()
    return IsWindowAlive() and not Window.Closed
end

local _UIStateByObject = setmetatable({}, { __mode = "k" })
local _UIOpenEpoch = 0
local _UIOnOpenCallbacks = {}

local function _RegisterUIOnOpen(fn)
    if type(fn) ~= "function" then
        return
    end
    table.insert(_UIOnOpenCallbacks, fn)
end

Optimizer = Optimizer or {
    Cache = {
        RankUp = {},
        VaultGachas = { Entries = {}, Cursor = 1 },
        WeaponShop = {}
    }
}

function Optimizer.MarkUIStale()
    local c = Optimizer.Cache
    c.RankUp.LastRank = nil
    c.RankUp.LastCoins = nil
    c.RankUp.LastAscend = nil
    c.RankUp.NextCost = nil

    c.WeaponShop.LastWeaponShop = nil
    c.WeaponShop.LastCoins = nil
    c.WeaponShop.LastDiscount = nil
    c.WeaponShop.LastMainImageKey = nil
    c.WeaponShop.NextPrice = nil

    c.VaultGachas.Cursor = 1
    for _, e in ipairs(c.VaultGachas.Entries) do
        if type(e) == "table" then
            e.lastOwned = nil
            e.lastEquippedId = nil
            e.lastLockReason = nil
            e.lastDesc = nil
        end
    end
end

local function _GetUIState(ui)
    if not ui then
        return nil
    end
    local state = _UIStateByObject[ui]
    if not state then
        state = {}
        _UIStateByObject[ui] = state
    end
    return state
end

local function _ApplyUIState(ui)
    if not ui or not IsWindowOpen() then
        return
    end

    local state = _UIStateByObject[ui]
    if not state then
        return
    end

    if state.desiredTitle ~= nil and ui.SetTitle and (state.appliedTitle ~= state.desiredTitle or state.appliedTitleEpoch ~= _UIOpenEpoch) then
        pcall(function()
            ui:SetTitle(state.desiredTitle)
            state.appliedTitle = state.desiredTitle
            state.appliedTitleEpoch = _UIOpenEpoch
        end)
    end

    if state.desiredDesc ~= nil and ui.SetDesc and (state.appliedDesc ~= state.desiredDesc or state.appliedDescEpoch ~= _UIOpenEpoch) then
        pcall(function()
            ui:SetDesc(state.desiredDesc)
            state.appliedDesc = state.desiredDesc
            state.appliedDescEpoch = _UIOpenEpoch
        end)
    end

    local desiredImageKey = nil
    if state.desiredMainImageKey ~= nil then
        desiredImageKey = tostring(state.desiredMainImageKey) .. "|" .. tostring(state.desiredMainImageSize)
    elseif state.desiredMainImageVersion ~= nil then
        desiredImageKey = state.desiredMainImageVersion
    end

    if desiredImageKey ~= nil and ui.SetMainImage and (state.appliedMainImageKey ~= desiredImageKey or state.appliedMainImageEpoch ~= _UIOpenEpoch) then
        pcall(function()
            if state.desiredMainImageSize ~= nil then
                ui:SetMainImage(state.desiredMainImage, state.desiredMainImageSize)
            else
                ui:SetMainImage(state.desiredMainImage)
            end
            state.appliedMainImageKey = desiredImageKey
            state.appliedMainImageEpoch = _UIOpenEpoch
        end)
    end
end

local function _FlushAllUIStates()
    if not IsWindowOpen() then
        return
    end
    for ui, _ in pairs(_UIStateByObject) do
        _ApplyUIState(ui)
    end
end

do
    local function onOpen()
        _UIOpenEpoch = _UIOpenEpoch + 1
        pcall(function()
            if Optimizer and Optimizer.MarkUIStale then
                Optimizer.MarkUIStale()
            end
        end)
        for _, fn in ipairs(_UIOnOpenCallbacks) do
            pcall(fn)
        end
        task.defer(_FlushAllUIStates)
    end

    if type(Window) == "table" and Window.OnOpen and Window.OnClose then
        Window:OnOpen(onOpen)
    else
        task.spawn(function()
            local wasClosed = Window and Window.Closed == true
            while Window and not Window.Destroyed do
                local isClosed = Window.Closed == true
                if wasClosed and not isClosed then
                    onOpen()
                end
                wasClosed = isClosed
                task.wait(0.1)
            end
        end)
    end
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
    ["Vault Gachas"] = "Remote gacha machines from anywhere.", -- Deskripsi baru
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
        Desc = "Anime Spike"
    }),
    SidebarProfile = false
});

FM_CategorySelector = FarmTab:Category({
    Title = "Select Category",
    Default = "Farm",
    Options = {
        {Title = "Farm", Icon = "rbxassetid://89761068698333"},
        {Title = "Rank Up", Icon = "rbxassetid://74044855367151"},
        {Title = "Vault Gachas", Icon = "rbxassetid://89761068698333"},
        {Title = "Mini Game", Icon = "rbxassetid://109634928579023"},
        {Title = "Trial/Power Upgrade", Icon = "rbxassetid://79672544012982"},
        {Title = "Eggs", Icon = "rbxassetid://92349810618564"},
        {Title = "Weapon Shop", Icon = "rbxassetid://107655675881805"}
    },
    Callback = FM_OnChange
})
local lastMiniState = false -- Variabel pembantu untuk deteksi perpindahan mode
local FarmGroup1 = FM_Add("Farm", FarmTab:Group({ Title = "Combat & Targeting" }))

local EnemyDropdown = FarmGroup1:Dropdown({
    Title = "Select Enemy",
    Values = GetEnemiesList(),
    Multi = true,
    AllowNone = true,
    Flag = "EnemySelector_Config",
    Callback = function(val)
        Config.SelectedEnemies = {}
        if typeof(val) == "table" then for _, item in ipairs(val) do table.insert(Config.SelectedEnemies, item.RawName) end end
        currentTarget = nil
    end
})

FarmGroup1:Toggle({
    Title = "Auto Attack Enemies",
    Default = false,
    Flag = "AutoAttack_Toggle",
    Callback = function(val)
        Config.AutoFarm = val
        if val then
            task.spawn(function()
                while Config.AutoFarm do
                    task.wait(0.3)
                    if not IsWindowAlive() then break end

                    local currentTime = os.date("*t")
                    local min = currentTime.min
                    local isTrialTime = (min == 0 or min == 1 or min == 30 or min == 31)
                    local inMini = IsInMinigame()

                    if Config.AutoTrialEasy and isTrialTime and not inMini then
                        currentTarget = nil 
                        task.wait(1) 
                        continue 
                    end

                    local enemiesFolder = workspace:FindFirstChild("_enemies")
                    local firstEnemy = enemiesFolder and enemiesFolder:FindFirstChildOfClass("Model")
                    local isPowerArea = firstEnemy and firstEnemy:GetAttribute("_area") == -200
                    
                    if lastMiniState ~= inMini then
                        lastMiniState = inMini
                        currentTarget = nil
                    end

                    if Config.AutoPowerArea and isPowerArea then
                        local char = LocalPlayer.Character
                        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                        local powerPos = Vector3.new(52255.9921875, 3.5937516689300537, 15767.1015625)

                        if myRoot and (myRoot.Position - powerPos).Magnitude > 10 then
                            myRoot.CFrame = CFrame.new(powerPos)
                        end
                    elseif inMini or #Config.SelectedEnemies > 0 then
                        local enemyArea = currentTarget and currentTarget:GetAttribute("_area")
                        local currentTargetIsMini = currentTarget and (currentTarget:GetAttribute("Minigame") or enemyArea == -200)
                        
                        local isValid = currentTarget 
                            and currentTarget.Parent 
                            and (currentTarget:GetAttribute("_h") and currentTarget:GetAttribute("_h") > 0)
                            and (inMini == currentTargetIsMini) 

                        if not isValid then
                            currentTarget = GetBestTarget()
                        end

                        if currentTarget and currentTarget:FindFirstChild("HumanoidRootPart") then
                            local char = LocalPlayer.Character
                            local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                            if myRoot then
                                local distance = (myRoot.Position - currentTarget.HumanoidRootPart.Position).Magnitude
                                local offsetZ = inMini and 5 or 9
                                if distance > 10 then 
                                    myRoot.CFrame = currentTarget.HumanoidRootPart.CFrame * CFrame.new(0, 0, offsetZ)
                                end
                            end
                        end
                    else
                        currentTarget = nil
                    end
                end
            end)
        end
    end
})
local FarmGroup2 = FM_Add("Farm", FarmTab:Group({ Title = "Fast Attack & Utility" }))

local AutoFastAttackToggle
AutoFastAttackToggle = FarmGroup2:Toggle({
    Title = "Auto Fast Attack",
    Default = false,
    Flag = "AutoFastAttack_Toggle",
    Callback = function(val)
        if not IsPremium then
            Config.FastClick = false
            pcall(function()
                AutoFastAttackToggle:Unlock()
                AutoFastAttackToggle:Set(false, false, true)
                AutoFastAttackToggle:Lock("Premium Only")
            end)
            return
        end
        Config.FastClick = val
        while task.wait() do
            if not Window or Window.Destroyed then break end
            if IsPremium and not Config.FastClick then
                SendConnection("System", "_main", "_click")
            else
                break
            end
        end
    end
})
OriginalDebounceCheck = Debounce.Check
-- [[ AUTO COLLECT TIME REWARDS ]] --
Config.AutoTimeRewards = false
-- Cari bagian Debounce.Check di script kamu dan ganti/tambahkan seperti ini:
task.spawn(function()
    while task.wait(0.1) do
        if not Window or Window.Destroyed then 
            Config.FastClick = false
            break
        end
        
        -- Bypass Cooldown (Sudah ada di script kamu)
        Debounce.Check = function(player, action, duration)
            if (action == "_combat" or action == "_click_client" or action == "_rating") and Config.FastClick then
                return false
            end
            if action == "AntiAfkCounter" then return true end
            return OriginalDebounceCheck(player, action, duration)
        end
    end
end)
local AutoTimeRewardsToggle
AutoTimeRewardsToggle = FarmGroup2:Toggle({
    Title = "Auto Collect Time Rewards",
    Desc = "Automatically claims playtime rewards when ready.",
    Default = false,
    Flag = "AutoTimeRewards_Toggle",
    Callback = function(val)
        if val and not IsPremium then
            Config.AutoTimeRewards = false
            pcall(function()
                AutoTimeRewardsToggle:Unlock()
                AutoTimeRewardsToggle:Set(false, false, true)
                AutoTimeRewardsToggle:Lock("Premium Only")
            end)
            return
        end
        Config.AutoTimeRewards = val
    end
})

-- Logika Premium Check untuk Group 2
if not IsPremium then
    Config.FastClick = false
    Config.AutoTimeRewards = false
    pcall(function()
        AutoFastAttackToggle:Set(false, false, true)
        AutoFastAttackToggle:Lock("Premium Only")
        AutoTimeRewardsToggle:Set(false, false, true)
        AutoTimeRewardsToggle:Lock("Premium Only")
    end)
end
-- [[ TIME REWARDS AUTO-COLLECT LOGIC ]] --
task.spawn(function()
    local TimeRewardsIndex = NightXLibrary.get_index("_time_rewards")
    local TimeRewardsFolder = LocalPlayer:WaitForChild("TimeRewards")

    while task.wait(3) do -- Check every 5 seconds to save CPU
        if not Window or Window.Destroyed then break end
        
        if Config.AutoTimeRewards then
            local currentPlaytime = LocalPlayer:GetAttribute("RewardsTime") or 0
            
            -- Loop through the reward index (usually 1 to 12)
            for i = 1, #TimeRewardsIndex do
                local rewardData = TimeRewardsIndex[i]
                local rewardId = tostring(i)
                
                if rewardData then
                    local requiredTime = rewardData[1]
                    local isClaimed = TimeRewardsFolder:GetAttribute(rewardId)
                    
                    -- Check if time is reached and not already claimed
                    if currentPlaytime >= requiredTime and not isClaimed then
                        -- Send the exact remote signal used by the game
                        SendConnection("System", "_main", "_collect_reward", rewardId)
                        
                        Notify("Farm", "Collected Time Reward #" .. rewardId, "gift")
                        task.wait(0.5) -- Small delay between claims
                    end
                end
            end
        end
    end
end)

local FarmGroup3 = FM_Add("Farm", FarmTab:Group({ Title = "Performance Boost" }))

FarmGroup3:Toggle({
    Title = "Delete Drop Animation",
    Desc = "Menghilangkan animasi koin/drop untuk mengurangi lag.",
    Default = false,
    Flag = "DeleteDropAnim_Toggle",
    Callback = function(val)
        Config.DeleteDropAnim = val
    end
})

FarmGroup3:Toggle({
    Title = "Disable Item Popups",
    Desc = "Removes item/gacha box animations that appear in the center.",
    Default = false,
    Flag = "DisableItemPopups_Toggle",
    Callback = function(val)
        Config.DisableItemPopups = val
    end
})
-- ==========================================
-- HOOKING DROP SERVICE (BYPASS ANIMATION)
-- ==========================================
local OldHandleDrop = DropsService._handle_drop
local OldCreateDrop = DropsService._create_drop

-- Hook _handle_drop to disable explosion effects and attachment spawning
DropsService._handle_drop = function(pos, amount, value, ...)
    if Config.DeleteDropAnim then
        -- We still call add_offset so the top coin HUD remains synchronized
        if shared.coins_hud and shared.coins_hud.add_offset then
            shared.coins_hud.add_offset(value)
        end
        
        -- Since we want to avoid physical objects, we do not call the original function.
        -- However, we must ensure the 'fill' reward in the HUD is still updated.
        if shared.coins_hud and shared.coins_hud.add_fill then
            shared.coins_hud.add_fill(value)
        end
        return 
    end
    return OldHandleDrop(pos, amount, value, ...)
end

-- Hook _create_drop to prevent items from entering the RenderStepped loop
DropsService._create_drop = function(pos, height, vel, adornee, event, ...)
    if Config.DeleteDropAnim then
        -- If there is an event (callback for HUD/Sound updates), execute it instantly
        if event then
            task.spawn(event)
        end
        
        -- If an object has already been created (adornee), destroy it immediately
        if adornee then
            adornee:Destroy()
        end
        
        -- Return an empty table to prevent errors in the game's RenderStepped loop
        return { ["position"] = Vector2.zero, ["event"] = nil }
    end
    return OldCreateDrop(pos, height, vel, adornee, event, ...)
end

-- ==========================================
-- HOOKING POPUP SERVICE (DISABLE ANIMATIONS)
-- ==========================================
local PopupService = NightXLibrary.get_service("popup_service")

-- Store original functions
local OldItemPopup = PopupService._item
local OldGachaPopup = PopupService._gacha

-- Hook Item Popup function
PopupService._item = function(itemId, amount, ...)
    if Config.DisableItemPopups then
        return -- Bypass UI Tween creation
    end
    return OldItemPopup(itemId, amount, ...)
end

-- Hook Gacha Popup function
PopupService._gacha = function(gachaId, rollIndex, amount, ...)
    if Config.DisableItemPopups then
        return -- Bypass UI Tween creation
    end
    return OldGachaPopup(gachaId, rollIndex, amount, ...)
end
-- [[ ELEMEN UNTUK KATEGORI RANK UP ]] --

local RankUpToggle = FM_Add("Rank Up", FarmTab:Toggle({
    Title = "Auto Rank Up",
    Desc = "Mengecek persyaratan...",
    Default = false,
    Flag = "AutoRankUp_Toggle",
    Callback = function(val)
        Config.AutoRankUp = val
    end
}))

local _RankUpUIState = _GetUIState(RankUpToggle)

local function UpdateRankUpUI()
    if not IsWindowAlive() or not RankUpToggle then
        return
    end

    local currentRank = LocalPlayer:GetAttribute("Rank") or 0
    local currentCoins = LocalPlayer:GetAttribute("Coins") or 0
    local cache = Optimizer and Optimizer.Cache and Optimizer.Cache.RankUp

    -- Prevent redundant updates if data hasn't changed
    if cache and cache.LastRank == currentRank and cache.LastCoins == currentCoins then
        if IsWindowOpen() then _ApplyUIState(RankUpToggle) end
        return
    end

    if cache then
        cache.LastRank = currentRank
        cache.LastCoins = currentCoins
    end

    local nextRankData = AscensionData[currentRank + 1]
    local currentRankData = AscensionData[currentRank]

    if nextRankData then
        local cost = nextRankData[1]
        if cache then cache.NextCost = cost end
        
        local progress = math.clamp(currentCoins / cost, 0, 1)
        local barLen = 15
        local filled = math.floor(progress * barLen)
        local bar = "[" .. string.rep("█", filled) .. string.rep("░", barLen - filled) .. "]"

        local titleTxt = string.format("Rank: %s | Bonus: +%s%%", currentRank, (currentRankData[2] - 1) * 100)
        local descTxt = string.format("%s %s%%\nCoins: %s / %s", bar, math.floor(progress * 100), AbbreviateService:Comma(currentCoins), AbbreviateService:Comma(cost))

        if _RankUpUIState then
            _RankUpUIState.desiredTitle = titleTxt
            _RankUpUIState.desiredDesc = descTxt
        end

        -- Ensure the toggle is unlocked if not yet Max
        pcall(function() RankUpToggle:Unlock() end)

        if Config.AutoRankUp and currentCoins >= cost then
            local now = os.clock()
            if (now - (cache.LastAscend or 0)) >= 1 then
                cache.LastAscend = now
                SendConnection("System", "_main", "_ascension")
                Notify("Rank Up!", "Successfully ascended to Rank " .. (currentRank + 1), "arrow-up")
            end
        end
    else
        -- LOGIC FOR MAX RANK
        if cache then cache.NextCost = nil end
        if _RankUpUIState then
            _RankUpUIState.desiredTitle = "Rank: MAX"
            _RankUpUIState.desiredDesc = "You have reached the maximum Rank!"
        end
        
        pcall(function()
            Config.AutoRankUp = false -- Disable config
            RankUpToggle:Set(false, true) -- Set visual toggle to OFF
            RankUpToggle:Lock("Max Rank Reached") -- Lock the UI element
        end)
    end
    
    if IsWindowOpen() then _FlushAllUIStates() end
end

LocalPlayer.AttributeChanged:Connect(function(attr)
    if attr == "Rank" or attr == "Coins" then
        UpdateRankUpUI()
    end
end)

_RegisterUIOnOpen(UpdateRankUpUI)
task.delay(1, UpdateRankUpUI)

task.spawn(function()
    while Window and not Window.Destroyed do
        if Config.AutoRankUp then
            UpdateRankUpUI()
            task.wait(0.25)
        else
            task.wait(0.6)
        end
    end
end)

-- [[ ELEMEN UNTUK KATEGORI VAULT GACHAS ]] --

local ActiveGachaToggles = {}
-- [[ ELEMEN UNTUK KATEGORI VAULT GACHAS (GROUP VERSION) ]] --

-- 1. Kumpulkan data agar bisa diurutkan (Pairs acak, jadi perlu tabel biasa)
local SortedGachas = {}
for gachaId, gachaData in pairs(VaultGachasIndex) do
    table.insert(SortedGachas, {ID = gachaId, Data = gachaData})
end

-- 2. Urutkan berdasarkan ID (Nama) agar posisi item stabil
table.sort(SortedGachas, function(a, b) return a.ID < b.ID end)

local function UpdateVaultGachaEntry(entry, isOpen)
    if not entry or not entry.toggle then
        return
    end

    if isOpen == nil then
        isOpen = IsWindowOpen()
    end

    -- Fungsi untuk menerapkan perubahan visual secara instan
    local function applyVisuals()
        if not isOpen then return end

        if entry.appliedLockReason ~= entry.desiredLockReason or entry.appliedLockEpoch ~= _UIOpenEpoch then
            entry.appliedLockEpoch = _UIOpenEpoch
            entry.appliedLockReason = entry.desiredLockReason
            
            pcall(function()
                if entry.desiredLockReason then
                    -- URUTAN PENTING: Buka dulu -> Matikan -> Baru Kunci
                    entry.toggle:Unlock() 
                    entry.toggle:Set(false, true) -- false = off, true = skip callback agar tidak spam remote
                    entry.toggle:Lock(entry.desiredLockReason)
                else
                    entry.toggle:Unlock()
                end
            end)
        end

        _ApplyUIState(entry.toggle)
    end

    if not entry.vaultFolder then
        local mainFolder = LocalPlayer:FindFirstChild("VaultGachas")
        if mainFolder then
            entry.vaultFolder = mainFolder:FindFirstChild(entry.gachaId)
        end
    end

    local invItem = LocalPlayer.Inventory.Items:FindFirstChild(entry.costId)
    local owned = invItem and invItem:GetAttribute("Amount") or 0
    local equippedId = entry.vaultFolder and entry.vaultFolder:GetAttribute("Name") or ""
    local equippedNum = tonumber(equippedId) or -1
    
    -- Tentukan alasan Lock
    local lockReason = nil
    if not IsPremium then
        lockReason = "Premium Only"
    elseif equippedNum == 1 then
        lockReason = "Secret Equipped!"
    end
    
    entry.desiredLockReason = lockReason

    -- Jika terkunci, pastikan config di script juga mati
    if lockReason then
        Config["AutoGacha_" .. entry.gachaId] = false
    end

    if owned == entry.lastOwned and equippedId == entry.lastEquippedId and lockReason == entry.lastLockReason then
        applyVisuals()
        return
    end

    entry.lastOwned = owned
    entry.lastEquippedId = equippedId
    entry.lastLockReason = lockReason

    local equippedData = entry.gachaData[equippedNum]
    local price = 1
    local colorCode = (owned >= price) and "#00FF00" or "#FF0000"
    local materialStatus = string.format("<font color=\"%s\">%s: %s/%s</font>", colorCode, entry.costName, AbbreviateService:Comma(owned), price)

    local currentDesc = ""
    if equippedData and equippedId ~= "" then
        currentDesc = string.format("Equipped: %s (%s%%)\n%s\nStats:", equippedData[2], equippedData[1], materialStatus)
        for stat, val in pairs(equippedData.Mults or {}) do
            currentDesc = currentDesc .. string.format("\n• %s: +%s%%", stat, val * 100)
        end
    else
        currentDesc = "Empty\n" .. materialStatus
    end

    if currentDesc ~= entry.lastDesc then
        entry.lastDesc = currentDesc
        if entry.uiState then entry.uiState.desiredDesc = currentDesc end
    end

    if equippedId ~= entry.lastEquippedIdForImage then
        entry.lastEquippedIdForImage = equippedId
        if equippedData and equippedId ~= "" and entry.uiState then
            local rarityName = equippedData[2]
            local gradientObj = GradientFolder:FindFirstChild(rarityName)
            entry.uiState.desiredMainImage = {
                Image = equippedData.Image or "rbxassetid://0",
                Gradient = gradientObj and gradientObj.Color or nil,
                Quantity = equippedData[1] .. "%",
                Title = rarityName
            }
            entry.uiState.desiredMainImageSize = 50
            entry.uiState.desiredMainImageKey = tostring(equippedId)
        end
    end

    applyVisuals()
end

task.spawn(function()
    while Window and not Window.Destroyed do
        local isOpen = IsWindowOpen()
        local entries = Optimizer and Optimizer.Cache and Optimizer.Cache.VaultGachas and Optimizer.Cache.VaultGachas.Entries
        if not entries or #entries == 0 then
            task.wait(0.5)
            continue
        end

        local n = #entries
        local cursor = Optimizer.Cache.VaultGachas.Cursor or 1
        if cursor < 1 or cursor > n then
            cursor = 1
        end

        local perTick = isOpen and math.clamp(math.floor(n / 10) + 1, 1, 6) or math.clamp(math.floor(n / 20) + 1, 1, 3)
        for _ = 1, perTick do
            local entry = entries[cursor]
            cursor = cursor + 1
            if cursor > n then
                cursor = 1
            end
            pcall(function()
                UpdateVaultGachaEntry(entry, isOpen)
            end)
        end
        Optimizer.Cache.VaultGachas.Cursor = cursor

        task.wait(isOpen and 0.15 or 0.25)
    end
end)

_RegisterUIOnOpen(function()
    local entries = Optimizer and Optimizer.Cache and Optimizer.Cache.VaultGachas and Optimizer.Cache.VaultGachas.Entries
    if not entries or #entries == 0 then
        return
    end
    Optimizer.Cache.VaultGachas.Cursor = 1
    task.defer(function()
        local isOpen = IsWindowOpen()
        for i, e in ipairs(entries) do
            UpdateVaultGachaEntry(e, isOpen)
            if i % 4 == 0 then
                task.wait()
            end
        end
    end)
end)

local function CreateGachaToggle(ParentGroup, gachaId, gachaData)
    local cleanName = gachaId:gsub("^_", ""):gsub("_", " ")
    cleanName = cleanName:sub(1,1):upper() .. cleanName:sub(2)

    local costId = gachaData.Cost
    local costItem = ItemsIndex[costId]
    local costName = costItem and costItem[1][1] or "Unknown"

    local GachaToggle = ParentGroup:Toggle({
        Title = cleanName,
        Default = false,
        Image = gachaData[1] and gachaData[1].Image or "rbxassetid://0", 
        Flag = "AutoGacha_" .. gachaId,
        Callback = function(val)
            if val then
                -- Cek kondisi sebelum mengaktifkan
                local folder = LocalPlayer:FindFirstChild("VaultGachas")
                local targetFolder = folder and folder:FindFirstChild(gachaId)
                local equippedId = targetFolder and targetFolder:GetAttribute("Name") or ""
                
                if not IsPremium or equippedId == "1" then
                    Config["AutoGacha_" .. gachaId] = false
                    task.spawn(function()
                        GachaToggle:Unlock()
                        GachaToggle:Set(false, true) -- Matikan visual tanpa trigger callback lagi
                        GachaToggle:Lock(not IsPremium and "Premium Only" or "Secret Equipped!")
                    end)
                    return
                end
            end
            
            Config["AutoGacha_" .. gachaId] = val
            if val then
                task.spawn(function()
                    while Config["AutoGacha_" .. gachaId] do
                        if not Window or Window.Destroyed then break end
                        local invItem = LocalPlayer.Inventory.Items:FindFirstChild(costId)
                        local owned = invItem and invItem:GetAttribute("Amount") or 0
                        if owned >= 1 then
                            SendConnection("System", "_main", "_gachas", gachaId, 1)
                        end
                        task.wait(0.1)
                    end
                end)
            end
        end
    })

    -- Inisialisasi awal jika sudah terkunci
    local _GachaUIState = _GetUIState(GachaToggle)
    local entry = {
        gachaId = gachaId,
        gachaData = gachaData,
        costId = costId,
        costName = costName,
        toggle = GachaToggle,
        uiState = _GachaUIState,
        vaultFolder = LocalPlayer:WaitForChild("VaultGachas", 5):FindFirstChild(gachaId),
        lastOwned = nil,
        lastEquippedId = nil,
        lastEquippedIdForImage = nil,
        lastLockReason = nil,
        lastDesc = nil
    }
    table.insert(Optimizer.Cache.VaultGachas.Entries, entry)
end

-- 4. Loop Utama: Pasang Group setiap 2 Item
for i = 1, #SortedGachas, 2 do
    local item1 = SortedGachas[i]
    local item2 = SortedGachas[i+1] -- Bisa nil jika jumlah gacha ganjil

    -- Buat Group Container & Daftarkan ke sistem Kategori
    local Group = FM_Add("Vault Gachas", FarmTab:Group({}))

    -- Pasang Toggle Item 1
    CreateGachaToggle(Group, item1.ID, item1.Data)

    -- Pasang Toggle Item 2 (Jika ada)
    if item2 then
        CreateGachaToggle(Group, item2.ID, item2.Data)
    end
end
-- Control variables
-- [[ MINI GAME & AUTO LEAVE ]] --
Config.TargetWave = 10;
-- [[ GLOBAL CONTROL & TRIAL SETTINGS ]] --
-- [[ MINI GAME: AUTO ENTRANCE & SPECIAL (TOP) ]] --
Config.LastIsland = ""

-- Group 1: Global Control & Tokyo
local GlobalGroup = FM_Add("Mini Game", FarmTab:Group({ Title = "Global Control & Tokyo" }))
GlobalGroup:Toggle({ 
    Title = "Mini Game Auto Leave", 
    Default = false, 
    Flag = "GlobalAutoLeave_Toggle", 
    Callback = function(val) Config.GlobalAutoLeave = val end 
})
GlobalGroup:Toggle({ 
    Title = "Auto Tokyo Raid", 
    Default = false, 
    Flag = "AutoTokyo_Toggle", 
    Callback = function(val) Config.AutoTokyoRaid = val end 
})

-- Group 2: Raids & Tower Entrance
local EntranceGroup = FM_Add("Mini Game", FarmTab:Group({ Title = "Raids & Tower Entrance" }))
EntranceGroup:Toggle({ 
    Title = "Auto DBZ Raid", 
    Default = false, 
    Flag = "AutoDBZ_Toggle", 
    Callback = function(val) Config.AutoDBZRaid = val end 
})
EntranceGroup:Toggle({ 
    Title = "Auto HxH Tower", 
    Default = false, 
    Flag = "AutoHXH_Toggle", 
    Callback = function(val) Config.AutoHXHTower = val end 
})

-- Group 3: Trial & Special Area
local SpecialGroup = FM_Add("Mini Game", FarmTab:Group({ Title = "Trial & Special Area" }))
SpecialGroup:Toggle({ 
    Title = "Auto Trial Easy", 
    Default = false, 
    Flag = "AutoTrial_Toggle", 
    Callback = function(val) Config.AutoTrialEasy = val end 
})

local AutoPowerAreaToggle
AutoPowerAreaToggle = SpecialGroup:Toggle({ 
    Title = "Auto 2x Power Area", 
    Default = false, 
    Flag = "AutoPowerArea_Toggle",
    Callback = function(val) 
        if val and not IsPremium then
            Config.AutoPowerArea = false
            pcall(function()
                AutoPowerAreaToggle:Unlock()
                AutoPowerAreaToggle:Set(false, false, true)
                AutoPowerAreaToggle:Lock("Premium Only")
            end)
            return
        end
        Config.AutoPowerArea = val 
    end 
})

-- [[ MINI GAME: TARGET WAVE SETTINGS (BOTTOM) ]] --

-- Group 4: Trial & Tokyo Waves
local WaveGroup1 = FM_Add("Mini Game", FarmTab:Group({ Title = "Trial & Tokyo Waves" }))
WaveGroup1:Input({ 
    Title = "Trial Target Wave", 
    Placeholder = "10", 
    Flag = "WaveTrial_Input", -- Menambahkan flag untuk menyimpan data Trial
    Callback = function(val) Config.Wave_Trial = tonumber(val) or 10 end 
})
WaveGroup1:Input({ 
    Title = "Tokyo Target Wave", 
    Placeholder = "5", 
    Flag = "WaveTokyo_Input", -- Menambahkan flag untuk menyimpan data Tokyo
    Callback = function(val) Config.Wave_Tokyo = tonumber(val) or 5 end 
})

-- Group 5: DBZ & HxH Waves
local WaveGroup2 = FM_Add("Mini Game", FarmTab:Group({ Title = "DBZ & HxH Waves" }))
WaveGroup2:Input({ 
    Title = "DBZ Target Wave", 
    Placeholder = "5", 
    Flag = "WaveDBZ_Input", -- Menambahkan flag untuk menyimpan data DBZ
    Callback = function(val) Config.Wave_DBZ = tonumber(val) or 5 end 
})
WaveGroup2:Input({ 
    Title = "HxH Tower Target Wave", 
    Placeholder = "15", 
    Flag = "WaveHXH_Input", -- Menambahkan flag untuk menyimpan data HxH
    Callback = function(val) Config.Wave_HXH = tonumber(val) or 15 end 
})

-- [[ FIXED MANUAL EXIT & SCHEDULER ]] --
-- Daftar Map yang tidak boleh disimpan sebagai LastIsland
local MiniMaps = {
    ["_trial_easy"] = true, 
    ["_dbz_defense"] = true, 
    ["_tokyo_raid"] = true, 
    ["_dbz_raid"] = true, 
    ["_hxh_tower"] = true,
    ["_hub"] = true, -- Jangan balik ke Hub/Lobby utama
    ["Lobby"] = true
}

task.spawn(function()
    local currentIslandObj = LocalPlayer:WaitForChild("CurrentIsland", 10)
    if currentIslandObj then
        currentIslandObj:GetAttributeChangedSignal("Name"):Connect(function()
            local currentLoc = currentIslandObj:GetAttribute("Name")
            
            -- Filter: Jangan teleport balik jika sedang di map minigame
            if not currentLoc or currentLoc == "" or MiniMaps[currentLoc] then return end

            if Config.LastIsland and Config.LastIsland ~= "" then
                if currentLoc ~= Config.LastIsland then
                    task.wait(2)
                    pcall(function()
                        local dest = Config.LastIsland
                        Config.LastIsland = nil -- Reset setelah digunakan
                        SendConnection("System", "_main", "_teleport", dest, "Lobby")
                        Notify("Teleport", "Returning to farm: " .. dest, "info")
                    end)
                else
                    Config.LastIsland = nil
                end
            end
        end)
    end
end)

-- [[ FIXED MANUAL EXIT & SCHEDULER ]] --
local lastTrialMinute = -1 
task.spawn(function()
    while task.wait(3) do
        if not Window or Window.Destroyed then break end
        
        local currentIslandObj = LocalPlayer:FindFirstChild("CurrentIsland")
        local currentLoc = currentIslandObj and currentIslandObj:GetAttribute("Name") or ""
        
        local currentTime = os.date("*t")
        local minute = currentTime.min
        
        -- =========================================================
        -- 1. PRIORITAS UTAMA: Logic Trial (Berdasarkan Waktu)
        -- =========================================================
        -- Kita pindahkan ini ke paling atas agar tetap dicek meskipun di minigame lain
        if Config.AutoTrialEasy and (minute == 0 or minute == 30) and minute ~= lastTrialMinute then
            -- Hanya teleport jika kita BELUM berada di Trial Easy
            if currentLoc ~= "_trial_easy" then
                lastTrialMinute = minute
                
                -- Simpan lokasi asal (LastIsland) HANYA jika lokasi saat ini bukan minigame/lobby
                if currentLoc ~= "" and not MiniMaps[currentLoc] then 
                    Config.LastIsland = currentLoc 
                end
                
                SendConnection("System", "_main", "_teleport", "_trial_easy")
                Notify("Trial", "Trial Started! Teleporting to Trial Easy...", "clock")
                task.wait(5) -- Beri jeda agar tidak spam saat proses pindah map
                continue -- Lanjut ke iterasi berikutnya setelah teleport
            end
        end

        -- =========================================================
        -- 2. GUARD CLAUSE: Cek Status Minigame Lain
        -- =========================================================
        -- Jika sudah di minigame (Raid/Tower/Trial), hentikan logika teleport tambahan
        -- agar tidak terjadi tumpang tindih (misal: sedang Tokyo Raid malah maksa ke DBZ Raid)
        if MiniMaps[currentLoc] and currentLoc ~= "_hub" then 
            continue 
        end 

        -- =========================================================
        -- 3. Logic Raid/Tower (Hanya jalan jika sedang di map farming biasa)
        -- =========================================================
        if currentLoc ~= "" and not MiniMaps[currentLoc] then
            if Config.AutoTokyoRaid then
                Config.LastIsland = currentLoc
                SendConnection("System", "_main", "_teleport", "_tokyo_raid")
            elseif Config.AutoDBZRaid then
                Config.LastIsland = currentLoc
                SendConnection("System", "_main", "_teleport", "_dbz_raid")
            elseif Config.AutoHXHTower then
                Config.LastIsland = currentLoc
                SendConnection("System", "_main", "_teleport", "_hxh_tower")
            end
        end
    end
end)

-- [[ SEPARATED TARGET WAVES WITH GLOBAL TOGGLE ]] --
Connection:receive("_update_minigame", function(data)
    if not Window or Window.Destroyed then return end
    if not data or typeof(data) ~= "table" or not Config.GlobalAutoLeave then return end

    local modeString = data[2] 
    if typeof(modeString) == "string" then
        local waveMatch = string.match(modeString, "Wave%s+(%d+)")
        local currentWave = waveMatch and tonumber(waveMatch)
        
        if currentWave then
            local currentIslandObj = LocalPlayer:FindFirstChild("CurrentIsland")
            local currentLoc = currentIslandObj and currentIslandObj:GetAttribute("Name") or ""
            
            local targetWave = 999 -- Default sangat tinggi jika tidak terdeteksi
            
            -- Menentukan target wave berdasarkan map saat ini
            if currentLoc == "_trial_easy" then
                targetWave = Config.Wave_Trial or 10
            elseif currentLoc == "_tokyo_raid" then
                targetWave = Config.Wave_Tokyo or 5
            elseif currentLoc == "_dbz_raid" then
                targetWave = Config.Wave_DBZ or 5
            elseif currentLoc == "_hxh_tower" then
                targetWave = Config.Wave_HXH or 15
            end

            -- Jika wave saat ini sudah mencapai atau melewati target
            if currentWave >= targetWave then
                pcall(function()
                    local destination = (Config.LastIsland and Config.LastIsland ~= "") and Config.LastIsland or "_hub"
                    SendConnection("System", "_main", "_teleport", destination, "Lobby")
                    Notify("Auto Leave", "Target reached in " .. currentLoc .. "! Returning to " .. destination, "info")
                end)
            end
        end
    end
end)

-- [[ UPDATED EGGS CATEGORY - BYPASS VERSION ]] --

-- 1. Egg Selection Dropdown
local EggList = {
    {Title = "Ninja Village", Value = 1},
    {Title = "Tokyo City", Value = 2},
    {Title = "XYZ Province", Value = 3},
    {Title = "Dragon Island", Value = 4},
    {Title = "Ant Island", Value = 5}
}

FM_Add("Eggs", FarmTab:Dropdown({
    Title = "Select Egg",
    Desc = "Choose which egg you want to hatch.",
    Values = EggList,
    Flag = "SelectedEgg_Dropdown",
    Callback = function(val)
        Config.SelectedEgg = val.Value
    end
}))

-- 3. Auto Hatch Toggle (With Animation & Logic Bypass)
FM_Add("Eggs", FarmTab:Toggle({
    Title = "Auto Hatch Eggs",
    Desc = "Bypass cooldown and animations for instant hatching.",
    Flag = "HatchEgg_Toggle",
    Default = false,
    -- Flag = "AutoHatch_Toggle",
    Callback = function(val)
        Config.AutoHatch = val
        -- Bypass Animasi via decompile path
        local EggService = require(ReplicatedStorage.frame_work.library._services.animations_service.egg)
        if val then
            if not getgenv().OriginalEggAnimation then
                getgenv().OriginalEggAnimation = EggService._s
            end
            EggService._s = function() end -- Mematikan fungsi animasi
        else
            if getgenv().OriginalEggAnimation then
                EggService._s = getgenv().OriginalEggAnimation
            end
        end
    end
}))

-- [[ OPTIMIZED AUTO HATCH LOOP (BYPASS 3s) ]] --
task.spawn(function()
    while true do
        -- Jeda minimal untuk stabilitas frame UI
        task.wait(0.1) 
        if not Window or Window.Destroyed then break end
        
        if Config.AutoHatch and Config.SelectedEgg then
            SendConnection("System", "_egg", "_open", Config.SelectedEgg)
        end
    end
end)

-- [[ WEAPON SHOP CATEGORY ]] --

-- Simpan toggle ke variabel lokal agar bisa diakses fungsi update
local WeaponInfoToggle = FM_Add("Weapon Shop", FarmTab:Toggle({
    Title = "Auto Buy Next Weapon",
    Desc = "Checking progress...",
    Default = false,
    Flag = "AutoWeapon_Toggle",
    Callback = function(val)
        Config.AutoWeaponShop = val
    end
}))

-- Fungsi Update yang dipanggil hanya saat diperlukan
local function SafeUpdateWeaponUI()
    -- Pastikan Window masih ada dan Toggle tidak nil
    if not IsWindowAlive() or not WeaponInfoToggle then return end

    local success, err = pcall(function()
        local currentWeaponShop = LocalPlayer:GetAttribute("WeaponShop") or 0
        local nextId = currentWeaponShop + 1
        local weaponData = WeaponsIndex[nextId]
        
        if weaponData then
            local discount = (MultsIndex and MultsIndex._discount) and MultsIndex._discount(LocalPlayer) or 1
            local finalPrice = (weaponData[4] or 0) / discount
            local currentCoins = LocalPlayer:GetAttribute("Coins") or 0
            
            -- Penyiapan Data Visual
            local weaponName = tostring(weaponData[1])
            local powerMult = tostring(AbbreviateService:Comma(weaponData[3]))
            local weaponImage = weaponData._image or weaponData.Image or "rbxassetid://0" -- Mengambil ID Gambar
            
            local displayTitle = "Next: " .. weaponName .. " (+" .. powerMult .. "x)"
            local displayDesc = string.format("Price: %s\nCoins: %s", tostring(AbbreviateService:Comma(finalPrice)), tostring(AbbreviateService:Comma(currentCoins)))
            
            -- Eksekusi aman di dalam thread UI
            task.defer(function()
                pcall(function()
                    WeaponInfoToggle:SetTitle(displayTitle)
                    WeaponInfoToggle:SetDesc(displayDesc)
                    WeaponInfoToggle:Unlock()
                end)
            end)

            -- Logika Auto Buy
            if Config.AutoWeaponShop and currentCoins >= finalPrice then
                SendConnection("System", "_main", "_weapon", "", "_all")
            end
        else
            -- Jika sudah mencapai level maksimal
            task.defer(function()
                WeaponInfoToggle:SetTitle("Weapon Shop: MAX")
                WeaponInfoToggle:SetDesc("All weapons unlocked.")
                WeaponInfoToggle:Lock("All weapons unlocked.")
                WeaponInfoToggle:Set(false)
            end)
        end
    end)
end

-- Hubungkan ke Event: Update hanya jika Coin atau Rank Toko berubah
LocalPlayer.AttributeChanged:Connect(function(attr)
    if attr == "Coins" or attr == "WeaponShop" then
        SafeUpdateWeaponUI()
    end
end)

-- Panggil sekali saat awal untuk inisialisasi teks dan gambar
task.delay(2, SafeUpdateWeaponUI)
-- [[ TRIAL & POWER UPGRADE CATEGORY - INTEGRATED LOGIC ]] --
local TrialUpgradeEntries = {}
local PowerUpgradeToggle = nil
local _PowerUpgradeUIState = nil
-- [[ TRIAL & POWER UPGRADE CATEGORY - UPDATED ]] --
local TrialUpgradeEntries = {}
local PowerUpgradeToggle = nil
local PowerUpgradeHXHToggle = nil -- Tambahan untuk HxH
local PowerUpgradeIndex = NightXLibrary.get_index("_power_upgrades")
local PowerUpgrade2Index = NightXLibrary.get_index("_power_upgrades2") -- Index HxH
-- [[ DAMAGE UPGRADE INDEX & HELPERS ]] --
local DamageUpgradeIndex = NightXLibrary.get_index("_damage_upgrades")
local DamageUpgrade2Index = NightXLibrary.get_index("_damage_upgrades2") -- Index untuk HxH

-- Helper: Mendapatkan jumlah Magic Books
local function GetMagicBooks()
    local inv = LocalPlayer:FindFirstChild("Inventory")
    local items = inv and inv:FindFirstChild("Items")
    local book = items and items:FindFirstChild("_magic_book")
    return book and book:GetAttribute("Amount") or 0
end
-- Helper: Mendapatkan jumlah Ametist (HxH Currency)
local function GetAmetists()
    local inv = LocalPlayer:FindFirstChild("Inventory")
    local items = inv and inv:FindFirstChild("Items")
    local ametist = items and items:FindFirstChild("_ametist")
    return ametist and ametist:GetAttribute("Amount") or 0
end

-- Fungsi Update Damage Upgrade Dragonball (Magic Books)
local function UpdateDamageUpgradeDBUI()
    if not IsWindowAlive() or not DamageUpgradeDBToggle then return end
    local level = LocalPlayer:GetAttribute("DamageUpgrade") or 0
    local books = GetMagicBooks()
    local maxLevel = #DamageUpgradeIndex
    local nextData = DamageUpgradeIndex[level + 1]
    local currentData = DamageUpgradeIndex[level]
    
    local bonus = currentData and ((currentData[2] - 1) * 100) .. "%" or "0%"
    local cost = nextData and nextData[1] or 0
    local isMax = level >= maxLevel
    local color = (books >= cost) and "#00FF00" or "#FF0000"

    pcall(function()
        DamageUpgradeDBToggle:SetTitle(isMax and "Damage Upgrade DB [MAX]" or "Damage Upgrade DB")
        DamageUpgradeDBToggle:SetDesc(string.format("Level: %d/%d | Bonus: +%s\n<font color=\"%s\">Magic Books: %s/%s</font>", 
            level, maxLevel, bonus, color, AbbreviateService:Comma(books), isMax and "MAX" or AbbreviateService:Comma(cost)))
        if isMax then DamageUpgradeDBToggle:Set(false, true); DamageUpgradeDBToggle:Lock("Max Level") end
    end)

    if IsPremium and Config.AutoDamageDB and not isMax and books >= cost then
        SendConnection("System", "_main", "_damage_upgrades")
    end
end

-- Fungsi Update Damage Upgrade HxH (Magic Books)
local function UpdateDamageUpgradeHXHUI()
    if not IsWindowAlive() or not DamageUpgradeHXHToggle then return end
    local level = LocalPlayer:GetAttribute("DamageUpgrade2") or 0
    local books = GetAmetists()
    local maxLevel = #DamageUpgrade2Index
    local nextData = DamageUpgrade2Index[level + 1]
    local currentData = DamageUpgrade2Index[level]
    
    local bonus = currentData and ((currentData[2] - 1) * 100) .. "%" or "0%"
    local cost = nextData and nextData[1] or 0
    local isMax = level >= maxLevel
    local color = (books >= cost) and "#00FF00" or "#FF0000"

    pcall(function()
        DamageUpgradeHXHToggle:SetTitle(isMax and "Damage Upgrade HxH [MAX]" or "Damage Upgrade HxH")
        DamageUpgradeHXHToggle:SetDesc(string.format("Level: %d/%d | Bonus: +%s\n<font color=\"%s\">Ametists: %s/%s</font>", 
            level, maxLevel, bonus, color, AbbreviateService:Comma(books), isMax and "MAX" or AbbreviateService:Comma(cost)))
        if isMax then DamageUpgradeHXHToggle:Set(false, true); DamageUpgradeHXHToggle:Lock("Max Level") end
    end)

    if IsPremium and Config.AutoDamageHXH and not isMax and books >= cost then
        SendConnection("System", "_main", "_damage_upgrades2")
    end
end
-- Fungsi Update untuk Power Upgrade HxH (Ametist)
local function UpdatePowerUpgradeHXHUI()
    if not IsWindowAlive() or not PowerUpgradeHXHToggle then return end
    
    local currentLevel = LocalPlayer:GetAttribute("PowerUpgrade2") or 0
    local ametistOwned = GetAmetists()
    local maxLevel = #PowerUpgrade2Index
    local nextData = PowerUpgrade2Index[currentLevel + 1]
    local currentData = PowerUpgrade2Index[currentLevel]
    
    local bonusTxt = currentData and ((currentData[2] - 1) * 100) .. "%" or "0%"
    local cost = nextData and nextData[1] or 0
    local isMax = currentLevel >= maxLevel
    
    local colorCode = (ametistOwned >= cost) and "#00FF00" or "#FF0000"
    local costDisplay = isMax and "MAX" or AbbreviateService:Comma(cost)
    local statusDesc = string.format("Level: %d/%d | Bonus: +%s\n<font color=\"%s\">Ametists: %s/%s</font>", 
        currentLevel, maxLevel, bonusTxt, colorCode, AbbreviateService:Comma(ametistOwned), costDisplay)

    pcall(function()
        PowerUpgradeHXHToggle:SetTitle(isMax and "Power Upgrade HxH [MAX]" or "Power Upgrade HxH")
        PowerUpgradeHXHToggle:SetDesc(statusDesc)
        
        if isMax then
            Config.AutoPowerUpgradeHXH = false
            PowerUpgradeHXHToggle:Set(false, true)
            PowerUpgradeHXHToggle:Lock("Max Level Reached")
        elseif not IsPremium then
            PowerUpgradeHXHToggle:Lock("Premium Only")
        else
            PowerUpgradeHXHToggle:Unlock()
        end
    end)

    if IsPremium and Config.AutoPowerUpgradeHXH and not isMax and ametistOwned >= cost then
        SendConnection("System", "_main", "_power_upgrades2")
    end
end
-- 1. Helper: Mendapatkan jumlah Dragon Shard
local function GetDragonShards()
    local inv = LocalPlayer:FindFirstChild("Inventory")
    local items = inv and inv:FindFirstChild("Items")
    local shard = items and items:FindFirstChild("_dbz_shard")
    return shard and shard:GetAttribute("Amount") or 0
end

-- 2. Helper: Mendapatkan jumlah Trial Upgrader
local function GetTrialCurrency()
    local inv = LocalPlayer:FindFirstChild("Inventory")
    local items = inv and inv:FindFirstChild("Items")
    local token = items and items:FindFirstChild("_trial_upgrader")
    return token and token:GetAttribute("Amount") or 0
end

-- 3. Fungsi Update untuk Power Upgrade (Dragon Shard)
local function UpdatePowerUpgradeUI()
    if not IsWindowAlive() or not PowerUpgradeToggle then return end
    
    local currentLevel = LocalPlayer:GetAttribute("PowerUpgrade") or 0
    local shardsOwned = GetDragonShards()
    local maxLevel = #PowerUpgradeIndex
    local nextData = PowerUpgradeIndex[currentLevel + 1]
    local currentData = PowerUpgradeIndex[currentLevel]
    
    local bonusTxt = currentData and ((currentData[2] - 1) * 100) .. "%" or "0%"
    local cost = nextData and nextData[1] or 0
    local isMax = currentLevel >= maxLevel
    
    local colorCode = (shardsOwned >= cost) and "#00FF00" or "#FF0000"
    local costDisplay = isMax and "MAX" or AbbreviateService:Comma(cost)
    local statusDesc = string.format("Level: %d/%d | Bonus: +%s\n<font color=\"%s\">Dragon Shards: %s/%s</font>", 
        currentLevel, maxLevel, bonusTxt, colorCode, AbbreviateService:Comma(shardsOwned), costDisplay)

    pcall(function()
        PowerUpgradeToggle:SetTitle(isMax and "Power Upgrade [MAX]" or "Power Upgrade")
        PowerUpgradeToggle:SetDesc(statusDesc)
        
        -- AUTOMATIC LOCK SYSTEM
        if isMax then
            Config.AutoPowerUpgrade = false
            PowerUpgradeToggle:Set(false, true)
            PowerUpgradeToggle:Lock("Max Level Reached")
        elseif not IsPremium then
            PowerUpgradeToggle:Lock("Premium Only")
        else
            PowerUpgradeToggle:Unlock()
        end
    end)

    if IsPremium and Config.AutoPowerUpgrade and not isMax and shardsOwned >= cost then
        SendConnection("System", "_main", "_power_upgrades")
    end
end

-- 4. Fungsi Update untuk Trial Upgrades (Trial Token)
local function UpdateTrialUpgradeUI()
    if not IsWindowAlive() then return end
    local folder = LocalPlayer:FindFirstChild("TrialUpgrades")
    local currency = GetTrialCurrency()

    for _, entry in ipairs(TrialUpgradeEntries) do
        local level = (folder and folder:GetAttribute(entry.Name)) or 1
        local bonusBase = (entry.Name == "Luck" and 1) or (table.find({"Power","CritChance","CritDmg"}, entry.Name) and 10) or (entry.Name == "Coins" and 2.5) or 5
        
        local cost = 5 * level 
        local bonusTotal = bonusBase * (level - 1)
        local isMax = level >= 11

        local colorCode = (currency >= cost) and "#00FF00" or "#FF0000"
        local materialStatus = string.format("<font color=\"%s\">Trial Upgrader: %s/%s</font>", 
            colorCode, AbbreviateService:Comma(currency), isMax and "MAX" or AbbreviateService:Comma(cost))

        pcall(function()
            entry.toggle:SetTitle(isMax and entry.Name .. " [MAX]" or entry.Name)
            entry.toggle:SetDesc(string.format("Level: %d/11 | Bonus: +%.1f%%\n%s", level, bonusTotal, materialStatus))
            
            -- AUTOMATIC LOCK SYSTEM
            if isMax then
                Config["AutoTrial_" .. entry.Name] = false
                entry.toggle:Set(false, true)
                entry.toggle:Lock("Max Level Reached")
            elseif not IsPremium then
                entry.toggle:Lock("Premium Only")
            else
                entry.toggle:Unlock()
            end
        end)

        if IsPremium and Config["AutoTrial_" .. entry.Name] and not isMax and currency >= cost then
            SendConnection("System", "_main", "_trial_upgrades", entry.Name)
        end
    end
end

-- Group 1: Power Upgrades (Dragon Shard & Ametist)
local MainPowerGroup = FM_Add("Trial/Power Upgrade", FarmTab:Group({ Title = "Special Power Upgrades" }))

-- Item 1: Dragon Shard
PowerUpgradeToggle = MainPowerGroup:Toggle({
    Title = "Power Upgrade Dragon",
    Desc = "Loading...",
    Default = false,
    Flag = "AutoPowerUpgrade_Toggle",
    Callback = function(val)
        if val and not IsPremium then
            Config.AutoPowerUpgrade = false
            pcall(function() PowerUpgradeToggle:Set(false, false, true); PowerUpgradeToggle:Lock("Premium Only") end)
            return
        end
        Config.AutoPowerUpgrade = val
    end
})

-- Item 2: HxH Power (Ametist)
PowerUpgradeHXHToggle = MainPowerGroup:Toggle({
    Title = "Power Upgrade HxH",
    Desc = "Loading...",
    Default = false,
    Flag = "AutoPowerUpgradeHXH_Toggle",
    Callback = function(val)
        if val and not IsPremium then
            Config.AutoPowerUpgradeHXH = false
            pcall(function() PowerUpgradeHXHToggle:Set(false, false, true); PowerUpgradeHXHToggle:Lock("Premium Only") end)
            return
        end
        Config.AutoPowerUpgradeHXH = val
    end
})
if not IsPremium then
    Config.AutoPowerUpgrade = false
    pcall(function()
        PowerUpgradeToggle:Set(false, false, true)
        PowerUpgradeToggle:Lock("Premium Only")
        PowerUpgradeHXHToggle:Set(false, false, true)
        PowerUpgradeHXHToggle:Lock("Premium Only")
    end)
end

-- Group 2+: Trial Upgrades (Grup isi 2)
local TrialStats = {"Power", "Luck", "CritChance", "CritDmg", "Coins"}
for i = 1, #TrialStats, 2 do
    local Group = FM_Add("Trial/Power Upgrade", FarmTab:Group({ Title = "Trial Upgrades " .. math.ceil(i/2) }))
    for j = i, math.min(i + 1, #TrialStats) do
        local stat = TrialStats[j]
        local toggle = Group:Toggle({
            Title = stat,
            Desc = "Waiting...",
            Default = false,
            Flag = "AutoTrial_" .. stat,
            Callback = function(val)
                if val and not IsPremium then
                    Config["AutoTrial_" .. stat] = false
                    pcall(function()
                        toggle:Unlock()
                        toggle:Set(false, false, true)
                        toggle:Lock("Premium Only")
                    end)
                    return
                end
                Config["AutoTrial_" .. stat] = val
            end
        })
        if not IsPremium then
            Config["AutoTrial_" .. stat] = false
            pcall(function()
                toggle:Set(false, false, true)
                toggle:Lock("Premium Only")
            end)
        end
        table.insert(TrialUpgradeEntries, { Name = stat, toggle = toggle })
    end
end

-- Group: Damage Upgrades (Dragonball & HxH)
local DamageGroup = FM_Add("Trial/Power Upgrade", FarmTab:Group({ Title = "Damage Upgrades" }))

DamageUpgradeDBToggle = DamageGroup:Toggle({
    Title = "Damage Upgrade DB",
    Default = false,
    Flag = "AutoDamageDB_Toggle",
    Callback = function(val)
        if val and not IsPremium then
            Config.AutoDamageDB = false
            pcall(function() DamageUpgradeDBToggle:Set(false, false, true); DamageUpgradeDBToggle:Lock("Premium Only") end)
            return
        end
        Config.AutoDamageDB = val
    end
})

DamageUpgradeHXHToggle = DamageGroup:Toggle({
    Title = "Damage Upgrade HxH",
    Default = false,
    Flag = "AutoDamageHXH_Toggle",
    Callback = function(val)
        if val and not IsPremium then
            Config.AutoDamageHXH = false
            pcall(function() DamageUpgradeHXHToggle:Set(false, false, true); DamageUpgradeHXHToggle:Lock("Premium Only") end)
            return
        end
        Config.AutoDamageHXH = val
    end
})
-- 6. Loop Update & Listener
task.spawn(function()
    -- Damage Upgrade Listeners
    LocalPlayer:GetAttributeChangedSignal("DamageUpgrade"):Connect(UpdateDamageUpgradeDBUI)
    LocalPlayer:GetAttributeChangedSignal("DamageUpgrade2"):Connect(UpdateDamageUpgradeHXHUI)
    
    -- Power Upgrade Listeners (Existing)
    LocalPlayer:GetAttributeChangedSignal("PowerUpgrade"):Connect(UpdatePowerUpgradeUI)
    LocalPlayer:GetAttributeChangedSignal("PowerUpgrade2"):Connect(UpdatePowerUpgradeHXHUI)

    while task.wait(1) do
        if not IsWindowAlive() then break end
        UpdateDamageUpgradeDBUI()
        UpdateDamageUpgradeHXHUI()
        UpdatePowerUpgradeUI()
        UpdatePowerUpgradeHXHUI()
        UpdateTrialUpgradeUI()
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
SettingsTab:Input({
    Title = "Config Name",
    Placeholder = "ANHub",
    Flag = "ConfigName_Input",
    Callback = function(txt)
        ConfigName = (txt and txt ~= "" and txt) or "ANHub"
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
-- ==========================================
-- LOGIKA SERVER BROWSER (SORTED BY ID)
-- ==========================================
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local function GetSortedServers()
    local ServerList = {}
    local PlaceId = game.PlaceId
    
    -- Mengambil data server publik (Limit 100)
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        if data and data.data then
            local rawServers = data.data
            
            -- 1. Sortir berdasarkan JobId secara Alfanumerik
            table.sort(rawServers, function(a, b)
                return a.id < b.id
            end)
            
            -- 2. Masukkan ke tabel Dropdown dengan penomoran (No. ID Server)
            local count = 0
            for _, srv in ipairs(rawServers) do
                -- if srv.id ~= game.JobId then -- Jangan masukkan server saat ini
                    count = count + 1
                    
                    -- Format Title: "1. ID: [8-digit-id] (Pemain/Max)"
                    local displayTitle = string.format("%d. ID: %s... [%d/%d]", 
                        count, 
                        srv.id:sub(1, 8), 
                        srv.playing, 
                        srv.maxPlayers
                    )
                    
                    table.insert(ServerList, {
                        Title = displayTitle,
                        Value = srv.id -- Ini JobId asli untuk teleport
                    })
                -- end
            end
        end
    end

    return ServerList
end

-- ==========================================
-- PENAMBAHAN KE UI (TAB SETTINGS)
-- ==========================================
SettingsTab:Section({ Title = "Server Browser", Icon = "server", Opened = false });

local ServerDropdown = SettingsTab:Dropdown({
    Title = "Server List",
    Desc = "Daftar server diurutkan berdasarkan JobID.",
    Values = GetSortedServers(),
    Callback = function(val)
        if val and val.Value then
            Notify("Server", "Teleporting to Server #" .. val.Title:match("^(%d+)"), "send")
            task.wait(0.5)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, val.Value, LocalPlayer)
        end
    end
})

SettingsTab:Button({
    Title = "Refresh Server List",
    Icon = "refresh-cw",
    Callback = function()
        local updatedList = GetSortedServers()
        if #updatedList > 0 then
            ServerDropdown:Refresh(updatedList)
            Notify("Success", "Daftar server diperbarui!", "check")
        else
            Notify("Error", "Gagal mengambil data server.", "x")
        end
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
        Terrain.WaterSpikeize = 0
        Terrain.WaterSpikepeed = 0
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
    Flag = "HighPerformance_toggle",
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
                v:Destroy() -- Hati-hati dengan ini, bisa menghapus part penting
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
-- [[ OPTIMIZED ENEMY DROPDOWN REFRESH ]] --
local LastIslandID = nil

task.spawn(function()
    while task.wait(1) do -- Interval 1 detik (sudah cukup ringan)
        if not Window or Window.Destroyed then break end
        
        -- Jangan refresh jika sedang di dalam Minigame/Trial
        if IsInMinigame() then continue end 

        -- MENGAMBIL LOKASI DARI OBJECT CurrentIsland (SESUAI REQUEST)
        local currentIslandObj = LocalPlayer:FindFirstChild("CurrentIsland")
        if currentIslandObj then
            local currentLoc = currentIslandObj:GetAttribute("Name")
            
            -- Jika ID Pulau berubah dan tidak kosong
            if currentLoc and currentLoc ~= "" and currentLoc ~= LastIslandID then
                LastIslandID = currentLoc
                
                -- Trigger refresh dropdown musuh berdasarkan pulau baru
                if EnemyDropdown and EnemyDropdown.Refresh then
                    -- Pastikan GetEnemiesList() mengambil data musuh yang sesuai dengan pulau saat ini
                    pcall(function()
                        EnemyDropdown:Refresh(GetEnemiesList())
                    end)
                end
            end
        end
    end
end)
-- Loop Refresh Dropdown Otomatis
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
