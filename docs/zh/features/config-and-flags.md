# Config & Flags

ANUI 可以把菜单的状态保存到磁盘并还原回来。给任何可持久化的元素设置一个 `Flag`，它的值就会在你保存配置时被写入、在你加载配置时被还原 —— 无需手动记账。

::: info 需要窗口的 `Folder`
配置系统由 `Window.ConfigManager` 驱动，而它只在窗口带 `Folder` 创建时才存在。在使用本页的任何内容之前，请先在 [`ANUI:CreateWindow{}`](/zh/guide/window-configuration) 中设置一个。
:::

## Flag 的工作方式

每个可持久化的元素都接受 `Flag = "key"`。当你设置它时：

1. 元素会自动注册到**当前配置**（`Window.CurrentConfig`）。
2. 在该配置上调用 `:Save()` 会把每个已注册 flag 的值写入一个 JSON 文件。
3. 调用 `:Load()` 会重新读取该文件，并把每个元素还原为保存过的值。

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm", -- 这个值现在可以持久化了
    Callback = function(v) print(v) end,
})
```

在当前配置存在之前创建的元素上的 flag 会被放入队列；这些队列会在下一次 `:Save()` 或 `:Load()` 时被清空并完成注册。

## 哪些内容会被持久化

只有以下元素类型会序列化自己的状态。其他元素会被配置系统忽略。

| Element | 保存的内容 |
| --- | --- |
| `Colorpicker` | 十六进制颜色**以及**透明度 |
| `Dropdown` | 所选的值 |
| `Input` | 文本值 |
| `Keybind` | 绑定的按键 |
| `Slider` | 默认值（`Value.Default`） |
| `Toggle` | 布尔值 |

## 配置文件保存在哪里

配置会写入根目录 `ANUI/` 下、你窗口的 `Folder` 内部：

```
ANUI/<Folder>/config/<name>.json
```

例如，当 `Folder = "MyHub"` 时，名为 `default` 的配置位于 `ANUI/MyHub/config/default.json`。

::: warning 需要执行器的文件函数
保存和加载会访问文件系统。你的执行器必须提供文件相关的全局函数 —— `readfile`、`writefile`、`isfile` 和 `makefolder`（以及相关的辅助函数）。缺少它们时，`:Save()` 和 `:Load()` 无法持久化任何内容。
:::

## 配置管理器 —— `Window.ConfigManager`

`Window.ConfigManager` 负责创建和管理具名的配置文件。

### `ConfigManager:CreateConfig(filename, autoload?)`

按名称创建（或打开）一个配置，并返回一个**配置对象**。可选的 `autoload` 会把它标记为自动加载。`ConfigManager:Config(...)` 是它的别名。

```lua
local ConfigManager = Window.ConfigManager
local config = ConfigManager:CreateConfig("default")
```

### `ConfigManager:GetConfig(name)`

返回某个已存在名称对应的配置对象（会暴露 `.AutoLoad` 等字段）。

### `ConfigManager:GetAutoLoadConfigs()`

返回被标记为自动加载的配置（以 JSON 字符串形式）。

### `ConfigManager:DeleteConfig(name)`

按名称删除一个配置文件。

### `ConfigManager:AllConfigs()`

返回包含所有配置名称的数组 —— 很适合用来填充下拉框。

```lua
local names = ConfigManager:AllConfigs() -- { "default", "pvp", ... }
```

## 配置对象

`CreateConfig`/`Config`/`GetConfig` 都会返回一个配置对象（即 `ConfigModule`），它带有以下方法。

### `config:SetAsCurrent()`

把这个配置标记为 `Window.CurrentConfig`，这样新建的带 flag 的元素就会注册到它上面。

### `config:Register(name, element)`

在某个 key 下手动注册一个元素（通常不需要 —— `Flag` 已经帮你做了）。

### `config:Set(key, value)` / `config:Get(key)`

在 flag 之外存取任意自定义数据。

```lua
config:Set("lastPlayer", game.Players.LocalPlayer.Name)
print(config:Get("lastPlayer"))
```

### `config:SetAutoLoad(bool)`

把这个配置标记（或取消标记）为自动加载。

### `config:Save()`

把每个已注册的 flag 和自定义值写入磁盘。成功时返回一个 truthy 值。

### `config:Load()`

读取文件并还原每个已注册的元素。成功时返回一个 truthy 值。

### `config:Delete()`

删除这个配置自己的文件。

### `config:GetData()`

返回配置当前持有的完整数据表。

## `Window.CurrentConfig`

`Window.CurrentConfig` 持有当前活动的配置对象。带 flag 的元素会注册到它上面，而当你从 UI 触发 `:SetAutoLoad`、`:Save` 和 `:Load` 时，作用的也正是这个配置。在保存或加载之前，请先把它指向某个配置：

```lua
Window.CurrentConfig = ConfigManager:CreateConfig("default")
Window.CurrentConfig:Load()
```

## 完整的 Save / Load UI

一个完整的配置面板：名称输入框、已有配置的下拉框、自动加载开关，以及 Save / Load 按钮。改编自示例脚本中的 "Config Usage" 标签页。

```lua
local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- 要保存/加载的配置名称
local ConfigNameInput = ConfigTab:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Callback = function(value)
        ConfigName = value
    end,
})

-- 为当前配置切换自动加载
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "Enable Auto Load to Selected Config",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})

-- 列出所有已存在配置的下拉框
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

-- 把当前状态保存到 ConfigName
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
        -- 刷新下拉框，让刚创建的配置显示出来
        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

-- 把 ConfigName 重新加载回 UI
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

## 参见

- [配置系统示例](/zh/examples/config-system) —— 一份完整、可直接复制粘贴的教程。
