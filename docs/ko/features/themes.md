# Themes

ANUI는 26개의 내장 테마를 제공하며 직접 등록할 수도 있습니다. 창을 생성할 때 테마를 선택하고, 런타임에 전환하고, 활성 테마를 읽고, 변경에 반응할 수 있습니다 — 모두 최상위 `ANUI` 메서드를 통해 이루어집니다.

## 생성 시 테마 설정

`Theme` 필드로 `CreateWindow`에 테마 키를 전달하십시오. 기본값은 `"Dark"`입니다.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Theme = "Midnight", -- any built-in key, or a custom theme name
})
```

나머지 창 옵션은 [Window Configuration](/guide/window-configuration)을 참고하십시오.

## 런타임에 테마 전환

### `ANUI:SetTheme(name)`

키로 테마를 적용하고 테마 테이블을 반환하며, 키를 알 수 없을 때는 `nil`을 반환합니다.

```lua
if not ANUI:SetTheme("Emerald") then
    warn("Unknown theme key")
end
```

## 활성 테마 읽기

### `ANUI:GetCurrentTheme()`

활성 테마의 **표시 이름**을 반환합니다(예를 들어 `MonokaiPro` 키가 아니라 `"Monokai Pro"`).

```lua
print(ANUI:GetCurrentTheme()) --> "Midnight"
```

### `ANUI:GetThemes()`

등록된 모든 테마의 테이블을 테마 키로 색인하여 반환합니다 — `AddTheme`로 추가한 것도 포함됩니다.

```lua
for key, theme in pairs(ANUI:GetThemes()) do
    print(key, "->", theme.Name)
end
```

## 테마 변경에 반응

### `ANUI:OnThemeChange(callback)`

`SetTheme`이 테마를 적용할 때마다 실행되는 핸들러를 등록합니다. 콜백은 **하나의 인수: 적용된 테마 키**를 받습니다 — `SetTheme`에 전달한 것과 동일한 문자열입니다(예: `"Dark"`).

```lua
ANUI:OnThemeChange(function(themeKey)
    print("Theme changed to:", themeKey)
end)
```

::: info 핸들러는 하나만
`OnThemeChange`는 단일 핸들러를 저장합니다 — 다시 호출하면 이전 것을 대체합니다. 하나의 함수를 등록하고, 스크립트의 여러 부분이 반응해야 하면 그 안에서 분기하십시오.
:::

## 내장 테마

`Theme` / `SetTheme`에 **키**를 전달하십시오. 표시 이름(`GetCurrentTheme`이 반환하는 것)은 소수의 테마에서만 키와 다릅니다.

| 키 | 표시 이름 |
| --- | --- |
| `Dark` | Dark *(기본값)* |
| `Light` | Light |
| `Rose` | Rose |
| `Plant` | Plant |
| `Red` | Red |
| `Indigo` | Indigo |
| `Sky` | Sky |
| `Violet` | Violet |
| `Amber` | Amber |
| `Emerald` | Emerald |
| `Midnight` | Midnight |
| `Crimson` | Crimson |
| `MonokaiPro` | Monokai Pro |
| `CottonCandy` | Cotton Candy |
| `Rainbow` | Rainbow |
| `NordTheme` | Nord |
| `DraculaTheme` | Dracula |
| `TokyoNight` | Tokyo Night |
| `OneDark` | One Dark |
| `Gruvbox` | Gruvbox |
| `SolarizedDark` | Solarized Dark |
| `MaterialDark` | Material Dark |
| `CyberpunkPink` | Cyberpunk Pink |
| `OceanBlue` | Ocean Blue |
| `NeonGreen` | Neon Green |
| `SoftPastel` | Soft Pastel |

## 사용자 지정 테마

### `ANUI:AddTheme(theme)`

`Name`으로 색인된 테마를 등록하고 이를 반환합니다. 추가한 후에는 `SetTheme(name)`으로 적용하십시오.

테마는 색상 키의 테이블입니다. 9개는 필수이며, `Toggle`과 `Checkbox`는 선택 사항입니다. 모든 색상은 `Color3`이며 — 보통 `Color3.fromHex("#…")`로 만듭니다.

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Name` | `string` | — | 고유한 테마 이름입니다. `SetTheme`에 전달하는 키입니다. |
| `Accent` | `Color3` | — | 기본 강조 / 패널 색상입니다. |
| `Dialog` | `Color3` | — | 대화 상자 및 팝업 배경입니다. |
| `Outline` | `Color3` | — | 테두리 / 스트로크 색상입니다. |
| `Text` | `Color3` | — | 기본 텍스트 색상입니다. |
| `Placeholder` | `Color3` | — | 흐린 / 자리 표시자 텍스트 색상입니다. |
| `Background` | `Color3` | — | 창 배경 색상입니다. |
| `Button` | `Color3` | — | 버튼 배경 색상입니다. |
| `Icon` | `Color3` | — | 아이콘 색조 색상입니다. |
| `Toggle` | `Color3` | *(선택)* | 토글 "켜짐" 색상입니다. |
| `Checkbox` | `Color3` | *(선택)* | 체크박스 "선택됨" 색상입니다. |

```lua
ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
    Toggle      = Color3.fromHex("#22d3ee"),
    Checkbox    = Color3.fromHex("#0ea5e9"),
})

ANUI:SetTheme("Oceanic")
```

::: tip
`AddTheme`로 추가한 테마는 즉시 `GetThemes()`에 나타나며 다른 내장 테마처럼 선택할 수 있습니다.
:::

## 그라데이션

### `ANUI:Gradient(stops, props)`

색상 정지점 집합으로 그라데이션 데이터 테이블을 만듭니다. `stops`는 `"0"`부터 `"100"`까지의 **위치 문자열**(그라데이션을 따라가는 백분율)로 색인됩니다. 각 정지점은 `{ Color = Color3, Transparency = number }`이며 — `Transparency`는 선택 사항이고 기본값은 `0`입니다. `props`는 결과에 병합되는 선택적 테이블로, 예를 들어 `{ Rotation = 45 }`입니다.

```lua
local sunset = ANUI:Gradient({
    ["0"]   = { Color = Color3.fromHex("#40c9ff") },
    ["50"]  = { Color = Color3.fromHex("#8b5cf6") },
    ["100"] = { Color = Color3.fromHex("#e81cff") },
}, {
    Rotation = 45,
})
```

::: warning 최소 두 개의 정지점
그라데이션에는 **두 개 이상**의 정지점이 필요합니다. 더 적게 전달하면 오류가 발생합니다.
:::

그라데이션은 라이브러리가 그라데이션 데이터를 받는 곳이면 어디든 들어갑니다 — 가장 흔하게는 요소의 `TitleGradient`와 `DescGradient` 필드입니다:

```lua
myTab:Button({
    Title = "Gradient Title",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Callback = function() end,
})
```

심지어 테마 색상을 구동할 수도 있습니다 — 내장 `Rainbow` 테마는 평평한 `Color3` 값 대신 그라데이션으로 정의되어 있습니다.

## 아크릴 블러

### `ANUI:ToggleAcrylic(enabled)`

창 뒤의 아크릴 블러를 켜거나 끕니다. 이는 창이 `Acrylic = true`로 생성되었을 때만 효과가 있으며, 그렇지 않으면 아무 동작도 하지 않습니다.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Acrylic = true,
})

ANUI:ToggleAcrylic(true)  -- enable blur
ANUI:ToggleAcrylic(false) -- disable blur
```

## 글꼴

### `ANUI:SetFont(fontId)`

UI 전체에서 사용되는 전역 글꼴을 설정합니다.

```lua
ANUI:SetFont("rbxassetid://12898095208")
```

## 전체 예제

사용자 지정 테마를 등록하고, 적용하고, 테마 전환기를 노출하고, 모든 변경을 기록합니다.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
})

local Window = ANUI:CreateWindow({
    Title = "Theme Demo",
    Theme = "Oceanic",
    Acrylic = true,
})

local Tab = Window:Tab({ Title = "Appearance", Icon = "palette" })

Tab:Paragraph({
    Title = "Theme switcher",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Desc = "Pick a theme below.",
})

Tab:Dropdown({
    Title = "Theme",
    Values = { "Dark", "Light", "Midnight", "Oceanic" },
    Value = "Oceanic",
    Callback = function(name)
        ANUI:SetTheme(name)
    end,
})

ANUI:OnThemeChange(function(themeKey)
    print("Active theme key:", themeKey)
    print("Display name:", ANUI:GetCurrentTheme())
end)
```
