# Localization

ANUI มีเลเยอร์การแปลในตัว คุณลงทะเบียนการแปลต่อภาษา, เปิดใช้งานระบบ, แล้วแต่ละ string ที่ขึ้นต้นด้วย prefix localization (`loc:`) จะถูกค้นหาและแทนที่ด้วยการแปลสำหรับภาษาที่ใช้งานอยู่

## เปิดใช้งาน localization

### `ANUI:Localization(config)`

ลงทะเบียนตารางการแปลของคุณและเปิดระบบ เรียกครั้งเดียว, ตอนต้น — ก่อนหรือทันทีหลังจากสร้าง window

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Enabled` | `boolean` | `false` | สวิตช์หลัก ต้องเป็น `true` เพื่อให้การแปลทำงาน |
| `Translations` | `table` | `{}` | Map รหัสภาษา → ตารางการแปล `{ key = value }` |
| `Prefix` | `string` | `"loc:"` | ตัวระบุที่ทำเครื่องหมาย string สำหรับแปล |
| `DefaultLanguage` | `string` | `"en"` | ภาษาที่ใช้จนกว่าคุณจะเรียก `SetLanguage` |

```lua
ANUI:Localization({
    Enabled = true,
    DefaultLanguage = "en",
    Translations = {
        en = {
            welcome = "Welcome!",
            settings = "Settings",
        },
        id = {
            welcome = "Selamat datang!",
            settings = "Pengaturan",
        },
    },
})
```

## การใช้ string ที่แปลแล้ว

นำหน้าชื่อหรือป้ายใดๆ ด้วย `loc:` ตามด้วย key การแปล ANUI จะแก้ไขตามตารางภาษาที่ใช้งานอยู่

```lua
local Tab = Window:Tab({
    Title = "loc:settings", -- แสดง "Settings" (en) หรือ "Pengaturan" (id)
    Icon = "settings",
})

Tab:Button({
    Title = "loc:welcome",
    Callback = function() end,
})
```

::: info วิธีการทำงานของ prefix
เฉพาะ string ที่ **ขึ้นต้นด้วย prefix** (`loc:` โดย default) ที่ถูกแปล — ข้อความหลัง prefix คือ key ค้นหา String อื่นๆ แสดงตรงๆ ตามที่เขียน หาก key หนึ่งไม่มีในภาษาที่ใช้งาน, string จะแสดงตามเดิม, ดังนั้นไม่มีอะไรพัง
:::

## เปลี่ยนภาษาขณะ runtime

### `ANUI:SetLanguage(language)`

เปลี่ยนภาษาที่ใช้งาน ต้องการ localization ในสถานะเปิดใช้งาน — ส่งคืน `false` หากคุณไม่เคยเรียก `Localization` ด้วย `Enabled = true`

```lua
ANUI:SetLanguage("id") -- เปลี่ยนเป็น Bahasa Indonesia
```

## ตัวอย่างแบบเต็ม

เปิดใช้งานการแปลอังกฤษ + อินโดนีเซีย, ใช้ string `loc:` บนแท็บและอิลิเมนต์, และให้ผู้ใช้เปลี่ยนภาษาจาก dropdown

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Localization({
    Enabled = true,
    DefaultLanguage = "en",
    Translations = {
        en = {
            title = "Control Panel",
            farm = "Auto Farm",
            language = "Language",
        },
        id = {
            title = "Panel Kontrol",
            farm = "Farm Otomatis",
            language = "Bahasa",
        },
    },
})

local Window = ANUI:CreateWindow({ Title = "loc:title" })
local Tab = Window:Tab({ Title = "loc:title", Icon = "gamepad-2" })

Tab:Toggle({
    Title = "loc:farm",
    Callback = function(on)
        print("farm:", on)
    end,
})

Tab:Dropdown({
    Title = "loc:language",
    Values = { "en", "id" },
    Value = "en",
    Callback = function(lang)
        ANUI:SetLanguage(lang)
    end,
})
```

::: tip
เนื่องจากการแปลสัมผัสเฉพาะ string ที่ขึ้นต้นด้วย `loc:`, string ที่แปลแล้วและ string ปกติสามารถอยู่ร่วมกัน — ผสมได้ตามใจชอบ
:::
