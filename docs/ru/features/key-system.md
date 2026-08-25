# Key System

Система ключей закрывает ваше меню запросом ключа, который показывается перед открытием окна. Настройте её, передав таблицу `KeySystem` в [`ANUI:CreateWindow{}`](/ru/guide/window-configuration). ANUI может проверять ключи локально, через собственную функцию или через встроенных провайдеров ключей.

## Базовое использование

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

## Настройка

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `Title` окна | Заголовок запроса ключа. Если не задан, берётся заголовок окна. |
| `Note` | `string` | — | Пояснительный текст под заголовком. |
| `Thumbnail` | `table` | — | Изображение-превью: `{ Image, Title?, Width = 200 }`. |
| `URL` | `string` | — | Показывает кнопку **Get key**, которая копирует этот URL в буфер обмена. |
| `Key` | `string` \| `array` | — | Принимаемый ключ или список ключей, проверяемые локально. |
| `KeyValidator` | `function` | — | `fn(key) -> boolean`. Собственная проверка с **наивысшим приоритетом**. |
| `SaveKey` | `boolean` | — | При `true` записывает принятый ключ в `ANUI/<Folder>/<hwid>.key`, чтобы у пользователя больше не спрашивали. |
| `API` | `array` | — | Одна или несколько конфигураций сервисов-провайдеров ключей (см. [Провайдеры](#провайдеры)). |

::: warning Требуются файловые и HTTP-функции исполнителя
`SaveKey` читает и записывает файл ключа, поэтому ему нужны файловые глобальные функции исполнителя (`readfile`/`writefile`/`isfile`), плюс `gethwid` для имени файла. Провайдеры `API` выполняют HTTP-запросы для проверки ключей, поэтому им нужна поддержка `game:HttpGet`/request. Локальные проверки `Key` и `KeyValidator` работают без всего этого.
:::

## Приоритет валидации

Когда пользователь отправляет ключ, ANUI проверяет его в следующем порядке и останавливается на первом совпадении:

1. **`KeyValidator`** — ваша собственная функция, если она указана.
2. **`Key`** — локальный ключ или список ключей.
3. **`API`** — настроенные сервисы-провайдеры, по порядку.

## Провайдеры

Каждая запись в `API` — это таблица с `Type` и обязательными аргументами соответствующего провайдера. Запись также может содержать `Icon`, `Title` и `Desc`, чтобы настроить её отображение в запросе.

| `Type` | Обязательные аргументы | Примечания |
| --- | --- | --- |
| `luarmor` | `ScriptId`, `Discord` | Сервис ключей Luarmor. |
| `platoboost` | `ServiceId`, `Secret` | Сервис ключей Platoboost. |
| `pandadevelopment` | `ServiceId` | Сервис ключей Panda Development. |
| `github` | `Owner`, `Repo`, `URL`, `Secret` | Ваши собственные ключи на устройство со сроком жизни 24 часа, база данных хранится в репозитории GitHub. См. [Ключи через GitHub](/ru/features/github-key-system). |

```lua
API = {
    {
        Type = "luarmor",
        ScriptId = "your-script-id",
        Discord = "https://discord.gg/bUkCZvmrpH",
        Icon = "key",          -- необязательно
        Title = "Luarmor",     -- необязательно
        Desc = "Get a key",    -- необязательно
    },
}
```

## Примеры

### Статические ключи с SaveKey

Принимает один из нескольких фиксированных ключей и запоминает тот, который подошёл.

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

### Собственный валидатор

`KeyValidator` получает введённый ключ в виде строки и возвращает boolean. Он выполняется раньше списка `Key` и сервисов `API`.

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Enter your personal key.",
        KeyValidator = function(key)
            -- принять любой ключ, который заканчивается на UserId игрока
            return key == "VIP-" .. game.Players.LocalPlayer.UserId
        end,
    },
})
```

### Провайдер Luarmor

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

### Провайдер Platoboost

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

## См. также

- [Ключи через GitHub](/ru/features/github-key-system) — ключи на устройство со сроком жизни 24 часа, выдаваемые вашим сайтом на GitHub Pages.
- [Настройка окна](/ru/guide/window-configuration) — где задаются `KeySystem` и `Folder`.
