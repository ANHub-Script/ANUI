# Section

A collapsible container placed inside a tab. Like a Tab, a Section exposes every element-creation method, so you add child elements to it and they appear grouped under a header that expands and collapses.

::: info Two different "Section" concepts
This page documents the **content element** `Tab:Section({...})` — a collapsible container placed *inside* a tab.

It is unrelated to `Window:Section({ Title = ... })`, which creates a **sidebar section header** that groups tabs. For that one, see [Tabs & Sections](/guide/tabs-and-sections).
:::

## Basic usage

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local combat = myTab:Section({ Title = "Combat" })

combat:Toggle({ Title = "God Mode", Callback = function(state) end })
combat:Button({ Title = "Kill Aura", Callback = function() end })
```

::: tip
A Section only becomes expandable once it has at least one child element — an empty Section has no content to collapse.
:::

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Section"` | Header label. Supports [rich-text tokens](/elements/#rich-text-in-title-desc), including inline `{icon}` tokens. |
| `Icon` | `string` | `nil` | Header icon: a Lucide name or `rbxassetid://…`. |
| `Image` | `string` | `nil` | Header image asset (alternative to `Icon`). |
| `IconSize` | `number` | `20` | Header icon size, in pixels. |
| `IconThemed` | `boolean` | `false` | Tint the icon with the current theme color. |
| `InlineIcon` | `boolean` | `true` | Render the icon inline with the title text. |
| `TextSize` | `number` | `19` | Header title text size. |
| `TextXAlignment` | `string` | `"Left"` | Horizontal alignment of the header title. |
| `TextTransparency` | `number` | `0.05` | Header title text transparency. |
| `FontWeight` | `Enum.FontWeight` \| `string` | `SemiBold` | Font weight of the header title. |
| `Box` | `boolean` | `false` | Wrap the section in an outlined box. |
| `Opened` | `boolean` | `false` | Start expanded instead of collapsed. |
| `HeaderSize` | `number` | `42` | Height of the header row, in pixels. |
| `HeaderPadding` | `number` | `8` | Inner padding of the header row. |
| `ChevronSize` | `number` | `20` | Size of the expand/collapse chevron. |

## Methods

Every element-creation method (`Section:Button`, `Section:Toggle`, `Section:Slider`, …) is available on a Section, exactly like on a Tab — see the [Elements overview](/elements/). The Section-specific methods are below.

### `Section:SetTitle(text)`

Updates the header label.

```lua
combat:SetTitle("Combat (active)")
```

### `Section:SetIcon(icon)`

Sets the header icon (Lucide name or `rbxassetid://…`).

```lua
combat:SetIcon("swords")
```

### `Section:SetIconSize(size)`

Sets the header icon size, in pixels.

```lua
combat:SetIconSize(24)
```

### `Section:GetIcon()`

Returns the current header icon.

```lua
print(combat:GetIcon())
```

### `Section:Open()` / `Section:Close()`

Expands or collapses the section.

```lua
combat:Open()
combat:Close()
```

### `Section:Destroy()`

Removes the section and its child elements.

```lua
combat:Destroy()
```

## Examples

### Icon, token title, and open by default

```lua
local stats = myTab:Section({
    Title = "{swords} Combat Stats",
    Icon = "swords",
    Opened = true,
})

stats:Slider({ Title = "Damage", Value = { Min = 0, Max = 100, Default = 50 } })
stats:Toggle({ Title = "Auto Attack", Callback = function(state) end })
```

### Expand and collapse from code

```lua
local advanced = myTab:Section({ Title = "Advanced" })
advanced:Toggle({ Title = "Verbose Logging" })

advanced:Open()  -- expand
advanced:Close() -- collapse
```

::: info
Because a Section is a container, it inherits none of the interactive shared-base behaviors (locking, highlighting, and so on) — those belong to the elements you place *inside* it.
:::
