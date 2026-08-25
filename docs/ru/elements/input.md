# Input

Текстовое поле для получения строкового ввода — однострочное (`"Input"`) или многострочное (`"Textarea"`). Его callback получает текущий текст каждый раз, когда поле применяет изменение.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Input({
    Title = "Input",
    InputIcon = "mouse",
    Placeholder = "Enter Text...",
    Callback = function(text)
        print("Text:", text)
    end
})
```

## Конфигурация

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `"Input"` | Основная подпись. Поддерживает [токены rich-text](/ru/elements/#rich-text-в-title-desc). |
| `Desc` | `string` | `nil` | Необязательное описание под заголовком. |
| `Type` | `string` | `"Input"` | `"Input"` (одна строка) или `"Textarea"` (несколько строк). |
| `Locked` | `boolean` | `false` | Отображает оверлей блокировки и блокирует взаимодействие. |
| `InputIcon` | `string` \| `boolean` | `false` | Иконка, отображаемая внутри поля ввода. `false` — без иконки. |
| `Placeholder` | `string` | `"Enter Text..."` | Серая подсказка, отображаемая, когда поле пустое. |
| `Value` | `string` | `""` | Начальный текст. |
| `ClearTextOnFocus` | `boolean` | `false` | Автоматически очищает поле, когда оно получает фокус. |
| `Callback` | `function` | `nil` | Выполняется при применении. **Принимает текущий текст в виде строки.** |
| `Buttons` | `table` | `nil` | Встроенные кнопки, отображаемые в строке. |
| `TitleGradient` | `table` | `nil` | Градиент, применяемый к тексту заголовка. |
| `DescGradient` | `table` | `nil` | Градиент, применяемый к тексту описания. |
| `Flag` | `string` | `nil` | Ключ сохранения конфигурации. См. [Конфигурация и флаги](/ru/features/config-and-flags). |

::: info Сигнатура callback
`Callback` получает одну **строку** — текущий текст поля. Он выполняется, когда поле применяет изменение (фокус потерян или нажат Enter для однострочного ввода) и **один раз при инициализации** с начальным значением `Value`.
:::

Input также наследует конфигурацию и методы [общей базы](/ru/elements/#общая-база).

## Методы

### `Input:Set(value, isUserInput?)`

Задаёт тексту поля значение `value`. Необязательный флаг `isUserInput` отмечает изменение как исходящее от пользователя.

```lua
myInput:Set("hello")
```

### `Input:SetPlaceholder(value)`

Обновляет подсказку placeholder, отображаемую, пока поле пустое.

```lua
myInput:SetPlaceholder("Type a name...")
```

### `Input:Lock()` / `Input:Unlock()`

Блокирует или разблокирует поле ввода. Заблокированное поле показывает оверлей и игнорирует ввод с клавиатуры.

```lua
myInput:Lock()
myInput:Unlock()
```

### Базовые методы

Input также поддерживает `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` и `:Destroy` из [общей базы](/ru/elements/#общие-методы).

## Примеры

### Базовое с иконкой

```lua
myTab:Input({
    Title = "Input",
    InputIcon = "mouse"
})
```

### Textarea (несколько строк)

```lua
myTab:Input({
    Title = "Input Textarea",
    Type = "Textarea",
    InputIcon = "mouse"
})
```

### С описанием

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example"
})
```

### Заблокированное

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example",
    Locked = true
})
```

### Сохранение через Flag

```lua
myTab:Input({
    Flag = "InputTest",
    Title = "Input",
    Desc = "Input Description",
    Value = "Default value",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter text...",
    Callback = function(input)
        print("Text entered:", input)
    end
})
```

Значение сохраняется и восстанавливается автоматически, как только активна конфигурация — см. [Конфигурация и флаги](/ru/features/config-and-flags).
