local cloneref = (cloneref or clonereference or function(instance) return instance end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local Mouse = cloneref(game:GetService("Players")).LocalPlayer:GetMouse()
local Camera = cloneref(game:GetService("Workspace")).CurrentCamera

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateLabel = require("../components/ui/Label").New
local CreateInput = require("../components/ui/Input").New
local CreateDropdown = require("../components/ui/Dropdown").New

local CurrentCamera = workspace.CurrentCamera

local Element = {
    UICorner = 10,
    UIPadding = 12,
    MenuCorner = 15,
    MenuPadding = 5,
    TabPadding = 10,
    SearchBarHeight = 39,
    TabIcon = 18,
}

function Element:New(Config)
    local Dropdown = {
        __type = "Dropdown",
        Title = Config.Title or "Dropdown",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or false,
        Values = Config.Values or {},
        MenuWidth = Config.MenuWidth,
        Value = Config.Value,
        AllowNone = Config.AllowNone,
        SearchBarEnabled = Config.SearchBarEnabled or false,
        Multi = Config.Multi,
        Callback = Config.Callback or nil,
        
        UIElements = {},
        
        Opened = false,
        Tabs = {},
        
        Width = 150,
    }
    
    if Dropdown.Multi and not Dropdown.Value then
        Dropdown.Value = {}
    end
    
    local CanCallback = true
    
    Dropdown.DropdownFrame = require("../components/window/Element")({
        Title = Dropdown.Title,
        Desc = Dropdown.Desc,
        Image = Config.Image,
        ImageSize = Config.ImageSize,
        IconThemed = Config.IconThemed,
        Color = Config.Color,
        Parent = Config.Parent,
        TextOffset = Dropdown.Callback and Dropdown.Width or 20,
        Hover = not Dropdown.Callback and true or false,
        Tab = Config.Tab,
        Index = Config.Index,
        Window = Config.Window,
        ElementTable = Dropdown,
        ParentConfig = Config,
        ParentType = Config.ParentType,
    })
    
    
    if Dropdown.Callback then
        Dropdown.UIElements.Dropdown = CreateLabel("", nil, Dropdown.DropdownFrame.UIElements.Main, nil, Config.Window.NewElements and 12 or 10)
        
        Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate = "AtEnd"
        Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Size = UDim2.new(1, Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset - 18 - 12 - 12,0,0)
        
        Dropdown.UIElements.Dropdown.Size = UDim2.new(0,Dropdown.Width,0,36)
        Dropdown.UIElements.Dropdown.Position = UDim2.new(1,0,Config.Window.NewElements and 0 or 0.5,0)
        Dropdown.UIElements.Dropdown.AnchorPoint = Vector2.new(1,Config.Window.NewElements and 0 or 0.5)
    end
    
    -- 1. [FIXED] SetMainImage (Gambar Kiri "AN")
    -- Memastikan gambar tetap di kiri dengan LayoutOrder negatif
    -- [FIXED] SetMainImage: Mencegah Duplikasi (Update Gambar)
    function Dropdown:SetMainImage(image, size)
        -- 1. Ambil Container Utama
        local TitleFrameOuter = Dropdown.DropdownFrame.UIElements.Container:FindFirstChild("TitleFrame")
        
        if not TitleFrameOuter then return end -- Safety check

        -- 2. [LOGIKA PEMBERSIHAN] Hapus gambar lama sebelum membuat yang baru
        -- Kita cari object dengan nama "CustomMainIcon"
        local OldIcon = TitleFrameOuter:FindFirstChild("CustomMainIcon")
        if OldIcon then
            OldIcon:Destroy()
        end

        -- Pembersihan cadangan: Hapus frame lain yang bukan bagian dari struktur teks
        for _, child in ipairs(TitleFrameOuter:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "TitleFrame" and child.Name ~= "UIListLayout" and child.Name ~= "CustomMainIcon" then
                child:Destroy()
            end
        end

        -- Jika parameter image nil/kosong, kita reset layout teks dan berhenti disini
        if not image then
            local InnerTitleFrame = TitleFrameOuter:FindFirstChild("TitleFrame")
            if InnerTitleFrame then
                InnerTitleFrame.Size = UDim2.new(1, 0, 1, 0)
            end
            return
        end

        -- 3. Setup Ukuran
        local ImageSize = size or Dropdown.ImageSize or 30
        if typeof(ImageSize) == "number" then
            ImageSize = UDim2.new(0, ImageSize, 0, ImageSize)
        end

        -- 4. Buat Frame Icon Baru
        local NewIconFrame

        -- [STYLE 1] Jika Input adalah TABEL (Card Style dengan Gradient/Quantity)
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
        -- [STYLE 2] Jika Input adalah ID Gambar Biasa
        else
            NewIconFrame = Creator.Image(
                image, 
                Dropdown.Title, 
                Config.Window.NewElements and 12 or 6, 
                Config.Window.Folder, 
                "DropdownIcon", 
                false
            )
            -- Set properti manual agar konsisten
            NewIconFrame.Name = "CustomMainIcon" -- PENTING
            NewIconFrame.Parent = TitleFrameOuter
            NewIconFrame.Size = ImageSize
            NewIconFrame.LayoutOrder = -1
            NewIconFrame.AnchorPoint = Vector2.new(0, 0.5)
            NewIconFrame.Position = UDim2.new(0, 0, 0.5, 0)
            NewIconFrame.BackgroundTransparency = 1
        end
        
        -- 5. Update Ukuran Teks (Geser teks agar tidak menimpa gambar)
        local InnerTitleFrame = TitleFrameOuter:FindFirstChild("TitleFrame")
        if InnerTitleFrame then
            InnerTitleFrame.Size = UDim2.new(1, -ImageSize.X.Offset, 1, 0)
        end
    end

    -- 2. SetValueImage (Gambar Kanan dalam kotak Value)
    function Dropdown:SetValueImage(image)
        if Dropdown.UIElements.Dropdown then
             -- [FIX] Menggunakan FindFirstChild untuk mencegah error "Frame is not a valid member"
             local OuterFrame = Dropdown.UIElements.Dropdown:FindFirstChild("Frame")
             local Container = OuterFrame and OuterFrame:FindFirstChild("Frame")
             
             -- Fallback jika path default tidak ditemukan
             if not Container then
                 local foundLabel = Dropdown.UIElements.Dropdown:FindFirstChild("TextLabel", true)
                 if foundLabel then
                     Container = foundLabel.Parent
                 end
             end

             if not Container then return end
             
             local TextLabel = Container:FindFirstChild("TextLabel")
             local DynamicIcon = Container:FindFirstChild("DynamicValueIcon")
             
             if image and image ~= "" then
                 if not DynamicIcon then
                     DynamicIcon = New("ImageLabel", {
                         Name = "DynamicValueIcon",
                         Size = UDim2.new(0, 21, 0, 21),
                         BackgroundTransparency = 1,
                         ThemeTag = {
                             ImageColor3 = "Icon",
                         },
                         LayoutOrder = -1,
                         Parent = Container
                     })
                 end
                 
                 local ic = Creator.Icon(image)
                 if ic then
                     DynamicIcon.Image = ic[1]
                     DynamicIcon.ImageRectSize = ic[2].ImageRectSize
                     DynamicIcon.ImageRectOffset = ic[2].ImageRectPosition
                 else
                     DynamicIcon.Image = image
                     DynamicIcon.ImageRectSize = Vector2.new(0,0)
                     DynamicIcon.ImageRectOffset = Vector2.new(0,0)
                 end
                 
                 DynamicIcon.Visible = true
                 
                 if TextLabel then
                     TextLabel.Size = UDim2.new(1, -29, 1, 0)
                 end
             else
                 if DynamicIcon then
                     DynamicIcon.Visible = false
                 end
                 if TextLabel then
                     TextLabel.Size = UDim2.new(1, 0, 1, 0)
                 end
             end
        end
    end
    
    function Dropdown:SetValueIcon(image)
        Dropdown:SetValueImage(image)
    end
    
    Dropdown.DropdownMenu = CreateDropdown(Config, Dropdown, Element, CanCallback, "Dropdown")
    
    Dropdown.Display = Dropdown.DropdownMenu.Display
    Dropdown.Refresh = Dropdown.DropdownMenu.Refresh
    Dropdown.Select = Dropdown.DropdownMenu.Select
    Dropdown.Open = Dropdown.DropdownMenu.Open
    Dropdown.Close = Dropdown.DropdownMenu.Close
    
    local DropdownIcon = New("ImageLabel", {
        Image = Creator.Icon("chevrons-up-down")[1],
        ImageRectOffset = Creator.Icon("chevrons-up-down")[2].ImageRectPosition,
        ImageRectSize = Creator.Icon("chevrons-up-down")[2].ImageRectSize,
        Size = UDim2.new(0,18,0,18),
        Position = UDim2.new(
            1,
            Dropdown.UIElements.Dropdown and -12 or 0,
            0.5,
            0
        ),
        ThemeTag = {
            ImageColor3 = "Icon"
        },
        AnchorPoint = Vector2.new(1,0.5),
        Parent = Dropdown.UIElements.Dropdown and Dropdown.UIElements.Dropdown.Frame or Dropdown.DropdownFrame.UIElements.Main
    })
    
    function Dropdown:Lock(text) -- Tambahkan 'text'
        Dropdown.Locked = true
        CanCallback = false
        return Dropdown.DropdownFrame:Lock(text) -- Kirim 'text' ke frame
    end
    function Dropdown:Unlock()
        Dropdown.Locked = false
        CanCallback = true
        return Dropdown.DropdownFrame:Unlock()
    end
    -- Ekspos fungsi Edit ke user
    function Dropdown:Edit(ItemName, NewData)
        Dropdown.DropdownMenu:Edit(ItemName, NewData)
    end
    -- Ekspos fungsi Edit ke user
    function Dropdown:EditDrop(Target, NewData)
        Dropdown.DropdownMenu:EditDrop(Target, NewData)
    end
    
    if Dropdown.Locked then
        Dropdown:Lock()
    end
    
    -- 3. [RESTORE DEFAULT POSITION + TOGGLE FIX]
    -- Mengembalikan fungsi Open ke default tapi dengan logika Toggle
    local OriginalOpen = Dropdown.Open
    
    Dropdown.Open = function()
        if Dropdown.Opened then
            -- Jika sudah terbuka, tutup (Toggle Close)
            Dropdown.Close()
        else
            -- Jika tertutup, buka (Normal Downwards)
            OriginalOpen()
        end
    end
    
    return Dropdown.__type, Dropdown
end

return Element