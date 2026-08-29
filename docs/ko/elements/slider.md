# Slider

선택적 단계 조절과 수동 텍스트 입력을 지원하는 드래그 가능한 숫자 슬라이더입니다. 값은 범위를 지정하고, 단계별로 조절하며, 정수 또는 부동 소수점으로 서식을 지정할 수 있습니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        print("Volume:", value)
    end
})
```

## 구성

범위는 `Value` 테이블로 정의하거나, 평면 형태의 `Min` / `Max` / `Default` 필드로 정의할 수 있습니다.

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Slider"` | 기본 레이블입니다. [리치 텍스트 토큰](/elements/#rich-text-in-title-desc)을 지원합니다. |
| `Desc` | `string` | `nil` | 제목 아래에 표시되는 선택적 설명입니다. |
| `Value` | `table` | `nil` | 범위 테이블 `{ Min, Max, Default }`입니다. 아래 필드의 대안입니다. |
| `Min` | `number` | `0` | 하한값입니다(`Value`를 사용하지 않을 때). |
| `Max` | `number` | `100` | 상한값입니다(`Value`를 사용하지 않을 때). |
| `Default` | `number` | `0` | 시작 값입니다(`Value`를 사용하지 않을 때). |
| `Step` | `number` | `1` | 각 정지점 사이의 증가량입니다. **분수** 단계(예: `0.1`)는 슬라이더를 부동 소수점 모드로 전환합니다. |
| `Locked` | `boolean` | `false` | 잠금 오버레이를 렌더링하고 상호작용을 차단합니다. |
| `Callback` | `function` | `nil` | 변경 시 실행됩니다. **서식이 지정된 문자열을 전달받습니다**(아래 참고). |
| `Flag` | `string` | `nil` | 구성 지속성 키입니다. [Config & Flags](/features/config-and-flags)를 참고하세요. |
| `Buttons` | `table` | `nil` | 행에 렌더링되는 인라인 버튼입니다. |
| `TitleGradient` | `table` | `nil` | 제목 텍스트에 적용되는 그라데이션입니다. |
| `DescGradient` | `table` | `nil` | 설명 텍스트에 적용되는 그라데이션입니다. |

::: warning 콜백 인자는 문자열입니다
`Callback`에 전달되는 값은 숫자가 아니라 **서식이 지정된 문자열**입니다. 정수 슬라이더는 내림 처리된 정수(`"50"`)를 전달받고, 부동 소수점 슬라이더(분수 `Step`)는 `"%.2f"` 문자열(`"0.50"`)을 전달받습니다. 계산을 수행하기 전에 `tonumber(value)`로 변환하세요.
:::

Slider 또한 [공유 베이스](/elements/#shared-base) 구성과 메서드를 상속받습니다.

## 값 서식 지정 및 스냅

- **스냅** — 원시 위치는 가장 가까운 단계로 스냅됩니다: `floor(raw / Step + 0.5) * Step`.
- **정수 대 부동 소수점** — 정수 `Step`은 값을 정수로 내림하고, 분수 `Step`은 `"%.2f"`로 서식을 지정합니다.
- **수동 입력** — 값은 텍스트 필드이기도 합니다. 클릭하여 숫자를 입력하고 **Enter**를 눌러 커밋합니다.
- **지속성** — `Flag`이 설정되면 구성은 `Value.Default`를 서식이 지정된 문자열로 저장합니다.

## 메서드

### `Slider:Set(value, input?)`

슬라이더 값을 프로그래밍 방식으로 설정합니다. `value`는 범위 내의 숫자이며, `input?`은 변경이 수동 텍스트 필드에서 발생할 때 사용되는 선택적 플래그입니다.

```lua
mySlider:Set(75)
```

### `Slider:SetMin(n)`

슬라이더의 하한값을 갱신합니다.

```lua
mySlider:SetMin(10)
```

### `Slider:SetMax(n)`

슬라이더의 상한값을 갱신합니다.

```lua
mySlider:SetMax(200)
```

### `Slider:Lock()` / `Slider:Unlock()`

슬라이더를 잠그거나 잠금을 해제합니다.

```lua
mySlider:Lock()
mySlider:Unlock()
```

## 예제

### 정수 슬라이더 (Volume 0–100)

문자열 인자를 숫자로 사용하기 전에 변환하는 것을 잊지 마세요.

```lua
myTab:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        local n = tonumber(value) -- value is a string like "50"
        print("Volume:", n)
    end
})
```

### 부동 소수점 슬라이더 (분수 Step)

`Step`이 `0.1`이면 슬라이더가 부동 소수점 모드로 전환되므로, 콜백은 `"0.50"`과 같은 값을 전달받습니다.

```lua
myTab:Slider({
    Title = "Brightness",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(value)
        print("Brightness:", value) -- "0.50"
    end
})
```

### Flag로 지속하기

```lua
myTab:Slider({
    Title = "Slider",
    Flag = "SliderTest",
    Step = 1,
    Value = { Min = 20, Max = 120, Default = 70 },
    Callback = function(value)
        print(value)
    end
})
```

### 프로그래밍 방식 제어

```lua
local speed = myTab:Slider({
    Title = "Speed",
    Value = { Min = 0, Max = 100, Default = 20 },
    Callback = function(value) print(value) end
})

speed:Set(60)     -- move the handle to 60
speed:SetMax(150) -- widen the range
```
