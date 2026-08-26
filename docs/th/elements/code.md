# Code

บล็อคโค้ดสไตล์ซินแท็กซ์พร้อมปุ่มคัดลอกในตัว เหมาะสำหรับแสดงสนิปเปต, คำสั่ง, หรือบรรทัดติดตั้งที่ผู้ใช้สามารถคัดลอกได้ในคลิกเดียว

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Code({
    Title = "Lua",
    Code = "print('Hello, world!')"
})
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | ป้ายกำกับที่แสดงเหนือบล็อคโค้ด |
| `Code` | `string` | `nil` | ข้อความโค้ดที่แสดง |
| `OnCopy` | `function` | `nil` | ทำงานหลังจากโค้ดถูกคัดลอกไปยังคลิปบอร์ด |

::: info การคัดลอก
ปุ่มคัดลอกเขียนไปยัง **clipboard executor** หากการคัดลอกล้มเหลว การแจ้งเตือนจะแสดงขึ้นแทน
:::

## Method

### `Code:SetCode(code)`

เปลี่ยนโค้ดที่แสดงด้วย string ใหม่

```lua
mySnippet:SetCode("print('updated!')")
```

### `Code:Destroy()`

ลบบล็อคโค้ดออกจาก container

```lua
mySnippet:Destroy()
```

## ตัวอย่าง

### บล็อคสนิปเปต Lua

```lua
myTab:Code({
    Title = "Lua",
    Code = "print('Hello from Group 1')"
})
```

### รัน callback หลังจากคัดลอก

```lua
myTab:Code({
    Title = "Install",
    Code = 'loadstring(game:HttpGet("https://example.com/script.lua"))()',
    OnCopy = function()
        print("Copied!")
    end
})
```

### อัปเดตโค้ดด้วย `SetCode`

บันทึก module ที่ส่งคืนและเปลี่ยนเนื้อหาในภายหลัง

```lua
local snippet = myTab:Code({
    Title = "Example",
    Code = "print('initial')"
})

myTab:Button({
    Title = "Update code",
    Callback = function()
        snippet:SetCode("print('updated!')")
    end
})
```
