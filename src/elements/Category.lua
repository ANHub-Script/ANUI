local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Element = {}

function Element:New(Config)
    local Category = {
        __type = "Category",
        Title = Config.Title,
        Desc = Config.Desc,
        Options = Config.Options or {}, -- List tombol: {"Yen", "Token"}
        Default = Config.Default, -- Yang aktif default
        Callback = Config.Callback or function() end,
        Parent = Config.Parent,
        UIElements = {},
    }

    -- 1. Container Utama (ScrollingFrame)
    -- Menggunakan struktur standard ANUI agar rapi di dalam Section/Tab
    local MainFrame = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 45), -- Tinggi area tombol
        BackgroundTransparency = 1,
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarThickness = 2,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        Parent = Config.Parent,
        ThemeTag = {
            ScrollBarImageColor3 = "Text", -- Warna scrollbar ikut tema
        }
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

    -- Menyimpan referensi ke semua tombol untuk update visual
    local ButtonObjects = {}
    
    -- Fungsi Update Visual (Aktif/Tidak Aktif)
    local function UpdateVisuals(selectedName)
        for name, objs in pairs(ButtonObjects) do
            local isActive = (name == selectedName)
            
            -- Warna saat Aktif: Accent (Hijau/Biru tema). Tidak Aktif: Button (Abu-abu)
            local targetColor = isActive and "Accent" or "Button"
            local targetTextColor = isActive and "Text" or "Text" -- Bisa diatur beda jika mau
            local targetTextTransparency = isActive and 0 or 0.4
            
            -- Kita gunakan Creator.GetThemeProperty untuk mengambil warna asli dari string tema
            -- Tapi untuk simpel animasi manual, kita bisa set ThemeTag ulang atau tween manual
            
            -- Cara ANUI: Update property ThemeTag atau tween manual
            -- Disini kita mainkan transparansi dan warna via ThemeTag helper jika ada, 
            -- tapi karena ANUI pakai ThemeTag static, kita tween manual propertinya.
            
            local ColorVal = Creator.GetThemeProperty(targetColor, Config.Window.Theme)
            local TextColorVal = Creator.GetThemeProperty(targetTextColor, Config.Window.Theme)
            
            Tween(objs.Background, 0.2, {ImageColor3 = ColorVal}):Play()
            Tween(objs.Title, 0.2, {TextTransparency = targetTextTransparency}):Play()
            
            if objs.Icon then
                Tween(objs.Icon.ImageLabel, 0.2, {ImageTransparency = targetTextTransparency}):Play()
            end
        end
    end

    -- 2. Loop untuk membuat setiap Tombol
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

        -- Background Tombol (Squircle)
        local Background = Creator.NewRoundFrame(8, "Squircle", {
            Size = UDim2.new(1, 0, 1, 0),
            ThemeTag = {
                ImageColor3 = "Button", -- Warna default (tidak aktif)
            },
            Name = "Background",
            Parent = ButtonFrame
        })

        -- Layout isi tombol (Icon + Teks)
        local ContentLayout = New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Parent = Background
        })
        
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            Parent = Background
        })

        -- Icon (Jika ada)
        local IconObj
        if OptIcon then
            IconObj = Creator.Image(OptIcon, "Icon", 0, Config.Window.Folder, "Icon", false)
            IconObj.Size = UDim2.new(0, 18, 0, 18)
            IconObj.BackgroundTransparency = 1
            IconObj.ImageLabel.ImageTransparency = 0.4
            IconObj.Parent = Background
        end

        -- Teks Judul
        local TitleObj = New("TextLabel", {
            Text = OptName,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
            TextSize = 14,
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            ThemeTag = {
                TextColor3 = "Text"
            },
            TextTransparency = 0.4, -- Default agak transparan (tidak aktif)
            Parent = Background
        })

        -- Simpan referensi untuk update nanti
        ButtonObjects[OptName] = {
            Frame = ButtonFrame,
            Background = Background,
            Title = TitleObj,
            Icon = IconObj
        }

        -- Logic Klik
        Creator.AddSignal(ButtonFrame.MouseButton1Click, function()
            UpdateVisuals(OptName)
            -- Panggil Callback
            if Category.Callback then
                Category.Callback(OptName)
            end
        end)
    end

    -- Set Default Active
    if Category.Default then
        UpdateVisuals(Category.Default)
    elseif Category.Options[1] then
        -- Jika tidak ada default, pilih yang pertama
        local firstOption = Category.Options[1]
        local firstName = (type(firstOption) == "table" and firstOption.Title) or firstOption
        UpdateVisuals(firstName)
    end
    
    Category.ElementFrame = MainFrame
    return Category.__type, Category
end

return Element