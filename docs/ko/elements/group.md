# Group

자식 요소를 세로로 쌓지 않고 **가로로** 배치하는 컨테이너입니다. 대화형 요소는 사용 가능한 너비를 동일하게 나누며, [Space](/ko/elements/space)와 [Divider](/ko/elements/divider)는 고정 너비를 유지합니다. Tab처럼 Group도 모든 요소 생성 메서드를 제공합니다.

## 기본 사용법

`Tab:Group({})`로 그룹을 만든 다음, 반환된 컨테이너에 요소를 추가합니다.

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local row = myTab:Group({})
row:Button({ Title = "Save", Callback = function() end })
row:Button({ Title = "Load", Callback = function() end })
```

두 버튼은 나란히 표시되며 각각 행 너비의 절반을 차지합니다.

## 구성

`Group`에는 구성이 필요 없습니다. 빈 테이블과 함께 `Tab:Group({})`를 호출하세요.

## Group에서 요소 만들기

Group은 컨테이너이므로 `Group:Button`, `Group:Toggle`, `Group:Dropdown` 등의 모든 요소 생성 메서드를 Tab과 똑같이 사용할 수 있습니다. 각 대화형 자식은 행 너비를 동일하게 나누고, `Space`와 `Divider` 자식은 늘어나지 않고 고정 너비를 유지합니다.

::: tip
Group 바로 위에 [Paragraph](/ko/elements/paragraph) 레이블을 두면 좋습니다. Paragraph를 아래 컨트롤 행을 설명하는 제목으로 사용하세요.
:::

## 예제

### 버튼 행

```lua
local buttons = myTab:Group({})
buttons:Button({
    Title = "Primary",
    Color = Color3.fromHex("#305dff"),
    Icon = "mouse-pointer-click",
    Callback = function() end,
})
buttons:Button({ Title = "Secondary", Icon = "mouse", Callback = function() end })
buttons:Button({ Title = "Locked", Icon = "lock", Locked = true, Callback = function() end })
```

### 나란히 놓은 두 드롭다운

```lua
myTab:Paragraph({ Title = "Dropdowns Group", Desc = "Two dropdowns grouped." })

local dropdowns = myTab:Group({})
dropdowns:Dropdown({
    Title = "Dropdown 1",
    Values = { "A", "B", "C" },
    Value = "A",
    Callback = function(v) print("Dropdown 1:", v) end,
})
dropdowns:Dropdown({
    Title = "Dropdown 2",
    Values = { { Title = "X", Desc = "First" }, { Title = "Y" }, { Title = "Z" } },
    SearchBarEnabled = true,
    Value = "Y",
    Callback = function(v) print("Dropdown 2:", v) end,
})
```

### 나란히 놓은 두 슬라이더

```lua
myTab:Paragraph({ Title = "Sliders Group", Desc = "Two sliders grouped." })

local sliders = myTab:Group({})
sliders:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(v) print("Volume:", v) end,
})
sliders:Slider({
    Title = "Brightness",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(v) print("Brightness:", v) end,
})
```

::: info
Group은 레이아웃 컨테이너이므로 대화형 공통 기반 동작을 상속하지 않습니다. 해당 동작은 Group 안에 배치하는 요소에 속합니다.
:::
