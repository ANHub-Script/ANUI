---
layout: home
title: ANUI
titleTemplate: Advanced Roblox UI Library

hero:
  name: ANUI
  text: Advanced Roblox UI Library
  tagline: A modern, feature-rich UI library for Roblox script executors. Build a beautiful, mobile-ready menu in just a few lines.
  image:
    src: /logo.svg
    alt: ANUI logo
  actions:
    - theme: brand
      text: Get Started
      link: /guide/introduction
    - theme: alt
      text: Installation
      link: /guide/installation
    - theme: alt
      text: View on GitHub
      link: https://github.com/ANHub-Script/ANUI

features:
  - icon: 🧩
    title: 15+ Elements
    details: Buttons, toggles, sliders, dropdowns, colorpickers, keybinds, inputs, code blocks and more — everything you need to build a full-featured menu.
    link: /elements/
    linkText: Browse elements
  - icon: 🎨
    title: 26 Built-in Themes
    details: Ship with Dark, Light, Dracula, Tokyo Night, Nord, Gruvbox and 20 more — or register your own palette with a single call.
    link: /features/themes
    linkText: Theming guide
  - icon: 💾
    title: Config & Flags
    details: Persist any element's state to disk with a single Flag, and restore it automatically the next time your script runs.
    link: /features/config-and-flags
    linkText: Config & flags
  - icon: 🔑
    title: Key System
    details: Gate your script behind a key with built-in support for Luarmor, Platoboost and PandaDevelopment — or your own custom validator.
    link: /features/key-system
    linkText: Key system
  - icon: 🔔
    title: Notifications & Dialogs
    details: Rich toast notifications, modal dialogs and popups come out of the box, with icons, buttons and progress bars.
    link: /features/notifications
    linkText: Notifications
  - icon: ⏱️
    title: Smart Scheduler
    details: Drift-free loops with per-loop busy guards that clean themselves up automatically when the window closes.
    link: /features/scheduler
    linkText: Scheduler & loops
---

## Quick preview

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})

local Main = Window:Tab({ Title = "Main", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "Notify me",
    Callback = function()
        ANUI:Notify({ Title = "Hello!", Content = "Welcome to ANUI", Icon = "bell", Duration = 3 })
    end
})
```

That's a complete, working menu. Head to the [Quick Start](/guide/getting-started) to build it step by step.
