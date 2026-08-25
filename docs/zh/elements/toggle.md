# Toggle

一个向回调返回布尔值的开关。Toggle 默认渲染为带动画的滑块，也可以通过 `Type = "Checkbox"` 渲染为复选框。

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})
```

## 配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Toggle"` | 主标签。支持[富文本标记](/zh/elements/#title-与-desc-中的富文本)。 |
| `Desc` | `string` | `nil` | 标题下方的可选描述。 |
| `Value` | `boolean` | `false` | 初始状态。 |
| `Type` | `string` | `"Toggle"` | `"Toggle"`（带动画的滑块）或 `"Checkbox"`。 |
| `Icon` | `string` | `nil` | 显示在滑块把手内的图标。 |
| `IconSize` | `number` | `23` | 把手图标的尺寸，单位为像素。 |
| `Image` | `string` \| `table` | `nil` | 左对齐图片（asset id 或 card 表）。 |
| `ImageSize` | `number` | `30` | 左侧图片的尺寸，单位为像素。 |
| `Thumbnail` | `string` | `nil` | 大尺寸缩略图。 |
| `ThumbnailSize` | `number` | `80` | 缩略图尺寸，单位为像素。 |
| `Locked` | `boolean` | `false` | 锁定遮罩；阻止交互**并且**停用回调。 |
| `Disabled` | `boolean` | `false` | 仅阻止用户交互（仍可从代码触发回调）。 |
| `Callback` | `function` | `nil` | 值变化时执行。**接收新的布尔值。** |
| `Flag` | `string` | `nil` | 配置持久化用的 key。参见[配置与 Flag](/zh/features/config-and-flags)。 |
| `Buttons` | `table` | `nil` | 渲染在该行内的内联按钮。 |
| `TitleGradient` | `table` | `nil` | 应用于标题文字的渐变。 |
| `DescGradient` | `table` | `nil` | 应用于描述文字的渐变。 |

::: info Locked vs Disabled
`Locked` 会显示锁定遮罩、阻止用户交互，**并且**阻止回调执行。`Disabled` 只阻止*用户*交互 —— 你仍然可以用 `:Set(...)` 从代码改变它的值，而且回调会照常执行。使用 `:Lock()`/`:Unlock()` 和 `:Disable()`/`:Enable()` 可以在运行时切换这些状态。
:::

Toggle 同样继承[共享基础](/zh/elements/#共享基础)的配置和方法。

## 方法

### `Toggle:Set(value, isCallback?, isAnimated?, force?)`

通过代码设置开关状态。

- `value`（`boolean`）—— 新的状态。
- `isCallback`（`boolean`，可选）—— 为这次变化执行 `Callback`。
- `isAnimated`（`boolean`，可选）—— 为把手的过渡添加动画。
- `force`（`boolean`，可选）—— 强制应用这次变化。

```lua
myToggle:Set(true, true)          -- 打开并执行回调
myToggle:Set(false, false, false) -- 静默关闭，且不带动画
```

### `Toggle:Lock(text?)` / `Toggle:Unlock()`

锁定或解锁开关。可选的 `text` 参数用于设置遮罩上的文字。

```lua
myToggle:Lock("Premium only")
myToggle:Unlock()
```

### `Toggle:Disable()` / `Toggle:Enable()`

在不显示锁定遮罩的情况下停用或重新启用*用户*交互。与 `Lock` 不同，当你从代码设置值时回调仍会执行。

### `Toggle:SetMainImage(image, size)`

更新左对齐图片及其尺寸。

```lua
myToggle:SetMainImage("rbxassetid://84366761557806", 24)
```

### 基础方法

Toggle 同样支持来自[共享基础](/zh/elements/#通用方法)的 `:SetTitle`、`:SetDesc`、`:SetIcon`、`:Highlight`、`:SetButtons` / `:GetButton` / `:GetButtons` 和 `:Destroy`。

## 示例

### 基础用法与描述

```lua
myTab:Toggle({
    Title = "Basic Toggle",
    Desc = "Standard toggle with animated slider (drag or click).",
    Callback = function(v)
        print("Basic Toggle:", v)
    end
})
```

### 带左侧图片

```lua
myTab:Toggle({
    Title = "Toggle with Left Image",
    Desc = "Image on the left, centered between title and desc.",
    Image = "rbxassetid://84366761557806",
    ImageSize = 24,
    Callback = function(v) print(v) end
})
```

### 带把手图标并默认开启

```lua
myTab:Toggle({
    Title = "Toggle with Icon",
    Desc = "Shows an icon inside the slider when toggled.",
    Icon = "mouse",
    IconSize = 15,
    Value = true,
    Callback = function(v) print(v) end
})
```

### Checkbox 变体

```lua
myTab:Toggle({
    Title = "Checkbox",
    Desc = "Checkbox variant of toggle.",
    Type = "Checkbox",
    Callback = function(v) print(v) end
})

myTab:Toggle({
    Title = "Checkbox (Default ON)",
    Type = "Checkbox",
    Value = true,
    Callback = function(v) print(v) end
})
```

### 锁定

```lua
myTab:Toggle({
    Title = "Locked Toggle",
    Desc = "Locked state prevents user interaction.",
    Locked = true,
    Callback = function(v) print(v) end
})
```

### 通过代码更新

```lua
local progToggle = myTab:Toggle({
    Title = "Programmatic Toggle",
    Desc = "Demonstrates using Set() and updating title/desc via code.",
    Value = false,
    Callback = function(v) print("Programmatic Toggle:", v) end
})

myTab:Button({
    Title = "Turn ON",
    Callback = function()
        progToggle:Set(true, true)
        progToggle:SetTitle("Programmatic Toggle (ON)")
        progToggle:SetDesc("Toggled on by code.")
    end
})

myTab:Button({
    Title = "Turn OFF (no animation)",
    Callback = function()
        progToggle:Set(false, true, false)
        progToggle:SetTitle("Programmatic Toggle (OFF)")
        progToggle:SetDesc("Toggled off by code without animation.")
    end
})
```

### 使用 Flag 持久化

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(v) print(v) end
})
```

只要有配置处于生效状态，这个值就会自动保存并恢复 —— 参见[配置与 Flag](/zh/features/config-and-flags)。
