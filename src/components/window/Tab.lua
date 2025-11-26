local cloneref = (cloneref or clonereference or function(instance) return instance end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local Mouse = game.Players.LocalPlayer:GetMouse()

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateToolTip = require("../ui/Tooltip").New
local CreateScrollSlider = require("../ui/ScrollSlider").New

local Window, ANUI, UIScale

local TabModule = {
    Tabs = {}, 
    Containers = {},
    SelectedTab = nil,
    TabCount = 0,
    ToolTipParent = nil,
    TabHighlight = nil,
    
    OnChangeFunc = function(v) end
}

function TabModule.Init(WindowTable, WindUITable, ToolTipParent, TabHighlight)
    Window = WindowTable
    ANUI = WindUITable
    TabModule.ToolTipParent = ToolTipParent
    TabModule.TabHighlight = TabHighlight
    return TabModule
end

function TabModule.New(Config, UIScale)
    local Tab = {
        __type = "Tab",
        Title = Config.Title or "Tab",
        Desc = Config.Desc,
        Icon = Config.Icon,
        Image = Config.Image,
        IconThemed = Config.IconThemed,
        Locked = Config.Locked,
        ShowTabTitle = Config.ShowTabTitle,
        
        -- [ANUI] Property Profile
        Profile = Config.Profile,
        
        Selected = false,
        Index = nil,
        Parent = Config.Parent,
        UIElements = {},
        Elements = {},
        ContainerFrame = nil,
        UICorner = Window.UICorner-(Window.UIPadding/2),
        
        Gap = Window.NewElements and 1 or 6,
    }
    
    TabModule.TabCount = TabModule.TabCount + 1
    
    local TabIndex = TabModule.TabCount
    Tab.Index = TabIndex
    
    -- 1. MEMBUAT TOMBOL SIDEBAR UTAMA
    Tab.UIElements.Main = Creator.NewRoundFrame(Tab.UICorner, "Squircle", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-7,0,0),
        AutomaticSize = "Y", -- Default Auto Size
        Parent = Config.Parent,
        ThemeTag = {
            ImageColor3 = "TabBackground",
        },
        ImageTransparency = 1,
    }, {
        Creator.NewRoundFrame(Tab.UICorner, "SquircleOutline", {
            Size = UDim2.new(1,0,1,0),
            ThemeTag = {
                ImageColor3 = "Text",
            },
            ImageTransparency = 1, 
            Name = "Outline"
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
        Creator.NewRoundFrame(Tab.UICorner, "Squircle", {
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            ThemeTag = {
                ImageColor3 = "Text",
            },
            ImageTransparency = 1,
            Name = "Frame",
            ClipsDescendants = true, -- Penting untuk memotong banner
        }, {
            New("UIListLayout", {
                SortOrder = "LayoutOrder",
                Padding = UDim.new(0,10),
                FillDirection = "Horizontal",
                VerticalAlignment = "Center",
            }),
            New("TextLabel", {
                Text = Tab.Title,
                ThemeTag = {
                    TextColor3 = "TabTitle"
                },
                TextTransparency = not Tab.Locked and 0.4 or .7,
                TextSize = 15,
                Size = UDim2.new(1,0,0,0),
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                TextWrapped = true,
                RichText = true,
                AutomaticSize = "Y",
                LayoutOrder = 2,
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
            }),
            New("UIPadding", {
                PaddingTop = UDim.new(0,2+(Window.UIPadding/2)),
                PaddingLeft = UDim.new(0,4+(Window.UIPadding/2)),
                PaddingRight = UDim.new(0,4+(Window.UIPadding/2)),
                PaddingBottom = UDim.new(0,2+(Window.UIPadding/2)),
            })
        }),
    }, true)
    
    local TextOffset = 0
    local Icon
    local Icon2

    -- [LOGIKA ICON BIASA]
    if Tab.Icon and not Tab.Profile then -- Skip icon biasa jika Profile aktif
        Icon = Creator.Image(Tab.Icon, Tab.Icon .. ":" .. Tab.Title, 0, Window.Folder, Tab.__type, true, Tab.IconThemed, "TabIcon")
        Icon.Size = UDim2.new(0,16,0,16)
        Icon.Parent = Tab.UIElements.Main.Frame
        Icon.ImageLabel.ImageTransparency = not Tab.Locked and 0 or .7
        Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1,-30,0,0)
        TextOffset = -30
        Tab.UIElements.Icon = Icon
        
        Icon2 = Creator.Image(Tab.Icon, Tab.Icon .. ":" .. Tab.Title, 0, Window.Folder, Tab.__type, true, Tab.IconThemed)
        Icon2.Size = UDim2.new(0,16,0,16)
        Icon2.ImageLabel.ImageTransparency = not Tab.Locked and 0 or .7
        TextOffset = -30
    end
    
    -- [LOGIKA IMAGE BESAR (Existing)]
    if Tab.Image and not Tab.Profile then
        local Image = Creator.Image(Tab.Image, Tab.Title, Tab.UICorner, Window.Folder, "TabImage", false)
        Image.Size = UDim2.new(1,0,0,100)
        Image.Parent = Tab.UIElements.Main.Frame
        Image.ImageLabel.ImageTransparency = not Tab.Locked and 0 or .7
        Image.LayoutOrder = -1
        
        Tab.UIElements.Main.Frame.UIListLayout.FillDirection = "Vertical"
        Tab.UIElements.Main.Frame.UIListLayout.Padding = UDim.new(0,0)
        Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1,0,0,30)
        Tab.UIElements.Main.Frame.TextLabel.TextXAlignment = "Center"
        Tab.UIElements.Main.Frame.UIPadding.PaddingTop = UDim.new(0,0)
        Tab.UIElements.Main.Frame.UIPadding.PaddingLeft = UDim.new(0,0)
        Tab.UIElements.Main.Frame.UIPadding.PaddingRight = UDim.new(0,0)
        Tab.UIElements.Main.Frame.UIPadding.PaddingBottom = UDim.new(0,0)
        
        Tab.UIElements.Image = Image
    end

    -- [ANUI FITUR BARU] SIDEBAR PROFILE BUTTON
    if Tab.Profile then
        -- 1. Hapus elemen default
        local Layout = Tab.UIElements.Main.Frame:FindFirstChild("UIListLayout")
        if Layout then Layout:Destroy() end
        local Padding = Tab.UIElements.Main.Frame:FindFirstChild("UIPadding")
        if Padding then Padding:Destroy() end
        local DefLabel = Tab.UIElements.Main.Frame:FindFirstChild("TextLabel")
        if DefLabel then DefLabel:Destroy() end
        
        -- 2. Atur Ukuran & Style
        Tab.UIElements.Main.Frame.AutomaticSize = Enum.AutomaticSize.None
        Tab.UIElements.Main.Frame.Size = UDim2.new(1, 0, 0, 85) -- Tinggi Button Profile
        
        -- 3. Buat Banner (Di tombol Sidebar)
        local BannerH = 40
        local Banner = New("ImageLabel", {
            Name = "Banner",
            Size = UDim2.new(1, 0, 0, BannerH),
            BackgroundTransparency = 1,
            Image = Tab.Profile.Banner or "",
            ScaleType = Enum.ScaleType.Crop,
            Parent = Tab.UIElements.Main.Frame,
            ZIndex = 1
        })
        
        -- 4. Buat Avatar (Di tombol Sidebar)
        local AvatarS = 34
        local AvatarContainer = New("Frame", {
            Name = "Avatar",
            Size = UDim2.new(0, AvatarS, 0, AvatarS),
            Position = UDim2.new(0, 10, 0, BannerH - (AvatarS/2)),
            BackgroundTransparency = 1,
            Parent = Tab.UIElements.Main.Frame,
            ZIndex = 2
        })
        
        -- Gambar Avatar
        local AvatarImg = New("ImageLabel", {
            Size = UDim2.fromScale(1, 1),
            Image = Tab.Profile.Avatar or "",
            BackgroundTransparency = 1,
            Parent = AvatarContainer
        }, {
            New("UICorner", { CornerRadius = UDim.new(1, 0) }),
            New("UIStroke", { -- Border agar terpisah dari banner
                Thickness = 2.5,
                ThemeTag = { Color = "Background" }, -- Warna mengikuti background window
                Transparency = 0,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })
        })

        -- Status Dot
        if Tab.Profile.Status then
             New("Frame", {
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(1, 0, 1, 0),
                AnchorPoint = Vector2.new(1, 1),
                BackgroundColor3 = Color3.fromHex("#23a559"),
                Parent = AvatarContainer,
                ZIndex = 3
            }, {
                New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                New("UIStroke", { 
                    Thickness = 2, 
                    ThemeTag = { Color = "Background" } 
                })
            })
        end

        -- 5. Teks (Username & Desc)
        local TextC = New("Frame", {
            Size = UDim2.new(1, -(10 + AvatarS + 8), 1, -BannerH),
            Position = UDim2.new(0, 10 + AvatarS + 8, 0, BannerH),
            BackgroundTransparency = 1,
            Parent = Tab.UIElements.Main.Frame,
            ZIndex = 2
        }, {
            New("UIListLayout", {
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 0)
            }),
            New("TextLabel", {
                Text = Tab.Profile.Title or Tab.Title,
                TextSize = 14,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                ThemeTag = { TextColor3 = "TabTitle" },
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextTransparency = not Tab.Locked and 0 or .7,
            }),
            New("TextLabel", {
                Text = Tab.Profile.Desc or "User",
                TextSize = 11,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
                ThemeTag = { TextColor3 = "Text" },
                TextTransparency = 0.5,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 12),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd
            })
        })
    end
    
    
    -- 2. CONTAINER KONTEN TAB
    Tab.UIElements.ContainerFrame = New("ScrollingFrame", {
        Size = UDim2.new(1,0,1,Tab.ShowTabTitle and -((Window.UIPadding*2.4)+12) or 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ElasticBehavior = "Never",
        CanvasSize = UDim2.new(0,0,0,0),
        AnchorPoint = Vector2.new(0,1),
        Position = UDim2.new(0,0,1,0),
        AutomaticCanvasSize = "Y",
        ScrollingDirection = "Y",
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0,not Window.HidePanelBackground and 20 or 10),
            PaddingLeft = UDim.new(0,not Window.HidePanelBackground and 20 or 10),
            PaddingRight = UDim.new(0,not Window.HidePanelBackground and 20 or 10),
            PaddingBottom = UDim.new(0,not Window.HidePanelBackground and 20 or 10),
        }),
        New("UIListLayout", {
            SortOrder = "LayoutOrder",
            Padding = UDim.new(0,Tab.Gap),
            HorizontalAlignment = "Center",
        })
    })

    -- [HEADER PROFIL DALAM KONTEN] (Sama seperti sebelumnya, sudah difix)
    if Tab.Profile then
        local ProfileHeight = 170 
        local BannerHeight = 100  
        local AvatarSize = 70     

        local ProfileHeader = New("Frame", {
            Name = "ProfileHeader",
            Size = UDim2.new(1, 0, 0, ProfileHeight),
            BackgroundTransparency = 1,
            Parent = Tab.UIElements.ContainerFrame,
            LayoutOrder = -999
        })

        local Banner = Creator.NewRoundFrame(12, "Squircle", {
            Size = UDim2.new(1, 0, 0, BannerHeight), 
            Position = UDim2.new(0.5, 0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0),
            ImageColor3 = Color3.fromRGB(30, 30, 30), 
            Parent = ProfileHeader,
            ClipsDescendants = true
        })

        if Tab.Profile.Banner then
            local BannerImg = Creator.Image(Tab.Profile.Banner, "Banner", 0, Window.Folder, "ProfileBanner", false)
            BannerImg.Size = UDim2.new(1, 0, 1, 0)
            BannerImg.Parent = Banner
        end

        local AvatarContainer = New("Frame", {
            Size = UDim2.new(0, AvatarSize, 0, AvatarSize),
            Position = UDim2.new(0, 14, 0, BannerHeight - (AvatarSize / 2) + 5), 
            BackgroundTransparency = 1,
            Parent = ProfileHeader,
            ZIndex = 2
        })

        New("UIStroke", {
            Parent = AvatarContainer,
            Thickness = 4,
            ThemeTag = { Color = "WindowBackground" },
            Transparency = 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        })
        New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = AvatarContainer })

        if Tab.Profile.Avatar then
            local AvatarImg = Creator.Image(Tab.Profile.Avatar, "Avatar", 0, Window.Folder, "ProfileAvatar", false)
            AvatarImg.Size = UDim2.fromScale(1, 1)
            AvatarImg.BackgroundTransparency = 1
            AvatarImg.Parent = AvatarContainer
            
            local ImgLabel = AvatarImg:FindFirstChild("ImageLabel")
            if ImgLabel then
                ImgLabel.Size = UDim2.fromScale(1, 1)
                ImgLabel.BackgroundTransparency = 1
                local OldCorner = ImgLabel:FindFirstChildOfClass("UICorner")
                if OldCorner then OldCorner:Destroy() end
                New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ImgLabel })
            end
        end

        if Tab.Profile.Status then
            New("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(1, -3, 1, -3), 
                AnchorPoint = Vector2.new(1, 1),
                BackgroundColor3 = Color3.fromHex("#23a559"),
                Parent = AvatarContainer,
                ZIndex = 3
            }, {
                New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                New("UIStroke", { Thickness = 3, ThemeTag = { Color = "WindowBackground" } })
            })
        end

        local TitleLabel = New("TextLabel", {
            Text = Tab.Profile.Title or Tab.Title,
            TextSize = 22,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
            ThemeTag = { TextColor3 = "Text" },
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            Position = UDim2.new(0, 14 + AvatarSize + 14, 0, BannerHeight + 2), 
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = ProfileHeader
        })
        
        if Tab.Profile.Desc then
            New("TextLabel", {
                Text = Tab.Profile.Desc,
                TextSize = 13,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
                ThemeTag = { TextColor3 = "Text" },
                TextTransparency = 0.4,
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.XY,
                Position = UDim2.new(0, 0, 1, 3), 
                AnchorPoint = Vector2.new(0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TitleLabel 
            })
        end
    end
    
    Tab.UIElements.ContainerFrameCanvas = New("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = Window.UIElements.MainBar,
        ZIndex = 5,
    }, {
        Tab.UIElements.ContainerFrame,
        New("Frame", {
            Size = UDim2.new(1,0,0,((Window.UIPadding*2.4)+12)),
            BackgroundTransparency = 1,
            Visible = Tab.ShowTabTitle or false,
            Name = "TabTitle"
        }, {
            Icon2,
            New("TextLabel", {
                Text = Tab.Title,
                ThemeTag = {
                    TextColor3 = "Text"
                },
                TextSize = 20,
                TextTransparency = .1,
                Size = UDim2.new(1,-TextOffset,1,0),
                FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                TextTruncate = "AtEnd",
                RichText = true,
                LayoutOrder = 2,
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
            }),
            New("UIPadding", {
                PaddingTop = UDim.new(0,20),
                PaddingLeft = UDim.new(0,20),
                PaddingRight = UDim.new(0,20),
                PaddingBottom = UDim.new(0,20),
            }),
            New("UIListLayout", {
                SortOrder = "LayoutOrder",
                Padding = UDim.new(0,10),
                FillDirection = "Horizontal",
                VerticalAlignment = "Center",
            })
        }),
        New("Frame", {
            Size = UDim2.new(1,0,0,1),
            BackgroundTransparency = .9,
            ThemeTag = {
                BackgroundColor3 = "Text"
            },
            Position = UDim2.new(0,0,0,((Window.UIPadding*2.4)+12)),
            Visible = Tab.ShowTabTitle or false,
        })
    })
    
    TabModule.Containers[TabIndex] = Tab.UIElements.ContainerFrameCanvas
    TabModule.Tabs[TabIndex] = Tab
    
    Tab.ContainerFrame = ContainerFrameCanvas
    
    Creator.AddSignal(Tab.UIElements.Main.MouseButton1Click, function()
        if not Tab.Locked then
            TabModule:SelectTab(TabIndex)
        end
    end)
    
    if Window.ScrollBarEnabled then
        CreateScrollSlider(Tab.UIElements.ContainerFrame, Tab.UIElements.ContainerFrameCanvas, Window, 3)
    end

    local ToolTip
    local hoverTimer
    local MouseConn
    local IsHovering = false
    
    -- ToolTip (Hanya aktif jika BUKAN Profile Tab, karena Profile Tab sudah besar)
    if Tab.Desc and not Tab.Profile then
        Creator.AddSignal(Tab.UIElements.Main.InputBegan, function()
            IsHovering = true
            hoverTimer = task.spawn(function()
                task.wait(0.35)
                if IsHovering and not ToolTip then
                    ToolTip = CreateToolTip(Tab.Desc, TabModule.ToolTipParent)
                    local function updatePosition()
                        if ToolTip then
                            ToolTip.Container.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y - 20)
                        end
                    end
                    updatePosition()
                    MouseConn = Mouse.Move:Connect(updatePosition)
                    ToolTip:Open()
                end
            end)
        end)
    end
    
    Creator.AddSignal(Tab.UIElements.Main.MouseEnter, function()
        if not Tab.Locked then
            Tween(Tab.UIElements.Main.Frame, 0.08, {ImageTransparency = .97}):Play()
        end
    end)
    Creator.AddSignal(Tab.UIElements.Main.InputEnded, function()
        if Tab.Desc and not Tab.Profile then
            IsHovering = false
            if hoverTimer then task.cancel(hoverTimer) hoverTimer = nil end
            if MouseConn then MouseConn:Disconnect() MouseConn = nil end
            if ToolTip then ToolTip:Close() ToolTip = nil end
        end
        
        if not Tab.Locked then
            Tween(Tab.UIElements.Main.Frame, 0.08, {ImageTransparency = 1}):Play()
        end
    end)
    
    
    
    function Tab:ScrollToTheElement(elemindex)
        Tab.UIElements.ContainerFrame.ScrollingEnabled = false
        Tween(Tab.UIElements.ContainerFrame, .45, 
            { 
                CanvasPosition = Vector2.new(
                    0, -- X
                    
                    Tab.Elements[elemindex].ElementFrame.AbsolutePosition.Y 
                    - Tab.UIElements.ContainerFrame.AbsolutePosition.Y  
                    - Tab.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset -- Y
                ) 
            }, 
            Enum.EasingStyle.Quint, Enum.EasingDirection.Out
        ):Play()
        
        task.spawn(function()
            task.wait(.48)
            
            if Tab.Elements[elemindex].Highlight then
                Tab.Elements[elemindex]:Highlight()
                Tab.UIElements.ContainerFrame.ScrollingEnabled = true
            end
        end)
        
        return Tab
    end
    
    local ElementsModule = require("../../elements/Init")
    ElementsModule.Load(Tab, Tab.UIElements.ContainerFrame, ElementsModule.Elements, Window, ANUI, nil, ElementsModule, UIScale)
    
    function Tab:LockAll()
        for _, element in next, Window.AllElements do
            if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Lock then 
                element:Lock()
            end
        end
    end
    function Tab:UnlockAll()
        for _, element in next, Window.AllElements do
            if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Unlock then
                element:Unlock()
            end
        end
    end
    function Tab:GetLocked()
        local LockedElements = {}
        for _, element in next, Window.AllElements do
            if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Locked == true then 
                table.insert(LockedElements, element)
            end
        end
        return LockedElements
    end
    function Tab:GetUnlocked()
        local UnlockedElements = {}
        for _, element in next, Window.AllElements do
            if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Locked == false then 
                table.insert(UnlockedElements, element)
            end
        end
        return UnlockedElements
    end
    
    function Tab:Select()
        return TabModule:SelectTab(Tab.Index)
    end
    
    task.spawn(function()
        local Empty = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
            Parent = Tab.UIElements.ContainerFrame
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,8),
                SortOrder = "LayoutOrder",
                VerticalAlignment = "Center",
                HorizontalAlignment = "Center",
                FillDirection = "Vertical",
            }), 
            New("ImageLabel", {
                Size = UDim2.new(0,48,0,48),
                Image = Creator.Icon("frown")[1],
                ImageRectOffset = Creator.Icon("frown")[2].ImageRectPosition,
                ImageRectSize = Creator.Icon("frown")[2].ImageRectSize,
                ThemeTag = {
                    ImageColor3 = "Icon"
                },
                BackgroundTransparency = 1,
                ImageTransparency = .6,
            }),
            New("TextLabel", {
                AutomaticSize = "XY",
                Text = "This tab is empty",
                ThemeTag = {
                    TextColor3 = "Text"
                },
                TextSize = 18,
                TextTransparency = .5,
                BackgroundTransparency = 1,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            })
        })
        
        local CreationConn
        CreationConn = Creator.AddSignal(Tab.UIElements.ContainerFrame.ChildAdded, function()
            Empty.Visible = false
            CreationConn:Disconnect()
        end)
    end)
    
    return Tab
end

function TabModule:OnChange(func)
    TabModule.OnChangeFunc = func
end

function TabModule:SelectTab(TabIndex)
    if not TabModule.Tabs[TabIndex].Locked then
        TabModule.SelectedTab = TabIndex
        
        for _, TabObject in next, TabModule.Tabs do
            if not TabObject.Locked then
                Tween(TabObject.UIElements.Main, 0.15, {ImageTransparency = 1}):Play()
                Tween(TabObject.UIElements.Main.Outline, 0.15, {ImageTransparency = 1}):Play()
                
                -- [FIX] Jika Profile Tab, kita tidak punya TextLabel biasa, jadi cek dulu
                if TabObject.UIElements.Main.Frame:FindFirstChild("TextLabel") then
                     Tween(TabObject.UIElements.Main.Frame.TextLabel, 0.15, {TextTransparency = 0.3}):Play()
                end
                
                if TabObject.UIElements.Icon then
                    Tween(TabObject.UIElements.Icon.ImageLabel, 0.15, {ImageTransparency = 0.4}):Play()
                end
                TabObject.Selected = false
            end
        end
        Tween(TabModule.Tabs[TabIndex].UIElements.Main, 0.15, {ImageTransparency = 0.95}):Play()
        Tween(TabModule.Tabs[TabIndex].UIElements.Main.Outline, 0.15, {ImageTransparency = 0.85}):Play()
        
        if TabModule.Tabs[TabIndex].UIElements.Main.Frame:FindFirstChild("TextLabel") then
             Tween(TabModule.Tabs[TabIndex].UIElements.Main.Frame.TextLabel, 0.15, {TextTransparency = 0}):Play()
        end

        if TabModule.Tabs[TabIndex].UIElements.Icon then
            Tween(TabModule.Tabs[TabIndex].UIElements.Icon.ImageLabel, 0.15, {ImageTransparency = 0.1}):Play()
        end
        TabModule.Tabs[TabIndex].Selected = true
        
        task.spawn(function()
            for _, ContainerObject in next, TabModule.Containers do
                ContainerObject.AnchorPoint = Vector2.new(0,0.05)
                ContainerObject.Visible = false
            end
            TabModule.Containers[TabIndex].Visible = true
            Tween(TabModule.Containers[TabIndex], 0.15, {AnchorPoint = Vector2.new(0,0)}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
        end)
        
        TabModule.OnChangeFunc(TabIndex)
    end
end

return TabModule