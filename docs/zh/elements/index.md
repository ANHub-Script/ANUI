# 元素

元素是窗口内的交互控件 —— 按钮、开关、滑块、下拉菜单等等。元素始终由**容器**创建：标签页（Tab）、分区（Section）或分组（Group）。

## 创建元素

每个元素都通过调用容器上的方法来创建。最常用的容器是标签页：

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "My Hub", Folder = "MyHub" })

-- 1. 创建一个容器（标签页）
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

-- 2. 在它上面创建元素
myTab:Button({ Title = "Click me", Callback = function() end })
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
```

`Section` 和 `Group` 同样是容器 —— 它们提供与标签页**相同**的元素创建方法，因此你可以嵌套元素来组织布局：

```lua
local section = myTab:Section({ Title = "Combat" })
section:Toggle({ Title = "God Mode", Callback = function(state) end })

local row = myTab:Group({})       -- 将子元素横向排列
row:Button({ Title = "Save" })
row:Button({ Title = "Load" })
```

::: tip
每个元素创建方法都会返回一个模块，你可以在它上面调用方法（例如 `local t = myTab:Toggle({...})` 然后 `t:Set(true)`）。如果你打算稍后更新该元素，请保存返回值。
:::

## 共享基础

大多数交互元素都构建在同一套基础之上，因此它们共享一组配置字段和方法。学会一次，处处适用。

### 通用配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | 元素名称 | 主标签。支持[富文本标记](#title-与-desc-中的富文本)。 |
| `Desc` | `string` | `nil` | 次要描述行。支持富文本标记、`\n` 和 `\t`。 |
| `Icon` | `string` | 因元素而异 | 图标名称（Lucide）或 `rbxassetid://…`。 |
| `Image` | `string` \| `table` | `nil` | 左对齐图片（asset id 或 card 表）。 |
| `ImageSize` | `number` | `30` | 左侧图片的尺寸，单位为像素。 |
| `Thumbnail` | `string` | `nil` | 大尺寸缩略图。 |
| `ThumbnailSize` | `number` | `80` | 缩略图尺寸，单位为像素。 |
| `IconThemed` | `boolean` | `false` | 用当前主题色为图标着色。 |
| `Color` | `Color3` \| `string` | `nil` | 彩色背景（主题名称或 `Color3`）；文字颜色会自动形成对比。 |
| `Justify` | `string` | `"Between"` | 元素行内的内容对齐方式。 |
| `Locked` | `boolean` | `false` | 显示锁定遮罩并阻止交互。 |
| `Buttons` | `table` | `nil` | 渲染在元素行内的内联按钮（见下文）。 |
| `TitleGradient` | `table` | `nil` | 应用于标题文字的渐变。 |
| `DescGradient` | `table` | `nil` | 应用于描述文字的渐变。 |

### 通用方法

以下方法在大多数交互元素上都可用：

- `:SetTitle(text)` —— 更新标题。
- `:SetDesc(text)` —— 更新描述。
- `:SetIcon(icon)` / `:SetImage(image)` —— 更新图标或图片。
- `:Lock(text?)` —— 锁定元素（可选附带遮罩文字）。
- `:Unlock()` —— 解除元素的锁定。
- `:Highlight()` —— 让元素短暂闪烁以吸引注意。
- `:Destroy()` —— 移除元素。
- `:SetButtons(buttons)` / `:GetButton(key)` / `:GetButtons()` —— 管理内联按钮。

::: info
每个元素都会在共享基础之上添加自己的方法 —— 例如 `Toggle:Set(...)`、`Slider:SetMax(...)` 或 `Dropdown:Refresh(...)`。完整列表请查看各元素对应的页面。
:::

## Title 与 Desc 中的富文本

`Title` 和 `Desc` 接受内联标记，让你可以直接在文本中嵌入图标、图片、渐变，甚至按钮：

- **内联图标** —— `{icon}` 或 `{name}`，并可选指定尺寸：`{icon:star size=28}`。
- **内联图片** —— 直接把 `rbxassetid://…` 引用放进字符串里即可。
- **渐变** —— 用 `<gradient>…</gradient>` 包裹文本，或指定颜色与旋转角度：`<gradient=#40c9ff,#e81cff|45>…</gradient>`。
- **内联按钮** —— `<button=key>Label</button>` 或简写 `{button:key}`，与元素 `Buttons` 映射表中的条目相连。

`Desc` 还额外支持：

- `\n` —— 多行描述。
- `\t` —— 两列布局的一行（左侧为标签，右侧为数值）。

```lua
myTab:Button({
    Title = "Status: <gradient=#30FF6A,#e7ff2f>Online</gradient> {check}",
    Desc = "Ping\t24ms\nRegion\tSEA",
})
```

## 使用 Flag 持久化配置

有状态的元素 —— **Toggle**、**Slider**、**Dropdown**、**Input**、**Keybind** 和 **Colorpicker** —— 都接受 `Flag` 字段。带 Flag 的元素会自动注册到当前生效的配置中，因此它的值会在会话之间保存并恢复。

```lua
myTab:Toggle({ Title = "Auto Farm", Flag = "AutoFarm", Callback = function(state) end })
```

完整流程请参阅[配置与 Flag](/zh/features/config-and-flags)。

## 所有元素

| 元素 | 描述 |
| --- | --- |
| [Button](/zh/elements/button) | 可点击的操作行，带可选图标和内联按钮。 |
| [Toggle](/zh/elements/toggle) | 返回布尔值的开关或复选框。 |
| [Slider](/zh/elements/slider) | 可拖动的数值滑块，带可选步进与手动输入。 |
| [Dropdown](/zh/elements/dropdown) | 单选或多选列表；也可以充当操作菜单。 |
| [Input](/zh/elements/input) | 单行或多行文本框。 |
| [Keybind](/zh/elements/keybind) | 将操作绑定到按键，按下时全局触发。 |
| [Colorpicker](/zh/elements/colorpicker) | 通过对话框选择颜色（可选带透明度）。 |
| [Paragraph](/zh/elements/paragraph) | 富文本块，带可选图片卡片和堆叠按钮。 |
| [Code](/zh/elements/code) | 可复制的代码片段块。 |
| [Section](/zh/elements/section) | 可折叠的容器，把子元素归入一个标题之下。 |
| [Divider](/zh/elements/divider) | 水平分隔线（在 Group 中为垂直分隔线）。 |
| [Space](/zh/elements/space) | 用于留出垂直空间的隐形间隔。 |
| [Image](/zh/elements/image) | 独立图片，可控制宽高比与缩放。 |
| [Group](/zh/elements/group) | 将子元素横向排列的容器。 |
| [Category](/zh/elements/category) | 用于在多组元素之间切换的横向选项条。 |
