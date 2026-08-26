# Code

コピーボタンを備えた、コード表示用のブロック。スニペット、コマンド、インストール用の 1 行などを、ワンクリックでコピーできる形で見せるのに最適です。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Code({
    Title = "Lua",
    Code = "print('Hello, world!')"
})
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | コードブロックの上に表示するラベル。 |
| `Code` | `string` | `nil` | 表示するコードのテキスト。 |
| `OnCopy` | `function` | `nil` | コードがクリップボードにコピーされたあとに実行されます。 |

::: info コピーについて
コピーボタンは**エグゼキュータのクリップボード**に書き込みます。コピーに失敗した場合は、代わりに通知が表示されます。
:::

## メソッド

### `Code:SetCode(code)`

表示中のコードを新しい文字列に置き換えます。

```lua
mySnippet:SetCode("print('updated!')")
```

### `Code:Destroy()`

コードブロックをコンテナから削除します。

```lua
mySnippet:Destroy()
```

## 例

### Lua スニペットのブロック

```lua
myTab:Code({
    Title = "Lua",
    Code = "print('Hello from Group 1')"
})
```

### コピー後にコールバックを実行する

```lua
myTab:Code({
    Title = "インストール",
    Code = 'loadstring(game:HttpGet("https://example.com/script.lua"))()',
    OnCopy = function()
        print("Copied!")
    end
})
```

### `SetCode` でコードを更新する

返されたモジュールを保持しておき、あとから中身を差し替えます。

```lua
local snippet = myTab:Code({
    Title = "例",
    Code = "print('initial')"
})

myTab:Button({
    Title = "コードを更新",
    Callback = function()
        snippet:SetCode("print('updated!')")
    end
})
```
