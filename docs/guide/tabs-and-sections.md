# Tabs & Sections

Tabs are the pages of your menu; sidebar sections group those tabs into labelled clusters. This page covers creating tabs with `Window:Tab{}` and grouping them with `Window:Section{}`.

::: info Two different "Section" concepts
ANUI has two unrelated things both called "Section" — do not mix them up:

1. **`Window:Section({ Title = ... })`** creates a **sidebar section header** that groups tabs in the sidebar. You then call `Section:Tab({...})` to add tabs under it. This is what this page documents.
2. **`Tab:Section({...})`** is a **content element** — a collapsible container placed *inside* a tab. That one is documented at [Section (element)](/elements/section).
:::

## Creating a tab

Create a tab with `Window:Tab{}`. It returns a `Tab` object you add elements to.

```lua
local Main = Window:Tab({
    Title = "Main",
    Icon = "house",
    Desc = "Main controls", -- tooltip shown on hover
})
```

### Tab config

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Tab"` | Tab label. |
| `Desc` | `string` | — | Tooltip shown when hovering the tab. |
| `Icon` | `string` | — | Tab icon (16px): a Lucide name or `rbxassetid://…`. |
| `Image` | `string` | — | Banner image (100px) shown in the tab header. |
| `IconThemed` | `boolean` | — | Tint the icon with the theme color. |
| `Locked` | `boolean` | — | Start the tab locked. |
| `ShowTabTitle` | `boolean` | — | Show the tab's title in the content header. |
| `Profile` | `table` | — | Profile card config (see below). |
| `SidebarProfile` | `boolean` | — | Render the profile as a sidebar card instead of a content header. |

## Profiles

A tab can display a **profile** — a card with an avatar, banner, status indicator and badge buttons. Pass a `Profile` table:

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | Display name. |
| `Desc` | `string` | — | Subtitle / role text. |
| `Avatar` | `string` | — | Avatar image. |
| `Banner` | `string` | — | Banner image. |
| `Status` | `boolean` | — | Show a status indicator. |
| `Badges` | `array` | — | List of `{ Icon, Title, Desc, Callback }` badge buttons. |
| `Sticky` | `boolean` | `true` | Keep the profile pinned while scrolling. |

Set `SidebarProfile = true` to render the profile as a card in the sidebar; `false` (or omitted) shows it as a large header inside the tab content.

```lua
local Badges = {
    {
        Icon = "geist:logo-discord",
        Title = "Discord",
        Desc = "Join ANHUB Discord",
        Callback = function()
            setclipboard("https://discord.gg/bUkCZvmrpH")
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

-- Sidebar card (decorative, rendered in the sidebar)
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

-- Regular tab with a large profile header
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

## Grouping tabs with sidebar sections

`Window:Section({ Title = ... })` creates a labelled header in the sidebar. Call `:Tab{}` on the returned section to add tabs beneath it.

```lua
local ElementsSection = Window:Section({ Title = "Elements" })

local ToggleTab = ElementsSection:Tab({ Title = "Toggle", Icon = "arrow-left-right" })
local ButtonTab = ElementsSection:Tab({ Title = "Button", Icon = "mouse-pointer-click" })

local OtherSection = Window:Section({ Title = "Other" })
local DiscordTab = OtherSection:Tab({ Title = "Discord" })
```

## Tab methods

- `Tab:Select()` — switch to this tab.
- `Tab:ScrollToTheElement(index)` — scroll the tab to a given element.
- `Tab:LockAll()` — lock every element in the tab.
- `Tab:UnlockAll()` — unlock every element in the tab.
- `Tab:GetLocked()` — get the tab's locked elements.
- `Tab:GetUnlocked()` — get the tab's unlocked elements.

Every element-creation method (`Tab:Button`, `Tab:Toggle`, …) is also available on a tab — see the [Elements overview](/elements/).

## Selecting a tab programmatically

Switch tabs from code either through the window or the tab itself. `Window:SelectTab` takes an index, available on each tab as `Tab.Index`:

```lua
Window:SelectTab(UpgradeTab.Index)
-- or, equivalently:
UpgradeTab:Select()
```

## Related

- [Elements overview](/elements/) — everything you can put in a tab.
- [Section (element)](/elements/section) — the in-tab collapsible container.
