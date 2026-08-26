# Slider

ドラッグできる数値スライダー。ステップ指定と手入力にも対応します。値には範囲と刻みを設定でき、整数または小数として整形されます。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Slider({
    Title = "音量",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        print("Volume:", value)
    end
})
```

## 設定

範囲は `Value` テーブルで指定するか、フラットな `Min` / `Max` / `Default` フィールドで指定できます。

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Slider"` | メインのラベル。[リッチテキストトークン](/ja/elements/#title-と-desc-のリッチテキスト)に対応。 |
| `Desc` | `string` | `nil` | タイトルの下に表示する任意の説明。 |
| `Value` | `table` | `nil` | 範囲のテーブル `{ Min, Max, Default }`。下のフィールドの代わりに使えます。 |
| `Min` | `number` | `0` | 下限（`Value` を使わない場合）。 |
| `Max` | `number` | `100` | 上限（`Value` を使わない場合）。 |
| `Default` | `number` | `0` | 初期値（`Value` を使わない場合）。 |
| `Step` | `number` | `1` | 刻み幅。**小数**の step（例: `0.1`）を指定すると、スライダーは小数モードになります。 |
| `Locked` | `boolean` | `false` | ロックのオーバーレイを表示し、操作をブロックします。 |
| `Callback` | `function` | `nil` | 変更時に実行されます。**整形済みの文字列**を受け取ります（下記参照）。 |
| `Flag` | `string` | `nil` | 設定を永続化するためのキー。[設定と Flag](/ja/features/config-and-flags)を参照。 |
| `Buttons` | `table` | `nil` | 行内に描画されるインラインボタン。 |
| `TitleGradient` | `table` | `nil` | タイトルテキストに適用するグラデーション。 |
| `DescGradient` | `table` | `nil` | 説明テキストに適用するグラデーション。 |

::: warning コールバックの引数は文字列です
`Callback` に渡される値は数値ではなく**整形済みの文字列**です。整数スライダーは切り捨てられた整数（`"50"`）を、小数スライダー（小数の `Step`）は `"%.2f"` 形式の文字列（`"0.50"`）を受け取ります。計算に使う前に `tonumber(value)` で変換してください。
:::

Slider は[共通のベース](/ja/elements/#共通のベース)の設定とメソッドも継承します。

## 値の整形とスナップ

- **スナップ** —— 生の位置は最も近いステップにスナップします: `floor(raw / Step + 0.5) * Step`。
- **整数と小数** —— 整数の `Step` は値を整数に切り捨て、小数の `Step` は `"%.2f"` で整形します。
- **手入力** —— 値はテキストフィールドにもなっています。クリックして数値を入力し、**Enter** で確定します。
- **永続化** —— `Flag` を設定すると、config は `Value.Default` を整形済みの文字列として保存します。

## メソッド

### `Slider:Set(value, input?)`

スライダーの値をコードから設定します。`value` は範囲内の数値、`input?` は手入力のテキストフィールド由来の変更であることを示す任意のフラグです。

```lua
mySlider:Set(75)
```

### `Slider:SetMin(n)`

スライダーの下限を更新します。

```lua
mySlider:SetMin(10)
```

### `Slider:SetMax(n)`

スライダーの上限を更新します。

```lua
mySlider:SetMax(200)
```

### `Slider:Lock()` / `Slider:Unlock()`

スライダーをロック / ロック解除します。

```lua
mySlider:Lock()
mySlider:Unlock()
```

## 例

### 整数スライダー（音量 0–100）

数値として使う前に、文字列を変換することを忘れないでください。

```lua
myTab:Slider({
    Title = "音量",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        local n = tonumber(value) -- value は "50" のような文字列
        print("Volume:", n)
    end
})
```

### 小数スライダー（小数の Step）

`Step` に `0.1` を指定するとスライダーは小数モードになり、コールバックは `"0.50"` のような値を受け取ります。

```lua
myTab:Slider({
    Title = "明るさ",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(value)
        print("Brightness:", value) -- "0.50"
    end
})
```

### Flag で永続化する

```lua
myTab:Slider({
    Title = "Slider",
    Flag = "SliderTest",
    Step = 1,
    Value = { Min = 20, Max = 120, Default = 70 },
    Callback = function(value)
        print(value)
    end
})
```

### コードからの制御

```lua
local speed = myTab:Slider({
    Title = "速度",
    Value = { Min = 0, Max = 100, Default = 20 },
    Callback = function(value) print(value) end
})

speed:Set(60)     -- ハンドルを 60 に移動
speed:SetMax(150) -- 範囲を広げる
```
