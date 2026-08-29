# ANUI

## 더 나은 Roblox UI를 만들어 보세요.

**ANUI는 깔끔한 메뉴, 빠른 설정, 유연한 커스터마이징을 목표로 하는 현대적인 Roblox UI 라이브러리입니다.**

## 왜 ANUI인가요?

ANUI는 UI를 처음부터 직접 구성하는 데 시간을 쓰기보다 **스크립트의 기능 자체에 집중하고 싶은 개발자**를 위해 만들어졌습니다.

- **현대적인 인터페이스** — 창, 탭, 대화 상자, 알림, 아크릴 효과 및 반응형 레이아웃
- **빠른 통합** — 라이브러리를 로드한 뒤 바로 메뉴를 만들 수 있습니다.
- **풍부한 UI 요소** — Button, Toggle, Slider, Dropdown, Input, Keybind, Colorpicker 등
- **높은 커스터마이징** — 다양한 내장 테마, 커스텀 테마, 그라디언트, 아이콘, 이미지 및 스케일링
- **상태 관리** — Flags와 Config Manager를 통한 UI 상태 저장 및 불러오기
- **개발자 도구** — Localization, Scheduler, Loop, Key System, Popup, Notification

> **ANUI의 목표는 간단합니다: UI를 스크립트에서 가장 쉬운 부분으로 만드는 것.**

## 빠른 시작

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Theme = "Dark",
})

local Main = Window:Tab({
    Title = "Main",
    Icon = "house",
})

Main:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(state)
        print("Auto Farm:", state)
    end,
})
```

안정적인 프로젝트에서는 `main` 대신 **release tag를 고정해서 사용하는 것을 권장합니다.**

## 주요 기능

| 영역 | 지원 기능 |
| --- | --- |
| UI | Window, Tab, Section, Group, Category 및 반응형 레이아웃 |
| Elements | Button, Toggle, Slider, Dropdown, Input, Keybind, Colorpicker, Paragraph, Code, Image 등 |
| Appearance | 내장 테마, 커스텀 테마, Gradient, Icon, Acrylic, Transparency, Background |
| State | Flags, Config Manager, Save/Load |
| Interaction | Notification, Dialog, Popup, Open Button, Locking |
| Developer Tools | Localization, Scheduler, Loop, Key System |

## 문서

- [시작하기](./guide/introduction)
- [설치](./guide/installation)
- [빠른 시작](./guide/getting-started)
- [Window 설정](./guide/window-configuration)
- [Tabs & Sections](./guide/tabs-and-sections)
- [Elements](./elements/)
- [Features](./features/notifications)
- [API Reference](./api/)

## 언어

한국어 문서는 영어 API 이름을 그대로 유지합니다. 예를 들어 `CreateWindow()`, `Button`, `Toggle`, `Slider` 등은 코드에서 사용하는 실제 identifier이므로 번역하지 않습니다.

**[ANUI GitHub](https://github.com/ANHub-Script/ANUI)** · **[Releases](https://github.com/ANHub-Script/ANUI/releases)**
