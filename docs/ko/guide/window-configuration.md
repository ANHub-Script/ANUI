# 창 구성

창은 모든 ANUI 메뉴의 뿌리입니다. `ANUI:CreateWindow{}`로 한 번 생성하며, 단일 구성 테이블을 전달합니다. 이 페이지에서는 모든 필드와 반환된 `Window` 객체에서 사용할 수 있는 메서드를 문서화합니다.

::: info 창은 하나만
한 번에 하나의 창만 존재할 수 있습니다. 두 번째 `ANUI:CreateWindow` 호출은 경고를 표시하고 `nil`을 반환합니다.
:::

## 기본 예제

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
    Theme = "Dark",
})
```

## 구성

### 식별 정보

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | — | 창 제목 텍스트입니다. |
| `Author` | `string` | — | 제목 아래에 표시되는 부제입니다. |
| `Icon` | `string` | — | 창 아이콘: Lucide 아이콘 이름 또는 `rbxassetid://…`. |
| `IconSize` | `number` \| `UDim2` | `22` | 아이콘 크기(픽셀)입니다. |
| `IconThemed` | `boolean` | — | 테마의 아이콘 색상으로 아이콘을 물들입니다. |

### 저장소

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Folder` | `string` | — | 디스크 저장 폴더입니다. 이를 설정하면 [구성 시스템](/features/config-and-flags)과 [키 시스템](/features/key-system)의 `SaveKey` 옵션이 활성화됩니다. 구성은 `ANUI/<Folder>/config/<name>.json`에 기록됩니다. |

### 크기 및 스케일링

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Size` | `UDim2` | `580 × 460` (clamped) | 초기 창 크기입니다. |
| `MinSize` | `Vector2` | `850 × 560` | 크기 조정 시 최소 크기입니다. |
| `MaxSize` | `Vector2` | `1050 × 560` | 크기 조정 시 최대 크기입니다. |
| `Resizable` | `boolean` | `true` | 사용자가 창 크기를 조정할 수 있도록 허용합니다. |
| `AutoScale` | `boolean` | `true` | UI를 자동으로 스케일링합니다(모바일 친화적). |

### 외관

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Theme` | `string` | `"Dark"` | 테마 이름 — [테마](/features/themes)를 참고하세요. |
| `Transparent` | `boolean` | `false` | 투명한 창 배경을 사용합니다. |
| `Acrylic` | `boolean` | `false` | 창 뒤에 아크릴 블러를 적용합니다. |
| `Background` | `Color3` \| image id \| `"https://…"` \| `"video:…"` \| gradient table | — | 사용자 지정 창 배경입니다. |
| `BackgroundImageTransparency` | `number` | `0` | 배경 이미지의 투명도입니다. |
| `ShadowTransparency` | `number` | `0.7` | 창 그림자의 투명도입니다. |
| `Radius` | `number` | `16` | 창 모서리 반경입니다. |
| `ElementsRadius` | `number` | — | 요소에 적용되는 모서리 반경입니다. |
| `SideBarWidth` | `number` | `200` | 사이드바 너비(픽셀)입니다. |
| `HidePanelBackground` | `boolean` | `false` | 콘텐츠 패널 배경을 숨깁니다. |
| `ScrollBarEnabled` | `boolean` | `false` | 콘텐츠 스크롤바를 표시합니다. |

### 동작

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `ToggleKey` | `Enum.KeyCode` | — | 창을 표시 / 숨기는 키입니다. |
| `HideSearchBar` | `boolean` | `true` | 요소 검색 바를 숨깁니다. 표시하려면 `false`로 설정하세요. |
| `NewElements` | `boolean` | `false` | 새로운 요소 스타일을 선택합니다. |
| `IgnoreAlerts` | `boolean` | `false` | 내장 알림 팝업을 억제합니다. |

### 하위 구성

이 필드들은 자체 구성 테이블을 받으며 전용 페이지에서 문서화되어 있습니다.

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `OpenButton` | `table` | — | 창을 다시 여는 플로팅 버튼입니다. [열기 버튼](/features/open-button)을 참고하세요. |
| `KeySystem` | `table` | — | 메뉴를 키로 제한합니다. [키 시스템](/features/key-system)을 참고하세요. |
| `User` | `table` | — | 사용자 표시 블록: `{ Enabled, Anonymous, Callback }`. |

## 창 메서드

`Window`를 확보하면 이 메서드들로 런타임에 창을 제어합니다.

### 수명 주기

- `Window:Open()` — 창을 표시합니다.
- `Window:Close()` — 창을 숨깁니다; `:Destroy()`가 있는 객체를 반환합니다.
- `Window:Destroy()` — 창을 영구적으로 제거합니다.
- `Window:Toggle()` — 열림과 닫힘 사이를 전환합니다.
- `Window:OnOpen(fn)` — 창이 열릴 때마다 `fn`을 실행합니다.
- `Window:OnClose(fn)` — 창이 닫힐 때마다 `fn`을 실행합니다.
- `Window:OnDestroy(fn)` — 창이 파괴될 때 `fn`을 실행합니다.

### 외관

- `Window:SetTitle(text)` — 제목을 변경합니다.
- `Window:SetAuthor(text)` — 부제를 변경합니다.
- `Window:SetIconSize(n | UDim2)` — 창 아이콘의 크기를 조정합니다.
- `Window:SetBackgroundImage(id)` — 배경 이미지를 교체합니다.
- `Window:ToggleTransparency(bool)` — 투명 배경을 전환합니다.
- `Window:SetUIScale(v)` — UI 스케일을 설정합니다(`Window:GetUIScale()`로 다시 읽어옵니다).

### 사이드바

- `Window:CollapseSidebar()` — 사이드바를 접습니다.
- `Window:ExpandSidebar()` — 사이드바를 펼칩니다.
- `Window:ToggleSidebar(state?)` — 전환하거나, `state`가 주어지면 해당 상태로 강제합니다.

```lua
task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
```

### 토글 키

- `Window:SetToggleKey(keycode)` — 런타임에 표시 / 숨김 키를 변경합니다.

```lua
Window:SetToggleKey(Enum.KeyCode.G)
```

### 잠금

- `Window:LockAll()` — 창의 모든 요소를 잠급니다.
- `Window:UnlockAll()` — 창의 모든 요소를 잠금 해제합니다.

### 상단바

- `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` — 창의 상단바에 버튼을 추가합니다.
- `Window:DisableTopbarButtons({names})` — 이름으로 특정 상단바 버튼을 비활성화합니다.

### 태그

`Window:Tag(cfg)`는 창에 이름이 붙은 작은 태그를 추가합니다 — 버전 배지를 표시하기에 편리합니다.

```lua
Window:Tag({ Title = "v" .. ANUI.Version, Icon = "github" })
```

### 대화 상자

`Window:Dialog{}`는 모달 대화 상자를 엽니다. [대화 상자 및 팝업](/features/dialogs-and-popups)을 참고하세요.

### 루프

`Window:Loop`, `Window:StatusLoop`, `Window:ManagedLoop`과 그 동반 메서드들은 창이 닫히거나 파괴될 때 자동으로 멈추는 관리되는 루프를 실행합니다. [스케줄러 및 루프](/features/scheduler)를 참고하세요.

## 다음 단계

- [탭 및 섹션](/guide/tabs-and-sections)을 추가하여 메뉴를 정리하세요.
- [테마](/features/themes)로 모든 것을 다시 꾸며 보세요.
