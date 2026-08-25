# Tombol Buka

Tombol buka adalah pil melayang yang membuka kembali UI Anda setelah ditutup. Konfigurasikan saat membuat window, atau ubah kemudian saat runtime.

## Konfigurasi saat pembuatan

Berikan tabel `OpenButton` ke `CreateWindow`.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | — | Teks yang ditampilkan pada tombol. |
| `Icon` | `string` | — | Nama ikon atau `rbxassetid://…` yang tampil sebelum judul. |
| `Enabled` | `boolean` | — | Atur `false` untuk menonaktifkan tombol buka sepenuhnya. |
| `Position` | `UDim2` | — | Posisi tombol di layar. |
| `OnlyIcon` | `boolean` | `false` | Tombol bulat khusus ikon (gaya Delta); menyembunyikan judul dan pegangan geser. |
| `Draggable` | `boolean` | — | Izinkan pengguna menggeser tombol ke mana saja. |
| `OnlyMobile` | `boolean` | — | Biarkan tidak diatur untuk mobile-saja; atur `false` agar tampil di desktop juga. |
| `CornerRadius` | `UDim` | `UDim.new(1, 0)` | Radius sudut tombol (default membulat penuh). |
| `StrokeThickness` | `number` | `2` | Ketebalan garis tepi tombol. |
| `Color` | `ColorSequence` | `#40c9ff → #e81cff` | Gradient untuk garis tepi (stroke) tombol. |
| `Size` | `UDim2` | auto | Ukuran tombol. Secara default menyesuaikan otomatis dengan isinya. |

::: info Default OnlyMobile
Jika Anda tidak mengatur `OnlyMobile`, tombol berperilaku **mobile-saja**. Atur `OnlyMobile = false` agar tampil di desktop juga — seperti pada contoh di atas.
:::

::: tip Color adalah gradient
`Color` menerima `ColorSequence`, bukan `Color3` — nilai ini diterapkan sebagai gradient pada garis tepi tombol. Buat satu dengan `ColorSequence.new(colorA, colorB)`.
:::

## Edit saat runtime

### `Window:EditOpenButton(config)`

Menerapkan perubahan pada tombol buka. Perubahan **digabungkan secara kumulatif** — field yang tidak Anda berikan tetap memakai nilai saat ini.

```lua
Window:EditOpenButton({
    Title = "Open Menu",
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromHex("#40c9ff"), Color3.fromHex("#e81cff")),
})
```

## Method open button

Objek tombol buka tersedia sebagai `Window.OpenButtonMain`.

### `Window.OpenButtonMain:SetIcon(icon)`

Mengganti ikon tombol (nama ikon atau `rbxassetid://…`).

```lua
Window.OpenButtonMain:SetIcon("menu")
```

### `Window.OpenButtonMain:Visible(visible)`

Menampilkan atau menyembunyikan tombol.

```lua
Window.OpenButtonMain:Visible(false) -- sembunyikan
Window.OpenButtonMain:Visible(true)  -- tampilkan
```

### `Window.OpenButtonMain:Edit(config)`

Sama seperti `Window:EditOpenButton` — menggabungkan config yang diberikan ke config saat ini. Gunakan mana pun yang lebih enak dibaca di kode Anda.

```lua
Window.OpenButtonMain:Edit({ Title = "Reopen" })
```

## Contoh

Diadaptasi dari skrip contoh: pil membulat yang bisa digeser dengan judul kustom dan garis tepi bergradasi hijau-ke-kuning, tampil di desktop maupun mobile.

```lua
local Window = ANUI:CreateWindow({
    Title = ".an hub | ANUI Library",
    OpenButton = {
        Title = ".an UI",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
    },
})
```

Lihat [Konfigurasi Window](/id/guide/window-configuration) untuk opsi window selengkapnya.
