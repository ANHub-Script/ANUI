# Section

Container ที่ยุบได้ (collapsible) ที่วางใน tab เหมือนกับ Tab, Section มี method สร้างอิลิเมนต์ทั้งหมด ดังนั้นคุณเพิ่มอิลิเมนต์ลูกเข้าไปและอิลิเมนต์เหล่านั้นแสดงเป็นกลุ่มใต้ header ที่สามารถเปิดและยุบได้

::: info สองคอนเซ็ปต์ "Section" ที่แตกต่างกัน
หน้านี้บันทึก **อิลิเมนต์เนื้อหา** `Tab:Section({...})` — container collapsible ที่วาง *ภายใน* tab

นี่ไม่เกี่ยวข้องกับ `Window:Section({ Title = ... })` ซึ่งสร้าง **header section ใน sidebar** เพื่อจัดกลุ่ม tab สำหรับอันนั้น ดู [Tab & Section](/th/guide/tabs-and-sections)
:::

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local combat = myTab:Section({ Title = "Combat" })

combat:Toggle({ Title = "God Mode", Callback = function(state) end })
combat:Button({ Title = "Kill Aura", Callback = function() end })
```

::: tip
Section ใหม่สามารถยุบได้หลังจากมีอย่างน้อยหนึ่งอิลิเมนต์ลูก — Section ว่างไม่มีเนื้อหาที่จะยุบ
:::

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `"Section"` | ป้ายกำกับ header รองรับ [token rich-text](/th/elements/#rich-text-di-title-desc), รวมถึง token `{icon}` inline |
| `Icon` | `string` | `nil` | ไอคอน header: ชื่อ Lucide หรือ `rbxassetid://…` |
| `Image` | `string` | `nil` | แอสเซทรูปภาพ header (ทางเลือกแทน `Icon`) |
| `IconSize` | `number` | `20` | ขนาดไอคอน header, เป็นพิกเซล |
| `IconThemed` | `boolean` | `false` | ระบายสีไอคอนด้วยสีธีมปัจจุบัน |
| `InlineIcon` | `boolean` | `true` | แสดงไอคอน inline กับข้อความชื่อ |
| `TextSize` | `number` | `19` | ขนาดข้อความชื่อ header |
| `TextXAlignment` | `string` | `"Left"` | การจัดแนวแนวนอนชื่อ header |
| `TextTransparency` | `number` | `0.05` | ความโปร่งใสข้อความชื่อ header |
| `FontWeight` | `Enum.FontWeight` \| `string` | `SemiBold` | ความหนาฟอนต์ชื่อ header |
| `Box` | `boolean` | `false` | ห่อ section ในกล่องมีขอบ |
| `Opened` | `boolean` | `false` | เริ่มในสถานะเปิด แทนที่จะยุบ |
| `HeaderSize` | `number` | `42` | ความสูงแถบ header, เป็นพิกเซล |
| `HeaderPadding` | `number` | `8` | Padding ในแถบ header |
| `ChevronSize` | `number` | `20` | ขนาด chevron เปิด/ยุบ |

## Method

ทุก method สร้างอิลิเมนต์ (`Section:Button`, `Section:Toggle`, `Section:Slider`, …) มีให้ใน Section, เหมือนกับบน Tab — ดู [สรุปอิลิเมนต์](/th/elements/) Method เฉพาะ Section อยู่ด้านล่าง

### `Section:SetTitle(text)`

อัปเดตป้ายกำกับ header

```lua
combat:SetTitle("Combat (active)")
```

### `Section:SetIcon(icon)`

ตั้งค่าไอคอน header (ชื่อ Lucide หรือ `rbxassetid://…`)

```lua
combat:SetIcon("swords")
```

### `Section:SetIconSize(size)`

ตั้งค่าขนาดไอคอน header, เป็นพิกเซล

```lua
combat:SetIconSize(24)
```

### `Section:GetIcon()`

ส่งคืนไอคอน header ปัจจุบัน

```lua
print(combat:GetIcon())
```

### `Section:Open()` / `Section:Close()`

เปิดหรือยุบ section

```lua
combat:Open()
combat:Close()
```

### `Section:Destroy()`

ลบ section พร้อมอิลิเมนต์ลูก

```lua
combat:Destroy()
```

## ตัวอย่าง

### ไอคอน, ชื่อพร้อม token, และเปิดโดย default

```lua
local stats = myTab:Section({
    Title = "{swords} Combat Stats",
    Icon = "swords",
    Opened = true,
})

stats:Slider({ Title = "Damage", Value = { Min = 0, Max = 100, Default = 50 } })
stats:Toggle({ Title = "Auto Attack", Callback = function(state) end })
```

### เปิดและยุบผ่านโค้ด

```lua
local advanced = myTab:Section({ Title = "Advanced" })
advanced:Toggle({ Title = "Verbose Logging" })

advanced:Open()  -- เปิด
advanced:Close() -- ยุบ
```

::: info
เนื่องจาก Section เป็น container มันไม่สืบทอดพฤติกรรมอินเทอแอคทีฟ shared-base (การล็อค, highlight, ฯลฯ) — พฤติกรรมนั้นเป็นของอิลิเมนต์ที่คุณวาง *ภายใน*
:::
