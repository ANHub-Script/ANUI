# Open Button

열기 버튼은 UI가 닫힌 후 다시 여는 떠 있는 알약 모양 버튼입니다. 창을 생성할 때 구성하거나 나중에 런타임에 편집할 수 있습니다.

## 생성 시 구성

`CreateWindow`에 `OpenButton` 테이블을 전달하십시오.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | — | 버튼에 표시되는 텍스트입니다. |
| `Icon` | `string` | — | 제목 앞에 표시되는 아이콘 이름 또는 `rbxassetid://…`입니다. |
| `Enabled` | `boolean` | — | 열기 버튼을 완전히 비활성화하려면 `false`로 설정하십시오. |
| `Position` | `UDim2` | — | 버튼이 화면에서 위치하는 곳입니다. |
| `OnlyIcon` | `boolean` | `false` | 아이콘만 있는 둥근 버튼(Delta 스타일)으로, 제목과 드래그 핸들을 숨깁니다. |
| `Draggable` | `boolean` | — | 사용자가 버튼을 끌어 옮길 수 있게 합니다. |
| `OnlyMobile` | `boolean` | — | 모바일 전용으로 두려면 설정하지 마십시오. 데스크톱에도 표시하려면 `false`로 설정하십시오. |
| `CornerRadius` | `UDim` | `UDim.new(1, 0)` | 버튼의 모서리 반경입니다(기본값은 완전히 둥근 모양). |
| `StrokeThickness` | `number` | `2` | 버튼 윤곽선의 두께입니다. |
| `Color` | `ColorSequence` | `#40c9ff → #e81cff` | 버튼 윤곽선 스트로크의 그라데이션입니다. |
| `Size` | `UDim2` | auto | 버튼 크기입니다. 기본적으로 내용에 맞게 자동 크기 조정됩니다. |

::: info OnlyMobile 기본값
`OnlyMobile`을 설정하지 않으면 버튼은 **모바일 전용**으로 동작합니다. 위 예제처럼 데스크톱에도 표시하려면 `OnlyMobile = false`로 설정하십시오.
:::

::: tip Color는 그라데이션입니다
`Color`는 `Color3`가 아니라 `ColorSequence`를 받습니다 — 버튼의 윤곽선에 그라데이션으로 적용됩니다. `ColorSequence.new(colorA, colorB)`로 하나를 만드십시오.
:::

## 런타임에 편집

### `Window:EditOpenButton(config)`

열기 버튼에 변경 사항을 적용합니다. 편집은 **누적적으로 병합됩니다** — 전달하지 않은 필드는 현재 값을 유지합니다.

```lua
Window:EditOpenButton({
    Title = "Open Menu",
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
})
```

## 열기 버튼 메서드

열기 버튼 객체는 `Window.OpenButtonMain`으로 사용할 수 있습니다.

### `Window.OpenButtonMain:SetIcon(icon)`

버튼의 아이콘을 교체합니다(아이콘 이름 또는 `rbxassetid://…`).

```lua
Window.OpenButtonMain:SetIcon("menu")
```

### `Window.OpenButtonMain:Visible(visible)`

버튼을 표시하거나 숨깁니다.

```lua
Window.OpenButtonMain:Visible(false) -- hide
Window.OpenButtonMain:Visible(true)  -- show
```

### `Window.OpenButtonMain:Edit(config)`

`Window:EditOpenButton`과 동일합니다 — 주어진 구성을 현재 구성에 병합합니다. 코드에서 더 잘 읽히는 쪽을 사용하십시오.

```lua
Window.OpenButtonMain:Edit({ Title = "Reopen" })
```

## 예제

예제 스크립트를 각색: 사용자 지정 제목과 초록-노랑 그라데이션 윤곽선을 가진 둥글고 끌 수 있는 알약 모양 버튼을 데스크톱과 모바일 모두에 표시합니다.

```lua
local Window = ANUI:CreateWindow({
    Title = ".an hub | ANUI Library",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

나머지 창 옵션은 [Window Configuration](/guide/window-configuration)을 참고하십시오.
