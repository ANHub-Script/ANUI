# 基本メニュー

コピーして貼り付けてすぐ動かせる、コメントを豊富に付けた入門用メニュー。2 つのタブを持つウィンドウ、よく使われるエレメントの組み合わせ、グループ化用のセクション、ボタンから発火する通知を作ります。

## スクリプト

```lua
-- 1. ANUI を `ANUI` というローカル変数に読み込む。
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

-- 2. ウィンドウを作成する。ウィンドウは 1 つだけ存在できる。
local Window = ANUI:CreateWindow({
    Title = "マイ Hub",                     -- トップバーに表示されるタイトル
    Author = "作成者: あなた",               -- タイトルの下のサブタイトル
    Icon = "rbxassetid://84366761557806",  -- トップバーのアイコン（アセット ID または Lucide のアイコン名）
    Folder = "MyHub",                      -- 設定 / キーを保存するディスク上のフォルダー（ANUI/MyHub 以下）
    OpenButton = {                         -- 閉じたウィンドウを開き直すフローティングボタン
        Title = "マイ Hub",
        Enabled = true,
        Draggable = true,
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
    },
})

-- 3. タブを追加する。各タブはエレメントを保持し、サイドバーに表示される。
local Main = Window:Tab({ Title = "メイン", Icon = "house" })
local Settings = Window:Tab({ Title = "設定", Icon = "settings" })

-- 4. Paragraph はリッチテキストのブロック —— タブ先頭の導入文に最適。
Main:Paragraph({
    Title = "ようこそ",
    Desc = "この入門メニューでは、ANUI の代表的なエレメントを紹介します。",
})

-- Toggle —— コールバックは真偽値（新しいオン / オフの状態）を受け取る。
Main:Toggle({
    Title = "オートファーム",
    Desc = "コインを自動で集めます",
    Value = false,
    Callback = function(state) -- state: 真偽値
        print("Auto Farm:", state)
    end,
})

-- Slider —— コールバックは整形済みの文字列（step に合わせて整形された値）を受け取る。
Main:Slider({
    Title = "歩行速度",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: 整形済みの文字列
        print("Walk Speed:", value)
    end,
})

-- 5. Section は関連するエレメントを折りたたみ可能なヘッダーの下にまとめる。
--    コンテナなので、エレメントはセクション自身に対して作成する。
local combat = Main:Section({ Title = "戦闘" })

-- Dropdown —— 単一選択のコールバックは選択された値（ここでは文字列）を受け取る。
combat:Dropdown({
    Title = "武器",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value) -- value: 選択された項目
        print("Weapon:", value)
    end,
})

-- Keybind —— コールバックはキー名を文字列として受け取る（例: "G"）。
combat:Keybind({
    Title = "攻撃キー",
    Value = "G",
    Callback = function(key) -- key: キー名の文字列
        print("Attack bound to:", key)
    end,
})

-- 6. Button のコールバックは引数を受け取らない。ここでは通知を出している。
Settings:Button({
    Title = "あいさつする",
    Icon = "bell",
    Callback = function() -- 引数なし
        ANUI:Notify({
            Title = "こんにちは！",
            Content = "ANUI へようこそ",
            Icon = "bell",
            Duration = 3,
        })
    end,
})
```

## 各パートの役割

- **読み込み行** —— ライブラリを取得して `ANUI` に代入します。どのサンプルもこの形で始まります。
- **`ANUI:CreateWindow`** —— 構築の起点となる `Window` を返します。`Folder` は設定やキーがディスク上に置かれる場所で、`OpenButton` はウィンドウを開き直すためのドラッグ可能なフローティングボタンを追加します。[ウィンドウ設定](/ja/guide/window-configuration)を参照してください。
- **`Window:Tab`** —— 各タブはサイドバーのページであり、エレメントのコンテナです。
- **エレメント** —— コンテナ（Tab や Section）のメソッドを呼んで作成します。後で更新したい場合は、返された値を保持しておきましょう。
- **`Main:Section`** —— Tab と同じエレメント作成メソッドを持つ折りたたみ可能なコンテナで、関連するコントロールをまとめられます。
- **`ANUI:Notify`** —— トーストを表示します。本文のフィールドは（`Desc` ではなく）`Content`、アイコンのフィールドは `Icon` です。

::: tip 各エレメントを詳しく学ぶ
すべてのエレメントには、設定テーブルとメソッドを網羅した専用ページがあります: [Toggle](/ja/elements/toggle)、[Slider](/ja/elements/slider)、[Dropdown](/ja/elements/dropdown)、[Button](/ja/elements/button)、[Keybind](/ja/elements/keybind)、[Paragraph](/ja/elements/paragraph)、[Section](/ja/elements/section)。一覧は[エレメント概要](/ja/elements/)で確認できます。
:::
