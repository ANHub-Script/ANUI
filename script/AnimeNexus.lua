-- if game.PlaceId ~= 81897457567012 then return end
repeat task.wait() until game:IsLoaded()

getgenv().SLoading = getgenv().SLoading or {}
getgenv().SLoading.SubTitle = "Anime Sensation"
loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/loading.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local FolderPath = "ANUI/AnimeLestial"
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
    Title = "AN Hub - Anime Lestial",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeLestial",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Lestial" }),
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
-- [[ RE-INITIALIZE CORE SERVICES (BYPASSING GETDATA ERROR) ]] --
local Library = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
local Remote = Library.Remote -- NetworkService

-- Bypass GetData Error dengan require langsung ke folder Data
local DataFolder = ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data")
local EnemyData = require(DataFolder:WaitForChild("EnemyData"))
local CurrencyData = require(DataFolder:WaitForChild("CurrencyData"))
local ItemData = require(DataFolder:WaitForChild("ItemData"))

-- Fungsi Pembantu untuk UI (Disesuaikan dengan logika v_u_38 di EnemyController)
local function GetEnemyDropCards(enemyInstance)
    local dropCards = {}
    local id = enemyInstance:GetAttribute("Id")
    local data = EnemyData[id]
    
    if data and data.Drops then
        for _, drop in pairs(data.Drops) do
            -- Menampilkan icon mata uang atau item di dropdown UI
            local dropId = drop.Id
            if CurrencyData[dropId] then
                table.insert(dropCards, CurrencyData[dropId].Icon or "")
            elseif ItemData[dropId] then
                table.insert(dropCards, ItemData[dropId].Icon or "")
            end
        end
    end
    return dropCards
end

-- [[ MODIFIED ENEMY DATA REFRESH ]] --
local function RefreshEnemyData()
    local enemyList = {}
    local seen = {}
    
    -- Menggunakan tag "EnemyServer" sesuai logika EnemyService
    for _, enemy in pairs(CollectionService:GetTagged("EnemyServer")) do
        local name = enemy:GetAttribute("Name")
        local id = enemy:GetAttribute("Id")
        
        if name and not seen[name] then
            seen[name] = true
            local maxHp = enemy:GetAttribute("MaxHealth") or 0
            -- Cek apakah musuh Secret (Order 6) berdasarkan EnemyController v_u_120
            local isSecret = enemy:GetAttribute("Secret") or (enemy:GetAttribute("Order") == 6)
            
            table.insert(enemyList, {
                Title = isSecret and "⭐ " .. name or name,
                Value = name,
                Desc = "HP: " .. (maxHp > 0 and math.floor(maxHp) or "???"),
                HPValue = maxHp,
                Images = GetEnemyDropCards(enemy)
            })
        end
    end
    
    table.sort(enemyList, function(a, b) return a.HPValue < b.HPValue end)
    CurrentMapEnemiesCache = enemyList
    return enemyList
end

-- [[ MODIFIED AUTO FARM LOGIC (Sesuai v_u_163 & EnemyService) ]] --
local function GetTargetFromService(selectedNames)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearest = nil
    local lastDist = math.huge
    
    -- Konstanta Jarak dari EnemyService v_u_18
    local RANGE_BASE = 500
    local SECRET_RANGE = 75

    for _, enemy in pairs(CollectionService:GetTagged("EnemyServer")) do
        local name = enemy:GetAttribute("Name")
        local isDead = enemy:GetAttribute("Dead")
        local hasShield = enemy:GetAttribute("Shield")
        
        if table.find(selectedNames, name) and not isDead and not hasShield then
            local dist = (hrp.Position - enemy.Position).Magnitude
            -- Logika jarak khusus musuh rahasia dari decompile
            local maxRange = (enemy:GetAttribute("Secret") or enemy:GetAttribute("Order") == 6) and SECRET_RANGE or RANGE_BASE

            if dist < maxRange and dist < lastDist then
                nearest = enemy
                lastDist = dist
            end
        end
    end
    return nearest
end

local function LogicAutoFarm()
    while Config.AutoFarm and IsWindowAlive() do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hrp and char.Humanoid.Health > 0 then
            local selected = Config.SelectedEnemy or {}
            if #selected > 0 then
                local target = GetTargetFromService(selected)
                
                if target then
                    local targetPos = target.Position
                    local distance = (hrp.Position - targetPos).Magnitude

                    -- Mengikuti target (Logika v_u_110: Sinkronisasi posisi)
                    if distance > 7 then
                        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0), targetPos)
                    end
                    
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    -- Serang via NetworkService (Remote)
                    if Remote then
                        Remote:FireServer("Attack", {
                            ["Target"] = target,
                            ["Id"] = target.Name -- Menggunakan UID dari Name instance
                        })
                    end
                end
            end
        end
        -- Interval 0.1s sesuai Heartbeat EnemyController v_u_164
        task.wait(0.1) 
    end
end

-- [[ UI REBUILD ]] --
EnemyDropdown = FarmTab:Dropdown({
    Title = "Target Selection",
    Multi = true,
    Values = RefreshEnemyData(),
    AllowNone = true,
    Callback = function(selected)
        local names = {}
        for _, item in pairs(selected) do
            table.insert(names, type(item) == "table" and item.Value or item)
        end
        Config.SelectedEnemy = names
    end
})
FM_Add("Farm", EnemyDropdown)

FarmToggle = FarmTab:Toggle({
    Title = "Start Auto Farm",
    Desc = "Bypass Shield & Dead Checks. Sync with EnemyServer.",
    Callback = function(val)
        Config.AutoFarm = val
        if val then task.spawn(LogicAutoFarm) end
    end
})
FM_Add("Farm", FarmToggle)

FM_Add("Farm", FarmTab:Button({
    Title = "Force Refresh (EnemyServer)",
    Icon = "refresh-cw",
    Callback = function()
        EnemyDropdown:Refresh(RefreshEnemyData())
        Notify("Updated", "Synced with game data folders.", "check")
    end
}))
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
