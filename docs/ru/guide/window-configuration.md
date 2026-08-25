# Настройка окна

Окно — это корень любого меню ANUI. Вы создаёте его один раз через `ANUI:CreateWindow{}`, передавая одну таблицу конфигурации. Эта страница описывает каждое поле и методы, доступные у возвращаемого объекта `Window`.

::: info Только одно окно
Одновременно может существовать только одно окно. Второй вызов `ANUI:CreateWindow` выдаёт предупреждение и возвращает `nil`.
:::

## Базовый пример

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
    Theme = "Dark",
})
```

## Конфигурация

### Identity

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | Текст заголовка окна. |
| `Author` | `string` | — | Подзаголовок, показываемый под заголовком. |
| `Icon` | `string` | — | Иконка окна: имя иконки Lucide или `rbxassetid://…`. |
| `IconSize` | `number` \| `UDim2` | `22` | Размер иконки в пикселях. |
| `IconThemed` | `boolean` | — | Окрашивает иконку в цвет иконок темы. |

### Storage

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Folder` | `string` | — | Папка хранения на диске. Её указание включает [систему конфигурации](/ru/features/config-and-flags) и опцию `SaveKey` в [системе ключей](/ru/features/key-system). Конфигурации пишутся в `ANUI/<Folder>/config/<name>.json`. |

### Size & scaling

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Size` | `UDim2` | `580 × 460` (с ограничением) | Начальный размер окна. |
| `MinSize` | `Vector2` | `850 × 560` | Минимальный размер при изменении размеров. |
| `MaxSize` | `Vector2` | `1050 × 560` | Максимальный размер при изменении размеров. |
| `Resizable` | `boolean` | `true` | Разрешает пользователю менять размер окна. |
| `AutoScale` | `boolean` | `true` | Автоматически масштабирует UI (удобно для мобильных). |

### Appearance

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Theme` | `string` | `"Dark"` | Название темы — см. [Темы](/ru/features/themes). |
| `Transparent` | `boolean` | `false` | Использует прозрачный фон окна. |
| `Acrylic` | `boolean` | `false` | Acrylic-блюр за окном. |
| `Background` | `Color3` \| image id \| `"https://…"` \| `"video:…"` \| таблица градиента | — | Собственный фон окна. |
| `BackgroundImageTransparency` | `number` | `0` | Прозрачность фонового изображения. |
| `ShadowTransparency` | `number` | `0.7` | Прозрачность тени окна. |
| `Radius` | `number` | `16` | Радиус скругления углов окна. |
| `ElementsRadius` | `number` | — | Радиус скругления углов, применяемый к элементам. |
| `SideBarWidth` | `number` | `200` | Ширина боковой панели в пикселях. |
| `HidePanelBackground` | `boolean` | `false` | Скрывает фон панели контента. |
| `ScrollBarEnabled` | `boolean` | `false` | Показывает полосу прокрутки контента. |

### Behavior

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `ToggleKey` | `Enum.KeyCode` | — | Клавиша, которая показывает / скрывает окно. |
| `HideSearchBar` | `boolean` | `true` | Скрывает строку поиска элементов. Установите `false`, чтобы показать её. |
| `NewElements` | `boolean` | `false` | Включает новый стиль элементов. |
| `IgnoreAlerts` | `boolean` | `false` | Подавляет встроенные alert-попапы. |

### Под-конфигурации

Эти поля принимают собственные таблицы конфигурации и описаны на отдельных страницах.

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `OpenButton` | `table` | — | Плавающая кнопка, которая снова открывает окно. См. [Кнопка открытия](/ru/features/open-button). |
| `KeySystem` | `table` | — | Закрывает меню ключом. См. [Система ключей](/ru/features/key-system). |
| `User` | `table` | — | Блок отображения пользователя: `{ Enabled, Anonymous, Callback }`. |

## Методы окна

Когда у вас есть `Window`, эти методы управляют им во время выполнения.

### Lifecycle

- `Window:Open()` — показать окно.
- `Window:Close()` — скрыть окно; возвращает объект с `:Destroy()`.
- `Window:Destroy()` — окончательно удалить окно.
- `Window:Toggle()` — переключить между открытым и закрытым состоянием.
- `Window:OnOpen(fn)` — выполнять `fn` каждый раз, когда окно открывается.
- `Window:OnClose(fn)` — выполнять `fn` каждый раз, когда окно закрывается.
- `Window:OnDestroy(fn)` — выполнить `fn`, когда окно уничтожается.

### Appearance

- `Window:SetTitle(text)` — изменить заголовок.
- `Window:SetAuthor(text)` — изменить подзаголовок.
- `Window:SetIconSize(n | UDim2)` — изменить размер иконки окна.
- `Window:SetBackgroundImage(id)` — заменить фоновое изображение.
- `Window:ToggleTransparency(bool)` — переключить прозрачный фон.
- `Window:SetUIScale(v)` — задать масштаб UI (прочитать его обратно можно через `Window:GetUIScale()`).

### Sidebar

- `Window:CollapseSidebar()` — свернуть боковую панель.
- `Window:ExpandSidebar()` — развернуть боковую панель.
- `Window:ToggleSidebar(state?)` — переключить или принудительно задать состояние, если передан `state`.

```lua
task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
```

### Toggle key

- `Window:SetToggleKey(keycode)` — изменить клавишу показа / скрытия во время выполнения.

```lua
Window:SetToggleKey(Enum.KeyCode.G)
```

### Locks

- `Window:LockAll()` — заблокировать каждый элемент в окне.
- `Window:UnlockAll()` — разблокировать каждый элемент в окне.

### Topbar

- `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` — добавить кнопку в верхнюю панель окна.
- `Window:DisableTopbarButtons({names})` — отключить конкретные кнопки topbar по имени.

### Tag

`Window:Tag(cfg)` добавляет небольшой подписанный тег на окно — удобно, чтобы показать badge с версией.

```lua
Window:Tag({ Title = "v" .. ANUI.Version, Icon = "github" })
```

### Диалоги

`Window:Dialog{}` открывает модальный диалог. См. [Диалоги и всплывающие окна](/ru/features/dialogs-and-popups).

### Циклы

`Window:Loop`, `Window:StatusLoop`, `Window:ManagedLoop` и их спутники запускают управляемые циклы, которые автоматически останавливаются, когда окно закрывается или уничтожается. См. [Планировщик и циклы](/ru/features/scheduler).

## Следующие шаги

- Добавьте [Вкладки и разделы](/ru/guide/tabs-and-sections), чтобы упорядочить своё меню.
- Измените внешний вид всего с помощью [Тем](/ru/features/themes).
