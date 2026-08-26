# สรุป API

ทุกอย่างในหนึ่งหน้า ข้อมูลอ้างอิงอย่างรวดเร็วสำหรับพื้นผิว ANUI ทั้งหมด — call ระดับบนสุด, method Window และ Tab, ทุกอิลิเมนต์, และจุดเข้าฟีเจอร์ ตามลิงก์สำหรับรายละเอียดเต็ม

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## `ANUI` (ระดับบนสุด)

Method และ field บนออบเจกต์ไลบรารีเอง

| Call | ฟังก์ชัน |
| --- | --- |
| `ANUI:CreateWindow(config)` → `Window` | สร้าง window (สามารถมีได้เพียงหนึ่ง) |
| `ANUI:Notify(config)` → notification | แสดงการแจ้งเตือนแบบ toast |
| `ANUI:SetNotificationLower(bool)` | ย้ายการแจ้งเตือนไปด้านล่างของหน้าจอ |
| `ANUI:SetFont(fontId)` | ตั้งค่าฟอนต์ UI ระดับโกลบอล |
| `ANUI:OnThemeChange(fn)` | รัน `fn` ทุกครั้งที่ธีมเปลี่ยน |
| `ANUI:AddTheme(theme)` → theme | ลงทะเบียนธีมที่กำหนดเอง (ถูกล็อคโดย `.Name` ของมัน) |
| `ANUI:SetTheme(name)` → theme \| `nil` | เปลี่ยนเป็นธีมตามชื่อ |
| `ANUI:GetThemes()` | คืนค่าธีมที่ลงทะเบียนทั้งหมด |
| `ANUI:GetCurrentTheme()` | คืนค่าธีมที่ใช้งานอยู่ |
| `ANUI:GetTransparency()` | คืนค่าความโปร่งใสปัจจุบัน |
| `ANUI:GetWindowSize()` | คืนค่าขนาด window ปัจจุบัน |
| `ANUI:Localization(config)` | ตั้งค่าการแปลภาษา |
| `ANUI:SetLanguage(lang)` | เปลี่ยนภาษา (ต้องการการแปลภาษาที่ใช้งาน) |
| `ANUI:ToggleAcrylic(bool)` | เปิดหรือปิดเอฟเฟกต์เบลอ acrylic |
| `ANUI:Gradient(stops, props)` → gradient | สร้างตารางข้อมูล gradient (stops ถูกล็อค `"0"`..`"100"`) |
| `ANUI:Popup(config)` → `Popup` | เปิด popup modal |
| `ANUI:Scheduler(config)` → `Scheduler` | สร้างตัวกำหนดเวลาลูปอิสระ |
| `ANUI.Version` | สตริงเวอร์ชันไลบรารี (field, ไม่ใช่ method) |

## Method Window

คืนค่าโดย `ANUI:CreateWindow` จัดกลุ่มตามฟังก์ชัน; signature ใน backtick

**แท็บและคอนเทนเนอร์**

| Method | ฟังก์ชัน |
| --- | --- |
| `Window:Tab(config)` | เพิ่มแท็บ (หน้า sidebar ที่บรรจุอิลิเมนต์) |
| `Window:Section(config)` | เพิ่ม section sidebar ที่จัดกลุ่มแท็บ |
| `Window:SelectTab(index)` | สลับไปยังแท็บตามดัชนี |
| `Window:Divider()` | เพิ่มเส้นแบ่งใน sidebar |
| `Window:Tag(config)` | เพิ่ม tag/badge เล็กๆ (เช่น เวอร์ชัน) บน window |

**ไดอะล็อก**

| Method | ฟังก์ชัน |
| --- | --- |
| `Window:Dialog({ Title, Content, Icon, Width, Buttons })` | เปิดไดอะล็อก modal แต่ละปุ่มเป็น `{ Title, Icon, Callback, Variant }` (`Width` ค่าเริ่มต้น `320`) |

**Lifecycle และ callback**

| Method | ฟังก์ชัน |
| --- | --- |
| `Window:Open()` / `Window:Close()` / `Window:Toggle()` | แสดง, ซ่อน, หรือสลับ window |
| `Window:Destroy()` | ทำลาย window และล้างข้อมูล |
| `Window:OnOpen(fn)` / `Window:OnClose(fn)` / `Window:OnDestroy(fn)` | รัน `fn` เมื่อเกิด event ที่ตรงกัน |

**การแสดงผล**

| Method | ฟังก์ชัน |
| --- | --- |
| `Window:SetTitle(t)` / `Window:SetAuthor(t)` | อัปเดตชื่อเรื่อง / คำบรรยาย |
| `Window:SetIconSize(n \| UDim2)` | เปลี่ยนขนาดไอคอน top-bar |
| `Window:SetBackgroundImage(id)` / `Window:SetBackgroundImageTransparency(v)` | ตั้งค่าภาพพื้นหลังและความโปร่งใส |
| `Window:SetBackgroundTransparency(v)` / `Window:ToggleTransparency(bool)` | ปรับหรือสลับความโปร่งใสของ window |
| `Window:SetToTheCenter()` | จัด window กลับไปกึ่งกลางหน้าจอ |
| `Window:GetUIScale()` / `Window:SetUIScale(v)` | อ่านหรือตั้งค่าสเกล UI |
| `Window:IsResizable(bool)` | เปิดหรือปิดการปรับขนาด |

**Sidebar**

| Method | ฟังก์ชัน |
| --- | --- |
| `Window:CollapseSidebar()` / `Window:ExpandSidebar()` / `Window:ToggleSidebar(state?)` | ยุบ, ขยาย, หรือสลับ sidebar |

**Toggle key**

| Method | ฟังก์ชัน |
| --- | --- |
| `Window:SetToggleKey(keycode)` | ตั้งค่า hotkey แสดง/ซ่อน (เป็น `Enum.KeyCode`) |

**Lock**

| Method | ฟังก์ชัน |
| --- | --- |
| `Window:LockAll()` / `Window:UnlockAll()` | ล็อคหรือปลดล็อคทุกอิลิเมนต์ |
| `Window:GetLocked()` / `Window:GetUnlocked()` | รายการอิลิเมนต์ที่ล็อค / ไม่ล็อค |

**Topbar**

| Method | ฟังก์ชัน |
| --- | --- |
| `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` | เพิ่มปุ่ม top-bar ที่กำหนดเอง |
| `Window:DisableTopbarButtons({ names })` | ซ่อนปุ่ม top-bar ในตัวตามชื่อ |

**ปุ่มเปิด**

| Method | ฟังก์ชัน |
| --- | --- |
| `Window:EditOpenButton(config)` | แก้ไขปุ่มเปิดลอย |

**ลูปและตัวกำหนดเวลา**

| Method | ฟังก์ชัน |
| --- | --- |
| `Window:Loop(key, interval, fn, opts?)` | รัน `fn` ทุก `interval` วินาที |
| `Window:StatusLoop(key, interval, fn)` | ลูปที่มีไว้สำหรับอัปเดตข้อความสถานะ |
| `Window:ManagedLoop(key, interval, predicate, fn)` | ลูปที่รันเฉพาะเมื่อ `predicate` คืนค่า true |
| `Window:StopLoop(key)` / `Window:StopAllLoops()` | หยุดหนึ่งลูป, หรือทั้งหมด |
| `Window:IsLoopRunning(key)` / `Window:GetActiveLoopCount()` | ค้นหาสถานะลูป |
| `Window:AddConnection(conn)` / `Window:DisconnectAll()` | ติดตามและล้าง connection |
| `Window:IsReady()` | ว่า window การเริ่มต้นเสร็จสมบูรณ์หรือยัง |

## Method Tab

| Method | ฟังก์ชัน |
| --- | --- |
| `Tab:Select()` | ทำให้นี่เป็นแท็บที่ใช้งานอยู่ |
| `Tab:ScrollToTheElement(index)` | เลื่อนไปยังอิลิเมนต์ตามดัชนี |
| `Tab:LockAll()` / `Tab:UnlockAll()` | ล็อคหรือปลดล็อคทุกอิลิเมนต์ในแท็บ |
| `Tab:GetLocked()` / `Tab:GetUnlocked()` | รายการอิลิเมนต์ที่ล็อค / ไม่ล็อคในแท็บ |
| `Tab:ReserveHeader(height, config)` | สงวนพื้นที่ header คงที่ด้านบนแท็บ |

::: info
Tab หนึ่งยังเปิดเผย **ทุก method สร้างอิลิเมนต์** — `Tab:Button{}`, `Tab:Toggle{}`, `Tab:Slider{}` และอื่นๆ `Section` และ `Group` เป็นคอนเทนเนอร์พร้อม method อิลิเมนต์เดียวกัน
:::

## ข้อมูลอ้างอิงอิลิเมนต์อย่างรวดเร็ว

หนึ่งบรรทัดต่ออิลิเมนต์ อาร์กิวเมนต์ callback คือสิ่งที่ฟังก์ชัน `Callback` ของคุณรับ

| อิลิเมนต์ | Signature | Config หลัก | อาร์กิวเมนต์ callback |
| --- | --- | --- | --- |
| [Button](/th/elements/button) | `Tab:Button{}` | `Callback`, `Icon` | ไม่มี |
| [Toggle](/th/elements/toggle) | `Tab:Toggle{}` | `Value`, `Type` | `boolean` |
| [Slider](/th/elements/slider) | `Tab:Slider{}` | `Value { Min, Max, Default }`, `Step` | `string` ที่ฟอร์แมตแล้ว |
| [Dropdown](/th/elements/dropdown) | `Tab:Dropdown{}` | `Values`, `Multi` | ค่าที่เลือก (เดี่ยว) / array (หลายตัว) |
| [Input](/th/elements/input) | `Tab:Input{}` | `Placeholder`, `Type` | `string` |
| [Keybind](/th/elements/keybind) | `Tab:Keybind{}` | `Value` (ชื่อ key) | `string` ชื่อ key |
| [Colorpicker](/th/elements/colorpicker) | `Tab:Colorpicker{}` | `Default`, `Transparency` | `(Color3, transparency)` |
| [Paragraph](/th/elements/paragraph) | `Tab:Paragraph{}` | `Title`, `Desc`, `Images` | — |
| [Code](/th/elements/code) | `Tab:Code{}` | `Code`, `OnCopy` | — |
| [Section](/th/elements/section) | `Tab:Section{}` | `Title`, `Opened` | — |
| [Divider](/th/elements/divider) | `Tab:Divider()` | — | — |
| [Space](/th/elements/space) | `Tab:Space{}` | `Columns` | — |
| [Image](/th/elements/image) | `Tab:Image{}` | `Image`, `AspectRatio` | — |
| [Group](/th/elements/group) | `Tab:Group{}` | — (คอนเทนเนอร์) | — |
| [Category](/th/elements/category) | `Tab:Category{}` | `Options`, `Default` | ชื่อตัวเลือกที่เลือก (`string`) |

## ข้อมูลอ้างอิงฟีเจอร์อย่างรวดเร็ว

| ฟีเจอร์ | Call เข้า | เอกสาร |
| --- | --- | --- |
| การแจ้งเตือน | `ANUI:Notify{}` | [การแจ้งเตือน](/th/features/notifications) |
| ไดอะล็อกและป๊อปอัป | `Window:Dialog{}` · `ANUI:Popup{}` | [ไดอะล็อกและป๊อปอัป](/th/features/dialogs-and-popups) |
| การตั้งค่าและ Flag | `Window.ConfigManager` · `Flag = "..."` | [การตั้งค่าและ Flag](/th/features/config-and-flags) |
| ระบบ Key | `ANUI:CreateWindow{ KeySystem = {...} }` | [ระบบ Key](/th/features/key-system) |
| ธีม | `ANUI:SetTheme(name)` · `ANUI:AddTheme{}` | [ธีมและรูปลักษณ์](/th/features/themes) |
| การแปลภาษา | `ANUI:Localization{}` · `ANUI:SetLanguage(lang)` | [การแปลภาษา](/th/features/localization) |
| ตัวกำหนดเวลาและลูป | `ANUI:Scheduler{}` · `Window:Loop(...)` | [ตัวกำหนดเวลาและลูป](/th/features/scheduler) |
