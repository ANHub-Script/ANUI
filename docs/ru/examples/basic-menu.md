# Базовое меню

Полное стартовое меню с подробными комментариями, которое можно скопировать, вставить и запустить. Оно создаёт окно с двумя вкладками, набор самых распространённых элементов, section для группировки и уведомление, вызываемое из button.

## Скрипт

```lua
-- 1. Загрузите ANUI в local с именем `ANUI`.
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

-- 2. Создайте окно. Существовать может только ОДНО окно.
local Window = ANUI:CreateWindow({
    Title = "My Hub",                      -- заголовок в верхней панели
    Author = "by you",                     -- подзаголовок под заголовком
    Icon = "rbxassetid://84366761557806",  -- иконка верхней панели (asset id или имя иконки Lucide)
    Folder = "MyHub",                      -- папка на диске для конфигураций/ключей (хранится в ANUI/MyHub)
    OpenButton = {                         -- плавающая кнопка, которая снова открывает закрытое окно
        Title = "My Hub",
        Enabled = true,
        Draggable = true,
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
    },
})

-- 3. Добавьте вкладки. Каждая вкладка содержит элементы и появляется в боковой панели.
local Main = Window:Tab({ Title = "Main", Icon = "house" })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

-- 4. Paragraph — это блок rich-text, отлично подходит как вступление в начале вкладки.
Main:Paragraph({
    Title = "Welcome",
    Desc = "This starter menu shows the most common ANUI elements.",
})

-- Toggle — callback получает BOOLEAN (новое состояние вкл/выкл).
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Value = false,
    Callback = function(state) -- state: boolean
        print("Auto Farm:", state)
    end,
})

-- Slider — callback получает ФОРМАТИРОВАННУЮ СТРОКУ (значение, отформатированное по шагу).
Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: форматированная строка
        print("Walk Speed:", value)
    end,
})

-- 5. Section группирует связанные элементы под сворачиваемым заголовком.
--    Это контейнер, поэтому элементы вы создаёте у самого section.
local combat = Main:Section({ Title = "Combat" })

-- Dropdown — callback с одиночным выбором получает выбранное значение (здесь строку).
combat:Dropdown({
    Title = "Weapon",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value) -- value: выбранный элемент
        print("Weapon:", value)
    end,
})

-- Keybind — callback получает ИМЯ КЛАВИШИ в виде строки (напр. "G").
combat:Keybind({
    Title = "Attack Key",
    Value = "G",
    Callback = function(key) -- key: строка с именем клавиши
        print("Attack bound to:", key)
    end,
})

-- 6. Button выполняет callback БЕЗ АРГУМЕНТОВ. Здесь он вызывает уведомление.
Settings:Button({
    Title = "Say Hello",
    Icon = "bell",
    Callback = function() -- без аргументов
        ANUI:Notify({
            Title = "Hello!",
            Content = "Welcome to ANUI",
            Icon = "bell",
            Duration = 3,
        })
    end,
})
```

## Что делает каждая часть

- **Строка загрузки** — подтягивает библиотеку и присваивает её `ANUI`. Каждый пример начинается именно так.
- **`ANUI:CreateWindow`** — возвращает `Window`, на котором вы всё строите. `Folder` — это место, где на диске лежат конфигурации и ключи; `OpenButton` добавляет перетаскиваемую плавающую кнопку, которая снова открывает окно. См. [Настройку окна](/ru/guide/window-configuration).
- **`Window:Tab`** — каждая вкладка одновременно и страница в боковой панели, и контейнер для элементов.
- **Элементы** — создаются вызовом метода у контейнера (Tab или Section). Сохраните возвращённое значение, если хотите обновлять элемент позже.
- **`Main:Section`** — сворачиваемый контейнер, предоставляющий те же методы элементов, что и Tab, так что вы можете группировать связанные элементы управления.
- **`ANUI:Notify`** — показывает toast. Поле с текстом содержимого — `Content` (а не `Desc`), а поле иконки — `Icon`.

::: tip Изучите каждый элемент
У каждого элемента есть своя страница с полной таблицей config и методами: [Toggle](/ru/elements/toggle), [Slider](/ru/elements/slider), [Dropdown](/ru/elements/dropdown), [Button](/ru/elements/button), [Keybind](/ru/elements/keybind), [Paragraph](/ru/elements/paragraph) и [Section](/ru/elements/section). Изучите их все в [Обзоре элементов](/ru/elements/).
:::
