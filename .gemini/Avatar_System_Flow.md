# 📖 Alur Lengkap Avatar System di Anime Weapons Script

## 🎯 Overview
Avatar System adalah fitur yang memungkinkan player untuk:
- Melihat semua avatar (morphs) yang tersedia
- Melihat status (Locked/Owned/Equipped)
- Preview 3D model avatar
- Equip avatar dengan stats bonus
- Auto-refresh saat ada perubahan

---

## 🔄 Alur Lengkap Avatar System

### 1️⃣ **DATA LOADING - GetAvatarsWithStats()** (Baris 624-707)

```lua
local function GetAvatarsWithStats()
    local list = {}           -- Output: array untuk dropdown
    local zoneOrders = {}     -- Urutan zona untuk sorting
    local machineStats = {}   -- Stats bonus dari Avatar Machine
    local Data = (getgenv()).PlayerData  -- Data player dari server
    
    -- ========================================
    -- A. LOAD ZONE ORDERS (untuk sorting)
    -- ========================================
    local zonesConfigPath = ReplicatedStorage.Scripts.Configs.Zones
    if zonesConfigPath then
        local success, zonesData = pcall(require, zonesConfigPath)
        if success then
            for zoneName, zoneData in pairs(zonesData) do
                zoneOrders[zoneName] = zoneData.Order or 999
                -- Contoh: zoneOrders["Village"] = 1
                --         zoneOrders["Forest"] = 2
            end
        end
    end
    
    -- ========================================
    -- B. LOAD MACHINE STATS (bonus stats)
    -- ========================================
    local machinePath = ReplicatedStorage.Scripts.Configs.Machines.Avatar
    if machinePath then
        local success, statsData = pcall(require, machinePath)
        if success then
            machineStats = statsData
            -- Contoh: machineStats["Naruto"] = {Mastery = 10, Damage = 5}
        end
    end
    
    -- ========================================
    -- C. LOAD AVATARS FROM ZONES (semua enemy)
    -- ========================================
    local ConfigsFolder = ReplicatedStorage.Scripts.Configs
    local MZFolder = ConfigsFolder:FindFirstChild("Multiple Zones") or 
                     ConfigsFolder:FindFirstChild("MultipleZones")
    local zonesPath = MZFolder and MZFolder:FindFirstChild("Enemies")
    
    if zonesPath then
        -- Loop semua zona (Village, Forest, etc.)
        for _, zoneModule in pairs(zonesPath:GetChildren()) do
            if zoneModule:IsA("ModuleScript") then
                local zoneName = zoneModule.Name
                local zoneOrder = zoneOrders[zoneName] or 999
                
                -- Require module zona untuk dapat data enemy
                local success, zoneData = pcall(require, zoneModule)
                if success and type(zoneData) == "table" then
                    
                    -- Loop semua enemy di zona ini
                    for internalKey, enemyStats in pairs(zoneData) do
                        -- internalKey = "Naruto", "Sasuke", dll
                        -- enemyStats = {Display, MaxHealth, dll}
                        
                        -- ========================================
                        -- D. CEK OWNERSHIP STATUS
                        -- ========================================
                        local isOwned = false
                        if Data and Data.Morphs and Data.Morphs[internalKey] then
                            isOwned = true  -- Player punya avatar ini
                        end
                        
                        -- ========================================
                        -- E. CEK EQUIPPED STATUS
                        -- ========================================
                        local isEquipped = false
                        if Data and Data.Attributes and 
                           Data.Attributes.Avatar == internalKey then
                            isEquipped = true  -- Avatar ini sedang dipakai
                        end
                        
                        -- ========================================
                        -- F. TENTUKAN STATUS PREFIX
                        -- ========================================
                        local statusPrefix = "[LOCKED]"  -- Default: locked
                        if isOwned then
                            statusPrefix = ""  -- Owned tapi tidak equipped
                        end
                        if isEquipped then
                            statusPrefix = "[EQUIPPED]"  -- Sedang dipakai
                        end
                        
                        -- ========================================
                        -- G. BUILD DESCRIPTION (stats)
                        -- ========================================
                        local mStat = machineStats[internalKey]
                        local descParts = {}
                        
                        if mStat then
                            if mStat.Mastery then
                                table.insert(descParts, "Mas: " .. mStat.Mastery .. "%")
                            end
                            if mStat.Damage then
                                table.insert(descParts, "Dmg: " .. mStat.Damage .. "%")
                            end
                        end
                        
                        local finalDesc = #descParts > 0 and 
                                         table.concat(descParts, " | ") or 
                                         "No Stats"
                        
                        if not isOwned then
                            finalDesc = "LOCKED - Defeat to unlock"
                        end
                        
                        -- ========================================
                        -- H. ADD TO LIST
                        -- ========================================
                        table.insert(list, {
                            Title = (statusPrefix ~= "" and statusPrefix .. " " or "") .. 
                                   (enemyStats.Display or internalKey),
                            -- Contoh: "[EQUIPPED] Naruto" atau "[LOCKED] Sasuke"
                            
                            Value = internalKey,  -- Internal key untuk server
                            Desc = finalDesc,     -- "Mas: 10% | Dmg: 5%"
                            _ZoneOrder = zoneOrder,  -- Untuk sorting
                            _HP = enemyStats.MaxHealth or 0,  -- Untuk sorting
                            _Owned = isOwned,
                            _Equipped = isEquipped
                        })
                    end
                end
            end
        end
        
        -- ========================================
        -- I. SORTING (by zone order, then HP)
        -- ========================================
        table.sort(list, function(a, b)
            if a._ZoneOrder ~= b._ZoneOrder then
                return a._ZoneOrder < b._ZoneOrder  -- Zona lebih awal dulu
            else
                return a._HP < b._HP  -- HP lebih rendah dulu
            end
        end)
    end
    
    return list
end
```

**Output Example:**
```lua
{
    {Title = "[EQUIPPED] Naruto", Value = "Naruto", Desc = "Mas: 10% | Dmg: 5%"},
    {Title = "Sasuke", Value = "Sasuke", Desc = "Mas: 8% | Dmg: 3%"},
    {Title = "[LOCKED] Madara", Value = "Madara", Desc = "LOCKED - Defeat to unlock"}
}
```

---

### 2️⃣ **3D PREVIEW SYSTEM** (Baris 1902-1945)

```lua
-- ========================================
-- A. PREVIEW CONTAINER SETUP
-- ========================================
local PreviewSection = GeneralManagerSection:Paragraph({
    Title = "Avatar Preview",
    Desc = "Select avatar to view",
    Image = ""
})
GeneralTabs:Add("Avatar", PreviewSection)

-- ========================================
-- B. TRACKING VARIABLE
-- ========================================
local AlreadyUsedAvatar = ""  -- Track avatar terakhir untuk prevent duplicate update

-- ========================================
-- C. UPDATE PREVIEW FUNCTION
-- ========================================
local function UpdatePreview(avatarName)
    -- 1. Ambil container dari Paragraph
    local container = PreviewSection.ParagraphFrame.UIElements.Container
    
    -- 2. Hapus preview lama jika ada
    if container:FindFirstChild("ViewportFrame") then
        container.ViewportFrame:Destroy()
    end
    
    -- 3. Buat ViewportFrame baru (untuk render 3D model)
    local VP = Instance.new("ViewportFrame")
    VP.Size = UDim2.new(1, 0, 0, 150)  -- Full width, 150px height
    VP.BackgroundTransparency = 1
    VP.Parent = container
    
    -- 4. Cari model avatar di ReplicatedFirst
    local Assets = ReplicatedFirst:FindFirstChild("Assets") and 
                   ReplicatedFirst.Assets:FindFirstChild("Enemies")
    
    if Assets then
        local Model = Assets:FindFirstChild(avatarName)
        if Model then
            -- 5. Clone model ke ViewportFrame
            local Clone = Model:Clone()
            Clone.Parent = VP
            
            -- 6. Setup Camera untuk lihat model
            local Cam = Instance.new("Camera")
            VP.CurrentCamera = Cam
            Cam.Parent = VP
            
            -- 7. Posisikan camera di depan model
            local Head = Clone:FindFirstChild("Head") or Clone.PrimaryPart
            if Head then
                Cam.CFrame = CFrame.new(
                    Head.CFrame.Position + Head.CFrame.LookVector * 4 + Vector3.new(0, 0.5, 0),
                    Head.CFrame.Position
                )
            end
            
            -- 8. Animasi rotasi model (optional)
            task.spawn(function()
                while VP.Parent do  -- Selama preview masih ada
                    if Head then
                        -- Rotate model 1 degree per frame
                        Clone:PivotTo(Clone:GetPivot() * CFrame.Angles(0, math.rad(1), 0))
                    end
                    task.wait(0.03)  -- ~30 FPS
                end
            end)
        end
    end
end
```

**Visual Output:**
```
┌────────────────────────────────┐
│    Avatar Preview              │
│  ┌──────────────────────────┐  │
│  │                          │  │
│  │      🧍 (3D Model)       │  │
│  │     rotating slowly      │  │
│  │                          │  │
│  └──────────────────────────┘  │
│  Select avatar to view         │
└────────────────────────────────┘
```

---

### 3️⃣ **AVATAR DROPDOWN SETUP** (Baris 1946-1978)

```lua
-- ========================================
-- A. CREATE DROPDOWN
-- ========================================
AvatarDropdown = GeneralManagerSection:Dropdown({
    Title = "Select Avatar",
    Description = "Loading...",
    Values = {},  -- Akan di-fill oleh Refresh()
    Multi = false,  -- Single selection only
    Flag = "Avatar_Select_Cfg",  -- Save to config
    
    Callback = function(selectedItem)
        -- Extract avatar key dari selection
        local avatarKey = type(selectedItem) == "table" and 
                         selectedItem.Value or 
                         selectedItem
        
        if avatarKey then
            -- ========================================
            -- OPTIMIZATION: Only update if different
            -- ========================================
            if not Window.Closed and avatarKey ~= AlreadyUsedAvatar then
                UpdatePreview(avatarKey)  -- Update 3D preview
                AlreadyUsedAvatar = avatarKey  -- Track untuk next check
            end
            
            -- ========================================
            -- SEND TO SERVER (Equip Avatar)
            -- ========================================
            pcall(function()
                Reliable:FireServer("Avatar Equip", {avatarKey})
            end)
        end
    end
})
GeneralTabs:Add("Avatar", AvatarDropdown)

-- ========================================
-- B. WAIT FOR PLAYER DATA
-- ========================================
repeat
    task.wait()
until (getgenv()).PlayerData

-- ========================================
-- C. INITIAL LOAD
-- ========================================
local InitialAvatarList = GetAvatarsWithStats()
AvatarDropdown:Refresh(InitialAvatarList)  -- Populate dropdown

-- ========================================
-- D. AUTO-SELECT EQUIPPED AVATAR
-- ========================================
local StartEquipped = (getgenv()).PlayerData.Attributes and 
                      (getgenv()).PlayerData.Attributes.Avatar

if StartEquipped then
    -- Cari item yang match dengan equipped avatar
    for _, item in ipairs(InitialAvatarList) do
        if item.Value == StartEquipped then
            AvatarDropdown:Select(item.Title)  -- Select di dropdown
            
            -- Update preview jika belum pernah
            if not Window.Closed and StartEquipped ~= AlreadyUsedAvatar then
                UpdatePreview(StartEquipped)
                AlreadyUsedAvatar = StartEquipped
            end
            break
        end
    end
end
```

**Workflow:**
1. Create dropdown dengan callback
2. Wait hingga PlayerData ready
3. Load avatar list dengan GetAvatarsWithStats()
4. Refresh dropdown dengan data
5. Auto-select avatar yang sedang equipped
6. Update preview untuk equipped avatar

---

### 4️⃣ **AUTO-REFRESH SYSTEM** (Original - Sudah dihapus user)

**Note:** User telah menghapus auto-refresh system, tapi ini adalah cara kerjanya sebelumnya:

```lua
-- ORIGINAL CODE (sudah dihapus):
local LastMorphCount = 0
local LastEquippedAvatar = ""

task.spawn(function()
    while not Window.Destroyed do
        local Data = (getgenv()).PlayerData
        if Data and Data.Attributes then
            -- Hitung jumlah morph yang dimiliki
            local currentMorphCount = 0
            if Data.Morphs then
                for _ in pairs(Data.Morphs) do
                    currentMorphCount = currentMorphCount + 1
                end
            end
            
            -- Cek equipped avatar
            local currentEquipped = Data.Attributes.Avatar or ""
            
            -- Refresh jika ada perubahan
            if currentMorphCount ~= LastMorphCount or 
               currentEquipped ~= LastEquippedAvatar then
                
                LastMorphCount = currentMorphCount
                LastEquippedAvatar = currentEquipped
                
                -- Refresh dropdown list
                if AvatarDropdown and AvatarDropdown.Refresh and not Window.Closed then
                    AvatarDropdown:Refresh(GetAvatarsWithStats())
                end
            end
        end
        task.wait(0.5)  -- Check setiap 0.5 detik
    end
end)
```

**Trigger Refresh:**
- ✅ Saat jumlah morph berubah (dapat avatar baru)
- ✅ Saat equipped avatar berubah
- ❌ **DIHAPUS oleh user** untuk optimasi

---

## 📊 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ 1. SCRIPT INITIALIZATION                                    │
│    PlayerData ready → GetAvatarsWithStats()                 │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. DATA COLLECTION                                          │
│    ┌──────────────────────────────────────┐                 │
│    │ A. Load Zone Orders (sorting)        │                 │
│    │    Configs.Zones → zoneOrders        │                 │
│    └───────────────┬──────────────────────┘                 │
│                    │                                         │
│    ┌───────────────▼──────────────────────┐                 │
│    │ B. Load Machine Stats (bonus)        │                 │
│    │    Configs.Machines.Avatar → stats   │                 │
│    └───────────────┬──────────────────────┘                 │
│                    │                                         │
│    ┌───────────────▼──────────────────────┐                 │
│    │ C. Loop All Zones & Enemies          │                 │
│    │    MultipleZones.Enemies.*           │                 │
│    │    - Check isOwned (Data.Morphs)     │                 │
│    │    - Check isEquipped (Attributes)   │                 │
│    │    - Build description with stats    │                 │
│    └───────────────┬──────────────────────┘                 │
│                    │                                         │
│    ┌───────────────▼──────────────────────┐                 │
│    │ D. Sort by Zone Order & HP           │                 │
│    │    Output: Sorted avatar list        │                 │
│    └───────────────┬──────────────────────┘                 │
└────────────────────┼─────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. UI SETUP                                                 │
│    ┌──────────────────────────────────────┐                 │
│    │ A. Create Preview Paragraph          │                 │
│    │    - ViewportFrame container         │                 │
│    │    - Initialized empty               │                 │
│    └───────────────┬──────────────────────┘                 │
│                    │                                         │
│    ┌───────────────▼──────────────────────┐                 │
│    │ B. Create Avatar Dropdown            │                 │
│    │    - Refresh with avatar list        │                 │
│    │    - Auto-select equipped avatar     │                 │
│    └───────────────┬──────────────────────┘                 │
└────────────────────┼─────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. USER INTERACTION                                         │
│    ┌──────────────────────────────────────┐                 │
│    │ User selects avatar from dropdown    │                 │
│    └───────────────┬──────────────────────┘                 │
│                    │                                         │
│    ┌───────────────▼──────────────────────┐                 │
│    │ Check: Window.Closed?                │                 │
│    │   No → Continue                      │                 │
│    │   Yes → Skip update                  │                 │
│    └───────────────┬──────────────────────┘                 │
│                    │                                         │
│    ┌───────────────▼──────────────────────┐                 │
│    │ Check: avatarKey == AlreadyUsed?     │                 │
│    │   Yes → Skip preview update          │                 │
│    │   No → Continue                      │                 │
│    └───────────────┬──────────────────────┘                 │
│                    │                                         │
│    ┌───────────────▼──────────────────────┐                 │
│    │ UpdatePreview(avatarKey)             │                 │
│    │   - Destroy old ViewportFrame        │                 │
│    │   - Create new ViewportFrame         │                 │
│    │   - Clone model from Assets          │                 │
│    │   - Setup camera                     │                 │
│    │   - Start rotation animation         │                 │
│    └───────────────┬──────────────────────┘                 │
│                    │                                         │
│    ┌───────────────▼──────────────────────┐                 │
│    │ FireServer("Avatar Equip")           │                 │
│    │   - Send to server untuk equip       │                 │
│    │   - Server update PlayerData         │                 │
│    └────────────────────────────────────────                │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎨 UI Layout

```
┌─────────────────────────────────────────────────────────────┐
│                    GENERAL MANAGER SECTION                  │
├─────────────────────────────────────────────────────────────┤
│  [Exchange]  [Crate Roll]  [Avatar] ← Tabs                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              Avatar Preview                            │ │
│  ├────────────────────────────────────────────────────────┤ │
│  │  ┌──────────────────────────────────────────────────┐  │ │
│  │  │                                                  │  │ │
│  │  │             🧍 3D Model                          │  │ │
│  │  │           (rotating slowly)                      │  │ │
│  │  │                                                  │  │ │
│  │  └──────────────────────────────────────────────────┘  │ │
│  │  Select avatar to view                                 │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                             │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Select Avatar                           ▼             │ │
│  ├────────────────────────────────────────────────────────┤ │
│  │  [EQUIPPED] Naruto                                    │ │
│  │  Desc: Mas: 10% | Dmg: 5%                             │ │
│  │  ────────────────────────────────────────────────────  │ │
│  │  Sasuke                                                │ │
│  │  Desc: Mas: 8% | Dmg: 3%                              │ │
│  │  ────────────────────────────────────────────────────  │ │
│  │  [LOCKED] Madara                                       │ │
│  │  Desc: LOCKED - Defeat to unlock                      │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔑 Key Variables & Data Structures

### **Global Variables**
```lua
AvatarDropdown          -- Dropdown UI element (global untuk refresh)
AlreadyUsedAvatar       -- String: Track avatar terakhir untuk optimization
PreviewSection          -- Paragraph UI untuk 3D preview
```

### **PlayerData Structure**
```lua
PlayerData = {
    Morphs = {
        ["Naruto"] = true,      -- Owned avatars
        ["Sasuke"] = true,
        -- Madara tidak ada = locked
    },
    Attributes = {
        Avatar = "Naruto"       -- Currently equipped avatar
    }
}
```

### **Avatar List Item**
```lua
{
    Title = "[EQUIPPED] Naruto",           -- Display text
    Value = "Naruto",                      -- Internal key untuk server
    Desc = "Mas: 10% | Dmg: 5%",          -- Stats description
    _ZoneOrder = 1,                        -- Untuk sorting (internal)
    _HP = 5000,                            -- Untuk sorting (internal)
    _Owned = true,                         -- Ownership flag
    _Equipped = true                       -- Equipped flag
}
```

### **Machine Stats**
```lua
machineStats = {
    ["Naruto"] = {
        Mastery = 10,   -- Mastery bonus %
        Damage = 5      -- Damage bonus %
    },
    ["Sasuke"] = {
        Mastery = 8,
        Damage = 3
    }
}
```

---

## ⚡ Optimizations Implemented

### **1. Duplicate Preview Prevention**
```lua
-- BEFORE: Update preview setiap kali select (wasteful)
UpdatePreview(avatarKey)

// AFTER: Only update jika berbeda
if avatarKey ~= AlreadyUsedAvatar then
    UpdatePreview(avatarKey)
    AlreadyUsedAvatar = avatarKey
end
```

**Benefit:** Prevent unnecessary ViewportFrame recreation

---

### **2. Window Closed Check**
```lua
-- Cek window status sebelum update UI
if not Window.Closed then
    UpdatePreview(avatarKey)
end
```

**Benefit:** Prevent errors saat window sudah destroyed

---

### **3. Auto-Refresh Removal** (by user)
**REMOVED:**
```lua
// Loop check morph changes setiap 0.5s
while not Window.Destroyed do
    if currentMorphCount ~= LastMorphCount then
        AvatarDropdown:Refresh(GetAvatarsWithStats())
    end
    task.wait(0.5)
end
```

**Benefit:** Reduce CPU usage, manual refresh jika perlu

---

## 🎮 User Experience Flow

### **Scenario 1: First Time Open**
```
1. User open tab "General" → Click "Avatar" button
2. Script load semua avatar dengan GetAvatarsWithStats()
3. Dropdown show list dengan status:
   - [EQUIPPED] Naruto (Mas: 10% | Dmg: 5%)
   - Sasuke (Mas: 8% | Dmg: 3%)
   - [LOCKED] Madara (LOCKED - Defeat to unlock)
4. Preview show Naruto model (current equipped)
5. Model rotating slowly untuk visual appeal
```

### **Scenario 2: Change Avatar**
```
1. User click dropdown → Select "Sasuke"
2. Script check:
   ✅ Window not closed
   ✅ Sasuke != Naruto (different avatar)
3. UpdatePreview("Sasuke") executed:
   - Destroy Naruto ViewportFrame
   - Create new ViewportFrame
   - Clone Sasuke model
   - Setup camera & rotation
4. FireServer("Avatar Equip", {"Sasuke"})
5. Server update PlayerData.Attributes.Avatar = "Sasuke"
6. Preview now shows Sasuke model
```

### **Scenario 3: Select Same Avatar**
```
1. User click dropdown → Select "Sasuke" (already equipped)
2. Script check:
   ✅ Window not closed
   ❌ Sasuke == AlreadyUsedAvatar (same!)
3. UpdatePreview SKIPPED (optimization)
4. FireServer still called (untuk safety)
5. No visual change (already showing Sasuke)
```

### **Scenario 4: Unlock New Avatar**
```
1. User defeat boss → Get new avatar "Madara"
2. Server update PlayerData.Morphs["Madara"] = true
3. (OLD SYSTEM - Auto refresh setiap 0.5s)
   - Detect morph count change
   - Auto refresh dropdown
4. (NEW SYSTEM - Manual)
   - User need to reopen/refresh manually
5. Dropdown update:
   - [LOCKED] Madara → Madara (Mas: 15% | Dmg: 10%)
```

---

## 🔧 Integration Points

### **1. Server Communication**
```lua
-- Equip avatar
Reliable:FireServer("Avatar Equip", {avatarKey})
```

### **2. Game Assets**
```lua
-- 3D models location
ReplicatedFirst.Assets.Enemies[avatarName]
```

### **3. Config Modules**
```lua
-- Zone orders
ReplicatedStorage.Scripts.Configs.Zones

// Machine stats
ReplicatedStorage.Scripts.Configs.Machines.Avatar

// Enemy data (avatars)
ReplicatedStorage.Scripts.Configs.MultipleZones.Enemies.*
```

### **4. PlayerData Integration**
```lua
(getgenv()).PlayerData = {
    Morphs = {...},         -- Ownership
    Attributes = {
        Avatar = "..."      -- Equipped
    }
}
```

---

## 🐛 Error Handling

### **1. Missing Model**
```lua
local Model = Assets:FindFirstChild(avatarName)
if Model then
    -- Create preview
else
    -- Silently fail, keep old preview
end
```

### **2. Missing PlayerData**
```lua
repeat
    task.wait()
until (getgenv()).PlayerData  -- Wait until ready
```

### **3. pcall Protection**
```lua
pcall(function()
    Reliable:FireServer("Avatar Equip", {avatarKey})
end)
-- No error if Reliable not available
```

---

## 📈 Performance Metrics

| Operation | Frequency | Optimization |
|-----------|-----------|--------------|
| GetAvatarsWithStats() | On demand only | ✅ Not in loop |
| UpdatePreview() | On avatar change | ✅ Duplicate check |
| Dropdown Refresh | Manual | ✅ Auto-refresh removed |
| Rotation Animation | 30 FPS | ✅ Async task |
| Server FireServer | On select | ⚠️ Not debounced |

---

## 🎯 Key Features Summary

✅ **Smart Loading:** Load from multiple sources (Zones, Machines, Enemies)  
✅ **Status Tracking:** LOCKED / Owned / EQUIPPED  
✅ **Stats Display:** Show Mastery & Damage bonuses  
✅ **3D Preview:** Real-time rotating 3D model  
✅ **Auto-Select:** Auto-select currently equipped avatar  
✅ **Optimization:** Duplicate prevention & Window.Closed check  
✅ **Sorting:** By zone order then HP  
✅ **Integration:** Full server sync dengan FireServer  

---

## 🔮 Future Enhancement Ideas

1. **Search/Filter:** Add search bar untuk cari avatar
2. **Stats Compare:** Compare stats before equipping
3. **Preview Animations:** Play avatar attack animations
4. **Quick Equip:** Double-click to equip
5. **Favorites:** Mark favorite avatars
6. **Preview Zoom:** Zoom in/out camera
7. **Multi-Preview:** Show multiple avatars side-by-side

---

**Created by:** AI Assistant  
**Date:** 2025-11-26  
**Version:** 1.0  
**Related to:** Defense_Gamemode_Flow.md
