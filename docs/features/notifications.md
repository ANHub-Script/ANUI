# Notifications

Toast-style notifications that slide in, show a title and body, and dismiss themselves after a countdown. Create one with `ANUI:Notify{}` — it works from anywhere, whether or not a window is open.

## Basic usage

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Notify({
    Title = "Welcome",
    Content = "Thanks for using ANUI!",
    Icon = "bell",
    Duration = 5,
})
```

::: info The body field is `Content`, not `Desc`
The notification body text is set with `Content`. `Notify` has no `Desc` field — passing `Desc` simply shows no body. Likewise, the image is set with `Icon` (a Lucide icon name **or** an `rbxassetid://…`), not `Image`.
:::

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Notification"` | Heading text of the toast. |
| `Content` | `string` | `nil` | Body text shown under the title. |
| `Icon` | `string` | `nil` | Leading icon: a Lucide icon name or `rbxassetid://…`. (Field is `Icon`, not `Image`.) |
| `IconThemed` | `boolean` | `nil` | Tint the icon with the theme's icon color. |
| `Background` | `string` | `nil` | Background image id for the toast. |
| `BackgroundImageTransparency` | `number` | `nil` | Transparency of the background image (`0` = opaque). |
| `Duration` | `number` \| `false` | `5` | Seconds before auto-close; also drives the progress bar. A falsy value (`false`/`nil`/`0`) means it never auto-closes. |
| `Buttons` | `table` | `{}` | Stored on the object but **not rendered** — see the warning below. |

::: warning `Buttons` are stored but not rendered
The `Buttons` field is accepted and kept on the notification object, but the current build does **not** draw them. For interactive choices, open a [Dialog or Popup](/features/dialogs-and-popups) instead.
:::

A close (X) button is always present, so the user can dismiss a toast manually even when `Duration` is falsy.

## The returned object

`ANUI:Notify{}` returns a notification object with a single method:

### `Notification:Close()`

Closes the notification immediately. Useful for persistent toasts (`Duration = false`) that you want to dismiss from code.

```lua
local note = ANUI:Notify({
    Title = "Working…",
    Content = "This stays open until you close it.",
    Icon = "loader",
    Duration = false, -- falsy → never auto-closes
})

task.delay(3, function()
    note:Close()
end)
```

## `ANUI:SetNotificationLower(bool)`

Moves the notification stack toward the lower part of the screen when `true`, and restores the default position when `false`. Call it once during setup.

```lua
ANUI:SetNotificationLower(true)
```

## Examples

### A simple notification

```lua
ANUI:Notify({
    Title = "Saved",
    Content = "Your settings have been saved.",
})
```

### With an icon and a custom duration

```lua
ANUI:Notify({
    Title = "Discord",
    Content = "Invite link copied to clipboard!",
    Icon = "geist:logo-discord",
    Duration = 3,
})

ANUI:Notify({
    Title = "YouTube",
    Content = "Channel link copied!",
    Icon = "youtube",
    Duration = 3,
})
```

### A persistent notification closed from code

Set `Duration = false` so the toast never times out, keep the returned object, and call `:Close()` when you are done.

```lua
local loading = ANUI:Notify({
    Title = "Loading…",
    Content = "Fetching data from the server.",
    Icon = "loader",
    Duration = false,
})

-- later, once the work finishes
loading:Close()
ANUI:Notify({
    Title = "Done",
    Content = "Data loaded successfully.",
    Icon = "check",
    Duration = 4,
})
```

::: details With a background image
```lua
ANUI:Notify({
    Title = "Event started",
    Content = "A limited-time event is now live.",
    Icon = "party-popper",
    Background = "rbxassetid://84366761557806",
    BackgroundImageTransparency = 0.4,
    Duration = 6,
})
```
:::
