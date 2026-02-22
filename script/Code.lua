if game.PlaceId ~= 79189799490564 then
    return
end

repeat
    task.wait()
until game:IsLoaded()
-- [[ 1. INITIALIZATION & SERVICE SYNC ]] --
local game_G = getrenv()._G
local shared = getrenv().shared

-- Mengambil service langsung dari memori game agar performa maksimal
local RF = game_G.RF or game:GetService("ReplicatedFirst")
local RS = game_G.RS or game:GetService("ReplicatedStorage")
ReplicatedFirst = RF
local RC = game_G.RC or game:GetService("RunService")

-- Pastikan game sudah selesai loading modul penting
repeat task.wait() until shared.Essential and shared.Reply
-- [[ ANIME WEAPON SIMULATOR - GIFT CODE CLAIMER ]] --

-- 1. DATA KODE (DARI INPUT KAMU)
local CodeDatabase = {
    ["35KLIKES"] = true, ["GAMEMODESLAGCORRECTION"] = true, ["15KLIKES"] = true,
    ["DEFENSEPATCHSORRY2"] = true, ["UPDATE12PT2"] = true, ["225KFAVS"] = true,
    ["FEATSREWARDFIX"] = true, ["UPDATE14"] = true, ["148KLIKES"] = true,
    ["UPDATE3"] = true, ["UPDATE13PT3"] = true, ["CHRISTMAS"] = true,
    ["230KFAVS"] = true, ["SORRY4SOMEDELAY"] = true, ["58MVISITS"] = true,
    ["UPDATE2"] = true, ["54MVISITS"] = true, ["PETS"] = true,
    ["136KLIKES"] = true, ["RELEASEPT2"] = true, ["130KLIKES"] = true,
    ["38MVISITS"] = true, ["139KLIKES"] = true, ["UPDATE7"] = true,
    ["UPDATE9PT3"] = true, ["50MVISITS"] = true, ["40MVISITS"] = true,
    ["30MVISITS"] = true, ["20MVISITS"] = true, ["S0RRYF0RD3L4Y"] = true,
    ["SORRYPITY"] = true, ["10KLIKES"] = true, ["SORRY4BUGS"] = true,
    ["200KFAVS"] = true, ["40KLIKES"] = true, ["50KLIKES"] = true,
    ["20KLIKES"] = true, ["210KFAVS"] = true, ["D7BUGCOMPENSATION"] = true,
    ["215KFAVS"] = true, ["DEFENSESORRY1"] = true, ["15KCCU"] = true,
    ["UPDATE12"] = true, ["17KCCU"] = true, ["SHIROBESTDEV"] = true,
    ["UPDATE3PT2"] = true, ["XOUBESTYT"] = true, ["UPDATE11PT2"] = true,
    ["45MVISITS"] = true, ["55MVISITS"] = true, ["PATCHUPDT1"] = true,
    ["DEFENSESORRY2"] = true, ["SORRYSHUTDOWN2"] = true, ["UPDATE10PT2"] = true,
    ["CRYOBESTDEV"] = true, ["90KLIKES"] = true, ["60KLIKES"] = true,
    ["70KLIKES"] = true, ["125KLIKES"] = true, ["UPDATE9"] = true,
    ["25KCCU"] = true, ["UPDATE8"] = true, ["BUGSFIXED"] = true,
    ["UPDATE9PT2"] = true, ["SORRYSHUTDOWN"] = true, ["RLBESTDEV"] = true,
    ["UPDATE10PT3"] = true, ["UPDATE10"] = true, ["UPDATE4PT2"] = true,
    ["DEFENSESORRY3"] = true, ["LENIBESTDEV"] = true, ["UPDATE7PT2"] = true,
    ["SORRY4SHUTDOWN"] = true, ["120KLIKES"] = true, ["51MVISITS"] = true,
    ["GACHAROLLFIX"] = true, ["BELABESTDEV"] = true, ["15MVISITS"] = true,
    ["1KCCU"] = true, ["RAIDFIXED"] = true, ["3KCCU"] = true,
    ["UPDATE6"] = true, ["5KCCU"] = true, ["UPDATE11PT3"] = true,
    ["80KLIKES"] = true, ["UPDATE8PT2"] = true, ["UPDATE11"] = true,
    ["135KLIKES"] = true, ["220KFAVS"] = true, ["190KFAVS"] = true,
    ["UPDATE4PT3"] = true, ["RELEASE"] = true, ["RANKUP"] = true,
    ["INSANEDUNGEONFIX"] = true, ["SORRYFORDELAY"] = true, ["UPDATE13"] = true,
    ["5MVISITS"] = true, ["160KFAVS"] = true, ["KHAEZARBESTDEV"] = true,
    ["SIXBESTDEV"] = true, ["BEPPBESTDEV"] = true, ["UPDATE6PT2"] = true,
    ["110KLIKES"] = true, ["SORRY45HUTD0WNS"] = true, ["29MVISITS"] = true,
    ["52MVISITS"] = true, ["DEFENSEPATCHSORRY1"] = true, ["MAGICRAID"] = true,
    ["UPDATE5PT2"] = true, ["S0RRY4DEL4Y"] = true, ["23KCCU"] = true,
    ["53MVISITS"] = true, ["ALOTOFBUGSSORRYYOUALL"] = true, ["SORRYSHUTDOWN3"] = true,
    ["145KLIKES"] = true, ["180KFAVS"] = true, ["57MVISITS"] = true,
    ["SHADOWPORTALFIXED"] = true, ["SORRY4PITYBUG"] = true, ["UPDATE8PT3"] = true,
    ["24KCCU"] = true, ["PATCHUPDT"] = true, ["30KCCU"] = true,
    ["UPDATE5"] = true, ["10KCCU"] = true, ["UPDATE12PT3"] = true, ["UPDATE13PT2"] = true, ["HIDDENQUESTSFIXED"] = true
}

-- 2. MEMBUAT GUI (Separate UI)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")
local ClaimButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

-- Setup Properties GUI
ScreenGui.Name = "GiftCodeClaimer"
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = MainFrame

TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1.000
TitleLabel.Position = UDim2.new(0, 0, 0, 10)
TitleLabel.Size = UDim2.new(1, 0, 0, 20)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "AUTO CODES"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16.000

StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1.000
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Ready to claim..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12.000
StatusLabel.TextWrapped = true

ClaimButton.Parent = MainFrame
ClaimButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ClaimButton.Position = UDim2.new(0, 25, 0, 80)
ClaimButton.Size = UDim2.new(0, 150, 0, 35)
ClaimButton.Font = Enum.Font.GothamBold
ClaimButton.Text = "CLAIM ALL"
ClaimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClaimButton.TextSize = 14.000

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = ClaimButton

CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12.000

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = CloseButton

-- 3. LOGIKA CLAIMING
local isRunning = false

CloseButton.MouseButton1Click:Connect(function()
    isRunning = false
    ScreenGui:Destroy()
end)

ClaimButton.MouseButton1Click:Connect(function()
    if isRunning then return end
    isRunning = true
    
    local totalCodes = 0
    for _ in pairs(CodeDatabase) do totalCodes = totalCodes + 1 end
    
    local processed = 0
    
    for code, _ in pairs(CodeDatabase) do
        if not isRunning then break end
        
        -- Sanitasi kode (Upper case & No space)
        local cleanCode = code:gsub(" ", ""):upper()
        
        -- Update Status UI
        StatusLabel.Text = "Redeeming: " .. cleanCode
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        
        -- Kirim Remote Event
        if shared.Reply and shared.Reply.To then
            shared.Reply.To("Code", cleanCode)
        else
            StatusLabel.Text = "Error: shared.Reply not found!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            break
        end
        
        processed = processed + 1
        ClaimButton.Text = math.floor((processed/totalCodes)*100) .. "%"
        
        -- Delay agar aman dari kick/ratelimit
        task.wait(0.3) 
    end
    
    isRunning = false
    StatusLabel.Text = "Done! Check console/inventory."
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    ClaimButton.Text = "CLAIM ALL"
end)

print("Gift Code UI Loaded!")
-- EntxN2D6j8