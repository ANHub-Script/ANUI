# Colorpicker

多機能なピッカーダイアログで `Color3` を選びます —— 任意で透過度も選べます。ユーザーが適用したタイミングで、選ばれた色を伴ってコールバックが発火します。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Colorpicker({
    Title = "Colorpicker",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(color, transparency)
        print("Color:", color, "Transparency:", transparency)
    end
})
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Colorpicker"` | メインのラベル。[リッチテキストトークン](/ja/elements/#title-と-desc-のリッチテキスト)に対応。 |
| `Desc` | `string` | `nil` | タイトルの下に表示する任意の説明。 |
| `Locked` | `boolean` | `false` | ロックのオーバーレイを表示し、操作をブロックします。 |
| `Default` | `Color3` | `Color3.new(1, 1, 1)`（白） | スウォッチに表示される初期色。 |
| `Transparency` | `number` | `nil` | 初期のアルファ値。数値を指定すると、ピッカー内でアルファのスライダーと入力欄が有効になります。 |
| `Callback` | `function` | `nil` | **適用**時に実行されます。**`(color: Color3, transparency: number)` を受け取ります。** |
| `Buttons` | `table` | `nil` | 行内に描画されるインラインボタン。 |
| `TitleGradient` | `table` | `nil` | タイトルテキストに適用するグラデーション。 |
| `DescGradient` | `table` | `nil` | 説明テキストに適用するグラデーション。 |
| `Flag` | `string` | `nil` | 設定を永続化するためのキー。[設定と Flag](/ja/features/config-and-flags)を参照。 |

::: info ピッカーのダイアログ
スウォッチをクリックすると、次を備えたダイアログが開きます。
- **彩度 / 明度**のマップと**色相**スライダー
- 任意の**アルファ**スライダー（`Transparency` が設定されているときのみ表示）
- **Hex** 入力（`#RRGGBB`）と **R / G / B** 入力 —— 透過度が有効なときは **Alpha** 入力も
- **キャンセル**と**適用**ボタン —— `Callback` は**適用**時に発火します

config に保存されるとき、Colorpicker は hex 値と透過度をシリアライズします。
:::

Colorpicker は[共通のベース](/ja/elements/#共通のベース)の設定とメソッドも継承します。

## メソッド

### `Colorpicker:Update(color, transparency?)`

現在の色（と任意で透過度）を設定し、スウォッチを更新します。

```lua
myColorpicker:Update(Color3.fromRGB(255, 0, 0))
myColorpicker:Update(Color3.fromRGB(255, 0, 0), 0.5)
```

### `Colorpicker:Set(color, transparency?)`

`:Update` のエイリアスです —— 引数と挙動は同じです。

```lua
myColorpicker:Set(Color3.fromHex("#305dff"))
```

### `Colorpicker:Lock()` / `Colorpicker:Unlock()`

Colorpicker をロック / ロック解除します。ロック中の Colorpicker はオーバーレイを表示し、開けません。

```lua
myColorpicker:Lock()
myColorpicker:Unlock()
```

### ベースのメソッド

Colorpicker は[共通のベース](/ja/elements/#共通のメソッド)の `:SetTitle`、`:SetDesc`、`:SetIcon`、`:Highlight`、`:SetButtons` / `:GetButton` / `:GetButtons`、`:Destroy` にも対応します。

## 例

### 透過度と Flag 付き

`Transparency` を設定すると（`0` でも）ダイアログのアルファ操作が有効になります。コールバックは色と透過度の両方を受け取ります。

```lua
myTab:Colorpicker({
    Flag = "ColorpickerTest",
    Title = "Colorpicker",
    Desc = "Colorpicker の説明",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color, transparency)
        print("Background color:", color, transparency)
    end
})
```

config が有効になっていれば、色と透過度は自動で保存・復元されます —— [設定と Flag](/ja/features/config-and-flags)を参照してください。
