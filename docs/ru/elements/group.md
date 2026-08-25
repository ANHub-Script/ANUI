# Group

Контейнер, который располагает свои дочерние элементы **горизонтально**, а не складывает их вертикально. Интерактивные элементы делят доступную ширину равномерно, тогда как [Space](/ru/elements/space) или [Divider](/ru/elements/divider) сохраняют свою фиксированную ширину. Как и Tab, Group предоставляет все методы создания элементов.

## Базовое использование

Создайте группу через `Tab:Group({})`, затем добавьте элементы в возвращённый контейнер:

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local row = myTab:Group({})
row:Button({ Title = "Save", Callback = function() end })
row:Button({ Title = "Load", Callback = function() end })
```

Обе кнопки отображаются рядом, каждая занимает половину строки.

## Конфигурация

`Group` не принимает никакой конфигурации — вызывайте `Tab:Group({})` с пустой таблицей.

## Создание элементов внутри группы

Group — это контейнер, поэтому каждый метод создания элементов (`Group:Button`, `Group:Toggle`, `Group:Dropdown`, …) работает на нём точно так же, как на Tab — см. [Обзор элементов](/ru/elements/). Каждый интерактивный дочерний элемент получает равную долю ширины строки; дочерние `Space` и `Divider` сохраняют свою фиксированную ширину вместо растягивания.

::: tip
Group хорошо сочетается с подписью [Paragraph](/ru/elements/paragraph), размещённой прямо над ней — используйте параграф как заголовок, описывающий строку элементов управления под ним.
:::

## Примеры

### Строка кнопок

```lua
local buttons = myTab:Group({})
buttons:Button({
    Title = "Primary",
    Color = Color3.fromHex("#305dff"),
    Icon = "mouse-pointer-click",
    Callback = function() end,
})
buttons:Button({ Title = "Secondary", Icon = "mouse", Callback = function() end })
buttons:Button({ Title = "Locked", Icon = "lock", Locked = true, Callback = function() end })
```

### Два dropdown рядом

```lua
myTab:Paragraph({ Title = "Dropdowns Group", Desc = "Two dropdowns grouped." })

local dropdowns = myTab:Group({})
dropdowns:Dropdown({
    Title = "Dropdown 1",
    Values = { "A", "B", "C" },
    Value = "A",
    Callback = function(v) print("Dropdown 1:", v) end,
})
dropdowns:Dropdown({
    Title = "Dropdown 2",
    Values = { { Title = "X", Desc = "First" }, { Title = "Y" }, { Title = "Z" } },
    SearchBarEnabled = true,
    Value = "Y",
    Callback = function(v) print("Dropdown 2:", v) end,
})
```

### Два slider рядом

```lua
myTab:Paragraph({ Title = "Sliders Group", Desc = "Two sliders grouped." })

local sliders = myTab:Group({})
sliders:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(v) print("Volume:", v) end,
})
sliders:Slider({
    Title = "Brightness",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(v) print("Brightness:", v) end,
})
```

::: info
Group — это контейнер компоновки, поэтому он не наследует интерактивные поведения общей базы — эти поведения принадлежат элементам, которые вы размещаете внутри него.
:::
