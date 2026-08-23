local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Element = {}

-- Nama cache ikon. Ikon boleh berupa string ("settings", "rbxassetid://...",
-- "https://...") atau tabel ({ url = "...", gif = "..." }), jadi tidak boleh
-- langsung digabung pakai ".." karena tabel akan bikin error.
local function IconCacheName(Icon, Title)
    local Source = Icon
    if type(Icon) == "table" then
        Source = Icon.url or Icon.gif or Icon.mp4 or Icon.webm or Icon.file or "SectionIcon"
    end
    return tostring(Source) .. ":" .. tostring(Title)
end

function Element:New(Config)
    local Section = {
        __type = "Section",
        Title = Config.Title or "Section",
        Icon = Config.Icon or Config.Image,
        TextXAlignment = Config.TextXAlignment or "Left",
        TextSize = Config.TextSize or 19,
        Box = Config.Box or false,
        FontWeight = Config.FontWeight or Enum.FontWeight.SemiBold,
        TextTransparency = Config.TextTransparency or 0.05,
        Opened = Config.Opened or false,
        UIElements = {},

        HeaderSize = Config.HeaderSize or 42,
        Padding = 10,

        -- [ IKON TITLE ]
        IconSize = Config.IconSize or 20,
        IconThemed = Config.IconThemed,
        IconTransparency = Config.IconTransparency or 0,
        IconScaleType = Config.IconScaleType or Config.ScaleType,
        IconKeepAspect = Config.IconKeepAspect,

        -- jarak antar isi header (ikon <-> judul <-> chevron)
        HeaderPadding = Config.HeaderPadding or 8,

        Elements = {},

        Expandable = false,
    }

    local ChevronSize = Config.ChevronSize or 20

    -- Ikon inline di dalam Title: "{icon} Auto {icon} Farm {icon}".
    -- Sumber "{icon}" diambil dari Config.Icon. Ikon kiri header tidak
    -- terpengaruh, token hanya menambah.
    Section.InlineIcon = Config.InlineIcon ~= false

    local function InlineContext(Index)
        return {
            Icon             = Section.Icon,
            IconSize         = Section.IconSize,
            IconThemed       = Section.IconThemed,
            IconTransparency = Section.IconTransparency,
            IconScaleType    = Section.IconScaleType,
            IconKeepAspect   = Section.IconKeepAspect,
            Folder           = Config.Window and Config.Window.Folder,
            ImageKind        = Section.__type,
            ThemeTagName     = "Text",
            CachePrefix      = "SectionTitle",
            Index            = Index,
        }
    end

    local function HasInlineTitle()
        return Section.InlineIcon and Creator.HasInlineIcons(Section.Title)
    end

    -- Header dipotong oleh ClipsDescendants, jadi kalau ikonnya lebih besar
    -- dari header, tinggi header ikut disesuaikan supaya ikon tidak terpotong.
    -- Ikon inline ikut dihitung karena "size=" per token bisa lebih besar.
    -- Dihitung ulang dari HeaderSize yang diminta, bukan dari nilai sekarang,
    -- supaya header ikut menyusut lagi saat judulnya diganti tanpa ikon besar.
    local RequestedHeaderSize = Section.HeaderSize

    local function FitHeaderSize()
        local Largest = Section.IconSize
        if HasInlineTitle() then
            Largest = Creator.MaxInlineIconSize(Section.Title, InlineContext(), Largest)
        end

        Section.HeaderSize = math.max(RequestedHeaderSize, Largest + 12)
    end

    FitHeaderSize()

    local Main
    local Icon
    local IconLabel
    local UpdateTitleSize
    local RenderTitle

    -- Dipanggil tiap Title/Icon/IconSize berubah: judul disusun ulang dan,
    -- kalau ikonnya jadi lebih besar, tinggi header dipasang ulang.
    -- Tinggi header dibekukan (AutomaticSize "None") begitu section bisa
    -- dibuka-tutup, jadi tanpa ini ikon yang lebih besar akan terpotong.
    local function RefreshHeader()
        local PreviousHeaderSize = Section.HeaderSize
        FitHeaderSize()

        if RenderTitle then RenderTitle() end
        if UpdateTitleSize then UpdateTitleSize() end

        if Section.HeaderSize == PreviousHeaderSize or not Main then return end

        if Main.Top.AutomaticSize == Enum.AutomaticSize.None then
            Main.Top.Size = UDim2.new(1, 0, 0, Section.HeaderSize)
        end
        Main.Content.Position = UDim2.new(0, 0, 0, Section.HeaderSize)

        if Main.AutomaticSize == Enum.AutomaticSize.None then
            if Section.Opened then
                Section:Open()
            else
                Main.Size = UDim2.new(1, 0, 0, Section.HeaderSize)
            end
        end
    end

    local function CreateIcon(Value)
        local Frame = Creator.Image(
            Value,
            IconCacheName(Value, Section.Title),
            0,
            Config.Window and Config.Window.Folder,
            Section.__type,
            true,
            Section.IconThemed,
            nil,
            {
                -- ikon tidak dipotong: perbandingan ukuran asli dipertahankan
                ScaleType = Section.IconScaleType,
                KeepAspect = Section.IconKeepAspect,
                Size = UDim2.fromOffset(Section.IconSize, Section.IconSize),
            }
        )
        if not Frame then return nil end

        Frame.Name = "Icon"
        Frame.LayoutOrder = 1
        Frame.Size = UDim2.new(0, Section.IconSize, 0, Section.IconSize)

        local Label = Frame:FindFirstChildOfClass("ImageLabel")
        if Label then
            Label.ImageTransparency = Section.IconTransparency
        end

        return Frame, Label
    end

    function Section:SetIcon(NewIcon)
        Section.Icon = NewIcon or nil

        if Icon then
            Icon:Destroy()
            Icon, IconLabel = nil, nil
        end

        if NewIcon then
            Icon, IconLabel = CreateIcon(NewIcon)
            -- Dipanggil setelah header dibuat: ikon baru harus dimasukkan
            -- sendiri ke header, kalau tidak frame-nya menggantung tanpa parent.
            if Icon and Main and Main:FindFirstChild("Top") then
                Icon.Parent = Main.Top
            end
        end

        Section.UIElements.Icon = Icon
        -- Title bisa memuat "{icon}" yang sumbernya dari Section.Icon,
        -- jadi ikut dirender ulang.
        RefreshHeader()

        return Section
    end

    function Section:SetIconSize(NewSize)
        Section.IconSize = NewSize or Section.IconSize
        if Icon then
            Icon.Size = UDim2.new(0, Section.IconSize, 0, Section.IconSize)
        end
        RefreshHeader()
        return Section
    end

    function Section:GetIcon()
        return Section.Icon
    end

    local ChevronIconFrame = New("Frame", {
        Name = "Chevron",
        Size = UDim2.new(0,ChevronSize,0,ChevronSize),
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Visible = false
    }, {
        New("ImageLabel", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Image = Creator.Icon("chevron-down")[1],
            ImageRectSize = Creator.Icon("chevron-down")[2].ImageRectSize,
            ImageRectOffset = Creator.Icon("chevron-down")[2].ImageRectPosition,
            ThemeTag = {
                ImageColor3 = "Icon",
            },
            ImageTransparency = .7,
        })
    })


    if Section.Icon then
        Section:SetIcon(Section.Icon)
    end

    local TitleFrame = New("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        TextXAlignment = Section.TextXAlignment,
        AutomaticSize = "Y",
        LayoutOrder = 2,
        TextSize = Section.TextSize,
        TextTransparency = Section.TextTransparency,
        ThemeTag = {
            TextColor3 = "Text",
        },
        FontFace = Font.new(Creator.Font, Section.FontWeight),
        --Parent = Config.Parent,
        --Size = UDim2.new(1,0,0,0),
        Text = Section.Title,
        Size = UDim2.new(
            1,
            0,
            0,
            0
        ),
        TextWrapped = true,
    })

    -- Dipakai kalau Title memuat token ikon: judul disusun dari beberapa
    -- segmen (potongan teks + frame ikon) karena RichText tidak punya <img>.
    local TitleRichLayout = New("UIListLayout", {
        FillDirection = "Horizontal",
        SortOrder = "LayoutOrder",
        Padding = UDim.new(0, math.max(2, math.floor(Section.HeaderPadding / 2))),
        VerticalAlignment = "Center",
        HorizontalAlignment = Section.TextXAlignment == "Right" and "Right"
            or (Section.TextXAlignment == "Center" and "Center" or "Left"),
    })
    -- judul panjang tetap bisa turun baris (properti baru, jadi lewat pcall)
    Creator.TrySetWraps(TitleRichLayout, true)

    local TitleRich = New("Frame", {
        Name = "TitleRich",
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = "Y",
        Visible = false,
    }, {
        TitleRichLayout,
    })

    local function CreateTitleTextPart(Text, Order)
        return New("TextLabel", {
            Name = "TitlePart",
            BackgroundTransparency = 1,
            Text = Text,
            TextXAlignment = Section.TextXAlignment,
            TextSize = Section.TextSize,
            TextTransparency = Section.TextTransparency,
            ThemeTag = {
                TextColor3 = "Text",
            },
            FontFace = Font.new(Creator.Font, Section.FontWeight),
            LayoutOrder = Order,
            Size = UDim2.new(0, 0, 0, 0),
            AutomaticSize = "XY",
            TextWrapped = false,
        })
    end

    RenderTitle = function()
        if not HasInlineTitle() then
            -- jalur lama: satu TextLabel biasa, tanpa perubahan perilaku
            TitleFrame.Text = Section.Title
            TitleFrame.Visible = true
            TitleRich.Visible = false
            for _, Child in ipairs(TitleRich:GetChildren()) do
                if Child:IsA("GuiObject") then Child:Destroy() end
            end
            return
        end

        local Segments = Creator.ParseInlineText(Section.Title, InlineContext())

        -- Kalau tidak ada satu pun token yang jadi ikon, teks biasa saja.
        -- Segmen digabung apa adanya (bukan lewat StripInlineIcons) supaya
        -- spasi & baris baru asli tidak ikut dirapikan.
        local IconCount = 0
        local PlainParts = {}
        for _, Segment in ipairs(Segments) do
            if Segment.Type == "Icon" then
                IconCount = IconCount + 1
            else
                table.insert(PlainParts, Segment.Content)
            end
        end
        if IconCount == 0 then
            TitleFrame.Text = table.concat(PlainParts)
            TitleFrame.Visible = true
            TitleRich.Visible = false
            return
        end

        for _, Child in ipairs(TitleRich:GetChildren()) do
            if Child:IsA("GuiObject") then Child:Destroy() end
        end

        -- Selalu ada minimal satu ikon di sini, jadi tiap potongan teks
        -- mengikuti lebar isinya (bukan satu label penuh selebar header).
        for Index, Segment in ipairs(Segments) do
            local Part
            if Segment.Type == "Text" then
                Part = CreateTitleTextPart(Segment.Content, Index)
            else
                Part = Creator.InlineIconFrame(Segment, InlineContext(Index))
                if Part then Part.LayoutOrder = Index end
            end
            if Part then Part.Parent = TitleRich end
        end

        TitleFrame.Visible = false
        TitleRich.Visible = true
    end


    UpdateTitleSize = function()
        local offset = 0
        if Icon then
            offset = offset - (Section.IconSize + Section.HeaderPadding)
        end
        if ChevronIconFrame.Visible then
            offset = offset - (ChevronSize + Section.HeaderPadding)
        end
        TitleFrame.Size = UDim2.new(1, offset, 0, 0)
        TitleRich.Size = UDim2.new(1, offset, 0, 0)
    end


    Main = Creator.NewRoundFrame(Config.Window.ElementConfig.UICorner, "Squircle", {
        Size = UDim2.new(1,0,0,0),
        BackgroundTransparency = 1,
        Parent = Config.Parent,
        ClipsDescendants = true,
        AutomaticSize = "Y",
        ImageTransparency = Section.Box and .93 or 1,
        ThemeTag = {
            ImageColor3 = "Text",
        },
    }, {
        New("TextButton", {
            Size = UDim2.new(1,0,0,Expandable and 0 or Section.HeaderSize),
            BackgroundTransparency = 1,
            AutomaticSize = Expandable and nil or "Y" ,
            Text = "",
            Name = "Top",
        }, {
            Section.Box and New("UIPadding", {
                PaddingLeft = UDim.new(0,Config.Window.ElementConfig.UIPadding),
                PaddingRight = UDim.new(0,Config.Window.ElementConfig.UIPadding),
            }) or nil,
            Icon,
            TitleFrame,
            TitleRich,
            New("UIListLayout", {
                Padding = UDim.new(0,Section.HeaderPadding),
                SortOrder = "LayoutOrder",
                FillDirection = "Horizontal",
                VerticalAlignment = "Center",
                HorizontalAlignment = "Left",
            }),
            ChevronIconFrame,
        }),
        New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            Name = "Content",
            Visible = false,
            Position = UDim2.new(0,0,0,Section.HeaderSize)
        }, {
            Section.Box and New("UIPadding", {
                PaddingLeft = UDim.new(0,Config.Window.ElementConfig.UIPadding),
                PaddingRight = UDim.new(0,Config.Window.ElementConfig.UIPadding),
                PaddingBottom = UDim.new(0,Config.Window.ElementConfig.UIPadding),
            }) or nil,
            New("UIListLayout", {
                FillDirection = "Vertical",
                Padding = UDim.new(0,Config.Tab.Gap),
                VerticalAlignment = "Top",
            }),
        })
    })

    Section.ElementFrame = Main

    Section.UIElements.Main = Main
    Section.UIElements.Top = Main.Top
    Section.UIElements.Content = Main.Content
    Section.UIElements.Title = TitleFrame
    Section.UIElements.TitleRich = TitleRich
    Section.UIElements.Chevron = ChevronIconFrame
    Section.UIElements.Icon = Icon

    -- Section.UIElements.Main:GetPropertyChangedSignal("TextBounds"):Connect(function()
    --     Section.UIElements.Main.Size = UDim2.new(1,0,0,Section.UIElements.Main.TextBounds.Y)
    -- end)



    local ElementsModule = Config.ElementsModule

    ElementsModule.Load(Section, Main.Content, ElementsModule.Elements, Config.Window, Config.ANUI, function()
        if not Section.Expandable then
            Section.Expandable = true
            ChevronIconFrame.Visible = true
            UpdateTitleSize()
        end
    end, ElementsModule, Config.UIScale, Config.Tab)


    RenderTitle()
    UpdateTitleSize()

    function Section:SetTitle(Title)
        Section.Title = Title
        -- Title bisa memuat token ikon, jadi disusun ulang (bukan set .Text saja)
        RefreshHeader()
        return Section
    end

    function Section:Destroy()
        for _,element in next, Section.Elements do
            element:Destroy()
        end

        -- Section.UIElements.Main.AutomaticSize = "None"
        -- Section.UIElements.Main.Size = UDim2.new(1,0,0,Section.UIElements.Main.TextBounds.Y)

        -- Tween(Section.UIElements.Main, .1, {TextTransparency = 1}):Play()
        -- task.wait(.1)
        -- Tween(Section.UIElements.Main, .15, {Size = UDim2.new(1,0,0,0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()

        Main:Destroy()
    end

    function Section:Open()
        if Section.Expandable then
            Section.Opened = true
            Tween(Main, 0.33, {
                Size = UDim2.new(1,0,0, Section.HeaderSize + (Main.Content.AbsoluteSize.Y/Config.UIScale))
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

            Tween(ChevronIconFrame.ImageLabel, 0.1, {Rotation = 180}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
    end
    function Section:Close()
        if Section.Expandable then
            Section.Opened = false
            Tween(Main, 0.26, {
                Size = UDim2.new(1,0,0, Section.HeaderSize)
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            Tween(ChevronIconFrame.ImageLabel, 0.1, {Rotation = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
    end

    Creator.AddSignal(Main.Top.MouseButton1Click, function()
        if Section.Expandable then
            if Section.Opened then
                Section:Close()
            else
                Section:Open()
            end
        end
    end)

    Creator.AddSignal(Main.Content.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        if Section.Opened then
            Section:Open()
        end
    end)

    task.spawn(function()
        task.wait(0.02)
        if Section.Expandable then
            -- New("UIPadding", {
            --     PaddingTop = UDim.new(0,4),
            --     PaddingLeft = UDim.new(0,Section.Padding),
            --     PaddingRight = UDim.new(0,Section.Padding),
            --     PaddingBottom = UDim.new(0,2),

            --     Parent = Main.Top,
            -- })
            Main.Size = UDim2.new(1,0,0,Section.HeaderSize)
            Main.AutomaticSize = "None"
            Main.Top.Size = UDim2.new(1,0,0,Section.HeaderSize)
            Main.Top.AutomaticSize = "None"
            Main.Content.Visible = true
        end
        if Section.Opened then
            Section:Open()
        end

    end)

    return Section.__type, Section
end

return Element
