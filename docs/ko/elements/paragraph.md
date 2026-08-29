# Paragraph

제목, 메모, 설명에 쓰는 리치 텍스트 블록입니다. 호버가 비활성화된 [공통 기반](/ko/elements/#공통-기반)으로 만들어져 정적 콘텐츠처럼 보이며, 자식 요소를 붙일 수 있는 가벼운 컨테이너 역할도 합니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Paragraph({
    Title = "Toggle Examples",
    Desc = "This tab showcases all supported Toggle features: classic toggle, checkbox variant, per-item icons, default values, locking, and programmatic updates."
})
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Paragraph"` | 제목 텍스트입니다. [리치 텍스트 토큰](/ko/elements/#title-및-desc의-리치-텍스트)을 지원합니다. |
| `Desc` | `string` | `nil` | 본문 텍스트입니다. 리치 텍스트 토큰과 `\n`을 사용한 여러 줄을 지원합니다. |
| `Locked` | `boolean` | `false` | 잠금 오버레이를 표시합니다. |
| `Images` | `table` | `nil` | 이미지 카드 격자로 표시할 카드 객체 배열입니다. |
| `ImageSize` | `UDim2` | `UDim2.fromOffset(70, 70)` | 각 이미지 카드의 크기입니다. |
| `Buttons` | `table` | `nil` | 텍스트 아래에 **세로 전체 너비 버튼**으로 표시할 `{ Title, Icon, Callback }` 배열입니다. |

### 이미지 카드 객체

`Images`의 각 항목은 테이블입니다.

| 필드 | 형식 | 설명 |
| --- | --- | --- |
| `Title` | `string` | 카드 레이블입니다. |
| `Quantity` | `string` | 수량/개수 배지(예: `"244x"`)입니다. |
| `Image` | `string` | 에셋 ID(`rbxassetid://…`) 또는 아이콘 이름입니다. |
| `Gradient` | `ColorSequence` | 카드 배경 그라데이션입니다. |
| `Callback` | `function` | 카드를 클릭할 때 실행합니다. |

::: info 두 종류의 `Buttons`
여기의 `Buttons` 구성은 Paragraph 텍스트 아래에 **세로 전체 너비** 버튼(각 `{ Title, Icon, Callback }`)을 표시합니다. 다른 요소가 행 안에 표시하는 공통 기반 인라인 `Buttons` **맵**과는 다릅니다.
:::

Paragraph는 [공통 기반](/ko/elements/#공통-기반)에서 `Image`, 그라데이션, 리치 텍스트 토큰, 잠금, 강조를 상속합니다. 호버는 항상 비활성화됩니다.

## 메서드

### `Paragraph:SetTitle(text)` / `Paragraph:SetDesc(text)`

Paragraph에 저장된 `Title` / `Desc` 필드를 갱신합니다.

```lua
myParagraph:SetTitle("Updated heading")
myParagraph:SetDesc("Updated body text.")
```

::: details 표시된 텍스트 갱신
`:SetTitle` / `:SetDesc`는 요소의 Lua 필드를 갱신합니다. 이미 화면에 표시된 텍스트를 바꾸려면 내부 ParagraphFrame의 setter를 사용하세요.
:::

### `Paragraph:SetViewport(model, cameraOffset?)`

선택적 `cameraOffset`과 함께 `model`의 3D 미리보기를 표시하는 95×95 `ViewportFrame`을 렌더링합니다.

```lua
myParagraph:SetViewport(workspace.SomeModel)
```

## 예제

### 여러 줄 설명

설명을 여러 줄로 나누려면 `\n`을 사용합니다.

```lua
myTab:Paragraph({
    Title = "Rank Information",
    Desc = "Current Rank: S-Class\nPower: 500,000"
})
```

### 가벼운 컨테이너로 사용

Paragraph 객체는 Tab과 같은 요소 생성 메서드를 제공하므로 자식 요소를 직접 붙일 수 있습니다. 제목 아래의 컨트롤을 묶기에 편리합니다.

```lua
local group = myTab:Paragraph({
    Title = "Yen Upgrades",
    Desc = "Upgrade stats using Yen currency"
})

group:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" })
group:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" })
group:Button({ Title = "Rank Up", Icon = "arrow-up-circle" })
```

### 이미지 카드 격자

```lua
myTab:Paragraph({
    Title = "Inventory",
    ImageSize = UDim2.fromOffset(70, 70),
    Images = {
        {
            Title = "World Box",
            Quantity = "244x",
            Image = "rbxassetid://84366761557806",
            Gradient = ColorSequence.new(Color3.fromHex("#C042FF"), Color3.fromHex("#8E24AA")),
            Callback = function() print("World Box") end
        },
        {
            Title = "Zone Key",
            Quantity = "3x",
            Image = "key",
            Gradient = ColorSequence.new(Color3.fromHex("#29B6F6"), Color3.fromHex("#0288D1")),
            Callback = function() print("Zone Key") end
        },
    }
})
```

### 세로 버튼

```lua
myTab:Paragraph({
    Title = "ANHUB Discord",
    Desc = "Members: 1,234\nOnline: 567",
    Buttons = {
        {
            Title = "Copy link",
            Icon = "link",
            Callback = function()
                setclipboard("https://discord.gg/qN47S3mKZA")
            end
        }
    }
})
```
