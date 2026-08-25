# Key System

密钥系统会在窗口打开之前弹出一个密钥输入提示，从而为你的菜单加上一道门槛。把一个 `KeySystem` 表传给 [`ANUI:CreateWindow{}`](/zh/guide/window-configuration) 即可配置它。ANUI 可以在本地校验密钥、通过自定义函数校验，或者借助内置的密钥提供方校验。

## 基本用法

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

## 配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | 窗口的 `Title` | 密钥提示框的标题。留空时回退为窗口标题。 |
| `Note` | `string` | — | 显示在标题下方的说明文字。 |
| `Thumbnail` | `table` | — | 预览图像：`{ Image, Title?, Width = 200 }`。 |
| `URL` | `string` | — | 显示一个 **Get key** 按钮，点击后把这个 URL 复制到剪贴板。 |
| `Key` | `string` \| `array` | — | 接受的密钥或密钥列表，在本地校验。 |
| `KeyValidator` | `function` | — | `fn(key) -> boolean`。**优先级最高**的自定义校验。 |
| `SaveKey` | `boolean` | — | 为 `true` 时，把通过校验的密钥写入 `ANUI/<Folder>/<hwid>.key`，这样就不会再向用户询问。 |
| `API` | `array` | — | 一个或多个密钥提供方服务的配置（见[提供方](#提供方)）。 |

::: warning 需要执行器的文件与 HTTP 函数
`SaveKey` 会读写密钥文件，因此需要执行器的文件全局函数（`readfile`/`writefile`/`isfile`），以及用于生成文件名的 `gethwid`。`API` 提供方会发起 HTTP 请求来验证密钥，因此需要 `game:HttpGet`／request 支持。本地的 `Key` 与 `KeyValidator` 校验不需要以上任何一项。
:::

## 校验优先级

当用户提交密钥时，ANUI 会按以下顺序检查，并在第一次匹配成功时停止：

1. **`KeyValidator`** —— 你的自定义函数（如果提供了）。
2. **`Key`** —— 本地的密钥或密钥列表。
3. **`API`** —— 已配置的提供方服务，按顺序依次尝试。

## 提供方

`API` 中的每一项都是一个表，包含 `Type` 以及该提供方要求的参数。每一项还可以带上 `Icon`、`Title` 和 `Desc`，用来自定义它在提示框中的显示方式。

| `Type` | 必需参数 | 备注 |
| --- | --- | --- |
| `luarmor` | `ScriptId`, `Discord` | Luarmor 密钥服务。 |
| `platoboost` | `ServiceId`, `Secret` | Platoboost 密钥服务。 |
| `pandadevelopment` | `ServiceId` | Panda Development 密钥服务。 |
| `github` | `Owner`、`Repo`、`URL`、`Secret` | 你自己的按设备密钥，有效期 24 小时，数据库提交到 GitHub 仓库。参见 [GitHub 密钥系统](/zh/features/github-key-system)。 |

```lua
API = {
    {
        Type = "luarmor",
        ScriptId = "your-script-id",
        Discord = "https://discord.gg/bUkCZvmrpH",
        Icon = "key",          -- 可选
        Title = "Luarmor",     -- 可选
        Desc = "Get a key",    -- 可选
    },
}
```

## 示例

### 静态密钥配合 SaveKey

接受若干固定密钥中的任意一个，并记住成功的那一个。

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

### 自定义校验函数

`KeyValidator` 接收用户输入的密钥字符串，并返回一个布尔值。它会在 `Key` 列表和 `API` 服务之前运行。

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Enter your personal key.",
        KeyValidator = function(key)
            -- 接受任何以玩家 UserId 结尾的密钥
            return key == "VIP-" .. game.Players.LocalPlayer.UserId
        end,
    },
})
```

### Luarmor 提供方

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

### Platoboost 提供方

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

## 参见

- [GitHub 密钥系统](/zh/features/github-key-system) —— 按设备发放、有效期 24 小时的密钥，由你自己的 GitHub Pages 站点生成。
- [窗口配置](/zh/guide/window-configuration) —— `KeySystem` 与 `Folder` 的设置位置。
