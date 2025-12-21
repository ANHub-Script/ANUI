local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateToggle = require("../components/ui/Toggle").New
local CreateCheckbox = require("../components/ui/Checkbox").New

local Element = {}

function Element:New(Config)
    local Toggle = {
        __type = "Toggle",
        Title = Config.Title or "Toggle",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or false,
        Value = Config.Value,
        Icon = Config.Icon or nil,
        IconSize = Config.IconSize or 23,
        Image = Config.Image,
        ImageSize = Config.ImageSize or 30,
        Thumbnail = Config.Thumbnail,
        ThumbnailSize = Config.ThumbnailSize or 80,
        Type = Config.Type or "Toggle",
        Callback = Config.Callback or function() end,
        UIElements = {}
    }

    -- Handle complex image for Element constructor
    local initialImage = Toggle.Image
    if typeof(initialImage) == "table" then
        initialImage = nil 
    end

    Toggle.ToggleFrame = require("../components/window/Element")({
        Title = Toggle.Title,
        Desc = Toggle.Desc,
        Image = initialImage,
        ImageSize = Toggle.ImageSize,  
        Thumbnail = Toggle.Thumbnail,
        ThumbnailSize = Toggle.ThumbnailSize,
        Window = Config.Window,
        Parent = Config.Parent,
        TextOffset = (24+24+4),
        Hover = false,
        Tab = Config.Tab,
        Index = Config.Index,
        ElementTable = Toggle,
        ParentConfig = Config,
        ParentType = Config.ParentType,
    })
    
    local CanCallback = true
    
    if Toggle.Value == nil then
        Toggle.Value = false
    end

    -- [UPDATED FUNCTION] SetMainImage dengan Title Bar & TextWrapped
    function Toggle:SetMainImage(image, size)
        local TitleFrameOuter = Toggle.ToggleFrame.UIElements.Container:FindFirstChild("TitleFrame")
        if not TitleFrameOuter then return end 

        local OldIcon = TitleFrameOuter:FindFirstChild("CustomMainIcon")
        if OldIcon then OldIcon:Destroy() end

        for _, child in ipairs(TitleFrameOuter:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "TitleFrame" and child.Name ~= "UIListLayout" and child.Name ~= "CustomMainIcon" then
                child:Destroy()
            end
        end

        if not image then
            local InnerTitleFrame = TitleFrameOuter:FindFirstChild("TitleFrame")
            if InnerTitleFrame then InnerTitleFrame.Size = UDim2.new(1, 0, 1, 0) end
            return
        end

        local ImageSize = size or Toggle.ImageSize or 30
        if typeof(ImageSize) == "number" then
            ImageSize = UDim2.new(0, ImageSize, 0, ImageSize)
        end

        local NewIconFrame

        -- [STYLE 1] Card Style (Table Input)
        if typeof(image) == "table" then
            local CardData = image
            local CardImage = CardData.Image or ""
            local CardGradient = CardData.Gradient
            local CardQuantity = CardData.Quantity
            local CardRate = CardData.Rate -- Tambahan: Rate (Contoh: "1%")
            local CardTitle = CardData.Title -- Tambahan: Title Bawah (Contoh: "Tobu")
            
            local GradientColor
            if typeof(CardGradient) == "ColorSequence" then
                GradientColor = CardGradient
            elseif typeof(CardGradient) == "Color3" then
                GradientColor = ColorSequence.new(CardGradient)
            else
                GradientColor = ColorSequence.new(Color3.fromRGB(80, 80, 80))
            end
            
            local BorderColor = GradientColor.Keypoints[1].Value
            local borderThickness = 2

            -- Frame Utama (Border)
            NewIconFrame = Creator.NewRoundFrame(8, "Squircle", {
                Name = "CustomMainIcon", 
                Size = ImageSize,
                Parent = TitleFrameOuter,
                ImageColor3 = BorderColor,
                ClipsDescendants = true,
                LayoutOrder = -1, 
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 0, 0.5, 0),
            }, {
                -- Inner Shadow
                New("ImageLabel", {
                    Image = "rbxassetid://5554236805",
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(23,23,277,277),
                    Size = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1,
                    ImageColor3 = Color3.new(0,0,0),
                    ImageTransparency = 0.4,
                    ZIndex = 2,
                }),
                -- Konten Dalam
                Creator.NewRoundFrame(8, "Squircle", {
                    Size = UDim2.new(1, -borderThickness*2, 1, -borderThickness*2),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ImageColor3 = Color3.new(1,1,1),
                    ClipsDescendants = true,
                    ZIndex = 3,
                }, {
                    -- Gradient Background
                    New("UIGradient", {
                        Color = GradientColor,
                        Rotation = 45,
                    }),
                    -- Gambar Item
                    New("ImageLabel", {
                        Image = CardImage,
                        Size = UDim2.new(0.65, 0, 0.65, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.45, 0), -- Sedikit ke atas agar muat Title
                        BackgroundTransparency = 1,
                        ScaleType = "Fit",
                        ZIndex = 4,
                    }),
                    
                    -- [1] Text Quantity (Kiri Atas) - TextWrapped = true
                    CardQuantity and New("TextLabel", {
                        Text = CardQuantity,
                        Size = UDim2.new(0.5, 0, 0, 12),
                        Position = UDim2.new(0, 4, 0, 2),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextColor3 = Color3.new(1, 1, 1),
                        FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                        TextSize = 8,
                        TextStrokeTransparency = 0,
                        TextStrokeColor3 = Color3.new(0,0,0),
                        -- TextWrapped = true, -- Request
                        ZIndex = 5,
                    }) or nil,

                    -- [2] Text Rate (Kanan Atas) - TextWrapped = true
                    CardRate and New("TextLabel", {
                        Text = CardRate,
                        Size = UDim2.new(0.5, -4, 0, 12),
                        Position = UDim2.new(1, -4, 0, 2),
                        AnchorPoint = Vector2.new(1, 0),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        TextColor3 = Color3.new(1, 1, 1),
                        FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                        TextSize = 11,
                        TextStrokeTransparency = 0,
                        TextStrokeColor3 = Color3.new(0,0,0),
                        TextWrapped = true, -- Request
                        ZIndex = 5,
                    }) or nil,

                    -- [3] Title Bar (Bawah) - TextWrapped = true
                    CardTitle and New("Frame", {
                        Size = UDim2.new(1, 0, 0, 18), -- Tinggi bar
                        Position = UDim2.new(0, 0, 1, 0), -- Di dasar
                        AnchorPoint = Vector2.new(0, 1),
                        BackgroundColor3 = Color3.new(0, 0, 0),
                        BackgroundTransparency = 0.4,
                        BorderSizePixel = 0,
                        ZIndex = 6,
                    }, {
                        New("TextLabel", {
                            Text = CardTitle,
                            Size = UDim2.new(1, -2, 1, 0),
                            Position = UDim2.new(0.5, 0, 0, 0),
                            AnchorPoint = Vector2.new(0.5, 0),
                            BackgroundTransparency = 1,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            TextColor3 = Color3.new(1, 1, 1),
                            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                            TextSize = 10,
                            TextWrapped = true, -- Request
                            ZIndex = 7,
                        })
                    }) or nil
                })
            })

        -- [STYLE 2] Image Biasa
        else
            NewIconFrame = Creator.Image(
                image, 
                Toggle.Title, 
                Config.Window.NewElements and 12 or 6, 
                Config.Window.Folder, 
                "ToggleIcon", 
                false
            )
            NewIconFrame.Name = "CustomMainIcon"
            NewIconFrame.Parent = TitleFrameOuter
            NewIconFrame.Size = ImageSize
            NewIconFrame.LayoutOrder = -1
            NewIconFrame.AnchorPoint = Vector2.new(0, 0.5)
            NewIconFrame.Position = UDim2.new(0, 0, 0.5, 0)
            NewIconFrame.BackgroundTransparency = 1
        end
        
        local InnerTitleFrame = TitleFrameOuter:FindFirstChild("TitleFrame")
        if InnerTitleFrame then
            InnerTitleFrame.Size = UDim2.new(1, -ImageSize.X.Offset, 1, 0)
        end
    end

    if typeof(Toggle.Image) == "table" then
        Toggle:SetMainImage(Toggle.Image, Toggle.ImageSize)
    end
    

    function Toggle:Lock(text) -- Tambahkan 'text'
        Toggle.Locked = true
        CanCallback = false
        return Toggle.ToggleFrame:Lock(text) -- Kirim 'text' ke frame
    end
    function Toggle:Unlock()
        Toggle.Locked = false
        CanCallback = true
        return Toggle.ToggleFrame:Unlock()
    end
    
    if Toggle.Locked then
        Toggle:Lock()
    end

    local Toggled = Toggle.Value
    
    local ToggleFrame, ToggleFunc
    if Toggle.Type == "Toggle" then
        ToggleFrame, ToggleFunc = CreateToggle(Toggled, Toggle.Icon, Toggle.IconSize, Toggle.ToggleFrame.UIElements.Main, Toggle.Callback, Config.Window.NewElements, Config)
    elseif Toggle.Type == "Checkbox" then
        ToggleFrame, ToggleFunc = CreateCheckbox(Toggled, Toggle.Icon, Toggle.IconSize, Toggle.ToggleFrame.UIElements.Main, Toggle.Callback, Config)
    else
        error("Unknown Toggle Type: " .. tostring(Toggle.Type))
    end

    ToggleFrame.AnchorPoint = Vector2.new(1,Config.Window.NewElements and 0 or 0.5)
    ToggleFrame.Position = UDim2.new(1,0,Config.Window.NewElements and 0 or 0.5,0)
    
    function Toggle:Set(v, isCallback, isAnim)
        if CanCallback then
            ToggleFunc:Set(v, isCallback, isAnim or false)
            Toggled = v
            Toggle.Value = v
        end
    end

    Toggle:Set(Toggled, false, Config.Window.NewElements)


    if Config.Window.NewElements and ToggleFunc.Animate then
        Creator.AddSignal(Toggle.ToggleFrame.UIElements.Main.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                ToggleFunc:Animate(input, Toggle)
            end
        end)
    else
        Creator.AddSignal(Toggle.ToggleFrame.UIElements.Main.MouseButton1Click, function()
            Toggle:Set(not Toggle.Value, nil, Config.Window.NewElements)
        end)
    end
    
    return Toggle.__type, Toggle
end

return Element