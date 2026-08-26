# Dropdown

単一選択・複数選択に対応する選択リスト。項目ごとのアイコン、説明、区切り線、画像も使えます。グローバルのコールバックを指定しなければ、**アクションメニュー**としても機能します。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Dropdown({
    Title = "基本",
    Values = { "選択肢 1", "選択肢 2", "選択肢 3", "選択肢 4" },
    Value = "選択肢 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dropdown"` | メインのラベル。[リッチテキストトークン](/ja/elements/#title-と-desc-のリッチテキスト)に対応。 |
| `Desc` | `string` | `nil` | タイトルの下に表示する任意の説明。 |
| `Values` | `table` | `{}` | 選択肢のリスト —— 文字列または項目オブジェクト（下記参照）。`{ Type = "Divider" }` で区切り線を挿入します。 |
| `Value` | `string` \| `table` | `nil` | 初期選択: 文字列、項目オブジェクト、または配列（`Multi` の場合）。 |
| `Multi` | `boolean` | `false` | 複数選択を許可します。 |
| `AllowNone` | `boolean` | `false` | 最後に残った項目の選択解除を許可します（`Multi` と組み合わせると特に便利）。 |
| `SearchBarEnabled` | `boolean` | `false` | メニュー上部に検索バーを表示します。 |
| `MenuWidth` | `number` | `nil` | メニューの固定幅（ピクセル）。省略すると自動調整。 |
| `Locked` | `boolean` | `false` | ロックのオーバーレイを表示し、操作をブロックします。 |
| `Image` | `string` \| `table` | `nil` | Dropdown 行の左寄せ画像。 |
| `ImageSize` | `number` \| `UDim2` | `30` | 画像サイズ —— 数値、または画像カード用の `UDim2`。 |
| `ImagePadding` | `number` | `—` | 項目画像の周囲の余白。 |
| `IconThemed` | `boolean` | `false` | 現在のテーマ色でアイコンを着色します。 |
| `Color` | `Color3` \| `string` | `nil` | 背景に色を付けます（テーマ名または `Color3`）。 |
| `Callback` | `function` | `nil` | 選択時に実行されます。シグネチャは下記の注記を参照。 |
| `Flag` | `string` | `nil` | 設定を永続化するためのキー。[設定と Flag](/ja/features/config-and-flags)を参照。 |
| `Buttons` | `table` | `nil` | 行内に描画されるインラインボタン。 |
| `TitleGradient` | `table` | `nil` | タイトルテキストに適用するグラデーション。 |
| `DescGradient` | `table` | `nil` | 説明テキストに適用するグラデーション。 |

### 項目オブジェクト

`Values` の各エントリーは、単純な文字列ではなくテーブルにもできます。

| フィールド | 型 | 説明 |
| --- | --- | --- |
| `Title` | `string` | 項目のラベル。 |
| `Desc` | `string` | タイトルの下に表示する任意の説明。 |
| `Icon` | `string` | 項目の任意のアイコン。 |
| `Images` | `table` | 画像 ID / アイコン名の配列、またはカードテーブル（`{ Card = true, Title, Quantity, Image, Gradient }`）。 |
| `Locked` | `boolean` | この項目の選択を無効にします。 |
| `Callback` | `function` | 項目ごとのアクション。**メニューモード**で使います（下記参照）。 |
| `Type` | `string` | 他のフィールドを付けずに `"Divider"` を指定すると、項目間に区切り線を挿入します。 |

::: info Callback のシグネチャとメニューモード
- **単一選択:** コールバックは選択された**値**を受け取ります —— 文字列項目なら `string`、オブジェクト項目なら**元の項目オブジェクト**（`option.Title` などを読めます）。
- **複数選択**（`Multi = true`）: コールバックは選択された項目の**配列**を受け取ります。
- **グローバルな `Callback` がない場合:** Dropdown は**アクションメニュー**になり、項目をクリックすると*その項目自身*の `Callback` が実行されます。
:::

Dropdown は[共通のベース](/ja/elements/#共通のベース)の設定とメソッドも継承します。

## メソッド

### `Dropdown:Select(items)`

現在の選択をコードから設定します。単一の値、または `Multi` が有効なときは配列を渡します。

```lua
myDropdown:Select("Blue")
myDropdown:Select({ "A", "C" }) -- 複数選択
```

### `Dropdown:Refresh(values)`

選択肢のリストを、新しい `values` 配列でまるごと置き換えます。

```lua
myDropdown:Refresh({ "New 1", "New 2", "New 3" })
```

### `Dropdown:Edit(itemName, newData)`

名前で見つけた既存の項目を、`newData` のフィールドで更新します。

```lua
myDropdown:Edit("Option 1", { Title = "Option 1 (updated)", Icon = "check" })
```

### `Dropdown:EditDrop(target, newData)`

Dropdown のコンテナ自体を編集し、指定した `target` に `newData` を適用します。

### `Dropdown:SetValueImage(img)` / `Dropdown:SetValueIcon(img)`

現在選択されている値の隣に表示する画像またはアイコンを設定します。

### `Dropdown:SetMainImage(img, size)`

Dropdown の左寄せ画像とそのサイズを更新します。

### `Dropdown:Open()` / `Dropdown:Close()`

メニューを開閉します。`Open()` はトグル動作で、開いている状態で呼ぶと閉じます。

### `Dropdown:Display()`

現在の選択に合わせて、表示中の値（テキスト、アイコン、画像）を再描画します。

### `Dropdown:Lock(text?)` / `Dropdown:Unlock()`

Dropdown をロック / ロック解除します。`text` を渡すとオーバーレイのラベルになります。

## 例

### 基本の文字列リスト

```lua
myTab:Dropdown({
    Title = "基本",
    Desc = "グローバルな選択コールバックを持つ、シンプルな文字列リスト。",
    Values = { "選択肢 1", "選択肢 2", "選択肢 3", "選択肢 4" },
    Value = "選択肢 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

### アイコン付き（オブジェクト項目）

オブジェクト項目の場合、コールバックは**項目オブジェクト**を受け取ります —— `option.Title` を読みます。

```lua
myTab:Dropdown({
    Title = "アイコン付き",
    Desc = "各選択肢はタイトルとアイコンを持つオブジェクトです。",
    Values = {
        { Title = "Bird",     Icon = "bird" },
        { Title = "House",    Icon = "house" },
        { Title = "Settings", Icon = "settings" },
        { Title = "Trash",    Icon = "trash-2" },
    },
    Value = { Title = "Bird", Icon = "bird" },
    Callback = function(option)
        print("Selected:", option.Title)
    end
})
```

### 説明付き

```lua
myTab:Dropdown({
    Title = "説明付き",
    Values = {
        { Title = "選択肢 A", Desc = "これは選択肢 A です" },
        { Title = "選択肢 B", Desc = "これは選択肢 B です" },
        { Title = "選択肢 C", Desc = "これは選択肢 C です" },
    },
    Value = { Title = "選択肢 A", Desc = "これは選択肢 A です" },
    Callback = function(option) print(option.Title) end
})
```

### 複数選択

`Multi = true` にすると、コールバックは選択された項目の**配列**を受け取ります。

```lua
myTab:Dropdown({
    Title = "複数選択",
    Desc = "複数の選択肢を選べます（コールバックは選択項目の配列を返します）。",
    Values = {
        { Title = "カテゴリー A", Icon = "folder" },
        { Title = "カテゴリー B", Icon = "folder" },
        { Title = "カテゴリー C", Icon = "folder" },
        { Title = "カテゴリー D", Icon = "folder" },
    },
    Multi = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do
            table.insert(titles, v.Title)
        end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### 区切り線によるグループ化

```lua
myTab:Dropdown({
    Title = "区切り線でグループ化",
    Desc = "Type = 'Divider' を使うと、選択肢を視覚的に分かれたグループに分割できます。",
    Values = {
        { Title = "グループ 1 - A", Icon = "star" },
        { Title = "グループ 1 - B", Icon = "star" },
        { Type = "Divider" },
        { Title = "グループ 2 - A", Icon = "heart" },
        { Title = "グループ 2 - B", Icon = "heart" },
    },
    Value = { Title = "グループ 1 - A", Icon = "star" },
    Callback = function(option) print(option.Title) end
})
```

### 選択なしを許可（複数選択）

`AllowNone` を使うと、複数選択で選択数を 0 まで減らせます。

```lua
myTab:Dropdown({
    Title = "複数選択（AllowNone）",
    Desc = "AllowNone 付きの複数選択では、最後に残った項目も選択解除できます。",
    Values = { { Title = "A" }, { Title = "B" }, { Title = "C" } },
    Value = "B",
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do table.insert(titles, v.Title) end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### ロックされた項目

```lua
myTab:Dropdown({
    Title = "ロックされた項目",
    Desc = "項目ごとのロックで、特定の選択肢だけ選択不可にできます。",
    Values = {
        { Title = "選択可 A" },
        { Title = "ロック中 B", Locked = true },
        { Title = "選択可 C" },
    },
    Value = "選択可 A",
    Callback = function(value)
        print("Selected:", typeof(value) == "table" and value.Title or value)
    end
})
```

### 幅の指定と検索バー

```lua
myTab:Dropdown({
    Title = "幅を指定",
    Desc = "自動調整の代わりに、メニュー幅を手動で指定します。",
    Values = { "短い", "普通の選択肢", "とてもとてもとても長い選択肢の名前" },
    Value = "短い",
    MenuWidth = 250,
    SearchBarEnabled = true,
    Callback = function(value) print(value) end
})
```

### コードからの選択

```lua
local colors = myTab:Dropdown({
    Title = "コードから選択",
    Values = { "Red", "Green", "Blue" },
    Value = "Red",
    Callback = function(value) print("Selected:", value) end
})

myTab:Button({
    Title = "コードから 'Blue' を選択",
    Callback = function()
        colors:Select("Blue")
    end
})
```

### アクションメニュー（項目ごとのコールバック）

グローバルな `Callback` を完全に省略し、各項目に自分の `Callback` を持たせます —— Dropdown が右クリックメニューのように振る舞います。

```lua
myTab:Dropdown({
    Title = "高度なアクション",
    Desc = "グローバルなコールバックなし: 項目ごとのコールバックでアクションメニューのように動きます。",
    Values = {
        { Title = "新規ファイル",  Desc = "新しいファイルを作成",   Icon = "file-plus", Callback = function() print("New file") end },
        { Title = "リンクをコピー", Desc = "ファイルのリンクをコピー",  Icon = "copy",      Callback = function() print("Copy link") end },
        { Type = "Divider" },
        { Title = "ファイルを削除", Desc = "ファイルを完全に削除", Icon = "trash", Callback = function() print("Delete file") end },
    }
})
```

::: tip 選択内容を永続化する
`Flag` を追加すると、選択された値がセッションをまたいで保存・復元されます。[設定と Flag](/ja/features/config-and-flags)を参照してください。
:::
