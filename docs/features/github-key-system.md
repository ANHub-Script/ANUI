---
outline: deep
---

# GitHub Key System

The `github` key provider issues **one key per device**, valid for **24 hours**, that the player generates on your own GitHub Pages site. The key database is a JSON file committed to a GitHub repository, so there is no server to host and no third-party key service in the loop.

- **Per device** — a key is bound to a fingerprint derived from the executor HWID.
- **24 hours** — the lifetime is configurable; the default is 24.
- **Regenerable at any time** — generating again immediately kills the previous key.
- **Realtime** — the library reads the database straight from `raw.githubusercontent.com` on every check, with a cache buster.

## How it works

```
Executor                     Your GitHub Pages site         GitHub repo
--------                     ----------------------         -----------
SHA-256(HWID)[0..31]
   │  "Get key" copies
   │  .../getkey/#fp=<fingerprint>
   ▼
   ├──────────────────────▶ generates ANUI-XXXXX-XXXXX-XXXXX
   │                        signs it with HMAC-SHA256
   │                        writes keys[<fingerprint>] ──────▶ db/keys.json
   │
   ◀── player pastes the key back into the prompt
   │
   └── reads db/keys.json ◀──────────────────────────────────── raw.githubusercontent.com
       checks fingerprint, expiry and signature
```

The raw HWID never leaves the executor. Only its truncated SHA-256 hash — the fingerprint — reaches the public repository.

Two things make expiry hard to cheat:

- **Timestamps come from GitHub.** Both the generator page and the library read the HTTP `Date` response header, so rolling the system clock back does not extend a key.
- **Every record is signed.** `sig = HMAC-SHA256(secret, "key|fingerprint|issued_at|expires_at")`, truncated to 32 hex characters. Editing the database by hand invalidates the entry.

## Setup

### 1. Create the database

Commit a seed file to the repository that will hold the keys:

```json
{
  "version": 1,
  "updated_at": 0,
  "ttl_hours": 24,
  "keys": {}
}
```

The default path is `db/keys.json`. Do not add it to `.gitignore` — the generator commits to it and the library reads it.

::: tip Use a separate repository
Putting the database in its own repo (for example `YourName/ANUI-Keys`) means the token on the generator page cannot touch your library's source. This is the single most valuable precaution in this setup.
:::

### 2. Create a token

On GitHub: **Settings → Developer settings → Personal access tokens → Fine-grained tokens**.

| Setting | Value |
| --- | --- |
| Type | **Fine-grained**, never classic |
| Repository access | Only the key-database repository |
| Permissions | **Contents → Read and write**, nothing else |
| Expiration | As short as you can tolerate, then rotate |

### 3. Build the generator config

```bash
node build/keygen-config.js
```

The prompts cover the repository, key format, lifetime, cooldown and branding; the token and the HMAC secret are typed hidden and never echoed. The script writes `docs/public/getkey/config.js` and prints the HMAC secret plus a ready-to-paste `KeySystem` block.

Non-interactive, for CI:

```bash
ANUI_GH_TOKEN=github_pat_... ANUI_HMAC_SECRET=your-secret node build/keygen-config.js --yes
```

| Flag | Environment variable | Default |
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
| `--site-url` | `ANUI_SITE_URL` | derived from owner and repo |
| `--token` | `ANUI_GH_TOKEN` | prompted, hidden |
| `--secret` | `ANUI_HMAC_SECRET` | prompted, hidden (generated if blank) |

### 4. Deploy the page

The generator lives in `docs/public/getkey/`, which VitePress copies verbatim, so after the docs are published it is reachable at:

```
https://<owner>.github.io/<repo>/getkey/
```

### 5. Wire it into your script

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Generate a key for this device. Valid for 24 hours.",
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

`Secret` must match the HMAC secret in the generator config, otherwise every key fails the signature check.

## Provider arguments

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Type` | `string` | — | Must be `"github"`. |
| `Owner` | `string` | — | User or organization that owns the database repo. |
| `Repo` | `string` | — | Repository holding the database. |
| `Branch` | `string` | `"main"` | Branch to read. |
| `DBPath` | `string` | `"db/keys.json"` | Path to the database inside the repo. |
| `URL` | `string` | — | Public URL of the generator page. **Get key** copies it with `#fp=<fingerprint>` appended. |
| `Secret` | `string` | — | HMAC secret. Leave empty to skip signature checks (not recommended). |
| `Folder` | `string` | window `Folder` | Filled in by ANUI; controls where the offline cache is written. |

`Icon`, `Title` and `Desc` work here like on any other provider and only affect the row in the **Get key** dropdown.

## What the player sees

1. Open the menu — the key prompt appears.
2. Press **Get key** and pick the provider row. The link, already carrying this device's fingerprint, is copied to the clipboard.
3. Open it in a browser, press **Generate key**, copy the key.
4. Paste it into the prompt.

With `SaveKey = true` the accepted key is written to `ANUI/<Folder>/<hwid>.key`, so the prompt is skipped on the next launch until the key expires.

## Verification

The library checks a key online first:

1. `GET https://raw.githubusercontent.com/<owner>/<repo>/<branch>/<path>?cb=<unique>` — the cache buster defeats the multi-minute CDN cache, which is what makes reads realtime.
2. Look up `keys[<fingerprint>]`. No entry, or `revoked`, means no key for this device.
3. Compare the entered key against the stored one — a regenerated key makes the old one fail here.
4. Verify the signature, then the expiry against GitHub's `Date` header.

On success the result is cached at `ANUI/<Folder>/<fingerprint>.keycache`. The cache is only a fallback for when the HTTP request itself fails: it can never confirm a key the server has not already confirmed, it never outlives `expires_at`, and it is deleted on every server-side rejection.

## Database format

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

| Field | Meaning |
| --- | --- |
| `key` | The key the player pastes. One per device — a new one overwrites it. |
| `sig` | `HMAC-SHA256(secret, "key\|fingerprint\|issued_at\|expires_at")[0..31]`. |
| `issued_at` / `expires_at` | Unix seconds, taken from GitHub's clock. |
| `regen` | How many times this device has generated a key. |
| `revoked` | Set it to `true` by hand to ban a device without deleting its history. |

Keys use the alphabet `0123456789ABCDEFGHJKMNPQRSTVWXYZ` — no `I`, `L`, `O` or `U` — so a key read aloud is unambiguous.

::: tip Pruning
Expired records are harmless but the file grows. Delete old entries whenever you like; the Contents API stops inlining file content past about 1 MB, and the generator will say so if you get there.
:::

## Security

::: danger The token is public
GitHub Pages is static hosting. The token in `config.js` is delivered to every visitor's browser. The scrambling in that file exists to stop GitHub's secret scanner from auto-revoking the token and to deter casual copy-paste — **it is not encryption**. Anyone who reads the file can recover the token and mint their own keys, or write to whatever the token can reach.

Because of that:

- Use a **fine-grained** token, scoped to the key repo only, with **Contents → Read and write** as its single permission.
- Keep the database in a **separate repository** from your library source.
- Set an expiry and rotate it.
- Treat this as *nuisance protection*, not as a licence server.
:::

If you later want a leak-proof setup, move the write path behind a small proxy — a Cloudflare Worker or a `repository_dispatch` GitHub Action — and delete the token from `config.js`. Nothing in the Lua library changes: it only ever reads the database.

The HMAC secret ships in the same file and is equally recoverable. Its value is that the database cannot be edited by hand without invalidating the entries, which is what keeps a stolen or hand-written record from passing verification.

## Troubleshooting

| Symptom | Cause |
| --- | --- |
| Page says *Generator not configured* | `config.js` is still the example. Run `node build/keygen-config.js`. |
| *the token is invalid or expired* | Token revoked, expired, or GitHub scanning caught it. Mint a new one. |
| *the token lacks Contents: read and write* | Wrong permission or the token is not scoped to that repository. |
| *the repository, branch or path does not exist* | Check `owner`, `repo`, `branch` and `dbPath`; a fine-grained token cannot see repos outside its scope. |
| *Signature mismatch* on the page | The database was edited outside the page, or the secret changed. Regenerate. |
| *Key signature is invalid* in game | `Secret` in your script differs from the generator's secret. |
| *No key issued for this device yet* | The device has no record. Press **Get key**, generate, paste. |
| Key still rejected right after generating | The library read a cached copy — press submit again; reads carry a cache buster and settle within seconds. |
| Nothing happens in game | The executor lacks `request`/`gethwid`. Both are required. |

## See also

- [Key System](/features/key-system) — the surrounding `KeySystem` configuration and the other providers.
- [Window Configuration](/guide/window-configuration) — where `KeySystem` and `Folder` are set.





