# 설치

ANUI는 단 한 줄로 설치됩니다 — 다운로드도, 의존성도 없습니다. 스크립트 맨 위에 붙여넣기만 하면 바로 만들 준비가 됩니다.

## 설치

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

### 동작 방식

- `game:HttpGet(url)`은 GitHub에서 최신 ANUI 소스를 문자열로 다운로드합니다.
- `loadstring(...)`은 그 문자열을 실행 가능한 함수로 컴파일합니다.
- 끝에 붙은 `()`가 함수를 호출하여 ANUI 라이브러리 테이블을 반환합니다.
- 결과는 `ANUI`라는 로컬 변수에 저장됩니다 — 이 사이트의 모든 예제는 이 변수의 메서드를 호출합니다(`ANUI:CreateWindow`, `ANUI:Notify` 등).

::: tip 개발 중 캐시 우회
일부 실행기는 `HttpGet` 응답을 캐시하므로, 반복 작업 중에 계속 오래된 빌드가 나올 수 있습니다. 무작위 쿼리 문자열을 덧붙여 새 복사본을 강제로 받아오세요:

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v="..math.random()))()
```

응답이 정상적으로 캐시될 수 있도록 프로덕션에서는 `?v=`... 부분을 제거하세요.
:::

## 로드 확인

버전을 출력하여 라이브러리를 사용할 수 있는지 확인하세요:

```lua
print(ANUI.Version)
```

버전 문자열이 보이면 ANUI가 올바르게 로드된 것입니다.

::: warning 실행기 요구 사항
ANUI는 `loadstring`과 `game:HttpGet`을 지원하는 실행기가 필요합니다.

구성 저장과 키 시스템의 `SaveKey` 옵션은 추가로 파일 전역 함수 `readfile`, `writefile`, `isfile`, `makefolder`가 필요합니다. 이들이 없어도 UI는 여전히 동작합니다 — 디스크 저장만 사용할 수 없습니다.
:::

## 문제 해결

::: details ANUI가 `nil`임 / "attempt to call a nil value"
`loadstring` 또는 `HttpGet`이 아무것도 반환하지 않았습니다. 실행기가 둘 다 지원하는지, 그리고 `raw.githubusercontent.com` 도메인을 차단하고 있지 않은지 확인하세요. 위에 표시된 캐시 우회용 `?v=` 쿼리를 추가한 뒤 다시 실행하세요.
:::

::: details HttpGet이 비활성화됨 / 요청 실패
일부 실행기는 HTTP 요청을 설정으로 제어합니다. 실행기에서 HTTP / HttpGet을 활성화한 뒤 스크립트를 다시 실행하세요.
:::

::: details 화면에 아무것도 나타나지 않음
라이브러리를 불러오기만 해서는 아무것도 렌더링되지 않습니다. 실제로 창을 생성했는지 확인하세요 — [빠른 시작](/guide/getting-started)을 참고하세요.
:::

---

다음: [빠른 시작](/guide/getting-started)
