# Space

Невидимый вертикальный разделитель, используемый для добавления пространства между элементами. Он ничего не отрисовывает — только резервирует высоту.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Space()
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })
```

## Конфигурация

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Columns` | `number` | `1` | Множитель высоты. Высота отступа равна `7 × Columns` пикселей. |

::: info Высота
Высота вычисляется как `7 * Columns` пикселей — при значении по умолчанию `Columns = 1` резервируется 7px, при `Columns = 2` — 14px, и так далее.
:::

## Примеры

### Больший промежуток

```lua
myTab:Space({ Columns = 2 }) -- вертикальное пространство 14px
```

### Расстановка отступов в стопке элементов

`Space()` между каждым элементом управления — обычный способ сделать так, чтобы длинный список не выглядел тесным.

```lua
myTab:Toggle({ Title = "Basic Toggle", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Toggle with Description", Desc = "Extra detail", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Checkbox", Type = "Checkbox", Callback = function(v) end })
```

::: info
Space не является интерактивным элементом, поэтому у него нет методов — задавайте его размер через поле `Columns` при создании.
:::
