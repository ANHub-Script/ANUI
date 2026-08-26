# エレメント

エレメントは、ウィンドウ内のインタラクティブなコントロールです —— button、toggle、slider、dropdown など。エレメントは必ず**コンテナ**から作成します。コンテナとは Tab、Section、Group のことです。

## エレメントを作成する

エレメントはすべて、コンテナのメソッドを呼ぶことで作成します。最も一般的なコンテナは Tab です。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "マイ Hub", Folder = "MyHub" })

-- 1. コンテナ（Tab）を作成する
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

-- 2. その上にエレメントを作成する
myTab:Button({ Title = "クリックして", Callback = function() end })
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
```

`Section` と `Group` もコンテナです —— Tab と**同じ**エレメント作成メソッドを持つので、エレメントを入れ子にしてレイアウトを整理できます。

```lua
local section = myTab:Section({ Title = "戦闘" })
section:Toggle({ Title = "God Mode", Callback = function(state) end })

local row = myTab:Group({})       -- 子要素を横方向に並べる
row:Button({ Title = "保存" })
row:Button({ Title = "読み込み" })
```

::: tip
各エレメント作成メソッドは、メソッドを呼び出せるモジュールを返します（例: `local t = myTab:Toggle({...})` としてから `t:Set(true)`）。あとでエレメントを更新する予定があるなら、返り値を保持しておきましょう。
:::

## 共通のベース

ほとんどのインタラクティブなエレメントは共通のベースの上に作られているため、設定フィールドとメソッドのセットを共有しています。一度覚えれば、どこでも同じように使えます。

### 共通の設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | エレメント名 | メインのラベル。[リッチテキストトークン](#title-と-desc-のリッチテキスト)に対応。 |
| `Desc` | `string` | `nil` | 補足説明の行。リッチテキストトークン、`\n`、`\t` に対応。 |
| `Icon` | `string` | エレメントごと | アイコン名（Lucide）または `rbxassetid://…`。 |
| `Image` | `string` \| `table` | `nil` | 左寄せの画像（アセット ID またはカードテーブル）。 |
| `ImageSize` | `number` | `30` | 左側の画像のサイズ（ピクセル）。 |
| `Thumbnail` | `string` | `nil` | 大きなサムネイル画像。 |
| `ThumbnailSize` | `number` | `80` | サムネイルのサイズ（ピクセル）。 |
| `IconThemed` | `boolean` | `false` | 現在のテーマ色でアイコンを着色します。 |
| `Color` | `Color3` \| `string` | `nil` | 背景に色を付けます（テーマ名または `Color3`）。テキストは自動でコントラストを取ります。 |
| `Justify` | `string` | `"Between"` | エレメント行内のコンテンツの揃え方。 |
| `Locked` | `boolean` | `false` | ロックのオーバーレイを表示し、操作をブロックします。 |
| `Buttons` | `table` | `nil` | エレメント行に描画されるインラインボタン（下記参照）。 |
| `TitleGradient` | `table` | `nil` | タイトルテキストに適用するグラデーション。 |
| `DescGradient` | `table` | `nil` | 説明テキストに適用するグラデーション。 |

### 共通のメソッド

ほとんどのインタラクティブなエレメントで使えます。

- `:SetTitle(text)` —— タイトルを更新します。
- `:SetDesc(text)` —— 説明を更新します。
- `:SetIcon(icon)` / `:SetImage(image)` —— アイコンや画像を更新します。
- `:Lock(text?)` —— エレメントをロックします（任意でオーバーレイのテキストを指定）。
- `:Unlock()` —— エレメントのロックを解除します。
- `:Highlight()` —— エレメントを一瞬光らせて注目を集めます。
- `:Destroy()` —— エレメントを削除します。
- `:SetButtons(buttons)` / `:GetButton(key)` / `:GetButtons()` —— インラインボタンを管理します。

::: info
個々のエレメントは、共通ベースに加えて独自のメソッドを持ちます —— 例えば `Toggle:Set(...)`、`Slider:SetMax(...)`、`Dropdown:Refresh(...)` など。完全な一覧は各エレメントのページを参照してください。
:::

## Title と Desc のリッチテキスト

`Title` と `Desc` はインラインのトークンを受け付け、テキストの中にアイコン、画像、グラデーション、さらにはボタンまで埋め込めます。

- **インラインアイコン** —— `{icon}` または `{name}`。サイズ指定も可能: `{icon:star size=28}`。
- **インライン画像** —— 文字列の中に `rbxassetid://…` の参照をそのまま入れます。
- **グラデーション** —— テキストを `<gradient>…</gradient>` で囲みます。色と回転角も指定できます: `<gradient=#40c9ff,#e81cff|45>…</gradient>`。
- **インラインボタン** —— `<button=key>ラベル</button>`、または短縮形の `{button:key}`。エレメントの `Buttons` マップのエントリーに紐づきます。

`Desc` はさらに次に対応します。

- `\n` —— 複数行の説明。
- `\t` —— 2 列のレイアウト（左にラベル、右に値）。

```lua
myTab:Button({
    Title = "状態: <gradient=#30FF6A,#e7ff2f>オンライン</gradient> {check}",
    Desc = "Ping\t24ms\nリージョン\tSEA",
})
```

## Flag による設定の永続化

状態を持つエレメント —— **Toggle**、**Slider**、**Dropdown**、**Input**、**Keybind**、**Colorpicker** —— は `Flag` フィールドを受け付けます。Flag が付いたエレメントは有効な config に自動登録され、その値がセッションをまたいで保存・復元されます。

```lua
myTab:Toggle({ Title = "Auto Farm", Flag = "AutoFarm", Callback = function(state) end })
```

詳しい流れは[設定と Flag](/ja/features/config-and-flags)を参照してください。

## エレメント一覧

| エレメント | 説明 |
| --- | --- |
| [Button](/ja/elements/button) | クリック可能なアクション行。アイコンやインラインボタンも付けられます。 |
| [Toggle](/ja/elements/toggle) | boolean を返す ON/OFF スイッチまたはチェックボックス。 |
| [Slider](/ja/elements/slider) | ドラッグできる数値スライダー。ステップや手入力にも対応。 |
| [Dropdown](/ja/elements/dropdown) | 単一選択・複数選択のリスト。アクションメニューとしても使えます。 |
| [Input](/ja/elements/input) | 1 行または複数行のテキストフィールド。 |
| [Keybind](/ja/elements/keybind) | アクションをキーに割り当て、押されたときにグローバルに発火します。 |
| [Colorpicker](/ja/elements/colorpicker) | ダイアログで色（任意で透過度）を選びます。 |
| [Paragraph](/ja/elements/paragraph) | 画像カードや縦並びボタンも置けるリッチテキストブロック。 |
| [Code](/ja/elements/code) | コピーできるコードスニペットのブロック。 |
| [Section](/ja/elements/section) | ヘッダーの下に子エレメントをまとめる折りたたみ可能なコンテナ。 |
| [Divider](/ja/elements/divider) | 水平（Group 内では垂直）の区切り線。 |
| [Space](/ja/elements/space) | 縦方向の余白を作る不可視のスペーサー。 |
| [Image](/ja/elements/image) | アスペクト比とスケーリングを制御できる単独の画像。 |
| [Group](/ja/elements/group) | 子要素を横方向に並べるコンテナ。 |
| [Category](/ja/elements/category) | エレメントのグループを切り替える横並びのオプションバー。 |
