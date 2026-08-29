# 다국어 지원

ANUI는 `loc:` 접두사를 사용하는 간단한 Localization 시스템을 제공합니다.

## 활성화

```lua
ANUI:Localization({
    Enabled = true,
    DefaultLanguage = "en",
    Translations = {
        en = {
            welcome = "Welcome!",
            settings = "Settings",
        },
        ko = {
            welcome = "환영합니다!",
            settings = "설정",
        },
    },
})
```

## 번역 문자열 사용

```lua
local Tab = Window:Tab({
    Title = "loc:settings",
    Icon = "settings",
})

Tab:Button({
    Title = "loc:welcome",
    Callback = function() end,
})
```

활성 언어의 translation table에서 `settings`, `welcome` 같은 key를 찾습니다.

## 언어 변경

```lua
ANUI:SetLanguage("ko")
```

Localization이 활성화된 경우 런타임에 언어를 변경할 수 있습니다.

::: tip
`loc:`로 시작하지 않는 문자열은 그대로 표시됩니다. 번역 key가 없더라도 원래 문자열이 표시되므로 UI가 깨지지 않습니다.
:::
