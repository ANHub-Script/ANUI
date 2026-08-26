# スケジューラーとループ

ANUI には集中管理されたループスケジューラーが含まれています。ループごとに `task.spawn` するのではなく、1 本のランナースレッドがすべてのループを駆動します。ループはドリフトがなく、多重実行も防止され、ウィンドウに紐づくラッパーはウィンドウが閉じられたり破棄されたときに自動で停止します。

## ウィンドウのループ（推奨）

ほとんどの用途では、`Window` のループメソッドを使ってください。ウィンドウ自身のスケジューラーで動くため、**ウィンドウが閉じられたり破棄されたときに自動停止**します —— 手動での後片付けは不要です。

### `Window:Loop(key, interval, callback, options?)`

`interval` 秒ごとに `callback` を実行します。`key` はループの名前で、同じキーを再利用すると古いループが置き換えられます。コールバックは**引数を受け取りません**。

```lua
Window:Loop("heartbeat", 1, function()
    print("tick")
end)
```

`options` は任意のテーブルです。

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `requireReady` | `boolean` | `false` | ウィンドウが「準備完了」（開いており破棄されていない）のときにのみコールバックを実行します。 |
| `predicate` | `function` | `nil` | 追加の条件 —— `true` を返したときのみコールバックが実行されます。 |

### `Window:StatusLoop(key, interval, callback)`

`requireReady` があらかじめ有効な `Loop` です —— ウィンドウが隠れている間は一時停止するため、画面上のテキストを更新するのに最適です。コールバックは**引数を受け取りません**。

```lua
Window:StatusLoop("clock", 1, function()
    -- `clock` は先に作成した Paragraph
    clock:SetDesc(os.date("%X"))
end)
```

### `Window:ManagedLoop(key, interval, predicate, callback)`

独自の `predicate` を持ち、ウィンドウの準備状態による制限がない素のループです。ループの実行時刻になるたびに `predicate` が呼ばれ、`true` を返した場合にのみ `callback` が実行されます。どちらも**引数を受け取りません**。

```lua
Window:ManagedLoop("guarded", 0.5, function()
    return workspace:FindFirstChild("Boss") ~= nil
end, function()
    -- Boss が存在する間だけ実行される
end)
```

### ループを制御する

- `Window:StopLoop(key)` —— キーを指定してループを 1 つ停止します。
- `Window:StopAllLoops()` —— そのウィンドウのすべてのループを停止します。
- `Window:IsLoopRunning(key)` —— そのキーのループが登録されていれば `true`。
- `Window:GetActiveLoopCount()` —— 登録されているループの数。

### 接続と準備状態

- `Window:AddConnection(connection)` —— `RBXScriptConnection` をウィンドウに預けると、破棄時に自動で切断されます。
- `Window:DisconnectAll()` —— 追加したものすべてを切断します。
- `Window:IsReady()` —— ウィンドウが開いており破棄されていない間は `true`。

```lua
Window:AddConnection(
    game:GetService("RunService").Heartbeat:Connect(function()
        -- ...
    end)
)
```

## 独立したスケジューラー

ウィンドウに紐づかないループが必要な場合は、`ANUI:Scheduler` で自分のスケジューラーを作れます。停止のタイミングは `ShouldStop` で制御し、「準備完了」を要求するループは `IsReady` で制限します。

### `ANUI:Scheduler(config)`

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `ShouldStop` | `function → boolean` | `nil` | `true` を返すとランナーを停止し、すべてのループを破棄します。 |
| `IsReady` | `function → boolean` | `nil` | `requireReady` で作られたループの条件。既定では常に準備完了とみなされます。 |
| `MinWait` | `number` | `0.01` | 許容される最小の間隔 / ティック。 |
| `IdleWait` | `number` | `0.05` | 実行すべきものがないときの最長スリープ時間。 |

```lua
local sched = ANUI:Scheduler({
    ShouldStop = function() return not _G.MyScriptRunning end,
    IsReady = function() return game:IsLoaded() end,
})
```

スケジューラーのメソッド:

### `sched:Start(key, interval, predicate, callback)`

素のループ。実行時刻になると `predicate` が呼ばれ、`true` を返した場合にのみ `callback` が実行されます。

### `sched:Loop(key, interval, callback, options?)`

`Window:Loop` と同様です。`options` は `requireReady` と `predicate` を受け付けます。

### `sched:StatusLoop(key, interval, callback)`

`requireReady` が有効な `Loop` です。

### その他のメソッド

- `sched:Stop(key)` —— ループを 1 つ停止します。
- `sched:StopAll()` —— すべてのループを停止します。
- `sched:IsRunning(key)` —— このキーでループが登録されているか。
- `sched:GetActiveCount()` —— 動作中のループの数。
- `sched:AddConnection(connection)` —— 後で片付けるために接続を追跡します。
- `sched:DisconnectAll()` —— 追跡中のすべての接続を切断します。
- `sched:Destroy()` —— ランナーを停止し、すべてのループを破棄し、すべての接続を切断します。

::: tip ドリフトなし・多重実行なし
各ループは、コールバックが終わった時点ではなく目標時刻を基準に次回の実行を予約します —— そのため処理にどれだけ時間がかかっても、1 秒のループは 1 秒の間隔を保ちます。さらにループごとのビジーガードにより、遅いコールバックが自分自身と重なることもありません。次の実行時刻になっても前回の実行が続いている場合、そのティックはスキップされます。
:::

## 例: オートファームのトグル

Toggle で処理を行う `Window:Loop` と、Paragraph を更新し続ける `Window:StatusLoop` を開始・停止します。どちらもウィンドウが閉じられたり破棄されたときにきれいに停止します。

```lua
local Window = ANUI:CreateWindow({ Title = "Farm Hub" })
local Tab = Window:Tab({ Title = "ファーム", Icon = "sword" })

local status = Tab:Paragraph({
    Title = "オートファーム",
    Desc = "状態: 待機中",
})

local farming = false
local kills = 0

Tab:Toggle({
    Title = "オートファーム",
    Value = false,
    Callback = function(on)
        farming = on

        if on then
            -- 1 秒あたり約 2 回処理する
            Window:Loop("autofarm", 0.5, function()
                kills += 1
                -- ... ここにファームの処理を書く ...
            end)

            -- UI が開いている間だけ、1 秒あたり 4 回 Paragraph を更新する
            Window:StatusLoop("autofarm-status", 0.25, function()
                status:SetDesc(("状態: 実行中 · %d 体撃破"):format(kills))
            end)
        else
            Window:StopLoop("autofarm")
            Window:StopLoop("autofarm-status")
            status:SetDesc("状態: 待機中")
        end
    end,
})
```

ウィンドウのライフサイクルの残りについては、[ウィンドウ設定](/ja/guide/window-configuration)を参照してください。
