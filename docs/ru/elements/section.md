# Section

Сворачиваемый контейнер (collapsible), размещаемый внутри вкладки. Как и Tab, Section предоставляет все методы создания элементов, поэтому вы добавляете в него дочерние элементы, и они отображаются сгруппированными под заголовком, который можно раскрывать и сворачивать.

::: info Два разных понятия «Section»
Эта страница документирует **элемент контента** `Tab:Section({...})` — сворачиваемый контейнер, размещаемый *внутри* вкладки.

Он не имеет отношения к `Window:Section({ Title = ... })`, который создаёт **заголовок раздела в боковой панели** для группировки вкладок. Про него смотрите [Вкладки и разделы](/ru/guide/tabs-and-sections).
:::

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local combat = myTab:Section({ Title = "Combat" })

combat:Toggle({ Title = "God Mode", Callback = function(state) end })
combat:Button({ Title = "Kill Aura", Callback = function() end })
```

::: tip
Section становится сворачиваемым только после того, как в нём появится хотя бы один дочерний элемент — у пустого Section нет содержимого, которое можно свернуть.
:::

## Конфигурация

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `"Section"` | Подпись заголовка. Поддерживает [токены rich-text](/ru/elements/#rich-text-в-title-desc), включая встроенные токены `{icon}`. |
| `Icon` | `string` | `nil` | Иконка заголовка: имя Lucide или `rbxassetid://…`. |
| `Image` | `string` | `nil` | Ресурс изображения для заголовка (альтернатива `Icon`). |
| `IconSize` | `number` | `20` | Размер иконки заголовка, в пикселях. |
| `IconThemed` | `boolean` | `false` | Окрашивает иконку в текущий цвет темы. |
| `InlineIcon` | `boolean` | `true` | Отображает иконку в одну строку с текстом заголовка. |
| `TextSize` | `number` | `19` | Размер текста заголовка. |
| `TextXAlignment` | `string` | `"Left"` | Горизонтальное выравнивание заголовка. |
| `TextTransparency` | `number` | `0.05` | Прозрачность текста заголовка. |
| `FontWeight` | `Enum.FontWeight` \| `string` | `SemiBold` | Насыщенность шрифта заголовка. |
| `Box` | `boolean` | `false` | Оборачивает секцию в рамку. |
| `Opened` | `boolean` | `false` | Начинать в раскрытом состоянии, а не в свёрнутом. |
| `HeaderSize` | `number` | `42` | Высота строки заголовка, в пикселях. |
| `HeaderPadding` | `number` | `8` | Внутренние отступы строки заголовка. |
| `ChevronSize` | `number` | `20` | Размер шеврона раскрытия/сворачивания. |

## Методы

Каждый метод создания элементов (`Section:Button`, `Section:Toggle`, `Section:Slider`, …) доступен у Section точно так же, как у Tab — см. [Обзор элементов](/ru/elements/). Специфичные для Section методы приведены ниже.

### `Section:SetTitle(text)`

Обновляет подпись заголовка.

```lua
combat:SetTitle("Combat (active)")
```

### `Section:SetIcon(icon)`

Устанавливает иконку заголовка (имя Lucide или `rbxassetid://…`).

```lua
combat:SetIcon("swords")
```

### `Section:SetIconSize(size)`

Устанавливает размер иконки заголовка, в пикселях.

```lua
combat:SetIconSize(24)
```

### `Section:GetIcon()`

Возвращает текущую иконку заголовка.

```lua
print(combat:GetIcon())
```

### `Section:Open()` / `Section:Close()`

Раскрывает или сворачивает секцию.

```lua
combat:Open()
combat:Close()
```

### `Section:Destroy()`

Удаляет секцию вместе с её дочерними элементами.

```lua
combat:Destroy()
```

## Примеры

### Иконка, заголовок с токеном и раскрытие по умолчанию

```lua
local stats = myTab:Section({
    Title = "{swords} Combat Stats",
    Icon = "swords",
    Opened = true,
})

stats:Slider({ Title = "Damage", Value = { Min = 0, Max = 100, Default = 50 } })
stats:Toggle({ Title = "Auto Attack", Callback = function(state) end })
```

### Раскрытие и сворачивание из кода

```lua
local advanced = myTab:Section({ Title = "Advanced" })
advanced:Toggle({ Title = "Verbose Logging" })

advanced:Open()  -- раскрыть
advanced:Close() -- свернуть
```

::: info
Поскольку Section — это контейнер, он не наследует интерактивные поведения общей базы (блокировку, подсветку и так далее) — эти поведения принадлежат элементам, которые вы размещаете *внутри него*.
:::
