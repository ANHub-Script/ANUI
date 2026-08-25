# Button

Baris aksi yang bisa diklik dengan ikon, warna, dan tombol inline opsional. Button adalah elemen interaktif paling sederhana — ia menjalankan callback saat diklik.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({
    Title = "Click me",
    Callback = function()
        print("Button clicked!")
    end
})
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `"Button"` | Label utama. Mendukung [token rich-text](/id/elements/#rich-text-di-title-desc). |
| `Desc` | `string` | `nil` | Deskripsi opsional di bawah judul. |
| `Icon` | `string` | `"mouse-pointer-click"` | Nama ikon atau `rbxassetid://…`. |
| `IconThemed` | `boolean` | `false` | Mewarnai ikon dengan warna tema saat ini. |
| `Color` | `Color3` \| `string` | `nil` | Latar berwarna (nama tema atau `Color3`); warna teks menyesuaikan otomatis. |
| `Justify` | `string` | `"Between"` | Perataan konten. `"Between"` merenggangkan judul dan ikon; `"Center"` memusatkan keduanya. |
| `IconAlign` | `string` | `"Right"` | Sisi tempat ikon berada: `"Right"` atau `"Left"`. |
| `Locked` | `boolean` | `false` | Menampilkan overlay kunci dan memblokir klik. |
| `Callback` | `function` | `nil` | Dijalankan saat button diklik. **Tidak menerima argumen.** |
| `Buttons` | `table` | `nil` | Tombol inline yang dirender di baris. |
| `TitleGradient` | `table` | `nil` | Gradient yang diterapkan pada teks judul. |
| `DescGradient` | `table` | `nil` | Gradient yang diterapkan pada teks deskripsi. |

::: info Tanda tangan callback
`Callback` sebuah Button **tidak menerima argumen** — ia hanya handler aksi biasa. Jika Anda perlu bereaksi terhadap sebuah nilai, gunakan [Toggle](/id/elements/toggle) atau [Dropdown](/id/elements/dropdown).
:::

Button juga mewarisi konfigurasi [base bersama](/id/elements/#base-bersama) (`Image`, `Thumbnail`, gradient, token rich-text di `Title`/`Desc`, dan sebagainya).

## Method

### `Button:Highlight()`

Mengedipkan button sesaat untuk menarik perhatian pengguna.

```lua
local btn = myTab:Button({ Title = "Notice me", Callback = function() end })
btn:Highlight()
```

### `Button:Lock()` / `Button:Unlock()`

Mengunci atau membuka kunci button. Button yang terkunci menampilkan overlay dan mengabaikan klik.

```lua
btn:Lock()
btn:Unlock()
```

### `Button:SetTitle(text)` / `Button:SetDesc(text)` / `Button:SetIcon(icon)`

Memperbarui judul, deskripsi, atau ikon saat runtime.

```lua
btn:SetTitle("Updated title")
btn:SetDesc("Updated description")
btn:SetIcon("check")
```

### `Button:SetButtons(buttons)` / `Button:GetButton(key)` / `Button:GetButtons()`

Mengelola tombol inline yang dirender di baris. `SetButtons` mengganti map, `GetButton` mengambil satu berdasarkan key, dan `GetButtons` mengembalikan semuanya.

### `Button:Destroy()`

Menghapus button dari containernya.

## Contoh

### Dasar dan berwarna

```lua
myTab:Button({
    Title = "Highlight Button",
    Icon = "mouse",
    Callback = function()
        print("clicked highlight")
    end
})

myTab:Button({
    Title = "Blue Button",
    Desc = "With description",
    Color = Color3.fromHex("#305dff"),
    Icon = "",
    Callback = function() end
})
```

### Perataan ikon dan justifikasi

```lua
myTab:Button({
    Title = "Left Icon",
    Desc = "Icon aligned to the left",
    Icon = "mouse",
    IconAlign = "Left",
    Justify = "Center",
    Callback = function() end
})
```

### Ikon bertema dan berwarna

```lua
myTab:Button({
    Title = "Themed Icon",
    Desc = "Icon follows theme colors",
    Icon = "palette",
    IconThemed = true,
    Callback = function() end
})

myTab:Button({
    Title = "Colored Icon",
    Desc = "Icon tinted with custom color",
    Icon = "mouse-pointer-click",
    Color = Color3.fromHex("#f57c00"),
    Callback = function() end
})
```

### Terkunci

```lua
myTab:Button({
    Title = "Button",
    Desc = "Button example",
    Locked = true
})
```

### Pembaruan lewat kode

Simpan module yang dikembalikan dan perbarui dari button lain. `Highlight()` menarik perhatian ke perubahan tersebut.

```lua
local progBtn = myTab:Button({
    Title = "Programmatic Button",
    Desc = "Will be updated by code",
    Icon = "edit",
    Callback = function() end
})

myTab:Button({
    Title = "Update Above",
    Desc = "SetTitle and SetDesc",
    Icon = "chevron-right",
    Callback = function()
        progBtn:SetTitle("Programmatic Button (Updated)")
        progBtn:SetDesc("Updated by code")
        progBtn:Highlight()
    end
})
```

### Varian UI button lewat Dialog

Tombol di dalam `Window:Dialog` mendukung penataan `Variant` — `"Primary"`, `"Secondary"`, dan `"White"`.

```lua
myTab:Button({
    Title = "Show UI Button Variants",
    Desc = "Opens dialog with Primary/Secondary/White",
    Icon = "square-menu",
    Callback = function()
        Window:Dialog({
            Title = "UI Button Variants",
            Content = "Demonstrates button variants.",
            Buttons = {
                { Title = "Primary",   Variant = "Primary",   Icon = "chevron-right", Callback = function() end },
                { Title = "Secondary", Variant = "Secondary", Icon = "chevron-right", Callback = function() end },
                { Title = "White",     Variant = "White",     Icon = "chevron-right", Callback = function() end },
            }
        })
    end
})
```

::: tip
Set `Icon = ""` untuk merender button tanpa ikon sama sekali — berguna untuk tombol aksi teks-saja yang terpusat.
:::
