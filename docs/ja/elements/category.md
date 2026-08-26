# Category

タブ内でサブタブ選択として機能する、横方向にスクロールできる選択肢の帯。オプションを選び、コールバックで対応するエレメント群を表示して残りを隠す —— 多数の「ページ」分のコントロールを 1 つのタブにコンパクトに収めるための仕組みです。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "ショップ", Icon = "shopping-cart" })

myTab:Category({
    Title = "カテゴリーを選択",
    Default = "Weapons",
    Options = {
        { Title = "Weapons", Icon = "sword" },
        { Title = "Armor",   Icon = "shield" },
        { Title = "Potions", Icon = "flask-round" },
    },
    Callback = function(selected)
        print("Selected category:", selected)
    end,
})
```

## 設定

挙動を決めるフィールド:

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | オプションの帯の上に表示されるラベル。 |
| `Desc` | `string` | `nil` | タイトルの下に表示する任意の説明。 |
| `Options` | `array` | `{}` | 選択できるオプション。各エントリーは**文字列**または**オプションテーブル**です（下記参照）。 |
| `Default` | `string` | 最初のオプション | 作成時に選択されるオプション。 |
| `Callback` / `OnChanged` | `function` | `nil` | 選択が変わったときに実行されます。**選択されたオプション名（文字列）を受け取ります。** |

### オプションのエントリー

`Options` の各エントリーは、単なる文字列またはテーブルです。

| フィールド | 型 | 説明 |
| --- | --- | --- |
| `Title` / `Name` / `Value` / `[1]` | `string` | オプション名 —— コールバックに渡される値。 |
| `Icon` / `Image` | `string` | 任意のアイコン（Lucide 名または `rbxassetid://…`）。 |
| `IconSize` | `number` | オプションごとのアイコンサイズの上書き。 |
| `Desc` | `string` | オプションごとの任意の説明。 |

オプションには、細かなアイコン設定である `ScaleType`、`KeepAspect` / `Native`、`NativeSize`、`Tint` も指定できます。

### 外観とレイアウト

いずれも任意です。デフォルト値は UI の他の部分と揃うように調整されています。

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Height` | `number` | `45` | 帯全体の高さ。 |
| `ButtonHeight` | `number` | `32` | 各オプションボタンの高さ。 |
| `IconSize` | `number` | `18` | オプションアイコンの既定サイズ。 |
| `TextSize` | `number` | `14` | オプションラベルの文字サイズ。 |
| `Radius` | `number` | `8` | オプションボタンの角の丸み。 |
| `Gap` / `Padding` | `number` | `8` | オプションボタン間の間隔。 |
| `SidePadding` | `number` | `12` | 帯の左右端の余白。 |
| `ScrollSpeed` | `number` | `35` | 横スクロールの速度。 |
| `Transparency` | `number` | `0.5` | 非アクティブなボタンの背景の透明度。 |
| `AutoCapture` | `boolean` | `true` | Category より後に作られたエレメントを、現在のオプションへ自動登録します（下記参照）。 |
| `Sticky` | `boolean` | `nil`（自動） | タブをスクロールしても帯を固定表示します。 |
| `ZIndex` | `number` | `6` | 帯の描画順。 |

::: details 高度なタグ / アイコン設定
`ActiveTag`（`"Toggle"`）、`InactiveTag`（`"Button"`）、`TextTag`（`"Text"`）は、アクティブ / 非アクティブなボタンとそのテキストのスタイルに使うテーマタグを選びます。`IconScaleType`、`IconKeepAspect`（`true`）、`IconAutoWidth`（`true`）、`TintIcon`（自動）はアイコンの描画を細かく調整し、`ContentPadding`（`5`）と `AlignWithContent`（`true`）は帯と下のエレメントの位置合わせを制御します。
:::

## メソッド

### `Category:Select(name, silent?)`

名前でオプションを選択します。`silent = true` を渡すと、コールバックを発火させずに選択状態だけを更新します。`Category:SetValue(name, silent?)` という別名もあります。

```lua
category:Select("Armor")
category:Select("Potions", true) -- コールバックなし
```

### `Category:GetSelected()`

現在選択されているオプション名を返します。

```lua
print(category:GetSelected())
```

### `Category:SetCallback(fn)`

変更時のコールバックを差し替えます。

```lua
category:SetCallback(function(name) print("now on", name) end)
```

### `Category:Add(name, ...)`

既存のエレメントを 1 つ以上オプション `name` に登録し、そのオプションと連動して表示 / 非表示されるようにします。

### `Category:Remove(item)`

登録済みのエレメントを登録解除します。

### `Category:GetElements(name?)`

指定したオプションに登録されているエレメントを返します。`name` を省略するとすべて返します。

### `Category:Refresh()`

オプションやエレメントが変わった後に、オプションの帯を再構築します。

### `Category:Capture(name)` / `Category:StopCapture()`

新しく作られるエレメントをオプション `name` に取り込み始める / 取り込みを止めます。これは `AutoCapture` を手動で行う形です。

### `Category:With(name, builder)`

`builder` を実行し、その中で作られたすべてのエレメントをオプション `name` に登録します。

```lua
category:With("Weapons", function()
    myTab:Toggle({ Title = "オートスイング" })
    myTab:Slider({ Title = "射程", Value = { Min = 0, Max = 50, Default = 10 } })
end)
```

### `Category:AddOption(option, order?)`

新しいオプションを追加します。任意で位置 `order` を指定できます。

### `Category:RemoveOption(name)`

名前でオプションを削除します。

### `Category:SetOptions(options, newDefault?)`

すべてのオプションを置き換えます。任意で `newDefault` を選択状態にできます。

### `Category:GetOptions()`

現在のオプションを返します。

### `Category:SetHeight(h)`

帯の高さを設定します。

### `Category:Destroy()`

Category を削除します。

## 表示 / 非表示のパターン

::: tip よく使われる形
典型的なパターンは、オプションを指定して Category を作り、コールバックで**選択されたオプションのエレメントを表示して残りを隠す**ことです。エレメントを自分で管理してそれぞれの `.Visible` を切り替えてもよいですが、`AutoCapture`（既定で有効）に任せることもできます。これは Category より*後*に作られたすべてのエレメントを現在のオプションに紐づけ、表示状態を代わりに管理してくれます。`Category:With(name, builder)` と `Category:Capture(name)` / `Category:StopCapture()` を使えば、その取り込みを明示的に制御できます。
:::

下の例は小さな「アップグレードシステム」を作ります。`Categories` テーブルが各オプションのエレメントを保持し、ヘルパー関数が作成時にそれらを隠し、コールバックが選択されたオプションのエレメントだけを表示します。

```lua
local UpgradeTab = Window:Tab({ Title = "アップグレードシステム", Icon = "hammer" })

-- 表示 / 非表示できるように、オプションごとにエレメントを保持する
local Categories = { Yen = {}, Token = {}, Rank = {} }

-- エレメントのルートフレームを取得する（エレメントの種類をまたいで動作）
local function GetElementFrame(element)
    if element.ElementFrame then
        return element.ElementFrame
    elseif element.UIElements and element.UIElements.Main then
        return element.UIElements.Main
    end
    for _, value in pairs(element) do
        if type(value) == "table" and value.UIElements and value.UIElements.Main then
            return value.UIElements.Main
        end
    end
end

-- エレメントをカテゴリーに登録し、既定では隠しておく
local function AddElement(category, element)
    table.insert(Categories[category], element)
    local frame = GetElementFrame(element)
    if frame then frame.Visible = false end
    return element
end

-- 選択されたカテゴリーのエレメントだけを表示する
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then frame.Visible = (name == selected) end
        end
    end
end

UpgradeTab:Category({
    Title = "カテゴリーを選択",
    Default = "Yen",
    Options = {
        { Title = "Yen",   Icon = "coins" },
        { Title = "Token", Icon = "layers" },
        { Title = "Rank",  Icon = "shield" },
    },
    Callback = OnCategoryChanged,
})

UpgradeTab:Space({ Columns = 1 })

-- 各カテゴリーのエレメントを作って登録する
AddElement("Yen", UpgradeTab:Paragraph({ Title = "Yen アップグレード", Desc = "Yen でステータスを強化します" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "コスト: 100 Yen | Luck +5%" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "コスト: 250 Yen | Damage +10" }))

AddElement("Token", UpgradeTab:Paragraph({ Title = "Token アップグレード", Desc = "Token を使った特別な強化" }))
AddElement("Token", UpgradeTab:Toggle({ Title = "Yen Multiplier", Desc = "コスト: 5 Tokens | Yen x1.5" }))

AddElement("Rank", UpgradeTab:Paragraph({ Title = "ランク情報", Desc = "現在のランク: S クラス" }))
AddElement("Rank", UpgradeTab:Button({ Title = "ランクアップ", Icon = "arrow-up-circle" }))

-- 読み込み時に既定のカテゴリーを一度表示する
OnCategoryChanged("Yen")
```

この手法のより詳しい解説は、[カテゴリーページのレシピ](/ja/examples/category-pages)を参照してください。
