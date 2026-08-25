# Code

带有内置复制按钮的语法样式代码块。非常适合展示代码片段、命令或安装行，用户一键即可复制。

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Code({
    Title = "Lua",
    Code = "print('Hello, world!')"
})
```

## 配置

| Field | Type | Default | 说明 |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | 显示在代码块上方的标签。 |
| `Code` | `string` | `nil` | 要显示的代码文本。 |
| `OnCopy` | `function` | `nil` | 代码复制到剪贴板后运行。 |

::: info 复制
复制按钮会写入**执行器剪贴板**。如果复制失败，则会改为显示一条通知。
:::

## 方法

### `Code:SetCode(code)`

用新的字符串替换所显示的代码。

```lua
mySnippet:SetCode("print('updated!')")
```

### `Code:Destroy()`

从容器中移除该代码块。

```lua
mySnippet:Destroy()
```

## 示例

### 一个 Lua 代码片段块

```lua
myTab:Code({
    Title = "Lua",
    Code = "print('Hello from Group 1')"
})
```

### 复制后运行回调

```lua
myTab:Code({
    Title = "Install",
    Code = 'loadstring(game:HttpGet("https://example.com/script.lua"))()',
    OnCopy = function()
        print("Copied!")
    end
})
```

### 使用 `SetCode` 更新代码

保存返回的模块，稍后替换其内容。

```lua
local snippet = myTab:Code({
    Title = "Example",
    Code = "print('initial')"
})

myTab:Button({
    Title = "Update code",
    Callback = function()
        snippet:SetCode("print('updated!')")
    end
})
```
