# Key System

Key System은 Window가 열리기 전에 key prompt를 표시하고 입력된 key를 검증합니다.

## 기본 사용

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "계속하려면 key를 입력하세요.",
        Key = { "free-key" },
        SaveKey = true,
    },
})
```

## 주요 설정

| Field | 설명 |
| --- | --- |
| `Title` | Key prompt 제목 |
| `Note` | 안내 문구 |
| `Thumbnail` | 미리보기 이미지 |
| `URL` | Get key 버튼이 복사할 URL |
| `Key` | 허용할 key 또는 key 배열 |
| `KeyValidator` | 사용자 지정 검증 함수 |
| `SaveKey` | 승인된 key를 로컬에 저장 |
| `API` | 외부 key provider 설정 |

## 검증 순서

ANUI는 다음 순서로 확인합니다.

1. `KeyValidator`
2. `Key`
3. `API` provider

## Custom Validator

```lua
KeySystem = {
    KeyValidator = function(key)
        return key == "VIP-" .. game.Players.LocalPlayer.UserId
    end,
}
```

::: warning 필요한 권한
`SaveKey`는 파일 API가 필요하고, API provider는 HTTP 요청 기능이 필요합니다. 로컬 `Key`와 `KeyValidator`는 이러한 기능 없이도 사용할 수 있습니다.
:::

지원되는 provider의 전체 옵션은 [영문 Key System 문서](../../features/key-system)에서 확인할 수 있습니다.
