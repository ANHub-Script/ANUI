# ダイアログとポップアップ

ANUI には、モーダルなプロンプトを表示する方法が 2 つあります。既存のウィンドウに紐づく **`Window:Dialog{}`** と、どこからでも開ける独立したモーダル **`ANUI:Popup{}`** です。どちらもタイトル、本文、ボタンの行を表示します。

## Dialog と Popup の違い

| | `Window:Dialog{}` | `ANUI:Popup{}` |
| --- | --- | --- |
| 描画先 | 既存のウィンドウの内側に描画 | 独立した画面レベルのモーダル |
| ウィンドウが必要か | 必要 —— `Window` に対して呼びます | 不要 —— `ANUI` に対して直接呼びます |
| 幅の制御 | `Width`（デフォルト `320`） | — |
| サムネイル画像 | — | `Thumbnail` |
| 返されるオブジェクト | — | メソッドなし。ボタンが閉じてくれます |
| 向いている用途 | すでに作ったメニューに紐づく確認ダイアログ | ウィンドウの前 / ウィンドウなしでの手早いプロンプト |

## `Window:Dialog{}`

ウィンドウに固定されたモーダルダイアログを開きます。メニュー内の確認や小さな選択に使います。

### 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | — | ダイアログの見出し。 |
| `Content` | `string` | — | タイトルの下の本文テキスト。 |
| `Icon` | `string` | — | 先頭のアイコン: Lucide のアイコン名または `rbxassetid://…`。 |
| `Width` | `number` | `320` | ダイアログの幅（ピクセル）。 |
| `Buttons` | `table` | — | ボタン定義の配列（下記参照）。 |

`Buttons` の各エントリーはテーブルです。

| フィールド | 型 | 説明 |
| --- | --- | --- |
| `Title` | `string` | ボタンのラベル。 |
| `Icon` | `string` | ボタンに表示する任意のアイコン。 |
| `Callback` | `function` | ボタンがクリックされたときに実行されます。**引数は受け取りません。** |
| `Variant` | `string` | 見た目のスタイル: `"Primary"`、`"Secondary"`、`"White"`。 |

```lua
Window:Dialog({
    Title = "セーブを削除しますか？",
    Content = "この操作は取り消せません。",
    Buttons = {
        { Title = "削除", Variant = "Primary", Icon = "trash", Callback = function()
            print("deleted")
        end },
    },
})
```

## `ANUI:Popup{}`

ウィンドウを必要とせず、独立したモーダルを即座に開きます。ボタンはクリックされるとポップアップを閉じ、返されるオブジェクトにはメソッドがありません。

### 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dialog"` | ポップアップの見出し。 |
| `Content` | `string` | `nil` | タイトルの下の本文テキスト。 |
| `Icon` | `string` | `nil` | 先頭のアイコン: Lucide のアイコン名または `rbxassetid://…`。 |
| `IconThemed` | `boolean` | — | テーマのアイコン色でアイコンを着色します。 |
| `Thumbnail` | `table` | — | 大きなプレビュー画像: `{ Image, Title? }`。 |
| `Buttons` | `table` | — | ボタン定義の配列（Dialog と同じ形）。 |

`Buttons` の各エントリーはテーブルです。

| フィールド | 型 | 説明 |
| --- | --- | --- |
| `Title` | `string` | ボタンのラベル。 |
| `Icon` | `string` | ボタンに表示する任意のアイコン。 |
| `Callback` | `function` | クリック時に実行され、その後ポップアップが閉じます。**引数は受け取りません。** |
| `Variant` | `string` | 見た目のスタイル: `"Primary"`、`"Secondary"`、`"White"`。 |

::: info Popup は即座に開く
`ANUI:Popup{}` は呼び出された時点でモーダルを表示します。`:Open()` するものは何もなく、返されたオブジェクトにもメソッドはありません —— ボタンが自動で閉じてくれるからです。
:::

## 例

### ボタンのバリアント（Dialog）

3 つのバリアント —— `Primary`、`Secondary`、`White` —— を 1 つのダイアログにまとめた例。

```lua
Window:Dialog({
    Title = "UI ボタンのバリアント",
    Content = "Button のバリアントを紹介します。",
    Buttons = {
        { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
        { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
        { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
    },
})
```

### 確認ダイアログ（キャンセル / 確定）

```lua
Window:Dialog({
    Title = "設定をリセットしますか？",
    Content = "すべての項目が初期値に戻ります。",
    Icon = "rotate-ccw",
    Width = 340,
    Buttons = {
        { Title = "キャンセル", Variant = "Secondary", Callback = function()
            print("cancelled")
        end },
        { Title = "確定", Variant = "Primary", Icon = "check", Callback = function()
            print("confirmed")
        end },
    },
})
```

### シンプルなポップアップ

```lua
ANUI:Popup({
    Title = "ようこそ",
    Content = "スクリプトをお試しいただきありがとうございます。最新情報はコミュニティでお知らせします。",
    Icon = "hand",
    Thumbnail = {
        Image = "rbxassetid://84366761557806",
        Title = "ANHub",
    },
    Buttons = {
        { Title = "Discord をコピー", Variant = "Primary", Icon = "link", Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
        end },
        { Title = "閉じる", Variant = "Secondary", Callback = function() end },
    },
})
```
