# Input

문자열 입력을 받는 텍스트 필드입니다 — 단일 행(`"Input"`) 또는 다중 행(`"Textarea"`)입니다. 콜백은 필드가 커밋될 때마다 현재 텍스트를 전달받습니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Input({
    Title = "Input",
    InputIcon = "mouse",
    Placeholder = "Enter Text...",
    Callback = function(text)
        print("Text:", text)
    end
})
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Input"` | 기본 레이블입니다. [리치 텍스트 토큰](/elements/#rich-text-in-title-desc)을 지원합니다. |
| `Desc` | `string` | `nil` | 제목 아래에 표시되는 선택적 설명입니다. |
| `Type` | `string` | `"Input"` | `"Input"`(단일 행) 또는 `"Textarea"`(다중 행)입니다. |
| `Locked` | `boolean` | `false` | 잠금 오버레이를 렌더링하고 상호작용을 차단합니다. |
| `InputIcon` | `string` \| `boolean` | `false` | 입력 상자 내부에 표시되는 아이콘입니다. 표시하지 않으려면 `false`로 설정합니다. |
| `Placeholder` | `string` | `"Enter Text..."` | 필드가 비어 있을 때 표시되는 흐린 색의 힌트입니다. |
| `Value` | `string` | `""` | 초기 텍스트입니다. |
| `ClearTextOnFocus` | `boolean` | `false` | 필드가 포커스를 받을 때 자동으로 지웁니다. |
| `Callback` | `function` | `nil` | 커밋 시 실행됩니다. **현재 텍스트를 문자열로 전달받습니다.** |
| `Buttons` | `table` | `nil` | 행에 렌더링되는 인라인 버튼입니다. |
| `TitleGradient` | `table` | `nil` | 제목 텍스트에 적용되는 그라데이션입니다. |
| `DescGradient` | `table` | `nil` | 설명 텍스트에 적용되는 그라데이션입니다. |
| `Flag` | `string` | `nil` | 구성 지속성 키입니다. [Config & Flags](/features/config-and-flags)를 참고하세요. |

::: info 콜백 시그니처
`Callback`은 단일 **문자열**(필드의 현재 텍스트)을 전달받습니다. 필드가 커밋될 때(포커스를 잃거나, 단일 행 입력의 경우 Enter를 누를 때) 실행되며, 시작 `Value`와 함께 **초기화 시 한 번** 실행됩니다.
:::

Input 또한 [공유 베이스](/elements/#shared-base) 구성과 메서드를 상속받습니다.

## 메서드

### `Input:Set(value, isUserInput?)`

필드의 텍스트를 `value`로 설정합니다. 선택적 `isUserInput` 플래그는 변경을 사용자에 의한 것으로 표시합니다.

```lua
myInput:Set("hello")
```

### `Input:SetPlaceholder(value)`

필드가 비어 있을 때 표시되는 플레이스홀더 힌트를 갱신합니다.

```lua
myInput:SetPlaceholder("Type a name...")
```

### `Input:Lock()` / `Input:Unlock()`

입력을 잠그거나 잠금을 해제합니다. 잠긴 입력은 오버레이를 표시하고 타이핑을 무시합니다.

```lua
myInput:Lock()
myInput:Unlock()
```

### 베이스 메서드

Input은 [공유 베이스](/elements/#common-methods)의 `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` 및 `:Destroy`도 지원합니다.

## 예제

### 아이콘이 포함된 기본 입력

```lua
myTab:Input({
    Title = "Input",
    InputIcon = "mouse"
})
```

### Textarea (다중 행)

```lua
myTab:Input({
    Title = "Input Textarea",
    Type = "Textarea",
    InputIcon = "mouse"
})
```

### 설명 포함

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example"
})
```

### 잠금

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example",
    Locked = true
})
```

### Flag로 지속하기

```lua
myTab:Input({
    Flag = "InputTest",
    Title = "Input",
    Desc = "Input Description",
    Value = "Default value",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter text...",
    Callback = function(input)
        print("Text entered:", input)
    end
})
```

구성이 활성화되면 값이 자동으로 저장되고 복원됩니다 — [Config & Flags](/features/config-and-flags)를 참고하세요.
