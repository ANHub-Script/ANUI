# Notifications

Notifikasi bergaya toast yang muncul dari samping, menampilkan judul dan isi, lalu menutup sendiri setelah hitung mundur. Buat satu dengan `ANUI:Notify{}` — bisa dipanggil dari mana saja, baik window sedang terbuka maupun tidak.

## Penggunaan dasar

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Notify({
    Title = "Welcome",
    Content = "Thanks for using ANUI!",
    Icon = "bell",
    Duration = 5,
})
```

::: info Field isi adalah `Content`, bukan `Desc`
Teks isi notifikasi diatur dengan `Content`. `Notify` tidak punya field `Desc` — memberikan `Desc` tidak akan menampilkan isi apa pun. Begitu juga gambar diatur dengan `Icon` (nama ikon Lucide **atau** `rbxassetid://…`), bukan `Image`.
:::

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `"Notification"` | Teks judul toast. |
| `Content` | `string` | `nil` | Teks isi yang ditampilkan di bawah judul. |
| `Icon` | `string` | `nil` | Ikon di depan: nama ikon Lucide atau `rbxassetid://…`. (Field-nya `Icon`, bukan `Image`.) |
| `IconThemed` | `boolean` | `nil` | Mewarnai ikon dengan warna ikon tema. |
| `Background` | `string` | `nil` | Id gambar background untuk toast. |
| `BackgroundImageTransparency` | `number` | `nil` | Transparansi gambar background (`0` = solid). |
| `Duration` | `number` \| `false` | `5` | Detik sebelum menutup otomatis; sekaligus menggerakkan progress bar. Nilai falsy (`false`/`nil`/`0`) berarti tidak pernah menutup otomatis. |
| `Buttons` | `table` | `{}` | Disimpan di objek tetapi **tidak dirender** — lihat peringatan di bawah. |

::: warning `Buttons` disimpan tetapi tidak dirender
Field `Buttons` diterima dan disimpan pada objek notifikasi, tetapi build saat ini **tidak** menggambarnya. Untuk pilihan interaktif, buka [Dialog atau Popup](/id/features/dialogs-and-popups).
:::

Tombol tutup (X) selalu ada, sehingga pengguna dapat menutup toast secara manual bahkan ketika `Duration` bernilai falsy.

## Objek yang dikembalikan

`ANUI:Notify{}` mengembalikan objek notifikasi dengan satu method:

### `Notification:Close()`

Menutup notifikasi seketika. Berguna untuk toast persisten (`Duration = false`) yang ingin Anda tutup lewat kode.

```lua
local note = ANUI:Notify({
    Title = "Working…",
    Content = "This stays open until you close it.",
    Icon = "loader",
    Duration = false, -- falsy → tidak pernah menutup otomatis
})

task.delay(3, function()
    note:Close()
end)
```

## `ANUI:SetNotificationLower(bool)`

Memindahkan tumpukan notifikasi ke bagian bawah layar ketika `true`, dan mengembalikan ke posisi default ketika `false`. Panggil sekali saat setup.

```lua
ANUI:SetNotificationLower(true)
```

## Contoh

### Notifikasi sederhana

```lua
ANUI:Notify({
    Title = "Saved",
    Content = "Your settings have been saved.",
})
```

### Dengan ikon dan durasi kustom

```lua
ANUI:Notify({
    Title = "Discord",
    Content = "Invite link copied to clipboard!",
    Icon = "geist:logo-discord",
    Duration = 3,
})

ANUI:Notify({
    Title = "YouTube",
    Content = "Channel link copied!",
    Icon = "youtube",
    Duration = 3,
})
```

### Notifikasi persisten yang ditutup lewat kode

Atur `Duration = false` agar toast tidak pernah kedaluwarsa, simpan objek yang dikembalikan, lalu panggil `:Close()` saat selesai.

```lua
local loading = ANUI:Notify({
    Title = "Loading…",
    Content = "Fetching data from the server.",
    Icon = "loader",
    Duration = false,
})

-- nanti, setelah pekerjaan selesai
loading:Close()
ANUI:Notify({
    Title = "Done",
    Content = "Data loaded successfully.",
    Icon = "check",
    Duration = 4,
})
```

::: details Dengan gambar background
```lua
ANUI:Notify({
    Title = "Event started",
    Content = "A limited-time event is now live.",
    Icon = "party-popper",
    Background = "rbxassetid://84366761557806",
    BackgroundImageTransparency = 0.4,
    Duration = 6,
})
```
:::
