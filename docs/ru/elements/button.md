# Button

Строка действия, по которой можно щёлкнуть, с необязательной иконкой, цветом и встроенными кнопками. Button — самый простой интерактивный элемент: при щелчке он выполняет callback.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({
    Title = "Click me",
    Callback = function()
        print("Button clicked!")
    end
})
```

## Конфигурация

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `"Button"` | Основная подпись. Поддерживает [токены rich-text](/ru/elements/#rich-text-в-title-desc). |
| `Desc` | `string` | `nil` | Необязательное описание под заголовком. |
| `Icon` | `string` | `"mouse-pointer-click"` | Имя иконки или `rbxassetid://…`. |
| `IconThemed` | `boolean` | `false` | Окрашивает иконку в текущий цвет темы. |
| `Color` | `Color3` \| `string` | `nil` | Цветной фон (имя темы или `Color3`); цвет текста подбирается автоматически. |
| `Justify` | `string` | `"Between"` | Выравнивание содержимого. `"Between"` разносит заголовок и иконку по краям; `"Center"` центрирует их. |
| `IconAlign` | `string` | `"Right"` | Сторона, на которой располагается иконка: `"Right"` или `"Left"`. |
| `Locked` | `boolean` | `false` | Отображает оверлей блокировки и блокирует щелчки. |
| `Callback` | `function` | `nil` | Выполняется при щелчке по кнопке. **Не принимает аргументов.** |
| `Buttons` | `table` | `nil` | Встроенные кнопки, отображаемые в строке. |
| `TitleGradient` | `table` | `nil` | Градиент, применяемый к тексту заголовка. |
| `DescGradient` | `table` | `nil` | Градиент, применяемый к тексту описания. |

::: info Сигнатура callback
`Callback` у Button **не принимает аргументов** — это обычный обработчик действия. Если вам нужно реагировать на значение, используйте [Toggle](/ru/elements/toggle) или [Dropdown](/ru/elements/dropdown).
:::

Button также наследует конфигурацию [общей базы](/ru/elements/#общая-база) (`Image`, `Thumbnail`, градиенты, токены rich-text в `Title`/`Desc` и так далее).

## Методы

### `Button:Highlight()`

Кратко подсвечивает кнопку, чтобы привлечь внимание пользователя.

```lua
local btn = myTab:Button({ Title = "Notice me", Callback = function() end })
btn:Highlight()
```

### `Button:Lock()` / `Button:Unlock()`

Блокирует или разблокирует кнопку. Заблокированная кнопка показывает оверлей и игнорирует щелчки.

```lua
btn:Lock()
btn:Unlock()
```

### `Button:SetTitle(text)` / `Button:SetDesc(text)` / `Button:SetIcon(icon)`

Обновляет заголовок, описание или иконку во время выполнения.

```lua
btn:SetTitle("Updated title")
btn:SetDesc("Updated description")
btn:SetIcon("check")
```

### `Button:SetButtons(buttons)` / `Button:GetButton(key)` / `Button:GetButtons()`

Управляет встроенными кнопками, отображаемыми в строке. `SetButtons` заменяет map, `GetButton` возвращает одну по ключу, а `GetButtons` возвращает их все.

### `Button:Destroy()`

Удаляет кнопку из её контейнера.

## Примеры

### Базовая и цветная

```lua
myTab:Button({
    Title = "Highlight Button",
    Icon = "mouse",
    Callback = function()
        print("clicked highlight")
    end
})

myTab:Button({
    Title = "Blue Button",
    Desc = "With description",
    Color = Color3.fromHex("#305dff"),
    Icon = "",
    Callback = function() end
})
```

### Выравнивание иконки и содержимого

```lua
myTab:Button({
    Title = "Left Icon",
    Desc = "Icon aligned to the left",
    Icon = "mouse",
    IconAlign = "Left",
    Justify = "Center",
    Callback = function() end
})
```

### Тематические и цветные иконки

```lua
myTab:Button({
    Title = "Themed Icon",
    Desc = "Icon follows theme colors",
    Icon = "palette",
    IconThemed = true,
    Callback = function() end
})

myTab:Button({
    Title = "Colored Icon",
    Desc = "Icon tinted with custom color",
    Icon = "mouse-pointer-click",
    Color = Color3.fromHex("#f57c00"),
    Callback = function() end
})
```

### Заблокированная

```lua
myTab:Button({
    Title = "Button",
    Desc = "Button example",
    Locked = true
})
```

### Обновление из кода

Сохраните возвращённый модуль и обновляйте его из другой кнопки. `Highlight()` привлекает внимание к изменению.

```lua
local progBtn = myTab:Button({
    Title = "Programmatic Button",
    Desc = "Will be updated by code",
    Icon = "edit",
    Callback = function() end
})

myTab:Button({
    Title = "Update Above",
    Desc = "SetTitle and SetDesc",
    Icon = "chevron-right",
    Callback = function()
        progBtn:SetTitle("Programmatic Button (Updated)")
        progBtn:SetDesc("Updated by code")
        progBtn:Highlight()
    end
})
```

### Варианты UI-кнопок через Dialog

Кнопки внутри `Window:Dialog` поддерживают оформление `Variant` — `"Primary"`, `"Secondary"` и `"White"`.

```lua
myTab:Button({
    Title = "Show UI Button Variants",
    Desc = "Opens dialog with Primary/Secondary/White",
    Icon = "square-menu",
    Callback = function()
        Window:Dialog({
            Title = "UI Button Variants",
            Content = "Demonstrates button variants.",
            Buttons = {
                { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
                { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
                { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
            }
        })
    end
})
```

::: tip
Задайте `Icon = ""`, чтобы отобразить кнопку вообще без иконки — удобно для центрированных кнопок действия только с текстом.
:::
