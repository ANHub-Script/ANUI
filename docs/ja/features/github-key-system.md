---
outline: deep
---

# GitHub キーシステム

`github` キープロバイダーは、**デバイスごとに 1 つ**、**有効期間 24 時間**のキーを発行します。キーはプレイヤー自身が、あなたの GitHub Pages サイトで生成します。キーのデータベースは GitHub リポジトリにコミットされる JSON ファイルなので、サーバーを用意する必要も、サードパーティのキーサービスを挟む必要もありません。

- **デバイスごと** —— キーはエグゼキュータの HWID から導かれるフィンガープリントに紐づきます。
- **24 時間** —— 有効期間は設定可能で、既定は 24 です。
- **いつでも再生成できる** —— もう一度生成すると、以前のキーは即座に無効になります。
- **リアルタイム** —— ライブラリは検証のたびに、キャッシュバスターを付けて `raw.githubusercontent.com` から直接データベースを読みます。

## 仕組み

```
エグゼキュータ                あなたの GitHub Pages サイト     GitHub リポジトリ
--------                     ----------------------         -----------
SHA-256(HWID)[0..31]
   │  「キーを取得」でコピーされる
   │  .../getkey/#fp=<fingerprint>
   ▼
   ├──────────────────────▶ ANUI-XXXXX-XXXXX-XXXXX を生成
   │                        HMAC-SHA256 で署名
   │                        keys[<fingerprint>] を書き込む ──▶ db/keys.json
   │
   ◀── プレイヤーがキーを入力画面に貼り付ける
   │
   └── db/keys.json を読む ◀─────────────────────────────────── raw.githubusercontent.com
       フィンガープリント、有効期限、署名を検証
```

生の HWID がエグゼキュータの外に出ることはありません。公開リポジトリに届くのは、その SHA-256 ハッシュを切り詰めたフィンガープリントだけです。

有効期限を偽装しにくくしている要素が 2 つあります。

- **タイムスタンプは GitHub 由来。** 生成ページとライブラリはどちらも HTTP の `Date` レスポンスヘッダーを読むため、システム時刻を巻き戻してもキーの期限は延びません。
- **すべてのレコードに署名がある。** `sig = HMAC-SHA256(secret, "key|fingerprint|issued_at|expires_at")` を 32 桁の 16 進文字に切り詰めたものです。データベースを手作業で編集するとエントリーは無効になります。

## セットアップ

### 1. データベースを作成する

キーを保持するリポジトリに、初期ファイルをコミットします。

```json
{
  "version": 1,
  "updated_at": 0,
  "ttl_hours": 24,
  "keys": {}
}
```

既定のパスは `db/keys.json` です。`.gitignore` に追加しないでください —— 生成ページがここにコミットし、ライブラリがここを読みます。

::: tip 専用のリポジトリを使う
データベースを独立したリポジトリ（例: `YourName/ANUI-Keys`）に置けば、生成ページのトークンがライブラリのソースに触れられなくなります。この構成で最も価値のある予防策です。
:::

### 2. トークンを作成する

GitHub で: **Settings → Developer settings → Personal access tokens → Fine-grained tokens**。

| 設定 | 値 |
| --- | --- |
| 種類 | **Fine-grained**（classic は使わない） |
| リポジトリのアクセス | キーデータベースのリポジトリのみ |
| 権限 | **Contents → Read and write** のみ |
| 有効期限 | 許容できる限り短くし、定期的にローテーション |

### 3. 生成ページの設定を作る

```bash
node build/keygen-config.js
```

対話では、リポジトリ、キーの形式、有効期間、クールダウン、ブランディングを設定します。トークンと HMAC シークレットは入力が隠され、画面に表示されることはありません。スクリプトは `docs/public/getkey/config.js` を書き出し、HMAC シークレットと、そのまま貼り付けられる `KeySystem` ブロックを出力します。

CI 用の非対話モード:

```bash
ANUI_GH_TOKEN=github_pat_... ANUI_HMAC_SECRET=your-secret node build/keygen-config.js --yes
```

| フラグ | 環境変数 | デフォルト |
| --- | --- | --- |
| `--owner` | `ANUI_GH_OWNER` | `ANHub-Script` |
| `--repo` | `ANUI_GH_REPO` | `ANUI` |
| `--branch` | `ANUI_GH_BRANCH` | `main` |
| `--db-path` | `ANUI_DB_PATH` | `db/keys.json` |
| `--prefix` | `ANUI_KEY_PREFIX` | `ANUI` |
| `--ttl` | `ANUI_TTL_HOURS` | `24` |
| `--cooldown` | `ANUI_COOLDOWN` | `0` |
| `--brand` | `ANUI_BRAND` | `ANUI` |
| `--discord` | `ANUI_DISCORD` | — |
| `--site-url` | `ANUI_SITE_URL` | owner と repo から導出 |
| `--token` | `ANUI_GH_TOKEN` | 入力を促す（非表示） |
| `--secret` | `ANUI_HMAC_SECRET` | 入力を促す（非表示。空なら自動生成） |

### 4. ページを公開する

生成ページは `docs/public/getkey/` にあり、VitePress がそのままコピーします。ドキュメントを公開すると、次の URL でアクセスできます。

```
https://<owner>.github.io/<repo>/getkey/
```

### 5. スクリプトに組み込む

```lua
ANUI:CreateWindow({
    Title = "マイ Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "このデバイス用のキーを生成してください。有効期間は 24 時間です。",
        SaveKey = true,
        API = {
            {
                Type = "github",
                Owner = "ANHub-Script",
                Repo = "ANUI-Keys",
                Branch = "main",
                DBPath = "db/keys.json",
                URL = "https://anhub-script.github.io/ANUI/getkey/",
                Secret = "the-secret-printed-by-keygen-config",
            },
        },
    },
})
```

`Secret` は生成ページの設定にある HMAC シークレットと一致していなければなりません。一致しないと、すべてのキーが署名検証で失敗します。

## プロバイダーの引数

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Type` | `string` | — | `"github"` である必要があります。 |
| `Owner` | `string` | — | データベースのリポジトリを所有するユーザーまたは組織。 |
| `Repo` | `string` | — | データベースを保持するリポジトリ。 |
| `Branch` | `string` | `"main"` | 読み取り対象のブランチ。 |
| `DBPath` | `string` | `"db/keys.json"` | リポジトリ内のデータベースのパス。 |
| `URL` | `string` | — | 生成ページの公開 URL。**キーを取得**すると、`#fp=<fingerprint>` を付けた形でコピーされます。 |
| `Secret` | `string` | — | HMAC シークレット。空にすると署名検証を省略します（非推奨）。 |
| `Folder` | `string` | ウィンドウの `Folder` | ANUI が補完します。オフラインキャッシュの書き込み先を決めます。 |

`Icon`、`Title`、`Desc` は他のプロバイダーと同じように使え、**キーを取得**のドロップダウン内の行の表示にのみ影響します。

## プレイヤーの操作の流れ

1. メニューを開く —— キー入力画面が表示されます。
2. **キーを取得**を押してプロバイダーの行を選ぶ。このデバイスのフィンガープリントが付いたリンクがクリップボードにコピーされます。
3. ブラウザで開き、**Generate key** を押してキーをコピーします。
4. 入力画面に貼り付けます。

`SaveKey = true` の場合、受理されたキーは `ANUI/<Folder>/<hwid>.key` に書き込まれるため、キーが期限切れになるまで次回起動時の入力画面はスキップされます。

## 検証

ライブラリはまずオンラインでキーを検証します。

1. `GET https://raw.githubusercontent.com/<owner>/<repo>/<branch>/<path>?cb=<unique>` —— キャッシュバスターが数分単位の CDN キャッシュを回避し、これによって読み取りがリアルタイムになります。
2. `keys[<fingerprint>]` を参照します。エントリーがない、または `revoked` の場合は、このデバイスにキーはありません。
3. 入力されたキーと保存されているキーを比較します —— 再生成された場合、古いキーはここで失敗します。
4. 署名を検証し、続いて GitHub の `Date` ヘッダーと照らして有効期限を検証します。

成功すると、結果は `ANUI/<Folder>/<fingerprint>.keycache` にキャッシュされます。このキャッシュは HTTP リクエスト自体が失敗したときのフォールバックにすぎません。サーバーがまだ承認していないキーを承認することはできず、`expires_at` を超えて生き残ることもなく、サーバー側で拒否されるたびに削除されます。

## データベースの形式

```json
{
  "version": 1,
  "updated_at": 1774440000,
  "ttl_hours": 24,
  "keys": {
    "a1b2c3d4e5f60718293a4b5c6d7e8f90": {
      "key": "ANUI-7GKQ2-XM4TB-9WHZP",
      "sig": "4f1c9ab27d3e5f60718293a4b5c6d7e8",
      "issued_at": 1774440000,
      "expires_at": 1774526400,
      "regen": 3,
      "revoked": false
    }
  }
}
```

| フィールド | 意味 |
| --- | --- |
| `key` | プレイヤーが貼り付けるキー。デバイスごとに 1 つで、新しいキーが上書きします。 |
| `sig` | `HMAC-SHA256(secret, "key\|fingerprint\|issued_at\|expires_at")[0..31]`。 |
| `issued_at` / `expires_at` | GitHub の時刻から取得した Unix 秒。 |
| `regen` | このデバイスがキーを生成した回数。 |
| `revoked` | 手作業で `true` にすると、履歴を消さずにデバイスを禁止できます。 |

キーには `0123456789ABCDEFGHJKMNPQRSTVWXYZ` の文字だけが使われます —— `I`、`L`、`O`、`U` は含まれないため、読み上げても取り違えが起きません。

::: tip 古いレコードの整理
期限切れのレコードは無害ですが、ファイルは膨らんでいきます。古いエントリーはいつでも削除してかまいません。Contents API は約 1 MB を超えるとファイル内容をインラインで返さなくなり、その状態になると生成ページがそう伝えます。
:::

## セキュリティ

::: danger トークンは公開される
GitHub Pages は静的ホスティングです。`config.js` に書かれたトークンは、すべての訪問者のブラウザに配信されます。あのファイル内での難読化は、GitHub のシークレットスキャナーによるトークンの自動失効を防ぎ、軽い気持ちのコピー＆ペーストを抑止するためのものであり、**暗号化ではありません**。ファイルを読める人は誰でもトークンを復元し、自分でキーを発行したり、そのトークンが届く範囲に書き込んだりできます。

そのため:

- **fine-grained** トークンを使い、キー用リポジトリのみにスコープを絞り、権限は **Contents → Read and write** だけにしてください。
- データベースはライブラリのソースとは**別のリポジトリ**に置いてください。
- 有効期限を設定し、ローテーションしてください。
- これはライセンスサーバーではなく、*嫌がらせ対策*程度のものと考えてください。
:::

後で漏洩しない構成にしたい場合は、書き込み経路を小さなプロキシ —— Cloudflare Worker や `repository_dispatch` の GitHub Actions —— の背後に移し、`config.js` からトークンを削除してください。Lua ライブラリ側の変更は不要です。ライブラリはデータベースを読むだけだからです。

HMAC シークレットも同じファイルに含まれるため、同様に復元可能です。その価値は、データベースを手作業で編集するとエントリーが無効になる点にあります。これが、盗まれたレコードや手書きのレコードが検証を通らないようにしています。

## トラブルシューティング

| 症状 | 原因 |
| --- | --- |
| ページに *Generator not configured* と表示される | `config.js` がサンプルのままです。`node build/keygen-config.js` を実行してください。 |
| *the token is invalid or expired* | トークンが失効、期限切れ、または GitHub のスキャンで検出されました。新しく発行してください。 |
| *the token lacks Contents: read and write* | 権限が違うか、トークンがそのリポジトリにスコープされていません。 |
| *the repository, branch or path does not exist* | `owner`、`repo`、`branch`、`dbPath` を確認してください。fine-grained トークンはスコープ外のリポジトリを見られません。 |
| ページで *Signature mismatch* | データベースがページ以外から編集されたか、シークレットが変わりました。再生成してください。 |
| ゲーム内で *Key signature is invalid* | スクリプトの `Secret` が生成ページのシークレットと異なります。 |
| *No key issued for this device yet* | そのデバイスのレコードがありません。**キーを取得**を押し、生成して貼り付けてください。 |
| 生成直後なのにキーが拒否される | ライブラリがキャッシュされたコピーを読みました —— もう一度送信してください。読み取りにはキャッシュバスターが付いており、数秒で解決します。 |
| ゲーム内で何も起きない | エグゼキュータに `request` / `gethwid` がありません。どちらも必須です。 |

## 関連

- [キーシステム](/ja/features/key-system) —— `KeySystem` 全体の設定と、その他のプロバイダー。
- [ウィンドウ設定](/ja/guide/window-configuration) —— `KeySystem` と `Folder` を設定する場所。
