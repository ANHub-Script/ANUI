# Elements

Elements are the interactive controls inside your window — buttons, toggles, sliders, dropdowns and more. They are always created from a **container**: a Tab, a Section, or a Group.

## Creating elements

Every element is created by calling a method on a container. The most common container is a Tab:

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "My Hub", Folder = "MyHub" })

-- 1. Create a container (a Tab)
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

-- 2. Create elements on it
myTab:Button({ Title = "Click me", Callback = function() end })
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
```

`Section` and `Group` are also containers — they expose the **same** element-creation methods as a Tab, so you can nest elements to organize your layout:

```lua
local section = myTab:Section({ Title = "Combat" })
section:Toggle({ Title = "God Mode", Callback = function(state) end })

local row = myTab:Group({})       -- lays children out horizontally
row:Button({ Title = "Save" })
row:Button({ Title = "Load" })
```

::: tip
Each element-creation method returns a module you call methods on (e.g. `local t = myTab:Toggle({...})` then `t:Set(true)`). Keep the returned value if you plan to update the element later.
:::

## Shared base

Most interactive elements are built on a common base, so they share a set of config fields and methods. Learn them once and they apply everywhere.

### Common configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | element name | Main label. Supports [rich-text tokens](#rich-text-in-title-desc). |
| `Desc` | `string` | `nil` | Secondary description line. Supports rich-text tokens, `\n` and `\t`. |
| `Icon` | `string` | element-specific | Icon name (Lucide) or `rbxassetid://…`. |
| `Image` | `string` \| `table` | `nil` | Left-aligned image (asset id or card table). |
| `ImageSize` | `number` | `30` | Size of the left image, in pixels. |
| `Thumbnail` | `string` | `nil` | Large thumbnail image. |
| `ThumbnailSize` | `number` | `80` | Thumbnail size, in pixels. |
| `IconThemed` | `boolean` | `false` | Tint the icon with the current theme color. |
| `Color` | `Color3` \| `string` | `nil` | Colored background (theme name or `Color3`); text auto-contrasts. |
| `Justify` | `string` | `"Between"` | Content alignment within the element row. |
| `Locked` | `boolean` | `false` | Renders a lock overlay and blocks interaction. |
| `Buttons` | `table` | `nil` | Inline buttons rendered in the element row (see below). |
| `TitleGradient` | `table` | `nil` | Gradient applied to the title text. |
| `DescGradient` | `table` | `nil` | Gradient applied to the description text. |

### Common methods

These are available on most interactive elements:

- `:SetTitle(text)` — update the title.
- `:SetDesc(text)` — update the description.
- `:SetIcon(icon)` / `:SetImage(image)` — update the icon or image.
- `:Lock(text?)` — lock the element (optionally with overlay text).
- `:Unlock()` — unlock the element.
- `:Highlight()` — briefly flash the element to draw attention.
- `:Destroy()` — remove the element.
- `:SetButtons(buttons)` / `:GetButton(key)` / `:GetButtons()` — manage inline buttons.

::: info
Individual elements add their own methods on top of the shared base — for example, `Toggle:Set(...)`, `Slider:SetMax(...)` or `Dropdown:Refresh(...)`. See each element's page for the full list.
:::

## Rich text in Title & Desc

`Title` and `Desc` accept inline tokens that let you embed icons, images, gradients and even buttons directly in the text:

- **Inline icons** — `{icon}` or `{name}`, with optional sizing: `{icon:star size=28}`.
- **Inline images** — drop an `rbxassetid://…` reference straight into the string.
- **Gradients** — wrap text in `<gradient>…</gradient>`, or specify colors and rotation: `<gradient=#40c9ff,#e81cff|45>…</gradient>`.
- **Inline buttons** — `<button=key>Label</button>` or the shorthand `{button:key}`, wired to entries in the element's `Buttons` map.

`Desc` additionally supports:

- `\n` — multi-line descriptions.
- `\t` — a two-column row (label on the left, value on the right).

```lua
myTab:Button({
    Title = "Status: <gradient=#30FF6A,#e7ff2f>Online</gradient> {check}",
    Desc = "Ping\t24ms\nRegion\tSEA",
})
```

## Config persistence with Flag

The stateful elements — **Toggle**, **Slider**, **Dropdown**, **Input**, **Keybind** and **Colorpicker** — accept a `Flag` field. A flagged element automatically registers with the active config so its value is saved and restored across sessions.

```lua
myTab:Toggle({ Title = "Auto Farm", Flag = "AutoFarm", Callback = function(state) end })
```

See [Config & Flags](/features/config-and-flags) for the full workflow.

## All elements

| Element | Description |
| --- | --- |
| [Button](/elements/button) | A clickable action row with an optional icon and inline buttons. |
| [Toggle](/elements/toggle) | An on/off switch or checkbox that reports a boolean. |
| [Slider](/elements/slider) | A draggable numeric slider with optional stepping and manual entry. |
| [Dropdown](/elements/dropdown) | Single or multi-select list; can also act as an action menu. |
| [Input](/elements/input) | A single-line or multi-line text field. |
| [Keybind](/elements/keybind) | Binds an action to a key, firing globally when pressed. |
| [Colorpicker](/elements/colorpicker) | Picks a color (with optional transparency) via a dialog. |
| [Paragraph](/elements/paragraph) | Rich text block with optional image cards and stacked buttons. |
| [Code](/elements/code) | A copyable code snippet block. |
| [Section](/elements/section) | A collapsible container that groups child elements under a header. |
| [Divider](/elements/divider) | A horizontal (or vertical, in a Group) separator line. |
| [Space](/elements/space) | An invisible spacer for vertical breathing room. |
| [Image](/elements/image) | A standalone image with aspect-ratio and scaling controls. |
| [Group](/elements/group) | A container that lays its children out horizontally. |
| [Category](/elements/category) | A horizontal option strip for switching between groups of elements. |
