# Section

탭 안에 배치하는 접을 수 있는 컨테이너입니다. Tab처럼 Section도 모든 요소 생성 메서드를 제공하므로, 자식 요소를 추가하면 펼치고 접을 수 있는 헤더 아래에 묶여 표시됩니다.

::: info 서로 다른 두 "Section" 개념
이 페이지는 탭 *안에* 배치하는 접이식 컨테이너인 **콘텐츠 요소** `Tab:Section({...})`를 설명합니다.

이는 탭을 묶는 **사이드바 섹션 헤더**를 만드는 `Window:Section({ Title = ... })`와 관련이 없습니다. 후자는 [탭 및 섹션](/ko/guide/tabs-and-sections)을 참조하세요.
:::

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local combat = myTab:Section({ Title = "Combat" })

combat:Toggle({ Title = "God Mode", Callback = function(state) end })
combat:Button({ Title = "Kill Aura", Callback = function() end })
```

::: tip
Section은 자식 요소가 하나 이상 있어야 접을 수 있습니다. 비어 있는 Section에는 접을 콘텐츠가 없습니다.
:::

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Section"` | 헤더 레이블입니다. 인라인 `{icon}`을 포함한 리치 텍스트 토큰을 지원합니다. |
| `Icon` | `string` | `nil` | Lucide 이름 또는 `rbxassetid://…` 헤더 아이콘입니다. |
| `Image` | `string` | `nil` | `Icon` 대신 쓸 헤더 이미지 에셋입니다. |
| `IconSize` | `number` | `20` | 헤더 아이콘 크기(픽셀)입니다. |
| `IconThemed` | `boolean` | `false` | 현재 테마 색상으로 아이콘에 색을 입힙니다. |
| `InlineIcon` | `boolean` | `true` | 제목 텍스트와 같은 줄에 아이콘을 표시합니다. |
| `TextSize` | `number` | `19` | 헤더 제목 텍스트 크기입니다. |
| `TextXAlignment` | `string` | `"Left"` | 헤더 제목의 가로 정렬입니다. |
| `TextTransparency` | `number` | `0.05` | 헤더 제목 텍스트 투명도입니다. |
| `FontWeight` | `Enum.FontWeight` \| `string` | `SemiBold` | 헤더 제목의 글꼴 굵기입니다. |
| `Box` | `boolean` | `false` | 테두리 상자로 Section을 감쌉니다. |
| `Opened` | `boolean` | `false` | 접힌 상태가 아닌 펼친 상태로 시작합니다. |
| `HeaderSize` | `number` | `42` | 헤더 행 높이(픽셀)입니다. |
| `HeaderPadding` | `number` | `8` | 헤더 행 안쪽 여백입니다. |
| `ChevronSize` | `number` | `20` | 펼치기/접기 셰브론 크기입니다. |

## Methods

Every element-creation method (`Section:Button`, `Section:Toggle`, `Section:Slider`, …) is available on a Section, exactly like on a Tab — see the [Elements overview](/elements/). The Section-specific methods are below.

### `Section:SetTitle(text)`

Updates the header label.

```lua
combat:SetTitle("Combat (active)")
```

### `Section:SetIcon(icon)`

Sets the header icon (Lucide name or `rbxassetid://…`).

```lua
combat:SetIcon("swords")
```

### `Section:SetIconSize(size)`

Sets the header icon size, in pixels.

```lua
combat:SetIconSize(24)
```

### `Section:GetIcon()`

Returns the current header icon.

```lua
print(combat:GetIcon())
```

### `Section:Open()` / `Section:Close()`

Expands or collapses the section.

```lua
combat:Open()
combat:Close()
```

### `Section:Destroy()`

Removes the section and its child elements.

```lua
combat:Destroy()
```

## Examples

### Icon, token title, and open by default

```lua
local stats = myTab:Section({
    Title = "{swords} Combat Stats",
    Icon = "swords",
    Opened = true,
})

stats:Slider({ Title = "Damage", Value = { Min = 0, Max = 100, Default = 50 } })
stats:Toggle({ Title = "Auto Attack", Callback = function(state) end })
```

### Expand and collapse from code

```lua
local advanced = myTab:Section({ Title = "Advanced" })
advanced:Toggle({ Title = "Verbose Logging" })

advanced:Open()  -- expand
advanced:Close() -- collapse
```

::: info
Because a Section is a container, it inherits none of the interactive shared-base behaviors (locking, highlighting, and so on) — those belong to the elements you place *inside* it.
:::
