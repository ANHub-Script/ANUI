# Система конфигурации

Полный рецепт сохранения/загрузки: элементы с флагами, значения которых сохраняются, выбор конфигурации из списка на диске, кнопки Save/Load и toggle авто-загрузки. Адаптировано из вкладки **Config Usage** в демо.

::: warning Нужен доступ к файлам в исполнителе
Сохранение конфигураций читает и пишет JSON-файлы на диске, поэтому ваш исполнитель должен поддерживать файловые глобальные функции `readfile`, `writefile`, `isfile` и `makefolder`. Конфигурации хранятся в `ANUI/<Folder>/config/<name>.json`, где `<Folder>` — это `Folder`, переданный в `CreateWindow`.
:::

## 1. Задайте флаги своим элементам

Любой элемент с состоянием (Toggle, Slider, Dropdown, Input, Keybind, Colorpicker), у которого есть ключ `Flag`, автоматически регистрируется в активной конфигурации. Его значение записывается при Save и восстанавливается при Load — никакого дополнительного кода для каждого элемента писать не нужно.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Folder = "MyHub", -- ОБЯЗАТЕЛЬНО для конфигураций — это корень на диске
})

local Tab = Window:Tab({ Title = "Settings", Icon = "sliders-horizontal" })

-- Каждый `Flag` становится ключом внутри сохранённого JSON-файла.
Tab:Toggle({
    Flag = "AutoFarm",
    Title = "Auto Farm",
    Callback = function(state) print("Auto Farm:", state) end,
})

Tab:Slider({
    Flag = "WalkSpeed",
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) print("Walk Speed:", value) end,
})

Tab:Dropdown({
    Flag = "Weapon",
    Title = "Weapon",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value) print("Weapon:", value) end,
})
```

## 2. Получите ConfigManager и задайте текущую конфигурацию

`Window.ConfigManager` создаётся автоматически, потому что мы передали `Folder`. Имя конфигурации мы храним в переменной и сразу делаем одну конфигурацию **текущей**, чтобы значениям с флагами всегда было куда сохраняться.

```lua
local ConfigTab = Window:Tab({ Title = "Config", Icon = "folder" })

local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- Убедимся, что текущая конфигурация существует. `:Config(name)` создаёт или открывает её (алиас :CreateConfig).
Window.CurrentConfig = ConfigManager:Config(ConfigName)
```

## 3. Поле ввода Config Name

Дайте пользователю возможность ввести имя конфигурации для сохранения или загрузки. Записываем его обратно в `ConfigName`.

```lua
local ConfigNameInput = ConfigTab:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Value = ConfigName,
    Callback = function(value)
        ConfigName = value
    end,
})
```

## 4. Toggle авто-загрузки

`ConfigModule:SetAutoLoad(bool)` помечает конфигурацию как загружаемую автоматически при запуске. Вызываем его на текущей конфигурации.

```lua
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "Auto Load This Config",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})
```

## 5. Dropdown «All Configs»

`ConfigManager:AllConfigs()` возвращает имена всех конфигураций, уже лежащих на диске. Мы передаём этот список в dropdown, чтобы пользователь мог выбрать существующую. Когда он выбирает её, мы синхронизируем поле ввода имени и отражаем сохранённое состояние авто-загрузки этой конфигурации (читаем из её поля `.AutoLoad`).

```lua
local AllConfigs = ConfigManager:AllConfigs()

local AllConfigsDropdown = ConfigTab:Dropdown({
    Title = "All Configs",
    Desc = "Select an existing config",
    Values = AllConfigs,
    Value = table.find(AllConfigs, ConfigName) and ConfigName or nil,
    Callback = function(value)
        ConfigName = value
        ConfigNameInput:Set(value)
        AutoLoadToggle:Set((ConfigManager:GetConfig(ConfigName)).AutoLoad or false)
    end,
})
```

## 6. Кнопки Save и Load

Кнопка Save делает `ConfigName` текущей конфигурацией и вызывает `:Save()`; при успехе мы показываем уведомление и обновляем dropdown, чтобы совсем новая конфигурация появилась в списке. Кнопка Load открывает конфигурацию и вызывает `:Load()`, который восстанавливает все значения с флагами.

```lua
ConfigTab:Button({
    Title = "Save Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:Config(ConfigName)
        if Window.CurrentConfig:Save() then
            ANUI:Notify({ Title = "Config Saved", Content = "Saved '" .. ConfigName .. "'", Icon = "check" })
        end
        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

ConfigTab:Button({
    Title = "Load Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
        if Window.CurrentConfig:Load() then
            ANUI:Notify({ Title = "Config Loaded", Content = "Loaded '" .. ConfigName .. "'", Icon = "refresh-cw" })
        end
    end,
})
```

::: info
`:Config(name)` и `:CreateConfig(name)` — это алиасы: оба создают файл конфигурации, если его нет, или открывают, если он есть. `:Save()` и `:Load()` возвращают truthy-значение при успехе — именно поэтому кнопки выше показывают уведомление только тогда, когда операция сработала.
:::

Полный процесс работы с флагами, список сохраняемых типов элементов и все методы `ConfigManager` / `ConfigModule` смотрите в разделе [Конфигурация и флаги](/ru/features/config-and-flags).
