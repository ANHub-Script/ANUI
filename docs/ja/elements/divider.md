# Divider

エレメントを視覚的に区切る細い区切り線。Tab や Section 上では水平線として描画され、[Group](/ja/elements/group) の内側ではグループの列と列の間に垂直線として描画されます。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Button({ Title = "保存", Callback = function() end })
myTab:Divider()
myTab:Button({ Title = "読み込み", Callback = function() end })
```

## 設定

`Divider` に設定はありません —— `Tab:Divider()` を引数なしで呼び出します。

::: info Group 内では垂直になる
[Group](/ja/elements/group) は子要素を横方向に並べるため、その内側に置いた Divider は水平線ではなく、列と列の間の**垂直**の区切り線として描画されます。
:::

## 例

### コントロールのまとまりを区切る

```lua
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })

myTab:Divider()

myTab:Button({ Title = "リセット", Callback = function() end })
```

### 列と列の間の垂直な区切り線

```lua
local row = myTab:Group({})
row:Button({ Title = "承認", Callback = function() end })
row:Divider()
row:Button({ Title = "却下", Callback = function() end })
```

::: info
Divider は純粋に装飾用です —— インタラクティブなエレメントではないため、設定もメソッドも持ちません。
:::
