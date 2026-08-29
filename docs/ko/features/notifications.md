# 알림

`ANUI:Notify{}`를 사용하면 화면에 Toast 스타일 알림을 표시할 수 있습니다. Window가 없어도 호출할 수 있습니다.

```lua
ANUI:Notify({
    Title = "Welcome",
    Content = "ANUI에 오신 것을 환영합니다!",
    Icon = "bell",
    Duration = 5,
})
```

## 주요 옵션

| Field | 설명 |
| --- | --- |
| `Title` | 알림 제목 |
| `Content` | 알림 본문. `Desc`가 아닙니다. |
| `Icon` | Lucide 아이콘 또는 `rbxassetid://...` |
| `IconThemed` | 현재 Theme 색상 적용 |
| `Background` | 배경 이미지 |
| `BackgroundImageTransparency` | 배경 이미지 투명도 |
| `Duration` | 자동 닫힘 시간. `false`이면 자동으로 닫히지 않음 |

::: info 반환 객체
`ANUI:Notify()`는 알림 객체를 반환합니다. 지속 알림을 직접 닫으려면 `notification:Close()`를 사용하세요.
:::

```lua
local notification = ANUI:Notify({
    Title = "Loading...",
    Content = "데이터를 가져오는 중입니다.",
    Icon = "loader",
    Duration = false,
})

task.delay(3, function()
    notification:Close()
end)
```

## 알림 위치 변경

```lua
ANUI:SetNotificationLower(true)
```

`true`이면 알림 스택을 화면 아래쪽으로 이동합니다.

[Dialogs & Popups →](./dialogs-and-popups)
