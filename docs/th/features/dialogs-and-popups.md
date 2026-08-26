# Dialogs & Popups

ANUI มีสองวิธีแสดง prompt modal: **`Window:Dialog{}`** ซึ่งแนบกับ window ที่มีอยู่แล้ว และ **`ANUI:Popup{}`** modal แบบสแตนด์อโลนที่สามารถเปิดจากที่ไหนก็ได้ ทั้งสองแสดงชื่อ, เนื้อหา, และแถวปุ่ม

## Dialog vs Popup

| | `Window:Dialog{}` | `ANUI:Popup{}` |
| --- | --- | --- |
| การแนบ | แสดงผลภายใน window ที่มีอยู่แล้ว | สแตนด์อโลน, modal ระดับหน้าจอ |
| ต้องการ window | ใช่ — เรียกบน `Window` | ไม่ — เรียกโดยตรงบน `ANUI` |
| ควบคุมความกว้าง | `Width` (default `320`) | — |
| รูปภาพ thumbnail | — | `Thumbnail` |
| ออบเจกต์ที่ส่งคืน | — | ไม่มี method; ปุ่มปิดมัน |
| เหมาะสมที่สุดสำหรับ | การยืนยันที่เกี่ยวข้องกับเมนูที่คุณสร้างแล้ว | Prompt ด่วนก่อน/โดยไม่มี window เต็ม |

## `Window:Dialog{}`

เปิด dialog modal ที่แนบกับ window ใช้สำหรับการยืนยันและตัวเลือกเล็กๆ ภายในเมนูของคุณ

### การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | — | ชื่อ dialog |
| `Content` | `string` | — | ข้อความเนื้อหาใต้ชื่อ |
| `Icon` | `string` | — | ไอคอนด้านหน้า: ชื่อไอคอน Lucide หรือ `rbxassetid://…` |
| `Width` | `number` | `320` | ความกว้าง dialog เป็นพิกเซล |
| `Buttons` | `table` | — | Array ของปุ่ม specification (ดูด้านล่าง) |

แต่ละรายการใน `Buttons` เป็นตาราง:

| Field | Type | คำอธิบาย |
| --- | --- | --- |
| `Title` | `string` | ป้ายปุ่ม |
| `Icon` | `string` | ไอคอนที่เป็นตัวเลือกบนปุ่ม |
| `Callback` | `function` | ทำงานเมื่อปุ่มถูกคลิก **ไม่รับ argument** |
| `Variant` | `string` | สไตล์ภาพ: `"Primary"`, `"Secondary"`, หรือ `"White"` |

```lua
Window:Dialog({
    Title = "Delete save?",
    Content = "This cannot be undone.",
    Buttons = {
        { Title = "Delete", Variant = "Primary", Icon = "trash", Callback = function()
            print("deleted")
        end },
    },
})
```

## `ANUI:Popup{}`

เปิด modal แบบสแตนด์อโลนทันที โดยไม่ต้องการ window ปุ่มจะปิด popup เมื่อคลิก และออบเจกต์ที่ส่งคืนไม่มี method ใดๆ

### การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dialog"` | ชื่อ popup |
| `Content` | `string` | `nil` | ข้อความเนื้อหาใต้ชื่อ |
| `Icon` | `string` | `nil` | ไอคอนด้านหน้า: ชื่อไอคอน Lucide หรือ `rbxassetid://…` |
| `IconThemed` | `boolean` | — | ระบายสีไอคอนด้วยสีไอคอนของธีม |
| `Thumbnail` | `table` | — | รูป preview ขนาดใหญ่: `{ Image, Title? }` |
| `Buttons` | `table` | — | Array ของปุ่ม specification (รูปแบบเหมือน Dialog) |

แต่ละรายการใน `Buttons` เป็นตาราง:

| Field | Type | คำอธิบาย |
| --- | --- | --- |
| `Title` | `string` | ป้ายปุ่ม |
| `Icon` | `string` | ไอคอนที่เป็นตัวเลือกบนปุ่ม |
| `Callback` | `function` | ทำงานเมื่อคลิก แล้ว popup ปิด **ไม่รับ argument** |
| `Variant` | `string` | สไตล์ภาพ: `"Primary"`, `"Secondary"`, หรือ `"White"` |

::: info Popup เปิดทันที
`ANUI:Popup{}` แสดง modal ทันทีหลังจากถูกเรียก ไม่มีอะไรต้อง `:Open()` — และไม่มี method บนออบเจกต์ที่ส่งคืน เพราะปุ่มปิดมันให้คุณแล้ว
:::

## ตัวอย่าง

### ตัวแปรปุ่ม (Dialog)

ปุ่มสามตัวแปร — `Primary`, `Secondary`, และ `White` — ใน dialog เดียว

```lua
Window:Dialog({
    Title = "UI Button Variants",
    Content = "Demonstrates the Button variants.",
    Buttons = {
        { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
        { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
        { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
    },
})
```

### Dialog ยืนยัน (Cancel / Confirm)

```lua
Window:Dialog({
    Title = "Reset settings?",
    Content = "All options will return to their defaults.",
    Icon = "rotate-ccw",
    Width = 340,
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function()
            print("cancelled")
        end },
        { Title = "Confirm", Variant = "Primary", Icon = "check", Callback = function()
            print("confirmed")
        end },
    },
})
```

### Popup แบบง่าย

```lua
ANUI:Popup({
    Title = "Welcome",
    Content = "Thanks for trying the script. Join our community for updates.",
    Icon = "hand",
    Thumbnail = {
        Image = "rbxassetid://84366761557806",
        Title = "ANHub",
    },
    Buttons = {
        { Title = "Copy Discord", Variant = "Primary", Icon = "link", Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
        end },
        { Title = "Close", Variant = "Secondary", Callback = function() end },
    },
})
```
