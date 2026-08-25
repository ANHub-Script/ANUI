# Быстрый старт

Соберите своё первое меню ANUI шаг за шагом. В конце у вас будет окно с одной вкладкой, содержащей toggle, button и slider, плюс уведомление — полноценный работающий скрипт.

## 1. Загрузите ANUI

Каждый скрипт начинается с загрузки библиотеки в local с именем `ANUI`.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## 2. Создайте окно

`ANUI:CreateWindow` возвращает объект `Window`, в который вы добавляете всё остальное. `Folder` — это место, где на диске хранятся конфигурации и ключи.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})
```

Все опции см. в [Настройке окна](/ru/guide/window-configuration).

## 3. Добавьте вкладку

Вкладки содержат ваши элементы. Создайте одну с помощью `Window:Tab`.

```lua
local Main = Window:Tab({ Title = "Main", Icon = "house" })
```

## 4. Добавьте элементы

Добавляйте элементы, вызывая методы у вкладки. Обратите внимание на аргумент, который получает каждый callback:

- **Toggle** — callback получает `boolean` (новое состояние вкл/выкл).
- **Button** — callback **не получает аргументов**.
- **Slider** — callback получает **форматированную строку** (значение, отформатированное согласно его шагу).

```lua
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state) -- state: boolean
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "Do something",
    Callback = function() -- без аргументов
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: форматированная строка
        print("Walk Speed:", value)
    end
})
```

## 5. Покажите уведомление

`ANUI:Notify` показывает toast. Поле иконки — `Icon`; поле текста тела — `Content`.

```lua
ANUI:Notify({
    Title = "Hello!",
    Content = "Welcome to ANUI",
    Icon = "bell",
    Duration = 3,
})
```

## Полный скрипт

Собираем всё вместе:

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})

local Main = Window:Tab({ Title = "Main", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "Do something",
    Callback = function()
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value)
        print("Walk Speed:", value)
    end
})

ANUI:Notify({
    Title = "Hello!",
    Content = "Welcome to ANUI",
    Icon = "bell",
    Duration = 3,
})
```

## Следующие шаги

- Настройте окно полностью в [Настройке окна](/ru/guide/window-configuration).
- Просмотрите все элементы в [Обзоре элементов](/ru/elements/).
