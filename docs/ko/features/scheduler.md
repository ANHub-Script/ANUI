# Scheduler & Loops

ANUI에는 중앙 집중식 루프 스케줄러가 포함되어 있습니다: 루프마다 `task.spawn`을 사용하는 대신 하나의 러너 스레드가 모든 루프를 구동합니다. 루프는 드리프트가 없고 겹침이 방지되며, 창에 바인딩된 래퍼는 창이 닫히거나 소멸될 때 자동으로 스스로 멈춥니다.

## 창 루프 (권장)

거의 모든 경우에 `Window`의 루프 메서드를 사용하십시오. 이들은 창 자체의 스케줄러에서 실행되므로 **창이 닫히거나 소멸될 때 자동으로 멈춥니다** — 수동 정리가 필요 없습니다.

### `Window:Loop(key, interval, callback, options?)`

`interval` 초마다 `callback`을 실행합니다. `key`는 루프에 이름을 붙이며, 키를 재사용하면 이전 루프를 대체합니다. 콜백은 **인수를 받지 않습니다**.

```lua
Window:Loop("heartbeat", 1, function()
    print("tick")
end)
```

`options`는 선택적 테이블입니다:

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `requireReady` | `boolean` | `false` | 창이 "준비됨"(열려 있고 소멸되지 않음) 상태일 때만 콜백을 실행합니다. |
| `predicate` | `function` | `nil` | 추가 게이트 — 콜백은 `true`를 반환할 때만 실행됩니다. |

### `Window:StatusLoop(key, interval, callback)`

`requireReady`가 이미 켜진 `Loop`입니다 — 창이 숨겨져 있는 동안 멈추므로 화면상의 텍스트를 새로 고치기에 이상적입니다. 콜백은 **인수를 받지 않습니다**.

```lua
Window:StatusLoop("clock", 1, function()
    -- `clock` is a Paragraph created earlier
    clock:SetDesc(os.date("%X"))
end)
```

### `Window:ManagedLoop(key, interval, predicate, callback)`

창 준비 게이트 없이 사용자 지정 `predicate`를 사용하는 원시 루프입니다. 루프가 실행될 때마다 `predicate`가 호출되며, `callback`은 그것이 `true`를 반환할 때만 실행됩니다. 둘 다 **인수를 받지 않습니다**.

```lua
Window:ManagedLoop("guarded", 0.5, function()
    return workspace:FindFirstChild("Boss") ~= nil
end, function()
    -- runs only while a Boss exists
end)
```

### 루프 제어

- `Window:StopLoop(key)` — 키로 루프 하나를 멈춥니다.
- `Window:StopAllLoops()` — 창의 모든 루프를 멈춥니다.
- `Window:IsLoopRunning(key)` — 해당 키로 등록된 루프가 있으면 `true`입니다.
- `Window:GetActiveLoopCount()` — 등록된 루프의 개수입니다.

### 연결 및 준비 상태

- `Window:AddConnection(connection)` — `RBXScriptConnection`을 창에 넘겨 소멸 시 자동으로 연결이 끊어지게 합니다.
- `Window:DisconnectAll()` — 추가한 모든 것의 연결을 끊습니다.
- `Window:IsReady()` — 창이 열려 있고 소멸되지 않은 동안 `true`입니다.

```lua
Window:AddConnection(
    game:GetService("RunService").Heartbeat:Connect(function()
        -- ...
    end)
)
```

## 독립형 스케줄러

창에 묶이지 않은 루프가 필요하신가요? `ANUI:Scheduler`로 자신만의 스케줄러를 만드십시오. `ShouldStop`으로 멈추는 시점을 제어하고, `IsReady`로 "준비됨" 루프를 게이트합니다.

### `ANUI:Scheduler(config)`

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `ShouldStop` | `function → boolean` | `nil` | 러너를 종료하고 모든 루프를 버리려면 `true`를 반환하십시오. |
| `IsReady` | `function → boolean` | `nil` | `requireReady`로 생성된 루프의 게이트입니다. 기본값은 항상 준비됨입니다. |
| `MinWait` | `number` | `0.01` | 허용되는 최소 간격 / 틱입니다. |
| `IdleWait` | `number` | `0.05` | 실행할 것이 없을 때의 최장 대기 시간입니다. |

```lua
local sched = ANUI:Scheduler({
    ShouldStop = function() return not _G.MyScriptRunning end,
    IsReady = function() return game:IsLoaded() end,
})
```

스케줄러 메서드:

### `sched:Start(key, interval, predicate, callback)`

원시 루프입니다. 실행될 때 `predicate`가 실행되고, `callback`은 그것이 `true`를 반환할 때만 실행됩니다.

### `sched:Loop(key, interval, callback, options?)`

`Window:Loop`과 같습니다. `options`는 `requireReady`와 `predicate`를 받습니다.

### `sched:StatusLoop(key, interval, callback)`

`requireReady`가 켜진 `Loop`입니다.

### 기타 메서드

- `sched:Stop(key)` — 루프 하나를 멈춥니다.
- `sched:StopAll()` — 모든 루프를 멈춥니다.
- `sched:IsRunning(key)` — 이 키로 등록된 루프가 있습니까?
- `sched:GetActiveCount()` — 활성 루프의 개수입니다.
- `sched:AddConnection(connection)` — 나중에 정리할 연결을 추적합니다.
- `sched:DisconnectAll()` — 추적된 모든 연결을 끊습니다.
- `sched:Destroy()` — 러너를 멈추고, 모든 루프를 버리고, 모든 연결을 끊습니다.

::: tip 드리프트 없음 & 겹침 방지
각 루프는 콜백이 끝나는 시점이 아니라 목표 시각에서 다음 실행을 예약합니다 — 따라서 1초 루프는 작업이 얼마나 걸리든 안정적인 1초 주기를 유지합니다. 루프별 사용 중 가드도 느린 콜백이 자기 자신과 겹치는 것을 막습니다: 다음 실행이 예정된 시점에 한 실행이 아직 진행 중이면 그 틱은 건너뜁니다.
:::

## 예제: 오토 파밍 토글

토글이 작업을 수행하는 `Window:Loop`을 시작하고 멈추며, Paragraph를 최신 상태로 유지하는 `Window:StatusLoop`도 함께 사용합니다. 둘 다 창이 닫히거나 소멸될 때 깔끔하게 멈춥니다.

```lua
local Window = ANUI:CreateWindow({ Title = "Farm Hub" })
local Tab = Window:Tab({ Title = "Farm", Icon = "sword" })

local status = Tab:Paragraph({
    Title = "Auto Farm",
    Desc = "Status: idle",
})

local farming = false
local kills = 0

Tab:Toggle({
    Title = "Auto Farm",
    Value = false,
    Callback = function(on)
        farming = on

        if on then
            -- do the work ~2x per second
            Window:Loop("autofarm", 0.5, function()
                kills += 1
                -- ... your farming actions here ...
            end)

            -- refresh the paragraph 4x per second, only while the UI is open
            Window:StatusLoop("autofarm-status", 0.25, function()
                status:SetDesc(("Status: running · %d kills"):format(kills))
            end)
        else
            Window:StopLoop("autofarm")
            Window:StopLoop("autofarm-status")
            status:SetDesc("Status: idle")
        end
    end,
})
```

나머지 창 수명 주기는 [Window Configuration](/guide/window-configuration)을 참고하십시오.
