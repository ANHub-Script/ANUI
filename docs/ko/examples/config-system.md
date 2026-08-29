# 설정 시스템

완전한 저장/불러오기 레시피입니다: 값이 유지되는 플래그가 지정된 요소, 디스크에서 채워지는 설정 선택기, 저장/불러오기 버튼, 그리고 자동 로드 토글을 다룹니다. 이것은 데모의 **Config Usage** 탭을 각색한 것입니다.

::: warning 실행기 파일 접근 필요
설정 저장은 디스크의 JSON 파일을 읽고 쓰므로, 실행기가 파일 전역 함수 `readfile`, `writefile`, `isfile`, `makefolder`를 지원해야 합니다. 설정은 `ANUI/<Folder>/config/<name>.json`에 저장되며, 여기서 `<Folder>`는 `CreateWindow`에 전달한 `Folder`입니다.
:::

## 1. 요소에 플래그 지정하기

`Flag` 키를 가진 상태 요소(Toggle, Slider, Dropdown, Input, Keybind, Colorpicker)는 활성 설정에 자동으로 등록됩니다. 해당 값은 저장 시 기록되고 불러오기 시 복원됩니다 — 요소마다 추가 코드를 작성할 필요가 없습니다.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Folder = "MyHub", -- REQUIRED for configs — this is the on-disk root
})

local Tab = Window:Tab({ Title = "Settings", Icon = "sliders-horizontal" })

-- Each `Flag` becomes a key inside the saved JSON file.
Tab:Toggle({
    Flag = "AutoFarm",
    Title = "Auto Farm",
    Callback = function(state) print("Auto Farm:", state) end,
})

Tab:Slider({
    Flag = "WalkSpeed",
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) print("Walk Speed:", value) end,
})

Tab:Dropdown({
    Flag = "Weapon",
    Title = "Weapon",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value) print("Weapon:", value) end,
})
```

## 2. ConfigManager 가져오기 및 현재 설정 지정하기

`Folder`를 전달했기 때문에 `Window.ConfigManager`가 자동으로 생성됩니다. 설정 이름을 변수에 보관하고 하나의 설정을 미리 **현재** 설정으로 만들어, 플래그가 지정된 값이 항상 저장할 곳을 갖도록 합니다.

```lua
local ConfigTab = Window:Tab({ Title = "Config", Icon = "folder" })

local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- Ensure a current config exists. `:Config(name)` creates-or-opens it (alias of :CreateConfig).
Window.CurrentConfig = ConfigManager:Config(ConfigName)
```

## 3. 설정 이름 입력란

사용자가 저장하거나 불러올 설정의 이름을 입력하도록 합니다. 이를 다시 `ConfigName`에 저장합니다.

```lua
local ConfigNameInput = ConfigTab:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Value = ConfigName,
    Callback = function(value)
        ConfigName = value
    end,
})
```

## 4. 자동 로드 토글

`ConfigModule:SetAutoLoad(bool)`은 시작 시 자동으로 불러올 설정을 표시합니다. 현재 설정에 대해 호출합니다.

```lua
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "Auto Load This Config",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})
```

## 5. "All Configs" 드롭다운

`ConfigManager:AllConfigs()`는 디스크에 이미 존재하는 모든 설정의 이름을 반환합니다. 그 목록을 드롭다운에 넣어 사용자가 기존 설정을 선택할 수 있도록 합니다. 사용자가 선택하면 이름 입력란을 동기화하고 해당 설정의 저장된 자동 로드 상태(그 설정의 `.AutoLoad` 필드에서 읽음)를 반영합니다.

```lua
local AllConfigs = ConfigManager:AllConfigs()

local AllConfigsDropdown = ConfigTab:Dropdown({
    Title = "All Configs",
    Desc = "Select an existing config",
    Values = AllConfigs,
    Value = table.find(AllConfigs, ConfigName) and ConfigName or nil,
    Callback = function(value)
        ConfigName = value
        ConfigNameInput:Set(value)
        AutoLoadToggle:Set((ConfigManager:GetConfig(ConfigName)).AutoLoad or false)
    end,
})
```

## 6. 저장 및 불러오기 버튼

저장 버튼은 `ConfigName`을 현재 설정으로 만들고 `:Save()`를 호출합니다. 성공하면 알림을 표시하고 드롭다운을 새로 고쳐 새로 만든 설정이 목록에 나타나도록 합니다. 불러오기 버튼은 설정을 열고 `:Load()`를 호출하여 플래그가 지정된 모든 값을 복원합니다.

```lua
ConfigTab:Button({
    Title = "Save Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:Config(ConfigName)
        if Window.CurrentConfig:Save() then
            ANUI:Notify({ Title = "Config Saved", Content = "Saved '" .. ConfigName .. "'", Icon = "check" })
        end
        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

ConfigTab:Button({
    Title = "Load Config",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
        if Window.CurrentConfig:Load() then
            ANUI:Notify({ Title = "Config Loaded", Content = "Loaded '" .. ConfigName .. "'", Icon = "refresh-cw" })
        end
    end,
})
```

::: info
`:Config(name)`과 `:CreateConfig(name)`은 별칭입니다 — 둘 다 설정 파일이 없으면 생성하고, 있으면 엽니다. `:Save()`와 `:Load()`는 성공 시 참 값을 반환하며, 위의 버튼들이 작업이 성공했을 때만 알림을 표시하는 이유가 바로 이것입니다.
:::

전체 플래그 워크플로, 유지되는 요소 유형 목록, 그리고 모든 `ConfigManager` / `ConfigModule` 메서드는 [설정 및 플래그](/features/config-and-flags)를 참고하세요.
