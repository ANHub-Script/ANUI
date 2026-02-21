if game.PlaceId ~= 95879578593446 then return end
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

local FolderPath = "ANUI/AnimeSensation"
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


local InfoPath = ReplicatedStorage.Shared.Info
local AvatarsInfo = require(InfoPath.Avatars.Avatars)
local MoneyInfo = require(InfoPath.Money.Money)
local ResourcesInfo = require(InfoPath.Resources.Resources)
local RaritiesGradients = ReplicatedStorage.UI.Gradients.Rarities -- Untuk warna rarity
local RanksInfo = require(ReplicatedStorage.Shared.Info.Rank.RanksInfo)
local NumberFormatter = require(ReplicatedStorage.Shared.Utils.NumberFormatter)
local RemoteEvents = require(ReplicatedStorage.Shared.Utils.RemoteEvents)
local RankUpRemote = RemoteEvents.RankUpEvent

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
    Title = "AN Hub - Anime Sensation",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeSensation",
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
    Profile = MakeProfile({ Title = "ANHub Script", Desc = "Anime Sensation" }),
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
        Desc = "Anime Sensation"
    }),
    SidebarProfile = false
});

-- Pembuatan Selector Kategori
FM_CategorySelector = FarmTab:Category({
    Title = "Select Category",
    Default = "Farm",
    Options = {
        {Title = "Farm", Icon = "sword"},
        {Title = "RankUp", Icon = "rbxassetid://93051230654960"},
        {Title = "Roll", Icon = "dice-5"}, -- Tambahkan ini
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

-- Helper: Modular Number Formatter
local function FormatNumber(val)
    if not val then return "0" end
    -- Memanggil fungsi asli dari module NumberFormatter game
    return NumberFormatter.FormatWithSuffix(val)
end
-- Helper: Mengubah ID menjadi Asset URL
local function GetIcon(id)
    if not id then return "rbxassetid://84366761557806" end
    local strId = tostring(id)
    if string.find(strId, "rbxassetid://") or string.find(strId, "rbxthumb://") then
        return strId
    end
    return "rbxassetid://" .. strId
end

-- [[ MODULAR DROP PARSER ]] --
local function GetDropAttributes(dropData)
    local itemKey = dropData.ItemKey
    local result = {
        Name = "Unknown",
        Image = "rbxassetid://84366761557806",
        Rarity = "Common",
        Gradient = nil
    }

    pcall(function()
        if itemKey == "Resource" then
            -- Mengikuti module_upvr.Resource
            local data = ResourcesInfo[dropData.ItemIndice]
            result.Name = data.Name
            result.Image = GetIcon(data.Image)
            result.Rarity = data.Rarity
        
        elseif itemKey == "Money" then
            -- Mengikuti module_upvr.Money
            local data = MoneyInfo[dropData.ItemIndice]
            result.Name = data.Name
            result.Image = GetIcon(data.Image)
            result.Rarity = data.Rarity

        elseif itemKey == "Avatar" then
            -- Mengikuti module_upvr.Avatar
            local data = AvatarsInfo[dropData.WorldType][dropData.World][dropData.AvatarId]
            result.Name = "Avatar " .. data.Name
            result.Image = GetIcon(data.Character) -- Avatar menggunakan model karakter
            result.Rarity = data.Rarity
        end
        
        -- Mengambil Gradient asli dari game berdasarkan Rarity
        if RaritiesGradients:FindFirstChild(result.Rarity) then
            result.Gradient = RaritiesGradients[result.Rarity].Color
        end
    end)

    return result
end

-- [[ GENERATE DROP CARDS FOR UI ]] --
local function GetEnemyDropCards(enemyInstance)
    local cards = {}
    local rawDrops = enemyInstance:GetAttribute("Drops")
    
    if rawDrops then
        local success, dropsTable = pcall(function() return HttpService:JSONDecode(rawDrops) end)
        if success and type(dropsTable) == "table" then
            for _, drop in ipairs(dropsTable) do
                -- Ambil data asli dari Info Modules game
                local info = GetDropAttributes(drop)
                
                local chanceStr = drop.Chance .. "%"
                local amountStr = (drop.Max == drop.Min) 
                    and FormatNumber(drop.Max) 
                    or (FormatNumber(drop.Min) .. "-" .. FormatNumber(drop.Max))
                
                table.insert(cards, {
                    Title = info.Name,
                    Quantity = amountStr,
                    Rate = chanceStr,
                    Image = info.Image,
                    Gradient = info.Gradient -- Warna kartu mengikuti Rarity asli game
                })
            end
        end
    end
    return cards
end
local function GetNearestEnemy(selectedNames)
    local nearest = nil
    local shortestDist = math.huge
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position

    if not myPos then return nil end

    for _, enemy in pairs(CollectionService:GetTagged("Enemy")) do
        local name = enemy:GetAttribute("Name")
        local isDead = enemy:GetAttribute("IsDead") -- Cek status mati
        local hp = enemy:GetAttribute("Health") or 0
        local root = enemy:FindFirstChild("HumanoidRootPart")

        if table.find(selectedNames, name) and not isDead and hp > 0 and root then
            local dist = (myPos - root.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                nearest = enemy
            end
        end
    end
    return nearest
end
-- Fungsi Sinkronisasi & Sorting Musuh
local function RefreshEnemyData()
    local enemyList = {}
    local seen = {}
    
    -- Mengambil musuh ber-tag "Enemy"
    for _, enemy in pairs(CollectionService:GetTagged("Enemy")) do
        local name = enemy:GetAttribute("Name")
        if name and not seen[name] then
            seen[name] = true
            local maxHp = enemy:GetAttribute("MaxHealth") or 0
            local variant = enemy:GetAttribute("VariantName") or "Normal"
            local dropCards = GetEnemyDropCards(enemy)
            
            table.insert(enemyList, {
                Title = string.format("%s [%s]", name, variant),
                Value = name,
                -- Menampilkan HP dengan suffix (K, M, B) sesuai module game
                Desc = "HP: " .. FormatNumber(maxHp), 
                HPValue = maxHp,
                Images = dropCards
            })
        end
    end
    
    -- Sort berdasarkan MaxHealth dari yang terkecil
    table.sort(enemyList, function(a, b) return a.HPValue < b.HPValue end)
    
    CurrentMapEnemiesCache = enemyList
    return enemyList
end

-- [[ LOGIKA AUTO FARM ]] --
local function LogicAutoFarm()
    while Config.AutoFarm and IsWindowAlive() do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hrp and char.Humanoid.Health > 0 then
            local selected = Config.SelectedEnemy or {}
            if #selected > 0 then
                -- Logika pencarian musuh terdekat tetap sama
                local target = GetNearestEnemy(selected)
                
                if target and target:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = target.HumanoidRootPart
                    local distance = (hrp.Position - targetRoot.Position).Magnitude

                    -- Jarak > 10 studs: Teleport ke jarak 3 studs
                    if distance > 10 then
                        local direction = (hrp.Position - targetRoot.Position).Unit
                        hrp.CFrame = CFrame.lookAt(targetRoot.Position + (direction * 3), targetRoot.Position)
                    end
                    
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    -- Trigger serangan menggunakan ID musuh
                    if AttackRemote then
                        AttackRemote:FireServer(target:GetAttribute("Id"))
                    end
                end
            end
        end
        task.wait() 
    end
end

-- [[ PATH UI UNTUK RANK UP ]] --
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RankUpUI = PlayerGui:WaitForChild("Screens"):WaitForChild("RankUp"):WaitForChild("Container"):WaitForChild("Background")
local RankUpTextAmount = RankUpUI:WaitForChild("Bottom"):WaitForChild("AmountBar"):WaitForChild("TextAmount")
local RankNameLabel = RankUpUI:WaitForChild("Current"):WaitForChild("RankName")
-- Tambahkan ini di bagian atas script
local SuffixInfo = require(game:GetService("ReplicatedStorage").Shared.Utils.NumberFormatter.Suffix)
-- [[ HELPERS ]] --
local function FormatNumber(val)
    if not val then return "0" end
    return NumberFormatter.FormatWithSuffix(val)
end

-- [[ MODULAR PARSER - NO HARDCODE ]] --
local function ParseRankUpPower(text)
    if not text or text == "" then return 0 end
    
    -- 1. Ambil bagian kiri sebelum tanda "/" (misal: "1.0Qd/6Qd" -> "1.0Qd")
    local currentPart = string.split(text, "/")[1] or text
    
    -- 2. Pisahkan angka dan suffix (misal: "1.0" dan "Qd")
    local numberPart, suffixPart = currentPart:match("([%d%.]+)(%a*)")
    local number = tonumber(numberPart) or 0
    
    if not suffixPart or suffixPart == "" then 
        return number 
    end

    -- 3. Cari multiplier secara dinamis dari module Suffix game
    for _, data in ipairs(SuffixInfo) do
        local multiplier = data[1]
        local suffixStr = data[2]
        
        -- Bandingkan suffix dari UI dengan suffix dari module (Case-Insensitive)
        if suffixPart:lower() == suffixStr:lower() then
            return number * multiplier
        end
    end
    
    return number
end

-- [[ UI STATE MANAGER ]] --
local _UIStateByObject = setmetatable({}, { __mode = "k" })
local function _GetUIState(ui)
    if not ui then return nil end
    local state = _UIStateByObject[ui]
    if not state then
        state = {}
        _UIStateByObject[ui] = state
    end
    return state
end

local function _ApplyUIState(ui)
    if not ui or not Window or Window.Destroyed then return end
    local state = _UIStateByObject[ui]
    if not state then return end
    if state.desiredTitle and ui.SetTitle then ui:SetTitle(state.desiredTitle) end
    if state.desiredDesc and ui.SetDesc then ui:SetDesc(state.desiredDesc) end
end
-- [[ UI ELEMENTS FOR FARM ]] --

-- Dropdown Enemy
EnemyDropdown = FarmTab:Dropdown({
    Title = "Select Enemy",
    Multi = true,
    Values = RefreshEnemyData(),
    AllowNone = true,
    Flag = "SelectedEnemy_Cfg",
    Callback = function(selected)
        local names = {}
        for _, item in pairs(selected) do
            table.insert(names, type(item) == "table" and item.Value or item)
        end
        Config.SelectedEnemy = names
    end
})
FM_Add("Farm", EnemyDropdown)

-- Refresh Button
RefreshBtn = FarmTab:Button({
    Title = "Refresh Enemy List",
    Icon = "refresh-cw",
    Callback = function()
        EnemyDropdown:Refresh(RefreshEnemyData())
        Notify("Refreshed", "Enemy list updated and sorted by HP.", "check")
    end
})
FM_Add("Farm", RefreshBtn)

-- Toggle Farm
FarmToggle = FarmTab:Toggle({
    Title = "Auto Farm Enemies",
    Desc = "Teleport (3 studs) & serang musuh. Cek jangkauan 10 studs.",
    Flag = "AutoFarm_Cfg",
    Callback = function(val)
        Config.AutoFarm = val
        if val then
            task.spawn(LogicAutoFarm)
        end
    end
})
FM_Add("Farm", FarmToggle)

-- [[ CATEGORY: RANK UP (UI PATH METHOD) ]] --
local StatsScrollingFrame = LocalPlayer.PlayerGui.Screens.Stats.Container.Background.Main.ScrollingFrame

-- [[ CATEGORY: RANK UP (METODE UI PATH FIX) ]] --
local RankUpToggle = FM_Add("RankUp", FarmTab:Toggle({
    Title = "Auto Rank Up",
    Desc = "Sinkronisasi data RankUp UI...",
    Default = false,
    Flag = "AutoRankUp_Toggle",
    Callback = function(val)
        Config.AutoRankUp = val
    end
}))

local _RankUpUIState = _GetUIState(RankUpToggle)

local function UpdateRankUpLogic()
    if not Window or Window.Destroyed or not RankUpToggle then return end

    -- 1. Ambil data langsung dari path RankUp UI sesuai permintaan
    local powerRawText = RankUpTextAmount.Text -- "8.7T/40T"
    local rankRawText = RankNameLabel.Text     -- "Rank 5" atau "5"

    -- 2. Konversi ke angka murni
    local currentPower = ParseRankUpPower(powerRawText)
    local currentRankIndex = tonumber(rankRawText:match("%d+")) or 1
    
    local currentData = RanksInfo[currentRankIndex]
    local nextRankData = RanksInfo[currentRankIndex + 1]

    if currentData then
        local titleTxt, descTxt = "", ""

        if nextRankData then
            local targetAmount = nextRankData.Amount or 0
            local progress = math.clamp(currentPower / targetAmount, 0, 1)
            local bar = "[" .. string.rep("█", math.floor(progress * 15)) .. string.rep("░", 15 - math.floor(progress * 15)) .. "]"
            
            titleTxt = string.format("Rank %d ➜ %d (+%sx)", currentRankIndex, currentRankIndex + 1, FormatNumber(nextRankData.BoostAmount))
            descTxt = string.format("%s %d%%\nPower: %s", bar, math.floor(progress * 100), powerRawText)

            -- 3. AUTO RANK UP: Jika Power cukup, tembak remote
            if Config.AutoRankUp and currentPower >= targetAmount then
                RankUpRemote:FireServer()
                task.wait(1) -- Delay agar tidak spam
            end
        else
            titleTxt = "Rank: " .. currentRankIndex .. " [MAX]"
            descTxt = "Boost: " .. FormatNumber(currentData.BoostAmount) .. "x\nRank tertinggi tercapai!"
        end

        if _RankUpUIState then
            _RankUpUIState.desiredTitle = titleTxt
            _RankUpUIState.desiredDesc = descTxt
            _ApplyUIState(RankUpToggle)
        end
    end
end
-- [[ LOOP SINKRONISASI ]] --
task.spawn(function()
    while task.wait(0.1) do
        if not Window or Window.Destroyed then break end
        UpdateRankUpLogic()
    end
end)
-- [[ CATEGORY: ROLL (Individual Toggles - UI Icon Path) ]] --
local RollTokenInfo = require(ReplicatedStorage.Shared.Info.RollToken)
local RollTokenRemote = RemoteEvents.RollTokenEvent

-- Header Section
FM_Add("Roll", FarmTab:Section({ 
    Title = "Auto Roll Tokens", 
    Icon = "dice-5", 
    Opened = true 
}))

local RollToggleElements = {}

-- Loop untuk membuat Toggle buat setiap Token
for id, data in ipairs(RollTokenInfo) do
    local resourceId = data.Price.Resource
    local possibilities = {}
    
    for _, pos in ipairs(data.Possibilities) do
        local rarityColor = RaritiesGradients:FindFirstChild(pos.Rarity) and RaritiesGradients[pos.Rarity].Color or nil
        table.insert(possibilities, {
            Title = pos.Name,
            Quantity = "Boost: " .. pos.BoostAmount,
            Rate = pos.Rarity,
            Image = "rbxassetid://84366761557806", 
            Gradient = rarityColor
        })
    end

    local NewToggle = FarmTab:Toggle({
        Title = "Auto " .. data.Name,
        Desc = "Menunggu data...",
        Default = false,
        Flag = "AutoRoll_ID_" .. id,
        Callback = function(val)
            Config["AutoRoll_" .. id] = val
        end
    })

    -- [[ AMBIL ICON LANGSUNG DARI UI INVENTORY ]] --
    local InventoryScrolling = LocalPlayer.PlayerGui.Screens.Inventory.Container.Background.Frames.Resources.DropsContainer.ScrollingFrame
    local resourceFrame = InventoryScrolling:FindFirstChild("Resource" .. resourceId)
    local finalIcon = "rbxassetid://84366761557806" -- Default jika tidak ditemukan

    if resourceFrame and resourceFrame:FindFirstChild("Icon") then
        finalIcon = resourceFrame.Icon.Image -- Mengambil langsung property .Image dari UI
    end

    -- Gunakan tabel ganda {{}} agar terbaca oleh SetMainImage ANHub
    NewToggle:SetMainImage({
        {
            Image = finalIcon,
            Title = ResourcesInfo[resourceId] and ResourcesInfo[resourceId].Name or "Material"
        }
    }, 50)

    FM_Add("Roll", NewToggle)
    
    table.insert(RollToggleElements, {
        Instance = NewToggle,
        Data = data,
        ID = id,
        ResourcePath = "Resource" .. resourceId
    })
end

-- [[ LOOP SINKRONISASI MATERIAL & AUTO ROLL ]] --
task.spawn(function()
    local InventoryPath = LocalPlayer.PlayerGui.Screens.Inventory.Container.Background.Frames.Resources.DropsContainer.ScrollingFrame

    while task.wait(0.5) do
        if not Window or Window.Destroyed then break end

        for _, item in ipairs(RollToggleElements) do
            local toggle = item.Instance
            local data = item.Data
            local id = item.ID
            local resourceObjName = item.ResourcePath
            
            local currentAmount = 0
            local rawText = "0"
            local resourceUI = InventoryPath:FindFirstChild(resourceObjName)
            
            if resourceUI and resourceUI:FindFirstChild("TextAmount") then
                rawText = resourceUI.TextAmount.Text
                currentAmount = ParseRankUpPower(rawText)
            end

            local price = data.Price.Amount
            local hasEnough = currentAmount >= price
            
            local colorTag = hasEnough and "#00FF00" or "#FF0000"
            if toggle.SetDesc then
                toggle:SetDesc(string.format(
                    "Material: <font color='%s'>%s/%s</font>",
                    colorTag,
                    rawText,
                    NumberFormatter.FormatWithSuffix(price)
                ))
            end

            if Config["AutoRoll_" .. id] and hasEnough then
                if RollTokenRemote then
                    RollTokenRemote:FireServer(id)
                end
                task.wait(0.1)
            end
        end
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
