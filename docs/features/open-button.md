# Open Button

The open button is the floating pill that reopens your UI after it has been closed. Configure it when you create the window, or edit it later at runtime.

## Configure at creation

Pass an `OpenButton` table to `CreateWindow`.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | Text shown on the button. |
| `Icon` | `string` | — | Icon name or `rbxassetid://…` shown before the title. |
| `Enabled` | `boolean` | — | Set `false` to disable the open button entirely. |
| `Position` | `UDim2` | — | Where the button sits on screen. |
| `OnlyIcon` | `boolean` | `false` | Icon-only round button (Delta-style); hides the title and drag handle. |
| `Draggable` | `boolean` | — | Allow the user to drag the button around. |
| `OnlyMobile` | `boolean` | — | Leave unset for mobile-only; set `false` to also show it on desktop. |
| `CornerRadius` | `UDim` | `UDim.new(1, 0)` | Corner radius of the button (default is fully rounded). |
| `StrokeThickness` | `number` | `2` | Thickness of the button's outline. |
| `Color` | `ColorSequence` | `#40c9ff → #e81cff` | Gradient of the button's outline stroke. |
| `Size` | `UDim2` | auto | Button size. Auto-sizes to its contents by default. |

::: info OnlyMobile default
If you don't set `OnlyMobile`, the button behaves as **mobile-only**. Set `OnlyMobile = false` to show it on desktop too — as the example above does.
:::

::: tip Color is a gradient
`Color` takes a `ColorSequence`, not a `Color3` — it is applied as a gradient to the button's outline. Build one with `ColorSequence.new(colorA, colorB)`.
:::

## Edit at runtime

### `Window:EditOpenButton(config)`

Applies changes to the open button. Edits **merge cumulatively** — fields you don't pass keep their current value.

```lua
Window:EditOpenButton({
    Title = "Open Menu",
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
})
```

## Open button methods

The open-button object is available as `Window.OpenButtonMain`.

### `Window.OpenButtonMain:SetIcon(icon)`

Swaps the button's icon (icon name or `rbxassetid://…`).

```lua
Window.OpenButtonMain:SetIcon("menu")
```

### `Window.OpenButtonMain:Visible(visible)`

Shows or hides the button.

```lua
Window.OpenButtonMain:Visible(false) -- hide
Window.OpenButtonMain:Visible(true)  -- show
```

### `Window.OpenButtonMain:Edit(config)`

The same as `Window:EditOpenButton` — merges the given config into the current one. Use whichever reads better in your code.

```lua
Window.OpenButtonMain:Edit({ Title = "Reopen" })
```

## Example

Adapted from the example script: a rounded, draggable pill with a custom title and a green-to-yellow gradient outline, shown on both desktop and mobile.

```lua
local Window = ANUI:CreateWindow({
    Title = ".an hub | ANUI Library",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

See [Window Configuration](/guide/window-configuration) for the rest of the window options.
