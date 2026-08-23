-- [[ SCHEDULER ]] --
-- Penjadwal loop terpusat: satu thread runner untuk SEMUA loop, bukan satu
-- task.spawn per loop. Dipakai lewat Window:Loop() / Window:StatusLoop().
--
-- Kenapa satu runner:
--   * 40+ loop aktif tidak jadi 40+ thread yang bangun sendiri-sendiri
--   * runner tidur tepat sampai loop terdekat jatuh tempo (GetSleep)
--   * begitu window mati, semua loop ikut mati (ShouldStop)
--
-- Modul ini sengaja tanpa dependency (tidak require Creator) supaya bebas
-- dipakai di luar window juga: Scheduler.new({ ShouldStop = ..., IsReady = ... })

local DEFAULT_MIN_WAIT  = 0.01
local DEFAULT_IDLE_WAIT = 0.05

local Scheduler = {}
Scheduler.__index = Scheduler

-- Config:
--   ShouldStop : function() -> boolean  -- true = bunuh runner + buang semua loop
--   IsReady    : function() -> boolean  -- gate untuk loop ber-requireReady
--   MinWait    : number (default 0.01)  -- interval terkecil yang diizinkan
--   IdleWait   : number (default 0.05)  -- tidur maksimum saat tidak ada yang jatuh tempo
function Scheduler.new(Config)
    Config = Config or {}

    return setmetatable({
        Loops        = {},
        Connections  = {},
        RunnerActive = false,

        MinWait  = tonumber(Config.MinWait)  or DEFAULT_MIN_WAIT,
        IdleWait = tonumber(Config.IdleWait) or DEFAULT_IDLE_WAIT,

        ShouldStopFunction = Config.ShouldStop,
        IsReadyFunction    = Config.IsReady,
    }, Scheduler)
end

function Scheduler:SetMinWait(Value)
    self.MinWait = tonumber(Value) or DEFAULT_MIN_WAIT
    return self.MinWait
end

function Scheduler:SetIdleWait(Value)
    self.IdleWait = tonumber(Value) or DEFAULT_IDLE_WAIT
    return self.IdleWait
end

function Scheduler:ShouldStop()
    if self.ShouldStopFunction then
        local ok, result = pcall(self.ShouldStopFunction)
        return ok and result and true or false
    end
    return false
end

function Scheduler:IsReady()
    if self.IsReadyFunction then
        local ok, result = pcall(self.IsReadyFunction)
        return ok and result and true or false
    end
    return true
end

function Scheduler:NormalizeInterval(Interval)
    return math.max(tonumber(Interval) or self.MinWait, self.MinWait)
end

-- Berapa lama runner boleh tidur: sampai loop terdekat jatuh tempo, dibatasi
-- [MinWait, IdleWait]. Kalau tidak ada jadwal sama sekali -> IdleWait.
function Scheduler:GetSleep(Now)
    local NextDelay = nil

    for _, Current in pairs(self.Loops) do
        if Current and Current.nextRunAt then
            local Remaining = Current.nextRunAt - Now
            if Remaining <= 0 then
                return self.MinWait
            end
            if not NextDelay or Remaining < NextDelay then
                NextDelay = Remaining
            end
        end
    end

    if not NextDelay then
        return self.IdleWait
    end

    return math.clamp(NextDelay, self.MinWait, self.IdleWait)
end

function Scheduler:EnsureRunner()
    if self.RunnerActive then
        return
    end
    self.RunnerActive = true

    task.spawn(function()
        while self.RunnerActive do
            if self:ShouldStop() then
                table.clear(self.Loops)
                self.RunnerActive = false
                break
            end

            local HasActiveLoop = false
            local Now = os.clock()
            local Due = nil

            for _, Current in pairs(self.Loops) do
                if Current then
                    HasActiveLoop = true
                    if Now >= (Current.nextRunAt or 0) then
                        -- Jadwalkan tembakan berikutnya dari TARGET, bukan dari waktu selesai
                        -- callback. Ini menghilangkan drift: periode = interval, bukan
                        -- interval + durasi kerja callback.
                        local Interval = self:NormalizeInterval(Current.interval)
                        Current.interval = Interval

                        local Base = Current.nextRunAt
                        if not Base or Base <= 0 then Base = Now end
                        Current.nextRunAt = Base + Interval

                        if Current.nextRunAt <= Now then
                            -- Tertinggal lebih dari satu periode: sinkronkan ulang tanpa
                            -- menembak beruntun (mis. setelah lag / frame berat).
                            Current.nextRunAt = Now + Interval
                        end

                        Due = Due or {}
                        Due[#Due + 1] = Current
                    end
                end
            end

            -- Dispatch dilakukan SETELAH iterasi pairs() selesai supaya callback bebas
            -- memanggil Start/Stop tanpa merusak iterasi, dan dijalankan lewat
            -- task.spawn supaya callback yang yield/berat tidak menahan runner ini maupun
            -- menggeser jadwal loop lain. Flag `busy` mencegah tumpang-tindih instance
            -- callback yang sama bila durasinya melebihi interval.
            if Due then
                for _, Current in ipairs(Due) do
                    local ShouldRun = true
                    if Current.predicate then
                        local ok, result = pcall(Current.predicate)
                        ShouldRun = ok and result or false
                    end
                    if ShouldRun and not Current.busy then
                        Current.busy = true
                        task.spawn(function()
                            pcall(Current.callback)
                            Current.busy = false
                        end)
                    end
                end
            end

            if not HasActiveLoop then
                self.RunnerActive = false
                break
            end

            task.wait(self:GetSleep(os.clock()))
        end
    end)
end

function Scheduler:Stop(Key)
    self.Loops[Key] = nil
end

function Scheduler:StopAll()
    table.clear(self.Loops)
end

function Scheduler:IsRunning(Key)
    return self.Loops[Key] ~= nil
end

function Scheduler:GetActiveCount()
    local Count = 0
    for _ in pairs(self.Loops) do
        Count += 1
    end
    return Count
end

-- Loop mentah: predicate dipanggil tiap kali jatuh tempo, callback hanya jalan
-- kalau predicate mengembalikan true. Key sama = loop lama diganti.
function Scheduler:Start(Key, Interval, Predicate, Callback)
    self:Stop(Key)

    local Token = {
        interval  = self:NormalizeInterval(Interval),
        predicate = Predicate,
        callback  = Callback,
        nextRunAt = 0,
    }

    self.Loops[Key] = Token
    self:EnsureRunner()

    return Token
end

-- Loop dengan opsi:
--   requireReady / requireWindowReady : hanya jalan kalau IsReady() true
--   predicate                         : syarat tambahan dari pemanggil
function Scheduler:Loop(Key, Interval, Callback, Options)
    Options = Options or {}
    local RequireReady = Options.requireReady or Options.requireWindowReady

    return self:Start(Key, Interval, function()
        if RequireReady and (not self:IsReady()) then
            return false
        end
        if Options.predicate then
            return Options.predicate()
        end
        return true
    end, Callback)
end

-- Loop khusus update tampilan: otomatis berhenti saat window belum siap
-- (tertutup / sudah dihancurkan), supaya tidak buang kerja menulis ke UI mati.
function Scheduler:StatusLoop(Key, Interval, Callback)
    return self:Loop(Key, Interval, Callback, {
        requireReady = true,
    })
end

-- [[ CONNECTIONS ]] --
-- Titipkan RBXScriptConnection di sini supaya ikut diputus saat Destroy().

function Scheduler:AddConnection(Connection)
    table.insert(self.Connections, Connection)
    return Connection
end

function Scheduler:DisconnectAll()
    for _, Connection in ipairs(self.Connections) do
        pcall(function() Connection:Disconnect() end)
    end
    self.Connections = {}
end

function Scheduler:Destroy()
    self.RunnerActive = false
    self:StopAll()
    self:DisconnectAll()
end

return Scheduler
