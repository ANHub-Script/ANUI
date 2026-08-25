# Key System

Sistem key mengunci menu Anda di balik prompt key yang ditampilkan sebelum window terbuka. Konfigurasikan dengan memberikan tabel `KeySystem` ke [`ANUI:CreateWindow{}`](/id/guide/window-configuration). ANUI dapat memvalidasi key secara lokal, melalui fungsi kustom, atau lewat penyedia key bawaan.

## Penggunaan dasar

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Enter your key to continue.",
        Key = { "free-key" },
        SaveKey = true,
    },
})
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `Title` window | Judul prompt key. Kembali ke judul window jika kosong. |
| `Note` | `string` | — | Teks petunjuk yang ditampilkan di bawah judul. |
| `Thumbnail` | `table` | — | Gambar preview: `{ Image, Title?, Width = 200 }`. |
| `URL` | `string` | — | Menampilkan tombol **Get key** yang menyalin URL ini ke clipboard. |
| `Key` | `string` \| `array` | — | Key yang diterima atau daftar key, divalidasi secara lokal. |
| `KeyValidator` | `function` | — | `fn(key) -> boolean`. Pemeriksaan kustom dengan **prioritas tertinggi**. |
| `SaveKey` | `boolean` | — | Ketika `true`, menulis key yang diterima ke `ANUI/<Folder>/<hwid>.key` agar pengguna tidak ditanya lagi. |
| `API` | `array` | — | Satu atau lebih konfigurasi layanan penyedia key (lihat [Penyedia](#penyedia)). |

::: warning Membutuhkan fungsi file dan HTTP executor
`SaveKey` membaca dan menulis file key, jadi butuh global file executor (`readfile`/`writefile`/`isfile`), plus `gethwid` untuk nama file-nya. Penyedia `API` melakukan permintaan HTTP untuk memverifikasi key, jadi butuh dukungan `game:HttpGet`/request. Pemeriksaan `Key` lokal dan `KeyValidator` bekerja tanpa semua itu.
:::

## Prioritas validasi

Ketika pengguna mengirimkan key, ANUI memeriksanya dalam urutan berikut dan berhenti pada kecocokan pertama:

1. **`KeyValidator`** — fungsi kustom Anda, jika disediakan.
2. **`Key`** — key atau daftar key lokal.
3. **`API`** — layanan penyedia yang dikonfigurasi, secara berurutan.

## Penyedia

Setiap entri dalam `API` adalah tabel dengan `Type` dan argumen wajib milik penyedia tersebut. Sebuah entri juga bisa membawa `Icon`, `Title`, dan `Desc` untuk menyesuaikan tampilannya di prompt.

| `Type` | Argumen wajib | Catatan |
| --- | --- | --- |
| `luarmor` | `ScriptId`, `Discord` | Layanan key Luarmor. |
| `platoboost` | `ServiceId`, `Secret` | Layanan key Platoboost. |
| `pandadevelopment` | `ServiceId` | Layanan key Panda Development. |

```lua
API = {
    {
        Type = "luarmor",
        ScriptId = "your-script-id",
        Discord = "https://discord.gg/bUkCZvmrpH",
        Icon = "key",          -- opsional
        Title = "Luarmor",     -- opsional
        Desc = "Get a key",    -- opsional
    },
}
```

## Contoh

### Key statis dengan SaveKey

Menerima salah satu dari beberapa key tetap dan mengingat key yang berhasil.

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Title = "My Hub — Key",
        Note = "Get your key from the Discord.",
        URL = "https://discord.gg/bUkCZvmrpH",
        Key = { "key1", "key2" },
        SaveKey = true,
    },
})
```

### Validator kustom

`KeyValidator` menerima key yang dimasukkan sebagai string dan mengembalikan boolean. Ia berjalan sebelum daftar `Key` dan layanan `API`.

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Enter your personal key.",
        KeyValidator = function(key)
            -- terima key apa pun yang diakhiri dengan UserId pemain
            return key == "VIP-" .. game.Players.LocalPlayer.UserId
        end,
    },
})
```

### Penyedia Luarmor

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Verify your Luarmor key.",
        API = {
            {
                Type = "luarmor",
                ScriptId = "your-script-id",
                Discord = "https://discord.gg/bUkCZvmrpH",
            },
        },
    },
})
```

### Penyedia Platoboost

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Verify your Platoboost key.",
        SaveKey = true,
        API = {
            {
                Type = "platoboost",
                ServiceId = "your-service-id",
                Secret = "your-secret",
            },
        },
    },
})
```

## Lihat juga

- [Konfigurasi Window](/id/guide/window-configuration) — tempat `KeySystem` dan `Folder` diatur.
