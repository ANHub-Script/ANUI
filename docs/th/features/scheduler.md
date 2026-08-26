# Scheduler & Loop

ANUI มี scheduler loop แบบรวมศูนย์: หนึ่ง thread runner ขับเคลื่อนทุก loop, ไม่ใช่หนึ่ง `task.spawn` ต่อ loop Loop ไม่มี drift และป้องกันการซ้อนทับ, และ wrapper ที่ผูกกับ window จะหยุดเองอัตโนมัติเมื่อ window ถูกปิดหรือทำลาย

## Loop window (แนะนำ)

สำหรับเกือบทุกความต้องการ, ใช้ method loop บน `Window` Method เหล่านี้ทำงานใน scheduler ของ window, ดังนั้น **หยุดอัตโนมัติเมื่อ window ถูกปิดหรือทำลาย** — โดยไม่ต้องทำความสะอาดด้วยมือ

### `Window:Loop(key, interval, callback, options?)`

เรียก `callback` ทุก `interval` วินาที `key` ตั้งชื่อ loop; การใช้ key เดิมซ้ำจะแทนที่ loop เก่า Callback **ไม่รับ argument**

```lua
Window:Loop("heartbeat", 1, function()
    print("tick")
end)
```

`options` เป็นตารางตัวเลือก:

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `requireReady` | `boolean` | `false` | เรียก callback เฉพาะเมื่อ window "พร้อม" (เปิดและยังไม่ถูกทำลาย) |
| `predicate` | `function` | `nil` | เกตเพิ่มเติม — callback ทำงานเฉพาะเมื่อนี่ส่งคืน `true` |

### `Window:StatusLoop(key, interval, callback)`

เป็น `Loop` กับ `requireReady` ที่เปิดอยู่แล้ว — เหมาะสำหรับการรีเฟรชข้อความบนหน้าจอ, เพราะจะหยุดชั่วคราวเมื่อ window ถูกซ่อน Callback **ไม่รับ argument**

```lua
Window:StatusLoop("clock", 1, function()
    -- `clock` เป็น Paragraph ที่สร้างไว้ก่อนหน้า
    clock:SetDesc(os.date("%X"))
end)
```

### `Window:ManagedLoop(key, interval, predicate, callback)`

Loop ดิบกับ `predicate` ของคุณเองและไม่มีเกต window-ready ทุกครั้งที่ loop ครบกำหนด, `predicate` ถูกเรียก; `callback` ทำงานเฉพาะเมื่อมันส่งคืน `true` ทั้งสอง **ไม่รับ argument**

```lua
Window:ManagedLoop("guarded", 0.5, function()
    return workspace:FindFirstChild("Boss") ~= nil
end, function()
    -- ทำงานเฉพาะเมื่อ Boss มีอยู่
end)
```

### ควบคุม loop

- `Window:StopLoop(key)` — หยุดหนึ่ง loop ตาม key
- `Window:StopAllLoops()` — หยุดทุก loop บน window
- `Window:IsLoopRunning(key)` — `true` หากมี loop กับ key นั้นลงทะเบียน
- `Window:GetActiveLoopCount()` — จำนวน loop ที่ลงทะเบียน

### Connection และความพร้อม

- `Window:AddConnection(connection)` — ฝาก `RBXScriptConnection` ไว้กับ window เพื่อตัดอัตโนมัติเมื่อ destroy
- `Window:DisconnectAll()` — ตัดทุก connection ที่คุณฝาก
- `Window:IsReady()` — `true` ตลอดที่ window เปิดและยังไม่ถูกทำลาย

```lua
Window:AddConnection(
    game:GetService("RunService").Heartbeat:Connect(function()
        -- ...
    end)
)
```

## Scheduler แบบสแตนด์อโลน

ต้องการ loop ที่ไม่ผูกกับ window? สร้าง scheduler ของคุณเองด้วย `ANUI:Scheduler` คุณควบคุมเมื่อมันหยุดผ่าน `ShouldStop`, และเกต loop "ready" ผ่าน `IsReady`

### `ANUI:Scheduler(config)`

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `ShouldStop` | `function → boolean` | `nil` | ส่งคืน `true` เพื่อปิด runner และทิ้งทุก loop |
| `IsReady` | `function → boolean` | `nil` | เกตสำหรับ loop ที่สร้างด้วย `requireReady` Default เป็นพร้อมเสมอ |
| `MinWait` | `number` | `0.01` | Interval / tick ที่เล็กที่สุดที่อนุญาต |
| `IdleWait` | `number` | `0.05` | การนอนที่ยาวที่สุดเมื่อไม่มีอะไรครบกำหนด |

```lua
local sched = ANUI:Scheduler({
    ShouldStop = function() return not _G.MyScriptRunning end,
    IsReady = function() return game:IsLoaded() end,
})
```

Method scheduler:

### `sched:Start(key, interval, predicate, callback)`

Loop ดิบ เมื่อครบกำหนด, `predicate` ถูกเรียก; `callback` ทำงานเฉพาะเมื่อมันส่งคืน `true`

### `sched:Loop(key, interval, callback, options?)`

เหมือนกับ `Window:Loop` `options` รับ `requireReady` และ `predicate`

### `sched:StatusLoop(key, interval, callback)`

เป็น `Loop` กับ `requireReady` เปิด

### Method อื่นๆ

- `sched:Stop(key)` — หยุดหนึ่ง loop
- `sched:StopAll()` — หยุดทุก loop
- `sched:IsRunning(key)` — มี loop ลงทะเบียนใต้ key นี้ไหม?
- `sched:GetActiveCount()` — จำนวน loop ที่ใช้งาน
- `sched:AddConnection(connection)` — ติดตาม connection เพื่อทำความสะอาดทีหลัง
- `sched:DisconnectAll()` — ตัดทุก connection ที่ติดตาม
- `sched:Destroy()` — หยุด runner, ทิ้งทุก loop, และตัดทุก connection

::: tip ไม่มี drift และปลอดภัยจากการซ้อนทับ
แต่ละ loop กำหนดเวลาการทำงานถัดไปจากเวลาเป้าหมาย, ไม่ใช่จากเมื่อ callback เสร็จ — ดังนั้น loop 1 วินาทียังคงจังหวะคงที่ 1 วินาทีไม่ว่างานจะนานแค่ไหน นอกจากนี้, การป้องกัน `busy` ต่อ loop ป้องกัน callback ที่ช้าจากสะสมกับตัวเอง: หากหนึ่งกระบวนการยังทำงานเมื่อกำหนดถัดไปมาถึง, tick นั้นจะถูกข้าม
:::

## ตัวอย่าง: toggle auto-farm

หนึ่ง toggle เปิดและปิด `Window:Loop` ที่ทำงานของมัน, บวก `Window:StatusLoop` ที่รักษา Paragraph อัปเดต ทั้งสองหยุดอย่างสวยงามเมื่อ window ถูกปิดหรือทำลาย

```lua
local Window = ANUI:CreateWindow({ Title = "Farm Hub" })
local Tab = Window:Tab({ Title = "Farm", Icon = "sword" })

local status = Tab:Paragraph({
    Title = "Auto Farm",
    Desc = "Status: idle",
})

local farming = false
local kills = 0

Tab:Toggle({
    Title = "Auto Farm",
    Value = false,
    Callback = function(on)
        farming = on

        if on then
            -- ทำงาน ~2x ต่อวินาที
            Window:Loop("autofarm", 0.5, function()
                kills += 1
                -- ... การกระทับฟาร์มของคุณที่นี่ ...
            end)

            -- รีเฟรช paragraph 4x ต่อวินาที, เฉพาะเมื่อ UI เปิด
            Window:StatusLoop("autofarm-status", 0.25, function()
                status:SetDesc(("Status: running · %d kills"):format(kills))
            end)
        else
            Window:StopLoop("autofarm")
            Window:StopLoop("autofarm-status")
            status:SetDesc("Status: idle")
        end
    end,
})
```

ดู [การกำหนดค่า Window](/th/guide/window-configuration) สำหรับข้อมูลเพิ่มเติมเกี่ยวกับวงจรชีวิต window
