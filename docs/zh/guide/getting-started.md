# 快速上手

一步一步构建你的第一个 ANUI 菜单。完成后，你将得到一个窗口，里面有一个包含 toggle、button 和 slider 的标签页，还会弹出一条通知 —— 一个完整可用的脚本。

## 1. 加载 ANUI

每个脚本都从把库加载到名为 `ANUI` 的 local 变量开始。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## 2. 创建窗口

`ANUI:CreateWindow` 返回一个 `Window` 对象，其他所有东西都添加到它上面。`Folder` 是配置和密钥在磁盘上的存放位置。

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})
```

所有可用选项请参见[窗口配置](/zh/guide/window-configuration)。

## 3. 添加标签页

标签页用来承载你的元素。用 `Window:Tab` 创建一个。

```lua
local Main = Window:Tab({ Title = "Main", Icon = "house" })
```

## 4. 添加元素

在标签页上调用方法即可添加元素。注意每个回调接收的参数：

- **Toggle** —— 回调接收一个 `boolean`（新的开/关状态）。
- **Button** —— 回调**不接收任何参数**。
- **Slider** —— 回调接收一个**格式化后的字符串**（按其步进格式化后的数值）。

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
    Callback = function() -- 无参数
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: 格式化后的字符串
        print("Walk Speed:", value)
    end
})
```

## 5. 显示通知

`ANUI:Notify` 会弹出一条 toast。图标字段是 `Icon`；正文文本字段是 `Content`。

```lua
ANUI:Notify({
    Title = "Hello!",
    Content = "Welcome to ANUI",
    Icon = "bell",
    Duration = 3,
})
```

## 完整脚本

把所有部分组合起来：

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

## 后续步骤

- 在[窗口配置](/zh/guide/window-configuration)中完整配置窗口。
- 在[元素概览](/zh/elements/)中浏览每一个元素。
