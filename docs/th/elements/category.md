# Category

แถวตัวเลือกแนวนอนที่เลื่อนได้และทำหน้าที่เป็นตัวเลือก sub-tab ภายใน tab เลือกตัวเลือก จากนั้นใน callback ให้แสดงกลุ่มอิลิเมนต์ที่เกี่ยวข้องในขณะที่ซ่อนส่วนที่เหลือ — วิธีที่กระชับในการโหลด "หน้า" คอนโทรลจำนวนมากใน tab เดียว

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })

myTab:Category({
    Title = "Select Category",
    Default = "Weapons",
    Options = {
        { Title = "Weapons", Icon = "sword" },
        { Title = "Armor",   Icon = "shield" },
        { Title = "Potions", Icon = "flask-round" },
    },
    Callback = function(selected)
        print("Selected category:", selected)
    end,
})
```

## การกำหนดค่า

Field ที่กำหนดพฤติกรรม:

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | ป้ายกำกับที่แสดงเหนือแถวตัวเลือก |
| `Desc` | `string` | `nil` | คำอธิบายเพิ่มเติมที่อยู่ใต้ชื่อ |
| `Options` | `array` | `{}` | ตัวเลือกที่สามารถเลือกได้ แต่ละรายการเป็น **string** หรือ **ตาราง opsi** (ดูด้านล่าง) |
| `Default` | `string` | ตัวเลือกแรก | ตัวเลือกที่ถูกเลือกเมื่อสร้าง |
| `Callback` / `OnChanged` | `function` | `nil` | ทำงานเมื่อการเลือกเปลี่ยนแปลง **รับชื่อตัวเลือกที่เลือก (string)** |

### รายการตัวเลือก

แต่ละรายการใน `Options` เป็น string ธรรมดา หรือเป็น ตาราง:

| Field | Type | คำอธิบาย |
| --- | --- | --- |
| `Title` / `Name` / `Value` / `[1]` | `string` | ชื่อตัวเลือก — ค่าที่ส่งไปยัง callback |
| `Icon` / `Image` | `string` | ไอคอนเพิ่มเติม (ชื่อ Lucide หรือ `rbxassetid://…`) |
| `IconSize` | `number` | การแทนที่ขนาดไอคอนต่อตัวเลือก |
| `Desc` | `string` | คำอธิบายเพิ่มเติมต่อตัวเลือก |

ตัวเลือกยังสามารถมี field รายละเอียดไอคอน `ScaleType`, `KeepAspect` / `Native`, `NativeSize`, และ `Tint`

### การแสดง & เลย์เอาต์

ทั้งหมดเป็นตัวเลือก; ค่า default ถูกตั้งค่าให้เข้ากับ UI ที่เหลือ

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Height` | `number` | `45` | ความสูงของแถวทั้งหมด |
| `ButtonHeight` | `number` | `32` | ความสูงของแต่ละปุ่มตัวเลือก |
| `IconSize` | `number` | `18` | ขนาดไอคอนตัวเลือก default |
| `TextSize` | `number` | `14` | ขนาดข้อความป้ายกำกับตัวเลือก |
| `Radius` | `number` | `8` | รัศมีมุมปุ่มตัวเลือก |
| `Gap` / `Padding` | `number` | `8` | ระยะห่างระหว่างปุ่มตัวเลือก |
| `SidePadding` | `number` | `12` | Padding ที่ปลายซ้าย/ขวาของแถว |
| `ScrollSpeed` | `number` | `35` | ความเร็วการเลื่อนแนวนอน |
| `Transparency` | `number` | `0.5` | ความโปร่งใสพื้นหลังปุ่มที่ไม่ active |
| `AutoCapture` | `boolean` | `true` | ลงทะเบียนอิลิเมนต์ที่สร้างหลัง Category กับตัวเลือกปัจจุบันโดยอัตโนมัติ (ดูด้านล่าง) |
| `Sticky` | `boolean` | `nil` (auto) | ปักหมุดแถวเมื่อ tab ถูกเลื่อน |
| `ZIndex` | `number` | `6` | ลำดับการแสดงแถว |

::: details แท็กตัวเลือก & ไอคอนขั้นสูง
`ActiveTag` (`"Toggle"`), `InactiveTag` (`"Button"`), และ `TextTag` (`"Text"`) เลือกแท็กธีมที่ใช้สำหรับจัดสไตล์ปุ่ม active/inactive พร้อมข้อความ `IconScaleType`, `IconKeepAspect` (`true`), `IconAutoWidth` (`true`), และ `TintIcon` (auto) ตั้งค่ารายละเอียดการแสดงไอคอน ในขณะที่ `ContentPadding` (`5`) และ `AlignWithContent` (`true`) กำหนดว่าแถวถูกจัดแนวกับอิลิเมนต์ด้านล่างอย่างไร
:::

## Method

### `Category:Select(name, silent?)`

เลือกตัวเลือกตามชื่อ ส่ง `silent = true` เพื่ออัปเดตการเลือกโดยไม่ทริกเกอร์ callback มี alias `Category:SetValue(name, silent?)`

```lua
category:Select("Armor")
category:Select("Potions", true) -- ไม่มี callback
```

### `Category:GetSelected()`

ส่งคืนชื่อตัวเลือกที่ถูกเลือกอยู่

```lua
print(category:GetSelected())
```

### `Category:SetCallback(fn)`

เปลี่ยน callback การเปลี่ยนแปลง

```lua
category:SetCallback(function(name) print("now on", name) end)
```

### `Category:Add(name, ...)`

ลงทะเบียนอิลิเมนต์ที่มีอยู่แล้วหนึ่งตัวหรือมากกว่ากับตัวเลือก `name` ทำให้อิลิเมนต์นั้นแสดง/ซ่อนพร้อมกับมัน

### `Category:Remove(item)`

ยกเลิกการลงทะเบียนอิลิเมนต์ที่เคยเพิ่มไว้ก่อนหน้านี้

### `Category:GetElements(name?)`

ส่งคืนอิลิเมนต์ที่ลงทะเบียนกับตัวเลือก หรือทั้งหมดหากไม่ได้ให้ `name`

### `Category:Refresh()`

สร้างแถวตัวเลือกใหม่หลังจากตัวเลือกหรืออิลิเมนต์เปลี่ยนแปลง

### `Category:Capture(name)` / `Category:StopCapture()`

เริ่มบันทึกอิลิเมนต์ที่สร้างใหม่กับตัวเลือก `name` และหยุดการบันทึก นี่คือรูปแบบ manual ของ `AutoCapture`

### `Category:With(name, builder)`

รัน `builder` และลงทะเบียนอิลิเมนต์ที่สร้างขึ้นทุกตัวกับตัวเลือก `name`

```lua
category:With("Weapons", function()
    myTab:Toggle({ Title = "Auto Swing" })
    myTab:Slider({ Title = "Range", Value = { Min = 0, Max = 50, Default = 10 } })
end)
```

### `Category:AddOption(option, order?)`

เพิ่มตัวเลือกใหม่ที่สามารถเลือกได้ โดยเลือกได้ว่าจะวางที่ตำแหน่ง `order`

### `Category:RemoveOption(name)`

ลบตัวเลือกตามชื่อ

### `Category:SetOptions(options, newDefault?)`

แทนที่ตัวเลือกทั้งหมด โดยเลือกได้ว่าจะเลือก `newDefault`

### `Category:GetOptions()`

ส่งคืนตัวเลือกปัจจุบัน

### `Category:SetHeight(h)`

ตั้งค่าความสูงของแถว

### `Category:Destroy()`

ลบ Category

## รูปแบบแสดง/ซ่อน

::: tip การใช้งานทั่วไป
รูปแบบทั่วไปคือสร้าง Category พร้อมตัวเลือกของคุณ จากนั้นใน callback **แสดงอิลิเมนต์ของตัวเลือกที่เลือกและซ่อนส่วนที่เหลือ** คุณสามารถติดตามอิลิเมนต์เองและเปลี่ยน `.Visible` ของแต่ละตัว หรือใช้ประโยชน์จาก `AutoCapture` (เปิดใช้งานโดย default) ที่เชื่อมโยงอิลิเมนต์ที่สร้าง *หลัง* Category กับตัวเลือกปัจจุบัน ทำให้มันจัดการการมองเห็นให้คุณ `Category:With(name, builder)` และ `Category:Capture(name)` / `Category:StopCapture()` ให้การควบคุมอย่างชัดเจนเหนือการบันทึกนั้น
:::

ตัวอย่างด้านล่างสร้าง "Upgrade System" เล็กๆ: ตาราง `Categories` เก็บอิลิเมนต์สำหรับแต่ละตัวเลือก, helper ซ่อนมันเมื่อสร้าง, และ callback แสดงเฉพาะอิลิเมนต์ของตัวเลือกที่เลือก

```lua
local UpgradeTab = Window:Tab({ Title = "Upgrade System", Icon = "hammer" })

-- เก็บอิลิเมนต์ต่อตัวเลือกเพื่อให้สามารถแสดง/ซ่อนได้
local Categories = { Yen = {}, Token = {}, Rank = {} }

-- หา frame หลักของอิลิเมนต์ (ทำงานกับอิลิเมนต์หลายประเภท)
local function GetElementFrame(element)
    if element.ElementFrame then
        return element.ElementFrame
    elseif element.UIElements and element.UIElements.Main then
        return element.UIElements.Main
    end
    for _, value in pairs(element) do
        if type(value) == "table" and value.UIElements and value.UIElements.Main then
            return value.UIElements.Main
        end
    end
end

-- ลงทะเบียนอิลิเมนต์กับหมวดหมู่และซ่อนโดย default
local function AddElement(category, element)
    table.insert(Categories[category], element)
    local frame = GetElementFrame(element)
    if frame then frame.Visible = false end
    return element
end

-- แสดงเฉพาะอิลิเมนต์ของหมวดหมู่ที่เลือก
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then frame.Visible = (name == selected) end
        end
    end
end

UpgradeTab:Category({
    Title = "Select Category",
    Default = "Yen",
    Options = {
        { Title = "Yen",   Icon = "coins" },
        { Title = "Token", Icon = "layers" },
        { Title = "Rank",  Icon = "shield" },
    },
    Callback = OnCategoryChanged,
})

UpgradeTab:Space({ Columns = 1 })

-- สร้างและลงทะเบียนอิลิเมนต์สำหรับแต่ละหมวดหมู่
AddElement("Yen", UpgradeTab:Paragraph({ Title = "Yen Upgrades", Desc = "Upgrade stats using Yen" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" }))

AddElement("Token", UpgradeTab:Paragraph({ Title = "Token Upgrades", Desc = "Special upgrades using Tokens" }))
AddElement("Token", UpgradeTab:Toggle({ Title = "Yen Multiplier", Desc = "Cost: 5 Tokens | x1.5 Yen" }))

AddElement("Rank", UpgradeTab:Paragraph({ Title = "Rank Information", Desc = "Current Rank: S-Class" }))
AddElement("Rank", UpgradeTab:Button({ Title = "Rank Up", Icon = "arrow-up-circle" }))

-- แสดงหมวดหมู่ default ครั้งหนึ่งเมื่อโหลด
OnCategoryChanged("Yen")
```

สำหรับคำแนะนำที่ครอบคลุมมากขึ้นเกี่ยวกับเทคนิคนี้ ดู [หน้าสูตร Category](/th/examples/category-pages)
