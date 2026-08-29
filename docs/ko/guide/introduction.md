# 소개

ANUI(Advanced Roblox UI Library)는 Roblox 스크립트 실행기를 위한 현대적이고 기능이 풍부한 UI 라이브러리입니다. 단 몇 줄의 Lua로 깔끔하고 모바일에 대응하는 메뉴 — 창, 탭, 토글, 슬라이더, 드롭다운 등 — 를 만들 수 있습니다.

## ANUI란?

ANUI는 어떤 Roblox 경험 위에도 떠 있는, 드래그와 크기 조정이 가능한 창을 렌더링합니다. 메뉴를 선언적으로 기술하면 — 창을 생성하고, 탭을 추가하고, 그 안에 요소를 넣으면 — ANUI가 레이아웃, 테마, 입력, 애니메이션, 지속성을 알아서 처리합니다.

단 하나의 `loadstring`으로 HTTP를 통해 로드되므로 설치하거나 번들링할 것이 없습니다: 한 줄만 붙여넣으면 메뉴가 바로 실행됩니다.

## 만들 수 있는 것

- 정리된 탭과 사이드바 섹션을 갖춘 기능 허브와 치트 메뉴
- [구성 및 플래그](/features/config-and-flags)를 통해 세션 간 상태가 유지되는 설정 패널
- 내장 [키 시스템](/features/key-system)을 사용하는 키 제한 스크립트
- 프로필, 배지, 알림, 대화 상자를 갖춘 풍부한 대시보드

## 기능 하이라이트

- 15개 이상의 [요소](/elements/) — 버튼, 토글, 슬라이더, 드롭다운, 컬러 피커, 키바인드, 입력, 코드 블록 등
- [26개의 내장 테마](/features/themes)와 직접 만든 사용자 지정 팔레트
- 어떤 요소의 상태든 디스크에 유지하는 [구성 및 플래그](/features/config-and-flags)
- Luarmor, Platoboost, PandaDevelopment 공급자를 갖춘 [키 시스템](/features/key-system)
- [알림](/features/notifications)과 [대화 상자 및 팝업](/features/dialogs-and-popups)
- 다국어 메뉴를 위한 [현지화](/features/localization)
- 관리되는 루프를 위한 드리프트 없는 [스케줄러](/features/scheduler)
- [모바일 대응 스케일링과 아크릴 블러](/guide/window-configuration)

## 요구 사항

ANUI는 Roblox 스크립트 실행기 안에서 실행됩니다. 실행기는 다음을 지원해야 합니다:

- `loadstring`과 `game:HttpGet` — 라이브러리를 로드하는 데 필요합니다
- `readfile`, `writefile`, `isfile`, `makefolder` — 구성과 키를 저장할 때만 필요합니다

::: info 창은 하나만
한 번에 하나의 창만 존재할 수 있습니다. `ANUI:CreateWindow`를 두 번째로 호출하면 경고를 표시하고 `nil`을 반환합니다.
:::

## 크레딧

- **WindUI by Footagesus** 기반
- 아이콘 제공: [Lucide](https://lucide.dev)
- Dawid-Scripts에게 감사드립니다

## 링크

- GitHub: [github.com/ANHub-Script/ANUI](https://github.com/ANHub-Script/ANUI)
- Discord: [https://discord.gg/qN47S3mKZA](https://discord.gg/qN47S3mKZA)
- YouTube: [@ANHubRoblox](https://www.youtube.com/@ANHubRoblox)

---

다음: [설치](/guide/installation)
