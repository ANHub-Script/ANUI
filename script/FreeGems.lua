--[[
    SERVER BROWSER GUI - SORT BY ID WITH INDEX
    Dibuat untuk: Delta Executor
    Fungsi: Menampilkan daftar server yang diurutkan berdasarkan ID dengan nomor urutan.
]]

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

-- Hapus GUI lama jika ada agar tidak menumpuk
if CoreGui:FindFirstChild("ServerBrowserDeltaNumbered") then
    CoreGui.ServerBrowserDeltaNumbered:Destroy()
end

-- Configuration
local PlaceId = game.PlaceId
local ApiUrl = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerBrowserDeltaNumbered"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "  Server Browser (Numbered & Sorted ID)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Title
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -100)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local RefreshButton = Instance.new("TextButton")
RefreshButton.Parent = MainFrame
RefreshButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
RefreshButton.Position = UDim2.new(0, 10, 1, -40)
RefreshButton.Size = UDim2.new(1, -20, 0, 30)
RefreshButton.Font = Enum.Font.Gotham
RefreshButton.Text = "Refresh List"
RefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.Padding = UDim.new(0, 5)

-- Fungsi untuk membuat baris server
local function CreateServerEntry(index, serverData)
    local EntryFrame = Instance.new("Frame")
    EntryFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    EntryFrame.Size = UDim2.new(1, -10, 0, 60)
    EntryFrame.Parent = ScrollingFrame

    -- Nomor Urutan
    local NumberLabel = Instance.new("TextLabel")
    NumberLabel.Parent = EntryFrame
    NumberLabel.Size = UDim2.new(0, 30, 1, 0)
    NumberLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    NumberLabel.BorderSizePixel = 0
    NumberLabel.Font = Enum.Font.GothamBold
    NumberLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NumberLabel.TextSize = 14
    NumberLabel.Text = tostring(index)

    -- Info ID Server
    local IdLabel = Instance.new("TextLabel")
    IdLabel.Parent = EntryFrame
    IdLabel.BackgroundTransparency = 1
    IdLabel.Position = UDim2.new(0, 40, 0, 5)
    IdLabel.Size = UDim2.new(0.6, 0, 0, 20)
    IdLabel.Font = Enum.Font.Code
    IdLabel.TextXAlignment = Enum.TextXAlignment.Left
    IdLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    IdLabel.TextSize = 11
    IdLabel.Text = "ID: " .. serverData.id

    -- Info Pemain
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Parent = EntryFrame
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Position = UDim2.new(0, 40, 0, 25)
    InfoLabel.Size = UDim2.new(0.6, 0, 0, 25)
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    InfoLabel.TextSize = 12
    InfoLabel.Text = "Pemain: " .. serverData.playing .. " / " .. serverData.maxPlayers .. " | Ping: " .. (serverData.ping or "N/A")

    -- Tombol Join
    local JoinButton = Instance.new("TextButton")
    JoinButton.Parent = EntryFrame
    JoinButton.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
    JoinButton.Position = UDim2.new(1, -75, 0, 15)
    JoinButton.Size = UDim2.new(0, 65, 0, 30)
    JoinButton.Font = Enum.Font.GothamBold
    JoinButton.Text = "JOIN"
    JoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    JoinButton.TextSize = 11
    
    JoinButton.MouseButton1Click:Connect(function()
        TeleportService:TeleportToPlaceInstance(PlaceId, serverData.id, Players.LocalPlayer)
    end)
end

local function FetchServers()
    -- Clear List
    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    RefreshButton.Text = "Memuat Server..."
    
    local success, result = pcall(function()
        return game:HttpGet(ApiUrl)
    end)
    
    if success then
        local json = HttpService:JSONDecode(result)
        if json and json.data then
            local serverList = json.data
            
            -- Sort by ID
            table.sort(serverList, function(a, b)
                return a.id < b.id
            end)
            
            -- Tampilkan dengan Nomor Urut
            for i, server in pairs(serverList) do
                CreateServerEntry(i, server)
            end
            
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
            RefreshButton.Text = "Refresh List ("..#serverList.." Server)"
        end
    else
        RefreshButton.Text = "Error! Coba Lagi"
    end
end

RefreshButton.MouseButton1Click:Connect(FetchServers)
FetchServers()