# Menu Dasar

Menu awal yang lengkap dan diberi banyak komentar, siap Anda salin, tempel, dan jalankan. Ia membuat sebuah window dengan dua tab, campuran elemen paling umum, sebuah section untuk pengelompokan, dan notifikasi yang dipicu dari sebuah button.

## Skrip

```lua
-- 1. Muat ANUI ke dalam local bernama `ANUI`.
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

-- 2. Buat window. Hanya SATU window yang boleh ada.
local Window = ANUI:CreateWindow({
    Title = "My Hub",                      -- judul di top bar
    Author = "by you",                     -- subjudul di bawah judul
    Icon = "rbxassetid://84366761557806",  -- ikon top-bar (asset id atau nama ikon Lucide)
    Folder = "MyHub",                      -- folder disk untuk config/key (disimpan di ANUI/MyHub)
    OpenButton = {                         -- tombol mengambang untuk membuka kembali window saat ditutup
        Title = "My Hub",
        Enabled = true,
        Draggable = true,
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
    },
})

-- 3. Tambahkan tab. Setiap tab menampung elemen dan muncul di sidebar.
local Main = Window:Tab({ Title = "Main", Icon = "house" })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

-- 4. Paragraph adalah blok rich-text — cocok sebagai pengantar di atas tab.
Main:Paragraph({
    Title = "Welcome",
    Desc = "This starter menu shows the most common ANUI elements.",
})

-- Toggle — callback menerima BOOLEAN (state on/off yang baru).
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Value = false,
    Callback = function(state) -- state: boolean
        print("Auto Farm:", state)
    end,
})

-- Slider — callback menerima STRING TERFORMAT (nilai, diformat sesuai step-nya).
Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: string terformat
        print("Walk Speed:", value)
    end,
})

-- 5. Section mengelompokkan elemen terkait di bawah header yang bisa dilipat.
--    Ini adalah container, jadi Anda membuat elemen pada section itu sendiri.
local combat = Main:Section({ Title = "Combat" })

-- Dropdown — callback single-select menerima nilai yang dipilih (di sini berupa string).
combat:Dropdown({
    Title = "Weapon",
    Values = { "Sword", "Bow", "Staff" },
    Value = "Sword",
    Callback = function(value) -- value: item yang dipilih
        print("Weapon:", value)
    end,
})

-- Keybind — callback menerima NAMA KEY sebagai string (mis. "G").
combat:Keybind({
    Title = "Attack Key",
    Value = "G",
    Callback = function(key) -- key: string nama key
        print("Attack bound to:", key)
    end,
})

-- 6. Button menjalankan callback TANPA ARGUMEN. Di sini ia memunculkan notifikasi.
Settings:Button({
    Title = "Say Hello",
    Icon = "bell",
    Callback = function() -- tanpa argumen
        ANUI:Notify({
            Title = "Hello!",
            Content = "Welcome to ANUI",
            Icon = "bell",
            Duration = 3,
        })
    end,
})
```

## Apa fungsi tiap bagian

- **Baris load** — menarik library dan menugaskannya ke `ANUI`. Setiap contoh diawali seperti ini.
- **`ANUI:CreateWindow`** — mengembalikan `Window` tempat Anda membangun. `Folder` adalah lokasi config dan key di disk; `OpenButton` menambahkan tombol mengambang yang bisa digeser untuk membuka kembali window. Lihat [Konfigurasi Window](/id/guide/window-configuration).
- **`Window:Tab`** — setiap tab adalah halaman di sidebar sekaligus container untuk elemen.
- **Elemen** — dibuat dengan memanggil method pada container (Tab atau Section). Simpan nilai yang dikembalikan jika ingin memperbarui elemen nanti.
- **`Main:Section`** — container yang bisa dilipat dan mengekspos method elemen yang sama seperti Tab, sehingga Anda bisa mengelompokkan kontrol terkait.
- **`ANUI:Notify`** — memunculkan toast. Field teks isinya adalah `Content` (bukan `Desc`), dan field ikonnya adalah `Icon`.

::: tip Pelajari tiap elemen
Setiap elemen punya halamannya sendiri dengan tabel config dan method lengkap: [Toggle](/id/elements/toggle), [Slider](/id/elements/slider), [Dropdown](/id/elements/dropdown), [Button](/id/elements/button), [Keybind](/id/elements/keybind), [Paragraph](/id/elements/paragraph), dan [Section](/id/elements/section). Jelajahi semuanya di [Ikhtisar Elemen](/id/elements/).
:::
