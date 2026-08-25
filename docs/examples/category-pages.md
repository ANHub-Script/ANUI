# Category Pages

A common pattern: one tab that shows several "pages" of elements, switched by a horizontal strip at the top. This is built with the [Category](/elements/category) element. The recipe below is adapted from the demo's **Upgrade System**.

## How it works

A Category renders a scrollable row of options. When the user picks one, its `Callback` fires with the selected option's name. We keep a table that maps each option name to the elements that belong to it, and flip every element's `.Visible` so only the active page shows.

## 1. Track elements per category

Define the categories, a helper to find an element's frame, and a helper that registers an element under a category (hiding it by default).

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "My Hub", Folder = "MyHub" })
local Tab = Window:Tab({ Title = "Upgrades", Icon = "hammer" })

-- One bucket of elements per category.
local Categories = {
    Combat = {},
    Farming = {},
    Settings = {},
}

-- Reach the element's root frame so we can toggle its visibility.
local function GetElementFrame(element)
    if element.ElementFrame then
        return element.ElementFrame
    elseif element.UIElements and element.UIElements.Main then
        return element.UIElements.Main
    end
    for _, value in pairs(element) do
        if type(value) == "table" and value.UIElements and value.UIElements.Main then
            return value.UIElements.Main
        end
    end
    return nil
end

-- Register an element under a category and hide it initially.
local function AddElement(categoryName, element)
    if Categories[categoryName] then
        table.insert(Categories[categoryName], element)
        local frame = GetElementFrame(element)
        if frame then
            frame.Visible = false
        end
    end
    return element
end

-- Show only the selected category's elements; hide the rest.
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        local isVisible = (name == selected)
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then
                frame.Visible = isVisible
            end
        end
    end
end
```

## 2. Add the Category strip

Create the Category with one option per page. `Default` sets the page shown first, and `Callback` runs `OnCategoryChanged` whenever the user switches.

```lua
Tab:Category({
    Title = "Select Category",
    Default = "Combat",
    Options = {
        { Title = "Combat", Icon = "sword" },
        { Title = "Farming", Icon = "coins" },
        { Title = "Settings", Icon = "settings" },
    },
    Callback = OnCategoryChanged, -- receives the selected option name (string)
})

Tab:Space({ Columns = 1 }) -- a little breathing room below the strip
```

## 3. Build each page and register its elements

Create elements as usual, wrapping each in `AddElement("<category>", ...)` so it joins the right bucket and starts hidden.

```lua
-- Combat
AddElement("Combat", Tab:Paragraph({ Title = "Combat", Desc = "Fighting options" }))
AddElement("Combat", Tab:Toggle({ Title = "God Mode", Callback = function(v) print(v) end }))
AddElement("Combat", Tab:Slider({ Title = "Damage", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end }))

-- Farming
AddElement("Farming", Tab:Paragraph({ Title = "Farming", Desc = "Auto-farm options" }))
AddElement("Farming", Tab:Toggle({ Title = "Auto Farm", Callback = function(v) print(v) end }))
AddElement("Farming", Tab:Dropdown({ Title = "Target", Values = { "Coins", "Gems", "XP" }, Value = "Coins", Callback = function(v) print(v) end }))

-- Settings
AddElement("Settings", Tab:Paragraph({ Title = "Settings", Desc = "Menu settings" }))
AddElement("Settings", Tab:Toggle({ Title = "Auto Save", Callback = function(v) print(v) end }))
```

## 4. Show the default page

The Category starts on `Default`, so call `OnCategoryChanged` once to hide the other pages up front.

```lua
OnCategoryChanged("Combat")
```

That is the whole pattern: switching options now swaps which page of elements is visible.

## Alternative: built-in capture

The Category can track elements for you instead of a manual `Categories` table. With `AutoCapture` enabled (the default), elements created after the Category are hooked automatically. The cleanest way is `:With(name, builder)` — everything created inside the builder is assigned to that option, and the Category shows/hides each group as you switch:

```lua
local cat = Tab:Category({
    Title = "Select Category",
    Default = "Combat",
    Options = { "Combat", "Farming", "Settings" },
})

cat:With("Combat", function()
    Tab:Toggle({ Title = "God Mode", Callback = function(v) print(v) end })
    Tab:Slider({ Title = "Damage", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end })
end)

cat:With("Farming", function()
    Tab:Toggle({ Title = "Auto Farm", Callback = function(v) print(v) end })
end)

cat:With("Settings", function()
    Tab:Toggle({ Title = "Auto Save", Callback = function(v) print(v) end })
end)
```

::: tip
`:Capture(name)` / `:StopCapture()` do the same thing without a builder — bracket any range of element creations between them. Use `:GetElements(name?)` to read back what a category is tracking. See the full method list on the [Category](/elements/category) page.
:::
