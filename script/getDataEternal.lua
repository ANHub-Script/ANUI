local ReplicaController = require(game:GetService("ReplicatedStorage").Common.ReplicatedService.ReplicaController)
local getupvalues = debug.getupvalues or getupvalues

-- Kita mencari tabel '_replicas' (v_u_22) di dalam fungsi GetReplicaById
local replicas = {}
for _, v in pairs(getupvalues(ReplicaController.GetReplicaById)) do
    if type(v) == "table" and not v.GetReplicaById then
        replicas = v
        break
    end
end

-- Menampilkan semua Replica yang terdaftar
for id, replica in pairs(replicas) do
    print("---------------------------------------")
    print("ID:", id)
    print("Class:", replica.Class)
    print("Data:", replica.Data) -- Ini adalah tabel informasi game-nya
    
    -- Contoh: Jika ingin melihat isi tabel data lebih detail
    for key, val in pairs(replica.Data) do
        print("  - " .. tostring(key) .. ": " .. tostring(val))
    end
end