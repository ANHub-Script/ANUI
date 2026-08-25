# Colorpicker

Picks a `Color3` — with optional transparency — through a full-featured picker dialog. The callback fires with the chosen color when the user applies it.

## Basic usage

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

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Colorpicker"` | Main label. Supports [rich-text tokens](/elements/#rich-text-in-title-desc). |
| `Desc` | `string` | `nil` | Optional description under the title. |
| `Locked` | `boolean` | `false` | Renders a lock overlay and blocks interaction. |
| `Default` | `Color3` | `Color3.new(1, 1, 1)` (white) | Initial color shown in the swatch. |
| `Transparency` | `number` | `nil` | Initial alpha. Providing any number enables the alpha slider and input in the picker. |
| `Callback` | `function` | `nil` | Runs on **Apply**. **Receives `(color: Color3, transparency: number)`.** |
| `Buttons` | `table` | `nil` | Inline buttons rendered in the row. |
| `TitleGradient` | `table` | `nil` | Gradient applied to the title text. |
| `DescGradient` | `table` | `nil` | Gradient applied to the description text. |
| `Flag` | `string` | `nil` | Config persistence key. See [Config & Flags](/features/config-and-flags). |

::: info The picker dialog
Clicking the swatch opens a dialog with:
- a **Saturation/Vibrance** map and a **Hue** slider,
- an optional **alpha** slider (shown only when `Transparency` is set),
- a **Hex** input (`#RRGGBB`) plus **R / G / B** inputs — and an **Alpha** input when transparency is enabled,
- **Cancel** and **Apply** buttons — the `Callback` fires on **Apply**.

When saved to a config, a colorpicker serializes its hex value plus its transparency.
:::

Colorpickers also inherit the [shared base](/elements/#shared-base) config and methods.

## Methods

### `Colorpicker:Update(color, transparency?)`

Sets the current color (and optional transparency), updating the swatch.

```lua
myColorpicker:Update(Color3.fromRGB(255, 0, 0))
myColorpicker:Update(Color3.fromRGB(255, 0, 0), 0.5)
```

### `Colorpicker:Set(color, transparency?)`

Alias for `:Update` — same arguments and behavior.

```lua
myColorpicker:Set(Color3.fromHex("#305dff"))
```

### `Colorpicker:Lock()` / `Colorpicker:Unlock()`

Locks or unlocks the colorpicker. A locked colorpicker shows an overlay and cannot be opened.

```lua
myColorpicker:Lock()
myColorpicker:Unlock()
```

### Base methods

Colorpickers also support `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` and `:Destroy` from the [shared base](/elements/#common-methods).

## Examples

### With transparency and a Flag

Setting `Transparency` (even to `0`) enables the alpha controls in the dialog. The callback then receives both the color and the transparency.

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

The color and transparency are saved and restored automatically once a config is active — see [Config & Flags](/features/config-and-flags).
