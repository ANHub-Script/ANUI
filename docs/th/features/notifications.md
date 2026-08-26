# Notifications

การแจ้งเตือนแบบ toast ที่ปรากฏจากด้านข้าง, แสดงชื่อและเนื้อหา, แล้วปิดเองหลังจากนับถอยหลัง สร้างหนึ่งด้วย `ANUI:Notify{}` — สามารถเรียกจากที่ไหนก็ได้, ไม่ว่า window จะเปิดหรือไม่

## การใช้งานพื้นฐาน

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Notify({
    Title = "Welcome",
    Content = "Thanks for using ANUI!",
    Icon = "bell",
    Duration = 5,
})
```

::: info Field เนื้อหาคือ `Content`, ไม่ใช่ `Desc`
ข้อความเนื้อหาการแจ้งเตือนกำหนดด้วย `Content` `Notify` ไม่มี field `Desc` — การให้ `Desc` จะไม่แสดงเนื้อหาใดๆ เช่นกันรูปภาพกำหนดด้วย `Icon` (ชื่อไอคอน Lucide **หรือ** `rbxassetid://…`), ไม่ใช่ `Image`
:::

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `"Notification"` | ข้อความชื่อ toast |
| `Content` | `string` | `nil` | ข้อความเนื้อหาที่แสดงใต้ชื่อ |
| `Icon` | `string` | `nil` | ไอคอนด้านหน้า: ชื่อไอคอน Lucide หรือ `rbxassetid://…` (Field คือ `Icon`, ไม่ใช่ `Image`) |
| `IconThemed` | `boolean` | `nil` | ระบายสีไอคอนด้วยสีไอคอนของธีม |
| `Background` | `string` | `nil` | Id รูป background สำหรับ toast |
| `BackgroundImageTransparency` | `number` | `nil` | ความโปร่งใสของรูป background (`0` = solid) |
| `Duration` | `number` \| `false` | `5` | วินาทีก่อนปิดอัตโนมัติ; และขับเคลื่อน progress bar ค่า falsy (`false`/`nil`/`0`) หมายความว่าไม่ปิดอัตโนมัติ |
| `Buttons` | `table` | `{}` | เก็บบนออบเจกต์แต่ **ไม่ถูกแสดงผล** — ดูคำเตือนด้านล่าง |

::: warning `Buttons` ถูกเก็บแต่ไม่ถูกแสดงผล
Field `Buttons` ถูกรับและเก็บบนออบเจกต์การแจ้งเตือน, แต่ build ปัจจุบัน **ไม่** วาดมัน สำหรับตัวเลือกแบบโต้ตอบ, เปิด [Dialog หรือ Popup](/th/features/dialogs-and-popups)
:::

ปุ่มปิด (X) มีอยู่เสมอ, ดังนั้นผู้ใช้สามารถปิด toast ด้วยมือได้แม้เมื่อ `Duration` เป็น falsy

## ออบเจกต์ที่ส่งคืน

`ANUI:Notify{}` ส่งคืนออบเจกต์การแจ้งเตือนพร้อมหนึ่ง method:

### `Notification:Close()`

ปิดการแจ้งเตือนทันที มีประโยชน์สำหรับ toast ถาวร (`Duration = false`) ที่คุณต้องการปิดผ่านโค้ด

```lua
local note = ANUI:Notify({
    Title = "Working…",
    Content = "This stays open until you close it.",
    Icon = "loader",
    Duration = false, -- falsy → ไม่ปิดอัตโนมัติ
})

task.delay(3, function()
    note:Close()
end)
```

## `ANUI:SetNotificationLower(bool)`

ย้าย stack การแจ้งเตือนไปยังส่วนล่างของหน้าจอเมื่อ `true`, และคืนไปยังตำแหน่ง default เมื่อ `false` เรียกครั้งเดียวตอน setup

```lua
ANUI:SetNotificationLower(true)
```

## ตัวอย่าง

### การแจ้งเตือนแบบง่าย

```lua
ANUI:Notify({
    Title = "Saved",
    Content = "Your settings have been saved.",
})
```

### พร้อมไอคอนและระยะเวลา custom

```lua
ANUI:Notify({
    Title = "Discord",
    Content = "Invite link copied to clipboard!",
    Icon = "geist:logo-discord",
    Duration = 3,
})

ANUI:Notify({
    Title = "YouTube",
    Content = "Channel link copied!",
    Icon = "youtube",
    Duration = 3,
})
```

### การแจ้งเตือนถาวรที่ปิดผ่านโค้ด

ตั้ง `Duration = false` เพื่อให้ toast ไม่หมดอายุ, เก็บออบเจกต์ที่ส่งคืน, แล้วเรียก `:Close()` เมื่อเสร็จ

```lua
local loading = ANUI:Notify({
    Title = "Loading…",
    Content = "Fetching data from the server.",
    Icon = "loader",
    Duration = false,
})

-- ต่อมา, หลังจากงานเสร็จ
loading:Close()
ANUI:Notify({
    Title = "Done",
    Content = "Data loaded successfully.",
    Icon = "check",
    Duration = 4,
})
```

::: details พร้อมรูป background
```lua
ANUI:Notify({
    Title = "Event started",
    Content = "A limited-time event is now live.",
    Icon = "party-popper",
    Background = "rbxassetid://84366761557806",
    BackgroundImageTransparency = 0.4,
    Duration = 6,
})
```
:::
