# Space

요소 사이에 여백을 더하는 보이지 않는 세로 공간입니다. 아무것도 표시하지 않고 높이만 확보합니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Space()
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Columns` | `number` | `1` | 높이 배수입니다. 공간의 높이는 `7 × Columns`픽셀입니다. |

::: info 높이
높이는 `7 * Columns`픽셀로 계산됩니다. 기본값 `Columns = 1`은 7px, `Columns = 2`는 14px을 확보합니다.
:::

## 예제

### 더 큰 간격

```lua
myTab:Space({ Columns = 2 }) -- 14px of vertical space
```

### 요소 목록에 간격 넣기

각 컨트롤 사이에 `Space()`를 두면 긴 목록이 답답해 보이지 않게 할 수 있습니다.

```lua
myTab:Toggle({ Title = "Basic Toggle", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Toggle with Description", Desc = "Extra detail", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Checkbox", Type = "Checkbox", Callback = function(v) end })
```

::: info
Space는 대화형 요소가 아니므로 메서드를 제공하지 않습니다. 생성할 때 `Columns` 필드로 크기를 조정하세요.
:::
