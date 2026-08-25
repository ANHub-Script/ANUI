# Colorpicker

通过功能完整的取色对话框选择一个 `Color3` —— 并可选带透明度。当用户应用所选颜色时，回调会带着该颜色触发。

## 基本用法

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Colorpicker({
    Title = "Colorpicker",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(color, transparency)
        print("Color:", color, "Transparency:", transparency)
    end
})
```

## 配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Colorpicker"` | 主标签。支持[富文本标记](/zh/elements/#title-与-desc-中的富文本)。 |
| `Desc` | `string` | `nil` | 标题下方的可选描述。 |
| `Locked` | `boolean` | `false` | 显示锁定遮罩并阻止交互。 |
| `Default` | `Color3` | `Color3.new(1, 1, 1)`（白色） | 色块中显示的初始颜色。 |
| `Transparency` | `number` | `nil` | 初始 alpha 值。只要提供任意数字，就会在取色器中启用 alpha 滑块和输入框。 |
| `Callback` | `function` | `nil` | 点击 **Apply** 时执行。**接收 `(color: Color3, transparency: number)`。** |
| `Buttons` | `table` | `nil` | 渲染在该行内的内联按钮。 |
| `TitleGradient` | `table` | `nil` | 应用于标题文字的渐变。 |
| `DescGradient` | `table` | `nil` | 应用于描述文字的渐变。 |
| `Flag` | `string` | `nil` | 配置持久化用的 key。参见[配置与 Flag](/zh/features/config-and-flags)。 |

::: info 取色对话框
点击色块会打开一个对话框，其中包含：
- 一个 **Saturation/Vibrance** 色域图和一个 **Hue** 滑块，
- 一个可选的 **alpha** 滑块（仅在设置了 `Transparency` 时显示），
- 一个 **Hex** 输入框（`#RRGGBB`）以及 **R / G / B** 输入框 —— 启用透明度时还会有一个 **Alpha** 输入框，
- **Cancel** 和 **Apply** 按钮 —— `Callback` 在点击 **Apply** 时执行。

保存到配置时，取色器会序列化它的十六进制值以及透明度。
:::

Colorpicker 同样继承[共享基础](/zh/elements/#共享基础)的配置和方法。

## 方法

### `Colorpicker:Update(color, transparency?)`

设置当前颜色（以及可选的透明度），并更新色块。

```lua
myColorpicker:Update(Color3.fromRGB(255, 0, 0))
myColorpicker:Update(Color3.fromRGB(255, 0, 0), 0.5)
```

### `Colorpicker:Set(color, transparency?)`

`:Update` 的别名 —— 参数与行为完全相同。

```lua
myColorpicker:Set(Color3.fromHex("#305dff"))
```

### `Colorpicker:Lock()` / `Colorpicker:Unlock()`

锁定或解锁取色器。被锁定的取色器会显示遮罩，并且无法打开。

```lua
myColorpicker:Lock()
myColorpicker:Unlock()
```

### 基础方法

Colorpicker 同样支持来自[共享基础](/zh/elements/#通用方法)的 `:SetTitle`、`:SetDesc`、`:SetIcon`、`:Highlight`、`:SetButtons` / `:GetButton` / `:GetButtons` 和 `:Destroy`。

## 示例

### 带透明度与 Flag

设置 `Transparency`（哪怕设为 `0`）会启用对话框中的 alpha 控件。回调随后会同时收到颜色和透明度。

```lua
myTab:Colorpicker({
    Flag = "ColorpickerTest",
    Title = "Colorpicker",
    Desc = "Colorpicker Description",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color, transparency)
        print("Background color:", color, transparency)
    end
})
```

只要有配置处于生效状态，颜色和透明度就会自动保存并恢复 —— 参见[配置与 Flag](/zh/features/config-and-flags)。
