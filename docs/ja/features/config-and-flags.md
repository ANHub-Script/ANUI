# 設定と Flag

ANUI はメニューの状態をディスクに保存し、復元できます。永続化に対応したエレメントに `Flag` を付けると、設定を保存したときにその値が書き込まれ、読み込んだときに復元されます —— 自分で管理する必要はありません。

::: info ウィンドウの `Folder` が必要
設定システムは `Window.ConfigManager` によって動作しますが、これはウィンドウが `Folder` 付きで作成された場合にのみ存在します。このページの内容を使う前に、[`ANUI:CreateWindow{}`](/ja/guide/window-configuration) で `Folder` を指定してください。
:::

## Flag の仕組み

永続化に対応したすべてのエレメントは `Flag = "key"` を受け付けます。指定すると:

1. エレメントが**現在の設定**（`Window.CurrentConfig`）に自動登録されます。
2. その設定で `:Save()` を呼ぶと、登録済みの各 Flag の値が JSON ファイルに書き込まれます。
3. `:Load()` を呼ぶとファイルが読み戻され、各エレメントが保存時の値に復元されます。

```lua
myTab:Toggle({
    Title = "オートファーム",
    Flag = "AutoFarm", -- この値が永続化されるようになる
    Callback = function(v) print(v) end,
})
```

現在の設定が存在する前に作られたエレメントの Flag はキューに入り、次の `:Save()` または `:Load()` のタイミングで取り出されて登録されます。

## 永続化される対象

状態がシリアライズされるのは以下のエレメントのみです。それ以外のエレメントは設定システムでは無視されます。

| エレメント | 保存される内容 |
| --- | --- |
| `Colorpicker` | 16 進カラー **と** 透明度 |
| `Dropdown` | 選択中の値 |
| `Input` | テキストの値 |
| `Keybind` | 割り当てられたキー |
| `Slider` | 既定値（`Value.Default`） |
| `Toggle` | 真偽値 |

## 設定の保存場所

設定はルートの `ANUI/` フォルダー内、ウィンドウの `Folder` の下に書き込まれます。

```
ANUI/<Folder>/config/<name>.json
```

例えば `Folder = "MyHub"` の場合、`default` という名前の設定は `ANUI/MyHub/config/default.json` に置かれます。

::: warning エグゼキュータのファイル関数が必要
保存と読み込みはファイルシステムを操作します。エグゼキュータがファイル関連のグローバル —— `readfile`、`writefile`、`isfile`、`makefolder`（および関連ヘルパー）—— を提供している必要があります。これらがないと、`:Save()` と `:Load()` は何も永続化できません。
:::

## 設定マネージャー —— `Window.ConfigManager`

`Window.ConfigManager` は名前付きの設定ファイルを作成・管理します。

### `ConfigManager:CreateConfig(filename, autoload?)`

名前を指定して設定を作成（または開いて）し、**設定オブジェクト**を返します。`autoload` を指定すると自動読み込み対象として印を付けられます。`ConfigManager:Config(...)` は別名です。

```lua
local ConfigManager = Window.ConfigManager
local config = ConfigManager:CreateConfig("default")
```

### `ConfigManager:GetConfig(name)`

既存の名前に対応する設定オブジェクトを返します（`.AutoLoad` などのフィールドを参照できます）。

### `ConfigManager:GetAutoLoadConfigs()`

自動読み込み対象として印が付いた設定を（JSON 文字列として）返します。

### `ConfigManager:DeleteConfig(name)`

名前を指定して設定ファイルを削除します。

### `ConfigManager:AllConfigs()`

すべての設定名の配列を返します —— Dropdown に流し込むのに便利です。

```lua
local names = ConfigManager:AllConfigs() -- { "default", "pvp", ... }
```

## 設定オブジェクト

`CreateConfig` / `Config` / `GetConfig` はいずれも、以下のメソッドを持つ設定オブジェクト（`ConfigModule`）を返します。

### `config:SetAsCurrent()`

この設定を `Window.CurrentConfig` として印を付け、新しく Flag を付けたエレメントがこの設定に登録されるようにします。

### `config:Register(name, element)`

エレメントを手動でキーに登録します（通常は不要です —— `Flag` が代わりに行ってくれます）。

### `config:Set(key, value)` / `config:Get(key)`

Flag とは別に、任意のカスタムデータを保存・読み出しします。

```lua
config:Set("lastPlayer", game.Players.LocalPlayer.Name)
print(config:Get("lastPlayer"))
```

### `config:SetAutoLoad(bool)`

この設定を自動読み込み対象として印を付ける（または外す）します。

### `config:Save()`

登録済みのすべての Flag とカスタム値をディスクに書き込みます。成功すると真値を返します。

### `config:Load()`

ファイルを読み込み、登録済みの各エレメントを復元します。成功すると真値を返します。

### `config:Delete()`

この設定のファイルを削除します。

### `config:GetData()`

設定が現在保持しているデータテーブル全体を返します。

## `Window.CurrentConfig`

`Window.CurrentConfig` は有効な設定オブジェクトを保持します。Flag 付きのエレメントはここに登録され、UI から操作したときに `:SetAutoLoad`、`:Save`、`:Load` が対象とするのもこの設定です。保存や読み込みの前に、対象の設定を指しておいてください。

```lua
Window.CurrentConfig = ConfigManager:CreateConfig("default")
Window.CurrentConfig:Load()
```

## 保存 / 読み込み UI の完全な例

名前入力、既存設定の Dropdown、自動読み込みの Toggle、保存 / 読み込みボタンを備えた設定パネル一式。サンプルスクリプトの「Config Usage」タブをもとにしています。

```lua
local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- 保存 / 読み込みする設定の名前
local ConfigNameInput = ConfigTab:Input({
    Title = "設定名",
    Icon = "file-cog",
    Callback = function(value)
        ConfigName = value
    end,
})

-- 現在の設定の自動読み込みを切り替える
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "選択中の設定を自動読み込みする",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})

-- 既存のすべての設定を一覧する Dropdown
local AllConfigs = ConfigManager:AllConfigs()
local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil

local AllConfigsDropdown = ConfigTab:Dropdown({
    Title = "すべての設定",
    Desc = "既存の設定を選択します",
    Values = AllConfigs,
    Value = DefaultValue,
    Callback = function(value)
        ConfigName = value
        ConfigNameInput:Set(value)
        AutoLoadToggle:Set((ConfigManager:GetConfig(ConfigName)).AutoLoad or false)
    end,
})

-- 現在の状態を ConfigName に保存する
ConfigTab:Button({
    Title = "設定を保存",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:Config(ConfigName)
        if Window.CurrentConfig:Save() then
            ANUI:Notify({
                Title = "設定を保存しました",
                Content = "設定 '" .. ConfigName .. "' を保存しました",
                Icon = "check",
            })
        end
        -- 新規作成した設定が表示されるように Dropdown を更新する
        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

-- ConfigName を UI に読み込む
ConfigTab:Button({
    Title = "設定を読み込む",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
        if Window.CurrentConfig:Load() then
            ANUI:Notify({
                Title = "設定を読み込みました",
                Content = "設定 '" .. ConfigName .. "' を読み込みました",
                Icon = "refresh-cw",
            })
        end
    end,
})
```

## 関連

- [設定システムのサンプル](/ja/examples/config-system) —— そのままコピーして使える完全な解説。
