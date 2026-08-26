# การติดตั้ง

ANUI ติดตั้งด้วยเพียงหนึ่งบรรทัด — ไม่ต้องดาวน์โหลด, ไม่มี dependencies วางที่ด้านบนของ script ของคุณและคุณพร้อมสร้าง

## การติดตั้ง

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

### บรรทัดนี้ทำอะไรบ้าง

- `game:HttpGet(url)` ดาวน์โหลด source ANUI ล่าสุดจาก GitHub เป็น string
- `loadstring(...)` คอมไพล์ string นั้นเป็นฟังก์ชันที่รันได้
- `()` ท้ายสุดเรียกมัน, แล้วคืนค่าตารางไลบรารี ANUI
- ผลลัพธ์ถูกเก็บใน local ชื่อ `ANUI` — ทุกตัวอย่างในเว็บไซต์นี้เรียก method บนตัวแปรนี้ (`ANUI:CreateWindow`, `ANUI:Notify` และอื่นๆ)

::: tip Cache-busting ระหว่างการพัฒนา
Executor บางตัวแคชการตอบสนอง `HttpGet`, ดังนั้นคุณอาจได้ build เก่าอยู่เรื่อยยๆ ขณะพัฒนา เพิ่ม query string แบบสุ่มเพื่อบังคับสำเนาล่าสุด:

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v="..math.random()))()
```

ลบส่วน `?v=`... สำหรับ production เพื่อให้การตอบสนองสามารถแคชตามปกติ
:::

## ตรวจสอบว่าโหลดแล้ว

พิมพ์เวอร์ชันเพื่อตรวจสอบว่าไลบรารีพร้อมใช้งาน:

```lua
print(ANUI.Version)
```

ถ้าแสดง string เวอร์ชัน, แสดงว่า ANUI โหลดสำเร็จ

::: warning ความต้องการของ executor
ANUI ต้องการ executor ที่รองรับ `loadstring` และ `game:HttpGet`

การจัดเก็บการตั้งค่าและตัวเลือก `SaveKey` บนระบบ key ต้องการ file functions ระดับ global `readfile`, `writefile`, `isfile` และ `makefolder` ถ้าไม่มี, UI ยังทำงานได้ — เพียงแต่การบันทึกลงดิสก์ไม่พร้อมใช้งาน
:::

## การแก้ไขปัญหา

::: details ANUI เป็น `nil` / "attempt to call a nil value"
`loadstring` หรือ `HttpGet` ไม่คืนค่าอะไร ตรวจสอบว่า executor ของคุณรองรับทั้งสอง, และไม่บล็อกโดเมน `raw.githubusercontent.com` รันใหม่หลังจากเพิ่ม query cache-busting `?v=` ตามด้านบน
:::

::: details HttpGet ถูกปิดใช้งาน / request ล้มเหลว
Executor บางตัวกำหนดค่า request HTTP ผ่านการตั้งค่า เปิดใช้งาน HTTP / HttpGet ใน executor ของคุณ, แล้วรัน script อีกครั้ง
:::

::: details ไม่มีอะไรปรากฏบนหน้าจอ
การโหลดไลบรารีเพียงอย่างเดียวไม่แสดงอะไร ตรวจสอบว่าคุณสร้าง window จริงๆ — ดู [เริ่มใช้งานด่วน](/th/guide/getting-started)
:::

---

ถัดไป: [เริ่มใช้งานด่วน](/th/guide/getting-started)
