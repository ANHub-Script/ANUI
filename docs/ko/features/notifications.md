# Notifications

슬라이드로 나타나 제목과 본문을 표시하고 카운트다운 후 스스로 사라지는 토스트 스타일 알림입니다. `ANUI:Notify{}`로 하나를 생성하십시오 — 창이 열려 있든 아니든 어디서나 작동합니다.

## 기본 사용법

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Notify({
    Title = "Welcome",
    Content = "Thanks for using ANUI!",
    Icon = "bell",
    Duration = 5,
})
```

::: info 본문 필드는 `Desc`가 아니라 `Content`입니다
알림 본문 텍스트는 `Content`로 설정합니다. `Notify`에는 `Desc` 필드가 없습니다 — `Desc`를 전달하면 본문이 표시되지 않습니다. 마찬가지로 이미지는 `Image`가 아니라 `Icon`(Lucide 아이콘 이름 **또는** `rbxassetid://…`)으로 설정합니다.
:::

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Notification"` | 토스트의 제목 텍스트입니다. |
| `Content` | `string` | `nil` | 제목 아래에 표시되는 본문 텍스트입니다. |
| `Icon` | `string` | `nil` | 선행 아이콘: Lucide 아이콘 이름 또는 `rbxassetid://…`입니다. (필드는 `Image`가 아니라 `Icon`입니다.) |
| `IconThemed` | `boolean` | `nil` | 아이콘을 테마의 아이콘 색상으로 물들입니다. |
| `Background` | `string` | `nil` | 토스트의 배경 이미지 id입니다. |
| `BackgroundImageTransparency` | `number` | `nil` | 배경 이미지의 투명도입니다 (`0` = 불투명). |
| `Duration` | `number` \| `false` | `5` | 자동 닫힘까지의 초 수이며, 진행 표시줄도 이 값으로 구동됩니다. 거짓 값(`false`/`nil`/`0`)은 자동으로 닫히지 않음을 의미합니다. |
| `Buttons` | `table` | `{}` | 객체에 저장되지만 **렌더링되지 않습니다** — 아래 경고를 참고하십시오. |

::: warning `Buttons`는 저장되지만 렌더링되지 않습니다
`Buttons` 필드는 허용되어 알림 객체에 보관되지만, 현재 빌드에서는 이를 **그리지 않습니다**. 상호작용식 선택이 필요하면 대신 [Dialog 또는 Popup](/features/dialogs-and-popups)을 여십시오.
:::

닫기(X) 버튼은 항상 존재하므로, `Duration`이 거짓 값일 때도 사용자가 토스트를 수동으로 닫을 수 있습니다.

## 반환된 객체

`ANUI:Notify{}`는 단일 메서드를 가진 알림 객체를 반환합니다:

### `Notification:Close()`

알림을 즉시 닫습니다. 코드에서 닫고 싶은 지속 토스트(`Duration = false`)에 유용합니다.

```lua
local note = ANUI:Notify({
    Title = "Working…",
    Content = "This stays open until you close it.",
    Icon = "loader",
    Duration = false, -- falsy → never auto-closes
})

task.delay(3, function()
    note:Close()
end)
```

## `ANUI:SetNotificationLower(bool)`

`true`일 때 알림 스택을 화면 아래쪽으로 옮기고, `false`일 때 기본 위치로 복원합니다. 설정 중에 한 번 호출하십시오.

```lua
ANUI:SetNotificationLower(true)
```

## 예제

### 간단한 알림

```lua
ANUI:Notify({
    Title = "Saved",
    Content = "Your settings have been saved.",
})
```

### 아이콘과 사용자 지정 지속 시간

```lua
ANUI:Notify({
    Title = "Discord",
    Content = "Invite link copied to clipboard!",
    Icon = "geist:logo-discord",
    Duration = 3,
})

ANUI:Notify({
    Title = "YouTube",
    Content = "Channel link copied!",
    Icon = "youtube",
    Duration = 3,
})
```

### 코드에서 닫는 지속 알림

토스트가 시간 초과되지 않도록 `Duration = false`로 설정하고, 반환된 객체를 보관한 뒤 작업이 끝나면 `:Close()`를 호출하십시오.

```lua
local loading = ANUI:Notify({
    Title = "Loading…",
    Content = "Fetching data from the server.",
    Icon = "loader",
    Duration = false,
})

-- later, once the work finishes
loading:Close()
ANUI:Notify({
    Title = "Done",
    Content = "Data loaded successfully.",
    Icon = "check",
    Duration = 4,
})
```

::: details 배경 이미지 사용
```lua
ANUI:Notify({
    Title = "Event started",
    Content = "A limited-time event is now live.",
    Icon = "party-popper",
    Background = "rbxassetid://84366761557806",
    BackgroundImageTransparency = 0.4,
    Duration = 6,
})
```
:::
