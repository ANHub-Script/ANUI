# Keybind

把一个操作绑定到键盘按键或鼠标按钮上。只要被绑定的按键被按下，回调就会全局触发，因此快捷键在游戏中的任何地方都有效 —— 而不只是窗口打开时。

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Keybind({
    Title = "Keybind",
    Value = "F",
    Callback = function(key)
        print("Pressed:", key)
    end
})
```

## 配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Keybind"` | 主标签。支持[富文本标记](/zh/elements/#title-与-desc-中的富文本)。 |
| `Desc` | `string` | `nil` | 标题下方的可选描述。 |
| `Locked` | `boolean` | `false` | 显示锁定遮罩并阻止交互。 |
| `Value` | `string` | `"F"` | 初始按键，以**按键名称**字符串给出（例如 `"F"`、`"G"`）。 |
| `CanChange` | `boolean` | `true` | 用户是否可以通过点击来重新绑定按键。在当前版本中实际上始终为启用状态。 |
| `Callback` | `function` | `nil` | 被绑定的按键被按下时执行。**接收按键名称，类型为字符串。** |
| `Buttons` | `table` | `nil` | 渲染在该行内的内联按钮。 |
| `TitleGradient` | `table` | `nil` | 应用于标题文字的渐变。 |
| `DescGradient` | `table` | `nil` | 应用于描述文字的渐变。 |
| `Flag` | `string` | `nil` | 配置持久化用的 key。参见[配置与 Flag](/zh/features/config-and-flags)。 |

::: info 触发方式与重新绑定
- 只要被绑定的按键被按下，回调就会**全局**执行 —— 仅当某个 TextBox 处于焦点状态时才会被抑制，因此打字不会触发快捷键。
- 回调参数是按键的**名称**字符串：`Enum.KeyCode.F` 返回 `"F"`，鼠标按钮返回 `"MouseLeft"` 或 `"MouseRight"`。
- **要重新绑定：** 点击该快捷键。它会显示 `...` 并捕获你接下来按下的按键。
:::

Keybind 同样继承[共享基础](/zh/elements/#共享基础)的配置和方法。

## 方法

### `Keybind:Set(value)`

按名称字符串设置被绑定的按键。

```lua
myKeybind:Set("G")
```

### `Keybind:Lock()` / `Keybind:Unlock()`

锁定或解锁快捷键。被锁定的快捷键会显示遮罩，并且无法重新绑定。

```lua
myKeybind:Lock()
myKeybind:Unlock()
```

### 基础方法

Keybind 同样支持来自[共享基础](/zh/elements/#通用方法)的 `:SetTitle`、`:SetDesc`、`:SetIcon`、`:Highlight`、`:SetButtons` / `:GetButton` / `:GetButtons` 和 `:Destroy`。

## 示例

### 重新绑定窗口的开关按键

由于回调给出的是按键名称，你可以用 `Enum.KeyCode[key]` 把它转换回 `Enum.KeyCode`，然后直接交给 `Window:SetToggleKey`。

```lua
myTab:Keybind({
    Flag = "KeybindTest",
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})
```

::: tip 持久化按键绑定
添加一个 `Flag`，即可在会话之间保存并恢复所绑定的按键。参见[配置与 Flag](/zh/features/config-and-flags)。
:::
