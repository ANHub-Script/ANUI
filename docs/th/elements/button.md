# Button

แถบการดำเนินการที่คลิกได้พร้อมไอคอน สี และปุ่มอินไลน์ที่เลือกได้ Button เป็นอิลิเมนต์อินเทอแอคทีฟที่เรียบง่ายที่สุด — มันรัน callback เมื่อถูกคลิก

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({
    Title = "Click me",
    Callback = function()
        print("Button clicked!")
    end
})
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `"Button"` | ป้ายกำกับหลัก รองรับ [token rich-text](/th/elements/#rich-text-di-title-desc) |
| `Desc` | `string` | `nil` | คำอธิบายเพิ่มเติมที่อยู่ใต้ชื่อ |
| `Icon` | `string` | `"mouse-pointer-click"` | ชื่อไอคอนหรือ `rbxassetid://…` |
| `IconThemed` | `boolean` | `false` | ระบายสีไอคอนด้วยสีธีมปัจจุบัน |
| `Color` | `Color3` \| `string` | `nil` | พื้นหลังสี (ชื่อธีมหรือ `Color3`); สีข้อความปรับโดยอัตโนมัติ |
| `Justify` | `string` | `"Between"` | การจัดแนวเนื้อหา `"Between"` กระจายชื่อและไอคอน; `"Center"` จัดกึ่งกลางทั้งสอง |
| `IconAlign` | `string` | `"Right"` | ด้านที่ไอคอนอยู่: `"Right"` หรือ `"Left"` |
| `Locked` | `boolean` | `false` | แสดง overlay ล็อคและบล็อกการคลิก |
| `Callback` | `function` | `nil` | ทำงานเมื่อ button ถูกคลิก **ไม่รับอาร์กิวเมนต์** |
| `Buttons` | `table` | `nil` | ปุ่มอินไลน์ที่แสดงในแถว |
| `TitleGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความชื่อ |
| `DescGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความคำอธิบาย |

::: info ลายเซ็น callback
`Callback` ของ Button **ไม่รับอาร์กิวเมนต์** — มันเป็นเพียงตัวจัดการการดำเนินการปกติ หากคุณต้องการตอบสนองต่อค่า ให้ใช้ [Toggle](/th/elements/toggle) หรือ [Dropdown](/th/elements/dropdown)
:::

Button ยังสืบทอดการกำหนดค่า [base ร่วมกัน](/th/elements/#base-bersama) (`Image`, `Thumbnail`, gradient, token rich-text ใน `Title`/`Desc` และอื่นๆ)

## Method

### `Button:Highlight()`

กระพริบ button ชั่วครู่เพื่อดึงดูดความสนใจของผู้ใช้

```lua
local btn = myTab:Button({ Title = "Notice me", Callback = function() end })
btn:Highlight()
```

### `Button:Lock()` / `Button:Unlock()`

ล็อคหรือปลดล็อค button Button ที่ล็อคจะแสดง overlay และเพิกเฉยการคลิก

```lua
btn:Lock()
btn:Unlock()
```

### `Button:SetTitle(text)` / `Button:SetDesc(text)` / `Button:SetIcon(icon)`

อัปเดตชื่อ คำอธิบาย หรือไอคอนขณะรันไทม์

```lua
btn:SetTitle("Updated title")
btn:SetDesc("Updated description")
btn:SetIcon("check")
```

### `Button:SetButtons(buttons)` / `Button:GetButton(key)` / `Button:GetButtons()`

จัดการปุ่มอินไลน์ที่แสดงในแถว `SetButtons` แทนที่ map, `GetButton` ดึงหนึ่งตัวตาม key, และ `GetButtons` ส่งคืนทั้งหมด

### `Button:Destroy()`

ลบ button ออกจาก container

## ตัวอย่าง

### พื้นฐานและมีสี

```lua
myTab:Button({
    Title = "Highlight Button",
    Icon = "mouse",
    Callback = function()
        print("clicked highlight")
    end
})

myTab:Button({
    Title = "Blue Button",
    Desc = "With description",
    Color = Color3.fromHex("#305dff"),
    Icon = "",
    Callback = function() end
})
```

### การจัดแนวไอคอนและการจัดช่อง

```lua
myTab:Button({
    Title = "Left Icon",
    Desc = "Icon aligned to the left",
    Icon = "mouse",
    IconAlign = "Left",
    Justify = "Center",
    Callback = function() end
})
```

### ไอคอนธีมและมีสี

```lua
myTab:Button({
    Title = "Themed Icon",
    Desc = "Icon follows theme colors",
    Icon = "palette",
    IconThemed = true,
    Callback = function() end
})

myTab:Button({
    Title = "Colored Icon",
    Desc = "Icon tinted with custom color",
    Icon = "mouse-pointer-click",
    Color = Color3.fromHex("#f57c00"),
    Callback = function() end
})
```

### ล็อค

```lua
myTab:Button({
    Title = "Button",
    Desc = "Button example",
    Locked = true
})
```

### อัปเดตผ่านโค้ด

บันทึก module ที่ส่งคืนและอัปเดตจาก button อื่น `Highlight()` ดึงดูดความสนใจไปยังการเปลี่ยนแปลงนั้น

```lua
local progBtn = myTab:Button({
    Title = "Programmatic Button",
    Desc = "Will be updated by code",
    Icon = "edit",
    Callback = function() end
})

myTab:Button({
    Title = "Update Above",
    Desc = "SetTitle and SetDesc",
    Icon = "chevron-right",
    Callback = function()
        progBtn:SetTitle("Programmatic Button (Updated)")
        progBtn:SetDesc("Updated by code")
        progBtn:Highlight()
    end
})
```

### ตัวแปร UI button ผ่าน Dialog

ปุ่มภายใน `Window:Dialog` รองรับการจัดสไตล์ `Variant` — `"Primary"`, `"Secondary"`, และ `"White"`

```lua
myTab:Button({
    Title = "Show UI Button Variants",
    Desc = "Opens dialog with Primary/Secondary/White",
    Icon = "square-menu",
    Callback = function()
        Window:Dialog({
            Title = "UI Button Variants",
            Content = "Demonstrates button variants.",
            Buttons = {
                { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
                { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
                { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
            }
        })
    end
})
```

::: tip
ตั้งค่า `Icon = ""` เพื่อแสดง button โดยไม่มีไอคอนเลย — มีประโยชน์สำหรับปุ่มการดำเนินการแบบข้อความอย่างเดียวที่จัดกึ่งกลาง
:::
