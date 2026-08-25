# Планировщик и циклы

ANUI включает централизованный планировщик циклов: все циклы приводит в движение один поток-раннер вместо отдельного `task.spawn` на каждый цикл. Циклы работают без дрифта и защищены от наложений, а обёртки, привязанные к окну, останавливаются сами, когда окно закрывается или уничтожается.

## Циклы окна (рекомендуется)

Практически для всего используйте методы циклов у `Window`. Они работают на собственном планировщике окна, поэтому **останавливаются автоматически, когда окно закрыто или уничтожено** — ручная очистка не нужна.

### `Window:Loop(key, interval, callback, options?)`

Выполняет `callback` каждые `interval` секунд. `key` задаёт имя цикла; повторное использование того же key заменяет старый цикл. Callback **не получает аргументов**.

```lua
Window:Loop("heartbeat", 1, function()
    print("tick")
end)
```

`options` — необязательная таблица:

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `requireReady` | `boolean` | `false` | Выполнять callback только пока окно «готово» (открыто и не уничтожено). |
| `predicate` | `function` | `nil` | Дополнительный фильтр — callback выполняется только когда он возвращает `true`. |

### `Window:StatusLoop(key, interval, callback)`

`Loop` с уже включённым `requireReady` — идеален для обновления текста на экране, поскольку приостанавливается, пока окно скрыто. Callback **не получает аргументов**.

```lua
Window:StatusLoop("clock", 1, function()
    -- `clock` — это Paragraph, созданный ранее
    clock:SetDesc(os.date("%X"))
end)
```

### `Window:ManagedLoop(key, interval, predicate, callback)`

Сырой цикл с вашим собственным `predicate` и без фильтра готовности окна. Каждый раз, когда цикл срабатывает, вызывается `predicate`; `callback` выполняется только если тот вернул `true`. Оба **не получают аргументов**.

```lua
Window:ManagedLoop("guarded", 0.5, function()
    return workspace:FindFirstChild("Boss") ~= nil
end, function()
    -- выполняется только пока существует Boss
end)
```

### Управление циклами

- `Window:StopLoop(key)` — остановить один цикл по key.
- `Window:StopAllLoops()` — остановить все циклы окна.
- `Window:IsLoopRunning(key)` — `true`, если цикл с таким key зарегистрирован.
- `Window:GetActiveLoopCount()` — количество зарегистрированных циклов.

### Соединения и готовность

- `Window:AddConnection(connection)` — передать `RBXScriptConnection` окну, чтобы оно автоматически отключилось при уничтожении.
- `Window:DisconnectAll()` — отключить всё, что вы добавили.
- `Window:IsReady()` — `true`, пока окно открыто и не уничтожено.

```lua
Window:AddConnection(
    game:GetService("RunService").Heartbeat:Connect(function()
        -- ...
    end)
)
```

## Автономный планировщик

Нужны циклы, не привязанные к окну? Создайте свой планировщик через `ANUI:Scheduler`. Вы управляете тем, когда он останавливается, через `ShouldStop`, и фильтруете «готовые» циклы через `IsReady`.

### `ANUI:Scheduler(config)`

| Field | Type | Default | Описание |
| --- | --- | --- | --- |
| `ShouldStop` | `function → boolean` | `nil` | Верните `true`, чтобы убить раннер и сбросить все циклы. |
| `IsReady` | `function → boolean` | `nil` | Фильтр для циклов, созданных с `requireReady`. По умолчанию считается всегда готовым. |
| `MinWait` | `number` | `0.01` | Наименьший допустимый интервал / тик. |
| `IdleWait` | `number` | `0.05` | Самый долгий сон, когда ничего не запланировано. |

```lua
local sched = ANUI:Scheduler({
    ShouldStop = function() return not _G.MyScriptRunning end,
    IsReady = function() return game:IsLoaded() end,
})
```

Методы планировщика:

### `sched:Start(key, interval, predicate, callback)`

Сырой цикл. Когда наступает срок, выполняется `predicate`; `callback` выполняется только если тот вернул `true`.

### `sched:Loop(key, interval, callback, options?)`

Как `Window:Loop`. `options` принимает `requireReady` и `predicate`.

### `sched:StatusLoop(key, interval, callback)`

`Loop` с включённым `requireReady`.

### Прочие методы

- `sched:Stop(key)` — остановить один цикл.
- `sched:StopAll()` — остановить все циклы.
- `sched:IsRunning(key)` — зарегистрирован ли цикл под этим key?
- `sched:GetActiveCount()` — количество активных циклов.
- `sched:AddConnection(connection)` — отслеживать соединение для последующей очистки.
- `sched:DisconnectAll()` — отключить все отслеживаемые соединения.
- `sched:Destroy()` — остановить раннер, сбросить все циклы и отключить все соединения.

::: tip Без дрифта и с защитой от наложений
Каждый цикл планирует следующий запуск от целевого времени, а не от момента завершения callback — поэтому цикл на 1 с сохраняет ровный ритм в 1 с независимо от того, сколько длится работа. Кроме того, отдельный для каждого цикла флаг занятости не даёт медленному callback наложиться на самого себя: если один запуск ещё выполняется, когда наступает срок следующего, этот тик пропускается.
:::

## Пример: переключатель авто-фарма

Toggle запускает и останавливает `Window:Loop`, который делает работу, плюс `Window:StatusLoop`, который держит Paragraph в актуальном состоянии. Оба аккуратно останавливаются, когда окно закрывается или уничтожается.

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
            -- выполнять работу ~2 раза в секунду
            Window:Loop("autofarm", 0.5, function()
                kills += 1
                -- ... здесь ваши действия фарма ...
            end)

            -- обновлять paragraph 4 раза в секунду, только пока UI открыт
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

Об остальном, что касается жизненного цикла окна, см. [Настройку окна](/ru/guide/window-configuration).
