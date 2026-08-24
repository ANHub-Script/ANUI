--!nocheck
-- Harness cepat untuk parser button inline. Dijalankan dengan lune:
--
--     lune run tools/test_inline_button_parser.lua
--
-- Parser-nya diambil APA ADANYA dari file sumber (bukan disalin ke sini), jadi
-- yang diuji benar-benar kode yang jalan di runtime. Keduanya hanya bergantung
-- pada string.*, jadi bisa diuji tanpa Roblox.

local fs = require("@lune/fs")

local Load = loadstring or load

local function ExtractBlock(Source, Pattern, Label)
    local Block = string.match(Source, Pattern)
    assert(Block, "blok tidak ditemukan di sumber: " .. Label)
    return Block
end

-- ===== Creator.ParseInlineAttrs =====

local CreatorSource = fs.readFile("src/modules/Creator.lua")
local AttrsBlock = ExtractBlock(
    CreatorSource,
    "(function Creator%.ParseInlineAttrs%(Text%).-\nend\n)",
    "Creator.ParseInlineAttrs"
)

local Creator = {}
Load("local Creator = ...\n" .. AttrsBlock)(Creator)
local ParseInlineAttrs = assert(Creator.ParseInlineAttrs)

-- ===== ParseButtonTagHead (local di dalam ParseTextSegments) =====

local ElementSource = fs.readFile("src/components/window/Element.lua")
local HeadBlock = ExtractBlock(
    ElementSource,
    "(    local function ParseButtonTagHead%(attr%).-\n    end\n)",
    "ParseButtonTagHead"
)

local ParseButtonTagHead = Load(
    "local Creator = ...\n" .. HeadBlock .. "\nreturn ParseButtonTagHead"
)(Creator)

-- ===== Perbandingan =====

local Failures = 0
local Total = 0

local function Show(Value)
    if type(Value) ~= "table" then return tostring(Value) end
    local Keys = {}
    for Key in pairs(Value) do table.insert(Keys, Key) end
    table.sort(Keys, function(a, b) return tostring(a) < tostring(b) end)
    local Parts = {}
    for _, Key in ipairs(Keys) do
        table.insert(Parts, string.format("%s=%q", tostring(Key), tostring(Value[Key])))
    end
    return "{" .. table.concat(Parts, ", ") .. "}"
end

local function SameMap(Got, Want)
    if type(Got) ~= "table" then return false end
    for Key, Value in pairs(Want) do
        if Got[Key] ~= Value then return false end
    end
    for Key in pairs(Got) do
        if Want[Key] == nil then return false end
    end
    return true
end

local function CheckAttrs(Input, Want)
    Total = Total + 1
    local Got = ParseInlineAttrs(Input)
    if SameMap(Got, Want) then
        print(string.format("  ok    attrs %q", Input))
    else
        Failures = Failures + 1
        print(string.format("  FAIL  attrs %q\n          dapat %s\n          harap %s",
            Input, Show(Got), Show(Want)))
    end
end

local function CheckHead(Input, WantKey, WantAttrs)
    Total = Total + 1
    local Key, Attrs = ParseButtonTagHead(Input)
    if Key == WantKey and SameMap(Attrs, WantAttrs) then
        print(string.format("  ok    head  %q", tostring(Input)))
    else
        Failures = Failures + 1
        print(string.format("  FAIL  head  %q\n          dapat key=%s attrs=%s\n          harap key=%s attrs=%s",
            tostring(Input), tostring(Key), Show(Attrs), tostring(WantKey), Show(WantAttrs)))
    end
end

print("Creator.ParseInlineAttrs")
CheckAttrs("", {})
CheckAttrs("variant=Ghost", { variant = "Ghost" })
-- nilai berkutip: alasan utama parser ini dipisah dari jalur ikon
CheckAttrs('text="Sell All"', { text = "Sell All" })
CheckAttrs("label='Beli 1x'", { label = "Beli 1x" })
CheckAttrs('variant=Ghost text="Sell All" size=24',
    { variant = "Ghost", text = "Sell All", size = "24" })
-- nama atribut dinormalisasi ke huruf kecil
CheckAttrs("TextSize=20", { textsize = "20" })
-- token sampah dilewati, tidak menghentikan sisanya
CheckAttrs("foo bar=1", { bar = "1" })
-- kutip tidak ditutup: sisanya diambil apa adanya, tidak error / tidak macet
CheckAttrs('text="unclosed', { text = "unclosed" })
-- URL dengan "=" di query string tetap utuh sebagai satu nilai
CheckAttrs("icon=https://x.com/a?w=1", { icon = "https://x.com/a?w=1" })
CheckAttrs("color=#e11d48", { color = "#e11d48" })

print("")
print("ParseButtonTagHead")
CheckHead(nil, nil, {})
CheckHead("", nil, {})
CheckHead("sell", "sell", {})
CheckHead("sell variant=Ghost", "sell", { variant = "Ghost" })
CheckHead('sell text="Sell All"', "sell", { text = "Sell All" })
-- kata pertama yang ternyata atribut berarti tag ini tanpa key
CheckHead("variant=Ghost", nil, { variant = "Ghost" })
CheckHead("1", "1", {})

print("")
print(string.format("%d/%d lulus", Total - Failures, Total))
if Failures > 0 then
    error(string.format("%d test gagal", Failures), 0)
end
