# 基础菜单

一个完整且注释详尽的入门菜单，可以直接复制、粘贴并运行。它会创建一个带两个标签页的窗口、一组最常用元素、一个用于分组的分区，以及一条由按钮触发的通知。

## 脚本

```lua
-- 1. 把 ANUI 加载到一个名为 `ANUI` 的 local 中。
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

-- 2. 创建窗口。只能存在一个窗口。
local Window = ANUI:CreateWindow({
    Title = "My Hub",                      -- 顶栏中显示的标题
    Author = "by you",                     -- 标题下方的副标题
    Icon = "rbxassetid://84366761557806",  -- 顶栏图标（asset id 或 Lucide 图标名称）
    Folder = "MyHub",                      -- 配置/密钥的磁盘文件夹（保存在 ANUI/MyHub 下）
    OpenButton = {                         -- 窗口关闭后用于重新打开它的悬浮按钮
        Title = "My Hub",
        Enabled = true,
        Draggable = true,
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
    },
})

-- 3. 添加标签页。每个标签页容纳元素，并出现在侧边栏中。
local Main = Window:Tab({ Title = "Main", Icon = "house" })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

-- 4. Paragraph 是一个富文本块 —— 很适合放在标签页顶部作为介绍。
Main:Paragraph({
    Title = "Welcome",
    Desc = "This starter menu shows the most common ANUI elements.",
})

-- Toggle —— 回调接收一个 BOOLEAN（新的开/关状态）。
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Value = false,
    Callback = function(state) -- state: boolean
        print("Auto Farm:", state)
    end,
})

-- Slider —— 回调接收一个格式化后的 STRING（按其步长格式化的值）。
Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: 格式化后的字符串
        print("Walk Speed:", value)
    end,
})

-- 5. Section 把相关元素归入一个可折叠的标题之下。
--    它是一个容器，所以你要在这个分区本身上创建元素。
local combat = Main:Section({ Title = "Combat" })

-- Dropdown —— 单选回调接收被选中的值（这里是一个字符串）。
combat:Dropdown({
    Title = "Weapon",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value) -- value: 被选中的项
        print("Weapon:", value)
    end,
})

-- Keybind —— 回调接收按键名称字符串（例如 "G"）。
combat:Keybind({
    Title = "Attack Key",
    Value = "G",
    Callback = function(key) -- key: 按键名称字符串
        print("Attack bound to:", key)
    end,
})

-- 6. Button 执行一个不带任何参数的回调。这里它触发了一条通知。
Settings:Button({
    Title = "Say Hello",
    Icon = "bell",
    Callback = function() -- 无参数
        ANUI:Notify({
            Title = "Hello!",
            Content = "Welcome to ANUI",
            Icon = "bell",
            Duration = 3,
        })
    end,
})
```

## 各部分的作用

- **加载行** —— 拉取库并把它赋给 `ANUI`。每个示例都以这种方式开头。
- **`ANUI:CreateWindow`** —— 返回你在其上构建的 `Window`。`Folder` 是配置与密钥在磁盘上的存放位置；`OpenButton` 会添加一个可拖动的悬浮按钮来重新打开窗口。参见[窗口配置](/zh/guide/window-configuration)。
- **`Window:Tab`** —— 每个标签页既是侧边栏中的一个页面，也是元素的容器。
- **元素** —— 通过在容器（Tab 或 Section）上调用方法来创建。如果之后想更新某个元素，请保存它的返回值。
- **`Main:Section`** —— 一个可折叠的容器，暴露与 Tab 相同的元素方法，因此你可以把相关的控件归为一组。
- **`ANUI:Notify`** —— 弹出一条提示。正文文本字段是 `Content`（不是 `Desc`），图标字段是 `Icon`。

::: tip 了解每个元素
每个元素都有自己的页面，附带完整的配置表和方法：[Toggle](/zh/elements/toggle)、[Slider](/zh/elements/slider)、[Dropdown](/zh/elements/dropdown)、[Button](/zh/elements/button)、[Keybind](/zh/elements/keybind)、[Paragraph](/zh/elements/paragraph) 和 [Section](/zh/elements/section)。在[元素概览](/zh/elements/)中浏览全部内容。
:::
