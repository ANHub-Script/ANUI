# Colorpicker

Memilih sebuah `Color3` — dengan transparansi opsional — melalui dialog picker yang lengkap. Callback berjalan dengan warna yang dipilih ketika pengguna menerapkannya.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Colorpicker({
    Title = "Colorpicker",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(color, transparency)
        print("Color:", color, "Transparency:", transparency)
    end
})
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `"Colorpicker"` | Label utama. Mendukung [token rich-text](/id/elements/#rich-text-di-title-desc). |
| `Desc` | `string` | `nil` | Deskripsi opsional di bawah judul. |
| `Locked` | `boolean` | `false` | Menampilkan overlay kunci dan memblokir interaksi. |
| `Default` | `Color3` | `Color3.new(1, 1, 1)` (putih) | Warna awal yang ditampilkan di swatch. |
| `Transparency` | `number` | `nil` | Alpha awal. Memberikan angka apa pun akan mengaktifkan slider dan input alpha di picker. |
| `Callback` | `function` | `nil` | Dijalankan saat **Apply**. **Menerima `(color: Color3, transparency: number)`.** |
| `Buttons` | `table` | `nil` | Tombol inline yang dirender di baris. |
| `TitleGradient` | `table` | `nil` | Gradient yang diterapkan pada teks judul. |
| `DescGradient` | `table` | `nil` | Gradient yang diterapkan pada teks deskripsi. |
| `Flag` | `string` | `nil` | Key persistensi konfigurasi. Lihat [Konfigurasi & Flag](/id/features/config-and-flags). |

::: info Dialog picker
Mengklik swatch membuka dialog dengan:
- peta **Saturation/Vibrance** dan slider **Hue**,
- slider **alpha** opsional (hanya tampil saat `Transparency` diatur),
- input **Hex** (`#RRGGBB`) plus input **R / G / B** — dan input **Alpha** saat transparansi diaktifkan,
- tombol **Cancel** dan **Apply** — `Callback` berjalan saat **Apply**.

Ketika disimpan ke sebuah konfigurasi, colorpicker menyerialisasi nilai hex-nya beserta transparansinya.
:::

Colorpicker juga mewarisi konfigurasi dan method [base bersama](/id/elements/#base-bersama).

## Method

### `Colorpicker:Update(color, transparency?)`

Mengatur warna saat ini (dan transparansi opsional), memperbarui swatch.

```lua
myColorpicker:Update(Color3.fromRGB(255, 0, 0))
myColorpicker:Update(Color3.fromRGB(255, 0, 0), 0.5)
```

### `Colorpicker:Set(color, transparency?)`

Alias untuk `:Update` — argumen dan perilaku sama.

```lua
myColorpicker:Set(Color3.fromHex("#305dff"))
```

### `Colorpicker:Lock()` / `Colorpicker:Unlock()`

Mengunci atau membuka kunci colorpicker. Colorpicker yang terkunci menampilkan overlay dan tidak bisa dibuka.

```lua
myColorpicker:Lock()
myColorpicker:Unlock()
```

### Method base

Colorpicker juga mendukung `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons`, dan `:Destroy` dari [base bersama](/id/elements/#method-umum).

## Contoh

### Dengan transparansi dan Flag

Mengatur `Transparency` (bahkan ke `0`) mengaktifkan kontrol alpha di dialog. Callback kemudian menerima warna sekaligus transparansi.

```lua
myTab:Colorpicker({
    Flag = "ColorpickerTest",
    Title = "Colorpicker",
    Desc = "Colorpicker Description",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color, transparency)
        print("Background color:", color, transparency)
    end
})
```

Warna dan transparansinya disimpan dan dipulihkan otomatis begitu sebuah konfigurasi aktif — lihat [Konfigurasi & Flag](/id/features/config-and-flags).
