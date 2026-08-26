# Group

子要素を縦に積むのではなく、**横方向**に並べるコンテナ。インタラクティブなエレメントは使える幅を均等に分け合い、[Space](/ja/elements/space) や [Divider](/ja/elements/divider) は固定幅を保ちます。Tab と同様に、Group もすべてのエレメント作成メソッドを持ちます。

## 基本的な使い方

`Tab:Group({})` でグループを作り、返されたコンテナにエレメントを追加します。

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

local row = myTab:Group({})
row:Button({ Title = "保存", Callback = function() end })
row:Button({ Title = "読み込み", Callback = function() end })
```

2 つのボタンが横並びになり、それぞれが行の半分の幅を占めます。

## 設定

`Group` に設定はありません —— `Tab:Group({})` に空のテーブルを渡して呼び出します。

## グループ内でエレメントを作る

Group はコンテナなので、エレメント作成メソッド（`Group:Button`、`Group:Toggle`、`Group:Dropdown` など）は Tab と全く同じように使えます —— [エレメント概要](/ja/elements/)を参照してください。インタラクティブな子要素には行の幅が均等に割り当てられ、`Space` と `Divider` の子要素は伸びずに固定幅を保ちます。

::: tip
Group は、そのすぐ上に置いた [Paragraph](/ja/elements/paragraph) のラベルと相性が良いです —— Paragraph を見出しにして、下に並ぶコントロールの説明にしましょう。
:::

## 例

### ボタンを 1 行に並べる

```lua
local buttons = myTab:Group({})
buttons:Button({
    Title = "Primary",
    Color = Color3.fromHex("#305dff"),
    Icon = "mouse-pointer-click",
    Callback = function() end,
})
buttons:Button({ Title = "Secondary", Icon = "mouse", Callback = function() end })
buttons:Button({ Title = "ロック中", Icon = "lock", Locked = true, Callback = function() end })
```

### Dropdown を 2 つ横並びにする

```lua
myTab:Paragraph({ Title = "Dropdown のグループ", Desc = "2 つの Dropdown をまとめています。" })

local dropdowns = myTab:Group({})
dropdowns:Dropdown({
    Title = "Dropdown 1",
    Values = { "A", "B", "C" },
    Value = "A",
    Callback = function(v) print("Dropdown 1:", v) end,
})
dropdowns:Dropdown({
    Title = "Dropdown 2",
    Values = { { Title = "X", Desc = "1 番目" }, { Title = "Y" }, { Title = "Z" } },
    SearchBarEnabled = true,
    Value = "Y",
    Callback = function(v) print("Dropdown 2:", v) end,
})
```

### Slider を 2 つ横並びにする

```lua
myTab:Paragraph({ Title = "Slider のグループ", Desc = "2 つの Slider をまとめています。" })

local sliders = myTab:Group({})
sliders:Slider({
    Title = "音量",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(v) print("Volume:", v) end,
})
sliders:Slider({
    Title = "明るさ",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(v) print("Brightness:", v) end,
})
```

::: info
Group はレイアウト用のコンテナなので、インタラクティブな共通ベースの挙動は一切継承しません —— それらは Group の内側に置くエレメントの機能です。
:::
