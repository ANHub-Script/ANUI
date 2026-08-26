# Group

Container ที่จัดเรียงลูกๆ ของมันใน **แนวนอน** แทนที่จะซ้อนกันในแนวตั้ง อิลิเมนต์อินเทอแอคทีฟแบ่งปันความกว้างที่มีอยู่อย่างเท่าๆ กัน ในขณะที่ [Space](/th/elements/space) หรือ [Divider](/th/elements/divider) รักษาความกว้างคงที่ เหมือนกับ Tab, Group มี method สร้างอิลิเมนต์ทั้งหมด

## การใช้งานพื้นฐาน

สร้าง group ด้วย `Tab:Group({})` จากนั้นเพิ่มอิลิเมนต์ไปยัง container ที่ส่งคืน:

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local row = myTab:Group({})
row:Button({ Title = "Save", Callback = function() end })
row:Button({ Title = "Load", Callback = function() end })
```

ทั้งสอง button แสดงเคียงข้างกัน แต่ละอันเต็มครึ่งแถว

## การกำหนดค่า

`Group` ไม่รับการกำหนดค่าใดๆ — เรียก `Tab:Group({})` ด้วย ตาราง ว่าง

## การสร้างอิลิเมนต์ภายใน group

Group เป็น container ดังนั้นทุก method สร้างอิลิเมนต์ (`Group:Button`, `Group:Toggle`, `Group:Dropdown`, …) ทำงานบนมันเหมือนกับบน Tab — ดู [สรุปอิลิเมนต์](/th/elements/) แต่ละลูกอินเทอแอคทีฟได้รับส่วนความกว้างแถวเท่ากัน; ลูก `Space` และ `Divider` รักษาความกว้างคงที่แทนที่จะยืด

::: tip
Group เข้ากันดีกับป้ายกำกับ [Paragraph](/th/elements/paragraph) ที่วางไว้ด้านบนพอดี — ใช้ paragraph เป็นชื่อที่อธิบายแถวคอนโทรลด้านล่าง
:::

## ตัวอย่าง

### แถว button

```lua
local buttons = myTab:Group({})
buttons:Button({
    Title = "Primary",
    Color = Color3.fromHex("#305dff"),
    Icon = "mouse-pointer-click",
    Callback = function() end,
})
buttons:Button({ Title = "Secondary", Icon = "mouse", Callback = function() end })
buttons:Button({ Title = "Locked", Icon = "lock", Locked = true, Callback = function() end })
```

### สอง dropdown เคียงข้างกัน

```lua
myTab:Paragraph({ Title = "Dropdowns Group", Desc = "Two dropdowns grouped." })

local dropdowns = myTab:Group({})
dropdowns:Dropdown({
    Title = "Dropdown 1",
    Values = { "A", "B", "C" },
    Value = "A",
    Callback = function(v) print("Dropdown 1:", v) end,
})
dropdowns:Dropdown({
    Title = "Dropdown 2",
    Values = { { Title = "X", Desc = "First" }, { Title = "Y" }, { Title = "Z" } },
    SearchBarEnabled = true,
    Value = "Y",
    Callback = function(v) print("Dropdown 2:", v) end,
})
```

### สอง slider เคียงข้างกัน

```lua
myTab:Paragraph({ Title = "Sliders Group", Desc = "Two sliders grouped." })

local sliders = myTab:Group({})
sliders:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(v) print("Volume:", v) end,
})
sliders:Slider({
    Title = "Brightness",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(v) print("Brightness:", v) end,
})
```

::: info
Group เป็น container เลย์เอาต์ ดังนั้นมันไม่สืบทอดพฤติกรรมอินเทอแอคทีฟ shared-base — พฤติกรรมนั้นเป็นของอิลิเมนต์ที่คุณวางไว้ภายใน
:::
