# インストール

ANUI は 1 行でインストールできます —— ダウンロードも依存関係も不要です。スクリプトの先頭に貼り付ければ、すぐ作り始められます。

## インストール

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

### この 1 行の中身

- `game:HttpGet(url)` が GitHub から最新の ANUI ソースを文字列として取得します。
- `loadstring(...)` がその文字列を実行可能な関数にコンパイルします。
- 末尾の `()` がそれを呼び出し、ANUI のライブラリテーブルを返します。
- 結果は `ANUI` という名前のローカル変数に格納されます。このサイトのすべての例は、この変数のメソッドを呼び出します（`ANUI:CreateWindow`、`ANUI:Notify` など）。

::: tip 開発中のキャッシュ回避
`HttpGet` のレスポンスをキャッシュするエグゼキュータもあるため、修正しても古いビルドが読み込まれ続けることがあります。ランダムなクエリ文字列を付けると、毎回新しいコピーを強制できます。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v="..math.random()))()
```

本番では `?v=`... の部分を外して、通常どおりキャッシュされるようにしましょう。
:::

## 読み込めたか確認する

バージョンを出力して、ライブラリが使える状態かを確かめます。

```lua
print(ANUI.Version)
```

バージョン文字列が表示されれば、ANUI は正しく読み込まれています。

::: warning エグゼキュータの要件
ANUI には `loadstring` と `game:HttpGet` に対応したエグゼキュータが必要です。

設定の保存とキーシステムの `SaveKey` オプションには、さらにファイル系のグローバル関数 `readfile`、`writefile`、`isfile`、`makefolder` が必要です。これらがなくても UI は動作します —— ディスクへの永続化だけが使えなくなります。
:::

## トラブルシューティング

::: details ANUI が `nil` になる / "attempt to call a nil value"
`loadstring` または `HttpGet` が何も返していません。エグゼキュータが両方に対応していること、`raw.githubusercontent.com` ドメインをブロックしていないことを確認してください。上記のキャッシュ回避用 `?v=` クエリを付けて再実行してみましょう。
:::

::: details HttpGet が無効 / リクエストが失敗する
HTTP リクエストを設定で制限しているエグゼキュータもあります。エグゼキュータ側で HTTP / HttpGet を有効にしてから、スクリプトを再実行してください。
:::

::: details 画面に何も表示されない
ライブラリを読み込むだけでは何も描画されません。実際にウィンドウを作成しているか確認してください —— [クイックスタート](/ja/guide/getting-started)を参照。
:::

---

次へ: [クイックスタート](/ja/guide/getting-started)
