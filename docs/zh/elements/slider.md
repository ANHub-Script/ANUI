# Slider

可拖动的数值滑块，带可选的步进和手动文本输入。它的值可以设定范围、按步进取值，并格式化为整数或浮点数。

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        print("Volume:", value)
    end
})
```

## 配置

你既可以用 `Value` 表来定义范围，也可以用扁平的 `Min` / `Max` / `Default` 字段。

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Slider"` | 主标签。支持[富文本标记](/zh/elements/#title-与-desc-中的富文本)。 |
| `Desc` | `string` | `nil` | 标题下方的可选描述。 |
| `Value` | `table` | `nil` | 范围表 `{ Min, Max, Default }`。可替代下面的字段。 |
| `Min` | `number` | `0` | 下限（不使用 `Value` 时）。 |
| `Max` | `number` | `100` | 上限（不使用 `Value` 时）。 |
| `Default` | `number` | `0` | 初始值（不使用 `Value` 时）。 |
| `Step` | `number` | `1` | 相邻停靠点之间的增量。**小数**步进（例如 `0.1`）会把滑块切换到浮点模式。 |
| `Locked` | `boolean` | `false` | 显示锁定遮罩并阻止交互。 |
| `Callback` | `function` | `nil` | 值变化时执行。**接收一个格式化后的字符串**（见下文）。 |
| `Flag` | `string` | `nil` | 配置持久化用的 key。参见[配置与 Flag](/zh/features/config-and-flags)。 |
| `Buttons` | `table` | `nil` | 渲染在该行内的内联按钮。 |
| `TitleGradient` | `table` | `nil` | 应用于标题文字的渐变。 |
| `DescGradient` | `table` | `nil` | 应用于描述文字的渐变。 |

::: warning 回调参数是字符串
传给 `Callback` 的值是一个**格式化后的字符串**，而不是数字。整数滑块收到的是向下取整后的整数（`"50"`）；浮点滑块（小数 `Step`）收到的是 `"%.2f"` 格式的字符串（`"0.50"`）。在进行任何数学运算之前，先用 `tonumber(value)` 转换它。
:::

Slider 同样继承[共享基础](/zh/elements/#共享基础)的配置和方法。

## 数值格式化与 snapping

- **Snapping** —— 原始位置会吸附到最近的步进点：`floor(raw / Step + 0.5) * Step`。
- **整数与浮点** —— 整数 `Step` 会把值向下取整为整数；小数 `Step` 会用 `"%.2f"` 格式化它。
- **手动输入** —— 这个数值同时也是一个文本框。点击它，输入数字，然后按 **Enter** 提交。
- **持久化** —— 设置了 `Flag` 时，配置会把 `Value.Default` 以格式化后的字符串保存下来。

## 方法

### `Slider:Set(value, input?)`

通过代码设置滑块的值。`value` 是范围内的一个数字；`input?` 是一个可选标记，用于表示这次变化来自手动文本框。

```lua
mySlider:Set(75)
```

### `Slider:SetMin(n)`

更新滑块的下限。

```lua
mySlider:SetMin(10)
```

### `Slider:SetMax(n)`

更新滑块的上限。

```lua
mySlider:SetMax(200)
```

### `Slider:Lock()` / `Slider:Unlock()`

锁定或解锁滑块。

```lua
mySlider:Lock()
mySlider:Unlock()
```

## 示例

### 整数滑块（Volume 0–100）

记住：在把字符串参数当作数字使用之前，要先转换它。

```lua
myTab:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        local n = tonumber(value) -- value 是形如 "50" 的字符串
        print("Volume:", n)
    end
})
```

### 浮点滑块（小数 Step）

`Step` 为 `0.1` 会让滑块进入浮点模式，因此回调收到的是类似 `"0.50"` 的值。

```lua
myTab:Slider({
    Title = "Brightness",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(value)
        print("Brightness:", value) -- "0.50"
    end
})
```

### 使用 Flag 持久化

```lua
myTab:Slider({
    Title = "Slider",
    Flag = "SliderTest",
    Step = 1,
    Value = { Min = 20, Max = 120, Default = 70 },
    Callback = function(value)
        print(value)
    end
})
```

### 通过代码控制

```lua
local speed = myTab:Slider({
    Title = "Speed",
    Value = { Min = 0, Max = 100, Default = 20 },
    Callback = function(value) print(value) end
})

speed:Set(60)     -- 把手柄移动到 60
speed:SetMax(150) -- 扩大范围
```
