# Keybind

Mengikat aksi ke sebuah tombol keyboard atau tombol mouse. Callback berjalan secara global setiap kali tombol yang diikat ditekan, jadi keybind bekerja di mana saja dalam game — bukan hanya saat window terbuka.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Keybind({
    Title = "Keybind",
    Value = "F",
    Callback = function(key)
        print("Pressed:", key)
    end
})
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `"Keybind"` | Label utama. Mendukung [token rich-text](/id/elements/#rich-text-di-title-desc). |
| `Desc` | `string` | `nil` | Deskripsi opsional di bawah judul. |
| `Locked` | `boolean` | `false` | Menampilkan overlay kunci dan memblokir interaksi. |
| `Value` | `string` | `"F"` | Tombol awal, diberikan sebagai string **nama tombol** (mis. `"F"`, `"G"`). |
| `CanChange` | `boolean` | `true` | Apakah pengguna dapat mengikat ulang tombol dengan mengklik. Efektifnya selalu aktif pada build saat ini. |
| `Callback` | `function` | `nil` | Dijalankan saat tombol yang diikat ditekan. **Menerima nama tombol sebagai string.** |
| `Buttons` | `table` | `nil` | Tombol inline yang dirender di baris. |
| `TitleGradient` | `table` | `nil` | Gradient yang diterapkan pada teks judul. |
| `DescGradient` | `table` | `nil` | Gradient yang diterapkan pada teks deskripsi. |
| `Flag` | `string` | `nil` | Key persistensi konfigurasi. Lihat [Konfigurasi & Flag](/id/features/config-and-flags). |

::: info Cara memicu dan mengikat ulang
- Callback berjalan **secara global** setiap kali tombol yang diikat ditekan — hanya ditahan selama sebuah TextBox sedang fokus, sehingga mengetik tidak memicu keybind.
- Argumen callback adalah string **nama** tombol: `Enum.KeyCode.F` melaporkan `"F"`, dan tombol mouse melaporkan `"MouseLeft"` atau `"MouseRight"`.
- **Untuk mengikat ulang:** klik keybind. Ia menampilkan `...` dan menangkap tombol berikutnya yang Anda tekan.
:::

Keybind juga mewarisi konfigurasi dan method [base bersama](/id/elements/#base-bersama).

## Method

### `Keybind:Set(value)`

Mengatur tombol yang diikat berdasarkan string namanya.

```lua
myKeybind:Set("G")
```

### `Keybind:Lock()` / `Keybind:Unlock()`

Mengunci atau membuka kunci keybind. Keybind yang terkunci menampilkan overlay dan tidak bisa diikat ulang.

```lua
myKeybind:Lock()
myKeybind:Unlock()
```

### Method base

Keybind juga mendukung `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons`, dan `:Destroy` dari [base bersama](/id/elements/#method-umum).

## Contoh

### Mengikat ulang tombol toggle window

Karena callback memberi Anda nama tombol, Anda bisa mengubahnya kembali menjadi `Enum.KeyCode` dengan `Enum.KeyCode[key]` dan langsung memberikannya ke `Window:SetToggleKey`.

```lua
myTab:Keybind({
    Flag = "KeybindTest",
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})
```

::: tip Persistensi ikatan tombol
Tambahkan `Flag` untuk menyimpan dan memulihkan tombol yang diikat antar sesi. Lihat [Konfigurasi & Flag](/id/features/config-and-flags).
:::
