# Toggle

コールバックに boolean を渡す ON/OFF スイッチ。デフォルトではアニメーション付きのスライダーとして描画され、`Type = "Checkbox"` でチェックボックスにもなります。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Toggle({
    Title = "Auto Farm",
    Desc = "コインを自動で集めます",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Toggle"` | メインのラベル。[リッチテキストトークン](/ja/elements/#title-と-desc-のリッチテキスト)に対応。 |
| `Desc` | `string` | `nil` | タイトルの下に表示する任意の説明。 |
| `Value` | `boolean` | `false` | 初期状態。 |
| `Type` | `string` | `"Toggle"` | `"Toggle"`（アニメーション付きスライダー）または `"Checkbox"`。 |
| `Icon` | `string` | `nil` | スライダーのノブ内に表示するアイコン。 |
| `IconSize` | `number` | `23` | ノブのアイコンのサイズ（ピクセル）。 |
| `Image` | `string` \| `table` | `nil` | 左寄せの画像（アセット ID またはカードテーブル）。 |
| `ImageSize` | `number` | `30` | 左側の画像のサイズ（ピクセル）。 |
| `Thumbnail` | `string` | `nil` | 大きなサムネイル画像。 |
| `ThumbnailSize` | `number` | `80` | サムネイルのサイズ（ピクセル）。 |
| `Locked` | `boolean` | `false` | ロックのオーバーレイ。操作をブロックし、**さらに**コールバックも無効にします。 |
| `Disabled` | `boolean` | `false` | ユーザー操作のみをブロックします（コードからのコールバックは発火します）。 |
| `Callback` | `function` | `nil` | 変更時に実行されます。**新しい boolean 値を受け取ります。** |
| `Flag` | `string` | `nil` | 設定を永続化するためのキー。[設定と Flag](/ja/features/config-and-flags)を参照。 |
| `Buttons` | `table` | `nil` | 行内に描画されるインラインボタン。 |
| `TitleGradient` | `table` | `nil` | タイトルテキストに適用するグラデーション。 |
| `DescGradient` | `table` | `nil` | 説明テキストに適用するグラデーション。 |

::: info Locked と Disabled の違い
`Locked` はロックのオーバーレイを表示し、ユーザー操作をブロックし、**さらに**コールバックの発火も防ぎます。`Disabled` は*ユーザー*の操作だけをブロックします —— コードから `:Set(...)` で値を変更でき、コールバックも実行されます。実行時に切り替えるには `:Lock()`/`:Unlock()` と `:Disable()`/`:Enable()` を使います。
:::

Toggle は[共通のベース](/ja/elements/#共通のベース)の設定とメソッドも継承します。

## メソッド

### `Toggle:Set(value, isCallback?, isAnimated?, force?)`

トグルの状態をコードから設定します。

- `value`（`boolean`）—— 新しい状態。
- `isCallback`（`boolean`、任意）—— この変更で `Callback` を発火させます。
- `isAnimated`（`boolean`、任意）—— ノブの遷移をアニメーションさせます。
- `force`（`boolean`、任意）—— 変更を強制的に適用します。

```lua
myToggle:Set(true, true)         -- ON にしてコールバックを発火
myToggle:Set(false, false, false) -- 通知なしで OFF、アニメーションなし
```

### `Toggle:Lock(text?)` / `Toggle:Unlock()`

トグルをロック / ロック解除します。`text` を渡すとオーバーレイのラベルになります。

```lua
myToggle:Lock("プレミアム限定")
myToggle:Unlock()
```

### `Toggle:Disable()` / `Toggle:Enable()`

ロックのオーバーレイなしで*ユーザー*操作を無効 / 再有効化します。`Lock` と違い、コードから値を設定したときはコールバックが発火します。

### `Toggle:SetMainImage(image, size)`

左寄せの画像とそのサイズを更新します。

```lua
myToggle:SetMainImage("rbxassetid://84366761557806", 24)
```

### ベースのメソッド

Toggle は[共通のベース](/ja/elements/#共通のメソッド)の `:SetTitle`、`:SetDesc`、`:SetIcon`、`:Highlight`、`:SetButtons` / `:GetButton` / `:GetButtons`、`:Destroy` にも対応します。

## 例

### 基本と説明付き

```lua
myTab:Toggle({
    Title = "基本のトグル",
    Desc = "アニメーション付きスライダーの標準トグル（ドラッグまたはクリック）。",
    Callback = function(v)
        print("Basic Toggle:", v)
    end
})
```

### 左側に画像を置く

```lua
myTab:Toggle({
    Title = "左に画像のあるトグル",
    Desc = "画像は左側、タイトルと説明の中間に配置されます。",
    Image = "rbxassetid://84366761557806",
    ImageSize = 24,
    Callback = function(v) print(v) end
})
```

### ノブのアイコンと初期 ON

```lua
myTab:Toggle({
    Title = "アイコン付きトグル",
    Desc = "ON のときスライダー内にアイコンを表示します。",
    Icon = "mouse",
    IconSize = 15,
    Value = true,
    Callback = function(v) print(v) end
})
```

### チェックボックス版

```lua
myTab:Toggle({
    Title = "チェックボックス",
    Desc = "トグルのチェックボックス版。",
    Type = "Checkbox",
    Callback = function(v) print(v) end
})

myTab:Toggle({
    Title = "チェックボックス（初期 ON）",
    Type = "Checkbox",
    Value = true,
    Callback = function(v) print(v) end
})
```

### ロック状態

```lua
myTab:Toggle({
    Title = "ロックされたトグル",
    Desc = "ロック状態ではユーザー操作ができません。",
    Locked = true,
    Callback = function(v) print(v) end
})
```

### コードからの更新

```lua
local progToggle = myTab:Toggle({
    Title = "コード操作用トグル",
    Desc = "Set() の使用と、コードによるタイトル / 説明の更新のデモです。",
    Value = false,
    Callback = function(v) print("Programmatic Toggle:", v) end
})

myTab:Button({
    Title = "ON にする",
    Callback = function()
        progToggle:Set(true, true)
        progToggle:SetTitle("コード操作用トグル（ON）")
        progToggle:SetDesc("コードから ON にしました。")
    end
})

myTab:Button({
    Title = "OFF にする（アニメーションなし）",
    Callback = function()
        progToggle:Set(false, true, false)
        progToggle:SetTitle("コード操作用トグル（OFF）")
        progToggle:SetDesc("コードからアニメーションなしで OFF にしました。")
    end
})
```

### Flag で永続化する

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(v) print(v) end
})
```

config が有効になっていれば、値は自動で保存・復元されます —— [設定と Flag](/ja/features/config-and-flags)を参照してください。
