# การตั้งค่าหน้าต่าง

Window คือรากของทุกเมนู ANUI คุณสร้างมันหนึ่งครั้งด้วย `ANUI:CreateWindow{}`, ส่งตารางการตั้งค่าหนึ่งตาราง หน้านี้บันทึกทุกฟิลด์และ method ที่มีบนออบเจกต์ `Window` ที่คืนมา

::: info หนึ่ง window เท่านั้น
หนึ่ง window เท่านั้นที่สามารถมีได้ในแต่ละเวลา การเรียก `ANUI:CreateWindow` ครั้งที่สองจะแสดงคำเตือนและคืนค่า `nil`
:::

## ตัวอย่างพื้นฐาน

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
    Theme = "Dark",
})
```

## การตั้งค่า

### Identity

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | ข้อความชื่อเรื่อง window |
| `Author` | `string` | — | คำบรรยายที่แสดงใต้ชื่อเรื่อง |
| `Icon` | `string` | — | ไอคอน window: ชื่อไอคอน Lucide หรือ `rbxassetid://…` |
| `IconSize` | `number` \| `UDim2` | `22` | ขนาดไอคอนเป็นพิกเซล |
| `IconThemed` | `boolean` | — | ระบายสีไอคอนด้วยสีไอคอนจากธีม |

### Storage

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Folder` | `string` | — | โฟลเดอร์จัดเก็บบนดิสก์ การตั้งค่านี้จะเปิดใช้งาน [ระบบการตั้งค่า](/th/features/config-and-flags) และตัวเลือก `SaveKey` บน [ระบบ key](/th/features/key-system) การตั้งค่าถูกเขียนไปที่ `ANUI/<Folder>/config/<name>.json` |

### Size & scaling

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Size` | `UDim2` | `580 × 460` (ถูกจำกัด) | ขนาดเริ่มต้นของ window |
| `MinSize` | `Vector2` | `850 × 560` | ขนาดขั้นต่ำเมื่อปรับขนาด |
| `MaxSize` | `Vector2` | `1050 × 560` | ขนาดสูงสุดเมื่อปรับขนาด |
| `Resizable` | `boolean` | `true` | อนุญาตให้ผู้ใช้ปรับขนาด window |
| `AutoScale` | `boolean` | `true` | ปรับขนาด UI อัตโนมัติ (รองรับมือถือ) |

### Appearance

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Theme` | `string` | `"Dark"` | ชื่อธีม — ดู [ธีม](/th/features/themes) |
| `Transparent` | `boolean` | `false` | ใช้พื้นหลัง window โปร่งใส |
| `Acrylic` | `boolean` | `false` | เบลอ acrylic หลัง window |
| `Background` | `Color3` \| image id \| `"https://…"` \| `"video:…"` \| ตาราง gradient | — | พื้นหลัง window ที่กำหนดเอง |
| `BackgroundImageTransparency` | `number` | `0` | ความโปร่งใสของภาพพื้นหลัง |
| `ShadowTransparency` | `number` | `0.7` | ความโปร่งใสของเงา window |
| `Radius` | `number` | `16` | รัศมีมุม window |
| `ElementsRadius` | `number` | — | รัศมีมุมที่ใช้กับอิลิเมนต์ |
| `SideBarWidth` | `number` | `200` | ความกว้าง sidebar เป็นพิกเซล |
| `HidePanelBackground` | `boolean` | `false` | ซ่อนพื้นหลังแผงเนื้อหา |
| `ScrollBarEnabled` | `boolean` | `false` | แสดง scrollbar เนื้อหา |

### Behavior

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `ToggleKey` | `Enum.KeyCode` | — | ปุ่มสำหรับแสดง / ซ่อน window |
| `HideSearchBar` | `boolean` | `true` | ซ่อน search bar อิลิเมนต์ ตั้งค่า `false` เพื่อแสดง |
| `NewElements` | `boolean` | `false` | ใช้สไตล์อิลิเมนต์เวอร์ชันใหม่ |
| `IgnoreAlerts` | `boolean` | `false` | ระงับ popup alert ในตัว |

### Sub-config

ฟิลด์ต่อไปนี้รับตารางการตั้งค่าของมันเองและบันทึกไว้ในหน้าเฉพาะ

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `OpenButton` | `table` | — | ปุ่มลอยเพื่อเปิด window อีกครั้ง ดู [ปุ่มเปิด](/th/features/open-button) |
| `KeySystem` | `table` | — | ล็อคเมนูด้วย key ดู [ระบบ Key](/th/features/key-system) |
| `User` | `table` | — | บล็อคแสดงผู้ใช้: `{ Enabled, Anonymous, Callback }` |

## Method window

เมื่อคุณมี `Window`, method ต่อไปนี้ควบคุมมันขณะ runtime

### Lifecycle

- `Window:Open()` — แสดง window
- `Window:Close()` — ซ่อน window; คืนค่าออบเจกต์พร้อม `:Destroy()`
- `Window:Destroy()` — ลบ window อย่างถาวร
- `Window:Toggle()` — สลับระหว่างเปิดและปิด
- `Window:OnOpen(fn)` — รัน `fn` ทุกครั้งที่ window เปิด
- `Window:OnClose(fn)` — รัน `fn` ทุกครั้งที่ window ปิด
- `Window:OnDestroy(fn)` — รัน `fn` เมื่อ window ถูกทำลาย

### Appearance

- `Window:SetTitle(text)` — เปลี่ยนชื่อเรื่อง
- `Window:SetAuthor(text)` — เปลี่ยนคำบรรยาย
- `Window:SetIconSize(n | UDim2)` — เปลี่ยนขนาดไอคอน window
- `Window:SetBackgroundImage(id)` — เปลี่ยนภาพพื้นหลัง
- `Window:ToggleTransparency(bool)` — สลับพื้นหลังโปร่งใส
- `Window:SetUIScale(v)` — ตั้งค่าสเกล UI (อ่านค่ากลับด้วย `Window:GetUIScale()`)

### Sidebar

- `Window:CollapseSidebar()` — ยุบ sidebar
- `Window:ExpandSidebar()` — ขยาย sidebar
- `Window:ToggleSidebar(state?)` — สลับ, หรือบังคับเป็นสถานะหนึ่งถ้า `state` ถูกกำหนด

```lua
task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
```

### Toggle key

- `Window:SetToggleKey(keycode)` — เปลี่ยนปุ่มแสดง / ซ่อนขณะ runtime

```lua
Window:SetToggleKey(Enum.KeyCode.G)
```

### Locks

- `Window:LockAll()` — ล็อคทุกอิลิเมนต์ใน window
- `Window:UnlockAll()` — ปลดล็อคทุกอิลิเมนต์ใน window

### Topbar

- `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` — เพิ่มปุ่มใน top bar ของ window
- `Window:DisableTopbarButtons({names})` — ปิดใช้งานปุ่ม topbar ที่ระบุตามชื่อ

### Tag

`Window:Tag(cfg)` เพิ่มป้าย tag เล็กๆ บน window — สะดวกสำหรับแสดง badge เวอร์ชัน

```lua
Window:Tag({ Title = "v" .. ANUI.Version, Icon = "github" })
```

### Dialog

`Window:Dialog{}` เปิดไดอะล็อก modal ดู [ไดอะล็อกและป๊อปอัป](/th/features/dialogs-and-popups)

### Loop

`Window:Loop`, `Window:StatusLoop`, `Window:ManagedLoop` และอื่นๆ รันลูปที่จัดการซึ่งหยุดอัตโนมัติเมื่อ window ปิดหรือถูกทำลาย ดู [ตัวกำหนดเวลาและลูป](/th/features/scheduler)

## ขั้นตอนถัดไป

- เพิ่ม [แท็บและเซกชัน](/th/guide/tabs-and-sections) เพื่อจัดระเบียบเมนูของคุณ
- เปลี่ยนรูปลักษณ์ของทุกสิ่งด้วย [ธีม](/th/features/themes)
