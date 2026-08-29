local Creator = require("../../modules/Creator")
local New = Creator.New
local NewRoundFrame = Creator.NewRoundFrame
local Tween = Creator.Tween

local InlineButton = require("../ui/InlineButton")

local cloneref = (cloneref or clonereference or function(instance) return instance end)

local function Color3ToHSB(color)
    local r, g, b = color.R, color.G, color.B
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local delta = max - min

    local h = 0
    if delta ~= 0 then
        if max == r then
            h = (g - b) / delta % 6
        elseif max == g then
            h = (b - r) / delta + 2
        else
            h = (r - g) / delta + 4
        end
        h = h * 60
    else
        h = 0
    end

    local s = (max == 0) and 0 or (delta / max)
    local v = max

    return {
        h = math.floor(h + 0.5),
        s = s,
        b = v
    }
end

local function GetPerceivedBrightness(color)
    local r = color.R
    local g = color.G
    local b = color.B
    return 0.299 * r + 0.587 * g + 0.114 * b
end

local function GetTextColorForHSB(color)
    local hsb = Color3ToHSB(color)
    local h, s, b = hsb.h, hsb.s, hsb.b
    if GetPerceivedBrightness(color) > 0.5 then
        return Color3.fromHSV(h / 360, 0, 0.05)
    else
        return Color3.fromHSV(h / 360, 0, 0.98)
    end
end

-- Warna bisa ditulis sebagai Color3 atau hex ("#FF3CAC"/"FF3CAC"), bentuk yang
-- sama dengan tag <gradient=...>, jadi keduanya boleh dicampur dalam satu list.
local function ToColor3(value)
    if typeof(value) == "Color3" then
        return value
    elseif type(value) == "string" then
        local ok, color = pcall(Color3.fromHex, value)
        if ok and color then
            return color
        end
    end
    return nil
end

-- ColorSequence dibatasi 20 keypoint oleh Roblox; lebih dari itu error.
local MAX_GRADIENT_KEYPOINTS = 20

-- Mengubah daftar warna menjadi ColorSequence (rata untuk setiap titik).
-- Balik nil kalau tidak ada warna yang sah, supaya pemanggil bisa menganggap
-- gradient-nya tidak diset alih-alih ikut error.
local function ColorsToSequence(colors)
    if type(colors) ~= "table" then return nil end

    local list = {}
    for _, value in ipairs(colors) do
        local color = ToColor3(value)
        if color then
            table.insert(list, color)
        end
    end

    if #list == 0 then
        return nil
    elseif #list == 1 then
        return ColorSequence.new(list[1])
    end

    -- kelebihan warna diambil merata, bukan dipotong di ujung
    if #list > MAX_GRADIENT_KEYPOINTS then
        local trimmed = {}
        for i = 1, MAX_GRADIENT_KEYPOINTS do
            local index = 1 + math.floor(((i - 1) * (#list - 1)) / (MAX_GRADIENT_KEYPOINTS - 1) + 0.5)
            table.insert(trimmed, list[index])
        end
        list = trimmed
    end

    local keypoints = {}
    for i, color in ipairs(list) do
        table.insert(keypoints, ColorSequenceKeypoint.new((i - 1) / (#list - 1), color))
    end
    return ColorSequence.new(keypoints)
end

-- Properti UIGradient yang boleh diset dari config. Kunci lain diabaikan:
-- sebelumnya semua kunci string disalin apa adanya, jadi satu kunci salah
-- tulis (atau tipe keliru) langsung error dan elemennya gagal dibangun.
local GRADIENT_PROP_TYPES = {
    Color = "ColorSequence",
    Transparency = "NumberSequence",
    Rotation = "number",
    Offset = "Vector2",
    Enabled = "boolean",
}

local function CoerceGradientProp(Expected, Value)
    if typeof(Value) == Expected then
        return Value
    elseif Expected == "number" then
        return tonumber(Value)
    elseif Expected == "NumberSequence" and type(Value) == "number" then
        return NumberSequence.new(Value)
    elseif Expected == "Vector2" and type(Value) == "number" then
        return Vector2.new(Value, 0)
    end
    return nil
end

-- Diisi di bawah; dideklarasi di sini supaya ResolveGradientProps bisa
-- menerima bentuk string "FF3CAC,2B86C5|90" (sama seperti atribut tag)
local ParseGradientAttr

-- Menerima ColorSequence, Color3, string hex, atau table (list warna dan/atau
-- { Color = ..., Rotation = ..., dst }) dan mengembalikan properti siap-pakai
-- untuk Instance "UIGradient". Balik nil kalau tidak ada warna yang sah.
local function ResolveGradientProps(Gradient)
    if not Gradient then return nil end

    if typeof(Gradient) == "ColorSequence" then
        return { Color = Gradient }
    elseif typeof(Gradient) == "Color3" then
        return { Color = ColorSequence.new(Gradient) }
    elseif type(Gradient) == "string" then
        return ParseGradientAttr(Gradient)
    elseif typeof(Gradient) ~= "table" then
        return nil
    end

    -- Sumber warna: Color / Colors, atau langsung bagian array-nya
    local Source = Gradient.Color
    if Source == nil then Source = Gradient.Colors end
    if Source == nil and #Gradient > 0 then Source = Gradient end

    local ColorSeq
    if typeof(Source) == "ColorSequence" then
        ColorSeq = Source
    elseif Source ~= nil then
        local Single = ToColor3(Source)
        if Single then
            ColorSeq = ColorSequence.new(Single)
        else
            ColorSeq = ColorsToSequence(Source)
        end
    end

    if not ColorSeq then return nil end

    local Props = { Color = ColorSeq }
    for Key, Value in pairs(Gradient) do
        local Expected = Key ~= "Color" and GRADIENT_PROP_TYPES[Key]
        if Expected then
            local Coerced = CoerceGradientProp(Expected, Value)
            if Coerced ~= nil then
                Props[Key] = Coerced
            end
        end
    end

    return Props
end

local GRADIENT_TAG_PLAIN = "<gradient>"
local GRADIENT_TAG_CLOSE = "</gradient>"

local BUTTON_TAG_PLAIN = "<button>"
local BUTTON_TAG_CLOSE = "</button>"

-- Teks memakai tag <gradient> atau tidak. Dipakai untuk dua hal:
--   1. teks bertag WAJIB lewat jalur banyak-TextLabel, kalau tidak tag-nya
--      ikut tampil mentah di layar;
--   2. menentukan default segmen: tanpa tag = seluruh teks ikut gradient
--      elemen, ada tag = hanya bagian di dalam tag yang gradient.
local function HasGradientTag(str)
    if type(str) ~= "string" or str == "" then return false end
    return string.find(str, GRADIENT_TAG_PLAIN, 1, true) ~= nil
        or string.find(str, "<gradient=", 1, true) ~= nil
        or string.find(str, GRADIENT_TAG_CLOSE, 1, true) ~= nil
end

-- Teks memuat tag <button ...>...</button>. Sama seperti gradient, teks bertag
-- harus lewat jalur banyak-item supaya tag-nya tidak tampil mentah.
local function HasButtonTag(str)
    if type(str) ~= "string" or str == "" then return false end
    return string.find(str, BUTTON_TAG_PLAIN, 1, true) ~= nil
        or string.find(str, "<button=", 1, true) ~= nil
        or string.find(str, "<button ", 1, true) ~= nil
end

-- Teks memuat button dalam bentuk apa pun (tag atau token "{button}")
local function HasAnyButton(str)
    return HasButtonTag(str) or Creator.HasInlineButtons(str)
end

-- Parse atribut tag, contoh: "FF3CAC,784BA0,2B86C5" atau "FF3CAC,2B86C5|90" (|rotasi opsional)
-- Mengembalikan gradient props {Color = ColorSequence, Rotation = number?} atau nil kalau tidak valid
ParseGradientAttr = function(attr)
    if type(attr) ~= "string" or attr == "" then return nil end

    local colorPart, rotationPart = attr, nil
    local barPos = string.find(attr, "|", 1, true)
    if barPos then
        colorPart = string.sub(attr, 1, barPos - 1)
        rotationPart = string.sub(attr, barPos + 1)
    end

    local colors = {}
    for hex in string.gmatch(colorPart, "[^,]+") do
        hex = hex:match("^%s*(.-)%s*$")
        if hex ~= "" then
            table.insert(colors, hex)
        end
    end

    local ColorSeq = ColorsToSequence(colors)
    if not ColorSeq then return nil end

    local props = { Color = ColorSeq }
    if rotationPart then
        local rotationNum = tonumber(rotationPart)
        if rotationNum then
            props.Rotation = rotationNum
        end
    end

    return props
end

-- Memecah teks menjadi beberapa segmen: teks biasa, gambar (rbxassetid://),
-- ikon inline token "{...}", dan teks yang ditandai tag gradient (agar hanya
-- sebagian teks yang gradient).
-- Mendukung dua bentuk tag gradient:
--   <gradient>...</gradient>              -> pakai TitleGradient/DescGradient milik elemen
--   <gradient=HEX1,HEX2,...>...</gradient> -> gradient custom miliknya sendiri (bisa beda-beda per tag)
-- Ikon inline (lihat Creator.ParseInlineText):
--   "{icon} Auto {icon} Farm"   -> "{icon}" ambil dari Config.Icon/Config.Image
--   "{swords} A {rocket} B"     -> sebut nama sendiri, boleh URL/rbxassetid
--   "{icon:star size=28}"       -> atribut per token
-- TagAware: teks memakai tag <gradient> atau tidak (default: dihitung sendiri).
-- Dikirim eksplisit oleh Desc supaya semua baris & kolomnya sepakat.
local function ParseTextSegments(str, Context, TagAware)
    local Segments = {}
    local pos = 1
    local length = #str

    if TagAware == nil then
        TagAware = HasGradientTag(str)
    end

    -- false = warna normal, true = pakai gradient elemen, table = gradient custom.
    -- Tanpa tag sama sekali, seluruh teks ikut gradient elemen (TitleGradient/
    -- DescGradient) seperti judul biasa; begitu ada tag, teks di luar tag
    -- dipaksa warna normal.
    local CurrentGradient = true
    if TagAware then
        CurrentGradient = false
    end

    -- Token ikon dipecah lebih dulu oleh Creator supaya aturannya sama di
    -- semua elemen; hasil teksnya lalu diproses lagi untuk tag gradient.
    -- Context nil = ikon inline dimatikan, token dibiarkan mentah.
    local function PushTextWithIcons(Text)
        if Text == "" then return end

        if not Context or not Creator.HasInlineIcons(Text) then
            table.insert(Segments, {Type = "Text", Content = Text, Gradient = CurrentGradient})
            return
        end

        for _, Part in ipairs(Creator.ParseInlineText(Text, Context)) do
            if Part.Type == "Icon" then
                table.insert(Segments, {
                    Type = "Icon",
                    Content = Part.Content,
                    Options = Part.Options,
                })
            elseif Part.Type == "Button" then
                -- token "{button:key}"; label & sisanya diambil dari
                -- Element.Buttons oleh pemanggil
                table.insert(Segments, {
                    Type = "Button",
                    Key = Part.Key,
                    Attrs = Part.Attrs,
                })
            elseif Part.Content ~= "" then
                table.insert(Segments, {Type = "Text", Content = Part.Content, Gradient = CurrentGradient})
            end
        end
    end

    -- Isi tag "<button=key attr=...>Label</button>" -> key + atribut + label
    local function ParseButtonTagHead(attr)
        if type(attr) ~= "string" or attr == "" then
            return nil, {}
        end

        -- kata pertama adalah key, kecuali kalau ternyata sebuah atribut
        local _, headEnd, head = string.find(attr, "^%s*(%S*)")
        if head and head ~= "" and not string.find(head, "=", 1, true) then
            return head, Creator.ParseInlineAttrs(string.sub(attr, (headEnd or 0) + 1))
        end

        return nil, Creator.ParseInlineAttrs(attr)
    end

    while pos <= length do
        local imgS, imgE = string.find(str, "rbxassetid://%d+", pos)
        local plainS, plainE = string.find(str, GRADIENT_TAG_PLAIN, pos, true)
        local attrS, attrE, attrCapture = string.find(str, "<gradient=([^>]*)>", pos)
        local closeS, closeE = string.find(str, GRADIENT_TAG_CLOSE, pos, true)
        local btnPlainS, btnPlainE = string.find(str, BUTTON_TAG_PLAIN, pos, true)
        local btnAttrS, btnAttrE, btnAttrCapture = string.find(str, "<button[ =]([^>]*)>", pos)

        local nextS, nextE, kind, attrVal
        for _, candidate in ipairs({
            {s = imgS, e = imgE, k = "Image"},
            {s = plainS, e = plainE, k = "OpenPlain"},
            {s = attrS, e = attrE, k = "OpenAttr", attr = attrCapture},
            {s = closeS, e = closeE, k = "Close"},
            {s = btnPlainS, e = btnPlainE, k = "Button"},
            {s = btnAttrS, e = btnAttrE, k = "Button", attr = btnAttrCapture},
        }) do
            if candidate.s and (not nextS or candidate.s < nextS) then
                nextS, nextE, kind, attrVal = candidate.s, candidate.e, candidate.k, candidate.attr
            end
        end

        if not nextS then
            PushTextWithIcons(string.sub(str, pos))
            break
        end

        PushTextWithIcons(string.sub(str, pos, nextS - 1))

        -- Tag button memakan isinya sampai "</button>", jadi posisi lanjutnya
        -- tidak selalu tepat setelah tag pembuka.
        local nextPos = nextE + 1

        if kind == "Image" then
            table.insert(Segments, {Type = "Image", Content = string.sub(str, nextS, nextE)})
        elseif kind == "OpenPlain" then
            CurrentGradient = true
        elseif kind == "OpenAttr" then
            CurrentGradient = ParseGradientAttr(attrVal) or true
        elseif kind == "Close" then
            CurrentGradient = false
        elseif kind == "Button" then
            local closeAt, closeEnd = string.find(str, BUTTON_TAG_CLOSE, nextE + 1, true)
            local key, attrs = ParseButtonTagHead(attrVal)

            -- Label sebuah button hanya teks polos: tag/token lain di dalamnya
            -- dibuang supaya tidak tampil mentah di atas tombol.
            local label = string.sub(str, nextE + 1, (closeAt and closeAt - 1) or length)
            label = string.gsub(label, "</?gradient[^>]*>", "")
            label = string.match(label, "^%s*(.-)%s*$") or label

            table.insert(Segments, {
                Type = "Button",
                Key = key,
                Attrs = attrs,
                -- tag tanpa penutup: sisa teksnya dianggap label
                Label = label,
            })

            nextPos = (closeEnd or length) + 1
        end

        pos = nextPos
    end

    return Segments
end

-- Cek apakah teks butuh dipecah jadi beberapa TextLabel (ada gambar inline,
-- token ikon, tag gradient parsial, dan/atau button inline).
-- AllowInline false = token "{...}" diabaikan (dianggap teks biasa), tapi button
-- tetap dihitung karena bukan ikon.
local function HasRichTokens(str, AllowInline)
    if not str or str == "" then return false end
    return string.find(str, "rbxassetid://%d+") ~= nil
        or HasGradientTag(str)
        or HasAnyButton(str)
        or (AllowInline ~= false and Creator.HasInlineIcons(str))
end

-- Mengubah nilai Gradient sebuah segmen (false/true/table) menjadi UIGradient props final
local function ResolveItemGradientProps(GradientValue, ElementGradient)
    if typeof(GradientValue) == "table" then
        return ResolveGradientProps(GradientValue)
    elseif GradientValue ~= false then
        return ResolveGradientProps(ElementGradient)
    end
    return nil
end

-- Signature ringkas untuk membandingkan apakah gradient sebuah segmen berubah (dipakai untuk reuse instance)
local function GradientSignature(GradientValue)
    if GradientValue == false then
        return ""
    elseif GradientValue == nil or GradientValue == true then
        -- ikut gradient elemen; harus beda dari "" supaya segmen "warna normal"
        -- tidak tertukar dengan segmen "ikut gradient elemen"
        return "@default"
    elseif typeof(GradientValue) == "table" and GradientValue.Color then
        local parts = {}
        for _, kp in ipairs(GradientValue.Color.Keypoints) do
            table.insert(parts, string.format("%.3f:%s", kp.Time, kp.Value:ToHex()))
        end
        if GradientValue.Rotation then
            table.insert(parts, "R" .. tostring(GradientValue.Rotation))
        end
        return table.concat(parts, "|")
    end
    return ""
end

-- Cara memulihkan warna teks sebuah label saat gradient-nya dilepas. Tanpa ini
-- label tetap putih (TextColor3 dipaksa putih supaya gradient tampil murni).
-- Weak key: ikut terbuang sendiri saat label-nya di-Destroy.
local TextRestore = setmetatable({}, { __mode = "k" })

local function RestoreTextColor(Label)
    local Info = TextRestore[Label]
    if not Info then return end

    if Info.ThemeTag then
        -- daftar ulang ke sistem theme (AddThemeObject langsung menerapkan warnanya)
        Creator.AddThemeObject(Label, { TextColor3 = Info.ThemeTag })
    elseif Info.Color then
        Label.TextColor3 = Info.Color
    end
end

-- Menambah/memperbarui/menghapus UIGradient "TextGradient" pada sebuah TextLabel
local function ApplyGradientToLabel(Label, GradientProps)
    if not Label then return end

    local Existing = Label:FindFirstChild("TextGradient")

    if GradientProps then
        if not Existing then
            Existing = Instance.new("UIGradient")
            Existing.Name = "TextGradient"
            Existing.Parent = Label
        end

        -- Properti yang tidak dikirim dikembalikan ke bawaan, supaya sisa
        -- gradient sebelumnya (mis. Rotation/Offset) tidak nyangkut saat diganti
        Existing.Color = GradientProps.Color
        Existing.Rotation = GradientProps.Rotation or 0
        Existing.Offset = GradientProps.Offset or Vector2.new(0, 0)
        Existing.Transparency = GradientProps.Transparency or NumberSequence.new(0)
        Existing.Enabled = GradientProps.Enabled ~= false

        -- Sistem theme menulis ulang TextColor3 setiap ganti theme. Kalau label
        -- ini masih terdaftar, warna theme akan mengalikan warna gradient
        -- sehingga gradient-nya tampak kusam/hilang.
        Creator.Objects[Label] = nil
        Label.TextColor3 = Color3.new(1, 1, 1)
    elseif Existing then
        Existing:Destroy()
        RestoreTextColor(Label)
    end
end

local function getElementPosition(elements, targetIndex)
    if type(targetIndex) ~= "number" or targetIndex ~= math.floor(targetIndex) then
        return nil, 1
    end

    local maxIndex = #elements

    if maxIndex == 0 or targetIndex < 1 or targetIndex > maxIndex then
        return nil, 2
    end

    local function isDelimiter(el)
        if el == nil then return true end
        local t = el.__type
        return t == "Divider" or t == "Space" or t == "Section" or t == "Code" or t == "Paragraph"
    end

    if isDelimiter(elements[targetIndex]) then
        return nil, 3
    end

    local function calculate(pos, size)
        if size == 1 then return "Squircle" end
        if pos == 1 then return "Squircle-TL-TR" end
        if pos == size then return "Squircle-BL-BR" end
        return "Square"
    end

    local groupStart = 1
    local groupCount = 0

    for i = 1, maxIndex do
        local el = elements[i]
        if isDelimiter(el) then
            if targetIndex >= groupStart and targetIndex <= i - 1 then
                local pos = targetIndex - groupStart + 1
                return calculate(pos, groupCount)
            end
            groupStart = i + 1
            groupCount = 0
        else
            groupCount = groupCount + 1
        end
    end

    if targetIndex >= groupStart and targetIndex <= maxIndex then
        local pos = targetIndex - groupStart + 1
        return calculate(pos, groupCount)
    end

    return nil, 4
end

return function(Config)
    local Element = {
        Title = Config.Title,
        Desc = Config.Desc or nil,
        Hover = Config.Hover,
        Thumbnail = Config.Thumbnail,
        ThumbnailSize = Config.ThumbnailSize or 80,
        Image = Config.Image,
        IconThemed = Config.IconThemed or false,
        ImageSize = Config.ImageSize or 30,
        Color = Config.Color,
        TitleGradient = Config.TitleGradient,
        DescGradient = Config.DescGradient,
        Scalable = Config.Scalable,
        Parent = Config.Parent,
        Justify = Config.Justify or "Between",
        UIPadding = Config.Window.ElementConfig.UIPadding,
        UICorner = Config.Window.ElementConfig.UICorner,
        UIElements = {},
        DescColumnWidth = Config.DescColumnWidth,

        -- Button inline di dalam Title/Desc. Map key -> spec, atau array kalau
        -- token/tag-nya ditulis tanpa key.
        Buttons = Config.Buttons,

        Index = Config.Index
    }

    local ImageSize = Element.ImageSize
    local ThumbnailSize = Element.ThumbnailSize
    local CanHover = true
    local IconOffset = 0

    -- Konteks untuk ikon inline di dalam Title/Desc. Sumber "{icon}" diambil
    -- dari Config.Icon (kalau elemennya punya) atau Config.Image.
    local InlineIconSource = Config.Icon or Config.Image
    if typeof(InlineIconSource) ~= "string" and type(InlineIconSource) ~= "table" then
        InlineIconSource = nil
    end

    local function InlineContext(Type, Index)
        return {
            Icon         = InlineIconSource,
            IconSize     = Config.InlineIconSize or (Type == "Desc" and 16 or 18),
            IconThemed   = Config.InlineIconThemed,
            Folder       = Config.Window and Config.Window.Folder,
            ImageKind    = "Icon",
            ThemeTagName = Type == "Desc" and "ElementDesc" or "ElementTitle",
            CachePrefix  = "Inline" .. (Type or "Title"),
            Index        = Index,
            IconTransparency = Type == "Desc" and 0.3 or 0,
            -- false = token ikon dibiarkan mentah; token button tetap diproses
            Icons        = Config.InlineIcon ~= false,
        }
    end

    -- Ikon inline bisa dimatikan per elemen: InlineIcon = false
    local InlineEnabled = Config.InlineIcon ~= false

    local function ParseInline(str, Type, TagAware)
        -- Context selalu dikirim: kalau ikon dimatikan, Context.Icons = false
        -- membuat token ikon dibiarkan mentah sementara token button tetap jalan.
        return ParseTextSegments(str, InlineContext(Type), TagAware)
    end

    local function HasRich(str)
        return HasRichTokens(str, InlineEnabled)
    end

    -- ===== Button inline =====

    -- Kapan sebuah button inline terakhir ditekan. Dipakai elemen induk
    -- (Toggle dsb.) lewat :IsInlineButtonActive() supaya klik pada button tidak
    -- ikut memicu aksi elemennya.
    local InlineLastPress = 0

    -- Instance button -> API-nya. Dipakai untuk tiga hal: memakai ulang instance
    -- saat Desc di-update (Api:Update), :GetButton(), dan supaya Lock/Unlock
    -- elemen ikut mengunci button-nya.
    -- Weak key: entri ikut terbuang sendiri saat instance-nya di-Destroy.
    local ActiveButtons = setmetatable({}, { __mode = "k" })
    local IsLocked = false

    local function ForEachButton(fn)
        for Frame, Api in pairs(ActiveButtons) do
            if Frame.Parent then
                fn(Api, Frame)
            else
                ActiveButtons[Frame] = nil
            end
        end
    end

    -- Dipanggil setiap kali sebuah button dibuat atau dipakai ulang
    local function RegisterButton(Frame, Api, Spec)
        ActiveButtons[Frame] = Api
        Api.SpecLocked = Spec.Locked and true or false

        if IsLocked or Api.SpecLocked then
            Api:Lock()
        else
            Api:Unlock()
        end
    end

    -- Config Buttons boleh ditulis ringkas: sebuah function dianggap Callback.
    local function NormalizeButtonEntry(Entry)
        if type(Entry) == "function" then
            return { Callback = Entry }
        elseif type(Entry) == "table" then
            return Entry
        end
        return nil
    end

    -- Segmen button -> spec siap pakai, atau nil kalau tidak ada padanannya di
    -- Config.Buttons (segmen dibuang, mengikuti perilaku token ikon tanpa sumber).
    --
    -- Urutan menang: atribut inline > label di dalam tag > tabel Buttons.
    local function ResolveButtonSpec(Segment, AutoIndex)
        local Source = Element.Buttons
        if type(Source) ~= "table" then return nil end

        local Key = Segment.Key
        local Entry

        if Key ~= nil then
            Entry = NormalizeButtonEntry(Source[Key])
            -- "{button:2}" boleh menunjuk entri array; key-nya ikut jadi angka
            -- supaya :GetButton(2) dan :GetButton("2") tidak berbeda hasil
            if not Entry then
                local AsNumber = tonumber(Key)
                if AsNumber then
                    Entry = NormalizeButtonEntry(Source[AsNumber])
                    if Entry then Key = AsNumber end
                end
            end
        else
            -- tanpa key: ambil berurutan sesuai kemunculan di teks
            Entry = NormalizeButtonEntry(Source[AutoIndex])
            Key = AutoIndex
        end

        if not Entry then return nil end

        local Spec = {}
        for Field, Value in pairs(Entry) do
            Spec[Field] = Value
        end

        Spec.Key = Key

        if Segment.Label and Segment.Label ~= "" then
            Spec.Title = Segment.Label
        end

        for Field, Value in pairs(InlineButton.NormalizeAttrs(Segment.Attrs)) do
            Spec[Field] = Value
        end

        Spec.Title = Spec.Title or (type(Key) == "string" and Key) or "Button"

        return Spec
    end

    local function ButtonContext(Index)
        return {
            Folder = Config.Window and Config.Window.Folder,
            Index = Index,
            OnPress = function()
                InlineLastPress = os.clock()
            end,
        }
    end

    -- Isi Spec ke setiap segmen button, sekaligus menomori yang tanpa key.
    -- Dipanggil sekali per update supaya penomorannya konsisten lintas baris.
    local function ResolveButtonsIn(itemLists)
        local AutoIndex = 0
        local Found = false

        for _, items in ipairs(itemLists) do
            for _, item in ipairs(items) do
                if item.Type == "Button" then
                    if item.Key == nil then
                        AutoIndex = AutoIndex + 1
                        item.Spec = ResolveButtonSpec(item, AutoIndex)
                    else
                        item.Spec = ResolveButtonSpec(item, nil)
                    end
                    Found = Found or item.Spec ~= nil
                end
            end
        end

        return Found
    end

    local ThumbnailFrame
    local ImageFrame
    if Element.Thumbnail then
        ThumbnailFrame = Creator.Image(
            Element.Thumbnail,
            Element.Title,
            Config.Window.NewElements and Element.UICorner-11 or (Element.UICorner-4),
            Config.Window.Folder,
            "Thumbnail",
            false,
            Element.IconThemed
        )
        ThumbnailFrame.Size = UDim2.new(1,0,0,ThumbnailSize)
    end
    if Element.Image then
        ImageFrame = Creator.Image(
            Element.Image,
            Element.Title,
            Config.Window.NewElements and Element.UICorner-11 or (Element.UICorner-4),
            Config.Window.Folder,
            "Image",
            Element.IconThemed,
            not Element.Color and true or false,
            "ElementIcon"
        )
        if typeof(Element.Color) == "string" then
            ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
        elseif typeof(Element.Color) == "Color3" then
            ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Element.Color)
        end

        ImageFrame.Size = UDim2.new(0,ImageSize,0,ImageSize)

        IconOffset = ImageSize
    end

    -- Helper Create Text
    -- UseGradient: nil/true = ikuti gradient elemen (default, untuk teks tanpa tag <gradient>)
    --              false = paksa warna normal (dipakai untuk segmen teks di luar tag <gradient>)
    local function CreateText(Title, Type, UseGradient)
        local TextColor = typeof(Element.Color) == "string"
            and GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
            or typeof(Element.Color) == "Color3"
            and GetTextColorForHSB(Element.Color)

        local GradientProps = ResolveItemGradientProps(UseGradient, Type == "Desc" and Element.DescGradient or Element.TitleGradient)

        local ThemeTagName = (not Element.Color) and ("Element" .. Type) or nil

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Text = Title or "",
            TextSize = Type == "Desc" and 15 or 17,
            TextXAlignment = "Left",
            ThemeTag = {
                TextColor3 = (not GradientProps) and ThemeTagName or nil,
            },
            TextColor3 = GradientProps and Color3.new(1, 1, 1) or (Element.Color and TextColor or nil),
            TextTransparency = Type == "Desc" and .3 or 0,
            TextWrapped = true,
            Size = UDim2.new(Element.Justify == "Between" and 1 or 0,0,0,0),
            AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
            FontFace = Font.new(Creator.Font, Type == "Desc" and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold)
        })

        -- Dicatat supaya warna aslinya bisa dipulihkan kalau gradient dilepas
        TextRestore[Label] = {
            ThemeTag = ThemeTagName,
            Color = Element.Color and TextColor or nil,
        }

        ApplyGradientToLabel(Label, GradientProps)

        return Label
    end

    local Title = CreateText(Element.Title, "Title")
    local TitleRichLayout = New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    -- judul panjang tetap bisa turun baris (properti baru, jadi lewat pcall).
    -- Hanya kalau lebarnya terbatas; "XY" ikut lebar isi jadi tidak pernah wrap.
    if Element.Justify == "Between" then
        Creator.TrySetWraps(TitleRichLayout, true)
    end

    local TitleRich = New("Frame", {
        Name = "TitleRich",
        BackgroundTransparency = 1,
        Size = UDim2.new(Element.Justify == "Between" and 1 or 0,0,0,0),
        AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
        Visible = false,
    }, {
        TitleRichLayout
    })

    -- Container Deskripsi
    local DescContainer = New("Frame", {
        Name = "DescContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, {
        New("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 2),
        })
    })

    -- [FUNGSI OPTIMASI LAG] UpdateDesc dengan Reuse Instance
    local function UpdateDesc(text)

        if not text or text == "" then
            DescContainer.Visible = false
            return
        end
        DescContainer.Visible = true

        -- Dihitung sekali dari teks utuh: kalau ada tag <gradient> di mana pun,
        -- semua baris & kolom memakai aturan yang sama (teks di luar tag = warna
        -- normal). Tanpa tag, seluruh desc ikut DescGradient.
        local descHasTag = HasGradientTag(text)

        local function parseInline(str)
            return ParseInline(str, "Desc", descHasTag)
        end

        local function getColumnWidth()
            if typeof(Element.DescColumnWidth) == "number" and Element.DescColumnWidth > 0 then
                return math.floor(Element.DescColumnWidth)
            end

            local w = DescContainer.AbsoluteSize.X
            if not w or w <= 0 then
                return 320
            end
            return math.clamp(math.floor(w * 0.62), 220, 520)
        end

        local function getOrCreateListLayout(parent, wraps)
            local layout = parent:FindFirstChild("UIListLayout")
            if not layout then
                layout = New("UIListLayout", {
                    Parent = parent,
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4),
                    VerticalAlignment = Enum.VerticalAlignment.Center
                })
            else
                layout.FillDirection = Enum.FillDirection.Horizontal
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Padding = UDim.new(0, 4)
                layout.VerticalAlignment = Enum.VerticalAlignment.Center
            end
            -- Baris yang memuat button biasanya "teks panjang + tombol", jadi
            -- perlu boleh turun baris. Baris lain dibiarkan seperti semula.
            if wraps then
                Creator.TrySetWraps(layout, true)
            end
            return layout
        end

        -- Penanda jenis item, dipakai untuk memutuskan sebuah instance masih
        -- bisa dipakai ulang atau harus dibuat baru. Isi teks & Image tidak
        -- ikut dihitung karena di bawah cukup di-assign ulang; ikon inline ikut
        -- karena ukuran/sumbernya menentukan cara frame-nya dibangun.
        local function ItemSignature(itemData)
            if itemData.Type == "Text" then
                return "T|" .. GradientSignature(itemData.Gradient)
            elseif itemData.Type == "Image" then
                return "I"
            elseif itemData.Type == "Button" then
                -- Title/Icon/Locked TIDAK ikut: itu diurus Api:Update() supaya
                -- instance-nya bisa dipakai ulang saat teksnya berubah.
                local Spec = itemData.Spec or {}
                return table.concat({
                    "B", tostring(itemData.Key),
                    tostring(Spec.Variant),
                    Spec.Color and tostring(Spec.Color) or "",
                    Spec.TextColor and tostring(Spec.TextColor) or "",
                    tostring(Spec.Height), tostring(Spec.Width),
                    tostring(Spec.Radius), tostring(Spec.TextSize),
                    tostring(Spec.Padding),
                }, "|")
            end

            local o = itemData.Options or {}
            return table.concat({
                "C", tostring(itemData.Content),
                tostring(o.Size), tostring(o.Width), tostring(o.Height),
                tostring(o.Transparency), tostring(o.Themed),
                tostring(o.ScaleType), tostring(o.KeepAspect),
                o.Color and o.Color:ToHex() or "",
            }, "|")
        end

        local function updateItemsInContainer(container, items)
            local currentItems = {}
            for _, c in ipairs(container:GetChildren()) do
                if c:IsA("GuiObject") then table.insert(currentItems, c) end
            end

            -- Kursor terpisah dari indeks item: sebuah ikon bisa gagal dibangun
            -- (sumber tidak sah) sehingga tidak memakai slot instance. Tanpa ini
            -- posisi instance lama bergeser dan ikut dibuang tiap update.
            local slot = 0

            for j, itemData in ipairs(items) do
                local signature = ItemSignature(itemData)
                local itemFrame = currentItems[slot + 1]

                if itemFrame and itemFrame:GetAttribute("ItemSig") ~= signature then
                    itemFrame:Destroy()
                    table.remove(currentItems, slot + 1)
                    itemFrame = nil
                end

                if not itemFrame then
                    if itemData.Type == "Text" then
                        itemFrame = CreateText(itemData.Content, "Desc", itemData.Gradient)
                        itemFrame:SetAttribute("GradientSig", GradientSignature(itemData.Gradient))
                        itemFrame.Parent = container
                    elseif itemData.Type == "Icon" then
                        itemFrame = Creator.InlineIconFrame(itemData, InlineContext("Desc", j))
                        if itemFrame then
                            itemFrame.Parent = container
                        end
                    elseif itemData.Type == "Button" then
                        -- spec tidak ketemu di Config.Buttons: segmen dibuang
                        if itemData.Spec then
                            local Frame, Api = InlineButton.New(itemData.Spec, ButtonContext(j))
                            if Frame then
                                RegisterButton(Frame, Api, itemData.Spec)
                                Frame.Parent = container
                                itemFrame = Frame
                            end
                        end
                    else
                        itemFrame = New("ImageLabel", {
                            Parent = container,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0, 16, 0, 16),
                            ScaleType = Enum.ScaleType.Fit,
                            ThemeTag = { ImageColor3 = "ElementDesc" },
                            ImageTransparency = 0.3
                        })
                    end

                    if itemFrame then
                        itemFrame:SetAttribute("ItemSig", signature)
                        table.insert(currentItems, slot + 1, itemFrame)
                    end
                end

                -- sumber ikon tidak sah: dilewati supaya tidak ada kotak kosong
                if itemFrame then
                    slot = slot + 1
                    itemFrame.LayoutOrder = j
                    itemFrame.Visible = true

                    if itemData.Type == "Text" then
                        if itemFrame.Text ~= itemData.Content then
                            itemFrame.Text = itemData.Content
                        end
                        ApplyGradientToLabel(itemFrame, ResolveItemGradientProps(itemData.Gradient, Element.DescGradient))
                        if #items == 1 then
                            itemFrame.Size = UDim2.new(1, 0, 0, 0)
                            itemFrame.AutomaticSize = Enum.AutomaticSize.Y
                            itemFrame.TextWrapped = true
                        else
                            itemFrame.Size = UDim2.new(0, 0, 0, 0)
                            itemFrame.AutomaticSize = Enum.AutomaticSize.XY
                            itemFrame.TextWrapped = false
                        end
                    elseif itemData.Type == "Icon" then
                        if Element.Color then
                            local Label = itemFrame:FindFirstChildOfClass("ImageLabel")
                            local Options = itemData.Options or {}
                            -- warna eksplisit di token tetap menang
                            if Label and not Options.Color then
                                if typeof(Element.Color) == "string" then
                                    Label.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
                                elseif typeof(Element.Color) == "Color3" then
                                    Label.ImageColor3 = GetTextColorForHSB(Element.Color)
                                end
                            end
                        end
                    elseif itemData.Type == "Button" then
                        -- instance dipakai ulang: cukup segarkan teks/ikon/callback
                        local Api = ActiveButtons[itemFrame]
                        if Api and itemData.Spec then
                            Api:Update(itemData.Spec)
                            RegisterButton(itemFrame, Api, itemData.Spec)
                        end
                    else
                        if itemFrame.Image ~= itemData.Content then
                            itemFrame.Image = itemData.Content
                        end
                        if Element.Color then
                            if typeof(Element.Color) == "string" then
                                itemFrame.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
                            elseif typeof(Element.Color) == "Color3" then
                                itemFrame.ImageColor3 = GetTextColorForHSB(Element.Color)
                            end
                        end
                    end
                end
            end

            -- sisa instance yang tidak terpakai lagi (pakai slot, bukan #items,
            -- karena ikon yang gagal dibangun tidak memakai slot)
            for k = slot + 1, #currentItems do
                currentItems[k]:Destroy()
            end
        end

        local lines = string.split(text, "\n")
        local parsedData = {}
        for _, line in ipairs(lines) do
            local cols = string.split(line, "\t")
            if #cols >= 2 then
                table.insert(parsedData, {Cols = {parseInline(cols[1] or ""), parseInline(cols[2] or "")}})
            else
                table.insert(parsedData, {Cols = {parseInline(line)}})
            end
        end

        -- Penomoran button tanpa key harus melihat SELURUH desc sekaligus, jadi
        -- dilakukan setelah semua baris & kolom selesai diparse. Urutannya
        -- deterministik: baris atas ke bawah, kolom kiri lalu kanan.
        local itemLists = {}
        for _, lineData in ipairs(parsedData) do
            for _, items in ipairs(lineData.Cols) do
                table.insert(itemLists, items)
            end
        end
        ResolveButtonsIn(itemLists)

        -- Baris yang memuat button dibolehkan turun baris (lihat getOrCreateListLayout)
        local function lineHasButton(lineData)
            for _, items in ipairs(lineData.Cols) do
                for _, item in ipairs(items) do
                    if item.Type == "Button" and item.Spec then
                        return true
                    end
                end
            end
            return false
        end

        local currentLines = {}
        for _, c in ipairs(DescContainer:GetChildren()) do
            if c:IsA("Frame") then table.insert(currentLines, c) end
        end

        for i, lineData in ipairs(parsedData) do
            local lineFrame = currentLines[i]
            local wraps = lineHasButton(lineData)

            if not lineFrame then
                lineFrame = New("Frame", {
                    Parent = DescContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
            end
            lineFrame.LayoutOrder = i
            lineFrame.Visible = true

            local cols = lineData.Cols
            if #cols >= 2 then
                local colWidth = getColumnWidth()
                local lineLayout = getOrCreateListLayout(lineFrame)
                lineLayout.Padding = UDim.new(0, 0)

                local leftCol = lineFrame:FindFirstChild("Col1")
                if not leftCol then
                    leftCol = New("Frame", {
                        Name = "Col1",
                        Parent = lineFrame,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, colWidth, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                    })
                    getOrCreateListLayout(leftCol, wraps)
                else
                    leftCol.Size = UDim2.new(0, colWidth, 0, 0)
                    leftCol.AutomaticSize = Enum.AutomaticSize.Y
                    getOrCreateListLayout(leftCol, wraps)
                end

                local rightCol = lineFrame:FindFirstChild("Col2")
                if not rightCol then
                    rightCol = New("Frame", {
                        Name = "Col2",
                        Parent = lineFrame,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -colWidth, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                    })
                    getOrCreateListLayout(rightCol, wraps)
                else
                    rightCol.Size = UDim2.new(1, -colWidth, 0, 0)
                    rightCol.AutomaticSize = Enum.AutomaticSize.Y
                    getOrCreateListLayout(rightCol, wraps)
                end

                for _, c in ipairs(lineFrame:GetChildren()) do
                    if c:IsA("GuiObject") and c ~= leftCol and c ~= rightCol then
                        c:Destroy()
                    end
                end

                updateItemsInContainer(leftCol, cols[1])
                updateItemsInContainer(rightCol, cols[2])
            else
                for _, c in ipairs(lineFrame:GetChildren()) do
                    if c:IsA("Frame") and (c.Name == "Col1" or c.Name == "Col2") then
                        c:Destroy()
                    end
                end

                getOrCreateListLayout(lineFrame, wraps)
                updateItemsInContainer(lineFrame, cols[1])
            end
        end

        for k = #parsedData + 1, #currentLines do
            currentLines[k]:Destroy()
        end
    end

    local function UpdateTitle(text)
        Title.Text = text or ""
        ApplyGradientToLabel(Title, ResolveGradientProps(Element.TitleGradient))

        if not text or text == "" then
            Title.Visible = true
            TitleRich.Visible = false
            return
        end

        if not HasRich(text) then
            Title.Visible = true
            TitleRich.Visible = false
            return
        end

        local items = ParseInline(text, "Title")
        ResolveButtonsIn({ items })

        -- Token yang tidak jadi ikon (mis. "Rate {5} stars") tetap teks biasa:
        -- kalau tidak ada segmen non-teks sama sekali, pakai jalur TextLabel
        -- tunggal supaya spasi & wrapping aslinya tidak berubah.
        --
        -- Teks bertag <gradient> DIKECUALIKAN: tag-nya harus dibuang dari teks
        -- yang tampil, dan itu hanya terjadi di jalur TitleRich. Tanpa
        -- pengecualian ini judul balik ke TextLabel tunggal yang isinya masih
        -- "<gradient>Judul</gradient>" mentah dan gradient-nya tidak jalan.
        local hasRichItem = HasGradientTag(text)
        if not hasRichItem then
            for _, item in ipairs(items) do
                if item.Type ~= "Text" then
                    hasRichItem = true
                    break
                end
            end
        end
        if not hasRichItem then
            Title.Visible = true
            TitleRich.Visible = false
            return
        end

        Title.Visible = false
        TitleRich.Visible = true

        for _, c in ipairs(TitleRich:GetChildren()) do
            if c:IsA("GuiObject") then
                c:Destroy()
            end
        end

        for idx, item in ipairs(items) do
            if item.Type == "Text" then
                local lbl = CreateText(item.Content, "Title", item.Gradient)
                lbl.LayoutOrder = idx
                if #items == 1 then
                    lbl.Size = UDim2.new(1, 0, 0, 0)
                    lbl.AutomaticSize = Enum.AutomaticSize.Y
                    lbl.TextWrapped = true
                else
                    lbl.Size = UDim2.new(0, 0, 0, 0)
                    lbl.AutomaticSize = Enum.AutomaticSize.XY
                    lbl.TextWrapped = false
                end
                lbl.Parent = TitleRich
            elseif item.Type == "Icon" then
                -- token "{...}": lucide / rbxassetid / URL, ukuran per token
                local frame = Creator.InlineIconFrame(item, InlineContext("Title", idx))
                if frame then
                    frame.LayoutOrder = idx

                    local label = frame:FindFirstChildOfClass("ImageLabel")
                    if label and Element.Color and not (item.Options and item.Options.Color) then
                        if typeof(Element.Color) == "string" then
                            label.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
                        elseif typeof(Element.Color) == "Color3" then
                            label.ImageColor3 = GetTextColorForHSB(Element.Color)
                        end
                    end

                    frame.Parent = TitleRich
                end
            elseif item.Type == "Button" then
                -- Judul dibangun ulang penuh setiap update, jadi tidak ada
                -- instance yang bisa dipakai ulang di sini.
                if item.Spec then
                    local frame, api = InlineButton.New(item.Spec, ButtonContext(idx))
                    if frame then
                        frame.LayoutOrder = idx
                        RegisterButton(frame, api, item.Spec)
                        frame.Parent = TitleRich
                    end
                end
            else
                local img = New("ImageLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 18, 0, 18),
                    ScaleType = Enum.ScaleType.Fit,
                    ThemeTag = { ImageColor3 = "ElementTitle" },
                    ImageTransparency = 0,
                    Image = item.Content,
                    LayoutOrder = idx,
                })

                if Element.Color then
                    if typeof(Element.Color) == "string" then
                        img.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
                    elseif typeof(Element.Color) == "Color3" then
                        img.ImageColor3 = GetTextColorForHSB(Element.Color)
                    end
                end

                img.Parent = TitleRich
            end
        end
    end

    Element.UIElements.Container = New("Frame", {
        Size = UDim2.new(1,0,1,0),
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0,Element.UIPadding),
            FillDirection = "Vertical",
            VerticalAlignment = "Center",
            HorizontalAlignment = Element.Justify == "Between" and "Left" or "Center",
        }),
        ThumbnailFrame,
        New("Frame", {
            Size = UDim2.new(
                Element.Justify == "Between" and 1 or 0,
                Element.Justify == "Between" and -Config.TextOffset or 0,
                0,
                0
            ),
            AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
            BackgroundTransparency = 1,
            Name = "TitleFrame",
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,Element.UIPadding),
                FillDirection = "Horizontal",
                VerticalAlignment = (Config.ElementTable and Config.ElementTable.__type == "Dropdown") and "Center"
                    or ((ImageFrame and Config.ElementTable and Config.ElementTable.__type == "Toggle") and "Center"
                    or (Config.Window.NewElements and ( Element.Justify == "Between" and "Top" or "Center" ) or "Center")),
                HorizontalAlignment = Element.Justify ~= "Between" and Element.Justify or "Center",
            }),
            ImageFrame,
            New("Frame", {
                BackgroundTransparency = 1,
                AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
                Size = UDim2.new(
                    Element.Justify == "Between" and 1 or 0,
                    Element.Justify == "Between" and ( ImageFrame and -IconOffset-Element.UIPadding or -IconOffset ) or 0,
                    1,
                    0
                ),
                Name = "TitleFrame",
            }, {
                New("UIPadding", {
                    PaddingTop = UDim.new(0,Config.Window.NewElements and Element.UIPadding/2 or 0),
                    PaddingLeft = UDim.new(0,Config.Window.NewElements and Element.UIPadding/2 or 0),
                    PaddingRight = UDim.new(0,Config.Window.NewElements and Element.UIPadding/2 or 0),
                    PaddingBottom = UDim.new(0,Config.Window.NewElements and Element.UIPadding/2 or 0),
                }),
                New("UIListLayout", {
                    Padding = UDim.new(0,6),
                    FillDirection = "Vertical",
                    VerticalAlignment = "Center",
                    HorizontalAlignment = "Left",
                }),
                Title,
                TitleRich,
                DescContainer -- Menggunakan Container Pintar
            }),
        })
    })

    -- Ambil custom config, fallback ke "lock"
    local LockIconAsset = Config.LockedIcon or Config.LockIcon or "lock"
    local LockedIconSize = Config.LockedIconSize or 20
    local LockedIconColor = Config.LockedIconColor or Color3.new(1,1,1)
    local LockedIconTransparency = Config.LockedIconTransparency or .4

    local LockedIcon = Creator.Image(
        LockIconAsset, "lock", 0, Config.Window.Folder, "Lock", false
    )
    LockedIcon.Size = UDim2.new(0, LockedIconSize, 0, LockedIconSize)
    LockedIcon.ImageLabel.ImageColor3 = LockedIconColor
    LockedIcon.ImageLabel.ImageTransparency = LockedIconTransparency

    local LockedTitle = New("TextLabel", {
        Text = "Locked",
        TextSize = 18,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        AutomaticSize = "XY",
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1,1,1),
        TextTransparency = .05,
    })

    local ElementFullFrame = New("Frame", {
        Size = UDim2.new(1,Element.UIPadding*2,1,Element.UIPadding*2),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.new(0.5,0,0.5,0),
        ZIndex = 9999999,
    })

    local Locked, LockedTable = NewRoundFrame(Element.UICorner, "Squircle", {
        Size = UDim2.new(1,0,1,0),
        ImageTransparency = .25,
        ImageColor3 = Color3.new(0,0,0),
        Visible = false,
        Active = false,
        Parent = ElementFullFrame,
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            Padding = UDim.new(0,8)
        }),
        LockedIcon, LockedTitle
    }, nil, true)

    local HighlightOutline, HighlightOutlineTable = NewRoundFrame(Element.UICorner, "Squircle-Outline", {
        Size = UDim2.new(1,0,1,0),
        ImageTransparency = 1,
        Active = false,
        ThemeTag = { ImageColor3 = "Text" },
        Parent = ElementFullFrame,
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            Padding = UDim.new(0,8)
        }),
    }, nil, true)

    local Highlight, HighlightTable = NewRoundFrame(Element.UICorner, "Squircle", {
        Size = UDim2.new(1,0,1,0),
        ImageTransparency = 1,
        Active = false,
        ThemeTag = { ImageColor3 = "Text" },
        Parent = ElementFullFrame,
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            Padding = UDim.new(0,8)
        }),
    }, nil, true)

    local HoverOutline, HoverOutlineTable = NewRoundFrame(Element.UICorner, "Squircle-Outline", {
        Size = UDim2.new(1,0,1,0),
        ImageTransparency = 1,
        Active = false,
        ThemeTag = { ImageColor3 = "Text" },
        Parent = ElementFullFrame,
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            Padding = UDim.new(0,8)
        }),
        New("UIGradient", {
            Name = "HoverGradient",
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.25, 0.9),
                NumberSequenceKeypoint.new(0.5, 0.3),
                NumberSequenceKeypoint.new(0.75, 0.9),
                NumberSequenceKeypoint.new(1, 1)
            }),
        }),
    }, nil, true)

    local Hover, HoverTable = NewRoundFrame(Element.UICorner, "Squircle", {
        Size = UDim2.new(1,0,1,0),
        ImageTransparency = 1,
        Active = false,
        ThemeTag = { ImageColor3 = "Text" },
        Parent = ElementFullFrame,
    }, {
        New("UIGradient", {
            Name = "HoverGradient",
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.25, 0.9),
                NumberSequenceKeypoint.new(0.5, 0.3),
                NumberSequenceKeypoint.new(0.75, 0.9),
                NumberSequenceKeypoint.new(1, 1)
            }),
        }),
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            Padding = UDim.new(0,8)
        }),
    }, nil, true)

    local Main, MainTable = NewRoundFrame(Element.UICorner, "Squircle", {
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = "Y",
        ImageTransparency = Element.Color and .05 or .93,
        Parent = Config.Parent,
        ThemeTag = {
            ImageColor3 = not Element.Color and "ElementBackground" or nil
        },
        ImageColor3 = Element.Color and
            (
                typeof(Element.Color) == "string"
                    and Color3.fromHex(Creator.Colors[Element.Color])
                    or typeof(Element.Color) == "Color3"
                    and Element.Color
            ) or nil
    }, {
        Element.UIElements.Container,
        ElementFullFrame,
        New("UIPadding", {
            PaddingTop = UDim.new(0,Element.UIPadding),
            PaddingLeft = UDim.new(0,Element.UIPadding),
            PaddingRight = UDim.new(0,Element.UIPadding),
            PaddingBottom = UDim.new(0,Element.UIPadding),
        }),
    }, true, true)

    Element.UIElements.Main = Main
    Element.UIElements.Locked = Locked

    if Element.Hover then
        Creator.AddSignal(Main.MouseEnter, function()
            if CanHover then
                Tween(Main, .12, {ImageTransparency = Element.Color and .15 or .9}):Play()
                Tween(Hover, .12, {ImageTransparency = .9}):Play()
                Tween(HoverOutline, .12, {ImageTransparency = .8}):Play()
                Creator.AddSignal(Main.MouseMoved, function(x,y)
                    Hover.HoverGradient.Offset = Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
                    HoverOutline.HoverGradient.Offset = Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
                end)
            end
        end)
        Creator.AddSignal(Main.InputEnded, function()
            if CanHover then
                Tween(Main, .12, {ImageTransparency = Element.Color and .05 or .93}):Play()
                Tween(Hover, .12, {ImageTransparency = 1}):Play()
                Tween(HoverOutline, .12, {ImageTransparency = 1}):Play()
            end
        end)
    end

    function Element:SetTitle(text)
        Element.Title = text
        UpdateTitle(text)
    end

    function Element:SetTitleGradient(gradient)
        Element.TitleGradient = gradient
        UpdateTitle(Element.Title)
    end

    function Element:SetDescGradient(gradient)
        Element.DescGradient = gradient
        UpdateDesc(Element.Desc)
    end

    function Element:SetDesc(text)
        -- [OPTIMASI 1] Equality Check: Jika teks sama persis, JANGAN update apapun.
        if Element.Desc == text then
            return
        end

        Element.Desc = text
        UpdateDesc(text) -- Panggil parser yang sudah dioptimasi

        if Config.ElementTable then
             Config.ElementTable.Desc = text
        end
    end

    -- ===== API button inline =====

    -- Sedang ada button inline yang di-hover / baru saja ditekan.
    -- Elemen induk memakai ini untuk mengabaikan klik yang sebenarnya ditujukan
    -- ke button, bukan ke elemennya.
    --
    -- Status hover dibaca langsung dari button yang masih hidup, bukan dari
    -- penghitung: kalau dihitung, sebuah button yang dibuang saat kursor sedang
    -- di atasnya (Desc di-update di bawah kursor) tidak pernah mengirim
    -- MouseLeave dan penghitungnya nyangkut — elemennya jadi tidak bisa diklik
    -- selamanya. ForEachButton sekalian membuang entri yang instance-nya mati.
    function Element:IsInlineButtonActive()
        local Hovering = false
        ForEachButton(function(Api)
            if not Hovering and Api:IsHovering() then
                Hovering = true
            end
        end)
        if Hovering then
            return true
        end

        -- Sentuhan di HP tidak meninggalkan status hover, jadi tekanan terakhir
        -- dipakai sebagai jendela singkat.
        return (os.clock() - InlineLastPress) < 0.2
    end

    -- Map key -> Api dari button yang sedang tampil
    function Element:GetButtons()
        local Result = {}
        ForEachButton(function(Api)
            if Api.Key ~= nil then
                Result[Api.Key] = Api
            end
        end)
        return Result
    end

    function Element:GetButton(key)
        local Found
        ForEachButton(function(Api)
            if Found == nil and Api.Key == key then
                Found = Api
            end
        end)
        return Found
    end

    -- Ganti seluruh tabel Buttons lalu bangun ulang Title & Desc
    function Element:SetButtons(buttons)
        Element.Buttons = buttons
        if Config.ElementTable then
            Config.ElementTable.Buttons = buttons
        end

        -- instance lama dibuang: spec-nya bisa berubah total
        ForEachButton(function(_, Frame)
            ActiveButtons[Frame] = nil
            Frame:Destroy()
        end)

        UpdateDesc(Element.Desc)
        UpdateTitle(Element.Title)
    end

    -- Inisialisasi awal
    UpdateDesc(Element.Desc)
    UpdateTitle(Element.Title)

    function Element:Colorize(obj, prop)
        if Element.Color then
            obj[prop] = typeof(Element.Color) == "string"
                and GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
                or typeof(Element.Color) == "Color3"
                and GetTextColorForHSB(Element.Color)
                or nil
        end
    end

    if Config.ElementTable then
        if Title and Title.GetPropertyChangedSignal then
            Creator.AddSignal(Title:GetPropertyChangedSignal("Text"), function()
                if Element.Title ~= Title.Text then
                    Element:SetTitle(Title.Text)
                    Config.ElementTable.Title = Title.Text
                end
            end)
        end
    end

    function Element:SetThumbnail(newThumbnail, newSize)
        Element.Thumbnail = newThumbnail
        if newSize then
            Element.ThumbnailSize = newSize
            ThumbnailSize = newSize
        end

        if ThumbnailFrame then
            if newThumbnail then
                ThumbnailFrame:Destroy()
                ThumbnailFrame = Creator.Image(
                    newThumbnail,
                    Element.Title,
                    Element.UICorner-3,
                    Config.Window.Folder,
                    "Thumbnail",
                    false,
                    Element.IconThemed
                )
                ThumbnailFrame.Size = UDim2.new(1,0,0,ThumbnailSize)
                ThumbnailFrame.Parent = Element.UIElements.Container
                local layout = Element.UIElements.Container:FindFirstChild("UIListLayout")
                if layout then
                    ThumbnailFrame.LayoutOrder = -1
                end
            else
                ThumbnailFrame.Visible = false
            end
        else
            if newThumbnail then
                ThumbnailFrame = Creator.Image(
                    newThumbnail,
                    Element.Title,
                    Element.UICorner-3,
                    Config.Window.Folder,
                    "Thumbnail",
                    false,
                    Element.IconThemed
                )
                ThumbnailFrame.Size = UDim2.new(1,0,0,ThumbnailSize)
                ThumbnailFrame.Parent = Element.UIElements.Container
                local layout = Element.UIElements.Container:FindFirstChild("UIListLayout")
                if layout then
                    ThumbnailFrame.LayoutOrder = -1
                end
            end
        end
    end

    function Element:SetImage(newImage, newSize)
        Element.Image = newImage
        if newSize then
            Element.ImageSize = newSize
            ImageSize = newSize
        end

        local oldFrame = ImageFrame
        if newImage then
            local newFrame = Creator.Image(
                newImage,
                Element.Title,
                Element.UICorner-3,
                Config.Window.Folder,
                "Image",
                not Element.Color and true or false
            )
            if typeof(Element.Color) == "string" and newFrame.ImageLabel then
                newFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
            elseif typeof(Element.Color) == "Color3" and newFrame.ImageLabel then
                newFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Element.Color)
            end
            newFrame.Visible = true
            newFrame.Size = UDim2.new(0, ImageSize, 0, ImageSize)
            IconOffset = ImageSize
            if oldFrame and oldFrame.Parent then oldFrame:Destroy() end
            newFrame.Parent = Element.UIElements.Container.TitleFrame
            ImageFrame = newFrame
        else
            if ImageFrame then
                ImageFrame.Visible = false
            end
            IconOffset = 0
        end

        Element.UIElements.Container.TitleFrame.TitleFrame.Size = UDim2.new(1, -IconOffset, 1, 0)
    end

    function Element:Destroy()
        Main:Destroy()
    end

    function Element:SetLockedIcon(asset, size, color, transparency)
        if LockedIcon and LockedIcon.ImageLabel then
            if asset then
                LockedIcon.ImageLabel.Image = asset
            end
            if size then
                LockedIcon.Size = UDim2.new(0, size, 0, size)
            end
            if color then
                LockedIcon.ImageLabel.ImageColor3 = color
            end
            if transparency then
                LockedIcon.ImageLabel.ImageTransparency = transparency
            end
        end
    end
    function Element:Lock(text,Image) -- Tambahkan 'text' di dalam kurung
        CanHover = false
        IsLocked = true
        LockIconAsset = Image or LockIconAsset
        LockedTitle.Text = text or "Locked" -- Tambahkan baris ini untuk ganti teksnya
        Locked.Active = true
        Locked.Visible = true

        -- Overlay "Locked" sudah menyerap klik lewat Active = true, tapi button
        -- inline tetap ikut dikunci supaya tampilannya redup dan callback-nya
        -- tidak jalan kalau overlay-nya kebetulan tidak menutupi (mis. dipanggil
        -- langsung lewat Api).
        ForEachButton(function(Api)
            Api:Lock()
        end)
    end

    function Element:Unlock()
        CanHover = true
        IsLocked = false
        Locked.Active = false
        Locked.Visible = false

        -- button yang memang diminta terkunci lewat spec-nya sendiri tetap terkunci
        ForEachButton(function(Api)
            if not Api.SpecLocked then
                Api:Unlock()
            end
        end)
    end

    function Element:Highlight()
        local OutlineGradient = New("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.1, 0.9),
                NumberSequenceKeypoint.new(0.5, 0.3),
                NumberSequenceKeypoint.new(0.9, 0.9),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Rotation = 0,
            Offset = Vector2.new(-1, 0),
            Parent = HighlightOutline
        })

        local HighlightGradient = New("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.15, 0.8),
                NumberSequenceKeypoint.new(0.5, 0.1),
                NumberSequenceKeypoint.new(0.85, 0.8),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Rotation = 0,
            Offset = Vector2.new(-1, 0),
            Parent = Highlight
        })

        HighlightOutline.ImageTransparency = 0.65
        Highlight.ImageTransparency = 0.88

        Tween(OutlineGradient, 0.75, {
            Offset = Vector2.new(1, 0)
        }):Play()

        Tween(HighlightGradient, 0.75, {
            Offset = Vector2.new(1, 0)
        }):Play()

        task.spawn(function()
            task.wait(.75)
            HighlightOutline.ImageTransparency = 1
            Highlight.ImageTransparency = 1
            OutlineGradient:Destroy()
            HighlightGradient:Destroy()
        end)
    end

    function Element.UpdateShape(Tab)
        if Config.Window.NewElements then
            local newShape
            local pType = Config.ParentType or (Config.ParentConfig and Config.ParentConfig.ParentType)
            if pType == "Group" or pType == "Paragraph" then
                newShape = "Squircle"
            else
                newShape = getElementPosition(Tab.Elements, Element.Index)
            end

            if newShape and Main then
                MainTable:SetType(newShape)
                LockedTable:SetType(newShape)
                HighlightTable:SetType(newShape)
                HighlightOutlineTable:SetType(newShape .. "-Outline")
                HoverTable:SetType(newShape)
                HoverOutlineTable:SetType(newShape .. "-Outline")
            end
        end
    end

    return Element
end
