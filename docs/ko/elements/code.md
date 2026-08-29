# Code

복사 버튼이 내장된 문법 스타일 코드 블록입니다. 사용자가 한 번에 복사할 수 있는 코드 조각, 명령 또는 설치 줄을 표시하기에 적합합니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Code({
    Title = "Lua",
    Code = "print('Hello, world!')"
})
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | 코드 블록 위에 표시할 레이블입니다. |
| `Code` | `string` | `nil` | 표시할 코드 텍스트입니다. |
| `OnCopy` | `function` | `nil` | 코드를 클립보드에 복사한 후 실행합니다. |

::: info 복사
복사 버튼은 **실행기 클립보드**에 내용을 기록합니다. 복사에 실패하면 대신 알림이 표시됩니다.
:::

## 메서드

### `Code:SetCode(code)`

표시된 코드를 새 문자열로 바꿉니다.

```lua
mySnippet:SetCode("print('updated!')")
```

### `Code:Destroy()`

컨테이너에서 코드 블록을 제거합니다.

```lua
mySnippet:Destroy()
```

## 예제

### Lua 코드 조각 블록

```lua
myTab:Code({
    Title = "Lua",
    Code = "print('Hello from Group 1')"
})
```

### 복사 후 콜백 실행

```lua
myTab:Code({
    Title = "Install",
    Code = 'loadstring(game:HttpGet("https://example.com/script.lua"))()',
    OnCopy = function()
        print("Copied!")
    end
})
```

### `SetCode`로 코드 갱신

반환된 모듈을 보관하면 나중에 내용을 교체할 수 있습니다.

```lua
local snippet = myTab:Code({
    Title = "Example",
    Code = "print('initial')"
})

myTab:Button({
    Title = "Update code",
    Callback = function()
        snippet:SetCode("print('updated!')")
    end
})
```
