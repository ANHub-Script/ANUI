# API Cheatsheet

Everything on one page. A dense quick reference for the whole ANUI surface — top-level calls, Window and Tab methods, every element, and the feature entry points. Follow a link for the full details.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## `ANUI` (top-level)

Methods and fields on the library object itself.

| Call | Purpose |
| --- | --- |
| `ANUI:CreateWindow(config)` → `Window` | Create the window (only one may exist). |
| `ANUI:Notify(config)` → notification | Show a toast notification. |
| `ANUI:SetNotificationLower(bool)` | Move notifications to the lower part of the screen. |
| `ANUI:SetFont(fontId)` | Set the global UI font. |
| `ANUI:OnThemeChange(fn)` | Run `fn` whenever the theme changes. |
| `ANUI:AddTheme(theme)` → theme | Register a custom theme (keyed by its `.Name`). |
| `ANUI:SetTheme(name)` → theme \| `nil` | Switch to a theme by name. |
| `ANUI:GetThemes()` | Return all registered themes. |
| `ANUI:GetCurrentTheme()` | Return the active theme. |
| `ANUI:GetTransparency()` | Return the current transparency value. |
| `ANUI:GetWindowSize()` | Return the current window size. |
| `ANUI:Localization(config)` | Configure translations. |
| `ANUI:SetLanguage(lang)` | Switch language (requires localization enabled). |
| `ANUI:ToggleAcrylic(bool)` | Turn the acrylic blur effect on or off. |
| `ANUI:Gradient(stops, props)` → gradient | Build a gradient data table (stops keyed `"0"`..`"100"`). |
| `ANUI:Popup(config)` → `Popup` | Open a modal popup. |
| `ANUI:Scheduler(config)` → `Scheduler` | Create a standalone loop scheduler. |
| `ANUI.Version` | The library version string (field, not a method). |

## Window methods

Returned by `ANUI:CreateWindow`. Grouped by purpose; signatures in backticks.

**Tabs & containers**

| Method | Purpose |
| --- | --- |
| `Window:Tab(config)` | Add a tab (a sidebar page that holds elements). |
| `Window:Section(config)` | Add a sidebar section that groups tabs. |
| `Window:SelectTab(index)` | Switch to a tab by its index. |
| `Window:Divider()` | Add a divider line in the sidebar. |
| `Window:Tag(config)` | Add a small tag/badge (e.g. version) to the window. |

**Dialogs**

| Method | Purpose |
| --- | --- |
| `Window:Dialog({ Title, Content, Icon, Width, Buttons })` | Open a modal dialog. Each button is `{ Title, Icon, Callback, Variant }` (`Width` defaults to `320`). |

**Lifecycle & callbacks**

| Method | Purpose |
| --- | --- |
| `Window:Open()` / `Window:Close()` / `Window:Toggle()` | Show, hide, or toggle the window. |
| `Window:Destroy()` | Destroy the window and clean up. |
| `Window:OnOpen(fn)` / `Window:OnClose(fn)` / `Window:OnDestroy(fn)` | Run `fn` on the matching event. |

**Appearance**

| Method | Purpose |
| --- | --- |
| `Window:SetTitle(t)` / `Window:SetAuthor(t)` | Update the title / subtitle. |
| `Window:SetIconSize(n \| UDim2)` | Resize the top-bar icon. |
| `Window:SetBackgroundImage(id)` / `Window:SetBackgroundImageTransparency(v)` | Set the background image and its transparency. |
| `Window:SetBackgroundTransparency(v)` / `Window:ToggleTransparency(bool)` | Adjust or toggle window transparency. |
| `Window:SetToTheCenter()` | Recenter the window on screen. |
| `Window:GetUIScale()` / `Window:SetUIScale(v)` | Read or set the UI scale. |
| `Window:IsResizable(bool)` | Enable or disable resizing. |

**Sidebar**

| Method | Purpose |
| --- | --- |
| `Window:CollapseSidebar()` / `Window:ExpandSidebar()` / `Window:ToggleSidebar(state?)` | Collapse, expand, or toggle the sidebar. |

**Toggle key**

| Method | Purpose |
| --- | --- |
| `Window:SetToggleKey(keycode)` | Set the show/hide hotkey (an `Enum.KeyCode`). |

**Locks**

| Method | Purpose |
| --- | --- |
| `Window:LockAll()` / `Window:UnlockAll()` | Lock or unlock every element. |
| `Window:GetLocked()` / `Window:GetUnlocked()` | List locked / unlocked elements. |

**Topbar**

| Method | Purpose |
| --- | --- |
| `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` | Add a custom top-bar button. |
| `Window:DisableTopbarButtons({ names })` | Hide built-in top-bar buttons by name. |

**Open button**

| Method | Purpose |
| --- | --- |
| `Window:EditOpenButton(config)` | Edit the floating open button. |

**Loops & scheduler**

| Method | Purpose |
| --- | --- |
| `Window:Loop(key, interval, fn, opts?)` | Run `fn` every `interval` seconds. |
| `Window:StatusLoop(key, interval, fn)` | A loop intended for updating status text. |
| `Window:ManagedLoop(key, interval, predicate, fn)` | Loop that runs only while `predicate` returns true. |
| `Window:StopLoop(key)` / `Window:StopAllLoops()` | Stop one loop, or all of them. |
| `Window:IsLoopRunning(key)` / `Window:GetActiveLoopCount()` | Query loop state. |
| `Window:AddConnection(conn)` / `Window:DisconnectAll()` | Track and clean up connections. |
| `Window:IsReady()` | Whether the window has finished initializing. |

## Tab methods

| Method | Purpose |
| --- | --- |
| `Tab:Select()` | Make this the active tab. |
| `Tab:ScrollToTheElement(index)` | Scroll to an element by index. |
| `Tab:LockAll()` / `Tab:UnlockAll()` | Lock or unlock every element in the tab. |
| `Tab:GetLocked()` / `Tab:GetUnlocked()` | List locked / unlocked elements in the tab. |
| `Tab:ReserveHeader(height, config)` | Reserve a fixed header area at the top of the tab. |

::: info
A Tab also exposes **every element-creation method** — `Tab:Button{}`, `Tab:Toggle{}`, `Tab:Slider{}`, and so on. `Section` and `Group` are containers with the same element methods.
:::

## Elements quick reference

One row per element. The callback argument is what your `Callback` function receives.

| Element | Signature | Key config | Callback argument |
| --- | --- | --- | --- |
| [Button](/elements/button) | `Tab:Button{}` | `Callback`, `Icon` | none |
| [Toggle](/elements/toggle) | `Tab:Toggle{}` | `Value`, `Type` | `boolean` |
| [Slider](/elements/slider) | `Tab:Slider{}` | `Value { Min, Max, Default }`, `Step` | formatted `string` |
| [Dropdown](/elements/dropdown) | `Tab:Dropdown{}` | `Values`, `Multi` | selected value (single) / array (multi) |
| [Input](/elements/input) | `Tab:Input{}` | `Placeholder`, `Type` | `string` |
| [Keybind](/elements/keybind) | `Tab:Keybind{}` | `Value` (key name) | key-name `string` |
| [Colorpicker](/elements/colorpicker) | `Tab:Colorpicker{}` | `Default`, `Transparency` | `(Color3, transparency)` |
| [Paragraph](/elements/paragraph) | `Tab:Paragraph{}` | `Title`, `Desc`, `Images` | — |
| [Code](/elements/code) | `Tab:Code{}` | `Code`, `OnCopy` | — |
| [Section](/elements/section) | `Tab:Section{}` | `Title`, `Opened` | — |
| [Divider](/elements/divider) | `Tab:Divider()` | — | — |
| [Space](/elements/space) | `Tab:Space{}` | `Columns` | — |
| [Image](/elements/image) | `Tab:Image{}` | `Image`, `AspectRatio` | — |
| [Group](/elements/group) | `Tab:Group{}` | — (container) | — |
| [Category](/elements/category) | `Tab:Category{}` | `Options`, `Default` | selected option name (`string`) |

## Features quick reference

| Feature | Entry call | Docs |
| --- | --- | --- |
| Notifications | `ANUI:Notify{}` | [Notifications](/features/notifications) |
| Dialog & Popup | `Window:Dialog{}` · `ANUI:Popup{}` | [Dialogs & Popups](/features/dialogs-and-popups) |
| Config & Flags | `Window.ConfigManager` · `Flag = "..."` | [Config & Flags](/features/config-and-flags) |
| Key System | `ANUI:CreateWindow{ KeySystem = {...} }` | [Key System](/features/key-system) |
| Themes | `ANUI:SetTheme(name)` · `ANUI:AddTheme{}` | [Themes & Appearance](/features/themes) |
| Localization | `ANUI:Localization{}` · `ANUI:SetLanguage(lang)` | [Localization](/features/localization) |
| Scheduler & Loops | `ANUI:Scheduler{}` · `Window:Loop(...)` | [Scheduler & Loops](/features/scheduler) |
