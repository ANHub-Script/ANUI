local OpenButton = {}

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween


local cloneref = (cloneref or clonereference or function(instance) return instance end)


local UserInputService = cloneref(game:GetService("UserInputService"))


function OpenButton.New(Window)
    local OpenButtonMain = {
        Button = nil,
        CurrentConfig = {}
    }
    
    local Icon
    
    
    
    -- Icon = New("ImageLabel", {
    --     Image = "",
    --     Size = UDim2.new(0,22,0,22),
    --     Position = UDim2.new(0.5,0,0.5,0),
    --     LayoutOrder = -1,
    --     AnchorPoint = Vector2.new(0.5,0.5),
    --     BackgroundTransparency = 1,
    --     Name = "Icon"
    -- })

    local Title = New("TextLabel", {
        Text = Window.Title,
        TextSize = 10,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        BackgroundTransparency = 1,
        AutomaticSize = "XY",
    })

    local Drag = New("Frame", {
        Size = UDim2.new(0,22-8,0,22-8),
        BackgroundTransparency = 1, 
        Name = "Drag",
    }, {
        New("ImageLabel", {
            Image = Creator.Icon("move")[1],
            ImageRectOffset = Creator.Icon("move")[2].ImageRectPosition,
            ImageRectSize = Creator.Icon("move")[2].ImageRectSize,
            Size = UDim2.new(0,9,0,9),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5,0,0.5,0),
            AnchorPoint = Vector2.new(0.5,0.5),
            ThemeTag = {
                ImageColor3 = "Icon",
            },
            ImageTransparency = .3,
        })
    })
    local Divider = New("Frame", {
        Size = UDim2.new(0,1,1,0),
        Position = UDim2.new(0,10+8,0.5,0),
        AnchorPoint = Vector2.new(0,0.5),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = .9,
    })

    local Container = New("Frame", {
        Size = UDim2.new(0,0,0,0),
        Position = UDim2.new(0.5,0,0,6+22/2),
        AnchorPoint = Vector2.new(0.5,0.5),
        Parent = Window.Parent,
        BackgroundTransparency = 1,
        Active = true,
        Visible = false,
    })
    local Button = New("TextButton", {
        Size = UDim2.new(0,0,0,22),
        AutomaticSize = "X",
        Parent = Container,
        Active = false,
        BackgroundTransparency = .25,
        ZIndex = 99,
        BackgroundColor3 = Color3.new(0,0,0),
    }, {
        New("UIScale", {
            Scale = 1,
        }),
	    New("UICorner", {
            CornerRadius = UDim.new(1,0)
        }),
        New("UIStroke", {
            Thickness = 1,
            ApplyStrokeMode = "Border",
            Color = Color3.new(1,1,1),
            Transparency = 0,
        }, {
            New("UIGradient", {
                Color = ColorSequence.new(Color3.fromHex("40c9ff"), Color3.fromHex("e81cff"))
            })
        }),
        Drag,
        Divider,
        
        New("UIListLayout", {
            Padding = UDim.new(0, 4),
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
        }),
        
        New("TextButton",{
            AutomaticSize = "XY",
            Active = true,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,0,22-(4*2)),
            BackgroundColor3 = Color3.new(1,1,1),
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(1,-4)
            }),
            Icon,
            New("UIListLayout", {
                Padding = UDim.new(0, Window.UIPadding),
                FillDirection = "Horizontal",
                VerticalAlignment = "Center",
            }),
            Title,
            New("UIPadding", {
                PaddingLeft = UDim.new(0,6),
                PaddingRight = UDim.new(0,6),
            }),
        }),
        New("UIPadding", {
            PaddingLeft = UDim.new(0,4),
            PaddingRight = UDim.new(0,4),
        })
    })
    
    OpenButtonMain.Button = Button
    
    
    
    function OpenButtonMain:SetIcon(newIcon)
        if Icon then
            Icon:Destroy()
        end
        if newIcon then
            Icon = Creator.Image(
                newIcon,
                Window.Title,
                0,
                Window.Folder,
                "OpenButton",
                true,
                Window.IconThemed
            )
            Icon.Size = UDim2.new(0,11,0,11)
            Icon.LayoutOrder = -1
            Icon.Parent = OpenButtonMain.Button.TextButton
        end
    end
    
    if Window.Icon then
        OpenButtonMain:SetIcon(Window.Icon)
    end
    
    
    
    Creator.AddSignal(Button:GetPropertyChangedSignal("AbsoluteSize"), function()
        Container.Size = UDim2.new(
            0, Button.AbsoluteSize.X,
            0, Button.AbsoluteSize.Y
        )
    end)
    
    Creator.AddSignal(Button.TextButton.MouseEnter, function()
        Tween(Button.TextButton, .1, {BackgroundTransparency = .93}):Play()
    end)
    Creator.AddSignal(Button.TextButton.MouseLeave, function()
        Tween(Button.TextButton, .1, {BackgroundTransparency = 1}):Play()
    end)
    
    local DragModule = Creator.Drag(Container, {Drag, Button.TextButton})
    
    
    function OpenButtonMain:Visible(v)
        Container.Visible = v
    end
    
    function OpenButtonMain:Edit(OpenButtonConfig)
        for k, v in pairs(OpenButtonConfig) do
            OpenButtonMain.CurrentConfig[k] = v
        end
        local cfg = OpenButtonMain.CurrentConfig

        local OpenButtonModule = {
            Title = cfg.Title,
            Icon = cfg.Icon,
            Enabled = cfg.Enabled,
            Position = cfg.Position,
            OnlyIcon = cfg.OnlyIcon or false,
            Draggable = cfg.Draggable,
            OnlyMobile = cfg.OnlyMobile,
            CornerRadius = cfg.CornerRadius or UDim.new(1, 0),
            StrokeThickness = cfg.StrokeThickness or 2,
            Color = cfg.Color 
                or ColorSequence.new(Color3.fromHex("40c9ff"), Color3.fromHex("e81cff")),
        }
        
        -- wtf lol
        
        if OpenButtonModule.Enabled == false then
            Window.IsOpenButtonEnabled = false
        end
        
        if OpenButtonModule.OnlyMobile ~= false then
            OpenButtonModule.OnlyMobile = true
        else
            Window.IsPC = false
        end
        
        if OpenButtonModule.OnlyIcon == true then
            -- Delta Executor Style: Square/Circle, Icon Only
            local size = Window.IsPC and 50 or 60
            OpenButtonModule.Size = UDim2.new(0, size, 0, size)
            OpenButtonModule.CornerRadius = UDim.new(1, 0)
            
            if Title then Title.Visible = false end
            if Drag then Drag.Visible = false end
            if Divider then Divider.Visible = false end
            
            -- Adjust Padding to 0 for centering
            Button.TextButton.UIPadding.PaddingLeft = UDim.new(0,0)
            Button.TextButton.UIPadding.PaddingRight = UDim.new(0,0)
            
            -- Center the layout
            Button.TextButton.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            Button.TextButton.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            
            -- Make Icon Bigger
            if Icon then
                Icon.Size = UDim2.new(0, size * 0.5, 0, size * 0.5)
            end

            -- Fill container
            Button.AutomaticSize = Enum.AutomaticSize.None
            Button.Size = OpenButtonModule.Size
            Button.TextButton.Size = UDim2.new(1, 0, 1, 0)
            Button.TextButton.AutomaticSize = Enum.AutomaticSize.None

        elseif OpenButtonModule.OnlyIcon == false then
            Title.Visible = true
            if Drag then Drag.Visible = true end
            if Divider then Divider.Visible = true end
            
            Button.TextButton.UIPadding.PaddingLeft = UDim.new(0,6)
            Button.TextButton.UIPadding.PaddingRight = UDim.new(0,6)
            
            Button.TextButton.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
            Button.TextButton.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            
            if Icon then
                Icon.Size = UDim2.new(0,11,0,11)
            end
            
            -- Reset Size Logic for Normal Mode
            local defaultWidth = Window.IsPC and 150 or 60
            if not OpenButtonModule.Size then
                 OpenButtonModule.Size = UDim2.new(0, defaultWidth, 0, 22)
            end
            Button.AutomaticSize = Enum.AutomaticSize.None
            Button.Size = OpenButtonModule.Size
            Button.TextButton.Size = UDim2.new(0,0,0,22-(4*2))
            Button.TextButton.AutomaticSize = Enum.AutomaticSize.XY
        end
        
        --OpenButtonMain:Visible((not OpenButtonModule.OnlyMobile) or (not Window.IsPC))
        
        --if not OpenButton.Visible then return end
        
        if Title then
            if OpenButtonModule.Title then
                Title.Text = OpenButtonModule.Title
                Creator:ChangeTranslationKey(Title, OpenButtonModule.Title)
            elseif OpenButtonModule.Title == nil then
                --Title.Visible = false
            end
        end
        
        if OpenButtonModule.Icon then
            OpenButtonMain:SetIcon(OpenButtonModule.Icon)
        end

        Button.UIStroke.UIGradient.Color = OpenButtonModule.Color
        if Glow then
            Glow.UIGradient.Color = OpenButtonModule.Color
        end

        Button.UICorner.CornerRadius = OpenButtonModule.CornerRadius
        Button.TextButton.UICorner.CornerRadius = UDim.new(OpenButtonModule.CornerRadius.Scale, OpenButtonModule.CornerRadius.Offset-4)
        Button.UIStroke.Thickness = OpenButtonModule.StrokeThickness
    end

    return OpenButtonMain
end



return OpenButton
