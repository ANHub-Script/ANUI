# เมนูพื้นฐาน

เมนูเริ่มต้นที่สมบูรณ์และมีคอมเมนต์มากมาย พร้อมให้คุณคัดลอก วาง และรัน มันสร้างหน้าต่างที่มีสองแท็บ ผสมผสานองค์ประกอบที่พบบ่อยที่สุด มี section สำหรับการจัดกลุ่ม และการแจ้งเตือนที่ถูกทริกเกอร์จากปุ่ม

## สคริปต์

```lua
-- 1. โหลด ANUI เข้าสู่ local ชื่อ `ANUI`
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

-- 2. สร้าง window มีได้เพียงหนึ่ง window เท่านั้น
local Window = ANUI:CreateWindow({
    Title = "My Hub",                      -- ชื่อใน top bar
    Author = "by you",                     -- ชื่อรองใต้ชื่อหลัก
    Icon = "rbxassetid://84366761557806",  -- ไอคอน top-bar (asset id หรือชื่อไอคอน Lucide)
    Folder = "MyHub",                      -- โฟลเดอร์ดิสก์สำหรับ config/key (บันทึกใน ANUI/MyHub)
    OpenButton = {                         -- ปุ่มลอยสำหรับเปิด window อีกครั้งเมื่อปิด
        Title = "My Hub",
        Enabled = true,
        Draggable = true,
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
    },
})

-- 3. เพิ่ม tab แต่ละ tab บรรจุองค์ประกอบและปรากฏใน sidebar
local Main = Window:Tab({ Title = "Main", Icon = "house" })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

-- 4. Paragraph เป็นบล็อก rich-text — เหมาะเป็นการแนะนำด้านบน tab
Main:Paragraph({
    Title = "Welcome",
    Desc = "This starter menu shows the most common ANUI elements.",
})

-- Toggle — callback รับ BOOLEAN (สถานะ on/off ใหม่)
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Value = false,
    Callback = function(state) -- state: boolean
        print("Auto Farm:", state)
    end,
})

-- Slider — callback รับ STRING ที่จัดรูปแบบแล้ว (ค่าที่จัดรูปแบบตาม step)
Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: string ที่จัดรูปแบบแล้ว
        print("Walk Speed:", value)
    end,
})

-- 5. Section จัดกลุ่มองค์ประกอบที่เกี่ยวข้องใต้ header ที่พับได้
--    นี่เป็น container ดังนั้นคุณสร้างองค์ประกอบบน section โดยตรง
local combat = Main:Section({ Title = "Combat" })

-- Dropdown — callback single-select รับค่าที่เลือก (ที่นี่เป็น string)
combat:Dropdown({
    Title = "Weapon",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value) -- value: รายการที่เลือก
        print("Weapon:", value)
    end,
})

-- Keybind — callback รับ NAMA KEY เป็น string (เช่น "G")
combat:Keybind({
    Title = "Attack Key",
    Value = "G",
    Callback = function(key) -- key: string ชื่อ key
        print("Attack bound to:", key)
    end,
})

-- 6. Button รัน callback โดยไม่มีอาร์กิวเมนต์ ที่นี่มันแสดงการแจ้งเตือน
Settings:Button({
    Title = "Say Hello",
    Icon = "bell",
    Callback = function() -- ไม่มีอาร์กิวเมนต์
        ANUI:Notify({
            Title = "Hello!",
            Content = "Welcome to ANUI",
            Icon = "bell",
            Duration = 3,
        })
    end,
})
```

## หน้าที่ของแต่ละส่วน

- **บรรทัด load** — ดึง library และกำหนดให้ `ANUI` ทุกตัวอย่างเริ่มต้นแบบนี้
- **`ANUI:CreateWindow`** — ส่งคืน `Window` ที่คุณสร้าง `Folder` เป็นตำแหน่ง config และ key ในดิสก์ `OpenButton` เพิ่มปุ่มลอยที่ลากได้เพื่อเปิด window อีกครั้ง ดู [การกำหนดค่า Window](/th/guide/window-configuration)
- **`Window:Tab`** — แต่ละ tab เป็นหน้าใน sidebar และเป็น container สำหรับองค์ประกอบ
- **องค์ประกอบ** — สร้างโดยเรียก method บน container (Tab หรือ Section) เก็บค่าที่ส่งคืนหากต้องการอัปเดตองค์ประกอบในภายหลัง
- **`Main:Section`** — container ที่พับได้และเปิดเผย method องค์ประกอบเหมือน Tab ทำให้คุณสามารถจัดกลุ่มตัวควบคุมที่เกี่ยวข้อง
- **`ANUI:Notify`** — แสดง toast ฟิลด์ข้อความคือ `Content` (ไม่ใช่ `Desc`) และฟิลด์ไอคอนคือ `Icon`

::: tip เรียนรู้แต่ละองค์ประกอบ
แต่ละองค์ประกอบมีหน้าของตัวเองพร้อมตาราง config และ method ครบถ้วน: [Toggle](/th/elements/toggle), [Slider](/th/elements/slider), [Dropdown](/th/elements/dropdown), [Button](/th/elements/button), [Keybind](/th/elements/keybind), [Paragraph](/th/elements/paragraph), และ [Section](/th/elements/section) สำรวจทั้งหมดที่ [ภาพรวมองค์ประกอบ](/th/elements/)
:::
