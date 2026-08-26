# ปุ่มเปิด

ปุ่มเปิดเป็นลูกกลิ้งลอยที่เปิด UI ของคุณอีกครั้งหลังจากปิด กำหนดค่าตอนสร้าง window, หรือเปลี่ยนทีหลังขณะ runtime

## การกำหนดค่าตอนสร้าง

ให้ตาราง `OpenButton` กับ `CreateWindow`

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | — | ข้อความที่แสดงบนปุ่ม |
| `Icon` | `string` | — | ชื่อไอคอนหรือ `rbxassetid://…` ที่ปรากฏก่อนชื่อ |
| `Enabled` | `boolean` | — | ตั้ง `false` เพื่อปิดใช้งานปุ่มเปิดทั้งหมด |
| `Position` | `UDim2` | — | ตำแหน่งปุ่มบนหน้าจอ |
| `OnlyIcon` | `boolean` | `false` | ปุ่มกลมเฉพาะไอคอน (สไตล์ Delta); ซ่อนชื่อและที่จับลาก |
| `Draggable` | `boolean` | — | อนุญาตให้ผู้ใช้ลากปุ่มไปที่ไหนก็ได้ |
| `OnlyMobile` | `boolean` | — | เว้นว่างไว้สำหรับ mobile-เท่านั้น; ตั้ง `false` เพื่อให้แสดงบน desktop ด้วย |
| `CornerRadius` | `UDim` | `UDim.new(1, 0)` | รัศมีมุมปุ่ม (default กลมสมบูรณ์) |
| `StrokeThickness` | `number` | `2` | ความหนาของเส้นขอบปุ่ม |
| `Color` | `ColorSequence` | `#40c9ff → #e81cff` | Gradient สำหรับเส้นขอบ (stroke) ปุ่ม |
| `Size` | `UDim2` | auto | ขนาดปุ่ม โดย default ปรับอัตโนมัติตามเนื้อหา |

::: info Default OnlyMobile
หากคุณไม่ตั้ง `OnlyMobile`, ปุ่มทำงานแบบ **mobile-เท่านั้น** ตั้ง `OnlyMobile = false` เพื่อให้แสดงบน desktop ด้วย — เหมือนในตัวอย่างด้านบน
:::

::: tip Color คือ gradient
`Color` รับ `ColorSequence`, ไม่ใช่ `Color3` — ค่านี้ถูกใช้เป็น gradient บนเส้นขอบปุ่ม สร้างหนึ่งด้วย `ColorSequence.new(colorA, colorB)`
:::

## แก้ไขขณะ runtime

### `Window:EditOpenButton(config)`

ใช้การเปลี่ยนแปลงกับปุ่มเปิด การเปลี่ยนแปลง **ถูกรวมแบบสะสม** — field ที่คุณไม่ให้ยังใช้ค่าปัจจุบัน

```lua
Window:EditOpenButton({
    Title = "Open Menu",
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
})
```

## Method open button

ออบเจกต์ปุ่มเปิดมีให้เป็น `Window.OpenButtonMain`

### `Window.OpenButtonMain:SetIcon(icon)`

เปลี่ยนไอคอนปุ่ม (ชื่อไอคอนหรือ `rbxassetid://…`)

```lua
Window.OpenButtonMain:SetIcon("menu")
```

### `Window.OpenButtonMain:Visible(visible)`

แสดงหรือซ่อนปุ่ม

```lua
Window.OpenButtonMain:Visible(false) -- ซ่อน
Window.OpenButtonMain:Visible(true)  -- แสดง
```

### `Window.OpenButtonMain:Edit(config)`

เหมือนกับ `Window:EditOpenButton` — รวม config ที่ให้กับ config ปัจจุบัน ใช้อันไหนก็ได้ที่อ่านง่ายกว่าในโค้ดของคุณ

```lua
Window.OpenButtonMain:Edit({ Title = "Reopen" })
```

## ตัวอย่าง

ดัดแปลงจากสคริปต์ตัวอย่าง: ลูกกลิ้งกลมที่ลากได้พร้อมชื่อ custom และเส้นขอบ gradient เขียว-เหลือง, แสดงบน desktop และ mobile

```lua
local Window = ANUI:CreateWindow({
    Title = ".an hub | ANUI Library",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

ดู [การกำหนดค่า Window](/th/guide/window-configuration) สำหรับตัวเลือก window เพิ่มเติม
