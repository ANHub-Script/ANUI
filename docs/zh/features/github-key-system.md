---
outline: deep
---

# GitHub 密钥系统

`github` 密钥提供者会**按设备发放密钥**，有效期 **24 小时**，由玩家在你自己的 GitHub Pages 站点上生成。密钥数据库就是一个提交到 GitHub 仓库的 JSON 文件，因此既不需要自建服务器，也不依赖第三方密钥服务。

- **按设备** —— 密钥绑定到由执行器 HWID 派生出的指纹。
- **24 小时** —— 有效期可配置，默认为 24。
- **随时可重新生成** —— 再次生成会立即让上一个密钥失效。
- **实时** —— 库在每次校验时都直接从 `raw.githubusercontent.com` 读取数据库，并附带缓存破坏参数。

## 工作方式

```
执行器                        你的 GitHub Pages 站点         GitHub 仓库
------                        ---------------------          -----------
SHA-256(HWID)[0..31]
   │  “Get key” 复制
   │  .../getkey/#fp=<指纹>
   ▼
   ├──────────────────────▶ 生成 ANUI-XXXXX-XXXXX-XXXXX
   │                        用 HMAC-SHA256 签名
   │                        写入 keys[<指纹>] ──────────────▶ db/keys.json
   │
   ◀── 玩家把密钥粘贴回输入框
   │
   └── 读取 db/keys.json ◀──────────────────────────────────── raw.githubusercontent.com
       校验指纹、有效期与签名
```

原始 HWID 永远不会离开执行器。进入公开仓库的只有它被截断的 SHA-256 哈希 —— 即指纹。

有两点让有效期难以被绕过：

- **时间戳来自 GitHub。** 生成页面和库都读取 HTTP 响应头 `Date`，所以把系统时间往回调并不能延长密钥。
- **每条记录都有签名。** `sig = HMAC-SHA256(secret, "key|fingerprint|issued_at|expires_at")`，截断为 32 个十六进制字符。手工改动数据库会让该条目失效。

## 配置步骤

### 1. 创建数据库

向存放密钥的仓库提交一个初始文件：

```json
{
  "version": 1,
  "updated_at": 0,
  "ttl_hours": 24,
  "keys": {}
}
```

默认路径是 `db/keys.json`。不要把它加进 `.gitignore` —— 生成器要向它提交，库要读取它。

::: tip 使用独立仓库
把数据库放在自己的仓库里（例如 `你的名字/ANUI-Keys`），生成页面上的令牌就无法触及库的源码。这是本方案中最有价值的一道防线。
:::

### 2. 创建令牌

在 GitHub：**Settings → Developer settings → Personal access tokens → Fine-grained tokens**。

| 设置项 | 取值 |
| --- | --- |
| 类型 | **Fine-grained**，绝不要用 classic |
| 仓库访问 | 仅密钥数据库所在仓库 |
| 权限 | **Contents → Read and write**，其他一律不给 |
| 有效期 | 越短越好，然后定期轮换 |

### 3. 生成前端配置

```bash
node build/keygen-config.js
```

交互提示涵盖仓库、密钥格式、有效期、冷却时间和品牌信息；令牌与 HMAC 密钥以隐藏方式输入，绝不回显。脚本会写出 `docs/public/getkey/config.js`，并打印 HMAC 密钥以及可直接粘贴的 `KeySystem` 代码块。

非交互方式，适合 CI：

```bash
ANUI_GH_TOKEN=github_pat_... ANUI_HMAC_SECRET=你的密钥 node build/keygen-config.js --yes
```

| 参数 | 环境变量 | 默认值 |
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
| `--site-url` | `ANUI_SITE_URL` | 由 owner 与 repo 推导 |
| `--token` | `ANUI_GH_TOKEN` | 隐藏输入 |
| `--secret` | `ANUI_HMAC_SECRET` | 隐藏输入（留空则自动生成） |

### 4. 部署页面

生成器位于 `docs/public/getkey/`，VitePress 会原样复制该目录，因此文档发布后可通过以下地址访问：

```
https://<owner>.github.io/<repo>/getkey/
```

### 5. 接入你的脚本

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "为此设备生成密钥，有效期 24 小时。",
        SaveKey = true,
        API = {
            {
                Type = "github",
                Owner = "ANHub-Script",
                Repo = "ANUI-Keys",
                Branch = "main",
                DBPath = "db/keys.json",
                URL = "https://anhub-script.github.io/ANUI/getkey/",
                Secret = "keygen-config 打印出的密钥",
            },
        },
    },
})
```

`Secret` 必须与生成器配置中的 HMAC 密钥一致，否则所有密钥都会在签名校验时失败。

## 提供者参数

| 字段 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `Type` | `string` | — | 必须为 `"github"`。 |
| `Owner` | `string` | — | 数据库仓库的所属用户或组织。 |
| `Repo` | `string` | — | 存放数据库的仓库。 |
| `Branch` | `string` | `"main"` | 读取的分支。 |
| `DBPath` | `string` | `"db/keys.json"` | 数据库在仓库中的路径。 |
| `URL` | `string` | — | 生成页面的公开地址。**Get key** 会在其后附加 `#fp=<指纹>` 再复制。 |
| `Secret` | `string` | — | HMAC 密钥。留空则跳过签名校验（不推荐）。 |
| `Folder` | `string` | 窗口的 `Folder` | 由 ANUI 自动填入；决定离线缓存的写入位置。 |

`Icon`、`Title` 与 `Desc` 的行为与其他提供者一致，只影响 **Get key** 下拉列表中的那一行。

## 玩家看到的流程

1. 打开菜单 —— 出现密钥输入框。
2. 按 **Get key** 并选择对应的提供者行。已带上本设备指纹的链接会被复制到剪贴板。
3. 在浏览器中打开，按 **Generate key**，复制密钥。
4. 粘贴回输入框。

设置 `SaveKey = true` 时，通过校验的密钥会写入 `ANUI/<Folder>/<hwid>.key`，因此在密钥过期前，下次启动会跳过输入框。

## 校验过程

库优先在线校验：

1. `GET https://raw.githubusercontent.com/<owner>/<repo>/<branch>/<path>?cb=<唯一值>` —— 缓存破坏参数击穿了 CDN 长达数分钟的缓存，这正是读取能做到实时的原因。
2. 查找 `keys[<指纹>]`。没有条目或标记为 `revoked`，即表示该设备没有密钥。
3. 将输入的密钥与存储值比对 —— 已被重新生成的旧密钥会在这一步失败。
4. 校验签名，再用 GitHub 的 `Date` 响应头判断是否过期。

成功后结果会缓存到 `ANUI/<Folder>/<指纹>.keycache`。该缓存仅在 HTTP 请求本身失败时作为兜底：它永远无法确认服务器没有确认过的密钥，绝不会活过 `expires_at`，并且在服务器每次拒绝时都会被删除。

## 数据库格式

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

| 字段 | 含义 |
| --- | --- |
| `key` | 玩家粘贴的密钥。每台设备仅一个 —— 新密钥会覆盖它。 |
| `sig` | `HMAC-SHA256(secret, "key\|fingerprint\|issued_at\|expires_at")[0..31]`。 |
| `issued_at` / `expires_at` | Unix 秒，取自 GitHub 的时钟。 |
| `regen` | 该设备已生成过多少次密钥。 |
| `revoked` | 手动设为 `true` 即可封禁某台设备而不删除其历史记录。 |

密钥使用字母表 `0123456789ABCDEFGHJKMNPQRSTVWXYZ` —— 不含 `I`、`L`、`O`、`U` —— 因此念出来不会有歧义。

::: tip 清理
过期记录无害，但文件会变大。你可以随时删除旧条目；Contents API 在文件超过约 1 MB 后不再内联返回内容，真到那一步生成器会明确提示。
:::

## 安全性

::: danger 令牌是公开的
GitHub Pages 是静态托管。`config.js` 中的令牌会被送到每一位访问者的浏览器。该文件里的混淆只是为了避免 GitHub 的密钥扫描自动吊销令牌，并阻止随手复制 —— **它不是加密**。任何读到该文件的人都能还原令牌，进而自行签发密钥，或写入该令牌可触及的任何地方。

因此：

- 使用 **fine-grained** 令牌，范围仅限密钥仓库，唯一权限为 **Contents → Read and write**。
- 把数据库放在与库源码**分开的仓库**中。
- 设置有效期并定期轮换。
- 把它当作*防骚扰措施*，而不是授权服务器。
:::

若日后想要不会泄露的方案，可把写入路径移到一个小型代理之后 —— Cloudflare Worker 或使用 `repository_dispatch` 的 GitHub Action —— 然后从 `config.js` 中删掉令牌。Lua 库无需任何改动：它只负责读取数据库。

HMAC 密钥同样存放在这个文件里，也同样可被还原。它的价值在于：数据库无法在不破坏条目签名的情况下被手工修改，这正是让被盗或伪造的记录无法通过校验的原因。

## 排查

| 现象 | 原因 |
| --- | --- |
| 页面显示 *Generator not configured* | `config.js` 仍是示例文件。运行 `node build/keygen-config.js`。 |
| *the token is invalid or expired* | 令牌被吊销、已过期，或被 GitHub 扫描捕获。重新生成一个。 |
| *the token lacks Contents: read and write* | 权限不对，或令牌未限定到该仓库。 |
| *the repository, branch or path does not exist* | 检查 `owner`、`repo`、`branch` 与 `dbPath`；fine-grained 令牌看不到范围之外的仓库。 |
| 页面提示 *Signature mismatch* | 数据库在页面之外被修改过，或密钥变了。重新生成即可。 |
| 游戏内提示 *Key signature is invalid* | 脚本中的 `Secret` 与生成器的密钥不一致。 |
| *No key issued for this device yet* | 该设备还没有记录。按 **Get key**，生成，再粘贴。 |
| 刚生成的密钥仍被拒绝 | 库读到了缓存副本 —— 再次提交即可；读取都带缓存破坏参数，数秒内即可一致。 |
| 游戏内毫无反应 | 执行器缺少 `request`/`gethwid`。两者都是必需的。 |

## 参见

- [密钥系统](/zh/features/key-system) —— 外层的 `KeySystem` 配置与其他提供者。
- [窗口配置](/zh/guide/window-configuration) —— `KeySystem` 与 `Folder` 的设置位置。





