# 分类页面

一种常见模式：一个标签页展示多"页"元素，通过顶部的一条横向选项条来切换。它由 [Category](/zh/elements/category) 元素构建。下面的方案改编自演示脚本中的 **Upgrade System**。

## 工作原理

Category 会渲染一行可滚动的选项。当用户选中其中一个时，它的 `Callback` 会带着被选中选项的名称触发。我们维护一张表，把每个选项名称映射到属于它的元素，然后翻转每个元素的 `.Visible`，让只有当前活动的页面显示出来。

## 1. 按分类跟踪元素

定义各个分类、一个用于找到元素框体的辅助函数，以及一个把元素注册到某个分类下（默认隐藏它）的辅助函数。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "My Hub", Folder = "MyHub" })
local Tab = Window:Tab({ Title = "Upgrades", Icon = "hammer" })

-- 每个分类一个元素容器。
local Categories = {
    Combat = {},
    Farming = {},
    Settings = {},
}

-- 拿到元素的根框体，以便我们切换它的可见性。
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

-- 把元素注册到某个分类下，并在一开始隐藏它。
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

-- 只显示被选中分类的元素；隐藏其余的。
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

## 2. 添加 Category 选项条

创建 Category，每个页面对应一个选项。`Default` 设定最先显示的页面，`Callback` 会在用户切换时运行 `OnCategoryChanged`。

```lua
Tab:Category({
    Title = "Select Category",
    Default = "Combat",
    Options = {
        { Title = "Combat", Icon = "sword" },
        { Title = "Farming", Icon = "coins" },
        { Title = "Settings", Icon = "settings" },
    },
    Callback = OnCategoryChanged, -- 接收被选中的选项名称（string）
})

Tab:Space({ Columns = 1 }) -- 在选项条下方留出一点空隙
```

## 3. 构建每个页面并注册它的元素

像平常一样创建元素，把每个元素包在 `AddElement("<分类>", ...)` 里，让它加入正确的容器，并以隐藏状态开始。

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

## 4. 显示默认页面

Category 从 `Default` 开始，所以调用一次 `OnCategoryChanged`，在一开始就隐藏其他页面。

```lua
OnCategoryChanged("Combat")
```

这就是整个模式：现在切换选项就会换掉当前可见的那一页元素。

## 备选方案：内置捕获

Category 可以替你跟踪元素，而不必手写 `Categories` 表。在 `AutoCapture` 启用时（默认如此），在 Category 之后创建的元素会被自动挂接。最干净的方式是 `:With(name, builder)` —— 在 builder 内部创建的一切都会被分配给那个选项，并且 Category 会在你切换时显示/隐藏每一组：

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
`:Capture(name)` / `:StopCapture()` 在不用 builder 的情况下做同样的事 —— 把任意一段元素创建代码夹在它们之间。用 `:GetElements(name?)` 读回某个分类正在跟踪的内容。完整的方法列表见 [Category](/zh/elements/category) 页面。
:::
