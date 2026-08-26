# キーシステム

キーシステムは、ウィンドウを開く前にキー入力画面を表示してメニューへのアクセスを制限します。[`ANUI:CreateWindow{}`](/ja/guide/window-configuration) に `KeySystem` テーブルを渡して設定します。ANUI はキーをローカルで検証したり、独自の関数で検証したり、組み込みのキープロバイダー経由で検証したりできます。

## 基本的な使い方

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "マイ Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "続けるにはキーを入力してください。",
        Key = { "free-key" },
        SaveKey = true,
    },
})
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | ウィンドウの `Title` | キー入力画面の見出し。未指定ならウィンドウのタイトルが使われます。 |
| `Note` | `string` | — | タイトルの下に表示される案内テキスト。 |
| `Thumbnail` | `table` | — | プレビュー画像: `{ Image, Title?, Width = 200 }`。 |
| `URL` | `string` | — | この URL をクリップボードにコピーする**キーを取得**ボタンを表示します。 |
| `Key` | `string` \| `array` | — | 受け付けるキー、またはキーのリスト。ローカルで検証されます。 |
| `KeyValidator` | `function` | — | `fn(key) -> boolean`。**最も優先度が高い**独自の検証処理。 |
| `SaveKey` | `boolean` | — | `true` にすると、受理されたキーを `ANUI/<Folder>/<hwid>.key` に書き込み、次回以降キーを尋ねなくなります。 |
| `API` | `array` | — | 1 つ以上のキープロバイダーサービスの設定（[プロバイダー](#プロバイダー)を参照）。 |

::: warning エグゼキュータのファイル関数と HTTP 関数が必要
`SaveKey` はキーファイルの読み書きを行うため、エグゼキュータのファイル関連グローバル（`readfile` / `writefile` / `isfile`）と、ファイル名に使う `gethwid` が必要です。`API` プロバイダーはキーの検証のために HTTP リクエストを送るので、`game:HttpGet` / request 系のサポートが必要です。ローカルの `Key` と `KeyValidator` による検証は、これらがなくても動作します。
:::

## 検証の優先順位

ユーザーがキーを送信すると、ANUI は次の順に検証し、最初に一致した時点で停止します。

1. **`KeyValidator`** —— 指定されていれば、独自の検証関数。
2. **`Key`** —— ローカルのキーまたはキーのリスト。
3. **`API`** —— 設定されたプロバイダーサービス（記載順）。

## プロバイダー

`API` の各エントリーは、`Type` とそのプロバイダーが要求する引数を持つテーブルです。エントリーには `Icon`、`Title`、`Desc` も指定でき、入力画面での表示をカスタマイズできます。

| `Type` | 必須の引数 | 備考 |
| --- | --- | --- |
| `luarmor` | `ScriptId`、`Discord` | Luarmor のキーサービス。 |
| `platoboost` | `ServiceId`、`Secret` | Platoboost のキーサービス。 |
| `pandadevelopment` | `ServiceId` | Panda Development のキーサービス。 |
| `github` | `Owner`、`Repo`、`URL`、`Secret` | 有効期間 24 時間のデバイスごとの独自キー。データベースは GitHub リポジトリにコミットされます。[GitHub キーシステム](/ja/features/github-key-system)を参照してください。 |

```lua
API = {
    {
        Type = "luarmor",
        ScriptId = "your-script-id",
        Discord = "https://discord.gg/qN47S3mKZA",
        Icon = "key",              -- 任意
        Title = "Luarmor",         -- 任意
        Desc = "キーを取得",        -- 任意
    },
}
```

## 例

### SaveKey 付きの固定キー

複数の固定キーのいずれかを受け付け、通ったキーを記憶します。

```lua
ANUI:CreateWindow({
    Title = "マイ Hub",
    Folder = "MyHub",
    KeySystem = {
        Title = "マイ Hub —— キー",
        Note = "キーは Discord で取得できます。",
        URL = "https://discord.gg/qN47S3mKZA",
        Key = { "key1", "key2" },
        SaveKey = true,
    },
})
```

### 独自の検証関数

`KeyValidator` は入力されたキーを文字列として受け取り、真偽値を返します。`Key` のリストや `API` サービスより先に実行されます。

```lua
ANUI:CreateWindow({
    Title = "マイ Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "個人用のキーを入力してください。",
        KeyValidator = function(key)
            -- プレイヤーの UserId で終わるキーをすべて受け付ける
            return key == "VIP-" .. game.Players.LocalPlayer.UserId
        end,
    },
})
```

### Luarmor プロバイダー

```lua
ANUI:CreateWindow({
    Title = "マイ Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Luarmor のキーを検証します。",
        API = {
            {
                Type = "luarmor",
                ScriptId = "your-script-id",
                Discord = "https://discord.gg/qN47S3mKZA",
            },
        },
    },
})
```

### Platoboost プロバイダー

```lua
ANUI:CreateWindow({
    Title = "マイ Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Platoboost のキーを検証します。",
        SaveKey = true,
        API = {
            {
                Type = "platoboost",
                ServiceId = "your-service-id",
                Secret = "your-secret",
            },
        },
    },
})
```

## 関連

- [GitHub キーシステム](/ja/features/github-key-system) —— 自分の GitHub Pages サイトで発行する、有効期間 24 時間のデバイスごとのキー。
- [ウィンドウ設定](/ja/guide/window-configuration) —— `KeySystem` と `Folder` を設定する場所。
