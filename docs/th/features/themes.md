# ธีม

ANUI มาพร้อม 26 ธีมในตัวและยังอนุญาตให้คุณลงทะเบียนธีมของคุณเอง คุณเลือกธีมเมื่อ window ถูกสร้าง, เปลี่ยนมันขณะ runtime, อ่านธีมที่ใช้งาน, และตอบสนองต่อการเปลี่ยนแปลง — ทั้งหมดผ่าน method ระดับบนสุดบน `ANUI`

## กำหนดธีมเมื่อสร้าง

ให้ key ธีมกับ `CreateWindow` ผ่าน field `Theme` ค่า default คือ `"Dark"`

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Theme = "Midnight", -- key ในตัวใดก็ตาม, หรือชื่อธีม custom
})
```

ดู [การกำหนดค่า Window](/th/guide/window-configuration) สำหรับตัวเลือก window เพิ่มเติม

## เปลี่ยนธีมขณะ runtime

### `ANUI:SetTheme(name)`

ใช้ธีมตาม key และส่งคืนตารางธีม, หรือ `nil` หาก key ไม่รู้จัก

```lua
if not ANUI:SetTheme("Emerald") then
    warn("Key ธีมไม่รู้จัก")
end
```

## อ่านธีมที่ใช้งาน

### `ANUI:GetCurrentTheme()`

ส่งคืน **ชื่อที่แสดง** ของธีมที่ใช้งาน (เช่น `"Monokai Pro"`, ไม่ใช่ key `MonokaiPro`)

```lua
print(ANUI:GetCurrentTheme()) --> "Midnight"
```

### `ANUI:GetThemes()`

ส่งคืนตารางที่มีทุกธีมที่ลงทะเบียน, กับ key เป็น key ธีม — รวมธีมที่คุณเพิ่มผ่าน `AddTheme`

```lua
for key, theme in pairs(ANUI:GetThemes()) do
    print(key, "->", theme.Name)
end
```

## ตอบสนองต่อการเปลี่ยนธีม

### `ANUI:OnThemeChange(callback)`

ลงทะเบียน handler ที่ทำงานทุกครั้งที่ `SetTheme` ใช้ธีม Callback รับ **หนึ่ง argument: key ธีม** ที่ถูกใช้ — string เดียวกับที่คุณให้กับ `SetTheme` (เช่น `"Dark"`)

```lua
ANUI:OnThemeChange(function(themeKey)
    print("ธีมเปลี่ยนเป็น:", themeKey)
end)
```

::: info เพียงหนึ่ง handler
`OnThemeChange` เก็บเพียงหนึ่ง handler — การเรียกอีกครั้งจะแทนที่ handler ก่อนหน้า ลงทะเบียนหนึ่งฟังก์ชันและทำการแยกสาขาภายในหากหลายส่วนของสคริปต์ของคุณต้องตอบสนอง
:::

## ธีมในตัว

ให้ **key** กับ `Theme` / `SetTheme` ชื่อที่แสดง (ที่ส่งคืนโดย `GetCurrentTheme`) แตกต่างจาก key เพียงไม่กี่ธีม

| Key | ชื่อที่แสดง |
| --- | --- |
| `Dark` | Dark *(default)* |
| `Light` | Light |
| `Rose` | Rose |
| `Plant` | Plant |
| `Red` | Red |
| `Indigo` | Indigo |
| `Sky` | Sky |
| `Violet` | Violet |
| `Amber` | Amber |
| `Emerald` | Emerald |
| `Midnight` | Midnight |
| `Crimson` | Crimson |
| `MonokaiPro` | Monokai Pro |
| `CottonCandy` | Cotton Candy |
| `Rainbow` | Rainbow |
| `NordTheme` | Nord |
| `DraculaTheme` | Dracula |
| `TokyoNight` | Tokyo Night |
| `OneDark` | One Dark |
| `Gruvbox` | Gruvbox |
| `SolarizedDark` | Solarized Dark |
| `MaterialDark` | Material Dark |
| `CyberpunkPink` | Cyberpunk Pink |
| `OceanBlue` | Ocean Blue |
| `NeonGreen` | Neon Green |
| `SoftPastel` | Soft Pastel |

## ธีม custom

### `ANUI:AddTheme(theme)`

ลงทะเบียนธีม, กับ key เป็น `Name` ของมัน, แล้วส่งคืนมัน หลังจากเพิ่ม, ใช้ด้วย `SetTheme(name)`

ธีมเป็นตารางที่มี key สี เก้าในนั้นจำเป็น; `Toggle` และ `Checkbox` เป็นตัวเลือก แต่ละสีเป็น `Color3` — โดยปกติสร้างด้วย `Color3.fromHex("#…")`

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Name` | `string` | — | ชื่อธีมที่ไม่ซ้ำ นี่คือ key ที่คุณให้กับ `SetTheme` |
| `Accent` | `Color3` | — | สี accent / แผงหลัก |
| `Dialog` | `Color3` | — | Background dialog และ popup |
| `Outline` | `Color3` | — | สีเส้นขอบ / stroke |
| `Text` | `Color3` | — | สีข้อความหลัก |
| `Placeholder` | `Color3` | — | สีข้อความ placeholder / จาง |
| `Background` | `Color3` | — | สี background window |
| `Button` | `Color3` | — | สี background button |
| `Icon` | `Color3` | — | สีการระบายไอคอน |
| `Toggle` | `Color3` | *(ตัวเลือก)* | สี toggle เมื่อ "on" |
| `Checkbox` | `Color3` | *(ตัวเลือก)* | สี checkbox เมื่อ "checked" |

```lua
ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
    Toggle      = Color3.fromHex("#22d3ee"),
    Checkbox    = Color3.fromHex("#0ea5e9"),
})

ANUI:SetTheme("Oceanic")
```

::: tip
ธีมที่คุณเพิ่มด้วย `AddTheme` ปรากฏใน `GetThemes()` ทันทีและสามารถเลือกเหมือนธีมในตัวอื่นๆ
:::

## Gradient

### `ANUI:Gradient(stops, props)`

สร้างตารางข้อมูล gradient จากชุด color stop `stops` ใช้ key เป็น **string ตำแหน่ง** จาก `"0"` ถึง `"100"` (เปอร์เซ็นต์ตามความยาว gradient); แต่ละ stop เป็น `{ Color = Color3, Transparency = number }` — `Transparency` เป็นตัวเลือกและ default เป็น `0` `props` เป็นตารางตัวเลือกที่ถูกรวมเข้ากับผลลัพธ์, เช่น `{ Rotation = 45 }`

```lua
local sunset = ANUI:Gradient({
    ["0"]   = { Color = Color3.fromHex("#40c9ff") },
    ["50"]  = { Color = Color3.fromHex("#8b5cf6") },
    ["100"] = { Color = Color3.fromHex("#e81cff") },
}, {
    Rotation = 45,
})
```

::: warning ขั้นต่ำสอง stop
Gradient ต้องการ **สองหรือมากกว่า** stop การให้น้อยกว่านั้นจะเกิด error
:::

Gradient สามารถใช้ได้ทุกที่ที่ library รับข้อมูล gradient — บ่อยที่สุดบน field `TitleGradient` และ `DescGradient` ของอิลิเมนต์:

```lua
myTab:Button({
    Title = "Gradient Title",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Callback = function() end,
})
```

Gradient สามารถขับเคลื่อนสีธีมได้แม้กระทั่ง — ธีมในตัว `Rainbow` ถูกกำหนดด้วย gradient แทนค่า `Color3` แบน

## Acrylic blur

### `ANUI:ToggleAcrylic(enabled)`

เปิดหรือปิด acrylic blur ด้านหลัง window นี่มีผลเฉพาะเมื่อ window ถูกสร้างด้วย `Acrylic = true`; มิฉะนั้น, method นี้ไม่ทำอะไร

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Acrylic = true,
})

ANUI:ToggleAcrylic(true)  -- เปิด blur
ANUI:ToggleAcrylic(false) -- ปิด blur
```

## Font

### `ANUI:SetFont(fontId)`

กำหนด font ทั่วโลกที่ใช้ทั่วทั้ง UI

```lua
ANUI:SetFont("rbxassetid://12898095208")
```

## ตัวอย่างแบบเต็ม

ลงทะเบียนธีม custom, ใช้มัน, ให้ตัวเลือกธีม, และบันทึกทุกการเปลี่ยนแปลง

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
})

local Window = ANUI:CreateWindow({
    Title = "Theme Demo",
    Theme = "Oceanic",
    Acrylic = true,
})

local Tab = Window:Tab({ Title = "Appearance", Icon = "palette" })

Tab:Paragraph({
    Title = "Theme switcher",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Desc = "เลือกธีมด้านล่าง",
})

Tab:Dropdown({
    Title = "Theme",
    Values = { "Dark", "Light", "Midnight", "Oceanic" },
    Value = "Oceanic",
    Callback = function(name)
        ANUI:SetTheme(name)
    end,
})

ANUI:OnThemeChange(function(themeKey)
    print("Key ธีมที่ใช้งาน:", themeKey)
    print("ชื่อที่แสดง:", ANUI:GetCurrentTheme())
end)
```
