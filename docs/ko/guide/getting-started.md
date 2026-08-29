# 빠른 시작

몇 단계만으로 첫 ANUI 메뉴를 만들어 보겠습니다.

## 1. ANUI 로드

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## 2. Window 생성

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})
```

`Folder`는 Config와 Key를 디스크에 저장할 때 사용됩니다.

## 3. Tab 추가

```lua
local Main = Window:Tab({ Title = "Main", Icon = "house" })
```

## 4. Element 추가

```lua
Main:Toggle({
    Title = "Auto Farm",
    Desc = "자동으로 코인을 파밍합니다.",
    Callback = function(state)
        print("Auto Farm:", state)
    end,
})

Main:Button({
    Title = "Do something",
    Callback = function()
        print("Button clicked")
    end,
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value)
        print("Walk Speed:", value)
    end,
})
```

`Toggle`의 callback은 `boolean`, `Button`은 인자 없음, `Slider`는 현재 값을 받습니다.

## 5. Notification

```lua
ANUI:Notify({
    Title = "Hello!",
    Content = "ANUI에 오신 것을 환영합니다.",
    Icon = "bell",
    Duration = 3,
})
```

## 전체 예제

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Folder = "MyHub",
})

local Main = Window:Tab({ Title = "Main", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Callback = function(state)
        print("Auto Farm:", state)
    end,
})

Main:Button({
    Title = "Notify",
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

## 다음 단계

- [Window 설정](./window-configuration)
- [Tabs & Sections](./tabs-and-sections)
- [Elements](../elements/)
