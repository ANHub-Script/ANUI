# Category

탭 내부에서 하위 탭 선택기 역할을 하는 가로 스크롤 옵션 스트립입니다. 옵션을 선택하고 콜백에서 일치하는 요소 그룹을 표시하며 나머지는 숨깁니다 — 여러 "페이지"의 컨트롤을 하나의 탭에 담는 간결한 방법입니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })

myTab:Category({
    Title = "Select Category",
    Default = "Weapons",
    Options = {
        { Title = "Weapons", Icon = "sword" },
        { Title = "Armor",   Icon = "shield" },
        { Title = "Potions", Icon = "flask-round" },
    },
    Callback = function(selected)
        print("Selected category:", selected)
    end,
})
```

## 구성

동작을 제어하는 필드:

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | 옵션 스트립 위에 표시할 레이블입니다. |
| `Desc` | `string` | `nil` | 제목 아래에 표시할 선택적 설명입니다. |
| `Options` | `array` | `{}` | 선택 가능한 옵션입니다. 각 항목은 **문자열** 또는 **옵션 테이블**입니다(아래 참조). |
| `Default` | `string` | first option | 생성 시 선택되는 옵션입니다. |
| `Callback` / `OnChanged` | `function` | `nil` | 선택이 변경될 때 실행합니다. **선택된 옵션의 이름(문자열)을 받습니다.** |

### 옵션 항목

`Options`의 각 항목은 일반 문자열이거나 테이블입니다:

| 필드 | 형식 | 설명 |
| --- | --- | --- |
| `Title` / `Name` / `Value` / `[1]` | `string` | 옵션의 이름 — 콜백에 전달되는 값입니다. |
| `Icon` / `Image` | `string` | 선택적 아이콘(Lucide 이름 또는 `rbxassetid://…`)입니다. |
| `IconSize` | `number` | 옵션별 아이콘 크기 재정의입니다. |
| `Desc` | `string` | 선택적 옵션별 설명입니다. |

옵션은 세밀한 아이콘 필드인 `ScaleType`, `KeepAspect` / `Native`, `NativeSize`, `Tint`도 가질 수 있습니다.

### 외관 및 레이아웃

이들은 모두 선택 사항이며, 기본값은 나머지 UI와 어울리도록 조정되어 있습니다.

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Height` | `number` | `45` | 전체 스트립의 높이입니다. |
| `ButtonHeight` | `number` | `32` | 각 옵션 버튼의 높이입니다. |
| `IconSize` | `number` | `18` | 기본 옵션 아이콘 크기입니다. |
| `TextSize` | `number` | `14` | 옵션 레이블 텍스트 크기입니다. |
| `Radius` | `number` | `8` | 옵션 버튼의 모서리 반경입니다. |
| `Gap` / `Padding` | `number` | `8` | 옵션 버튼 사이의 간격입니다. |
| `SidePadding` | `number` | `12` | 스트립의 좌우 끝의 여백입니다. |
| `ScrollSpeed` | `number` | `35` | 가로 스크롤 속도입니다. |
| `Transparency` | `number` | `0.5` | 비활성 버튼의 배경 투명도입니다. |
| `AutoCapture` | `boolean` | `true` | Category 이후에 생성된 요소를 현재 옵션에 자동으로 등록합니다(아래 참조). |
| `Sticky` | `boolean` | `nil` (auto) | 탭을 스크롤하는 동안 스트립을 고정합니다. |
| `ZIndex` | `number` | `6` | 스트립의 렌더링 순서입니다. |

::: details 고급 태그 및 아이콘 옵션
`ActiveTag` (`"Toggle"`), `InactiveTag` (`"Button"`), `TextTag` (`"Text"`)는 활성/비활성 버튼과 그 텍스트의 스타일을 지정하는 데 사용되는 테마 태그를 선택합니다. `IconScaleType`, `IconKeepAspect` (`true`), `IconAutoWidth` (`true`), `TintIcon` (auto)는 아이콘 렌더링을 세밀하게 조정하며, `ContentPadding` (`5`)와 `AlignWithContent` (`true`)는 스트립이 아래 요소와 어떻게 정렬되는지 제어합니다.
:::

## 메서드

### `Category:Select(name, silent?)`

이름으로 옵션을 선택합니다. `silent = true`를 전달하면 콜백을 발생시키지 않고 선택을 갱신합니다. `Category:SetValue(name, silent?)`의 별칭입니다.

```lua
category:Select("Armor")
category:Select("Potions", true) -- no callback
```

### `Category:GetSelected()`

현재 선택된 옵션 이름을 반환합니다.

```lua
print(category:GetSelected())
```

### `Category:SetCallback(fn)`

변경 콜백을 교체합니다.

```lua
category:SetCallback(function(name) print("now on", name) end)
```

### `Category:Add(name, ...)`

하나 이상의 기존 요소를 옵션 `name` 아래에 등록하여, 해당 옵션과 함께 표시/숨김되도록 합니다.

### `Category:Remove(item)`

이전에 추가한 요소의 등록을 해제합니다.

### `Category:GetElements(name?)`

옵션에 등록된 요소를 반환하며, `name`이 생략되면 전체를 반환합니다.

### `Category:Refresh()`

옵션이나 요소가 변경된 후 옵션 스트립을 다시 빌드합니다.

### `Category:Capture(name)` / `Category:StopCapture()`

새로 생성된 요소를 옵션 `name`으로 캡처하기 시작하고, 캡처를 중지합니다. 이는 `AutoCapture`의 수동 형태입니다.

### `Category:With(name, builder)`

`builder`를 실행하고 그것이 생성하는 모든 요소를 옵션 `name` 아래에 등록합니다.

```lua
category:With("Weapons", function()
    myTab:Toggle({ Title = "Auto Swing" })
    myTab:Slider({ Title = "Range", Value = { Min = 0, Max = 50, Default = 10 } })
end)
```

### `Category:AddOption(option, order?)`

새 선택 가능 옵션을 추가하며, 선택적으로 위치 `order`에 넣습니다.

### `Category:RemoveOption(name)`

이름으로 옵션을 제거합니다.

### `Category:SetOptions(options, newDefault?)`

모든 옵션을 교체하며, 선택적으로 `newDefault`를 선택합니다.

### `Category:GetOptions()`

현재 옵션을 반환합니다.

### `Category:SetHeight(h)`

스트립의 높이를 설정합니다.

### `Category:Destroy()`

Category를 제거합니다.

## 표시/숨김 패턴

::: tip 일반적인 사용법
일반적인 패턴은 옵션을 가진 Category를 생성한 다음, 콜백에서 **선택된 옵션의 요소를 표시하고 나머지는 숨기는** 것입니다. 요소를 직접 추적하며 각각의 `.Visible`을 토글하거나, 기본적으로 켜져 있는 `AutoCapture`에 의존할 수 있습니다. `AutoCapture`는 Category *이후에* 생성된 모든 요소를 현재 옵션에 연결하여 가시성을 자동으로 관리합니다. `Category:With(name, builder)`와 `Category:Capture(name)` / `Category:StopCapture()`는 그 캡처를 명시적으로 제어할 수 있게 해줍니다.
:::

아래 예제는 작은 "업그레이드 시스템"을 빌드합니다: `Categories` 테이블이 각 옵션의 요소를 저장하고, 헬퍼가 생성 시 이들을 숨기며, 콜백이 선택된 옵션의 요소만 표시합니다.

```lua
local UpgradeTab = Window:Tab({ Title = "Upgrade System", Icon = "hammer" })

-- Store elements per option so we can show/hide them
local Categories = { Yen = {}, Token = {}, Rank = {} }

-- Find an element's root frame (works across element types)
local function GetElementFrame(element)
    if element.ElementFrame then
        return element.ElementFrame
    elseif element.UIElements and element.UIElements.Main then
        return element.UIElements.Main
    end
    for _, value in pairs(element) do
        if type(value) == "table" and value.UIElements and value.UIElements.Main then
            return value.UIElements.Main
        end
    end
end

-- Register an element under a category and hide it by default
local function AddElement(category, element)
    table.insert(Categories[category], element)
    local frame = GetElementFrame(element)
    if frame then frame.Visible = false end
    return element
end

-- Show only the selected category's elements
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then frame.Visible = (name == selected) end
        end
    end
end

UpgradeTab:Category({
    Title = "Select Category",
    Default = "Yen",
    Options = {
        { Title = "Yen",   Icon = "coins" },
        { Title = "Token", Icon = "layers" },
        { Title = "Rank",  Icon = "shield" },
    },
    Callback = OnCategoryChanged,
})

UpgradeTab:Space({ Columns = 1 })

-- Build and register each category's elements
AddElement("Yen", UpgradeTab:Paragraph({ Title = "Yen Upgrades", Desc = "Upgrade stats using Yen" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" }))

AddElement("Token", UpgradeTab:Paragraph({ Title = "Token Upgrades", Desc = "Special upgrades using Tokens" }))
AddElement("Token", UpgradeTab:Toggle({ Title = "Yen Multiplier", Desc = "Cost: 5 Tokens | x1.5 Yen" }))

AddElement("Rank", UpgradeTab:Paragraph({ Title = "Rank Information", Desc = "Current Rank: S-Class" }))
AddElement("Rank", UpgradeTab:Button({ Title = "Rank Up", Icon = "arrow-up-circle" }))

-- Show the default category once on load
OnCategoryChanged("Yen")
```

이 기법에 대한 더 자세한 설명은 [Category 페이지 레시피](/examples/category-pages)를 참조하세요.
