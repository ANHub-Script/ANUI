# Config & Flags

ANUI สามารถบันทึกและกู้คืนสถานะของเมนูของคุณไปยังดิสก์ กำหนด `Flag` ให้กับอิลิเมนต์ที่สามารถบันทึกได้ และค่าของมันจะถูกเขียนเมื่อคุณบันทึก config และกู้คืนเมื่อคุณโหลด — โดยไม่ต้องบันทึกด้วยมือ

::: info ต้องการ `Folder` บน window
ระบบ config ขับเคลื่อนโดย `Window.ConfigManager` ซึ่งมีอยู่เฉพาะเมื่อ window ถูกสร้างด้วย `Folder` กำหนดหนึ่งที่ [`ANUI:CreateWindow{}`](/th/guide/window-configuration) ก่อนใช้อะไรก็ตามในหน้านี้
:::

## วิธีการทำงานของ flag

แต่ละอิลิเมนต์ที่สามารถบันทึกได้รับ `Flag = "key"` เมื่อคุณกำหนด:

1. อิลิเมนต์ลงทะเบียนอัตโนมัติกับ **config ปัจจุบัน** (`Window.CurrentConfig`)
2. เรียก `:Save()` บน config นั้นเขียนค่าของแต่ละ flag ที่ลงทะเบียนไปยังไฟล์ JSON
3. เรียก `:Load()` อ่านไฟล์นั้นกลับมาและกู้คืนแต่ละอิลิเมนต์เป็นค่าที่บันทึกไว้

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm", -- ค่านี้สามารถบันทึกได้แล้ว
    Callback = function(v) print(v) end,
})
```

Flag บนอิลิเมนต์ที่สร้างก่อนมี config ปัจจุบันจะถูกจัดคิว; คิวนั้นจะถูเคลียร์และลงทะเบียนเมื่อ `:Save()` หรือ `:Load()` ครั้งถัดไป

## อะไรบ้างที่ถูกบันทึก

เฉพาะประเภทอิลิเมนต์ต่อไปนี้ที่ซีเรียลไลซ์สถานะ อิลิเมนต์อื่นๆ จะถูกข้ามโดยระบบ config

| Element | สิ่งที่บันทึก |
| --- | --- |
| `Colorpicker` | สี hex **และ** ความโปร่งใส |
| `Dropdown` | ค่าที่เลือก |
| `Input` | ค่าข้อความ |
| `Keybind` | ปุ่มที่ผูกไว้ |
| `Slider` | ค่าเริ่มต้น (`Value.Default`) |
| `Toggle` | ค่า boolean |

## config ถูกบันทึกที่ไหน

Config ถูกเขียนภายในโฟลเดอร์รูท `ANUI/` ภายใน `Folder` ของ window คุณ:

```
ANUI/<Folder>/config/<name>.json
```

ตัวอย่างเช่น ด้วย `Folder = "MyHub"` config ชื่อ `default` อยู่ที่ `ANUI/MyHub/config/default.json`

::: warning ต้องการฟังก์ชันไฟล์ของ executor
การบันทึกและโหลดสัมผัส filesystem Executor ของคุณต้องมี global file — `readfile`, `writefile`, `isfile`, และ `makefolder` (พร้อม helper ที่เกี่ยวข้อง) โดยไม่มีเหล่านี้ `:Save()` และ `:Load()` ไม่สามารถบันทึกอะไรได้
:::

## ตัวจัดการ config — `Window.ConfigManager`

`Window.ConfigManager` สร้างและจัดการไฟล์ config ที่มีชื่อ

### `ConfigManager:CreateConfig(filename, autoload?)`

สร้าง (หรือเปิด) config ตามชื่อและส่งคืน **ออบเจกต์ config** `autoload` ที่เป็นตัวเลือกจะทำเครื่องหมายให้โหลดอัตโนมัติ `ConfigManager:Config(...)` เป็น alias

```lua
local ConfigManager = Window.ConfigManager
local config = ConfigManager:CreateConfig("default")
```

### `ConfigManager:GetConfig(name)`

ส่งคืนออบเจกต์ config สำหรับชื่อที่มีอยู่ (เปิดเผย field เช่น `.AutoLoad`)

### `ConfigManager:GetAutoLoadConfigs()`

ส่งคืน config ที่ทำเครื่องหมายสำหรับ auto-load (เป็น JSON string)

### `ConfigManager:DeleteConfig(name)`

ลบไฟล์ config ตามชื่อ

### `ConfigManager:AllConfigs()`

ส่งคืน array ที่มีชื่อ config ทั้งหมด — มีประโยชน์สำหรับเติม dropdown

```lua
local names = ConfigManager:AllConfigs() -- { "default", "pvp", ... }
```

## ออบเจกต์ config

`CreateConfig`/`Config`/`GetConfig` ทั้งหมดส่งคืนออบเจกต์ config (เป็น `ConfigModule`) พร้อม method ต่อไปนี้

### `config:SetAsCurrent()`

ทำเครื่องหมาย config นี้เป็น `Window.CurrentConfig` ดังนั้นอิลิเมนต์ที่มี flag ใหม่จะลงทะเบียนกับ config นี้

### `config:Register(name, element)`

ลงทะเบียนอิลิเมนต์ด้วยตนเองภายใต้ key (โดยปกติไม่จำเป็น — `Flag` ทำให้คุณแล้ว)

### `config:Set(key, value)` / `config:Get(key)`

บันทึกและอ่านข้อมูล custom ใดๆ เคียงข้าง flag ของคุณ

```lua
config:Set("lastPlayer", game.Players.LocalPlayer.Name)
print(config:Get("lastPlayer"))
```

### `config:SetAutoLoad(bool)`

ทำเครื่องหมาย (หรือยกเลิกเครื่องหมาย) config นี้ให้โหลดอัตโนมัติ

### `config:Save()`

เขียนแต่ละ flag ที่ลงทะเบียนและค่า custom ไปยังดิสก์ ส่งคืนค่า truthy หากสำเร็จ

### `config:Load()`

อ่านไฟล์และกู้คืนแต่ละอิลิเมนต์ที่ลงทะเบียน ส่งคืนค่า truthy หากสำเร็จ

### `config:Delete()`

ลบไฟล์ของ config นี้

### `config:GetData()`

ส่งคืนตารางข้อมูลทั้งหมดที่ config ถืออยู่ในปัจจุบัน

## `Window.CurrentConfig`

`Window.CurrentConfig` ถือออบเจกต์ config ที่ใช้งานอยู่ อิลิเมนต์ที่มี flag ลงทะเบียนกับมัน และ config นี้คือเป้าหมายของ `:SetAutoLoad`, `:Save`, และ `:Load` เมื่อเรียกจาก UI ของคุณ ชี้ไปที่ config ก่อนบันทึกหรือโหลด:

```lua
Window.CurrentConfig = ConfigManager:CreateConfig("default")
Window.CurrentConfig:Load()
```

## UI Save / Load แบบครบถ้วน

แผง config แบบครบถ้วน: input ชื่อ, dropdown config ที่มีอยู่, toggle auto-load, และปุ่ม Save / Load ดัดแปลงจากแท็บ "Config Usage" บนสคริปต์ตัวอย่าง

```lua
local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- ชื่อ config ที่จะบันทึก/โหลด
local ConfigNameInput = ConfigTab:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Callback = function(value)
        ConfigName = value
    end,
})

-- Toggle auto-load สำหรับ config ปัจจุบัน
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "Enable Auto Load to Selected Config",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})

-- Dropdown ที่แสดงแต่ละ config ที่มีอยู่
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

-- บันทึกสถานะปัจจุบันไปยัง ConfigName
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
        -- refresh dropdown เพื่อให้ config ที่สร้างใหม่ปรากฏ
        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

-- โหลด ConfigName กลับมายัง UI
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

## ดูเพิ่มเติม

- [ตัวอย่างระบบ Config](/th/examples/config-system) — คู่มือแบบเต็มที่สามารถคัดลอกได้ทันที
