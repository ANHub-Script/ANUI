# Category

Горизонтальная прокручиваемая полоса опций, которая работает как переключатель под-вкладок внутри вкладки. Выберите опцию, а затем в callback покажите соответствующую группу элементов, скрыв остальные — компактный способ разместить множество «страниц» элементов управления в одной вкладке.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })

myTab:Category({
    Title = "Select Category",
    Default = "Weapons",
    Options = {
        { Title = "Weapons", Icon = "sword" },
        { Title = "Armor",   Icon = "shield" },
        { Title = "Potions", Icon = "flask-round" },
    },
    Callback = function(selected)
        print("Selected category:", selected)
    end,
})
```

## Конфигурация

Поля, управляющие поведением:

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | Подпись, отображаемая над полосой опций. |
| `Desc` | `string` | `nil` | Необязательное описание под заголовком. |
| `Options` | `array` | `{}` | Доступные для выбора опции. Каждая запись — **строка** или **таблица опции** (см. ниже). |
| `Default` | `string` | первая опция | Опция, выбранная при создании. |
| `Callback` / `OnChanged` | `function` | `nil` | Выполняется при изменении выбора. **Получает имя выбранной опции (string).** |

### Записи опций

Каждая запись в `Options` — это либо обычная строка, либо таблица:

| Field | Type | Описание |
| --- | --- | --- |
| `Title` / `Name` / `Value` / `[1]` | `string` | Имя опции — значение, передаваемое в callback. |
| `Icon` / `Image` | `string` | Необязательная иконка (имя Lucide или `rbxassetid://…`). |
| `IconSize` | `number` | Переопределение размера иконки для отдельной опции. |
| `Desc` | `string` | Необязательное описание для отдельной опции. |

Опции также могут содержать детальные поля иконок `ScaleType`, `KeepAspect` / `Native`, `NativeSize` и `Tint`.

### Внешний вид и компоновка

Все они необязательны; значения по умолчанию подобраны так, чтобы соответствовать остальному интерфейсу.

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Height` | `number` | `45` | Высота всей полосы. |
| `ButtonHeight` | `number` | `32` | Высота каждой кнопки опции. |
| `IconSize` | `number` | `18` | Размер иконки опции по умолчанию. |
| `TextSize` | `number` | `14` | Размер текста подписи опции. |
| `Radius` | `number` | `8` | Радиус углов кнопок опций. |
| `Gap` / `Padding` | `number` | `8` | Расстояние между кнопками опций. |
| `SidePadding` | `number` | `12` | Отступы у левого/правого краёв полосы. |
| `ScrollSpeed` | `number` | `35` | Скорость горизонтальной прокрутки. |
| `Transparency` | `number` | `0.5` | Прозрачность фона неактивных кнопок. |
| `AutoCapture` | `boolean` | `true` | Автоматически регистрировать элементы, созданные после Category, в текущую опцию (см. ниже). |
| `Sticky` | `boolean` | `nil` (auto) | Закреплять полосу при прокрутке вкладки. |
| `ZIndex` | `number` | `6` | Порядок отрисовки полосы. |

::: details Расширенные настройки тегов и иконок
`ActiveTag` (`"Toggle"`), `InactiveTag` (`"Button"`) и `TextTag` (`"Text"`) выбирают теги темы, используемые для оформления активных/неактивных кнопок и их текста. `IconScaleType`, `IconKeepAspect` (`true`), `IconAutoWidth` (`true`) и `TintIcon` (auto) точно настраивают отрисовку иконок, тогда как `ContentPadding` (`5`) и `AlignWithContent` (`true`) управляют тем, как полоса выравнивается с элементами под ней.
:::

## Методы

### `Category:Select(name, silent?)`

Выбирает опцию по имени. Передайте `silent = true`, чтобы обновить выбор без вызова callback. Имеет псевдоним `Category:SetValue(name, silent?)`.

```lua
category:Select("Armor")
category:Select("Potions", true) -- без callback
```

### `Category:GetSelected()`

Возвращает имя выбранной в данный момент опции.

```lua
print(category:GetSelected())
```

### `Category:SetCallback(fn)`

Заменяет callback изменения.

```lua
category:SetCallback(function(name) print("now on", name) end)
```

### `Category:Add(name, ...)`

Регистрирует один или несколько уже существующих элементов в опции `name`, чтобы они показывались/скрывались вместе с ней.

### `Category:Remove(item)`

Отменяет регистрацию ранее добавленного элемента.

### `Category:GetElements(name?)`

Возвращает элементы, зарегистрированные в опции, или все элементы, если `name` не указан.

### `Category:Refresh()`

Перестраивает полосу опций после изменения её опций или элементов.

### `Category:Capture(name)` / `Category:StopCapture()`

Начинает захват вновь создаваемых элементов в опцию `name` и останавливает захват. Это ручная форма `AutoCapture`.

### `Category:With(name, builder)`

Выполняет `builder` и регистрирует каждый созданный им элемент в опции `name`.

```lua
category:With("Weapons", function()
    myTab:Toggle({ Title = "Auto Swing" })
    myTab:Slider({ Title = "Range", Value = { Min = 0, Max = 50, Default = 10 } })
end)
```

### `Category:AddOption(option, order?)`

Добавляет новую доступную для выбора опцию, при необходимости на позицию `order`.

### `Category:RemoveOption(name)`

Удаляет опцию по имени.

### `Category:SetOptions(options, newDefault?)`

Заменяет все опции, при необходимости выбирая `newDefault`.

### `Category:GetOptions()`

Возвращает текущие опции.

### `Category:SetHeight(h)`

Устанавливает высоту полосы.

### `Category:Destroy()`

Удаляет Category.

## Шаблон показа/скрытия

::: tip Типичное использование
Обычный шаблон — создать Category со своими опциями, а затем в callback **показать элементы выбранной опции и скрыть остальные**. Вы можете отслеживать элементы самостоятельно и переключать `.Visible` у каждого, либо опереться на `AutoCapture` (включён по умолчанию), который привязывает каждый элемент, созданный *после* Category, к текущей опции, так что он управляет видимостью за вас. `Category:With(name, builder)` и `Category:Capture(name)` / `Category:StopCapture()` дают явный контроль над этим захватом.
:::

Пример ниже строит небольшую «Upgrade System»: таблица `Categories` хранит элементы для каждой опции, вспомогательная функция скрывает их при создании, а callback показывает только элементы выбранной опции.

```lua
local UpgradeTab = Window:Tab({ Title = "Upgrade System", Icon = "hammer" })

-- Храним элементы по опциям, чтобы их можно было показывать/скрывать
local Categories = { Yen = {}, Token = {}, Rank = {} }

-- Находим корневой фрейм элемента (работает для разных типов элементов)
local function GetElementFrame(element)
    if element.ElementFrame then
        return element.ElementFrame
    elseif element.UIElements and element.UIElements.Main then
        return element.UIElements.Main
    end
    for _, value in pairs(element) do
        if type(value) == "table" and value.UIElements and value.UIElements.Main then
            return value.UIElements.Main
        end
    end
end

-- Регистрируем элемент в категории и скрываем его по умолчанию
local function AddElement(category, element)
    table.insert(Categories[category], element)
    local frame = GetElementFrame(element)
    if frame then frame.Visible = false end
    return element
end

-- Показываем только элементы выбранной категории
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then frame.Visible = (name == selected) end
        end
    end
end

UpgradeTab:Category({
    Title = "Select Category",
    Default = "Yen",
    Options = {
        { Title = "Yen",   Icon = "coins" },
        { Title = "Token", Icon = "layers" },
        { Title = "Rank",  Icon = "shield" },
    },
    Callback = OnCategoryChanged,
})

UpgradeTab:Space({ Columns = 1 })

-- Создаём и регистрируем элементы каждой категории
AddElement("Yen", UpgradeTab:Paragraph({ Title = "Yen Upgrades", Desc = "Upgrade stats using Yen" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" }))

AddElement("Token", UpgradeTab:Paragraph({ Title = "Token Upgrades", Desc = "Special upgrades using Tokens" }))
AddElement("Token", UpgradeTab:Toggle({ Title = "Yen Multiplier", Desc = "Cost: 5 Tokens | x1.5 Yen" }))

AddElement("Rank", UpgradeTab:Paragraph({ Title = "Rank Information", Desc = "Current Rank: S-Class" }))
AddElement("Rank", UpgradeTab:Button({ Title = "Rank Up", Icon = "arrow-up-circle" }))

-- Показываем категорию по умолчанию один раз при загрузке
OnCategoryChanged("Yen")
```

Более подробное руководство по этой технике смотрите в [рецепте страниц Category](/ru/examples/category-pages).
