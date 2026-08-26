# Divider

เส้นแบ่งบางๆ ที่แบ่งอิลิเมนต์ออกจากกันทางภาพ บน Tab หรือ Section มันถูกแสดงเป็นเส้นแนวนอน; ภายใน [Group](/th/elements/group) มันถูกแสดงเป็นเส้นแนวตั้งระหว่างคอลัมน์ต่างๆ ของ group

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({ Title = "Save", Callback = function() end })
myTab:Divider()
myTab:Button({ Title = "Load", Callback = function() end })
```

## การกำหนดค่า

`Divider` ไม่รับการกำหนดค่าใดๆ — เรียก `Tab:Divider()` โดยไม่มีอาร์กิวเมนต์

::: info แนวตั้งใน Group
เนื่องจาก [Group](/th/elements/group) จัดเรียงลูกๆ ของมันในแนวนอน Divider ที่วางภายในจะถูกวาดเป็นตัวแบ่ง **แนวตั้ง** ระหว่างคอลัมน์ แทนที่จะเป็นเส้นแนวนอน
:::

## ตัวอย่าง

### แบ่งกลุ่มคอนโทรล

```lua
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })

myTab:Divider()

myTab:Button({ Title = "Reset", Callback = function() end })
```

### Divider แนวตั้งระหว่างคอลัมน์

```lua
local row = myTab:Group({})
row:Button({ Title = "Accept", Callback = function() end })
row:Divider()
row:Button({ Title = "Decline", Callback = function() end })
```

::: info
Divider เป็นเพียงการตกแต่ง — มันไม่ใช่อิลิเมนต์อินเทอแอคทีฟ จึงไม่มีการกำหนดค่าหรือ method
:::
