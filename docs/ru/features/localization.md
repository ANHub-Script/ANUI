# Локализация

В ANUI встроен слой переводов. Вы регистрируете переводы по языкам, включаете систему, и после этого любая строка, начинающаяся с префикса локализации (`loc:`), находится в таблице и заменяется переводом для активного языка.

## Включение локализации

### `ANUI:Localization(config)`

Регистрирует ваши таблицы переводов и включает систему. Вызовите один раз, как можно раньше — до или сразу после создания окна.

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Enabled` | `boolean` | `false` | Главный выключатель. Должен быть `true`, чтобы перевод работал. |
| `Translations` | `table` | `{}` | Соответствие кода языка → таблице переводов `{ key = value }`. |
| `Prefix` | `string` | `"loc:"` | Маркер, помечающий строку как подлежащую переводу. |
| `DefaultLanguage` | `string` | `"en"` | Язык, используемый до вызова `SetLanguage`. |

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

## Использование переведённых строк

Добавьте к любому заголовку или подписи префикс `loc:`, за которым идёт ключ перевода. ANUI разрешит его по таблице активного языка.

```lua
local Tab = Window:Tab({
    Title = "loc:settings", -- показывает "Settings" (en) или "Pengaturan" (id)
    Icon = "settings",
})

Tab:Button({
    Title = "loc:welcome",
    Callback = function() end,
})
```

::: info Как работает префикс
Переводятся только строки, которые **начинаются с префикса** (по умолчанию `loc:`) — текст после префикса и есть ключ поиска. Все остальные строки показываются точно так, как написаны. Если ключа нет в активном языке, строка отображается буквально, поэтому ничего не ломается.
:::

## Смена языка во время работы

### `ANUI:SetLanguage(language)`

Переключает активный язык. Требует, чтобы локализация была включена — возвращает `false`, если вы никогда не вызывали `Localization` с `Enabled = true`.

```lua
ANUI:SetLanguage("id") -- переключиться на индонезийский
```

## Полный пример

Включаем переводы на английский и индонезийский, используем строки `loc:` на вкладке и её элементах и даём пользователю переключать язык из dropdown.

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
Поскольку перевод затрагивает только строки с префиксом `loc:`, локализованные и обычные строки могут спокойно существовать рядом — смешивайте их как угодно.
:::
