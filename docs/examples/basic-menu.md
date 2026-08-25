# Basic Menu

A complete, heavily-commented starter menu you can copy, paste and run. It creates a window with two tabs, a mix of the most common elements, a grouping section, and a notification fired from a button.

## The script

```lua
-- 1. Load ANUI into a local called `ANUI`.
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

-- 2. Create the window. Only ONE window may exist.
local Window = ANUI:CreateWindow({
    Title = "My Hub",                      -- title shown in the top bar
    Author = "by you",                     -- subtitle under the title
    Icon = "rbxassetid://84366761557806",  -- top-bar icon (asset id or Lucide icon name)
    Folder = "MyHub",                      -- disk folder for configs/keys (stored under ANUI/MyHub)
    OpenButton = {                         -- floating button that reopens the window when closed
        Title = "My Hub",
        Enabled = true,
        Draggable = true,
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
    },
})

-- 3. Add tabs. Each tab holds elements and appears in the sidebar.
local Main = Window:Tab({ Title = "Main", Icon = "house" })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

-- 4. A Paragraph is a rich-text block — great as an intro at the top of a tab.
Main:Paragraph({
    Title = "Welcome",
    Desc = "This starter menu shows the most common ANUI elements.",
})

-- Toggle — the callback receives a BOOLEAN (the new on/off state).
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Value = false,
    Callback = function(state) -- state: boolean
        print("Auto Farm:", state)
    end,
})

-- Slider — the callback receives a FORMATTED STRING (the value, formatted to its step).
Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: formatted string
        print("Walk Speed:", value)
    end,
})

-- 5. A Section groups related elements under a collapsible header.
--    It is a container, so you create elements on the section itself.
local combat = Main:Section({ Title = "Combat" })

-- Dropdown — a single-select callback receives the selected value (a string here).
combat:Dropdown({
    Title = "Weapon",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value) -- value: the selected item
        print("Weapon:", value)
    end,
})

-- Keybind — the callback receives the KEY NAME as a string (e.g. "G").
combat:Keybind({
    Title = "Attack Key",
    Value = "G",
    Callback = function(key) -- key: key-name string
        print("Attack bound to:", key)
    end,
})

-- 6. A Button runs a callback with NO ARGUMENTS. Here it fires a notification.
Settings:Button({
    Title = "Say Hello",
    Icon = "bell",
    Callback = function() -- no arguments
        ANUI:Notify({
            Title = "Hello!",
            Content = "Welcome to ANUI",
            Icon = "bell",
            Duration = 3,
        })
    end,
})
```

## What each part does

- **Load line** — pulls the library in and assigns it to `ANUI`. Every example starts this way.
- **`ANUI:CreateWindow`** — returns the `Window` you build on. `Folder` is where configs and keys live on disk; `OpenButton` adds a draggable floating button to reopen the window. See [Window Configuration](/guide/window-configuration).
- **`Window:Tab`** — each tab is a page in the sidebar and a container for elements.
- **Elements** — created by calling a method on a container (a Tab or a Section). Keep the returned value if you want to update the element later.
- **`Main:Section`** — a collapsible container that exposes the same element methods as a Tab, so you can group related controls.
- **`ANUI:Notify`** — pops a toast. The body text field is `Content` (not `Desc`), and the icon field is `Icon`.

::: tip Learn each element
Every element has its own page with the full config table and methods: [Toggle](/elements/toggle), [Slider](/elements/slider), [Dropdown](/elements/dropdown), [Button](/elements/button), [Keybind](/elements/keybind), [Paragraph](/elements/paragraph), and [Section](/elements/section). Browse them all in the [Elements overview](/elements/).
:::
