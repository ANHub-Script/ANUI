# Вкладки и разделы

Вкладки — это страницы вашего меню; разделы боковой панели группируют эти вкладки в подписанные группы. Эта страница рассказывает о создании вкладок через `Window:Tab{}` и их группировке через `Window:Section{}`.

::: info Две разные концепции "Section"
В ANUI есть две несвязанные вещи, которые обе называются "Section" — не путайте их:

1. **`Window:Section({ Title = ... })`** создаёт **заголовок раздела боковой панели**, который группирует вкладки в боковой панели. Затем вы вызываете `Section:Tab({...})`, чтобы добавить вкладки под ним. Именно это описано на этой странице.
2. **`Tab:Section({...})`** — это **элемент контента**, сворачиваемый контейнер, размещаемый *внутри* вкладки. Он описан на странице [Section (элемент)](/ru/elements/section).
:::

## Создание вкладки

Создайте вкладку через `Window:Tab{}`. Он возвращает объект `Tab`, в который вы добавляете элементы.

```lua
local Main = Window:Tab({
    Title = "Main",
    Icon = "house",
    Desc = "Main controls", -- всплывающая подсказка при наведении
})
```

### Конфигурация вкладки

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Tab"` | Подпись вкладки. |
| `Desc` | `string` | — | Всплывающая подсказка при наведении на вкладку. |
| `Icon` | `string` | — | Иконка вкладки (16px): имя Lucide или `rbxassetid://…`. |
| `Image` | `string` | — | Баннерное изображение (100px), показываемое в заголовке вкладки. |
| `IconThemed` | `boolean` | — | Окрашивает иконку в цвет темы. |
| `Locked` | `boolean` | — | Запускает вкладку в заблокированном состоянии. |
| `ShowTabTitle` | `boolean` | — | Показывает заголовок вкладки в шапке контента. |
| `Profile` | `table` | — | Конфигурация карточки профиля (см. ниже). |
| `SidebarProfile` | `boolean` | — | Отрисовывает профиль как карточку боковой панели вместо шапки контента. |

## Профили

Вкладка может отображать **профиль** — карточку с аватаром, баннером, индикатором статуса и кнопками-badge. Передайте таблицу `Profile`:

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | Отображаемое имя. |
| `Desc` | `string` | — | Подзаголовок / текст роли. |
| `Avatar` | `string` | — | Изображение аватара. |
| `Banner` | `string` | — | Баннерное изображение. |
| `Status` | `boolean` | — | Показывает индикатор статуса. |
| `Badges` | `array` | — | Список кнопок-badge `{ Icon, Title, Desc, Callback }`. |
| `Sticky` | `boolean` | `true` | Оставляет профиль закреплённым при прокрутке. |

Установите `SidebarProfile = true`, чтобы отрисовать профиль как карточку в боковой панели; `false` (или пропуск) показывает его как большую шапку внутри контента вкладки.

```lua
local Badges = {
    {
        Icon = "geist:logo-discord",
        Title = "Discord",
        Desc = "Join ANHUB Discord",
        Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
            ANUI:Notify({ Title = "Discord", Content = "Invite link copied!", Icon = "geist:logo-discord", Duration = 3 })
        end
    },
    {
        Icon = "youtube",
        Desc = "Subscribe to YouTube",
        Callback = function()
            setclipboard("https://www.youtube.com/@ANHubRoblox")
            ANUI:Notify({ Title = "YouTube", Content = "Channel link copied!", Icon = "youtube", Duration = 3 })
        end
    },
}

-- Карточка боковой панели (декоративная, отрисовывается в боковой панели)
Window:Tab({
    Profile = {
        Title = "AdityaNugraha",
        Desc = "Admin",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = true,
})

-- Обычная вкладка с большой шапкой профиля
local UserTab = Window:Tab({
    Title = "Example Profile Content",
    Icon = "user",
    Profile = {
        Title = "User Settings",
        Desc = "Manage your account details here",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = false,
})

UserTab:Button({ Title = "Change Password", Callback = function() end })
UserTab:Button({ Title = "Log Out", Icon = "log-out", Callback = function() end })
```

## Группировка вкладок разделами боковой панели

`Window:Section({ Title = ... })` создаёт подписанный заголовок в боковой панели. Вызовите `:Tab{}` у возвращённого раздела, чтобы добавить вкладки под ним.

```lua
local ElementsSection = Window:Section({ Title = "Elements" })

local ToggleTab = ElementsSection:Tab({ Title = "Toggle", Icon = "arrow-left-right" })
local ButtonTab = ElementsSection:Tab({ Title = "Button", Icon = "mouse-pointer-click" })

local OtherSection = Window:Section({ Title = "Other" })
local DiscordTab = OtherSection:Tab({ Title = "Discord" })
```

## Методы вкладки

- `Tab:Select()` — переключиться на эту вкладку.
- `Tab:ScrollToTheElement(index)` — прокрутить вкладку к заданному элементу.
- `Tab:LockAll()` — заблокировать каждый элемент во вкладке.
- `Tab:UnlockAll()` — разблокировать каждый элемент во вкладке.
- `Tab:GetLocked()` — получить заблокированные элементы вкладки.
- `Tab:GetUnlocked()` — получить незаблокированные элементы вкладки.

Каждый метод создания элемента (`Tab:Button`, `Tab:Toggle`, …) также доступен у вкладки — см. [Обзор элементов](/ru/elements/).

## Программный выбор вкладки

Переключайте вкладки из кода либо через окно, либо через саму вкладку. `Window:SelectTab` принимает индекс, доступный у каждой вкладки как `Tab.Index`:

```lua
Window:SelectTab(UpgradeTab.Index)
-- или, что то же самое:
UpgradeTab:Select()
```

## См. также

- [Обзор элементов](/ru/elements/) — всё, что можно поместить во вкладку.
- [Section (элемент)](/ru/elements/section) — сворачиваемый контейнер внутри вкладки.
