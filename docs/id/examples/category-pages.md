# Halaman Kategori

Pola yang umum: satu tab yang menampilkan beberapa "halaman" elemen, yang dialihkan lewat strip horizontal di atas. Ini dibangun dengan elemen [Category](/id/elements/category). Resep di bawah diadaptasi dari **Upgrade System** pada demo.

## Cara kerjanya

Category menampilkan baris opsi yang bisa di-scroll. Saat pengguna memilih salah satu, `Callback`-nya terpanggil dengan nama opsi yang dipilih. Kita simpan sebuah tabel yang memetakan setiap nama opsi ke elemen yang menjadi miliknya, lalu membalik `.Visible` setiap elemen sehingga hanya halaman aktif yang tampil.

## 1. Lacak elemen per kategori

Definisikan kategori, sebuah helper untuk menemukan frame elemen, dan sebuah helper yang mendaftarkan elemen ke sebuah kategori (menyembunyikannya secara default).

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "My Hub", Folder = "MyHub" })
local Tab = Window:Tab({ Title = "Upgrades", Icon = "hammer" })

-- Satu wadah elemen per kategori.
local Categories = {
    Combat = {},
    Farming = {},
    Settings = {},
}

-- Jangkau frame root elemen agar kita bisa mengalihkan visibilitasnya.
local function GetElementFrame(element)
    if element.ElementFrame then
        return element.ElementFrame
    elseif element.UIElements and element.UIElements.Main then
        return element.UIElements.Main
    end
    for _, value in pairs(element) do
        if type(value) == "table" and value.UIElements and value.UIElements.Main then
            return value.UIElements.Main
        end
    end
    return nil
end

-- Daftarkan elemen ke sebuah kategori dan sembunyikan di awal.
local function AddElement(categoryName, element)
    if Categories[categoryName] then
        table.insert(Categories[categoryName], element)
        local frame = GetElementFrame(element)
        if frame then
            frame.Visible = false
        end
    end
    return element
end

-- Tampilkan hanya elemen kategori terpilih; sembunyikan sisanya.
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        local isVisible = (name == selected)
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then
                frame.Visible = isVisible
            end
        end
    end
end
```

## 2. Tambahkan strip Category

Buat Category dengan satu opsi per halaman. `Default` menetapkan halaman yang tampil pertama, dan `Callback` menjalankan `OnCategoryChanged` setiap kali pengguna beralih.

```lua
Tab:Category({
    Title = "Select Category",
    Default = "Combat",
    Options = {
        { Title = "Combat", Icon = "sword" },
        { Title = "Farming", Icon = "coins" },
        { Title = "Settings", Icon = "settings" },
    },
    Callback = OnCategoryChanged, -- menerima nama opsi terpilih (string)
})

Tab:Space({ Columns = 1 }) -- sedikit ruang di bawah strip
```

## 3. Bangun tiap halaman dan daftarkan elemennya

Buat elemen seperti biasa, bungkus masing-masing dengan `AddElement("<kategori>", ...)` agar bergabung ke wadah yang tepat dan mulai dalam keadaan tersembunyi.

```lua
-- Combat
AddElement("Combat", Tab:Paragraph({ Title = "Combat", Desc = "Fighting options" }))
AddElement("Combat", Tab:Toggle({ Title = "God Mode", Callback = function(v) print(v) end }))
AddElement("Combat", Tab:Slider({ Title = "Damage", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end }))

-- Farming
AddElement("Farming", Tab:Paragraph({ Title = "Farming", Desc = "Auto-farm options" }))
AddElement("Farming", Tab:Toggle({ Title = "Auto Farm", Callback = function(v) print(v) end }))
AddElement("Farming", Tab:Dropdown({ Title = "Target", Values = { "Coins", "Gems", "XP" }, Value = "Coins", Callback = function(v) print(v) end }))

-- Settings
AddElement("Settings", Tab:Paragraph({ Title = "Settings", Desc = "Menu settings" }))
AddElement("Settings", Tab:Toggle({ Title = "Auto Save", Callback = function(v) print(v) end }))
```

## 4. Tampilkan halaman default

Category dimulai pada `Default`, jadi panggil `OnCategoryChanged` sekali untuk menyembunyikan halaman lain di awal.

```lua
OnCategoryChanged("Combat")
```

Itulah keseluruhan polanya: mengganti opsi kini menukar halaman elemen mana yang terlihat.

## Alternatif: capture bawaan

Category bisa melacak elemen untuk Anda alih-alih tabel `Categories` manual. Dengan `AutoCapture` aktif (default), elemen yang dibuat setelah Category akan dikaitkan otomatis. Cara paling rapi adalah `:With(name, builder)` — semua yang dibuat di dalam builder ditugaskan ke opsi itu, dan Category menampilkan/menyembunyikan tiap grup saat Anda beralih:

```lua
local cat = Tab:Category({
    Title = "Select Category",
    Default = "Combat",
    Options = { "Combat", "Farming", "Settings" },
})

cat:With("Combat", function()
    Tab:Toggle({ Title = "God Mode", Callback = function(v) print(v) end })
    Tab:Slider({ Title = "Damage", Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) print(v) end })
end)

cat:With("Farming", function()
    Tab:Toggle({ Title = "Auto Farm", Callback = function(v) print(v) end })
end)

cat:With("Settings", function()
    Tab:Toggle({ Title = "Auto Save", Callback = function(v) print(v) end })
end)
```

::: tip
`:Capture(name)` / `:StopCapture()` melakukan hal yang sama tanpa builder — apit rentang pembuatan elemen apa pun di antara keduanya. Gunakan `:GetElements(name?)` untuk membaca kembali apa yang sedang dilacak sebuah kategori. Lihat daftar method lengkap di halaman [Category](/id/elements/category).
:::
