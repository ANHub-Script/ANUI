# Slider

A draggable numeric slider with optional stepping and manual text entry. The value can be bounded, stepped, and formatted as an integer or a float.

## Basic usage

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

## Configuration

You can define the range either with a `Value` table or with the flat `Min` / `Max` / `Default` fields.

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Slider"` | Main label. Supports [rich-text tokens](/elements/#rich-text-in-title-desc). |
| `Desc` | `string` | `nil` | Optional description under the title. |
| `Value` | `table` | `nil` | Range table `{ Min, Max, Default }`. Alternative to the fields below. |
| `Min` | `number` | `0` | Lower bound (when not using `Value`). |
| `Max` | `number` | `100` | Upper bound (when not using `Value`). |
| `Default` | `number` | `0` | Starting value (when not using `Value`). |
| `Step` | `number` | `1` | Increment between stops. A **fractional** step (e.g. `0.1`) switches the slider to float mode. |
| `Locked` | `boolean` | `false` | Renders a lock overlay and blocks interaction. |
| `Callback` | `function` | `nil` | Runs on change. **Receives a formatted string** (see below). |
| `Flag` | `string` | `nil` | Config persistence key. See [Config & Flags](/features/config-and-flags). |
| `Buttons` | `table` | `nil` | Inline buttons rendered in the row. |
| `TitleGradient` | `table` | `nil` | Gradient applied to the title text. |
| `DescGradient` | `table` | `nil` | Gradient applied to the description text. |

::: warning The callback argument is a string
The value passed to `Callback` is a **formatted string**, not a number. Integer sliders receive a floored whole number (`"50"`); float sliders (fractional `Step`) receive a `"%.2f"` string (`"0.50"`). Convert it with `tonumber(value)` before doing any math.
:::

Sliders also inherit the [shared base](/elements/#shared-base) config and methods.

## Value formatting & snapping

- **Snapping** — the raw position snaps to the nearest step: `floor(raw / Step + 0.5) * Step`.
- **Integer vs float** — an integer `Step` floors the value to a whole number; a fractional `Step` formats it with `"%.2f"`.
- **Manual entry** — the value is also a text field. Click it, type a number, and press **Enter** to commit.
- **Persistence** — when a `Flag` is set, the config stores `Value.Default` as the formatted string.

## Methods

### `Slider:Set(value, input?)`

Sets the slider value programmatically. `value` is a number within the range; `input?` is an optional flag used when the change originates from the manual text field.

```lua
mySlider:Set(75)
```

### `Slider:SetMin(n)`

Updates the lower bound of the slider.

```lua
mySlider:SetMin(10)
```

### `Slider:SetMax(n)`

Updates the upper bound of the slider.

```lua
mySlider:SetMax(200)
```

### `Slider:Lock()` / `Slider:Unlock()`

Locks or unlocks the slider.

```lua
mySlider:Lock()
mySlider:Unlock()
```

## Examples

### Integer slider (Volume 0–100)

Remember to convert the string argument before using it as a number.

```lua
myTab:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        local n = tonumber(value) -- value is a string like "50"
        print("Volume:", n)
    end
})
```

### Float slider (fractional Step)

A `Step` of `0.1` puts the slider into float mode, so the callback receives values like `"0.50"`.

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

### Persisting with a Flag

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

### Programmatic control

```lua
local speed = myTab:Slider({
    Title = "Speed",
    Value = { Min = 0, Max = 100, Default = 20 },
    Callback = function(value) print(value) end
})

speed:Set(60)     -- move the handle to 60
speed:SetMax(150) -- widen the range
```
