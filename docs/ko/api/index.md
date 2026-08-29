# API 치트시트

ANUI 전체 API를 빠르게 확인할 수 있는 요약입니다. API 이름은 실제 Lua identifier이므로 영어로 유지합니다.

## ANUI

| API | 설명 |
| --- | --- |
| `ANUI:CreateWindow(config)` | Window 생성 |
| `ANUI:Notify(config)` | Toast 알림 |
| `ANUI:SetNotificationLower(bool)` | 알림 위치 변경 |
| `ANUI:SetFont(fontId)` | 전역 Font 변경 |
| `ANUI:AddTheme(theme)` | Custom Theme 등록 |
| `ANUI:SetTheme(name)` | Theme 변경 |
| `ANUI:GetThemes()` | 등록된 Theme 목록 |
| `ANUI:GetCurrentTheme()` | 현재 Theme |
| `ANUI:GetWindowSize()` | Window 크기 |
| `ANUI:Localization(config)` | 다국어 설정 |
| `ANUI:SetLanguage(lang)` | 언어 변경 |
| `ANUI:ToggleAcrylic(bool)` | Acrylic 효과 변경 |
| `ANUI:Gradient(stops, props)` | Gradient 데이터 생성 |
| `ANUI:Popup(config)` | 독립형 Popup |
| `ANUI:Scheduler(config)` | Standalone Scheduler |
| `ANUI.Version` | 라이브러리 버전 |

## Window

| API | 설명 |
| --- | --- |
| `Window:Tab(config)` | Tab 추가 |
| `Window:Section(config)` | Sidebar Section 추가 |
| `Window:SelectTab(index)` | Tab 선택 |
| `Window:Dialog(config)` | Dialog 표시 |
| `Window:Open()` / `Close()` / `Toggle()` | Window 상태 제어 |
| `Window:Destroy()` | Window 제거 |
| `Window:SetTitle(text)` | 제목 변경 |
| `Window:SetAuthor(text)` | 부제목 변경 |
| `Window:SetUIScale(value)` | UI scale 변경 |
| `Window:CollapseSidebar()` | Sidebar 접기 |
| `Window:ExpandSidebar()` | Sidebar 펼치기 |
| `Window:SetToggleKey(keycode)` | Toggle key 변경 |
| `Window:LockAll()` / `UnlockAll()` | 모든 Element 잠금/해제 |
| `Window:Loop(...)` | Window 관리 Loop |
| `Window:StatusLoop(...)` | 상태 갱신 Loop |
| `Window:StopLoop(key)` | Loop 정지 |

## Tab / Element

모든 Tab은 다음 Element 생성 메서드를 제공합니다.

```lua
Tab:Button({})
Tab:Toggle({})
Tab:Slider({})
Tab:Dropdown({})
Tab:Input({})
Tab:Keybind({})
Tab:Colorpicker({})
Tab:Paragraph({})
Tab:Code({})
Tab:Section({})
Tab:Divider()
Tab:Space({})
Tab:Image({})
Tab:Group({})
Tab:Category({})
```

자세한 Element 옵션은 [Elements](../elements/)에서 확인할 수 있습니다.

## 관련 기능

- [Config & Flags](../features/config-and-flags)
- [Key System](../features/key-system)
- [Themes](../features/themes)
- [Localization](../features/localization)
- [Scheduler](../features/scheduler)
