# Config & Flags

ANUI는 `Flag`를 지정한 상태형 Element의 값을 Config 파일에 저장하고 다시 불러올 수 있습니다.

::: warning `Folder` 필요
Config System은 `Window.ConfigManager`를 사용하며 `CreateWindow()`에 `Folder`가 지정되어 있어야 합니다.
:::

## Flag 사용

```lua
Main:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(value)
        print(value)
    end,
})
```

다음 Element가 상태를 저장할 수 있습니다.

- `Toggle` — boolean
- `Slider` — 값
- `Dropdown` — 선택 값
- `Input` — 텍스트
- `Keybind` — 키
- `Colorpicker` — 색상 및 투명도

## Config 생성

```lua
local ConfigManager = Window.ConfigManager
local config = ConfigManager:CreateConfig("default")
Window.CurrentConfig = config
```

또는 alias인 `Config()`를 사용할 수 있습니다.

```lua
Window.CurrentConfig = ConfigManager:Config("default")
```

## 저장 및 불러오기

```lua
Window.CurrentConfig:Save()
Window.CurrentConfig:Load()
```

Config는 일반적으로 다음 구조로 저장됩니다.

```text
ANUI/<Folder>/config/<name>.json
```

## ConfigManager 주요 API

| API | 설명 |
| --- | --- |
| `CreateConfig(name, autoload?)` | Config 생성 또는 열기 |
| `Config(name)` | `CreateConfig` alias |
| `GetConfig(name)` | 기존 Config 가져오기 |
| `AllConfigs()` | 모든 Config 이름 반환 |
| `DeleteConfig(name)` | Config 삭제 |
| `GetAutoLoadConfigs()` | Auto Load Config 목록 |

## Config 객체

```lua
config:Set("lastPlayer", game.Players.LocalPlayer.Name)
print(config:Get("lastPlayer"))

config:SetAutoLoad(true)
config:Save()
```

::: tip
저장/불러오기는 실행 환경의 파일 API(`readfile`, `writefile`, `isfile`, `makefolder`)가 필요합니다.
:::

[Config System 예제 →](../examples/config-system)
