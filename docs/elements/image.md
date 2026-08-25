# Image

A standalone image element with control over aspect ratio, scaling and corner radius. Use it to show banners, icons, previews or any decorative art inside a tab.

## Basic usage

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
})
```

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Image` | `string` | `""` | Image asset to display: `rbxassetid://…` (or a URL if the executor supports it). |
| `AspectRatio` | `string` | `"16:9"` | Width-to-height ratio, e.g. `"16:9"` or `"4:3"`. Set to `"native"`, `"original"`, or `"auto"` to use the image's real dimensions. |
| `Radius` | `number` | `—` | Corner radius of the image element. |
| `ScaleType` | `string` | `"Fit"` | How the image fills its frame: `"Fit"` letterboxes it inside; `"Crop"` fills and clips it. |
| `Crop` | `boolean` | `false` | Shortcut for `ScaleType = "Crop"`. |
| `Native` / `KeepAspect` | `boolean` | `false` | Use the image's native size / preserve its true aspect ratio. |
| `NativeSize` | `Vector2` | `—` | Explicit native pixel size, used with native/aspect handling. |
| `Height` | `number` | `—` | Fixed height in pixels; width follows the aspect ratio. |
| `Size` | `UDim2` | `—` | Explicit size that overrides `AspectRatio` and `Height`. |

## Methods

### `Image:SetSize(size)`

Resizes the image. Pass a `UDim2` for an explicit size, or a number to set a fixed pixel height.

```lua
img:SetSize(UDim2.fromOffset(200, 200))
img:SetSize(120) -- height in pixels
```

### `Image:SetScaleType(type)`

Sets the scale type: `"Fit"` or `"Crop"`.

```lua
img:SetScaleType("Crop")
```

### `Image:SetAspectRatio(ratio)`

Sets the aspect ratio. Accepts a ratio string like `"16:9"`, or `"native"` / `"original"` / `"auto"` for the image's real ratio.

```lua
img:SetAspectRatio("4:3")
img:SetAspectRatio("native")
```

### `Image:GetNativeSize()`

Returns the image's native pixel size as a `Vector2`.

```lua
local size = img:GetNativeSize()
print(size.X, size.Y)
```

### `Image:Destroy()`

Removes the image element.

```lua
img:Destroy()
```

## Examples

### 16:9 image by asset id

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
    Radius = 12,
})
```

### Native-ratio image

Let the image keep its real proportions by setting `AspectRatio = "native"`.

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "native",
})
```

### Cropped square via Size

Give the image an explicit square `Size` and crop it to fill the frame.

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    Size = UDim2.fromOffset(120, 120),
    ScaleType = "Crop", -- or Crop = true
})
```
