# Dialogs & Popups

ANUI 提供两种显示模态提示的方式：**`Window:Dialog{}`**，它依附于已有的窗口；以及 **`ANUI:Popup{}`**，一个可以从任何地方打开的独立模态框。两者都会显示标题、正文和一排按钮。

## Dialog 与 Popup 的对比

| | `Window:Dialog{}` | `ANUI:Popup{}` |
| --- | --- | --- |
| 依附方式 | 渲染在已有的窗口内部 | 独立的屏幕级模态框 |
| 是否需要窗口 | 需要 —— 在 `Window` 上调用 | 不需要 —— 直接在 `ANUI` 上调用 |
| 宽度控制 | `Width`（默认 `320`） | — |
| 缩略图图像 | — | `Thumbnail` |
| 返回的对象 | — | 没有方法；由按钮负责关闭 |
| 最适合 | 与你已构建的菜单相关的确认操作 | 在完整窗口之前／没有完整窗口时的快速提示 |

## `Window:Dialog{}`

打开一个依附于窗口的模态对话框。适合用于菜单内部的确认操作和小型选择。

### 配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | — | 对话框标题。 |
| `Content` | `string` | — | 标题下方的正文文字。 |
| `Icon` | `string` | — | 前置图标：Lucide 图标名称或 `rbxassetid://…`。 |
| `Width` | `number` | `320` | 对话框宽度（像素）。 |
| `Buttons` | `table` | — | 按钮配置数组（见下文）。 |

`Buttons` 中的每一项都是一个表：

| Field | Type | 描述 |
| --- | --- | --- |
| `Title` | `string` | 按钮标签。 |
| `Icon` | `string` | 按钮上的可选图标。 |
| `Callback` | `function` | 按钮被点击时执行。**不接受任何参数。** |
| `Variant` | `string` | 视觉样式：`"Primary"`、`"Secondary"` 或 `"White"`。 |

```lua
Window:Dialog({
    Title = "Delete save?",
    Content = "This cannot be undone.",
    Buttons = {
        { Title = "Delete", Variant = "Primary", Icon = "trash", Callback = function()
            print("deleted")
        end },
    },
})
```

## `ANUI:Popup{}`

立即打开一个独立的模态框，无需窗口。它的按钮在被点击时会关闭弹窗，而返回的对象不提供任何方法。

### 配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dialog"` | 弹窗标题。 |
| `Content` | `string` | `nil` | 标题下方的正文文字。 |
| `Icon` | `string` | `nil` | 前置图标：Lucide 图标名称或 `rbxassetid://…`。 |
| `IconThemed` | `boolean` | — | 用主题的图标颜色为图标着色。 |
| `Thumbnail` | `table` | — | 大尺寸预览图像：`{ Image, Title? }`。 |
| `Buttons` | `table` | — | 按钮配置数组（结构与 Dialog 相同）。 |

`Buttons` 中的每一项都是一个表：

| Field | Type | 描述 |
| --- | --- | --- |
| `Title` | `string` | 按钮标签。 |
| `Icon` | `string` | 按钮上的可选图标。 |
| `Callback` | `function` | 被点击时执行，随后弹窗关闭。**不接受任何参数。** |
| `Variant` | `string` | 视觉样式：`"Primary"`、`"Secondary"` 或 `"White"`。 |

::: info Popup 会立即打开
`ANUI:Popup{}` 一被调用就会显示模态框。没有需要 `:Open()` 的东西 —— 返回的对象上也没有任何方法，因为它的按钮已经帮你把它关掉了。
:::

## 示例

### 按钮变体（Dialog）

在同一个对话框里展示三种按钮变体 —— `Primary`、`Secondary` 和 `White`。

```lua
Window:Dialog({
    Title = "UI Button Variants",
    Content = "Demonstrates the Button variants.",
    Buttons = {
        { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
        { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
        { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
    },
})
```

### 确认对话框（Cancel / Confirm）

```lua
Window:Dialog({
    Title = "Reset settings?",
    Content = "All options will return to their defaults.",
    Icon = "rotate-ccw",
    Width = 340,
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function()
            print("cancelled")
        end },
        { Title = "Confirm", Variant = "Primary", Icon = "check", Callback = function()
            print("confirmed")
        end },
    },
})
```

### 简单的弹窗

```lua
ANUI:Popup({
    Title = "Welcome",
    Content = "Thanks for trying the script. Join our community for updates.",
    Icon = "hand",
    Thumbnail = {
        Image = "rbxassetid://84366761557806",
        Title = "ANHub",
    },
    Buttons = {
        { Title = "Copy Discord", Variant = "Primary", Icon = "link", Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
        end },
        { Title = "Close", Variant = "Secondary", Callback = function() end },
    },
})
```
