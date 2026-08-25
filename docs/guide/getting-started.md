# Quick Start

Build your first ANUI menu step by step. By the end you will have a window with a tab containing a toggle, a button and a slider, plus a notification — a complete, working script.

## 1. Load ANUI

Every script starts by loading the library into a local called `ANUI`.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## 2. Create a window

`ANUI:CreateWindow` returns a `Window` object you add everything else to. `Folder` is where configs and keys are stored on disk.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})
```

See [Window Configuration](/guide/window-configuration) for every option.

## 3. Add a tab

Tabs hold your elements. Create one with `Window:Tab`.

```lua
local Main = Window:Tab({ Title = "Main", Icon = "house" })
```

## 4. Add elements

Add elements by calling methods on the tab. Note the argument each callback receives:

- **Toggle** — the callback receives a `boolean` (the new on/off state).
- **Button** — the callback receives **no arguments**.
- **Slider** — the callback receives a **formatted string** (the value, formatted according to its step).

```lua
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state) -- state: boolean
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "Do something",
    Callback = function() -- no arguments
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: formatted string
        print("Walk Speed:", value)
    end
})
```

## 5. Show a notification

`ANUI:Notify` pops a toast. The icon field is `Icon`; the body text field is `Content`.

```lua
ANUI:Notify({
    Title = "Hello!",
    Content = "Welcome to ANUI",
    Icon = "bell",
    Duration = 3,
})
```

## Full script

Putting it all together:

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
    Title = "Do something",
    Callback = function()
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value)
        print("Walk Speed:", value)
    end
})

ANUI:Notify({
    Title = "Hello!",
    Content = "Welcome to ANUI",
    Icon = "bell",
    Duration = 3,
})
```

## Next steps

- Configure the window fully in [Window Configuration](/guide/window-configuration).
- Browse every element in the [Elements overview](/elements/).
