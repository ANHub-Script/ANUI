# Config & Flags

ANUI dapat menyimpan dan memulihkan state menu Anda ke disk. Beri elemen yang bisa dipersistenkan sebuah `Flag`, maka nilainya ditulis saat Anda menyimpan config dan dipulihkan saat Anda memuatnya — tanpa perlu pencatatan manual.

::: info Membutuhkan `Folder` pada window
Sistem config ditenagai oleh `Window.ConfigManager`, yang hanya ada ketika window dibuat dengan `Folder`. Atur satu di [`ANUI:CreateWindow{}`](/id/guide/window-configuration) sebelum menggunakan apa pun di halaman ini.
:::

## Cara kerja flag

Setiap elemen yang bisa dipersistenkan menerima `Flag = "key"`. Ketika Anda mengaturnya:

1. Elemen otomatis mendaftar ke **config saat ini** (`Window.CurrentConfig`).
2. Memanggil `:Save()` pada config itu menulis nilai setiap flag terdaftar ke file JSON.
3. Memanggil `:Load()` membaca file tersebut kembali dan memulihkan tiap elemen ke nilai yang tersimpan.

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm", -- nilai ini kini bisa dipersistenkan
    Callback = function(v) print(v) end,
})
```

Flag pada elemen yang dibuat sebelum ada config saat ini akan diantrekan; antrean itu dikuras dan didaftarkan pada `:Save()` atau `:Load()` berikutnya.

## Apa saja yang dipersistenkan

Hanya tipe elemen berikut yang menserialisasi state-nya. Elemen lain diabaikan oleh sistem config.

| Element | Yang disimpan |
| --- | --- |
| `Colorpicker` | Warna hex **dan** transparansi |
| `Dropdown` | Nilai yang dipilih |
| `Input` | Nilai teks |
| `Keybind` | Key yang di-bind |
| `Slider` | Nilai default (`Value.Default`) |
| `Toggle` | Nilai boolean |

## Di mana config disimpan

Config ditulis di dalam folder root `ANUI/`, di dalam `Folder` window Anda:

```
ANUI/<Folder>/config/<name>.json
```

Contohnya, dengan `Folder = "MyHub"`, config bernama `default` berada di `ANUI/MyHub/config/default.json`.

::: warning Membutuhkan fungsi file executor
Menyimpan dan memuat menyentuh filesystem. Executor Anda harus menyediakan global file — `readfile`, `writefile`, `isfile`, dan `makefolder` (beserta helper terkait). Tanpa itu, `:Save()` dan `:Load()` tidak dapat mempersistenkan apa pun.
:::

## Manajer config — `Window.ConfigManager`

`Window.ConfigManager` membuat dan mengelola file config bernama.

### `ConfigManager:CreateConfig(filename, autoload?)`

Membuat (atau membuka) config berdasarkan nama dan mengembalikan sebuah **objek config**. `autoload` opsional menandainya agar dimuat otomatis. `ConfigManager:Config(...)` adalah alias.

```lua
local ConfigManager = Window.ConfigManager
local config = ConfigManager:CreateConfig("default")
```

### `ConfigManager:GetConfig(name)`

Mengembalikan objek config untuk nama yang sudah ada (mengekspos field seperti `.AutoLoad`).

### `ConfigManager:GetAutoLoadConfigs()`

Mengembalikan config yang ditandai untuk auto-load (sebagai string JSON).

### `ConfigManager:DeleteConfig(name)`

Menghapus file config berdasarkan nama.

### `ConfigManager:AllConfigs()`

Mengembalikan array berisi semua nama config — berguna untuk mengisi dropdown.

```lua
local names = ConfigManager:AllConfigs() -- { "default", "pvp", ... }
```

## Objek config

`CreateConfig`/`Config`/`GetConfig` semuanya mengembalikan objek config (sebuah `ConfigModule`) dengan method berikut.

### `config:SetAsCurrent()`

Menandai config ini sebagai `Window.CurrentConfig`, sehingga elemen ber-flag yang baru akan mendaftar ke config ini.

### `config:Register(name, element)`

Mendaftarkan elemen secara manual di bawah sebuah key (biasanya tidak perlu — `Flag` melakukannya untuk Anda).

### `config:Set(key, value)` / `config:Get(key)`

Menyimpan dan membaca data kustom sembarang di samping flag Anda.

```lua
config:Set("lastPlayer", game.Players.LocalPlayer.Name)
print(config:Get("lastPlayer"))
```

### `config:SetAutoLoad(bool)`

Menandai (atau membatalkan tanda) config ini agar dimuat otomatis.

### `config:Save()`

Menulis setiap flag terdaftar dan nilai kustom ke disk. Mengembalikan nilai truthy jika berhasil.

### `config:Load()`

Membaca file dan memulihkan setiap elemen terdaftar. Mengembalikan nilai truthy jika berhasil.

### `config:Delete()`

Menghapus file milik config ini.

### `config:GetData()`

Mengembalikan seluruh tabel data yang saat ini dipegang oleh config.

## `Window.CurrentConfig`

`Window.CurrentConfig` memegang objek config yang aktif. Elemen ber-flag mendaftar ke sana, dan config inilah yang menjadi sasaran `:SetAutoLoad`, `:Save`, dan `:Load` ketika dijalankan dari UI Anda. Arahkan ke sebuah config sebelum menyimpan atau memuat:

```lua
Window.CurrentConfig = ConfigManager:CreateConfig("default")
Window.CurrentConfig:Load()
```

## UI Save / Load lengkap

Panel config lengkap: input nama, dropdown config yang sudah ada, toggle auto-load, dan tombol Save / Load. Diadaptasi dari tab "Config Usage" pada script contoh.

```lua
local ConfigManager = Window.ConfigManager
local ConfigName = "default"

-- Nama config yang akan disimpan/dimuat
local ConfigNameInput = ConfigTab:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Callback = function(value)
        ConfigName = value
    end,
})

-- Toggle auto-load untuk config saat ini
local AutoLoadToggle = ConfigTab:Toggle({
    Title = "Enable Auto Load to Selected Config",
    Value = false,
    Callback = function(v)
        Window.CurrentConfig:SetAutoLoad(v)
    end,
})

-- Dropdown yang menampilkan setiap config yang ada
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

-- Simpan state saat ini ke ConfigName
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
        -- refresh dropdown agar config yang baru dibuat muncul
        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
    end,
})

-- Muat ConfigName kembali ke UI
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

## Lihat juga

- [Contoh Sistem Konfigurasi](/id/examples/config-system) — panduan lengkap yang bisa langsung disalin.
