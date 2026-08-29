# 카테고리 페이지

일반적인 패턴 하나: 상단의 가로 스트립으로 전환되는 여러 요소 "페이지"를 한 탭에 표시하는 것입니다. 이것은 [Category](/elements/category) 요소로 만듭니다. 아래 레시피는 데모의 **Upgrade System**을 각색한 것입니다.

## 작동 방식

Category는 스크롤 가능한 옵션 행을 렌더링합니다. 사용자가 하나를 선택하면 선택된 옵션의 이름과 함께 `Callback`이 발생합니다. 각 옵션 이름을 해당 옵션에 속한 요소들에 매핑하는 테이블을 유지하고, 모든 요소의 `.Visible`을 전환하여 활성 페이지만 표시합니다.

## 1. 카테고리별로 요소 추적하기

카테고리, 요소의 프레임을 찾는 헬퍼, 그리고 요소를 카테고리 아래에 등록하는(기본적으로 숨김) 헬퍼를 정의합니다.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "My Hub", Folder = "MyHub" })
local Tab = Window:Tab({ Title = "Upgrades", Icon = "hammer" })

-- One bucket of elements per category.
local Categories = {
    Combat = {},
    Farming = {},
    Settings = {},
}

-- Reach the element's root frame so we can toggle its visibility.
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
    return nil
end

-- Register an element under a category and hide it initially.
local function AddElement(categoryName, element)
    if Categories[categoryName] then
        table.insert(Categories[categoryName], element)
        local frame = GetElementFrame(element)
        if frame then
            frame.Visible = false
        end
    end
    return element
end

-- Show only the selected category's elements; hide the rest.
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        local isVisible = (name == selected)
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then
                frame.Visible = isVisible
            end
        end
    end
end
```

## 2. Category 스트립 추가하기

페이지마다 옵션 하나씩으로 Category를 만듭니다. `Default`는 처음 표시되는 페이지를 설정하고, `Callback`은 사용자가 전환할 때마다 `OnCategoryChanged`를 실행합니다.

```lua
Tab:Category({
    Title = "Select Category",
    Default = "Combat",
    Options = {
        { Title = "Combat", Icon = "sword" },
        { Title = "Farming", Icon = "coins" },
        { Title = "Settings", Icon = "settings" },
    },
    Callback = OnCategoryChanged, -- receives the selected option name (string)
})

Tab:Space({ Columns = 1 }) -- a little breathing room below the strip
```

## 3. 각 페이지를 구성하고 요소 등록하기

평소처럼 요소를 생성하되, 각각을 `AddElement("<category>", ...)`로 감싸서 올바른 버킷에 들어가고 숨겨진 상태로 시작하도록 합니다.

```lua
-- Combat
AddElement("Combat", Tab:Paragraph({ Title = "Combat", Desc = "Fighting options" }))
AddElement("Combat", Tab:Toggle({ Title = "God Mode", Callback = function(v) print(v) end }))
AddElement("Combat", Tab:Slider({ Title = "Damage", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end }))

-- Farming
AddElement("Farming", Tab:Paragraph({ Title = "Farming", Desc = "Auto-farm options" }))
AddElement("Farming", Tab:Toggle({ Title = "Auto Farm", Callback = function(v) print(v) end }))
AddElement("Farming", Tab:Dropdown({ Title = "Target", Values = { "Coins", "Gems", "XP" }, Value = "Coins", Callback = function(v) print(v) end }))

-- Settings
AddElement("Settings", Tab:Paragraph({ Title = "Settings", Desc = "Menu settings" }))
AddElement("Settings", Tab:Toggle({ Title = "Auto Save", Callback = function(v) print(v) end }))
```

## 4. 기본 페이지 표시하기

Category는 `Default`에서 시작하므로, `OnCategoryChanged`를 한 번 호출하여 처음에 다른 페이지들을 숨깁니다.

```lua
OnCategoryChanged("Combat")
```

이것이 전체 패턴입니다: 이제 옵션을 전환하면 어떤 요소 페이지가 표시될지가 바뀝니다.

## 대안: 내장 캡처

Category는 수동 `Categories` 테이블 대신 요소를 대신 추적할 수 있습니다. `AutoCapture`가 활성화되어 있으면(기본값) Category 이후에 생성된 요소가 자동으로 연결됩니다. 가장 깔끔한 방법은 `:With(name, builder)`입니다 — 빌더 안에서 생성된 모든 것이 해당 옵션에 할당되며, Category는 전환할 때마다 각 그룹을 표시/숨김 처리합니다:

```lua
local cat = Tab:Category({
    Title = "Select Category",
    Default = "Combat",
    Options = { "Combat", "Farming", "Settings" },
})

cat:With("Combat", function()
    Tab:Toggle({ Title = "God Mode", Callback = function(v) print(v) end })
    Tab:Slider({ Title = "Damage", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end })
end)

cat:With("Farming", function()
    Tab:Toggle({ Title = "Auto Farm", Callback = function(v) print(v) end })
end)

cat:With("Settings", function()
    Tab:Toggle({ Title = "Auto Save", Callback = function(v) print(v) end })
end)
```

::: tip
`:Capture(name)` / `:StopCapture()`는 빌더 없이 동일한 작업을 수행합니다 — 이 둘 사이에 요소 생성 범위를 묶으면 됩니다. `:GetElements(name?)`을 사용하면 카테고리가 추적 중인 항목을 다시 읽을 수 있습니다. 전체 메서드 목록은 [Category](/elements/category) 페이지를 참고하세요.
:::
