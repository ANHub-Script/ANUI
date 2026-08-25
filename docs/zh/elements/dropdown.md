# Dropdown

可供选择的列表，支持单选或多选、逐条目图标、描述、分隔符和图片。在没有全局回调的情况下，它还能充当**操作菜单**。

## 基本用法

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

## 配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dropdown"` | 主标签。支持[富文本标记](/zh/elements/#title-与-desc-中的富文本)。 |
| `Desc` | `string` | `nil` | 标题下方的可选描述。 |
| `Values` | `table` | `{}` | 选项列表 —— 字符串或条目对象（见下文）。`{ Type = "Divider" }` 会插入一条分隔符。 |
| `Value` | `string` \| `table` | `nil` | 初始选中项：字符串、条目对象，或数组（用于 `Multi`）。 |
| `Multi` | `boolean` | `false` | 允许同时选中多个条目。 |
| `AllowNone` | `boolean` | `false` | 允许取消选中最后剩下的那个条目（配合 `Multi` 最有用）。 |
| `SearchBarEnabled` | `boolean` | `false` | 在菜单顶部显示搜索栏。 |
| `MenuWidth` | `number` | `nil` | 固定的菜单宽度，单位为像素。留空则自动适配。 |
| `Locked` | `boolean` | `false` | 显示锁定遮罩并阻止交互。 |
| `Image` | `string` \| `table` | `nil` | 下拉菜单行上的左对齐图片。 |
| `ImageSize` | `number` \| `UDim2` | `30` | 图片尺寸 —— 一个数字，或用于图片卡片的 `UDim2`。 |
| `ImagePadding` | `number` | `—` | 条目图片周围的间距。 |
| `IconThemed` | `boolean` | `false` | 用当前主题色为图标着色。 |
| `Color` | `Color3` \| `string` | `nil` | 彩色背景（主题名称或 `Color3`）。 |
| `Callback` | `function` | `nil` | 选择时执行。参见下面关于签名的说明。 |
| `Flag` | `string` | `nil` | 配置持久化用的 key。参见[配置与 Flag](/zh/features/config-and-flags)。 |
| `Buttons` | `table` | `nil` | 渲染在该行内的内联按钮。 |
| `TitleGradient` | `table` | `nil` | 应用于标题文字的渐变。 |
| `DescGradient` | `table` | `nil` | 应用于描述文字的渐变。 |

### 条目对象

`Values` 中的每一项除了可以是普通字符串，也可以是一个表：

| Field | Type | 描述 |
| --- | --- | --- |
| `Title` | `string` | 条目的标签。 |
| `Desc` | `string` | 显示在标题下方的可选描述。 |
| `Icon` | `string` | 条目的可选图标。 |
| `Images` | `table` | 图片 id / 图标名称的数组，或卡片表（`{ Card = true, Title, Quantity, Image, Gradient }`）。 |
| `Locked` | `boolean` | 禁止选中这个特定条目。 |
| `Callback` | `function` | 逐条目的操作，用于**菜单模式**（见下文）。 |
| `Type` | `string` | 设为 `"Divider"`（且不带其他字段）可在条目之间插入一条分隔符。 |

::: info Callback 签名 —— 以及菜单模式
- **单选：** 回调接收所选的**值** —— 字符串条目得到一个 `string`，对象条目得到**原始的条目对象**（读取 `option.Title` 等）。
- **多选**（`Multi = true`）：回调接收一个包含所选条目的**数组**。
- **没有全局 `Callback`：** 下拉菜单会变成**操作菜单** —— 点击某个条目会转而执行*该条目自己的* `Callback`。
:::

Dropdown 同样继承[共享基础](/zh/elements/#共享基础)的配置和方法。

## 方法

### `Dropdown:Select(items)`

通过代码设置当前的选中项。传入单个值，或在启用 `Multi` 时传入一个数组。

```lua
myDropdown:Select("Blue")
myDropdown:Select({ "A", "C" }) -- multi
```

### `Dropdown:Refresh(values)`

用新的 `values` 数组替换整个选项列表。

```lua
myDropdown:Refresh({ "New 1", "New 2", "New 3" })
```

### `Dropdown:Edit(itemName, newData)`

按名称找到一个已存在的条目，并用 `newData` 中的字段更新它。

```lua
myDropdown:Edit("Option 1", { Title = "Option 1 (updated)", Icon = "check" })
```

### `Dropdown:EditDrop(target, newData)`

编辑下拉菜单容器本身，把 `newData` 应用到给定的 `target` 上。

### `Dropdown:SetValueImage(img)` / `Dropdown:SetValueIcon(img)`

设置显示在当前所选值旁边的图片或图标。

### `Dropdown:SetMainImage(img, size)`

更新下拉菜单左对齐的图片及其尺寸。

### `Dropdown:Open()` / `Dropdown:Close()`

打开或关闭菜单。`Open()` 是切换式的 —— 在菜单已打开时调用它会把菜单关闭。

### `Dropdown:Display()`

为当前的选中项刷新所显示的值（文字、图标和图片）。

### `Dropdown:Lock(text?)` / `Dropdown:Unlock()`

锁定或解锁下拉菜单。可选的 `text` 参数用于设置遮罩上的文字。

## 示例

### 基础字符串列表

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

### 带图标（对象条目）

对于对象条目，回调接收的是**条目对象** —— 读取 `option.Title`。

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

### 带描述

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

当 `Multi = true` 时，回调接收一个包含所选条目的**数组**。

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

### 用分隔符分组

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

### Allow none（多选）

`AllowNone` 允许多选下拉菜单一直取消到零个选中条目。

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

### 锁定的条目

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

### 自定义宽度与搜索栏

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

### 通过代码选择

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

### 操作菜单（逐条目回调）

完全省略全局 `Callback`，并给每个条目各自的 `Callback` —— 这样下拉菜单的行为就像一个右键操作菜单。

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

::: tip 持久化选中项
添加一个 `Flag`，即可在会话之间保存并恢复所选的值。参见[配置与 Flag](/zh/features/config-and-flags)。
:::
