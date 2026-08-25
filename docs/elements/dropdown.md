# Dropdown

A selectable list supporting single or multiple selection, per-item icons, descriptions, dividers and images. With no global callback it doubles as an **action menu**.

## Basic usage

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Dropdown({
    Title = "Basic",
    Values = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Value = "Option 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dropdown"` | Main label. Supports [rich-text tokens](/elements/#rich-text-in-title-desc). |
| `Desc` | `string` | `nil` | Optional description under the title. |
| `Values` | `table` | `{}` | List of options — strings or item objects (see below). `{ Type = "Divider" }` inserts a divider. |
| `Value` | `string` \| `table` | `nil` | Initial selection: a string, an item object, or an array (for `Multi`). |
| `Multi` | `boolean` | `false` | Allow selecting multiple items. |
| `AllowNone` | `boolean` | `false` | Allow deselecting the last remaining item (most useful with `Multi`). |
| `SearchBarEnabled` | `boolean` | `false` | Show a search bar at the top of the menu. |
| `MenuWidth` | `number` | `nil` | Fixed menu width in pixels. Omit for auto-fit. |
| `Locked` | `boolean` | `false` | Renders a lock overlay and blocks interaction. |
| `Image` | `string` \| `table` | `nil` | Left-aligned image on the dropdown row. |
| `ImageSize` | `number` \| `UDim2` | `30` | Image size — a number, or a `UDim2` for image cards. |
| `ImagePadding` | `number` | `—` | Spacing around item images. |
| `IconThemed` | `boolean` | `false` | Tint the icon with the current theme color. |
| `Color` | `Color3` \| `string` | `nil` | Colored background (theme name or `Color3`). |
| `Callback` | `function` | `nil` | Runs on selection. See the signature note below. |
| `Flag` | `string` | `nil` | Config persistence key. See [Config & Flags](/features/config-and-flags). |
| `Buttons` | `table` | `nil` | Inline buttons rendered in the row. |
| `TitleGradient` | `table` | `nil` | Gradient applied to the title text. |
| `DescGradient` | `table` | `nil` | Gradient applied to the description text. |

### Item objects

Instead of plain strings, each entry in `Values` can be a table:

| Field | Type | Description |
| --- | --- | --- |
| `Title` | `string` | The item's label. |
| `Desc` | `string` | Optional description shown under the title. |
| `Icon` | `string` | Optional icon for the item. |
| `Images` | `table` | Array of image ids / icon names, or card tables (`{ Card = true, Title, Quantity, Image, Gradient }`). |
| `Locked` | `boolean` | Disables selection of this specific item. |
| `Callback` | `function` | Per-item action, used in **menu mode** (see below). |
| `Type` | `string` | Set to `"Divider"` (with no other fields) to insert a divider between items. |

::: info Callback signature — and menu mode
- **Single-select:** the callback receives the selected **value** — a `string` for string items, or the **original item object** for object items (read `option.Title`, etc.).
- **Multi-select** (`Multi = true`): the callback receives an **array** of the selected items.
- **No global `Callback`:** the dropdown becomes an **action menu** — clicking an item runs *that item's own* `Callback` instead.
:::

Dropdowns also inherit the [shared base](/elements/#shared-base) config and methods.

## Methods

### `Dropdown:Select(items)`

Sets the current selection programmatically. Pass a single value, or an array when `Multi` is enabled.

```lua
myDropdown:Select("Blue")
myDropdown:Select({ "A", "C" }) -- multi
```

### `Dropdown:Refresh(values)`

Replaces the entire list of options with a new `values` array.

```lua
myDropdown:Refresh({ "New 1", "New 2", "New 3" })
```

### `Dropdown:Edit(itemName, newData)`

Updates an existing item, found by its name, with the fields in `newData`.

```lua
myDropdown:Edit("Option 1", { Title = "Option 1 (updated)", Icon = "check" })
```

### `Dropdown:EditDrop(target, newData)`

Edits the dropdown container itself, applying `newData` to the given `target`.

### `Dropdown:SetValueImage(img)` / `Dropdown:SetValueIcon(img)`

Sets the image or icon shown next to the currently selected value.

### `Dropdown:SetMainImage(img, size)`

Updates the dropdown's left-aligned image and its size.

### `Dropdown:Open()` / `Dropdown:Close()`

Opens or closes the menu. `Open()` toggles — calling it while open closes the menu.

### `Dropdown:Display()`

Refreshes the displayed value (text, icon and image) for the current selection.

### `Dropdown:Lock(text?)` / `Dropdown:Unlock()`

Locks or unlocks the dropdown. An optional `text` sets the overlay label.

## Examples

### Basic string list

```lua
myTab:Dropdown({
    Title = "Basic",
    Desc = "Simple list of string values with a global selection callback.",
    Values = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Value = "Option 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

### With icons (object items)

For object items, the callback receives the **item object** — read `option.Title`.

```lua
myTab:Dropdown({
    Title = "With Icons",
    Desc = "Each option is an object containing a title and an icon.",
    Values = {
        { Title = "Bird",     Icon = "bird" },
        { Title = "House",    Icon = "house" },
        { Title = "Settings", Icon = "settings" },
        { Title = "Trash",    Icon = "trash-2" },
    },
    Value = { Title = "Bird", Icon = "bird" },
    Callback = function(option)
        print("Selected:", option.Title)
    end
})
```

### With descriptions

```lua
myTab:Dropdown({
    Title = "With Descriptions",
    Values = {
        { Title = "Option A", Desc = "This is option A" },
        { Title = "Option B", Desc = "This is option B" },
        { Title = "Option C", Desc = "This is option C" },
    },
    Value = { Title = "Option A", Desc = "This is option A" },
    Callback = function(option) print(option.Title) end
})
```

### Multi-select

With `Multi = true`, the callback receives an **array** of selected items.

```lua
myTab:Dropdown({
    Title = "Multi-Select",
    Desc = "Select multiple options (callback returns an array of selected items).",
    Values = {
        { Title = "Category A", Icon = "folder" },
        { Title = "Category B", Icon = "folder" },
        { Title = "Category C", Icon = "folder" },
        { Title = "Category D", Icon = "folder" },
    },
    Multi = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do
            table.insert(titles, v.Title)
        end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### Divider grouping

```lua
myTab:Dropdown({
    Title = "Divider Grouping",
    Desc = "Use Type = 'Divider' to split options into visually separated groups.",
    Values = {
        { Title = "Group 1 - A", Icon = "star" },
        { Title = "Group 1 - B", Icon = "star" },
        { Type = "Divider" },
        { Title = "Group 2 - A", Icon = "heart" },
        { Title = "Group 2 - B", Icon = "heart" },
    },
    Value = { Title = "Group 1 - A", Icon = "star" },
    Callback = function(option) print(option.Title) end
})
```

### Allow none (multi)

`AllowNone` lets a multi-select drop back down to zero selected items.

```lua
myTab:Dropdown({
    Title = "Multi (AllowNone)",
    Desc = "Multi-select with AllowNone lets you deselect the last remaining item.",
    Values = { { Title = "A" }, { Title = "B" }, { Title = "C" } },
    Value = "B",
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do table.insert(titles, v.Title) end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### Locked items

```lua
myTab:Dropdown({
    Title = "Locked Items",
    Desc = "Per-item locking disables selection for specific options.",
    Values = {
        { Title = "Usable A" },
        { Title = "Locked B", Locked = true },
        { Title = "Usable C" },
    },
    Value = "Usable A",
    Callback = function(value)
        print("Selected:", typeof(value) == "table" and value.Title or value)
    end
})
```

### Custom width and search bar

```lua
myTab:Dropdown({
    Title = "Custom Width",
    Desc = "Manually define menu width instead of using auto-fit.",
    Values = { "Short", "Medium Option", "Veryyyyyyyy Long Option Name" },
    Value = "Short",
    MenuWidth = 250,
    SearchBarEnabled = true,
    Callback = function(value) print(value) end
})
```

### Programmatic selection

```lua
local colors = myTab:Dropdown({
    Title = "Programmatic Select",
    Values = { "Red", "Green", "Blue" },
    Value = "Red",
    Callback = function(value) print("Selected:", value) end
})

myTab:Button({
    Title = "Select 'Blue' via code",
    Callback = function()
        colors:Select("Blue")
    end
})
```

### Action menu (per-item callbacks)

Omit the global `Callback` entirely and give each item its own `Callback` — the dropdown behaves like a right-click action menu.

```lua
myTab:Dropdown({
    Title = "Advanced Actions",
    Desc = "No global callback: items behave like an action menu using per-item callbacks.",
    Values = {
        { Title = "New file",  Desc = "Create a new file",   Icon = "file-plus", Callback = function() print("New file") end },
        { Title = "Copy link", Desc = "Copy the file link",  Icon = "copy",      Callback = function() print("Copy link") end },
        { Type = "Divider" },
        { Title = "Delete file", Desc = "Permanently delete the file", Icon = "trash", Callback = function() print("Delete file") end },
    }
})
```

::: tip Persisting the selection
Add a `Flag` to save and restore the selected value across sessions. See [Config & Flags](/features/config-and-flags).
:::
