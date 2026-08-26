# Section

タブの内側に置く折りたたみ可能なコンテナ。Tab と同様に、Section もすべてのエレメント作成メソッドを持ちます。子エレメントを追加すると、開閉できるヘッダーの下にまとめて表示されます。

::: info 「Section」という 2 つの別概念
このページで説明するのは**コンテンツエレメント**の `Tab:Section({...})` —— タブの*内側*に置く折りたたみ可能なコンテナです。

タブをグループ化する**サイドバーのセクションヘッダー**を作る `Window:Section({ Title = ... })` とは無関係です。そちらは[タブとセクション](/ja/guide/tabs-and-sections)を参照してください。
:::

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

local combat = myTab:Section({ Title = "戦闘" })

combat:Toggle({ Title = "God Mode", Callback = function(state) end })
combat:Button({ Title = "Kill Aura", Callback = function() end })
```

::: tip
Section が開閉できるようになるのは、子エレメントが 1 つ以上ある場合だけです —— 空の Section には折りたたむ中身がありません。
:::

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Section"` | ヘッダーのラベル。インラインの `{icon}` トークンを含む[リッチテキストトークン](/ja/elements/#title-と-desc-のリッチテキスト)に対応。 |
| `Icon` | `string` | `nil` | ヘッダーのアイコン: Lucide 名または `rbxassetid://…`。 |
| `Image` | `string` | `nil` | ヘッダーの画像アセット（`Icon` の代わり）。 |
| `IconSize` | `number` | `20` | ヘッダーアイコンのサイズ（ピクセル）。 |
| `IconThemed` | `boolean` | `false` | 現在のテーマ色でアイコンを着色します。 |
| `InlineIcon` | `boolean` | `true` | アイコンをタイトルテキストと同じ行に描画します。 |
| `TextSize` | `number` | `19` | ヘッダータイトルの文字サイズ。 |
| `TextXAlignment` | `string` | `"Left"` | ヘッダータイトルの水平方向の揃え方。 |
| `TextTransparency` | `number` | `0.05` | ヘッダータイトルの文字の透過度。 |
| `FontWeight` | `Enum.FontWeight` \| `string` | `SemiBold` | ヘッダータイトルのフォントウェイト。 |
| `Box` | `boolean` | `false` | セクションを枠線付きのボックスで囲みます。 |
| `Opened` | `boolean` | `false` | 折りたたみではなく展開状態で開始します。 |
| `HeaderSize` | `number` | `42` | ヘッダー行の高さ（ピクセル）。 |
| `HeaderPadding` | `number` | `8` | ヘッダー行の内側の余白。 |
| `ChevronSize` | `number` | `20` | 開閉用シェブロンのサイズ。 |

## メソッド

エレメント作成メソッド（`Section:Button`、`Section:Toggle`、`Section:Slider` など）は、Tab と全く同じように Section でも使えます —— [エレメント概要](/ja/elements/)を参照してください。Section 固有のメソッドは以下です。

### `Section:SetTitle(text)`

ヘッダーのラベルを更新します。

```lua
combat:SetTitle("戦闘（有効）")
```

### `Section:SetIcon(icon)`

ヘッダーのアイコンを設定します（Lucide 名または `rbxassetid://…`）。

```lua
combat:SetIcon("swords")
```

### `Section:SetIconSize(size)`

ヘッダーアイコンのサイズをピクセルで設定します。

```lua
combat:SetIconSize(24)
```

### `Section:GetIcon()`

現在のヘッダーアイコンを返します。

```lua
print(combat:GetIcon())
```

### `Section:Open()` / `Section:Close()`

セクションを展開 / 折りたたみます。

```lua
combat:Open()
combat:Close()
```

### `Section:Destroy()`

セクションとその子エレメントを削除します。

```lua
combat:Destroy()
```

## 例

### アイコン、トークン入りタイトル、初期展開

```lua
local stats = myTab:Section({
    Title = "{swords} 戦闘ステータス",
    Icon = "swords",
    Opened = true,
})

stats:Slider({ Title = "ダメージ", Value = { Min = 0, Max = 100, Default = 50 } })
stats:Toggle({ Title = "自動攻撃", Callback = function(state) end })
```

### コードから開閉する

```lua
local advanced = myTab:Section({ Title = "詳細設定" })
advanced:Toggle({ Title = "詳細ログ" })

advanced:Open()  -- 展開
advanced:Close() -- 折りたたみ
```

::: info
Section はコンテナなので、インタラクティブな共通ベースの挙動（ロック、ハイライトなど）は一切継承しません —— それらは Section の*内側*に置くエレメントの機能です。
:::
