# 테마 및 외관

ANUI에는 26개의 내장 Theme이 있으며 Custom Theme도 등록할 수 있습니다.

## Window 생성 시 Theme 지정

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Theme = "Midnight",
})
```

## 런타임에 Theme 변경

```lua
ANUI:SetTheme("Emerald")
print(ANUI:GetCurrentTheme())
```

사용 가능한 Theme은 `ANUI:GetThemes()`로 확인할 수 있습니다.

## Theme 변경 감지

```lua
ANUI:OnThemeChange(function(themeKey)
    print("Theme changed:", themeKey)
end)
```

## 주요 내장 Theme

`Dark`, `Light`, `Rose`, `Plant`, `Red`, `Indigo`, `Sky`, `Violet`, `Amber`, `Emerald`, `Midnight`, `Crimson`, `MonokaiPro`, `CottonCandy`, `Rainbow`, `NordTheme`, `DraculaTheme`, `TokyoNight`, `OneDark`, `Gruvbox`, `SolarizedDark`, `MaterialDark`, `CyberpunkPink`, `OceanBlue`, `NeonGreen`, `SoftPastel`을 사용할 수 있습니다.

## Custom Theme

```lua
ANUI:AddTheme({
    Name = "Oceanic",
    Accent = Color3.fromHex("#0e2a3b"),
    Dialog = Color3.fromHex("#0b2231"),
    Outline = Color3.fromHex("#7dd3fc"),
    Text = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background = Color3.fromHex("#071722"),
    Button = Color3.fromHex("#0284c7"),
    Icon = Color3.fromHex("#38bdf8"),
})

ANUI:SetTheme("Oceanic")
```

## Gradient

```lua
local gradient = ANUI:Gradient({
    ["0"] = { Color = Color3.fromHex("#40c9ff") },
    ["100"] = { Color = Color3.fromHex("#e81cff") },
}, { Rotation = 45 })
```

최소 두 개의 color stop이 필요합니다.

## Acrylic

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Acrylic = true,
})

ANUI:ToggleAcrylic(true)
```

[영문 Theme 전체 레퍼런스 →](../../features/themes)
