# カテゴリーページ

よく使われるパターン: 1 つのタブでエレメントの「ページ」を複数持ち、上部の横方向の帯で切り替えます。これは [Category](/ja/elements/category) エレメントで作ります。以下のレシピはデモの **Upgrade System** をもとにしています。

## 仕組み

Category はスクロール可能なオプションの行を描画します。ユーザーがオプションを選ぶと、`Callback` が選択されたオプション名とともに発火します。各オプション名とそれに属するエレメントを対応づけるテーブルを保持し、すべてのエレメントの `.Visible` を切り替えて、有効なページだけを表示します。

## 1. カテゴリーごとにエレメントを管理する

カテゴリーを定義し、エレメントのフレームを取得するヘルパーと、エレメントをカテゴリーに登録する（既定では隠す）ヘルパーを用意します。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "マイ Hub", Folder = "MyHub" })
local Tab = Window:Tab({ Title = "アップグレード", Icon = "hammer" })

-- カテゴリーごとに 1 つのエレメント置き場を用意する。
local Categories = {
    Combat = {},
    Farming = {},
    Settings = {},
}

-- 表示状態を切り替えられるように、エレメントのルートフレームを取得する。
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
    return nil
end

-- エレメントをカテゴリーに登録し、最初は隠しておく。
local function AddElement(categoryName, element)
    if Categories[categoryName] then
        table.insert(Categories[categoryName], element)
        local frame = GetElementFrame(element)
        if frame then
            frame.Visible = false
        end
    end
    return element
end

-- 選択されたカテゴリーのエレメントだけを表示し、残りは隠す。
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        local isVisible = (name == selected)
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then
                frame.Visible = isVisible
            end
        end
    end
end
```

## 2. Category の帯を追加する

ページごとに 1 つのオプションを持つ Category を作ります。`Default` が最初に表示されるページを決め、`Callback` はユーザーが切り替えるたびに `OnCategoryChanged` を実行します。

```lua
Tab:Category({
    Title = "カテゴリーを選択",
    Default = "Combat",
    Options = {
        { Title = "Combat", Icon = "sword" },
        { Title = "Farming", Icon = "coins" },
        { Title = "Settings", Icon = "settings" },
    },
    Callback = OnCategoryChanged, -- 選択されたオプション名（文字列）を受け取る
})

Tab:Space({ Columns = 1 }) -- 帯の下に少し余白を入れる
```

## 3. 各ページを作ってエレメントを登録する

通常どおりエレメントを作成し、それぞれを `AddElement("<category>", ...)` で包むことで、正しい置き場に入り、最初は隠れた状態になります。

```lua
-- Combat
AddElement("Combat", Tab:Paragraph({ Title = "戦闘", Desc = "戦闘関連の項目" }))
AddElement("Combat", Tab:Toggle({ Title = "ゴッドモード", Callback = function(v) print(v) end }))
AddElement("Combat", Tab:Slider({ Title = "ダメージ", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end }))

-- Farming
AddElement("Farming", Tab:Paragraph({ Title = "ファーム", Desc = "オートファーム関連の項目" }))
AddElement("Farming", Tab:Toggle({ Title = "オートファーム", Callback = function(v) print(v) end }))
AddElement("Farming", Tab:Dropdown({ Title = "対象", Values = { "Coins", "Gems", "XP" }, Value = "Coins", Callback = function(v) print(v) end }))

-- Settings
AddElement("Settings", Tab:Paragraph({ Title = "設定", Desc = "メニューの設定" }))
AddElement("Settings", Tab:Toggle({ Title = "自動保存", Callback = function(v) print(v) end }))
```

## 4. 既定のページを表示する

Category は `Default` の状態で始まるので、`OnCategoryChanged` を一度呼んで、他のページをあらかじめ隠しておきます。

```lua
OnCategoryChanged("Combat")
```

これでパターンは完成です。オプションを切り替えると、表示されるエレメントのページが入れ替わります。

## 別の方法: 組み込みのキャプチャ

手動の `Categories` テーブルの代わりに、Category にエレメントを管理させることもできます。`AutoCapture` が有効な場合（既定）、Category より後に作られたエレメントは自動的に紐づけられます。最もすっきりするのは `:With(name, builder)` です —— builder の内側で作られたものすべてがそのオプションに割り当てられ、切り替えに応じて Category が各グループを表示 / 非表示します。

```lua
local cat = Tab:Category({
    Title = "カテゴリーを選択",
    Default = "Combat",
    Options = { "Combat", "Farming", "Settings" },
})

cat:With("Combat", function()
    Tab:Toggle({ Title = "ゴッドモード", Callback = function(v) print(v) end })
    Tab:Slider({ Title = "ダメージ", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end })
end)

cat:With("Farming", function()
    Tab:Toggle({ Title = "オートファーム", Callback = function(v) print(v) end })
end)

cat:With("Settings", function()
    Tab:Toggle({ Title = "自動保存", Callback = function(v) print(v) end })
end)
```

::: tip
`:Capture(name)` / `:StopCapture()` は builder を使わずに同じことを行います —— 任意の範囲のエレメント作成をこの 2 つで挟んでください。カテゴリーが管理している内容を読み取るには `:GetElements(name?)` を使います。メソッドの全一覧は [Category](/ja/elements/category) のページを参照してください。
:::
