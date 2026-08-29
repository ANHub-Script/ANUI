# Key System

키 시스템은 윈도우가 열리기 전에 표시되는 키 프롬프트 뒤에 메뉴를 잠급니다. [`ANUI:CreateWindow{}`](/guide/window-configuration)에 `KeySystem` 테이블을 전달하여 구성합니다. ANUI는 키를 로컬에서, 사용자 정의 함수에 대해, 또는 내장 키 공급자를 통해 검증할 수 있습니다.

## 기본 사용법

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Enter your key to continue.",
        Key = { "free-key" },
        SaveKey = true,
    },
})
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | window `Title` | 키 프롬프트의 제목입니다. 윈도우의 제목으로 대체됩니다. |
| `Note` | `string` | — | 제목 아래에 표시되는 안내 텍스트입니다. |
| `Thumbnail` | `table` | — | 미리보기 이미지: `{ Image, Title?, Width = 200 }`입니다. |
| `URL` | `string` | — | 이 URL을 클립보드에 복사하는 **Get key** 버튼을 표시합니다. |
| `Key` | `string` \| `array` | — | 로컬에서 검증되는, 승인된 키 또는 키 목록입니다. |
| `KeyValidator` | `function` | — | `fn(key) -> boolean`. **가장 높은 우선순위**를 갖는 사용자 정의 검사입니다. |
| `SaveKey` | `boolean` | — | `true`일 때 승인된 키를 `ANUI/<Folder>/<hwid>.key`에 기록하여 사용자에게 다시 묻지 않습니다. |
| `API` | `array` | — | 하나 이상의 키 공급자 서비스 구성입니다([Providers](#providers) 참조). |

::: warning 실행기 파일 및 HTTP 함수가 필요합니다
`SaveKey`는 키 파일을 읽고 쓰므로 실행기 파일 전역 함수(`readfile`/`writefile`/`isfile`)와 파일명을 위한 `gethwid`가 필요합니다. `API` 공급자는 키를 검증하기 위해 HTTP 요청을 하므로 `game:HttpGet`/request 지원이 필요합니다. 로컬 `Key`와 `KeyValidator` 검사는 이들 중 어느 것도 없이 작동합니다.
:::

## 검증 우선순위

사용자가 키를 제출하면 ANUI는 다음 순서로 검사하고 첫 번째 일치에서 멈춥니다:

1. **`KeyValidator`** — 제공된 경우 사용자 정의 함수입니다.
2. **`Key`** — 로컬 키 또는 키 목록입니다.
3. **`API`** — 구성된 공급자 서비스를 순서대로 검사합니다.

## Providers

`API`의 각 항목은 `Type`과 해당 공급자의 필수 인수를 갖는 테이블입니다. 항목은 프롬프트에 표시되는 방식을 사용자 정의하기 위해 `Icon`, `Title`, `Desc`를 함께 가질 수도 있습니다.

| `Type` | 필수 인수 | 비고 |
| --- | --- | --- |
| `luarmor` | `ScriptId`, `Discord` | Luarmor 키 서비스. |
| `platoboost` | `ServiceId`, `Secret` | Platoboost 키 서비스. |
| `pandadevelopment` | `ServiceId` | Panda Development 키 서비스. |
| `github` | `Owner`, `Repo`, `URL`, `Secret` | 24시간 수명을 갖는 여러분 자신의 기기당 키, 데이터베이스는 GitHub 저장소에 커밋됩니다. [GitHub Key System](/features/github-key-system) 참조. |

```lua
API = {
    {
        Type = "luarmor",
        ScriptId = "your-script-id",
        Discord = "https://discord.gg/qN47S3mKZA",
        Icon = "key",          -- optional
        Title = "Luarmor",     -- optional
        Desc = "Get a key",    -- optional
    },
}
```

## 예제

### SaveKey와 함께하는 정적 키

여러 고정 키 중 하나를 승인하고 작동한 키를 기억합니다.

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Title = "My Hub — Key",
        Note = "Get your key from the Discord.",
        URL = "https://discord.gg/qN47S3mKZA",
        Key = { "key1", "key2" },
        SaveKey = true,
    },
})
```

### 사용자 정의 검증기

`KeyValidator`는 입력된 키를 문자열로 받아 불리언을 반환합니다. `Key` 목록과 `API` 서비스보다 먼저 실행됩니다.

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Enter your personal key.",
        KeyValidator = function(key)
            -- accept any key that ends with the player's UserId
            return key == "VIP-" .. game.Players.LocalPlayer.UserId
        end,
    },
})
```

### Luarmor 공급자

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Verify your Luarmor key.",
        API = {
            {
                Type = "luarmor",
                ScriptId = "your-script-id",
                Discord = "https://discord.gg/qN47S3mKZA",
            },
        },
    },
})
```

### Platoboost 공급자

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Verify your Platoboost key.",
        SaveKey = true,
        API = {
            {
                Type = "platoboost",
                ServiceId = "your-service-id",
                Secret = "your-secret",
            },
        },
    },
})
```

## 참고

- [GitHub Key System](/features/github-key-system) — 여러분 자신의 GitHub Pages 사이트에서 생성되는, 24시간 수명을 갖는 기기당 키.
- [Window Configuration](/guide/window-configuration) — `KeySystem`과 `Folder`가 설정되는 곳.
