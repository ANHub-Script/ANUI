# Страницы категорий

Распространённый приём: одна вкладка, которая показывает несколько «страниц» элементов, переключаемых горизонтальной полосой сверху. Он строится на элементе [Category](/ru/elements/category). Рецепт ниже адаптирован из **Upgrade System** в демо.

## Как это работает

Category отрисовывает прокручиваемый ряд опций. Когда пользователь выбирает одну из них, её `Callback` вызывается с именем выбранной опции. Мы храним таблицу, которая сопоставляет каждое имя опции с принадлежащими ей элементами, и переключаем `.Visible` у каждого элемента так, чтобы отображалась только активная страница.

## 1. Отслеживайте элементы по категориям

Определите категории, вспомогательную функцию для поиска frame элемента и вспомогательную функцию, которая регистрирует элемент в категории (по умолчанию скрывая его).

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "My Hub", Folder = "MyHub" })
local Tab = Window:Tab({ Title = "Upgrades", Icon = "hammer" })

-- Одно хранилище элементов на каждую категорию.
local Categories = {
    Combat = {},
    Farming = {},
    Settings = {},
}

-- Добираемся до корневого frame элемента, чтобы переключать его видимость.
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
    return nil
end

-- Регистрируем элемент в категории и скрываем его в начале.
local function AddElement(categoryName, element)
    if Categories[categoryName] then
        table.insert(Categories[categoryName], element)
        local frame = GetElementFrame(element)
        if frame then
            frame.Visible = false
        end
    end
    return element
end

-- Показываем только элементы выбранной категории; остальные скрываем.
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        local isVisible = (name == selected)
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then
                frame.Visible = isVisible
            end
        end
    end
end
```

## 2. Добавьте полосу Category

Создайте Category с одной опцией на страницу. `Default` задаёт страницу, показываемую первой, а `Callback` запускает `OnCategoryChanged` каждый раз, когда пользователь переключается.

```lua
Tab:Category({
    Title = "Select Category",
    Default = "Combat",
    Options = {
        { Title = "Combat", Icon = "sword" },
        { Title = "Farming", Icon = "coins" },
        { Title = "Settings", Icon = "settings" },
    },
    Callback = OnCategoryChanged, -- получает имя выбранной опции (string)
})

Tab:Space({ Columns = 1 }) -- немного свободного места под полосой
```

## 3. Соберите каждую страницу и зарегистрируйте её элементы

Создавайте элементы как обычно, оборачивая каждый в `AddElement("<категория>", ...)`, чтобы он попал в нужное хранилище и изначально был скрыт.

```lua
-- Combat
AddElement("Combat", Tab:Paragraph({ Title = "Combat", Desc = "Fighting options" }))
AddElement("Combat", Tab:Toggle({ Title = "God Mode", Callback = function(v) print(v) end }))
AddElement("Combat", Tab:Slider({ Title = "Damage", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end }))

-- Farming
AddElement("Farming", Tab:Paragraph({ Title = "Farming", Desc = "Auto-farm options" }))
AddElement("Farming", Tab:Toggle({ Title = "Auto Farm", Callback = function(v) print(v) end }))
AddElement("Farming", Tab:Dropdown({ Title = "Target", Values = { "Coins", "Gems", "XP" }, Value = "Coins", Callback = function(v) print(v) end }))

-- Settings
AddElement("Settings", Tab:Paragraph({ Title = "Settings", Desc = "Menu settings" }))
AddElement("Settings", Tab:Toggle({ Title = "Auto Save", Callback = function(v) print(v) end }))
```

## 4. Покажите страницу по умолчанию

Category стартует на `Default`, поэтому вызовите `OnCategoryChanged` один раз, чтобы сразу скрыть остальные страницы.

```lua
OnCategoryChanged("Combat")
```

Вот и весь приём: переключение опций теперь меняет то, какая страница элементов видна.

## Альтернатива: встроенный захват

Category может отслеживать элементы за вас — вместо ручной таблицы `Categories`. При включённом `AutoCapture` (значение по умолчанию) элементы, созданные после Category, подключаются автоматически. Самый аккуратный способ — `:With(name, builder)`: всё, что создано внутри builder, назначается этой опции, а Category показывает/скрывает каждую группу при переключении:

```lua
local cat = Tab:Category({
    Title = "Select Category",
    Default = "Combat",
    Options = { "Combat", "Farming", "Settings" },
})

cat:With("Combat", function()
    Tab:Toggle({ Title = "God Mode", Callback = function(v) print(v) end })
    Tab:Slider({ Title = "Damage", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end })
end)

cat:With("Farming", function()
    Tab:Toggle({ Title = "Auto Farm", Callback = function(v) print(v) end })
end)

cat:With("Settings", function()
    Tab:Toggle({ Title = "Auto Save", Callback = function(v) print(v) end })
end)
```

::: tip
`:Capture(name)` / `:StopCapture()` делают то же самое без builder — заключите между ними любой диапазон создания элементов. Используйте `:GetElements(name?)`, чтобы прочитать, что именно отслеживает категория. Полный список методов смотрите на странице [Category](/ru/elements/category).
:::
