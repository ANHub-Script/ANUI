local KeySystem = {}


local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateButton = require("./ui/Button").New
local CreateInput = require("./ui/Input").New

function KeySystem.new(Config, Filename, func, keyValidator)
    local KeyDialogInit = require("./window/Dialog").Init(nil, Config.ANUI.ScreenGui.KeySystem)
    local KeyDialog = KeyDialogInit.Create(true)
    
    local Services = {}
    
    local EnteredKey
    
    local ThumbnailSize = (Config.KeySystem.Thumbnail and Config.KeySystem.Thumbnail.Width) or 200
    
    local UISize = 430
    if Config.KeySystem.Thumbnail and Config.KeySystem.Thumbnail.Image then
        UISize = 430+(ThumbnailSize/2)
    end
    
    KeyDialog.UIElements.Main.AutomaticSize = "Y"
    KeyDialog.UIElements.Main.Size = UDim2.new(0,UISize,0,0)

    -- Hairline gradien di sekeliling kartu. ZIndex-nya di atas Main (99999)
    -- supaya thumbnail tidak menutupinya.
    Creator.NewRoundFrame(KeyDialog.UICorner, "SquircleOutline", {
        Size = UDim2.new(1,0,1,0),
        ThemeTag = {
            ImageColor3 = "Outline",
        },
        ImageTransparency = .85,
        ZIndex = 100000,
        Parent = KeyDialog.UIElements.MainContainer,
    }, {
        New("UIGradient", {
            Rotation = 70,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, .2),
                NumberSequenceKeypoint.new(.5, 1),
                NumberSequenceKeypoint.new(1, .35),
            })
        })
    })

    local function IconLabel(Name, Size)
        local Data = Creator.Icon(Name)
        if not Data then return nil end
        return New("ImageLabel", {
            Image = Data[1],
            ImageRectSize = Data[2].ImageRectSize,
            ImageRectOffset = Data[2].ImageRectPosition,
            Size = UDim2.new(0,Size,0,Size),
            BackgroundTransparency = 1,
            ThemeTag = {
                ImageColor3 = "Icon",
            },
        })
    end

    local function SetIconLabel(Label, Name)
        local Data = Label and Creator.Icon(Name)
        if not Data then return end
        Label.Image = Data[1]
        Label.ImageRectSize = Data[2].ImageRectSize
        Label.ImageRectOffset = Data[2].ImageRectPosition
    end

    local IconFrame = Creator.Image(
        Config.Icon or "key",
        Config.Title .. ":" .. tostring(Config.Icon or "key"),
        0,
        "Temp",
        "KeySystem",
        Config.Icon and Config.IconThemed or (not Config.Icon)
    )
    IconFrame.Size = UDim2.new(0,22,0,22)
    IconFrame.AnchorPoint = Vector2.new(0.5,0.5)
    IconFrame.Position = UDim2.new(0.5,0,0.5,0)

    -- Ikon dibungkus badge supaya header punya titik fokus.
    local IconBadge = Creator.NewRoundFrame(13, "Squircle", {
        Size = UDim2.new(0,40,0,40),
        ThemeTag = {
            ImageColor3 = "Text",
        },
        ImageTransparency = .93,
        LayoutOrder = -1,
    }, {
        IconFrame,
        Creator.NewRoundFrame(13, "SquircleOutline", {
            Size = UDim2.new(1,0,1,0),
            ThemeTag = {
                ImageColor3 = "Outline",
            },
            ImageTransparency = .9,
        })
    })

    local Title = New("TextLabel", {
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Text = Config.KeySystem.Title or Config.Title,
        TextXAlignment = "Left",
        TextTruncate = "AtEnd",
        FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
        ThemeTag = {
            TextColor3 = "Text",
        },
        TextSize = 20
    })

    local Subtitle = New("TextLabel", {
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Text = Config.KeySystem.Subtitle or "Key System",
        TextXAlignment = "Left",
        TextTruncate = "AtEnd",
        TextTransparency = .55,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        ThemeTag = {
            TextColor3 = "Text",
        },
        TextSize = 15
    })
    
    local StatusIcon = IconLabel("lock", 15)
    local StatusLabel = New("TextLabel", {
        AutomaticSize = "XY",
        BackgroundTransparency = 1,
        Text = "Locked",
        TextTransparency = .25,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        ThemeTag = {
            TextColor3 = "Text",
        },
        TextSize = 15
    })

    -- Badge status di kanan header: "Locked" jadi "Verified" saat key diterima.
    local StatusPill = Creator.NewRoundFrame(99, "Squircle", {
        Size = UDim2.new(0,0,0,0),
        AutomaticSize = "XY",
        AnchorPoint = Vector2.new(1,0.5),
        Position = UDim2.new(1,0,0.5,0),
        ThemeTag = {
            ImageColor3 = "Text",
        },
        ImageTransparency = .93,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0,7),
            FillDirection = "Horizontal",
            VerticalAlignment = "Center"
        }),
        New("UIPadding", {
            PaddingTop = UDim.new(0,7),
            PaddingLeft = UDim.new(0,11),
            PaddingRight = UDim.new(0,12),
            PaddingBottom = UDim.new(0,7),
        }),
        StatusIcon, StatusLabel,
    })
    
    local TitleStack = New("Frame", {
        Size = UDim2.new(1,-(40+14),0,0),
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0,2),
            FillDirection = "Vertical",
        }),
        Title, Subtitle
    })

    -- 110px di kanan disisakan untuk StatusPill.
    local HeaderRow = New("Frame", {
        Size = UDim2.new(1,-110,0,0),
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0,14),
            FillDirection = "Horizontal",
            VerticalAlignment = "Center"
        }),
        IconBadge, TitleStack
    })

    local TitleContainer = New("Frame", {
        AutomaticSize = "Y",
        Size = UDim2.new(1,0,0,0),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
    }, {
        HeaderRow, StatusPill,
    })

    local HeaderDivider = Creator.NewRoundFrame(99, "Squircle", {
        Size = UDim2.new(1,0,0,1),
        ThemeTag = {
            ImageColor3 = "Outline",
        },
        ImageTransparency = .9,
        LayoutOrder = 2,
    })
    
    local InputFrame = CreateInput("Enter Key", "key", nil, "Input", function(k)
        EnteredKey = k
    end, true)
    InputFrame.LayoutOrder = 4

    -- Outline merah yang berkedip saat key ditolak.
    local InputGlow = Creator.NewRoundFrame(10, "SquircleOutline", {
        Size = UDim2.new(1,0,1,0),
        ImageColor3 = Color3.fromHex(Creator.Colors.Red),
        ImageTransparency = 1,
        ZIndex = 5,
        Parent = InputFrame,
    })

    local function FlashError()
        Tween(InputGlow, .12, { ImageTransparency = .1 }):Play()
        task.delay(.55, function()
            Tween(InputGlow, .35, { ImageTransparency = 1 }):Play()
        end)
    end

    local NoteText
    if Config.KeySystem.Note and Config.KeySystem.Note ~= "" then
        NoteText = New("TextLabel", {
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            TextXAlignment = "Left",
            Text = Config.KeySystem.Note,
            TextSize = 17,
            TextTransparency = .45,
            LineHeight = 1.15,
            LayoutOrder = 3,
            ThemeTag = {
                TextColor3 = "Text",
            },
            BackgroundTransparency = 1,
            RichText = true,
            TextWrapped = true,
        })
    end

    local ButtonsContainer = New("Frame", {
        Size = UDim2.new(1,0,0,42),
        BackgroundTransparency = 1,
        LayoutOrder = 5,
    }, {
        New("Frame", {
            BackgroundTransparency = 1,
            AutomaticSize = "X",
            Size = UDim2.new(0,0,1,0),
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,18/2),
                FillDirection = "Horizontal",
            })
        })
    })
    
    
    local ThumbnailFrame
    if Config.KeySystem.Thumbnail and Config.KeySystem.Thumbnail.Image then
        local ThumbnailTitle
        if Config.KeySystem.Thumbnail.Title then
            ThumbnailTitle = New("TextLabel", {
                Text = Config.KeySystem.Thumbnail.Title,
                ThemeTag = {
                    TextColor3 = "Text",
                },
                TextSize = 18,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                BackgroundTransparency = 1,
                AutomaticSize = "XY",
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.5,0,0.5,0),
            })
        end
        ThumbnailFrame = New("ImageLabel", {
            Image = Config.KeySystem.Thumbnail.Image,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,ThumbnailSize,1,-12),
            Position = UDim2.new(0,6,0,6),
            Parent = KeyDialog.UIElements.Main,
            ScaleType = "Crop"
        }, {
            ThumbnailTitle,
            New("UICorner", {
                CornerRadius = UDim.new(0,26-6),
            })
        })
    end
    
    -- Pegangan geser di atas kartu.
    local GrabPill = Creator.NewRoundFrame(99, "Squircle", {
        Size = UDim2.new(0,42,0,4),
        AnchorPoint = Vector2.new(0.5,0),
        Position = UDim2.new(0.5,0,0,9),
        ThemeTag = {
            ImageColor3 = "Text",
        },
        ImageTransparency = .82,
        ZIndex = 3,
    })

    local MainFrame = New("Frame", {
        Size = UDim2.new(1, ThumbnailFrame and -ThumbnailSize or 0,0,0),
        AutomaticSize = "Y",
        Position = UDim2.new(0, ThumbnailFrame and ThumbnailSize or 0,0,0),
        BackgroundTransparency = 1,
        Parent = KeyDialog.UIElements.Main
    }, {
        -- Cahaya lembut di kepala kartu.
        Creator.NewRoundFrame(KeyDialog.UICorner, "Squircle-TL-TR", {
            Size = UDim2.new(1,0,0,120),
            ThemeTag = {
                ImageColor3 = "Text",
            },
            ImageTransparency = .96,
            ZIndex = 0,
        }, {
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                })
            })
        }),
        GrabPill,
        New("Frame", {
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            BackgroundTransparency = 1,
            ZIndex = 2,
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,16),
                FillDirection = "Vertical",
            }),
            TitleContainer,
            HeaderDivider,
            NoteText,
            InputFrame,
            ButtonsContainer,
            New("UIPadding", {
                PaddingTop = UDim.new(0,26),
                PaddingLeft = UDim.new(0,18),
                PaddingRight = UDim.new(0,18),
                PaddingBottom = UDim.new(0,18),
            })
        }),
    })
    
    -- for _, values in next, KeySystemButtons do
    --     CreateButton(values.Title, values.Icon, values.Callback, values.Variant)
    -- end
    
    local ExitButton = CreateButton("Exit", "log-out", function()
        KeyDialog:Close()()
    end, "Tertiary", ButtonsContainer.Frame)
    
    if ThumbnailFrame then
        ExitButton.Parent = ThumbnailFrame
        ExitButton.Size = UDim2.new(0,0,0,42)
        ExitButton.Position = UDim2.new(0,10,1,-10)
        ExitButton.AnchorPoint = Vector2.new(0,1)
    end
    
    if Config.KeySystem.URL then
        CreateButton("Get key", "key", function()
            setclipboard(Config.KeySystem.URL)
        end, "Secondary", ButtonsContainer.Frame)
    end
    
    if Config.KeySystem.API then
        -- local Icons = {
        --     platoboost = "rbxassetid://75920162824531",
        --     pandadevelopment = "panda",
        -- }
        -- local Names = {
        --     platoboost = "Platoboost",
        --     pandadevelopment = "Panda Development",
        -- }
        local Width = 240
        local Opened = false
        local ButtonFrame = CreateButton("Get key", "key", nil, "Secondary", ButtonsContainer.Frame)
        
        local Divider = Creator.NewRoundFrame(99, "Squircle", {
            Size = UDim2.new(0,1,1,0),
            ThemeTag = {
                ImageColor3 = "Text",
            },
            ImageTransparency = .9,
        })
        
        local DividerContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,1,0),
            AutomaticSize = "X",
            Parent = ButtonFrame.Frame,
        }, {
            Divider,
            New("UIPadding", {
                PaddingLeft = UDim.new(0,5),
                PaddingRight = UDim.new(0,5),
            })
        })
        
        local ChevronDown = Creator.Image(
            "chevron-down",
            "chevron-down",
            0,
            "Temp",
            "KeySystem",
            true
        )
        
        ChevronDown.Size = UDim2.new(1,0,1,0)
        
        local IconContainer = New("Frame", {
            Size = UDim2.new(0,24-3,0,24-3),
            Parent = ButtonFrame.Frame,
            BackgroundTransparency = 1,
        }, {
            ChevronDown
        })
        
        local DropdownFrame = Creator.NewRoundFrame(15, "Squircle", {
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            ThemeTag = {
                ImageColor3 = "Background",
            },
        }, {
            New("UIPadding", {
                PaddingTop = UDim.new(0,10/2),
                PaddingLeft = UDim.new(0,10/2),
                PaddingRight = UDim.new(0,10/2),
                PaddingBottom = UDim.new(0,10/2),
            }),
            New("UIListLayout", {
                FillDirection = "Vertical",
                Padding = UDim.new(0,10/2),
            })
        })
        
        local DropdownContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0,Width,0,0),
            ClipsDescendants = true,
            AnchorPoint = Vector2.new(1,0),
            Parent = ButtonFrame,
            Position = UDim2.new(1,0,1,15)
        }, {
            DropdownFrame
        })
        
        New("TextLabel", {
            Text = "Select Service",
            BackgroundTransparency = 1,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            ThemeTag = { TextColor3 = "Text" },
            TextTransparency = 0.2,
            TextSize = 16,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = "Y",
            TextWrapped = true,
            TextXAlignment = "Left",
            Parent = DropdownFrame,
        }, {
            New("UIPadding", {
                PaddingTop = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
            })
        })
        
        for _, i in next, Config.KeySystem.API do
            local serviceInstance, serviceDef = Config.ANUI.Services.Build(i, {
                Folder = Config.Folder or Config.Title,
            })

            if serviceInstance then
                table.insert(Services, serviceInstance)

                local ServiceIcon = i.Icon or serviceDef.Icon or "user"

                local IconFrame = Creator.Image(
                    ServiceIcon,
                    ServiceIcon,
                    0,
                    "Temp",
                    "KeySystem",
                    true
                )
                IconFrame.Size = UDim2.new(0, 24, 0, 24)
                
                local APIFrame = Creator.NewRoundFrame(10, "Squircle", {
                    Size = UDim2.new(1, 0, 0, 0),
                    ThemeTag = { ImageColor3 = "Text" },
                    ImageTransparency = 1,
                    Parent = DropdownFrame,
                    AutomaticSize = "Y",
                }, {
                    New("UIListLayout", {
                        FillDirection = "Horizontal",
                        Padding = UDim.new(0, 10),
                        VerticalAlignment = "Center",
                    }),
                    IconFrame,
                    New("UIPadding", {
                        PaddingTop = UDim.new(0, 10),
                        PaddingLeft = UDim.new(0, 10),
                        PaddingRight = UDim.new(0, 10),
                        PaddingBottom = UDim.new(0, 10),
                    }),
                    New("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -24 - 10, 0, 0),
                        AutomaticSize = "Y",
                    }, {
                        New("UIListLayout", {
                            FillDirection = "Vertical",
                            Padding = UDim.new(0, 5),
                            HorizontalAlignment = "Center",
                        }),
                        New("TextLabel", {
                            Text = i.Title or serviceDef.Name,
                            BackgroundTransparency = 1,
                            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                            ThemeTag = { TextColor3 = "Text" },
                            TextTransparency = 0.05,
                            TextSize = 18,
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = "Y",
                            TextWrapped = true,
                            TextXAlignment = "Left",
                        }),
                        New("TextLabel", {
                            Text = i.Desc or "",
                            BackgroundTransparency = 1,
                            FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
                            ThemeTag = { TextColor3 = "Text" },
                            TextTransparency = 0.2,
                            TextSize = 16,
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = "Y",
                            TextWrapped = true,
                            Visible = i.Desc and true or false,
                            TextXAlignment = "Left",
                        })
                    })
                }, true)
        
                Creator.AddSignal(APIFrame.MouseEnter, function()
                    Tween(APIFrame, 0.08, { ImageTransparency = .95 }):Play()
                end)
                Creator.AddSignal(APIFrame.InputEnded, function()
                    Tween(APIFrame, 0.08, { ImageTransparency = 1 }):Play()
                end)
                Creator.AddSignal(APIFrame.MouseButton1Click, function()
                    serviceInstance.Copy()
                    Config.ANUI:Notify({
                        Title = "Key System",
                        Content = "Key link copied to clipboard.",
                        Image = "key",
                    })
                end)
            end
        end
        
        Creator.AddSignal(ButtonFrame.MouseButton1Click, function()  
            if not Opened then  
                Tween(DropdownContainer, .3, { Size = UDim2.new(0, Width, 0, DropdownFrame.AbsoluteSize.Y + 1)  }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()  
                Tween(ChevronDown, .3, { Rotation = 180 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()  
            else  
                Tween(DropdownContainer, .25, { Size = UDim2.new(0, Width, 0, 0)  }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()  
                Tween(ChevronDown, .25, { Rotation = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()  
            end  
            Opened = not Opened  
        end)

    end
    
    local function SetVerified()
        local Green = Color3.fromHex(Creator.Colors.Green)
        SetIconLabel(StatusIcon, "check")
        StatusLabel.Text = "Verified"
        StatusLabel.TextColor3 = Green
        StatusLabel.TextTransparency = 0
        if StatusIcon then
            StatusIcon.ImageColor3 = Green
        end
        StatusPill.ImageColor3 = Green
        Tween(StatusPill, .2, { ImageTransparency = .85 }):Play()
    end

    -- Semua jalur "key diterima" lewat sini supaya badge sempat berubah dulu.
    local function CloseAccepted()
        SetVerified()
        task.wait(.25)
        KeyDialog:Close()()
    end

    local function handleSuccess(key)
        CloseAccepted()
        writefile((Config.Folder or "Temp") .. "/" .. Filename .. ".key", tostring(key))
        task.wait(.4)
        func(true)
    end

    local function handleFailure(reason)
        FlashError()
        Config.ANUI:Notify({
            Title = "Key System. Error",
            Content = reason or "Invalid key.",
            Icon = "triangle-alert",
        })
    end
    
    local SubmitButton = CreateButton("Submit", "arrow-right", function()
        local key = tostring(EnteredKey or "empty")
        local folder = Config.Folder or Config.Title
        
        if Config.KeySystem.KeyValidator then
            local isValid = Config.KeySystem.KeyValidator(key)

            if isValid then
                if Config.KeySystem.SaveKey then
                    handleSuccess(key)
                else
                    CloseAccepted()
                    task.wait(.4)
                    func(true)
                end
            else
                handleFailure("Invalid key.")
            end
        elseif not Config.KeySystem.API then
            local isKey = type(Config.KeySystem.Key) == "table"
                and table.find(Config.KeySystem.Key, key)
                or Config.KeySystem.Key == key

            if isKey then
                if Config.KeySystem.SaveKey then
                    handleSuccess(key)
                else
                    CloseAccepted()
                    task.wait(.4)
                    func(true)
                end
            else
                handleFailure("Invalid key.")
            end
        else
            local isSuccess, result
            for _, service in next, Services do
                local success, res = service.Verify(key)
                if success then
                    isSuccess, result = true, res
                    break
                end
                result = res
            end

            if isSuccess then
                handleSuccess(key)
            else
                handleFailure(result)
            end
        end
    end, "Primary", ButtonsContainer)
    
    SubmitButton.AnchorPoint = Vector2.new(1,0.5)
    SubmitButton.Position = UDim2.new(1,0,0.5,0)
    
    -- Kartu digeser dari header, pegangan atas, atau thumbnail.
    local DragModule = Creator.Drag(
        KeyDialog.UIElements.MainContainer,
        { TitleContainer, GrabPill, ThumbnailFrame },
        function(dragging)
            Tween(GrabPill, dragging and .1 or .25, {
                ImageTransparency = dragging and .35 or .82,
                Size = UDim2.new(0, dragging and 58 or 42, 0, 4),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
    )
    DragModule:Set(Config.KeySystem.Draggable ~= false)
    GrabPill.Visible = Config.KeySystem.Draggable ~= false

    KeyDialog:Open()
end

return KeySystem