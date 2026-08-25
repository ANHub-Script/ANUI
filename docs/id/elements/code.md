# Code

Blok kode bergaya sintaks dengan tombol salin bawaan. Cocok untuk menampilkan cuplikan, perintah, atau baris instalasi yang bisa disalin pengguna dengan satu klik.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Code({
    Title = "Lua",
    Code = "print('Hello, world!')"
})
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | Label yang tampil di atas blok kode. |
| `Code` | `string` | `nil` | Teks kode yang ditampilkan. |
| `OnCopy` | `function` | `nil` | Dijalankan setelah kode disalin ke clipboard. |

::: info Menyalin
Tombol salin menulis ke **clipboard executor**. Jika penyalinan gagal, sebuah notifikasi ditampilkan sebagai gantinya.
:::

## Method

### `Code:SetCode(code)`

Mengganti kode yang ditampilkan dengan string baru.

```lua
mySnippet:SetCode("print('updated!')")
```

### `Code:Destroy()`

Menghapus blok kode dari container-nya.

```lua
mySnippet:Destroy()
```

## Contoh

### Blok cuplikan Lua

```lua
myTab:Code({
    Title = "Lua",
    Code = "print('Hello from Group 1')"
})
```

### Menjalankan callback setelah disalin

```lua
myTab:Code({
    Title = "Install",
    Code = 'loadstring(game:HttpGet("https://example.com/script.lua"))()',
    OnCopy = function()
        print("Copied!")
    end
})
```

### Memperbarui kode dengan `SetCode`

Simpan module yang dikembalikan dan ganti isinya kemudian.

```lua
local snippet = myTab:Code({
    Title = "Example",
    Code = "print('initial')"
})

myTab:Button({
    Title = "Update code",
    Callback = function()
        snippet:SetCode("print('updated!')")
    end
})
```
