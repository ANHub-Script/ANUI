# เริ่มใช้งานด่วน

สร้างเมนู ANUI แรกของคุณทีละขั้นตอน ในตอนท้ายคุณจะมี window ที่มีหนึ่ง tab บรรจุ toggle, button และ slider, บวกการแจ้งเตือน — script ที่สมบูรณ์และใช้งานได้

## 1. โหลด ANUI

ทุก script เริ่มต้นด้วยการโหลดไลบรารีลงใน local ชื่อ `ANUI`

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## 2. สร้าง window

`ANUI:CreateWindow` คืนค่าออบเจกต์ `Window` เป็นที่ที่คุณเพิ่มทุกสิ่ง `Folder` คือตำแหน่งจัดเก็บการตั้งค่าและ key บนดิสก์

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})
```

ดู [การตั้งค่าหน้าต่าง](/th/guide/window-configuration) สำหรับทุกตัวเลือก

## 3. เพิ่ม tab

Tab บรรจุอิลิเมนต์ของคุณ สร้างหนึ่งตัวด้วย `Window:Tab`

```lua
local Main = Window:Tab({ Title = "Main", Icon = "house" })
```

## 4. เพิ่มอิลิเมนต์

เพิ่มอิลิเมนต์โดยเรียก method บน tab สังเกตอาร์กิวเมนต์ที่แต่ละ callback รับ:

- **Toggle** — callback รับ `boolean` (สถานะ on/off ใหม่)
- **Button** — callback **ไม่รับอาร์กิวเมนต์**
- **Slider** — callback รับ **string ที่ฟอร์แมตแล้ว** (ค่าที่ฟอร์แมตตาม step)

```lua
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state) -- state: boolean
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "Do something",
    Callback = function() -- ไม่มีอาร์กิวเมนต์
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: string ที่ฟอร์แมตแล้ว
        print("Walk Speed:", value)
    end
})
```

## 5. แสดงการแจ้งเตือน

`ANUI:Notify` แสดง toast ฟิลด์ไอคอนคือ `Icon`; ฟิลด์ข้อความคือ `Content`

```lua
ANUI:Notify({
    Title = "Hello!",
    Content = "Welcome to ANUI",
    Icon = "bell",
    Duration = 3,
})
```

## Script ที่สมบูรณ์

รวมทุกอย่างเข้าด้วยกัน:

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})

local Main = Window:Tab({ Title = "Main", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "Do something",
    Callback = function()
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value)
        print("Walk Speed:", value)
    end
})

ANUI:Notify({
    Title = "Hello!",
    Content = "Welcome to ANUI",
    Icon = "bell",
    Duration = 3,
})
```

## ขั้นตอนถัดไป

- ตั้งค่า window อย่างเต็มที่ที่ [การตั้งค่าหน้าต่าง](/th/guide/window-configuration)
- สำรวจแต่ละอิลิเมนต์ที่ [ภาพรวมอิลิเมนต์](/th/elements/)
