# Config System

A complete save/load recipe: flagged elements whose values persist, a config picker populated from disk, Save/Load buttons, and an auto-load toggle. This is adapted from the demo's **Config Usage** tab.

::: warning Executor file access required
Config saving reads and writes JSON files on disk, so your executor must support the file globals `readfile`, `writefile`, `isfile` and `makefolder`. Configs are stored at `ANUI/<Folder>/config/<name>.json`, where `<Folder>` is the `Folder` you passed to `CreateWindow`.
:::

## 1. Flag your elements

Any stateful element (Toggle, Slider, Dropdown, Input, Keybind, Colorpicker) that has a `Flag` key auto-registers with the active config. Its value is written on Save and restored on Load — you write no extra code per element.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Folder = "MyHub", -- REQUIRED for configs — this is the on-disk root
})

local Tab = Window:Tab({ Title = "Settings", Icon = "sliders-horizontal" })

-- Each `Flag` becomes a key inside the saved JSON file.
Tab:Toggle({
    Flag = "AutoFarm",
    Title = "Auto Farm",
    Callback = function(state) print("Auto Farm:", state) end,
})

Tab:Slider({
    Flag = "WalkSpeed",
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) print("Walk Speed:", value) end,
})

Tab:Dropdown({
    Flag = "Weapon",
    Title = "Weapon",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value) print("Weapon:", value) end,
})
```

## 2. Grab the ConfigManager and set a current config

`Window.ConfigManager` is created automatically because we passed a `Folder`. We keep the config name in a variable and make one config **current** up front, so flagged values always have somewhere to save to.

```lua
local ConfigTab = Window:Tab({ Title = "Config", Icon = "folder" })

local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- Ensure a current config exists. `:Config(name)` creates-or-opens it (alias of :CreateConfig).
Window.CurrentConfig = ConfigManager:Config(ConfigName)
```

## 3. A Config Name input

Let the user type the name of the config to save or load. We store it back into `ConfigName`.

```lua
local ConfigNameInput = ConfigTab:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Value = ConfigName,
    Callback = function(value)
        ConfigName = value
    end,
})
```

## 4. An auto-load toggle

`ConfigModule:SetAutoLoad(bool)` marks a config to load automatically on startup. We call it on the current config.

```lua
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "Auto Load This Config",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})
```

## 5. An "All Configs" dropdown

`ConfigManager:AllConfigs()` returns the names of every config already on disk. We feed that list into a dropdown so the user can pick an existing one. When they select it we sync the name input and reflect that config's saved auto-load state (read from its `.AutoLoad` field).

```lua
local AllConfigs = ConfigManager:AllConfigs()

local AllConfigsDropdown = ConfigTab:Dropdown({
    Title = "All Configs",
    Desc = "Select an existing config",
    Values = AllConfigs,
    Value = table.find(AllConfigs, ConfigName) and ConfigName or nil,
    Callback = function(value)
        ConfigName = value
        ConfigNameInput:Set(value)
        AutoLoadToggle:Set((ConfigManager:GetConfig(ConfigName)).AutoLoad or false)
    end,
})
```

## 6. Save and Load buttons

The Save button makes `ConfigName` the current config and calls `:Save()`; on success we notify and refresh the dropdown so a brand-new config appears in the list. The Load button opens the config and calls `:Load()`, which restores every flagged value.

```lua
ConfigTab:Button({
    Title = "Save Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:Config(ConfigName)
        if Window.CurrentConfig:Save() then
            ANUI:Notify({ Title = "Config Saved", Content = "Saved '" .. ConfigName .. "'", Icon = "check" })
        end
        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

ConfigTab:Button({
    Title = "Load Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
        if Window.CurrentConfig:Load() then
            ANUI:Notify({ Title = "Config Loaded", Content = "Loaded '" .. ConfigName .. "'", Icon = "refresh-cw" })
        end
    end,
})
```

::: info
`:Config(name)` and `:CreateConfig(name)` are aliases — both create the config file if it does not exist, or open it if it does. `:Save()` and `:Load()` return a truthy value on success, which is why the buttons above notify only when the operation worked.
:::

For the full flag workflow, the list of persisted element types, and every `ConfigManager` / `ConfigModule` method, see [Config & Flags](/features/config-and-flags).
