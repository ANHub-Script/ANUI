# Slider

Slider ตัวเลขที่ลากได้พร้อม stepping เพิ่มเติมและการป้อนข้อความด้วยตนเอง ค่าสามารถจำกัด, step, และจัดรูปแบบเป็น integer หรือ float

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        print("Volume:", value)
    end
})
```

## การกำหนดค่า

คุณสามารถกำหนดช่วงด้วย ตาราง `Value` หรือด้วย field datar `Min` / `Max` / `Default`

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `"Slider"` | ป้ายกำกับหลัก รองรับ [token rich-text](/th/elements/#rich-text-di-title-desc) |
| `Desc` | `string` | `nil` | คำอธิบายเพิ่มเติมที่อยู่ใต้ชื่อ |
| `Value` | `table` | `nil` | Tabel ช่วง `{ Min, Max, Default }` ทางเลือกแทน field ด้านล่าง |
| `Min` | `number` | `0` | ขีดจำกัดล่าง (หากไม่ใช้ `Value`) |
| `Max` | `number` | `100` | ขีดจำกัดบน (หากไม่ใช้ `Value`) |
| `Default` | `number` | `0` | ค่าเริ่มต้น (หากไม่ใช้ `Value`) |
| `Step` | `number` | `1` | ผลคูณระหว่างจุด Step **เศษส่วน** (เช่น `0.1`) เปลี่ยน slider เป็น mode float |
| `Locked` | `boolean` | `false` | แสดง overlay ล็อคและบล็อกการโต้ตอบ |
| `Callback` | `function` | `nil` | ทำงานเมื่อเปลี่ยนแปลง **รับ string ที่จัดรูปแบบ** (ดูด้านล่าง) |
| `Flag` | `string` | `nil` | Key การคงอยู่ของการกำหนดค่า ดู [การกำหนดค่า & Flag](/th/features/config-and-flags) |
| `Buttons` | `table` | `nil` | ปุ่มอินไลน์ที่แสดงในแถว |
| `TitleGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความชื่อ |
| `DescGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความคำอธิบาย |

::: warning อาร์กิวเมนต์ callback เป็น string
ค่าที่ส่งไปยัง `Callback` เป็น **string ที่จัดรูปแบบ** ไม่ใช่ตัวเลข Slider integer รับจำนวนเต็มที่ถูก floor (`"50"`); slider float (`Step` เศษส่วน) รับ string `"%.2f"` (`"0.50"`) แปลงด้วย `tonumber(value)` ก่อนทำการดำเนินการทางคณิตศาสตร์
:::

Slider ยังสืบทอดการกำหนดค่าและ method [base ร่วมกัน](/th/elements/#base-bersama)

## รูปแบบค่า & snapping

- **Snapping** — ตำแหน่งดิบติดที่ step ใกล้ที่สุด: `floor(raw / Step + 0.5) * Step`
- **Integer vs float** — `Step` integer ทำ floor ค่าเป็นจำนวนเต็ม; `Step` เศษส่วนจัดรูปแบบด้วย `"%.2f"`
- **การป้อนด้วยตนเอง** — ค่ายังเป็น field ข้อความ คลิก, พิมพ์ตัวเลข, แล้วกด **Enter** เพื่อนำไปใช้
- **การคงอยู่** — เมื่อ `Flag` ถูกตั้งค่า การกำหนดค่าบันทึก `Value.Default` เป็น string ที่จัดรูปแบบ

## Method

### `Slider:Set(value, input?)`

ตั้งค่า slider ผ่านโค้ด `value` เป็นตัวเลขในช่วง; `input?` เป็น flag เพิ่มเติมที่ใช้เมื่อการเปลี่ยนแปลงมาจาก field ข้อความ manual

```lua
mySlider:Set(75)
```

### `Slider:SetMin(n)`

อัปเดตขีดจำกัดล่างของ slider

```lua
mySlider:SetMin(10)
```

### `Slider:SetMax(n)`

อัปเดตขีดจำกัดบนของ slider

```lua
mySlider:SetMax(200)
```

### `Slider:Lock()` / `Slider:Unlock()`

ล็อคหรือปลดล็อค slider

```lua
mySlider:Lock()
mySlider:Unlock()
```

## ตัวอย่าง

### Slider integer (Volume 0–100)

อย่าลืมแปลงอาร์กิวเมนต์ string ก่อนใช้เป็นตัวเลข

```lua
myTab:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        local n = tonumber(value) -- value เป็น string เช่น "50"
        print("Volume:", n)
    end
})
```

### Slider float (Step เศษส่วน)

`Step` `0.1` ทำให้ slider เข้าสู่ mode float ดังนั้น callback รับค่าเช่น `"0.50"`

```lua
myTab:Slider({
    Title = "Brightness",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(value)
        print("Brightness:", value) -- "0.50"
    end
})
```

### การคงอยู่ด้วย Flag

```lua
myTab:Slider({
    Title = "Slider",
    Flag = "SliderTest",
    Step = 1,
    Value = { Min = 20, Max = 120, Default = 70 },
    Callback = function(value)
        print(value)
    end
})
```

### ควบคุมผ่านโค้ด

```lua
local speed = myTab:Slider({
    Title = "Speed",
    Value = { Min = 0, Max = 100, Default = 20 },
    Callback = function(value) print(value) end
})

speed:Set(60)     -- ย้าย handle ไป 60
speed:SetMax(150) -- ขยายช่วง
```
