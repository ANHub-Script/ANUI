# Divider

Тонкий разделитель, визуально отделяющий элементы. На Tab или Section он отображается как горизонтальная линия; внутри [Group](/ru/elements/group) — как вертикальная линия между колонками группы.

## Базовое использование

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({ Title = "Save", Callback = function() end })
myTab:Divider()
myTab:Button({ Title = "Load", Callback = function() end })
```

## Конфигурация

`Divider` не принимает никакой конфигурации — вызывайте `Tab:Divider()` без аргументов.

::: info Вертикальный внутри Group
Поскольку [Group](/ru/elements/group) располагает свои дочерние элементы горизонтально, Divider, размещённый внутри неё, отрисовывается как **вертикальный** разделитель между колонками, а не как горизонтальная линия.
:::

## Примеры

### Разделение групп элементов управления

```lua
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })

myTab:Divider()

myTab:Button({ Title = "Reset", Callback = function() end })
```

### Вертикальный divider между колонками

```lua
local row = myTab:Group({})
row:Button({ Title = "Accept", Callback = function() end })
row:Divider()
row:Button({ Title = "Decline", Callback = function() end })
```

::: info
Divider носит чисто декоративный характер — это не интерактивный элемент, поэтому у него нет ни конфигурации, ни методов.
:::
