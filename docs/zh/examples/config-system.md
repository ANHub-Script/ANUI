# 配置系统

一套完整的保存/加载方案：带 Flag 的元素让值持久保存、从磁盘填充的配置选择器、Save/Load 按钮，以及一个自动加载开关。本文改编自演示脚本的 **Config Usage** 标签页。

::: warning 需要执行器的文件访问能力
配置保存会在磁盘上读写 JSON 文件，因此你的执行器必须支持文件全局函数 `readfile`、`writefile`、`isfile` 和 `makefolder`。配置保存在 `ANUI/<Folder>/config/<name>.json`，其中 `<Folder>` 就是你传给 `CreateWindow` 的 `Folder`。
:::

## 1. 给元素加上 Flag

任何带有 `Flag` 键的有状态元素（Toggle、Slider、Dropdown、Input、Keybind、Colorpicker）都会自动注册到当前激活的配置中。它的值会在 Save 时写入、在 Load 时恢复 —— 你无需为每个元素额外写代码。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Folder = "MyHub", -- 配置功能必需 —— 这是磁盘上的根目录
})

local Tab = Window:Tab({ Title = "Settings", Icon = "sliders-horizontal" })

-- 每个 `Flag` 都会成为所保存 JSON 文件中的一个键。
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

## 2. 取得 ConfigManager 并设定当前配置

因为我们传入了 `Folder`，`Window.ConfigManager` 会被自动创建。我们把配置名保存在一个变量里，并在一开始就把某个配置设为**当前**配置，这样带 Flag 的值始终有地方可以保存。

```lua
local ConfigTab = Window:Tab({ Title = "Config", Icon = "folder" })

local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- 确保存在一个当前配置。`:Config(name)` 会创建或打开它（:CreateConfig 的别名）。
Window.CurrentConfig = ConfigManager:Config(ConfigName)
```

## 3. Config Name 输入框

让用户输入要保存或加载的配置名称。我们把它写回 `ConfigName`。

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

## 4. 自动加载开关

`ConfigModule:SetAutoLoad(bool)` 会标记某个配置在启动时自动加载。我们在当前配置上调用它。

```lua
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "Auto Load This Config",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})
```

## 5. "All Configs" 下拉框

`ConfigManager:AllConfigs()` 会返回磁盘上已存在的每个配置的名称。我们把这个列表喂给一个下拉框，让用户可以挑选已有的配置。当用户选中时，我们同步名称输入框，并反映该配置已保存的自动加载状态（从它的 `.AutoLoad` 字段读取）。

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

## 6. Save 与 Load 按钮

Save 按钮把 `ConfigName` 设为当前配置并调用 `:Save()`；成功时我们发出通知并刷新下拉框，让全新的配置出现在列表中。Load 按钮打开该配置并调用 `:Load()`，它会恢复每一个带 Flag 的值。

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
`:Config(name)` 与 `:CreateConfig(name)` 是别名 —— 两者都会在配置文件不存在时创建它，已存在时则打开它。`:Save()` 和 `:Load()` 在成功时返回真值，这就是上面的按钮只在操作成功时才发出通知的原因。
:::

关于完整的 Flag 工作流、被持久化的元素类型列表，以及每一个 `ConfigManager` / `ConfigModule` 方法，请参见[配置与 Flag](/zh/features/config-and-flags)。
