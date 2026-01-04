local MainController = nil

print("========== ANHub: DIRECT MODULE STEAL ==========")

-- 1. Akses Module Reply secara langsung lewat Path
-- Berdasarkan gambar decompiled kamu: game:GetService("ReplicatedFirst").Scripts["Reply.client"]
local ReplyPath = game:GetService("ReplicatedFirst").Scripts:FindFirstChild("Reply.client")

if not ReplyPath then 
    return warn("❌ File Reply.client tidak ditemukan di ReplicatedFirst.Scripts") 
end

-- 2. Require module-nya
-- Karena module ini sudah dijalankan game (via Init.client), require ini akan memberi kita
-- akses ke TABLE YANG SAMA yang sedang dipakai game.
local ReplyModule = require(ReplyPath)

-- 3. Curi penyimpanan Listener lewat fungsi .Connect
-- Di kode Reply.client baris 58: function module.Connect(...) menggunakan upvalue 'tbl_3_upvr' (penyimpanan listener)
if ReplyModule and ReplyModule.Connect then
    -- Biasanya upvalue ke-1 adalah tabel listener (tbl_3_upvr)
    local Listeners = debug.getupvalue(ReplyModule.Connect, 1)
    
    -- Validasi: Pastikan yang kita ambil adalah tabel
    if type(Listeners) ~= "table" then
        -- Jika urutan upvalue berubah, kita cari manual
        for i, v in pairs(debug.getupvalues(ReplyModule.Connect)) do
            if type(v) == "table" and v["Data Sync Setup"] then -- Ciri khas: ada key "Data Sync Setup"
                Listeners = v
                break
            end
        end
    end

    -- 4. Ambil MainController dari Listener "Data Sync Setup"
    if Listeners and Listeners["Data Sync Setup"] then
        print(">> Listener 'Data Sync Setup' ditemukan!")
        
        -- Listener disimpan dalam format: {[function] = true}
        for func, _ in pairs(Listeners["Data Sync Setup"]) do
            if type(func) == "function" then
                -- Fungsi ini adalah anonim di DataSync.c yang menyimpan MainController
                -- Kita bongkar upvalue fungsi ini
                local upvals = debug.getupvalues(func)
                for _, val in pairs(upvals) do
                    -- Cari tabel yang punya struktur MainController
                    if type(val) == "table" and rawget(val, "Data") and rawget(val, "SyncChanged") then
                        MainController = val
                        print("\n🎉 SUKSES! MainController berhasil dicuri via require direct!")
                        break
                    end
                end
            end
            if MainController then break end
        end
    else
        warn("⚠️ Listener 'Data Sync Setup' belum terdaftar. Tunggu game loading sebentar.")
    end
else
    warn("❌ Gagal mendapatkan fungsi Connect dari Reply module.")
end

local function JSONPretty(val, indent)
    indent = indent or 0;
    local valType = type(val);
    if valType == "table" then
        local s = "{\n";
        for k, v in pairs(val) do
            local formattedKey = type(k) == "number" and tostring(k) or "\"" .. tostring(k) .. "\"";
            s = s .. string.rep("    ", indent + 1) .. formattedKey .. ": " .. JSONPretty(v, indent + 1) .. ",\n";
        end;
        return s .. string.rep("    ", indent) .. "}";
    elseif valType == "string" then
        return "\"" .. val .. "\"";
    else
        return tostring(val);
    end;
end;

-- CONTOH PENGGUNAAN
if MainController then
    print(">> Data Player:", MainController.Data)
    setclipboard(JSONPretty(MainController.Data,1))
    -- Code fitur kamu di sini...
end