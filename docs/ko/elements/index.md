# Elements

ANUI의 Element는 Window 내부에서 사용하는 인터랙티브 컨트롤입니다. 일반적으로 `Tab`, `Section`, `Group`에서 생성합니다.

```lua
local Main = Window:Tab({ Title = "Main", Icon = "house" })

Main:Button({
    Title = "Click me",
    Callback = function()
        print("clicked")
    end,
})
```

## 지원 Element

| Element | 용도 |
| --- | --- |
| `Button` | 클릭 가능한 작업 버튼 |
| `Toggle` | On/Off 상태 전환 |
| `Slider` | 숫자 범위 선택 |
| `Dropdown` | 단일/다중 선택 |
| `Input` | 텍스트 입력 |
| `Keybind` | 키에 동작 연결 |
| `Colorpicker` | 색상 및 투명도 선택 |
| `Paragraph` | 설명/리치 텍스트 블록 |
| `Code` | 복사 가능한 코드 블록 |
| `Section` | 접을 수 있는 Element 그룹 |
| `Divider` | 구분선 |
| `Space` | 여백 |
| `Image` | 독립 이미지 |
| `Group` | 가로 방향 컨테이너 |
| `Category` | 여러 페이지를 전환하는 옵션 스트립 |

## 공통 설정

대부분의 Element는 다음 옵션을 공유합니다.

- `Title` — 기본 제목
- `Desc` — 보조 설명
- `Icon` — Lucide 이름 또는 `rbxassetid://...`
- `Locked` — 상호작용 잠금
- `Color` — 배경 색상
- `Image` / `Thumbnail` — 이미지
- `TitleGradient` / `DescGradient` — 텍스트 그라디언트
- `Buttons` — 인라인 버튼

## 상태 저장

`Toggle`, `Slider`, `Dropdown`, `Input`, `Keybind`, `Colorpicker`는 `Flag`를 지정하면 Config System에서 상태를 저장할 수 있습니다.

```lua
Main:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(value) end,
})
```

::: tip
Element를 나중에 코드로 변경해야 한다면 생성 결과를 변수에 저장하세요. 예: `local toggle = Main:Toggle({...})`.
:::

더 자세한 API와 옵션은 [영문 Elements 문서](../../elements/)에서 확인할 수 있습니다.
