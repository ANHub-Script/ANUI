# 主题

ANUI 内置了 26 套主题，也允许你注册自己的主题。你可以在创建窗口时选择主题、在运行时切换主题、读取当前生效的主题，并对主题变化做出响应 —— 全部通过 `ANUI` 上的顶层方法完成。

## 在创建时指定主题

通过 `Theme` 字段把主题 key 传给 `CreateWindow`。它的默认值是 `"Dark"`。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Theme = "Midnight", -- 任意内置 key，或自定义主题名称
})
```

更多窗口选项请参见[窗口配置](/zh/guide/window-configuration)。

## 在运行时切换主题

### `ANUI:SetTheme(name)`

按 key 应用一套主题，并返回该主题表；当 key 未知时返回 `nil`。

```lua
if not ANUI:SetTheme("Emerald") then
    warn("未知的主题 key")
end
```

## 读取当前主题

### `ANUI:GetCurrentTheme()`

返回当前主题的**显示名称**（例如 `"Monokai Pro"`，而不是 key `MonokaiPro`）。

```lua
print(ANUI:GetCurrentTheme()) --> "Midnight"
```

### `ANUI:GetThemes()`

返回包含所有已注册主题的表，以主题 key 作为键 —— 其中也包括你用 `AddTheme` 添加的主题。

```lua
for key, theme in pairs(ANUI:GetThemes()) do
    print(key, "->", theme.Name)
end
```

## 响应主题变化

### `ANUI:OnThemeChange(callback)`

注册一个处理函数，每当 `SetTheme` 应用某个主题时都会运行。回调接收**一个参数：被应用的主题 key** —— 也就是你传给 `SetTheme` 的那个字符串（例如 `"Dark"`）。

```lua
ANUI:OnThemeChange(function(themeKey)
    print("主题已切换为：", themeKey)
end)
```

::: info 只能有一个处理函数
`OnThemeChange` 只保存一个处理函数 —— 再次调用会替换掉之前那个。如果脚本中有多个部分需要响应，请只注册一个函数，并在它内部做分支处理。
:::

## 内置主题

请把 **key** 传给 `Theme` / `SetTheme`。只有少数几套主题的显示名称（也就是 `GetCurrentTheme` 返回的值）与 key 不同。

| Key | 显示名称 |
| --- | --- |
| `Dark` | Dark *(default)* |
| `Light` | Light |
| `Rose` | Rose |
| `Plant` | Plant |
| `Red` | Red |
| `Indigo` | Indigo |
| `Sky` | Sky |
| `Violet` | Violet |
| `Amber` | Amber |
| `Emerald` | Emerald |
| `Midnight` | Midnight |
| `Crimson` | Crimson |
| `MonokaiPro` | Monokai Pro |
| `CottonCandy` | Cotton Candy |
| `Rainbow` | Rainbow |
| `NordTheme` | Nord |
| `DraculaTheme` | Dracula |
| `TokyoNight` | Tokyo Night |
| `OneDark` | One Dark |
| `Gruvbox` | Gruvbox |
| `SolarizedDark` | Solarized Dark |
| `MaterialDark` | Material Dark |
| `CyberpunkPink` | Cyberpunk Pink |
| `OceanBlue` | Ocean Blue |
| `NeonGreen` | Neon Green |
| `SoftPastel` | Soft Pastel |

## 自定义主题

### `ANUI:AddTheme(theme)`

注册一套主题（以它的 `Name` 作为 key）并把它返回。添加之后，用 `SetTheme(name)` 应用它。

主题就是一个颜色键的表。其中九个是必填的；`Toggle` 和 `Checkbox` 是可选的。每个颜色都是 `Color3` —— 通常用 `Color3.fromHex("#…")` 构造。

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Name` | `string` | — | 唯一的主题名称。这就是你传给 `SetTheme` 的 key。 |
| `Accent` | `Color3` | — | 主要的强调色／面板色。 |
| `Dialog` | `Color3` | — | 对话框与弹窗的背景。 |
| `Outline` | `Color3` | — | 边框／描边颜色。 |
| `Text` | `Color3` | — | 主要文字颜色。 |
| `Placeholder` | `Color3` | — | 占位符／暗淡文字颜色。 |
| `Background` | `Color3` | — | 窗口背景色。 |
| `Button` | `Color3` | — | 按钮背景色。 |
| `Icon` | `Color3` | — | 图标着色颜色。 |
| `Toggle` | `Color3` | *(可选)* | Toggle 处于 "on" 时的颜色。 |
| `Checkbox` | `Color3` | *(可选)* | Checkbox 处于 "checked" 时的颜色。 |

```lua
ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
    Toggle      = Color3.fromHex("#22d3ee"),
    Checkbox    = Color3.fromHex("#0ea5e9"),
})

ANUI:SetTheme("Oceanic")
```

::: tip
你用 `AddTheme` 添加的主题会立即出现在 `GetThemes()` 中，并且可以像任何内置主题那样被选中。
:::

## 渐变

### `ANUI:Gradient(stops, props)`

用一组 color stop 构建渐变数据表。`stops` 的键是从 `"0"` 到 `"100"` 的**位置字符串**（沿渐变方向的百分比）；每个 stop 的形式为 `{ Color = Color3, Transparency = number }` —— `Transparency` 是可选的，默认为 `0`。`props` 是一个可选的表，会被合并进结果中，例如 `{ Rotation = 45 }`。

```lua
local sunset = ANUI:Gradient({
    ["0"]   = { Color = Color3.fromHex("#40c9ff") },
    ["50"]  = { Color = Color3.fromHex("#8b5cf6") },
    ["100"] = { Color = Color3.fromHex("#e81cff") },
}, {
    Rotation = 45,
})
```

::: warning 至少两个 stop
一个渐变需要**两个或更多**stop。传入少于两个会抛出错误。
:::

渐变可以用在库接受渐变数据的任何地方 —— 最常见的是元素上的 `TitleGradient` 与 `DescGradient` 字段：

```lua
myTab:Button({
    Title = "Gradient Title",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Callback = function() end,
})
```

渐变甚至可以驱动主题颜色 —— 内置的 `Rainbow` 主题就是用渐变而非扁平的 `Color3` 值定义的。

## Acrylic 模糊

### `ANUI:ToggleAcrylic(enabled)`

打开或关闭窗口背后的 acrylic 模糊。只有当窗口是以 `Acrylic = true` 创建时它才有效；否则这个方法什么都不做。

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Acrylic = true,
})

ANUI:ToggleAcrylic(true)  -- 启用模糊
ANUI:ToggleAcrylic(false) -- 关闭模糊
```

## 字体

### `ANUI:SetFont(fontId)`

设置整个 UI 使用的全局字体。

```lua
ANUI:SetFont("rbxassetid://12898095208")
```

## 完整示例

注册一套自定义主题、应用它、提供一个主题选择器，并记录每一次变化。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
})

local Window = ANUI:CreateWindow({
    Title = "Theme Demo",
    Theme = "Oceanic",
    Acrylic = true,
})

local Tab = Window:Tab({ Title = "Appearance", Icon = "palette" })

Tab:Paragraph({
    Title = "Theme switcher",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Desc = "在下方挑选一套主题。",
})

Tab:Dropdown({
    Title = "Theme",
    Values = { "Dark", "Light", "Midnight", "Oceanic" },
    Value = "Oceanic",
    Callback = function(name)
        ANUI:SetTheme(name)
    end,
})

ANUI:OnThemeChange(function(themeKey)
    print("当前主题 key：", themeKey)
    print("显示名称：", ANUI:GetCurrentTheme())
end)
```
