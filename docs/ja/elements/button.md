# Button

クリック可能なアクション行。任意でアイコン、色、インラインボタンを付けられます。Button は最もシンプルなインタラクティブエレメントで、クリックされるとコールバックを実行します。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Button({
    Title = "クリックして",
    Callback = function()
        print("Button clicked!")
    end
})
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Button"` | メインのラベル。[リッチテキストトークン](/ja/elements/#title-と-desc-のリッチテキスト)に対応。 |
| `Desc` | `string` | `nil` | タイトルの下に表示する任意の説明。 |
| `Icon` | `string` | `"mouse-pointer-click"` | アイコン名または `rbxassetid://…`。 |
| `IconThemed` | `boolean` | `false` | 現在のテーマ色でアイコンを着色します。 |
| `Color` | `Color3` \| `string` | `nil` | 背景に色を付けます（テーマ名または `Color3`）。テキストは自動でコントラストを取ります。 |
| `Justify` | `string` | `"Between"` | コンテンツの揃え方。`"Between"` はタイトルとアイコンを両端に離し、`"Center"` は中央に寄せます。 |
| `IconAlign` | `string` | `"Right"` | アイコンを置く側: `"Right"` または `"Left"`。 |
| `Locked` | `boolean` | `false` | ロックのオーバーレイを表示し、クリックをブロックします。 |
| `Callback` | `function` | `nil` | ボタンがクリックされたときに実行されます。**引数は受け取りません。** |
| `Buttons` | `table` | `nil` | 行内に描画されるインラインボタン。 |
| `TitleGradient` | `table` | `nil` | タイトルテキストに適用するグラデーション。 |
| `DescGradient` | `table` | `nil` | 説明テキストに適用するグラデーション。 |

::: info Callback のシグネチャ
Button の `Callback` は**引数を受け取りません** —— 単なるアクションハンドラーです。値に反応させたい場合は [Toggle](/ja/elements/toggle) や [Dropdown](/ja/elements/dropdown) を使ってください。
:::

Button は[共通のベース](/ja/elements/#共通のベース)の設定（`Image`、`Thumbnail`、グラデーション、`Title`/`Desc` のリッチテキストトークンなど）も継承します。

## メソッド

### `Button:Highlight()`

ボタンを一瞬光らせて、ユーザーの注意を引きます。

```lua
local btn = myTab:Button({ Title = "注目して", Callback = function() end })
btn:Highlight()
```

### `Button:Lock()` / `Button:Unlock()`

ボタンをロック / ロック解除します。ロック中のボタンはオーバーレイを表示し、クリックを無視します。

```lua
btn:Lock()
btn:Unlock()
```

### `Button:SetTitle(text)` / `Button:SetDesc(text)` / `Button:SetIcon(icon)`

タイトル、説明、アイコンを実行時に更新します。

```lua
btn:SetTitle("更新後のタイトル")
btn:SetDesc("更新後の説明")
btn:SetIcon("check")
```

### `Button:SetButtons(buttons)` / `Button:GetButton(key)` / `Button:GetButtons()`

行内に描画されるインラインボタンを管理します。`SetButtons` はマップを置き換え、`GetButton` はキーで 1 つ取得し、`GetButtons` はすべてを返します。

### `Button:Destroy()`

ボタンをコンテナから削除します。

## 例

### 基本と色付き

```lua
myTab:Button({
    Title = "ハイライトボタン",
    Icon = "mouse",
    Callback = function()
        print("clicked highlight")
    end
})

myTab:Button({
    Title = "青いボタン",
    Desc = "説明付き",
    Color = Color3.fromHex("#305dff"),
    Icon = "",
    Callback = function() end
})
```

### アイコンの配置と揃え方

```lua
myTab:Button({
    Title = "左アイコン",
    Desc = "アイコンを左に配置",
    Icon = "mouse",
    IconAlign = "Left",
    Justify = "Center",
    Callback = function() end
})
```

### テーマ色と任意色のアイコン

```lua
myTab:Button({
    Title = "テーマ連動アイコン",
    Desc = "アイコンがテーマ色に追従します",
    Icon = "palette",
    IconThemed = true,
    Callback = function() end
})

myTab:Button({
    Title = "色付きアイコン",
    Desc = "アイコンをカスタム色で着色",
    Icon = "mouse-pointer-click",
    Color = Color3.fromHex("#f57c00"),
    Callback = function() end
})
```

### ロック状態

```lua
myTab:Button({
    Title = "Button",
    Desc = "Button の例",
    Locked = true
})
```

### コードからの更新

返されたモジュールを保持しておき、別のボタンから更新します。`Highlight()` で変更に注目を集められます。

```lua
local progBtn = myTab:Button({
    Title = "コード操作用ボタン",
    Desc = "コードから更新されます",
    Icon = "edit",
    Callback = function() end
})

myTab:Button({
    Title = "上のボタンを更新",
    Desc = "SetTitle と SetDesc",
    Icon = "chevron-right",
    Callback = function()
        progBtn:SetTitle("コード操作用ボタン（更新済み）")
        progBtn:SetDesc("コードから更新しました")
        progBtn:Highlight()
    end
})
```

### Dialog による UI ボタンのバリアント

`Window:Dialog` 内のボタンは `Variant` によるスタイル指定に対応します —— `"Primary"`、`"Secondary"`、`"White"`。

```lua
myTab:Button({
    Title = "UI ボタンのバリアントを表示",
    Desc = "Primary / Secondary / White のダイアログを開きます",
    Icon = "square-menu",
    Callback = function()
        Window:Dialog({
            Title = "UI ボタンのバリアント",
            Content = "ボタンのバリアントのデモです。",
            Buttons = {
                { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
                { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
                { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
            }
        })
    end
})
```

::: tip
`Icon = ""` にすると、アイコンなしのボタンを描画できます —— 中央寄せのテキストだけのアクションボタンに便利です。
:::
