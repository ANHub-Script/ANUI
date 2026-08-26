# หน้าหมวดหมู่

รูปแบบที่พบบ่อย: หนึ่ง tab ที่แสดงหลาย "หน้า" ขององค์ประกอบ ที่สลับผ่านแถบแนวนอนด้านบน นี่สร้างด้วยองค์ประกอบ [Category](/th/elements/category) สูตรด้านล่างดัดแปลงมาจาก **Upgrade System** ใน demo

## วิธีการทำงาน

Category แสดงแถวตัวเลือกที่เลื่อนได้ เมื่อผู้ใช้เลือกหนึ่ง `Callback` ถูกเรียกพร้อมชื่อตัวเลือกที่เลือก เราเก็บตารางที่แมปแต่ละชื่อตัวเลือกกับองค์ประกอบที่เป็นของมัน แล้วสลับ `.Visible` ของแต่ละองค์ประกอบเพื่อให้มีเพียงหน้า active ที่แสดง

## 1. ติดตามองค์ประกอบต่อหมวดหมู่

กำหนดหมวดหมู่, helper เพื่อค้นหา frame องค์ประกอบ, และ helper ที่ลงทะเบียนองค์ประกอบกับหมวดหมู่ (ซ่อนโดย default)

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "My Hub", Folder = "MyHub" })
local Tab = Window:Tab({ Title = "Upgrades", Icon = "hammer" })

-- หนึ่ง container องค์ประกอบต่อหมวดหมู่
local Categories = {
    Combat = {},
    Farming = {},
    Settings = {},
}

-- เข้าถึง frame root ขององค์ประกอบเพื่อให้เราสามารถสลับการมองเห็นได้
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
    return nil
end

-- ลงทะเบียนองค์ประกอบกับหมวดหมู่และซ่อนในตอนแรก
local function AddElement(categoryName, element)
    if Categories[categoryName] then
        table.insert(Categories[categoryName], element)
        local frame = GetElementFrame(element)
        if frame then
            frame.Visible = false
        end
    end
    return element
end

-- แสดงเฉพาะองค์ประกอบของหมวดหมู่ที่เลือก ซ่อนที่เหลือ
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        local isVisible = (name == selected)
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then
                frame.Visible = isVisible
            end
        end
    end
end
```

## 2. เพิ่มแถบ Category

สร้าง Category พร้อมหนึ่งตัวเลือกต่อหน้า `Default` กำหนดหน้าที่แสดงก่อน และ `Callback` รัน `OnCategoryChanged` ทุกครั้งที่ผู้ใช้สลับ

```lua
Tab:Category({
    Title = "Select Category",
    Default = "Combat",
    Options = {
        { Title = "Combat", Icon = "sword" },
        { Title = "Farming", Icon = "coins" },
        { Title = "Settings", Icon = "settings" },
    },
    Callback = OnCategoryChanged, -- รับชื่อตัวเลือกที่เลือก (string)
})

Tab:Space({ Columns = 1 }) -- เว้นที่นิดหน่อยใต้แถบ
```

## 3. สร้างแต่ละหน้าและลงทะเบียนองค์ประกอบ

สร้างองค์ประกอบตามปกติ ห่อแต่ละอันด้วย `AddElement("<หมวดหมู่>", ...)` เพื่อเข้าร่วม container ที่ถูกต้องและเริ่มในสถานะซ่อน

```lua
-- Combat
AddElement("Combat", Tab:Paragraph({ Title = "Combat", Desc = "Fighting options" }))
AddElement("Combat", Tab:Toggle({ Title = "God Mode", Callback = function(v) print(v) end }))
AddElement("Combat", Tab:Slider({ Title = "Damage", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end }))

-- Farming
AddElement("Farming", Tab:Paragraph({ Title = "Farming", Desc = "Auto-farm options" }))
AddElement("Farming", Tab:Toggle({ Title = "Auto Farm", Callback = function(v) print(v) end }))
AddElement("Farming", Tab:Dropdown({ Title = "Target", Values = { "Coins", "Gems", "XP" }, Value = "Coins", Callback = function(v) print(v) end }))

-- Settings
AddElement("Settings", Tab:Paragraph({ Title = "Settings", Desc = "Menu settings" }))
AddElement("Settings", Tab:Toggle({ Title = "Auto Save", Callback = function(v) print(v) end }))
```

## 4. แสดงหน้า default

Category เริ่มที่ `Default` ดังนั้นเรียก `OnCategoryChanged` หนึ่งครั้งเพื่อซ่อนหน้าอื่นในตอนแรก

```lua
OnCategoryChanged("Combat")
```

นั่นคือรูปแบบทั้งหมด: การเปลี่ยนตัวเลือกสลับหน้าองค์ประกอบที่มองเห็น

## ทางเลือก: capture อัตโนมัติ

Category สามารถติดตามองค์ประกอบให้คุณแทนตาราง `Categories` แบบ manual เมื่อ `AutoCapture` เปิด (default) องค์ประกอบที่สร้างหลัง Category จะถูกเชื่อมโยงอัตโนมัติ วิธีที่สะอาดที่สุดคือ `:With(name, builder)` — ทุกอย่างที่สร้างใน builder ถูกกำหนดให้ตัวเลือกนั้น และ Category แสดง/ซ่อนแต่ละกลุ่มเมื่อคุณสลับ:

```lua
local cat = Tab:Category({
    Title = "Select Category",
    Default = "Combat",
    Options = { "Combat", "Farming", "Settings" },
})

cat:With("Combat", function()
    Tab:Toggle({ Title = "God Mode", Callback = function(v) print(v) end })
    Tab:Slider({ Title = "Damage", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end })
end)

cat:With("Farming", function()
    Tab:Toggle({ Title = "Auto Farm", Callback = function(v) print(v) end })
end)

cat:With("Settings", function()
    Tab:Toggle({ Title = "Auto Save", Callback = function(v) print(v) end })
end)
```

::: tip
`:Capture(name)` / `:StopCapture()` ทำสิ่งเดียวกันโดยไม่มี builder — ครอบช่วงการสร้างองค์ประกอบใดๆ ระหว่างทั้งสอง ใช้ `:GetElements(name?)` เพื่ออ่านสิ่งที่หมวดหมู่กำลังติดตาม ดูรายการ method ฉบับสมบูรณ์ที่หน้า [Category](/th/elements/category)
:::
