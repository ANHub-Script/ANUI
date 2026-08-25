# Input

用于获取字符串输入的文本框 —— 单行（`"Input"`）或多行（`"Textarea"`）。每次文本框提交时，它的回调都会收到当前的文本。

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Input({
    Title = "Input",
    InputIcon = "mouse",
    Placeholder = "Enter Text...",
    Callback = function(text)
        print("Text:", text)
    end
})
```

## 配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Input"` | 主标签。支持[富文本标记](/zh/elements/#title-与-desc-中的富文本)。 |
| `Desc` | `string` | `nil` | 标题下方的可选描述。 |
| `Type` | `string` | `"Input"` | `"Input"`（单行）或 `"Textarea"`（多行）。 |
| `Locked` | `boolean` | `false` | 显示锁定遮罩并阻止交互。 |
| `InputIcon` | `string` \| `boolean` | `false` | 显示在输入框内的图标。`false` 表示不显示。 |
| `Placeholder` | `string` | `"Enter Text..."` | 文本框为空时显示的灰色提示文字。 |
| `Value` | `string` | `""` | 初始文本。 |
| `ClearTextOnFocus` | `boolean` | `false` | 获得焦点时自动清空文本框。 |
| `Callback` | `function` | `nil` | 提交时执行。**接收当前文本，类型为字符串。** |
| `Buttons` | `table` | `nil` | 渲染在该行内的内联按钮。 |
| `TitleGradient` | `table` | `nil` | 应用于标题文字的渐变。 |
| `DescGradient` | `table` | `nil` | 应用于描述文字的渐变。 |
| `Flag` | `string` | `nil` | 配置持久化用的 key。参见[配置与 Flag](/zh/features/config-and-flags)。 |

::: info Callback 签名
`Callback` 接收单个**字符串** —— 也就是文本框当前的文本。它会在文本框提交时（失去焦点，或单行输入框中按下 Enter）执行，并且**在初始化时执行一次**，带上初始的 `Value`。
:::

Input 同样继承[共享基础](/zh/elements/#共享基础)的配置和方法。

## 方法

### `Input:Set(value, isUserInput?)`

把文本框的文本设为 `value`。可选的 `isUserInput` 标记表示这次变化来自用户。

```lua
myInput:Set("hello")
```

### `Input:SetPlaceholder(value)`

更新文本框为空时显示的占位提示。

```lua
myInput:SetPlaceholder("Type a name...")
```

### `Input:Lock()` / `Input:Unlock()`

锁定或解锁输入框。被锁定的输入框会显示遮罩并忽略键入。

```lua
myInput:Lock()
myInput:Unlock()
```

### 基础方法

Input 同样支持来自[共享基础](/zh/elements/#通用方法)的 `:SetTitle`、`:SetDesc`、`:SetIcon`、`:Highlight`、`:SetButtons` / `:GetButton` / `:GetButtons` 和 `:Destroy`。

## 示例

### 基础用法与图标

```lua
myTab:Input({
    Title = "Input",
    InputIcon = "mouse"
})
```

### Textarea（多行）

```lua
myTab:Input({
    Title = "Input Textarea",
    Type = "Textarea",
    InputIcon = "mouse"
})
```

### 带描述

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example"
})
```

### 锁定

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example",
    Locked = true
})
```

### 使用 Flag 持久化

```lua
myTab:Input({
    Flag = "InputTest",
    Title = "Input",
    Desc = "Input Description",
    Value = "Default value",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter text...",
    Callback = function(input)
        print("Text entered:", input)
    end
})
```

只要有配置处于生效状态，这个值就会自动保存并恢复 —— 参见[配置与 Flag](/zh/features/config-and-flags)。
