# 기본 메뉴 예제

가장 자주 사용하는 Window, Tab, Toggle, Slider, Dropdown, Button, Keybind를 한 번에 구성하는 예제입니다.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Folder = "MyHub",
})

local Main = Window:Tab({ Title = "Main", Icon = "house" })

Main:Paragraph({
    Title = "Welcome",
    Desc = "ANUI 기본 메뉴 예제입니다.",
})

Main:Toggle({
    Title = "Auto Farm",
    Callback = function(state)
        print("Auto Farm:", state)
    end,
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value)
        print("Walk Speed:", value)
    end,
})

Main:Dropdown({
    Title = "Weapon",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value)
        print("Weapon:", value)
    end,
})

Main:Button({
    Title = "Notify",
    Icon = "bell",
    Callback = function()
        ANUI:Notify({
            Title = "Hello!",
            Content = "Welcome to ANUI",
            Icon = "bell",
            Duration = 3,
        })
    end,
})
```

더 많은 조합은 [Elements](../elements/)와 [API](../api/)를 참고하세요.
