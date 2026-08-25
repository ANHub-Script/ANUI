# Paragraph

Блок форматированного текста для заголовков, заметок и описаний. Построен на основе [общей базы](/ru/elements/#общая-база) с отключённым наведением, поэтому отображается как статичный контент — а также служит лёгким контейнером, к которому можно прикреплять дочерние элементы.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Paragraph({
    Title = "Toggle Examples",
    Desc = "This tab showcases all supported Toggle features: classic toggle, checkbox variant, per-item icons, default values, locking, and programmatic updates."
})
```

## Конфигурация

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `"Paragraph"` | Текст заголовка. Поддерживает [токены rich-text](/ru/elements/#rich-text-в-title-desc). |
| `Desc` | `string` | `nil` | Текст тела. Поддерживает токены rich-text и многострочность через `\n`. |
| `Locked` | `boolean` | `false` | Отображает оверлей блокировки. |
| `Images` | `table` | `nil` | Массив объектов карточек, отображаемых как сетка карточек с изображениями (см. ниже). |
| `ImageSize` | `UDim2` | `UDim2.fromOffset(70, 70)` | Размер каждой карточки с изображением. |
| `Buttons` | `table` | `nil` | Массив `{ Title, Icon, Callback }`, отображаемый как **сложенные стопкой кнопки во всю ширину** под текстом. |

### Объекты карточек с изображениями

Каждый элемент в `Images` — это таблица:

| Field | Type | Описание |
| --- | --- | --- |
| `Title` | `string` | Подпись карточки. |
| `Quantity` | `string` | Значок количества (напр. `"244x"`). |
| `Image` | `string` | Asset id (`rbxassetid://…`) или имя иконки. |
| `Gradient` | `ColorSequence` | Фоновый градиент для карточки. |
| `Callback` | `function` | Выполняется при клике по карточке. |

::: info Два вида `Buttons`
Конфигурация `Buttons` здесь отображает **сложенные стопкой кнопки во всю ширину** под текстом параграфа (каждая `{ Title, Icon, Callback }`). Это отличается от встроенной **map** `Buttons` общей базы, которую другие элементы отображают внутри своей строки.
:::

Paragraph наследует `Image`, градиенты, токены rich-text, блокировку и подсветку от [общей базы](/ru/elements/#общая-база). Наведение всегда отключено.

## Методы

### `Paragraph:SetTitle(text)` / `Paragraph:SetDesc(text)`

Обновляет сохранённые поля `Title` / `Desc` параграфа.

```lua
myParagraph:SetTitle("Updated heading")
myParagraph:SetDesc("Updated body text.")
```

::: details Обновление видимого текста
`:SetTitle` / `:SetDesc` обновляют Lua-поля элемента. Чтобы изменить текст, уже отображённый на экране, используйте собственные сеттеры базового ParagraphFrame.
:::

### `Paragraph:SetViewport(model, cameraOffset?)`

Отображает `ViewportFrame` размером 95×95, показывающий 3D-предпросмотр `model`, с необязательным `cameraOffset`.

```lua
myParagraph:SetViewport(workspace.SomeModel)
```

## Примеры

### Многострочное описание

Используйте `\n`, чтобы разбить описание на несколько строк.

```lua
myTab:Paragraph({
    Title = "Rank Information",
    Desc = "Current Rank: S-Class\nPower: 500,000"
})
```

### Как лёгкий контейнер

Объект Paragraph предоставляет те же методы создания элементов, что и Tab, поэтому вы можете прикреплять дочерние элементы прямо к нему — удобно для группировки элементов управления под заголовком.

```lua
local group = myTab:Paragraph({
    Title = "Yen Upgrades",
    Desc = "Upgrade stats using Yen currency"
})

group:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" })
group:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" })
group:Button({ Title = "Rank Up", Icon = "arrow-up-circle" })
```

### Сетка карточек с изображениями

```lua
myTab:Paragraph({
    Title = "Inventory",
    ImageSize = UDim2.fromOffset(70, 70),
    Images = {
        {
            Title = "World Box",
            Quantity = "244x",
            Image = "rbxassetid://84366761557806",
            Gradient = ColorSequence.new(Color3.fromHex("#C042FF"), Color3.fromHex("#8E24AA")),
            Callback = function() print("World Box") end
        },
        {
            Title = "Zone Key",
            Quantity = "3x",
            Image = "key",
            Gradient = ColorSequence.new(Color3.fromHex("#29B6F6"), Color3.fromHex("#0288D1")),
            Callback = function() print("Zone Key") end
        },
    }
})
```

### Сложенные стопкой кнопки

```lua
myTab:Paragraph({
    Title = "ANHUB Discord",
    Desc = "Members: 1,234\nOnline: 567",
    Buttons = {
        {
            Title = "Copy link",
            Icon = "link",
            Callback = function()
                setclipboard("https://discord.gg/bUkCZvmrpH")
            end
        }
    }
})
```
