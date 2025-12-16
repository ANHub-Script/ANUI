local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Element = {}

function Element:New(Config)
    local Category = {
        __type = "Category",
        Title = Config.Title,
        Desc = Config.Desc,
        Options = Config.Options or {}, 
        Default = Config.Default, 
        Callback = Config.Callback or function() end,
        Parent = Config.Parent,
        UIElements = {},
    }

    -- [FIX UTAMA] Wrapper Frame agar Section mendeteksi tinggi elemen ini
    -- Tanpa ini, AutomaticSize Section akan menganggap Category tingginya 0
    local WrapperFrame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 45), -- Tinggi Fix 45px
        BackgroundTransparency = 1,
        Parent = Config.Parent,
    })

    -- Container Scroll (Dimasukkan ke dalam Wrapper)
    local MainFrame = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), -- Mengisi Wrapper
        BackgroundTransparency = 1,
        ScrollingDirection = Enum.ScrollingDirection.X, -- Scroll Horizontal
        ScrollBarThickness = 0, -- Sembunyikan scrollbar
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        Parent = WrapperFrame, 
    }, {
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
        })
    })

    -- [FIX START] - Logika Scroll Manual (Drag & Mouse Wheel)
    MainFrame.Active = true -- Penting agar frame bisa menerima input
    
    local isDragging = false
    local dragStart = Vector2.new()
    local startCanvasPos = Vector2.new()

    -- 1. Deteksi Klik untuk Mulai Drag
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startCanvasPos = MainFrame.CanvasPosition
        end
    end)

    -- 2. Deteksi Lepas Klik untuk Stop Drag
    MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    -- 3. Deteksi Gerakan Mouse & Roda Mouse
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if isDragging then
                local delta = input.Position - dragStart
                -- Menggeser CanvasPosition berdasarkan gerakan mouse
                MainFrame.CanvasPosition = Vector2.new(startCanvasPos.X - delta.X, 0)
            end
        elseif input.UserInputType == Enum.UserInputType.MouseWheel then
            -- Mengubah Scroll Atas/Bawah menjadi Kiri/Kanan
            local scrollAmount = input.Position.Z * -35 -- Atur kecepatan scroll di sini (-35)
            MainFrame.CanvasPosition = MainFrame.CanvasPosition + Vector2.new(scrollAmount, 0)
        end
    end)
    -- [FIX END]

    local ButtonObjects = {}
    
    local function UpdateVisuals(selectedName)
        for name, objs in pairs(ButtonObjects) do
            local isActive = (name == selectedName)
            local Theme = Creator.Theme
            
            local ColorVal = Creator.GetThemeProperty(isActive and "Toggle" or "Button", Theme)
            local TextColorVal = Creator.GetThemeProperty("Text", Theme)
            local TargetTransparency = isActive and 0 or 0.5

            Tween(objs.Background, 0.2, {ImageColor3 = ColorVal}):Play()
            Tween(objs.Title, 0.2, {TextTransparency = TargetTransparency, TextColor3 = TextColorVal}):Play()
            
            if objs.Icon then
                Tween(objs.Icon.ImageLabel, 0.2, {ImageTransparency = TargetTransparency, ImageColor3 = TextColorVal}):Play()
            end
        end
    end

    for i, option in ipairs(Category.Options) do
        local OptName = (type(option) == "table" and option.Title) or option
        local OptIcon = (type(option) == "table" and option.Icon) or nil
        
        local ButtonFrame = New("TextButton", {
            AutoButtonColor = false,
            Size = UDim2.new(0, 0, 0, 32),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text = "",
            Parent = MainFrame,
            LayoutOrder = i
        })

        local Background = Creator.NewRoundFrame(8, "Squircle", {
            Size = UDim2.new(1, 0, 1, 0),
            ThemeTag = { ImageColor3 = "Button" },
            Name = "Background",
            Parent = ButtonFrame
        }, {
             New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
            }),
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
            })
        })

        local IconObj
        if OptIcon then
            IconObj = Creator.Image(OptIcon, "Icon", 0, Config.Window.Folder, "Icon", false)
            IconObj.Size = UDim2.new(0, 18, 0, 18)
            IconObj.BackgroundTransparency = 1
            IconObj.ImageLabel.ImageTransparency = 0.5
            IconObj.Parent = Background
        end

        local TitleObj = New("TextLabel", {
            Text = OptName,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
            TextSize = 14,
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            ThemeTag = { TextColor3 = "Text" },
            TextTransparency = 0.5,
            Parent = Background
        })

        ButtonObjects[OptName] = {
            Frame = ButtonFrame,
            Background = Background,
            Title = TitleObj,
            Icon = IconObj
        }

        Creator.AddSignal(ButtonFrame.MouseButton1Click, function()
            UpdateVisuals(OptName)
            if Category.Callback then
                Category.Callback(OptName)
            end
        end)
    end

    if Category.Default then
        UpdateVisuals(Category.Default)
    elseif Category.Options[1] then
        local firstOption = Category.Options[1]
        local firstName = (type(firstOption) == "table" and firstOption.Title) or firstOption
        UpdateVisuals(firstName)
    end
    
    -- Return WrapperFrame agar Section menganggap ini elemen yang valid
    Category.ElementFrame = WrapperFrame 
    return Category.__type, Category
end

return Element