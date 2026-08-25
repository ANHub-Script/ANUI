# Category

一条可横向滚动的选项条，在标签页内充当子标签页选择器。选中某个选项后，在回调中显示对应的元素组并隐藏其余部分——这是把多"页"控件塞进单个标签页的紧凑做法。

## 基本用法

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

## 配置

决定行为的字段：

| Field | Type | Default | 说明 |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | 显示在选项条上方的标签。 |
| `Desc` | `string` | `nil` | 标题下方的可选描述。 |
| `Options` | `array` | `{}` | 可选择的选项。每一项为一个**字符串**或一个**选项表**（见下文）。 |
| `Default` | `string` | 第一个选项 | 创建时选中的选项。 |
| `Callback` / `OnChanged` | `function` | `nil` | 选择发生变化时运行。**接收所选选项的名称（字符串）。** |

### 选项条目

`Options` 中的每一项要么是普通字符串，要么是一个表：

| Field | Type | 说明 |
| --- | --- | --- |
| `Title` / `Name` / `Value` / `[1]` | `string` | 选项的名称——传给回调的值。 |
| `Icon` / `Image` | `string` | 可选图标（Lucide 名称或 `rbxassetid://…`）。 |
| `IconSize` | `number` | 单个选项的图标尺寸覆盖值。 |
| `Desc` | `string` | 单个选项的可选描述。 |

选项还可以携带更细粒度的图标字段 `ScaleType`、`KeepAspect` / `Native`、`NativeSize` 和 `Tint`。

### 外观与布局

这些全部可选；默认值已经调校得与 UI 的其余部分相匹配。

| Field | Type | Default | 说明 |
| --- | --- | --- | --- |
| `Height` | `number` | `45` | 整条选项条的高度。 |
| `ButtonHeight` | `number` | `32` | 每个选项按钮的高度。 |
| `IconSize` | `number` | `18` | 默认的选项图标尺寸。 |
| `TextSize` | `number` | `14` | 选项标签的文本大小。 |
| `Radius` | `number` | `8` | 选项按钮的圆角半径。 |
| `Gap` / `Padding` | `number` | `8` | 选项按钮之间的间距。 |
| `SidePadding` | `number` | `12` | 选项条左右两端的内边距。 |
| `ScrollSpeed` | `number` | `35` | 横向滚动速度。 |
| `Transparency` | `number` | `0.5` | 未激活按钮的背景透明度。 |
| `AutoCapture` | `boolean` | `true` | 自动把 Category 之后创建的元素注册到当前选项（见下文）。 |
| `Sticky` | `boolean` | `nil`（自动） | 滚动标签页时固定选项条。 |
| `ZIndex` | `number` | `6` | 选项条的渲染顺序。 |

::: details 高级标签与图标选项
`ActiveTag`（`"Toggle"`）、`InactiveTag`（`"Button"`）和 `TextTag`（`"Text"`）用于选择设置激活/未激活按钮及其文本样式所用的主题标签。`IconScaleType`、`IconKeepAspect`（`true`）、`IconAutoWidth`（`true`）和 `TintIcon`（自动）用于微调图标渲染，而 `ContentPadding`（`5`）和 `AlignWithContent`（`true`）控制选项条如何与其下方的元素对齐。
:::

## 方法

### `Category:Select(name, silent?)`

按名称选中某个选项。传入 `silent = true` 可在不触发回调的情况下更新选择。别名为 `Category:SetValue(name, silent?)`。

```lua
category:Select("Armor")
category:Select("Potions", true) -- 不触发回调
```

### `Category:GetSelected()`

返回当前选中的选项名称。

```lua
print(category:GetSelected())
```

### `Category:SetCallback(fn)`

替换变更回调。

```lua
category:SetCallback(function(name) print("now on", name) end)
```

### `Category:Add(name, ...)`

将一个或多个已有元素注册到选项 `name` 下，使它们随该选项一起显示/隐藏。

### `Category:Remove(item)`

取消注册先前添加的元素。

### `Category:GetElements(name?)`

返回注册到某个选项的元素；若省略 `name`，则返回全部元素。

### `Category:Refresh()`

在选项或其元素发生变化后重建选项条。

### `Category:Capture(name)` / `Category:StopCapture()`

开始把新创建的元素捕获到选项 `name`，以及停止捕获。这是 `AutoCapture` 的手动形式。

### `Category:With(name, builder)`

运行 `builder`，并把它创建的每个元素注册到选项 `name` 下。

```lua
category:With("Weapons", function()
    myTab:Toggle({ Title = "Auto Swing" })
    myTab:Slider({ Title = "Range", Value = { Min = 0, Max = 50, Default = 10 } })
end)
```

### `Category:AddOption(option, order?)`

添加一个新的可选择选项，可选择性地放在位置 `order`。

### `Category:RemoveOption(name)`

按名称移除某个选项。

### `Category:SetOptions(options, newDefault?)`

替换所有选项，并可选择性地选中 `newDefault`。

### `Category:GetOptions()`

返回当前的选项。

### `Category:SetHeight(h)`

设置选项条的高度。

### `Category:Destroy()`

移除该 Category。

## 显示/隐藏模式

::: tip 常见用法
典型的做法是用你的选项创建一个 Category，然后在回调中**显示所选选项的元素并隐藏其余部分**。你可以自己跟踪这些元素并切换各自的 `.Visible`，也可以依靠 `AutoCapture`（默认开启），它会把 Category *之后*创建的每个元素挂到当前选项上，从而替你管理可见性。`Category:With(name, builder)` 以及 `Category:Capture(name)` / `Category:StopCapture()` 让你对这种捕获拥有显式控制权。
:::

下面的示例构建了一个小型"Upgrade System"：`Categories` 表保存每个选项对应的元素，一个辅助函数在创建时把它们隐藏，回调则只显示所选选项的元素。

```lua
local UpgradeTab = Window:Tab({ Title = "Upgrade System", Icon = "hammer" })

-- 按选项保存元素，以便显示/隐藏它们
local Categories = { Yen = {}, Token = {}, Rank = {} }

-- 找到某个元素的根框架（适用于各种元素类型）
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

-- 把元素注册到某个分类，并默认将其隐藏
local function AddElement(category, element)
    table.insert(Categories[category], element)
    local frame = GetElementFrame(element)
    if frame then frame.Visible = false end
    return element
end

-- 只显示所选分类的元素
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

-- 构建并注册每个分类的元素
AddElement("Yen", UpgradeTab:Paragraph({ Title = "Yen Upgrades", Desc = "Upgrade stats using Yen" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" }))

AddElement("Token", UpgradeTab:Paragraph({ Title = "Token Upgrades", Desc = "Special upgrades using Tokens" }))
AddElement("Token", UpgradeTab:Toggle({ Title = "Yen Multiplier", Desc = "Cost: 5 Tokens | x1.5 Yen" }))

AddElement("Rank", UpgradeTab:Paragraph({ Title = "Rank Information", Desc = "Current Rank: S-Class" }))
AddElement("Rank", UpgradeTab:Button({ Title = "Rank Up", Icon = "arrow-up-circle" }))

-- 加载时先显示默认分类一次
OnCategoryChanged("Yen")
```

要了解这一技巧的更完整讲解，请参阅[分类页面实用方案](/zh/examples/category-pages)。
