# Toggle

Переключатель on/off, который сообщает boolean своему callback. По умолчанию Toggle отображается как анимированный слайдер, либо как checkbox через `Type = "Checkbox"`.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})
```

## Конфигурация

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `"Toggle"` | Основная подпись. Поддерживает [токены rich-text](/ru/elements/#rich-text-в-title-desc). |
| `Desc` | `string` | `nil` | Необязательное описание под заголовком. |
| `Value` | `boolean` | `false` | Начальное состояние. |
| `Type` | `string` | `"Toggle"` | `"Toggle"` (анимированный слайдер) или `"Checkbox"`. |
| `Icon` | `string` | `nil` | Иконка, отображаемая внутри ползунка слайдера. |
| `IconSize` | `number` | `23` | Размер иконки ползунка, в пикселях. |
| `Image` | `string` \| `table` | `nil` | Изображение с выравниванием по левому краю (asset id или таблица карточки). |
| `ImageSize` | `number` | `30` | Размер левого изображения, в пикселях. |
| `Thumbnail` | `string` | `nil` | Большое изображение-миниатюра. |
| `ThumbnailSize` | `number` | `80` | Размер миниатюры, в пикселях. |
| `Locked` | `boolean` | `false` | Оверлей блокировки; блокирует взаимодействие **и** отключает callback. |
| `Disabled` | `boolean` | `false` | Блокирует только взаимодействие пользователя (callback по-прежнему срабатывает из кода). |
| `Callback` | `function` | `nil` | Выполняется при изменении. **Принимает новое значение boolean.** |
| `Flag` | `string` | `nil` | Ключ сохранения конфигурации. См. [Конфигурация и флаги](/ru/features/config-and-flags). |
| `Buttons` | `table` | `nil` | Встроенные кнопки, отображаемые в строке. |
| `TitleGradient` | `table` | `nil` | Градиент, применяемый к тексту заголовка. |
| `DescGradient` | `table` | `nil` | Градиент, применяемый к тексту описания. |

::: info Locked vs Disabled
`Locked` показывает оверлей блокировки, блокирует взаимодействие пользователя **и** не даёт callback выполниться. `Disabled` блокирует только взаимодействие *пользователя* — вы по-прежнему можете изменить значение из кода через `:Set(...)`, и callback выполнится. Используйте `:Lock()`/`:Unlock()` и `:Disable()`/`:Enable()`, чтобы переключать эти состояния во время выполнения.
:::

Toggle также наследует конфигурацию и методы [общей базы](/ru/elements/#общая-база).

## Методы

### `Toggle:Set(value, isCallback?, isAnimated?, force?)`

Устанавливает состояние переключателя из кода.

- `value` (`boolean`) — новое состояние.
- `isCallback` (`boolean`, необязательно) — выполнить `Callback` для этого изменения.
- `isAnimated` (`boolean`, необязательно) — анимировать переход ползунка.
- `force` (`boolean`, необязательно) — принудительно применить изменение.

```lua
myToggle:Set(true, true)          -- включить и выполнить callback
myToggle:Set(false, false, false) -- выключить тихо, без анимации
```

### `Toggle:Lock(text?)` / `Toggle:Unlock()`

Блокирует или разблокирует переключатель. Необязательный аргумент `text` задаёт подпись оверлея.

```lua
myToggle:Lock("Premium only")
myToggle:Unlock()
```

### `Toggle:Disable()` / `Toggle:Enable()`

Отключает или снова включает взаимодействие *пользователя* без оверлея блокировки. В отличие от `Lock`, callback по-прежнему выполняется, когда вы задаёте значение из кода.

### `Toggle:SetMainImage(image, size)`

Обновляет изображение с выравниванием по левому краю и его размер.

```lua
myToggle:SetMainImage("rbxassetid://84366761557806", 24)
```

### Базовые методы

Toggle также поддерживает `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` и `:Destroy` из [общей базы](/ru/elements/#общие-методы).

## Примеры

### Базовый и с описанием

```lua
myTab:Toggle({
    Title = "Basic Toggle",
    Desc = "Standard toggle with animated slider (drag or click).",
    Callback = function(v)
        print("Basic Toggle:", v)
    end
})
```

### С изображением слева

```lua
myTab:Toggle({
    Title = "Toggle with Left Image",
    Desc = "Image on the left, centered between title and desc.",
    Image = "rbxassetid://84366761557806",
    ImageSize = 24,
    Callback = function(v) print(v) end
})
```

### С иконкой на ползунке и включённый по умолчанию

```lua
myTab:Toggle({
    Title = "Toggle with Icon",
    Desc = "Shows an icon inside the slider when toggled.",
    Icon = "mouse",
    IconSize = 15,
    Value = true,
    Callback = function(v) print(v) end
})
```

### Вариант checkbox

```lua
myTab:Toggle({
    Title = "Checkbox",
    Desc = "Checkbox variant of toggle.",
    Type = "Checkbox",
    Callback = function(v) print(v) end
})

myTab:Toggle({
    Title = "Checkbox (Default ON)",
    Type = "Checkbox",
    Value = true,
    Callback = function(v) print(v) end
})
```

### Заблокированный

```lua
myTab:Toggle({
    Title = "Locked Toggle",
    Desc = "Locked state prevents user interaction.",
    Locked = true,
    Callback = function(v) print(v) end
})
```

### Обновление из кода

```lua
local progToggle = myTab:Toggle({
    Title = "Programmatic Toggle",
    Desc = "Demonstrates using Set() and updating title/desc via code.",
    Value = false,
    Callback = function(v) print("Programmatic Toggle:", v) end
})

myTab:Button({
    Title = "Turn ON",
    Callback = function()
        progToggle:Set(true, true)
        progToggle:SetTitle("Programmatic Toggle (ON)")
        progToggle:SetDesc("Toggled on by code.")
    end
})

myTab:Button({
    Title = "Turn OFF (no animation)",
    Callback = function()
        progToggle:Set(false, true, false)
        progToggle:SetTitle("Programmatic Toggle (OFF)")
        progToggle:SetDesc("Toggled off by code without animation.")
    end
})
```

### Сохранение через Flag

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(v) print(v) end
})
```

Значение сохраняется и восстанавливается автоматически, как только активна конфигурация — см. [Конфигурация и флаги](/ru/features/config-and-flags).
