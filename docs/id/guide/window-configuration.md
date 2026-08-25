# Konfigurasi Window

Window adalah akar dari setiap menu ANUI. Anda membuatnya sekali dengan `ANUI:CreateWindow{}`, meneruskan satu tabel konfigurasi. Halaman ini mendokumentasikan setiap field serta method yang tersedia pada objek `Window` yang dikembalikan.

::: info Hanya satu window
Hanya satu window yang boleh ada dalam satu waktu. Panggilan `ANUI:CreateWindow` kedua akan memunculkan peringatan dan mengembalikan `nil`.
:::

## Contoh dasar

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
    Theme = "Dark",
})
```

## Konfigurasi

### Identity

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | Teks judul window. |
| `Author` | `string` | — | Subjudul yang tampil di bawah judul. |
| `Icon` | `string` | — | Ikon window: nama ikon Lucide atau `rbxassetid://…`. |
| `IconSize` | `number` \| `UDim2` | `22` | Ukuran ikon dalam piksel. |
| `IconThemed` | `boolean` | — | Warnai ikon dengan warna ikon dari tema. |

### Storage

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Folder` | `string` | — | Folder penyimpanan di disk. Mengaturnya akan mengaktifkan [sistem konfigurasi](/id/features/config-and-flags) dan opsi `SaveKey` pada [sistem key](/id/features/key-system). Konfigurasi ditulis ke `ANUI/<Folder>/config/<name>.json`. |

### Size & scaling

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Size` | `UDim2` | `580 × 460` (dibatasi) | Ukuran awal window. |
| `MinSize` | `Vector2` | `850 × 560` | Ukuran minimum saat diubah ukurannya. |
| `MaxSize` | `Vector2` | `1050 × 560` | Ukuran maksimum saat diubah ukurannya. |
| `Resizable` | `boolean` | `true` | Izinkan pengguna mengubah ukuran window. |
| `AutoScale` | `boolean` | `true` | Skalakan UI secara otomatis (ramah-mobile). |

### Appearance

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Theme` | `string` | `"Dark"` | Nama tema — lihat [Tema](/id/features/themes). |
| `Transparent` | `boolean` | `false` | Gunakan background window transparan. |
| `Acrylic` | `boolean` | `false` | Blur acrylic di belakang window. |
| `Background` | `Color3` \| image id \| `"https://…"` \| `"video:…"` \| tabel gradient | — | Background window kustom. |
| `BackgroundImageTransparency` | `number` | `0` | Transparansi gambar background. |
| `ShadowTransparency` | `number` | `0.7` | Transparansi bayangan window. |
| `Radius` | `number` | `16` | Radius sudut window. |
| `ElementsRadius` | `number` | — | Radius sudut yang diterapkan ke elemen. |
| `SideBarWidth` | `number` | `200` | Lebar sidebar dalam piksel. |
| `HidePanelBackground` | `boolean` | `false` | Sembunyikan background panel konten. |
| `ScrollBarEnabled` | `boolean` | `false` | Tampilkan scrollbar konten. |

### Behavior

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `ToggleKey` | `Enum.KeyCode` | — | Tombol untuk menampilkan / menyembunyikan window. |
| `HideSearchBar` | `boolean` | `true` | Sembunyikan search bar elemen. Set `false` untuk menampilkannya. |
| `NewElements` | `boolean` | `false` | Pakai gaya elemen versi baru. |
| `IgnoreAlerts` | `boolean` | `false` | Tekan popup alert bawaan. |

### Sub-config

Field berikut menerima tabel konfigurasinya sendiri dan didokumentasikan di halaman khusus.

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `OpenButton` | `table` | — | Tombol melayang untuk membuka kembali window. Lihat [Tombol Buka](/id/features/open-button). |
| `KeySystem` | `table` | — | Kunci menu di balik key. Lihat [Sistem Key](/id/features/key-system). |
| `User` | `table` | — | Blok tampilan pengguna: `{ Enabled, Anonymous, Callback }`. |

## Method window

Setelah Anda punya `Window`, method berikut mengendalikannya saat runtime.

### Lifecycle

- `Window:Open()` — tampilkan window.
- `Window:Close()` — sembunyikan window; mengembalikan objek dengan `:Destroy()`.
- `Window:Destroy()` — hapus window secara permanen.
- `Window:Toggle()` — bergantian antara terbuka dan tertutup.
- `Window:OnOpen(fn)` — jalankan `fn` setiap kali window terbuka.
- `Window:OnClose(fn)` — jalankan `fn` setiap kali window tertutup.
- `Window:OnDestroy(fn)` — jalankan `fn` saat window dihancurkan.

### Appearance

- `Window:SetTitle(text)` — ubah judul.
- `Window:SetAuthor(text)` — ubah subjudul.
- `Window:SetIconSize(n | UDim2)` — ubah ukuran ikon window.
- `Window:SetBackgroundImage(id)` — ganti gambar background.
- `Window:ToggleTransparency(bool)` — alihkan background transparan.
- `Window:SetUIScale(v)` — atur skala UI (baca kembali dengan `Window:GetUIScale()`).

### Sidebar

- `Window:CollapseSidebar()` — ciutkan sidebar.
- `Window:ExpandSidebar()` — bentangkan sidebar.
- `Window:ToggleSidebar(state?)` — alihkan, atau paksa ke suatu state jika `state` diberikan.

```lua
task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
```

### Toggle key

- `Window:SetToggleKey(keycode)` — ubah tombol tampil / sembunyi saat runtime.

```lua
Window:SetToggleKey(Enum.KeyCode.G)
```

### Locks

- `Window:LockAll()` — kunci setiap elemen di window.
- `Window:UnlockAll()` — buka kunci setiap elemen di window.

### Topbar

- `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` — tambahkan tombol ke top bar window.
- `Window:DisableTopbarButtons({names})` — nonaktifkan tombol topbar tertentu berdasarkan nama.

### Tag

`Window:Tag(cfg)` menambahkan label tag kecil pada window — praktis untuk menampilkan badge versi.

```lua
Window:Tag({ Title = "v" .. ANUI.Version, Icon = "github" })
```

### Dialog

`Window:Dialog{}` membuka dialog modal. Lihat [Dialog & Popup](/id/features/dialogs-and-popups).

### Loop

`Window:Loop`, `Window:StatusLoop`, `Window:ManagedLoop`, dan kawan-kawannya menjalankan loop terkelola yang berhenti otomatis saat window ditutup atau dihancurkan. Lihat [Scheduler & Loop](/id/features/scheduler).

## Langkah berikutnya

- Tambahkan [Tab & Section](/id/guide/tabs-and-sections) untuk menata menu Anda.
- Ubah tampilan semuanya dengan [Tema](/id/features/themes).
