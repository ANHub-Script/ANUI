# Localization

ANUI에는 내장 번역 계층이 있습니다. 언어별로 번역을 등록하고 시스템을 활성화하면, 지역화 접두사(`loc:`)로 시작하는 모든 문자열이 조회되어 활성 언어의 번역으로 대체됩니다.

## 지역화 활성화

### `ANUI:Localization(config)`

번역 테이블을 등록하고 시스템을 켭니다. 창을 생성하기 전이나 직후에 한 번만 일찍 호출하십시오.

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Enabled` | `boolean` | `false` | 마스터 스위치입니다. 번역이 이루어지려면 `true`여야 합니다. |
| `Translations` | `table` | `{}` | 언어 코드 → `{ key = value }` 번역 테이블의 맵입니다. |
| `Prefix` | `string` | `"loc:"` | 번역 대상 문자열을 표시하는 마커입니다. |
| `DefaultLanguage` | `string` | `"en"` | `SetLanguage`를 호출하기 전까지 사용되는 언어입니다. |

```lua
ANUI:Localization({
    Enabled = true,
    DefaultLanguage = "en",
    Translations = {
        en = {
            welcome = "Welcome!",
            settings = "Settings",
        },
        id = {
            welcome = "Selamat datang!",
            settings = "Pengaturan",
        },
    },
})
```

## 번역된 문자열 사용

제목이나 레이블 앞에 `loc:`와 번역 키를 붙이십시오. ANUI가 활성 언어의 테이블에서 이를 조회합니다.

```lua
local Tab = Window:Tab({
    Title = "loc:settings", -- shows "Settings" (en) or "Pengaturan" (id)
    Icon = "settings",
})

Tab:Button({
    Title = "loc:welcome",
    Callback = function() end,
})
```

::: info 접두사가 작동하는 방식
**접두사로 시작하는** 문자열(기본값 `loc:`)만 번역됩니다 — 접두사 뒤의 텍스트가 조회 키입니다. 다른 모든 문자열은 작성된 그대로 표시됩니다. 활성 언어에 키가 없으면 문자열이 그대로 표시되므로 아무 것도 깨지지 않습니다.
:::

## 런타임에 언어 전환

### `ANUI:SetLanguage(language)`

활성 언어를 전환합니다. 지역화가 활성화되어 있어야 하며, `Localization`을 `Enabled = true`로 호출한 적이 없으면 `false`를 반환합니다.

```lua
ANUI:SetLanguage("id") -- switch to Indonesian
```

## 전체 예제

영어 + 인도네시아어 번역을 활성화하고, 탭과 그 요소에 `loc:` 문자열을 사용하며, 사용자가 드롭다운에서 언어를 전환할 수 있게 합니다.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Localization({
    Enabled = true,
    DefaultLanguage = "en",
    Translations = {
        en = {
            title = "Control Panel",
            farm = "Auto Farm",
            language = "Language",
        },
        id = {
            title = "Panel Kontrol",
            farm = "Farm Otomatis",
            language = "Bahasa",
        },
    },
})

local Window = ANUI:CreateWindow({ Title = "loc:title" })
local Tab = Window:Tab({ Title = "loc:title", Icon = "gamepad-2" })

Tab:Toggle({
    Title = "loc:farm",
    Callback = function(on)
        print("farm:", on)
    end,
})

Tab:Dropdown({
    Title = "loc:language",
    Values = { "en", "id" },
    Value = "en",
    Callback = function(lang)
        ANUI:SetLanguage(lang)
    end,
})
```

::: tip
번역은 `loc:`로 접두사가 붙은 문자열에만 적용되므로, 지역화된 문자열과 일반 문자열이 나란히 공존할 수 있습니다 — 자유롭게 혼용하십시오.
:::
