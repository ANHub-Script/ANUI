# Themes

ANUI ships with 26 built-in themes and lets you register your own. You choose a theme when the window is created, switch it at runtime, read the active one, and react to changes — all through top-level `ANUI` methods.

## Set a theme at creation

Pass a theme key to `CreateWindow` with the `Theme` field. It defaults to `"Dark"`.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Theme = "Midnight", -- any built-in key, or a custom theme name
})
```

See [Window Configuration](/guide/window-configuration) for the rest of the window options.

## Switch themes at runtime

### `ANUI:SetTheme(name)`

Applies a theme by its key and returns the theme table, or `nil` when the key is unknown.

```lua
if not ANUI:SetTheme("Emerald") then
    warn("Unknown theme key")
end
```

## Read the active theme

### `ANUI:GetCurrentTheme()`

Returns the **display name** of the active theme (for example `"Monokai Pro"`, not the `MonokaiPro` key).

```lua
print(ANUI:GetCurrentTheme()) --> "Midnight"
```

### `ANUI:GetThemes()`

Returns the table of every registered theme, keyed by theme key — including any you add with `AddTheme`.

```lua
for key, theme in pairs(ANUI:GetThemes()) do
    print(key, "->", theme.Name)
end
```

## React to theme changes

### `ANUI:OnThemeChange(callback)`

Registers a handler that runs whenever `SetTheme` applies a theme. The callback receives **one argument: the theme key** that was applied — the same string you passed to `SetTheme` (e.g. `"Dark"`).

```lua
ANUI:OnThemeChange(function(themeKey)
    print("Theme changed to:", themeKey)
end)
```

::: info Only one handler
`OnThemeChange` stores a single handler — calling it again replaces the previous one. Register one function and branch inside it if several parts of your script need to react.
:::

## Built-in themes

Pass the **key** to `Theme` / `SetTheme`. The display name (what `GetCurrentTheme` returns) only differs from the key for a handful of themes.

| Key | Display name |
| --- | --- |
| `Dark` | Dark *(default)* |
| `Light` | Light |
| `Rose` | Rose |
| `Plant` | Plant |
| `Red` | Red |
| `Indigo` | Indigo |
| `Sky` | Sky |
| `Violet` | Violet |
| `Amber` | Amber |
| `Emerald` | Emerald |
| `Midnight` | Midnight |
| `Crimson` | Crimson |
| `MonokaiPro` | Monokai Pro |
| `CottonCandy` | Cotton Candy |
| `Rainbow` | Rainbow |
| `NordTheme` | Nord |
| `DraculaTheme` | Dracula |
| `TokyoNight` | Tokyo Night |
| `OneDark` | One Dark |
| `Gruvbox` | Gruvbox |
| `SolarizedDark` | Solarized Dark |
| `MaterialDark` | Material Dark |
| `CyberpunkPink` | Cyberpunk Pink |
| `OceanBlue` | Ocean Blue |
| `NeonGreen` | Neon Green |
| `SoftPastel` | Soft Pastel |

## Custom themes

### `ANUI:AddTheme(theme)`

Registers a theme, keyed by its `Name`, and returns it. After adding it, apply it with `SetTheme(name)`.

A theme is a table of color keys. Nine are required; `Toggle` and `Checkbox` are optional. Every color is a `Color3` — usually built with `Color3.fromHex("#…")`.

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | `string` | — | Unique theme name. This is the key you pass to `SetTheme`. |
| `Accent` | `Color3` | — | Primary accent / panel color. |
| `Dialog` | `Color3` | — | Dialog and popup background. |
| `Outline` | `Color3` | — | Border / stroke color. |
| `Text` | `Color3` | — | Primary text color. |
| `Placeholder` | `Color3` | — | Muted / placeholder text color. |
| `Background` | `Color3` | — | Window background color. |
| `Button` | `Color3` | — | Button background color. |
| `Icon` | `Color3` | — | Icon tint color. |
| `Toggle` | `Color3` | *(optional)* | Toggle "on" color. |
| `Checkbox` | `Color3` | *(optional)* | Checkbox "checked" color. |

```lua
ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
    Toggle      = Color3.fromHex("#22d3ee"),
    Checkbox    = Color3.fromHex("#0ea5e9"),
})

ANUI:SetTheme("Oceanic")
```

::: tip
A theme you add with `AddTheme` immediately shows up in `GetThemes()` and can be selected like any built-in theme.
:::

## Gradients

### `ANUI:Gradient(stops, props)`

Builds a gradient data table from a set of color stops. `stops` is keyed by **position strings** from `"0"` to `"100"` (percent along the gradient); each stop is `{ Color = Color3, Transparency = number }` — `Transparency` is optional and defaults to `0`. `props` is an optional table merged into the result, for example `{ Rotation = 45 }`.

```lua
local sunset = ANUI:Gradient({
    ["0"]   = { Color = Color3.fromHex("#40c9ff") },
    ["50"]  = { Color = Color3.fromHex("#8b5cf6") },
    ["100"] = { Color = Color3.fromHex("#e81cff") },
}, {
    Rotation = 45,
})
```

::: warning At least two stops
A gradient needs **two or more** stops. Passing fewer raises an error.
:::

Gradients slot into anywhere the library accepts gradient data — most commonly the `TitleGradient` and `DescGradient` fields on elements:

```lua
myTab:Button({
    Title = "Gradient Title",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Callback = function() end,
})
```

They can even drive theme colors — the built-in `Rainbow` theme is defined with gradients instead of flat `Color3` values.

## Acrylic blur

### `ANUI:ToggleAcrylic(enabled)`

Turns the acrylic blur behind the window on or off. This only has an effect when the window was created with `Acrylic = true`; otherwise it is a no-op.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Acrylic = true,
})

ANUI:ToggleAcrylic(true)  -- enable blur
ANUI:ToggleAcrylic(false) -- disable blur
```

## Font

### `ANUI:SetFont(fontId)`

Sets the global font used across the whole UI.

```lua
ANUI:SetFont("rbxassetid://12898095208")
```

## Full example

Register a custom theme, apply it, expose a theme switcher, and log every change.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
})

local Window = ANUI:CreateWindow({
    Title = "Theme Demo",
    Theme = "Oceanic",
    Acrylic = true,
})

local Tab = Window:Tab({ Title = "Appearance", Icon = "palette" })

Tab:Paragraph({
    Title = "Theme switcher",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Desc = "Pick a theme below.",
})

Tab:Dropdown({
    Title = "Theme",
    Values = { "Dark", "Light", "Midnight", "Oceanic" },
    Value = "Oceanic",
    Callback = function(name)
        ANUI:SetTheme(name)
    end,
})

ANUI:OnThemeChange(function(themeKey)
    print("Active theme key:", themeKey)
    print("Display name:", ANUI:GetCurrentTheme())
end)
```
