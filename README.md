<div align="center">

<img src="docs/public/logo.svg" width="112" height="112" alt="ANUI logo">

# ANUI

### Build better Roblox interfaces.

**A modern, feature-rich UI library for Roblox script executors — designed for clean menus, fast setup, and flexible customization.**

<p>
  <a href="https://ANHub-Script.github.io/ANUI/"><strong>Documentation</strong></a> ·
  <a href="https://ANHub-Script.github.io/ANUI/guide/getting-started"><strong>Quick Start</strong></a> ·
  <a href="https://github.com/ANHub-Script/ANUI/releases"><strong>Releases</strong></a> ·
  <a href="https://discord.gg/qN47S3mKZA"><strong>Discord</strong></a>
</p>

[![version](https://img.shields.io/github/package-json/v/ANHub-Script/ANUI?style=for-the-badge&label=version&labelColor=111111&color=40c9ff)](https://github.com/ANHub-Script/ANUI/releases)
[![docs](https://img.shields.io/badge/docs-anui-e81cff?style=for-the-badge&labelColor=111111)](https://ANHub-Script.github.io/ANUI/)
[![license](https://img.shields.io/badge/license-MIT-30ff6a?style=for-the-badge&labelColor=111111)](#license)
[![discord](https://img.shields.io/badge/discord-community-5865F2?style=for-the-badge&logo=discord&logoColor=white&labelColor=111111)](https://discord.gg/qN47S3mKZA)

**15+ UI elements · 26 built-in themes · Config & Flags · Key System · Localization · Scheduler**

</div>

> [!WARNING]
> **ANUI is currently in beta.** The API is settling down, but breaking changes are still possible between releases. Pin a release tag for production scripts and read the release notes before upgrading.

---

## Why ANUI?

ANUI is built for developers who want a **complete Roblox UI layer without spending hours wiring individual components together**.

- **Modern interface** — polished windows, tabs, dialogs, notifications, acrylic effects, and responsive layouts.
- **Fast integration** — load the library and start building your menu immediately.
- **Rich component set** — buttons, toggles, sliders, dropdowns, inputs, keybinds, colorpickers, groups, categories, images, code blocks, and more.
- **Built for customization** — 26 themes, custom themes, gradients, icons, images, locking, scaling, and topbar controls.
- **State management included** — flags and a config manager make persistent UI state straightforward.
- **Developer-friendly utilities** — localization, scheduler/loops, key systems, popups, and notifications are included in the same API.
- **Documentation-first** — examples, API references, and documentation are available in English, Bahasa Indonesia, Русский, and 简体中文.

> **ANUI's goal:** make the UI layer the easy part of your script.

## Install

One line is enough to load the latest `main` build:

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

For stable projects, prefer a release tag instead of `main`. See the **[Installation guide](https://ANHub-Script.github.io/ANUI/guide/installation)** for version pinning and offline usage.

## Quick start

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub", -- enables the config system and SaveKey
    Theme = "Dark",
})

local Main = Window:Tab({
    Title = "Main",
    Icon = "house",
})

Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Flag = "AutoFarm",
    Callback = function(state)
        print("Auto Farm:", state)
    end,
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value)
        print("Walk Speed:", tonumber(value))
    end,
})

Main:Button({
    Title = "Say Hello",
    Icon = "bell",
    Callback = function()
        ANUI:Notify({
            Title = "Hello!",
            Content = "Welcome to ANUI",
            Icon = "bell",
            Duration = 3,
        })
    end,
})
```

**[Follow the Quick Start →](https://ANHub-Script.github.io/ANUI/guide/getting-started)**

## Features at a glance

| Area | Included |
| --- | --- |
| **UI** | Windows, tabs, sections, groups, categories, responsive/mobile scaling |
| **Elements** | Button, Toggle, Slider, Dropdown, Input, Keybind, Colorpicker, Paragraph, Code, Divider, Space, Image, Group, Category, Section |
| **Appearance** | 26 built-in themes, custom themes, gradients, icons, acrylic, transparency, image/video backgrounds |
| **State** | Flags, Config Manager, save/load, persistent element state |
| **Interaction** | Notifications, dialogs, popups, open button, locking, topbar controls |
| **Developer tools** | Localization, scheduler, loops, key system, API helpers |
| **Docs** | Guides, API cheatsheet, examples, multilingual documentation |

### Elements

| Element | Purpose | Callback |
| --- | --- | --- |
| [Button](https://ANHub-Script.github.io/ANUI/elements/button) | Clickable action row with optional icon and inline buttons | nothing |
| [Toggle](https://ANHub-Script.github.io/ANUI/elements/toggle) | Switch or checkbox | `boolean` |
| [Slider](https://ANHub-Script.github.io/ANUI/elements/slider) | Numeric slider with stepping and manual entry | formatted `string` |
| [Dropdown](https://ANHub-Script.github.io/ANUI/elements/dropdown) | Single/multi-select list or action menu | value / array |
| [Input](https://ANHub-Script.github.io/ANUI/elements/input) | Single-line or textarea input | `string` |
| [Keybind](https://ANHub-Script.github.io/ANUI/elements/keybind) | Global key-bound action | key-name `string` |
| [Colorpicker](https://ANHub-Script.github.io/ANUI/elements/colorpicker) | Color and optional transparency picker | `(Color3, transparency)` |
| [Paragraph](https://ANHub-Script.github.io/ANUI/elements/paragraph) | Rich text block with images and buttons | — |
| [Code](https://ANHub-Script.github.io/ANUI/elements/code) | Copyable code snippet | — |
| [Section](https://ANHub-Script.github.io/ANUI/elements/section) | Collapsible element container | — |
| [Divider](https://ANHub-Script.github.io/ANUI/elements/divider) | Horizontal or group separator | — |
| [Space](https://ANHub-Script.github.io/ANUI/elements/space) | Invisible spacing element | — |
| [Image](https://ANHub-Script.github.io/ANUI/elements/image) | Standalone responsive image | — |
| [Group](https://ANHub-Script.github.io/ANUI/elements/group) | Horizontal child layout | — |
| [Category](https://ANHub-Script.github.io/ANUI/elements/category) | Switchable horizontal page/category strip | option name |

All containers share the same element-creation model, so you can compose interfaces without learning a different API for every layout.

## Themes & customization

ANUI ships with **26 built-in themes** and supports custom themes through the same API.

```lua
ANUI:SetTheme("Dark")

ANUI:AddTheme({
    Name = "MyTheme",
    -- theme configuration
})
```

Themes are only part of the customization layer. ANUI also supports gradients, rich-text tokens, icons, custom images, acrylic blur, transparent backgrounds, video backgrounds, per-element locking, mobile auto-scaling, and custom topbar controls.

**[Explore Themes & Appearance →](https://ANHub-Script.github.io/ANUI/features/themes)**

## Config & flags

Stateful elements can register a `Flag` with the active config.

```lua
local ConfigManager = Window.ConfigManager
Window.CurrentConfig = ConfigManager:CreateConfig("default")

Main:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(value) end,
})

Window.CurrentConfig:Save()
Window.CurrentConfig:Load()
```

Persistent elements include **Toggle, Slider, Dropdown, Input, Keybind, and Colorpicker**.

**[Read Config & Flags →](https://ANHub-Script.github.io/ANUI/features/config-and-flags)**

## Key system

ANUI supports local keys, custom validation, and supported external key providers.

**[Read Key System →](https://ANHub-Script.github.io/ANUI/features/key-system)**

## Localization

Build multilingual menus without rewriting your UI logic.

```lua
ANUI:Localization({
    -- localization configuration
})

ANUI:SetLanguage("id")
```

Supported documentation languages currently include English, Bahasa Indonesia, Русский, and 简体中文.

**[Read Localization →](https://ANHub-Script.github.io/ANUI/features/localization)**

## Examples

| Example | What it demonstrates |
| --- | --- |
| [Basic Menu](https://ANHub-Script.github.io/ANUI/examples/basic-menu) | Complete starter menu with comments |
| [Config System](https://ANHub-Script.github.io/ANUI/examples/config-system) | Save/load, flags, config selection, auto-load |
| [Category Pages](https://ANHub-Script.github.io/ANUI/examples/category-pages) | Multiple pages inside one tab |
| [`main_example.lua`](main_example.lua) | Full feature demo |

## Documentation

The documentation is built with VitePress and published to GitHub Pages.

- [Introduction](https://ANHub-Script.github.io/ANUI/guide/introduction)
- [Installation](https://ANHub-Script.github.io/ANUI/guide/installation)
- [Quick Start](https://ANHub-Script.github.io/ANUI/guide/getting-started)
- [Window Configuration](https://ANHub-Script.github.io/ANUI/guide/window-configuration)
- [Tabs & Sections](https://ANHub-Script.github.io/ANUI/guide/tabs-and-sections)
- [Elements](https://ANHub-Script.github.io/ANUI/elements/)
- [API Cheatsheet](https://ANHub-Script.github.io/ANUI/api/)

## Requirements

- A Roblox script executor with `game:HttpGet` support.
- The **config system** and `SaveKey` require file globals such as `readfile`, `writefile`, `isfile`, and `makefolder` (plus `gethwid` for `SaveKey`).
- Key providers require HTTP request support.

The UI itself, notifications, dialogs, themes, loops, and other non-filesystem features do not intentionally depend on config file APIs.

## Versioning & releases

ANUI uses semantic-style versions:

```text
MAJOR.MINOR.PATCH
  │     │     └─ fixes / small improvements
  │     └────── compatible features
  └──────────── breaking changes
```

Releases are published from Git tags in the format `vX.Y.Z`.

```bash
git tag v1.0.289
git push origin v1.0.289
```

The release workflow automatically verifies the tag against `package.json`, generates GitHub release notes from commits and pull requests, publishes the release, and attaches `dist/main.lua`.

See [`CHANGELOG.md`](CHANGELOG.md) for the curated project history and the **[Releases](https://github.com/ANHub-Script/ANUI/releases)** page for published versions.

## Contributing

Issues and pull requests are welcome.

- [Report a bug](https://github.com/ANHub-Script/ANUI/issues/new)
- [Request a feature](https://github.com/ANHub-Script/ANUI/issues/new)
- For documentation work, start with [`docs/README.md`](docs/README.md).

When proposing a breaking API change, please explain the migration path and update the relevant documentation/examples.

## Credits

ANUI is a fork of **[WindUI](https://github.com/Footagesus/WindUI)** by [Footagesus](https://github.com/Footagesus), which itself draws on work by [Dawid-Scripts](https://github.com/Dawid-Scripts). Icons come from [Lucide](https://lucide.dev).

## License

Released under the **MIT License**. Copyright © 2024–present ANHub-Script.

<div align="center">

**[Docs](https://ANHub-Script.github.io/ANUI/)** · **[Releases](https://github.com/ANHub-Script/ANUI/releases)** · **[Discord](https://discord.gg/qN47S3mKZA)** · **[YouTube](https://www.youtube.com/@ANHubRoblox)** · **[GitHub](https://github.com/ANHub-Script/ANUI)**

</div>
