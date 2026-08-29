# 기본 메뉴

복사하고 붙여넣어 바로 실행할 수 있는, 주석이 풍부하게 달린 완전한 시작용 메뉴입니다. 탭 두 개, 가장 일반적인 요소들의 조합, 그룹화 섹션, 그리고 버튼에서 발생하는 알림이 포함된 창을 만듭니다.

## 스크립트

```lua
-- 1. Load ANUI into a local called `ANUI`.
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

-- 2. Create the window. Only ONE window may exist.
local Window = ANUI:CreateWindow({
    Title = "My Hub",                      -- title shown in the top bar
    Author = "by you",                     -- subtitle under the title
    Icon = "rbxassetid://84366761557806",  -- top-bar icon (asset id or Lucide icon name)
    Folder = "MyHub",                      -- disk folder for configs/keys (stored under ANUI/MyHub)
    OpenButton = {                         -- floating button that reopens the window when closed
        Title = "My Hub",
        Enabled = true,
        Draggable = true,
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
    },
})

-- 3. Add tabs. Each tab holds elements and appears in the sidebar.
local Main = Window:Tab({ Title = "Main", Icon = "house" })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

-- 4. A Paragraph is a rich-text block — great as an intro at the top of a tab.
Main:Paragraph({
    Title = "Welcome",
    Desc = "This starter menu shows the most common ANUI elements.",
})

-- Toggle — the callback receives a BOOLEAN (the new on/off state).
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Value = false,
    Callback = function(state) -- state: boolean
        print("Auto Farm:", state)
    end,
})

-- Slider — the callback receives a FORMATTED STRING (the value, formatted to its step).
Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: formatted string
        print("Walk Speed:", value)
    end,
})

-- 5. A Section groups related elements under a collapsible header.
--    It is a container, so you create elements on the section itself.
local combat = Main:Section({ Title = "Combat" })

-- Dropdown — a single-select callback receives the selected value (a string here).
combat:Dropdown({
    Title = "Weapon",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value) -- value: the selected item
        print("Weapon:", value)
    end,
})

-- Keybind — the callback receives the KEY NAME as a string (e.g. "G").
combat:Keybind({
    Title = "Attack Key",
    Value = "G",
    Callback = function(key) -- key: key-name string
        print("Attack bound to:", key)
    end,
})

-- 6. A Button runs a callback with NO ARGUMENTS. Here it fires a notification.
Settings:Button({
    Title = "Say Hello",
    Icon = "bell",
    Callback = function() -- no arguments
        ANUI:Notify({
            Title = "Hello!",
            Content = "Welcome to ANUI",
            Icon = "bell",
            Duration = 3,
        })
    end,
})
```

## 각 부분의 역할

- **로드 줄** — 라이브러리를 가져와 `ANUI`에 할당합니다. 모든 예제는 이렇게 시작합니다.
- **`ANUI:CreateWindow`** — 여러분이 구축할 `Window`를 반환합니다. `Folder`는 설정과 키가 디스크에 저장되는 위치이며, `OpenButton`은 창을 다시 열 수 있는 드래그 가능한 플로팅 버튼을 추가합니다. [창 구성](/guide/window-configuration)을 참고하세요.
- **`Window:Tab`** — 각 탭은 사이드바의 한 페이지이자 요소를 담는 컨테이너입니다.
- **요소** — 컨테이너(Tab 또는 Section)의 메서드를 호출하여 생성합니다. 나중에 요소를 업데이트하려면 반환된 값을 보관하세요.
- **`Main:Section`** — Tab과 동일한 요소 메서드를 제공하는 접을 수 있는 컨테이너로, 관련 컨트롤을 그룹화할 수 있습니다.
- **`ANUI:Notify`** — 토스트를 띄웁니다. 본문 텍스트 필드는 `Content`(`Desc`가 아님)이며, 아이콘 필드는 `Icon`입니다.

::: tip 각 요소 알아보기
모든 요소에는 전체 구성 테이블과 메서드가 담긴 전용 페이지가 있습니다: [Toggle](/elements/toggle), [Slider](/elements/slider), [Dropdown](/elements/dropdown), [Button](/elements/button), [Keybind](/elements/keybind), [Paragraph](/elements/paragraph), [Section](/elements/section). [요소 개요](/elements/)에서 전체를 둘러볼 수 있습니다.
:::
