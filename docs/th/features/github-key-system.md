---
outline: deep
---

# ระบบ Key GitHub

ผู้ให้บริการ key `github` ออก **หนึ่ง key ต่ออุปกรณ์** มีอายุ **24 ชั่วโมง** ที่ถูก generate โดยผู้เล่นเองบนเว็บไซต์ GitHub Pages ของคุณ ฐานข้อมูล key เป็นไฟล์ JSON หนึ่งไฟล์ที่ commit ไปยัง repositori GitHub ดังนั้นไม่มีเซิร์ฟเวอร์ที่ต้องโฮสต์และไม่มีบริการ key ภายนอก

- **ต่ออุปกรณ์** — key ผูกกับ fingerprint ที่ได้มาจาก HWID executor
- **24 ชั่วโมง** — ระยะเวลาสามารถตั้งค่าได้; default เป็น 24
- **Generate ใหม่ได้ทุกเมื่อ** — generate อีกครั้งจะยกเลิก key ก่อนหน้าทันที
- **แบบเรียลไทม์** — library อ่านฐานข้อมูลโดยตรงจาก `raw.githubusercontent.com` ในทุกการตรวจสอบ พร้อม cache buster

## วิธีการทำงาน

```
Executor                     เว็บไซต์ GitHub Pages คุณ          Repo GitHub
--------                     ---------------------          -----------
SHA-256(HWID)[0..31]
   │  "Get key" คัดลอก
   │  .../getkey/#fp=<fingerprint>
   ▼
   ├──────────────────────▶ generate ANUI-XXXXX-XXXXX-XXXXX
   │                        เซ็นด้วย HMAC-SHA256
   │                        เขียน keys[<fingerprint>] ─────▶ db/keys.json
   │
   ◀── ผู้เล่นวาง key กลับไปยัง prompt
   │
   └── อ่าน db/keys.json ◀────────────────────────────────── raw.githubusercontent.com
       ตรวจสอบ fingerprint, หมดอายุ, และลายเซ็น
```

HWID ดิบไม่เคยออกจาก executor เฉพาะ hash SHA-256 ที่ถูกตัด — fingerprint — ที่ไปถึง repositori สาธารณะ

สองสิ่งทำให้การหมดอายุยากที่จะถูกโกง:

- **Timestamp มาจาก GitHub** ทั้งหน้า generator และ library อ่าน header การตอบสนอง HTTP `Date` ดังนั้นการย้อนเวลาระบบจะไม่ขยายอายุ key
- **แต่ละ record ถูกเซ็น** `sig = HMAC-SHA256(secret, "key|fingerprint|issued_at|expires_at")` ตัดเป็น 32 อักขระ hex การแก้ไขฐานข้อมูลด้วยมือจะทำให้รายการนั้นไม่ถูกต้อง

## การเตรียมการ

### 1. สร้างฐานข้อมูล

Commit ไฟล์เริ่มต้นไปยัง repositori ที่จะเก็บ key:

```json
{
  "version": 1,
  "updated_at": 0,
  "ttl_hours": 24,
  "keys": {}
}
```

Path default คือ `db/keys.json` อย่าใส่ใน `.gitignore` — generator commit ไปยังไฟล์นั้นและ library อ่านมัน

::: tip ใช้ repositori แยกต่างหาก
การวางฐานข้อมูลใน repo ของตัวเอง (เช่น `NamaKamu/ANUI-Keys`) ทำให้ token ในหน้า generator ไม่สามารถเข้าถึง source library ของคุณ นี่เป็นขั้นตอนป้องกันที่มีค่ามากที่สุดในการตั้งค่านี้
:::

### 2. สร้าง token

บน GitHub: **Settings → Developer settings → Personal access tokens → Fine-grained tokens**

| การตั้งค่า | ค่า |
| --- | --- |
| ประเภท | **Fine-grained**, ไม่ใช่ classic |
| การเข้าถึง repositori | เฉพาะ repo ฐานข้อมูล key |
| Permission | **Contents → Read and write**, ไม่มีอย่างอื่น |
| หมดอายุ | สั้นที่สุดที่คุณยอมรับได้ แล้วหมุนเวียน |

### 3. สร้าง config generator

```bash
node build/keygen-config.js
```

Prompt รวม repositori, รูปแบบ key, ระยะเวลา, cooldown, และ branding; token และ HMAC secret พิมพ์แบบซ่อนและไม่เคยแสดง สคริปต์นี้เขียน `docs/public/getkey/config.js` และพิมพ์ HMAC secret พร้อมบล็อก `KeySystem` ที่พร้อมวาง

แบบไม่โต้ตอบ, สำหรับ CI:

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
| `--site-url` | `ANUI_SITE_URL` | ได้มาจาก owner และ repo |
| `--token` | `ANUI_GH_TOKEN` | ถาม, ซ่อน |
| `--secret` | `ANUI_HMAC_SECRET` | ถาม, ซ่อน (generate ถ้าว่าง) |

### 4. Deploy หน้าเว็บ

Generator อยู่ที่ `docs/public/getkey/` ซึ่งถูกคัดลอกตรงๆ โดย VitePress ดังนั้นหลังจากเอกสารถูกเผยแพร่หน้าเว็บสามารถเข้าถึงได้ที่:

```
https://<owner>.github.io/<repo>/getkey/
```

### 5. เชื่อมต่อกับสคริปต์ของคุณ

```lua
ANUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Generate key สำหรับอุปกรณ์นี้ มีอายุ 24 ชั่วโมง",
        SaveKey = true,
        API = {
            {
                Type = "github",
                Owner = "ANHub-Script",
                Repo = "ANUI-Keys",
                Branch = "main",
                DBPath = "db/keys.json",
                URL = "https://anhub-script.github.io/ANUI/getkey/",
                Secret = "secret-ที่-keygen-config-พิมพ์",
            },
        },
    },
})
```

`Secret` ต้องตรงกับ HMAC secret ใน config generator มิฉะนั้น key ทั้งหมดจะไม่ผ่านการตรวจสอบลายเซ็น

## อาร์กิวเมนต์ผู้ให้บริการ

| Field | Type | Default | คำอธิบาย |
| --- | --- | --- | --- |
| `Type` | `string` | — | ต้องเป็น `"github"` |
| `Owner` | `string` | — | User หรือ organization เจ้าของ repo ฐานข้อมูล |
| `Repo` | `string` | — | Repositori ที่เก็บฐานข้อมูล |
| `Branch` | `string` | `"main"` | Branch ที่อ่าน |
| `DBPath` | `string` | `"db/keys.json"` | Path ฐานข้อมูลใน repo |
| `URL` | `string` | — | URL สาธารณะของหน้า generator **Get key** คัดลอกมันพร้อมเพิ่ม `#fp=<fingerprint>` |
| `Secret` | `string` | — | HMAC secret เว้นว่างเพื่อข้ามการตรวจสอบลายเซ็น (ไม่แนะนำ) |
| `Folder` | `string` | `Folder` window | กรอกอัตโนมัติโดย ANUI; กำหนดตำแหน่งเขียน cache offline |

`Icon`, `Title`, และ `Desc` ทำงานเหมือนผู้ให้บริการอื่นและมีผลเฉพาะแถวของมันใน dropdown **Get key**

## สิ่งที่ผู้เล่นเห็น

1. เปิดเมนู — prompt key ปรากฏ
2. กด **Get key** แล้วเลือกแถวผู้ให้บริการ Link ที่มี fingerprint อุปกรณ์นี้ถูกคัดลอกไปยัง clipboard
3. เปิดในเบราว์เซอร์, กด **Generate key**, คัดลอก key
4. วางใน prompt

ด้วย `SaveKey = true`, key ที่ได้รับถูกเขียนไปยัง `ANUI/<Folder>/<hwid>.key` ดังนั้น prompt ถูกข้ามในการเปิดครั้งถัดไปจนกว่า key จะหมดอายุ

## การตรวจสอบ

Library ตรวจสอบ key ออนไลน์ก่อน:

1. `GET https://raw.githubusercontent.com/<owner>/<repo>/<branch>/<path>?cb=<unik>` — cache buster เอาชนะ cache CDN ที่คงอยู่หลายนาที และนี่คือสิ่งที่ทำให้การอ่านเป็นแบบเรียลไทม์
2. ค้นหา `keys[<fingerprint>]` ไม่มีรายการ, หรือ `revoked`, หมายความว่าอุปกรณ์นี้ไม่มี key
3. เปรียบเทียบ key ที่ป้อนกับที่เก็บไว้ — key ที่ generate ใหม่แล้วจะไม่ผ่านที่นี่
4. ตรวจสอบลายเซ็น, แล้วหมดอายุเทียบกับ header `Date` จาก GitHub

หากสำเร็จ, ผลลัพธ์ถูกแคชใน `ANUI/<Folder>/<fingerprint>.keycache` Cache นี้เป็นเพียงสำรองเมื่อ request HTTP เองล้มเหลว: มันไม่เคยสามารถยืนยัน key ที่ยังไม่ได้รับการยืนยันจากเซิร์ฟเวอร์, ไม่เคยมีชีวิตเกิน `expires_at`, และถูกลบในทุกการปฏิเสธจากเซิร์ฟเวอร์

## รูปแบบฐานข้อมูล

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

| Field | ความหมาย |
| --- | --- |
| `key` | Key ที่ผู้เล่นวาง หนึ่งต่ออุปกรณ์ — key ใหม่เขียนทับมัน |
| `sig` | `HMAC-SHA256(secret, "key\|fingerprint\|issued_at\|expires_at")[0..31]` |
| `issued_at` / `expires_at` | Unix seconds, นำมาจากนาฬิกา GitHub |
| `regen` | กี่ครั้งแล้วที่อุปกรณ์นี้ generate key |
| `revoked` | ตั้งเป็น `true` ด้วยมือเพื่อบล็อกอุปกรณ์โดยไม่ลบประวัติ |

Key ใช้ตัวอักษร `0123456789ABCDEFGHJKMNPQRSTVWXYZ` — ไม่มี `I`, `L`, `O`, หรือ `U` — ดังนั้น key ที่อ่านออกเสียงจะไม่คลุมเครือ

::: tip การตัดทอน
Record ที่หมดอายุไม่เป็นอันตราย, แต่ไฟล์จะใหญ่ขึ้น ลบรายการเก่าได้ทุกเมื่อ; Contents API หยุดรวมเนื้อหาไฟล์เกินประมาณ 1 MB, และ generator จะแจ้งให้คุณทราบหากคุณไปถึงจุดนั้น
:::

## ความปลอดภัย

::: danger Token เป็นสาธารณะ
GitHub Pages เป็นโฮสติ้งแบบสแตติก Token ใน `config.js` ถูกส่งไปยังเบราว์เซอร์ทุกผู้เยี่ยมชม การสุ่มในไฟล์นั้นมีเพื่อป้องกัน secret scanner GitHub เพิกถอน token โดยอัตโนมัติและเพื่อขัดขวางการคัดลอกวางแบบสุ่มเลอะ — **มันไม่ใช่การเข้ารหัส** ใครก็ตามที่อ่านไฟล์นั้นสามารถกู้คืน token, แล้วออก key เองหรือเขียนไปยังสิ่งใดก็ตามที่ token นั้นเข้าถึงได้

ด้วยเหตุนี้:

- ใช้ token **fine-grained**, จำกัดเฉพาะ repo key, กับ **Contents → Read and write** เป็น permission เดียว
- เก็บฐานข้อมูลใน **repositori แยกต่างหาก** จาก source library ของคุณ
- กำหนดวันหมดอายุและหมุนเวียน token
- ถือว่านี่เป็น *สิ่งกีดขวางการรบกวน*, ไม่ใช่เซิร์ฟเวอร์ลิขสิทธิ์
:::

หากต่อมาคุณต้องการการตั้งค่าที่แท้จริงไม่สามารถถูกแฮ็ก, ย้ายเส้นทางเขียนไปยัง proxy เล็ก — Cloudflare Worker หรือ GitHub Action `repository_dispatch` — แล้วลบ token ออกจาก `config.js` ไม่มีอะไรเปลี่ยนแปลงใน library Lua: มันเพียงแค่อ่านฐานข้อมูล

HMAC secret ถูกส่งในไฟล์เดียวกันและสามารถกู้คืนได้เช่นกัน คุณค่าของมันคือฐานข้อมูลไม่สามารถแก้ไขด้วยมือโดยไม่ทำให้รายการไม่ถูกต้อง, และนั่นคือสิ่งที่ป้องกัน record ที่ถูกขโมยหรือทำด้วยมือผ่านการตรวจสอบ

## การแก้ไขปัญหา

| อาการ | สาเหตุ |
| --- | --- |
| หน้าเว็บแสดง *Generator not configured* | `config.js` ยังเป็นไฟล์ตัวอย่าง รัน `node build/keygen-config.js` |
| *the token is invalid or expired* | Token ถูกเพิกถอน, หมดอายุ, หรือถูกจับโดย scanning GitHub สร้างใหม่ |
| *the token lacks Contents: read and write* | Permission ผิดหรือ token ไม่ได้จำกัดไว้ที่ repositori นั้น |
| *the repository, branch or path does not exist* | ตรวจสอบ `owner`, `repo`, `branch`, และ `dbPath`; token fine-grained ไม่สามารถเห็น repo นอกขอบเขต |
| *Signature mismatch* บนหน้าเว็บ | ฐานข้อมูลถูกแก้ไขนอกหน้าเว็บ, หรือ secret เปลี่ยน Generate ใหม่ |
| *Key signature is invalid* ในเกม | `Secret` ในสคริปต์ของคุณต่างจาก secret generator |
| *No key issued for this device yet* | อุปกรณ์ยังไม่มี record กด **Get key**, generate, วาง |
| Key ยังถูกปฏิเสธทันทีหลัง generate | Library อ่านสำเนาแคช — กด submit อีกครั้ง; การอ่านมี cache buster และเรียบร้อยในไม่กี่วินาที |
| ไม่มีอะไรเกิดขึ้นในเกม | Executor ไม่มี `request`/`gethwid` ทั้งสองจำเป็น |

## ดูเพิ่มเติม

- [ระบบ Key](/th/features/key-system) — การกำหนดค่า `KeySystem` โดยรอบและผู้ให้บริการอื่นๆ
- [การกำหนดค่า Window](/th/guide/window-configuration) — ที่ `KeySystem` และ `Folder` ถูกตั้งค่า




