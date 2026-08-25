# Instalasi

ANUI dipasang hanya dengan satu baris — tanpa unduhan, tanpa dependensi. Tempel di bagian atas script Anda dan Anda siap membangun.

## Pemasangan

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

### Apa yang dilakukan baris ini

- `game:HttpGet(url)` mengunduh source ANUI terbaru dari GitHub sebagai string.
- `loadstring(...)` mengompilasi string tersebut menjadi fungsi yang bisa dijalankan.
- Tanda `()` di akhir memanggilnya, lalu mengembalikan tabel library ANUI.
- Hasilnya disimpan dalam local bernama `ANUI` — setiap contoh di situs ini memanggil method pada variabel ini (`ANUI:CreateWindow`, `ANUI:Notify`, dan seterusnya).

::: tip Cache-busting saat pengembangan
Beberapa executor menyimpan cache respons `HttpGet`, sehingga Anda bisa terus mendapatkan build lama saat sedang mengembangkan. Tambahkan query string acak untuk memaksa salinan terbaru:

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v="..math.random()))()
```

Hapus bagian `?v=`... untuk produksi agar respons bisa di-cache secara normal.
:::

## Pastikan sudah termuat

Cetak versi untuk memastikan library tersedia:

```lua
print(ANUI.Version)
```

Jika muncul string versi, berarti ANUI berhasil dimuat.

::: warning Persyaratan executor
ANUI membutuhkan executor yang mendukung `loadstring` dan `game:HttpGet`.

Penyimpanan konfigurasi dan opsi `SaveKey` pada sistem key juga membutuhkan file global `readfile`, `writefile`, `isfile`, dan `makefolder`. Tanpa itu, UI tetap berfungsi — hanya penyimpanan ke disk yang tidak tersedia.
:::

## Pemecahan masalah

::: details ANUI bernilai `nil` / "attempt to call a nil value"
`loadstring` atau `HttpGet` tidak mengembalikan apa pun. Pastikan executor Anda mendukung keduanya, dan tidak memblokir domain `raw.githubusercontent.com`. Jalankan ulang setelah menambahkan query cache-busting `?v=` seperti di atas.
:::

::: details HttpGet dinonaktifkan / request gagal
Beberapa executor mengatur request HTTP lewat pengaturan. Aktifkan HTTP / HttpGet di executor Anda, lalu jalankan script kembali.
:::

::: details Tidak ada yang muncul di layar
Memuat library saja tidak menampilkan apa pun. Pastikan Anda benar-benar membuat window — lihat [Mulai Cepat](/id/guide/getting-started).
:::

---

Berikutnya: [Mulai Cepat](/id/guide/getting-started)
