# ระบบ Key

ระบบ key ล็อคเมนูของคุณไว้หลัง prompt key ที่แสดงก่อน window เปิด กำหนดค่าโดยให้ตาราง `KeySystem` กับ [`ANUI:CreateWindow{}`](/th/guide/window-configuration) ANUI สามารถตรวจสอบ key แบบ local, ผ่านฟังก์ชัน custom, หรือผ่านผู้ให้บริการ key ในตัว

## การใช้งานพื้นฐาน

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Enter your key to continue.",
        Key = { "free-key" },
        SaveKey = true,
    },
})
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `Title` window | ชื่อ prompt key ย้อนกลับไปชื่อ window หากว่าง |
| `Note` | `string` | — | ข้อความแนะนำที่แสดงใต้ชื่อ |
| `Thumbnail` | `table` | — | รูป preview: `{ Image, Title?, Width = 200 }` |
| `URL` | `string` | — | แสดงปุ่ม **Get key** ที่คัดลอก URL นี้ไปยัง clipboard |
| `Key` | `string` \| `array` | — | Key ที่ยอมรับหรือรายการ key, ตรวจสอบแบบ local |
| `KeyValidator` | `function` | — | `fn(key) -> boolean` การตรวจสอบ custom ที่มี **priority สูงสุด** |
| `SaveKey` | `boolean` | — | เมื่อ `true`, เขียน key ที่ยอมรับไปยัง `ANUI/<Folder>/<hwid>.key` เพื่อไม่ให้ถามผู้ใช้อีก |
| `API` | `array` | — | หนึ่งหรือมากกว่าการกำหนดค่าบริการผู้ให้บริการ key (ดู [ผู้ให้บริการ](#ผู้ให้บริการ)) |

::: warning ต้องการฟังก์ชันไฟล์และ HTTP executor
`SaveKey` อ่านและเขียนไฟล์ key, ดังนั้นต้องการ global file executor (`readfile`/`writefile`/`isfile`), บวก `gethwid` สำหรับชื่อไฟล์ ผู้ให้บริการ `API` ทำ request HTTP เพื่อตรวจสอบ key, ดังนั้นต้องการการรองรับ `game:HttpGet`/request การตรวจสอบ `Key` local และ `KeyValidator` ทำงานโดยไม่ต้องมีทั้งหมดนั้น
:::

## ลำดับความสำคัญการตรวจสอบ

เมื่อผู้ใช้ส่ง key, ANUI ตรวจสอบในลำดับต่อไปนี้และหยุดที่การตรงแรก:

1. **`KeyValidator`** — ฟังก์ชัน custom ของคุณ, หากมี
2. **`Key`** — key หรือรายการ key local
3. **`API`** — บริการผู้ให้บริการที่กำหนดค่า, ตามลำดับ

## ผู้ให้บริการ

แต่ละรายการใน `API` เป็นตารางที่มี `Type` และอาร์กิวเมนต์จำเป็นของผู้ให้บริการนั้น รายการหนึ่งยังสามารถมี `Icon`, `Title`, และ `Desc` เพื่อปรับรูปลักษณ์ใน prompt

| `Type` | อาร์กิวเมนต์จำเป็น | หมายเหตุ |
| --- | --- | --- |
| `luarmor` | `ScriptId`, `Discord` | บริการ key Luarmor |
| `platoboost` | `ServiceId`, `Secret` | บริการ key Platoboost |
| `pandadevelopment` | `ServiceId` | บริการ key Panda Development |
| `github` | `Owner`, `Repo`, `URL`, `Secret` | Key ต่ออุปกรณ์ของคุณเองที่มีอายุ 24 ชั่วโมง, ฐานข้อมูล commit ไปยัง repo GitHub ดู [ระบบ Key GitHub](/th/features/github-key-system) |

```lua
API = {
    {
        Type = "luarmor",
        ScriptId = "your-script-id",
        Discord = "https://discord.gg/qN47S3mKZA",
        Icon = "key",          -- ตัวเลือก
        Title = "Luarmor",     -- ตัวเลือก
        Desc = "Get a key",    -- ตัวเลือก
    },
}
```

## ตัวอย่าง

### Key คงที่กับ SaveKey

ยอมรับหนึ่งในหลาย key คงที่และจำ key ที่สำเร็จ

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Title = "My Hub — Key",
        Note = "Get your key from the Discord.",
        URL = "https://discord.gg/qN47S3mKZA",
        Key = { "key1", "key2" },
        SaveKey = true,
    },
})
```

### Validator custom

`KeyValidator` รับ key ที่ป้อนเป็น string และส่งคืน boolean มันทำงานก่อนรายการ `Key` และบริการ `API`

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Enter your personal key.",
        KeyValidator = function(key)
            -- ยอมรับ key ใดๆ ที่ลงท้ายด้วย UserId ของผู้เล่น
            return key == "VIP-" .. game.Players.LocalPlayer.UserId
        end,
    },
})
```

### ผู้ให้บริการ Luarmor

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Verify your Luarmor key.",
        API = {
            {
                Type = "luarmor",
                ScriptId = "your-script-id",
                Discord = "https://discord.gg/qN47S3mKZA",
            },
        },
    },
})
```

### ผู้ให้บริการ Platoboost

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Verify your Platoboost key.",
        SaveKey = true,
        API = {
            {
                Type = "platoboost",
                ServiceId = "your-service-id",
                Secret = "your-secret",
            },
        },
    },
})
```

## ดูเพิ่มเติม

- [ระบบ Key GitHub](/th/features/github-key-system) — key ต่ออุปกรณ์ที่มีอายุ 24 ชั่วโมง, generate จากเว็บไซต์ GitHub Pages ของคุณ
- [การกำหนดค่า Window](/th/guide/window-configuration) — ที่ `KeySystem` และ `Folder` ถูกตั้งค่า
