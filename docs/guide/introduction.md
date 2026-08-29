# Introduction

ANUI (Advanced Roblox UI Library) is a modern, feature-rich UI library for Roblox script executors. It lets you build a clean, mobile-ready menu — windows, tabs, toggles, sliders, dropdowns and more — in just a few lines of Lua.

## What is ANUI?

ANUI renders a floating, draggable, resizable window on top of any Roblox experience. You describe your menu declaratively — create a window, add tabs, drop elements into them — and ANUI handles layout, theming, input, animation and persistence for you.

Because it loads over HTTP with a single `loadstring`, there is nothing to install or bundle: paste one line and your menu is live.

## What you can build

- Feature hubs and cheat menus with organized tabs and sidebar sections
- Settings panels whose state persists across sessions via [Config & Flags](/features/config-and-flags)
- Key-gated scripts using the built-in [Key System](/features/key-system)
- Rich dashboards with profiles, badges, notifications and dialogs

## Feature highlights

- 15+ [elements](/elements/) — buttons, toggles, sliders, dropdowns, colorpickers, keybinds, inputs, code blocks and more
- [26 built-in themes](/features/themes), plus your own custom palettes
- [Config & flags](/features/config-and-flags) to persist any element's state to disk
- A [key system](/features/key-system) with Luarmor, Platoboost and PandaDevelopment providers
- [Notifications](/features/notifications) and [dialogs & popups](/features/dialogs-and-popups)
- [Localization](/features/localization) for multi-language menus
- A drift-free [scheduler](/features/scheduler) for managed loops
- [Mobile-ready scaling and acrylic blur](/guide/window-configuration)

## Requirements

ANUI runs inside a Roblox script executor. Your executor must support:

- `loadstring` and `game:HttpGet` — required to load the library
- `readfile`, `writefile`, `isfile`, `makefolder` — required only for saving configs and keys

::: info Only one window
Only one window may exist at a time. Calling `ANUI:CreateWindow` a second time warns and returns `nil`.
:::

## Credits

- Based on **WindUI by Footagesus**
- Icons by [Lucide](https://lucide.dev)
- Thanks to Dawid-Scripts

## Links

- GitHub: [github.com/ANHub-Script/ANUI](https://github.com/ANHub-Script/ANUI)
- Discord: [https://discord.gg/qN47S3mKZA](https://discord.gg/qN47S3mKZA)
- YouTube: [@ANHubRoblox](https://www.youtube.com/@ANHubRoblox)

---

Next: [Installation](/guide/installation)
