# Config System 예제

상태형 Element에 `Flag`를 지정하고 Config를 저장/로드하는 기본 패턴입니다.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
})

local Tab = Window:Tab({ Title = "Settings", Icon = "settings" })

Tab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(value) end,
})

Tab:Slider({
    Title = "Walk Speed",
    Flag = "WalkSpeed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) end,
})

local ConfigManager = Window.ConfigManager
Window.CurrentConfig = ConfigManager:Config("default")

Tab:Button({
    Title = "Save",
    Callback = function()
        Window.CurrentConfig:Save()
    end,
})

Tab:Button({
    Title = "Load",
    Callback = function()
        Window.CurrentConfig:Load()
    end,
})
```

Config는 `ANUI/<Folder>/config/<name>.json`에 저장됩니다. 저장 기능을 사용하려면 실행 환경의 파일 API가 필요합니다.

[Config & Flags 전체 문서 →](../features/config-and-flags)
