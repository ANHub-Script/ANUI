# テーマ

ANUI には 26 種の組み込みテーマが同梱されており、独自のテーマを登録することもできます。ウィンドウ作成時にテーマを選び、実行中に切り替え、現在のテーマを読み取り、変更に反応する —— すべてトップレベルの `ANUI` メソッドで行えます。

## 作成時にテーマを指定する

`CreateWindow` の `Theme` フィールドにテーマのキーを渡します。既定は `"Dark"` です。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "マイ Hub",
    Theme = "Midnight", -- 任意の組み込みキー、またはカスタムテーマ名
})
```

その他のウィンドウ設定は[ウィンドウ設定](/ja/guide/window-configuration)を参照してください。

## 実行中にテーマを切り替える

### `ANUI:SetTheme(name)`

キーを指定してテーマを適用し、テーマテーブルを返します。キーが不明な場合は `nil` を返します。

```lua
if not ANUI:SetTheme("Emerald") then
    warn("Unknown theme key")
end
```

## 現在のテーマを読み取る

### `ANUI:GetCurrentTheme()`

有効なテーマの**表示名**を返します（例: `MonokaiPro` というキーではなく `"Monokai Pro"`）。

```lua
print(ANUI:GetCurrentTheme()) --> "Midnight"
```

### `ANUI:GetThemes()`

登録されているすべてのテーマを、テーマキーをキーとするテーブルで返します —— `AddTheme` で追加したものも含まれます。

```lua
for key, theme in pairs(ANUI:GetThemes()) do
    print(key, "->", theme.Name)
end
```

## テーマの変更に反応する

### `ANUI:OnThemeChange(callback)`

`SetTheme` がテーマを適用したときに実行されるハンドラーを登録します。コールバックは**引数を 1 つ、適用されたテーマキー**を受け取ります —— `SetTheme` に渡したのと同じ文字列（例: `"Dark"`）です。

```lua
ANUI:OnThemeChange(function(themeKey)
    print("Theme changed to:", themeKey)
end)
```

::: info ハンドラーは 1 つだけ
`OnThemeChange` はハンドラーを 1 つだけ保持します —— もう一度呼ぶと以前のものが置き換えられます。スクリプトの複数の箇所で反応させたい場合は、1 つの関数を登録し、その内部で分岐してください。
:::

## 組み込みテーマ

`Theme` / `SetTheme` には**キー**を渡します。表示名（`GetCurrentTheme` が返す値）がキーと異なるのは、ごく一部のテーマだけです。

| キー | 表示名 |
| --- | --- |
| `Dark` | Dark *(デフォルト)* |
| `Light` | Light |
| `Rose` | Rose |
| `Plant` | Plant |
| `Red` | Red |
| `Indigo` | Indigo |
| `Sky` | Sky |
| `Violet` | Violet |
| `Amber` | Amber |
| `Emerald` | Emerald |
| `Midnight` | Midnight |
| `Crimson` | Crimson |
| `MonokaiPro` | Monokai Pro |
| `CottonCandy` | Cotton Candy |
| `Rainbow` | Rainbow |
| `NordTheme` | Nord |
| `DraculaTheme` | Dracula |
| `TokyoNight` | Tokyo Night |
| `OneDark` | One Dark |
| `Gruvbox` | Gruvbox |
| `SolarizedDark` | Solarized Dark |
| `MaterialDark` | Material Dark |
| `CyberpunkPink` | Cyberpunk Pink |
| `OceanBlue` | Ocean Blue |
| `NeonGreen` | Neon Green |
| `SoftPastel` | Soft Pastel |

## カスタムテーマ

### `ANUI:AddTheme(theme)`

テーマを `Name` をキーとして登録し、それを返します。追加後は `SetTheme(name)` で適用します。

テーマは色キーのテーブルです。9 つが必須で、`Toggle` と `Checkbox` は任意です。すべての色は `Color3` —— 通常は `Color3.fromHex("#…")` で作ります。

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Name` | `string` | — | 一意なテーマ名。`SetTheme` に渡すキーになります。 |
| `Accent` | `Color3` | — | 主要なアクセント / パネルの色。 |
| `Dialog` | `Color3` | — | ダイアログとポップアップの背景。 |
| `Outline` | `Color3` | — | 境界線 / ストロークの色。 |
| `Text` | `Color3` | — | 主要なテキストの色。 |
| `Placeholder` | `Color3` | — | 控えめな / プレースホルダーのテキスト色。 |
| `Background` | `Color3` | — | ウィンドウの背景色。 |
| `Button` | `Color3` | — | ボタンの背景色。 |
| `Icon` | `Color3` | — | アイコンの着色。 |
| `Toggle` | `Color3` | *(任意)* | Toggle が「オン」のときの色。 |
| `Checkbox` | `Color3` | *(任意)* | Checkbox が「チェック済み」のときの色。 |

```lua
ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
    Toggle      = Color3.fromHex("#22d3ee"),
    Checkbox    = Color3.fromHex("#0ea5e9"),
})

ANUI:SetTheme("Oceanic")
```

::: tip
`AddTheme` で追加したテーマはすぐに `GetThemes()` に現れ、組み込みテーマと同じように選択できます。
:::

## グラデーション

### `ANUI:Gradient(stops, props)`

カラーストップの集合からグラデーションのデータテーブルを作ります。`stops` は `"0"` から `"100"`（グラデーション上の位置をパーセントで表す）までの**位置を表す文字列**をキーとし、各ストップは `{ Color = Color3, Transparency = number }` です —— `Transparency` は任意で、既定は `0` です。`props` は任意のテーブルで、結果にマージされます（例: `{ Rotation = 45 }`）。

```lua
local sunset = ANUI:Gradient({
    ["0"]   = { Color = Color3.fromHex("#40c9ff") },
    ["50"]  = { Color = Color3.fromHex("#8b5cf6") },
    ["100"] = { Color = Color3.fromHex("#e81cff") },
}, {
    Rotation = 45,
})
```

::: warning ストップは 2 つ以上
グラデーションには**2 つ以上**のストップが必要です。それより少ないとエラーになります。
:::

グラデーションは、ライブラリがグラデーションデータを受け付けるあらゆる場所で使えます —— 最もよく使われるのはエレメントの `TitleGradient` と `DescGradient` フィールドです。

```lua
myTab:Button({
    Title = "グラデーションのタイトル",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Callback = function() end,
})
```

テーマの色として使うことさえできます —— 組み込みの `Rainbow` テーマは、単色の `Color3` ではなくグラデーションで定義されています。

## アクリルブラー

### `ANUI:ToggleAcrylic(enabled)`

ウィンドウ背後のアクリルブラーをオン / オフします。これはウィンドウが `Acrylic = true` で作られたときにのみ効果があり、そうでなければ何もしません。

```lua
local Window = ANUI:CreateWindow({
    Title = "マイ Hub",
    Acrylic = true,
})

ANUI:ToggleAcrylic(true)  -- ブラーを有効化
ANUI:ToggleAcrylic(false) -- ブラーを無効化
```

## フォント

### `ANUI:SetFont(fontId)`

UI 全体で使われるグローバルフォントを設定します。

```lua
ANUI:SetFont("rbxassetid://12898095208")
```

## 完全な例

カスタムテーマを登録して適用し、テーマ切り替え UI を用意して、変更をすべてログ出力します。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
})

local Window = ANUI:CreateWindow({
    Title = "テーマのデモ",
    Theme = "Oceanic",
    Acrylic = true,
})

local Tab = Window:Tab({ Title = "外観", Icon = "palette" })

Tab:Paragraph({
    Title = "テーマ切り替え",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Desc = "下からテーマを選んでください。",
})

Tab:Dropdown({
    Title = "テーマ",
    Values = { "Dark", "Light", "Midnight", "Oceanic" },
    Value = "Oceanic",
    Callback = function(name)
        ANUI:SetTheme(name)
    end,
})

ANUI:OnThemeChange(function(themeKey)
    print("Active theme key:", themeKey)
    print("Display name:", ANUI:GetCurrentTheme())
end)
```
