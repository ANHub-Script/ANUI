# บทนำ

ANUI (Advanced Roblox UI Library) เป็นไลบรารี UI สมัยใหม่และเต็มไปด้วยฟีเจอร์สำหรับ executor script Roblox ด้วย ANUI คุณสามารถสร้างเมนูที่เรียบร้อยและรองรับมือถือ — window, tab, toggle, slider, dropdown และอื่นๆ — ในไม่กี่บรรทัด Lua

## ANUI คืออะไร?

ANUI แสดงหน้าต่างลอยที่สามารถลากและปรับขนาดได้เหนือ experience Roblox ใดๆ คุณอธิบายเมนูแบบ declarative — สร้าง window, เพิ่ม tab, เติมด้วยอิลิเมนต์ — และ ANUI จัดการ layout, ธีม, input, animation และการจัดเก็บให้คุณ

เนื่องจากโหลดผ่าน HTTP ด้วย `loadstring` เพียงหนึ่งครั้ง ไม่มีอะไรต้องติดตั้งหรือรวมไว้: วางหนึ่งบรรทัดและเมนูของคุณพร้อมใช้งาน

## คุณสามารถสร้างอะไรได้บ้าง

- Hub ฟีเจอร์และเมนู cheat ที่มี tab และ section sidebar ที่จัดเรียงอย่างดี
- แผงการตั้งค่าที่สถานะยังคงอยู่ระหว่างเซสชันผ่าน [การตั้งค่าและ Flag](/th/features/config-and-flags)
- Script ที่ล็อคด้วย key โดยใช้ [ระบบ Key](/th/features/key-system) ในตัว
- Dashboard ที่หลากหลายพร้อมโปรไฟล์, badge, การแจ้งเตือน และไดอะล็อก

## จุดเด่นของฟีเจอร์

- 15+ [อิลิเมนต์](/th/elements/) — button, toggle, slider, dropdown, colorpicker, keybind, input, บล็อกโค้ด และอื่นๆ
- [26 ธีมในตัว](/th/features/themes), บวกพาเลตที่คุณสร้างเอง
- [การตั้งค่าและ flag](/th/features/config-and-flags) เพื่อบันทึกสถานะอิลิเมนต์ใดๆ ลงดิสก์
- [ระบบ key](/th/features/key-system) พร้อม provider Luarmor, Platoboost และ PandaDevelopment
- [การแจ้งเตือน](/th/features/notifications) และ [ไดอะล็อกและ popup](/th/features/dialogs-and-popups)
- [การแปลภาษา](/th/features/localization) สำหรับเมนูหลายภาษา
- [ตัวกำหนดเวลา](/th/features/scheduler) แบบไร้ drift สำหรับลูปที่จัดการได้
- [การปรับขนาดรองรับมือถือและเบลอ acrylic](/th/guide/window-configuration)

## ความต้องการ

ANUI ทำงานภายใน executor script Roblox Executor ของคุณต้องรองรับ:

- `loadstring` และ `game:HttpGet` — จำเป็นสำหรับโหลดไลบรารี
- `readfile`, `writefile`, `isfile`, `makefolder` — จำเป็นเฉพาะสำหรับบันทึกการตั้งค่าและ key

::: info หนึ่ง window เท่านั้น
หนึ่ง window เท่านั้นที่สามารถมีได้ในแต่ละเวลา การเรียก `ANUI:CreateWindow` เป็นครั้งที่สองจะแสดงคำเตือนและคืนค่า `nil`
:::

## เครดิต

- พัฒนาต่อยอดจาก **WindUI โดย Footagesus**
- ไอคอนโดย [Lucide](https://lucide.dev)
- ขอบคุณ Dawid-Scripts

## ลิงก์

- GitHub: [github.com/ANHub-Script/ANUI](https://github.com/ANHub-Script/ANUI)
- Discord: [discord.gg/bUkCZvmrpH](https://discord.gg/qN47S3mKZA)
- YouTube: [@ANHubRoblox](https://www.youtube.com/@ANHubRoblox)

---

ถัดไป: [การติดตั้ง](/th/guide/installation)
