# Button

A clickable action row with an optional icon, color and inline buttons. Buttons are the simplest interactive element — they run a callback when clicked.

## Basic usage

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({
    Title = "Click me",
    Callback = function()
        print("Button clicked!")
    end
})
```

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Button"` | Main label. Supports [rich-text tokens](/elements/#rich-text-in-title-desc). |
| `Desc` | `string` | `nil` | Optional description under the title. |
| `Icon` | `string` | `"mouse-pointer-click"` | Icon name or `rbxassetid://…`. |
| `IconThemed` | `boolean` | `false` | Tint the icon with the current theme color. |
| `Color` | `Color3` \| `string` | `nil` | Colored background (theme name or `Color3`); text auto-contrasts. |
| `Justify` | `string` | `"Between"` | Content alignment. `"Between"` spreads title and icon apart; `"Center"` centers them. |
| `IconAlign` | `string` | `"Right"` | Which side the icon sits on: `"Right"` or `"Left"`. |
| `Locked` | `boolean` | `false` | Renders a lock overlay and blocks clicks. |
| `Callback` | `function` | `nil` | Runs when the button is clicked. **Receives no arguments.** |
| `Buttons` | `table` | `nil` | Inline buttons rendered in the row. |
| `TitleGradient` | `table` | `nil` | Gradient applied to the title text. |
| `DescGradient` | `table` | `nil` | Gradient applied to the description text. |

::: info Callback signature
A Button's `Callback` receives **no arguments** — it is a plain action handler. If you need to react to a value, use a [Toggle](/elements/toggle) or [Dropdown](/elements/dropdown) instead.
:::

Buttons also inherit the [shared base](/elements/#shared-base) config (`Image`, `Thumbnail`, gradients, rich-text tokens in `Title`/`Desc`, and so on).

## Methods

### `Button:Highlight()`

Briefly flashes the button to draw the user's attention.

```lua
local btn = myTab:Button({ Title = "Notice me", Callback = function() end })
btn:Highlight()
```

### `Button:Lock()` / `Button:Unlock()`

Locks or unlocks the button. A locked button shows an overlay and ignores clicks.

```lua
btn:Lock()
btn:Unlock()
```

### `Button:SetTitle(text)` / `Button:SetDesc(text)` / `Button:SetIcon(icon)`

Update the title, description or icon at runtime.

```lua
btn:SetTitle("Updated title")
btn:SetDesc("Updated description")
btn:SetIcon("check")
```

### `Button:SetButtons(buttons)` / `Button:GetButton(key)` / `Button:GetButtons()`

Manage the inline buttons rendered in the row. `SetButtons` replaces the map, `GetButton` fetches one by key, and `GetButtons` returns them all.

### `Button:Destroy()`

Removes the button from its container.

## Examples

### Basic and colored

```lua
myTab:Button({
    Title = "Highlight Button",
    Icon = "mouse",
    Callback = function()
        print("clicked highlight")
    end
})

myTab:Button({
    Title = "Blue Button",
    Desc = "With description",
    Color = Color3.fromHex("#305dff"),
    Icon = "",
    Callback = function() end
})
```

### Icon alignment and justification

```lua
myTab:Button({
    Title = "Left Icon",
    Desc = "Icon aligned to the left",
    Icon = "mouse",
    IconAlign = "Left",
    Justify = "Center",
    Callback = function() end
})
```

### Themed and colored icons

```lua
myTab:Button({
    Title = "Themed Icon",
    Desc = "Icon follows theme colors",
    Icon = "palette",
    IconThemed = true,
    Callback = function() end
})

myTab:Button({
    Title = "Colored Icon",
    Desc = "Icon tinted with custom color",
    Icon = "mouse-pointer-click",
    Color = Color3.fromHex("#f57c00"),
    Callback = function() end
})
```

### Locked

```lua
myTab:Button({
    Title = "Button",
    Desc = "Button example",
    Locked = true
})
```

### Programmatic update

Keep the returned module and update it from another button. `Highlight()` draws attention to the change.

```lua
local progBtn = myTab:Button({
    Title = "Programmatic Button",
    Desc = "Will be updated by code",
    Icon = "edit",
    Callback = function() end
})

myTab:Button({
    Title = "Update Above",
    Desc = "SetTitle and SetDesc",
    Icon = "chevron-right",
    Callback = function()
        progBtn:SetTitle("Programmatic Button (Updated)")
        progBtn:SetDesc("Updated by code")
        progBtn:Highlight()
    end
})
```

### UI button variants via a Dialog

The buttons inside a `Window:Dialog` support `Variant` styling — `"Primary"`, `"Secondary"` and `"White"`.

```lua
myTab:Button({
    Title = "Show UI Button Variants",
    Desc = "Opens dialog with Primary/Secondary/White",
    Icon = "square-menu",
    Callback = function()
        Window:Dialog({
            Title = "UI Button Variants",
            Content = "Demonstrates button variants.",
            Buttons = {
                { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
                { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
                { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
            }
        })
    end
})
```

::: tip
Set `Icon = ""` to render a button with no icon at all — useful for centered, text-only action buttons.
:::
