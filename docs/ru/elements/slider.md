# Slider

Перетаскиваемый числовой слайдер с необязательным шагом и ручным вводом текста. Значение можно ограничить, задать ему шаг и отформатировать как целое число или число с плавающей точкой.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        print("Volume:", value)
    end
})
```

## Конфигурация

Диапазон можно задать либо таблицей `Value`, либо отдельными полями `Min` / `Max` / `Default`.

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `"Slider"` | Основная подпись. Поддерживает [токены rich-text](/ru/elements/#rich-text-в-title-desc). |
| `Desc` | `string` | `nil` | Необязательное описание под заголовком. |
| `Value` | `table` | `nil` | Таблица диапазона `{ Min, Max, Default }`. Альтернатива полям ниже. |
| `Min` | `number` | `0` | Нижняя граница (если не используется `Value`). |
| `Max` | `number` | `100` | Верхняя граница (если не используется `Value`). |
| `Default` | `number` | `0` | Начальное значение (если не используется `Value`). |
| `Step` | `number` | `1` | Шаг между позициями. **Дробный** шаг (напр. `0.1`) переводит слайдер в режим float. |
| `Locked` | `boolean` | `false` | Отображает оверлей блокировки и блокирует взаимодействие. |
| `Callback` | `function` | `nil` | Выполняется при изменении. **Принимает форматированную строку** (см. ниже). |
| `Flag` | `string` | `nil` | Ключ сохранения конфигурации. См. [Конфигурация и флаги](/ru/features/config-and-flags). |
| `Buttons` | `table` | `nil` | Встроенные кнопки, отображаемые в строке. |
| `TitleGradient` | `table` | `nil` | Градиент, применяемый к тексту заголовка. |
| `DescGradient` | `table` | `nil` | Градиент, применяемый к тексту описания. |

::: warning Аргумент callback — строка
Значение, передаваемое в `Callback`, — это **форматированная строка**, а не число. Целочисленные слайдеры получают округлённое вниз целое число (`"50"`); слайдеры float (дробный `Step`) получают строку `"%.2f"` (`"0.50"`). Преобразуйте её через `tonumber(value)`, прежде чем выполнять любые вычисления.
:::

Slider также наследует конфигурацию и методы [общей базы](/ru/elements/#общая-база).

## Форматирование значения и snapping

- **Snapping** — исходная позиция притягивается к ближайшему шагу: `floor(raw / Step + 0.5) * Step`.
- **Integer vs float** — целочисленный `Step` округляет значение вниз до целого; дробный `Step` форматирует его через `"%.2f"`.
- **Ручной ввод** — значение также является текстовым полем. Щёлкните по нему, введите число и нажмите **Enter**, чтобы применить.
- **Сохранение** — когда задан `Flag`, конфигурация хранит `Value.Default` в виде форматированной строки.

## Методы

### `Slider:Set(value, input?)`

Устанавливает значение слайдера из кода. `value` — число внутри диапазона; `input?` — необязательный флаг, используемый когда изменение приходит из поля ручного ввода.

```lua
mySlider:Set(75)
```

### `Slider:SetMin(n)`

Обновляет нижнюю границу слайдера.

```lua
mySlider:SetMin(10)
```

### `Slider:SetMax(n)`

Обновляет верхнюю границу слайдера.

```lua
mySlider:SetMax(200)
```

### `Slider:Lock()` / `Slider:Unlock()`

Блокирует или разблокирует слайдер.

```lua
mySlider:Lock()
mySlider:Unlock()
```

## Примеры

### Целочисленный слайдер (Volume 0–100)

Не забудьте преобразовать строковый аргумент, прежде чем использовать его как число.

```lua
myTab:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        local n = tonumber(value) -- value — строка вида "50"
        print("Volume:", n)
    end
})
```

### Слайдер float (дробный Step)

`Step` в `0.1` переводит слайдер в режим float, поэтому callback получает значения вида `"0.50"`.

```lua
myTab:Slider({
    Title = "Brightness",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(value)
        print("Brightness:", value) -- "0.50"
    end
})
```

### Сохранение через Flag

```lua
myTab:Slider({
    Title = "Slider",
    Flag = "SliderTest",
    Step = 1,
    Value = { Min = 20, Max = 120, Default = 70 },
    Callback = function(value)
        print(value)
    end
})
```

### Управление из кода

```lua
local speed = myTab:Slider({
    Title = "Speed",
    Value = { Min = 0, Max = 100, Default = 20 },
    Callback = function(value) print(value) end
})

speed:Set(60)     -- переместить ручку на 60
speed:SetMax(150) -- расширить диапазон
```
