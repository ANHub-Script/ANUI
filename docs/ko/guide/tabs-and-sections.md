# Tabs & Sections

Tab은 메뉴의 페이지이고, Window의 Section은 사이드바에서 Tab을 그룹화하는 헤더입니다.

::: warning 두 가지 Section을 구분하세요
`Window:Section()`은 사이드바용 그룹이고, `Tab:Section()`은 탭 내부의 접을 수 있는 콘텐츠 컨테이너입니다.
:::

## Tab 만들기

```lua
local Main = Window:Tab({
    Title = "Main",
    Icon = "house",
    Desc = "Main controls",
})
```

### 주요 옵션

| Field | 설명 |
| --- | --- |
| `Title` | Tab 이름 |
| `Desc` | 마우스 오버 시 표시되는 설명 |
| `Icon` | Lucide 아이콘 또는 Roblox asset |
| `Image` | Tab header 이미지 |
| `Locked` | 시작할 때 Tab 잠금 |
| `Profile` | Profile 카드 설정 |
| `SidebarProfile` | Profile을 사이드바에 표시 |

## Sidebar Section으로 Tab 그룹화

```lua
local Elements = Window:Section({ Title = "Elements" })

local ToggleTab = Elements:Tab({
    Title = "Toggle",
    Icon = "arrow-left-right",
})

local ButtonTab = Elements:Tab({
    Title = "Button",
    Icon = "mouse-pointer-click",
})
```

## Tab 메서드

```lua
Tab:Select()
Tab:ScrollToTheElement(index)
Tab:LockAll()
Tab:UnlockAll()
Tab:GetLocked()
Tab:GetUnlocked()
```

Tab, Section, Group에서는 동일한 Element 생성 API를 사용할 수 있습니다.

## 코드에서 Tab 선택

```lua
Window:SelectTab(MyTab.Index)
-- 또는
MyTab:Select()
```

[Elements →](../elements/)
