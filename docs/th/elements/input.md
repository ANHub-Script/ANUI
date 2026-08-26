# Input

Field ข้อความสำหรับรับข้อมูล string — หนึ่งบรรทัด (`"Input"`) หรือหลายบรรทัด (`"Textarea"`) Callback รับข้อความปัจจุบันทุกครั้งที่ field ถูก commit

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Input({
    Title = "Input",
    InputIcon = "mouse",
    Placeholder = "Enter Text...",
    Callback = function(text)
        print("Text:", text)
    end
})
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `"Input"` | ป้ายกำกับหลัก รองรับ [token rich-text](/th/elements/#rich-text-di-title-desc) |
| `Desc` | `string` | `nil` | คำอธิบายเพิ่มเติมที่อยู่ใต้ชื่อ |
| `Type` | `string` | `"Input"` | `"Input"` (หนึ่งบรรทัด) หรือ `"Textarea"` (หลายบรรทัด) |
| `Locked` | `boolean` | `false` | แสดง overlay ล็อคและบล็อกการโต้ตอบ |
| `InputIcon` | `string` \| `boolean` | `false` | ไอคอนที่แสดงภายในกล่อง input `false` สำหรับไม่มีไอคอน |
| `Placeholder` | `string` | `"Enter Text..."` | ข้อความแนะนำสีเทาที่แสดงเมื่อ field ว่าง |
| `Value` | `string` | `""` | ข้อความเริ่มต้น |
| `ClearTextOnFocus` | `boolean` | `false` | ล้าง field โดยอัตโนมัติเมื่อได้รับโฟกัส |
| `Callback` | `function` | `nil` | ทำงานเมื่อ commit **รับข้อความปัจจุบันเป็น string** |
| `Buttons` | `table` | `nil` | ปุ่มอินไลน์ที่แสดงในแถว |
| `TitleGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความชื่อ |
| `DescGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความคำอธิบาย |
| `Flag` | `string` | `nil` | Key การคงอยู่ของการกำหนดค่า ดู [การกำหนดค่า & Flag](/th/features/config-and-flags) |

::: info ลายเซ็น callback
`Callback` รับหนึ่ง **string** — ข้อความปัจจุบันของ field Callback ทำงานเมื่อ field ถูก commit (โฟกัสหาย, หรือกด Enter สำหรับ input หนึ่งบรรทัด) และ **หนึ่งครั้งเมื่อเริ่มต้น** ด้วย `Value` เริ่มต้น
:::

Input ยังสืบทอดการกำหนดค่าและ method [ร่วมฐาน](/th/elements/#base-bersama)

## Method

### `Input:Set(value, isUserInput?)`

ตั้งค่าข้อความ field เป็น `value` Flag เพิ่มเติม `isUserInput` ระบุการเปลี่ยนแปลงว่ามาจากผู้ใช้

```lua
myInput:Set("hello")
```

### `Input:SetPlaceholder(value)`

อัปเดตข้อความแนะนำ placeholder ที่แสดงเมื่อ field ว่าง

```lua
myInput:SetPlaceholder("Type a name...")
```

### `Input:Lock()` / `Input:Unlock()`

ล็อคหรือปลดล็อค input Input ที่ล็อคจะแสดง overlay และเพิกเฉยการพิมพ์

```lua
myInput:Lock()
myInput:Unlock()
```

### Method base

Input ยังรองรับ `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons`, และ `:Destroy` จาก [ร่วมฐาน](/th/elements/#method-umum)

## ตัวอย่าง

### พื้นฐานพร้อมไอคอน

```lua
myTab:Input({
    Title = "Input",
    InputIcon = "mouse"
})
```

### Textarea (หลายบรรทัด)

```lua
myTab:Input({
    Title = "Input Textarea",
    Type = "Textarea",
    InputIcon = "mouse"
})
```

### พร้อมคำอธิบาย

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example"
})
```

### ล็อค

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example",
    Locked = true
})
```

### การคงอยู่ด้วย Flag

```lua
myTab:Input({
    Flag = "InputTest",
    Title = "Input",
    Desc = "Input Description",
    Value = "Default value",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter text...",
    Callback = function(input)
        print("Text entered:", input)
    end
})
```

ค่าถูกบันทึกและกู้คืนโดยอัตโนมัติเมื่อการกำหนดค่า active — ดู [การกำหนดค่า & Flag](/th/features/config-and-flags)
