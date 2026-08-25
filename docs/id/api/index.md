# Ringkasan API

Semuanya dalam satu halaman. Referensi cepat yang padat untuk seluruh permukaan ANUI — call tingkat atas, method Window dan Tab, setiap elemen, dan titik masuk fitur. Ikuti tautan untuk detail lengkap.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## `ANUI` (tingkat atas)

Method dan field pada objek library itu sendiri.

| Call | Fungsi |
| --- | --- |
| `ANUI:CreateWindow(config)` → `Window` | Buat window (hanya boleh ada satu). |
| `ANUI:Notify(config)` → notification | Tampilkan notifikasi toast. |
| `ANUI:SetNotificationLower(bool)` | Pindahkan notifikasi ke bagian bawah layar. |
| `ANUI:SetFont(fontId)` | Atur font UI global. |
| `ANUI:OnThemeChange(fn)` | Jalankan `fn` setiap kali tema berubah. |
| `ANUI:AddTheme(theme)` → theme | Daftarkan tema kustom (dikunci oleh `.Name`-nya). |
| `ANUI:SetTheme(name)` → theme \| `nil` | Ganti ke tema berdasarkan nama. |
| `ANUI:GetThemes()` | Kembalikan semua tema terdaftar. |
| `ANUI:GetCurrentTheme()` | Kembalikan tema aktif. |
| `ANUI:GetTransparency()` | Kembalikan nilai transparansi saat ini. |
| `ANUI:GetWindowSize()` | Kembalikan ukuran window saat ini. |
| `ANUI:Localization(config)` | Konfigurasikan terjemahan. |
| `ANUI:SetLanguage(lang)` | Ganti bahasa (butuh lokalisasi aktif). |
| `ANUI:ToggleAcrylic(bool)` | Nyalakan atau matikan efek blur acrylic. |
| `ANUI:Gradient(stops, props)` → gradient | Bangun tabel data gradient (stops dikunci `"0"`..`"100"`). |
| `ANUI:Popup(config)` → `Popup` | Buka popup modal. |
| `ANUI:Scheduler(config)` → `Scheduler` | Buat scheduler loop mandiri. |
| `ANUI.Version` | String versi library (field, bukan method). |

## Method Window

Dikembalikan oleh `ANUI:CreateWindow`. Dikelompokkan berdasarkan fungsi; signature dalam backtick.

**Tab & container**

| Method | Fungsi |
| --- | --- |
| `Window:Tab(config)` | Tambahkan tab (halaman sidebar yang menampung elemen). |
| `Window:Section(config)` | Tambahkan section sidebar yang mengelompokkan tab. |
| `Window:SelectTab(index)` | Beralih ke tab berdasarkan indeksnya. |
| `Window:Divider()` | Tambahkan garis pembatas di sidebar. |
| `Window:Tag(config)` | Tambahkan tag/badge kecil (mis. versi) ke window. |

**Dialog**

| Method | Fungsi |
| --- | --- |
| `Window:Dialog({ Title, Content, Icon, Width, Buttons })` | Buka dialog modal. Setiap tombol berupa `{ Title, Icon, Callback, Variant }` (`Width` default `320`). |

**Lifecycle & callback**

| Method | Fungsi |
| --- | --- |
| `Window:Open()` / `Window:Close()` / `Window:Toggle()` | Tampilkan, sembunyikan, atau toggle window. |
| `Window:Destroy()` | Hancurkan window dan bersihkan. |
| `Window:OnOpen(fn)` / `Window:OnClose(fn)` / `Window:OnDestroy(fn)` | Jalankan `fn` pada event yang cocok. |

**Tampilan**

| Method | Fungsi |
| --- | --- |
| `Window:SetTitle(t)` / `Window:SetAuthor(t)` | Perbarui judul / subjudul. |
| `Window:SetIconSize(n \| UDim2)` | Ubah ukuran ikon top-bar. |
| `Window:SetBackgroundImage(id)` / `Window:SetBackgroundImageTransparency(v)` | Atur gambar latar dan transparansinya. |
| `Window:SetBackgroundTransparency(v)` / `Window:ToggleTransparency(bool)` | Sesuaikan atau toggle transparansi window. |
| `Window:SetToTheCenter()` | Pusatkan kembali window di layar. |
| `Window:GetUIScale()` / `Window:SetUIScale(v)` | Baca atau atur skala UI. |
| `Window:IsResizable(bool)` | Aktifkan atau nonaktifkan resize. |

**Sidebar**

| Method | Fungsi |
| --- | --- |
| `Window:CollapseSidebar()` / `Window:ExpandSidebar()` / `Window:ToggleSidebar(state?)` | Lipat, buka, atau toggle sidebar. |

**Toggle key**

| Method | Fungsi |
| --- | --- |
| `Window:SetToggleKey(keycode)` | Atur hotkey tampil/sembunyi (sebuah `Enum.KeyCode`). |

**Lock**

| Method | Fungsi |
| --- | --- |
| `Window:LockAll()` / `Window:UnlockAll()` | Kunci atau buka semua elemen. |
| `Window:GetLocked()` / `Window:GetUnlocked()` | Daftar elemen terkunci / tidak terkunci. |

**Topbar**

| Method | Fungsi |
| --- | --- |
| `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` | Tambahkan tombol top-bar kustom. |
| `Window:DisableTopbarButtons({ names })` | Sembunyikan tombol top-bar bawaan berdasarkan nama. |

**Tombol buka**

| Method | Fungsi |
| --- | --- |
| `Window:EditOpenButton(config)` | Edit tombol buka mengambang. |

**Loop & scheduler**

| Method | Fungsi |
| --- | --- |
| `Window:Loop(key, interval, fn, opts?)` | Jalankan `fn` setiap `interval` detik. |
| `Window:StatusLoop(key, interval, fn)` | Loop yang ditujukan untuk memperbarui teks status. |
| `Window:ManagedLoop(key, interval, predicate, fn)` | Loop yang berjalan hanya selama `predicate` mengembalikan true. |
| `Window:StopLoop(key)` / `Window:StopAllLoops()` | Hentikan satu loop, atau semuanya. |
| `Window:IsLoopRunning(key)` / `Window:GetActiveLoopCount()` | Kueri status loop. |
| `Window:AddConnection(conn)` / `Window:DisconnectAll()` | Lacak dan bersihkan connection. |
| `Window:IsReady()` | Apakah window sudah selesai inisialisasi. |

## Method Tab

| Method | Fungsi |
| --- | --- |
| `Tab:Select()` | Jadikan ini tab aktif. |
| `Tab:ScrollToTheElement(index)` | Scroll ke elemen berdasarkan indeks. |
| `Tab:LockAll()` / `Tab:UnlockAll()` | Kunci atau buka semua elemen di tab. |
| `Tab:GetLocked()` / `Tab:GetUnlocked()` | Daftar elemen terkunci / tidak terkunci di tab. |
| `Tab:ReserveHeader(height, config)` | Sisakan area header tetap di atas tab. |

::: info
Sebuah Tab juga mengekspos **setiap method pembuatan elemen** — `Tab:Button{}`, `Tab:Toggle{}`, `Tab:Slider{}`, dan seterusnya. `Section` dan `Group` adalah container dengan method elemen yang sama.
:::

## Referensi cepat elemen

Satu baris per elemen. Argumen callback adalah apa yang diterima fungsi `Callback` Anda.

| Elemen | Signature | Config utama | Argumen callback |
| --- | --- | --- | --- |
| [Button](/id/elements/button) | `Tab:Button{}` | `Callback`, `Icon` | tidak ada |
| [Toggle](/id/elements/toggle) | `Tab:Toggle{}` | `Value`, `Type` | `boolean` |
| [Slider](/id/elements/slider) | `Tab:Slider{}` | `Value { Min, Max, Default }`, `Step` | `string` terformat |
| [Dropdown](/id/elements/dropdown) | `Tab:Dropdown{}` | `Values`, `Multi` | nilai terpilih (single) / array (multi) |
| [Input](/id/elements/input) | `Tab:Input{}` | `Placeholder`, `Type` | `string` |
| [Keybind](/id/elements/keybind) | `Tab:Keybind{}` | `Value` (nama key) | `string` nama key |
| [Colorpicker](/id/elements/colorpicker) | `Tab:Colorpicker{}` | `Default`, `Transparency` | `(Color3, transparency)` |
| [Paragraph](/id/elements/paragraph) | `Tab:Paragraph{}` | `Title`, `Desc`, `Images` | — |
| [Code](/id/elements/code) | `Tab:Code{}` | `Code`, `OnCopy` | — |
| [Section](/id/elements/section) | `Tab:Section{}` | `Title`, `Opened` | — |
| [Divider](/id/elements/divider) | `Tab:Divider()` | — | — |
| [Space](/id/elements/space) | `Tab:Space{}` | `Columns` | — |
| [Image](/id/elements/image) | `Tab:Image{}` | `Image`, `AspectRatio` | — |
| [Group](/id/elements/group) | `Tab:Group{}` | — (container) | — |
| [Category](/id/elements/category) | `Tab:Category{}` | `Options`, `Default` | nama opsi terpilih (`string`) |

## Referensi cepat fitur

| Fitur | Call masuk | Dokumen |
| --- | --- | --- |
| Notifikasi | `ANUI:Notify{}` | [Notifikasi](/id/features/notifications) |
| Dialog & Popup | `Window:Dialog{}` · `ANUI:Popup{}` | [Dialog & Popup](/id/features/dialogs-and-popups) |
| Konfigurasi & Flag | `Window.ConfigManager` · `Flag = "..."` | [Konfigurasi & Flag](/id/features/config-and-flags) |
| Sistem Key | `ANUI:CreateWindow{ KeySystem = {...} }` | [Sistem Key](/id/features/key-system) |
| Tema | `ANUI:SetTheme(name)` · `ANUI:AddTheme{}` | [Tema & Tampilan](/id/features/themes) |
| Lokalisasi | `ANUI:Localization{}` · `ANUI:SetLanguage(lang)` | [Lokalisasi](/id/features/localization) |
| Scheduler & Loop | `ANUI:Scheduler{}` · `Window:Loop(...)` | [Scheduler & Loop](/id/features/scheduler) |
