# Group

A container that lays its children out **horizontally** instead of stacking them vertically. Interactive elements share the available width equally, while a [Space](/elements/space) or [Divider](/elements/divider) keeps its fixed width. Like a Tab, a Group exposes every element-creation method.

## Basic usage

Create a group with `Tab:Group({})`, then add elements to the returned container:

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local row = myTab:Group({})
row:Button({ Title = "Save", Callback = function() end })
row:Button({ Title = "Load", Callback = function() end })
```

The two buttons appear side by side, each taking half the row.

## Configuration

`Group` takes no configuration — call `Tab:Group({})` with an empty table.

## Creating elements in a group

A Group is a container, so every element-creation method (`Group:Button`, `Group:Toggle`, `Group:Dropdown`, …) works on it exactly like on a Tab — see the [Elements overview](/elements/). Each interactive child is given an equal share of the row's width; `Space` and `Divider` children keep their fixed width instead of stretching.

::: tip
Groups pair well with a [Paragraph](/elements/paragraph) label placed just above them — use the paragraph as a heading that describes the row of controls beneath it.
:::

## Examples

### A row of buttons

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

### Two dropdowns side by side

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

### Two sliders side by side

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
A Group is a layout container, so it inherits none of the interactive shared-base behaviors — those belong to the elements you place inside it.
:::
