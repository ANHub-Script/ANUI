# Input

Field teks untuk menangkap masukan string — satu baris (`"Input"`) atau banyak baris (`"Textarea"`). Callback-nya menerima teks saat ini setiap kali field di-commit.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Input({
    Title = "Input",
    InputIcon = "mouse",
    Placeholder = "Enter Text...",
    Callback = function(text)
        print("Text:", text)
    end
})
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `"Input"` | Label utama. Mendukung [token rich-text](/id/elements/#rich-text-di-title-desc). |
| `Desc` | `string` | `nil` | Deskripsi opsional di bawah judul. |
| `Type` | `string` | `"Input"` | `"Input"` (satu baris) atau `"Textarea"` (banyak baris). |
| `Locked` | `boolean` | `false` | Menampilkan overlay kunci dan memblokir interaksi. |
| `InputIcon` | `string` \| `boolean` | `false` | Ikon yang ditampilkan di dalam kotak input. `false` untuk tanpa ikon. |
| `Placeholder` | `string` | `"Enter Text..."` | Petunjuk abu-abu yang tampil saat field kosong. |
| `Value` | `string` | `""` | Teks awal. |
| `ClearTextOnFocus` | `boolean` | `false` | Otomatis mengosongkan field saat mendapat fokus. |
| `Callback` | `function` | `nil` | Dijalankan saat commit. **Menerima teks saat ini sebagai string.** |
| `Buttons` | `table` | `nil` | Tombol inline yang dirender di baris. |
| `TitleGradient` | `table` | `nil` | Gradient yang diterapkan pada teks judul. |
| `DescGradient` | `table` | `nil` | Gradient yang diterapkan pada teks deskripsi. |
| `Flag` | `string` | `nil` | Key persistensi konfigurasi. Lihat [Konfigurasi & Flag](/id/features/config-and-flags). |

::: info Tanda tangan callback
`Callback` menerima satu **string** — teks field saat ini. Callback berjalan ketika field di-commit (fokus hilang, atau Enter ditekan untuk input satu baris) dan **sekali saat inisialisasi** dengan `Value` awal.
:::

Input juga mewarisi konfigurasi dan method [base bersama](/id/elements/#base-bersama).

## Method

### `Input:Set(value, isUserInput?)`

Mengatur teks field menjadi `value`. Flag opsional `isUserInput` menandai perubahan sebagai berasal dari pengguna.

```lua
myInput:Set("hello")
```

### `Input:SetPlaceholder(value)`

Memperbarui petunjuk placeholder yang tampil saat field kosong.

```lua
myInput:SetPlaceholder("Type a name...")
```

### `Input:Lock()` / `Input:Unlock()`

Mengunci atau membuka kunci input. Input yang terkunci menampilkan overlay dan mengabaikan ketikan.

```lua
myInput:Lock()
myInput:Unlock()
```

### Method base

Input juga mendukung `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons`, dan `:Destroy` dari [base bersama](/id/elements/#method-umum).

## Contoh

### Dasar dengan ikon

```lua
myTab:Input({
    Title = "Input",
    InputIcon = "mouse"
})
```

### Textarea (banyak baris)

```lua
myTab:Input({
    Title = "Input Textarea",
    Type = "Textarea",
    InputIcon = "mouse"
})
```

### Dengan deskripsi

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example"
})
```

### Terkunci

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example",
    Locked = true
})
```

### Persistensi dengan Flag

```lua
myTab:Input({
    Flag = "InputTest",
    Title = "Input",
    Desc = "Input Description",
    Value = "Default value",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter text...",
    Callback = function(input)
        print("Text entered:", input)
    end
})
```

Nilainya disimpan dan dipulihkan otomatis begitu sebuah konfigurasi aktif — lihat [Konfigurasi & Flag](/id/features/config-and-flags).
