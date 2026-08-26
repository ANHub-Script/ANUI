# API チートシート

すべてを 1 ページにまとめました。トップレベルの呼び出し、Window と Tab のメソッド、すべてのエレメント、各機能のエントリーポイント —— ANUI の全体像を素早く見渡すための凝縮されたリファレンスです。詳細はリンク先を参照してください。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## `ANUI`（トップレベル）

ライブラリオブジェクト自身のメソッドとフィールド。

| 呼び出し | 用途 |
| --- | --- |
| `ANUI:CreateWindow(config)` → `Window` | ウィンドウを作成します（1 つだけ存在できます）。 |
| `ANUI:Notify(config)` → 通知 | トースト通知を表示します。 |
| `ANUI:SetNotificationLower(bool)` | 通知を画面の下寄りに移動します。 |
| `ANUI:SetFont(fontId)` | UI 全体のフォントを設定します。 |
| `ANUI:OnThemeChange(fn)` | テーマが変わるたびに `fn` を実行します。 |
| `ANUI:AddTheme(theme)` → テーマ | カスタムテーマを登録します（`.Name` がキー）。 |
| `ANUI:SetTheme(name)` → テーマ \| `nil` | 名前を指定してテーマを切り替えます。 |
| `ANUI:GetThemes()` | 登録済みのすべてのテーマを返します。 |
| `ANUI:GetCurrentTheme()` | 現在のテーマを返します。 |
| `ANUI:GetTransparency()` | 現在の透明度の値を返します。 |
| `ANUI:GetWindowSize()` | 現在のウィンドウサイズを返します。 |
| `ANUI:Localization(config)` | 翻訳を設定します。 |
| `ANUI:SetLanguage(lang)` | 言語を切り替えます（ローカライズが有効である必要があります）。 |
| `ANUI:ToggleAcrylic(bool)` | アクリルブラー効果をオン / オフします。 |
| `ANUI:Gradient(stops, props)` → グラデーション | グラデーションのデータテーブルを作ります（ストップのキーは `"0"`〜`"100"`）。 |
| `ANUI:Popup(config)` → `Popup` | モーダルのポップアップを開きます。 |
| `ANUI:Scheduler(config)` → `Scheduler` | 独立したループスケジューラーを作成します。 |
| `ANUI.Version` | ライブラリのバージョン文字列（メソッドではなくフィールド）。 |

## Window のメソッド

`ANUI:CreateWindow` が返します。用途ごとにまとめ、シグネチャはバッククォートで示します。

**タブとコンテナ**

| メソッド | 用途 |
| --- | --- |
| `Window:Tab(config)` | タブ（エレメントを保持するサイドバーのページ）を追加します。 |
| `Window:Section(config)` | タブをグループ化するサイドバーのセクションを追加します。 |
| `Window:SelectTab(index)` | インデックスを指定してタブを切り替えます。 |
| `Window:Divider()` | サイドバーに区切り線を追加します。 |
| `Window:Tag(config)` | ウィンドウに小さなタグ / バッジ（バージョンなど）を追加します。 |

**ダイアログ**

| メソッド | 用途 |
| --- | --- |
| `Window:Dialog({ Title, Content, Icon, Width, Buttons })` | モーダルダイアログを開きます。各ボタンは `{ Title, Icon, Callback, Variant }`（`Width` の既定は `320`）。 |

**ライフサイクルとコールバック**

| メソッド | 用途 |
| --- | --- |
| `Window:Open()` / `Window:Close()` / `Window:Toggle()` | ウィンドウを表示、非表示、切り替えます。 |
| `Window:Destroy()` | ウィンドウを破棄して後片付けします。 |
| `Window:OnOpen(fn)` / `Window:OnClose(fn)` / `Window:OnDestroy(fn)` | 対応するイベントで `fn` を実行します。 |

**外観**

| メソッド | 用途 |
| --- | --- |
| `Window:SetTitle(t)` / `Window:SetAuthor(t)` | タイトル / サブタイトルを更新します。 |
| `Window:SetIconSize(n \| UDim2)` | トップバーのアイコンサイズを変更します。 |
| `Window:SetBackgroundImage(id)` / `Window:SetBackgroundImageTransparency(v)` | 背景画像とその透明度を設定します。 |
| `Window:SetBackgroundTransparency(v)` / `Window:ToggleTransparency(bool)` | ウィンドウの透明度を調整 / 切り替えます。 |
| `Window:SetToTheCenter()` | ウィンドウを画面中央に戻します。 |
| `Window:GetUIScale()` / `Window:SetUIScale(v)` | UI スケールを読み取る / 設定します。 |
| `Window:IsResizable(bool)` | リサイズを有効 / 無効にします。 |

**サイドバー**

| メソッド | 用途 |
| --- | --- |
| `Window:CollapseSidebar()` / `Window:ExpandSidebar()` / `Window:ToggleSidebar(state?)` | サイドバーを折りたたむ / 展開する / 切り替えます。 |

**切り替えキー**

| メソッド | 用途 |
| --- | --- |
| `Window:SetToggleKey(keycode)` | 表示 / 非表示のホットキー（`Enum.KeyCode`）を設定します。 |

**ロック**

| メソッド | 用途 |
| --- | --- |
| `Window:LockAll()` / `Window:UnlockAll()` | すべてのエレメントをロック / ロック解除します。 |
| `Window:GetLocked()` / `Window:GetUnlocked()` | ロック済み / ロック解除済みのエレメントを一覧します。 |

**トップバー**

| メソッド | 用途 |
| --- | --- |
| `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` | 独自のトップバーボタンを追加します。 |
| `Window:DisableTopbarButtons({ names })` | 組み込みのトップバーボタンを名前で隠します。 |

**オープンボタン**

| メソッド | 用途 |
| --- | --- |
| `Window:EditOpenButton(config)` | フローティングのオープンボタンを編集します。 |

**ループとスケジューラー**

| メソッド | 用途 |
| --- | --- |
| `Window:Loop(key, interval, fn, opts?)` | `interval` 秒ごとに `fn` を実行します。 |
| `Window:StatusLoop(key, interval, fn)` | ステータステキストの更新を想定したループ。 |
| `Window:ManagedLoop(key, interval, predicate, fn)` | `predicate` が true を返す間だけ実行されるループ。 |
| `Window:StopLoop(key)` / `Window:StopAllLoops()` | ループを 1 つ、またはすべて停止します。 |
| `Window:IsLoopRunning(key)` / `Window:GetActiveLoopCount()` | ループの状態を問い合わせます。 |
| `Window:AddConnection(conn)` / `Window:DisconnectAll()` | 接続を追跡して後片付けします。 |
| `Window:IsReady()` | ウィンドウの初期化が完了しているか。 |

## Tab のメソッド

| メソッド | 用途 |
| --- | --- |
| `Tab:Select()` | このタブを有効なタブにします。 |
| `Tab:ScrollToTheElement(index)` | インデックスを指定してエレメントまでスクロールします。 |
| `Tab:LockAll()` / `Tab:UnlockAll()` | タブ内のすべてのエレメントをロック / ロック解除します。 |
| `Tab:GetLocked()` / `Tab:GetUnlocked()` | タブ内のロック済み / ロック解除済みのエレメントを一覧します。 |
| `Tab:ReserveHeader(height, config)` | タブ上部に固定のヘッダー領域を確保します。 |

::: info
Tab は**すべてのエレメント作成メソッド** —— `Tab:Button{}`、`Tab:Toggle{}`、`Tab:Slider{}` など —— も備えています。`Section` と `Group` は、同じエレメントメソッドを持つコンテナです。
:::

## エレメントのクイックリファレンス

エレメントごとに 1 行。コールバックの引数は、あなたの `Callback` 関数が受け取る値です。

| エレメント | シグネチャ | 主な設定 | コールバックの引数 |
| --- | --- | --- | --- |
| [Button](/ja/elements/button) | `Tab:Button{}` | `Callback`、`Icon` | なし |
| [Toggle](/ja/elements/toggle) | `Tab:Toggle{}` | `Value`、`Type` | `boolean` |
| [Slider](/ja/elements/slider) | `Tab:Slider{}` | `Value { Min, Max, Default }`、`Step` | 整形済みの `string` |
| [Dropdown](/ja/elements/dropdown) | `Tab:Dropdown{}` | `Values`、`Multi` | 選択された値（単一） / 配列（複数） |
| [Input](/ja/elements/input) | `Tab:Input{}` | `Placeholder`、`Type` | `string` |
| [Keybind](/ja/elements/keybind) | `Tab:Keybind{}` | `Value`（キー名） | キー名の `string` |
| [Colorpicker](/ja/elements/colorpicker) | `Tab:Colorpicker{}` | `Default`、`Transparency` | `(Color3, transparency)` |
| [Paragraph](/ja/elements/paragraph) | `Tab:Paragraph{}` | `Title`、`Desc`、`Images` | — |
| [Code](/ja/elements/code) | `Tab:Code{}` | `Code`、`OnCopy` | — |
| [Section](/ja/elements/section) | `Tab:Section{}` | `Title`、`Opened` | — |
| [Divider](/ja/elements/divider) | `Tab:Divider()` | — | — |
| [Space](/ja/elements/space) | `Tab:Space{}` | `Columns` | — |
| [Image](/ja/elements/image) | `Tab:Image{}` | `Image`、`AspectRatio` | — |
| [Group](/ja/elements/group) | `Tab:Group{}` | —（コンテナ） | — |
| [Category](/ja/elements/category) | `Tab:Category{}` | `Options`、`Default` | 選択されたオプション名（`string`） |

## 機能のクイックリファレンス

| 機能 | 入り口の呼び出し | ドキュメント |
| --- | --- | --- |
| 通知 | `ANUI:Notify{}` | [通知](/ja/features/notifications) |
| ダイアログとポップアップ | `Window:Dialog{}` · `ANUI:Popup{}` | [ダイアログとポップアップ](/ja/features/dialogs-and-popups) |
| 設定と Flag | `Window.ConfigManager` · `Flag = "..."` | [設定と Flag](/ja/features/config-and-flags) |
| キーシステム | `ANUI:CreateWindow{ KeySystem = {...} }` | [キーシステム](/ja/features/key-system) |
| テーマ | `ANUI:SetTheme(name)` · `ANUI:AddTheme{}` | [テーマと外観](/ja/features/themes) |
| ローカライズ | `ANUI:Localization{}` · `ANUI:SetLanguage(lang)` | [ローカライズ](/ja/features/localization) |
| スケジューラーとループ | `ANUI:Scheduler{}` · `Window:Loop(...)` | [スケジューラーとループ](/ja/features/scheduler) |
