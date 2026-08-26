# Dialogs & Popups

ANUI has two ways to show a modal prompt: **`Window:Dialog{}`**, which is attached to an existing window, and **`ANUI:Popup{}`**, a standalone modal you can open from anywhere. Both present a title, body, and a row of buttons.

## Dialog vs Popup

| | `Window:Dialog{}` | `ANUI:Popup{}` |
| --- | --- | --- |
| Attachment | Rendered inside an existing window | Standalone, screen-level modal |
| Needs a window | Yes — call it on a `Window` | No — call it on `ANUI` directly |
| Width control | `Width` (default `320`) | — |
| Thumbnail image | — | `Thumbnail` |
| Returned object | — | No methods; buttons close it |
| Best for | Confirmations tied to the menu you already built | Quick prompts before/without a full window |

## `Window:Dialog{}`

Opens a modal dialog anchored to the window. Use it for confirmations and small choices inside your menu.

### Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | Dialog heading. |
| `Content` | `string` | — | Body text under the title. |
| `Icon` | `string` | — | Leading icon: a Lucide icon name or `rbxassetid://…`. |
| `Width` | `number` | `320` | Dialog width in pixels. |
| `Buttons` | `table` | — | Array of button specs (see below). |

Each entry in `Buttons` is a table:

| Field | Type | Description |
| --- | --- | --- |
| `Title` | `string` | Button label. |
| `Icon` | `string` | Optional icon on the button. |
| `Callback` | `function` | Runs when the button is clicked. **Receives no arguments.** |
| `Variant` | `string` | Visual style: `"Primary"`, `"Secondary"`, or `"White"`. |

```lua
Window:Dialog({
    Title = "Delete save?",
    Content = "This cannot be undone.",
    Buttons = {
        { Title = "Delete", Variant = "Primary", Icon = "trash", Callback = function()
            print("deleted")
        end },
    },
})
```

## `ANUI:Popup{}`

Opens a standalone modal immediately, without needing a window. Its buttons close the popup when clicked, and the returned object exposes no methods.

### Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dialog"` | Popup heading. |
| `Content` | `string` | `nil` | Body text under the title. |
| `Icon` | `string` | `nil` | Leading icon: a Lucide icon name or `rbxassetid://…`. |
| `IconThemed` | `boolean` | — | Tint the icon with the theme's icon color. |
| `Thumbnail` | `table` | — | Large preview image: `{ Image, Title? }`. |
| `Buttons` | `table` | — | Array of button specs (same shape as Dialog). |

Each entry in `Buttons` is a table:

| Field | Type | Description |
| --- | --- | --- |
| `Title` | `string` | Button label. |
| `Icon` | `string` | Optional icon on the button. |
| `Callback` | `function` | Runs when clicked, then the popup closes. **Receives no arguments.** |
| `Variant` | `string` | Visual style: `"Primary"`, `"Secondary"`, or `"White"`. |

::: info Popup opens immediately
`ANUI:Popup{}` shows the modal as soon as it is called. There is nothing to `:Open()` — and no methods on the returned object, since the buttons dismiss it for you.
:::

## Examples

### Button variants (Dialog)

The three button variants — `Primary`, `Secondary`, and `White` — in one dialog.

```lua
Window:Dialog({
    Title = "UI Button Variants",
    Content = "Demonstrates the Button variants.",
    Buttons = {
        { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
        { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
        { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
    },
})
```

### A confirm dialog (Cancel / Confirm)

```lua
Window:Dialog({
    Title = "Reset settings?",
    Content = "All options will return to their defaults.",
    Icon = "rotate-ccw",
    Width = 340,
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function()
            print("cancelled")
        end },
        { Title = "Confirm", Variant = "Primary", Icon = "check", Callback = function()
            print("confirmed")
        end },
    },
})
```

### A simple popup

```lua
ANUI:Popup({
    Title = "Welcome",
    Content = "Thanks for trying the script. Join our community for updates.",
    Icon = "hand",
    Thumbnail = {
        Image = "rbxassetid://84366761557806",
        Title = "ANHub",
    },
    Buttons = {
        { Title = "Copy Discord", Variant = "Primary", Icon = "link", Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
        end },
        { Title = "Close", Variant = "Secondary", Callback = function() end },
    },
})
```
