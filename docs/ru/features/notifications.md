# Notifications

Уведомления в стиле toast, которые выезжают сбоку, показывают заголовок и текст и закрываются сами после обратного отсчёта. Создайте одно с помощью `ANUI:Notify{}` — оно работает откуда угодно, независимо от того, открыто окно или нет.

## Базовое использование

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Notify({
    Title = "Welcome",
    Content = "Thanks for using ANUI!",
    Icon = "bell",
    Duration = 5,
})
```

::: info Поле текста — это `Content`, а не `Desc`
Текст тела уведомления задаётся через `Content`. У `Notify` нет поля `Desc` — передача `Desc` просто не покажет никакого текста. Аналогично, изображение задаётся через `Icon` (имя иконки Lucide **или** `rbxassetid://…`), а не `Image`.
:::

## Настройка

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `Title` | `string` | `"Notification"` | Текст заголовка toast. |
| `Content` | `string` | `nil` | Текст тела, отображаемый под заголовком. |
| `Icon` | `string` | `nil` | Ведущая иконка: имя иконки Lucide или `rbxassetid://…`. (Поле — `Icon`, а не `Image`.) |
| `IconThemed` | `boolean` | `nil` | Окрашивает иконку в цвет иконок темы. |
| `Background` | `string` | `nil` | Id фонового изображения для toast. |
| `BackgroundImageTransparency` | `number` | `nil` | Прозрачность фонового изображения (`0` = непрозрачное). |
| `Duration` | `number` \| `false` | `5` | Секунды до автозакрытия; также управляет индикатором прогресса. Ложное значение (`false`/`nil`/`0`) означает, что оно никогда не закрывается автоматически. |
| `Buttons` | `table` | `{}` | Хранится в объекте, но **не отображается** — см. предупреждение ниже. |

::: warning `Buttons` хранятся, но не отображаются
Поле `Buttons` принимается и сохраняется в объекте уведомления, но текущая сборка **не** отрисовывает их. Для интерактивного выбора откройте [Диалог или Popup](/ru/features/dialogs-and-popups).
:::

Кнопка закрытия (X) присутствует всегда, поэтому пользователь может закрыть toast вручную, даже когда `Duration` ложно.

## Возвращаемый объект

`ANUI:Notify{}` возвращает объект уведомления с единственным методом:

### `Notification:Close()`

Закрывает уведомление немедленно. Полезно для постоянных toast (`Duration = false`), которые вы хотите закрыть из кода.

```lua
local note = ANUI:Notify({
    Title = "Working…",
    Content = "This stays open until you close it.",
    Icon = "loader",
    Duration = false, -- ложно → никогда не закрывается автоматически
})

task.delay(3, function()
    note:Close()
end)
```

## `ANUI:SetNotificationLower(bool)`

Перемещает стек уведомлений к нижней части экрана при `true` и восстанавливает позицию по умолчанию при `false`. Вызовите один раз во время настройки.

```lua
ANUI:SetNotificationLower(true)
```

## Примеры

### Простое уведомление

```lua
ANUI:Notify({
    Title = "Saved",
    Content = "Your settings have been saved.",
})
```

### С иконкой и пользовательской длительностью

```lua
ANUI:Notify({
    Title = "Discord",
    Content = "Invite link copied to clipboard!",
    Icon = "geist:logo-discord",
    Duration = 3,
})

ANUI:Notify({
    Title = "YouTube",
    Content = "Channel link copied!",
    Icon = "youtube",
    Duration = 3,
})
```

### Постоянное уведомление, закрываемое из кода

Установите `Duration = false`, чтобы toast никогда не истекал по времени, сохраните возвращённый объект и вызовите `:Close()`, когда закончите.

```lua
local loading = ANUI:Notify({
    Title = "Loading…",
    Content = "Fetching data from the server.",
    Icon = "loader",
    Duration = false,
})

-- позже, когда работа завершится
loading:Close()
ANUI:Notify({
    Title = "Done",
    Content = "Data loaded successfully.",
    Icon = "check",
    Duration = 4,
})
```

::: details С фоновым изображением
```lua
ANUI:Notify({
    Title = "Event started",
    Content = "A limited-time event is now live.",
    Icon = "party-popper",
    Background = "rbxassetid://84366761557806",
    BackgroundImageTransparency = 0.4,
    Duration = 6,
})
```
:::
