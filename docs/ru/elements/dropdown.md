# Dropdown

Список для выбора с поддержкой одиночного или множественного выбора, иконок для каждого элемента, описаний, разделителей и изображений. Без глобального callback он также работает как **меню действий**.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Dropdown({
    Title = "Basic",
    Values = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Value = "Option 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

## Конфигурация

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dropdown"` | Основная подпись. Поддерживает [токены rich-text](/ru/elements/#rich-text-в-title-desc). |
| `Desc` | `string` | `nil` | Необязательное описание под заголовком. |
| `Values` | `table` | `{}` | Список опций — строки или объекты элементов (см. ниже). `{ Type = "Divider" }` вставляет разделитель. |
| `Value` | `string` \| `table` | `nil` | Начальный выбор: строка, объект элемента или массив (для `Multi`). |
| `Multi` | `boolean` | `false` | Разрешает выбирать несколько элементов. |
| `AllowNone` | `boolean` | `false` | Разрешает снять выбор с последнего оставшегося элемента (полезнее всего с `Multi`). |
| `SearchBarEnabled` | `boolean` | `false` | Показывает строку поиска в верхней части меню. |
| `MenuWidth` | `number` | `nil` | Фиксированная ширина меню в пикселях. Не указывайте для автоподбора. |
| `Locked` | `boolean` | `false` | Отображает оверлей блокировки и блокирует взаимодействие. |
| `Image` | `string` \| `table` | `nil` | Изображение с выравниванием по левому краю в строке dropdown. |
| `ImageSize` | `number` \| `UDim2` | `30` | Размер изображения — число или `UDim2` для карточек с изображениями. |
| `ImagePadding` | `number` | `—` | Отступы вокруг изображений элементов. |
| `IconThemed` | `boolean` | `false` | Окрашивает иконку в текущий цвет темы. |
| `Color` | `Color3` \| `string` | `nil` | Цветной фон (имя темы или `Color3`). |
| `Callback` | `function` | `nil` | Выполняется при выборе. См. примечание о сигнатуре ниже. |
| `Flag` | `string` | `nil` | Ключ сохранения конфигурации. См. [Конфигурация и флаги](/ru/features/config-and-flags). |
| `Buttons` | `table` | `nil` | Встроенные кнопки, отображаемые в строке. |
| `TitleGradient` | `table` | `nil` | Градиент, применяемый к тексту заголовка. |
| `DescGradient` | `table` | `nil` | Градиент, применяемый к тексту описания. |

### Объекты элементов

Вместо обычных строк каждая запись в `Values` может быть таблицей:

| Field | Type | Описание |
| --- | --- | --- |
| `Title` | `string` | Подпись элемента. |
| `Desc` | `string` | Необязательное описание, отображаемое под заголовком. |
| `Icon` | `string` | Необязательная иконка для элемента. |
| `Images` | `table` | Массив id изображений / имён иконок либо таблиц карточек (`{ Card = true, Title, Quantity, Image, Gradient }`). |
| `Locked` | `boolean` | Отключает выбор именно этого элемента. |
| `Callback` | `function` | Действие для отдельного элемента, используется в **режиме меню** (см. ниже). |
| `Type` | `string` | Задайте `"Divider"` (без других полей), чтобы вставить разделитель между элементами. |

::: info Сигнатура callback — и режим меню
- **Одиночный выбор:** callback получает выбранное **значение** — `string` для строковых элементов или **исходный объект элемента** для объектов (читайте `option.Title` и т. д.).
- **Множественный выбор** (`Multi = true`): callback получает **массив** выбранных элементов.
- **Без глобального `Callback`:** dropdown превращается в **меню действий** — щелчок по элементу вместо этого выполняет `Callback` *этого элемента*.
:::

Dropdown также наследует конфигурацию и методы [общей базы](/ru/elements/#общая-база).

## Методы

### `Dropdown:Select(items)`

Устанавливает текущий выбор из кода. Передайте одно значение или массив, когда включён `Multi`.

```lua
myDropdown:Select("Blue")
myDropdown:Select({ "A", "C" }) -- multi
```

### `Dropdown:Refresh(values)`

Заменяет весь список опций новым массивом `values`.

```lua
myDropdown:Refresh({ "New 1", "New 2", "New 3" })
```

### `Dropdown:Edit(itemName, newData)`

Обновляет существующий элемент, найденный по его имени, полями из `newData`.

```lua
myDropdown:Edit("Option 1", { Title = "Option 1 (updated)", Icon = "check" })
```

### `Dropdown:EditDrop(target, newData)`

Редактирует сам контейнер dropdown, применяя `newData` к указанному `target`.

### `Dropdown:SetValueImage(img)` / `Dropdown:SetValueIcon(img)`

Задаёт изображение или иконку, отображаемую рядом с текущим выбранным значением.

### `Dropdown:SetMainImage(img, size)`

Обновляет изображение dropdown с выравниванием по левому краю и его размер.

### `Dropdown:Open()` / `Dropdown:Close()`

Открывает или закрывает меню. `Open()` работает как переключатель — вызов при открытом меню закроет его.

### `Dropdown:Display()`

Обновляет отображаемое значение (текст, иконку и изображение) для текущего выбора.

### `Dropdown:Lock(text?)` / `Dropdown:Unlock()`

Блокирует или разблокирует dropdown. Необязательный аргумент `text` задаёт подпись оверлея.

## Примеры

### Базовый список строк

```lua
myTab:Dropdown({
    Title = "Basic",
    Desc = "Simple list of string values with a global selection callback.",
    Values = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Value = "Option 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

### С иконками (объекты элементов)

Для объектов элементов callback получает **объект элемента** — читайте `option.Title`.

```lua
myTab:Dropdown({
    Title = "With Icons",
    Desc = "Each option is an object containing a title and an icon.",
    Values = {
        { Title = "Bird",     Icon = "bird" },
        { Title = "House",    Icon = "house" },
        { Title = "Settings", Icon = "settings" },
        { Title = "Trash",    Icon = "trash-2" },
    },
    Value = { Title = "Bird", Icon = "bird" },
    Callback = function(option)
        print("Selected:", option.Title)
    end
})
```

### С описаниями

```lua
myTab:Dropdown({
    Title = "With Descriptions",
    Values = {
        { Title = "Option A", Desc = "This is option A" },
        { Title = "Option B", Desc = "This is option B" },
        { Title = "Option C", Desc = "This is option C" },
    },
    Value = { Title = "Option A", Desc = "This is option A" },
    Callback = function(option) print(option.Title) end
})
```

### Multi-select

При `Multi = true` callback получает **массив** выбранных элементов.

```lua
myTab:Dropdown({
    Title = "Multi-Select",
    Desc = "Select multiple options (callback returns an array of selected items).",
    Values = {
        { Title = "Category A", Icon = "folder" },
        { Title = "Category B", Icon = "folder" },
        { Title = "Category C", Icon = "folder" },
        { Title = "Category D", Icon = "folder" },
    },
    Multi = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do
            table.insert(titles, v.Title)
        end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### Группировка разделителями

```lua
myTab:Dropdown({
    Title = "Divider Grouping",
    Desc = "Use Type = 'Divider' to split options into visually separated groups.",
    Values = {
        { Title = "Group 1 - A", Icon = "star" },
        { Title = "Group 1 - B", Icon = "star" },
        { Type = "Divider" },
        { Title = "Group 2 - A", Icon = "heart" },
        { Title = "Group 2 - B", Icon = "heart" },
    },
    Value = { Title = "Group 1 - A", Icon = "star" },
    Callback = function(option) print(option.Title) end
})
```

### Allow none (multi)

`AllowNone` позволяет множественному выбору вернуться к нулю выбранных элементов.

```lua
myTab:Dropdown({
    Title = "Multi (AllowNone)",
    Desc = "Multi-select with AllowNone lets you deselect the last remaining item.",
    Values = { { Title = "A" }, { Title = "B" }, { Title = "C" } },
    Value = "B",
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do table.insert(titles, v.Title) end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### Заблокированные элементы

```lua
myTab:Dropdown({
    Title = "Locked Items",
    Desc = "Per-item locking disables selection for specific options.",
    Values = {
        { Title = "Usable A" },
        { Title = "Locked B", Locked = true },
        { Title = "Usable C" },
    },
    Value = "Usable A",
    Callback = function(value)
        print("Selected:", typeof(value) == "table" and value.Title or value)
    end
})
```

### Своя ширина и строка поиска

```lua
myTab:Dropdown({
    Title = "Custom Width",
    Desc = "Manually define menu width instead of using auto-fit.",
    Values = { "Short", "Medium Option", "Veryyyyyyyy Long Option Name" },
    Value = "Short",
    MenuWidth = 250,
    SearchBarEnabled = true,
    Callback = function(value) print(value) end
})
```

### Выбор из кода

```lua
local colors = myTab:Dropdown({
    Title = "Programmatic Select",
    Values = { "Red", "Green", "Blue" },
    Value = "Red",
    Callback = function(value) print("Selected:", value) end
})

myTab:Button({
    Title = "Select 'Blue' via code",
    Callback = function()
        colors:Select("Blue")
    end
})
```

### Меню действий (callback для каждого элемента)

Полностью уберите глобальный `Callback` и задайте каждому элементу собственный `Callback` — dropdown будет вести себя как контекстное меню действий.

```lua
myTab:Dropdown({
    Title = "Advanced Actions",
    Desc = "No global callback: items behave like an action menu using per-item callbacks.",
    Values = {
        { Title = "New file",  Desc = "Create a new file",   Icon = "file-plus", Callback = function() print("New file") end },
        { Title = "Copy link", Desc = "Copy the file link",  Icon = "copy",      Callback = function() print("Copy link") end },
        { Type = "Divider" },
        { Title = "Delete file", Desc = "Permanently delete the file", Icon = "trash", Callback = function() print("Delete file") end },
    }
})
```

::: tip Сохранение выбора
Добавьте `Flag`, чтобы сохранять и восстанавливать выбранное значение между сессиями. См. [Конфигурация и флаги](/ru/features/config-and-flags).
:::
