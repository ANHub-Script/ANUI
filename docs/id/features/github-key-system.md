---
outline: deep
---

# Sistem Key GitHub

Penyedia key `github` menerbitkan **satu key per device**, berlaku **24 jam**, yang digenerate sendiri oleh pemain di situs GitHub Pages milikmu. Database key-nya adalah satu file JSON yang di-commit ke repositori GitHub, jadi tidak ada server yang perlu di-hosting dan tidak ada layanan key pihak ketiga.

- **Per device** — key terikat pada fingerprint yang diturunkan dari HWID executor.
- **24 jam** — masa berlakunya bisa diatur; default-nya 24.
- **Bisa digenerate ulang kapan saja** — generate lagi langsung mematikan key sebelumnya.
- **Realtime** — library membaca database langsung dari `raw.githubusercontent.com` di setiap pemeriksaan, dengan cache buster.

## Cara kerjanya

```
Executor                     Situs GitHub Pages-mu          Repo GitHub
--------                     ---------------------          -----------
SHA-256(HWID)[0..31]
   │  "Get key" menyalin
   │  .../getkey/#fp=<fingerprint>
   ▼
   ├──────────────────────▶ generate ANUI-XXXXX-XXXXX-XXXXX
   │                        menandatanganinya dengan HMAC-SHA256
   │                        menulis keys[<fingerprint>] ─────▶ db/keys.json
   │
   ◀── pemain menempelkan key kembali ke prompt
   │
   └── membaca db/keys.json ◀────────────────────────────────── raw.githubusercontent.com
       memeriksa fingerprint, kedaluwarsa, dan tanda tangan
```

HWID mentah tidak pernah keluar dari executor. Hanya hash SHA-256 yang dipotong — fingerprint — yang sampai ke repositori publik.

Dua hal membuat kedaluwarsa sulit dicurangi:

- **Timestamp berasal dari GitHub.** Halaman generator maupun library membaca header respons HTTP `Date`, jadi memutar balik jam sistem tidak memperpanjang masa berlaku key.
- **Setiap record ditandatangani.** `sig = HMAC-SHA256(secret, "key|fingerprint|issued_at|expires_at")`, dipotong menjadi 32 karakter hex. Mengedit database secara manual membuat entri itu tidak valid.

## Persiapan

### 1. Buat database

Commit file awal ke repositori yang akan menyimpan key:

```json
{
  "version": 1,
  "updated_at": 0,
  "ttl_hours": 24,
  "keys": {}
}
```

Path default-nya `db/keys.json`. Jangan masukkan ke `.gitignore` — generator melakukan commit ke file itu dan library membacanya.

::: tip Gunakan repositori terpisah
Menempatkan database di repo sendiri (misalnya `NamaKamu/ANUI-Keys`) membuat token di halaman generator tidak bisa menyentuh source library-mu. Ini langkah pencegahan paling berharga dalam setup ini.
:::

### 2. Buat token

Di GitHub: **Settings → Developer settings → Personal access tokens → Fine-grained tokens**.

| Pengaturan | Nilai |
| --- | --- |
| Tipe | **Fine-grained**, jangan classic |
| Akses repositori | Hanya repo database key |
| Permission | **Contents → Read and write**, tidak ada yang lain |
| Kedaluwarsa | Sesingkat yang bisa kamu terima, lalu rotasi |

### 3. Bangun config generator

```bash
node build/keygen-config.js
```

Prompt-nya mencakup repositori, format key, masa berlaku, cooldown, dan branding; token serta HMAC secret diketik tersembunyi dan tidak pernah ditampilkan. Script ini menulis `docs/public/getkey/config.js` dan mencetak HMAC secret beserta blok `KeySystem` yang siap ditempel.

Non-interaktif, untuk CI:

```bash
ANUI_GH_TOKEN=github_pat_... ANUI_HMAC_SECRET=secret-kamu node build/keygen-config.js --yes
```

| Flag | Environment variable | Default |
| --- | --- | --- |
| `--owner` | `ANUI_GH_OWNER` | `ANHub-Script` |
| `--repo` | `ANUI_GH_REPO` | `ANUI` |
| `--branch` | `ANUI_GH_BRANCH` | `main` |
| `--db-path` | `ANUI_DB_PATH` | `db/keys.json` |
| `--prefix` | `ANUI_KEY_PREFIX` | `ANUI` |
| `--ttl` | `ANUI_TTL_HOURS` | `24` |
| `--cooldown` | `ANUI_COOLDOWN` | `0` |
| `--brand` | `ANUI_BRAND` | `ANUI` |
| `--discord` | `ANUI_DISCORD` | — |
| `--site-url` | `ANUI_SITE_URL` | diturunkan dari owner dan repo |
| `--token` | `ANUI_GH_TOKEN` | ditanyakan, tersembunyi |
| `--secret` | `ANUI_HMAC_SECRET` | ditanyakan, tersembunyi (digenerate jika dikosongkan) |

### 4. Deploy halamannya

Generator berada di `docs/public/getkey/`, yang disalin apa adanya oleh VitePress, jadi setelah dokumentasi dipublikasikan halamannya bisa diakses di:

```
https://<owner>.github.io/<repo>/getkey/
```

### 5. Hubungkan ke script-mu

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Generate key untuk device ini. Berlaku 24 jam.",
        SaveKey = true,
        API = {
            {
                Type = "github",
                Owner = "ANHub-Script",
                Repo = "ANUI-Keys",
                Branch = "main",
                DBPath = "db/keys.json",
                URL = "https://anhub-script.github.io/ANUI/getkey/",
                Secret = "secret-yang-dicetak-keygen-config",
            },
        },
    },
})
```

`Secret` harus sama dengan HMAC secret di config generator, kalau tidak semua key akan gagal pemeriksaan tanda tangan.

## Argumen penyedia

| Field | Tipe | Default | Deskripsi |
| --- | --- | --- | --- |
| `Type` | `string` | — | Harus `"github"`. |
| `Owner` | `string` | — | User atau organisasi pemilik repo database. |
| `Repo` | `string` | — | Repositori yang menyimpan database. |
| `Branch` | `string` | `"main"` | Branch yang dibaca. |
| `DBPath` | `string` | `"db/keys.json"` | Path database di dalam repo. |
| `URL` | `string` | — | URL publik halaman generator. **Get key** menyalinnya dengan tambahan `#fp=<fingerprint>`. |
| `Secret` | `string` | — | HMAC secret. Kosongkan untuk melewati pemeriksaan tanda tangan (tidak disarankan). |
| `Folder` | `string` | `Folder` window | Diisi otomatis oleh ANUI; menentukan lokasi penulisan cache offline. |

`Icon`, `Title`, dan `Desc` bekerja seperti pada penyedia lain dan hanya memengaruhi barisnya di dropdown **Get key**.

## Yang dilihat pemain

1. Buka menu — prompt key muncul.
2. Tekan **Get key** lalu pilih baris penyedianya. Link yang sudah membawa fingerprint device ini disalin ke clipboard.
3. Buka di browser, tekan **Generate key**, salin key-nya.
4. Tempel ke prompt.

Dengan `SaveKey = true`, key yang diterima ditulis ke `ANUI/<Folder>/<hwid>.key`, jadi prompt dilewati pada peluncuran berikutnya sampai key kedaluwarsa.

## Verifikasi

Library memeriksa key secara online lebih dulu:

1. `GET https://raw.githubusercontent.com/<owner>/<repo>/<branch>/<path>?cb=<unik>` — cache buster mengalahkan cache CDN yang bertahan beberapa menit, dan inilah yang membuat pembacaan bersifat realtime.
2. Cari `keys[<fingerprint>]`. Tidak ada entri, atau `revoked`, berarti device ini tidak punya key.
3. Bandingkan key yang dimasukkan dengan yang tersimpan — key yang sudah digenerate ulang akan gagal di sini.
4. Verifikasi tanda tangan, lalu kedaluwarsa terhadap header `Date` dari GitHub.

Jika berhasil, hasilnya di-cache di `ANUI/<Folder>/<fingerprint>.keycache`. Cache ini hanya cadangan saat request HTTP-nya sendiri gagal: ia tidak pernah bisa mengonfirmasi key yang belum dikonfirmasi server, tidak pernah hidup melampaui `expires_at`, dan dihapus pada setiap penolakan dari sisi server.

## Format database

```json
{
  "version": 1,
  "updated_at": 1774440000,
  "ttl_hours": 24,
  "keys": {
    "a1b2c3d4e5f60718293a4b5c6d7e8f90": {
      "key": "ANUI-7GKQ2-XM4TB-9WHZP",
      "sig": "4f1c9ab27d3e5f60718293a4b5c6d7e8",
      "issued_at": 1774440000,
      "expires_at": 1774526400,
      "regen": 3,
      "revoked": false
    }
  }
}
```

| Field | Arti |
| --- | --- |
| `key` | Key yang ditempel pemain. Satu per device — key baru menimpanya. |
| `sig` | `HMAC-SHA256(secret, "key\|fingerprint\|issued_at\|expires_at")[0..31]`. |
| `issued_at` / `expires_at` | Unix seconds, diambil dari jam GitHub. |
| `regen` | Berapa kali device ini sudah generate key. |
| `revoked` | Set ke `true` secara manual untuk memblokir device tanpa menghapus riwayatnya. |

Key memakai alfabet `0123456789ABCDEFGHJKMNPQRSTVWXYZ` — tanpa `I`, `L`, `O`, atau `U` — jadi key yang dibacakan tidak ambigu.

::: tip Pemangkasan
Record yang kedaluwarsa tidak berbahaya, tapi file-nya membesar. Hapus entri lama kapan saja; Contents API berhenti menyertakan isi file di atas sekitar 1 MB, dan generator akan memberitahu kalau kamu sampai ke titik itu.
:::

## Keamanan

::: danger Token-nya publik
GitHub Pages adalah hosting statis. Token di `config.js` dikirim ke browser setiap pengunjung. Pengacakan di file itu ada untuk mencegah secret scanner GitHub mencabut token secara otomatis dan untuk menghalangi copy-paste sembarangan — **itu bukan enkripsi**. Siapa pun yang membaca file itu bisa memulihkan token-nya, lalu menerbitkan key sendiri atau menulis ke apa pun yang bisa dijangkau token tersebut.

Karena itu:

- Gunakan token **fine-grained**, dibatasi hanya ke repo key, dengan **Contents → Read and write** sebagai satu-satunya permission.
- Simpan database di **repositori terpisah** dari source library-mu.
- Beri masa kedaluwarsa dan rotasi token-nya.
- Anggap ini sebagai *penghalang gangguan*, bukan server lisensi.
:::

Kalau nanti kamu ingin setup yang benar-benar tidak bisa dibobol, pindahkan jalur tulis ke proxy kecil — Cloudflare Worker atau GitHub Action `repository_dispatch` — lalu hapus token dari `config.js`. Tidak ada yang berubah di library Lua: ia hanya membaca database.

HMAC secret dikirim di file yang sama dan sama-sama bisa dipulihkan. Nilainya adalah database tidak bisa diedit manual tanpa membuat entrinya tidak valid, dan itulah yang mencegah record curian atau buatan tangan lolos verifikasi.

## Pemecahan masalah

| Gejala | Penyebab |
| --- | --- |
| Halaman menampilkan *Generator not configured* | `config.js` masih file contoh. Jalankan `node build/keygen-config.js`. |
| *the token is invalid or expired* | Token dicabut, kedaluwarsa, atau tertangkap scanning GitHub. Buat yang baru. |
| *the token lacks Contents: read and write* | Permission salah atau token tidak dibatasi ke repositori itu. |
| *the repository, branch or path does not exist* | Periksa `owner`, `repo`, `branch`, dan `dbPath`; token fine-grained tidak bisa melihat repo di luar cakupannya. |
| *Signature mismatch* di halaman | Database diedit di luar halaman, atau secret-nya berubah. Generate ulang. |
| *Key signature is invalid* di dalam game | `Secret` di script-mu berbeda dari secret generator. |
| *No key issued for this device yet* | Device belum punya record. Tekan **Get key**, generate, tempel. |
| Key masih ditolak tepat setelah digenerate | Library membaca salinan cache — tekan submit lagi; pembacaan membawa cache buster dan beres dalam hitungan detik. |
| Tidak terjadi apa-apa di dalam game | Executor tidak punya `request`/`gethwid`. Keduanya wajib. |

## Lihat juga

- [Sistem Key](/id/features/key-system) — konfigurasi `KeySystem` di sekitarnya dan penyedia lainnya.
- [Konfigurasi Window](/id/guide/window-configuration) — tempat `KeySystem` dan `Folder` diatur.





