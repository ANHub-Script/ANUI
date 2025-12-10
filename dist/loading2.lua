local function PlayElegantLoading()
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local CoreGui = game:GetService("CoreGui")
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    local TargetParent = pcall(function() return CoreGui.Name end) and CoreGui or PlayerGui
    
    -- Setup Blur
    local Blur = Instance.new("BlurEffect")
    Blur.Name = "ANHub_Blur"
    Blur.Size = 0
    Blur.Parent = Lighting

    -- Setup GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ANHub_LoadScreen"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 9999
    ScreenGui.Parent = TargetParent

    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.Parent = ScreenGui
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.Size = UDim2.new(1, 0, 1, 0)

    local Card = Instance.new("Frame")
    Card.Name = "Card"
    Card.Parent = ScreenGui
    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Card.Position = UDim2.new(0.5, 0, 0.5, 0)
    Card.Size = UDim2.new(0, 0, 0, 0)
    Card.BorderSizePixel = 0
    Card.ClipsDescendants = false

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 12)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Parent = Card
    CardStroke.Thickness = 2
    CardStroke.Transparency = 1

    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 170)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
    })
    StrokeGradient.Rotation = 45
    StrokeGradient.Parent = CardStroke

    local Shadow = Instance.new("ImageLabel")
    Shadow.Parent = Card
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 140, 1, 140)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 200, 255)
    Shadow.ImageTransparency = 1
    Shadow.ZIndex = 0

    local ContentContainer = Instance.new("CanvasGroup")
    ContentContainer.Name = "Content"
    ContentContainer.Parent = Card
    ContentContainer.Size = UDim2.new(1, 0, 1, 0)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.GroupTransparency = 1

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 12)
    ContentCorner.Parent = ContentContainer

    local Title = Instance.new("TextLabel")
    Title.Parent = ContentContainer
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0.15, 0)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "AN HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 32

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Parent = ContentContainer
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, 0, 0.4, 0)
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Font = Enum.Font.GothamMedium;
    SubTitle.Text = "ANIME ADVANCED"
    SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    SubTitle.TextSize = 14

    local StatusText = Instance.new("TextLabel")
    StatusText.Parent = ContentContainer
    StatusText.BackgroundTransparency = 1
    StatusText.Position = UDim2.new(0, 30, 0.65, 0)
    StatusText.Size = UDim2.new(1, -60, 0, 20)
    StatusText.Font = Enum.Font.Gotham
    StatusText.Text = "Initializing..."
    StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusText.TextSize = 12
    StatusText.TextXAlignment = Enum.TextXAlignment.Left

    local PercentText = Instance.new("TextLabel")
    PercentText.Parent = ContentContainer
    PercentText.BackgroundTransparency = 1
    PercentText.Position = UDim2.new(0, 30, 0.65, 0)
    PercentText.Size = UDim2.new(1, -60, 0, 20)
    PercentText.Font = Enum.Font.GothamBold
    PercentText.Text = "0%"
    PercentText.TextColor3 = Color3.fromRGB(0, 255, 170)
    PercentText.TextSize = 12
    PercentText.TextXAlignment = Enum.TextXAlignment.Right

    local BarBG = Instance.new("Frame")
    BarBG.Parent = ContentContainer
    BarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BarBG.Position = UDim2.new(0, 30, 0.8, 0)
    BarBG.Size = UDim2.new(1, -60, 0, 6)
    BarBG.BorderSizePixel = 0

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = BarBG

    local BarFill = Instance.new("Frame")
    BarFill.Parent = BarBG
    BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BorderSizePixel = 0

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = BarFill

    local BarGradient = Instance.new("UIGradient")
    BarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 170)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
    })
    BarGradient.Parent = BarFill

    -- Animation Intro
    TweenService:Create(Blur, TweenInfo.new(0.8), {Size = 20}):Play()
    TweenService:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 0.3}):Play()
    task.wait(0.2)
    
    local TargetSize = UDim2.new(0, 420, 0, 160)
    TweenService:Create(Card, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
    TweenService:Create(CardStroke, TweenInfo.new(0.6), {Transparency = 0}):Play()
    TweenService:Create(Shadow, TweenInfo.new(0.6), {ImageTransparency = 0.6}):Play()
    task.wait(0.3)
    TweenService:Create(ContentContainer, TweenInfo.new(0.5), {GroupTransparency = 0}):Play()

    -- Loading Process
    local StartTime = os.clock()
    local Duration = 5
    local ProgressValue = Instance.new("NumberValue")
    ProgressValue.Value = 0

    ProgressValue:GetPropertyChangedSignal("Value"):Connect(function()
        local val = ProgressValue.Value
        PercentText.Text = math.floor(val) .. "%"
        BarFill.Size = UDim2.new(val / 100, 0, 1, 0)
    end)

    task.spawn(function()
        local TweenInfoAnim = TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        TweenService:Create(ProgressValue, TweenInfoAnim, {Value = 100}):Play()
    end)

    local steps = {
        {Time = 0, Text = "Verifying Key System..."},
        {Time = 1, Text = "Bypassing Security Checks..."},
        {Time = 2.2, Text = "Reading Game Data..."},
        {Time = 3.5, Text = "Loading Configs & Assets..."},
        {Time = 4.5, Text = "Finalizing Interface..."}
    }

    for i, step in ipairs(steps) do
        local elapsedTime = os.clock() - StartTime
        local waitTime = step.Time - elapsedTime
        if waitTime > 0 then task.wait(waitTime) end
        
        StatusText.TextTransparency = 1
        StatusText.Text = step.Text
        TweenService:Create(StatusText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    end

    local remaining = Duration - (os.clock() - StartTime)
    if remaining > 0 then task.wait(remaining) end

    -- Done
    PercentText.Text = "100%"
    BarFill.Size = UDim2.new(1, 0, 1, 0)
    StatusText.Text = "Ready!"
    task.wait(0.5)

    -- Animation Out
    TweenService:Create(ContentContainer, TweenInfo.new(0.3), {GroupTransparency = 1}):Play()
    TweenService:Create(CardStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
    
    local PopOut = TweenService:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    PopOut:Play()
    TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
    TweenService:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    
    PopOut.Completed:Wait()
    ScreenGui:Destroy()
    Blur:Destroy()
end
PlayElegantLoading()
