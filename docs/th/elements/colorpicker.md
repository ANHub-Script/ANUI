# Colorpicker

เลือก `Color3` — พร้อมความโปร่งใสเพิ่มเติม — ผ่านไดอะล็อก picker ที่สมบูรณ์ Callback ทำงานด้วยสีที่เลือกเมื่อผู้ใช้นำไปใช้

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Colorpicker({
    Title = "Colorpicker",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(color, transparency)
        print("Color:", color, "Transparency:", transparency)
    end
})
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `"Colorpicker"` | ป้ายกำกับหลัก รองรับ [token rich-text](/th/elements/#rich-text-di-title-desc) |
| `Desc` | `string` | `nil` | คำอธิบายเพิ่มเติมที่อยู่ใต้ชื่อ |
| `Locked` | `boolean` | `false` | แสดง overlay ล็อคและบล็อกการโต้ตอบ |
| `Default` | `Color3` | `Color3.new(1, 1, 1)` (ขาว) | สีเริ่มต้นที่แสดงใน swatch |
| `Transparency` | `number` | `nil` | Alpha เริ่มต้น การให้ค่าใดๆ จะเปิดใช้งาน slider และ input alpha ใน picker |
| `Callback` | `function` | `nil` | ทำงานเมื่อ **Apply** **รับ `(color: Color3, transparency: number)`** |
| `Buttons` | `table` | `nil` | ปุ่มอินไลน์ที่แสดงในแถว |
| `TitleGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความชื่อ |
| `DescGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความคำอธิบาย |
| `Flag` | `string` | `nil` | Key การคงอยู่ของการกำหนดค่า ดู [การกำหนดค่า & Flag](/th/features/config-and-flags) |

::: info ไดอะล็อก picker
การคลิก swatch เปิดไดอะล็อกที่มี:
- แผนที่ **Saturation/Vibrance** และ slider **Hue**,
- slider **alpha** เพิ่มเติม (แสดงเฉพาะเมื่อ `Transparency` ถูกตั้งค่า),
- input **Hex** (`#RRGGBB`) พร้อม input **R / G / B** — และ input **Alpha** เมื่อเปิดใช้งานความโปร่งใส,
- ปุ่ม **Cancel** และ **Apply** — `Callback` ทำงานเมื่อ **Apply**

เมื่อบันทึกไปยังการกำหนดค่า colorpicker จะซีเรียลไลซ์ค่า hex พร้อมความโปร่งใส
:::

Colorpicker ยังสืบทอดการกำหนดค่าและ method [base ร่วมกัน](/th/elements/#base-bersama)

## Method

### `Colorpicker:Update(color, transparency?)`

ตั้งค่าสีปัจจุบัน (และความโปร่งใสเพิ่มเติม) อัปเดต swatch

```lua
myColorpicker:Update(Color3.fromRGB(255, 0, 0))
myColorpicker:Update(Color3.fromRGB(255, 0, 0), 0.5)
```

### `Colorpicker:Set(color, transparency?)`

Alias สำหรับ `:Update` — อาร์กิวเมนต์และพฤติกรรมเหมือนกัน

```lua
myColorpicker:Set(Color3.fromHex("#305dff"))
```

### `Colorpicker:Lock()` / `Colorpicker:Unlock()`

ล็อคหรือปลดล็อค colorpicker Colorpicker ที่ล็อคจะแสดง overlay และไม่สามารถเปิดได้

```lua
myColorpicker:Lock()
myColorpicker:Unlock()
```

### Method base

Colorpicker ยังรองรับ `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons`, และ `:Destroy` จาก [base ร่วมกัน](/th/elements/#method-umum)

## ตัวอย่าง

### พร้อมความโปร่งใสและ Flag

การตั้งค่า `Transparency` (แม้เป็น `0`) เปิดใช้งานการควบคุม alpha ในไดอะล็อก Callback จะรับสีและความโปร่งใส

```lua
myTab:Colorpicker({
    Flag = "ColorpickerTest",
    Title = "Colorpicker",
    Desc = "Colorpicker Description",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color, transparency)
        print("Background color:", color, transparency)
    end
})
```

สีและความโปร่งใสถูกบันทึกและกู้คืนโดยอัตโนมัติเมื่อการกำหนดค่า active — ดู [การกำหนดค่า & Flag](/th/features/config-and-flags)