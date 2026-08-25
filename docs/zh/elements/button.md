# Button

可点击的操作行，带可选的图标、颜色和内联按钮。Button 是最简单的交互元素 —— 点击时它会执行一个回调。

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({
    Title = "Click me",
    Callback = function()
        print("Button clicked!")
    end
})
```

## 配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Button"` | 主标签。支持[富文本标记](/zh/elements/#title-与-desc-中的富文本)。 |
| `Desc` | `string` | `nil` | 标题下方的可选描述。 |
| `Icon` | `string` | `"mouse-pointer-click"` | 图标名称或 `rbxassetid://…`。 |
| `IconThemed` | `boolean` | `false` | 用当前主题色为图标着色。 |
| `Color` | `Color3` \| `string` | `nil` | 彩色背景（主题名称或 `Color3`）；文字颜色会自动形成对比。 |
| `Justify` | `string` | `"Between"` | 内容对齐方式。`"Between"` 会把标题与图标撑向两端；`"Center"` 会让两者居中。 |
| `IconAlign` | `string` | `"Right"` | 图标所在的一侧：`"Right"` 或 `"Left"`。 |
| `Locked` | `boolean` | `false` | 显示锁定遮罩并阻止点击。 |
| `Callback` | `function` | `nil` | 按钮被点击时执行。**不接受任何参数。** |
| `Buttons` | `table` | `nil` | 渲染在该行内的内联按钮。 |
| `TitleGradient` | `table` | `nil` | 应用于标题文字的渐变。 |
| `DescGradient` | `table` | `nil` | 应用于描述文字的渐变。 |

::: info Callback 签名
Button 的 `Callback` **不接受任何参数** —— 它只是一个普通的操作处理函数。如果你需要响应某个值，请改用 [Toggle](/zh/elements/toggle) 或 [Dropdown](/zh/elements/dropdown)。
:::

Button 同样继承[共享基础](/zh/elements/#共享基础)的配置（`Image`、`Thumbnail`、渐变、`Title`/`Desc` 中的富文本标记等等）。

## 方法

### `Button:Highlight()`

让按钮短暂闪烁以吸引用户注意。

```lua
local btn = myTab:Button({ Title = "Notice me", Callback = function() end })
btn:Highlight()
```

### `Button:Lock()` / `Button:Unlock()`

锁定或解锁按钮。被锁定的按钮会显示遮罩并忽略点击。

```lua
btn:Lock()
btn:Unlock()
```

### `Button:SetTitle(text)` / `Button:SetDesc(text)` / `Button:SetIcon(icon)`

在运行时更新标题、描述或图标。

```lua
btn:SetTitle("Updated title")
btn:SetDesc("Updated description")
btn:SetIcon("check")
```

### `Button:SetButtons(buttons)` / `Button:GetButton(key)` / `Button:GetButtons()`

管理渲染在该行内的内联按钮。`SetButtons` 替换整个映射表，`GetButton` 按 key 取出其中一个，`GetButtons` 返回全部。

### `Button:Destroy()`

把按钮从它所属的容器中移除。

## 示例

### 基础与彩色

```lua
myTab:Button({
    Title = "Highlight Button",
    Icon = "mouse",
    Callback = function()
        print("clicked highlight")
    end
})

myTab:Button({
    Title = "Blue Button",
    Desc = "With description",
    Color = Color3.fromHex("#305dff"),
    Icon = "",
    Callback = function() end
})
```

### 图标对齐与内容分布

```lua
myTab:Button({
    Title = "Left Icon",
    Desc = "Icon aligned to the left",
    Icon = "mouse",
    IconAlign = "Left",
    Justify = "Center",
    Callback = function() end
})
```

### 主题图标与彩色图标

```lua
myTab:Button({
    Title = "Themed Icon",
    Desc = "Icon follows theme colors",
    Icon = "palette",
    IconThemed = true,
    Callback = function() end
})

myTab:Button({
    Title = "Colored Icon",
    Desc = "Icon tinted with custom color",
    Icon = "mouse-pointer-click",
    Color = Color3.fromHex("#f57c00"),
    Callback = function() end
})
```

### 锁定

```lua
myTab:Button({
    Title = "Button",
    Desc = "Button example",
    Locked = true
})
```

### 通过代码更新

保存返回的模块，然后从另一个按钮更新它。`Highlight()` 会把注意力吸引到这次变化上。

```lua
local progBtn = myTab:Button({
    Title = "Programmatic Button",
    Desc = "Will be updated by code",
    Icon = "edit",
    Callback = function() end
})

myTab:Button({
    Title = "Update Above",
    Desc = "SetTitle and SetDesc",
    Icon = "chevron-right",
    Callback = function()
        progBtn:SetTitle("Programmatic Button (Updated)")
        progBtn:SetDesc("Updated by code")
        progBtn:Highlight()
    end
})
```

### 通过对话框展示 UI 按钮变体

`Window:Dialog` 内部的按钮支持 `Variant` 样式 —— `"Primary"`、`"Secondary"` 和 `"White"`。

```lua
myTab:Button({
    Title = "Show UI Button Variants",
    Desc = "Opens dialog with Primary/Secondary/White",
    Icon = "square-menu",
    Callback = function()
        Window:Dialog({
            Title = "UI Button Variants",
            Content = "Demonstrates button variants.",
            Buttons = {
                { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
                { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
                { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
            }
        })
    end
})
```

::: tip
设置 `Icon = ""` 可以渲染出完全没有图标的按钮 —— 适合居中的纯文字操作按钮。
:::
