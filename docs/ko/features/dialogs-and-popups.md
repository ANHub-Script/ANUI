# Dialogs & Popups

ANUI에는 모달 프롬프트를 표시하는 두 가지 방법이 있습니다: 기존 윈도우에 부착되는 **`Window:Dialog{}`**와, 어디서든 열 수 있는 독립형 모달인 **`ANUI:Popup{}`**입니다. 둘 다 제목, 본문, 그리고 버튼 열을 표시합니다.

## Dialog vs Popup

| | `Window:Dialog{}` | `ANUI:Popup{}` |
| --- | --- | --- |
| 부착 | 기존 윈도우 내부에 렌더링됨 | 독립형, 화면 수준 모달 |
| 윈도우 필요 여부 | 예 — `Window`에서 호출 | 아니요 — `ANUI`에서 직접 호출 |
| 너비 조절 | `Width` (기본값 `320`) | — |
| 썸네일 이미지 | — | `Thumbnail` |
| 반환된 객체 | — | 메서드 없음; 버튼이 닫음 |
| 적합한 용도 | 이미 만든 메뉴와 연결된 확인 | 완전한 윈도우 전 또는 없이 하는 빠른 프롬프트 |

## `Window:Dialog{}`

윈도우에 고정된 모달 대화 상자를 엽니다. 메뉴 내부의 확인 및 작은 선택에 사용하세요.

### 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | — | 대화 상자 제목입니다. |
| `Content` | `string` | — | 제목 아래의 본문 텍스트입니다. |
| `Icon` | `string` | — | 선행 아이콘: Lucide 아이콘 이름 또는 `rbxassetid://…`입니다. |
| `Width` | `number` | `320` | 대화 상자 너비(픽셀)입니다. |
| `Buttons` | `table` | — | 버튼 사양의 배열입니다(아래 참조). |

`Buttons`의 각 항목은 테이블입니다:

| 필드 | 형식 | 설명 |
| --- | --- | --- |
| `Title` | `string` | 버튼 레이블입니다. |
| `Icon` | `string` | 버튼의 선택적 아이콘입니다. |
| `Callback` | `function` | 버튼을 클릭할 때 실행됩니다. **인수를 받지 않습니다.** |
| `Variant` | `string` | 시각적 스타일: `"Primary"`, `"Secondary"`, 또는 `"White"`입니다. |

```lua
Window:Dialog({
    Title = "Delete save?",
    Content = "This cannot be undone.",
    Buttons = {
        { Title = "Delete", Variant = "Primary", Icon = "trash", Callback = function()
            print("deleted")
        end },
    },
})
```

## `ANUI:Popup{}`

윈도우 없이 독립형 모달을 즉시 엽니다. 버튼을 클릭하면 팝업이 닫히며, 반환된 객체는 메서드를 노출하지 않습니다.

### 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dialog"` | 팝업 제목입니다. |
| `Content` | `string` | `nil` | 제목 아래의 본문 텍스트입니다. |
| `Icon` | `string` | `nil` | 선행 아이콘: Lucide 아이콘 이름 또는 `rbxassetid://…`입니다. |
| `IconThemed` | `boolean` | — | 테마의 아이콘 색상으로 아이콘을 물들입니다. |
| `Thumbnail` | `table` | — | 큰 미리보기 이미지: `{ Image, Title? }`입니다. |
| `Buttons` | `table` | — | 버튼 사양의 배열입니다(Dialog와 동일한 형태). |

`Buttons`의 각 항목은 테이블입니다:

| 필드 | 형식 | 설명 |
| --- | --- | --- |
| `Title` | `string` | 버튼 레이블입니다. |
| `Icon` | `string` | 버튼의 선택적 아이콘입니다. |
| `Callback` | `function` | 클릭할 때 실행된 후 팝업이 닫힙니다. **인수를 받지 않습니다.** |
| `Variant` | `string` | 시각적 스타일: `"Primary"`, `"Secondary"`, 또는 `"White"`입니다. |

::: info 팝업은 즉시 열립니다
`ANUI:Popup{}`는 호출되는 즉시 모달을 표시합니다. `:Open()`할 것이 없으며 — 버튼이 대신 닫아 주므로 반환된 객체에도 메서드가 없습니다.
:::

## 예제

### 버튼 변형 (Dialog)

세 가지 버튼 변형 — `Primary`, `Secondary`, `White` — 을 하나의 대화 상자에서 보여줍니다.

```lua
Window:Dialog({
    Title = "UI Button Variants",
    Content = "Demonstrates the Button variants.",
    Buttons = {
        { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
        { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
        { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
    },
})
```

### 확인 대화 상자 (Cancel / Confirm)

```lua
Window:Dialog({
    Title = "Reset settings?",
    Content = "All options will return to their defaults.",
    Icon = "rotate-ccw",
    Width = 340,
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function()
            print("cancelled")
        end },
        { Title = "Confirm", Variant = "Primary", Icon = "check", Callback = function()
            print("confirmed")
        end },
    },
})
```

### 간단한 팝업

```lua
ANUI:Popup({
    Title = "Welcome",
    Content = "Thanks for trying the script. Join our community for updates.",
    Icon = "hand",
    Thumbnail = {
        Image = "rbxassetid://84366761557806",
        Title = "ANHub",
    },
    Buttons = {
        { Title = "Copy Discord", Variant = "Primary", Icon = "link", Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
        end },
        { Title = "Close", Variant = "Secondary", Callback = function() end },
    },
})
```
