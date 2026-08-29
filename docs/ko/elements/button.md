# Button

선택적 아이콘, 색상 및 인라인 버튼을 가진 클릭 가능한 동작 행입니다. 버튼은 가장 단순한 상호작용 요소로, 클릭하면 콜백을 실행합니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({
    Title = "Click me",
    Callback = function()
        print("Button clicked!")
    end
})
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Button"` | 기본 레이블입니다. [리치 텍스트 토큰](/elements/#rich-text-in-title-desc)을 지원합니다. |
| `Desc` | `string` | `nil` | 제목 아래에 표시할 선택적 설명입니다. |
| `Icon` | `string` | `"mouse-pointer-click"` | 아이콘 이름 또는 `rbxassetid://…`입니다. |
| `IconThemed` | `boolean` | `false` | 현재 테마 색상으로 아이콘을 착색합니다. |
| `Color` | `Color3` \| `string` | `nil` | 색상 배경(테마 이름 또는 `Color3`)이며, 텍스트는 자동으로 대비됩니다. |
| `Justify` | `string` | `"Between"` | 콘텐츠 정렬입니다. `"Between"`은 제목과 아이콘을 양 끝으로 벌리고, `"Center"`는 가운데로 정렬합니다. |
| `IconAlign` | `string` | `"Right"` | 아이콘이 놓일 위치입니다: `"Right"` 또는 `"Left"`. |
| `Locked` | `boolean` | `false` | 잠금 오버레이를 표시하고 클릭을 차단합니다. |
| `Callback` | `function` | `nil` | 버튼을 클릭할 때 실행합니다. **인수를 받지 않습니다.** |
| `Buttons` | `table` | `nil` | 행에 렌더링되는 인라인 버튼입니다. |
| `TitleGradient` | `table` | `nil` | 제목 텍스트에 적용되는 그라디언트입니다. |
| `DescGradient` | `table` | `nil` | 설명 텍스트에 적용되는 그라디언트입니다. |

::: info Callback 서명
버튼의 `Callback`은 **인수를 받지 않습니다** — 단순한 동작 핸들러입니다. 값에 반응해야 한다면 [Toggle](/elements/toggle) 또는 [Dropdown](/elements/dropdown)을 대신 사용하세요.
:::

버튼은 [공유 베이스](/elements/#shared-base) 구성(`Image`, `Thumbnail`, 그라디언트, `Title`/`Desc`의 리치 텍스트 토큰 등)도 상속합니다.

## 메서드

### `Button:Highlight()`

사용자의 주의를 끌기 위해 버튼을 잠깐 깜빡입니다.

```lua
local btn = myTab:Button({ Title = "Notice me", Callback = function() end })
btn:Highlight()
```

### `Button:Lock()` / `Button:Unlock()`

버튼을 잠그거나 잠금 해제합니다. 잠긴 버튼은 오버레이를 표시하고 클릭을 무시합니다.

```lua
btn:Lock()
btn:Unlock()
```

### `Button:SetTitle(text)` / `Button:SetDesc(text)` / `Button:SetIcon(icon)`

런타임에 제목, 설명 또는 아이콘을 갱신합니다.

```lua
btn:SetTitle("Updated title")
btn:SetDesc("Updated description")
btn:SetIcon("check")
```

### `Button:SetButtons(buttons)` / `Button:GetButton(key)` / `Button:GetButtons()`

행에 렌더링되는 인라인 버튼을 관리합니다. `SetButtons`는 맵을 교체하고, `GetButton`은 키로 하나를 가져오며, `GetButtons`는 전체를 반환합니다.

### `Button:Destroy()`

컨테이너에서 버튼을 제거합니다.

## 예제

### 기본과 색상

```lua
myTab:Button({
    Title = "Highlight Button",
    Icon = "mouse",
    Callback = function()
        print("clicked highlight")
    end
})

myTab:Button({
    Title = "Blue Button",
    Desc = "With description",
    Color = Color3.fromHex("#305dff"),
    Icon = "",
    Callback = function() end
})
```

### 아이콘 정렬과 배치

```lua
myTab:Button({
    Title = "Left Icon",
    Desc = "Icon aligned to the left",
    Icon = "mouse",
    IconAlign = "Left",
    Justify = "Center",
    Callback = function() end
})
```

### 테마 및 색상 아이콘

```lua
myTab:Button({
    Title = "Themed Icon",
    Desc = "Icon follows theme colors",
    Icon = "palette",
    IconThemed = true,
    Callback = function() end
})

myTab:Button({
    Title = "Colored Icon",
    Desc = "Icon tinted with custom color",
    Icon = "mouse-pointer-click",
    Color = Color3.fromHex("#f57c00"),
    Callback = function() end
})
```

### 잠김

```lua
myTab:Button({
    Title = "Button",
    Desc = "Button example",
    Locked = true
})
```

### 프로그래밍 방식 갱신

반환된 모듈을 보관하고 다른 버튼에서 갱신합니다. `Highlight()`는 변경 사항에 주의를 끕니다.

```lua
local progBtn = myTab:Button({
    Title = "Programmatic Button",
    Desc = "Will be updated by code",
    Icon = "edit",
    Callback = function() end
})

myTab:Button({
    Title = "Update Above",
    Desc = "SetTitle and SetDesc",
    Icon = "chevron-right",
    Callback = function()
        progBtn:SetTitle("Programmatic Button (Updated)")
        progBtn:SetDesc("Updated by code")
        progBtn:Highlight()
    end
})
```

### Dialog를 통한 UI 버튼 변형

`Window:Dialog` 내부의 버튼은 `Variant` 스타일링 — `"Primary"`, `"Secondary"`, `"White"`을 지원합니다.

```lua
myTab:Button({
    Title = "Show UI Button Variants",
    Desc = "Opens dialog with Primary/Secondary/White",
    Icon = "square-menu",
    Callback = function()
        Window:Dialog({
            Title = "UI Button Variants",
            Content = "Demonstrates button variants.",
            Buttons = {
                { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
                { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
                { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
            }
        })
    end
})
```

::: tip
`Icon = ""`로 설정하면 아이콘이 전혀 없는 버튼이 렌더링됩니다 — 가운데 정렬된 텍스트 전용 동작 버튼에 유용합니다.
:::
