local DropdownMenu = {}

local cloneref = (cloneref or clonereference or function(instance) return instance end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local Mouse = cloneref(game:GetService("Players")).LocalPlayer:GetMouse()
local Camera = cloneref(game:GetService("Workspace")).CurrentCamera

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CurrentCamera = workspace.CurrentCamera

function DropdownMenu.New(Config, Dropdown, Element, CanCallback, Type)
    local DropdownModule = {}
    
    if not Dropdown.Callback then
        Type = "Menu"
    end
    
    -- [RENDER IMAGES HELPER] - Dipindahkan ke sini agar bisa diakses oleh Edit & Refresh
    local function RenderImages(Container, ImagesData)
        -- Bersihkan container lama
        for _, child in ipairs(Container:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end

        if not ImagesData or #ImagesData == 0 then return end

        for _, imageData in ipairs(ImagesData) do
            local isCard = false
            if typeof(imageData) == "table" and (imageData.Quantity or imageData.Gradient or imageData.Card) then
                isCard = true
            end
            
            if isCard then
                local CardSize = imageData.Size or Dropdown.ImageSize or UDim2.new(0, 60, 0, 60)
                local CardTitle = imageData.Title or "Item"
                local CardQuantity = imageData.Quantity or ""
                local CardRate = imageData.Rate or "" 
                local CardImage = imageData.Image or ""
                local CardGradient = imageData.Gradient
                
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

                -- Render Struktur Card
                local Card = Creator.NewRoundFrame(8, "Squircle", {
                    Size = CardSize,
                    Parent = Container,
                    ImageColor3 = BorderColor,
                    ClipsDescendants = true,
                }, {
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
                    
                    (Creator.NewRoundFrame(8, "Squircle", {
                        Size = UDim2.new(1, -borderThickness*2, 1, -borderThickness*2),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ImageColor3 = Color3.new(1,1,1),
                        ClipsDescendants = true,
                        ZIndex = 3,
                    }, {
                        New("UIGradient", { Color = GradientColor, Rotation = 45 }),
                        New("ImageLabel", {
                            Image = CardImage,
                            Size = UDim2.new(0.65, 0, 0.65, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.45, 0),
                            BackgroundTransparency = 1,
                            ScaleType = "Fit",
                            ZIndex = 4,
                        }),
                        CardQuantity and New("TextLabel", {
                            Text = CardQuantity,
                            Size = UDim2.new(0.5, 0, 0, 12),
                            Position = UDim2.new(0, 4, 0, 2),
                            BackgroundTransparency = 1,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextColor3 = Color3.new(1, 1, 1),
                            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                            TextSize = 10,
                            TextStrokeTransparency = 0, 
                            TextStrokeColor3 = Color3.new(0,0,0),
                            ZIndex = 5,
                        }) or nil,
                        CardRate and New("TextLabel", {
                            Text = CardRate,
                            Size = UDim2.new(0.5, -4, 0, 12),
                            Position = UDim2.new(1, -4, 0, 2),
                            AnchorPoint = Vector2.new(1, 0),
                            BackgroundTransparency = 1,
                            TextXAlignment = Enum.TextXAlignment.Right, 
                            TextColor3 = Color3.new(1, 1, 1),
                            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                            TextSize = 10,
                            TextStrokeTransparency = 0,
                            TextStrokeColor3 = Color3.new(0,0,0),
                            ZIndex = 5,
                        }) or nil,
                        New("Frame", {
                            Size = UDim2.new(1, 0, 0, 18),
                            Position = UDim2.new(0, 0, 1, 0),
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
                                TextSize = 9, 
                                TextWrapped = true,
                                TextTruncate = "AtEnd",
                                ZIndex = 7,
                            }),
                        })
                    }))
                })
            else
                local imageId = (typeof(imageData) == "table" and (imageData.Image or imageData.Icon or imageData.Id)) or imageData
                local imgFrame = Creator.Image(imageId, tostring(imageId), 6, Config.Window.Folder, "Dropdown", false)
                imgFrame.Size = Dropdown.ImageSize or UDim2.new(0, 30, 0, 30)
                imgFrame.Parent = Container
            end
        end
    end

    -- Setup UI List Layouts
    Dropdown.UIElements.UIListLayout = New("UIListLayout", {
        Padding = UDim.new(0,Element.MenuPadding/1.5),
        FillDirection = "Vertical",
        HorizontalAlignment = "Center",
    })

    Dropdown.UIElements.Menu = Creator.NewRoundFrame(Element.MenuCorner, "Squircle", {
        ThemeTag = { ImageColor3 = "Background" },
        ImageTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        AnchorPoint = Vector2.new(1,0),
        Position = UDim2.new(1,0,0,0),
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0, Element.MenuPadding),
            PaddingLeft = UDim.new(0, Element.MenuPadding),
            PaddingRight = UDim.new(0, Element.MenuPadding),
            PaddingBottom = UDim.new(0, Element.MenuPadding),
        }),
        New("UIListLayout", { FillDirection = "Vertical", Padding = UDim.new(0,Element.MenuPadding) }),
        New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,Dropdown.SearchBarEnabled and -Element.MenuPadding-Element.SearchBarHeight ),
            Name = "Frame",
            ClipsDescendants = true,
            LayoutOrder = 999,
        }, {
            New("UICorner", { CornerRadius = UDim.new(0,Element.MenuCorner - Element.MenuPadding) }),
            New("ScrollingFrame", {
                Size = UDim2.new(1,0,1,0),
                ScrollBarThickness = 0,
                ScrollingDirection = "Y",
                AutomaticCanvasSize = "Y",
                CanvasSize = UDim2.new(0,0,0,0),
                BackgroundTransparency = 1,
                ScrollBarImageTransparency = 1,
            }, {
                Dropdown.UIElements.UIListLayout,
            })
        })
    })

    Dropdown.UIElements.MenuCanvas = New("Frame", {
        Size = UDim2.new(0,Dropdown.MenuWidth,0,300),
        BackgroundTransparency = 1,
        Position = UDim2.new(-10,0,-10,0),
        Visible = false,
        Active = false,
        Parent = Config.ANUI.DropdownGui,
        AnchorPoint = Vector2.new(1,0),
    }, {
        Dropdown.UIElements.Menu,
        New("UISizeConstraint", {
            MinSize = Vector2.new(170,0),
            MaxSize = Vector2.new(300,400),
        })
    })
    
    local function RecalculateCanvasSize()
        Dropdown.UIElements.Menu.Frame.ScrollingFrame.CanvasSize = UDim2.fromOffset(0, Dropdown.UIElements.UIListLayout.AbsoluteContentSize.Y)
    end
    local function RecalculateListSize()
        local MaxHeight = CurrentCamera.ViewportSize.Y * 0.6
        local ContentY = Dropdown.UIElements.UIListLayout.AbsoluteContentSize.Y 
        local SearchBarOffset = Dropdown.SearchBarEnabled and (Element.SearchBarHeight + (Element.MenuPadding*3)) or (Element.MenuPadding*2)
        local TotalY = (ContentY) + SearchBarOffset
        if TotalY > MaxHeight then
            Dropdown.UIElements.MenuCanvas.Size = UDim2.fromOffset(Dropdown.UIElements.MenuCanvas.AbsoluteSize.X, MaxHeight)
        else
            Dropdown.UIElements.MenuCanvas.Size = UDim2.fromOffset(Dropdown.UIElements.MenuCanvas.AbsoluteSize.X, TotalY)
        end
    end
    
    function UpdatePosition()
        local button = Dropdown.UIElements.Dropdown or Dropdown.DropdownFrame.UIElements.Main
        local menu = Dropdown.UIElements.MenuCanvas
        local availableSpaceBelow = Camera.ViewportSize.Y - (button.AbsolutePosition.Y + button.AbsoluteSize.Y) - Element.MenuPadding - 54
        local requiredSpace = menu.AbsoluteSize.Y + Element.MenuPadding
        local offset = -54 
        if availableSpaceBelow < requiredSpace then offset = requiredSpace - availableSpaceBelow - 54 end
        menu.Position = UDim2.new(0, button.AbsolutePosition.X + button.AbsoluteSize.X, 0, button.AbsolutePosition.Y + button.AbsoluteSize.Y - offset + (Element.MenuPadding*2))
    end
    
    local SearchLabel
    
    function DropdownModule:Display()
        local Values = Dropdown.Values
        local Str = ""
        if Dropdown.Multi then
            local selected = {}
            if typeof(Dropdown.Value) == "table" then
                for _, item in ipairs(Dropdown.Value) do
                    local title = typeof(item) == "table" and item.Title or item
                    selected[title] = true
                end
            end
            for _, value in ipairs(Values) do
                local title = typeof(value) == "table" and value.Title or value
                if selected[title] then Str = Str .. title .. ", " end
            end
            if #Str > 0 then Str = Str:sub(1, #Str - 2) end
        else
            Str = typeof(Dropdown.Value) == "table" and Dropdown.Value.Title or Dropdown.Value or ""
        end
        if Dropdown.UIElements.Dropdown then
            Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Text = (Str == "" and "--" or Str)
        end
    end
    
    local function Callback(customCallback)
        DropdownModule:Display()
        if Dropdown.Callback then
            task.spawn(function() Creator.SafeCallback(Dropdown.Callback, Dropdown.Value) end)
        else
            task.spawn(function() Creator.SafeCallback(customCallback) end)
        end
    end

    function DropdownModule:Refresh(Values)
        for _, Elementt in next, Dropdown.UIElements.Menu.Frame.ScrollingFrame:GetChildren() do
            if not Elementt:IsA("UIListLayout") then Elementt:Destroy() end
        end
        Dropdown.Tabs = {}
        
        if Dropdown.SearchBarEnabled then
            if not SearchLabel then
                SearchLabel = CreateInput("Search...", "search", Dropdown.UIElements.Menu, nil, function(val)
                    for _, tab in next, Dropdown.Tabs do
                        if string.find(string.lower(tab.Name), string.lower(val), 1, true) then
                            tab.UIElements.TabItem.Visible = true
                        else
                            tab.UIElements.TabItem.Visible = false
                        end
                        RecalculateListSize()
                        RecalculateCanvasSize()
                    end
                end, true)
                SearchLabel.Size = UDim2.new(1,0,0,Element.SearchBarHeight)
                SearchLabel.Position = UDim2.new(0,0,0,0)
                SearchLabel.Name = "SearchBar"
            end
        end
        
        for Index,Tab in next, Values do
            if (Tab.Type ~= "Divider") then
                local TabMain = {
                    Name = typeof(Tab) == "table" and Tab.Title or Tab,
                    Desc = typeof(Tab) == "table" and Tab.Desc or nil,
                    Icon = typeof(Tab) == "table" and Tab.Icon or nil,
                    Images = typeof(Tab) == "table" and Tab.Images or nil,
                    Original = Tab,
                    Selected = false,
                    Locked = typeof(Tab) == "table" and Tab.Locked or false,
                    UIElements = {},
                }
                local TabIcon
                if TabMain.Icon then
                    TabIcon = Creator.Image(TabMain.Icon, TabMain.Icon, 0, Config.Window.Folder, "Dropdown", true)
                    TabIcon.Size = UDim2.new(0,Element.TabIcon,0,Element.TabIcon)
                    TabIcon.ImageLabel.ImageTransparency = Type == "Dropdown" and .2 or 0
                    TabMain.UIElements.TabIcon = TabIcon
                end
                TabMain.UIElements.TabItem = Creator.NewRoundFrame(Element.MenuCorner - Element.MenuPadding, "Squircle", {
                    Size = UDim2.new(1,0,0,36),
                    AutomaticSize = ((TabMain.Desc or (TabMain.Images and #TabMain.Images > 0)) and "Y") or nil,
                    ImageTransparency = 1, 
                    Parent = Dropdown.UIElements.Menu.Frame.ScrollingFrame,
                    ImageColor3 = Color3.new(1,1,1),
                    Active = not TabMain.Locked,
                }, {
                    Creator.NewRoundFrame(Element.MenuCorner - Element.MenuPadding, "SquircleOutline", {
                        Size = UDim2.new(1,0,1,0),
                        ImageColor3 = Color3.new(1,1,1),
                        ImageTransparency = 1,
                        Name = "Highlight",
                    }, {
                        New("UIGradient", {
                            Rotation = 80,
                            Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
                            }),
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0.0, 0.1),
                                NumberSequenceKeypoint.new(0.5, 1),
                                NumberSequenceKeypoint.new(1.0, 0.1),
                            })
                        }),
                    }),
                    New("Frame", {
                        Size = UDim2.new(1,0,1,0),
                        BackgroundTransparency = 1,
                        Name = "Frame",
                    }, {
                        New("UIListLayout", { Padding = UDim.new(0, Element.TabPadding), FillDirection = "Horizontal", VerticalAlignment = "Center" }),
                        New("UIPadding", {
                            PaddingTop = UDim.new(0,Element.TabPadding),
                            PaddingLeft = UDim.new(0,Element.TabPadding),
                            PaddingRight = UDim.new(0,Element.TabPadding),
                            PaddingBottom = UDim.new(0,Element.TabPadding),
                        }),
                        New("UICorner", { CornerRadius = UDim.new(0,Element.MenuCorner - Element.MenuPadding) }),
                        TabIcon,
                        New("Frame", {
                            Size = UDim2.new(1,TabIcon and -Element.TabPadding-Element.TabIcon or 0,0,0),
                            BackgroundTransparency = 1,
                            AutomaticSize = "Y",
                            Name = "Title",
                        }, {
                            New("TextLabel", {
                                Text = TabMain.Name,
                                TextXAlignment = "Left",
                                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                                ThemeTag = { TextColor3 = "Text", BackgroundColor3 = "Text" },
                                TextSize = 15,
                                BackgroundTransparency = 1,
                                TextTransparency = Type == "Dropdown" and .4 or .05,
                                LayoutOrder = 1,
                                AutomaticSize = "Y",
                                Size = UDim2.new(1,0,0,0),
                            }),
                            New("TextLabel", {
                                Text = TabMain.Desc or "",
                                TextXAlignment = "Left",
                                FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
                                ThemeTag = { TextColor3 = "Text", BackgroundColor3 = "Text" },
                                TextSize = 15,
                                BackgroundTransparency = 1,
                                TextTransparency = Type == "Dropdown" and .6 or .35,
                                LayoutOrder = 2,
                                AutomaticSize = "Y",
                                TextWrapped = true,
                                Size = UDim2.new(1,0,0,0),
                                Visible = TabMain.Desc and true or false,
                                Name = "Desc",
                            }),
                            New("ScrollingFrame", {
                                Size = UDim2.new(1,0,0,70), 
                                BackgroundTransparency = 1,
                                AutomaticSize = Enum.AutomaticSize.None,
                                AutomaticCanvasSize = Enum.AutomaticSize.X,
                                ScrollingDirection = Enum.ScrollingDirection.X,
                                ScrollBarThickness = 0,
                                CanvasSize = UDim2.new(0,0,0,0),
                                Visible = (TabMain.Images and #TabMain.Images > 0) and true or false,
                                LayoutOrder = 3,
                                Name = "Images",
                            }, {
                                New("UIListLayout", { FillDirection = "Horizontal", Padding = UDim.new(0, Dropdown.ImagePadding or Element.TabPadding/3), VerticalAlignment = "Center" }),
                                New("UIPadding", { PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 2), PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2) })
                            }),
                            New("UIListLayout", { Padding = UDim.new(0, Element.TabPadding/3), FillDirection = "Vertical" }), 
                        })
                    })
                }, true)

                if TabMain.Images and #TabMain.Images > 0 then
                    local imagesContainer = TabMain.UIElements.TabItem.Frame.Title:FindFirstChild("Images")
                    if imagesContainer then RenderImages(imagesContainer, TabMain.Images) end
                end
                
                if TabMain.Locked then
                    TabMain.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency = 0.6
                    if TabMain.UIElements.TabIcon then TabMain.UIElements.TabIcon.ImageLabel.ImageTransparency = 0.6 end
                end

                if Dropdown.Multi and typeof(Dropdown.Value) == "string" then
                    for _, i in next, Dropdown.Values do
                        if typeof(i) == "table" then
                            if i.Title == Dropdown.Value then Dropdown.Value = { i } end
                        else
                            if i == Dropdown.Value then Dropdown.Value = { Dropdown.Value } end
                        end
                    end
                end
                
                if Dropdown.Multi then
                    local found = false
                    if typeof(Dropdown.Value) == "table" then
                        for _, item in ipairs(Dropdown.Value) do
                            local itemName = typeof(item) == "table" and item.Title or item
                            if itemName == TabMain.Name then found = true break end
                        end
                    end
                    TabMain.Selected = found
                else
                    local currentValue = typeof(Dropdown.Value) == "table" and Dropdown.Value.Title or Dropdown.Value
                    TabMain.Selected = currentValue == TabMain.Name
                end
                
                if TabMain.Selected and not TabMain.Locked then
                    TabMain.UIElements.TabItem.ImageTransparency = .95
                    TabMain.UIElements.TabItem.Highlight.ImageTransparency = .75
                    TabMain.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency = 0
                    if TabMain.UIElements.TabIcon then TabMain.UIElements.TabIcon.ImageLabel.ImageTransparency = 0 end
                end
                
                Dropdown.Tabs[Index] = TabMain
                DropdownModule:Display()
                
                if Type == "Dropdown" then
                    Creator.AddSignal(TabMain.UIElements.TabItem.MouseButton1Click, function()
                        if TabMain.Locked then return end 
                        if Dropdown.Multi then
                            if typeof(Dropdown.Value) ~= "table" then
                                Dropdown.Value = {}
                            end
                            if not TabMain.Selected then
                                TabMain.Selected = true
                                Tween(TabMain.UIElements.TabItem, 0.1, {ImageTransparency = .95}):Play()
                                Tween(TabMain.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = .75}):Play()
                                Tween(TabMain.UIElements.TabItem.Frame.Title.TextLabel, 0.1, {TextTransparency = 0}):Play()
                                if TabMain.UIElements.TabIcon then Tween(TabMain.UIElements.TabIcon.ImageLabel, 0.1, {ImageTransparency = 0}):Play() end
                                table.insert(Dropdown.Value, TabMain.Original)
                            else
                                if not Dropdown.AllowNone and #Dropdown.Value == 1 then return end
                                TabMain.Selected = false
                                Tween(TabMain.UIElements.TabItem, 0.1, {ImageTransparency = 1}):Play()
                                Tween(TabMain.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = 1}):Play()
                                Tween(TabMain.UIElements.TabItem.Frame.Title.TextLabel, 0.1, {TextTransparency = .4}):Play()
                                if TabMain.UIElements.TabIcon then Tween(TabMain.UIElements.TabIcon.ImageLabel, 0.1, {ImageTransparency = .2}):Play() end
                                for i, v in next, Dropdown.Value do
                                    if typeof(v) == "table" and (v.Title == TabMain.Name) or (v == TabMain.Name) then
                                        table.remove(Dropdown.Value, i)
                                        break
                                    end
                                end
                            end
                        else
                            for Index, TabPisun in next, Dropdown.Tabs do
                                Tween(TabPisun.UIElements.TabItem, 0.1, {ImageTransparency = 1}):Play()
                                Tween(TabPisun.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = 1}):Play()
                                Tween(TabPisun.UIElements.TabItem.Frame.Title.TextLabel, 0.1, {TextTransparency = .4}):Play()
                                if TabPisun.UIElements.TabIcon then Tween(TabPisun.UIElements.TabIcon.ImageLabel, 0.1, {ImageTransparency = .2}):Play() end
                                TabPisun.Selected = false
                            end
                            TabMain.Selected = true
                            Tween(TabMain.UIElements.TabItem, 0.1, {ImageTransparency = .95}):Play()
                            Tween(TabMain.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = .75}):Play()
                            Tween(TabMain.UIElements.TabItem.Frame.Title.TextLabel, 0.1, {TextTransparency = 0}):Play()
                            if TabMain.UIElements.TabIcon then Tween(TabMain.UIElements.TabIcon.ImageLabel, 0.1, {ImageTransparency = 0}):Play() end
                            Dropdown.Value = TabMain.Original
                        end
                        Callback()
                    end)
                elseif Type == "Menu" then
                    if not TabMain.Locked then
                        Creator.AddSignal(TabMain.UIElements.TabItem.MouseEnter, function() Tween(TabMain.UIElements.TabItem, 0.08, {ImageTransparency = .95}):Play() end)
                        Creator.AddSignal(TabMain.UIElements.TabItem.InputEnded, function() Tween(TabMain.UIElements.TabItem, 0.08, {ImageTransparency = 1}):Play() end)
                    end
                    Creator.AddSignal(TabMain.UIElements.TabItem.MouseButton1Click, function()
                        if TabMain.Locked then return end 
                        Callback(Tab.Callback or function() end)
                    end)
                end
                RecalculateCanvasSize()
                RecalculateListSize()
            else
                require("../../elements/Divider"):New({ Parent = Dropdown.UIElements.Menu.Frame.ScrollingFrame })
            end
        end
        local maxWidth = Dropdown.MenuWidth or 0
        if maxWidth == 0 then
            for _, tabmain in next, Dropdown.Tabs do
                if tabmain.UIElements.TabItem.Frame.UIListLayout then maxWidth = math.max(maxWidth, tabmain.UIElements.TabItem.Frame.UIListLayout.AbsoluteContentSize.X) end
            end
        end
        Dropdown.UIElements.MenuCanvas.Size = UDim2.new(0, maxWidth + 6 + 6 + 5 + 5 + 18 + 6 + 6, Dropdown.UIElements.MenuCanvas.Size.Y.Scale, Dropdown.UIElements.MenuCanvas.Size.Y.Offset)
        Callback()
        Dropdown.Values = Values
    end
      
    DropdownModule:Refresh(Dropdown.Values)
    
    function DropdownModule:Select(Items)
        if Items then Dropdown.Value = Items else
            if Dropdown.Multi then Dropdown.Value = {} else Dropdown.Value = nil end
        end
        DropdownModule:Refresh(Dropdown.Values)
    end

    
    
    -- [PERBAIKAN] Edit Item Tanpa Refresh (Support All Properties)
    function DropdownModule:Edit(TargetName, NewData)
        for Index, TabData in ipairs(Dropdown.Tabs) do
            -- Cek kesesuaian Nama Item
            if TabData.Name == TargetName then
                
                -- 1. Update Internal Data Source (Agar data tersimpan di memori)
                local SourceVal = Dropdown.Values[Index]
                if SourceVal and type(SourceVal) == "table" then
                     if NewData.Title then SourceVal.Title = NewData.Title end
                     if NewData.Desc then SourceVal.Desc = NewData.Desc end
                     if NewData.Icon then SourceVal.Icon = NewData.Icon end
                     if NewData.Images then SourceVal.Images = NewData.Images end 
                     
                     -- Update Tab Data Internal UI Library
                     if NewData.Title then TabData.Name = NewData.Title end
                     if NewData.Desc then 
                        TabData.Desc = NewData.Desc
                        TabData.Original.Desc = NewData.Desc 
                     end
                     if NewData.Images then 
                        TabData.Images = NewData.Images
                        TabData.Original.Images = NewData.Images 
                     end
                end

                -- 2. Update UI Visual
                local TabUI = TabData.UIElements
                if TabUI and TabUI.TabItem then
                    local Frame = TabUI.TabItem:FindFirstChild("Frame")
                    local TitleFrame = Frame and Frame:FindFirstChild("Title")
                    
                    if TitleFrame then
                        -- Update Judul
                        if NewData.Title then
                            local TitleLabel = TitleFrame:FindFirstChild("TextLabel") 
                            if TitleLabel then TitleLabel.Text = NewData.Title end
                        end

                        -- Update Deskripsi
                        if NewData.Desc then
                            local DescLabel = TitleFrame:FindFirstChild("Desc")
                            if DescLabel then
                                DescLabel.Text = NewData.Desc
                                DescLabel.Visible = true
                                -- Paksa tinggi otomatis agar deskripsi muat
                                TabData.UIElements.TabItem.AutomaticSize = Enum.AutomaticSize.Y
                            end
                        end

                        -- Update Images / Cards Grid
                        if NewData.Images then
                            local ImagesScroll = TitleFrame:FindFirstChild("Images")
                            if ImagesScroll then
                                ImagesScroll.Visible = true
                                -- Panggil helper RenderImages yang sudah ada di script lokal
                                RenderImages(ImagesScroll, NewData.Images)
                                
                                -- Paksa tinggi otomatis agar gambar muat
                                TabData.UIElements.TabItem.AutomaticSize = Enum.AutomaticSize.Y
                            end
                        end
                    end
                    
                    -- Update Icon Utama Item (Kiri)
                    if NewData.Icon and TabUI.TabIcon then
                        local RealImage = TabUI.TabIcon:FindFirstChild("ImageLabel")
                        if RealImage then
                            -- Support Lucide Icons / Asset ID biasa
                            local IconData = Creator.Icon(NewData.Icon)
                            if IconData then
                                RealImage.Image = IconData[1]
                                RealImage.ImageRectOffset = IconData[2].ImageRectPosition
                                RealImage.ImageRectSize = IconData[2].ImageRectSize
                            else
                                RealImage.Image = NewData.Icon
                                RealImage.ImageRectOffset = Vector2.new(0,0)
                                RealImage.ImageRectSize = Vector2.new(0,0)
                            end

                            -- Support Gradient pada Icon
                            if NewData.Gradient then
                                local grad = RealImage:FindFirstChildOfClass("UIGradient") or New("UIGradient", {Parent=RealImage})
                                grad.Color = NewData.Gradient
                            end
                        end
                    end
                end
                
                -- 3. Hitung ulang ukuran Menu agar pas dengan konten baru
                RecalculateCanvasSize()
                RecalculateListSize()
                break 
            end
        end
    end
    
    -- [MODIFIED] Edit by Index (Fixed: Image Rendering & Header Update)
    function DropdownModule:EditDrop(Target, NewData)
        local TargetIndex = nil
        local TabData = nil

        -- 1. Cari Target berdasarkan Angka (Index) atau Nama (String)
        if type(Target) == "number" then
            TargetIndex = Target
            TabData = Dropdown.Tabs[Target]
        else
            for i, tab in ipairs(Dropdown.Tabs) do
                if tab.Name == Target then
                    TargetIndex = i
                    TabData = tab
                    break
                end
            end
        end

        if TabData and TargetIndex then
            -- 2. Update Internal Data Source
            local SourceVal = Dropdown.Values[TargetIndex]
            if type(SourceVal) ~= "table" then
                SourceVal = { Title = SourceVal, Value = SourceVal }
                Dropdown.Values[TargetIndex] = SourceVal
            end

            -- Update Properties
            if NewData.Title then SourceVal.Title = NewData.Title end
            if NewData.Desc then SourceVal.Desc = NewData.Desc end
            if NewData.Icon then SourceVal.Icon = NewData.Icon end
            if NewData.Images then SourceVal.Images = NewData.Images end
            if NewData.Gradient then SourceVal.Gradient = NewData.Gradient end
            if NewData.Value then SourceVal.Value = NewData.Value end
            
            -- Update Tab Data
            if NewData.Title then TabData.Name = NewData.Title end
            if NewData.Desc then 
                TabData.Desc = NewData.Desc
                TabData.Original.Desc = NewData.Desc 
            end
            if NewData.Images then 
                TabData.Images = NewData.Images
                TabData.Original.Images = NewData.Images 
            end
            for k, v in pairs(NewData) do TabData.Original[k] = v end

            -- 3. Update Visual List Item
            local TabUI = TabData.UIElements
            if TabUI and TabUI.TabItem then
                local Frame = TabUI.TabItem:FindFirstChild("Frame")
                local TitleFrame = Frame and Frame:FindFirstChild("Title")

                if TitleFrame then
                    if NewData.Title then
                        local TitleLabel = TitleFrame:FindFirstChild("TextLabel")
                        if TitleLabel then TitleLabel.Text = NewData.Title end
                    end
                    if NewData.Desc then
                        local DescLabel = TitleFrame:FindFirstChild("Desc")
                        if DescLabel then 
                            DescLabel.Text = NewData.Desc 
                            DescLabel.Visible = true
                            TabUI.TabItem.AutomaticSize = Enum.AutomaticSize.Y
                        end
                    end
                    -- [CRITICAL] Re-render Images with forced Visible
                    if NewData.Images then
                        local ImagesScroll = TitleFrame:FindFirstChild("Images")
                        if ImagesScroll then
                            ImagesScroll.Visible = (NewData.Images and #NewData.Images > 0)
                            RenderImages(ImagesScroll, NewData.Images)
                            TabUI.TabItem.AutomaticSize = Enum.AutomaticSize.Y
                        end
                    end
                end
                
                if NewData.Icon and TabUI.TabIcon then
                    local RealImage = TabUI.TabIcon:FindFirstChild("ImageLabel")
                    if RealImage then
                         local IconData = Creator.Icon(NewData.Icon)
                         if IconData then
                             RealImage.Image = IconData[1]
                             RealImage.ImageRectOffset = IconData[2].ImageRectPosition
                             RealImage.ImageRectSize = IconData[2].ImageRectSize
                         else
                             RealImage.Image = NewData.Icon
                             RealImage.ImageRectOffset = Vector2.new(0,0)
                             RealImage.ImageRectSize = Vector2.new(0,0)
                         end
                         
                         if NewData.Gradient then
                             local grad = RealImage:FindFirstChildOfClass("UIGradient") or New("UIGradient", {Parent=RealImage})
                             grad.Color = NewData.Gradient
                         end
                    end
                end
            end

            -- 4. Update Header Utama (Visual Luar) jika item ini terpilih
            local currentSelected = Dropdown.Value
            local isSelected = false
            if not Dropdown.Multi and currentSelected == SourceVal then isSelected = true end
            
            if isSelected then
                if Dropdown.UIElements.Dropdown and NewData.Title then
                     local outerFrame = Dropdown.UIElements.Dropdown:FindFirstChild("Frame")
                     local innerFrame = outerFrame and outerFrame:FindFirstChild("Frame")
                     local label = innerFrame and innerFrame:FindFirstChild("TextLabel")
                     if label then label.Text = NewData.Title end
                end
                
                Dropdown.Value = SourceVal

                if NewData.Desc then DropdownModule:SetDesc(NewData.Desc) end
                
                if NewData.Icon then
                    DropdownModule:SetValueImage(NewData.Icon)
                    if NewData.Gradient then
                        DropdownModule:SetMainImage({Image = NewData.Icon, Quantity = "", Gradient = NewData.Gradient}, 50)
                    else
                        DropdownModule:SetMainImage(NewData.Icon)
                    end
                end
            end

            RecalculateCanvasSize()
            RecalculateListSize()
        end
    end

    RecalculateListSize()
    RecalculateCanvasSize()
    
    function DropdownModule:Open()
        if CanCallback then
            Dropdown.UIElements.Menu.Visible = true
            Dropdown.UIElements.MenuCanvas.Visible = true
            Dropdown.UIElements.MenuCanvas.Active = true
            Dropdown.UIElements.Menu.Size = UDim2.new(1, 0, 0, 0)
            Tween(Dropdown.UIElements.Menu, 0.1, { Size = UDim2.new(1, 0, 1, 0), ImageTransparency = 0.05 }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
            task.spawn(function() task.wait(.1) Dropdown.Opened = true end)
            UpdatePosition()
        end
    end
    
    function DropdownModule:Close()
        Dropdown.Opened = false
        Tween(Dropdown.UIElements.Menu, 0.25, { Size = UDim2.new(1, 0, 0, 0), ImageTransparency = 1 }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
        task.spawn(function() task.wait(.1) Dropdown.UIElements.Menu.Visible = false end)
        task.spawn(function() task.wait(.25) Dropdown.UIElements.MenuCanvas.Visible = false Dropdown.UIElements.MenuCanvas.Active = false end)
    end
    
    Creator.AddSignal((Dropdown.UIElements.Dropdown and Dropdown.UIElements.Dropdown.MouseButton1Click or Dropdown.DropdownFrame.UIElements.Main.MouseButton1Click), function()
        DropdownModule:Open()
    end)
    
    Creator.AddSignal(UserInputService.InputBegan, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            local menuCanvas = Dropdown.UIElements.MenuCanvas
            local AbsPos, AbsSize = menuCanvas.AbsolutePosition, menuCanvas.AbsoluteSize
            local DropdownButton = Dropdown.UIElements.Dropdown or Dropdown.DropdownFrame.UIElements.Main
            local ButtonAbsPos = DropdownButton.AbsolutePosition
            local ButtonAbsSize = DropdownButton.AbsoluteSize
            
            local isClickOnDropdown = Mouse.X >= ButtonAbsPos.X and Mouse.X <= ButtonAbsPos.X + ButtonAbsSize.X and Mouse.Y >= ButtonAbsPos.Y and Mouse.Y <= ButtonAbsPos.Y + ButtonAbsSize.Y
            local isClickOnMenu = Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y
            
            if Config.Window.CanDropdown and Dropdown.Opened and not isClickOnDropdown and not isClickOnMenu then
                DropdownModule:Close()
            end
        end
    end)
    
    Creator.AddSignal(
        Dropdown.UIElements.Dropdown and Dropdown.UIElements.Dropdown:GetPropertyChangedSignal("AbsolutePosition") or Dropdown.DropdownFrame.UIElements.Main:GetPropertyChangedSignal("AbsolutePosition"), 
        UpdatePosition
    )
    
    return DropdownModule
end

return DropdownMenu
