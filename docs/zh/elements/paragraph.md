# Paragraph

用于标题、说明和描述的富文本块。它构建在[共享基础](/zh/elements/#共享基础)之上并禁用了悬停效果，因此表现为静态内容——同时它也可以作为一个轻量容器，让你在其上挂载子元素。

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Paragraph({
    Title = "Toggle Examples",
    Desc = "This tab showcases all supported Toggle features: classic toggle, checkbox variant, per-item icons, default values, locking, and programmatic updates."
})
```

## 配置

| Field | Type | Default | 说明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Paragraph"` | 标题文本。支持[富文本标记](/zh/elements/#title-与-desc-中的富文本)。 |
| `Desc` | `string` | `nil` | 正文文本。支持富文本标记，并可通过 `\n` 换行。 |
| `Locked` | `boolean` | `false` | 显示锁定遮罩。 |
| `Images` | `table` | `nil` | 卡片对象数组，渲染为图片卡片网格（见下文）。 |
| `ImageSize` | `UDim2` | `UDim2.fromOffset(70, 70)` | 每个图片卡片的尺寸。 |
| `Buttons` | `table` | `nil` | `{ Title, Icon, Callback }` 数组，渲染为文本下方的**堆叠全宽按钮**。 |

### 图片卡片对象

`Images` 中的每一项都是一个表：

| Field | Type | 说明 |
| --- | --- | --- |
| `Title` | `string` | 卡片的标签。 |
| `Quantity` | `string` | 数量/计数徽章（例如 `"244x"`）。 |
| `Image` | `string` | Asset id（`rbxassetid://…`）或图标名称。 |
| `Gradient` | `ColorSequence` | 卡片的背景渐变。 |
| `Callback` | `function` | 点击卡片时运行。 |

::: info 两种 `Buttons`
这里的 `Buttons` 配置会在段落文本下方渲染**堆叠的全宽**按钮（每项为 `{ Title, Icon, Callback }`）。这与其他元素在自身行内渲染的共享基础内联 `Buttons` **映射表**不同。
:::

Paragraph 会从[共享基础](/zh/elements/#共享基础)继承 `Image`、渐变、富文本标记、锁定和高亮。悬停始终处于禁用状态。

## 方法

### `Paragraph:SetTitle(text)` / `Paragraph:SetDesc(text)`

更新段落中保存的 `Title` / `Desc` 字段。

```lua
myParagraph:SetTitle("Updated heading")
myParagraph:SetDesc("Updated body text.")
```

::: details 更新可见的文本
`:SetTitle` / `:SetDesc` 更新的是元素的 Lua 字段。要修改已经显示在屏幕上的文本，请使用底层 ParagraphFrame 自带的设置方法。
:::

### `Paragraph:SetViewport(model, cameraOffset?)`

渲染一个 95×95 的 `ViewportFrame`，显示 `model` 的 3D 预览，`cameraOffset` 为可选参数。

```lua
myParagraph:SetViewport(workspace.SomeModel)
```

## 示例

### 多行描述

使用 `\n` 将描述分成多行。

```lua
myTab:Paragraph({
    Title = "Rank Information",
    Desc = "Current Rank: S-Class\nPower: 500,000"
})
```

### 作为轻量容器

Paragraph 对象提供与 Tab 相同的元素创建方法，因此你可以直接在它上面挂载子元素——非常适合把控件归到一个标题之下。

```lua
local group = myTab:Paragraph({
    Title = "Yen Upgrades",
    Desc = "Upgrade stats using Yen currency"
})

group:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" })
group:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" })
group:Button({ Title = "Rank Up", Icon = "arrow-up-circle" })
```

### 图片卡片网格

```lua
myTab:Paragraph({
    Title = "Inventory",
    ImageSize = UDim2.fromOffset(70, 70),
    Images = {
        {
            Title = "World Box",
            Quantity = "244x",
            Image = "rbxassetid://84366761557806",
            Gradient = ColorSequence.new(Color3.fromHex("#C042FF"), Color3.fromHex("#8E24AA")),
            Callback = function() print("World Box") end
        },
        {
            Title = "Zone Key",
            Quantity = "3x",
            Image = "key",
            Gradient = ColorSequence.new(Color3.fromHex("#29B6F6"), Color3.fromHex("#0288D1")),
            Callback = function() print("Zone Key") end
        },
    }
})
```

### 堆叠按钮

```lua
myTab:Paragraph({
    Title = "ANHUB Discord",
    Desc = "Members: 1,234\nOnline: 567",
    Buttons = {
        {
            Title = "Copy link",
            Icon = "link",
            Callback = function()
                setclipboard("https://discord.gg/qN47S3mKZA")
            end
        }
    }
})
```
