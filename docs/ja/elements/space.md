# Space

エレメント間に余白を作るための、見えない縦方向のスペーサー。何も描画せず、高さだけを確保します。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Space()
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Columns` | `number` | `1` | 高さの倍率。スペーサーの高さは `7 × Columns` ピクセルになります。 |

::: info 高さについて
高さは `7 * Columns` ピクセルで計算されます —— デフォルトの `Columns = 1` は 7px、`Columns = 2` は 14px を確保します。
:::

## 例

### 大きめの余白

```lua
myTab:Space({ Columns = 2 }) -- 縦 14px の余白
```

### 縦に並ぶエレメントの間隔を空ける

各コントロールの間に `Space()` を入れるのが、長いリストを窮屈に見せないための一般的な方法です。

```lua
myTab:Toggle({ Title = "基本のトグル", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "説明付きトグル", Desc = "補足の説明", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "チェックボックス", Type = "Checkbox", Callback = function(v) end })
```

::: info
Space はインタラクティブではないため、メソッドを持ちません —— サイズは作成時の `Columns` フィールドで調整します。
:::
