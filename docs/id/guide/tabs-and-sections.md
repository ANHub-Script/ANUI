# Tab & Section

Tab adalah halaman-halaman dari menu Anda; section sidebar mengelompokkan tab-tab tersebut menjadi kluster berlabel. Halaman ini membahas pembuatan tab dengan `Window:Tab{}` dan pengelompokannya dengan `Window:Section{}`.

::: info Dua konsep "Section" yang berbeda
ANUI punya dua hal berbeda yang sama-sama disebut "Section" — jangan sampai tertukar:

1. **`Window:Section({ Title = ... })`** membuat **header section sidebar** yang mengelompokkan tab di sidebar. Anda lalu memanggil `Section:Tab({...})` untuk menambahkan tab di bawahnya. Inilah yang didokumentasikan di halaman ini.
2. **`Tab:Section({...})`** adalah **elemen konten** — kontainer yang bisa diciutkan dan ditempatkan *di dalam* sebuah tab. Yang itu didokumentasikan di [Section (elemen)](/id/elements/section).
:::

## Membuat tab

Buat tab dengan `Window:Tab{}`. Ia mengembalikan objek `Tab` sebagai tempat Anda menambahkan elemen.

```lua
local Main = Window:Tab({
    Title = "Main",
    Icon = "house",
    Desc = "Main controls", -- tooltip yang tampil saat hover
})
```

### Konfigurasi tab

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Tab"` | Label tab. |
| `Desc` | `string` | — | Tooltip yang tampil saat tab di-hover. |
| `Icon` | `string` | — | Ikon tab (16px): nama Lucide atau `rbxassetid://…`. |
| `Image` | `string` | — | Gambar banner (100px) yang tampil di header tab. |
| `IconThemed` | `boolean` | — | Warnai ikon dengan warna tema. |
| `Locked` | `boolean` | — | Mulai dengan tab dalam keadaan terkunci. |
| `ShowTabTitle` | `boolean` | — | Tampilkan judul tab di header konten. |
| `Profile` | `table` | — | Konfigurasi kartu profil (lihat di bawah). |
| `SidebarProfile` | `boolean` | — | Render profil sebagai kartu sidebar alih-alih header konten. |

## Profil

Sebuah tab bisa menampilkan **profil** — kartu dengan avatar, banner, indikator status, dan tombol badge. Teruskan tabel `Profile`:

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | Nama tampilan. |
| `Desc` | `string` | — | Subjudul / teks peran. |
| `Avatar` | `string` | — | Gambar avatar. |
| `Banner` | `string` | — | Gambar banner. |
| `Status` | `boolean` | — | Tampilkan indikator status. |
| `Badges` | `array` | — | Daftar tombol badge `{ Icon, Title, Desc, Callback }`. |
| `Sticky` | `boolean` | `true` | Tahan profil tetap tersemat saat menggulir. |

Set `SidebarProfile = true` untuk merender profil sebagai kartu di sidebar; `false` (atau tidak diisi) menampilkannya sebagai header besar di dalam konten tab.

```lua
local Badges = {
    {
        Icon = "geist:logo-discord",
        Title = "Discord",
        Desc = "Join ANHUB Discord",
        Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
            ANUI:Notify({ Title = "Discord", Content = "Invite link copied!", Icon = "geist:logo-discord", Duration = 3 })
        end
    },
    {
        Icon = "youtube",
        Desc = "Subscribe to YouTube",
        Callback = function()
            setclipboard("https://www.youtube.com/@ANHubRoblox")
            ANUI:Notify({ Title = "YouTube", Content = "Channel link copied!", Icon = "youtube", Duration = 3 })
        end
    },
}

-- Kartu sidebar (dekoratif, dirender di sidebar)
Window:Tab({
    Profile = {
        Title = "AdityaNugraha",
        Desc = "Admin",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = true,
})

-- Tab biasa dengan header profil besar
local UserTab = Window:Tab({
    Title = "Example Profile Content",
    Icon = "user",
    Profile = {
        Title = "User Settings",
        Desc = "Manage your account details here",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = false,
})

UserTab:Button({ Title = "Change Password", Callback = function() end })
UserTab:Button({ Title = "Log Out", Icon = "log-out", Callback = function() end })
```

## Mengelompokkan tab dengan section sidebar

`Window:Section({ Title = ... })` membuat header berlabel di sidebar. Panggil `:Tab{}` pada section yang dikembalikan untuk menambahkan tab di bawahnya.

```lua
local ElementsSection = Window:Section({ Title = "Elements" })

local ToggleTab = ElementsSection:Tab({ Title = "Toggle", Icon = "arrow-left-right" })
local ButtonTab = ElementsSection:Tab({ Title = "Button", Icon = "mouse-pointer-click" })

local OtherSection = Window:Section({ Title = "Other" })
local DiscordTab = OtherSection:Tab({ Title = "Discord" })
```

## Method tab

- `Tab:Select()` — beralih ke tab ini.
- `Tab:ScrollToTheElement(index)` — gulir tab ke elemen tertentu.
- `Tab:LockAll()` — kunci setiap elemen di tab.
- `Tab:UnlockAll()` — buka kunci setiap elemen di tab.
- `Tab:GetLocked()` — ambil elemen-elemen yang terkunci di tab.
- `Tab:GetUnlocked()` — ambil elemen-elemen yang tidak terkunci di tab.

Setiap method pembuat elemen (`Tab:Button`, `Tab:Toggle`, …) juga tersedia pada tab — lihat [Ikhtisar Elemen](/id/elements/).

## Memilih tab secara terprogram

Beralih tab dari kode, baik melalui window maupun tab itu sendiri. `Window:SelectTab` menerima sebuah indeks, yang tersedia pada tiap tab sebagai `Tab.Index`:

```lua
Window:SelectTab(UpgradeTab.Index)
-- atau, setara dengan:
UpgradeTab:Select()
```

## Terkait

- [Ikhtisar Elemen](/id/elements/) — semua yang bisa Anda masukkan ke dalam tab.
- [Section (elemen)](/id/elements/section) — kontainer di dalam tab yang bisa diciutkan.
