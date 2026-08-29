# Scheduler & Loops

ANUI는 여러 Loop를 하나의 중앙 scheduler에서 관리합니다. Window에 연결된 Loop는 Window가 닫히거나 제거될 때 자동으로 정리됩니다.

## 권장 방식: Window Loop

```lua
Window:Loop("heartbeat", 1, function()
    print("tick")
end)
```

`key`가 같은 Loop를 다시 등록하면 기존 Loop가 교체됩니다.

### 옵션

```lua
Window:Loop("guarded", 0.5, function()
    print("running")
end, {
    requireReady = true,
    predicate = function()
        return true
    end,
})
```

## StatusLoop

UI가 열려 있을 때 상태 텍스트를 갱신하는 용도로 적합합니다.

```lua
Window:StatusLoop("clock", 1, function()
    status:SetDesc(os.date("%X"))
end)
```

## 관리

```lua
Window:StopLoop("heartbeat")
Window:StopAllLoops()
Window:IsLoopRunning("heartbeat")
Window:GetActiveLoopCount()
```

Window가 제거될 때 연결된 Loop도 정리되므로 별도의 cleanup 코드를 줄일 수 있습니다.

## Standalone Scheduler

Window와 독립적인 Loop가 필요하면 `ANUI:Scheduler()`를 사용할 수 있습니다.

```lua
local scheduler = ANUI:Scheduler({
    ShouldStop = function()
        return not _G.MyScriptRunning
    end,
})

scheduler:Loop("worker", 1, function()
    print("work")
end)
```

주요 메서드: `Start`, `Loop`, `StatusLoop`, `Stop`, `StopAll`, `IsRunning`, `GetActiveCount`, `AddConnection`, `DisconnectAll`, `Destroy`.

::: tip
Loop callback이 오래 걸리더라도 같은 Loop가 동시에 중복 실행되지 않도록 busy guard가 적용됩니다.
:::
