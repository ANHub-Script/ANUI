# 打开按钮

打开按钮就是那颗悬浮的胶囊按钮，用于在 UI 被关闭后重新打开它。你可以在创建窗口时配置它，也可以之后在运行时修改。

## 创建时配置

把一个 `OpenButton` 表传给 `CreateWindow`。

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

## 配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | — | 显示在按钮上的文字。 |
| `Icon` | `string` | — | 显示在标题之前的图标名称或 `rbxassetid://…`。 |
| `Enabled` | `boolean` | — | 设为 `false` 可完全禁用打开按钮。 |
| `Position` | `UDim2` | — | 按钮在屏幕上的位置。 |
| `OnlyIcon` | `boolean` | `false` | 纯图标的圆形按钮（Delta 风格）；会隐藏标题和拖动把手。 |
| `Draggable` | `boolean` | — | 允许用户随意拖动按钮。 |
| `OnlyMobile` | `boolean` | — | 不设置即为仅移动端；设为 `false` 可让它同时显示在桌面端。 |
| `CornerRadius` | `UDim` | `UDim.new(1, 0)` | 按钮的圆角半径（默认为完全圆角）。 |
| `StrokeThickness` | `number` | `2` | 按钮描边的粗细。 |
| `Color` | `ColorSequence` | `#40c9ff → #e81cff` | 按钮描边所用的渐变。 |
| `Size` | `UDim2` | auto | 按钮尺寸。默认会根据内容自动调整。 |

::: info OnlyMobile 的默认行为
如果你不设置 `OnlyMobile`，按钮的行为是**仅移动端**。设置 `OnlyMobile = false` 可让它同时显示在桌面端 —— 就像上面的示例那样。
:::

::: tip Color 是一个渐变
`Color` 接受 `ColorSequence`，而不是 `Color3` —— 这个值会作为渐变应用到按钮的描边上。用 `ColorSequence.new(colorA, colorB)` 构造一个即可。
:::

## 在运行时修改

### `Window:EditOpenButton(config)`

对打开按钮应用修改。修改是**累积合并**的 —— 你没有传入的字段会保留当前的值。

```lua
Window:EditOpenButton({
    Title = "Open Menu",
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
})
```

## 打开按钮的方法

打开按钮对象可通过 `Window.OpenButtonMain` 访问。

### `Window.OpenButtonMain:SetIcon(icon)`

替换按钮的图标（图标名称或 `rbxassetid://…`）。

```lua
Window.OpenButtonMain:SetIcon("menu")
```

### `Window.OpenButtonMain:Visible(visible)`

显示或隐藏按钮。

```lua
Window.OpenButtonMain:Visible(false) -- 隐藏
Window.OpenButtonMain:Visible(true)  -- 显示
```

### `Window.OpenButtonMain:Edit(config)`

与 `Window:EditOpenButton` 相同 —— 把传入的配置合并进当前配置。在你的代码里用哪个读起来更顺就用哪个。

```lua
Window.OpenButtonMain:Edit({ Title = "Reopen" })
```

## 示例

改编自示例脚本：一颗可拖动的圆角胶囊按钮，带自定义标题和绿色到黄色的渐变描边，在桌面端和移动端都会显示。

```lua
local Window = ANUI:CreateWindow({
    Title = ".an hub | ANUI Library",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

更多窗口选项请参见[窗口配置](/zh/guide/window-configuration)。
