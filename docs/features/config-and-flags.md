# Config & Flags

ANUI can save and restore the state of your menu to disk. Give any persistable element a `Flag`, and its value is written when you save a config and restored when you load one — no manual bookkeeping required.

::: info Requires a window `Folder`
The config system is powered by `Window.ConfigManager`, which only exists when the window was created with a `Folder`. Set one in [`ANUI:CreateWindow{}`](/guide/window-configuration) before using anything on this page.
:::

## How flags work

Every persistable element accepts a `Flag = "key"`. When you set it:

1. The element auto-registers with the **current config** (`Window.CurrentConfig`).
2. Calling `:Save()` on that config writes each registered flag's value to a JSON file.
3. Calling `:Load()` reads the file back and restores each element to its saved value.

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm", -- this value is now persistable
    Callback = function(v) print(v) end,
})
```

Flags on elements created before a current config exists are queued; they are drained and registered on the next `:Save()` or `:Load()`.

## What gets persisted

Only these element types serialize their state. Any other element is ignored by the config system.

| Element | What is saved |
| --- | --- |
| `Colorpicker` | Hex color **and** transparency |
| `Dropdown` | Selected value |
| `Input` | Text value |
| `Keybind` | Bound key |
| `Slider` | Default value (`Value.Default`) |
| `Toggle` | Boolean value |

## Where configs are stored

Configs are written under the root `ANUI/` folder, inside your window's `Folder`:

```
ANUI/<Folder>/config/<name>.json
```

For example, with `Folder = "MyHub"`, a config named `default` lives at `ANUI/MyHub/config/default.json`.

::: warning Requires executor file functions
Saving and loading touch the filesystem. Your executor must expose the file globals — `readfile`, `writefile`, `isfile`, and `makefolder` (plus related helpers). Without them, `:Save()` and `:Load()` cannot persist anything.
:::

## The config manager — `Window.ConfigManager`

`Window.ConfigManager` creates and manages named config files.

### `ConfigManager:CreateConfig(filename, autoload?)`

Creates (or opens) a config by name and returns a **config object**. `autoload` optionally marks it to load automatically. `ConfigManager:Config(...)` is an alias.

```lua
local ConfigManager = Window.ConfigManager
local config = ConfigManager:CreateConfig("default")
```

### `ConfigManager:GetConfig(name)`

Returns the config object for an existing name (exposing fields such as `.AutoLoad`).

### `ConfigManager:GetAutoLoadConfigs()`

Returns the configs marked for auto-load (as a JSON string).

### `ConfigManager:DeleteConfig(name)`

Deletes a config file by name.

### `ConfigManager:AllConfigs()`

Returns an array of all config names — handy for populating a dropdown.

```lua
local names = ConfigManager:AllConfigs() -- { "default", "pvp", ... }
```

## The config object

`CreateConfig`/`Config`/`GetConfig` all return a config object (a `ConfigModule`) with these methods.

### `config:SetAsCurrent()`

Marks this config as `Window.CurrentConfig`, so newly flagged elements register with it.

### `config:Register(name, element)`

Manually registers an element under a key (usually unnecessary — `Flag` does this for you).

### `config:Set(key, value)` / `config:Get(key)`

Store and read arbitrary custom data alongside your flags.

```lua
config:Set("lastPlayer", game.Players.LocalPlayer.Name)
print(config:Get("lastPlayer"))
```

### `config:SetAutoLoad(bool)`

Marks (or unmarks) this config to load automatically.

### `config:Save()`

Writes every registered flag and custom value to disk. Returns a truthy value on success.

### `config:Load()`

Reads the file and restores each registered element. Returns a truthy value on success.

### `config:Delete()`

Deletes this config's file.

### `config:GetData()`

Returns the full data table currently held by the config.

## `Window.CurrentConfig`

`Window.CurrentConfig` holds the active config object. Flagged elements register with it, and it is the config that `:SetAutoLoad`, `:Save`, and `:Load` act on when driven from your UI. Point it at a config before saving or loading:

```lua
Window.CurrentConfig = ConfigManager:CreateConfig("default")
Window.CurrentConfig:Load()
```

## Complete Save / Load UI

A full config panel: a name input, a dropdown of existing configs, an auto-load toggle, and Save / Load buttons. Adapted from the example script's "Config Usage" tab.

```lua
local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- Name of the config to save/load
local ConfigNameInput = ConfigTab:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Callback = function(value)
        ConfigName = value
    end,
})

-- Toggle auto-load for the current config
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "Enable Auto Load to Selected Config",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})

-- Dropdown listing every existing config
local AllConfigs = ConfigManager:AllConfigs()
local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil

local AllConfigsDropdown = ConfigTab:Dropdown({
    Title = "All Configs",
    Desc = "Select existing configs",
    Values = AllConfigs,
    Value = DefaultValue,
    Callback = function(value)
        ConfigName = value
        ConfigNameInput:Set(value)
        AutoLoadToggle:Set((ConfigManager:GetConfig(ConfigName)).AutoLoad or false)
    end,
})

-- Save the current state into ConfigName
ConfigTab:Button({
    Title = "Save Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:Config(ConfigName)
        if Window.CurrentConfig:Save() then
            ANUI:Notify({
                Title = "Config Saved",
                Content = "Config '" .. ConfigName .. "' saved",
                Icon = "check",
            })
        end
        -- refresh the dropdown so a brand-new config appears
        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

-- Load ConfigName back into the UI
ConfigTab:Button({
    Title = "Load Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
        if Window.CurrentConfig:Load() then
            ANUI:Notify({
                Title = "Config Loaded",
                Content = "Config '" .. ConfigName .. "' loaded",
                Icon = "refresh-cw",
            })
        end
    end,
})
```

## See also

- [Config System example](/examples/config-system) — a complete, copy-pasteable walkthrough.
