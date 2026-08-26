# 設定システム

保存 / 読み込みの完全なレシピ: 値が永続化される Flag 付きエレメント、ディスクから一覧を作る設定ピッカー、保存 / 読み込みボタン、自動読み込みの Toggle。デモの **Config Usage** タブをもとにしています。

::: warning エグゼキュータのファイルアクセスが必要
設定の保存はディスク上の JSON ファイルを読み書きするため、エグゼキュータがファイル関連のグローバル `readfile`、`writefile`、`isfile`、`makefolder` に対応している必要があります。設定は `ANUI/<Folder>/config/<name>.json` に保存され、`<Folder>` は `CreateWindow` に渡した `Folder` です。
:::

## 1. エレメントに Flag を付ける

状態を持つエレメント（Toggle、Slider、Dropdown、Input、Keybind、Colorpicker）に `Flag` キーを付けると、有効な設定へ自動登録されます。値は保存時に書き込まれ、読み込み時に復元されます —— エレメントごとに追加のコードを書く必要はありません。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "マイ Hub",
    Author = "作成者: あなた",
    Folder = "MyHub", -- 設定機能に必須 —— ディスク上のルートになる
})

local Tab = Window:Tab({ Title = "設定", Icon = "sliders-horizontal" })

-- 各 `Flag` が、保存される JSON ファイル内のキーになる。
Tab:Toggle({
    Flag = "AutoFarm",
    Title = "オートファーム",
    Callback = function(state) print("Auto Farm:", state) end,
})

Tab:Slider({
    Flag = "WalkSpeed",
    Title = "歩行速度",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) print("Walk Speed:", value) end,
})

Tab:Dropdown({
    Flag = "Weapon",
    Title = "武器",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value) print("Weapon:", value) end,
})
```

## 2. ConfigManager を取得して現在の設定を決める

`Folder` を渡したので `Window.ConfigManager` は自動的に作られています。設定名を変数に保持し、あらかじめ 1 つの設定を**現在の設定**にしておくことで、Flag の値が常に保存先を持つようにします。

```lua
local ConfigTab = Window:Tab({ Title = "設定ファイル", Icon = "folder" })

local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- 現在の設定が存在するようにしておく。`:Config(name)` は作成または既存を開く（:CreateConfig の別名）。
Window.CurrentConfig = ConfigManager:Config(ConfigName)
```

## 3. 設定名の入力欄

保存 / 読み込みする設定の名前をユーザーに入力させます。入力値は `ConfigName` に戻して保持します。

```lua
local ConfigNameInput = ConfigTab:Input({
    Title = "設定名",
    Icon = "file-cog",
    Value = ConfigName,
    Callback = function(value)
        ConfigName = value
    end,
})
```

## 4. 自動読み込みの Toggle

`ConfigModule:SetAutoLoad(bool)` は、起動時に自動で読み込む設定として印を付けます。ここでは現在の設定に対して呼び出します。

```lua
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "この設定を自動読み込みする",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})
```

## 5. 「すべての設定」の Dropdown

`ConfigManager:AllConfigs()` は、すでにディスクにあるすべての設定名を返します。このリストを Dropdown に流し込み、既存の設定を選べるようにします。選択されたら名前の入力欄を同期し、その設定に保存されている自動読み込みの状態（`.AutoLoad` フィールドから読み取り）を反映します。

```lua
local AllConfigs = ConfigManager:AllConfigs()

local AllConfigsDropdown = ConfigTab:Dropdown({
    Title = "すべての設定",
    Desc = "既存の設定を選択します",
    Values = AllConfigs,
    Value = table.find(AllConfigs, ConfigName) and ConfigName or nil,
    Callback = function(value)
        ConfigName = value
        ConfigNameInput:Set(value)
        AutoLoadToggle:Set((ConfigManager:GetConfig(ConfigName)).AutoLoad or false)
    end,
})
```

## 6. 保存ボタンと読み込みボタン

保存ボタンは `ConfigName` を現在の設定にして `:Save()` を呼びます。成功したら通知を出し、新規作成した設定が一覧に現れるように Dropdown を更新します。読み込みボタンは設定を開いて `:Load()` を呼び、Flag 付きのすべての値を復元します。

```lua
ConfigTab:Button({
    Title = "設定を保存",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:Config(ConfigName)
        if Window.CurrentConfig:Save() then
            ANUI:Notify({ Title = "設定を保存しました", Content = "'" .. ConfigName .. "' を保存しました", Icon = "check" })
        end
        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

ConfigTab:Button({
    Title = "設定を読み込む",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
        if Window.CurrentConfig:Load() then
            ANUI:Notify({ Title = "設定を読み込みました", Content = "'" .. ConfigName .. "' を読み込みました", Icon = "refresh-cw" })
        end
    end,
})
```

::: info
`:Config(name)` と `:CreateConfig(name)` は別名です —— どちらも設定ファイルが存在しなければ作成し、あれば開きます。`:Save()` と `:Load()` は成功時に真値を返すため、上のボタンは処理がうまくいったときにだけ通知を出します。
:::

Flag のワークフロー全体、永続化されるエレメントの種類一覧、`ConfigManager` / `ConfigModule` のすべてのメソッドについては、[設定と Flag](/ja/features/config-and-flags) を参照してください。
