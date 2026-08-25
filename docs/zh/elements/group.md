# Group

一个将其子元素**横向**排列而不是纵向堆叠的容器。交互式元素会均分可用宽度，而 [Space](/zh/elements/space) 或 [Divider](/zh/elements/divider) 会保持其固定宽度。与 Tab 一样，Group 提供全部元素创建方法。

## 基本用法

用 `Tab:Group({})` 创建一个分组，然后向返回的容器中添加元素：

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local row = myTab:Group({})
row:Button({ Title = "Save", Callback = function() end })
row:Button({ Title = "Load", Callback = function() end })
```

两个按钮会并排显示，各占该行的一半。

## 配置

`Group` 不接受任何配置——调用 `Tab:Group({})` 并传入一个空表即可。

## 在分组中创建元素

Group 是一个容器，因此每个元素创建方法（`Group:Button`、`Group:Toggle`、`Group:Dropdown`……）在它上面的用法与在 Tab 上完全一样——参见[元素概览](/zh/elements/)。每个交互式子元素都会获得该行宽度的等分份额；`Space` 和 `Divider` 子元素则保持其固定宽度而不会拉伸。

::: tip
Group 与紧贴其上方放置的 [Paragraph](/zh/elements/paragraph) 标签搭配得很好——用该段落作为标题来说明下方的这一排控件。
:::

## 示例

### 一排按钮

```lua
local buttons = myTab:Group({})
buttons:Button({
    Title = "Primary",
    Color = Color3.fromHex("#305dff"),
    Icon = "mouse-pointer-click",
    Callback = function() end,
})
buttons:Button({ Title = "Secondary", Icon = "mouse", Callback = function() end })
buttons:Button({ Title = "Locked", Icon = "lock", Locked = true, Callback = function() end })
```

### 两个并排的下拉菜单

```lua
myTab:Paragraph({ Title = "Dropdowns Group", Desc = "Two dropdowns grouped." })

local dropdowns = myTab:Group({})
dropdowns:Dropdown({
    Title = "Dropdown 1",
    Values = { "A", "B", "C" },
    Value = "A",
    Callback = function(v) print("Dropdown 1:", v) end,
})
dropdowns:Dropdown({
    Title = "Dropdown 2",
    Values = { { Title = "X", Desc = "First" }, { Title = "Y" }, { Title = "Z" } },
    SearchBarEnabled = true,
    Value = "Y",
    Callback = function(v) print("Dropdown 2:", v) end,
})
```

### 两个并排的滑块

```lua
myTab:Paragraph({ Title = "Sliders Group", Desc = "Two sliders grouped." })

local sliders = myTab:Group({})
sliders:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(v) print("Volume:", v) end,
})
sliders:Slider({
    Title = "Brightness",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(v) print("Brightness:", v) end,
})
```

::: info
Group 是一个布局容器，因此它不会继承任何交互式的 shared-base 行为——这些行为属于你放置在其内部的元素。
:::
