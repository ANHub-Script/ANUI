# Input

文字列の入力を受け取るテキストフィールド —— 1 行（`"Input"`）または複数行（`"Textarea"`）。フィールドが確定するたびに、コールバックが現在のテキストを受け取ります。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Input({
    Title = "Input",
    InputIcon = "mouse",
    Placeholder = "テキストを入力...",
    Callback = function(text)
        print("Text:", text)
    end
})
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Input"` | メインのラベル。[リッチテキストトークン](/ja/elements/#title-と-desc-のリッチテキスト)に対応。 |
| `Desc` | `string` | `nil` | タイトルの下に表示する任意の説明。 |
| `Type` | `string` | `"Input"` | `"Input"`（1 行）または `"Textarea"`（複数行）。 |
| `Locked` | `boolean` | `false` | ロックのオーバーレイを表示し、操作をブロックします。 |
| `InputIcon` | `string` \| `boolean` | `false` | 入力ボックス内に表示するアイコン。なしにするには `false`。 |
| `Placeholder` | `string` | `"Enter Text..."` | フィールドが空のときに表示されるグレーのヒント。 |
| `Value` | `string` | `""` | 初期テキスト。 |
| `ClearTextOnFocus` | `boolean` | `false` | フォーカス時にフィールドを自動でクリアします。 |
| `Callback` | `function` | `nil` | 確定時に実行されます。**現在のテキストを文字列で受け取ります。** |
| `Buttons` | `table` | `nil` | 行内に描画されるインラインボタン。 |
| `TitleGradient` | `table` | `nil` | タイトルテキストに適用するグラデーション。 |
| `DescGradient` | `table` | `nil` | 説明テキストに適用するグラデーション。 |
| `Flag` | `string` | `nil` | 設定を永続化するためのキー。[設定と Flag](/ja/features/config-and-flags)を参照。 |

::: info Callback のシグネチャ
`Callback` は 1 つの**文字列** —— フィールドの現在のテキスト —— を受け取ります。フィールドが確定したとき（フォーカスが外れたとき、または 1 行入力で Enter が押されたとき）に発火し、**初期化時にも 1 回**、初期の `Value` で発火します。
:::

Input は[共通のベース](/ja/elements/#共通のベース)の設定とメソッドも継承します。

## メソッド

### `Input:Set(value, isUserInput?)`

フィールドのテキストを `value` に設定します。任意の `isUserInput` フラグは、その変更がユーザー由来であることを示します。

```lua
myInput:Set("hello")
```

### `Input:SetPlaceholder(value)`

フィールドが空のときに表示されるプレースホルダーのヒントを更新します。

```lua
myInput:SetPlaceholder("名前を入力...")
```

### `Input:Lock()` / `Input:Unlock()`

Input をロック / ロック解除します。ロック中の Input はオーバーレイを表示し、入力を無視します。

```lua
myInput:Lock()
myInput:Unlock()
```

### ベースのメソッド

Input は[共通のベース](/ja/elements/#共通のメソッド)の `:SetTitle`、`:SetDesc`、`:SetIcon`、`:Highlight`、`:SetButtons` / `:GetButton` / `:GetButtons`、`:Destroy` にも対応します。

## 例

### アイコン付きの基本形

```lua
myTab:Input({
    Title = "Input",
    InputIcon = "mouse"
})
```

### Textarea（複数行）

```lua
myTab:Input({
    Title = "Input Textarea",
    Type = "Textarea",
    InputIcon = "mouse"
})
```

### 説明付き

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input の例"
})
```

### ロック状態

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input の例",
    Locked = true
})
```

### Flag で永続化する

```lua
myTab:Input({
    Flag = "InputTest",
    Title = "Input",
    Desc = "Input の説明",
    Value = "初期値",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "テキストを入力...",
    Callback = function(input)
        print("Text entered:", input)
    end
})
```

config が有効になっていれば、値は自動で保存・復元されます —— [設定と Flag](/ja/features/config-and-flags)を参照してください。
