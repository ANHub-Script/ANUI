# 通知

スライドインしてタイトルと本文を表示し、カウントダウン後に自動で閉じるトースト形式の通知。`ANUI:Notify{}` で作成します —— ウィンドウが開いているかどうかに関係なく、どこからでも使えます。

## 基本的な使い方

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Notify({
    Title = "ようこそ",
    Content = "ANUI をご利用いただきありがとうございます！",
    Icon = "bell",
    Duration = 5,
})
```

::: info 本文のフィールドは `Desc` ではなく `Content`
通知の本文テキストは `Content` で設定します。`Notify` に `Desc` フィールドはありません —— `Desc` を渡しても本文は表示されません。同様に、画像は `Image` ではなく `Icon`（Lucide のアイコン名 **または** `rbxassetid://…`）で設定します。
:::

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Notification"` | トーストの見出しテキスト。 |
| `Content` | `string` | `nil` | タイトルの下に表示される本文テキスト。 |
| `Icon` | `string` | `nil` | 先頭のアイコン: Lucide のアイコン名または `rbxassetid://…`。（フィールド名は `Image` ではなく `Icon` です。） |
| `IconThemed` | `boolean` | `nil` | テーマのアイコン色でアイコンを着色します。 |
| `Background` | `string` | `nil` | トーストの背景画像の ID。 |
| `BackgroundImageTransparency` | `number` | `nil` | 背景画像の透明度（`0` で不透明）。 |
| `Duration` | `number` \| `false` | `5` | 自動で閉じるまでの秒数。プログレスバーもこれに従います。偽値（`false` / `nil` / `0`）にすると自動では閉じません。 |
| `Buttons` | `table` | `{}` | オブジェクトには保持されますが、**描画されません** —— 下の警告を参照してください。 |

::: warning `Buttons` は保持されるが描画されない
`Buttons` フィールドは受け付けられ通知オブジェクトに保持されますが、現在のビルドでは**描画されません**。操作を伴う選択肢が必要な場合は、代わりに[ダイアログやポップアップ](/ja/features/dialogs-and-popups)を開いてください。
:::

閉じる（X）ボタンは常に表示されるため、`Duration` が偽値でもユーザーが手動でトーストを閉じられます。

## 返されるオブジェクト

`ANUI:Notify{}` は、メソッドを 1 つ持つ通知オブジェクトを返します。

### `Notification:Close()`

通知を即座に閉じます。コードから閉じたい常駐トースト（`Duration = false`）に便利です。

```lua
local note = ANUI:Notify({
    Title = "処理中…",
    Content = "閉じるまで表示され続けます。",
    Icon = "loader",
    Duration = false, -- 偽値 → 自動では閉じない
})

task.delay(3, function()
    note:Close()
end)
```

## `ANUI:SetNotificationLower(bool)`

`true` で通知スタックを画面の下寄りに移動し、`false` で既定の位置に戻します。セットアップ時に一度呼び出してください。

```lua
ANUI:SetNotificationLower(true)
```

## 例

### シンプルな通知

```lua
ANUI:Notify({
    Title = "保存しました",
    Content = "設定が保存されました。",
})
```

### アイコンと表示時間を指定する

```lua
ANUI:Notify({
    Title = "Discord",
    Content = "招待リンクをクリップボードにコピーしました！",
    Icon = "geist:logo-discord",
    Duration = 3,
})

ANUI:Notify({
    Title = "YouTube",
    Content = "チャンネルのリンクをコピーしました！",
    Icon = "youtube",
    Duration = 3,
})
```

### コードから閉じる常駐通知

`Duration = false` にするとトーストはタイムアウトしません。返されたオブジェクトを保持しておき、処理が終わったら `:Close()` を呼びます。

```lua
local loading = ANUI:Notify({
    Title = "読み込み中…",
    Content = "サーバーからデータを取得しています。",
    Icon = "loader",
    Duration = false,
})

-- 処理が完了したら
loading:Close()
ANUI:Notify({
    Title = "完了",
    Content = "データを正常に読み込みました。",
    Icon = "check",
    Duration = 4,
})
```

::: details 背景画像を使う
```lua
ANUI:Notify({
    Title = "イベント開始",
    Content = "期間限定イベントが開催中です。",
    Icon = "party-popper",
    Background = "rbxassetid://84366761557806",
    BackgroundImageTransparency = 0.4,
    Duration = 6,
})
```
:::
