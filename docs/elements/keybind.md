# Keybind

Binds an action to a keyboard key or mouse button. The callback fires globally whenever the bound key is pressed, so a keybind works anywhere in the game — not just while the window is open.

## Basic usage

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Keybind({
    Title = "Keybind",
    Value = "F",
    Callback = function(key)
        print("Pressed:", key)
    end
})
```

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Keybind"` | Main label. Supports [rich-text tokens](/elements/#rich-text-in-title-desc). |
| `Desc` | `string` | `nil` | Optional description under the title. |
| `Locked` | `boolean` | `false` | Renders a lock overlay and blocks interaction. |
| `Value` | `string` | `"F"` | Initial key, given as a **key name** string (e.g. `"F"`, `"G"`). |
| `CanChange` | `boolean` | `true` | Whether the user can rebind the key by clicking. Effectively always enabled in the current build. |
| `Callback` | `function` | `nil` | Runs when the bound key is pressed. **Receives the key name as a string.** |
| `Buttons` | `table` | `nil` | Inline buttons rendered in the row. |
| `TitleGradient` | `table` | `nil` | Gradient applied to the title text. |
| `DescGradient` | `table` | `nil` | Gradient applied to the description text. |
| `Flag` | `string` | `nil` | Config persistence key. See [Config & Flags](/features/config-and-flags). |

::: info How it fires and rebinds
- The callback fires **globally** whenever the bound key is pressed — it is suppressed only while a TextBox is focused, so typing doesn't trigger keybinds.
- The callback argument is the key **name** string: `Enum.KeyCode.F` reports `"F"`, and mouse buttons report `"MouseLeft"` or `"MouseRight"`.
- **To rebind:** click the keybind. It shows `...` and captures the next key you press.
:::

Keybinds also inherit the [shared base](/elements/#shared-base) config and methods.

## Methods

### `Keybind:Set(value)`

Sets the bound key by its name string.

```lua
myKeybind:Set("G")
```

### `Keybind:Lock()` / `Keybind:Unlock()`

Locks or unlocks the keybind. A locked keybind shows an overlay and cannot be rebound.

```lua
myKeybind:Lock()
myKeybind:Unlock()
```

### Base methods

Keybinds also support `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` and `:Destroy` from the [shared base](/elements/#common-methods).

## Examples

### Rebinding the window's toggle key

Because the callback gives you a key name, you can convert it back to an `Enum.KeyCode` with `Enum.KeyCode[key]` and feed it straight into `Window:SetToggleKey`.

```lua
myTab:Keybind({
    Flag = "KeybindTest",
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})
```

::: tip Persisting the binding
Add a `Flag` to save and restore the bound key across sessions. See [Config & Flags](/features/config-and-flags).
:::
