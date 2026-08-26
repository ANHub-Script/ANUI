# Paragraph

見出し、注記、説明のためのリッチテキストブロック。[共通のベース](/ja/elements/#共通のベース)の上に作られ、ホバー効果が無効になっているため静的なコンテンツとして表示されます —— さらに、子エレメントを取り付けられる軽量なコンテナとしても使えます。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Paragraph({
    Title = "Toggle の例",
    Desc = "このタブでは、Toggle でサポートされている機能をすべて紹介します: 通常のトグル、チェックボックス版、項目ごとのアイコン、初期値、ロック、コードからの更新。"
})
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Paragraph"` | 見出しのテキスト。[リッチテキストトークン](/ja/elements/#title-と-desc-のリッチテキスト)に対応。 |
| `Desc` | `string` | `nil` | 本文のテキスト。リッチテキストトークンと `\n` による複数行に対応。 |
| `Locked` | `boolean` | `false` | ロックのオーバーレイを表示します。 |
| `Images` | `table` | `nil` | 画像カードのグリッドとして描画されるカードオブジェクトの配列（下記参照）。 |
| `ImageSize` | `UDim2` | `UDim2.fromOffset(70, 70)` | 各画像カードのサイズ。 |
| `Buttons` | `table` | `nil` | `{ Title, Icon, Callback }` の配列。テキストの下に**縦積みの全幅ボタン**として描画されます。 |

### 画像カードのオブジェクト

`Images` の各エントリーはテーブルです。

| フィールド | 型 | 説明 |
| --- | --- | --- |
| `Title` | `string` | カードのラベル。 |
| `Quantity` | `string` | 数量 / 個数のバッジ（例: `"244x"`）。 |
| `Image` | `string` | アセット ID（`rbxassetid://…`）またはアイコン名。 |
| `Gradient` | `ColorSequence` | カードの背景グラデーション。 |
| `Callback` | `function` | カードがクリックされたときに実行されます。 |

::: info 2 種類の `Buttons`
ここでの `Buttons` 設定は、Paragraph のテキストの下に**縦積みの全幅**ボタン（それぞれ `{ Title, Icon, Callback }`）を描画します。これは、他のエレメントが行の内側に描画する共通ベースのインライン `Buttons` **マップ**とは別のものです。
:::

Paragraph は[共通のベース](/ja/elements/#共通のベース)から `Image`、グラデーション、リッチテキストトークン、ロック、ハイライトを継承します。ホバーは常に無効です。

## メソッド

### `Paragraph:SetTitle(text)` / `Paragraph:SetDesc(text)`

Paragraph が保持する `Title` / `Desc` フィールドを更新します。

```lua
myParagraph:SetTitle("更新後の見出し")
myParagraph:SetDesc("更新後の本文。")
```

::: details 画面上のテキストを更新する
`:SetTitle` / `:SetDesc` はエレメントの Lua フィールドを更新します。すでに画面に表示されているテキストを変更するには、内部の ParagraphFrame 自身のセッターを使ってください。
:::

### `Paragraph:SetViewport(model, cameraOffset?)`

`model` の 3D プレビューを表示する 95×95 の `ViewportFrame` を描画します。任意で `cameraOffset` を指定できます。

```lua
myParagraph:SetViewport(workspace.SomeModel)
```

## 例

### 複数行の説明

`\n` を使って説明を改行します。

```lua
myTab:Paragraph({
    Title = "ランク情報",
    Desc = "現在のランク: S クラス\n戦闘力: 500,000"
})
```

### 軽量なコンテナとして使う

Paragraph オブジェクトは Tab と同じエレメント作成メソッドを持つので、子要素を直接取り付けられます —— 見出しの下にコントロールをまとめるのに便利です。

```lua
local group = myTab:Paragraph({
    Title = "Yen アップグレード",
    Desc = "Yen 通貨でステータスを強化します"
})

group:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "コスト: 100 Yen | Luck +5%" })
group:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "コスト: 250 Yen | Damage +10" })
group:Button({ Title = "ランクアップ", Icon = "arrow-up-circle" })
```

### 画像カードのグリッド

```lua
myTab:Paragraph({
    Title = "インベントリ",
    ImageSize = UDim2.fromOffset(70, 70),
    Images = {
        {
            Title = "World Box",
            Quantity = "244x",
            Image = "rbxassetid://84366761557806",
            Gradient = ColorSequence.new(Color3.fromHex("#C042FF"), Color3.fromHex("#8E24AA")),
            Callback = function() print("World Box") end
        },
        {
            Title = "Zone Key",
            Quantity = "3x",
            Image = "key",
            Gradient = ColorSequence.new(Color3.fromHex("#29B6F6"), Color3.fromHex("#0288D1")),
            Callback = function() print("Zone Key") end
        },
    }
})
```

### 縦積みのボタン

```lua
myTab:Paragraph({
    Title = "ANHUB Discord",
    Desc = "メンバー: 1,234\nオンライン: 567",
    Buttons = {
        {
            Title = "リンクをコピー",
            Icon = "link",
            Callback = function()
                setclipboard("https://discord.gg/qN47S3mKZA")
            end
        }
    }
})
```
