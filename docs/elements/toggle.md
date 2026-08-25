# Toggle

An on/off switch that reports a boolean to its callback. Toggles render as an animated slider by default, or as a checkbox via `Type = "Checkbox"`.

## Basic usage

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

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Toggle"` | Main label. Supports [rich-text tokens](/elements/#rich-text-in-title-desc). |
| `Desc` | `string` | `nil` | Optional description under the title. |
| `Value` | `boolean` | `false` | Initial state. |
| `Type` | `string` | `"Toggle"` | `"Toggle"` (animated slider) or `"Checkbox"`. |
| `Icon` | `string` | `nil` | Icon shown inside the slider knob. |
| `IconSize` | `number` | `23` | Size of the knob icon, in pixels. |
| `Image` | `string` \| `table` | `nil` | Left-aligned image (asset id or card table). |
| `ImageSize` | `number` | `30` | Size of the left image, in pixels. |
| `Thumbnail` | `string` | `nil` | Large thumbnail image. |
| `ThumbnailSize` | `number` | `80` | Thumbnail size, in pixels. |
| `Locked` | `boolean` | `false` | Lock overlay; blocks interaction **and** disables the callback. |
| `Disabled` | `boolean` | `false` | Blocks user interaction only (callback still fires from code). |
| `Callback` | `function` | `nil` | Runs on change. **Receives the new boolean value.** |
| `Flag` | `string` | `nil` | Config persistence key. See [Config & Flags](/features/config-and-flags). |
| `Buttons` | `table` | `nil` | Inline buttons rendered in the row. |
| `TitleGradient` | `table` | `nil` | Gradient applied to the title text. |
| `DescGradient` | `table` | `nil` | Gradient applied to the description text. |

::: info Locked vs Disabled
`Locked` shows a lock overlay, blocks user interaction **and** prevents the callback from firing. `Disabled` only blocks *user* interaction — you can still change the value from code with `:Set(...)`, and the callback runs. Use `:Lock()`/`:Unlock()` and `:Disable()`/`:Enable()` to switch these states at runtime.
:::

Toggles also inherit the [shared base](/elements/#shared-base) config and methods.

## Methods

### `Toggle:Set(value, isCallback?, isAnimated?, force?)`

Sets the toggle state programmatically.

- `value` (`boolean`) — the new state.
- `isCallback` (`boolean`, optional) — fire the `Callback` for this change.
- `isAnimated` (`boolean`, optional) — animate the knob transition.
- `force` (`boolean`, optional) — force the change through.

```lua
myToggle:Set(true, true)         -- turn on and fire the callback
myToggle:Set(false, false, false) -- turn off silently, no animation
```

### `Toggle:Lock(text?)` / `Toggle:Unlock()`

Locks or unlocks the toggle. An optional `text` sets the overlay label.

```lua
myToggle:Lock("Premium only")
myToggle:Unlock()
```

### `Toggle:Disable()` / `Toggle:Enable()`

Disables or re-enables *user* interaction without a lock overlay. Unlike `Lock`, the callback still fires when you set the value from code.

### `Toggle:SetMainImage(image, size)`

Updates the left-aligned image and its size.

```lua
myToggle:SetMainImage("rbxassetid://84366761557806", 24)
```

### Base methods

Toggles also support `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` and `:Destroy` from the [shared base](/elements/#common-methods).

## Examples

### Basic and with description

```lua
myTab:Toggle({
    Title = "Basic Toggle",
    Desc = "Standard toggle with animated slider (drag or click).",
    Callback = function(v)
        print("Basic Toggle:", v)
    end
})
```

### With a left image

```lua
myTab:Toggle({
    Title = "Toggle with Left Image",
    Desc = "Image on the left, centered between title and desc.",
    Image = "rbxassetid://84366761557806",
    ImageSize = 24,
    Callback = function(v) print(v) end
})
```

### With a knob icon and default-on

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

### Checkbox variant

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

### Locked

```lua
myTab:Toggle({
    Title = "Locked Toggle",
    Desc = "Locked state prevents user interaction.",
    Locked = true,
    Callback = function(v) print(v) end
})
```

### Programmatic update

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

### Persisting with a Flag

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(v) print(v) end
})
```

The value is saved and restored automatically once a config is active — see [Config & Flags](/features/config-and-flags).
