---
layout: home
title: ANUI
titleTemplate: ไลบรารี UI Roblox ขั้นสูง

hero:
  name: ANUI
  text: ไลบรารี UI Roblox ขั้นสูง
  tagline: ไลบรารี UI สมัยใหม่และเต็มไปด้วยฟีเจอร์สำหรับ executor script Roblox สร้างเมนูที่สวยงามและรองรับมือถือได้ในไม่กี่บรรทัด
  image:
    src: /logo.svg
    alt: โลโก้ ANUI
  actions:
    - theme: brand
      text: เริ่มต้น
      link: /th/guide/introduction
    - theme: alt
      text: การติดตั้ง
      link: /th/guide/installation
    - theme: alt
      text: ดูบน GitHub
      link: https://github.com/ANHub-Script/ANUI

features:
  - icon: 🧩
    title: 15+ อิลิเมนต์
    details: Button, toggle, slider, dropdown, colorpicker, keybind, input, บล็อกโค้ด และอื่นๆ — ทุกสิ่งที่คุณต้องการเพื่อสร้างเมนูที่สมบูรณ์
    link: /th/elements/
    linkText: สำรวจอิลิเมนต์
  - icon: 🎨
    title: 26 ธีมในตัว
    details: มี Dark, Light, Dracula, Tokyo Night, Nord, Gruvbox และอีก 20 ธีม — หรือลงทะเบียนพาเลตของคุณเองด้วยการเรียกเพียงครั้งเดียว
    link: /th/features/themes
    linkText: คู่มือธีม
  - icon: 💾
    title: การตั้งค่าและ Flag
    details: บันทึกสถานะของอิลิเมนต์ใดๆ ลงดิสก์ด้วย Flag เพียงหนึ่ง และกู้คืนอัตโนมัติเมื่อ script ของคุณทำงานอีกครั้ง
    link: /th/features/config-and-flags
    linkText: การตั้งค่าและ flag
  - icon: 🔑
    title: ระบบ Key
    details: ล็อค script ของคุณด้วย key รองรับ Luarmor, Platoboost และ PandaDevelopment — หรือ validator ที่คุณสร้างเอง
    link: /th/features/key-system
    linkText: ระบบ key
  - icon: 🔔
    title: การแจ้งเตือนและไดอะล็อก
    details: การแจ้งเตือนแบบ toast, ไดอะล็อก modal และ popup พร้อมใช้งาน — พร้อมไอคอน, ปุ่ม และแถบความคืบหน้า
    link: /th/features/notifications
    linkText: การแจ้งเตือน
  - icon: ⏱️
    title: ตัวกำหนดเวลาอัจฉริยะ
    details: ลูปแบบไร้ drift พร้อมการป้องกันการทับซ้อนที่หยุดอัตโนมัติเมื่อปิดหน้าต่าง
    link: /th/features/scheduler
    linkText: ตัวกำหนดเวลาและลูป
---

## ตัวอย่างสั้นๆ

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "Hub ของฉัน",
    Author = "โดยคุณ",
    Icon = "rbxassetid://84366761557806",
    Folder = "HubSaya",
})

local Main = Window:Tab({ Title = "หลัก", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Desc = "ฟาร์มเหรียญอัตโนมัติ",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "แสดงการแจ้งเตือน",
    Callback = function()
        ANUI:Notify({ Title = "สวัสดี!", Content = "ยินดีต้อนรับสู่ ANUI", Icon = "bell", Duration = 3 })
    end
})
```

นี่คือเมนูที่สมบูรณ์และใช้งานได้ ไปต่อที่ [เริ่มใช้งานด่วน](/th/guide/getting-started) เพื่อสร้างมันทีละขั้นตอน
