# อิลิเมนต์

อิลิเมนต์เป็นคอนโทรลอินเทอแอคทีฟภายใน window ของคุณ — button, toggle, slider, dropdown, และอื่นๆ อิลิเมนต์ถูกสร้างเสมอจาก **container**: Tab, Section, หรือ Group

## การสร้างอิลิเมนต์

แต่ละอิลิเมนต์ถูกสร้างโดยการเรียก method บน container Container ที่พบมากที่สุดคือ Tab:

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "My Hub", Folder = "MyHub" })

-- 1. สร้าง container (Tab)
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

-- 2. สร้างอิลิเมนต์บนมัน
myTab:Button({ Title = "Click me", Callback = function() end })
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
```

`Section` และ `Group` ก็เป็น container — ทั้งสองมี method สร้างอิลิเมนต์ **เหมือนกัน** กับ Tab ดังนั้นคุณสามารถจัดเรียงอิลิเมนต์แบบซ้อนเพื่อทำให้เลย์เอาต์เป็นระเบียบ:

```lua
local section = myTab:Section({ Title = "Combat" })
section:Toggle({ Title = "God Mode", Callback = function(state) end })

local row = myTab:Group({})       -- จัดเรียงลูกๆ ในแนวนอน
row:Button({ Title = "Save" })
row:Button({ Title = "Load" })
```

::: tip
แต่ละ method สร้างอิลิเมนต์ส่งคืน module ที่คุณสามารถเรียก method ได้ (เช่น `local t = myTab:Toggle({...})` แล้ว `t:Set(true)`) บันทึกค่าที่ส่งคืนหากคุณวางแผนจะอัปเดตอิลิเมนต์นั้นในภายหลัง
:::

## Base ร่วมกัน

อิลิเมนต์อินเทอแอคทีฟส่วนใหญ่สร้างบน base เดียวกัน ดังนั้นพวกมันแบ่งปันชุด field การกำหนดค่าและ method เรียนรู้ครั้งเดียว และทุกอย่างใช้ได้ทุกที่

### การกำหนดค่าทั่วไป

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | ชื่ออิลิเมนต์ | ป้ายกำกับหลัก รองรับ [token rich-text](#rich-text-di-title-desc) |
| `Desc` | `string` | `nil` | บรรทัดคำอธิบายเพิ่มเติม รองรับ token rich-text, `\n`, และ `\t` |
| `Icon` | `string` | ขึ้นอยู่กับอิลิเมนต์ | ชื่อไอคอน (Lucide) หรือ `rbxassetid://…` |
| `Image` | `string` \| `table` | `nil` | รูปภาพชิดซ้าย (asset id หรือตารางการ์ด) |
| `ImageSize` | `number` | `30` | ขนาดรูปภาพซ้าย, เป็นพิกเซล |
| `Thumbnail` | `string` | `nil` | รูปภาพ thumbnail ขนาดใหญ่ |
| `ThumbnailSize` | `number` | `80` | ขนาด thumbnail, เป็นพิกเซล |
| `IconThemed` | `boolean` | `false` | ระบายสีไอคอนด้วยสีธีมปัจจุบัน |
| `Color` | `Color3` \| `string` | `nil` | พื้นหลังสี (ชื่อธีมหรือ `Color3`); สีข้อความปรับโดยอัตโนมัติ |
| `Justify` | `string` | `"Between"` | การจัดแนวเนื้อหาภายในแถวอิลิเมนต์ |
| `Locked` | `boolean` | `false` | แสดง overlay ล็อคและบล็อกการโต้ตอบ |
| `Buttons` | `table` | `nil` | ปุ่มอินไลน์ที่แสดงในแถวอิลิเมนต์ (ดูด้านล่าง) |
| `TitleGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความชื่อ |
| `DescGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความคำอธิบาย |

### Method ทั่วไป

Method ต่อไปนี้มีให้ในอิลิเมนต์อินเทอแอคทีฟส่วนใหญ่:

- `:SetTitle(text)` — อัปเดตชื่อ
- `:SetDesc(text)` — อัปเดตคำอธิบาย
- `:SetIcon(icon)` / `:SetImage(image)` — อัปเดตไอคอนหรือรูปภาพ
- `:Lock(text?)` — ล็อคอิลิเมนต์ (เพิ่มเติมด้วยข้อความ overlay)
- `:Unlock()` — ปลดล็อคอิลิเมนต์
- `:Highlight()` — กระพริบอิลิเมนต์ชั่วครู่เพื่อดึงดูดความสนใจ
- `:Destroy()` — ลบอิลิเมนต์
- `:SetButtons(buttons)` / `:GetButton(key)` / `:GetButtons()` — จัดการปุ่มอินไลน์

::: info
แต่ละอิลิเมนต์เพิ่ม method ของตัวเองบน base ร่วมกัน — เช่น `Toggle:Set(...)`, `Slider:SetMax(...)`, หรือ `Dropdown:Refresh(...)` ดูหน้าอิลิเมนต์แต่ละตัวสำหรับรายการทั้งหมด
:::

## Rich text di Title & Desc

`Title` และ `Desc` รับ token inline ที่ช่วยให้คุณแทรกไอคอน, รูปภาพ, gradient, แม้แต่ปุ่มโดยตรงภายในข้อความ:

- **ไอคอน inline** — `{icon}` หรือ `{name}`, พร้อมขนาดเพิ่มเติม: `{icon:star size=28}`
- **รูปภาพ inline** — เพียงแทรก referensi `rbxassetid://…` โดยตรงใน string
- **Gradient** — ห่อข้อความด้วย `<gradient>…</gradient>`, หรือระบุสีและการหมุน: `<gradient=#40c9ff,#e81cff|45>…</gradient>`
- **ปุ่ม inline** — `<button=key>Label</button>` หรือรูปแบบสั้น `{button:key}`, เชื่อมต่อกับรายการใน map `Buttons` ของอิลิเมนต์

`Desc` ยังรองรับ:

- `\n` — คำอธิบายหลายบรรทัด
- `\t` — บรรทัดสองคอลัมน์ (ป้ายกำกับซ้าย, ค่าขวา)

```lua
myTab:Button({
    Title = "Status: <gradient=#30FF6A,#e7ff2f>Online</gradient> {check}",
    Desc = "Ping\t24ms\nRegion\tSEA",
})
```

## การคงอยู่ของการกำหนดค่าด้วย Flag

อิลิเมนต์ที่มีสถานะ — **Toggle**, **Slider**, **Dropdown**, **Input**, **Keybind**, และ **Colorpicker** — รับ field `Flag` อิลิเมนต์ที่มี flag จะลงทะเบียนกับการกำหนดค่า active โดยอัตโนมัติ ทำให้ค่าถูกบันทึกและกู้คืนระหว่างเซสชัน

```lua
myTab:Toggle({ Title = "Auto Farm", Flag = "AutoFarm", Callback = function(state) end })
```

ดู [การกำหนดค่า & Flag](/th/features/config-and-flags) สำหรับขั้นตอนการทำงานทั้งหมด

## อิลิเมนต์ทั้งหมด

| อิลิเมนต์ | คำอธิบาย |
| --- | --- |
| [Button](/th/elements/button) | แถบการดำเนินการที่คลิกได้พร้อมไอคอนเพิ่มเติมและปุ่มอินไลน์ |
| [Toggle](/th/elements/toggle) | สวิตช์ on/off หรือ checkbox ที่รายงาน boolean |
| [Slider](/th/elements/slider) | Slider ตัวเลขที่ลากได้พร้อม stepping เพิ่มเติมและการป้อนข้อมูลด้วยตนเอง |
| [Dropdown](/th/elements/dropdown) | รายการ single หรือ multi-select; ยังสามารถทำหน้าที่เป็นเมนูการดำเนินการ |
| [Input](/th/elements/input) | Field ข้อความหนึ่งบรรทัดหรือหลายบรรทัด |
| [Keybind](/th/elements/keybind) | ผูกการดำเนินการกับปุ่ม, ทริกเกอร์ทั่วโลกเมื่อกด |
| [Colorpicker](/th/elements/colorpicker) | เลือกสี (พร้อมความโปร่งใสเพิ่มเติม) ผ่านไดอะล็อก |
| [Paragraph](/th/elements/paragraph) | บล็อคข้อความ rich พร้อม card รูปภาพเพิ่มเติมและปุ่มเรียงซ้อน |
| [Code](/th/elements/code) | บล็อคสนิปเปตโค้ดที่สามารถคัดลอกได้ |
| [Section](/th/elements/section) | Container ที่พับได้สำหรับจัดกลุ่มอิลิเมนต์ลูกใต้ header |
| [Divider](/th/elements/divider) | เส้นแบ่งแนวนอน (หรือแนวตั้ง, ภายใน Group) |
| [Space](/th/elements/space) | Spacer ที่มองไม่เห็นเพื่อให้ระยะห่างแนวตั้ง |
| [Image](/th/elements/image) | รูปภาพอิสระพรับการควบคุมอัตราส่วนภาพและการปรับขนาด |
| [Group](/th/elements/group) | Container ที่จัดเรียงลูกๆ ในแนวนอน |
| [Category](/th/elements/category) | แถบตัวเลือกแนวนอนสำหรับสลับระหว่างกลุ่มอิลิเมนต์ |
