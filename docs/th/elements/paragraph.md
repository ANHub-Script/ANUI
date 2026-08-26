# Paragraph

บล็อคข้อความ rich สำหรับ heading, บันทึก, และคำอธิบาย สร้างบน [base ร่วมกัน](/th/elements/#base-bersama) โดยมี hover ถูกปิดใช้งาน ดังนั้นมันแสดงเป็นเนื้อหา static — และมันยังทำหน้าที่เป็น container เบาที่คุณสามารถติดตั้งอิลิเมนต์ลูกได้

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Paragraph({
    Title = "Toggle Examples",
    Desc = "This tab showcases all supported Toggle features: classic toggle, checkbox variant, per-item icons, default values, locking, and programmatic updates."
})
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `"Paragraph"` | ข้อความ heading รองรับ [token rich-text](/th/elements/#rich-text-di-title-desc) |
| `Desc` | `string` | `nil` | ข้อความเนื้อหา รองรับ token rich-text และ multi-baris lewat `\n` |
| `Locked` | `boolean` | `false` | แสดง overlay ล็อค |
| `Images` | `table` | `nil` | Array ออปเจกต์การ์ด ที่แสดงเป็น grid card รูปภาพ (ดูด้านล่าง) |
| `ImageSize` | `UDim2` | `UDim2.fromOffset(70, 70)` | ขนาดแต่ละ card รูปภาพ |
| `Buttons` | `table` | `nil` | Array `{ Title, Icon, Callback }` ที่แสดงเป็น **ปุ่มเรียงซ้อนเต็มความกว้าง** ใต้ข้อความ |

### ออปเจกต์การ์ด รูปภาพ

แต่ละรายการใน `Images` เป็น ตาราง:

| Field | Type | คำอธิบาย |
| --- | --- | --- |
| `Title` | `string` | ป้ายกำกับ card |
| `Quantity` | `string` | Badge จำนวน/นับ (เช่น `"244x"`) |
| `Image` | `string` | Asset id (`rbxassetid://…`) หรือชื่อไอคอน |
| `Gradient` | `ColorSequence` | Gradient พื้นหลังสำหรับ card |
| `Callback` | `function` | ทำงานเมื่อ card ถูกคลิก |

::: info สองประเภท `Buttons`
การกำหนดค่า `Buttons` ที่นี่แสดงปุ่ม **เรียงซ้อนเต็มความกว้าง** ใต้ข้อความ paragraph (แต่ละอัน `{ Title, Icon, Callback }`) นี่แตกต่างจาก **map** `Buttons` base ร่วมกัน inline ที่อิลิเมนต์อื่นแสดงในแถวของมัน
:::

Paragraph สืบทอด `Image`, gradient, token rich-text, lock, และ highlight จาก [base ร่วมกัน](/th/elements/#base-bersama) Hover ถูกปิดใช้งานเสมอ

## Method

### `Paragraph:SetTitle(text)` / `Paragraph:SetDesc(text)`

อัปเดต field `Title` / `Desc` ที่เก็บไว้ใน paragraph

```lua
myParagraph:SetTitle("Updated heading")
myParagraph:SetDesc("Updated body text.")
```

::: details อัปเดตข้อความที่มองเห็น
`:SetTitle` / `:SetDesc` อัปเดต field Lua บนอิลิเมนต์ เพื่อเปลี่ยนข้อความที่แสดงบนหน้าจอ ใช้ setter ของ ParagraphFrame ที่อยู่ด้านล่าง
:::

### `Paragraph:SetViewport(model, cameraOffset?)`

แสดง `ViewportFrame` 95×95 ที่แสดงตัวอย่าง 3D ของ `model`, พร้อม `cameraOffset` เพิ่มเติม

```lua
myParagraph:SetViewport(workspace.SomeModel)
```

## ตัวอย่าง

### คำอธิบายหลายบรรทัด

ใช้ `\n` เพื่อแบ่งคำอธิบายเป็นหลายบรรทัด

```lua
myTab:Paragraph({
    Title = "Rank Information",
    Desc = "Current Rank: S-Class\nPower: 500,000"
})
```

### เป็น container เบา

ออปเจกต์ Paragraph มี method สร้างอิลิเมนต์เหมือนกับ Tab ดังนั้นคุณสามารถติดตั้งลูกโดยตรง — มีประโยชน์สำหรับจัดกลุ่มคอนโทรลใต้ heading

```lua
local group = myTab:Paragraph({
    Title = "Yen Upgrades",
    Desc = "Upgrade stats using Yen currency"
})

group:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" })
group:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" })
group:Button({ Title = "Rank Up", Icon = "arrow-up-circle" })
```

### Grid card รูปภาพ

```lua
myTab:Paragraph({
    Title = "Inventory",
    ImageSize = UDim2.fromOffset(70, 70),
    Images = {
        {
            Title = "World Box",
            Quantity = "244x",
            Image = "rbxassetid://84366761557806",
            Gradient = ColorSequence.new(Color3.fromHex("#C042FF"), Color3.fromHex("#8E24AA")),
            Callback = function() print("World Box") end
        },
        {
            Title = "Zone Key",
            Quantity = "3x",
            Image = "key",
            Gradient = ColorSequence.new(Color3.fromHex("#29B6F6"), Color3.fromHex("#0288D1")),
            Callback = function() print("Zone Key") end
        },
    }
})
```

### ปุ่มเรียงซ้อน

```lua
myTab:Paragraph({
    Title = "ANHUB Discord",
    Desc = "Members: 1,234\nOnline: 567",
    Buttons = {
        {
            Title = "Copy link",
            Icon = "link",
            Callback = function()
                setclipboard("https://discord.gg/qN47S3mKZA")
            end
        }
    }
})
```
