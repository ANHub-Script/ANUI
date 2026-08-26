# แท็บและเซกชัน

แท็บคือหน้าต่างๆ ของเมนูของคุณ; section sidebar จัดกลุ่มแท็บเหล่านั้นเป็นคลัสเตอร์ที่มีป้ายกำกับ หน้านี้อธิบายการสร้างแท็บด้วย `Window:Tab{}` และการจัดกลุ่มด้วย `Window:Section{}`

::: info สองแนวคิด "Section" ที่แตกต่าง
ANUI มีสองสิ่งที่แตกต่างกันซึ่งเรียกว่า "Section" — อย่าสับสน:

1. **`Window:Section({ Title = ... })`** สร้าง **header section sidebar** ที่จัดกลุ่มแท็บใน sidebar จากนั้นคุณเรียก `Section:Tab({...})` เพื่อเพิ่มแท็บใต้มัน นี่คือสิ่งที่บันทึกไว้ในหน้านี้
2. **`Tab:Section({...})`** เป็น **อิลิเมนต์เนื้อหา** — คอนเทนเนอร์ที่ยุบได้และวาง *ภายใน* แท็บ สิ่งนั้นบันทึกไว้ใน [Section (อิลิเมนต์)](/th/elements/section)
:::

## การสร้างแท็บ

สร้างแท็บด้วย `Window:Tab{}` มันคืนค่าออบเจกต์ `Tab` เป็นที่ที่คุณเพิ่มอิลิเมนต์

```lua
local Main = Window:Tab({
    Title = "Main",
    Icon = "house",
    Desc = "Main controls", -- tooltip ที่แสดงเมื่อ hover
})
```

### การตั้งค่าแท็บ

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Tab"` | ป้ายกำกับแท็บ |
| `Desc` | `string` | — | Tooltip ที่แสดงเมื่อแท็บถูก hover |
| `Icon` | `string` | — | ไอคอนแท็บ (16px): ชื่อ Lucide หรือ `rbxassetid://…` |
| `Image` | `string` | — | ภาพแบนเนอร์ (100px) ที่แสดงใน header แท็บ |
| `IconThemed` | `boolean` | — | ระบายสีไอคอนด้วยสีธีม |
| `Locked` | `boolean` | — | เริ่มต้นด้วยแท็บในสถานะล็อค |
| `ShowTabTitle` | `boolean` | — | แสดงชื่อแท็บใน header เนื้อหา |
| `Profile` | `table` | — | การตั้งค่าการ์ดโปรไฟล์ (ดูด้านล่าง) |
| `SidebarProfile` | `boolean` | — | เรนเดอร์โปรไฟล์เป็นการ์ด sidebar แทน header เนื้อหา |

## โปรไฟล์

แท็บหนึ่งสามารถแสดง **โปรไฟล์** — การ์ดพร้อม avatar, แบนเนอร์, ตัวบ่งชี้สถานะ และปุ่ม badge ส่งตาราง `Profile`:

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | ชื่อที่แสดง |
| `Desc` | `string` | — | คำบรรยาย / ข้อความบทบาท |
| `Avatar` | `string` | — | ภาพ avatar |
| `Banner` | `string` | — | ภาพแบนเนอร์ |
| `Status` | `boolean` | — | แสดงตัวบ่งชี้สถานะ |
| `Badges` | `array` | — | รายการปุ่ม badge `{ Icon, Title, Desc, Callback }` |
| `Sticky` | `boolean` | `true` | คงโปรไฟล์ติดอยู่ขณะเลื่อน |

ตั้งค่า `SidebarProfile = true` เพื่อเรนเดอร์โปรไฟล์เป็นการ์ดใน sidebar; `false` (หรือไม่กรอก) แสดงเป็น header ใหญ่ในเนื้อหาแท็บ

```lua
local Badges = {
    {
        Icon = "geist:logo-discord",
        Title = "Discord",
        Desc = "Join ANHUB Discord",
        Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
            ANUI:Notify({ Title = "Discord", Content = "Invite link copied!", Icon = "geist:logo-discord", Duration = 3 })
        end
    },
    {
        Icon = "youtube",
        Desc = "Subscribe to YouTube",
        Callback = function()
            setclipboard("https://www.youtube.com/@ANHubRoblox")
            ANUI:Notify({ Title = "YouTube", Content = "Channel link copied!", Icon = "youtube", Duration = 3 })
        end
    },
}

-- การ์ด sidebar (ตกแต่ง, เรนเดอร์ใน sidebar)
Window:Tab({
    Profile = {
        Title = "AdityaNugraha",
        Desc = "Admin",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = true,
})

-- แท็บปกติพร้อม header โปรไฟล์ใหญ่
local UserTab = Window:Tab({
    Title = "Example Profile Content",
    Icon = "user",
    Profile = {
        Title = "User Settings",
        Desc = "Manage your account details here",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = false,
})

UserTab:Button({ Title = "Change Password", Callback = function() end })
UserTab:Button({ Title = "Log Out", Icon = "log-out", Callback = function() end })
```

## จัดกลุ่มแท็บด้วย section sidebar

`Window:Section({ Title = ... })` สร้าง header ที่มีป้ายกำกับใน sidebar เรียก `:Tab{}` บน section ที่คืนมาเพื่อเพิ่มแท็บใต้มัน

```lua
local ElementsSection = Window:Section({ Title = "Elements" })

local ToggleTab = ElementsSection:Tab({ Title = "Toggle", Icon = "arrow-left-right" })
local ButtonTab = ElementsSection:Tab({ Title = "Button", Icon = "mouse-pointer-click" })

local OtherSection = Window:Section({ Title = "Other" })
local DiscordTab = OtherSection:Tab({ Title = "Discord" })
```

## Method แท็บ

- `Tab:Select()` — สลับไปยังแท็บนี้
- `Tab:ScrollToTheElement(index)` — เลื่อนแท็บไปยังอิลิเมนต์ที่ระบุ
- `Tab:LockAll()` — ล็อคทุกอิลิเมนต์ในแท็บ
- `Tab:UnlockAll()` — ปลดล็อคทุกอิลิเมนต์ในแท็บ
- `Tab:GetLocked()` — ดึงอิลิเมนต์ที่ล็อคในแท็บ
- `Tab:GetUnlocked()` — ดึงอิลิเมนต์ที่ไม่ล็อคในแท็บ

ทุก method สร้างอิลิเมนต์ (`Tab:Button`, `Tab:Toggle`, …) ก็มีให้บนแท็บ — ดู [ภาพรวมอิลิเมนต์](/th/elements/)

## เลือกแท็บแบบโปรแกรม

สลับแท็บจากโค้ด ทั้งผ่าน window หรือแท็บเอง `Window:SelectTab` รับดัชนี ซึ่งมีให้บนแต่ละแท็บเป็น `Tab.Index`:

```lua
Window:SelectTab(UpgradeTab.Index)
-- หรือ, เทียบเท่ากับ:
UpgradeTab:Select()
```

## ที่เกี่ยวข้อง

- [ภาพรวมอิลิเมนต์](/th/elements/) — ทุกสิ่งที่คุณสามารถใส่ในแท็บ
- [Section (อิลิเมนต์)](/th/elements/section) — คอนเทนเนอร์ภายในแท็บที่ยุบได้
