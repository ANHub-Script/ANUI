# Dialogs & Popups

ANUI에는 두 가지 모달 방식이 있습니다.

- `Window:Dialog{}` — 기존 Window에 연결된 모달
- `ANUI:Popup{}` — Window 없이 사용할 수 있는 독립 모달

## Dialog

```lua
Window:Dialog({
    Title = "Delete save?",
    Content = "이 작업은 되돌릴 수 없습니다.",
    Icon = "trash",
    Buttons = {
        {
            Title = "Delete",
            Variant = "Primary",
            Callback = function()
                print("deleted")
            end,
        },
        {
            Title = "Cancel",
            Variant = "Secondary",
            Callback = function() end,
        },
    },
})
```

버튼의 `Callback`은 인자를 받지 않습니다. `Variant`는 `Primary`, `Secondary`, `White`를 지원합니다.

## Popup

```lua
ANUI:Popup({
    Title = "Welcome",
    Content = "ANUI를 사용해 주셔서 감사합니다.",
    Icon = "hand",
    Buttons = {
        {
            Title = "Close",
            Variant = "Secondary",
            Callback = function() end,
        },
    },
})
```

Popup은 호출 즉시 표시됩니다.

[영문 전체 레퍼런스 →](../../features/dialogs-and-popups)
