# 本地化

ANUI 内置了一层翻译机制。你按语言注册翻译表、启用该系统，之后任何以本地化前缀（`loc:`）开头的字符串都会被查表，并替换为当前语言对应的翻译。

## 启用本地化

### `ANUI:Localization(config)`

注册你的翻译表并启用该系统。只需在早期调用一次 —— 在创建窗口之前或刚创建之后。

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Enabled` | `boolean` | `false` | 总开关。必须为 `true` 翻译才会生效。 |
| `Translations` | `table` | `{}` | 语言代码 → `{ key = value }` 翻译表的映射。 |
| `Prefix` | `string` | `"loc:"` | 用于标记某个字符串需要翻译的前缀。 |
| `DefaultLanguage` | `string` | `"en"` | 在你调用 `SetLanguage` 之前使用的语言。 |

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

## 使用翻译字符串

在任意标题或标签前加上 `loc:`，后面接翻译 key。ANUI 会根据当前语言的表来解析它。

```lua
local Tab = Window:Tab({
    Title = "loc:settings", -- 显示 "Settings"（en）或 "Pengaturan"（id）
    Icon = "settings",
})

Tab:Button({
    Title = "loc:welcome",
    Callback = function() end,
})
```

::: info 前缀的工作方式
只有**以前缀开头**的字符串（默认是 `loc:`）才会被翻译 —— 前缀之后的文字就是查找用的 key。其他字符串都会原样显示。如果某个 key 在当前语言中不存在，字符串会按字面显示，因此不会出现任何问题。
:::

## 在运行时切换语言

### `ANUI:SetLanguage(language)`

切换当前语言。要求本地化处于启用状态 —— 如果你从未用 `Enabled = true` 调用过 `Localization`，它会返回 `false`。

```lua
ANUI:SetLanguage("id") -- 切换为印尼语
```

## 完整示例

启用英语 + 印尼语翻译，在一个标签页及其元素上使用 `loc:` 字符串，并让用户通过下拉框切换语言。

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
由于翻译只作用于以 `loc:` 开头的字符串，本地化字符串和普通字符串可以并存 —— 你可以随意混用。
:::
