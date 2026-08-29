# 탭 및 섹션

탭은 메뉴의 페이지이며, 사이드바 섹션은 그 탭들을 이름이 붙은 묶음으로 그룹화합니다. 이 페이지에서는 `Window:Tab{}`으로 탭을 생성하고 `Window:Section{}`으로 그룹화하는 방법을 다룹니다.

::: info 서로 다른 두 가지 "Section" 개념
ANUI에는 모두 "Section"이라고 불리는 서로 관련 없는 두 가지가 있습니다 — 혼동하지 마세요:

1. **`Window:Section({ Title = ... })`**는 사이드바에서 탭을 그룹화하는 **사이드바 섹션 헤더**를 생성합니다. 그런 다음 `Section:Tab({...})`을 호출하여 그 아래에 탭을 추가합니다. 이 페이지가 문서화하는 것이 바로 이것입니다.
2. **`Tab:Section({...})`**는 **콘텐츠 요소**입니다 — 탭 *안에* 배치되는 접을 수 있는 컨테이너입니다. 이는 [Section (요소)](/elements/section)에서 문서화되어 있습니다.
:::

## 탭 생성

`Window:Tab{}`으로 탭을 생성합니다. 요소를 추가할 `Tab` 객체를 반환합니다.

```lua
local Main = Window:Tab({
    Title = "Main",
    Icon = "house",
    Desc = "Main controls", -- tooltip shown on hover
})
```

### 탭 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Tab"` | 탭 레이블입니다. |
| `Desc` | `string` | — | 탭에 마우스를 올렸을 때 표시되는 툴팁입니다. |
| `Icon` | `string` | — | 탭 아이콘(16px): Lucide 이름 또는 `rbxassetid://…`. |
| `Image` | `string` | — | 탭 헤더에 표시되는 배너 이미지(100px)입니다. |
| `IconThemed` | `boolean` | — | 테마 색상으로 아이콘을 물들입니다. |
| `Locked` | `boolean` | — | 탭을 잠긴 상태로 시작합니다. |
| `ShowTabTitle` | `boolean` | — | 콘텐츠 헤더에 탭 제목을 표시합니다. |
| `Profile` | `table` | — | 프로필 카드 구성(아래 참고). |
| `SidebarProfile` | `boolean` | — | 프로필을 콘텐츠 헤더 대신 사이드바 카드로 렌더링합니다. |

## 프로필

탭은 **프로필**을 표시할 수 있습니다 — 아바타, 배너, 상태 표시기, 배지 버튼을 담은 카드입니다. `Profile` 테이블을 전달하세요:

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | — | 표시 이름입니다. |
| `Desc` | `string` | — | 부제 / 역할 텍스트입니다. |
| `Avatar` | `string` | — | 아바타 이미지입니다. |
| `Banner` | `string` | — | 배너 이미지입니다. |
| `Status` | `boolean` | — | 상태 표시기를 표시합니다. |
| `Badges` | `array` | — | `{ Icon, Title, Desc, Callback }` 배지 버튼의 목록입니다. |
| `Sticky` | `boolean` | `true` | 스크롤하는 동안 프로필을 고정된 상태로 유지합니다. |

`SidebarProfile = true`로 설정하면 프로필을 사이드바의 카드로 렌더링하고, `false`(또는 생략)이면 탭 콘텐츠 안에 큰 헤더로 표시합니다.

```lua
local Badges = {
    {
        Icon = "geist:logo-discord",
        Title = "Discord",
        Desc = "Join ANHUB Discord",
        Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
            ANUI:Notify({ Title = "Discord", Content = "Invite link copied!", Icon = "geist:logo-discord", Duration = 3 })
        end
    },
    {
        Icon = "youtube",
        Desc = "Subscribe to YouTube",
        Callback = function()
            setclipboard("https://www.youtube.com/@ANHubRoblox")
            ANUI:Notify({ Title = "YouTube", Content = "Channel link copied!", Icon = "youtube", Duration = 3 })
        end
    },
}

-- Sidebar card (decorative, rendered in the sidebar)
Window:Tab({
    Profile = {
        Title = "AdityaNugraha",
        Desc = "Admin",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = true,
})

-- Regular tab with a large profile header
local UserTab = Window:Tab({
    Title = "Example Profile Content",
    Icon = "user",
    Profile = {
        Title = "User Settings",
        Desc = "Manage your account details here",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = false,
})

UserTab:Button({ Title = "Change Password", Callback = function() end })
UserTab:Button({ Title = "Log Out", Icon = "log-out", Callback = function() end })
```

## 사이드바 섹션으로 탭 그룹화

`Window:Section({ Title = ... })`는 사이드바에 이름이 붙은 헤더를 생성합니다. 반환된 섹션에서 `:Tab{}`을 호출하여 그 아래에 탭을 추가하세요.

```lua
local ElementsSection = Window:Section({ Title = "Elements" })

local ToggleTab = ElementsSection:Tab({ Title = "Toggle", Icon = "arrow-left-right" })
local ButtonTab = ElementsSection:Tab({ Title = "Button", Icon = "mouse-pointer-click" })

local OtherSection = Window:Section({ Title = "Other" })
local DiscordTab = OtherSection:Tab({ Title = "Discord" })
```

## 탭 메서드

- `Tab:Select()` — 이 탭으로 전환합니다.
- `Tab:ScrollToTheElement(index)` — 지정한 요소로 탭을 스크롤합니다.
- `Tab:LockAll()` — 탭의 모든 요소를 잠급니다.
- `Tab:UnlockAll()` — 탭의 모든 요소를 잠금 해제합니다.
- `Tab:GetLocked()` — 탭의 잠긴 요소를 가져옵니다.
- `Tab:GetUnlocked()` — 탭의 잠금 해제된 요소를 가져옵니다.

모든 요소 생성 메서드(`Tab:Button`, `Tab:Toggle`, …)는 탭에서도 사용할 수 있습니다 — [요소 개요](/elements/)를 참고하세요.

## 프로그래밍 방식으로 탭 선택

창을 통하거나 탭 자체를 통해 코드에서 탭을 전환합니다. `Window:SelectTab`은 인덱스를 받으며, 이 인덱스는 각 탭에서 `Tab.Index`로 제공됩니다:

```lua
Window:SelectTab(UpgradeTab.Index)
-- or, equivalently:
UpgradeTab:Select()
```

## 관련 항목

- [요소 개요](/elements/) — 탭에 넣을 수 있는 모든 것.
- [Section (요소)](/elements/section) — 탭 내부의 접을 수 있는 컨테이너.
