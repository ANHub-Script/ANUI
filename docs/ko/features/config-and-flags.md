# Config & Flags

ANUI는 메뉴의 상태를 디스크에 저장하고 복원할 수 있습니다. 저장 가능한 요소에 `Flag`를 지정하면, 설정을 저장할 때 그 값이 기록되고 불러올 때 복원됩니다 — 수동으로 관리할 필요가 없습니다.

::: info 윈도우 `Folder`가 필요합니다
설정 시스템은 `Window.ConfigManager`로 구동되며, 이는 윈도우가 `Folder`와 함께 생성되었을 때만 존재합니다. 이 페이지의 기능을 사용하기 전에 [`ANUI:CreateWindow{}`](/guide/window-configuration)에서 하나를 설정하세요.
:::

## 플래그의 작동 방식

저장 가능한 모든 요소는 `Flag = "key"`를 받습니다. 이를 설정하면:

1. 요소가 **현재 설정**(`Window.CurrentConfig`)에 자동으로 등록됩니다.
2. 해당 설정에서 `:Save()`를 호출하면 등록된 각 플래그의 값이 JSON 파일에 기록됩니다.
3. `:Load()`를 호출하면 파일을 다시 읽어 각 요소를 저장된 값으로 복원합니다.

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm", -- this value is now persistable
    Callback = function(v) print(v) end,
})
```

현재 설정이 존재하기 전에 생성된 요소의 플래그는 대기열에 들어가며, 다음 `:Save()` 또는 `:Load()` 시점에 처리되어 등록됩니다.

## 저장되는 항목

다음 요소 형식만 상태를 직렬화합니다. 그 외의 요소는 설정 시스템에서 무시됩니다.

| 요소 | 저장되는 값 |
| --- | --- |
| `Colorpicker` | 16진수 색상 **및** 투명도 |
| `Dropdown` | 선택된 값 |
| `Input` | 텍스트 값 |
| `Keybind` | 바인딩된 키 |
| `Slider` | 기본값 (`Value.Default`) |
| `Toggle` | 불리언 값 |

## 설정이 저장되는 위치

설정은 윈도우의 `Folder` 안에 있는 루트 `ANUI/` 폴더 아래에 기록됩니다:

```
ANUI/<Folder>/config/<name>.json
```

예를 들어 `Folder = "MyHub"`인 경우, `default`라는 이름의 설정은 `ANUI/MyHub/config/default.json`에 저장됩니다.

::: warning 실행기 파일 함수가 필요합니다
저장과 불러오기는 파일 시스템에 접근합니다. 실행기는 파일 전역 함수 — `readfile`, `writefile`, `isfile`, `makefolder`(및 관련 헬퍼) — 를 제공해야 합니다. 이들이 없으면 `:Save()`와 `:Load()`는 아무것도 저장할 수 없습니다.
:::

## 설정 관리자 — `Window.ConfigManager`

`Window.ConfigManager`는 이름이 지정된 설정 파일을 생성하고 관리합니다.

### `ConfigManager:CreateConfig(filename, autoload?)`

이름으로 설정을 생성(또는 엽니다)하고 **설정 객체**를 반환합니다. `autoload`는 선택적으로 자동 불러오기 대상으로 표시합니다. `ConfigManager:Config(...)`는 별칭입니다.

```lua
local ConfigManager = Window.ConfigManager
local config = ConfigManager:CreateConfig("default")
```

### `ConfigManager:GetConfig(name)`

기존 이름에 대한 설정 객체를 반환합니다(`.AutoLoad`와 같은 필드를 노출합니다).

### `ConfigManager:GetAutoLoadConfigs()`

자동 불러오기로 표시된 설정을 (JSON 문자열로) 반환합니다.

### `ConfigManager:DeleteConfig(name)`

이름으로 설정 파일을 삭제합니다.

### `ConfigManager:AllConfigs()`

모든 설정 이름의 배열을 반환합니다 — 드롭다운을 채우는 데 유용합니다.

```lua
local names = ConfigManager:AllConfigs() -- { "default", "pvp", ... }
```

## 설정 객체

`CreateConfig`/`Config`/`GetConfig`는 모두 다음 메서드를 갖는 설정 객체(`ConfigModule`)를 반환합니다.

### `config:SetAsCurrent()`

이 설정을 `Window.CurrentConfig`로 표시하여, 새로 플래그가 지정된 요소가 여기에 등록되도록 합니다.

### `config:Register(name, element)`

키를 기준으로 요소를 수동으로 등록합니다(보통 불필요합니다 — `Flag`가 대신 처리합니다).

### `config:Set(key, value)` / `config:Get(key)`

플래그와 함께 임의의 사용자 정의 데이터를 저장하고 읽습니다.

```lua
config:Set("lastPlayer", game.Players.LocalPlayer.Name)
print(config:Get("lastPlayer"))
```

### `config:SetAutoLoad(bool)`

이 설정을 자동으로 불러오도록 표시(또는 표시 해제)합니다.

### `config:Save()`

등록된 모든 플래그와 사용자 정의 값을 디스크에 기록합니다. 성공 시 참 값을 반환합니다.

### `config:Load()`

파일을 읽어 등록된 각 요소를 복원합니다. 성공 시 참 값을 반환합니다.

### `config:Delete()`

이 설정의 파일을 삭제합니다.

### `config:GetData()`

설정이 현재 보유하고 있는 전체 데이터 테이블을 반환합니다.

## `Window.CurrentConfig`

`Window.CurrentConfig`는 활성 설정 객체를 보유합니다. 플래그가 지정된 요소가 여기에 등록되며, UI에서 구동될 때 `:SetAutoLoad`, `:Save`, `:Load`가 작용하는 대상이 바로 이 설정입니다. 저장하거나 불러오기 전에 이를 특정 설정으로 지정하세요:

```lua
Window.CurrentConfig = ConfigManager:CreateConfig("default")
Window.CurrentConfig:Load()
```

## 완전한 저장 / 불러오기 UI

완전한 설정 패널: 이름 입력, 기존 설정 드롭다운, 자동 불러오기 토글, 저장 / 불러오기 버튼. 예제 스크립트의 "Config Usage" 탭을 각색했습니다.

```lua
local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- Name of the config to save/load
local ConfigNameInput = ConfigTab:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Callback = function(value)
        ConfigName = value
    end,
})

-- Toggle auto-load for the current config
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "Enable Auto Load to Selected Config",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})

-- Dropdown listing every existing config
local AllConfigs = ConfigManager:AllConfigs()
local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil

local AllConfigsDropdown = ConfigTab:Dropdown({
    Title = "All Configs",
    Desc = "Select existing configs",
    Values = AllConfigs,
    Value = DefaultValue,
    Callback = function(value)
        ConfigName = value
        ConfigNameInput:Set(value)
        AutoLoadToggle:Set((ConfigManager:GetConfig(ConfigName)).AutoLoad or false)
    end,
})

-- Save the current state into ConfigName
ConfigTab:Button({
    Title = "Save Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:Config(ConfigName)
        if Window.CurrentConfig:Save() then
            ANUI:Notify({
                Title = "Config Saved",
                Content = "Config '" .. ConfigName .. "' saved",
                Icon = "check",
            })
        end
        -- refresh the dropdown so a brand-new config appears
        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

-- Load ConfigName back into the UI
ConfigTab:Button({
    Title = "Load Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
        if Window.CurrentConfig:Load() then
            ANUI:Notify({
                Title = "Config Loaded",
                Content = "Config '" .. ConfigName .. "' loaded",
                Icon = "refresh-cw",
            })
        end
    end,
})
```

## 참고

- [Config System 예제](/examples/config-system) — 완전하며 복사해서 붙여넣을 수 있는 안내.
