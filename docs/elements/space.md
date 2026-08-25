# Space

An invisible vertical spacer used to add breathing room between elements. It renders nothing — it only reserves height.

## Basic usage

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Space()
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })
```

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Columns` | `number` | `1` | Height multiplier. The spacer's height is `7 × Columns` pixels. |

::: info Height
The height is computed as `7 * Columns` pixels — the default `Columns = 1` reserves 7px, `Columns = 2` reserves 14px, and so on.
:::

## Examples

### Larger gap

```lua
myTab:Space({ Columns = 2 }) -- 14px of vertical space
```

### Spacing a stack of elements

A `Space()` between each control is the common way to keep a long list from feeling cramped.

```lua
myTab:Toggle({ Title = "Basic Toggle", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Toggle with Description", Desc = "Extra detail", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Checkbox", Type = "Checkbox", Callback = function(v) end })
```

::: info
A Space is not interactive, so it exposes no methods — adjust its size with the `Columns` field when you create it.
:::
