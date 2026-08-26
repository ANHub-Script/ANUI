# Введение

ANUI (Advanced Roblox UI Library) — это современная и богатая возможностями библиотека UI для исполнителей скриптов Roblox. С ней вы можете собрать аккуратное меню, готовое к мобильным устройствам — окна, вкладки, toggle, slider, dropdown и не только — всего за несколько строк Lua.

## Что такое ANUI?

ANUI отрисовывает плавающее окно, которое можно перетаскивать и менять в размерах, поверх любого Roblox-опыта. Вы описываете своё меню декларативно — создаёте окно, добавляете вкладки, наполняете их элементами — а ANUI берёт на себя вёрстку, темы, ввод, анимации и сохранение данных.

Поскольку библиотека загружается по HTTP одним `loadstring`, ничего не нужно устанавливать или собирать: вставьте одну строку, и ваше меню сразу заработает.

## Что можно построить

- Хабы функций и чит-меню с упорядоченными вкладками и разделами боковой панели
- Панели настроек, состояние которых сохраняется между сессиями через [Конфигурацию и флаги](/ru/features/config-and-flags)
- Скрипты, закрытые ключом, с помощью встроенной [Системы ключей](/ru/features/key-system)
- Насыщенные дашборды с профилями, badge, уведомлениями и диалогами

## Ключевые возможности

- 15+ [элементов](/ru/elements/) — button, toggle, slider, dropdown, colorpicker, keybind, input, блоки кода и не только
- [26 встроенных тем](/ru/features/themes), плюс ваши собственные палитры
- [Конфигурация и флаги](/ru/features/config-and-flags), чтобы сохранять состояние любого элемента на диск
- [Система ключей](/ru/features/key-system) с провайдерами Luarmor, Platoboost и PandaDevelopment
- [Уведомления](/ru/features/notifications) и [диалоги и popup](/ru/features/dialogs-and-popups)
- [Локализация](/ru/features/localization) для многоязычных меню
- [Планировщик](/ru/features/scheduler) без дрифта для управляемых циклов
- [Масштабирование под мобильные устройства и acrylic-блюр](/ru/guide/window-configuration)

## Требования

ANUI работает внутри исполнителя скриптов Roblox. Ваш исполнитель должен поддерживать:

- `loadstring` и `game:HttpGet` — обязательны для загрузки библиотеки
- `readfile`, `writefile`, `isfile`, `makefolder` — нужны только для сохранения конфигураций и ключей

::: info Только одно окно
Одновременно может существовать только одно окно. Второй вызов `ANUI:CreateWindow` выдаст предупреждение и вернёт `nil`.
:::

## Благодарности

- Основано на **WindUI от Footagesus**
- Иконки от [Lucide](https://lucide.dev)
- Спасибо Dawid-Scripts

## Ссылки

- GitHub: [github.com/ANHub-Script/ANUI](https://github.com/ANHub-Script/ANUI)
- Discord: [discord.gg/bUkCZvmrpH](https://discord.gg/qN47S3mKZA)
- YouTube: [@ANHubRoblox](https://www.youtube.com/@ANHubRoblox)

---

Далее: [Установка](/ru/guide/installation)
