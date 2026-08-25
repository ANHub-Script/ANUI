# Divider

一条细分隔线，用于在视觉上分隔元素。在 Tab 或 Section 中它渲染为水平线；在 [Group](/zh/elements/group) 内部则渲染为分组各列之间的垂直线。

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({ Title = "Save", Callback = function() end })
myTab:Divider()
myTab:Button({ Title = "Load", Callback = function() end })
```

## 配置

`Divider` 不接受任何配置——直接调用 `Tab:Divider()`，无需参数。

::: info 在 Group 内部为垂直方向
由于 [Group](/zh/elements/group) 会将其子元素横向排列，放置在其中的 Divider 会绘制为列之间的**垂直**分隔线，而不是水平线。
:::

## 示例

### 分隔多组控件

```lua
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })

myTab:Divider()

myTab:Button({ Title = "Reset", Callback = function() end })
```

### 列之间的垂直分隔线

```lua
local row = myTab:Group({})
row:Button({ Title = "Accept", Callback = function() end })
row:Divider()
row:Button({ Title = "Decline", Callback = function() end })
```

::: info
Divider 纯粹是装饰性的——它不是交互式元素，因此没有任何配置或方法。
:::
