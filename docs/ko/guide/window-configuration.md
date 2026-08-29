# Window 설정

`ANUI:CreateWindow{}`는 모든 ANUI 메뉴의 루트입니다. 하나의 설정 테이블을 전달해 창을 생성합니다.

::: info 하나의 Window만 지원
한 번에 하나의 Window만 존재할 수 있습니다. 두 번째 `CreateWindow()` 호출은 경고 후 `nil`을 반환합니다.
:::

## 기본 예제

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
    Theme = "Dark",
})
```

## 주요 설정

| Field | Type | 설명 |
| --- | --- | --- |
| `Title` | `string` | 창 제목 |
| `Author` | `string` | 제목 아래에 표시되는 부제목 |
| `Icon` | `string` | Lucide 아이콘 이름 또는 `rbxassetid://...` |
| `Folder` | `string` | Config/Key 저장 폴더 |
| `Size` | `UDim2` | 초기 창 크기 |
| `Resizable` | `boolean` | 창 크기 조절 허용 여부 |
| `AutoScale` | `boolean` | 자동 UI 스케일링, 모바일에 유용 |
| `Theme` | `string` | 사용할 테마. 기본값은 `Dark` |
| `Transparent` | `boolean` | 투명 배경 |
| `Acrylic` | `boolean` | Acrylic blur 효과 |
| `Background` | `Color3` / image / gradient | 사용자 지정 배경 |
| `ToggleKey` | `Enum.KeyCode` | 창 표시/숨김 단축키 |
| `HideSearchBar` | `boolean` | 요소 검색창 숨김 |
| `OpenButton` | `table` | 닫힌 창을 다시 여는 floating button |
| `KeySystem` | `table` | Key System 설정 |

## 런타임 제어

```lua
Window:Open()
Window:Close()
Window:Toggle()
Window:SetTitle("New Title")
Window:SetAuthor("by ANHub")
Window:SetUIScale(1)
Window:SetToggleKey(Enum.KeyCode.G)
Window:CollapseSidebar()
Window:ExpandSidebar()
```

## Lock

```lua
Window:LockAll()
Window:UnlockAll()
```

모든 요소를 잠그거나 다시 활성화할 수 있습니다.

## Topbar

```lua
Window:CreateTopbarButton(
    "MyButton",
    "settings",
    function()
        print("clicked")
    end
)
```

## 관련 문서

- [Tabs & Sections](./tabs-and-sections)
- [Themes](../features/themes)
- [Config & Flags](../features/config-and-flags)
- [Open Button](../features/open-button)
