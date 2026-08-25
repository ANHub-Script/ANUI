# Темы

ANUI поставляется с 26 встроенными темами и позволяет зарегистрировать свои собственные. Вы выбираете тему при создании окна, меняете её во время работы, читаете активную и реагируете на изменения — всё это через методы верхнего уровня у `ANUI`.

## Установка темы при создании

Передайте key темы в `CreateWindow` через поле `Theme`. По умолчанию используется `"Dark"`.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Theme = "Midnight", -- любой встроенный key или имя пользовательской темы
})
```

Все остальные опции окна см. в [Настройке окна](/ru/guide/window-configuration).

## Смена темы во время работы

### `ANUI:SetTheme(name)`

Применяет тему по её key и возвращает таблицу темы либо `nil`, если key неизвестен.

```lua
if not ANUI:SetTheme("Emerald") then
    warn("Неизвестный key темы")
end
```

## Чтение активной темы

### `ANUI:GetCurrentTheme()`

Возвращает **отображаемое имя** активной темы (например, `"Monokai Pro"`, а не key `MonokaiPro`).

```lua
print(ANUI:GetCurrentTheme()) --> "Midnight"
```

### `ANUI:GetThemes()`

Возвращает таблицу всех зарегистрированных тем, где ключами служат key тем — включая те, что вы добавили через `AddTheme`.

```lua
for key, theme in pairs(ANUI:GetThemes()) do
    print(key, "->", theme.Name)
end
```

## Реакция на смену темы

### `ANUI:OnThemeChange(callback)`

Регистрирует обработчик, который выполняется каждый раз, когда `SetTheme` применяет тему. Callback получает **один аргумент: key темы**, которая была применена — ту же строку, что вы передали в `SetTheme` (например, `"Dark"`).

```lua
ANUI:OnThemeChange(function(themeKey)
    print("Тема изменена на:", themeKey)
end)
```

::: info Только один обработчик
`OnThemeChange` хранит лишь один обработчик — повторный вызов заменяет предыдущий. Зарегистрируйте одну функцию и разветвляйте логику внутри неё, если реагировать должны несколько частей вашего скрипта.
:::

## Встроенные темы

Передавайте **key** в `Theme` / `SetTheme`. Отображаемое имя (то, что возвращает `GetCurrentTheme`) отличается от key лишь у нескольких тем.

| Key | Отображаемое имя |
| --- | --- |
| `Dark` | Dark *(по умолчанию)* |
| `Light` | Light |
| `Rose` | Rose |
| `Plant` | Plant |
| `Red` | Red |
| `Indigo` | Indigo |
| `Sky` | Sky |
| `Violet` | Violet |
| `Amber` | Amber |
| `Emerald` | Emerald |
| `Midnight` | Midnight |
| `Crimson` | Crimson |
| `MonokaiPro` | Monokai Pro |
| `CottonCandy` | Cotton Candy |
| `Rainbow` | Rainbow |
| `NordTheme` | Nord |
| `DraculaTheme` | Dracula |
| `TokyoNight` | Tokyo Night |
| `OneDark` | One Dark |
| `Gruvbox` | Gruvbox |
| `SolarizedDark` | Solarized Dark |
| `MaterialDark` | Material Dark |
| `CyberpunkPink` | Cyberpunk Pink |
| `OceanBlue` | Ocean Blue |
| `NeonGreen` | Neon Green |
| `SoftPastel` | Soft Pastel |

## Пользовательские темы

### `ANUI:AddTheme(theme)`

Регистрирует тему, используя её `Name` в качестве key, и возвращает её. После добавления примените её через `SetTheme(name)`.

Тема — это таблица цветовых ключей. Девять из них обязательны; `Toggle` и `Checkbox` необязательны. Каждый цвет — это `Color3`, обычно создаваемый через `Color3.fromHex("#…")`.

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Name` | `string` | — | Уникальное имя темы. Именно его вы передаёте в `SetTheme`. |
| `Accent` | `Color3` | — | Основной акцентный цвет / цвет панели. |
| `Dialog` | `Color3` | — | Фон диалогов и popup. |
| `Outline` | `Color3` | — | Цвет границы / обводки. |
| `Text` | `Color3` | — | Основной цвет текста. |
| `Placeholder` | `Color3` | — | Цвет приглушённого текста / placeholder. |
| `Background` | `Color3` | — | Цвет фона окна. |
| `Button` | `Color3` | — | Цвет фона кнопок. |
| `Icon` | `Color3` | — | Цвет окрашивания иконок. |
| `Toggle` | `Color3` | *(необязательно)* | Цвет toggle в положении "on". |
| `Checkbox` | `Color3` | *(необязательно)* | Цвет checkbox в состоянии "checked". |

```lua
ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
    Toggle      = Color3.fromHex("#22d3ee"),
    Checkbox    = Color3.fromHex("#0ea5e9"),
})

ANUI:SetTheme("Oceanic")
```

::: tip
Тема, добавленная через `AddTheme`, сразу же появляется в `GetThemes()` и может быть выбрана так же, как любая встроенная тема.
:::

## Градиенты

### `ANUI:Gradient(stops, props)`

Строит таблицу данных градиента из набора цветовых точек. Ключами `stops` служат **строки позиций** от `"0"` до `"100"` (процент по длине градиента); каждая точка имеет вид `{ Color = Color3, Transparency = number }` — `Transparency` необязателен и по умолчанию равен `0`. `props` — необязательная таблица, которая объединяется с результатом, например `{ Rotation = 45 }`.

```lua
local sunset = ANUI:Gradient({
    ["0"]   = { Color = Color3.fromHex("#40c9ff") },
    ["50"]  = { Color = Color3.fromHex("#8b5cf6") },
    ["100"] = { Color = Color3.fromHex("#e81cff") },
}, {
    Rotation = 45,
})
```

::: warning Минимум две точки
Градиенту нужны **две или более** цветовые точки. Если передать меньше, возникнет ошибка.
:::

Градиенты вставляются всюду, где библиотека принимает данные градиента — чаще всего в поля `TitleGradient` и `DescGradient` у элементов:

```lua
myTab:Button({
    Title = "Gradient Title",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Callback = function() end,
})
```

Градиенты могут даже задавать цвета темы — встроенная тема `Rainbow` описана градиентами вместо плоских значений `Color3`.

## Acrylic-блюр

### `ANUI:ToggleAcrylic(enabled)`

Включает или выключает acrylic-блюр позади окна. Это действует только если окно было создано с `Acrylic = true`; иначе метод ничего не делает.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Acrylic = true,
})

ANUI:ToggleAcrylic(true)  -- включить блюр
ANUI:ToggleAcrylic(false) -- выключить блюр
```

## Шрифт

### `ANUI:SetFont(fontId)`

Задаёт глобальный шрифт, используемый во всём UI.

```lua
ANUI:SetFont("rbxassetid://12898095208")
```

## Полный пример

Регистрируем пользовательскую тему, применяем её, добавляем переключатель тем и логируем каждое изменение.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
})

local Window = ANUI:CreateWindow({
    Title = "Theme Demo",
    Theme = "Oceanic",
    Acrylic = true,
})

local Tab = Window:Tab({ Title = "Appearance", Icon = "palette" })

Tab:Paragraph({
    Title = "Theme switcher",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Desc = "Выберите тему ниже.",
})

Tab:Dropdown({
    Title = "Theme",
    Values = { "Dark", "Light", "Midnight", "Oceanic" },
    Value = "Oceanic",
    Callback = function(name)
        ANUI:SetTheme(name)
    end,
})

ANUI:OnThemeChange(function(themeKey)
    print("Активный key темы:", themeKey)
    print("Отображаемое имя:", ANUI:GetCurrentTheme())
end)
```
