-- Button kecil yang hidup DI DALAM baris teks (Title/Desc sebuah elemen).
--
-- Dipakai oleh components/window/Element.lua untuk token "{button:key}" dan tag
-- "<button=key>Label</button>", sehingga sebuah Desc bisa memuat kontrol yang
-- punya Callback sendiri:
--
--     Desc = "Klik di sebelah kanan ini untuk sell <button=sell>Sell</button>"
--
-- Bentuknya mengikuti components/ui/Button.lua tapi jauh lebih ringkas (tanpa
-- shadow & gradient outline) supaya proporsional dengan teks Desc.
--
-- Susunan instance-nya sengaja dua tingkat:
--
--     ImageButton "InlineButton"      <- root, TANPA layout, AutomaticSize X
--     |-- Background   (Squircle, 1x1)
--     |-- Overlay      (Squircle, 1x1)      efek hover/tekan
--     |-- Outline      (Squircle-Outline)   hanya variant Secondary
--     `-- Content      (offset, AutomaticSize X)
--         |-- UIPadding + UIListLayout
--         |-- IconHolder
--         `-- Title
--
-- Layer 1x1 TIDAK boleh jadi anak dari frame yang memuat UIListLayout, karena
-- UIListLayout mengatur semua anak langsung dan layer-nya akan ikut dihitung
-- sebagai item (lebar tombol jadi salah). Karena itu lebar diambil dari
-- "Content" yang berukuran offset, sedangkan layer-nya mengikuti root.

local InlineButton = {}

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

-- Ukuran default: sedikit lebih kecil dari teks Desc (TextSize 15) supaya
-- tingginya tidak mendorong tinggi baris.
local DEFAULTS = {
    Height = 22,
    TextSize = 13,
    IconSize = 14,
    Padding = 8,
    Gap = 5,
    Radius = 999,
}

-- Transparansi background & lapisan hover per variant.
-- "Primary" = pill solid berwarna theme Button; sisanya lebih kalem.
local VARIANTS = {
    Primary   = { Background = 0,    Outline = 1,   Overlay = 0.85 },
    Secondary = { Background = 0.9,  Outline = 0.8, Overlay = 0.92 },
    Ghost     = { Background = 1,    Outline = 1,   Overlay = 0.9 },
}

local function ResolveVariant(Name)
    if type(Name) == "string" and Name ~= "" then
        local Key = string.upper(string.sub(Name, 1, 1)) .. string.lower(string.sub(Name, 2))
        local Spec = VARIANTS[Key]
        if Spec then return Key, Spec end
    end
    return "Primary", VARIANTS.Primary
end

-- Warna bisa ditulis Color3 atau hex ("#e11d48"/"e11d48"), bentuk yang sama
-- dengan atribut <gradient=...> supaya penulisannya konsisten.
local function ToColor3(Value)
    if typeof(Value) == "Color3" then
        return Value
    elseif type(Value) == "string" and Value ~= "" then
        local Named = Creator.Colors[Value]
        local Ok, Color = pcall(Color3.fromHex, (string.gsub(Named or Value, "^#", "")))
        if Ok then return Color end
    end
    return nil
end

local function NumberOr(Value, Fallback)
    local Number = tonumber(Value)
    if Number == nil then return Fallback end
    return Number
end

-- ThemeTag kosong tetap mendaftarkan objek ke sistem theme tanpa guna, jadi
-- dibuat nil kalau tidak ada tag yang dipakai.
local function ThemeTag(Property, Tag)
    if not Tag then return nil end
    return { [Property] = Tag }
end

-- Nama atribut yang boleh ditulis di dalam tag/token, mis.
--   <button=sell variant=Ghost text="Sell All" size=24>Sell</button>
local ATTR_ALIASES = {
    text = "Title", title = "Title", label = "Title",
    icon = "Icon",
    variant = "Variant", style = "Variant",
    color = "Color", colour = "Color", bg = "Color",
    textcolor = "TextColor", fg = "TextColor",
    size = "Height", h = "Height", height = "Height",
    w = "Width", width = "Width",
    radius = "Radius", r = "Radius",
    textsize = "TextSize", ts = "TextSize",
    iconsize = "IconSize",
    padding = "Padding", pad = "Padding",
    locked = "Locked", disabled = "Locked",
}

local NUMBER_ATTRS = {
    Height = true, Width = true, Radius = true,
    TextSize = true, IconSize = true, Padding = true,
}

local BOOL_WORDS = {
    ["true"] = true, ["1"] = true, ["yes"] = true, ["on"] = true,
    ["false"] = false, ["0"] = false, ["no"] = false, ["off"] = false,
}

-- Atribut mentah (semuanya string, hasil Creator.ParseInlineAttrs) -> field Spec
-- yang sudah bertipe. Atribut yang tidak dikenali diabaikan, bukan bikin error.
function InlineButton.NormalizeAttrs(Attrs)
    local Out = {}
    if type(Attrs) ~= "table" then return Out end

    for RawKey, RawValue in pairs(Attrs) do
        local Name = ATTR_ALIASES[string.lower(tostring(RawKey))]
        if Name then
            if NUMBER_ATTRS[Name] then
                local Number = tonumber(RawValue)
                if Number then Out[Name] = Number end
            elseif Name == "Locked" then
                local Bool = BOOL_WORDS[string.lower(tostring(RawValue))]
                Out[Name] = (Bool == nil) and true or Bool
            elseif Name == "Color" or Name == "TextColor" then
                local Color = ToColor3(RawValue)
                if Color then Out[Name] = Color end
            else
                Out[Name] = RawValue
            end
        end
    end

    return Out
end

-- Spec: { Key, Title, Icon, Variant, Color, TextColor, Height, Width, Radius,
--         TextSize, IconSize, Padding, Locked, Callback }
-- Context: { Folder, OnPress, OnHoverChanged, Index }
--
-- Balik Frame, Api. Balik nil kalau Spec tidak sah, mengikuti pola
-- Creator.InlineIconFrame supaya pemanggil tidak menyisakan kotak kosong.
function InlineButton.New(Spec, Context)
    if type(Spec) ~= "table" then return nil end

    Context = Context or {}

    local VariantName, VariantSpec = ResolveVariant(Spec.Variant)
    local CustomColor = ToColor3(Spec.Color)

    local Height = NumberOr(Spec.Height, DEFAULTS.Height)
    local Radius = NumberOr(Spec.Radius, DEFAULTS.Radius)
    local Padding = NumberOr(Spec.Padding, DEFAULTS.Padding)
    local TextSize = NumberOr(Spec.TextSize, DEFAULTS.TextSize)
    local IconSize = NumberOr(Spec.IconSize, DEFAULTS.IconSize)
    local Width = NumberOr(Spec.Width, nil)

    -- Warna teks: eksplisit > auto-kontras di atas Color custom > putih untuk
    -- pill solid > ikut theme.
    local ForcedTextColor = ToColor3(Spec.TextColor)
        or (CustomColor and Creator.GetContrastTextColor(CustomColor))
        or (VariantName == "Primary" and Color3.new(1, 1, 1))
        or nil

    -- ===== Konten =====

    local IconHolder = New("Frame", {
        Name = "IconHolder",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, IconSize, 0, IconSize),
        Visible = false,
        LayoutOrder = 1,
    })

    local Title = New("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Text = tostring(Spec.Title or "Button"),
        TextSize = TextSize,
        AutomaticSize = "XY",
        Size = UDim2.new(0, 0, 0, 0),
        FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
        TextColor3 = ForcedTextColor or nil,
        ThemeTag = ThemeTag("TextColor3", (not ForcedTextColor) and "Text" or nil),
        LayoutOrder = 2,
    })

    -- Lebar tombol berasal dari sini (offset), bukan dari layer 1x1 di bawah
    local Content = New("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = "X",
        ZIndex = 4,
    }, {
        New("UIPadding", {
            PaddingLeft = UDim.new(0, Padding),
            PaddingRight = UDim.new(0, Padding),
        }),
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, DEFAULTS.Gap),
        }),
        IconHolder,
        Title,
    })

    -- ===== Layer =====

    local Background, BackgroundTable = Creator.NewRoundFrame(Radius, "Squircle", {
        Name = "Background",
        Size = UDim2.new(1, 0, 1, 0),
        Active = false,
        ImageTransparency = VariantSpec.Background,
        ImageColor3 = CustomColor or nil,
        ThemeTag = ThemeTag(
            "ImageColor3",
            (not CustomColor) and (VariantName == "Primary" and "Button" or "Text") or nil
        ),
        ZIndex = 1,
    }, nil, nil, true)

    local Overlay, OverlayTable = Creator.NewRoundFrame(Radius, "Squircle", {
        Name = "Overlay",
        Size = UDim2.new(1, 0, 1, 0),
        Active = false,
        ImageTransparency = 1,
        ThemeTag = ThemeTag("ImageColor3", "Text"),
        ZIndex = 2,
    }, nil, nil, true)

    local Outline, OutlineTable = Creator.NewRoundFrame(Radius, "Squircle-Outline", {
        Name = "Outline",
        Size = UDim2.new(1, 0, 1, 0),
        Active = false,
        ImageTransparency = VariantSpec.Outline,
        ImageColor3 = CustomColor and Color3.new(1, 1, 1) or nil,
        ThemeTag = ThemeTag("ImageColor3", (not CustomColor) and "Outline" or nil),
        ZIndex = 3,
    }, nil, nil, true)

    -- Root sengaja ImageButton polos (tanpa Image) supaya seluruh kotaknya bisa
    -- diklik sementara tampilannya sepenuhnya digambar oleh layer di dalamnya.
    local Root = New("ImageButton", {
        Name = "InlineButton",
        BackgroundTransparency = 1,
        Image = "",
        AutoButtonColor = false,
        Size = Width and UDim2.new(0, Width, 0, Height) or UDim2.new(0, 0, 0, Height),
        AutomaticSize = Width and Enum.AutomaticSize.None or Enum.AutomaticSize.X,
    }, {
        Background,
        Overlay,
        Outline,
        Content,
    })

    local State = {
        Callback = Spec.Callback,
        Locked = Spec.Locked and true or false,
        Hovering = false,
        Icon = Spec.Icon,
        LastPress = 0,
    }

    local Api = {
        Instance = Root,
        Key = Spec.Key,
    }

    -- ===== Ikon =====

    local function ClearIcon()
        for _, Child in ipairs(IconHolder:GetChildren()) do
            if Child:IsA("GuiObject") then
                Child:Destroy()
            end
        end
        IconHolder.Visible = false
    end

    local function BuildIcon(Source, Size)
        ClearIcon()
        if not Source or Source == "" then return end
        if not Creator.IsImageSource(Source) then return end

        Size = NumberOr(Size, IconSize)

        -- Ikon lucide (monokrom) ikut warna teks; gambar asli dibiarkan apa adanya
        local IsLucide = Creator.TryIcon(Source) ~= nil
        local Themed = IsLucide and not ForcedTextColor

        local Frame = Creator.Image(
            Source,
            Creator.InlineIconCacheName(Source, Context.Index or Spec.Key or 1, "InlineButton"),
            0,
            Context.Folder,
            "Icon",
            Themed,
            Themed,
            "Text",
            { Size = UDim2.fromOffset(Size, Size) }
        )
        if not Frame then return end

        Frame.Size = UDim2.fromOffset(Size, Size)
        Frame.BackgroundTransparency = 1
        Frame.Parent = IconHolder

        local Label = Frame:FindFirstChildOfClass("ImageLabel")
        if Label and ForcedTextColor and IsLucide then
            -- lepas dari theme supaya warnanya tidak ditimpa saat ganti tema
            Creator.Objects[Label] = nil
            Label.ImageColor3 = ForcedTextColor
        end

        IconHolder.Size = UDim2.new(0, Size, 0, Size)
        IconHolder.Visible = true
    end

    BuildIcon(State.Icon, IconSize)

    -- ===== Tampilan terkunci =====

    local function ApplyLockedLook()
        Title.TextTransparency = State.Locked and 0.4 or 0
        Background.ImageTransparency = State.Locked
            and math.min(1, VariantSpec.Background + 0.35)
            or VariantSpec.Background

        local IconLabel = IconHolder:FindFirstChildWhichIsA("ImageLabel", true)
        if IconLabel then
            IconLabel.ImageTransparency = State.Locked and 0.4 or 0
        end
    end

    ApplyLockedLook()

    -- ===== Interaksi =====

    local function SetHover(Value)
        if State.Hovering == Value then return end
        State.Hovering = Value

        Tween(Overlay, 0.08, {
            ImageTransparency = (Value and not State.Locked) and VariantSpec.Overlay or 1,
        }):Play()

        if type(Context.OnHoverChanged) == "function" then
            Context.OnHoverChanged(Value, Api)
        end
    end

    -- Dipanggil setiap kali tombol disentuh/ditekan, terkunci atau tidak, supaya
    -- elemen induk tahu klik ini bukan miliknya.
    local function NotifyPress()
        State.LastPress = os.clock()
        if type(Context.OnPress) == "function" then
            Context.OnPress(Api)
        end
    end

    Creator.AddSignal(Root.MouseEnter, function()
        SetHover(true)
    end)
    Creator.AddSignal(Root.MouseLeave, function()
        SetHover(false)
    end)

    -- Sentuhan tidak memicu MouseEnter/MouseLeave, jadi jalur input dipakai juga
    -- supaya guard "sedang menyentuh button" tetap jalan di HP.
    Creator.AddSignal(Root.InputBegan, function(Input)
        if Input.UserInputType == Enum.UserInputType.Touch then
            SetHover(true)
        end
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then
            NotifyPress()
        end
    end)
    Creator.AddSignal(Root.InputEnded, function(Input)
        if Input.UserInputType == Enum.UserInputType.Touch then
            SetHover(false)
        end
    end)

    Creator.AddSignal(Root.MouseButton1Click, function()
        NotifyPress()
        if State.Locked then return end

        local Callback = State.Callback
        if type(Callback) ~= "function" then return end

        task.spawn(function()
            Creator.SafeCallback(Callback, Api)
        end)
    end)

    -- ===== API =====

    function Api:SetTitle(Text)
        Title.Text = tostring(Text or "")
    end

    function Api:SetIcon(Source, Size)
        State.Icon = Source
        BuildIcon(Source, Size)
        ApplyLockedLook()
    end

    function Api:SetCallback(Callback)
        State.Callback = Callback
    end

    function Api:Lock()
        if State.Locked then return end
        State.Locked = true
        SetHover(false)
        Overlay.ImageTransparency = 1
        ApplyLockedLook()
    end

    function Api:Unlock()
        if not State.Locked then return end
        State.Locked = false
        ApplyLockedLook()
    end

    function Api:IsLocked()
        return State.Locked
    end

    function Api:IsHovering()
        return State.Hovering
    end

    function Api:LastPressAt()
        return State.LastPress
    end

    function Api:SetRadius(NewRadius)
        BackgroundTable:SetRadius(NewRadius)
        OverlayTable:SetRadius(NewRadius)
        OutlineTable:SetRadius(NewRadius)
    end

    -- Perubahan yang tidak mengubah bentuk instance (teks/ikon/callback/locked),
    -- supaya Element bisa memakai ulang instance yang sama saat Desc di-update.
    function Api:Update(NewSpec)
        if type(NewSpec) ~= "table" then return end

        if NewSpec.Key ~= nil then
            Api.Key = NewSpec.Key
        end

        Api:SetTitle(NewSpec.Title or "Button")
        State.Callback = NewSpec.Callback

        if NewSpec.Icon ~= State.Icon then
            Api:SetIcon(NewSpec.Icon, NumberOr(NewSpec.IconSize, IconSize))
        end

        if NewSpec.Locked then
            Api:Lock()
        else
            Api:Unlock()
        end
    end

    function Api:Destroy()
        Root:Destroy()
    end

    return Root, Api
end

return InlineButton
