# Image

一个独立的图片元素，可控制宽高比、缩放方式和圆角半径。用它在标签页中显示横幅、图标、预览或任何装饰性图像。

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
})
```

## 配置

| Field | Type | Default | 说明 |
| --- | --- | --- | --- |
| `Image` | `string` | `""` | 要显示的图片资源：`rbxassetid://…`（如果执行器支持，也可以是 URL）。 |
| `AspectRatio` | `string` | `"16:9"` | 宽高比，例如 `"16:9"` 或 `"4:3"`。设为 `"native"`、`"original"` 或 `"auto"` 可使用图片的真实尺寸。 |
| `Radius` | `number` | `—` | 图片元素的圆角半径。 |
| `ScaleType` | `string` | `"Fit"` | 图片如何填充其框架：`"Fit"` 完整显示（加黑边）；`"Crop"` 填满并裁剪。 |
| `Crop` | `boolean` | `false` | `ScaleType = "Crop"` 的快捷方式。 |
| `Native` / `KeepAspect` | `boolean` | `false` | 使用图片的原始尺寸／保持其真实宽高比。 |
| `NativeSize` | `Vector2` | `—` | 显式指定原始像素尺寸，与 native/宽高比处理一起使用。 |
| `Height` | `number` | `—` | 固定高度（像素）；宽度按宽高比推算。 |
| `Size` | `UDim2` | `—` | 显式尺寸，会覆盖 `AspectRatio` 和 `Height`。 |

## 方法

### `Image:SetSize(size)`

调整图片尺寸。传入 `UDim2` 表示显式尺寸，或传入一个数字来设置固定的像素高度。

```lua
img:SetSize(UDim2.fromOffset(200, 200))
img:SetSize(120) -- 高度（像素）
```

### `Image:SetScaleType(type)`

设置缩放类型：`"Fit"` 或 `"Crop"`。

```lua
img:SetScaleType("Crop")
```

### `Image:SetAspectRatio(ratio)`

设置宽高比。接受形如 `"16:9"` 的比例字符串，或 `"native"` / `"original"` / `"auto"` 以使用图片的真实比例。

```lua
img:SetAspectRatio("4:3")
img:SetAspectRatio("native")
```

### `Image:GetNativeSize()`

以 `Vector2` 形式返回图片的原始像素尺寸。

```lua
local size = img:GetNativeSize()
print(size.X, size.Y)
```

### `Image:Destroy()`

移除该图片元素。

```lua
img:Destroy()
```

## 示例

### 通过 asset id 显示 16:9 图片

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
    Radius = 12,
})
```

### 原始比例的图片

将 `AspectRatio = "native"`，让图片保持其真实比例。

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "native",
})
```

### 通过 Size 实现裁剪的正方形

给图片一个显式的正方形 `Size`，并裁剪它以填满框架。

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    Size = UDim2.fromOffset(120, 120),
    ScaleType = "Crop", -- 或 Crop = true
})
```
