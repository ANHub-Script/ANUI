# Elemen

Elemen adalah kontrol interaktif di dalam window Anda — button, toggle, slider, dropdown, dan lainnya. Elemen selalu dibuat dari sebuah **container**: Tab, Section, atau Group.

## Membuat elemen

Setiap elemen dibuat dengan memanggil method pada sebuah container. Container yang paling umum adalah Tab:

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({ Title = "My Hub", Folder = "MyHub" })

-- 1. Buat container (sebuah Tab)
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

-- 2. Buat elemen di atasnya
myTab:Button({ Title = "Click me", Callback = function() end })
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
```

`Section` dan `Group` juga merupakan container — keduanya menyediakan method pembuatan elemen yang **sama** seperti Tab, sehingga Anda bisa menyusun elemen secara bersarang untuk merapikan tata letak:

```lua
local section = myTab:Section({ Title = "Combat" })
section:Toggle({ Title = "God Mode", Callback = function(state) end })

local row = myTab:Group({})       -- menata anak-anaknya secara horizontal
row:Button({ Title = "Save" })
row:Button({ Title = "Load" })
```

::: tip
Setiap method pembuatan elemen mengembalikan sebuah module yang bisa Anda panggil methodnya (mis. `local t = myTab:Toggle({...})` lalu `t:Set(true)`). Simpan nilai yang dikembalikan jika Anda berencana memperbarui elemen tersebut nanti.
:::

## Base bersama

Sebagian besar elemen interaktif dibangun di atas base yang sama, sehingga mereka berbagi sekumpulan field konfigurasi dan method. Pelajari sekali, dan semuanya berlaku di mana pun.

### Konfigurasi umum

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | nama elemen | Label utama. Mendukung [token rich-text](#rich-text-di-title-desc). |
| `Desc` | `string` | `nil` | Baris deskripsi tambahan. Mendukung token rich-text, `\n`, dan `\t`. |
| `Icon` | `string` | tergantung elemen | Nama ikon (Lucide) atau `rbxassetid://…`. |
| `Image` | `string` \| `table` | `nil` | Gambar rata kiri (asset id atau tabel card). |
| `ImageSize` | `number` | `30` | Ukuran gambar kiri, dalam piksel. |
| `Thumbnail` | `string` | `nil` | Gambar thumbnail besar. |
| `ThumbnailSize` | `number` | `80` | Ukuran thumbnail, dalam piksel. |
| `IconThemed` | `boolean` | `false` | Mewarnai ikon dengan warna tema saat ini. |
| `Color` | `Color3` \| `string` | `nil` | Latar berwarna (nama tema atau `Color3`); warna teks menyesuaikan otomatis. |
| `Justify` | `string` | `"Between"` | Perataan konten di dalam baris elemen. |
| `Locked` | `boolean` | `false` | Menampilkan overlay kunci dan memblokir interaksi. |
| `Buttons` | `table` | `nil` | Tombol inline yang dirender di baris elemen (lihat di bawah). |
| `TitleGradient` | `table` | `nil` | Gradient yang diterapkan pada teks judul. |
| `DescGradient` | `table` | `nil` | Gradient yang diterapkan pada teks deskripsi. |

### Method umum

Method berikut tersedia pada sebagian besar elemen interaktif:

- `:SetTitle(text)` — memperbarui judul.
- `:SetDesc(text)` — memperbarui deskripsi.
- `:SetIcon(icon)` / `:SetImage(image)` — memperbarui ikon atau gambar.
- `:Lock(text?)` — mengunci elemen (opsional dengan teks overlay).
- `:Unlock()` — membuka kunci elemen.
- `:Highlight()` — mengedipkan elemen sesaat untuk menarik perhatian.
- `:Destroy()` — menghapus elemen.
- `:SetButtons(buttons)` / `:GetButton(key)` / `:GetButtons()` — mengelola tombol inline.

::: info
Tiap elemen menambahkan methodnya sendiri di atas base bersama — misalnya `Toggle:Set(...)`, `Slider:SetMax(...)`, atau `Dropdown:Refresh(...)`. Lihat halaman masing-masing elemen untuk daftar lengkapnya.
:::

## Rich text di Title & Desc

`Title` dan `Desc` menerima token inline yang memungkinkan Anda menyisipkan ikon, gambar, gradient, bahkan tombol langsung di dalam teks:

- **Ikon inline** — `{icon}` atau `{name}`, dengan ukuran opsional: `{icon:star size=28}`.
- **Gambar inline** — cukup masukkan referensi `rbxassetid://…` langsung ke dalam string.
- **Gradient** — bungkus teks dengan `<gradient>…</gradient>`, atau tentukan warna dan rotasi: `<gradient=#40c9ff,#e81cff|45>…</gradient>`.
- **Tombol inline** — `<button=key>Label</button>` atau bentuk singkat `{button:key}`, terhubung ke entri di map `Buttons` milik elemen.

`Desc` juga mendukung:

- `\n` — deskripsi multi-baris.
- `\t` — baris dua kolom (label di kiri, nilai di kanan).

```lua
myTab:Button({
    Title = "Status: <gradient=#30FF6A,#e7ff2f>Online</gradient> {check}",
    Desc = "Ping\t24ms\nRegion\tSEA",
})
```

## Persistensi konfigurasi dengan Flag

Elemen berstatus — **Toggle**, **Slider**, **Dropdown**, **Input**, **Keybind**, dan **Colorpicker** — menerima field `Flag`. Elemen ber-flag otomatis terdaftar ke konfigurasi aktif sehingga nilainya disimpan dan dipulihkan antar sesi.

```lua
myTab:Toggle({ Title = "Auto Farm", Flag = "AutoFarm", Callback = function(state) end })
```

Lihat [Konfigurasi & Flag](/id/features/config-and-flags) untuk alur kerja lengkapnya.

## Semua elemen

| Elemen | Deskripsi |
| --- | --- |
| [Button](/id/elements/button) | Baris aksi yang bisa diklik dengan ikon opsional dan tombol inline. |
| [Toggle](/id/elements/toggle) | Sakelar on/off atau checkbox yang melaporkan boolean. |
| [Slider](/id/elements/slider) | Slider numerik yang bisa diseret dengan stepping opsional dan input manual. |
| [Dropdown](/id/elements/dropdown) | Daftar single atau multi-select; bisa juga berperan sebagai menu aksi. |
| [Input](/id/elements/input) | Field teks satu baris atau banyak baris. |
| [Keybind](/id/elements/keybind) | Mengikat aksi ke sebuah tombol, memicu secara global saat ditekan. |
| [Colorpicker](/id/elements/colorpicker) | Memilih warna (dengan transparansi opsional) lewat dialog. |
| [Paragraph](/id/elements/paragraph) | Blok teks kaya dengan card gambar opsional dan tombol bertumpuk. |
| [Code](/id/elements/code) | Blok cuplikan kode yang bisa disalin. |
| [Section](/id/elements/section) | Container yang bisa dilipat untuk mengelompokkan elemen anak di bawah header. |
| [Divider](/id/elements/divider) | Garis pemisah horizontal (atau vertikal, di dalam Group). |
| [Space](/id/elements/space) | Spacer tak terlihat untuk memberi ruang vertikal. |
| [Image](/id/elements/image) | Gambar mandiri dengan kontrol rasio aspek dan penskalaan. |
| [Group](/id/elements/group) | Container yang menata anak-anaknya secara horizontal. |
| [Category](/id/elements/category) | Strip opsi horizontal untuk berpindah antar kelompok elemen. |
