# Colorpicker

Выбирает `Color3` — с необязательной прозрачностью — через полнофункциональный диалог выбора цвета. Callback срабатывает с выбранным цветом, когда пользователь применяет его.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Colorpicker({
    Title = "Colorpicker",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(color, transparency)
        print("Color:", color, "Transparency:", transparency)
    end
})
```

## Конфигурация

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `"Colorpicker"` | Основная подпись. Поддерживает [токены rich-text](/ru/elements/#rich-text-в-title-desc). |
| `Desc` | `string` | `nil` | Необязательное описание под заголовком. |
| `Locked` | `boolean` | `false` | Отображает оверлей блокировки и блокирует взаимодействие. |
| `Default` | `Color3` | `Color3.new(1, 1, 1)` (белый) | Начальный цвет, отображаемый в образце. |
| `Transparency` | `number` | `nil` | Начальная альфа. Указание любого числа включает слайдер и поле ввода альфы в picker. |
| `Callback` | `function` | `nil` | Выполняется при нажатии **Apply**. **Принимает `(color: Color3, transparency: number)`.** |
| `Buttons` | `table` | `nil` | Встроенные кнопки, отображаемые в строке. |
| `TitleGradient` | `table` | `nil` | Градиент, применяемый к тексту заголовка. |
| `DescGradient` | `table` | `nil` | Градиент, применяемый к тексту описания. |
| `Flag` | `string` | `nil` | Ключ сохранения конфигурации. См. [Конфигурация и флаги](/ru/features/config-and-flags). |

::: info Диалог picker
Щелчок по образцу открывает диалог с:
- картой **Saturation/Vibrance** и слайдером **Hue**,
- необязательным слайдером **alpha** (отображается только когда задан `Transparency`),
- полем ввода **Hex** (`#RRGGBB`) плюс полями **R / G / B** — и полем **Alpha**, когда включена прозрачность,
- кнопками **Cancel** и **Apply** — `Callback` срабатывает при нажатии **Apply**.

При сохранении в конфигурацию colorpicker сериализует своё hex-значение вместе с прозрачностью.
:::

Colorpicker также наследует конфигурацию и методы [общей базы](/ru/elements/#общая-база).

## Методы

### `Colorpicker:Update(color, transparency?)`

Задаёт текущий цвет (и необязательную прозрачность), обновляя образец.

```lua
myColorpicker:Update(Color3.fromRGB(255, 0, 0))
myColorpicker:Update(Color3.fromRGB(255, 0, 0), 0.5)
```

### `Colorpicker:Set(color, transparency?)`

Псевдоним для `:Update` — те же аргументы и поведение.

```lua
myColorpicker:Set(Color3.fromHex("#305dff"))
```

### `Colorpicker:Lock()` / `Colorpicker:Unlock()`

Блокирует или разблокирует colorpicker. Заблокированный colorpicker показывает оверлей и не может быть открыт.

```lua
myColorpicker:Lock()
myColorpicker:Unlock()
```

### Базовые методы

Colorpicker также поддерживает `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` и `:Destroy` из [общей базы](/ru/elements/#общие-методы).

## Примеры

### С прозрачностью и Flag

Задание `Transparency` (даже в `0`) включает управление альфой в диалоге. Тогда callback получает и цвет, и прозрачность.

```lua
myTab:Colorpicker({
    Flag = "ColorpickerTest",
    Title = "Colorpicker",
    Desc = "Colorpicker Description",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color, transparency)
        print("Background color:", color, transparency)
    end
})
```

Цвет и прозрачность сохраняются и восстанавливаются автоматически, как только активна конфигурация — см. [Конфигурация и флаги](/ru/features/config-and-flags).
