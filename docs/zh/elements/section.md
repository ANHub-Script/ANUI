# Section

放置在标签页内部的可折叠容器。与 Tab 一样，Section 提供全部元素创建方法，因此你可以向其中添加子元素，它们会分组显示在一个可展开和折叠的表头之下。

::: info 两个不同的 "Section" 概念
本页介绍的是**内容元素** `Tab:Section({...})`——一个放置在标签页*内部*的可折叠容器。

它与 `Window:Section({ Title = ... })` 无关，后者创建的是用于给标签页分组的**侧边栏分区标题**。关于那一个，请参阅[标签页与分区](/zh/guide/tabs-and-sections)。
:::

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local combat = myTab:Section({ Title = "Combat" })

combat:Toggle({ Title = "God Mode", Callback = function(state) end })
combat:Button({ Title = "Kill Aura", Callback = function() end })
```

::: tip
只有在至少包含一个子元素后，Section 才可以展开——空的 Section 没有内容可以折叠。
:::

## 配置

| Field | Type | Default | 说明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Section"` | 表头标签。支持[富文本标记](/zh/elements/#title-与-desc-中的富文本)，包括内联的 `{icon}` 标记。 |
| `Icon` | `string` | `nil` | 表头图标：Lucide 名称或 `rbxassetid://…`。 |
| `Image` | `string` | `nil` | 表头图片资源（`Icon` 的替代方案）。 |
| `IconSize` | `number` | `20` | 表头图标尺寸，单位为像素。 |
| `IconThemed` | `boolean` | `false` | 用当前主题色为图标着色。 |
| `InlineIcon` | `boolean` | `true` | 将图标与标题文本内联渲染。 |
| `TextSize` | `number` | `19` | 表头标题文本大小。 |
| `TextXAlignment` | `string` | `"Left"` | 表头标题的水平对齐方式。 |
| `TextTransparency` | `number` | `0.05` | 表头标题文本透明度。 |
| `FontWeight` | `Enum.FontWeight` \| `string` | `SemiBold` | 表头标题的字体粗细。 |
| `Box` | `boolean` | `false` | 将分区包裹在带描边的方框中。 |
| `Opened` | `boolean` | `false` | 初始为展开状态而非折叠。 |
| `HeaderSize` | `number` | `42` | 表头行的高度，单位为像素。 |
| `HeaderPadding` | `number` | `8` | 表头行的内边距。 |
| `ChevronSize` | `number` | `20` | 展开/折叠箭头的尺寸。 |

## 方法

每个元素创建方法（`Section:Button`、`Section:Toggle`、`Section:Slider`……）在 Section 上都可用，和在 Tab 上完全一样——参见[元素概览](/zh/elements/)。Section 专属的方法列在下面。

### `Section:SetTitle(text)`

更新表头标签。

```lua
combat:SetTitle("Combat (active)")
```

### `Section:SetIcon(icon)`

设置表头图标（Lucide 名称或 `rbxassetid://…`）。

```lua
combat:SetIcon("swords")
```

### `Section:SetIconSize(size)`

设置表头图标尺寸，单位为像素。

```lua
combat:SetIconSize(24)
```

### `Section:GetIcon()`

返回当前的表头图标。

```lua
print(combat:GetIcon())
```

### `Section:Open()` / `Section:Close()`

展开或折叠该分区。

```lua
combat:Open()
combat:Close()
```

### `Section:Destroy()`

移除该分区及其子元素。

```lua
combat:Destroy()
```

## 示例

### 图标、带标记的标题以及默认展开

```lua
local stats = myTab:Section({
    Title = "{swords} Combat Stats",
    Icon = "swords",
    Opened = true,
})

stats:Slider({ Title = "Damage", Value = { Min = 0, Max = 100, Default = 50 } })
stats:Toggle({ Title = "Auto Attack", Callback = function(state) end })
```

### 通过代码展开和折叠

```lua
local advanced = myTab:Section({ Title = "Advanced" })
advanced:Toggle({ Title = "Verbose Logging" })

advanced:Open()  -- 展开
advanced:Close() -- 折叠
```

::: info
由于 Section 是一个容器，它不会继承任何交互式的 shared-base 行为（锁定、高亮等等）——这些行为属于你放置在*其内部*的元素。
:::
