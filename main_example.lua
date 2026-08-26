--[[
================================================================================
  ANUI — Official demo script
================================================================================

  Every element and feature in the documentation, in one runnable file.
  Read it top to bottom, or jump to the tab you care about — each section is
  self-contained and commented.

    Docs      https://ANHub-Script.github.io/ANUI/
    Elements  https://ANHub-Script.github.io/ANUI/elements/
    API       https://ANHub-Script.github.io/ANUI/api/
    Discord   https://discord.gg/qN47S3mKZA

  Layout of this file
    1.  Load & window          — ANUI:CreateWindow, Tag, OpenButton
    2.  Sidebar & welcome      — profile cards, Paragraph, Image, Code
    3.  Elements               — one tab per element
    4.  Features               — notifications, dialogs, themes, loops
    5.  Config                 — flags + save / load panel

  Three things that trip people up (all documented, all easy to miss):
    • Slider callbacks receive a formatted STRING — call tonumber() first.
    • ANUI:Notify uses `Content` for the body text, not `Desc`.
    • Colorpicker's initial color field is `Default`, not `Value`.

================================================================================
--]]

-- ============================================================================
-- 1. LOAD & WINDOW
-- ============================================================================

local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

-- Only ONE window may exist at a time. A second CreateWindow call warns and
-- returns nil. `Folder` is what enables the config system and SaveKey.
local Window = ANUI:CreateWindow({
    Title = "ANUI Demo",
    Author = "by ANHub-Script",
    Icon = "rbxassetid://84366761557806",
    IconSize = 26,
    Folder = "ANUIDemo",
    Theme = "Dark",
    Acrylic = true, -- required for ANUI:ToggleAcrylic to do anything
    ToggleKey = Enum.KeyCode.RightShift,

    -- Floating button that reopens the window once it's closed.
    -- Note: `Color` is a ColorSequence (a gradient), not a Color3. And without
    -- `OnlyMobile = false` the button only appears on mobile.
    OpenButton = {
        Title = "ANUI",
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
    },
})

-- A small badge in the window chrome. ANUI.Version is a field, not a method.
Window:Tag({
    Title = "v" .. ANUI.Version,
    Icon = "github",
})

-- Window.ConfigManager only exists because we passed `Folder` above — and it
-- still needs executor file globals (readfile / writefile / isfile / makefolder)
-- to actually persist anything. Point Window.CurrentConfig at a config HERE,
-- before any element is built: a `Flag` registers with whichever config is
-- current at the moment the element is created. Section 5 drives it from the UI.
local ConfigManager = Window.ConfigManager
local ConfigName = "default"

if ConfigManager then
    -- :Config(name) is an alias of :CreateConfig(name) — creates or opens.
    Window.CurrentConfig = ConfigManager:Config(ConfigName)
end

-- ============================================================================
-- 2. SIDEBAR & WELCOME
-- ============================================================================

-- Reused by both profile cards below.
local Badges = {
    {
        Icon = "geist:logo-discord",
        Title = "Discord",
        Desc = "Join the ANHub Discord",
        Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
            ANUI:Notify({
                Title = "Discord",
                Content = "Invite link copied to clipboard!",
                Icon = "geist:logo-discord",
                Duration = 3,
            })
        end,
    },
    {
        Icon = "youtube",
        Title = "YouTube",
        Desc = "Subscribe on YouTube",
        Callback = function()
            setclipboard("https://www.youtube.com/@ANHubRoblox")
            ANUI:Notify({
                Title = "YouTube",
                Content = "Channel link copied!",
                Icon = "youtube",
                Duration = 3,
            })
        end,
    },
}

-- A tab with no Title and SidebarProfile = true renders as a decorative card
-- pinned in the sidebar rather than a clickable page.
Window:Tab({
    Profile = {
        Title = "ANUI",
        Desc = "Demo build",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = true,
})

local WelcomeTab = Window:Tab({
    Title = "Welcome",
    Icon = "sparkles",
    Desc = "Start here",
})

-- Title and Desc accept rich-text tokens: {icon}, <gradient>…</gradient>, and
-- \t inside Desc renders a two-column label/value row.
WelcomeTab:Paragraph({
    Title = "<gradient=#40c9ff,#e81cff>ANUI</gradient> {sparkles}",
    Desc = "A modern UI library for Roblox script executors.\n"
        .. "Version\t" .. ANUI.Version .. "\n"
        .. "Theme\t" .. tostring(ANUI:GetCurrentTheme()) .. "\n"
        .. "Elements\t15",
})

WelcomeTab:Divider()

WelcomeTab:Paragraph({
    Title = "How to read this demo",
    Desc = "The sidebar is grouped into sections. Elements has one tab per element, "
        .. "Features covers notifications, dialogs, themes and loops, and Config "
        .. "shows saving and loading state to disk.",
    Buttons = {
        {
            Title = "Copy the install line",
            Icon = "clipboard",
            Callback = function()
                setclipboard('local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()')
                ANUI:Notify({ Title = "Copied", Content = "Install line copied.", Icon = "check", Duration = 3 })
            end,
        },
        {
            Title = "Open the documentation",
            Icon = "book-open",
            Callback = function()
                setclipboard("https://ANHub-Script.github.io/ANUI/")
                ANUI:Notify({ Title = "Docs", Content = "Docs URL copied to clipboard.", Icon = "book-open", Duration = 3 })
            end,
        },
    },
})

WelcomeTab:Space({ Columns = 2 })

WelcomeTab:Code({
    Title = "Install",
    Code = 'local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()',
    OnCopy = function()
        ANUI:Notify({ Title = "Copied", Content = "Paste it into your executor.", Icon = "check", Duration = 3 })
    end,
})

WelcomeTab:Space()

WelcomeTab:Image({
    Image = "rbxassetid://114772391775993",
    AspectRatio = "16:9",
    ScaleType = "Crop",
    Radius = 12,
})

-- Sidebar sections group tabs under a label. Note this is Window:Section —
-- completely unrelated to Tab:Section, which is an in-tab collapsible element.
local ElementsSection = Window:Section({ Title = "Elements" })
local FeaturesSection = Window:Section({ Title = "Features" })
local ConfigSection = Window:Section({ Title = "Config" })

-- ============================================================================
-- 3. ELEMENTS
-- ============================================================================

-- ---------------------------------------------------------------- Button ----
do
    local Tab = ElementsSection:Tab({ Title = "Button", Icon = "mouse-pointer-click" })

    Tab:Paragraph({
        Title = "Button",
        Desc = "A clickable action row. The Callback receives NO arguments — use a "
            .. "Toggle or Dropdown when you need a value.",
    })

    Tab:Button({
        Title = "Basic button",
        Desc = "Prints to the console",
        Callback = function()
            print("[ANUI] Button clicked")
        end,
    })

    Tab:Button({
        Title = "Centered, icon on the left",
        Icon = "settings",
        IconAlign = "Left",
        Justify = "Center",
        Callback = function() end,
    })

    Tab:Button({
        Title = "Themed icon",
        Desc = "IconThemed tints the icon with the theme color",
        Icon = "palette",
        IconThemed = true,
        Callback = function() end,
    })

    Tab:Button({
        Title = "Colored button",
        Desc = "Color accepts a Color3 or a theme name; text auto-contrasts",
        Color = Color3.fromHex("#305dff"),
        Icon = "",                      -- an empty string renders no icon
        Callback = function() end,
    })

    Tab:Button({
        Title = "Locked button",
        Desc = "Locked draws an overlay and blocks interaction",
        Locked = true,
    })

    Tab:Space()

    -- Keep the returned object to update the element later.
    local Live = Tab:Button({
        Title = "I get updated",
        Desc = "Press the button below",
        Icon = "pencil",
        Callback = function() end,
    })

    Tab:Button({
        Title = "Update the button above",
        Icon = "chevron-right",
        Callback = function()
            Live:SetTitle("Updated at " .. os.date("%X"))
            Live:SetDesc("SetTitle / SetDesc / Highlight")
            Live:Highlight()            -- briefly flashes the element
        end,
    })

    Tab:Space()

    -- Inline buttons live in the element row itself (a keyed map), unlike a
    -- Paragraph's `Buttons`, which stack full-width beneath the text.
    Tab:Button({
        Title = "Inline buttons {button:copy}",
        Desc = "Rich-text token {button:key} renders an entry from Buttons",
        Buttons = {
            copy = {
                Title = "Copy",
                Icon = "copy",
                Callback = function()
                    setclipboard("ANUI")
                    ANUI:Notify({ Title = "Copied", Content = "Wrote 'ANUI' to the clipboard.", Icon = "copy", Duration = 3 })
                end,
            },
        },
    })
end

-- ---------------------------------------------------------------- Toggle ----
do
    local Tab = ElementsSection:Tab({ Title = "Toggle", Icon = "toggle-right" })

    Tab:Paragraph({
        Title = "Toggle",
        Desc = "An on/off switch. The Callback receives a boolean. Set Type = "
            .. '"Checkbox" for the checkbox variant.',
    })

    Tab:Toggle({
        Title = "Basic toggle",
        Desc = "Click or drag the knob",
        Value = false,
        Callback = function(state)
            print("[ANUI] Basic toggle:", state)
        end,
    })

    Tab:Toggle({
        Title = "Starts on, with a knob icon",
        Icon = "check",
        IconSize = 15,
        Value = true,
        Callback = function(state)
            print("[ANUI] Icon toggle:", state)
        end,
    })

    Tab:Toggle({
        Title = "Checkbox",
        Desc = "Same behaviour, different look",
        Type = "Checkbox",
        Callback = function(state)
            print("[ANUI] Checkbox:", state)
        end,
    })

    Tab:Toggle({
        Title = "With a left image",
        Image = "rbxassetid://84366761557806",
        ImageSize = 24,
        Callback = function(state)
            print("[ANUI] Image toggle:", state)
        end,
    })

    Tab:Space()

    -- Locked vs Disabled: Locked blocks interaction AND prevents the callback.
    -- Disabled blocks user interaction only — :Set() from code still fires it.
    Tab:Toggle({ Title = "Locked", Desc = "Overlay shown, callback never fires", Locked = true })

    local Disabled = Tab:Toggle({
        Title = "Disabled",
        Desc = "Not clickable, but :Set() from code still works",
        Disabled = true,
        Callback = function(state)
            print("[ANUI] Disabled toggle set from code:", state)
        end,
    })

    Tab:Space()

    local Programmatic = Tab:Toggle({
        Title = "Controlled from code",
        Value = false,
        Callback = function(state)
            print("[ANUI] Programmatic toggle:", state)
        end,
    })

    local Row = Tab:Group({})           -- Group takes an EMPTY TABLE, not no args

    Row:Button({
        Title = "Turn on",
        Icon = "power",
        Callback = function()
            -- Set(value, fireCallback?, animate?, force?)
            Programmatic:Set(true, true, true)
            Disabled:Set(true, true, true)
        end,
    })

    Row:Button({
        Title = "Turn off",
        Icon = "power-off",
        Callback = function()
            Programmatic:Set(false, true, true)
            Disabled:Set(false, true, true)
        end,
    })
end

-- ------------------------------------------------------ Slider & Keybind ----
do
    local Tab = ElementsSection:Tab({ Title = "Slider & Keybind", Icon = "sliders-horizontal" })

    -- Tab:Section is a collapsible container: everything created on it lives
    -- inside it. (Not to be confused with Window:Section in the sidebar.)
    local SliderBox = Tab:Section({ Title = "Slider {sliders-horizontal}", Opened = true, Box = true })

    SliderBox:Paragraph({
        Title = "The callback argument is a string",
        Desc = "Integer sliders report a whole number as text ('50'); a fractional "
            .. "Step switches to float mode and reports '%.2f' ('0.50'). Always "
            .. "wrap it in tonumber() before doing maths.",
    })

    SliderBox:Slider({
        Title = "Walk speed",
        Desc = "Integer slider, Step = 1",
        Value = { Min = 16, Max = 200, Default = 16 },
        Step = 1,
        Callback = function(value)
            local n = tonumber(value)
            print("[ANUI] Walk speed:", n)
        end,
    })

    SliderBox:Slider({
        Title = "Volume",
        Desc = "Fractional Step = 0.1 → float mode",
        Value = { Min = 0, Max = 1, Default = 0.5 },
        Step = 0.1,
        Callback = function(value)
            print("[ANUI] Volume:", tonumber(value))
        end,
    })

    SliderBox:Space()

    local Ranged = SliderBox:Slider({
        Title = "Adjustable range",
        Desc = "SetMin / SetMax change the bounds at runtime",
        Value = { Min = 0, Max = 100, Default = 25 },
        Callback = function(value)
            print("[ANUI] Ranged:", tonumber(value))
        end,
    })

    local SliderRow = SliderBox:Group({})
    SliderRow:Button({ Title = "Max → 500", Callback = function() Ranged:SetMax(500) end })
    SliderRow:Button({ Title = "Max → 100", Callback = function() Ranged:SetMax(100) end })
    SliderRow:Button({ Title = "Set to 50", Callback = function() Ranged:Set(50) end })

    Tab:Space({ Columns = 2 })

    local KeybindBox = Tab:Section({ Title = "Keybind {keyboard}", Opened = true, Box = true })

    KeybindBox:Paragraph({
        Title = "Keybinds fire globally",
        Desc = "The callback runs whenever the key is pressed anywhere in the game "
            .. "(suppressed only while a text box is focused). It receives the key "
            .. "NAME as a string, e.g. 'G' — convert back with Enum.KeyCode[name].",
    })

    KeybindBox:Keybind({
        Title = "Toggle the menu",
        Desc = "Click the keybind, then press any key to rebind",
        Value = "RightShift",
        Callback = function(key)
            -- Indexing Enum.KeyCode with an unknown name (e.g. "MouseLeft")
            -- throws, so guard the lookup.
            local ok, keycode = pcall(function()
                return Enum.KeyCode[key]
            end)
            if ok and keycode then
                Window:SetToggleKey(keycode)
                ANUI:Notify({
                    Title = "Keybind updated",
                    Content = "Menu toggle is now " .. key .. ".",
                    Icon = "keyboard",
                    Duration = 3,
                })
            end
        end,
    })

    KeybindBox:Keybind({
        Title = "Quick action",
        Desc = "Mouse buttons work too: MouseLeft / MouseRight",
        Value = "G",
        Callback = function(key)
            print("[ANUI] Quick action fired via", key)
        end,
    })
end

-- -------------------------------------------------------------- Dropdown ----
do
    local Tab = ElementsSection:Tab({ Title = "Dropdown", Icon = "list" })

    Tab:Paragraph({
        Title = "Dropdown",
        Desc = "Values may be plain strings or item objects. Single-select passes the "
            .. "selected value through (the whole object, for object items); Multi "
            .. "passes an array. Omit the global Callback and it becomes an action menu.",
    })

    Tab:Dropdown({
        Title = "Plain strings",
        Values = { "Sword", "Bow", "Staff" },
        Value = "Sword",
        SearchBarEnabled = true,
        Callback = function(value)
            print("[ANUI] Weapon:", value)
        end,
    })

    Tab:Dropdown({
        Title = "Item objects",
        Desc = "Each option carries a Title, Icon and Desc",
        Values = {
            { Title = "Home", Icon = "house", Desc = "Spawn point" },
            { Title = "Shop", Icon = "shopping-bag", Desc = "Buy upgrades" },
            { Type = "Divider" },                       -- visual separator
            { Title = "Arena", Icon = "swords", Desc = "PvP zone" },
            { Title = "Locked zone", Icon = "lock", Locked = true },
        },
        Value = { Title = "Home", Icon = "house", Desc = "Spawn point" },
        SearchBarEnabled = true,
        Callback = function(option)
            -- Object items come back as the original table.
            print("[ANUI] Teleport to:", option.Title)
        end,
    })

    Tab:Dropdown({
        Title = "Multi-select",
        Desc = "AllowNone lets you deselect the last remaining item",
        Values = {
            { Title = "Coins", Icon = "coins" },
            { Title = "Gems", Icon = "gem" },
            { Title = "XP", Icon = "star" },
        },
        Multi = true,
        AllowNone = true,
        SearchBarEnabled = true,
        Callback = function(selected)
            local names = {}
            for _, item in ipairs(selected) do
                table.insert(names, item.Title)
            end
            print("[ANUI] Collecting:", #names > 0 and table.concat(names, ", ") or "nothing")
        end,
    })

    Tab:Space()

    -- No global Callback → action menu. Each item runs its own Callback.
    Tab:Dropdown({
        Title = "Action menu",
        Desc = "No global Callback — items act like menu commands",
        Values = {
            { Title = "Rejoin", Icon = "refresh-cw", Callback = function() print("[ANUI] Rejoin") end },
            { Title = "Copy job id", Icon = "copy", Callback = function() setclipboard(game.JobId) end },
            { Type = "Divider" },
            { Title = "Leave", Icon = "log-out", Desc = "Disconnect", Callback = function() print("[ANUI] Leave") end },
        },
    })

    Tab:Space()

    local Colours = Tab:Dropdown({
        Title = "Refreshed from code",
        Values = { "Red", "Green", "Blue" },
        Value = "Red",
        MenuWidth = 260,
        Callback = function(value)
            print("[ANUI] Colour:", value)
        end,
    })

    local DropRow = Tab:Group({})
    DropRow:Button({
        Title = "Select 'Blue'",
        Callback = function() Colours:Select("Blue") end,
    })
    DropRow:Button({
        Title = "Replace options",
        Callback = function()
            Colours:Refresh({ "Cyan", "Magenta", "Yellow" })
            ANUI:Notify({ Title = "Dropdown", Content = "Options replaced.", Icon = "list", Duration = 3 })
        end,
    })
end

-- -------------------------------------------------- Input & Colorpicker ----
do
    local Tab = ElementsSection:Tab({ Title = "Input & Color", Icon = "text-cursor-input" })

    Tab:Paragraph({
        Title = "Input",
        Desc = "Commits on focus lost, or Enter for single-line fields. Heads up: the "
            .. "callback also fires ONCE at creation with the starting Value, so guard "
            .. "anything expensive.",
    })

    local ready = false                 -- ignore the initial callback

    Tab:Input({
        Title = "Player name",
        Placeholder = "Enter a name...",
        InputIcon = "user",
        Callback = function(text)
            if not ready then return end
            print("[ANUI] Player name:", text)
        end,
    })

    Tab:Input({
        Title = "Notes",
        Desc = "Type = 'Textarea' gives you a multi-line field",
        Type = "Textarea",
        Placeholder = "Anything you like...",
        Callback = function(text)
            if not ready then return end
            print("[ANUI] Notes:", #text, "characters")
        end,
    })

    local Prefilled = Tab:Input({
        Title = "Prefilled",
        Value = "ANUI",
        ClearTextOnFocus = true,
        Callback = function(text)
            if not ready then return end
            print("[ANUI] Prefilled:", text)
        end,
    })

    Tab:Button({
        Title = "Set the field above from code",
        Icon = "pencil",
        Callback = function()
            Prefilled:Set("set at " .. os.date("%X"))
        end,
    })

    ready = true

    Tab:Space({ Columns = 2 })

    Tab:Paragraph({
        Title = "Colorpicker",
        Desc = "The initial colour field is `Default`, not `Value`. Providing any "
            .. "Transparency number — even 0 — enables the alpha slider. The callback "
            .. "fires on Apply and receives (Color3, transparency).",
    })

    Tab:Colorpicker({
        Title = "Highlight colour",
        Default = Color3.fromHex("#40c9ff"),
        Callback = function(colour)
            print("[ANUI] Highlight:", colour)
        end,
    })

    local Alpha = Tab:Colorpicker({
        Title = "With transparency",
        Desc = "Alpha slider and input are shown",
        Default = Color3.fromHex("#e81cff"),
        Transparency = 0,
        Callback = function(colour, transparency)
            print("[ANUI] Colour:", colour, "alpha:", transparency)
        end,
    })

    Tab:Button({
        Title = "Reset to green",
        Icon = "rotate-ccw",
        Callback = function()
            Alpha:Set(Color3.fromHex("#30ff6a"), 0)
        end,
    })
end

-- ---------------------------------------------------------------- Layout ----
do
    local Tab = ElementsSection:Tab({ Title = "Layout", Icon = "layout-grid" })

    Tab:Paragraph({
        Title = "Containers & spacing",
        Desc = "Section, Group and Paragraph are containers — they expose the same "
            .. "element-creation methods as a Tab. Divider, Space, Image and Code are "
            .. "plain decoration.",
    })

    -- Section: a collapsible container inside the tab.
    local Combat = Tab:Section({
        Title = "Combat {swords}",
        Icon = "shield",
        Opened = true,
        Box = true,
    })

    Combat:Toggle({ Title = "God mode", Callback = function(v) print("[ANUI] God mode:", v) end })
    Combat:Slider({
        Title = "Damage",
        Value = { Min = 1, Max = 100, Default = 10 },
        Callback = function(v) print("[ANUI] Damage:", tonumber(v)) end,
    })

    local Farming = Tab:Section({ Title = "Farming", Icon = "coins", Opened = false })
    Farming:Toggle({ Title = "Auto farm", Callback = function(v) print("[ANUI] Auto farm:", v) end })
    Farming:Dropdown({
        Title = "Target",
        Values = { "Coins", "Gems", "XP" },
        Value = "Coins",
        Callback = function(v) print("[ANUI] Target:", v) end,
    })

    Tab:Space({ Columns = 2 })

    -- Group: horizontal layout. Interactive children share the width equally;
    -- Space and Divider children keep their natural width.
    Tab:Paragraph({ Title = "Group", Desc = "Children are laid out side by side." })

    local Actions = Tab:Group({})
    Actions:Button({ Title = "Save", Icon = "save", Color = Color3.fromHex("#305dff"), Callback = function() end })
    Actions:Divider()               -- vertical inside a Group
    Actions:Button({ Title = "Load", Icon = "folder-open", Callback = function() end })
    Actions:Divider()
    Actions:Button({ Title = "Reset", Icon = "trash-2", Callback = function() end })

    local Mixed = Tab:Group({})
    Mixed:Toggle({ Title = "Notify", Value = true, Callback = function() end })
    Mixed:Slider({ Title = "Delay", Value = { Min = 0, Max = 10, Default = 2 }, Callback = function() end })

    Tab:Space({ Columns = 2 })

    -- Paragraph is also a container, and its Images render as a card grid.
    Tab:Paragraph({ Title = "Paragraph as a container", Desc = "Children attach directly to it." })

    local Inventory = Tab:Paragraph({
        Title = "Inventory",
        Desc = "Images render as a grid of cards.",
        ImageSize = UDim2.fromOffset(80, 80),
        Images = {
            {
                Title = "World Box",
                Quantity = "244x",
                Image = "rbxassetid://84366761557806",
                Gradient = ColorSequence.new(Color3.fromHex("#C042FF"), Color3.fromHex("#8E24AA")),
                Callback = function() print("[ANUI] World Box") end,
            },
            {
                Title = "Golden Ticket",
                Quantity = "72x",
                Image = "ticket",
                Gradient = ColorSequence.new(Color3.fromHex("#FFD700"), Color3.fromHex("#FFA000")),
                Callback = function() print("[ANUI] Golden Ticket") end,
            },
            {
                Title = "Zone Key",
                Quantity = "3x",
                Image = "key",
                Gradient = ColorSequence.new(Color3.fromHex("#29B6F6"), Color3.fromHex("#0288D1")),
                Callback = function() print("[ANUI] Zone Key") end,
            },
        },
    })

    Inventory:Button({ Title = "Sell everything", Icon = "banknote", Callback = function() end })

    Tab:Space({ Columns = 2 })

    Tab:Paragraph({ Title = "Divider, Space & Image", Desc = "Divider() takes no arguments at all." })
    Tab:Divider()
    Tab:Space({ Columns = 3 })

    local Banner = Tab:Image({
        Image = "rbxassetid://114772391775993",
        AspectRatio = "16:9",
        ScaleType = "Fit",
    })

    local ImageRow = Tab:Group({})
    ImageRow:Button({ Title = "Crop", Callback = function() Banner:SetScaleType("Crop") end })
    ImageRow:Button({ Title = "Fit", Callback = function() Banner:SetScaleType("Fit") end })
    ImageRow:Button({ Title = "Native", Callback = function() Banner:SetAspectRatio("native") end })
end

-- -------------------------------------------------------------- Category ----
do
    local Tab = ElementsSection:Tab({ Title = "Category", Icon = "hammer" })

    Tab:Paragraph({
        Title = "Category",
        Desc = "One tab, several pages. The strip scrolls horizontally and the callback "
            .. "receives the selected option's name. AutoCapture is on by default, so "
            .. ":With(name, builder) is the tidiest way to assign elements to a page.",
    })

    -- Declared up front so the controls below can close over it. These live
    -- ABOVE the Category on purpose: with AutoCapture on, anything created
    -- after it gets folded into a page, so permanent controls belong here.
    local Pages

    local CatRow = Tab:Group({})
    CatRow:Button({ Title = "Go to Shop", Callback = function() Pages:Select("Shop") end })
    CatRow:Button({
        Title = "Which page?",
        Callback = function()
            ANUI:Notify({
                Title = "Category",
                Content = "Currently showing: " .. tostring(Pages:GetSelected()),
                Icon = "info",
                Duration = 3,
            })
        end,
    })

    Tab:Divider()
    Tab:Space()

    Pages = Tab:Category({
        Title = "Select a page",
        Default = "Stats",
        Options = {
            { Title = "Stats", Icon = "chart-no-axes-column" },
            { Title = "Shop", Icon = "shopping-bag" },
            { Title = "Trainers", Icon = "swords" },
            { Title = "Misc", Icon = "settings" },
        },
        Callback = function(name)
            print("[ANUI] Category page:", name)
        end,
    })

    Tab:Space({ Columns = 1 })

    -- Everything created inside the builder belongs to that page and is shown
    -- or hidden automatically as the user switches.
    Pages:With("Stats", function()
        Tab:Paragraph({ Title = "Stats", Desc = "Spend your points." })
        Tab:Slider({ Title = "Strength", Value = { Min = 0, Max = 100, Default = 40 }, Callback = function(v) print("[ANUI] Strength:", tonumber(v)) end })
        Tab:Slider({ Title = "Agility", Value = { Min = 0, Max = 100, Default = 25 }, Callback = function(v) print("[ANUI] Agility:", tonumber(v)) end })
        Tab:Toggle({ Title = "Auto spend", Callback = function(v) print("[ANUI] Auto spend:", v) end })
    end)

    Pages:With("Shop", function()
        Tab:Paragraph({ Title = "Shop", Desc = "Buy upgrades with coins." })
        Tab:Dropdown({
            Title = "Item",
            Values = { "Health potion", "Damage boost", "Luck charm" },
            Value = "Health potion",
            Callback = function(v) print("[ANUI] Item:", v) end,
        })
        Tab:Button({ Title = "Buy", Icon = "shopping-cart", Callback = function() print("[ANUI] Buy") end })
    end)

    Pages:With("Trainers", function()
        Tab:Paragraph({ Title = "Trainers", Desc = "Pick a master and train." })
        Tab:Dropdown({
            Title = "Trainer",
            Values = { { Title = "Ryu", Icon = "flame" }, { Title = "Mira", Icon = "wind" } },
            Value = { Title = "Ryu", Icon = "flame" },
            Callback = function(option) print("[ANUI] Trainer:", option.Title) end,
        })
        Tab:Button({ Title = "Train now", Icon = "dumbbell", Callback = function() print("[ANUI] Train") end })
    end)

    Pages:With("Misc", function()
        Tab:Paragraph({ Title = "Misc", Desc = "Everything else." })
        Tab:Toggle({ Title = "Anti AFK", Callback = function(v) print("[ANUI] Anti AFK:", v) end })
        Tab:Keybind({ Title = "Panic key", Value = "P", Callback = function(k) print("[ANUI] Panic:", k) end })
    end)
end

-- ============================================================================
-- 4. FEATURES
-- ============================================================================

-- --------------------------------------------------------- Notifications ----
do
    local Tab = FeaturesSection:Tab({
        Title = "Notifications",
        Icon = "bell",
        Desc = "ANUI:Notify",
    })

    Tab:Paragraph({
        Title = "Notifications",
        Desc = "Toasts work with or without a window. The body field is `Content` "
            .. "(there is no `Desc`), and the image field is `Icon` — it takes a "
            .. "Lucide name or an rbxassetid://.",
    })

    local Row = Tab:Group({})

    Row:Button({
        Title = "Plain",
        Callback = function()
            ANUI:Notify({
                Title = "Saved",
                Content = "Your settings have been saved.",
            })
        end,
    })

    Row:Button({
        Title = "Icon + duration",
        Callback = function()
            ANUI:Notify({
                Title = "Event started",
                Content = "A limited-time event is now live.",
                Icon = "party-popper",
                Duration = 4,
            })
        end,
    })

    Row:Button({
        Title = "Background image",
        Callback = function()
            ANUI:Notify({
                Title = "New season",
                Content = "Season 4 rewards are available.",
                Icon = "trophy",
                Background = "rbxassetid://114772391775993",
                BackgroundImageTransparency = 0.4,
                Duration = 6,
            })
        end,
    })

    Tab:Divider()

    -- Duration = false (or nil / 0) means the toast never times out. Keep the
    -- returned object so you can dismiss it yourself with :Close().
    local persistent = nil

    Tab:Button({
        Title = "Open a persistent toast",
        Desc = "Duration = false — it stays until you close it",
        Icon = "loader",
        Callback = function()
            if persistent then
                return
            end
            persistent = ANUI:Notify({
                Title = "Working…",
                Content = "This one has no countdown.",
                Icon = "loader",
                Duration = false,
            })
        end,
    })

    Tab:Button({
        Title = "Close it from code",
        Desc = "Notification:Close()",
        Icon = "x",
        Callback = function()
            if persistent then
                persistent:Close()
                persistent = nil
            end
        end,
    })

    Tab:Toggle({
        Title = "Stack toasts lower",
        Desc = "ANUI:SetNotificationLower(bool)",
        Callback = function(state)
            ANUI:SetNotificationLower(state)
        end,
    })

    -- Buttons on a notification are accepted but NOT rendered by the current
    -- build — use a Dialog or Popup when you need the user to choose.
end

-- ------------------------------------------------------ Dialogs & popups ----
do
    local Tab = FeaturesSection:Tab({
        Title = "Dialogs",
        Icon = "message-square",
        Desc = "Window:Dialog & ANUI:Popup",
    })

    Tab:Paragraph({
        Title = "Dialogs & popups",
        Desc = "Window:Dialog renders inside the window and takes a `Width`. "
            .. "ANUI:Popup is screen-level, opens the moment you call it, supports "
            .. "a `Thumbnail`, and has no methods — its buttons dismiss it.",
    })

    Tab:Button({
        Title = "Button variants",
        Desc = "Primary · Secondary · White",
        Icon = "square-stack",
        Callback = function()
            Window:Dialog({
                Title = "UI Button Variants",
                Content = "The three visual styles a dialog button can take.",
                Buttons = {
                    { Title = "Primary", Variant = "Primary", Icon = "chevron-right", Callback = function() end },
                    { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
                    { Title = "White", Variant = "White", Icon = "chevron-right", Callback = function() end },
                },
            })
        end,
    })

    Tab:Button({
        Title = "Confirm dialog",
        Desc = "Cancel / Confirm, Width = 340",
        Icon = "rotate-ccw",
        Callback = function()
            Window:Dialog({
                Title = "Reset settings?",
                Content = "All options will return to their defaults.",
                Icon = "rotate-ccw",
                Width = 340,
                Buttons = {
                    {
                        Title = "Cancel",
                        Variant = "Secondary",
                        Callback = function()
                            ANUI:Notify({ Title = "Cancelled", Content = "Nothing was changed.", Icon = "x", Duration = 3 })
                        end,
                    },
                    {
                        Title = "Confirm",
                        Variant = "Primary",
                        Icon = "check",
                        Callback = function()
                            ANUI:Notify({ Title = "Reset", Content = "Settings restored to defaults.", Icon = "check", Duration = 3 })
                        end,
                    },
                },
            })
        end,
    })

    Tab:Button({
        Title = "Standalone popup",
        Desc = "ANUI:Popup with a Thumbnail",
        Icon = "image",
        Callback = function()
            ANUI:Popup({
                Title = "Welcome",
                Content = "Thanks for trying ANUI. Join the community for updates.",
                Icon = "hand",
                Thumbnail = {
                    Image = "rbxassetid://114772391775993",
                    Title = "ANHub",
                },
                Buttons = {
                    {
                        Title = "Copy Discord",
                        Variant = "Primary",
                        Icon = "link",
                        Callback = function()
                            setclipboard("https://discord.gg/qN47S3mKZA")
                        end,
                    },
                    { Title = "Close", Variant = "Secondary", Callback = function() end },
                },
            })
        end,
    })
end

-- ---------------------------------------------------------------- Themes ----
do
    local Tab = FeaturesSection:Tab({
        Title = "Themes",
        Icon = "palette",
        Desc = "26 built-ins + your own",
    })

    -- ANUI:Gradient takes stops keyed by POSITION STRINGS ("0" … "100") and an
    -- optional props table. Two stops minimum, or it errors.
    local Brand = ANUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }, {
        Rotation = 45,
    })

    Tab:Paragraph({
        Title = "Theme switcher",
        TitleGradient = Brand,
        Desc = "Pick any built-in key below. SetTheme returns the theme table, or "
            .. "nil when the key is unknown.",
    })

    -- A custom theme is registered by its Name, which then works exactly like a
    -- built-in key. Nine colors are required; Toggle and Checkbox are optional.
    ANUI:AddTheme({
        Name = "ANUINeon",
        Accent = Color3.fromHex("#161226"),
        Dialog = Color3.fromHex("#120f1f"),
        Outline = Color3.fromHex("#40c9ff"),
        Text = Color3.fromHex("#f4f0ff"),
        Placeholder = Color3.fromHex("#6f6693"),
        Background = Color3.fromHex("#0b0913"),
        Button = Color3.fromHex("#2a2142"),
        Icon = Color3.fromHex("#e81cff"),
        Toggle = Color3.fromHex("#40c9ff"),
        Checkbox = Color3.fromHex("#e81cff"),
    })

    local ThemeKeys = {
        "Dark", "Light", "Rose", "Plant", "Red", "Indigo", "Sky", "Violet",
        "Amber", "Emerald", "Midnight", "Crimson", "MonokaiPro", "CottonCandy",
        "Rainbow", "NordTheme", "DraculaTheme", "TokyoNight", "OneDark",
        "Gruvbox", "SolarizedDark", "MaterialDark", "CyberpunkPink", "OceanBlue",
        "NeonGreen", "SoftPastel",
        "ANUINeon", -- the custom one registered just above
    }

    Tab:Dropdown({
        Title = "Theme",
        Desc = "26 built-in keys plus the custom ANUINeon",
        Values = ThemeKeys,
        Value = "Dark",
        Flag = "Theme",
        Callback = function(key)
            if not ANUI:SetTheme(key) then
                warn("[ANUI] Unknown theme key: " .. tostring(key))
            end
        end,
    })

    local Row = Tab:Group({})

    Row:Button({
        Title = "Active theme",
        Callback = function()
            -- GetCurrentTheme returns the DISPLAY name ("Monokai Pro"), which is
            -- not always the same string as the key ("MonokaiPro").
            ANUI:Notify({
                Title = "Theme",
                Content = "Display name: " .. tostring(ANUI:GetCurrentTheme()),
                Icon = "palette",
                Duration = 3,
            })
        end,
    })

    Row:Button({
        Title = "Count registered",
        Callback = function()
            local n = 0
            for _ in pairs(ANUI:GetThemes()) do
                n += 1
            end
            ANUI:Notify({
                Title = "Themes",
                Content = n .. " themes registered (built-ins + custom).",
                Icon = "list",
                Duration = 3,
            })
        end,
    })

    Tab:Divider()

    Tab:Toggle({
        Title = "Acrylic blur",
        Desc = "Only does something when the window was created with Acrylic = true",
        Value = true,
        Callback = function(state)
            ANUI:ToggleAcrylic(state)
        end,
    })

    Tab:Toggle({
        Title = "Transparent background",
        Desc = "Window:ToggleTransparency(bool)",
        Callback = function(state)
            Window:ToggleTransparency(state)
        end,
    })

    local SidebarRow = Tab:Group({})
    SidebarRow:Button({ Title = "Collapse sidebar", Callback = function() Window:CollapseSidebar() end })
    SidebarRow:Button({ Title = "Expand sidebar", Callback = function() Window:ExpandSidebar() end })

    -- OnThemeChange keeps exactly ONE handler — registering again replaces the
    -- previous one, so branch inside a single function instead.
    ANUI:OnThemeChange(function(themeKey)
        print("[ANUI] Theme key:", themeKey, "→ display:", ANUI:GetCurrentTheme())
    end)
end

-- ------------------------------------------------------------- Scheduler ----
do
    local Tab = FeaturesSection:Tab({
        Title = "Scheduler",
        Icon = "timer",
        Desc = "Drift-free loops",
    })

    Tab:Paragraph({
        Title = "Scheduler & loops",
        Desc = "One runner thread drives every loop, so they never drift and never "
            .. "overlap themselves. Window loops stop automatically when the window "
            .. "closes or is destroyed.",
    })

    -- A Button doubles as a live status readout: its :SetTitle / :SetDesc repaint
    -- the on-screen text, which is what makes it a good display target.
    local Status = Tab:Button({
        Title = "Ticks: 0",
        Desc = "Status: idle",
        Icon = "activity",
        Callback = function()
            ANUI:Notify({
                Title = "Loops",
                Content = "Active loops: " .. Window:GetActiveLoopCount(),
                Icon = "timer",
                Duration = 3,
            })
        end,
    })

    local ticks = 0

    Tab:Toggle({
        Title = "Run a demo loop",
        Desc = "Window:Loop every 0.5s + StatusLoop every 0.25s",
        Callback = function(state)
            if state then
                -- Reusing a key replaces the previous loop with the same key.
                Window:Loop("demo-ticker", 0.5, function()
                    ticks += 1
                end)

                -- StatusLoop is Loop with requireReady already on, so it pauses
                -- while the window is hidden — perfect for UI text.
                Window:StatusLoop("demo-status", 0.25, function()
                    Status:SetTitle("Ticks: " .. ticks)
                    Status:SetDesc("Status: running")
                end)
            else
                Window:StopLoop("demo-ticker")
                Window:StopLoop("demo-status")
                Status:SetDesc("Status: idle")
            end
        end,
    })

    Tab:Toggle({
        Title = "Guarded loop",
        Desc = "ManagedLoop — only fires while your character exists",
        Callback = function(state)
            if state then
                Window:ManagedLoop("demo-guarded", 1, function()
                    local player = game:GetService("Players").LocalPlayer
                    return player and player.Character ~= nil
                end, function()
                    print("[ANUI] guarded tick — character is alive")
                end)
            else
                Window:StopLoop("demo-guarded")
            end
        end,
    })

    local Row = Tab:Group({})

    Row:Button({
        Title = "Is ticker running?",
        Callback = function()
            ANUI:Notify({
                Title = "Loop state",
                Content = "demo-ticker running: " .. tostring(Window:IsLoopRunning("demo-ticker")),
                Icon = "help-circle",
                Duration = 3,
            })
        end,
    })

    Row:Button({
        Title = "Stop everything",
        Callback = function()
            Window:StopAllLoops()
            Status:SetDesc("Status: idle")
            ANUI:Notify({
                Title = "Loops stopped",
                Content = "Every loop on this window was stopped.",
                Icon = "square",
                Duration = 3,
            })
        end,
    })

    -- Hand connections to the window and they are disconnected on destroy.
    Window:AddConnection(
        game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
            print("[ANUI] character respawned")
        end)
    )
end

-- ============================================================================
-- 5. CONFIG
-- ============================================================================

-- Wrapped in a function so the "no filesystem" case can bail out early.
local function BuildConfigTab()
    local Tab = ConfigSection:Tab({
        Title = "Save & load",
        Icon = "folder-cog",
        Desc = "Flags + ConfigManager",
    })

    Tab:Paragraph({
        Title = "Config & flags",
        Desc = "Give a stateful element a `Flag` and its value is written on Save "
            .. "and restored on Load — no per-element code.\n"
            .. "Persisted\tToggle · Slider · Dropdown · Input · Keybind · Colorpicker\n"
            .. "Not persisted\tButton (it has no Flag)\n"
            .. "On disk\tANUI/ANUIDemo/config/<name>.json",
    })

    -- Everything below is only useful when the executor can touch the filesystem.
    if not ConfigManager then
        Tab:Paragraph({
            Title = "{triangle-alert} Config unavailable",
            Desc = "Window.ConfigManager is nil. Either the window has no `Folder`, "
                .. "or this executor is missing the file globals readfile, writefile, "
                .. "isfile and makefolder. Everything else in this demo still works.",
        })
        return
    end

    local Flags = Tab:Section({
        Title = "Flagged elements {flag}",
        Opened = true,
        Box = true,
    })

    Flags:Paragraph({
        Title = "Try me",
        Desc = "Change these, hit Save, rejoin the game, then hit Load.",
    })

    Flags:Toggle({
        Title = "Auto Farm",
        Flag = "AutoFarm",
        Callback = function(state)
            print("[ANUI] Auto Farm:", state)
        end,
    })

    Flags:Slider({
        Title = "Walk Speed",
        Flag = "WalkSpeed",
        Value = { Min = 16, Max = 200, Default = 16 },
        Callback = function(value)
            print("[ANUI] Walk Speed:", tonumber(value))
        end,
    })

    Flags:Dropdown({
        Title = "Weapon",
        Flag = "Weapon",
        Values = { "Sword", "Bow", "Staff" },
        Value = "Sword",
        Callback = function(value)
            print("[ANUI] Weapon:", value)
        end,
    })

    Flags:Input({
        Title = "Player name",
        Flag = "TargetPlayer",
        Placeholder = "Someone",
        Callback = function(text)
            print("[ANUI] Target:", text)
        end,
    })

    Flags:Keybind({
        Title = "Attack key",
        Flag = "AttackKey",
        Value = "E",
        Callback = function(key)
            print("[ANUI] Attack key:", key)
        end,
    })

    Flags:Colorpicker({
        Title = "Highlight color",
        Flag = "HighlightColor",
        Default = Color3.fromHex("#40c9ff"),
        Callback = function(color)
            print("[ANUI] Highlight:", color:ToHex())
        end,
    })

    Tab:Space({ Columns = 2 })

    local Manage = Tab:Section({
        Title = "Manage configs {folder}",
        Opened = true,
        Box = true,
    })

    -- Typing here only changes which name Save / Load will act on.
    local NameInput = Manage:Input({
        Title = "Config name",
        Icon = "file-cog",
        Value = ConfigName,
        Callback = function(value)
            ConfigName = value
        end,
    })

    local AutoLoadToggle = Manage:Toggle({
        Title = "Auto load this config",
        Desc = "Marks it to load on startup",
        Callback = function(state)
            Window.CurrentConfig:SetAutoLoad(state)
        end,
    })

    local Existing = ConfigManager:AllConfigs()

    local ConfigsDropdown = Manage:Dropdown({
        Title = "All configs",
        Desc = "Pick one that already exists on disk",
        Values = Existing,
        Value = table.find(Existing, ConfigName) and ConfigName or nil,
        Callback = function(value)
            ConfigName = value
            NameInput:Set(value)
            -- .AutoLoad is a field on the config object, not a method.
            AutoLoadToggle:Set((ConfigManager:GetConfig(ConfigName)).AutoLoad or false)
        end,
    })

    local Actions = Manage:Group({})

    Actions:Button({
        Title = "Save",
        Icon = "save",
        Callback = function()
            Window.CurrentConfig = ConfigManager:Config(ConfigName)
            if Window.CurrentConfig:Save() then
                ANUI:Notify({
                    Title = "Config saved",
                    Content = "Saved '" .. ConfigName .. "'",
                    Icon = "check",
                    Duration = 3,
                })
            end
            -- Refresh so a brand-new name shows up in the list.
            ConfigsDropdown:Refresh(ConfigManager:AllConfigs())
        end,
    })

    Actions:Divider()

    Actions:Button({
        Title = "Load",
        Icon = "refresh-cw",
        Callback = function()
            Window.CurrentConfig = ConfigManager:Config(ConfigName)
            if Window.CurrentConfig:Load() then
                ANUI:Notify({
                    Title = "Config loaded",
                    Content = "Restored '" .. ConfigName .. "'",
                    Icon = "refresh-cw",
                    Duration = 3,
                })
            end
        end,
    })

    Tab:Button({
        Title = "Delete this config",
        Desc = "Asks first — ConfigManager:DeleteConfig(name)",
        Icon = "trash",
        Callback = function()
            Window:Dialog({
                Title = "Delete '" .. ConfigName .. "'?",
                Content = "The file is removed from disk. This cannot be undone.",
                Icon = "trash",
                Width = 340,
                Buttons = {
                    { Title = "Cancel", Variant = "Secondary", Callback = function() end },
                    {
                        Title = "Delete",
                        Variant = "Primary",
                        Icon = "trash",
                        Callback = function()
                            ConfigManager:DeleteConfig(ConfigName)
                            ConfigsDropdown:Refresh(ConfigManager:AllConfigs())
                            ANUI:Notify({
                                Title = "Config deleted",
                                Content = "Removed '" .. ConfigName .. "'",
                                Icon = "trash",
                                Duration = 3,
                            })
                        end,
                    },
                },
            })
        end,
    })

    local Inspect = Tab:Group({})

    Inspect:Button({
        Title = "Show stored data",
        Callback = function()
            -- Custom values live alongside your flags in the same file.
            Window.CurrentConfig:Set("lastPlayer", game:GetService("Players").LocalPlayer.Name)

            local keys = {}
            for key in pairs(Window.CurrentConfig:GetData() or {}) do
                table.insert(keys, key)
            end
            table.sort(keys)

            ANUI:Notify({
                Title = "Config data",
                Content = #keys > 0 and table.concat(keys, ", ") or "Nothing stored yet.",
                Icon = "database",
                Duration = 6,
            })
        end,
    })

    Inspect:Button({
        Title = "Auto-load list",
        Callback = function()
            -- GetAutoLoadConfigs returns a JSON string, not a table.
            print("[ANUI] Auto-load configs:", ConfigManager:GetAutoLoadConfigs())
            ANUI:Notify({
                Title = "Auto-load",
                Content = "Printed to console (it returns a JSON string).",
                Icon = "terminal",
                Duration = 3,
            })
        end,
    })
end

BuildConfigTab()

-- ============================================================================
-- READY
-- ============================================================================

-- Land on the Welcome tab and say hello.
Window:SelectTab(WelcomeTab.Index)

ANUI:Notify({
    Title = "ANUI Demo loaded",
    Content = "Press RightShift to hide or show the window.",
    Icon = "sparkles",
    Duration = 6,
})
