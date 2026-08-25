# Dialogs & Popups

ANUI punya dua cara menampilkan prompt modal: **`Window:Dialog{}`**, yang menempel pada window yang sudah ada, dan **`ANUI:Popup{}`**, modal mandiri yang bisa dibuka dari mana saja. Keduanya menampilkan judul, isi, dan sederet tombol.

## Dialog vs Popup

| | `Window:Dialog{}` | `ANUI:Popup{}` |
| --- | --- | --- |
| Penempelan | Dirender di dalam window yang sudah ada | Mandiri, modal tingkat layar |
| Butuh window | Ya — dipanggil pada `Window` | Tidak — dipanggil langsung pada `ANUI` |
| Kontrol lebar | `Width` (default `320`) | — |
| Gambar thumbnail | — | `Thumbnail` |
| Objek yang dikembalikan | — | Tanpa method; tombol menutupnya |
| Paling cocok untuk | Konfirmasi yang terkait menu yang sudah Anda buat | Prompt cepat sebelum/tanpa window penuh |

## `Window:Dialog{}`

Membuka dialog modal yang menempel pada window. Gunakan untuk konfirmasi dan pilihan kecil di dalam menu Anda.

### Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | — | Judul dialog. |
| `Content` | `string` | — | Teks isi di bawah judul. |
| `Icon` | `string` | — | Ikon di depan: nama ikon Lucide atau `rbxassetid://…`. |
| `Width` | `number` | `320` | Lebar dialog dalam piksel. |
| `Buttons` | `table` | — | Array spesifikasi tombol (lihat di bawah). |

Setiap entri dalam `Buttons` adalah sebuah tabel:

| Field | Type | Deskripsi |
| --- | --- | --- |
| `Title` | `string` | Label tombol. |
| `Icon` | `string` | Ikon opsional pada tombol. |
| `Callback` | `function` | Dijalankan saat tombol diklik. **Tidak menerima argumen.** |
| `Variant` | `string` | Gaya visual: `"Primary"`, `"Secondary"`, atau `"White"`. |

```lua
Window:Dialog({
    Title = "Delete save?",
    Content = "This cannot be undone.",
    Buttons = {
        { Title = "Delete", Variant = "Primary", Icon = "trash", Callback = function()
            print("deleted")
        end },
    },
})
```

## `ANUI:Popup{}`

Membuka modal mandiri seketika, tanpa perlu window. Tombolnya menutup popup saat diklik, dan objek yang dikembalikan tidak punya method apa pun.

### Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `"Dialog"` | Judul popup. |
| `Content` | `string` | `nil` | Teks isi di bawah judul. |
| `Icon` | `string` | `nil` | Ikon di depan: nama ikon Lucide atau `rbxassetid://…`. |
| `IconThemed` | `boolean` | — | Mewarnai ikon dengan warna ikon tema. |
| `Thumbnail` | `table` | — | Gambar preview besar: `{ Image, Title? }`. |
| `Buttons` | `table` | — | Array spesifikasi tombol (bentuk sama seperti Dialog). |

Setiap entri dalam `Buttons` adalah sebuah tabel:

| Field | Type | Deskripsi |
| --- | --- | --- |
| `Title` | `string` | Label tombol. |
| `Icon` | `string` | Ikon opsional pada tombol. |
| `Callback` | `function` | Dijalankan saat diklik, lalu popup menutup. **Tidak menerima argumen.** |
| `Variant` | `string` | Gaya visual: `"Primary"`, `"Secondary"`, atau `"White"`. |

::: info Popup langsung terbuka
`ANUI:Popup{}` menampilkan modal segera setelah dipanggil. Tidak ada yang perlu di-`:Open()` — dan tidak ada method pada objek yang dikembalikan, karena tombolnya sudah menutupnya untuk Anda.
:::

## Contoh

### Varian tombol (Dialog)

Ketiga varian tombol — `Primary`, `Secondary`, dan `White` — dalam satu dialog.

```lua
Window:Dialog({
    Title = "UI Button Variants",
    Content = "Demonstrates the Button variants.",
    Buttons = {
        { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
        { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
        { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
    },
})
```

### Dialog konfirmasi (Cancel / Confirm)

```lua
Window:Dialog({
    Title = "Reset settings?",
    Content = "All options will return to their defaults.",
    Icon = "rotate-ccw",
    Width = 340,
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function()
            print("cancelled")
        end },
        { Title = "Confirm", Variant = "Primary", Icon = "check", Callback = function()
            print("confirmed")
        end },
    },
})
```

### Popup sederhana

```lua
ANUI:Popup({
    Title = "Welcome",
    Content = "Thanks for trying the script. Join our community for updates.",
    Icon = "hand",
    Thumbnail = {
        Image = "rbxassetid://84366761557806",
        Title = "ANHub",
    },
    Buttons = {
        { Title = "Copy Discord", Variant = "Primary", Icon = "link", Callback = function()
            setclipboard("https://discord.gg/bUkCZvmrpH")
        end },
        { Title = "Close", Variant = "Secondary", Callback = function() end },
    },
})
```
