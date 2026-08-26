# Dropdown

รายการที่เลือกได้พร้อมรองรับการเลือกเดี่ยวหรือหลายตัวเลือก, ไอคอนต่อรายการ, คำอธิบาย, divider, และรูปภาพ โดยไม่มี callback ส่วนกลาง มันยังทำหน้าที่เป็น **เมนูการดำเนินการ**

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Dropdown({
    Title = "Basic",
    Values = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Value = "Option 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dropdown"` | ป้ายกำกับหลัก รองรับ [token rich-text](/th/elements/#rich-text-di-title-desc) |
| `Desc` | `string` | `nil` | คำอธิบายเพิ่มเติมที่อยู่ใต้ชื่อ |
| `Values` | `table` | `{}` | รายการตัวเลือก — string หรือ รายการออปเจกต์ (ดูด้านล่าง) `{ Type = "Divider" }` แทรก divider |
| `Value` | `string` \| `table` | `nil` | การเลือกเริ่มต้น: string, รายการออปเจกต์, หรือ array (สำหรับ `Multi`) |
| `Multi` | `boolean` | `false` | อนุญาตให้เลือกมากกว่าหนึ่งรายการ |
| `AllowNone` | `boolean` | `false` | อนุญาตให้ยกเลิกรายการสุดท้ายที่เหลืออยู่ (มีประโยชน์มากที่สุดกับ `Multi`) |
| `SearchBarEnabled` | `boolean` | `false` | แสดง search bar เหนือเมนู |
| `MenuWidth` | `number` | `nil` | ความกว้างเมนูคงที่เป็นพิกเซล เว้นว่างไว้สำหรับ auto-fit |
| `Locked` | `boolean` | `false` | แสดง overlay ล็อคและบล็อกการโต้ตอบ |
| `Image` | `string` \| `table` | `nil` | รูปภาพชิดซ้ายบนแถว dropdown |
| `ImageSize` | `number` \| `UDim2` | `30` | ขนาดรูปภาพ — ตัวเลข, หรือ `UDim2` สำหรับ card รูปภาพ |
| `ImagePadding` | `number` | `—` | ระยะห่างรอบรูปภาพรายการ |
| `IconThemed` | `boolean` | `false` | ระบายสีไอคอนด้วยสีธีมปัจจุบัน |
| `Color` | `Color3` \| `string` | `nil` | พื้นหลังสี (ชื่อธีมหรือ `Color3`) |
| `Callback` | `function` | `nil` | ทำงานเมื่อเลือก ดูหมายเหตุลายเซ็นด้านล่าง |
| `Flag` | `string` | `nil` | Key การคงอยู่ของการกำหนดค่า ดู [การกำหนดค่า & Flag](/th/features/config-and-flags) |
| `Buttons` | `table` | `nil` | ปุ่มอินไลน์ที่แสดงในแถว |
| `TitleGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความชื่อ |
| `DescGradient` | `table` | `nil` | Gradient ที่ใช้กับข้อความคำอธิบาย |

### รายการออปเจกต์

แทนที่จะเป็น string ธรรมดา แต่ละรายการใน `Values` สามารถเป็น ตาราง:

| Field | Type | คำอธิบาย |
| --- | --- | --- |
| `Title` | `string` | ป้ายกำกับรายการ |
| `Desc` | `string` | คำอธิบายเพิ่มเติมที่แสดงใต้ชื่อ |
| `Icon` | `string` | ไอคอนเพิ่มเติมสำหรับรายการ |
| `Images` | `table` | Array id รูปภาพ / ชื่อไอคอน, หรือ ตาราง card (`{ Card = true, Title, Quantity, Image, Gradient }`) |
| `Locked` | `boolean` | ปิดใช้งานการเลือกรายการเฉพาะนี้ |
| `Callback` | `function` | การดำเนินการต่อรายการ ใช้ใน **โหมดเมนู** (ดูด้านล่าง) |
| `Type` | `string` | ตั้งค่าเป็น `"Divider"` (โดยไม่มี field อื่น) เพื่อแทรก divider ระหว่างรายการ |

::: info ลายเซ็น callback — และโหมดเมนู
- **Single-select:** callback รับ **ค่า** ที่เลือก — `string` สำหรับรายการ string, หรือ **รายการออปเจกต์ ต้นฉบับ** สำหรับรายการ ออปเจกต์ (อ่าน `option.Title`, ฯลฯ)
- **Multi-select** (`Multi = true`): callback รับ **array** ที่มีรายการที่เลือก
- **โดยไม่มี `Callback` ส่วนกลาง:** dropdown กลายเป็น **เมนูการดำเนินการ** — การคลิกรายการจะรัน `Callback` *ของรายการนั้น*
:::

Dropdown ยังสืบทอดการกำหนดค่าและ method [ร่วมฐาน](/th/elements/#base-bersama)

## Method

### `Dropdown:Select(items)`

ตั้งค่าการเลือกปัจจุบันผ่านโค้ด ส่งหนึ่งค่า หรือ array เมื่อ `Multi` active

```lua
myDropdown:Select("Blue")
myDropdown:Select({ "A", "C" }) -- multi
```

### `Dropdown:Refresh(values)`

แทนที่รายการตัวเลือกทั้งหมดด้วย array `values` ใหม่

```lua
myDropdown:Refresh({ "New 1", "New 2", "New 3" })
```

### `Dropdown:Edit(itemName, newData)`

อัปเดตรายการที่มีอยู่ ค้นหาตามชื่อ ด้วย field ใน `newData`

```lua
myDropdown:Edit("Option 1", { Title = "Option 1 (updated)", Icon = "check" })
```

### `Dropdown:EditDrop(target, newData)`

แก้ไข container dropdown เอง โดยนำ `newData` ไปใช้กับ `target` ที่กำหนด

### `Dropdown:SetValueImage(img)` / `Dropdown:SetValueIcon(img)`

ตั้งค่ารูปภาพหรือไอคอนที่แสดงข้างค่าที่เลือกอยู่

### `Dropdown:SetMainImage(img, size)`

อัปเดตรูปภาพชิดซ้ายของ dropdown พร้อมขนาด

### `Dropdown:Open()` / `Dropdown:Close()`

เปิดหรือปิดเมนู `Open()` เป็น toggle — เรียกมันเมื่อเปิดอยู่จะปิดเมนู

### `Dropdown:Display()`

รีเฟรชค่าที่แสดง (ข้อความ, ไอคอน, และรูปภาพ) สำหรับการเลือกปัจจุบัน

### `Dropdown:Lock(text?)` / `Dropdown:Unlock()`

ล็อคหรือปลดล็อค dropdown อาร์กิวเมนต์ `text` เพิ่มเติมตั้งค่าป้ายกำกับ overlay

## ตัวอย่าง

### รายการ string พื้นฐาน

```lua
myTab:Dropdown({
    Title = "Basic",
    Desc = "Simple list of string values with a global selection callback.",
    Values = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Value = "Option 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

### พร้อมไอคอน (item ออปเจกต์)

สำหรับ item ออปเจกต์ callback รับ **รายการออปเจกต์** — อ่าน `option.Title`

```lua
myTab:Dropdown({
    Title = "With Icons",
    Desc = "Each option is an object containing a title and an icon.",
    Values = {
        { Title = "Bird",     Icon = "bird" },
        { Title = "House",    Icon = "house" },
        { Title = "Settings", Icon = "settings" },
        { Title = "Trash",    Icon = "trash-2" },
    },
    Value = { Title = "Bird", Icon = "bird" },
    Callback = function(option)
        print("Selected:", option.Title)
    end
})
```

### พร้อมคำอธิบาย

```lua
myTab:Dropdown({
    Title = "With Descriptions",
    Values = {
        { Title = "Option A", Desc = "This is option A" },
        { Title = "Option B", Desc = "This is option B" },
        { Title = "Option C", Desc = "This is option C" },
    },
    Value = { Title = "Option A", Desc = "This is option A" },
    Callback = function(option) print(option.Title) end
})
```

### Multi-select

ด้วย `Multi = true` callback รับ **array** ที่มีรายการที่เลือก

```lua
myTab:Dropdown({
    Title = "Multi-Select",
    Desc = "Select multiple options (callback returns an array of selected items).",
    Values = {
        { Title = "Category A", Icon = "folder" },
        { Title = "Category B", Icon = "folder" },
        { Title = "Category C", Icon = "folder" },
        { Title = "Category D", Icon = "folder" },
    },
    Multi = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do
            table.insert(titles, v.Title)
        end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### การจัดกลุ่ม divider

```lua
myTab:Dropdown({
    Title = "Divider Grouping",
    Desc = "Use Type = 'Divider' to split options into visually separated groups.",
    Values = {
        { Title = "Group 1 - A", Icon = "star" },
        { Title = "Group 1 - B", Icon = "star" },
        { Type = "Divider" },
        { Title = "Group 2 - A", Icon = "heart" },
        { Title = "Group 2 - B", Icon = "heart" },
    },
    Value = { Title = "Group 1 - A", Icon = "star" },
    Callback = function(option) print(option.Title) end
})
```

### Allow none (multi)

`AllowNone` อนุญาตให้ multi-select ลดลงเหลือศูนย์รายการที่เลือก

```lua
myTab:Dropdown({
    Title = "Multi (AllowNone)",
    Desc = "Multi-select with AllowNone lets you deselect the last remaining item.",
    Values = { { Title = "A" }, { Title = "B" }, { Title = "C" } },
    Value = "B",
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do table.insert(titles, v.Title) end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### รายการล็อค

```lua
myTab:Dropdown({
    Title = "Locked Items",
    Desc = "Per-item locking disables selection for specific options.",
    Values = {
        { Title = "Usable A" },
        { Title = "Locked B", Locked = true },
        { Title = "Usable C" },
    },
    Value = "Usable A",
    Callback = function(value)
        print("Selected:", typeof(value) == "table" and value.Title or value)
    end
})
```

### ความกว้างกำหนดเองและ search bar

```lua
myTab:Dropdown({
    Title = "Custom Width",
    Desc = "Manually define menu width instead of using auto-fit.",
    Values = { "Short", "Medium Option", "Veryyyyyyyy Long Option Name" },
    Value = "Short",
    MenuWidth = 250,
    SearchBarEnabled = true,
    Callback = function(value) print(value) end
})
```

### การเลือกผ่านโค้ด

```lua
local colors = myTab:Dropdown({
    Title = "Programmatic Select",
    Values = { "Red", "Green", "Blue" },
    Value = "Red",
    Callback = function(value) print("Selected:", value) end
})

myTab:Button({
    Title = "Select 'Blue' via code",
    Callback = function()
        colors:Select("Blue")
    end
})
```

### เมนูการดำเนินการ (callback ต่อรายการ)

ตัด `Callback` ส่วนกลางออกทั้งหมดและให้แต่ละรายการมี `Callback` ของตัวเอง — dropdown จะทำตัวเหมือนเมนูการดำเนินการคลิกขวา

```lua
myTab:Dropdown({
    Title = "Advanced Actions",
    Desc = "No global callback: items behave like an action menu using per-item callbacks.",
    Values = {
        { Title = "New file",  Desc = "Create a new file",   Icon = "file-plus", Callback = function() print("New file") end },
        { Title = "Copy link", Desc = "Copy the file link",  Icon = "copy",      Callback = function() print("Copy link") end },
        { Type = "Divider" },
        { Title = "Delete file", Desc = "Permanently delete the file", Icon = "trash", Callback = function() print("Delete file") end },
    }
})
```

::: tip บันทึกการเลือก
เพิ่ม `Flag` เพื่อบันทึกและกู้คืนค่าที่เลือกระหว่างเซสชัน ดู [การกำหนดค่า & Flag](/th/features/config-and-flags)
:::
