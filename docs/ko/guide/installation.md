# 설치

ANUI는 한 줄로 로드할 수 있습니다. 별도의 다운로드나 의존성 설치가 필요하지 않습니다.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## 동작 방식

- `game:HttpGet(url)`이 GitHub에서 ANUI 빌드를 가져옵니다.
- `loadstring(...)`이 코드를 실행 가능한 함수로 변환합니다.
- 마지막 `()`이 함수를 호출하고 ANUI 테이블을 반환합니다.

## 로드 확인

```lua
print(ANUI.Version)
```

버전 문자열이 출력되면 정상적으로 로드된 것입니다.

::: warning 실행 환경 요구 사항
`loadstring`과 `game:HttpGet`이 필요합니다. Config 저장 및 `SaveKey`를 사용하려면 `readfile`, `writefile`, `isfile`, `makefolder` 등의 파일 API도 필요합니다.
:::

## 캐시 문제

개발 중 오래된 빌드가 계속 로드된다면 cache-busting query를 사용할 수 있습니다.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v=" .. math.random()))()
```

프로덕션에서는 일반적으로 query를 제거하는 것을 권장합니다.

## 문제 해결

### `ANUI`가 `nil`입니다

`loadstring` 또는 `HttpGet`이 실패했는지 확인하고 실행 환경에서 두 기능을 지원하는지 확인하세요.

### 화면에 아무것도 표시되지 않습니다

라이브러리를 로드하는 것만으로는 UI가 표시되지 않습니다. `ANUI:CreateWindow()`로 창을 생성해야 합니다.

[빠른 시작 →](./getting-started)
