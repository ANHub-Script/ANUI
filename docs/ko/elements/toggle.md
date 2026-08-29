# Toggle

콜백에 불리언 값을 보고하는 켜기/끄기 스위치입니다. 토글은 기본적으로 애니메이션 슬라이더로 렌더링되거나, `Type = "Checkbox"`를 통해 체크박스로 렌더링됩니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Toggle"` | 기본 레이블입니다. [리치 텍스트 토큰](/elements/#rich-text-in-title-desc)을 지원합니다. |
| `Desc` | `string` | `nil` | 제목 아래에 표시되는 선택적 설명입니다. |
| `Value` | `boolean` | `false` | 초기 상태입니다. |
| `Type` | `string` | `"Toggle"` | `"Toggle"`(애니메이션 슬라이더) 또는 `"Checkbox"`입니다. |
| `Icon` | `string` | `nil` | 슬라이더 노브 내부에 표시되는 아이콘입니다. |
| `IconSize` | `number` | `23` | 노브 아이콘의 크기입니다(픽셀 단위). |
| `Image` | `string` \| `table` | `nil` | 왼쪽 정렬 이미지입니다(에셋 id 또는 카드 테이블). |
| `ImageSize` | `number` | `30` | 왼쪽 이미지의 크기입니다(픽셀 단위). |
| `Thumbnail` | `string` | `nil` | 큰 썸네일 이미지입니다. |
| `ThumbnailSize` | `number` | `80` | 썸네일 크기입니다(픽셀 단위). |
| `Locked` | `boolean` | `false` | 잠금 오버레이입니다. 상호작용을 차단**하고** 콜백을 비활성화합니다. |
| `Disabled` | `boolean` | `false` | 사용자 상호작용만 차단합니다(콜백은 코드에서 여전히 실행됨). |
| `Callback` | `function` | `nil` | 변경 시 실행됩니다. **새 불리언 값을 전달받습니다.** |
| `Flag` | `string` | `nil` | 구성 지속성 키입니다. [Config & Flags](/features/config-and-flags)를 참고하세요. |
| `Buttons` | `table` | `nil` | 행에 렌더링되는 인라인 버튼입니다. |
| `TitleGradient` | `table` | `nil` | 제목 텍스트에 적용되는 그라데이션입니다. |
| `DescGradient` | `table` | `nil` | 설명 텍스트에 적용되는 그라데이션입니다. |

::: info Locked 대 Disabled
`Locked`는 잠금 오버레이를 표시하고, 사용자 상호작용을 차단**하며** 콜백이 실행되지 않도록 방지합니다. `Disabled`는 *사용자* 상호작용만 차단합니다 — `:Set(...)`으로 코드에서 여전히 값을 변경할 수 있으며 콜백이 실행됩니다. 런타임에 이러한 상태를 전환하려면 `:Lock()`/`:Unlock()` 및 `:Disable()`/`:Enable()`을 사용하세요.
:::

Toggle 또한 [공유 베이스](/elements/#shared-base) 구성과 메서드를 상속받습니다.

## 메서드

### `Toggle:Set(value, isCallback?, isAnimated?, force?)`

토글 상태를 프로그래밍 방식으로 설정합니다.

- `value` (`boolean`) — 새 상태입니다.
- `isCallback` (`boolean`, 선택) — 이 변경에 대해 `Callback`을 실행합니다.
- `isAnimated` (`boolean`, 선택) — 노브 전환을 애니메이션 처리합니다.
- `force` (`boolean`, 선택) — 변경을 강제로 적용합니다.

```lua
myToggle:Set(true, true)         -- turn on and fire the callback
myToggle:Set(false, false, false) -- turn off silently, no animation
```

### `Toggle:Lock(text?)` / `Toggle:Unlock()`

토글을 잠그거나 잠금을 해제합니다. 선택적 `text`는 오버레이 레이블을 설정합니다.

```lua
myToggle:Lock("Premium only")
myToggle:Unlock()
```

### `Toggle:Disable()` / `Toggle:Enable()`

잠금 오버레이 없이 *사용자* 상호작용을 비활성화하거나 다시 활성화합니다. `Lock`과 달리, 코드에서 값을 설정하면 콜백이 여전히 실행됩니다.

### `Toggle:SetMainImage(image, size)`

왼쪽 정렬 이미지와 그 크기를 갱신합니다.

```lua
myToggle:SetMainImage("rbxassetid://84366761557806", 24)
```

### 베이스 메서드

Toggle은 [공유 베이스](/elements/#common-methods)의 `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` 및 `:Destroy`도 지원합니다.

## 예제

### 기본 및 설명 포함

```lua
myTab:Toggle({
    Title = "Basic Toggle",
    Desc = "Standard toggle with animated slider (drag or click).",
    Callback = function(v)
        print("Basic Toggle:", v)
    end
})
```

### 왼쪽 이미지 포함

```lua
myTab:Toggle({
    Title = "Toggle with Left Image",
    Desc = "Image on the left, centered between title and desc.",
    Image = "rbxassetid://84366761557806",
    ImageSize = 24,
    Callback = function(v) print(v) end
})
```

### 노브 아이콘 및 기본 켜짐

```lua
myTab:Toggle({
    Title = "Toggle with Icon",
    Desc = "Shows an icon inside the slider when toggled.",
    Icon = "mouse",
    IconSize = 15,
    Value = true,
    Callback = function(v) print(v) end
})
```

### 체크박스 변형

```lua
myTab:Toggle({
    Title = "Checkbox",
    Desc = "Checkbox variant of toggle.",
    Type = "Checkbox",
    Callback = function(v) print(v) end
})

myTab:Toggle({
    Title = "Checkbox (Default ON)",
    Type = "Checkbox",
    Value = true,
    Callback = function(v) print(v) end
})
```

### 잠금

```lua
myTab:Toggle({
    Title = "Locked Toggle",
    Desc = "Locked state prevents user interaction.",
    Locked = true,
    Callback = function(v) print(v) end
})
```

### 프로그래밍 방식 갱신

```lua
local progToggle = myTab:Toggle({
    Title = "Programmatic Toggle",
    Desc = "Demonstrates using Set() and updating title/desc via code.",
    Value = false,
    Callback = function(v) print("Programmatic Toggle:", v) end
})

myTab:Button({
    Title = "Turn ON",
    Callback = function()
        progToggle:Set(true, true)
        progToggle:SetTitle("Programmatic Toggle (ON)")
        progToggle:SetDesc("Toggled on by code.")
    end
})

myTab:Button({
    Title = "Turn OFF (no animation)",
    Callback = function()
        progToggle:Set(false, true, false)
        progToggle:SetTitle("Programmatic Toggle (OFF)")
        progToggle:SetDesc("Toggled off by code without animation.")
    end
})
```

### Flag로 지속하기

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(v) print(v) end
})
```

구성이 활성화되면 값이 자동으로 저장되고 복원됩니다 — [Config & Flags](/features/config-and-flags)를 참고하세요.
