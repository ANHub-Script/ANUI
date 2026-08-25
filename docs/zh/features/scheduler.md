# 调度器与循环

ANUI 内置了一个集中式的循环调度器：由一个 runner 线程驱动所有循环，而不是为每个循环开一个 `task.spawn`。循环不会产生时间漂移，也有防重叠保护；而与窗口绑定的包装方法会在窗口关闭或被销毁时自动停止。

## 窗口循环（推荐）

绝大多数情况下，请使用 `Window` 上的循环方法。它们运行在窗口自己的调度器上，因此会**在窗口关闭或被销毁时自动停止** —— 无需手动清理。

### `Window:Loop(key, interval, callback, options?)`

每隔 `interval` 秒运行一次 `callback`。`key` 用于给循环命名；重复使用同一个 key 会替换掉旧的循环。回调**不接受任何参数**。

```lua
Window:Loop("heartbeat", 1, function()
    print("tick")
end)
```

`options` 是一个可选的表：

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `requireReady` | `boolean` | `false` | 仅在窗口处于“就绪”状态（已打开且未被销毁）时运行回调。 |
| `predicate` | `function` | `nil` | 额外的门控 —— 只有当它返回 `true` 时回调才会运行。 |

### `Window:StatusLoop(key, interval, callback)`

一个已经开启 `requireReady` 的 `Loop` —— 非常适合刷新屏幕上的文字，因为窗口被隐藏时它会暂停。回调**不接受任何参数**。

```lua
Window:StatusLoop("clock", 1, function()
    -- `clock` 是之前创建的一个 Paragraph
    clock:SetDesc(os.date("%X"))
end)
```

### `Window:ManagedLoop(key, interval, predicate, callback)`

一个原始循环，使用你自己的 `predicate`，并且没有窗口就绪门控。每次循环到期时都会调用 `predicate`；只有它返回 `true` 时 `callback` 才会运行。两者都**不接受任何参数**。

```lua
Window:ManagedLoop("guarded", 0.5, function()
    return workspace:FindFirstChild("Boss") ~= nil
end, function()
    -- 只在 Boss 存在时运行
end)
```

### 控制循环

- `Window:StopLoop(key)` —— 按 key 停止某一个循环。
- `Window:StopAllLoops()` —— 停止窗口上的所有循环。
- `Window:IsLoopRunning(key)` —— 若已注册使用该 key 的循环则为 `true`。
- `Window:GetActiveLoopCount()` —— 已注册循环的数量。

### 连接与就绪状态

- `Window:AddConnection(connection)` —— 把一个 `RBXScriptConnection` 托管给窗口，销毁时会自动断开。
- `Window:DisconnectAll()` —— 断开你托管的所有连接。
- `Window:IsReady()` —— 窗口已打开且未被销毁时为 `true`。

```lua
Window:AddConnection(
    game:GetService("RunService").Heartbeat:Connect(function()
        -- ...
    end)
)
```

## 独立调度器

需要不与窗口绑定的循环？用 `ANUI:Scheduler` 创建你自己的调度器。你通过 `ShouldStop` 控制它何时停止，并通过 `IsReady` 为“就绪”循环设置门控。

### `ANUI:Scheduler(config)`

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `ShouldStop` | `function → boolean` | `nil` | 返回 `true` 会终止 runner 并丢弃所有循环。 |
| `IsReady` | `function → boolean` | `nil` | 为使用 `requireReady` 创建的循环提供门控。默认始终就绪。 |
| `MinWait` | `number` | `0.01` | 允许的最小间隔／tick。 |
| `IdleWait` | `number` | `0.05` | 没有任务到期时的最长休眠时间。 |

```lua
local sched = ANUI:Scheduler({
    ShouldStop = function() return not _G.MyScriptRunning end,
    IsReady = function() return game:IsLoaded() end,
})
```

调度器的方法：

### `sched:Start(key, interval, predicate, callback)`

原始循环。到期时会运行 `predicate`；只有它返回 `true` 时 `callback` 才会运行。

### `sched:Loop(key, interval, callback, options?)`

与 `Window:Loop` 相同。`options` 接受 `requireReady` 和 `predicate`。

### `sched:StatusLoop(key, interval, callback)`

一个开启了 `requireReady` 的 `Loop`。

### 其他方法

- `sched:Stop(key)` —— 停止某一个循环。
- `sched:StopAll()` —— 停止所有循环。
- `sched:IsRunning(key)` —— 这个 key 下是否注册了循环？
- `sched:GetActiveCount()` —— 活动循环的数量。
- `sched:AddConnection(connection)` —— 追踪一个连接，以便稍后清理。
- `sched:DisconnectAll()` —— 断开所有被追踪的连接。
- `sched:Destroy()` —— 停止 runner、丢弃所有循环，并断开所有连接。

::: tip 无漂移且防重叠
每个循环都是从目标时间点、而不是从回调结束的时刻来安排下一次运行 —— 因此一个 1 秒的循环无论工作耗时多久都能保持稳定的 1 秒节奏。此外，每个循环各自的 busy 保护会防止较慢的回调与自己重叠：如果下一次到期时上一次仍在运行，那一个 tick 会被跳过。
:::

## 示例：auto-farm 开关

一个开关负责启动和停止执行实际工作的 `Window:Loop`，外加一个让 Paragraph 保持最新的 `Window:StatusLoop`。两者都会在窗口关闭或被销毁时干净地停止。

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
            -- 每秒执行大约 2 次工作
            Window:Loop("autofarm", 0.5, function()
                kills += 1
                -- ... 在这里写你的 farming 操作 ...
            end)

            -- 每秒刷新 paragraph 4 次，仅在 UI 打开时
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

窗口生命周期的其余内容请参见[窗口配置](/zh/guide/window-configuration)。
