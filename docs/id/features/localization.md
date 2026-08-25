# Lokalisasi

ANUI memiliki lapisan terjemahan bawaan. Anda mendaftarkan terjemahan per bahasa, mengaktifkan sistemnya, lalu setiap string yang diawali prefix lokalisasi (`loc:`) akan dicari dan diganti dengan terjemahan untuk bahasa yang aktif.

## Mengaktifkan lokalisasi

### `ANUI:Localization(config)`

Mendaftarkan tabel terjemahan Anda dan menyalakan sistemnya. Panggil sekali saja, di awal — sebelum atau tepat setelah membuat window.

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Enabled` | `boolean` | `false` | Saklar utama. Harus `true` agar terjemahan berjalan. |
| `Translations` | `table` | `{}` | Peta kode bahasa → tabel terjemahan `{ key = value }`. |
| `Prefix` | `string` | `"loc:"` | Penanda yang menandai sebuah string untuk diterjemahkan. |
| `DefaultLanguage` | `string` | `"en"` | Bahasa yang dipakai sampai Anda memanggil `SetLanguage`. |

```lua
ANUI:Localization({
    Enabled = true,
    DefaultLanguage = "en",
    Translations = {
        en = {
            welcome = "Welcome!",
            settings = "Settings",
        },
        id = {
            welcome = "Selamat datang!",
            settings = "Pengaturan",
        },
    },
})
```

## Menggunakan string terjemahan

Awali judul atau label mana pun dengan `loc:` diikuti key terjemahan. ANUI akan menyelesaikannya berdasarkan tabel bahasa yang aktif.

```lua
local Tab = Window:Tab({
    Title = "loc:settings", -- menampilkan "Settings" (en) atau "Pengaturan" (id)
    Icon = "settings",
})

Tab:Button({
    Title = "loc:welcome",
    Callback = function() end,
})
```

::: info Cara kerja prefix
Hanya string yang **diawali prefix** (`loc:` secara default) yang diterjemahkan — teks setelah prefix adalah key pencarian. String lainnya ditampilkan persis seperti yang ditulis. Jika sebuah key tidak ada pada bahasa yang aktif, string akan ditampilkan apa adanya, jadi tidak ada yang rusak.
:::

## Mengganti bahasa saat runtime

### `ANUI:SetLanguage(language)`

Mengganti bahasa yang aktif. Membutuhkan lokalisasi dalam keadaan aktif — mengembalikan `false` jika Anda tidak pernah memanggil `Localization` dengan `Enabled = true`.

```lua
ANUI:SetLanguage("id") -- ganti ke Bahasa Indonesia
```

## Contoh lengkap

Mengaktifkan terjemahan Inggris + Indonesia, memakai string `loc:` pada tab beserta elemennya, dan membiarkan pengguna mengganti bahasa dari sebuah dropdown.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Localization({
    Enabled = true,
    DefaultLanguage = "en",
    Translations = {
        en = {
            title = "Control Panel",
            farm = "Auto Farm",
            language = "Language",
        },
        id = {
            title = "Panel Kontrol",
            farm = "Farm Otomatis",
            language = "Bahasa",
        },
    },
})

local Window = ANUI:CreateWindow({ Title = "loc:title" })
local Tab = Window:Tab({ Title = "loc:title", Icon = "gamepad-2" })

Tab:Toggle({
    Title = "loc:farm",
    Callback = function(on)
        print("farm:", on)
    end,
})

Tab:Dropdown({
    Title = "loc:language",
    Values = { "en", "id" },
    Value = "en",
    Callback = function(lang)
        ANUI:SetLanguage(lang)
    end,
})
```

::: tip
Karena terjemahan hanya menyentuh string yang diawali `loc:`, string terlokalisasi dan string biasa bisa berdampingan — bebas dicampur sesuka Anda.
:::
