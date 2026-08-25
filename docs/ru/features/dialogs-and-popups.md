# Dialogs & Popups

У ANUI есть два способа показать модальное окно: **`Window:Dialog{}`**, которое прикрепляется к существующему окну, и **`ANUI:Popup{}`**, автономное модальное окно, которое можно открыть откуда угодно. Оба показывают заголовок, текст и ряд кнопок.

## Dialog vs Popup

| | `Window:Dialog{}` | `ANUI:Popup{}` |
| --- | --- | --- |
| Прикрепление | Отрисовывается внутри существующего окна | Автономное, модальное окно уровня экрана |
| Требует окно | Да — вызывается на `Window` | Нет — вызывается напрямую на `ANUI` |
| Управление шириной | `Width` (по умолчанию `320`) | — |
| Изображение thumbnail | — | `Thumbnail` |
| Возвращаемый объект | — | Без методов; кнопки закрывают его |
| Лучше всего для | Подтверждений, связанных с уже созданным вами меню | Быстрых окон до/без полного окна |

## `Window:Dialog{}`

Открывает модальный диалог, привязанный к окну. Используйте его для подтверждений и небольшого выбора внутри вашего меню.

### Настройка

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | — | Заголовок диалога. |
| `Content` | `string` | — | Текст тела под заголовком. |
| `Icon` | `string` | — | Ведущая иконка: имя иконки Lucide или `rbxassetid://…`. |
| `Width` | `number` | `320` | Ширина диалога в пикселях. |
| `Buttons` | `table` | — | Массив спецификаций кнопок (см. ниже). |

Каждая запись в `Buttons` — это таблица:

| Field | Type | Описание |
| --- | --- | --- |
| `Title` | `string` | Подпись кнопки. |
| `Icon` | `string` | Необязательная иконка на кнопке. |
| `Callback` | `function` | Выполняется при нажатии кнопки. **Не принимает аргументов.** |
| `Variant` | `string` | Визуальный стиль: `"Primary"`, `"Secondary"` или `"White"`. |

```lua
Window:Dialog({
    Title = "Delete save?",
    Content = "This cannot be undone.",
    Buttons = {
        { Title = "Delete", Variant = "Primary", Icon = "trash", Callback = function()
            print("deleted")
        end },
    },
})
```

## `ANUI:Popup{}`

Открывает автономное модальное окно немедленно, без необходимости в окне. Его кнопки закрывают popup при нажатии, а возвращаемый объект не предоставляет никаких методов.

### Настройка

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dialog"` | Заголовок popup. |
| `Content` | `string` | `nil` | Текст тела под заголовком. |
| `Icon` | `string` | `nil` | Ведущая иконка: имя иконки Lucide или `rbxassetid://…`. |
| `IconThemed` | `boolean` | — | Окрашивает иконку в цвет иконок темы. |
| `Thumbnail` | `table` | — | Большое изображение предпросмотра: `{ Image, Title? }`. |
| `Buttons` | `table` | — | Массив спецификаций кнопок (та же форма, что и в Dialog). |

Каждая запись в `Buttons` — это таблица:

| Field | Type | Описание |
| --- | --- | --- |
| `Title` | `string` | Подпись кнопки. |
| `Icon` | `string` | Необязательная иконка на кнопке. |
| `Callback` | `function` | Выполняется при нажатии, затем popup закрывается. **Не принимает аргументов.** |
| `Variant` | `string` | Визуальный стиль: `"Primary"`, `"Secondary"` или `"White"`. |

::: info Popup открывается сразу
`ANUI:Popup{}` показывает модальное окно сразу после вызова. Нет ничего, что нужно `:Open()` — и нет методов у возвращаемого объекта, поскольку кнопки закрывают его за вас.
:::

## Примеры

### Варианты кнопок (Dialog)

Три варианта кнопок — `Primary`, `Secondary` и `White` — в одном диалоге.

```lua
Window:Dialog({
    Title = "UI Button Variants",
    Content = "Demonstrates the Button variants.",
    Buttons = {
        { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
        { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
        { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
    },
})
```

### Диалог подтверждения (Cancel / Confirm)

```lua
Window:Dialog({
    Title = "Reset settings?",
    Content = "All options will return to their defaults.",
    Icon = "rotate-ccw",
    Width = 340,
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function()
            print("cancelled")
        end },
        { Title = "Confirm", Variant = "Primary", Icon = "check", Callback = function()
            print("confirmed")
        end },
    },
})
```

### Простой popup

```lua
ANUI:Popup({
    Title = "Welcome",
    Content = "Thanks for trying the script. Join our community for updates.",
    Icon = "hand",
    Thumbnail = {
        Image = "rbxassetid://84366761557806",
        Title = "ANHub",
    },
    Buttons = {
        { Title = "Copy Discord", Variant = "Primary", Icon = "link", Callback = function()
            setclipboard("https://discord.gg/bUkCZvmrpH")
        end },
        { Title = "Close", Variant = "Secondary", Callback = function() end },
    },
})
```
