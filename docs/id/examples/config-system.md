# Sistem Konfigurasi

Resep simpan/muat yang lengkap: elemen ber-flag yang nilainya persisten, pemilih config yang diisi dari disk, tombol Save/Load, dan toggle auto-load. Ini diadaptasi dari tab **Config Usage** pada demo.

::: warning Butuh akses file executor
Penyimpanan config membaca dan menulis file JSON di disk, jadi executor Anda harus mendukung global file `readfile`, `writefile`, `isfile`, dan `makefolder`. Config disimpan di `ANUI/<Folder>/config/<name>.json`, di mana `<Folder>` adalah `Folder` yang Anda berikan ke `CreateWindow`.
:::

## 1. Beri flag pada elemen Anda

Setiap elemen stateful (Toggle, Slider, Dropdown, Input, Keybind, Colorpicker) yang punya key `Flag` otomatis terdaftar ke config yang aktif. Nilainya ditulis saat Save dan dipulihkan saat Load — Anda tidak perlu menulis kode tambahan per elemen.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Folder = "MyHub", -- WAJIB untuk config — ini adalah root di disk
})

local Tab = Window:Tab({ Title = "Settings", Icon = "sliders-horizontal" })

-- Setiap `Flag` menjadi sebuah key di dalam file JSON yang disimpan.
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

## 2. Ambil ConfigManager dan tetapkan current config

`Window.ConfigManager` dibuat otomatis karena kita memberikan `Folder`. Kita simpan nama config dalam sebuah variabel dan jadikan satu config **current** di awal, agar nilai ber-flag selalu punya tempat untuk disimpan.

```lua
local ConfigTab = Window:Tab({ Title = "Config", Icon = "folder" })

local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- Pastikan sebuah current config ada. `:Config(name)` membuat-atau-membuka-nya (alias dari :CreateConfig).
Window.CurrentConfig = ConfigManager:Config(ConfigName)
```

## 3. Input Config Name

Biarkan pengguna mengetik nama config yang akan disimpan atau dimuat. Kita simpan kembali ke `ConfigName`.

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

`ConfigModule:SetAutoLoad(bool)` menandai sebuah config agar dimuat otomatis saat startup. Kita panggil pada current config.

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

`ConfigManager:AllConfigs()` mengembalikan nama setiap config yang sudah ada di disk. Kita masukkan daftar itu ke sebuah dropdown agar pengguna bisa memilih yang sudah ada. Saat mereka memilih, kita sinkronkan input nama dan mencerminkan state auto-load tersimpan dari config itu (dibaca dari field `.AutoLoad`-nya).

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

## 6. Tombol Save dan Load

Tombol Save menjadikan `ConfigName` sebagai current config lalu memanggil `:Save()`; jika berhasil kita beri notifikasi dan me-refresh dropdown agar config baru muncul di daftar. Tombol Load membuka config dan memanggil `:Load()`, yang memulihkan setiap nilai ber-flag.

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
`:Config(name)` dan `:CreateConfig(name)` adalah alias — keduanya membuat file config jika belum ada, atau membukanya jika sudah. `:Save()` dan `:Load()` mengembalikan nilai truthy saat berhasil, itulah sebabnya tombol di atas memberi notifikasi hanya ketika operasi berhasil.
:::

Untuk alur flag lengkap, daftar tipe elemen yang dipersistkan, dan setiap method `ConfigManager` / `ConfigModule`, lihat [Konfigurasi & Flag](/id/features/config-and-flags).
