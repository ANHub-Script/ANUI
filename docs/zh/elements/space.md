# Space

一个不可见的垂直间隔器，用于在元素之间留出空间。它不渲染任何内容——只占据高度。

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Space()
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })
```

## 配置

| Field | Type | Default | 说明 |
| --- | --- | --- | --- |
| `Columns` | `number` | `1` | 高度倍数。间隔器的高度为 `7 × Columns` 像素。 |

::: info 高度
高度按 `7 * Columns` 像素计算——默认的 `Columns = 1` 占据 7px，`Columns = 2` 占据 14px，依此类推。
:::

## 示例

### 更大的间距

```lua
myTab:Space({ Columns = 2 }) -- 14px 的垂直空间
```

### 为一叠元素添加间距

在每个控件之间放一个 `Space()`，是让长列表不显得拥挤的常见做法。

```lua
myTab:Toggle({ Title = "Basic Toggle", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Toggle with Description", Desc = "Extra detail", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Checkbox", Type = "Checkbox", Callback = function(v) end })
```

::: info
Space 不是交互式元素，因此没有任何方法——创建它时通过 `Columns` 字段调整其尺寸。
:::
