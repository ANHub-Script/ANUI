# 소개

ANUI(Advanced Roblox UI Library)는 Roblox 스크립트 실행 환경을 위한 현대적인 UI 라이브러리입니다. 몇 줄의 Lua 코드만으로 깔끔하고 모바일 친화적인 메뉴를 만들 수 있습니다.

## ANUI란?

ANUI는 Roblox 화면 위에 이동 및 크기 조절이 가능한 창을 만들고, 탭·요소·테마·입력·애니메이션을 관리합니다. 개발자는 `Window:Tab()`과 같은 선언적인 API로 UI 구조를 정의하면 됩니다.

HTTP와 `loadstring`을 사용해 로드하므로 별도의 패키징이나 설치가 필요하지 않습니다.

## 무엇을 만들 수 있나요?

- 기능별 탭과 사이드바를 가진 Hub/Menu
- Config & Flags를 이용한 설정 패널
- Key System으로 보호되는 스크립트
- Profile, Badge, Notification, Dialog를 포함한 대시보드

## 주요 기능

- 15+ UI Elements
- 26개의 내장 Theme 및 Custom Theme
- Config & Flags를 통한 상태 저장
- Key System 및 여러 provider
- Notifications, Dialogs & Popups
- Localization
- Scheduler & managed loops
- 모바일 스케일링 및 Acrylic 효과

::: info 창은 하나만 생성할 수 있습니다
`ANUI:CreateWindow()`는 한 번만 사용할 수 있습니다. 두 번째 호출은 경고 후 `nil`을 반환합니다.
:::

## 요구 사항

실행 환경에서 다음 기능을 지원해야 합니다.

- `loadstring`
- `game:HttpGet`
- Config/Key 저장 시 `readfile`, `writefile`, `isfile`, `makefolder`

## 다음 단계

- [설치](./installation)
- [빠른 시작](./getting-started)
- [Window 설정](./window-configuration)
- [Tabs & Sections](./tabs-and-sections)
