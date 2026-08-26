# Space

Spacer แนวตั้งที่มองไม่เห็นที่ใช้เพื่อให้ระยะห่างระหว่างอิลิเมนต์ มันไม่ได้แสดงอะไรเลย — เพียงให้ความสูง

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Space()
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Columns` | `number` | `1` | ตัวคูณความสูง ความสูง spacer คือ `7 × Columns` พิกเซล |

::: info ความสูง
ความสูงคำนวณเป็น `7 * Columns` พิกเซล — default `Columns = 1` ให้ 7px, `Columns = 2` ให้ 14px, และต่อไป
:::

## ตัวอย่าง

### ระยะห่างมากขึ้น

```lua
myTab:Space({ Columns = 2 }) -- ระยะห่างแนวตั้ง 14px
```

### ให้ระยะห่างกับกองอิลิเมนต์

`Space()` ระหว่างแต่ละคอนโทรลเป็นวิธีทั่วไปเพื่อให้รายการยาวไม่รู้สึกแน่น

```lua
myTab:Toggle({ Title = "Basic Toggle", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Toggle with Description", Desc = "Extra detail", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Checkbox", Type = "Checkbox", Callback = function(v) end })
```

::: info
Space ไม่ใช่อิลิเมนต์อินเทอแอคทีฟ จึงไม่มี method — ตั้งค่าขนาดผ่าน field `Columns` เมื่อคุณสร้างมัน
:::
