# Paragraph

A rich text block for headings, notes and descriptions. It is built on the [shared base](/elements/#shared-base) with hover disabled, so it reads as static content — and it doubles as a lightweight container you can attach child elements to.

## Basic usage

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Paragraph({
    Title = "Toggle Examples",
    Desc = "This tab showcases all supported Toggle features: classic toggle, checkbox variant, per-item icons, default values, locking, and programmatic updates."
})
```

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Paragraph"` | Heading text. Supports [rich-text tokens](/elements/#rich-text-in-title-desc). |
| `Desc` | `string` | `nil` | Body text. Supports rich-text tokens and multi-line via `\n`. |
| `Locked` | `boolean` | `false` | Renders a lock overlay. |
| `Images` | `table` | `nil` | Array of card objects rendered as an image-card grid (see below). |
| `ImageSize` | `UDim2` | `UDim2.fromOffset(70, 70)` | Size of each image card. |
| `Buttons` | `table` | `nil` | Array of `{ Title, Icon, Callback }` rendered as **stacked full-width buttons** below the text. |

### Image card objects

Each entry in `Images` is a table:

| Field | Type | Description |
| --- | --- | --- |
| `Title` | `string` | The card's label. |
| `Quantity` | `string` | A quantity/count badge (e.g. `"244x"`). |
| `Image` | `string` | Asset id (`rbxassetid://…`) or icon name. |
| `Gradient` | `ColorSequence` | Background gradient for the card. |
| `Callback` | `function` | Runs when the card is clicked. |

::: info Two kinds of `Buttons`
The `Buttons` config here renders **stacked, full-width** buttons beneath the paragraph text (each `{ Title, Icon, Callback }`). This is distinct from the shared-base inline `Buttons` **map** that other elements render inside their row.
:::

Paragraphs inherit `Image`, gradients, rich-text tokens, lock and highlight from the [shared base](/elements/#shared-base). Hover is always disabled.

## Methods

### `Paragraph:SetTitle(text)` / `Paragraph:SetDesc(text)`

Update the paragraph's stored `Title` / `Desc` fields.

```lua
myParagraph:SetTitle("Updated heading")
myParagraph:SetDesc("Updated body text.")
```

::: details Updating the visible text
`:SetTitle` / `:SetDesc` update the element's Lua fields. To change the text already on screen, use the underlying ParagraphFrame's own setters.
:::

### `Paragraph:SetViewport(model, cameraOffset?)`

Renders a 95×95 `ViewportFrame` showing a 3D preview of `model`, with an optional `cameraOffset`.

```lua
myParagraph:SetViewport(workspace.SomeModel)
```

## Examples

### Multi-line description

Use `\n` to break the description across lines.

```lua
myTab:Paragraph({
    Title = "Rank Information",
    Desc = "Current Rank: S-Class\nPower: 500,000"
})
```

### As a lightweight container

A Paragraph object exposes the same element-creation methods as a Tab, so you can attach children directly to it — handy for grouping controls under a heading.

```lua
local group = myTab:Paragraph({
    Title = "Yen Upgrades",
    Desc = "Upgrade stats using Yen currency"
})

group:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" })
group:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" })
group:Button({ Title = "Rank Up", Icon = "arrow-up-circle" })
```

### Image-card grid

```lua
myTab:Paragraph({
    Title = "Inventory",
    ImageSize = UDim2.fromOffset(70, 70),
    Images = {
        {
            Title = "World Box",
            Quantity = "244x",
            Image = "rbxassetid://84366761557806",
            Gradient = ColorSequence.new(Color3.fromHex("#C042FF"), Color3.fromHex("#8E24AA")),
            Callback = function() print("World Box") end
        },
        {
            Title = "Zone Key",
            Quantity = "3x",
            Image = "key",
            Gradient = ColorSequence.new(Color3.fromHex("#29B6F6"), Color3.fromHex("#0288D1")),
            Callback = function() print("Zone Key") end
        },
    }
})
```

### Stacked buttons

```lua
myTab:Paragraph({
    Title = "ANHUB Discord",
    Desc = "Members: 1,234\nOnline: 567",
    Buttons = {
        {
            Title = "Copy link",
            Icon = "link",
            Callback = function()
                setclipboard("https://discord.gg/qN47S3mKZA")
            end
        }
    }
})
```
