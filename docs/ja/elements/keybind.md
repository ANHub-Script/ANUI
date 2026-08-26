# Keybind

アクションをキーボードのキーやマウスボタンに割り当てます。バインドしたキーが押されるとコールバックがグローバルに発火するため、ウィンドウが開いていなくてもゲーム中どこでも動作します。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Keybind({
    Title = "Keybind",
    Value = "F",
    Callback = function(key)
        print("Pressed:", key)
    end
})
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Keybind"` | メインのラベル。[リッチテキストトークン](/ja/elements/#title-と-desc-のリッチテキスト)に対応。 |
| `Desc` | `string` | `nil` | タイトルの下に表示する任意の説明。 |
| `Locked` | `boolean` | `false` | ロックのオーバーレイを表示し、操作をブロックします。 |
| `Value` | `string` | `"F"` | 初期キー。**キー名**の文字列で指定します（例: `"F"`、`"G"`）。 |
| `CanChange` | `boolean` | `true` | ユーザーがクリックでキーを再割り当てできるか。現在のビルドでは実質的に常に有効です。 |
| `Callback` | `function` | `nil` | バインドしたキーが押されたときに実行されます。**キー名を文字列で受け取ります。** |
| `Buttons` | `table` | `nil` | 行内に描画されるインラインボタン。 |
| `TitleGradient` | `table` | `nil` | タイトルテキストに適用するグラデーション。 |
| `DescGradient` | `table` | `nil` | 説明テキストに適用するグラデーション。 |
| `Flag` | `string` | `nil` | 設定を永続化するためのキー。[設定と Flag](/ja/features/config-and-flags)を参照。 |

::: info 発火と再割り当ての仕組み
- コールバックは、バインドしたキーが押されるたびに**グローバルに**発火します —— TextBox にフォーカスがある間だけ抑制されるので、入力中にキーバインドが誤発火することはありません。
- コールバックの引数はキー**名**の文字列です: `Enum.KeyCode.F` は `"F"`、マウスボタンは `"MouseLeft"` または `"MouseRight"` を返します。
- **再割り当て:** キーバインドをクリックすると `...` が表示され、次に押したキーを取り込みます。
:::

Keybind は[共通のベース](/ja/elements/#共通のベース)の設定とメソッドも継承します。

## メソッド

### `Keybind:Set(value)`

バインドするキーを、その名前の文字列で設定します。

```lua
myKeybind:Set("G")
```

### `Keybind:Lock()` / `Keybind:Unlock()`

Keybind をロック / ロック解除します。ロック中の Keybind はオーバーレイを表示し、再割り当てできません。

```lua
myKeybind:Lock()
myKeybind:Unlock()
```

### ベースのメソッド

Keybind は[共通のベース](/ja/elements/#共通のメソッド)の `:SetTitle`、`:SetDesc`、`:SetIcon`、`:Highlight`、`:SetButtons` / `:GetButton` / `:GetButtons`、`:Destroy` にも対応します。

## 例

### ウィンドウのトグルキーを再割り当てする

コールバックがキー名を渡してくれるので、`Enum.KeyCode[key]` で `Enum.KeyCode` に戻し、そのまま `Window:SetToggleKey` に渡せます。

```lua
myTab:Keybind({
    Flag = "KeybindTest",
    Title = "Keybind",
    Desc = "UI を開くキーバインド",
    Value = "G",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})
```

::: tip 割り当てを永続化する
`Flag` を追加すると、バインドしたキーがセッションをまたいで保存・復元されます。[設定と Flag](/ja/features/config-and-flags)を参照してください。
:::
