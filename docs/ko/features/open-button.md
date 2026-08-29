# Open Button

Open Button은 Window을 닫은 뒤 다시 열 수 있는 floating button입니다.

## 생성 시 설정

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    OpenButton = {
        Title = "My Hub",
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"),
            Color3.fromHex("#e7ff2f")
        ),
    },
})
```

## 주요 옵션

| Field | 설명 |
| --- | --- |
| `Title` | 버튼에 표시할 텍스트 |
| `Icon` | 아이콘 |
| `Enabled` | 버튼 활성화 여부 |
| `Position` | 화면 위치 |
| `OnlyIcon` | 아이콘만 표시 |
| `Draggable` | 버튼 이동 허용 |
| `OnlyMobile` | 모바일에서만 표시할지 여부 |
| `CornerRadius` | 모서리 반경 |
| `StrokeThickness` | 외곽선 두께 |
| `Color` | `ColorSequence` 기반 외곽선 그라디언트 |

## 런타임 수정

```lua
Window:EditOpenButton({
    Title = "Open Menu",
    StrokeThickness = 4,
})

Window.OpenButtonMain:SetIcon("menu")
Window.OpenButtonMain:Visible(false)
Window.OpenButtonMain:Visible(true)
```

설정은 누적 병합되므로 전달하지 않은 기존 옵션은 유지됩니다.
