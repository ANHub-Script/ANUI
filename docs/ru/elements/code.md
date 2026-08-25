# Code

Блок кода с подсветкой синтаксиса и встроенной кнопкой копирования. Идеально подходит для показа фрагментов, команд или строк установки, которые пользователи могут скопировать в один клик.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Code({
    Title = "Lua",
    Code = "print('Hello, world!')"
})
```

## Конфигурация

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | Подпись, отображаемая над блоком кода. |
| `Code` | `string` | `nil` | Отображаемый текст кода. |
| `OnCopy` | `function` | `nil` | Выполняется после копирования кода в буфер обмена. |

::: info Копирование
Кнопка копирования записывает в **буфер обмена executor'а**. Если копирование не удаётся, вместо этого показывается уведомление.
:::

## Методы

### `Code:SetCode(code)`

Заменяет отображаемый код новой строкой.

```lua
mySnippet:SetCode("print('updated!')")
```

### `Code:Destroy()`

Удаляет блок кода из его контейнера.

```lua
mySnippet:Destroy()
```

## Примеры

### Блок фрагмента Lua

```lua
myTab:Code({
    Title = "Lua",
    Code = "print('Hello from Group 1')"
})
```

### Запуск callback после копирования

```lua
myTab:Code({
    Title = "Install",
    Code = 'loadstring(game:HttpGet("https://example.com/script.lua"))()',
    OnCopy = function()
        print("Copied!")
    end
})
```

### Обновление кода с помощью `SetCode`

Сохраните возвращённый модуль и замените его содержимое позже.

```lua
local snippet = myTab:Code({
    Title = "Example",
    Code = "print('initial')"
})

myTab:Button({
    Title = "Update code",
    Callback = function()
        snippet:SetCode("print('updated!')")
    end
})
```
