# Category

Deretan opsi horizontal yang bisa di-scroll dan berfungsi sebagai pemilih sub-tab di dalam sebuah tab. Pilih sebuah opsi, lalu di dalam callback tampilkan kelompok elemen yang sesuai sambil menyembunyikan sisanya — cara ringkas untuk memuat banyak "halaman" kontrol dalam satu tab.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })

myTab:Category({
    Title = "Select Category",
    Default = "Weapons",
    Options = {
        { Title = "Weapons", Icon = "sword" },
        { Title = "Armor",   Icon = "shield" },
        { Title = "Potions", Icon = "flask-round" },
    },
    Callback = function(selected)
        print("Selected category:", selected)
    end,
})
```

## Konfigurasi

Field yang mengatur perilaku:

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | Label yang tampil di atas deretan opsi. |
| `Desc` | `string` | `nil` | Deskripsi opsional di bawah judul. |
| `Options` | `array` | `{}` | Opsi yang dapat dipilih. Tiap entri berupa **string** atau **tabel opsi** (lihat di bawah). |
| `Default` | `string` | opsi pertama | Opsi yang terpilih saat dibuat. |
| `Callback` / `OnChanged` | `function` | `nil` | Dijalankan saat pilihan berubah. **Menerima nama opsi yang dipilih (string).** |

### Entri opsi

Tiap entri dalam `Options` berupa string biasa, atau sebuah tabel:

| Field | Type | Deskripsi |
| --- | --- | --- |
| `Title` / `Name` / `Value` / `[1]` | `string` | Nama opsi — nilai yang diteruskan ke callback. |
| `Icon` / `Image` | `string` | Ikon opsional (nama Lucide atau `rbxassetid://…`). |
| `IconSize` | `number` | Penimpaan ukuran ikon per-opsi. |
| `Desc` | `string` | Deskripsi opsional per-opsi. |

Opsi juga dapat membawa field ikon terperinci `ScaleType`, `KeepAspect` / `Native`, `NativeSize`, dan `Tint`.

### Tampilan & tata letak

Semuanya opsional; nilai default sudah disetel agar cocok dengan sisa UI.

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Height` | `number` | `45` | Tinggi seluruh deretan. |
| `ButtonHeight` | `number` | `32` | Tinggi tiap tombol opsi. |
| `IconSize` | `number` | `18` | Ukuran ikon opsi default. |
| `TextSize` | `number` | `14` | Ukuran teks label opsi. |
| `Radius` | `number` | `8` | Radius sudut tombol opsi. |
| `Gap` / `Padding` | `number` | `8` | Jarak antar tombol opsi. |
| `SidePadding` | `number` | `12` | Padding di ujung kiri/kanan deretan. |
| `ScrollSpeed` | `number` | `35` | Kecepatan scroll horizontal. |
| `Transparency` | `number` | `0.5` | Transparansi latar tombol yang tidak aktif. |
| `AutoCapture` | `boolean` | `true` | Otomatis mendaftarkan elemen yang dibuat setelah Category ke opsi saat ini (lihat di bawah). |
| `Sticky` | `boolean` | `nil` (auto) | Menyematkan deretan saat tab di-scroll. |
| `ZIndex` | `number` | `6` | Urutan render deretan. |

::: details Opsi tag & ikon lanjutan
`ActiveTag` (`"Toggle"`), `InactiveTag` (`"Button"`), dan `TextTag` (`"Text"`) memilih tag tema yang dipakai untuk menata tombol aktif/tidak aktif beserta teksnya. `IconScaleType`, `IconKeepAspect` (`true`), `IconAutoWidth` (`true`), dan `TintIcon` (auto) menyetel detail render ikon, sementara `ContentPadding` (`5`) dan `AlignWithContent` (`true`) mengatur bagaimana deretan disejajarkan dengan elemen di bawahnya.
:::

## Method

### `Category:Select(name, silent?)`

Memilih opsi berdasarkan nama. Berikan `silent = true` untuk memperbarui pilihan tanpa memicu callback. Punya alias `Category:SetValue(name, silent?)`.

```lua
category:Select("Armor")
category:Select("Potions", true) -- tanpa callback
```

### `Category:GetSelected()`

Mengembalikan nama opsi yang sedang terpilih.

```lua
print(category:GetSelected())
```

### `Category:SetCallback(fn)`

Mengganti callback perubahan.

```lua
category:SetCallback(function(name) print("now on", name) end)
```

### `Category:Add(name, ...)`

Mendaftarkan satu atau lebih elemen yang sudah ada ke opsi `name`, sehingga elemen itu ikut tampil/sembunyi bersamanya.

### `Category:Remove(item)`

Membatalkan pendaftaran elemen yang sebelumnya ditambahkan.

### `Category:GetElements(name?)`

Mengembalikan elemen yang terdaftar pada sebuah opsi, atau semuanya jika `name` tidak diberikan.

### `Category:Refresh()`

Membangun ulang deretan opsi setelah opsi atau elemennya berubah.

### `Category:Capture(name)` / `Category:StopCapture()`

Mulai menangkap elemen yang baru dibuat ke opsi `name`, dan menghentikan penangkapan. Ini bentuk manual dari `AutoCapture`.

### `Category:With(name, builder)`

Menjalankan `builder` dan mendaftarkan setiap elemen yang dibuatnya ke opsi `name`.

```lua
category:With("Weapons", function()
    myTab:Toggle({ Title = "Auto Swing" })
    myTab:Slider({ Title = "Range", Value = { Min = 0, Max = 50, Default = 10 } })
end)
```

### `Category:AddOption(option, order?)`

Menambahkan opsi baru yang dapat dipilih, secara opsional pada posisi `order`.

### `Category:RemoveOption(name)`

Menghapus opsi berdasarkan nama.

### `Category:SetOptions(options, newDefault?)`

Mengganti semua opsi, secara opsional memilih `newDefault`.

### `Category:GetOptions()`

Mengembalikan opsi saat ini.

### `Category:SetHeight(h)`

Mengatur tinggi deretan.

### `Category:Destroy()`

Menghapus Category.

## Pola tampil/sembunyi

::: tip Penggunaan umum
Pola yang lazim adalah membuat Category dengan opsi Anda, lalu di dalam callback **menampilkan elemen opsi yang dipilih dan menyembunyikan sisanya**. Anda bisa melacak elemen sendiri dan mengubah `.Visible` masing-masing, atau memanfaatkan `AutoCapture` (aktif secara default) yang mengaitkan setiap elemen yang dibuat *setelah* Category ke opsi saat ini sehingga ia mengelola visibilitas untuk Anda. `Category:With(name, builder)` dan `Category:Capture(name)` / `Category:StopCapture()` memberi kontrol eksplisit atas penangkapan tersebut.
:::

Contoh di bawah membangun "Upgrade System" kecil: tabel `Categories` menyimpan elemen untuk tiap opsi, sebuah helper menyembunyikannya saat dibuat, dan callback hanya menampilkan elemen opsi yang dipilih.

```lua
local UpgradeTab = Window:Tab({ Title = "Upgrade System", Icon = "hammer" })

-- Simpan elemen per opsi agar bisa ditampilkan/disembunyikan
local Categories = { Yen = {}, Token = {}, Rank = {} }

-- Temukan frame utama sebuah elemen (bekerja untuk berbagai jenis elemen)
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
end

-- Daftarkan elemen ke sebuah kategori dan sembunyikan secara default
local function AddElement(category, element)
    table.insert(Categories[category], element)
    local frame = GetElementFrame(element)
    if frame then frame.Visible = false end
    return element
end

-- Tampilkan hanya elemen dari kategori yang dipilih
local function OnCategoryChanged(selected)
    for name, elements in pairs(Categories) do
        for _, elem in ipairs(elements) do
            local frame = GetElementFrame(elem)
            if frame then frame.Visible = (name == selected) end
        end
    end
end

UpgradeTab:Category({
    Title = "Select Category",
    Default = "Yen",
    Options = {
        { Title = "Yen",   Icon = "coins" },
        { Title = "Token", Icon = "layers" },
        { Title = "Rank",  Icon = "shield" },
    },
    Callback = OnCategoryChanged,
})

UpgradeTab:Space({ Columns = 1 })

-- Bangun dan daftarkan elemen tiap kategori
AddElement("Yen", UpgradeTab:Paragraph({ Title = "Yen Upgrades", Desc = "Upgrade stats using Yen" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" }))
AddElement("Yen", UpgradeTab:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" }))

AddElement("Token", UpgradeTab:Paragraph({ Title = "Token Upgrades", Desc = "Special upgrades using Tokens" }))
AddElement("Token", UpgradeTab:Toggle({ Title = "Yen Multiplier", Desc = "Cost: 5 Tokens | x1.5 Yen" }))

AddElement("Rank", UpgradeTab:Paragraph({ Title = "Rank Information", Desc = "Current Rank: S-Class" }))
AddElement("Rank", UpgradeTab:Button({ Title = "Rank Up", Icon = "arrow-up-circle" }))

-- Tampilkan kategori default sekali saat load
OnCategoryChanged("Yen")
```

Untuk panduan lebih lengkap tentang teknik ini, lihat [resep halaman Category](/id/examples/category-pages).
