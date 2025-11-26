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
        
        Profile = Config.Profile,
        SidebarProfile = Config.SidebarProfile, 
        
        Selected = false,
        Index = nil,
        Parent = Config.Parent,
        UIElements = {},
        Elements = {},
        ContainerFrame = nil,
        UICorner = Window.UICorner-(Window.UIPadding/2),
        
        Gap = Window.NewElements and 1 or 6,
    }

    local IsSidebarCard = Tab.Profile and Tab.SidebarProfile
    local HasContentProfile = Tab.Profile
    
    -- [STICKY LOGIC] Default true jika tidak didefinisikan
    local IsProfileSticky = HasContentProfile and (Tab.Profile.Sticky ~= false)
    
    if IsSidebarCard then
        Tab.Locked = true
    end
    
    TabModule.TabCount = TabModule.TabCount + 1
    
    local TabIndex = TabModule.TabCount
    Tab.Index = TabIndex
    
    -- 1. MEMBUAT TOMBOL SIDEBAR UTAMA
    Tab.UIElements.Main = Creator.NewRoundFrame(Tab.UICorner, "Squircle", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-7,0,0),
        AutomaticSize = "Y", 
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
            ClipsDescendants = true, 
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
    if Tab.Icon and not IsSidebarCard then 
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
    
    -- [LOGIKA IMAGE BESAR]
    if Tab.Image and not IsSidebarCard then
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

    -- [SIDEBAR PROFILE CARD]
    if IsSidebarCard then
        local Layout = Tab.UIElements.Main.Frame:FindFirstChild("UIListLayout")
        if Layout then Layout:Destroy() end
        local Padding = Tab.UIElements.Main.Frame:FindFirstChild("UIPadding")
        if Padding then Padding:Destroy() end
        local DefLabel = Tab.UIElements.Main.Frame:FindFirstChild("TextLabel")
        if DefLabel then DefLabel:Destroy() end
        
        Tab.UIElements.Main.Frame.AutomaticSize = Enum.AutomaticSize.None
        Tab.UIElements.Main.Frame.Size = UDim2.new(1, 0, 0, 120)
        
        local BannerH = 55
        if Tab.Profile.Banner then
            local BannerFrame = Creator.Image(
                Tab.Profile.Banner, "SidebarBanner", 0, Window.Folder, "ProfileBanner", false
            )
            BannerFrame.Size = UDim2.new(1, 0, 0, BannerH)
            BannerFrame.Position = UDim2.new(0, 0, 0, 0)
            BannerFrame.BackgroundTransparency = 1
            BannerFrame.Parent = Tab.UIElements.Main.Frame
            BannerFrame.ZIndex = 1
            
            if BannerFrame:FindFirstChild("ImageLabel") then
                BannerFrame.ImageLabel.ScaleType = Enum.ScaleType.Crop
                BannerFrame.ImageLabel.Size = UDim2.fromScale(1, 1)
            end
        end
        
        -- [SIDEBAR BADGES]
        if Tab.Profile.Badges then
             local SidebarBadgeContainer = New("Frame", {
                Name = "SidebarBadgeContainer",
                Size = UDim2.new(0, 0, 0, 24), 
                AutomaticSize = Enum.AutomaticSize.X,
                Position = UDim2.new(1, -6, 0, BannerH - 4), 
                AnchorPoint = Vector2.new(1, 1),
                BackgroundTransparency = 1,
                Parent = Tab.UIElements.Main.Frame, 
                ZIndex = 5
            }, {
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 4)
                })
            })
            
            for _, badge in ipairs(Tab.Profile.Badges) do
                local BadgeIcon = badge.Icon or "help-circle"
                local HasTitle = badge.Title ~= nil 
                
                local BadgeWrapper = New("Frame", {
                    Name = "BadgeWrapper",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 24),
                    AutomaticSize = Enum.AutomaticSize.X,
                    Parent = SidebarBadgeContainer,
                })

                local BadgeBG = Creator.NewRoundFrame(6, "Squircle", {
                    ImageColor3 = Color3.new(0,0,0),
                    ImageTransparency = 0.4,
                    Size = UDim2.new(1, 0, 1, 0),
                    Name = "BG",
                    Parent = BadgeWrapper
                })
                
                local Content = New("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = BadgeWrapper
                }, {
                    New("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        Padding = UDim.new(0, 4)
                    }),
                    New("UIPadding", {
                        PaddingLeft = UDim.new(0, HasTitle and 6 or 4),
                        PaddingRight = UDim.new(0, HasTitle and 6 or 4),
                    })
                })

                local IconFrame = Creator.Image(BadgeIcon, "BadgeIcon", 0, Window.Folder, "Badge", false)
                IconFrame.Size = UDim2.new(0, 14, 0, 14)
                IconFrame.BackgroundTransparency = 1
                IconFrame.Parent = Content
                
                local RealImage = IconFrame:FindFirstChild("ImageLabel") or IconFrame:FindFirstChild("VideoFrame")
                if RealImage then
                    RealImage.Size = UDim2.fromScale(1, 1)
                    RealImage.ImageColor3 = Color3.new(1, 1, 1)
                    RealImage.BackgroundTransparency = 1
                end
                
                if HasTitle then
                    New("TextLabel", {
                        Text = badge.Title,
                        TextSize = 11,
                        FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                        TextColor3 = Color3.new(1,1,1),
                        BackgroundTransparency = 1,
                        AutomaticSize = Enum.AutomaticSize.XY,
                        LayoutOrder = 2,
                        Parent = Content
                    })
                end
                
                local ClickArea = New("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 10,
                    Parent = BadgeWrapper
                })

                if badge.Callback then
                    Creator.AddSignal(ClickArea.MouseButton1Click, function()
                        badge.Callback()
                    end)
                end
                
                Creator.AddSignal(ClickArea.MouseEnter, function()
                     Tween(BadgeBG, 0.1, {ImageTransparency = 0.2}):Play()
                end)
                Creator.AddSignal(ClickArea.MouseLeave, function()
                     Tween(BadgeBG, 0.1, {ImageTransparency = 0.4}):Play()
                end)
                
                if badge.Desc then
                    local ToolTip
                    local hoverTimer
                    local MouseConn
                    local IsHoveringBadge = false
                    
                    Creator.AddSignal(ClickArea.MouseEnter, function()
                        IsHoveringBadge = true
                        hoverTimer = task.spawn(function()
                            task.wait(0.35) 
                            if IsHoveringBadge and not ToolTip then
                                ToolTip = CreateToolTip(badge.Desc, TabModule.ToolTipParent)
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
                    
                    Creator.AddSignal(ClickArea.MouseLeave, function()
                        IsHoveringBadge = false
                        if hoverTimer then task.cancel(hoverTimer) hoverTimer = nil end
                        if MouseConn then MouseConn:Disconnect() MouseConn = nil end
                        if ToolTip then ToolTip:Close() ToolTip = nil end
                    end)
                end
            end
        end
        
        local AvatarS = 46
        local AvatarContainer = New("Frame", {
            Name = "Avatar",
            Size = UDim2.new(0, AvatarS, 0, AvatarS),
            Position = UDim2.new(0, 10, 0, BannerH - (AvatarS/2)),
            BackgroundTransparency = 1,
            Parent = Tab.UIElements.Main.Frame,
            ZIndex = 2
        })
        
        if Tab.Profile.Avatar then
             local AvatarImg = Creator.Image(
                Tab.Profile.Avatar, "SidebarAvatar", 0, Window.Folder, "ProfileAvatar", false
            )
            AvatarImg.Size = UDim2.fromScale(1, 1)
            AvatarImg.Parent = AvatarContainer
            AvatarImg.BackgroundTransparency = 1
            
            local ImgLabel = AvatarImg:FindFirstChild("ImageLabel")
            if ImgLabel then
                ImgLabel.Size = UDim2.fromScale(1, 1)
                ImgLabel.BackgroundTransparency = 1
                local OldCorner = ImgLabel:FindFirstChildOfClass("UICorner")
                if OldCorner then OldCorner:Destroy() end
                New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ImgLabel })
            end
            
            New("UIStroke", { 
                Parent = AvatarContainer,
                Thickness = 2.5,
                ThemeTag = { Color = "TabBackground" },
                Transparency = 0,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })
            New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = AvatarContainer })
        end

        if Tab.Profile.Status then
             New("Frame", {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(1, 0, 1, 0),
                AnchorPoint = Vector2.new(1, 1),
                BackgroundColor3 = Color3.fromHex("#23a559"),
                Parent = AvatarContainer,
                ZIndex = 3
            }, {
                New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                New("UIStroke", { 
                    Thickness = 2, 
                    ThemeTag = { Color = "TabBackground" } 
                })
            })
        end

        local TextC = New("Frame", {
            Size = UDim2.new(1, -(10 + AvatarS + 8), 1, -BannerH - 6),
            Position = UDim2.new(0, 10 + AvatarS + 8, 0, BannerH + 5), 
            BackgroundTransparency = 1,
            Parent = Tab.UIElements.Main.Frame,
            ZIndex = 2
        }, {
            New("UIListLayout", {
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Padding = UDim.new(0, 2)
            }),
            New("TextLabel", {
                Text = Tab.Profile.Title or Tab.Title,
                TextSize = 16,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                ThemeTag = { TextColor3 = "TabTitle" },
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextTransparency = not Tab.Locked and 0 or .7,
            }),
            New("TextLabel", {
                Text = Tab.Profile.Desc or "User",
                TextSize = 13,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
                ThemeTag = { TextColor3 = "Text" },
                TextTransparency = 0.5,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd
            })
        })
    end
    
    -- 2. PERHITUNGAN OFFSET KONTEN
    local ContentOffsetY = 0
    local ContentSizeOffset = 0
    
    local ProfileHeight = 150 
    
    if Tab.ShowTabTitle then
        ContentOffsetY = ((Window.UIPadding*2.4)+12)
        ContentSizeOffset = ContentSizeOffset - ContentOffsetY
    end

    -- [OFFSET HANYA JIKA STICKY]
    if HasContentProfile and IsProfileSticky then
        ContentOffsetY = ContentOffsetY + ProfileHeight
        ContentSizeOffset = ContentSizeOffset - ProfileHeight
    end
    
    -- 3. CONTAINER KONTEN TAB
    Tab.UIElements.ContainerFrame = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, ContentSizeOffset), 
        Position = UDim2.new(0, 0, 0, ContentOffsetY), 
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ElasticBehavior = "Never",
        CanvasSize = UDim2.new(0,0,0,0),
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

    -- 4. WRAPPER UNTUK KONTEN
    Tab.UIElements.ContainerFrameCanvas = New("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = Window.UIElements.MainBar,
        ZIndex = 5,
    }, {
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

    -- [HEADER PROFIL DALAM KONTEN]
    if HasContentProfile then
        local BannerHeight = 100  
        local AvatarSize = 70     
        
        local ProfileHeader = New("Frame", {
            Name = "ProfileHeader",
            Size = UDim2.new(1, 0, 0, ProfileHeight),
            -- Posisi awal (akan diabaikan UIListLayout jika tidak sticky)
            Position = UDim2.new(0, 0, 0, Tab.ShowTabTitle and ((Window.UIPadding*2.4)+12) or 0),
            BackgroundTransparency = 1,
            ZIndex = 2
        })

        -- [LOGIKA STICKY PARENTING]
        if IsProfileSticky and not IsSidebarCard then
            ProfileHeader.Parent = Tab.UIElements.ContainerFrameCanvas -- Statis
        else
            ProfileHeader.Parent = Tab.UIElements.ContainerFrame -- Ikut Scroll
            ProfileHeader.LayoutOrder = -999 -- Paling atas di list
        end

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
            
            -- [PERBAIKAN] Auto Fit / Crop Logic
            local RealImage = BannerImg:FindFirstChild("ImageLabel")
            if RealImage then
                RealImage.Size = UDim2.fromScale(1, 1) -- Memaksa gambar memenuhi frame pembungkus
                RealImage.BackgroundTransparency = 1
                RealImage.ScaleType = Enum.ScaleType.Crop -- Memotong gambar agar pas (Zoom to Fill)
                -- Jika ingin gambar terlihat utuh (mungkin ada gap kosong), ubah ke Enum.ScaleType.Fit
            end
        end
        
        -- [BADGES KONTEN]
        if Tab.Profile.Badges then
            local BadgeContainer = New("Frame", {
                Name = "BadgeContainer",
                Size = UDim2.new(0, 0, 0, 28),
                AutomaticSize = Enum.AutomaticSize.X,
                Position = UDim2.new(1, -8, 1, -8), 
                AnchorPoint = Vector2.new(1, 1),
                BackgroundTransparency = 1,
                Parent = Banner, 
                ZIndex = 5
            }, {
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 6)
                })
            })
            
            for _, badge in ipairs(Tab.Profile.Badges) do
                local BadgeIcon = badge.Icon or "help-circle"
                local HasTitle = badge.Title ~= nil 
                
                local BadgeWrapper = New("Frame", {
                    Name = "BadgeWrapper",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 28),
                    AutomaticSize = Enum.AutomaticSize.X,
                    Parent = BadgeContainer,
                })

                local BadgeBG = Creator.NewRoundFrame(6, "Squircle", {
                    ImageColor3 = Color3.new(0,0,0),
                    ImageTransparency = 0.4,
                    Size = UDim2.new(1, 0, 1, 0),
                    Name = "BG",
                    Parent = BadgeWrapper
                })
                
                local Content = New("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = BadgeWrapper
                }, {
                    New("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        Padding = UDim.new(0, 4)
                    }),
                    New("UIPadding", {
                        PaddingLeft = UDim.new(0, HasTitle and 8 or 5), 
                        PaddingRight = UDim.new(0, HasTitle and 8 or 5),
                    })
                })

                local IconFrame = Creator.Image(BadgeIcon, "BadgeIcon", 0, Window.Folder, "Badge", false)
                IconFrame.Size = UDim2.new(0, 16, 0, 16)
                IconFrame.BackgroundTransparency = 1
                IconFrame.Parent = Content
                
                local RealImage = IconFrame:FindFirstChild("ImageLabel") or IconFrame:FindFirstChild("VideoFrame")
                if RealImage then
                    RealImage.Size = UDim2.fromScale(1, 1)
                    RealImage.ImageColor3 = Color3.new(1, 1, 1)
                    RealImage.BackgroundTransparency = 1
                end
                
                if HasTitle then
                    New("TextLabel", {
                        Text = badge.Title,
                        TextSize = 12,
                        FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                        TextColor3 = Color3.new(1,1,1),
                        BackgroundTransparency = 1,
                        AutomaticSize = Enum.AutomaticSize.XY,
                        LayoutOrder = 2,
                        Parent = Content
                    })
                end
                
                local ClickArea = New("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 10,
                    Parent = BadgeWrapper
                })

                if badge.Callback then
                    Creator.AddSignal(ClickArea.MouseButton1Click, function()
                        badge.Callback()
                    end)
                end
                
                Creator.AddSignal(ClickArea.MouseEnter, function()
                     Tween(BadgeBG, 0.1, {ImageTransparency = 0.2}):Play()
                end)
                Creator.AddSignal(ClickArea.MouseLeave, function()
                     Tween(BadgeBG, 0.1, {ImageTransparency = 0.4}):Play()
                end)
                
                if badge.Desc then
                    local ToolTip
                    local hoverTimer
                    local MouseConn
                    local IsHoveringBadge = false
                    
                    Creator.AddSignal(ClickArea.MouseEnter, function()
                        IsHoveringBadge = true
                        hoverTimer = task.spawn(function()
                            task.wait(0.35) 
                            if IsHoveringBadge and not ToolTip then
                                ToolTip = CreateToolTip(badge.Desc, TabModule.ToolTipParent)
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
                    
                    Creator.AddSignal(ClickArea.MouseLeave, function()
                        IsHoveringBadge = false
                        if hoverTimer then task.cancel(hoverTimer) hoverTimer = nil end
                        if MouseConn then MouseConn:Disconnect() MouseConn = nil end
                        if ToolTip then ToolTip:Close() ToolTip = nil end
                    end)
                end
            end
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

        local TextContainer = New("Frame", {
            Name = "TextContainer",
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.new(1, -(14 + AvatarSize + 14), 0, 0),
            Position = UDim2.new(0, 14 + AvatarSize + 14, 0, BannerHeight + 2), 
            Parent = ProfileHeader
        }, {
            New("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2), 
                FillDirection = Enum.FillDirection.Vertical,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                HorizontalAlignment = Enum.HorizontalAlignment.Left
            })
        })

        local TitleLabel = New("TextLabel", {
            Text = Tab.Profile.Title or Tab.Title,
            TextSize = 22,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
            ThemeTag = { TextColor3 = "Text" },
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TextContainer,
            LayoutOrder = 1
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
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TextContainer,
                LayoutOrder = 2
            })
        end
    end

    Tab.UIElements.ContainerFrame.Parent = Tab.UIElements.ContainerFrameCanvas
    
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
    
    if Tab.Desc and not IsSidebarCard then
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
        if Tab.Desc and not IsSidebarCard then
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