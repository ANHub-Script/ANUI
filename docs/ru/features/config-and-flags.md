# Config & Flags

ANUI может сохранять и восстанавливать состояние вашего меню на диск. Дайте любому сохраняемому элементу `Flag` — и его значение будет записано при сохранении конфигурации и восстановлено при её загрузке, без всякого ручного учёта.

::: info Требуется `Folder` у окна
Система конфигураций работает на `Window.ConfigManager`, который существует только тогда, когда окно было создано с `Folder`. Задайте его в [`ANUI:CreateWindow{}`](/ru/guide/window-configuration) перед использованием чего-либо с этой страницы.
:::

## Как работают флаги

Каждый сохраняемый элемент принимает `Flag = "key"`. Когда вы его задаёте:

1. Элемент автоматически регистрируется в **текущей конфигурации** (`Window.CurrentConfig`).
2. Вызов `:Save()` у этой конфигурации записывает значение каждого зарегистрированного флага в JSON-файл.
3. Вызов `:Load()` читает файл обратно и восстанавливает каждый элемент к сохранённому значению.

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm", -- это значение теперь сохраняемое
    Callback = function(v) print(v) end,
})
```

Флаги на элементах, созданных до появления текущей конфигурации, ставятся в очередь; эта очередь опустошается и регистрируется при следующем `:Save()` или `:Load()`.

## Что именно сохраняется

Только эти типы элементов сериализуют своё состояние. Любой другой элемент система конфигураций игнорирует.

| Element | Что сохраняется |
| --- | --- |
| `Colorpicker` | Hex-цвет **и** прозрачность |
| `Dropdown` | Выбранное значение |
| `Input` | Текстовое значение |
| `Keybind` | Привязанная клавиша |
| `Slider` | Значение по умолчанию (`Value.Default`) |
| `Toggle` | Логическое значение |

## Где хранятся конфигурации

Конфигурации записываются внутри корневой папки `ANUI/`, внутри `Folder` вашего окна:

```
ANUI/<Folder>/config/<name>.json
```

Например, при `Folder = "MyHub"` конфигурация с именем `default` находится в `ANUI/MyHub/config/default.json`.

::: warning Требуются файловые функции исполнителя
Сохранение и загрузка обращаются к файловой системе. Ваш исполнитель должен предоставлять файловые глобальные функции — `readfile`, `writefile`, `isfile` и `makefolder` (плюс связанные с ними помощники). Без них `:Save()` и `:Load()` не смогут ничего сохранить.
:::

## Менеджер конфигураций — `Window.ConfigManager`

`Window.ConfigManager` создаёт именованные файлы конфигураций и управляет ими.

### `ConfigManager:CreateConfig(filename, autoload?)`

Создаёт (или открывает) конфигурацию по имени и возвращает **объект конфигурации**. Необязательный `autoload` помечает её для автоматической загрузки. `ConfigManager:Config(...)` — это псевдоним.

```lua
local ConfigManager = Window.ConfigManager
local config = ConfigManager:CreateConfig("default")
```

### `ConfigManager:GetConfig(name)`

Возвращает объект конфигурации для уже существующего имени (открывая доступ к полям вроде `.AutoLoad`).

### `ConfigManager:GetAutoLoadConfigs()`

Возвращает конфигурации, помеченные для авто-загрузки (в виде строки JSON).

### `ConfigManager:DeleteConfig(name)`

Удаляет файл конфигурации по имени.

### `ConfigManager:AllConfigs()`

Возвращает массив со всеми именами конфигураций — удобно для заполнения dropdown.

```lua
local names = ConfigManager:AllConfigs() -- { "default", "pvp", ... }
```

## Объект конфигурации

`CreateConfig`/`Config`/`GetConfig` — все они возвращают объект конфигурации (`ConfigModule`) со следующими методами.

### `config:SetAsCurrent()`

Помечает эту конфигурацию как `Window.CurrentConfig`, чтобы новые элементы с флагами регистрировались в ней.

### `config:Register(name, element)`

Регистрирует элемент вручную под указанным ключом (обычно не нужно — `Flag` делает это за вас).

### `config:Set(key, value)` / `config:Get(key)`

Сохраняет и читает произвольные пользовательские данные наряду с вашими флагами.

```lua
config:Set("lastPlayer", game.Players.LocalPlayer.Name)
print(config:Get("lastPlayer"))
```

### `config:SetAutoLoad(bool)`

Помечает (или снимает пометку) эту конфигурацию для автоматической загрузки.

### `config:Save()`

Записывает на диск каждый зарегистрированный флаг и пользовательское значение. Возвращает истинное значение при успехе.

### `config:Load()`

Читает файл и восстанавливает каждый зарегистрированный элемент. Возвращает истинное значение при успехе.

### `config:Delete()`

Удаляет файл этой конфигурации.

### `config:GetData()`

Возвращает всю таблицу данных, которую конфигурация держит в данный момент.

## `Window.CurrentConfig`

`Window.CurrentConfig` держит активный объект конфигурации. Элементы с флагами регистрируются в нём, и именно на эту конфигурацию действуют `:SetAutoLoad`, `:Save` и `:Load`, когда их вызывают из вашего UI. Направьте его на конфигурацию перед сохранением или загрузкой:

```lua
Window.CurrentConfig = ConfigManager:CreateConfig("default")
Window.CurrentConfig:Load()
```

## Полный UI Save / Load

Полноценная панель конфигураций: поле ввода имени, dropdown с существующими конфигурациями, переключатель авто-загрузки и кнопки Save / Load. Адаптировано из вкладки "Config Usage" в скрипте-примере.

```lua
local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- Имя конфигурации для сохранения/загрузки
local ConfigNameInput = ConfigTab:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Callback = function(value)
        ConfigName = value
    end,
})

-- Переключатель авто-загрузки для текущей конфигурации
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "Enable Auto Load to Selected Config",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})

-- Dropdown, показывающий все существующие конфигурации
local AllConfigs = ConfigManager:AllConfigs()
local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil

local AllConfigsDropdown = ConfigTab:Dropdown({
    Title = "All Configs",
    Desc = "Select existing configs",
    Values = AllConfigs,
    Value = DefaultValue,
    Callback = function(value)
        ConfigName = value
        ConfigNameInput:Set(value)
        AutoLoadToggle:Set((ConfigManager:GetConfig(ConfigName)).AutoLoad or false)
    end,
})

-- Сохранить текущее состояние в ConfigName
ConfigTab:Button({
    Title = "Save Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:Config(ConfigName)
        if Window.CurrentConfig:Save() then
            ANUI:Notify({
                Title = "Config Saved",
                Content = "Config '" .. ConfigName .. "' saved",
                Icon = "check",
            })
        end
        -- обновить dropdown, чтобы появилась только что созданная конфигурация
        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

-- Загрузить ConfigName обратно в UI
ConfigTab:Button({
    Title = "Load Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
        if Window.CurrentConfig:Load() then
            ANUI:Notify({
                Title = "Config Loaded",
                Content = "Config '" .. ConfigName .. "' loaded",
                Icon = "refresh-cw",
            })
        end
    end,
})
```

## См. также

- [Пример системы конфигураций](/ru/examples/config-system) — полное пошаговое руководство, готовое к копированию.
