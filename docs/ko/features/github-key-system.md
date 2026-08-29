---
outline: deep
---

# GitHub Key System

`github` 키 공급자는 플레이어가 여러분의 GitHub Pages 사이트에서 생성하는, **기기당 하나의 키**를 발급하며 이는 **24시간** 동안 유효합니다. 키 데이터베이스는 GitHub 저장소에 커밋된 JSON 파일이므로, 호스팅할 서버도 없고 중간에 개입하는 서드파티 키 서비스도 없습니다.

- **기기당** — 키는 실행기 HWID에서 파생된 지문에 바인딩됩니다.
- **24시간** — 수명은 구성 가능하며, 기본값은 24입니다.
- **언제든 재생성 가능** — 다시 생성하면 이전 키가 즉시 무효화됩니다.
- **실시간** — 라이브러리는 매 검사마다 캐시 버스터와 함께 `raw.githubusercontent.com`에서 데이터베이스를 직접 읽습니다.

## 작동 방식

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

원본 HWID는 절대 실행기를 떠나지 않습니다. 잘린 SHA-256 해시 — 지문 — 만이 공개 저장소에 도달합니다.

두 가지 요소가 만료를 속이기 어렵게 만듭니다:

- **타임스탬프는 GitHub에서 옵니다.** 생성기 페이지와 라이브러리 모두 HTTP `Date` 응답 헤더를 읽으므로, 시스템 시계를 되돌려도 키가 연장되지 않습니다.
- **모든 레코드는 서명됩니다.** `sig = HMAC-SHA256(secret, "key|fingerprint|issued_at|expires_at")`이며, 32개의 16진수 문자로 잘립니다. 데이터베이스를 손으로 편집하면 해당 항목이 무효화됩니다.

## 설정

### 1. 데이터베이스 생성

키를 보관할 저장소에 시드 파일을 커밋하세요:

```json
{
  "version": 1,
  "updated_at": 0,
  "ttl_hours": 24,
  "keys": {}
}
```

기본 경로는 `db/keys.json`입니다. 이를 `.gitignore`에 추가하지 마세요 — 생성기가 여기에 커밋하고 라이브러리가 이를 읽습니다.

::: tip 별도의 저장소를 사용하세요
데이터베이스를 자체 저장소(예: `YourName/ANUI-Keys`)에 두면 생성기 페이지의 토큰이 라이브러리 소스에 접근할 수 없게 됩니다. 이는 이 설정에서 가장 가치 있는 예방 조치입니다.
:::

### 2. 토큰 생성

GitHub에서: **Settings → Developer settings → Personal access tokens → Fine-grained tokens**.

| 설정 | 값 |
| --- | --- |
| Type | **Fine-grained**, 절대 classic이 아님 |
| Repository access | 키 데이터베이스 저장소만 |
| Permissions | **Contents → Read and write**, 그 외에는 없음 |
| Expiration | 감당할 수 있는 한 짧게, 그 후 교체 |

### 3. 생성기 구성 빌드

```bash
node build/keygen-config.js
```

프롬프트는 저장소, 키 형식, 수명, 쿨다운 및 브랜딩을 다룹니다; 토큰과 HMAC 시크릿은 숨겨진 채로 입력되며 절대 표시되지 않습니다. 스크립트는 `docs/public/getkey/config.js`를 작성하고 HMAC 시크릿과 함께 바로 붙여넣을 수 있는 `KeySystem` 블록을 출력합니다.

비대화형, CI용:

```bash
ANUI_GH_TOKEN=github_pat_... ANUI_HMAC_SECRET=your-secret node build/keygen-config.js --yes
```

| 플래그 | 환경 변수 | 기본값 |
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
| `--site-url` | `ANUI_SITE_URL` | 소유자와 저장소로부터 파생됨 |
| `--token` | `ANUI_GH_TOKEN` | 프롬프트로 입력, 숨김 |
| `--secret` | `ANUI_HMAC_SECRET` | 프롬프트로 입력, 숨김(비어 있으면 생성됨) |

### 4. 페이지 배포

생성기는 `docs/public/getkey/`에 있으며, VitePress가 이를 그대로 복사하므로 문서가 게시된 후에는 다음 위치에서 접근할 수 있습니다:

```
https://<owner>.github.io/<repo>/getkey/
```

### 5. 스크립트에 연결

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

`Secret`은 생성기 구성의 HMAC 시크릿과 일치해야 하며, 그렇지 않으면 모든 키가 서명 검사에 실패합니다.

## 공급자 인수

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Type` | `string` | — | 반드시 `"github"`여야 합니다. |
| `Owner` | `string` | — | 데이터베이스 저장소를 소유한 사용자 또는 조직입니다. |
| `Repo` | `string` | — | 데이터베이스를 보관하는 저장소입니다. |
| `Branch` | `string` | `"main"` | 읽을 브랜치입니다. |
| `DBPath` | `string` | `"db/keys.json"` | 저장소 내 데이터베이스의 경로입니다. |
| `URL` | `string` | — | 생성기 페이지의 공개 URL입니다. **Get key**는 여기에 `#fp=<fingerprint>`를 덧붙여 복사합니다. |
| `Secret` | `string` | — | HMAC 시크릿입니다. 비워 두면 서명 검사를 건너뜁니다(권장하지 않음). |
| `Folder` | `string` | window `Folder` | ANUI가 채웁니다; 오프라인 캐시가 기록되는 위치를 제어합니다. |

`Icon`, `Title`, `Desc`는 다른 모든 공급자에서와 마찬가지로 여기서도 작동하며, **Get key** 드롭다운의 행에만 영향을 줍니다.

## 플레이어가 보는 것

1. 메뉴를 엽니다 — 키 프롬프트가 나타납니다.
2. **Get key**를 누르고 공급자 행을 선택합니다. 이미 이 기기의 지문을 담고 있는 링크가 클립보드에 복사됩니다.
3. 브라우저에서 열어 **Generate key**를 누르고 키를 복사합니다.
4. 프롬프트에 붙여넣습니다.

`SaveKey = true`이면 승인된 키가 `ANUI/<Folder>/<hwid>.key`에 기록되므로, 키가 만료될 때까지 다음 실행 시 프롬프트를 건너뜁니다.

## 검증

라이브러리는 먼저 키를 온라인으로 검사합니다:

1. `GET https://raw.githubusercontent.com/<owner>/<repo>/<branch>/<path>?cb=<unique>` — 캐시 버스터가 몇 분 단위의 CDN 캐시를 무력화하여 읽기를 실시간으로 만듭니다.
2. `keys[<fingerprint>]`를 조회합니다. 항목이 없거나 `revoked`이면 이 기기에 대한 키가 없다는 뜻입니다.
3. 입력된 키를 저장된 키와 비교합니다 — 재생성된 키는 여기서 이전 키가 실패하게 만듭니다.
4. 서명을 검증한 후, GitHub의 `Date` 헤더에 대해 만료를 검증합니다.

성공하면 결과가 `ANUI/<Folder>/<fingerprint>.keycache`에 캐시됩니다. 캐시는 HTTP 요청 자체가 실패할 때를 위한 대비책일 뿐입니다: 서버가 이미 확인하지 않은 키를 절대 확인할 수 없으며, `expires_at`보다 오래 지속되지 않고, 서버 측 거부가 있을 때마다 삭제됩니다.

## 데이터베이스 형식

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

| 필드 | 의미 |
| --- | --- |
| `key` | 플레이어가 붙여넣는 키입니다. 기기당 하나이며 — 새 키가 이를 덮어씁니다. |
| `sig` | `HMAC-SHA256(secret, "key\|fingerprint\|issued_at\|expires_at")[0..31]`입니다. |
| `issued_at` / `expires_at` | GitHub의 시계에서 가져온 유닉스 초입니다. |
| `regen` | 이 기기가 키를 생성한 횟수입니다. |
| `revoked` | 기록을 삭제하지 않고 기기를 차단하려면 손으로 `true`로 설정합니다. |

키는 `0123456789ABCDEFGHJKMNPQRSTVWXYZ` 알파벳을 사용합니다 — `I`, `L`, `O`, `U`가 없으므로 — 소리 내어 읽은 키가 모호하지 않습니다.

::: tip 정리
만료된 레코드는 무해하지만 파일이 커집니다. 언제든 오래된 항목을 삭제하세요; Contents API는 약 1 MB를 넘으면 파일 내용을 인라인으로 넣는 것을 중단하며, 거기에 도달하면 생성기가 이를 알려줍니다.
:::

## 보안

::: danger 토큰은 공개됩니다
GitHub Pages는 정적 호스팅입니다. `config.js`의 토큰은 모든 방문자의 브라우저로 전달됩니다. 그 파일의 뒤섞기(scrambling)는 GitHub의 시크릿 스캐너가 토큰을 자동으로 무효화하는 것을 막고 무심한 복사-붙여넣기를 저지하기 위해 존재합니다 — **이것은 암호화가 아닙니다.** 파일을 읽는 누구나 토큰을 복구하여 자신의 키를 발행하거나, 토큰이 접근할 수 있는 모든 곳에 쓸 수 있습니다.

그렇기 때문에:

- 키 저장소로만 범위가 지정된, **Contents → Read and write**를 유일한 권한으로 갖는 **fine-grained** 토큰을 사용하세요.
- 데이터베이스를 라이브러리 소스와 **별도의 저장소**에 두세요.
- 만료를 설정하고 교체하세요.
- 이것을 라이선스 서버가 아니라 *성가심 방지*로 취급하세요.
:::

나중에 유출에 강한 설정을 원한다면, 쓰기 경로를 작은 프록시 — Cloudflare Worker 또는 `repository_dispatch` GitHub Action — 뒤로 옮기고 `config.js`에서 토큰을 삭제하세요. Lua 라이브러리에서는 아무것도 바뀌지 않습니다: 라이브러리는 언제나 데이터베이스를 읽기만 합니다.

HMAC 시크릿은 같은 파일에 실려 있으며 마찬가지로 복구 가능합니다. 그 가치는 데이터베이스를 손으로 편집하면 항목이 무효화된다는 점에 있으며, 이것이 도난당하거나 손으로 작성한 레코드가 검증을 통과하지 못하게 막습니다.

## 문제 해결

| 증상 | 원인 |
| --- | --- |
| 페이지에 *Generator not configured* 표시 | `config.js`가 여전히 예제 상태입니다. `node build/keygen-config.js`를 실행하세요. |
| *the token is invalid or expired* | 토큰이 무효화, 만료되었거나 GitHub 스캐닝이 감지했습니다. 새로 발행하세요. |
| *the token lacks Contents: read and write* | 권한이 잘못되었거나 토큰이 해당 저장소로 범위가 지정되지 않았습니다. |
| *the repository, branch or path does not exist* | `owner`, `repo`, `branch`, `dbPath`를 확인하세요; fine-grained 토큰은 범위 밖의 저장소를 볼 수 없습니다. |
| 페이지에서 *Signature mismatch* | 데이터베이스가 페이지 밖에서 편집되었거나 시크릿이 변경되었습니다. 다시 생성하세요. |
| 게임 내에서 *Key signature is invalid* | 스크립트의 `Secret`이 생성기의 시크릿과 다릅니다. |
| *No key issued for this device yet* | 기기에 레코드가 없습니다. **Get key**를 누르고 생성한 후 붙여넣으세요. |
| 생성 직후에도 키가 여전히 거부됨 | 라이브러리가 캐시된 사본을 읽었습니다 — 제출을 다시 누르세요; 읽기는 캐시 버스터를 담고 있으며 몇 초 내에 안정됩니다. |
| 게임 내에서 아무 일도 일어나지 않음 | 실행기에 `request`/`gethwid`가 없습니다. 둘 다 필요합니다. |

## 참고

- [Key System](/features/key-system) — 주변의 `KeySystem` 구성과 다른 공급자들.
- [Window Configuration](/guide/window-configuration) — `KeySystem`과 `Folder`가 설정되는 곳.




