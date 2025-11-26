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

    -- 1. Container Scroll Horizontal
    local MainFrame = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1,
        ScrollingDirection = Enum.ScrollingDirection.X, -- Scroll Horizontal
        ScrollBarThickness = 0, -- Sembunyikan scrollbar
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        Parent = Config.Parent,
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

    local ButtonObjects = {}
    
    -- Fungsi Update Visual (Warna Aktif/Mati)
    local function UpdateVisuals(selectedName)
        for name, objs in pairs(ButtonObjects) do
            local isActive = (name == selectedName)
            
            -- Ambil tema global dari Creator untuk menghindari error nil
            local Theme = Creator.Theme
            
            -- Tentukan key warna: "Toggle" (Hijau/Aktif) atau "Button" (Abu/Mati)
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

    -- 2. Loop Membuat Tombol
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

    -- Set Default Active saat pertama kali load
    if Category.Default then
        UpdateVisuals(Category.Default)
    elseif Category.Options[1] then
        local firstOption = Category.Options[1]
        local firstName = (type(firstOption) == "table" and firstOption.Title) or firstOption
        UpdateVisuals(firstName)
    end
    
    Category.ElementFrame = MainFrame
    return Category.__type, Category
end

return Element