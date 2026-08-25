# Scheduler & Loops

ANUI includes a centralized loop scheduler: one runner thread drives every loop instead of a `task.spawn` per loop. Loops are drift-free and guarded against overlap, and the window-bound wrappers stop themselves automatically when the window closes or is destroyed.

## Window loops (recommended)

For almost everything, use the loop methods on the `Window`. They run on the window's own scheduler, so they **auto-stop when the window is closed or destroyed** — no manual cleanup needed.

### `Window:Loop(key, interval, callback, options?)`

Runs `callback` every `interval` seconds. `key` names the loop; reusing a key replaces the old loop. The callback receives **no arguments**.

```lua
Window:Loop("heartbeat", 1, function()
    print("tick")
end)
```

`options` is an optional table:

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `requireReady` | `boolean` | `false` | Only run the callback while the window is "ready" (open and not destroyed). |
| `predicate` | `function` | `nil` | Extra gate — the callback runs only when it returns `true`. |

### `Window:StatusLoop(key, interval, callback)`

A `Loop` with `requireReady` already on — ideal for refreshing on-screen text, since it pauses while the window is hidden. The callback receives **no arguments**.

```lua
Window:StatusLoop("clock", 1, function()
    -- `clock` is a Paragraph created earlier
    clock:SetDesc(os.date("%X"))
end)
```

### `Window:ManagedLoop(key, interval, predicate, callback)`

A raw loop with your own `predicate` and no window-ready gate. Each time the loop is due, `predicate` is called; `callback` runs only if it returns `true`. Both receive **no arguments**.

```lua
Window:ManagedLoop("guarded", 0.5, function()
    return workspace:FindFirstChild("Boss") ~= nil
end, function()
    -- runs only while a Boss exists
end)
```

### Controlling loops

- `Window:StopLoop(key)` — stop one loop by key.
- `Window:StopAllLoops()` — stop every loop on the window.
- `Window:IsLoopRunning(key)` — `true` if a loop with that key is registered.
- `Window:GetActiveLoopCount()` — number of registered loops.

### Connections & readiness

- `Window:AddConnection(connection)` — hand a `RBXScriptConnection` to the window so it is disconnected automatically on destroy.
- `Window:DisconnectAll()` — disconnect everything you added.
- `Window:IsReady()` — `true` while the window is open and not destroyed.

```lua
Window:AddConnection(
    game:GetService("RunService").Heartbeat:Connect(function()
        -- ...
    end)
)
```

## Standalone scheduler

Need loops that aren't tied to a window? Create your own scheduler with `ANUI:Scheduler`. You control when it stops via `ShouldStop`, and gate "ready" loops via `IsReady`.

### `ANUI:Scheduler(config)`

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `ShouldStop` | `function → boolean` | `nil` | Return `true` to kill the runner and drop every loop. |
| `IsReady` | `function → boolean` | `nil` | Gate for loops created with `requireReady`. Defaults to always-ready. |
| `MinWait` | `number` | `0.01` | Smallest allowed interval / tick. |
| `IdleWait` | `number` | `0.05` | Longest sleep when nothing is due. |

```lua
local sched = ANUI:Scheduler({
    ShouldStop = function() return not _G.MyScriptRunning end,
    IsReady = function() return game:IsLoaded() end,
})
```

Scheduler methods:

### `sched:Start(key, interval, predicate, callback)`

Raw loop. When due, `predicate` runs; `callback` runs only if it returns `true`.

### `sched:Loop(key, interval, callback, options?)`

Like `Window:Loop`. `options` accepts `requireReady` and `predicate`.

### `sched:StatusLoop(key, interval, callback)`

A `Loop` with `requireReady` on.

### Other methods

- `sched:Stop(key)` — stop one loop.
- `sched:StopAll()` — stop every loop.
- `sched:IsRunning(key)` — is a loop registered under this key?
- `sched:GetActiveCount()` — number of active loops.
- `sched:AddConnection(connection)` — track a connection for later cleanup.
- `sched:DisconnectAll()` — disconnect all tracked connections.
- `sched:Destroy()` — stop the runner, drop all loops, and disconnect all connections.

::: tip Drift-free & overlap-safe
Each loop schedules its next run from the target time, not from when the callback finishes — so a 1s loop keeps a steady 1s cadence no matter how long the work takes. A per-loop busy guard also stops a slow callback from overlapping itself: if one run is still going when the next is due, that tick is skipped.
:::

## Example: auto-farm toggle

A toggle starts and stops a `Window:Loop` that does the work, plus a `Window:StatusLoop` that keeps a Paragraph up to date. Both stop cleanly when the window is closed or destroyed.

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

See [Window Configuration](/guide/window-configuration) for the rest of the window lifecycle.
