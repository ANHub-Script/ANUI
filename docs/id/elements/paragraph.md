# Paragraph

Blok teks kaya untuk heading, catatan, dan deskripsi. Dibangun di atas [base bersama](/id/elements/#base-bersama) dengan hover dinonaktifkan, sehingga tampil sebagai konten statis — dan ia juga berfungsi sebagai container ringan yang bisa Anda pasangi elemen anak.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Paragraph({
    Title = "Toggle Examples",
    Desc = "This tab showcases all supported Toggle features: classic toggle, checkbox variant, per-item icons, default values, locking, and programmatic updates."
})
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `"Paragraph"` | Teks heading. Mendukung [token rich-text](/id/elements/#rich-text-di-title-desc). |
| `Desc` | `string` | `nil` | Teks isi. Mendukung token rich-text dan multi-baris lewat `\n`. |
| `Locked` | `boolean` | `false` | Menampilkan overlay kunci. |
| `Images` | `table` | `nil` | Array objek card yang dirender sebagai grid card gambar (lihat di bawah). |
| `ImageSize` | `UDim2` | `UDim2.fromOffset(70, 70)` | Ukuran tiap card gambar. |
| `Buttons` | `table` | `nil` | Array `{ Title, Icon, Callback }` yang dirender sebagai **tombol bertumpuk selebar penuh** di bawah teks. |

### Objek card gambar

Setiap entri di `Images` adalah sebuah tabel:

| Field | Type | Deskripsi |
| --- | --- | --- |
| `Title` | `string` | Label card. |
| `Quantity` | `string` | Badge jumlah/hitungan (mis. `"244x"`). |
| `Image` | `string` | Asset id (`rbxassetid://…`) atau nama ikon. |
| `Gradient` | `ColorSequence` | Gradient latar untuk card. |
| `Callback` | `function` | Dijalankan saat card diklik. |

::: info Dua jenis `Buttons`
Konfigurasi `Buttons` di sini merender tombol **bertumpuk selebar penuh** di bawah teks paragraf (masing-masing `{ Title, Icon, Callback }`). Ini berbeda dari **map** inline `Buttons` base bersama yang dirender elemen lain di dalam barisnya.
:::

Paragraph mewarisi `Image`, gradient, token rich-text, lock, dan highlight dari [base bersama](/id/elements/#base-bersama). Hover selalu dinonaktifkan.

## Method

### `Paragraph:SetTitle(text)` / `Paragraph:SetDesc(text)`

Memperbarui field `Title` / `Desc` yang tersimpan pada paragraf.

```lua
myParagraph:SetTitle("Updated heading")
myParagraph:SetDesc("Updated body text.")
```

::: details Memperbarui teks yang terlihat
`:SetTitle` / `:SetDesc` memperbarui field Lua pada elemen. Untuk mengubah teks yang sudah tampil di layar, gunakan setter milik ParagraphFrame yang mendasarinya.
:::

### `Paragraph:SetViewport(model, cameraOffset?)`

Merender sebuah `ViewportFrame` 95×95 yang menampilkan pratinjau 3D dari `model`, dengan `cameraOffset` opsional.

```lua
myParagraph:SetViewport(workspace.SomeModel)
```

## Contoh

### Deskripsi multi-baris

Gunakan `\n` untuk memecah deskripsi menjadi beberapa baris.

```lua
myTab:Paragraph({
    Title = "Rank Information",
    Desc = "Current Rank: S-Class\nPower: 500,000"
})
```

### Sebagai container ringan

Objek Paragraph menyediakan method pembuatan elemen yang sama seperti Tab, jadi Anda bisa memasang anak langsung padanya — praktis untuk mengelompokkan kontrol di bawah sebuah heading.

```lua
local group = myTab:Paragraph({
    Title = "Yen Upgrades",
    Desc = "Upgrade stats using Yen currency"
})

group:Toggle({ Title = "Luck Upgrade [0/20]", Desc = "Cost: 100 Yen | +5% Luck" })
group:Toggle({ Title = "Damage Upgrade [0/50]", Desc = "Cost: 250 Yen | +10 Damage" })
group:Button({ Title = "Rank Up", Icon = "arrow-up-circle" })
```

### Grid card gambar

```lua
myTab:Paragraph({
    Title = "Inventory",
    ImageSize = UDim2.fromOffset(70, 70),
    Images = {
        {
            Title = "World Box",
            Quantity = "244x",
            Image = "rbxassetid://84366761557806",
            Gradient = ColorSequence.new(Color3.fromHex("#C042FF"), Color3.fromHex("#8E24AA")),
            Callback = function() print("World Box") end
        },
        {
            Title = "Zone Key",
            Quantity = "3x",
            Image = "key",
            Gradient = ColorSequence.new(Color3.fromHex("#29B6F6"), Color3.fromHex("#0288D1")),
            Callback = function() print("Zone Key") end
        },
    }
})
```

### Tombol bertumpuk

```lua
myTab:Paragraph({
    Title = "ANHUB Discord",
    Desc = "Members: 1,234\nOnline: 567",
    Buttons = {
        {
            Title = "Copy link",
            Icon = "link",
            Callback = function()
                setclipboard("https://discord.gg/qN47S3mKZA")
            end
        }
    }
})
```
