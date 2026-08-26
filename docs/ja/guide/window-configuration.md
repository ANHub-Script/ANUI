# ウィンドウ設定

ウィンドウはすべての ANUI メニューのルートです。設定テーブルを 1 つ渡して `ANUI:CreateWindow{}` で一度だけ作成します。このページでは、すべてのフィールドと、返される `Window` オブジェクトで使えるメソッドを説明します。

::: info ウィンドウは 1 つだけ
同時に存在できるウィンドウは 1 つだけです。2 回目の `ANUI:CreateWindow` 呼び出しは警告を出して `nil` を返します。
:::

## 基本の例

```lua
local Window = ANUI:CreateWindow({
    Title = "マイ Hub",
    Author = "作成者: あなた",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
    Theme = "Dark",
})
```

## 設定

### アイデンティティ

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | — | ウィンドウのタイトル。 |
| `Author` | `string` | — | タイトルの下に表示されるサブタイトル。 |
| `Icon` | `string` | — | ウィンドウアイコン: Lucide のアイコン名または `rbxassetid://…`。 |
| `IconSize` | `number` \| `UDim2` | `22` | アイコンサイズ（ピクセル）。 |
| `IconThemed` | `boolean` | — | テーマのアイコン色でアイコンを着色します。 |

### ストレージ

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Folder` | `string` | — | ディスク上の保存フォルダー。指定すると[設定システム](/ja/features/config-and-flags)と[キーシステム](/ja/features/key-system)の `SaveKey` オプションが有効になります。設定は `ANUI/<Folder>/config/<name>.json` に書き込まれます。 |

### サイズとスケーリング

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Size` | `UDim2` | `580 × 460`（クランプ後） | ウィンドウの初期サイズ。 |
| `MinSize` | `Vector2` | `850 × 560` | リサイズ時の最小サイズ。 |
| `MaxSize` | `Vector2` | `1050 × 560` | リサイズ時の最大サイズ。 |
| `Resizable` | `boolean` | `true` | ユーザーによるリサイズを許可します。 |
| `AutoScale` | `boolean` | `true` | UI を自動でスケーリングします（モバイル向け）。 |

### 外観

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Theme` | `string` | `"Dark"` | テーマ名 —— [テーマ](/ja/features/themes)を参照。 |
| `Transparent` | `boolean` | `false` | ウィンドウ背景を透明にします。 |
| `Acrylic` | `boolean` | `false` | ウィンドウ背後のアクリルブラー。 |
| `Background` | `Color3` \| 画像 ID \| `"https://…"` \| `"video:…"` \| グラデーションテーブル | — | ウィンドウのカスタム背景。 |
| `BackgroundImageTransparency` | `number` | `0` | 背景画像の透過度。 |
| `ShadowTransparency` | `number` | `0.7` | ウィンドウのドロップシャドウの透過度。 |
| `Radius` | `number` | `16` | ウィンドウの角の丸み。 |
| `ElementsRadius` | `number` | — | エレメントに適用される角の丸み。 |
| `SideBarWidth` | `number` | `200` | サイドバーの幅（ピクセル）。 |
| `HidePanelBackground` | `boolean` | `false` | コンテンツパネルの背景を隠します。 |
| `ScrollBarEnabled` | `boolean` | `false` | コンテンツのスクロールバーを表示します。 |

### 挙動

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `ToggleKey` | `Enum.KeyCode` | — | ウィンドウの表示 / 非表示を切り替えるキー。 |
| `HideSearchBar` | `boolean` | `true` | エレメント検索バーを隠します。表示するには `false` にします。 |
| `NewElements` | `boolean` | `false` | 新しいエレメントスタイルを有効にします。 |
| `IgnoreAlerts` | `boolean` | `false` | 組み込みのアラートポップアップを抑制します。 |

### サブ設定

これらのフィールドは独自の設定テーブルを取り、専用ページで説明しています。

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `OpenButton` | `table` | — | ウィンドウを再度開くためのフローティングボタン。[オープンボタン](/ja/features/open-button)を参照。 |
| `KeySystem` | `table` | — | メニューをキーで保護します。[キーシステム](/ja/features/key-system)を参照。 |
| `User` | `table` | — | ユーザー表示ブロック: `{ Enabled, Anonymous, Callback }`。 |

## Window のメソッド

`Window` を取得したら、これらのメソッドで実行時に制御できます。

### ライフサイクル

- `Window:Open()` —— ウィンドウを表示します。
- `Window:Close()` —— ウィンドウを隠します。`:Destroy()` を持つオブジェクトを返します。
- `Window:Destroy()` —— ウィンドウを完全に削除します。
- `Window:Toggle()` —— 開閉を切り替えます。
- `Window:OnOpen(fn)` —— ウィンドウが開くたびに `fn` を実行します。
- `Window:OnClose(fn)` —— ウィンドウが閉じるたびに `fn` を実行します。
- `Window:OnDestroy(fn)` —— ウィンドウが破棄されたときに `fn` を実行します。

### 外観

- `Window:SetTitle(text)` —— タイトルを変更します。
- `Window:SetAuthor(text)` —— サブタイトルを変更します。
- `Window:SetIconSize(n | UDim2)` —— ウィンドウアイコンのサイズを変更します。
- `Window:SetBackgroundImage(id)` —— 背景画像を差し替えます。
- `Window:ToggleTransparency(bool)` —— 透明背景を切り替えます。
- `Window:SetUIScale(v)` —— UI スケールを設定します（`Window:GetUIScale()` で取得できます）。

### サイドバー

- `Window:CollapseSidebar()` —— サイドバーを折りたたみます。
- `Window:ExpandSidebar()` —— サイドバーを展開します。
- `Window:ToggleSidebar(state?)` —— 切り替えます。`state` を渡すとその状態に固定します。

```lua
task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
```

### トグルキー

- `Window:SetToggleKey(keycode)` —— 表示 / 非表示キーを実行時に変更します。

```lua
Window:SetToggleKey(Enum.KeyCode.G)
```

### ロック

- `Window:LockAll()` —— ウィンドウ内のすべてのエレメントをロックします。
- `Window:UnlockAll()` —— ウィンドウ内のすべてのエレメントをロック解除します。

### トップバー

- `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` —— ウィンドウのトップバーにボタンを追加します。
- `Window:DisableTopbarButtons({names})` —— 指定した名前のトップバーボタンを無効にします。

### タグ

`Window:Tag(cfg)` は、ウィンドウに小さなラベル付きタグを追加します —— バージョンバッジの表示に便利です。

```lua
Window:Tag({ Title = "v" .. ANUI.Version, Icon = "github" })
```

### ダイアログ

`Window:Dialog{}` はモーダルダイアログを開きます。[ダイアログとポップアップ](/ja/features/dialogs-and-popups)を参照してください。

### ループ

`Window:Loop`、`Window:StatusLoop`、`Window:ManagedLoop` とその仲間は、ウィンドウが閉じられたり破棄されたときに自動停止する管理付きループを実行します。[スケジューラーとループ](/ja/features/scheduler)を参照してください。

## 次のステップ

- [タブとセクション](/ja/guide/tabs-and-sections)を追加してメニューを整理する。
- [テーマ](/ja/features/themes)で見た目をまるごと変える。
