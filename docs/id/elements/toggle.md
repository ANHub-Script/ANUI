# Toggle

Sakelar on/off yang melaporkan sebuah boolean ke callback-nya. Toggle dirender sebagai slider beranimasi secara default, atau sebagai checkbox lewat `Type = "Checkbox"`.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `"Toggle"` | Label utama. Mendukung [token rich-text](/id/elements/#rich-text-di-title-desc). |
| `Desc` | `string` | `nil` | Deskripsi opsional di bawah judul. |
| `Value` | `boolean` | `false` | State awal. |
| `Type` | `string` | `"Toggle"` | `"Toggle"` (slider beranimasi) atau `"Checkbox"`. |
| `Icon` | `string` | `nil` | Ikon yang ditampilkan di dalam knob slider. |
| `IconSize` | `number` | `23` | Ukuran ikon knob, dalam piksel. |
| `Image` | `string` \| `table` | `nil` | Gambar rata kiri (asset id atau tabel card). |
| `ImageSize` | `number` | `30` | Ukuran gambar kiri, dalam piksel. |
| `Thumbnail` | `string` | `nil` | Gambar thumbnail besar. |
| `ThumbnailSize` | `number` | `80` | Ukuran thumbnail, dalam piksel. |
| `Locked` | `boolean` | `false` | Overlay kunci; memblokir interaksi **dan** menonaktifkan callback. |
| `Disabled` | `boolean` | `false` | Hanya memblokir interaksi pengguna (callback tetap bisa dipicu dari kode). |
| `Callback` | `function` | `nil` | Dijalankan saat berubah. **Menerima nilai boolean baru.** |
| `Flag` | `string` | `nil` | Key persistensi konfigurasi. Lihat [Konfigurasi & Flag](/id/features/config-and-flags). |
| `Buttons` | `table` | `nil` | Tombol inline yang dirender di baris. |
| `TitleGradient` | `table` | `nil` | Gradient yang diterapkan pada teks judul. |
| `DescGradient` | `table` | `nil` | Gradient yang diterapkan pada teks deskripsi. |

::: info Locked vs Disabled
`Locked` menampilkan overlay kunci, memblokir interaksi pengguna, **dan** mencegah callback berjalan. `Disabled` hanya memblokir interaksi *pengguna* — Anda tetap bisa mengubah nilainya dari kode dengan `:Set(...)`, dan callback tetap berjalan. Gunakan `:Lock()`/`:Unlock()` dan `:Disable()`/`:Enable()` untuk mengganti state ini saat runtime.
:::

Toggle juga mewarisi konfigurasi dan method [base bersama](/id/elements/#base-bersama).

## Method

### `Toggle:Set(value, isCallback?, isAnimated?, force?)`

Mengatur state toggle lewat kode.

- `value` (`boolean`) — state baru.
- `isCallback` (`boolean`, opsional) — jalankan `Callback` untuk perubahan ini.
- `isAnimated` (`boolean`, opsional) — animasikan transisi knob.
- `force` (`boolean`, opsional) — paksa perubahan diterapkan.

```lua
myToggle:Set(true, true)          -- nyalakan dan jalankan callback
myToggle:Set(false, false, false) -- matikan tanpa suara, tanpa animasi
```

### `Toggle:Lock(text?)` / `Toggle:Unlock()`

Mengunci atau membuka kunci toggle. Argumen `text` opsional mengatur label overlay.

```lua
myToggle:Lock("Premium only")
myToggle:Unlock()
```

### `Toggle:Disable()` / `Toggle:Enable()`

Menonaktifkan atau mengaktifkan kembali interaksi *pengguna* tanpa overlay kunci. Berbeda dengan `Lock`, callback tetap berjalan ketika Anda mengatur nilainya dari kode.

### `Toggle:SetMainImage(image, size)`

Memperbarui gambar rata kiri beserta ukurannya.

```lua
myToggle:SetMainImage("rbxassetid://84366761557806", 24)
```

### Method base

Toggle juga mendukung `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons`, dan `:Destroy` dari [base bersama](/id/elements/#method-umum).

## Contoh

### Dasar dan dengan deskripsi

```lua
myTab:Toggle({
    Title = "Basic Toggle",
    Desc = "Standard toggle with animated slider (drag or click).",
    Callback = function(v)
        print("Basic Toggle:", v)
    end
})
```

### Dengan gambar kiri

```lua
myTab:Toggle({
    Title = "Toggle with Left Image",
    Desc = "Image on the left, centered between title and desc.",
    Image = "rbxassetid://84366761557806",
    ImageSize = 24,
    Callback = function(v) print(v) end
})
```

### Dengan ikon knob dan default-on

```lua
myTab:Toggle({
    Title = "Toggle with Icon",
    Desc = "Shows an icon inside the slider when toggled.",
    Icon = "mouse",
    IconSize = 15,
    Value = true,
    Callback = function(v) print(v) end
})
```

### Varian checkbox

```lua
myTab:Toggle({
    Title = "Checkbox",
    Desc = "Checkbox variant of toggle.",
    Type = "Checkbox",
    Callback = function(v) print(v) end
})

myTab:Toggle({
    Title = "Checkbox (Default ON)",
    Type = "Checkbox",
    Value = true,
    Callback = function(v) print(v) end
})
```

### Terkunci

```lua
myTab:Toggle({
    Title = "Locked Toggle",
    Desc = "Locked state prevents user interaction.",
    Locked = true,
    Callback = function(v) print(v) end
})
```

### Pembaruan lewat kode

```lua
local progToggle = myTab:Toggle({
    Title = "Programmatic Toggle",
    Desc = "Demonstrates using Set() and updating title/desc via code.",
    Value = false,
    Callback = function(v) print("Programmatic Toggle:", v) end
})

myTab:Button({
    Title = "Turn ON",
    Callback = function()
        progToggle:Set(true, true)
        progToggle:SetTitle("Programmatic Toggle (ON)")
        progToggle:SetDesc("Toggled on by code.")
    end
})

myTab:Button({
    Title = "Turn OFF (no animation)",
    Callback = function()
        progToggle:Set(false, true, false)
        progToggle:SetTitle("Programmatic Toggle (OFF)")
        progToggle:SetDesc("Toggled off by code without animation.")
    end
})
```

### Persistensi dengan Flag

```lua
myTab:Toggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Callback = function(v) print(v) end
})
```

Nilainya disimpan dan dipulihkan otomatis begitu sebuah konfigurasi aktif — lihat [Konfigurasi & Flag](/id/features/config-and-flags).
