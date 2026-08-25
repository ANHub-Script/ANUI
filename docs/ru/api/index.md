# Шпаргалка по API

Всё на одной странице. Плотный краткий справочник по всей поверхности ANUI — вызовы верхнего уровня, методы Window и Tab, все элементы и точки входа возможностей. Переходите по ссылке за полными подробностями.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## `ANUI` (верхний уровень)

Методы и поля самого объекта библиотеки.

| Call | Назначение |
| --- | --- |
| `ANUI:CreateWindow(config)` → `Window` | Создать окно (существовать может только одно). |
| `ANUI:Notify(config)` → notification | Показать toast-уведомление. |
| `ANUI:SetNotificationLower(bool)` | Переместить уведомления в нижнюю часть экрана. |
| `ANUI:SetFont(fontId)` | Задать глобальный шрифт UI. |
| `ANUI:OnThemeChange(fn)` | Выполнять `fn` при каждой смене темы. |
| `ANUI:AddTheme(theme)` → theme | Зарегистрировать пользовательскую тему (ключом служит её `.Name`). |
| `ANUI:SetTheme(name)` → theme \| `nil` | Переключиться на тему по имени. |
| `ANUI:GetThemes()` | Вернуть все зарегистрированные темы. |
| `ANUI:GetCurrentTheme()` | Вернуть активную тему. |
| `ANUI:GetTransparency()` | Вернуть текущее значение прозрачности. |
| `ANUI:GetWindowSize()` | Вернуть текущий размер окна. |
| `ANUI:Localization(config)` | Настроить переводы. |
| `ANUI:SetLanguage(lang)` | Переключить язык (требуется включённая локализация). |
| `ANUI:ToggleAcrylic(bool)` | Включить или выключить эффект acrylic-блюра. |
| `ANUI:Gradient(stops, props)` → gradient | Собрать таблицу данных gradient (stops с ключами `"0"`..`"100"`). |
| `ANUI:Popup(config)` → `Popup` | Открыть модальный popup. |
| `ANUI:Scheduler(config)` → `Scheduler` | Создать отдельный планировщик циклов. |
| `ANUI.Version` | Строка версии библиотеки (поле, а не метод). |

## Методы Window

Возвращается из `ANUI:CreateWindow`. Сгруппированы по назначению; signature — в обратных кавычках.

**Вкладки и контейнеры**

| Method | Назначение |
| --- | --- |
| `Window:Tab(config)` | Добавить вкладку (страницу боковой панели, содержащую элементы). |
| `Window:Section(config)` | Добавить section боковой панели, который группирует вкладки. |
| `Window:SelectTab(index)` | Переключиться на вкладку по её индексу. |
| `Window:Divider()` | Добавить разделительную линию в боковую панель. |
| `Window:Tag(config)` | Добавить в окно небольшой tag/badge (напр. версию). |

**Диалоги**

| Method | Назначение |
| --- | --- |
| `Window:Dialog({ Title, Content, Icon, Width, Buttons })` | Открыть модальный диалог. Каждая кнопка — это `{ Title, Icon, Callback, Variant }` (`Width` по умолчанию `320`). |

**Lifecycle и callback**

| Method | Назначение |
| --- | --- |
| `Window:Open()` / `Window:Close()` / `Window:Toggle()` | Показать, скрыть или переключить окно. |
| `Window:Destroy()` | Уничтожить окно и выполнить очистку. |
| `Window:OnOpen(fn)` / `Window:OnClose(fn)` / `Window:OnDestroy(fn)` | Выполнить `fn` при соответствующем событии. |

**Appearance**

| Method | Назначение |
| --- | --- |
| `Window:SetTitle(t)` / `Window:SetAuthor(t)` | Обновить заголовок / подзаголовок. |
| `Window:SetIconSize(n \| UDim2)` | Изменить размер иконки верхней панели. |
| `Window:SetBackgroundImage(id)` / `Window:SetBackgroundImageTransparency(v)` | Задать фоновое изображение и его прозрачность. |
| `Window:SetBackgroundTransparency(v)` / `Window:ToggleTransparency(bool)` | Настроить или переключить прозрачность окна. |
| `Window:SetToTheCenter()` | Вернуть окно в центр экрана. |
| `Window:GetUIScale()` / `Window:SetUIScale(v)` | Прочитать или задать масштаб UI. |
| `Window:IsResizable(bool)` | Включить или отключить изменение размера. |

**Sidebar**

| Method | Назначение |
| --- | --- |
| `Window:CollapseSidebar()` / `Window:ExpandSidebar()` / `Window:ToggleSidebar(state?)` | Свернуть, развернуть или переключить боковую панель. |

**Toggle key**

| Method | Назначение |
| --- | --- |
| `Window:SetToggleKey(keycode)` | Задать горячую клавишу показа/скрытия (это `Enum.KeyCode`). |

**Locks**

| Method | Назначение |
| --- | --- |
| `Window:LockAll()` / `Window:UnlockAll()` | Заблокировать или разблокировать все элементы. |
| `Window:GetLocked()` / `Window:GetUnlocked()` | Список заблокированных / разблокированных элементов. |

**Topbar**

| Method | Назначение |
| --- | --- |
| `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` | Добавить свою кнопку в верхнюю панель. |
| `Window:DisableTopbarButtons({ names })` | Скрыть встроенные кнопки верхней панели по имени. |

**Кнопка открытия**

| Method | Назначение |
| --- | --- |
| `Window:EditOpenButton(config)` | Изменить плавающую кнопку открытия. |

**Циклы и планировщик**

| Method | Назначение |
| --- | --- |
| `Window:Loop(key, interval, fn, opts?)` | Выполнять `fn` каждые `interval` секунд. |
| `Window:StatusLoop(key, interval, fn)` | Цикл, предназначенный для обновления текста статуса. |
| `Window:ManagedLoop(key, interval, predicate, fn)` | Цикл, который работает только пока `predicate` возвращает true. |
| `Window:StopLoop(key)` / `Window:StopAllLoops()` | Остановить один цикл или все сразу. |
| `Window:IsLoopRunning(key)` / `Window:GetActiveLoopCount()` | Запросить состояние циклов. |
| `Window:AddConnection(conn)` / `Window:DisconnectAll()` | Отслеживать и очищать connection. |
| `Window:IsReady()` | Завершило ли окно инициализацию. |

## Методы Tab

| Method | Назначение |
| --- | --- |
| `Tab:Select()` | Сделать эту вкладку активной. |
| `Tab:ScrollToTheElement(index)` | Прокрутить к элементу по индексу. |
| `Tab:LockAll()` / `Tab:UnlockAll()` | Заблокировать или разблокировать все элементы во вкладке. |
| `Tab:GetLocked()` / `Tab:GetUnlocked()` | Список заблокированных / разблокированных элементов во вкладке. |
| `Tab:ReserveHeader(height, config)` | Зарезервировать фиксированную область заголовка сверху вкладки. |

::: info
Tab также предоставляет **все методы создания элементов** — `Tab:Button{}`, `Tab:Toggle{}`, `Tab:Slider{}` и так далее. `Section` и `Group` — это контейнеры с теми же методами элементов.
:::

## Краткий справочник по элементам

По одной строке на элемент. Аргумент callback — это то, что получает ваша функция `Callback`.

| Элемент | Signature | Основной config | Аргумент callback |
| --- | --- | --- | --- |
| [Button](/ru/elements/button) | `Tab:Button{}` | `Callback`, `Icon` | нет |
| [Toggle](/ru/elements/toggle) | `Tab:Toggle{}` | `Value`, `Type` | `boolean` |
| [Slider](/ru/elements/slider) | `Tab:Slider{}` | `Value { Min, Max, Default }`, `Step` | форматированная `string` |
| [Dropdown](/ru/elements/dropdown) | `Tab:Dropdown{}` | `Values`, `Multi` | выбранное значение (single) / массив (multi) |
| [Input](/ru/elements/input) | `Tab:Input{}` | `Placeholder`, `Type` | `string` |
| [Keybind](/ru/elements/keybind) | `Tab:Keybind{}` | `Value` (имя клавиши) | `string` с именем клавиши |
| [Colorpicker](/ru/elements/colorpicker) | `Tab:Colorpicker{}` | `Default`, `Transparency` | `(Color3, transparency)` |
| [Paragraph](/ru/elements/paragraph) | `Tab:Paragraph{}` | `Title`, `Desc`, `Images` | — |
| [Code](/ru/elements/code) | `Tab:Code{}` | `Code`, `OnCopy` | — |
| [Section](/ru/elements/section) | `Tab:Section{}` | `Title`, `Opened` | — |
| [Divider](/ru/elements/divider) | `Tab:Divider()` | — | — |
| [Space](/ru/elements/space) | `Tab:Space{}` | `Columns` | — |
| [Image](/ru/elements/image) | `Tab:Image{}` | `Image`, `AspectRatio` | — |
| [Group](/ru/elements/group) | `Tab:Group{}` | — (контейнер) | — |
| [Category](/ru/elements/category) | `Tab:Category{}` | `Options`, `Default` | имя выбранной опции (`string`) |

## Краткий справочник по возможностям

| Возможность | Точка входа | Документация |
| --- | --- | --- |
| Уведомления | `ANUI:Notify{}` | [Уведомления](/ru/features/notifications) |
| Диалоги и popup | `Window:Dialog{}` · `ANUI:Popup{}` | [Диалоги и всплывающие окна](/ru/features/dialogs-and-popups) |
| Конфигурация и флаги | `Window.ConfigManager` · `Flag = "..."` | [Конфигурация и флаги](/ru/features/config-and-flags) |
| Система ключей | `ANUI:CreateWindow{ KeySystem = {...} }` | [Система ключей](/ru/features/key-system) |
| Темы | `ANUI:SetTheme(name)` · `ANUI:AddTheme{}` | [Темы и оформление](/ru/features/themes) |
| Локализация | `ANUI:Localization{}` · `ANUI:SetLanguage(lang)` | [Локализация](/ru/features/localization) |
| Планировщик и циклы | `ANUI:Scheduler{}` · `Window:Loop(...)` | [Планировщик и циклы](/ru/features/scheduler) |
