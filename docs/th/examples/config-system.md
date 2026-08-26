# ระบบการกำหนดค่า

สูตรบันทึก/โหลดที่สมบูรณ์: องค์ประกอบที่มี flag ที่ค่า persisten, ตัวเลือก config ที่โหลดจากดิสก์, ปุ่ม Save/Load, และ toggle auto-load นี่ดัดแปลงมาจาก tab **Config Usage** ใน demo

::: warning ต้องการการเข้าถึงไฟล์ executor
การบันทึก config อ่านและเขียนไฟล์ JSON ในดิสก์ ดังนั้น executor ของคุณต้องรองรับ global file `readfile`, `writefile`, `isfile`, และ `makefolder` Config ถูกบันทึกใน `ANUI/<Folder>/config/<name>.json` โดย `<Folder>` คือ `Folder` ที่คุณให้กับ `CreateWindow`
:::

## 1. ใส่ flag ในองค์ประกอบของคุณ

แต่ละองค์ประกอบ stateful (Toggle, Slider, Dropdown, Input, Keybind, Colorpicker) ที่มี key `Flag` จะถูกลงทะเบียนกับ config ที่ active โดยอัตโนมัติ ค่าถูกเขียนเมื่อ Save และกู้คืนเมื่อ Load — คุณไม่ต้องเขียนโค้ดเพิ่มเติมต่อองค์ประกอบ

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Folder = "MyHub", -- จำเป็นสำหรับ config — นี่คือ root ในดิสก์
})

local Tab = Window:Tab({ Title = "Settings", Icon = "sliders-horizontal" })

-- แต่ละ `Flag` กลายเป็น key ในไฟล์ JSON ที่บันทึก
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

## 2. ดึง ConfigManager และกำหนด current config

`Window.ConfigManager` ถูกสร้างอัตโนมัติเพราะเราให้ `Folder` เราเก็บชื่อ config ในตัวแปรและทำให้หนึ่ง config เป็น **current** ตั้งแต่แรก เพื่อให้ค่าที่มี flag มีที่บันทึกเสมอ

```lua
local ConfigTab = Window:Tab({ Title = "Config", Icon = "folder" })

local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- ตรวจสอบว่ามี current config อยู่ `:Config(name)` สร้าง-หรือ-เปิด-มัน (alias ของ :CreateConfig)
Window.CurrentConfig = ConfigManager:Config(ConfigName)
```

## 3. Input ชื่อ Config

ให้ผู้ใช้พิมพ์ชื่อ config ที่จะบันทึกหรือโหลด เราเก็บกลับไปที่ `ConfigName`

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

## 4. Toggle auto-load

`ConfigModule:SetAutoLoad(bool)` ทำเครื่องหมาย config ให้โหลดอัตโนมัติเมื่อ startup เราเรียกบน current config

```lua
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "Auto Load This Config",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})
```

## 5. Dropdown "All Configs"

`ConfigManager:AllConfigs()` ส่งคืนชื่อทุก config ที่มีอยู่ในดิสก์ เราใส่รายการนั้นใน dropdown เพื่อให้ผู้ใช้เลือกที่มีอยู่แล้ว เมื่อพวกเขาเลือก เรา sync input ชื่อและสะท้อนสถานะ auto-load ที่บันทึกจาก config นั้น (อ่านจาก field `.AutoLoad` ของมัน)

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

## 6. ปุ่ม Save และ Load

ปุ่ม Save ทำให้ `ConfigName` เป็น current config แล้วเรียก `:Save()` หากสำเร็จเราแจ้งเตือนและ refresh dropdown เพื่อให้ config ใหม่ปรากฏในรายการ ปุ่ม Load เปิด config และเรียก `:Load()` ซึ่งกู้คืนทุกค่าที่มี flag

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
`:Config(name)` และ `:CreateConfig(name)` เป็น alias — ทั้งสองสร้างไฟล์ config หากยังไม่มี หรือเปิดหากมีแล้ว `:Save()` และ `:Load()` ส่งคืนค่า truthy เมื่อสำเร็จ นั่นคือเหตุผลที่ปุ่มด้านบนแจ้งเตือนเฉพาะเมื่อการดำเนินการสำเร็จ
:::

สำหรับขั้นตอน flag ฉบับสมบูรณ์ รายการประเภทองค์ประกอบที่ถูก persist และทุก method ของ `ConfigManager` / `ConfigModule` ดู [การกำหนดค่า & Flag](/th/features/config-and-flags)
