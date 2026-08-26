# Image

อิลิเมนต์รูปภาพอิสระพร้อมการควบคุมอัตราส่วนภาพ, การปรับขนาด, และรัศมีมุม ใช้เพื่อแสดงแบนเนอร์, ไอคอน, ตัวอย่าง, หรืองานศิลป์ที่เป็นการตกแต่งใดๆ ภายใน tab

## การใช้งานพื้นฐาน

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
})
```

## การกำหนดค่า

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Image` | `string` | `""` | แอสเซทรูปภาพที่แสดง: `rbxassetid://…` (หรือ URL หาก executor รองรับ) |
| `AspectRatio` | `string` | `"16:9"` | อัตราส่วนกว้าง-ต่อ-สูง, เช่น `"16:9"` หรือ `"4:3"` ตั้งค่าเป็น `"native"`, `"original"`, หรือ `"auto"` เพื่อใช้ขนาดต้นฉบับของรูปภาพ |
| `Radius` | `number` | `—` | รัศมีมุมอิลิเมนต์รูปภาพ |
| `ScaleType` | `string` | `"Fit"` | วิธีที่รูปภาพเติม frame: `"Fit"` แสดงมันทั้งหมด (letterbox); `"Crop"` เต็มเฟรมแล้วครอบตัด |
| `Crop` | `boolean` | `false` | ทางลัดสำหรับ `ScaleType = "Crop"` |
| `Native` / `KeepAspect` | `boolean` | `false` | ใช้ขนาดต้นฉบับของรูปภาพ / รักษาอัตราส่วนต้นฉบับ |
| `NativeSize` | `Vector2` | `—` | ขนาดพิกเซลต้นฉบับอย่างชัดเจน ใช้กับการจัดการ native/aspek |
| `Height` | `number` | `—` | ความสูงคงที่เป็นพิกเซล; ความกว้างตามอัตราส่วน |
| `Size` | `UDim2` | `—` | ขนาดชัดเจนที่แทนที่ `AspectRatio` และ `Height` |

## Method

### `Image:SetSize(size)`

เปลี่ยนขนาดรูปภาพ ส่ง `UDim2` สำหรับขนาดชัดเจน หรือตัวเลขเพื่อตั้งค่าความสูงพิกเซลคงที่

```lua
img:SetSize(UDim2.fromOffset(200, 200))
img:SetSize(120) -- ความสูงเป็นพิกเซล
```

### `Image:SetScaleType(type)`

ตั้งค่าประเภทสเกล: `"Fit"` หรือ `"Crop"`

```lua
img:SetScaleType("Crop")
```

### `Image:SetAspectRatio(ratio)`

ตั้งค่าอัตราส่วน รับ string อัตราส่วนเช่น `"16:9"` หรือ `"native"` / `"original"` / `"auto"` สำหรับอัตราส่วนต้นฉบับของรูปภาพ

```lua
img:SetAspectRatio("4:3")
img:SetAspectRatio("native")
```

### `Image:GetNativeSize()`

ส่งคืนขนาดพิกเซลต้นฉบับของรูปภาพเป็น `Vector2`

```lua
local size = img:GetNativeSize()
print(size.X, size.Y)
```

### `Image:Destroy()`

ลบอิลิเมนต์รูปภาพ

```lua
img:Destroy()
```

## ตัวอย่าง

### รูปภาพ 16:9 ผ่าน asset id

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
    Radius = 12,
})
```

### รูปภาพอัตราส่วน native

ปล่อยให้รูปภาพรักษาสัดส่วนต้นฉบับโดยตั้งค่า `AspectRatio = "native"`

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "native",
})
```

### สี่เหลี่ยมจัตุรัสที่ครอบตัดผ่าน Size

ให้รูปภาพ `Size` สี่เหลี่ยมจัตุรัสชัดเจนแล้วครอบตัดให้เต็ม frame

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    Size = UDim2.fromOffset(120, 120),
    ScaleType = "Crop", -- หรือ Crop = true
})
```
