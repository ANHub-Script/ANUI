# 요소

요소는 버튼, 토글, 슬라이더, 드롭다운 등 창 안에서 사용하는 대화형 컨트롤입니다. 요소는 항상 **컨테이너**(Tab, Section 또는 Group)에서 생성합니다.

## 요소 만들기

모든 요소는 컨테이너의 메서드를 호출하여 만듭니다. 가장 흔히 쓰는 컨테이너는 Tab입니다.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "My Hub", Folder = "MyHub" })

-- 1. 컨테이너(Tab)를 만듭니다
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

-- 2. 컨테이너에 요소를 만듭니다
myTab:Button({ Title = "Click me", Callback = function() end })
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
```

`Section`과 `Group`도 컨테이너입니다. Tab과 **동일한** 요소 생성 메서드를 제공하므로, 요소를 중첩하여 레이아웃을 정리할 수 있습니다.

```lua
local section = myTab:Section({ Title = "Combat" })
section:Toggle({ Title = "God Mode", Callback = function(state) end })

local row = myTab:Group({})       -- 자식 요소를 가로로 배치합니다
row:Button({ Title = "Save" })
row:Button({ Title = "Load" })
```

::: tip
각 요소 생성 메서드는 메서드를 호출할 수 있는 모듈을 반환합니다(예: `local t = myTab:Toggle({...})` 다음 `t:Set(true)`). 나중에 요소를 갱신할 계획이라면 반환값을 보관하세요.
:::

## 공통 기반

대부분의 대화형 요소는 공통 기반으로 만들어져 같은 구성 필드와 메서드를 공유합니다. 한 번 익혀 두면 모든 요소에 적용할 수 있습니다.

### 공통 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | 요소 이름 | 주 레이블입니다. [리치 텍스트 토큰](#title-desc의-리치-텍스트)을 지원합니다. |
| `Desc` | `string` | `nil` | 보조 설명 줄입니다. 리치 텍스트 토큰, `\n`, `\t`를 지원합니다. |
| `Icon` | `string` | 요소별 | 아이콘 이름(Lucide) 또는 `rbxassetid://…`입니다. |
| `Image` | `string` \| `table` | `nil` | 왼쪽 정렬 이미지(에셋 ID 또는 카드 테이블)입니다. |
| `ImageSize` | `number` | `30` | 왼쪽 이미지 크기(픽셀)입니다. |
| `Thumbnail` | `string` | `nil` | 큰 미리보기 이미지입니다. |
| `ThumbnailSize` | `number` | `80` | 미리보기 크기(픽셀)입니다. |
| `IconThemed` | `boolean` | `false` | 현재 테마 색상으로 아이콘에 색을 입힙니다. |
| `Color` | `Color3` \| `string` | `nil` | 색상 배경(테마 이름 또는 `Color3`)입니다. 텍스트 대비는 자동으로 조정됩니다. |
| `Justify` | `string` | `"Between"` | 요소 행 안의 콘텐츠 정렬입니다. |
| `Locked` | `boolean` | `false` | 잠금 오버레이를 표시하고 상호작용을 막습니다. |
| `Buttons` | `table` | `nil` | 요소 행에 표시되는 인라인 버튼입니다. |
| `TitleGradient` | `table` | `nil` | 제목 텍스트에 적용하는 그라데이션입니다. |
| `DescGradient` | `table` | `nil` | 설명 텍스트에 적용하는 그라데이션입니다. |

### 공통 메서드

다음 메서드는 대부분의 대화형 요소에서 사용할 수 있습니다.

- `:SetTitle(text)` — 제목을 갱신합니다.
- `:SetDesc(text)` — 설명을 갱신합니다.
- `:SetIcon(icon)` / `:SetImage(image)` — 아이콘 또는 이미지를 갱신합니다.
- `:Lock(text?)` — 요소를 잠급니다. 선택적으로 오버레이 텍스트를 지정할 수 있습니다.
- `:Unlock()` — 요소 잠금을 해제합니다.
- `:Highlight()` — 시선을 끌도록 요소를 잠시 강조합니다.
- `:Destroy()` — 요소를 제거합니다.
- `:SetButtons(buttons)` / `:GetButton(key)` / `:GetButtons()` — 인라인 버튼을 관리합니다.

::: info
개별 요소는 공통 기반에 고유 메서드를 추가합니다. 예를 들어 `Toggle:Set(...)`, `Slider:SetMax(...)`, `Dropdown:Refresh(...)`가 있습니다. 전체 목록은 각 요소 페이지를 참조하세요.
:::

## Title 및 Desc의 리치 텍스트

`Title`과 `Desc`는 아이콘, 이미지, 그라데이션, 버튼까지 텍스트에 직접 넣을 수 있는 인라인 토큰을 지원합니다.

- **인라인 아이콘** — `{icon}` 또는 `{name}` 형식이며, `{icon:star size=28}`처럼 크기를 지정할 수 있습니다.
- **인라인 이미지** — 문자열 안에 `rbxassetid://…` 참조를 바로 넣습니다.
- **그라데이션** — 텍스트를 `<gradient>…</gradient>`로 감싸거나 `<gradient=#40c9ff,#e81cff|45>…</gradient>`처럼 색상과 회전값을 지정합니다.
- **인라인 버튼** — `<button=key>Label</button>` 또는 축약형 `{button:key}`를 사용합니다. 요소의 `Buttons` 맵 항목에 연결됩니다.

`Desc`는 다음도 추가로 지원합니다.

- `\n` — 여러 줄 설명입니다.
- `\t` — 왼쪽 레이블과 오른쪽 값으로 이루어진 두 열 행입니다.

```lua
myTab:Button({
    Title = "Status: <gradient=#30FF6A,#e7ff2f>Online</gradient> {check}",
    Desc = "Ping\t24ms\nRegion\tSEA",
})
```

## Flag를 사용한 구성 저장

상태를 갖는 요소인 **Toggle**, **Slider**, **Dropdown**, **Input**, **Keybind**, **Colorpicker**는 `Flag` 필드를 지원합니다. 플래그가 지정된 요소는 활성 구성에 자동 등록되어 세션 간 값을 저장하고 복원합니다.

```lua
myTab:Toggle({ Title = "Auto Farm", Flag = "AutoFarm", Callback = function(state) end })
```

전체 작업 흐름은 [구성 및 플래그](/ko/features/config-and-flags)를 참조하세요.

## 모든 요소

| 요소 | 설명 |
| --- | --- |
| [Button](/ko/elements/button) | 선택 아이콘과 인라인 버튼을 포함할 수 있는 클릭 가능한 작업 행입니다. |
| [Toggle](/ko/elements/toggle) | boolean을 전달하는 켜기/끄기 스위치 또는 확인란입니다. |
| [Slider](/ko/elements/slider) | 단계 설정과 직접 입력을 지원하는 드래그형 숫자 슬라이더입니다. |
| [Dropdown](/ko/elements/dropdown) | 단일 또는 다중 선택 목록이며 작업 메뉴로도 사용할 수 있습니다. |
| [Input](/ko/elements/input) | 한 줄 또는 여러 줄 텍스트 필드입니다. |
| [Keybind](/ko/elements/keybind) | 동작을 키에 연결하며 키를 누르면 전역적으로 실행됩니다. |
| [Colorpicker](/ko/elements/colorpicker) | 대화 상자에서 색상과 선택적 투명도를 고릅니다. |
| [Paragraph](/ko/elements/paragraph) | 선택적 이미지 카드와 세로 버튼을 포함할 수 있는 리치 텍스트 블록입니다. |
| [Code](/ko/elements/code) | 복사할 수 있는 코드 조각 블록입니다. |
| [Section](/ko/elements/section) | 헤더 아래에 자식 요소를 묶는 접을 수 있는 컨테이너입니다. |
| [Divider](/ko/elements/divider) | 가로 구분선이며 Group 안에서는 세로 구분선이 됩니다. |
| [Space](/ko/elements/space) | 세로 여백을 만드는 보이지 않는 공간입니다. |
| [Image](/ko/elements/image) | 가로세로 비율과 크기 조절을 지원하는 독립 이미지입니다. |
| [Group](/ko/elements/group) | 자식 요소를 가로로 배치하는 컨테이너입니다. |
| [Category](/ko/elements/category) | 요소 그룹을 전환하는 가로 옵션 막대입니다. |
