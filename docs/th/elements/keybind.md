# Keybind

ผูกการดำเนินการกับปุ่มคีย์บอร์ดหรือปุ่มเมาส์ Callback ทำงานทั่วโลกทุกครั้งที่ปุ่มที่ผูกถูกกด ดังนั้น keybind ทำงานได้ทุกที่ในเกม — ไม่ใช่เฉพาะเมื่อ window เปิดอยู่

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Keybind({
    Title = "Keybind",
    Value = "F",
    Callback = function(key)
        print("Pressed:", key)
    end
})
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `"Keybind"` | ป้ายกำกับหลัก รองรับ [token rich-text](/th/elements/#rich-text-di-title-desc) |
| `Desc` | `string` | `nil` | คำอธิบายเพิ่มเติมที่อยู่ใต้ชื่อ |
| `Locked` | `boolean` | `false` | แสดง overlay ล็อคและบล็อกการโต้ตอบ |
| `Value` | `string` | `"F"` | ปุ่มเริ่มต้น, ให้เป็น string **ชื่อปุ่ม** (เช่น `"F"`, `"G"`) |
| `CanChange` | `boolean` | `true` | ผู้ใช้สามารถผูกปุ่มใหม่โดยคลิกได้หรือไม่ ใน build ปัจจุบันมัน active เสมอ |
| `Callback` | `function` | `nil` | ทำงานเมื่อปุ่มที่ผูกถูกกด **รับชื่อปุ่มเป็น string** |
| `Buttons` | `table` | `nil` | ปุ่มอินไลน์ที่แสดงในแถว |
| `TitleGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความชื่อ |
| `DescGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความคำอธิบาย |
| `Flag` | `string` | `nil` | Key การคงอยู่ของการกำหนดค่า ดู [การกำหนดค่า & Flag](/th/features/config-and-flags) |

::: info วิธีทริกเกอร์และผูกใหม่
- Callback ทำงาน **ทั่วโลก** ทุกครั้งที่ปุ่มที่ผูกถูกกด — ถูกบล็อคเฉพาะเมื่อ TextBox กำลังโฟกัส ดังนั้นการพิมพ์ไม่ทริกเกอร์ keybind
- อาร์กิวเมนต์ callback เป็น string **ชื่อ** ปุ่ม: `Enum.KeyCode.F` รายงาน `"F"`, และปุ่มเมาส์รายงาน `"MouseLeft"` หรือ `"MouseRight"`
- **เพื่อผูกใหม่:** คลิก keybind มันแสดง `...` และบันทึกปุ่มถัดไปที่คุณกด
:::

Keybind ยังสืบทอดการกำหนดค่าและ method [ร่วมฐาน](/th/elements/#base-bersama)

## Method

### `Keybind:Set(value)`

ตั้งค่าปุ่มที่ผูกตาม string ชื่อของมัน

```lua
myKeybind:Set("G")
```

### `Keybind:Lock()` / `Keybind:Unlock()`

ล็อคหรือปลดล็อค keybind Keybind ที่ล็อคจะแสดง overlay และไม่สามารถผูกใหม่ได้

```lua
myKeybind:Lock()
myKeybind:Unlock()
```

### Method base

Keybind ยังรองรับ `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons`, และ `:Destroy` จาก [ร่วมฐาน](/th/elements/#method-umum)

## ตัวอย่าง

### ผูกปุ่ม toggle window ใหม่

เนื่องจาก callback ให้ชื่อปุ่มคุณ คุณสามารถเปลี่ยนมันกลับเป็น `Enum.KeyCode` ด้วย `Enum.KeyCode[key]` และส่งตรงไปยัง `Window:SetToggleKey`

```lua
myTab:Keybind({
    Flag = "KeybindTest",
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})
```

::: tip การคงอยู่ของการผูกปุ่ม
เพิ่ม `Flag` เพื่อบันทึกและกู้คืนปุ่มที่ผูกระหว่างเซสชัน ดู [การกำหนดค่า & Flag](/th/features/config-and-flags)
:::
