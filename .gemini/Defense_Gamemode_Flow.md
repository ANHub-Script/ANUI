# 📖 Alur Lengkap Defense Gamemode di Anime Weapons Script

## 🎯 Overview
Defense adalah salah satu dari 3 gamemode yang ada (Dungeon, Raid, Defense). Defense beroperasi dengan sistem waktu spawn tertentu dan auto-join untuk farming otomatis.

---

## 🔄 Alur Lengkap Defense Gamemode

### 1️⃣ **LOADING & INITIALIZATION** (Baris 491-513)

```lua
local function LoadDefenseData()
    -- Mengambil data Defense dari game module
    local module = require(ReplicatedStorage.Scripts.Configs.Gamemodes.Defense)
    
    -- Loop semua PHASES (tingkat kesulitan Defense)
    for id, phase in ipairs(module.PHASES) do
        local rName = phase.Name              -- Nama Defense (contoh: "Easy Defense")
        local hpCalc = math.floor((phase.HealthBase or 0) / 50)  -- HP musuh
        local desc = "Hp Base: " .. FormatNumber(hpCalc)
        
        -- Simpan ke defenseList (untuk UI Dropdown)
        table.insert(defenseList, {
            Title = rName,
            Value = rName,
            Desc = desc
        })
        
        -- Simpan ke defenseDB (database untuk logic)
        defenseDB[rName] = {
            ID = id,                    -- ID untuk join (1, 2, 3, dst)
            Times = phase.START_TIMES,  -- Array waktu spawn [0, 15, 30, 45]
            BaseDesc = desc
        }
    end
end

LoadDefenseData()  -- Dipanggil saat script start
```

**Output:**
- `defenseList` → Untuk ditampilkan di dropdown UI
- `defenseDB` → Database dengan info ID dan waktu spawn

---

### 2️⃣ **UI DROPDOWN SETUP** (Baris 1467-1481)

```lua
local DefenseDrop = FarmingManagerSection:Dropdown({
    Title = "Select Defense",
    Multi = true,          -- User bisa pilih multiple Defense
    AllowNone = true,      -- Boleh tidak pilih apa-apa
    Flag = "DefenseDiff_Cfg",
    Values = defenseList,  -- List dari LoadDefenseData()
    Callback = function(val)
        -- Simpan pilihan user ke Config.TargetDefense
        local t = {}
        for _, v in pairs(val) do
            table.insert(t, type(v) == "table" and v.Value or v)
        end
        Config.TargetDefense = t  -- Array nama Defense yang dipilih
    end
})
FarmTabs:Add("Gamemodes", DefenseDrop)
```

**Fitur:**
- Multi-select dropdown
- User bisa pilih Defense mana yang mau di-farm
- Hasil disimpan di `Config.TargetDefense`

---

### 3️⃣ **COUNTDOWN TIMER UPDATE** (Baris 1529-1557)

```lua
task.spawn(function()
    local function GetNextTimeDiff(times, currentMin, currentSec)
        -- Cari waktu spawn berikutnya
        -- times = [0, 15, 30, 45]
        -- currentMin = menit sekarang (0-59)
        
        for _, t in ipairs(times) do
            if t > currentMin then
                return (t - currentMin) * 60 - currentSec
            end
        end
        
        -- Jika tidak ada, ambil waktu pertama di jam berikutnya
        local firstTime = times[1]
        return (60 - currentMin + firstTime) * 60 - currentSec
    end

    while not Window.Destroyed do
        local t = os.date("*t")
        local currentMin = t.min
        local currentSec = t.sec
        
        -- Update countdown untuk setiap Defense
        local newDefenseList = {}
        for _, item in ipairs(defenseList) do
            local dName = item.Value
            local data = defenseDB[dName]
            
            if data and data.Times then
                -- Hitung waktu tersisa
                local diff = GetNextTimeDiff(data.Times, currentMin, currentSec)
                if diff < 0 then diff = 0 end
                
                local m = math.floor(diff / 60)
                local s = diff % 60
                local timeStr = string.format("%02d:%02d", m, s)
                
                -- Update deskripsi dengan countdown
                table.insert(newDefenseList, {
                    Title = item.Title,
                    Value = item.Value,
                    Desc = data.BaseDesc .. " | Starts in: " .. timeStr
                })
            else
                table.insert(newDefenseList, item)
            end
        end
        
        -- Refresh dropdown dengan data baru
        if DefenseDrop and DefenseDrop.Refresh then
            pcall(function() DefenseDrop:Refresh(newDefenseList) end)
        end
        
        task.wait(1)  -- Update setiap detik
    end
end)
```

**Fungsi:**
- Menampilkan countdown real-time
- Update setiap 1 detik
- Format: "Hp Base: 1.2K | Starts in: 14:32"

---

### 4️⃣ **AUTO JOIN & KILL TOGGLE** (Baris 1559-1569)

```lua
local ModeToggle = FarmingManagerSection:Toggle({
    Title = "Auto Join & Kill",
    Flag = "AutoDungeon_Cfg",
    Callback = function(val)
        Config.AutoDungeon = val
        if val then
            task.spawn(LogicGamemodes)  -- Jalankan logic farming
        end
    end
})
FarmTabs:Add("Gamemodes", ModeToggle)
```

**Note:** 
- Toggle ini mengontrol **semua gamemode** (Dungeon, Raid, Defense)
- Nama flag: `AutoDungeon_Cfg` tapi berlaku untuk Defense juga

---

### 5️⃣ **MAIN LOGIC - AUTO JOIN** (Baris 1140-1160)

```lua
-- Di dalam function LogicGamemodes() - Loop utama farming

-- Cek apakah sudah waktunya join Defense
local t = os.date("*t")
local currentMinute = t.min
local targetString, targetName = nil, ""

-- Pertama cek Dungeon (prioritas 1)
for _, dName in pairs(Config.TargetDungeon) do
    -- ... cek dungeon
end

-- Kedua cek Raid (prioritas 2)
if not targetString then
    for _, rName in pairs(Config.TargetRaid) do
        -- ... cek raid
    end
end

-- Ketiga cek Defense (prioritas 3)
if not targetString then
    for _, dName in pairs(Config.TargetDefense) do
        local data = defenseDB[dName]
        if data and data.Times then
            -- Cek apakah menit sekarang ada di array START_TIMES
            for _, timeVal in ipairs(data.Times) do
                if currentMinute == timeVal then
                    -- FOUND! Waktunya join Defense ini
                    targetString = "Defense:" .. tostring(data.ID)
                    targetName = dName
                    break
                end
            end
        end
        if targetString then break end
    end
end

-- Jika menemukan Defense yang harus di-join
if targetString then
    LastZone = GetCurrentMapStatus()  -- Simpan zona terakhir untuk return
    
    -- Notifikasi ke user
    l:Notify({
        Title = "Joining Mode",
        Content = targetName,
        Icon = "map-pin",
        Duration = 3
    })
    
    -- TELEPORT KE DEFENSE
    if Reliable then
        pcall(function()
            Reliable:FireServer("Zone Teleport", {targetString})
        end)
    end
    
    task.wait(6)  -- Tunggu loading
end
```

**Prioritas Join:**
1. Dungeon (prioritas tertinggi)
2. Raid
3. Defense (prioritas terendah)

**Contoh:**
- User select "Easy Defense" dengan START_TIMES = [0, 15, 30, 45]
- Saat menit = 15, script akan join "Defense:1"

---

### 6️⃣ **MAP DETECTION** (Baris 967-969, 1017-1020)

```lua
-- Function untuk detect map status
function GetCurrentMapStatus()
    -- ... cek Zones dulu
    
    -- Cek Defense workspace
    if Workspace:FindFirstChild("Defense") then
        return "Defense"  -- Player di dalam Defense arena
    end
    
    return "Unknown"
end

-- Di LogicGamemodes, deteksi fighting zone
local currentMap = GetCurrentMapStatus()
local isFightingZone = string.find(currentMap, "Dungeon") or 
                       string.find(currentMap, "Raid") or 
                       string.find(currentMap, "Defense")

if currentMap == "Defense" then
    isFightingZone = true  -- Konfirmasi sedang di Defense
end
```

**Status Map:**
- `"Defense"` → Player ada di Defense arena
- `"Unknown"` → Player di tempat lain

---

### 7️⃣ **ENEMY DETECTION & REFRESH** (Baris 976-999)

```lua
task.spawn(function()
    local EnemiesFolder = Workspace:WaitForChild("Enemies", 5)
    if EnemiesFolder then
        local Debounce = false
        
        local function TriggerRefresh()
            if Debounce then return end
            
            local currentMap = GetCurrentMapStatus()
            
            -- Cek apakah di gamemode (termasuk Defense)
            local isGamemode = string.find(currentMap, "Dungeon") or 
                              string.find(currentMap, "Raid") or 
                              string.find(currentMap, "Defense")
            
            if not isGamemode then
                return  -- Jangan refresh jika tidak di gamemode
            end

            Debounce = true
            task.wait(1.5)  -- Tunggu enemy spawn sempurna
            RefreshEnemyData()  -- Update GlobalEnemyMap
            Debounce = false
        end
        
        -- Auto-refresh saat enemy spawn/despawn
        EnemiesFolder.ChildAdded:Connect(TriggerRefresh)
        EnemiesFolder.ChildRemoved:Connect(TriggerRefresh)
    end
end)
```

**Fitur:**
- Auto-detect enemy baru di Defense
- Update `GlobalEnemyMap` otomatis
- Debounce untuk menghindari spam refresh

---

### 8️⃣ **MAIN FARMING LOGIC** (Baris 1023-1086)

```lua
-- Di dalam LogicGamemodes()

if isFightingZone then  -- Sedang di Defense arena
    wasInGamemode = true
    
    -- Refresh enemy list setiap 5 detik
    if os.time() - refreshTimer > 5 then
        RefreshEnemyData()
        refreshTimer = os.time()
    end
    
    -- Cek target masih hidup
    if currentTargetObj then
        if currentTargetObj.Alive == false or not currentTargetObj.Data then
            currentTargetObj = nil  -- Reset, cari target baru
        end
    end
    
    local isDefense = string.find(currentMap, "Defense")
    
    -- Cari target baru jika belum ada
    if not currentTargetObj and hrp then
        local closest, minDst = nil, math.huge
        local myPos = hrp.Position
        
        -- Loop semua enemy di GlobalEnemyMap
        for _, enemyList in pairs(GlobalEnemyMap) do
            for _, enemyObj in ipairs(enemyList) do
                if enemyObj.Alive == true and enemyObj.Data and enemyObj.Data.CFrame then
                    local dst = (myPos - enemyObj.Data.CFrame.Position).Magnitude
                    
                    -- Pilih yang terdekat
                    if dst < minDst then
                        minDst = dst
                        closest = enemyObj
                    end
                end
            end
        end
        
        -- Set target dan teleport
        if closest then
            currentTargetObj = closest
            if currentTargetObj.Data and currentTargetObj.Data.CFrame then
                -- TELEPORT KE ENEMY
                hrp.CFrame = currentTargetObj.Data.CFrame * CFrame.new(0, 5, 2)
                lastTeleportedUid = currentTargetObj.Uid
            end
        end
    end
    
    task.wait(0.1)  -- Loop cepat untuk responsive farming
end
```

**Logic Defense:**
- **Tidak** ada prioritas Boss (berbeda dengan Raid)
- Selalu cari enemy terdekat
- Teleport loop ke setiap enemy
- Refresh target jika mati

**Perbedaan dengan Raid:**
```lua
// RAID: Prioritas Boss, hanya TP sekali ke boss
if isRaid then
    if isBoss and not hasTeleportedToBossInRaid then
        hrp.CFrame = target.CFrame
        hasTeleportedToBossInRaid = true
    end
end

// DEFENSE: Loop TP ke semua enemy terdekat
else  -- Defense / Dungeon
    hrp.CFrame = target.CFrame  -- Always teleport
    lastTeleportedUid = targetUid
end
```

---

### 9️⃣ **RETURN TO ZONE** (Baris 1088-1111)

```lua
-- Deteksi Defense selesai (kembali ke lobby)
elseif inLobbyZone or (wasInGamemode and not isFightingZone) then
    -- Reset semua state
    currentTargetObj = nil
    lastTeleportedUid = nil
    hasTeleportedToBossInRaid = false
    
    -- Return ke zona farming sebelumnya
    if LastZone and LastZone ~= "" and 
       not string.find(LastZone, "Defense:") and 
       LastZone ~= "Unknown" then
        
        -- Notifikasi
        l:Notify({
            Title = "Mode Finished",
            Content = "In Lobby -> Returning to " .. LastZone,
            Icon = "map-pin",
            Duration = 3
        })
        
        -- Teleport kembali
        if Reliable then
            pcall(function()
                Reliable:FireServer("Zone Teleport", {LastZone})
            end)
        end
        
        wasInGamemode = false
        task.wait(4)  -- Tunggu teleport
    else
        wasInGamemode = false
    end
end
```

**Fitur:**
- Otomatis kembali ke zona sebelumnya
- Hanya return jika `LastZone` valid
- Reset semua state untuk Defense berikutnya

---

## 📊 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ 1. SCRIPT START                                             │
│    LoadDefenseData() → defenseDB, defenseList               │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│ 2. UI SETUP                                                 │
│    DefenseDrop → User pilih Defense → Config.TargetDefense │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│ 3. COUNTDOWN TIMER (Loop setiap 1s)                        │
│    GetNextTimeDiff() → Update "Starts in: XX:XX"           │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│ 4. USER ENABLE TOGGLE                                       │
│    Auto Join & Kill = ON → Config.AutoDungeon = true       │
│    task.spawn(LogicGamemodes)                               │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│ 5. MAIN LOOP (LogicGamemodes)                              │
│    ┌─────────────────────────────────────────────┐         │
│    │ A. Cek waktu sekarang vs START_TIMES        │         │
│    │    currentMin in data.Times? → YES!         │         │
│    └───────────────┬─────────────────────────────┘         │
│                    │                                        │
│    ┌───────────────▼─────────────────────────────┐         │
│    │ B. AUTO JOIN                                │         │
│    │    Reliable:FireServer("Zone Teleport",     │         │
│    │                        {"Defense:1"})       │         │
│    └───────────────┬─────────────────────────────┘         │
│                    │                                        │
│    ┌───────────────▼─────────────────────────────┐         │
│    │ C. WAIT & DETECT MAP                        │         │
│    │    GetCurrentMapStatus() == "Defense"       │         │
│    └───────────────┬─────────────────────────────┘         │
│                    │                                        │
│    ┌───────────────▼─────────────────────────────┐         │
│    │ D. ENEMY AUTO-REFRESH                       │         │
│    │    EnemiesFolder events → RefreshEnemyData()│         │
│    └───────────────┬─────────────────────────────┘         │
│                    │                                        │
│    ┌───────────────▼─────────────────────────────┐         │
│    │ E. FARMING LOOP                             │         │
│    │    - Cari enemy terdekat                    │         │
│    │    - Teleport ke enemy                      │         │
│    │    - Loop sampai semua mati                 │         │
│    └───────────────┬─────────────────────────────┘         │
│                    │                                        │
│    ┌───────────────▼─────────────────────────────┐         │
│    │ F. DEFENSE SELESAI                          │         │
│    │    - Detect kembali ke lobby                │         │
│    │    - Return ke LastZone                     │         │
│    └───────────────┬─────────────────────────────┘         │
│                    │                                        │
│                    ▼                                        │
│            Kembali ke step 5A                               │
│            (Tunggu Defense berikutnya)                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔑 Variabel Penting

| Variabel | Tipe | Fungsi |
|----------|------|--------|
| `defenseDB` | Table | Database info Defense (ID, Times, Desc) |
| `defenseList` | Array | List untuk UI dropdown |
| `Config.TargetDefense` | Array | Defense yang dipilih user |
| `Config.AutoDungeon` | Boolean | Enable/disable auto join |
| `currentTargetObj` | Object | Enemy yang sedang di-target |
| `LastZone` | String | Zona sebelum join Defense (untuk return) |
| `wasInGamemode` | Boolean | Flag pernah masuk gamemode |
| `lastTeleportedUid` | String | UID enemy terakhir yang di-TP |

---

## ⚙️ Config Structure

```lua
-- Defense Module (dari game)
{
    PHASES = {
        [1] = {
            Name = "Easy Defense",
            HealthBase = 50000,
            START_TIMES = {0, 15, 30, 45}  -- Spawn setiap 15 menit
        },
        [2] = {
            Name = "Medium Defense",
            HealthBase = 100000,
            START_TIMES = {5, 20, 35, 50}
        },
        [3] = {
            Name = "Hard Defense",
            HealthBase = 200000,
            START_TIMES = {10, 25, 40, 55}
        }
    }
}

-- defenseDB (script internal)
{
    ["Easy Defense"] = {
        ID = 1,
        Times = {0, 15, 30, 45},
        BaseDesc = "Hp Base: 1.0K"
    },
    ["Medium Defense"] = {
        ID = 2,
        Times = {5, 20, 35, 50},
        BaseDesc = "Hp Base: 2.0K"
    }
}

-- Config.TargetDefense (user selection)
Config.TargetDefense = {
    "Easy Defense",
    "Hard Defense"
}
```

---

## 🎮 User Experience Flow

1. **User membuka tab "Gamemodes"**
2. **User melihat dropdown "Select Defense"** dengan countdown timer
   - "Easy Defense | Hp Base: 1.0K | Starts in: 14:23"
3. **User select** Defense yang diinginkan (bisa multiple)
4. **User enable toggle** "Auto Join & Kill"
5. **Script menunggu** waktu spawn Defense
6. **Saat waktu tiba:**
   - Notifikasi: "Joining Mode - Easy Defense"
   - Teleport ke Defense arena
7. **Di arena:**
   - Auto refresh enemy list
   - Auto teleport ke enemy terdekat
   - Farm sampai semua enemy mati
8. **Defense selesai:**
   - Notifikasi: "Mode Finished - Returning to X"
   - Kembali ke zona farming sebelumnya
9. **Repeat** untuk Defense berikutnya

---

## 🐛 Troubleshooting

### Defense tidak auto-join?
- ✅ Pastikan `Config.AutoDungeon = true` (toggle ON)
- ✅ Cek `Config.TargetDefense` tidak kosong
- ✅ Pastikan waktu sekarang ada di `START_TIMES`

### Tidak kembali ke zona sebelumnya?
- ✅ `LastZone` harus valid (bukan "Unknown" atau gamemode)
- ✅ Cek `wasInGamemode` flag sudah di-set

### Tidak farm enemy?
- ✅ `GlobalEnemyMap` harus terisi (cek RefreshEnemyData)
- ✅ Enemy harus punya `Alive = true` dan `Data.CFrame`

---

## 📝 Summary

**Defense Gamemode** adalah sistem farming otomatis yang:

1. ✅ **Load data** dari game module
2. ✅ **Tampilkan UI** dengan countdown timer real-time
3. ✅ **Auto-join** saat waktu spawn tiba
4. ✅ **Auto-farm** semua enemy dengan target terdekat
5. ✅ **Auto-return** ke zona farming sebelumnya

**Fitur Unik Defense:**
- Multi-select dropdown (bisa pilih beberapa Defense sekaligus)
- Sistem prioritas lebih rendah dari Dungeon & Raid
- Loop teleport ke semua enemy (tidak ada prioritas Boss)
- Countdown timer yang update setiap detik

---

**Created by:** AI Assistant  
**Date:** 2025-11-26  
**Version:** 1.0
