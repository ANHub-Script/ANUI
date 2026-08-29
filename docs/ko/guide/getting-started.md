# 빠른 시작

첫 번째 ANUI 메뉴를 단계별로 만들어 봅니다. 이 과정을 마치면 토글, 버튼, 슬라이더를 담은 탭과 알림을 포함한 창이 완성됩니다 — 완전하게 동작하는 스크립트입니다.

## 1. ANUI 불러오기

모든 스크립트는 라이브러리를 `ANUI`라는 로컬 변수에 불러오는 것으로 시작합니다.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## 2. 창 생성

`ANUI:CreateWindow`는 다른 모든 것을 추가할 `Window` 객체를 반환합니다. `Folder`는 구성과 키가 디스크에 저장되는 위치입니다.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})
```

모든 옵션은 [창 구성](/guide/window-configuration)을 참고하세요.

## 3. 탭 추가

탭은 요소를 담습니다. `Window:Tab`으로 하나를 생성합니다.

```lua
local Main = Window:Tab({ Title = "Main", Icon = "house" })
```

## 4. 요소 추가

탭의 메서드를 호출하여 요소를 추가합니다. 각 콜백이 받는 인수에 유의하세요:

- **Toggle** — 콜백은 `boolean`(새로운 켜짐/꺼짐 상태)을 받습니다.
- **Button** — 콜백은 **인수를 받지 않습니다**.
- **Slider** — 콜백은 **형식화된 문자열**(단계에 따라 형식화된 값)을 받습니다.

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
    Callback = function() -- no arguments
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: formatted string
        print("Walk Speed:", value)
    end
})
```

## 5. 알림 표시

`ANUI:Notify`는 토스트를 띄웁니다. 아이콘 필드는 `Icon`이고, 본문 텍스트 필드는 `Content`입니다.

```lua
ANUI:Notify({
    Title = "Hello!",
    Content = "Welcome to ANUI",
    Icon = "bell",
    Duration = 3,
})
```

## 전체 스크립트

모두 합치면:

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

## 다음 단계

- [창 구성](/guide/window-configuration)에서 창을 완전하게 구성해 보세요.
- [요소 개요](/elements/)에서 모든 요소를 살펴보세요.
