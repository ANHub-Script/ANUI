# Dropdown

단일 또는 다중 선택, 항목별 아이콘, 설명, 구분선, 이미지를 지원하는 선택 가능한 목록입니다. 전역 콜백이 없으면 **액션 메뉴**로도 동작합니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Dropdown({
    Title = "Basic",
    Values = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Value = "Option 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dropdown"` | 기본 레이블입니다. [리치 텍스트 토큰](/elements/#rich-text-in-title-desc)을 지원합니다. |
| `Desc` | `string` | `nil` | 제목 아래에 표시할 선택적 설명입니다. |
| `Values` | `table` | `{}` | 옵션 목록 — 문자열 또는 항목 객체입니다 (아래 참고). `{ Type = "Divider" }`는 구분선을 삽입합니다. |
| `Value` | `string` \| `table` | `nil` | 초기 선택값: 문자열, 항목 객체, 또는 배열(`Multi`용)입니다. |
| `Multi` | `boolean` | `false` | 여러 항목을 선택할 수 있게 합니다. |
| `AllowNone` | `boolean` | `false` | 마지막으로 남은 항목의 선택 해제를 허용합니다 (`Multi`와 함께 사용할 때 가장 유용). |
| `SearchBarEnabled` | `boolean` | `false` | 메뉴 상단에 검색창을 표시합니다. |
| `MenuWidth` | `number` | `nil` | 고정 메뉴 너비(픽셀)입니다. 자동 맞춤을 원하면 생략하세요. |
| `Locked` | `boolean` | `false` | 잠금 오버레이를 표시하고 상호작용을 차단합니다. |
| `Image` | `string` \| `table` | `nil` | 드롭다운 행의 왼쪽 정렬 이미지입니다. |
| `ImageSize` | `number` \| `UDim2` | `30` | 이미지 크기 — 숫자, 또는 이미지 카드용 `UDim2`입니다. |
| `ImagePadding` | `number` | `—` | 항목 이미지 주변 간격입니다. |
| `IconThemed` | `boolean` | `false` | 현재 테마 색상으로 아이콘에 색조를 입힙니다. |
| `Color` | `Color3` \| `string` | `nil` | 색상 배경입니다 (테마 이름 또는 `Color3`). |
| `Callback` | `function` | `nil` | 선택 시 실행됩니다. 아래 시그니처 안내를 참고하세요. |
| `Flag` | `string` | `nil` | 설정 저장 키입니다. [설정 및 플래그](/features/config-and-flags)를 참고하세요. |
| `Buttons` | `table` | `nil` | 행에 렌더링되는 인라인 버튼입니다. |
| `TitleGradient` | `table` | `nil` | 제목 텍스트에 적용되는 그라디언트입니다. |
| `DescGradient` | `table` | `nil` | 설명 텍스트에 적용되는 그라디언트입니다. |

### 항목 객체

`Values`의 각 항목은 일반 문자열 대신 테이블이 될 수 있습니다:

| 필드 | 형식 | 설명 |
| --- | --- | --- |
| `Title` | `string` | 항목의 레이블입니다. |
| `Desc` | `string` | 제목 아래에 표시할 선택적 설명입니다. |
| `Icon` | `string` | 항목의 선택적 아이콘입니다. |
| `Images` | `table` | 이미지 id / 아이콘 이름의 배열, 또는 카드 테이블(`{ Card = true, Title, Quantity, Image, Gradient }`)입니다. |
| `Locked` | `boolean` | 이 특정 항목의 선택을 비활성화합니다. |
| `Callback` | `function` | 항목별 액션으로, **메뉴 모드**에서 사용됩니다 (아래 참고). |
| `Type` | `string` | 항목 사이에 구분선을 삽입하려면 (다른 필드 없이) `"Divider"`로 설정하세요. |

::: info 콜백 시그니처 — 그리고 메뉴 모드
- **단일 선택:** 콜백은 선택된 **값**을 받습니다 — 문자열 항목은 `string`, 객체 항목은 **원본 항목 객체**입니다 (`option.Title` 등을 읽으세요).
- **다중 선택** (`Multi = true`): 콜백은 선택된 항목의 **배열**을 받습니다.
- **전역 `Callback` 없음:** 드롭다운이 **액션 메뉴**가 됩니다 — 항목을 클릭하면 대신 *그 항목 자체의* `Callback`이 실행됩니다.
:::

드롭다운은 [공유 베이스](/elements/#shared-base)의 구성과 메서드도 상속합니다.

## 메서드

### `Dropdown:Select(items)`

현재 선택을 프로그램적으로 설정합니다. 단일 값을 전달하거나, `Multi`가 활성화된 경우 배열을 전달하세요.

```lua
myDropdown:Select("Blue")
myDropdown:Select({ "A", "C" }) -- multi
```

### `Dropdown:Refresh(values)`

전체 옵션 목록을 새 `values` 배열로 교체합니다.

```lua
myDropdown:Refresh({ "New 1", "New 2", "New 3" })
```

### `Dropdown:Edit(itemName, newData)`

이름으로 찾은 기존 항목을 `newData`의 필드로 갱신합니다.

```lua
myDropdown:Edit("Option 1", { Title = "Option 1 (updated)", Icon = "check" })
```

### `Dropdown:EditDrop(target, newData)`

드롭다운 컨테이너 자체를 편집하여, 지정한 `target`에 `newData`를 적용합니다.

### `Dropdown:SetValueImage(img)` / `Dropdown:SetValueIcon(img)`

현재 선택된 값 옆에 표시되는 이미지 또는 아이콘을 설정합니다.

### `Dropdown:SetMainImage(img, size)`

드롭다운의 왼쪽 정렬 이미지와 그 크기를 갱신합니다.

### `Dropdown:Open()` / `Dropdown:Close()`

메뉴를 열거나 닫습니다. `Open()`은 토글입니다 — 열려 있을 때 호출하면 메뉴가 닫힙니다.

### `Dropdown:Display()`

현재 선택에 대해 표시되는 값(텍스트, 아이콘, 이미지)을 새로 고칩니다.

### `Dropdown:Lock(text?)` / `Dropdown:Unlock()`

드롭다운을 잠그거나 잠금을 해제합니다. 선택적 `text`는 오버레이 레이블을 설정합니다.

## 예제

### 기본 문자열 목록

```lua
myTab:Dropdown({
    Title = "Basic",
    Desc = "Simple list of string values with a global selection callback.",
    Values = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Value = "Option 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

### 아이콘 사용 (객체 항목)

객체 항목의 경우 콜백은 **항목 객체**를 받습니다 — `option.Title`을 읽으세요.

```lua
myTab:Dropdown({
    Title = "With Icons",
    Desc = "Each option is an object containing a title and an icon.",
    Values = {
        { Title = "Bird",     Icon = "bird" },
        { Title = "House",    Icon = "house" },
        { Title = "Settings", Icon = "settings" },
        { Title = "Trash",    Icon = "trash-2" },
    },
    Value = { Title = "Bird", Icon = "bird" },
    Callback = function(option)
        print("Selected:", option.Title)
    end
})
```

### 설명 사용

```lua
myTab:Dropdown({
    Title = "With Descriptions",
    Values = {
        { Title = "Option A", Desc = "This is option A" },
        { Title = "Option B", Desc = "This is option B" },
        { Title = "Option C", Desc = "This is option C" },
    },
    Value = { Title = "Option A", Desc = "This is option A" },
    Callback = function(option) print(option.Title) end
})
```

### 다중 선택

`Multi = true`이면 콜백이 선택된 항목의 **배열**을 받습니다.

```lua
myTab:Dropdown({
    Title = "Multi-Select",
    Desc = "Select multiple options (callback returns an array of selected items).",
    Values = {
        { Title = "Category A", Icon = "folder" },
        { Title = "Category B", Icon = "folder" },
        { Title = "Category C", Icon = "folder" },
        { Title = "Category D", Icon = "folder" },
    },
    Multi = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do
            table.insert(titles, v.Title)
        end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### 구분선 그룹화

```lua
myTab:Dropdown({
    Title = "Divider Grouping",
    Desc = "Use Type = 'Divider' to split options into visually separated groups.",
    Values = {
        { Title = "Group 1 - A", Icon = "star" },
        { Title = "Group 1 - B", Icon = "star" },
        { Type = "Divider" },
        { Title = "Group 2 - A", Icon = "heart" },
        { Title = "Group 2 - B", Icon = "heart" },
    },
    Value = { Title = "Group 1 - A", Icon = "star" },
    Callback = function(option) print(option.Title) end
})
```

### 선택 없음 허용 (다중)

`AllowNone`을 사용하면 다중 선택에서 선택 항목을 0개까지 줄일 수 있습니다.

```lua
myTab:Dropdown({
    Title = "Multi (AllowNone)",
    Desc = "Multi-select with AllowNone lets you deselect the last remaining item.",
    Values = { { Title = "A" }, { Title = "B" }, { Title = "C" } },
    Value = "B",
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do table.insert(titles, v.Title) end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### 잠긴 항목

```lua
myTab:Dropdown({
    Title = "Locked Items",
    Desc = "Per-item locking disables selection for specific options.",
    Values = {
        { Title = "Usable A" },
        { Title = "Locked B", Locked = true },
        { Title = "Usable C" },
    },
    Value = "Usable A",
    Callback = function(value)
        print("Selected:", typeof(value) == "table" and value.Title or value)
    end
})
```

### 사용자 지정 너비와 검색창

```lua
myTab:Dropdown({
    Title = "Custom Width",
    Desc = "Manually define menu width instead of using auto-fit.",
    Values = { "Short", "Medium Option", "Veryyyyyyyy Long Option Name" },
    Value = "Short",
    MenuWidth = 250,
    SearchBarEnabled = true,
    Callback = function(value) print(value) end
})
```

### 프로그램적 선택

```lua
local colors = myTab:Dropdown({
    Title = "Programmatic Select",
    Values = { "Red", "Green", "Blue" },
    Value = "Red",
    Callback = function(value) print("Selected:", value) end
})

myTab:Button({
    Title = "Select 'Blue' via code",
    Callback = function()
        colors:Select("Blue")
    end
})
```

### 액션 메뉴 (항목별 콜백)

전역 `Callback`을 완전히 생략하고 각 항목에 자체 `Callback`을 지정하세요 — 드롭다운이 우클릭 액션 메뉴처럼 동작합니다.

```lua
myTab:Dropdown({
    Title = "Advanced Actions",
    Desc = "No global callback: items behave like an action menu using per-item callbacks.",
    Values = {
        { Title = "New file",  Desc = "Create a new file",   Icon = "file-plus", Callback = function() print("New file") end },
        { Title = "Copy link", Desc = "Copy the file link",  Icon = "copy",      Callback = function() print("Copy link") end },
        { Type = "Divider" },
        { Title = "Delete file", Desc = "Permanently delete the file", Icon = "trash", Callback = function() print("Delete file") end },
    }
})
```

::: tip 선택 유지하기
`Flag`을 추가하면 세션 간에 선택된 값을 저장하고 복원할 수 있습니다. [설정 및 플래그](/features/config-and-flags)를 참고하세요.
:::
