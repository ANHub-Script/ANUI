# Кнопка открытия

Кнопка открытия — это плавающая «пилюля», которая снова открывает ваш UI после того, как он был закрыт. Настройте её при создании окна или измените позже, во время работы.

## Настройка при создании

Передайте таблицу `OpenButton` в `CreateWindow`.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

## Настройка

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | — | Текст, отображаемый на кнопке. |
| `Icon` | `string` | — | Имя иконки или `rbxassetid://…`, отображаемое перед заголовком. |
| `Enabled` | `boolean` | — | Установите `false`, чтобы полностью отключить кнопку открытия. |
| `Position` | `UDim2` | — | Положение кнопки на экране. |
| `OnlyIcon` | `boolean` | `false` | Круглая кнопка только с иконкой (в стиле Delta); скрывает заголовок и ручку перетаскивания. |
| `Draggable` | `boolean` | — | Разрешить пользователю перетаскивать кнопку куда угодно. |
| `OnlyMobile` | `boolean` | — | Оставьте незаданным для режима «только мобильные»; укажите `false`, чтобы кнопка появлялась и на десктопе. |
| `CornerRadius` | `UDim` | `UDim.new(1, 0)` | Радиус скругления углов кнопки (по умолчанию полностью круглая). |
| `StrokeThickness` | `number` | `2` | Толщина обводки кнопки. |
| `Color` | `ColorSequence` | `#40c9ff → #e81cff` | Градиент обводки (stroke) кнопки. |
| `Size` | `UDim2` | auto | Размер кнопки. По умолчанию подстраивается под содержимое. |

::: info Значение OnlyMobile по умолчанию
Если вы не задаёте `OnlyMobile`, кнопка ведёт себя как **только для мобильных**. Укажите `OnlyMobile = false`, чтобы она отображалась и на десктопе — как в примере выше.
:::

::: tip Color — это градиент
`Color` принимает `ColorSequence`, а не `Color3` — это значение применяется как градиент к обводке кнопки. Создайте его через `ColorSequence.new(colorA, colorB)`.
:::

## Изменение во время работы

### `Window:EditOpenButton(config)`

Применяет изменения к кнопке открытия. Изменения **объединяются накопительно** — поля, которые вы не передали, сохраняют текущее значение.

```lua
Window:EditOpenButton({
    Title = "Open Menu",
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
})
```

## Методы кнопки открытия

Объект кнопки открытия доступен как `Window.OpenButtonMain`.

### `Window.OpenButtonMain:SetIcon(icon)`

Меняет иконку кнопки (имя иконки или `rbxassetid://…`).

```lua
Window.OpenButtonMain:SetIcon("menu")
```

### `Window.OpenButtonMain:Visible(visible)`

Показывает или скрывает кнопку.

```lua
Window.OpenButtonMain:Visible(false) -- скрыть
Window.OpenButtonMain:Visible(true)  -- показать
```

### `Window.OpenButtonMain:Edit(config)`

То же самое, что `Window:EditOpenButton` — объединяет переданный config с текущим. Используйте тот вариант, который лучше читается в вашем коде.

```lua
Window.OpenButtonMain:Edit({ Title = "Reopen" })
```

## Пример

Адаптировано из скрипта-примера: скруглённая перетаскиваемая «пилюля» с пользовательским заголовком и обводкой с градиентом от зелёного к жёлтому, отображаемая и на десктопе, и на мобильных.

```lua
local Window = ANUI:CreateWindow({
    Title = ".an hub | ANUI Library",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

Все остальные опции окна см. в [Настройке окна](/ru/guide/window-configuration).
