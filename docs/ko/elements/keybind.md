# Keybind

동작을 키보드 키 또는 마우스 버튼에 바인딩합니다. 콜백은 바인딩된 키가 눌릴 때마다 전역적으로 실행되므로, 키바인드는 창이 열려 있을 때뿐만 아니라 게임 어디에서나 동작합니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Keybind({
    Title = "Keybind",
    Value = "F",
    Callback = function(key)
        print("Pressed:", key)
    end
})
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Keybind"` | 기본 레이블입니다. [리치 텍스트 토큰](/elements/#rich-text-in-title-desc)을 지원합니다. |
| `Desc` | `string` | `nil` | 제목 아래에 표시되는 선택적 설명입니다. |
| `Locked` | `boolean` | `false` | 잠금 오버레이를 렌더링하고 상호작용을 차단합니다. |
| `Value` | `string` | `"F"` | 초기 키이며, **키 이름** 문자열로 지정합니다(예: `"F"`, `"G"`). |
| `CanChange` | `boolean` | `true` | 사용자가 클릭하여 키를 다시 바인딩할 수 있는지 여부입니다. 현재 빌드에서는 사실상 항상 활성화되어 있습니다. |
| `Callback` | `function` | `nil` | 바인딩된 키가 눌릴 때 실행됩니다. **키 이름을 문자열로 전달받습니다.** |
| `Buttons` | `table` | `nil` | 행에 렌더링되는 인라인 버튼입니다. |
| `TitleGradient` | `table` | `nil` | 제목 텍스트에 적용되는 그라데이션입니다. |
| `DescGradient` | `table` | `nil` | 설명 텍스트에 적용되는 그라데이션입니다. |
| `Flag` | `string` | `nil` | 구성 지속성 키입니다. [Config & Flags](/features/config-and-flags)를 참고하세요. |

::: info 실행 및 재바인딩 방식
- 콜백은 바인딩된 키가 눌릴 때마다 **전역적으로** 실행됩니다 — TextBox가 포커스를 가진 동안에만 억제되므로, 타이핑이 키바인드를 실행하지 않습니다.
- 콜백 인자는 키 **이름** 문자열입니다: `Enum.KeyCode.F`는 `"F"`를 보고하고, 마우스 버튼은 `"MouseLeft"` 또는 `"MouseRight"`를 보고합니다.
- **재바인딩하려면:** 키바인드를 클릭합니다. `...`가 표시되며 다음에 누르는 키를 캡처합니다.
:::

Keybind 또한 [공유 베이스](/elements/#shared-base) 구성과 메서드를 상속받습니다.

## 메서드

### `Keybind:Set(value)`

이름 문자열로 바인딩된 키를 설정합니다.

```lua
myKeybind:Set("G")
```

### `Keybind:Lock()` / `Keybind:Unlock()`

키바인드를 잠그거나 잠금을 해제합니다. 잠긴 키바인드는 오버레이를 표시하며 다시 바인딩할 수 없습니다.

```lua
myKeybind:Lock()
myKeybind:Unlock()
```

### 베이스 메서드

Keybind는 [공유 베이스](/elements/#common-methods)의 `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` 및 `:Destroy`도 지원합니다.

## 예제

### 창의 토글 키 재바인딩

콜백이 키 이름을 제공하므로, `Enum.KeyCode[key]`로 다시 `Enum.KeyCode`로 변환하여 `Window:SetToggleKey`에 바로 전달할 수 있습니다.

```lua
myTab:Keybind({
    Flag = "KeybindTest",
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})
```

::: tip 바인딩 지속하기
`Flag`을 추가하면 세션 간에 바인딩된 키를 저장하고 복원할 수 있습니다. [Config & Flags](/features/config-and-flags)를 참고하세요.
:::
