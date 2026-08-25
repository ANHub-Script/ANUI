# Category

A horizontal, scrollable strip of options that acts as a sub-tab selector inside a tab. Pick an option and, in the callback, show the matching group of elements while hiding the rest — a compact way to fit many "pages" of controls into a single tab.

## Basic usage

```lua
local myTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })

myTab:Category({
    Title = "Select Category",
    Default = "Weapons",
    Options = {
        { Title = "Weapons", Icon = "sword" },
        { Title = "Armor",   Icon = "shield" },
        { Title = "Potions", Icon = "flask-round" },
    },
    Callback = function(selected)
        print("Selected category:", selected)
    end,
})
```

## Configuration

The fields that drive behavior:

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | Label shown above the option strip. |
| `Desc` | `string` | `nil` | Optional description under the title. |
| `Options` | `array` | `{}` | The selectable options. Each entry is a **string** or an **option table** (see below). |
| `Default` | `string` | first option | The option selected on creation. |
| `Callback` / `OnChanged` | `function` | `nil` | Runs when the selection changes. **Receives the selected option's name (string).** |

### Option entries

Each entry in `Options` is either a plain string, or a table:

| Field | Type | Description |
| --- | --- | --- |
| `Title` / `Name` / `Value` / `[1]` | `string` | The option's name — the value passed to the callback. |
| `Icon` / `Image` | `string` | Optional icon (Lucide name or `rbxassetid://…`). |
| `IconSize` | `number` | Per-option icon size override. |
| `Desc` | `string` | Optional per-option description. |

Options may also carry the fine-grained icon fields `ScaleType`, `KeepAspect` / `Native`, `NativeSize` and `Tint`.

### Appearance & layout

These are all optional; the defaults are tuned to match the rest of the UI.

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Height` | `number` | `45` | Height of the whole strip. |
| `ButtonHeight` | `number` | `32` | Height of each option button. |
| `IconSize` | `number` | `18` | Default option icon size. |
| `TextSize` | `number` | `14` | Option label text size. |
| `Radius` | `number` | `8` | Corner radius of the option buttons. |
| `Gap` / `Padding` | `number` | `8` | Spacing between option buttons. |
| `SidePadding` | `number` | `12` | Padding at the left/right ends of the strip. |
| `ScrollSpeed` | `number` | `35` | Horizontal scroll speed. |
| `Transparency` | `number` | `0.5` | Background transparency of inactive buttons. |
| `AutoCapture` | `boolean` | `true` | Automatically register elements created after the Category into the current option (see below). |
| `Sticky` | `boolean` | `nil` (auto) | Pin the strip while scrolling the tab. |
| `ZIndex` | `number` | `6` | Render order of the strip. |

::: details Advanced tag & icon options
`ActiveTag` (`"Toggle"`), `InactiveTag` (`"Button"`) and `TextTag` (`"Text"`) select the theme tags used to style active/inactive buttons and their text. `IconScaleType`, `IconKeepAspect` (`true`), `IconAutoWidth` (`true`) and `TintIcon` (auto) fine-tune icon rendering, while `ContentPadding` (`5`) and `AlignWithContent` (`true`) control how the strip aligns with the elements below it.
:::

## Methods

### `Category:Select(name, silent?)`

Selects an option by name. Pass `silent = true` to update the selection without firing the callback. Aliased as `Category:SetValue(name, silent?)`.

```lua
category:Select("Armor")
category:Select("Potions", true) -- no callback
```

### `Category:GetSelected()`

Returns the currently selected option name.

```lua
print(category:GetSelected())
```

### `Category:SetCallback(fn)`

Replaces the change callback.

```lua
category:SetCallback(function(name) print("now on", name) end)
```

### `Category:Add(name, ...)`

Registers one or more existing elements under the option `name`, so they show/hide with it.

### `Category:Remove(item)`

Unregisters a previously added element.

### `Category:GetElements(name?)`

Returns the elements registered to an option, or all of them when `name` is omitted.

### `Category:Refresh()`

Rebuilds the option strip after its options or elements change.

### `Category:Capture(name)` / `Category:StopCapture()`

Begins capturing newly-created elements into option `name`, and stops capturing. This is the manual form of `AutoCapture`.

### `Category:With(name, builder)`

Runs `builder` and registers every element it creates under the option `name`.

```lua
category:With("Weapons", function()
    myTab:Toggle({ Title = "Auto Swing" })
    myTab:Slider({ Title = "Range", Value = { Min = 0, Max = 50, Default = 10 } })
end)
```

### `Category:AddOption(option, order?)`

Adds a new selectable option, optionally at position `order`.

### `Category:RemoveOption(name)`

Removes an option by name.

### `Category:SetOptions(options, newDefault?)`

Replaces all options, optionally selecting `newDefault`.

### `Category:GetOptions()`

Returns the current options.

### `Category:SetHeight(h)`

Sets the height of the strip.

### `Category:Destroy()`

Removes the Category.

## The show/hide pattern

::: tip Common usage
The typical pattern is to create a Category with your options, then in the callback **show the selected option's elements and hide the rest**. You can track the elements yourself and toggle each one's `.Visible`, or lean on `AutoCapture` (on by default) which hooks every element created *after* the Category into the current option so it manages visibility for you. `Category:With(name, builder)` and `Category:Capture(name)` / `Category:StopCapture()` give you explicit control over that capture.
:::

The example below builds a small "Upgrade System": a `Categories` table stores the elements for each option, a helper hides them on creation, and the callback shows only the selected option's elements.

```lua
local UpgradeTab = Window:Tab({ Title = "Upgrade System", Icon = "hammer" })

-- Store elements per option so we can show/hide them
local Categories = { Yen = {}, Token = {}, Rank = {} }

-- Find an element's root frame (works across element types)
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
end

-- Register an element under a category and hide it by default
local function AddElement(category, element)
    table.insert(Categories[category], element)
    local frame = GetElementFrame(element)
    if frame then frame.Visible = false end
    return element
end

-- Show only the selected category's elements
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then frame.Visible = (name == selected) end
        end
    end
end

UpgradeTab:Category({
    Title = "Select Category",
    Default = "Yen",
    Options = {
        { Title = "Yen",   Icon = "coins" },
        { Title = "Token", Icon = "layers" },
        { Title = "Rank",  Icon = "shield" },
    },
    Callback = OnCategoryChanged,
})

UpgradeTab:Space({ Columns = 1 })

-- Build and register each category's elements
AddElement("Yen", UpgradeTab:Paragraph({ Title = "Yen Upgrades", Desc = "Upgrade stats using Yen" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" }))

AddElement("Token", UpgradeTab:Paragraph({ Title = "Token Upgrades", Desc = "Special upgrades using Tokens" }))
AddElement("Token", UpgradeTab:Toggle({ Title = "Yen Multiplier", Desc = "Cost: 5 Tokens | x1.5 Yen" }))

AddElement("Rank", UpgradeTab:Paragraph({ Title = "Rank Information", Desc = "Current Rank: S-Class" }))
AddElement("Rank", UpgradeTab:Button({ Title = "Rank Up", Icon = "arrow-up-circle" }))

-- Show the default category once on load
OnCategoryChanged("Yen")
```

For a fuller walkthrough of this technique, see the [Category pages recipe](/examples/category-pages).
