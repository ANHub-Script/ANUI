# Window Configuration

The window is the root of every ANUI menu. You create it once with `ANUI:CreateWindow{}`, passing a single config table. This page documents every field and the methods available on the returned `Window` object.

::: info Only one window
Only one window may exist at a time. A second `ANUI:CreateWindow` call warns and returns `nil`.
:::

## Basic example

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
    Theme = "Dark",
})
```

## Configuration

### Identity

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | Window title text. |
| `Author` | `string` | — | Subtitle shown under the title. |
| `Icon` | `string` | — | Window icon: a Lucide icon name or `rbxassetid://…`. |
| `IconSize` | `number` \| `UDim2` | `22` | Icon size in pixels. |
| `IconThemed` | `boolean` | — | Tint the icon with the theme's icon color. |

### Storage

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Folder` | `string` | — | On-disk storage folder. Setting it enables the [config system](/features/config-and-flags) and the [key system](/features/key-system) `SaveKey` option. Configs are written to `ANUI/<Folder>/config/<name>.json`. |

### Size & scaling

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Size` | `UDim2` | `580 × 460` (clamped) | Initial window size. |
| `MinSize` | `Vector2` | `850 × 560` | Minimum size when resizing. |
| `MaxSize` | `Vector2` | `1050 × 560` | Maximum size when resizing. |
| `Resizable` | `boolean` | `true` | Allow the user to resize the window. |
| `AutoScale` | `boolean` | `true` | Automatically scale the UI (mobile-friendly). |

### Appearance

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Theme` | `string` | `"Dark"` | Theme name — see [Themes](/features/themes). |
| `Transparent` | `boolean` | `false` | Use a transparent window background. |
| `Acrylic` | `boolean` | `false` | Acrylic blur behind the window. |
| `Background` | `Color3` \| image id \| `"https://…"` \| `"video:…"` \| gradient table | — | Custom window background. |
| `BackgroundImageTransparency` | `number` | `0` | Transparency of the background image. |
| `ShadowTransparency` | `number` | `0.7` | Window drop-shadow transparency. |
| `Radius` | `number` | `16` | Window corner radius. |
| `ElementsRadius` | `number` | — | Corner radius applied to elements. |
| `SideBarWidth` | `number` | `200` | Sidebar width in pixels. |
| `HidePanelBackground` | `boolean` | `false` | Hide the content panel background. |
| `ScrollBarEnabled` | `boolean` | `false` | Show the content scrollbar. |

### Behavior

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `ToggleKey` | `Enum.KeyCode` | — | Key that shows / hides the window. |
| `HideSearchBar` | `boolean` | `true` | Hide the element search bar. Set `false` to show it. |
| `NewElements` | `boolean` | `false` | Opt into the newer element style. |
| `IgnoreAlerts` | `boolean` | `false` | Suppress built-in alert popups. |

### Sub-configs

These fields take their own config tables and are documented on dedicated pages.

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `OpenButton` | `table` | — | Floating button that reopens the window. See [Open Button](/features/open-button). |
| `KeySystem` | `table` | — | Gate the menu behind a key. See [Key System](/features/key-system). |
| `User` | `table` | — | User display block: `{ Enabled, Anonymous, Callback }`. |

## Window methods

Once you have a `Window`, these methods control it at runtime.

### Lifecycle

- `Window:Open()` — show the window.
- `Window:Close()` — hide the window; returns an object with `:Destroy()`.
- `Window:Destroy()` — permanently remove the window.
- `Window:Toggle()` — flip between open and closed.
- `Window:OnOpen(fn)` — run `fn` whenever the window opens.
- `Window:OnClose(fn)` — run `fn` whenever the window closes.
- `Window:OnDestroy(fn)` — run `fn` when the window is destroyed.

### Appearance

- `Window:SetTitle(text)` — change the title.
- `Window:SetAuthor(text)` — change the subtitle.
- `Window:SetIconSize(n | UDim2)` — resize the window icon.
- `Window:SetBackgroundImage(id)` — swap the background image.
- `Window:ToggleTransparency(bool)` — toggle the transparent background.
- `Window:SetUIScale(v)` — set the UI scale (read it back with `Window:GetUIScale()`).

### Sidebar

- `Window:CollapseSidebar()` — collapse the sidebar.
- `Window:ExpandSidebar()` — expand the sidebar.
- `Window:ToggleSidebar(state?)` — toggle, or force a state when `state` is given.

```lua
task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
```

### Toggle key

- `Window:SetToggleKey(keycode)` — change the show / hide key at runtime.

```lua
Window:SetToggleKey(Enum.KeyCode.G)
```

### Locks

- `Window:LockAll()` — lock every element in the window.
- `Window:UnlockAll()` — unlock every element in the window.

### Topbar

- `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` — add a button to the window's top bar.
- `Window:DisableTopbarButtons({names})` — disable specific topbar buttons by name.

### Tag

`Window:Tag(cfg)` adds a small labelled tag to the window — handy for showing a version badge.

```lua
Window:Tag({ Title = "v" .. ANUI.Version, Icon = "github" })
```

### Dialogs

`Window:Dialog{}` opens a modal dialog. See [Dialogs & Popups](/features/dialogs-and-popups).

### Loops

`Window:Loop`, `Window:StatusLoop`, `Window:ManagedLoop` and their companions run managed loops that stop automatically when the window closes or is destroyed. See [Scheduler & Loops](/features/scheduler).

## Next steps

- Add [Tabs & Sections](/guide/tabs-and-sections) to organize your menu.
- Restyle everything with [Themes](/features/themes).
