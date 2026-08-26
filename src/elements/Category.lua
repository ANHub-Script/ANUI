local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween
local cloneref = (cloneref or clonereference or function(instance) return instance end)

local Element = {}

-- Option boleh string ("Automation") atau tabel ({ Title = "...", Icon = "..." })
-- Title boleh memuat token ikon inline, mis. "{swords} Auto Farm".
-- Key = judul tanpa token, dipakai sebagai nama option supaya
-- Category:Select("Auto Farm") tetap jalan.
local function ResolveOption(Option)
    local Resolved
    if type(Option) == "table" then
        local Title = Option.Title or Option.Name or Option.Value or Option[1]
        Resolved = {
            Title      = tostring(Title or ""),
            Icon       = Option.Icon or Option.Image,
            IconSize   = Option.IconSize,
            ScaleType  = Option.ScaleType,
            KeepAspect = Option.KeepAspect ~= nil and Option.KeepAspect or Option.Native,
            NativeSize = Option.NativeSize,
            Tint       = Option.Tint,
            ImageRectOffset = Option.ImageRectOffset,
            ImageRectSize   = Option.ImageRectSize,
            Desc       = Option.Desc,
            Raw        = Option,
        }
    else
        Resolved = { Title = tostring(Option), Raw = Option }
    end

    Resolved.Key = Resolved.Title
    if Creator.HasInlineIcons(Resolved.Title) then
        local Stripped = Creator.StripInlineIcons(Resolved.Title, { Icon = Resolved.Icon })
        if Stripped ~= "" then
            Resolved.Key = Stripped
        end
    end

    return Resolved
end

-- Cari frame dari sebuah elemen ANUI (Toggle/Group/Section/dll) atau Instance langsung
local function ResolveElementFrame(Item)
    if typeof(Item) == "Instance" then
        return Item
    end
    if type(Item) ~= "table" then
        return nil
    end

    local Frame = rawget(Item, "ElementFrame")
    if typeof(Frame) == "Instance" then
        return Frame
    end

    local UIElements = rawget(Item, "UIElements")
    if type(UIElements) == "table" and typeof(UIElements.Main) == "Instance" then
        return UIElements.Main
    end

    for _, Key in ipairs({ "GroupFrame", "MainFrame", "Main", "Frame", "Container" }) do
        local Value = rawget(Item, Key)
        if typeof(Value) == "Instance" then
            return Value
        end
    end

    return nil
end

function Element:New(Config)
    local Window = Config.Window
    local Tab = Config.Tab

    local Category = {
        __type   = "Category",
        Title    = Config.Title,
        Desc     = Config.Desc,
        Options  = {},
        Default  = Config.Default,
        Value    = nil,
        Callback = Config.Callback or Config.OnChanged or function() end,
        Parent   = Config.Parent,
        UIElements = {},

        -- [ TAMPILAN ] semua bisa diatur dari config, tidak dipatok di script
        Height        = Config.Height or 45,
        ButtonHeight  = Config.ButtonHeight or 32,
        IconSize      = Config.IconSize or 18,
        TextSize      = Config.TextSize or 14,
        Radius        = Config.Radius or 8,
        Gap           = Config.Gap or Config.Padding or 8,
        SidePadding   = Config.SidePadding or 12,
        ScrollSpeed   = Config.ScrollSpeed or 35,
        ActiveTag     = Config.ActiveTag or "Toggle",
        InactiveTag   = Config.InactiveTag or "Button",
        TextTag       = Config.TextTag or "Text",
        Transparency  = Config.Transparency or 0.5,

        -- [ IKON ] default: tidak dipotong, perbandingan ukuran asli dipertahankan
        IconScaleType  = Config.IconScaleType or Config.ScaleType,
        IconKeepAspect = Config.IconKeepAspect ~= false,
        IconAutoWidth  = Config.IconAutoWidth ~= false,
        TintIcon       = Config.TintIcon, -- nil = auto (lucide diwarnai, gambar asli tidak)

        -- [ LAYOUT ] menempel di atas konten tab
        ContentPadding   = Config.ContentPadding or 5,
        AlignWithContent = Config.AlignWithContent ~= false,

        -- [ MANAJEMEN ELEMEN ] library yang urus tampil/sembunyi elemen
        AutoCapture = Config.AutoCapture ~= false,
        Registry    = {},
        Owners      = {},
    }

    -- Deteksi apakah Category berada di dalam Section (melihat keturunan parent)
    local function IsInsideSection()
        local Parent = Config.Parent
        while Parent do
            if rawget(Parent, "__type") == "Section" then
                return Parent
            end
            Parent = Parent.Parent
        end
        return nil
    end

    local SectionRef = IsInsideSection()

    -- Sticky: boleh kalau direktur konten Tab, ATAU jika di dalam Section
    local CanStickWithTab = Tab and type(Tab.ReserveHeader) == "function"
        and Tab.UIElements and Config.Parent == Tab.UIElements.ContainerFrame
    local CanStickWithSection = SectionRef ~= nil
    local CanStick = CanStickWithTab or CanStickWithSection

    local Sticky = Config.Sticky
    if Sticky == nil then Sticky = CanStick end
    if Sticky and not (CanStickWithTab or CanStickWithSection) then
        -- di dalam Section/Group, sticky tidak didukung; jangan diam-diam dibuang
        warn("[ ANUI.Category ] Sticky diabaikan: Category ini bukan anak langsung konten Tab juga bukan di dalam Section")
    end
    Sticky = (Sticky and (CanStickWithTab or CanStickWithSection)) and true or false

    -- Wrapper: dibutuhkan agar AutomaticSize induk menghitung tinggi elemen ini
    local WrapperFrame = New("Frame", {
        Name = "Category",
        Size = UDim2.new(1, 0, 0, Category.Height),
        BackgroundTransparency = 1,
    })

    local Header
    if Sticky then
        if CanStickWithSection and SectionRef then
            -- Di dalam Section: gunakan Tab's ReserveHeader. Header akan ikut
            -- Tab's relayout otomatis, posisinya akan ditentukan urutan penyisipan
            -- di antara header lain (profile header, dll). Header ini akan menempel
            -- di bagian Atas konten Tab, di atas Section content.
            Header = Tab:ReserveHeader(Category.Height, {
                Name             = "CategoryHeader",
                ContentPadding   = Category.ContentPadding,
                AlignWithContent = Category.AlignWithContent,
                ZIndex           = Config.ZIndex or 6,
            })
            -- WrapperFrame dipindahkan ke Header.Frame
            WrapperFrame.Size = UDim2.new(1, 0, 1, 0)
            WrapperFrame.Parent = Header.Frame
        else
            -- Library yang memindahkan & menggeser konten tab, bukan script pemakai
            Header = Tab:ReserveHeader(Category.Height, {
                Name             = "CategoryHeader",
                ContentPadding   = Category.ContentPadding,
                AlignWithContent = Category.AlignWithContent,
                ZIndex           = Config.ZIndex or 6,
            })
            WrapperFrame.Size = UDim2.new(1, 0, 1, 0)
            WrapperFrame.Parent = Header.Frame
        end
    else
        WrapperFrame.Parent = Config.Parent
    end

    -- Container scroll horizontal
    local MainFrame = New("ScrollingFrame", {
        Name = "Options",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        Active = true,
        Parent = WrapperFrame,
    }, {
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, Category.Gap),
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
        })
    })

    Category.UIElements.Main = WrapperFrame
    Category.UIElements.Container = MainFrame
    Category.UIElements.Header = Header and Header.Frame or nil
    Category.Header = Header
    Category.Sticky = Sticky
    Category.ElementFrame = WrapperFrame

    -- [ SCROLL MANUAL: drag & roda mouse ]
    -- Strip ini ScrollingFrame sendiri (arah X). Kalau Category dipasang di dalam
    -- Section/Group, strip-nya ikut berada DI DALAM ScrollingFrame konten tab,
    -- jadi satu gesture dipakai dua-duanya: strip geser ke samping sekaligus
    -- halaman ke-scroll ke bawah. Selama kursor/jari ada di atas strip, konten
    -- tab dikunci supaya yang gerak cuma strip-nya. Di luar strip, halaman
    -- ke-scroll seperti biasa.
    local IsDragging = false
    local DragStart = Vector2.new()
    local StartCanvasPos = Vector2.new()
    -- Dibaca tombol option: klik yang sebenarnya cuma akhir dari drag strip
    -- tidak boleh ikut mengganti kategori.
    local DidDrag = false

    local Hovering = false
    local ReleaseConnection

    local PageTab = (Tab and type(Tab.LockScroll) == "function") and Tab or nil

    -- ScrollingFrame konten tab. Dipakai langsung (bukan cuma lewat LockScroll)
    -- karena roda mouse tetap diteruskan ke induk walaupun ScrollingEnabled-nya
    -- sudah false, jadi posisi kanvasnya perlu dikembalikan sendiri.
    local PageScroll = (Tab and Tab.UIElements
        and typeof(Tab.UIElements.ContainerFrame) == "Instance")
        and Tab.UIElements.ContainerFrame or nil

    local RunService = cloneref(game:GetService("RunService"))
    local UserInputService = cloneref(game:GetService("UserInputService"))

    -- Sentuhan aktif di atas strip (jari belum diangkat)
    local TouchActive = false

    -- Backstop: ScrollingEnabled = false saja TIDAK cukup, roda mouse tetap
    -- diteruskan ke ScrollingFrame induk. Jadi selama gesture ada di atas strip,
    -- posisi kanvas konten tab dipaku tiap frame. Snap-back-nya terjadi sebelum
    -- frame digambar, jadi tidak kelihatan berkedip.
    local PinConnection
    local PinPos

    local function UnpinPage()
        if PinConnection then
            PinConnection:Disconnect()
            PinConnection = nil
        end
    end

    local function ReleaseLock()
        Hovering = false
        UnpinPage()
        if PageTab then PageTab:UnlockScroll(Category) end
    end

    local function PinPage()
        if not PageScroll or PinConnection then return end
        PinPos = PageScroll.CanvasPosition
        PinConnection = RunService.RenderStepped:Connect(function()
            -- strip sudah dibuang: jangan menahan halaman
            if WrapperFrame.Parent == nil or PageScroll.Parent == nil then
                ReleaseLock()
                return
            end
            if not Hovering and not IsDragging and not TouchActive then
                ReleaseLock()
                return
            end
            if PageScroll.CanvasPosition ~= PinPos then
                PageScroll.CanvasPosition = PinPos
            end
        end)
    end

    -- Kunci dipegang selama masih hover ATAU masih drag. Dua-duanya dilacak
    -- terpisah: drag yang keluar dari strip mematikan hover, tapi kuncinya harus
    -- tetap jalan sampai tombol/jari dilepas.
    local function SyncPageScroll()
        if Hovering or IsDragging or TouchActive then
            if PageTab then PageTab:LockScroll(Category, WrapperFrame) end
            PinPage()
        else
            ReleaseLock()
        end
    end

    Category.ReleasePageScroll = function()
        Hovering = false
        IsDragging = false
        TouchActive = false
        ReleaseLock()
    end

    local function StopDrag()
        IsDragging = false
        if ReleaseConnection then
            ReleaseConnection:Disconnect()
            ReleaseConnection = nil
        end
        SyncPageScroll()
    end

    Creator.AddSignal(MainFrame.MouseEnter, function()
        Hovering = true
        SyncPageScroll()
    end)

    Creator.AddSignal(MainFrame.MouseLeave, function()
        Hovering = false
        SyncPageScroll()
    end)

    -- Strip dibuang/dilepas dari UI: kunci jangan sampai nyangkut
    Creator.AddSignal(WrapperFrame.AncestryChanged, function(_, NewParent)
        if NewParent == nil then
            Category.ReleasePageScroll()
        end
    end)

    Creator.AddSignal(MainFrame.InputBegan, function(Input)
        local IsMouse = Input.UserInputType == Enum.UserInputType.MouseButton1
        local IsTouch = Input.UserInputType == Enum.UserInputType.Touch
        if not (IsMouse or IsTouch) then return end

        -- Sentuhan tidak memicu MouseEnter/MouseLeave, jadi jalur input dipakai
        -- juga supaya di HP halaman tetap dikunci selama jari di atas strip.
        if IsTouch then TouchActive = true end

        DidDrag = false

        -- Di HP geser horizontal sudah ditangani ScrollingFrame-nya sendiri
        -- (lengkap dengan inersia), jadi CanvasPosition TIDAK digeser manual:
        -- kalau dua-duanya jalan, jaraknya jadi dobel.
        if IsMouse then
            IsDragging = true
            DragStart = Input.Position
            StartCanvasPos = MainFrame.CanvasPosition
        end

        SyncPageScroll()

        -- Dilepas di luar strip tetap mengakhiri drag & kunci. MainFrame.InputEnded
        -- tidak kena kalau kursor sudah keluar duluan, jadi dipantau global.
        if ReleaseConnection then ReleaseConnection:Disconnect() end
        ReleaseConnection = UserInputService.InputEnded:Connect(function(EndInput)
            if EndInput ~= Input then return end
            if IsTouch then TouchActive = false end
            StopDrag()
        end)
    end)

    Creator.AddSignal(MainFrame.InputChanged, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            if IsDragging then
                local Delta = Input.Position - DragStart
                -- geseran kecil masih dihitung klik, bukan drag
                if math.abs(Delta.X) > 4 then
                    DidDrag = true
                end
                MainFrame.CanvasPosition = Vector2.new(StartCanvasPos.X - Delta.X, 0)
            end
        elseif Input.UserInputType == Enum.UserInputType.MouseWheel then
            -- Roda mouse di atas strip: event ini pasti terpanggil walaupun
            -- MouseEnter tadi terlewat, jadi kuncinya dipasang di sini juga.
            Hovering = true
            SyncPageScroll()

            -- scroll atas/bawah diubah jadi kiri/kanan
            MainFrame.CanvasPosition = MainFrame.CanvasPosition
                + Vector2.new(Input.Position.Z * -Category.ScrollSpeed, 0)
        end
    end)

    -- =====================================================
    -- [ TOMBOL OPTION ]
    -- =====================================================
    local ButtonObjects = {}

    -- Nama option boleh ditulis dengan atau tanpa token ikon:
    -- Select("Auto Farm") dan Select("{swords} Auto Farm") sama-sama jalan.
    local function NormalizeName(Name)
        if Name == nil then return nil end
        Name = tostring(Name)
        if ButtonObjects[Name] or not Creator.HasInlineIcons(Name) then
            return Name
        end
        local Stripped = Creator.StripInlineIcons(Name)
        if Stripped ~= "" and ButtonObjects[Stripped] then
            return Stripped
        end
        return Name
    end

    local function UpdateVisuals(SelectedName)
        local Theme = Creator.Theme

        for Name, Objs in pairs(ButtonObjects) do
            local IsActive = (Name == SelectedName)
            local Tag = IsActive and Category.ActiveTag or Category.InactiveTag
            local ColorVal = Creator.GetThemeProperty(Tag, Theme)
            local TextColorVal = Creator.GetThemeProperty(Category.TextTag, Theme)
            local TargetTransparency = IsActive and 0 or Category.Transparency

            -- ThemeTag ikut di-update supaya warna tetap benar saat ganti theme
            local ThemeData = Creator.Objects[Objs.Background]
            if ThemeData and ThemeData.Properties then
                ThemeData.Properties.ImageColor3 = Tag
            end

            if typeof(ColorVal) == "Color3" then
                Tween(Objs.Background, 0.2, { ImageColor3 = ColorVal }):Play()
            end

            -- judul bisa terdiri dari beberapa label kalau memuat ikon inline
            for _, Label in ipairs(Objs.TitleParts or {}) do
                if Label.Parent then
                    Tween(Label, 0.2, {
                        TextTransparency = TargetTransparency,
                        TextColor3 = typeof(TextColorVal) == "Color3" and TextColorVal or Label.TextColor3,
                    }):Play()
                end
            end

            -- ikon inline di dalam judul ikut meredup/menyala bersama teksnya
            for _, Item in ipairs(Objs.TitleIcons or {}) do
                if Item.Label and Item.Label.Parent then
                    local IconProps = { ImageTransparency = TargetTransparency }
                    if Item.Tint and typeof(TextColorVal) == "Color3" then
                        IconProps.ImageColor3 = TextColorVal
                    end
                    Tween(Item.Label, 0.2, IconProps):Play()
                end
            end

            if Objs.IconLabel and Objs.IconLabel.Parent then
                local IconProps = { ImageTransparency = TargetTransparency }
                -- ikon lucide (monokrom) ikut warna teks; gambar/asset asli
                -- dibiarkan apa adanya supaya warnanya tidak hilang
                if Objs.Tint and typeof(TextColorVal) == "Color3" then
                    IconProps.ImageColor3 = TextColorVal
                end
                Tween(Objs.IconLabel, 0.2, IconProps):Play()
            end
        end
    end

    local function CreateButton(Option, Order)
        local Opt = ResolveOption(Option)
        if Opt.Title == "" then return nil end

        local ButtonFrame = New("TextButton", {
            Name = "Option",
            AutoButtonColor = false,
            Size = UDim2.new(0, 0, 0, Category.ButtonHeight),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text = "",
            Parent = MainFrame,
            LayoutOrder = Order or (#Category.Options + 1),
        })

        local Background = Creator.NewRoundFrame(Category.Radius, "Squircle", {
            Size = UDim2.new(1, 0, 1, 0),
            ThemeTag = { ImageColor3 = Category.InactiveTag },
            Name = "Background",
            Parent = ButtonFrame,
        }, {
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
            }),
            New("UIPadding", {
                PaddingLeft = UDim.new(0, Category.SidePadding),
                PaddingRight = UDim.new(0, Category.SidePadding),
            })
        })

        local IconObj, IconLabel
        local Tint = Opt.Tint
        if Tint == nil then Tint = Category.TintIcon end

        if Opt.Icon then
            local IconSize = Opt.IconSize or Category.IconSize
            local KeepAspect = Opt.KeepAspect
            if KeepAspect == nil then KeepAspect = Category.IconKeepAspect end

            -- auto: hanya ikon lucide (monokrom) yang diwarnai mengikuti theme,
            -- gambar/asset asli dibiarkan warna aslinya
            if Tint == nil then
                Tint = Creator.Icon(Opt.Icon) ~= nil
            end

            IconObj = Creator.Image(
                Opt.Icon,
                "CategoryIcon-" .. Opt.Key,
                0,
                Window and Window.Folder,
                "Icon",
                false,
                nil,
                nil,
                {
                    -- ikon tidak dipotong: perbandingan ukuran asli dipertahankan
                    ScaleType  = Opt.ScaleType or Category.IconScaleType,
                    KeepAspect = KeepAspect,
                    NativeSize = Opt.NativeSize,
                    ImageRectOffset = Opt.ImageRectOffset,
                    ImageRectSize = Opt.ImageRectSize,
                    Size       = UDim2.fromOffset(IconSize, IconSize),
                    OnNativeSize = Category.IconAutoWidth and function(NativeSize, Frame)
                        -- tinggi tetap sesuai IconSize, lebar mengikuti rasio asli
                        -- (jadi tidak ada bagian yang terpotong & tidak ada ruang kosong)
                        if not Frame or not Frame.Parent or NativeSize.Y <= 0 then return end
                        local Ratio = NativeSize.X / NativeSize.Y
                        Frame.Size = UDim2.fromOffset(math.max(1, math.floor(IconSize * Ratio + 0.5)), IconSize)
                    end or nil,
                }
            )
            IconObj.Name = "Icon"
            IconObj.BackgroundTransparency = 1
            -- selalu di depan judul, termasuk kalau judulnya dipecah jadi
            -- beberapa segmen ber-LayoutOrder karena memuat ikon inline
            IconObj.LayoutOrder = -1

            IconLabel = IconObj:FindFirstChildOfClass("ImageLabel")
            if IconLabel then
                IconLabel.ImageTransparency = Category.Transparency
            end
            IconObj.Parent = Background
        end

        local function CreateTitleLabel(Text, Order)
            return New("TextLabel", {
                Name = "Title",
                Text = Text,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                TextSize = Category.TextSize,
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.XY,
                ThemeTag = { TextColor3 = Category.TextTag },
                TextTransparency = Category.Transparency,
                LayoutOrder = Order,
                Parent = Background,
            })
        end

        local TitleParts = {}
        local TitleIcons = {}
        local TitleObj

        -- Judul boleh memuat ikon inline: "{swords} Auto Farm"
        local Segments = Creator.HasInlineIcons(Opt.Title)
            and Creator.ParseInlineText(Opt.Title, {
                Icon = Opt.Icon,
                IconSize = Opt.IconSize or Category.IconSize,
            })
            or nil

        local HasInlineIcon = false
        for _, Segment in ipairs(Segments or {}) do
            if Segment.Type == "Icon" then
                HasInlineIcon = true
                break
            end
        end

        if HasInlineIcon then
            for Index, Segment in ipairs(Segments) do
                if Segment.Type == "Text" then
                    local Label = CreateTitleLabel(Segment.Content, Index)
                    table.insert(TitleParts, Label)
                    TitleObj = TitleObj or Label
                else
                    local InlineFrame, InlineLabel = Creator.InlineIconFrame(Segment, {
                        Icon             = Opt.Icon,
                        IconSize         = Opt.IconSize or Category.IconSize,
                        IconScaleType    = Opt.ScaleType or Category.IconScaleType,
                        IconKeepAspect   = Opt.KeepAspect,
                        IconTransparency = Category.Transparency,
                        Folder           = Window and Window.Folder,
                        ImageKind        = "Icon",
                        ThemeTagName     = Category.TextTag,
                        CachePrefix      = "CategoryInline",
                        Index            = Index,
                    })
                    if InlineFrame then
                        InlineFrame.LayoutOrder = Index
                        InlineFrame.Parent = Background
                        table.insert(TitleIcons, {
                            Frame = InlineFrame,
                            Label = InlineLabel,
                            -- ikon lucide ikut warna teks, gambar asli tidak
                            Tint = (Segment.Options and Segment.Options.Color) == nil
                                and Creator.Icon(Segment.Content) ~= nil,
                        })
                    end
                end
            end
        else
            TitleObj = CreateTitleLabel(Opt.Title)
            table.insert(TitleParts, TitleObj)
        end

        ButtonObjects[Opt.Key] = {
            Frame = ButtonFrame,
            Background = Background,
            Title = TitleObj,
            TitleParts = TitleParts,
            TitleIcons = TitleIcons,
            Icon = IconObj,
            IconLabel = IconLabel,
            Tint = Tint,
            Option = Opt,
        }

        Creator.AddSignal(ButtonFrame.MouseButton1Click, function()
            -- klik ini cuma akhir dari drag strip: kategori jangan diganti
            if DidDrag then return end
            Category:Select(Opt.Key)
        end)

        return Opt
    end

    -- =====================================================
    -- [ API ]
    -- =====================================================

    local function ApplyVisibility(SelectedName)
        for Name, Elements in pairs(Category.Registry) do
            local Visible = (Name == SelectedName)
            for _, Item in ipairs(Elements) do
                local Frame = ResolveElementFrame(Item)
                if Frame then
                    Frame.Visible = Visible
                end
            end
        end
    end

    function Category:Select(Name, Silent)
        if Name == nil then return Category end
        Name = NormalizeName(Name)

        Category.Value = Name
        Category.Selected = Name

        UpdateVisuals(Name)
        ApplyVisibility(Name)

        if not Silent and Category.Callback then
            local Ok, Err = pcall(Category.Callback, Name)
            if not Ok then
                warn("[ ANUI.Category ] Callback error: " .. tostring(Err))
            end
        end

        return Category
    end
    Category.SetValue = Category.Select

    function Category:GetSelected()
        return Category.Value
    end

    function Category:SetCallback(Callback)
        Category.Callback = Callback or function() end
        return Category
    end

    -- Daftarkan elemen ke sebuah kategori. Bisa banyak sekaligus:
    --   Category:Add("Automation", toggleA, toggleB)
    --   Category:Add("Automation", { toggleA, toggleB })
    function Category:Add(Name, ...)
        if Name == nil then return nil end
        Name = NormalizeName(Name)

        local List = Category.Registry[Name]
        if not List then
            List = {}
            Category.Registry[Name] = List
        end

        local First
        for Index = 1, select("#", ...) do
            local Item = select(Index, ...)
            if type(Item) == "table" and rawget(Item, "__type") == nil and #Item > 0 then
                for _, Sub in ipairs(Item) do
                    local Added = Category:Add(Name, Sub)
                    First = First or Added
                end
            elseif Item ~= nil then
                local Owner = Category.Owners[Item]
                if Owner ~= Name then
                    if Owner then
                        Category:Remove(Item)
                    end
                    table.insert(List, Item)
                    Category.Owners[Item] = Name
                end
                local Frame = ResolveElementFrame(Item)
                if Frame then
                    Frame.Visible = (Name == Category.Value)
                end
                First = First or Item
            end
        end

        return First
    end

    function Category:Remove(Item)
        local Name = Item and Category.Owners[Item]
        if not Name then return false end

        local List = Category.Registry[Name]
        if List then
            for Index, Value in ipairs(List) do
                if Value == Item then
                    table.remove(List, Index)
                    break
                end
            end
        end
        Category.Owners[Item] = nil
        return true
    end

    function Category:GetElements(Name)
        if Name == nil then return Category.Registry end
        return Category.Registry[NormalizeName(Name)] or {}
    end

    function Category:Refresh()
        ApplyVisibility(Category.Value)
        return Category
    end

    -- Tangkap otomatis elemen yang dibuat setelah ini, tanpa Add() satu-satu:
    --   Category:Capture("Automation")
    --   Tab:Toggle({...}) ; Tab:Toggle({...})
    --   Category:StopCapture()
    function Category:Capture(Name)
        Category.CaptureTarget = Name and NormalizeName(Name) or nil
        return Category
    end

    function Category:StopCapture()
        Category.CaptureTarget = nil
        return Category
    end

    -- Versi terbungkus: Category:With("Automation", function() Tab:Toggle({...}) end)
    function Category:With(Name, Builder)
        local Previous = Category.CaptureTarget
        Category:Capture(Name)

        local Ok, Err
        if type(Builder) == "function" then
            Ok, Err = pcall(Builder, function(...)
                return Category:Add(Name, ...)
            end)
        end

        Category.CaptureTarget = Previous
        if Ok == false then
            warn("[ ANUI.Category ] With('" .. tostring(Name) .. "') error: " .. tostring(Err))
        end
        return Category
    end

    function Category:AddOption(Option, Order)
        local Opt = CreateButton(Option, Order)
        if Opt then
            table.insert(Category.Options, Opt.Raw)
            if Category.Value == nil then
                Category:Select(Opt.Key, true)
            end
        end
        return Category
    end

    function Category:RemoveOption(Name)
        Name = NormalizeName(Name)
        local Objs = ButtonObjects[Name]
        if Objs then
            Objs.Frame:Destroy()
            ButtonObjects[Name] = nil
        end
        for Index, Option in ipairs(Category.Options) do
            local Opt = ResolveOption(Option)
            if Opt.Key == Name then
                table.remove(Category.Options, Index)
                break
            end
        end
        Category.Registry[Name] = nil
        return Category
    end

    function Category:SetOptions(Options, NewDefault)
        for Name, Objs in pairs(ButtonObjects) do
            Objs.Frame:Destroy()
            ButtonObjects[Name] = nil
        end
        Category.Options = {}
        Category.Value = nil

        for Index, Option in ipairs(Options or {}) do
            local Opt = CreateButton(Option, Index)
            if Opt then
                table.insert(Category.Options, Option)
            end
        end

        local Default = NewDefault or Category.Default
        if Default and ButtonObjects[NormalizeName(Default)] then
            Category:Select(Default, true)
        elseif Category.Options[1] then
            Category:Select(ResolveOption(Category.Options[1]).Key, true)
        end

        return Category
    end

    function Category:GetOptions()
        return Category.Options
    end

    function Category:SetHeight(Height)
        Category.Height = Height
        if Header then
            Header:SetHeight(Height)
        else
            WrapperFrame.Size = UDim2.new(1, 0, 0, Height)
        end
        return Category
    end

    function Category:Destroy()
        Category:StopCapture()
        Category.Registry = {}
        Category.Owners = {}

        -- Dibuang saat kursor masih di atas strip tidak mengirim MouseLeave, jadi
        -- kunci scroll konten tab dilepas di sini juga.
        Category.ReleasePageScroll()

        -- lepas hook auto-capture supaya tidak menggantung setelah dihapus
        if Tab and Category.CaptureHook and rawget(Tab, "__OnElementCreated") == Category.CaptureHook then
            Tab.__OnElementCreated = Category.PreviousHook
        end

        if Header then
            Header:Release()
        end
        WrapperFrame:Destroy()
    end

    -- =====================================================
    -- [ INISIALISASI ]
    -- =====================================================
    for Index, Option in ipairs(Config.Options or {}) do
        local Opt = CreateButton(Option, Index)
        if Opt then
            table.insert(Category.Options, Option)
        end
    end

    -- Hook auto-capture (elemen yang dibuat lewat Tab setelah Category ini)
    if Tab and Category.AutoCapture then
        local PreviousHook = rawget(Tab, "__OnElementCreated")
        local CaptureHook
        CaptureHook = function(Content, ElementConfig, Owner)
            if PreviousHook then
                pcall(PreviousHook, Content, ElementConfig, Owner)
            end
            if Category.CaptureTarget
                and Content ~= Category
                and ElementConfig and ElementConfig.Parent == Config.Parent then
                Category:Add(Category.CaptureTarget, Content)
            end
        end

        Category.PreviousHook = PreviousHook
        Category.CaptureHook = CaptureHook
        Tab.__OnElementCreated = CaptureHook
    end

    local Default = Category.Default
    if Default == nil and Config.Options and Config.Options[1] then
        Default = ResolveOption(Config.Options[1]).Key
    end
    if Default ~= nil then
        -- silent: callback tidak ditembak saat pembuatan
        Category:Select(Default, true)
    end

    return Category.__type, Category
end

return Element
