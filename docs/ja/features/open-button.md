# オープンボタン

オープンボタンは、UI を閉じた後にもう一度開くためのフローティングのピル型ボタンです。ウィンドウ作成時に設定するか、後から実行中に編集できます。

## 作成時に設定する

`CreateWindow` に `OpenButton` テーブルを渡します。

```lua
local Window = ANUI:CreateWindow({
    Title = "マイ Hub",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | — | ボタンに表示されるテキスト。 |
| `Icon` | `string` | — | タイトルの前に表示するアイコン名または `rbxassetid://…`。 |
| `Enabled` | `boolean` | — | `false` にするとオープンボタンを完全に無効化します。 |
| `Position` | `UDim2` | — | 画面上のボタンの位置。 |
| `OnlyIcon` | `boolean` | `false` | アイコンのみの丸いボタン（Delta 風）。タイトルとドラッグハンドルを隠します。 |
| `Draggable` | `boolean` | — | ユーザーがボタンをドラッグして動かせるようにします。 |
| `OnlyMobile` | `boolean` | — | 未指定ならモバイル専用。`false` にするとデスクトップでも表示されます。 |
| `CornerRadius` | `UDim` | `UDim.new(1, 0)` | ボタンの角の丸み（既定は完全な丸み）。 |
| `StrokeThickness` | `number` | `2` | ボタンの輪郭線の太さ。 |
| `Color` | `ColorSequence` | `#40c9ff → #e81cff` | ボタンの輪郭線のグラデーション。 |
| `Size` | `UDim2` | 自動 | ボタンのサイズ。既定では内容に合わせて自動調整されます。 |

::: info OnlyMobile の既定値
`OnlyMobile` を設定しない場合、ボタンは**モバイル専用**として振る舞います。上の例のように `OnlyMobile = false` を指定すると、デスクトップでも表示されます。
:::

::: tip Color はグラデーション
`Color` は `Color3` ではなく `ColorSequence` を取り、ボタンの輪郭線にグラデーションとして適用されます。`ColorSequence.new(colorA, colorB)` で作成してください。
:::

## 実行中に編集する

### `Window:EditOpenButton(config)`

オープンボタンに変更を適用します。編集は**累積的にマージ**されます —— 渡さなかったフィールドは現在の値が保たれます。

```lua
Window:EditOpenButton({
    Title = "メニューを開く",
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
})
```

## オープンボタンのメソッド

オープンボタンのオブジェクトは `Window.OpenButtonMain` で参照できます。

### `Window.OpenButtonMain:SetIcon(icon)`

ボタンのアイコンを差し替えます（アイコン名または `rbxassetid://…`）。

```lua
Window.OpenButtonMain:SetIcon("menu")
```

### `Window.OpenButtonMain:Visible(visible)`

ボタンを表示 / 非表示します。

```lua
Window.OpenButtonMain:Visible(false) -- 非表示
Window.OpenButtonMain:Visible(true)  -- 表示
```

### `Window.OpenButtonMain:Edit(config)`

`Window:EditOpenButton` と同じで、渡した設定を現在の設定にマージします。コードとして読みやすい方を使ってください。

```lua
Window.OpenButtonMain:Edit({ Title = "再度開く" })
```

## 例

サンプルスクリプトをもとにした例: 丸みのあるドラッグ可能なピル型ボタンに独自のタイトルと緑〜黄のグラデーション輪郭を付け、デスクトップとモバイルの両方で表示します。

```lua
local Window = ANUI:CreateWindow({
    Title = ".an hub | ANUI Library",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

その他のウィンドウ設定は[ウィンドウ設定](/ja/guide/window-configuration)を参照してください。
