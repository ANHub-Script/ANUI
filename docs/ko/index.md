---
layout: home
title: ANUI
titleTemplate: 고급 Roblox UI 라이브러리

hero:
  name: ANUI
  text: 고급 Roblox UI 라이브러리
  tagline: Roblox 스크립트 실행기를 위한 현대적이고 풍부한 기능의 UI 라이브러리입니다. 단 몇 줄의 코드로 아름답고 모바일 친화적인 메뉴를 만드세요.
  image:
    src: /logo.svg
    alt: ANUI 로고
  actions:
    - theme: brand
      text: 시작하기
      link: /ko/guide/introduction
    - theme: alt
      text: 설치
      link: /ko/guide/installation
    - theme: alt
      text: GitHub에서 보기
      link: https://github.com/ANHub-Script/ANUI

features:
  - icon: 🧩
    title: 15개 이상의 요소
    details: 버튼, 토글, 슬라이더, 드롭다운, 색상 선택기, 키 바인드, 입력 필드, 코드 블록 등 완전한 메뉴를 만드는 데 필요한 모든 요소를 제공합니다.
    link: /ko/elements/
    linkText: 요소 둘러보기
  - icon: 🎨
    title: 26개의 기본 제공 테마
    details: Dark, Light, Dracula, Tokyo Night, Nord, Gruvbox 등 20개 이상의 테마를 제공하며, 한 번의 호출로 나만의 팔레트를 등록할 수 있습니다.
    link: /ko/features/themes
    linkText: 테마 가이드
  - icon: 💾
    title: 구성 및 플래그
    details: 플래그 하나로 어떤 요소의 상태든 디스크에 저장하고, 다음 스크립트 실행 시 자동으로 복원합니다.
    link: /ko/features/config-and-flags
    linkText: 구성 및 플래그
  - icon: 🔑
    title: 키 시스템
    details: Luarmor, Platoboost, PandaDevelopment를 기본 지원하는 키로 스크립트를 보호하거나 자체 검증기를 사용할 수 있습니다.
    link: /ko/features/key-system
    linkText: 키 시스템
  - icon: 🔔
    title: 알림 및 대화 상자
    details: 아이콘, 버튼, 진행률 표시줄을 지원하는 풍부한 토스트 알림, 모달 대화 상자, 팝업을 바로 사용할 수 있습니다.
    link: /ko/features/notifications
    linkText: 알림
  - icon: ⏱️
    title: 스마트 스케줄러
    details: 드리프트 없는 루프와 루프별 중복 실행 방지 기능을 제공하며, 창을 닫으면 자동으로 정리됩니다.
    link: /ko/features/scheduler
    linkText: 스케줄러 및 루프
---

## 빠른 미리 보기

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "내 허브",
    Author = "제작자: 나",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})

local Main = Window:Tab({ Title = "메인", Icon = "house" })

Main:Toggle({
    Title = "자동 파밍",
    Desc = "코인을 자동으로 모읍니다",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "알림 표시",
    Callback = function()
        ANUI:Notify({ Title = "안녕하세요!", Content = "ANUI에 오신 것을 환영합니다", Icon = "bell", Duration = 3 })
    end
})
```

완전히 작동하는 메뉴입니다. [빠른 시작](/ko/guide/getting-started)에서 단계별로 만들어 보세요.
