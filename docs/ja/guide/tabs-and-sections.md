# タブとセクション

タブはメニューのページであり、サイドバーのセクションはそれらのタブをラベル付きのまとまりにグループ化します。このページでは、`Window:Tab{}` でのタブ作成と `Window:Section{}` でのグループ化を扱います。

::: info 「Section」という 2 つの別概念
ANUI には「Section」と呼ばれる無関係な 2 つのものがあります —— 混同しないでください。

1. **`Window:Section({ Title = ... })`** は、サイドバーでタブをグループ化する**サイドバーのセクションヘッダー**を作ります。その後 `Section:Tab({...})` を呼んで、その下にタブを追加します。このページで説明するのはこちらです。
2. **`Tab:Section({...})`** は**コンテンツエレメント** —— タブの*内側*に置く折りたたみ可能なコンテナです。こちらは [Section（エレメント）](/ja/elements/section)で説明しています。
:::

## タブを作成する

`Window:Tab{}` でタブを作成します。返される `Tab` オブジェクトにエレメントを追加していきます。

```lua
local Main = Window:Tab({
    Title = "メイン",
    Icon = "house",
    Desc = "メインの操作", -- ホバー時に表示されるツールチップ
})
```

### Tab の設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Tab"` | タブのラベル。 |
| `Desc` | `string` | — | タブにホバーしたときに表示されるツールチップ。 |
| `Icon` | `string` | — | タブアイコン（16px）: Lucide 名または `rbxassetid://…`。 |
| `Image` | `string` | — | タブヘッダーに表示されるバナー画像（100px）。 |
| `IconThemed` | `boolean` | — | テーマ色でアイコンを着色します。 |
| `Locked` | `boolean` | — | 最初からタブをロック状態にします。 |
| `ShowTabTitle` | `boolean` | — | コンテンツヘッダーにタブのタイトルを表示します。 |
| `Profile` | `table` | — | プロフィールカードの設定（下記参照）。 |
| `SidebarProfile` | `boolean` | — | プロフィールをコンテンツヘッダーではなくサイドバーのカードとして描画します。 |

## プロフィール

タブには**プロフィール** —— アバター、バナー、ステータス表示、バッジボタンを備えたカード —— を表示できます。`Profile` テーブルを渡します。

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | — | 表示名。 |
| `Desc` | `string` | — | サブタイトル / 役割のテキスト。 |
| `Avatar` | `string` | — | アバター画像。 |
| `Banner` | `string` | — | バナー画像。 |
| `Status` | `boolean` | — | ステータス表示を出します。 |
| `Badges` | `array` | — | `{ Icon, Title, Desc, Callback }` 形式のバッジボタンのリスト。 |
| `Sticky` | `boolean` | `true` | スクロール中もプロフィールを固定表示します。 |

`SidebarProfile = true` にするとプロフィールがサイドバーのカードとして描画され、`false`（または省略）ではタブのコンテンツ内に大きなヘッダーとして表示されます。

```lua
local Badges = {
    {
        Icon = "geist:logo-discord",
        Title = "Discord",
        Desc = "ANHUB の Discord に参加",
        Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
            ANUI:Notify({ Title = "Discord", Content = "招待リンクをコピーしました！", Icon = "geist:logo-discord", Duration = 3 })
        end
    },
    {
        Icon = "youtube",
        Desc = "YouTube を登録",
        Callback = function()
            setclipboard("https://www.youtube.com/@ANHubRoblox")
            ANUI:Notify({ Title = "YouTube", Content = "チャンネルのリンクをコピーしました！", Icon = "youtube", Duration = 3 })
        end
    },
}

-- サイドバーのカード（装飾用、サイドバーに描画される）
Window:Tab({
    Profile = {
        Title = "AdityaNugraha",
        Desc = "管理者",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = true,
})

-- 大きなプロフィールヘッダーを持つ通常のタブ
local UserTab = Window:Tab({
    Title = "プロフィールの表示例",
    Icon = "user",
    Profile = {
        Title = "ユーザー設定",
        Desc = "アカウント情報はここで管理します",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = false,
})

UserTab:Button({ Title = "パスワードを変更", Callback = function() end })
UserTab:Button({ Title = "ログアウト", Icon = "log-out", Callback = function() end })
```

## サイドバーセクションでタブをグループ化する

`Window:Section({ Title = ... })` はサイドバーにラベル付きのヘッダーを作ります。返されたセクションで `:Tab{}` を呼ぶと、その下にタブを追加できます。

```lua
local ElementsSection = Window:Section({ Title = "エレメント" })

local ToggleTab = ElementsSection:Tab({ Title = "Toggle", Icon = "arrow-left-right" })
local ButtonTab = ElementsSection:Tab({ Title = "Button", Icon = "mouse-pointer-click" })

local OtherSection = Window:Section({ Title = "その他" })
local DiscordTab = OtherSection:Tab({ Title = "Discord" })
```

## Tab のメソッド

- `Tab:Select()` —— このタブに切り替えます。
- `Tab:ScrollToTheElement(index)` —— 指定したエレメントまでタブをスクロールします。
- `Tab:LockAll()` —— タブ内のすべてのエレメントをロックします。
- `Tab:UnlockAll()` —— タブ内のすべてのエレメントをロック解除します。
- `Tab:GetLocked()` —— タブのロック済みエレメントを取得します。
- `Tab:GetUnlocked()` —— タブのロック解除済みエレメントを取得します。

エレメント作成メソッド（`Tab:Button`、`Tab:Toggle` など）はすべてタブで使えます —— [エレメント概要](/ja/elements/)を参照してください。

## コードからタブを選択する

タブの切り替えは、ウィンドウ経由でもタブ自身からでも行えます。`Window:SelectTab` はインデックスを取り、各タブの `Tab.Index` で参照できます。

```lua
Window:SelectTab(UpgradeTab.Index)
-- または同じ意味で:
UpgradeTab:Select()
```

## 関連

- [エレメント概要](/ja/elements/) —— タブに置けるものすべて。
- [Section（エレメント）](/ja/elements/section) —— タブ内の折りたたみ可能なコンテナ。
