# Dropdown

Daftar yang bisa dipilih dengan dukungan pilihan tunggal atau ganda, ikon per-item, deskripsi, divider, dan gambar. Tanpa callback global, ia juga berfungsi sebagai **menu aksi**.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Dropdown({
    Title = "Basic",
    Values = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Value = "Option 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dropdown"` | Label utama. Mendukung [token rich-text](/id/elements/#rich-text-di-title-desc). |
| `Desc` | `string` | `nil` | Deskripsi opsional di bawah judul. |
| `Values` | `table` | `{}` | Daftar opsi — string atau objek item (lihat di bawah). `{ Type = "Divider" }` menyisipkan divider. |
| `Value` | `string` \| `table` | `nil` | Pilihan awal: string, objek item, atau array (untuk `Multi`). |
| `Multi` | `boolean` | `false` | Mengizinkan pemilihan lebih dari satu item. |
| `AllowNone` | `boolean` | `false` | Mengizinkan pembatalan item terakhir yang tersisa (paling berguna dengan `Multi`). |
| `SearchBarEnabled` | `boolean` | `false` | Menampilkan search bar di atas menu. |
| `MenuWidth` | `number` | `nil` | Lebar menu tetap dalam piksel. Kosongkan untuk auto-fit. |
| `Locked` | `boolean` | `false` | Menampilkan overlay kunci dan memblokir interaksi. |
| `Image` | `string` \| `table` | `nil` | Gambar rata kiri pada baris dropdown. |
| `ImageSize` | `number` \| `UDim2` | `30` | Ukuran gambar — sebuah angka, atau `UDim2` untuk card gambar. |
| `ImagePadding` | `number` | `—` | Jarak di sekitar gambar item. |
| `IconThemed` | `boolean` | `false` | Mewarnai ikon dengan warna tema saat ini. |
| `Color` | `Color3` \| `string` | `nil` | Latar berwarna (nama tema atau `Color3`). |
| `Callback` | `function` | `nil` | Dijalankan saat memilih. Lihat catatan tanda tangan di bawah. |
| `Flag` | `string` | `nil` | Key persistensi konfigurasi. Lihat [Konfigurasi & Flag](/id/features/config-and-flags). |
| `Buttons` | `table` | `nil` | Tombol inline yang dirender di baris. |
| `TitleGradient` | `table` | `nil` | Gradient yang diterapkan pada teks judul. |
| `DescGradient` | `table` | `nil` | Gradient yang diterapkan pada teks deskripsi. |

### Objek item

Alih-alih string biasa, setiap entri di `Values` bisa berupa tabel:

| Field | Type | Deskripsi |
| --- | --- | --- |
| `Title` | `string` | Label item. |
| `Desc` | `string` | Deskripsi opsional yang tampil di bawah judul. |
| `Icon` | `string` | Ikon opsional untuk item. |
| `Images` | `table` | Array id gambar / nama ikon, atau tabel card (`{ Card = true, Title, Quantity, Image, Gradient }`). |
| `Locked` | `boolean` | Menonaktifkan pemilihan item tertentu ini. |
| `Callback` | `function` | Aksi per-item, dipakai dalam **mode menu** (lihat di bawah). |
| `Type` | `string` | Set ke `"Divider"` (tanpa field lain) untuk menyisipkan divider antar item. |

::: info Tanda tangan callback — dan mode menu
- **Single-select:** callback menerima **nilai** yang dipilih — sebuah `string` untuk item string, atau **objek item asli** untuk item objek (baca `option.Title`, dst.).
- **Multi-select** (`Multi = true`): callback menerima sebuah **array** berisi item yang dipilih.
- **Tanpa `Callback` global:** dropdown menjadi **menu aksi** — mengklik item menjalankan `Callback` *milik item tersebut*.
:::

Dropdown juga mewarisi konfigurasi dan method [base bersama](/id/elements/#base-bersama).

## Method

### `Dropdown:Select(items)`

Mengatur pilihan saat ini lewat kode. Berikan satu nilai, atau sebuah array ketika `Multi` aktif.

```lua
myDropdown:Select("Blue")
myDropdown:Select({ "A", "C" }) -- multi
```

### `Dropdown:Refresh(values)`

Mengganti seluruh daftar opsi dengan array `values` baru.

```lua
myDropdown:Refresh({ "New 1", "New 2", "New 3" })
```

### `Dropdown:Edit(itemName, newData)`

Memperbarui item yang ada, dicari berdasarkan namanya, dengan field di `newData`.

```lua
myDropdown:Edit("Option 1", { Title = "Option 1 (updated)", Icon = "check" })
```

### `Dropdown:EditDrop(target, newData)`

Mengedit container dropdown itu sendiri, menerapkan `newData` ke `target` yang diberikan.

### `Dropdown:SetValueImage(img)` / `Dropdown:SetValueIcon(img)`

Mengatur gambar atau ikon yang tampil di samping nilai yang sedang dipilih.

### `Dropdown:SetMainImage(img, size)`

Memperbarui gambar rata kiri dropdown beserta ukurannya.

### `Dropdown:Open()` / `Dropdown:Close()`

Membuka atau menutup menu. `Open()` bersifat toggle — memanggilnya saat terbuka akan menutup menu.

### `Dropdown:Display()`

Menyegarkan nilai yang ditampilkan (teks, ikon, dan gambar) untuk pilihan saat ini.

### `Dropdown:Lock(text?)` / `Dropdown:Unlock()`

Mengunci atau membuka kunci dropdown. Argumen `text` opsional mengatur label overlay.

## Contoh

### Daftar string dasar

```lua
myTab:Dropdown({
    Title = "Basic",
    Desc = "Simple list of string values with a global selection callback.",
    Values = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Value = "Option 1",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

### Dengan ikon (item objek)

Untuk item objek, callback menerima **objek item** — baca `option.Title`.

```lua
myTab:Dropdown({
    Title = "With Icons",
    Desc = "Each option is an object containing a title and an icon.",
    Values = {
        { Title = "Bird",     Icon = "bird" },
        { Title = "House",    Icon = "house" },
        { Title = "Settings", Icon = "settings" },
        { Title = "Trash",    Icon = "trash-2" },
    },
    Value = { Title = "Bird", Icon = "bird" },
    Callback = function(option)
        print("Selected:", option.Title)
    end
})
```

### Dengan deskripsi

```lua
myTab:Dropdown({
    Title = "With Descriptions",
    Values = {
        { Title = "Option A", Desc = "This is option A" },
        { Title = "Option B", Desc = "This is option B" },
        { Title = "Option C", Desc = "This is option C" },
    },
    Value = { Title = "Option A", Desc = "This is option A" },
    Callback = function(option) print(option.Title) end
})
```

### Multi-select

Dengan `Multi = true`, callback menerima **array** berisi item yang dipilih.

```lua
myTab:Dropdown({
    Title = "Multi-Select",
    Desc = "Select multiple options (callback returns an array of selected items).",
    Values = {
        { Title = "Category A", Icon = "folder" },
        { Title = "Category B", Icon = "folder" },
        { Title = "Category C", Icon = "folder" },
        { Title = "Category D", Icon = "folder" },
    },
    Multi = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do
            table.insert(titles, v.Title)
        end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### Pengelompokan divider

```lua
myTab:Dropdown({
    Title = "Divider Grouping",
    Desc = "Use Type = 'Divider' to split options into visually separated groups.",
    Values = {
        { Title = "Group 1 - A", Icon = "star" },
        { Title = "Group 1 - B", Icon = "star" },
        { Type = "Divider" },
        { Title = "Group 2 - A", Icon = "heart" },
        { Title = "Group 2 - B", Icon = "heart" },
    },
    Value = { Title = "Group 1 - A", Icon = "star" },
    Callback = function(option) print(option.Title) end
})
```

### Allow none (multi)

`AllowNone` memungkinkan multi-select turun kembali ke nol item terpilih.

```lua
myTab:Dropdown({
    Title = "Multi (AllowNone)",
    Desc = "Multi-select with AllowNone lets you deselect the last remaining item.",
    Values = { { Title = "A" }, { Title = "B" }, { Title = "C" } },
    Value = "B",
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        local titles = {}
        for _, v in ipairs(values) do table.insert(titles, v.Title) end
        print("Selected:", table.concat(titles, ", "))
    end
})
```

### Item terkunci

```lua
myTab:Dropdown({
    Title = "Locked Items",
    Desc = "Per-item locking disables selection for specific options.",
    Values = {
        { Title = "Usable A" },
        { Title = "Locked B", Locked = true },
        { Title = "Usable C" },
    },
    Value = "Usable A",
    Callback = function(value)
        print("Selected:", typeof(value) == "table" and value.Title or value)
    end
})
```

### Lebar kustom dan search bar

```lua
myTab:Dropdown({
    Title = "Custom Width",
    Desc = "Manually define menu width instead of using auto-fit.",
    Values = { "Short", "Medium Option", "Veryyyyyyyy Long Option Name" },
    Value = "Short",
    MenuWidth = 250,
    SearchBarEnabled = true,
    Callback = function(value) print(value) end
})
```

### Pemilihan lewat kode

```lua
local colors = myTab:Dropdown({
    Title = "Programmatic Select",
    Values = { "Red", "Green", "Blue" },
    Value = "Red",
    Callback = function(value) print("Selected:", value) end
})

myTab:Button({
    Title = "Select 'Blue' via code",
    Callback = function()
        colors:Select("Blue")
    end
})
```

### Menu aksi (callback per-item)

Hilangkan `Callback` global sepenuhnya dan beri tiap item `Callback`-nya sendiri — dropdown akan berperilaku seperti menu aksi klik-kanan.

```lua
myTab:Dropdown({
    Title = "Advanced Actions",
    Desc = "No global callback: items behave like an action menu using per-item callbacks.",
    Values = {
        { Title = "New file",  Desc = "Create a new file",   Icon = "file-plus", Callback = function() print("New file") end },
        { Title = "Copy link", Desc = "Copy the file link",  Icon = "copy",      Callback = function() print("Copy link") end },
        { Type = "Divider" },
        { Title = "Delete file", Desc = "Permanently delete the file", Icon = "trash", Callback = function() print("Delete file") end },
    }
})
```

::: tip Menyimpan pilihan
Tambahkan `Flag` untuk menyimpan dan memulihkan nilai terpilih antar sesi. Lihat [Konfigurasi & Flag](/id/features/config-and-flags).
:::
