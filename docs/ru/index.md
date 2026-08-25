---
layout: home
title: ANUI
titleTemplate: Продвинутая библиотека UI для Roblox

hero:
  name: ANUI
  text: Продвинутая библиотека UI для Roblox
  tagline: Современная и богатая возможностями библиотека UI для исполнителей скриптов Roblox. Соберите красивое меню, готовое к мобильным устройствам, всего за несколько строк.
  image:
    src: /logo.svg
    alt: Логотип ANUI
  actions:
    - theme: brand
      text: Начать
      link: /ru/guide/introduction
    - theme: alt
      text: Установка
      link: /ru/guide/installation
    - theme: alt
      text: Смотреть на GitHub
      link: https://github.com/ANHub-Script/ANUI

features:
  - icon: 🧩
    title: 15+ элементов
    details: Button, toggle, slider, dropdown, colorpicker, keybind, input, блоки кода и многое другое — всё, что нужно, чтобы собрать полноценное меню.
    link: /ru/elements/
    linkText: Обзор элементов
  - icon: 🎨
    title: 26 встроенных тем
    details: В комплекте Dark, Light, Dracula, Tokyo Night, Nord, Gruvbox и ещё 20 — или зарегистрируйте свою палитру одним вызовом.
    link: /ru/features/themes
    linkText: Руководство по темам
  - icon: 💾
    title: Конфигурация и флаги
    details: Сохраняйте состояние любого элемента на диск всего одним Flag и восстанавливайте его автоматически при следующем запуске скрипта.
    link: /ru/features/config-and-flags
    linkText: Конфигурация и флаги
  - icon: 🔑
    title: Система ключей
    details: Закройте свой скрипт ключом — со встроенной поддержкой Luarmor, Platoboost и PandaDevelopment — или со своим собственным валидатором.
    link: /ru/features/key-system
    linkText: Система ключей
  - icon: 🔔
    title: Уведомления и диалоги
    details: Насыщенные toast-уведомления, модальные диалоги и popup доступны сразу — с иконками, кнопками и индикаторами прогресса.
    link: /ru/features/notifications
    linkText: Уведомления
  - icon: ⏱️
    title: Умный планировщик
    details: Циклы без дрифта с защитой от наложения для каждого цикла, которые сами останавливаются, когда окно закрывается.
    link: /ru/features/scheduler
    linkText: Планировщик и циклы
---

## Быстрый предпросмотр

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "Мой хаб",
    Author = "от вас",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})

local Main = Window:Tab({ Title = "Главная", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Desc = "Автоматически фармить монеты",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "Уведомить меня",
    Callback = function()
        ANUI:Notify({ Title = "Привет!", Content = "Добро пожаловать в ANUI", Icon = "bell", Duration = 3 })
    end
})
```

Это полноценное работающее меню. Перейдите к [Быстрому старту](/ru/guide/getting-started), чтобы собрать его шаг за шагом.
