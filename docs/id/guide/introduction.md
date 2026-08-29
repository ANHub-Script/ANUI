# Pengenalan

ANUI (Advanced Roblox UI Library) adalah library UI modern dan kaya fitur untuk executor script Roblox. Dengan ANUI Anda bisa membangun menu yang rapi dan siap-mobile — window, tab, toggle, slider, dropdown, dan lainnya — hanya dalam beberapa baris Lua.

## Apa itu ANUI?

ANUI menampilkan window melayang yang bisa digeser dan diubah ukurannya di atas experience Roblox apa pun. Anda mendeskripsikan menu secara deklaratif — buat window, tambahkan tab, isi dengan elemen — dan ANUI menangani layout, tema, input, animasi, serta penyimpanan untuk Anda.

Karena dimuat lewat HTTP dengan satu `loadstring`, tidak ada yang perlu diinstal atau dibundel: tempel satu baris dan menu Anda langsung aktif.

## Apa yang bisa Anda bangun

- Hub fitur dan menu cheat dengan tab dan section sidebar yang tertata
- Panel pengaturan yang state-nya bertahan antar sesi lewat [Konfigurasi & Flag](/id/features/config-and-flags)
- Script terkunci key menggunakan [Sistem Key](/id/features/key-system) bawaan
- Dashboard kaya dengan profil, badge, notifikasi, dan dialog

## Sorotan fitur

- 15+ [elemen](/id/elements/) — button, toggle, slider, dropdown, colorpicker, keybind, input, blok kode, dan lainnya
- [26 tema bawaan](/id/features/themes), plus palet kustom buatan Anda sendiri
- [Konfigurasi & flag](/id/features/config-and-flags) untuk menyimpan state elemen apa pun ke disk
- [Sistem key](/id/features/key-system) dengan provider Luarmor, Platoboost, dan PandaDevelopment
- [Notifikasi](/id/features/notifications) serta [dialog & popup](/id/features/dialogs-and-popups)
- [Lokalisasi](/id/features/localization) untuk menu multi-bahasa
- [Scheduler](/id/features/scheduler) bebas-drift untuk loop terkelola
- [Penskalaan siap-mobile dan blur acrylic](/id/guide/window-configuration)

## Persyaratan

ANUI berjalan di dalam executor script Roblox. Executor Anda harus mendukung:

- `loadstring` dan `game:HttpGet` — wajib untuk memuat library
- `readfile`, `writefile`, `isfile`, `makefolder` — hanya diperlukan untuk menyimpan konfigurasi dan key

::: info Hanya satu window
Hanya satu window yang boleh ada dalam satu waktu. Memanggil `ANUI:CreateWindow` untuk kedua kalinya akan memunculkan peringatan dan mengembalikan `nil`.
:::

## Kredit

- Berbasis **WindUI oleh Footagesus**
- Ikon oleh [Lucide](https://lucide.dev)
- Terima kasih kepada Dawid-Scripts

## Tautan

- GitHub: [github.com/ANHub-Script/ANUI](https://github.com/ANHub-Script/ANUI)
- Discord: [https://discord.gg/qN47S3mKZA](https://discord.gg/qN47S3mKZA)
- YouTube: [@ANHubRoblox](https://www.youtube.com/@ANHubRoblox)

---

Berikutnya: [Instalasi](/id/guide/installation)
