# クイックスタート

はじめての ANUI メニューを、順を追って作っていきます。最後には、トグル・ボタン・スライダーを持つタブと通知を備えたウィンドウ —— 完全に動くスクリプトが完成します。

## 1. ANUI を読み込む

どのスクリプトも、まずライブラリを `ANUI` というローカル変数に読み込むところから始まります。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## 2. ウィンドウを作成する

`ANUI:CreateWindow` は `Window` オブジェクトを返します。以降のすべてはこれに追加していきます。`Folder` は設定やキーをディスク上に保存する場所です。

```lua
local Window = ANUI:CreateWindow({
    Title = "マイ Hub",
    Author = "作成者: あなた",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})
```

すべてのオプションは[ウィンドウ設定](/ja/guide/window-configuration)を参照してください。

## 3. タブを追加する

タブがエレメントの入れ物になります。`Window:Tab` で作成します。

```lua
local Main = Window:Tab({ Title = "メイン", Icon = "house" })
```

## 4. エレメントを追加する

タブのメソッドを呼ぶだけでエレメントを追加できます。各コールバックが受け取る引数に注目してください。

- **Toggle** —— コールバックは `boolean`（新しい ON/OFF 状態）を受け取ります。
- **Button** —— コールバックは**引数を受け取りません**。
- **Slider** —— コールバックは**整形済みの文字列**（step に応じて整形された値）を受け取ります。

```lua
Main:Toggle({
    Title = "Auto Farm",
    Desc = "コインを自動で集めます",
    Callback = function(state) -- state: boolean
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "何かする",
    Callback = function() -- 引数なし
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: 整形済み文字列
        print("Walk Speed:", value)
    end
})
```

## 5. 通知を表示する

`ANUI:Notify` はトーストを表示します。アイコンのフィールドは `Icon`、本文のフィールドは `Content` です。

```lua
ANUI:Notify({
    Title = "こんにちは！",
    Content = "ANUI へようこそ",
    Icon = "bell",
    Duration = 3,
})
```

## スクリプト全体

ここまでをまとめると次のようになります。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "マイ Hub",
    Author = "作成者: あなた",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})

local Main = Window:Tab({ Title = "メイン", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Desc = "コインを自動で集めます",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "何かする",
    Callback = function()
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value)
        print("Walk Speed:", value)
    end
})

ANUI:Notify({
    Title = "こんにちは！",
    Content = "ANUI へようこそ",
    Icon = "bell",
    Duration = 3,
})
```

## 次のステップ

- [ウィンドウ設定](/ja/guide/window-configuration)でウィンドウを細かく設定する。
- [エレメント概要](/ja/elements/)ですべてのエレメントを見る。
