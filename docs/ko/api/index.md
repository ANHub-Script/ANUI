# API 요약표

ANUI 전체 기능을 한 페이지에서 빠르게 확인할 수 있는 참조 문서입니다. 최상위 호출, Window 및 Tab 메서드, 모든 요소와 기능 진입점을 다룹니다. 자세한 내용은 링크를 참조하세요.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## `ANUI` (최상위)

라이브러리 객체 자체에서 제공하는 메서드와 필드입니다.

| 호출 | 용도 |
| --- | --- |
| `ANUI:CreateWindow(config)` → `Window` | 창을 생성합니다. 동시에 하나만 존재할 수 있습니다. |
| `ANUI:Notify(config)` → notification | 토스트 알림을 표시합니다. |
| `ANUI:SetNotificationLower(bool)` | 알림을 화면 아래쪽으로 이동합니다. |
| `ANUI:SetFont(fontId)` | 전역 UI 글꼴을 설정합니다. |
| `ANUI:OnThemeChange(fn)` | 테마가 바뀔 때마다 `fn`을 실행합니다. |
| `ANUI:AddTheme(theme)` → theme | 사용자 테마를 등록합니다. 키는 `.Name`입니다. |
| `ANUI:SetTheme(name)` → theme \| `nil` | 이름으로 테마를 전환합니다. |
| `ANUI:GetThemes()` | 등록된 모든 테마를 반환합니다. |
| `ANUI:GetCurrentTheme()` | 활성 테마를 반환합니다. |
| `ANUI:GetTransparency()` | 현재 투명도 값을 반환합니다. |
| `ANUI:GetWindowSize()` | 현재 창 크기를 반환합니다. |
| `ANUI:Localization(config)` | 번역 설정을 구성합니다. |
| `ANUI:SetLanguage(lang)` | 언어를 전환합니다. 현지화가 활성화되어 있어야 합니다. |
| `ANUI:ToggleAcrylic(bool)` | 아크릴 블러 효과를 켜거나 끕니다. |
| `ANUI:Gradient(stops, props)` → gradient | 그라데이션 데이터 테이블을 만듭니다. 정지점 키는 `"0"`부터 `"100"`까지입니다. |
| `ANUI:Popup(config)` → `Popup` | 모달 팝업을 엽니다. |
| `ANUI:Scheduler(config)` → `Scheduler` | 독립 실행형 루프 스케줄러를 만듭니다. |
| `ANUI.Version` | 라이브러리 버전 문자열입니다. 메서드가 아닌 필드입니다. |

## Window 메서드

`ANUI:CreateWindow`가 반환하는 메서드입니다. 용도별로 묶었으며, 시그니처는 백틱으로 표기합니다.

**탭 및 컨테이너**

| 메서드 | 용도 |
| --- | --- |
| `Window:Tab(config)` | 요소를 담는 탭(사이드바 페이지)을 추가합니다. |
| `Window:Section(config)` | 탭을 묶는 사이드바 섹션을 추가합니다. |
| `Window:SelectTab(index)` | 인덱스로 탭을 전환합니다. |
| `Window:Divider()` | 사이드바에 구분선을 추가합니다. |
| `Window:Tag(config)` | 창에 작은 태그/배지(예: 버전)를 추가합니다. |

**대화 상자**

| Method | Purpose |
| --- | --- |
| `Window:Dialog({ Title, Content, Icon, Width, Buttons })` | 모달 대화 상자를 엽니다. 각 버튼은 `{ Title, Icon, Callback, Variant }`이며 `Width`의 기본값은 `320`입니다. |

**수명 주기 및 콜백**

| Method | Purpose |
| --- | --- |
| `Window:Open()` / `Window:Close()` / `Window:Toggle()` | 창을 표시, 숨김 또는 전환합니다. |
| `Window:Destroy()` | 창을 제거하고 정리합니다. |
| `Window:OnOpen(fn)` / `Window:OnClose(fn)` / `Window:OnDestroy(fn)` | 해당 이벤트에서 `fn`을 실행합니다. |

**모양**

| Method | Purpose |
| --- | --- |
| `Window:SetTitle(t)` / `Window:SetAuthor(t)` | 제목 또는 부제목을 갱신합니다. |
| `Window:SetIconSize(n \| UDim2)` | 상단 표시줄 아이콘 크기를 변경합니다. |
| `Window:SetBackgroundImage(id)` / `Window:SetBackgroundImageTransparency(v)` | 배경 이미지와 투명도를 설정합니다. |
| `Window:SetBackgroundTransparency(v)` / `Window:ToggleTransparency(bool)` | 창 투명도를 조정하거나 전환합니다. |
| `Window:SetToTheCenter()` | 창을 화면 중앙에 다시 배치합니다. |
| `Window:GetUIScale()` / `Window:SetUIScale(v)` | UI 배율을 읽거나 설정합니다. |
| `Window:IsResizable(bool)` | 크기 조절을 활성화하거나 비활성화합니다. |

**사이드바**

| Method | Purpose |
| --- | --- |
| `Window:CollapseSidebar()` / `Window:ExpandSidebar()` / `Window:ToggleSidebar(state?)` | 사이드바를 접기, 펼치기 또는 전환합니다. |

**전환 키**

| Method | Purpose |
| --- | --- |
| `Window:SetToggleKey(keycode)` | 창 표시/숨김 단축키(`Enum.KeyCode`)를 설정합니다. |

**잠금**

| Method | Purpose |
| --- | --- |
| `Window:LockAll()` / `Window:UnlockAll()` | 모든 요소를 잠그거나 잠금 해제합니다. |
| `Window:GetLocked()` / `Window:GetUnlocked()` | 잠긴/잠금 해제된 요소를 나열합니다. |

**상단 표시줄**

| Method | Purpose |
| --- | --- |
| `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` | 사용자 상단 표시줄 버튼을 추가합니다. |
| `Window:DisableTopbarButtons({ names })` | 이름으로 내장 상단 표시줄 버튼을 숨깁니다. |

**열기 버튼**

| Method | Purpose |
| --- | --- |
| `Window:EditOpenButton(config)` | 떠 있는 열기 버튼을 편집합니다. |

**루프 및 스케줄러**

| Method | Purpose |
| --- | --- |
| `Window:Loop(key, interval, fn, opts?)` | `interval`초마다 `fn`을 실행합니다. |
| `Window:StatusLoop(key, interval, fn)` | 상태 텍스트 갱신용 루프입니다. |
| `Window:ManagedLoop(key, interval, predicate, fn)` | `predicate`가 참인 동안만 실행되는 루프입니다. |
| `Window:StopLoop(key)` / `Window:StopAllLoops()` | 하나 또는 모든 루프를 중지합니다. |
| `Window:IsLoopRunning(key)` / `Window:GetActiveLoopCount()` | 루프 상태를 조회합니다. |
| `Window:AddConnection(conn)` / `Window:DisconnectAll()` | 연결을 추적하고 정리합니다. |
| `Window:IsReady()` | 창 초기화 완료 여부를 반환합니다. |

## Tab 메서드

| Method | Purpose |
| --- | --- |
| `Tab:Select()` | 이 탭을 활성 탭으로 만듭니다. |
| `Tab:ScrollToTheElement(index)` | 인덱스의 요소로 스크롤합니다. |
| `Tab:LockAll()` / `Tab:UnlockAll()` | 탭 안의 모든 요소를 잠그거나 해제합니다. |
| `Tab:GetLocked()` / `Tab:GetUnlocked()` | 탭의 잠긴/잠금 해제 요소를 나열합니다. |
| `Tab:ReserveHeader(height, config)` | 탭 상단에 고정 헤더 영역을 확보합니다. |

::: info
Tab은 `Tab:Button{}`, `Tab:Toggle{}`, `Tab:Slider{}` 등의 **모든 요소 생성 메서드**도 제공합니다. `Section`과 `Group` 역시 같은 요소 메서드를 제공하는 컨테이너입니다.
:::

## 요소 빠른 참조

각 요소를 한 행으로 정리했습니다. 콜백 인수는 `Callback` 함수가 받는 값입니다.

| 요소 | 시그니처 | 주요 구성 | 콜백 인수 |
| --- | --- | --- | --- |
| [Button](/ko/elements/button) | `Tab:Button{}` | `Callback`, `Icon` | 없음 |
| [Toggle](/elements/toggle) | `Tab:Toggle{}` | `Value`, `Type` | `boolean` |
| [Slider](/ko/elements/slider) | `Tab:Slider{}` | `Value { Min, Max, Default }`, `Step` | 형식화된 `string` |
| [Dropdown](/ko/elements/dropdown) | `Tab:Dropdown{}` | `Values`, `Multi` | 선택 값 또는 배열 |
| [Input](/ko/elements/input) | `Tab:Input{}` | `Placeholder`, `Type` | `string` |
| [Keybind](/ko/elements/keybind) | `Tab:Keybind{}` | `Value`(키 이름) | 키 이름 `string` |
| [Colorpicker](/ko/elements/colorpicker) | `Tab:Colorpicker{}` | `Default`, `Transparency` | `(Color3, transparency)` |
| [Paragraph](/ko/elements/paragraph) | `Tab:Paragraph{}` | `Title`, `Desc`, `Images` | — |
| [Code](/ko/elements/code) | `Tab:Code{}` | `Code`, `OnCopy` | — |
| [Section](/ko/elements/section) | `Tab:Section{}` | `Title`, `Opened` | — |
| [Divider](/ko/elements/divider) | `Tab:Divider()` | — | — |
| [Space](/ko/elements/space) | `Tab:Space{}` | `Columns` | — |
| [Image](/ko/elements/image) | `Tab:Image{}` | `Image`, `AspectRatio` | — |
| [Group](/ko/elements/group) | `Tab:Group{}` | 컨테이너 | — |
| [Category](/ko/elements/category) | `Tab:Category{}` | `Options`, `Default` | 선택 옵션 이름(`string`) |

## 기능 빠른 참조

| 기능 | 진입 호출 | 문서 |
| --- | --- | --- |
| 알림 | `ANUI:Notify{}` | [알림](/ko/features/notifications) |
| 대화 상자 및 팝업 | `Window:Dialog{}` · `ANUI:Popup{}` | [대화 상자 및 팝업](/ko/features/dialogs-and-popups) |
| 구성 및 플래그 | `Window.ConfigManager` · `Flag = "..."` | [구성 및 플래그](/ko/features/config-and-flags) |
| 키 시스템 | `ANUI:CreateWindow{ KeySystem = {...} }` | [키 시스템](/ko/features/key-system) |
| 테마 | `ANUI:SetTheme(name)` · `ANUI:AddTheme{}` | [테마 및 모양](/ko/features/themes) |
| 현지화 | `ANUI:Localization{}` · `ANUI:SetLanguage(lang)` | [현지화](/ko/features/localization) |
| 스케줄러 및 루프 | `ANUI:Scheduler{}` · `Window:Loop(...)` | [스케줄러 및 루프](/ko/features/scheduler) |
