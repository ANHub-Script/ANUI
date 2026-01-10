local function PlayFixedPremiumLoading()
    -- SERVICES
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    -- CONFIGURATION (Warna Tema Dark Premium)
    local DarkBG = Color3.fromRGB(25, 25, 30) -- Background Hitam Abu Premium
    local AccentColor1 = Color3.fromRGB(0, 255, 200) -- Cyan Cerah
    local AccentColor2 = Color3.fromRGB(0, 120, 255) -- Biru Elektrik
    local TextWhite = Color3.fromRGB(255, 255, 255)
    local TextGray = Color3.fromRGB(180, 180, 180) 

    local Duration = 6 -- Durasi loading (detik)

    -- PARENTING CHECK
    local TargetParent = pcall(function() return CoreGui.Name end) and CoreGui or PlayerGui

    -- CLEANUP OLD GUI
    for _, v in pairs(TargetParent:GetChildren()) do
        if v.Name == "ANHub_PremiumLoad" then v:Destroy() end
    end
    for _, v in pairs(Lighting:GetChildren()) do
        if v.Name == "ANHub_Blur" then v:Destroy() end
    end

    -- 1. SETUP BLUR & SCREEN GUI
    local Blur = Instance.new("BlurEffect")
    Blur.Name = "ANHub_Blur"
    Blur.Size = 0
    Blur.Parent = Lighting

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ANHub_PremiumLoad"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 10000
    ScreenGui.Parent = TargetParent

    -- Overlay Gelap
    local Overlay = Instance.new("Frame")
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.Size = UDim2.fromScale(1, 1)
    Overlay.Parent = ScreenGui

    -- 2. KARTU UTAMA
    local Card = Instance.new("Frame")
    Card.Name = "MainCard"
    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.Position = UDim2.fromScale(0.5, 0.5)
    Card.Size = UDim2.fromOffset(0, 0) 
    Card.BackgroundColor3 = DarkBG
    Card.BorderSizePixel = 0
    Card.Parent = ScreenGui

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 20)
    CardCorner.Parent = Card

    -- Garis Tepi (Stroke) dengan Gradasi
    local CardStroke = Instance.new("UIStroke")
    CardStroke.Thickness = 1.5
    CardStroke.Transparency = 1
    CardStroke.Parent = Card
    
    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, AccentColor1),
        ColorSequenceKeypoint.new(1, AccentColor2)
    }
    StrokeGradient.Rotation = 45
    StrokeGradient.Parent = CardStroke

    -- Container Isi
    local Content = Instance.new("CanvasGroup")
    Content.Parent = Card
    Content.Size = UDim2.fromScale(1, 1)
    Content.BackgroundTransparency = 1
    Content.GroupTransparency = 1
    
    -- Judul Utama
    local Title = Instance.new("TextLabel")
    Title.Parent = Content
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 30, 0, 30)
    Title.Size = UDim2.new(1, -60, 0, 40)
    Title.Font = Enum.Font.GothamBlack
    Title.Text = "AN HUB"
    Title.TextColor3 = TextWhite
    Title.TextSize = 38
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Sub-Judul
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Parent = Content
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, 30, 0, 70)
    SubTitle.Size = UDim2.new(1, -60, 0, 20)
    SubTitle.Font = Enum.Font.GothamMedium
    SubTitle.Text = "Anime Waves"
    SubTitle.TextColor3 = AccentColor1
    SubTitle.TextSize = 14
    SubTitle.TextTransparency = 0.2
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Status Text
    local StatusText = Instance.new("TextLabel")
    StatusText.Parent = Content
    StatusText.BackgroundTransparency = 1
    StatusText.Position = UDim2.new(0, 30, 1, -70)
    StatusText.Size = UDim2.new(1, -120, 0, 20)
    StatusText.Font = Enum.Font.GothamMedium
    StatusText.Text = "Initializing..."
    StatusText.TextColor3 = TextGray
    StatusText.TextSize = 14
    StatusText.TextXAlignment = Enum.TextXAlignment.Left

    -- Persentase Text
    local PercentText = Instance.new("TextLabel")
    PercentText.Parent = Content
    PercentText.BackgroundTransparency = 1
    PercentText.Position = UDim2.new(1, -90, 1, -70)
    PercentText.Size = UDim2.new(0, 60, 0, 20)
    PercentText.Font = Enum.Font.GothamBold
    PercentText.Text = "0%"
    PercentText.TextColor3 = AccentColor1
    PercentText.TextSize = 16
    PercentText.TextXAlignment = Enum.TextXAlignment.Right

    -- BAR BACKGROUND
    local BarBG = Instance.new("Frame")
    BarBG.Parent = Content
    BarBG.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    BarBG.Position = UDim2.new(0, 30, 1, -40)
    BarBG.Size = UDim2.new(1, -60, 0, 8)
    BarBG.BorderSizePixel = 0

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = BarBG

    -- BAR FILL
    local BarFill = Instance.new("Frame")
    BarFill.Parent = BarBG
    BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BarFill.Size = UDim2.fromScale(0, 1)
    BarFill.BorderSizePixel = 0

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = BarFill

    local BarGradient = Instance.new("UIGradient")
    BarGradient.Color = ColorSequence.new(AccentColor1, AccentColor2)
    BarGradient.Parent = BarFill

    -- 3. ANIMASI MASUK
    TweenService:Create(Blur, TweenInfo.new(0.8), {Size = 25}):Play()
    TweenService:Create(Overlay, TweenInfo.new(0.8), {BackgroundTransparency = 0.3}):Play()
    
    local TargetSize = UDim2.fromOffset(500, 250)
    
    TweenService:Create(Card, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
    TweenService:Create(CardStroke, TweenInfo.new(0.7), {Transparency = 0.5}):Play()
    
    task.wait(0.3)
    TweenService:Create(Content, TweenInfo.new(0.5), {GroupTransparency = 0}):Play()

    -- 4. LOGIKA LOADING (FIXED HERE)
    local StartTime = os.clock()
    local ProgressValue = Instance.new("NumberValue")
    ProgressValue.Value = 0

    ProgressValue:GetPropertyChangedSignal("Value"):Connect(function()
        local val = ProgressValue.Value
        PercentText.Text = math.floor(val) .. "%"
        TweenService:Create(BarFill, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {Size = UDim2.fromScale(val/100, 1)}):Play()
    end)

    -- *** BAGIAN YANG DIPERBAIKI (Ganti InOut jadi Quad) ***
    local AnimTween = TweenService:Create(
        ProgressValue, 
        TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 
        {Value = 100}
    )
    AnimTween:Play()

    local steps = {
        {Time = 0.5, Text = "Verifying Assets..."},
        {Time = 2.0, Text = "Downloading Scripts..."},
        {Time = 3.5, Text = "Executing Core..."},
        {Time = 5.0, Text = "Finalizing..."}
    }

    task.spawn(function()
        for i, step in ipairs(steps) do
            local elapsedTime = os.clock() - StartTime
            local waitTime = step.Time - elapsedTime
            if waitTime > 0 then task.wait(waitTime) end
            
            TweenService:Create(StatusText, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
            task.wait(0.2)
            StatusText.Text = step.Text
            TweenService:Create(StatusText, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        end
    end)

    AnimTween.Completed:Wait()
    
    -- Done
    StatusText.Text = "Ready!"
    PercentText.Text = "100%"
    TweenService:Create(BarFill, TweenInfo.new(0.3), {BackgroundColor3 = AccentColor1}):Play()
    task.wait(0.8)

    -- 5. ANIMASI KELUAR
    TweenService:Create(Content, TweenInfo.new(0.3), {GroupTransparency = 1}):Play()
    TweenService:Create(CardStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    
    local PopOut = TweenService:Create(Card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0)})
    PopOut:Play()

    TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
    TweenService:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()

    PopOut.Completed:Wait()
    ScreenGui:Destroy()
    Blur:Destroy()
end

PlayFixedPremiumLoading()