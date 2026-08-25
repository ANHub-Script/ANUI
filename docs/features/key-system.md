# Key System

The key system gates your menu behind a key prompt shown before the window opens. Configure it by passing a `KeySystem` table to [`ANUI:CreateWindow{}`](/guide/window-configuration). ANUI can validate keys locally, against a custom function, or through built-in key providers.

## Basic usage

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Enter your key to continue.",
        Key = { "free-key" },
        SaveKey = true,
    },
})
```

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | window `Title` | Heading of the key prompt. Falls back to the window's title. |
| `Note` | `string` | — | Instructional text shown under the title. |
| `Thumbnail` | `table` | — | Preview image: `{ Image, Title?, Width = 200 }`. |
| `URL` | `string` | — | Shows a **Get key** button that copies this URL to the clipboard. |
| `Key` | `string` \| `array` | — | Accepted key or list of keys, validated locally. |
| `KeyValidator` | `function` | — | `fn(key) -> boolean`. Custom check with the **highest priority**. |
| `SaveKey` | `boolean` | — | When `true`, writes the accepted key to `ANUI/<Folder>/<hwid>.key` so the user isn't asked again. |
| `API` | `array` | — | One or more key-provider service configs (see [Providers](#providers)). |

::: warning Requires executor file and HTTP functions
`SaveKey` reads and writes the key file, so it needs the executor file globals (`readfile`/`writefile`/`isfile`), plus `gethwid` for the filename. The `API` providers make HTTP requests to verify keys, so they need `game:HttpGet`/request support. Local `Key` and `KeyValidator` checks work without any of these.
:::

## Validation priority

When a user submits a key, ANUI checks it in this order and stops at the first match:

1. **`KeyValidator`** — your custom function, if provided.
2. **`Key`** — the local key or key list.
3. **`API`** — the configured provider services, in order.

## Providers

Each entry in `API` is a table with a `Type` and that provider's required arguments. An entry may also carry `Icon`, `Title`, and `Desc` to customize how it appears in the prompt.

| `Type` | Required args | Notes |
| --- | --- | --- |
| `luarmor` | `ScriptId`, `Discord` | Luarmor key service. |
| `platoboost` | `ServiceId`, `Secret` | Platoboost key service. |
| `pandadevelopment` | `ServiceId` | Panda Development key service. |
| `github` | `Owner`, `Repo`, `URL`, `Secret` | Your own per-device keys with a 24h lifetime, database committed to a GitHub repo. See [GitHub Key System](/features/github-key-system). |

```lua
API = {
    {
        Type = "luarmor",
        ScriptId = "your-script-id",
        Discord = "https://discord.gg/bUkCZvmrpH",
        Icon = "key",          -- optional
        Title = "Luarmor",     -- optional
        Desc = "Get a key",    -- optional
    },
}
```

## Examples

### Static keys with SaveKey

Accept one of several fixed keys and remember the one that worked.

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Title = "My Hub — Key",
        Note = "Get your key from the Discord.",
        URL = "https://discord.gg/bUkCZvmrpH",
        Key = { "key1", "key2" },
        SaveKey = true,
    },
})
```

### Custom validator

`KeyValidator` receives the entered key as a string and returns a boolean. It runs before the `Key` list and `API` services.

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Enter your personal key.",
        KeyValidator = function(key)
            -- accept any key that ends with the player's UserId
            return key == "VIP-" .. game.Players.LocalPlayer.UserId
        end,
    },
})
```

### Luarmor provider

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Verify your Luarmor key.",
        API = {
            {
                Type = "luarmor",
                ScriptId = "your-script-id",
                Discord = "https://discord.gg/bUkCZvmrpH",
            },
        },
    },
})
```

### Platoboost provider

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Verify your Platoboost key.",
        SaveKey = true,
        API = {
            {
                Type = "platoboost",
                ServiceId = "your-service-id",
                Secret = "your-secret",
            },
        },
    },
})
```

## See also

- [GitHub Key System](/features/github-key-system) — per-device keys with a 24-hour lifetime, generated on your own GitHub Pages site.
- [Window Configuration](/guide/window-configuration) — where `KeySystem` and `Folder` are set.
