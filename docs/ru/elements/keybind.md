# Keybind

Привязывает действие к клавише клавиатуры или кнопке мыши. Callback срабатывает глобально каждый раз, когда нажата привязанная клавиша, поэтому keybind работает в любом месте игры — а не только когда открыто окно.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Keybind({
    Title = "Keybind",
    Value = "F",
    Callback = function(key)
        print("Pressed:", key)
    end
})
```

## Конфигурация

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `"Keybind"` | Основная подпись. Поддерживает [токены rich-text](/ru/elements/#rich-text-в-title-desc). |
| `Desc` | `string` | `nil` | Необязательное описание под заголовком. |
| `Locked` | `boolean` | `false` | Отображает оверлей блокировки и блокирует взаимодействие. |
| `Value` | `string` | `"F"` | Начальная клавиша, задаётся строкой с **именем клавиши** (напр. `"F"`, `"G"`). |
| `CanChange` | `boolean` | `true` | Может ли пользователь переназначить клавишу щелчком. В текущей сборке фактически всегда включено. |
| `Callback` | `function` | `nil` | Выполняется при нажатии привязанной клавиши. **Принимает имя клавиши в виде строки.** |
| `Buttons` | `table` | `nil` | Встроенные кнопки, отображаемые в строке. |
| `TitleGradient` | `table` | `nil` | Градиент, применяемый к тексту заголовка. |
| `DescGradient` | `table` | `nil` | Градиент, применяемый к тексту описания. |
| `Flag` | `string` | `nil` | Ключ сохранения конфигурации. См. [Конфигурация и флаги](/ru/features/config-and-flags). |

::: info Как срабатывает и как переназначить
- Callback срабатывает **глобально** каждый раз, когда нажата привязанная клавиша — он подавляется только пока TextBox находится в фокусе, поэтому набор текста не запускает keybind.
- Аргумент callback — строка с **именем** клавиши: `Enum.KeyCode.F` сообщает `"F"`, а кнопки мыши сообщают `"MouseLeft"` или `"MouseRight"`.
- **Чтобы переназначить:** щёлкните по keybind. Он покажет `...` и захватит следующую нажатую вами клавишу.
:::

Keybind также наследует конфигурацию и методы [общей базы](/ru/elements/#общая-база).

## Методы

### `Keybind:Set(value)`

Задаёт привязанную клавишу по строке с её именем.

```lua
myKeybind:Set("G")
```

### `Keybind:Lock()` / `Keybind:Unlock()`

Блокирует или разблокирует keybind. Заблокированный keybind показывает оверлей и не может быть переназначен.

```lua
myKeybind:Lock()
myKeybind:Unlock()
```

### Базовые методы

Keybind также поддерживает `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` и `:Destroy` из [общей базы](/ru/elements/#общие-методы).

## Примеры

### Переназначение клавиши переключения окна

Поскольку callback передаёт вам имя клавиши, вы можете преобразовать его обратно в `Enum.KeyCode` через `Enum.KeyCode[key]` и сразу передать в `Window:SetToggleKey`.

```lua
myTab:Keybind({
    Flag = "KeybindTest",
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})
```

::: tip Сохранение привязки
Добавьте `Flag`, чтобы сохранять и восстанавливать привязанную клавишу между сессиями. См. [Конфигурация и флаги](/ru/features/config-and-flags).
:::
