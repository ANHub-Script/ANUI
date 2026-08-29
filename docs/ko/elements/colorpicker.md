# Colorpicker

기능이 완비된 선택 대화상자를 통해 `Color3`를 — 선택적으로 투명도까지 — 고릅니다. 사용자가 적용하면 선택한 색상과 함께 콜백이 실행됩니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Colorpicker({
    Title = "Colorpicker",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(color, transparency)
        print("Color:", color, "Transparency:", transparency)
    end
})
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Colorpicker"` | 기본 레이블입니다. [리치 텍스트 토큰](/elements/#rich-text-in-title-desc)을 지원합니다. |
| `Desc` | `string` | `nil` | 제목 아래에 표시할 선택적 설명입니다. |
| `Locked` | `boolean` | `false` | 잠금 오버레이를 표시하고 상호작용을 차단합니다. |
| `Default` | `Color3` | `Color3.new(1, 1, 1)` (흰색) | 색상 견본에 표시되는 초기 색상입니다. |
| `Transparency` | `number` | `nil` | 초기 알파값입니다. 숫자를 제공하면 선택기에서 알파 슬라이더와 입력이 활성화됩니다. |
| `Callback` | `function` | `nil` | **적용** 시 실행됩니다. **`(color: Color3, transparency: number)`를 인자로 받습니다.** |
| `Buttons` | `table` | `nil` | 행에 렌더링되는 인라인 버튼입니다. |
| `TitleGradient` | `table` | `nil` | 제목 텍스트에 적용되는 그라디언트입니다. |
| `DescGradient` | `table` | `nil` | 설명 텍스트에 적용되는 그라디언트입니다. |
| `Flag` | `string` | `nil` | 설정 저장 키입니다. [설정 및 플래그](/features/config-and-flags)를 참고하세요. |

::: info 선택 대화상자
색상 견본을 클릭하면 다음이 포함된 대화상자가 열립니다:
- **채도/명도** 맵과 **색조** 슬라이더,
- 선택적 **알파** 슬라이더 (`Transparency`가 설정된 경우에만 표시됨),
- **Hex** 입력 (`#RRGGBB`)과 **R / G / B** 입력 — 투명도가 활성화된 경우 **Alpha** 입력까지,
- **취소**와 **적용** 버튼 — `Callback`은 **적용** 시 실행됩니다.

설정에 저장되면 컬러피커는 hex 값과 투명도를 함께 직렬화합니다.
:::

컬러피커는 [공유 베이스](/elements/#shared-base)의 구성과 메서드도 상속합니다.

## 메서드

### `Colorpicker:Update(color, transparency?)`

현재 색상(및 선택적 투명도)을 설정하고 색상 견본을 갱신합니다.

```lua
myColorpicker:Update(Color3.fromRGB(255, 0, 0))
myColorpicker:Update(Color3.fromRGB(255, 0, 0), 0.5)
```

### `Colorpicker:Set(color, transparency?)`

`:Update`의 별칭입니다 — 인자와 동작이 동일합니다.

```lua
myColorpicker:Set(Color3.fromHex("#305dff"))
```

### `Colorpicker:Lock()` / `Colorpicker:Unlock()`

컬러피커를 잠그거나 잠금을 해제합니다. 잠긴 컬러피커는 오버레이를 표시하며 열 수 없습니다.

```lua
myColorpicker:Lock()
myColorpicker:Unlock()
```

### 베이스 메서드

컬러피커는 [공유 베이스](/elements/#common-methods)의 `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` 및 `:Destroy`도 지원합니다.

## 예제

### 투명도와 Flag 사용

`Transparency`를 (심지어 `0`으로라도) 설정하면 대화상자에서 알파 컨트롤이 활성화됩니다. 그러면 콜백이 색상과 투명도를 모두 받습니다.

```lua
myTab:Colorpicker({
    Flag = "ColorpickerTest",
    Title = "Colorpicker",
    Desc = "Colorpicker Description",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color, transparency)
        print("Background color:", color, transparency)
    end
})
```

설정이 활성화되면 색상과 투명도는 자동으로 저장되고 복원됩니다 — [설정 및 플래그](/features/config-and-flags)를 참고하세요.
