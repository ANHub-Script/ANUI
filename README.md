<div align="center">

<img src="docs/public/logo.svg" width="96" height="96" alt="ANUI logo">

# ANUI

**A modern, feature-rich UI library for Roblox script executors.**

15 elements, 26 built-in themes, a config system with flags, a key system,
localization and a drift-free loop scheduler — in a single `loadstring`.

[![version](https://img.shields.io/github/package-json/v/ANHub-Script/ANUI?style=for-the-badge&label=version&labelColor=1c1c1c&color=40c9ff)](https://github.com/ANHub-Script/ANUI/releases)
[![docs](https://img.shields.io/badge/docs-anui-e81cff?style=for-the-badge&labelColor=1c1c1c)](https://ANHub-Script.github.io/ANUI/)
[![discord](https://img.shields.io/badge/discord-join-5865F2?style=for-the-badge&logo=discord&logoColor=white&labelColor=1c1c1c)](https://discord.gg/bUkCZvmrpH)
[![license](https://img.shields.io/badge/license-MIT-30ff6a?style=for-the-badge&labelColor=1c1c1c)](#license)

**[Documentation](https://ANHub-Script.github.io/ANUI/)** ·
[Quick Start](https://ANHub-Script.github.io/ANUI/guide/getting-started) ·
[Elements](https://ANHub-Script.github.io/ANUI/elements/) ·
[API Cheatsheet](https://ANHub-Script.github.io/ANUI/api/) ·
[Demo script](main_example.lua)

Read the docs in
[English](https://ANHub-Script.github.io/ANUI/) ·
[Bahasa Indonesia](https://ANHub-Script.github.io/ANUI/id/) ·
[Русский](https://ANHub-Script.github.io/ANUI/ru/) ·
[简体中文](https://ANHub-Script.github.io/ANUI/zh/)

</div>

> [!WARNING]
> **ANUI is in beta.** The API is settling down but breaking changes are still possible
> between releases. Pin a release tag if you need stability, and check the
> [release notes](https://github.com/ANHub-Script/ANUI/releases) before updating.

---

## Install

One line. That's the whole installation.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

Full details, version pinning and offline usage: **[Installation guide](https://ANHub-Script.github.io/ANUI/guide/installation)**

## Quick start

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

-- Only ONE window may exist at a time.
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",  -- enables the config system and SaveKey
    Theme = "Dark",
})

local Main = Window:Tab({ Title = "Main", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Flag = "AutoFarm",              -- value is saved with the config
    Callback = function(state)      -- boolean
        print("Auto Farm:", state)
    end,
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value)      -- formatted STRING, not a number
        print("Walk Speed:", tonumber(value))
    end,
})

Main:Button({
    Title = "Say Hello",
    Icon = "bell",
    Callback = function()
        ANUI:Notify({
            Title = "Hello!",
            Content = "Welcome to ANUI",  -- body field is Content, not Desc
            Icon = "bell",
            Duration = 3,
        })
    end,
})
```

Walkthrough with commentary: **[Quick Start](https://ANHub-Script.github.io/ANUI/guide/getting-started)** ·
**[Basic Menu example](https://ANHub-Script.github.io/ANUI/examples/basic-menu)**

## Elements

Every element is created from a **container** — a Tab, a `Tab:Section`, a `Tab:Group`,
or a Paragraph. Containers all expose the same element-creation methods.

| Element | What it does | Callback receives |
| --- | --- | --- |
| [Button](https://ANHub-Script.github.io/ANUI/elements/button) | Clickable action row with an optional icon and inline buttons | nothing |
| [Toggle](https://ANHub-Script.github.io/ANUI/elements/toggle) | On/off switch or checkbox (`Type = "Checkbox"`) | `boolean` |
| [Slider](https://ANHub-Script.github.io/ANUI/elements/slider) | Numeric slider with stepping and manual entry | formatted `string` |
| [Dropdown](https://ANHub-Script.github.io/ANUI/elements/dropdown) | Single/multi-select list, or an action menu | value, or array when `Multi` |
| [Input](https://ANHub-Script.github.io/ANUI/elements/input) | Single-line or `Textarea` text field | `string` |
| [Keybind](https://ANHub-Script.github.io/ANUI/elements/keybind) | Binds an action to a key, fires globally | key-name `string` |
| [Colorpicker](https://ANHub-Script.github.io/ANUI/elements/colorpicker) | Color + optional transparency, via a dialog | `(Color3, transparency)` |
| [Paragraph](https://ANHub-Script.github.io/ANUI/elements/paragraph) | Rich-text block with image cards and stacked buttons | — |
| [Code](https://ANHub-Script.github.io/ANUI/elements/code) | Copyable code snippet | — |
| [Section](https://ANHub-Script.github.io/ANUI/elements/section) | Collapsible container grouping child elements | — |
| [Divider](https://ANHub-Script.github.io/ANUI/elements/divider) | Separator line — horizontal, or vertical inside a Group | — |
| [Space](https://ANHub-Script.github.io/ANUI/elements/space) | Invisible spacer (`Columns × 7px`) | — |
| [Image](https://ANHub-Script.github.io/ANUI/elements/image) | Standalone image with aspect-ratio and scaling control | — |
| [Group](https://ANHub-Script.github.io/ANUI/elements/group) | Container that lays its children out horizontally | — |
| [Category](https://ANHub-Script.github.io/ANUI/elements/category) | Horizontal option strip that swaps pages of elements | option name `string` |

Shared config fields (`Title`, `Desc`, `Icon`, `Image`, `Color`, `Locked`, `Buttons`,
gradients) and shared methods (`:SetTitle`, `:Lock`, `:Highlight`, `:Destroy`, …) are
documented once in the **[Elements overview](https://ANHub-Script.github.io/ANUI/elements/)**.

## Features

| Feature | Entry point | Docs |
| --- | --- | --- |
| **Window & tabs** | `ANUI:CreateWindow{}` · `Window:Tab{}` · `Window:Section{}` | [Window config](https://ANHub-Script.github.io/ANUI/guide/window-configuration) · [Tabs & Sections](https://ANHub-Script.github.io/ANUI/guide/tabs-and-sections) |
| **Notifications** | `ANUI:Notify{}` | [Notifications](https://ANHub-Script.github.io/ANUI/features/notifications) |
| **Dialogs & popups** | `Window:Dialog{}` · `ANUI:Popup{}` | [Dialogs & Popups](https://ANHub-Script.github.io/ANUI/features/dialogs-and-popups) |
| **Config & flags** | `Flag = "key"` · `Window.ConfigManager` | [Config & Flags](https://ANHub-Script.github.io/ANUI/features/config-and-flags) |
| **Key system** | `KeySystem = {...}` — local keys, custom validator, or Luarmor / Platoboost / Panda Development | [Key System](https://ANHub-Script.github.io/ANUI/features/key-system) |
| **Themes** | `ANUI:SetTheme(name)` · `ANUI:AddTheme{}` — 26 built-ins | [Themes & Appearance](https://ANHub-Script.github.io/ANUI/features/themes) |
| **Localization** | `ANUI:Localization{}` · `ANUI:SetLanguage(lang)` | [Localization](https://ANHub-Script.github.io/ANUI/features/localization) |
| **Scheduler & loops** | `Window:Loop(...)` · `ANUI:Scheduler{}` | [Scheduler & Loops](https://ANHub-Script.github.io/ANUI/features/scheduler) |
| **Open button** | `OpenButton = {...}` · `Window:EditOpenButton{}` | [Open Button](https://ANHub-Script.github.io/ANUI/features/open-button) |

Other niceties: acrylic blur, transparent and image/video backgrounds, rich-text tokens
in `Title` and `Desc` (inline icons, gradients, inline buttons), tab profile cards,
custom topbar buttons, a collapsible sidebar, mobile auto-scaling, and per-element locking.

## Persisting state

Give any stateful element a `Flag` and it registers itself with the active config.
Only **Toggle, Slider, Dropdown, Input, Keybind and Colorpicker** persist.

```lua
local ConfigManager = Window.ConfigManager          -- requires Folder on the window
Window.CurrentConfig = ConfigManager:CreateConfig("default")

Main:Toggle({ Title = "Auto Farm", Flag = "AutoFarm", Callback = function(v) end })

Window.CurrentConfig:Save()                          -- → ANUI/MyHub/config/default.json
Window.CurrentConfig:Load()
```

Full save/load panel: **[Config System example](https://ANHub-Script.github.io/ANUI/examples/config-system)**

## Examples

| Example | Shows |
| --- | --- |
| [Basic Menu](https://ANHub-Script.github.io/ANUI/examples/basic-menu) | A complete starter menu, heavily commented |
| [Config System](https://ANHub-Script.github.io/ANUI/examples/config-system) | Name input, config dropdown, auto-load, save/load buttons |
| [Category Pages](https://ANHub-Script.github.io/ANUI/examples/category-pages) | One tab, several swappable pages of elements |
| [`main_example.lua`](main_example.lua) | The full demo — every element and feature in one script |

## Documentation

The docs are a VitePress site living in [`docs/`](docs/) and published to GitHub Pages
in four languages. See [`docs/README.md`](docs/README.md) to run or edit them locally.

- [Introduction](https://ANHub-Script.github.io/ANUI/guide/introduction) — what ANUI is and how it's put together
- [Installation](https://ANHub-Script.github.io/ANUI/guide/installation) — loading the library, executor requirements
- [Quick Start](https://ANHub-Script.github.io/ANUI/guide/getting-started) — your first menu, step by step
- [Window Configuration](https://ANHub-Script.github.io/ANUI/guide/window-configuration) — every window field and method
- [Tabs & Sections](https://ANHub-Script.github.io/ANUI/guide/tabs-and-sections) — organizing the sidebar
- [Elements](https://ANHub-Script.github.io/ANUI/elements/) — one page per element, full config tables
- [API Cheatsheet](https://ANHub-Script.github.io/ANUI/api/) — the entire surface on one page

## Requirements

- A Roblox script executor with `game:HttpGet` support.
- For the **config system** and `SaveKey`: file globals — `readfile`, `writefile`,
  `isfile`, `makefolder` (and `gethwid` for `SaveKey`).
- For **key providers**: HTTP request support.

Everything else — the whole UI, notifications, dialogs, themes, loops — works without
any executor file functions.

## Contributing

Issues and pull requests are welcome.

- [Report a bug](https://github.com/ANHub-Script/ANUI/issues/new)
- [Request a feature](https://github.com/ANHub-Script/ANUI/issues/new)
- Working on the docs? Start with [`docs/README.md`](docs/README.md).

## Credits

ANUI is a fork of **[WindUI](https://github.com/Footagesus/WindUI)** by
[Footagesus](https://github.com/Footagesus), which itself draws on work by
[Dawid-Scripts](https://github.com/Dawid-Scripts). Icons come from
[Lucide](https://lucide.dev).

## License

Released under the **MIT License**. Copyright © 2024–present ANHub-Script.

<div align="center">

**[Docs](https://ANHub-Script.github.io/ANUI/)** ·
**[Discord](https://discord.gg/bUkCZvmrpH)** ·
**[YouTube](https://www.youtube.com/@ANHubRoblox)** ·
**[GitHub](https://github.com/ANHub-Script/ANUI)**

</div>
