# Localization

ANUI has a built-in translation layer. You register translations per language, enable the system, and then any string that starts with the localization prefix (`loc:`) is looked up and replaced with the translation for the active language.

## Enable localization

### `ANUI:Localization(config)`

Registers your translation tables and turns the system on. Call it once, early — before or right after creating the window.

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Enabled` | `boolean` | `false` | Master switch. Must be `true` for translation to happen. |
| `Translations` | `table` | `{}` | Map of language code → `{ key = value }` translation table. |
| `Prefix` | `string` | `"loc:"` | The marker that flags a string for translation. |
| `DefaultLanguage` | `string` | `"en"` | Language used until you call `SetLanguage`. |

```lua
ANUI:Localization({
    Enabled = true,
    DefaultLanguage = "en",
    Translations = {
        en = {
            welcome = "Welcome!",
            settings = "Settings",
        },
        id = {
            welcome = "Selamat datang!",
            settings = "Pengaturan",
        },
    },
})
```

## Use translated strings

Prefix any title or label with `loc:` followed by a translation key. ANUI resolves it against the active language's table.

```lua
local Tab = Window:Tab({
    Title = "loc:settings", -- shows "Settings" (en) or "Pengaturan" (id)
    Icon = "settings",
})

Tab:Button({
    Title = "loc:welcome",
    Callback = function() end,
})
```

::: info How the prefix works
Only strings that **start with the prefix** (`loc:` by default) are translated — the text after the prefix is the lookup key. Every other string is shown exactly as written. If a key is missing from the active language, the string is shown literally, so nothing breaks.
:::

## Switch language at runtime

### `ANUI:SetLanguage(language)`

Switches the active language. Requires localization to be enabled — it returns `false` if you never called `Localization` with `Enabled = true`.

```lua
ANUI:SetLanguage("id") -- switch to Indonesian
```

## Full example

Enable English + Indonesian translations, use `loc:` strings on a tab and its elements, and let the user switch languages from a dropdown.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Localization({
    Enabled = true,
    DefaultLanguage = "en",
    Translations = {
        en = {
            title = "Control Panel",
            farm = "Auto Farm",
            language = "Language",
        },
        id = {
            title = "Panel Kontrol",
            farm = "Farm Otomatis",
            language = "Bahasa",
        },
    },
})

local Window = ANUI:CreateWindow({ Title = "loc:title" })
local Tab = Window:Tab({ Title = "loc:title", Icon = "gamepad-2" })

Tab:Toggle({
    Title = "loc:farm",
    Callback = function(on)
        print("farm:", on)
    end,
})

Tab:Dropdown({
    Title = "loc:language",
    Values = { "en", "id" },
    Value = "en",
    Callback = function(lang)
        ANUI:SetLanguage(lang)
    end,
})
```

::: tip
Because translation only touches strings prefixed with `loc:`, localized and plain strings can live side by side — mix and match freely.
:::
