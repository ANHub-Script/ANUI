# Toggle

สวิตช์ on/off ที่รายงาน boolean ไปยัง callback Toggle ถูกแสดงเป็น slider แบบ animated โดย default หรือเป็น checkbox ผ่าน `Type = "Checkbox"`

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `"Toggle"` | ป้ายกำกับหลัก รองรับ [token rich-text](/th/elements/#rich-text-di-title-desc) |
| `Desc` | `string` | `nil` | คำอธิบายเพิ่มเติมที่อยู่ใต้ชื่อ |
| `Value` | `boolean` | `false` | สถานะเริ่มต้น |
| `Type` | `string` | `"Toggle"` | `"Toggle"` (slider animated) หรือ `"Checkbox"` |
| `Icon` | `string` | `nil` | ไอคอนที่แสดงภายใน knob slider |
| `IconSize` | `number` | `23` | ขนาดไอคอน knob, เป็นพิกเซล |
| `Image` | `string` \| `table` | `nil` | รูปภาพชิดซ้าย (asset id หรือ ตาราง card) |
| `ImageSize` | `number` | `30` | ขนาดรูปภาพซ้าย, เป็นพิกเซล |
| `Thumbnail` | `string` | `nil` | รูปภาพ thumbnail ขนาดใหญ่ |
| `ThumbnailSize` | `number` | `80` | ขนาด thumbnail, เป็นพิกเซล |
| `Locked` | `boolean` | `false` | Overlay ล็อค; บล็อกการโต้ตอบ **และ** ปิดใช้งาน callback |
| `Disabled` | `boolean` | `false` | บล็อกการโต้ตอบของผู้ใช้เท่านั้น (callback ยังสามารถทริกเกอร์จากโค้ด) |
| `Callback` | `function` | `nil` | ทำงานเมื่อเปลี่ยนแปลง **รับค่า boolean ใหม่** |
| `Flag` | `string` | `nil` | Key การคงอยู่ของการกำหนดค่า ดู [การกำหนดค่า & Flag](/th/features/config-and-flags) |
| `Buttons` | `table` | `nil` | ปุ่มอินไลน์ที่แสดงในแถว |
| `TitleGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความชื่อ |
| `DescGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความคำอธิบาย |

::: info Locked vs Disabled
`Locked` แสดง overlay ล็อค, บล็อกการโต้ตอบของผู้ใช้, **และ** ป้องกันไม่ให้ callback ทำงาน `Disabled` บล็อกเฉพาะการโต้ตอบ *ของผู้ใช้* — คุณยังสามารถเปลี่ยนค่าจากโค้ดด้วย `:Set(...)` และ callback ยังทำงาน ใช้ `:Lock()`/`:Unlock()` และ `:Disable()`/`:Enable()` เพื่อสลับสถานะเหล่านี้ขณะรันไทม์
:::

Toggle ยังสืบทอดการกำหนดค่าและ method [base ร่วมกัน](/th/elements/#base-bersama)

## Method

### `Toggle:Set(value, isCallback?, isAnimated?, force?)`

ตั้งค่าสถานะ toggle ผ่านโค้ด

- `value` (`boolean`) — สถานะใหม่
- `isCallback` (`boolean`, เพิ่มเติม) — รัน `Callback` สำหรับการเปลี่ยนแปลงนี้
- `isAnimated` (`boolean`, เพิ่มเติม) — animate การเปลี่ยน knob
- `force` (`boolean`, เพิ่มเติม) — บังคับให้การเปลี่ยนแปลงถูกนำไปใช้

```lua
myToggle:Set(true, true)          -- เปิดและรัน callback
myToggle:Set(false, false, false) -- ปิดโดยไม่มีเสียง, ไม่มี animation
```

### `Toggle:Lock(text?)` / `Toggle:Unlock()`

ล็อคหรือปลดล็อค toggle อาร์กิวเมนต์ `text` เพิ่มเติมตั้งค่าป้ายกำกับ overlay

```lua
myToggle:Lock("Premium only")
myToggle:Unlock()
```

### `Toggle:Disable()` / `Toggle:Enable()`

ปิดใช้งานหรือเปิดใช้งานการโต้ตอบ *ของผู้ใช้* โดยไม่มี overlay ล็อค ต่างจาก `Lock` callback ยังทำงานเมื่อคุณตั้งค่าจากโค้ด

### `Toggle:SetMainImage(image, size)`

อัปเดตรูปภาพชิดซ้ายพร้อมขนาด

```lua
myToggle:SetMainImage("rbxassetid://84366761557806", 24)
```

### Method base

Toggle ยังรองรับ `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons`, และ `:Destroy` จาก [base ร่วมกัน](/th/elements/#method-umum)

## ตัวอย่าง

### พื้นฐานและพร้อมคำอธิบาย

```lua
myTab:Toggle({
    Title = "Basic Toggle",
    Desc = "Standard toggle with animated slider (drag or click).",
    Callback = function(v)
        print("Basic Toggle:", v)
    end
})
```

### พร้อมรูปภาพซ้าย

```lua
myTab:Toggle({
    Title = "Toggle with Left Image",
    Desc = "Image on the left, centered between title and desc.",
    Image = "rbxassetid://84366761557806",
    ImageSize = 24,
    Callback = function(v) print(v) end
})
```

### พร้อมไอคอน knob และ default-on

```lua
myTab:Toggle({
    Title = "Toggle with Icon",
    Desc = "Shows an icon inside the slider when toggled.",
    Icon = "mouse",
    IconSize = 15,
    Value = true,
    Callback = function(v) print(v) end
})
```

### ตัวแปร checkbox

```lua
myTab:Toggle({
    Title = "Checkbox",
    Desc = "Checkbox variant of toggle.",
    Type = "Checkbox",
    Callback = function(v) print(v) end
})

myTab:Toggle({
    Title = "Checkbox (Default ON)",
    Type = "Checkbox",
    Value = true,
    Callback = function(v) print(v) end
})
```

### ล็อค

```lua
myTab:Toggle({
    Title = "Locked Toggle",
    Desc = "Locked state prevents user interaction.",
    Locked = true,
    Callback = function(v) print(v) end
})
```

### อัปเดตผ่านโค้ด

```lua
local progToggle = myTab:Toggle({
    Title = "Programmatic Toggle",
    Desc = "Demonstrates using Set() and updating title/desc via code.",
    Value = false,
    Callback = function(v) print("Programmatic Toggle:", v) end
})

myTab:Button({
    Title = "Turn ON",
    Callback = function()
        progToggle:Set(true, true)
        progToggle:SetTitle("Programmatic Toggle (ON)")
        progToggle:SetDesc("Toggled on by code.")
    end
})

myTab:Button({
    Title = "Turn OFF (no animation)",
    Callback = function()
        progToggle:Set(false, true, false)
        progToggle:SetTitle("Programmatic Toggle (OFF)")
        progToggle:SetDesc("Toggled off by code without animation.")
    end
})
```

### การคงอยู่ด้วย Flag

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(v) print(v) end
})
```

ค่าถูกบันทึกและกู้คืนโดยอัตโนมัติเมื่อการกำหนดค่า active — ดู [การกำหนดค่า & Flag](/th/features/config-and-flags)
