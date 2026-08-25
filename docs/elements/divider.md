# Divider

A thin separator that visually splits elements. On a Tab or Section it renders as a horizontal line; inside a [Group](/elements/group) it renders as a vertical line between the group's columns.

## Basic usage

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({ Title = "Save", Callback = function() end })
myTab:Divider()
myTab:Button({ Title = "Load", Callback = function() end })
```

## Configuration

`Divider` takes no configuration — call `Tab:Divider()` with no arguments.

::: info Vertical inside a Group
Because a [Group](/elements/group) lays its children out horizontally, a Divider placed inside one is drawn as a **vertical** separator between columns rather than a horizontal line.
:::

## Examples

### Separating groups of controls

```lua
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })

myTab:Divider()

myTab:Button({ Title = "Reset", Callback = function() end })
```

### Vertical divider between columns

```lua
local row = myTab:Group({})
row:Button({ Title = "Accept", Callback = function() end })
row:Divider()
row:Button({ Title = "Decline", Callback = function() end })
```

::: info
A Divider is purely decorative — it is not an interactive element, so it exposes no configuration or methods.
:::
