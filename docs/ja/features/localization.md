# ローカライズ

ANUI には翻訳レイヤーが組み込まれています。言語ごとに翻訳を登録し、システムを有効化すると、ローカライズ用のプレフィックス（`loc:`）で始まる文字列が検索され、現在の言語の翻訳に置き換えられます。

## ローカライズを有効化する

### `ANUI:Localization(config)`

翻訳テーブルを登録してシステムを有効にします。ウィンドウ作成の直前か直後に、一度だけ呼び出してください。

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Enabled` | `boolean` | `false` | 全体のスイッチ。翻訳を行うには `true` である必要があります。 |
| `Translations` | `table` | `{}` | 言語コード → `{ key = value }` の翻訳テーブルのマップ。 |
| `Prefix` | `string` | `"loc:"` | 翻訳対象の文字列であることを示す目印。 |
| `DefaultLanguage` | `string` | `"en"` | `SetLanguage` を呼ぶまで使われる言語。 |

```lua
ANUI:Localization({
    Enabled = true,
    DefaultLanguage = "en",
    Translations = {
        en = {
            welcome = "Welcome!",
            settings = "Settings",
        },
        id = {
            welcome = "Selamat datang!",
            settings = "Pengaturan",
        },
    },
})
```

## 翻訳文字列を使う

タイトルやラベルの先頭に `loc:` を付け、その後ろに翻訳キーを書きます。ANUI が現在の言語のテーブルを使って解決します。

```lua
local Tab = Window:Tab({
    Title = "loc:settings", -- "Settings"（en）または "Pengaturan"（id）と表示される
    Icon = "settings",
})

Tab:Button({
    Title = "loc:welcome",
    Callback = function() end,
})
```

::: info プレフィックスの仕組み
翻訳されるのは、**プレフィックスで始まる**文字列（既定では `loc:`）だけです —— プレフィックスより後ろのテキストが検索キーになります。それ以外の文字列は書いたとおりに表示されます。現在の言語にキーが存在しない場合は文字列がそのまま表示されるため、壊れることはありません。
:::

## 実行中に言語を切り替える

### `ANUI:SetLanguage(language)`

現在の言語を切り替えます。ローカライズが有効である必要があり、`Enabled = true` で `Localization` を呼んでいない場合は `false` を返します。

```lua
ANUI:SetLanguage("id") -- インドネシア語に切り替える
```

## 完全な例

英語 + インドネシア語の翻訳を有効にし、タブとそのエレメントで `loc:` 文字列を使い、Dropdown からユーザーが言語を切り替えられるようにします。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Localization({
    Enabled = true,
    DefaultLanguage = "en",
    Translations = {
        en = {
            title = "Control Panel",
            farm = "Auto Farm",
            language = "Language",
        },
        id = {
            title = "Panel Kontrol",
            farm = "Farm Otomatis",
            language = "Bahasa",
        },
    },
})

local Window = ANUI:CreateWindow({ Title = "loc:title" })
local Tab = Window:Tab({ Title = "loc:title", Icon = "gamepad-2" })

Tab:Toggle({
    Title = "loc:farm",
    Callback = function(on)
        print("farm:", on)
    end,
})

Tab:Dropdown({
    Title = "loc:language",
    Values = { "en", "id" },
    Value = "en",
    Callback = function(lang)
        ANUI:SetLanguage(lang)
    end,
})
```

::: tip
翻訳は `loc:` で始まる文字列にしか作用しないので、ローカライズされた文字列と通常の文字列を並べて使えます —— 自由に混在させてかまいません。
:::
