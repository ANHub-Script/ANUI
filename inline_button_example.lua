-- ============================================================================
-- ANUI — Contoh lengkap INLINE BUTTON di dalam Title / Desc
-- ============================================================================
--
-- SATU ATURAN YANG MENJELASKAN SEMUANYA:
--
--     Desc hanya menentukan POSISI (dan opsional LABEL).
--     Callback-nya SELALU hidup di tabel `Buttons`.
--
-- Jadi "<button=sell>Sell</button>" di dalam Desc bukan definisi button — itu
-- cuma penanda tempat yang berkata "di sini taruh button dengan key `sell`".
-- Isinya dicari di Element.Buttons. Kalau key-nya tidak ketemu di sana, segmen
-- itu DIBUANG tanpa error: tidak muncul teks mentah, tidak ada warning, hilang
-- begitu saja. (Sengaja — mengikuti perilaku token ikon {icon:...} tanpa sumber.)
--
-- Itu juga jawaban untuk pertanyaan paling sering: "kenapa button saya tidak
-- muncul setelah SetDesc?" — lihat tab "SetDesc" di bawah.
-- ============================================================================

local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v=" .. math.random()))()

local Window = ANUI:CreateWindow({
	Title = "Inline Button — Semua Contoh",
	Author = "ANUI Library",
	Folder = "anui_inline_button",
	Icon = "square-mouse-pointer",
	NewElements = true,
})

Window:Tag({ Title = "v" .. ANUI.Version, Icon = "github" })

local function Notify(title, content, icon)
	ANUI:Notify({ Title = title, Content = content, Icon = icon or "info", Duration = 3 })
end

-- ============================================================================
-- 1. SINTAKS — tiga bentuk, boleh dicampur dalam satu Desc
-- ============================================================================

do
	local Tab = Window:Tab({ Title = "1. Sintaks", Icon = "code" })

	Tab:Paragraph({
		Title = "Tiga bentuk penulisan",
		Desc = "Semuanya menghasilkan button yang sama. Bedanya cuma di mana label-nya ditulis dan bagaimana key-nya ditentukan.",
	})
	Tab:Space()

	-- ---- Bentuk A: TAG — label ditulis langsung di dalam Desc ----
	Tab:Toggle({
		Title = "Bentuk A — Tag",
		Desc = "Click di sebelah kanan ini untuk sell <button=sell>Sell</button>",
		Buttons = {
			sell = {
				Icon = "coins",
				Callback = function()
					Notify("Bentuk A", "Tombol Sell ditekan", "coins")
				end,
			},
		},
		Callback = function(v) print("Toggle A:", v) end,
	})
	Tab:Space()

	-- ---- Bentuk B: TOKEN — label diambil dari Buttons.<key>.Title ----
	Tab:Toggle({
		Title = "Bentuk B — Token",
		Desc = "Label datang dari tabel Buttons, bukan dari Desc {button:sell}",
		Buttons = {
			sell = {
				Title = "Sell All",
				Icon = "coins",
				Callback = function()
					Notify("Bentuk B", "Label-nya dari Buttons.sell.Title", "coins")
				end,
			},
		},
		Callback = function(v) print("Toggle B:", v) end,
	})
	Tab:Space()

	-- ---- Bentuk C: TANPA KEY — dinomori otomatis sesuai urutan kemunculan ----
	Tab:Toggle({
		Title = "Bentuk C — Tanpa key (auto-order)",
		Desc = "Mau {button} atau {button}? Nomor mengikuti urutan kemunculan di teks.",
		Buttons = {
			{ Title = "Beli", Icon = "shopping-cart", Callback = function() Notify("Auto #1", "Beli") end },
			{ Title = "Jual", Icon = "coins",         Callback = function() Notify("Auto #2", "Jual") end },
		},
		Callback = function(v) print("Toggle C:", v) end,
	})
	Tab:Space()

	-- ---- Campuran ----
	Tab:Toggle({
		Title = "Campur semuanya",
		Desc = "Tag <button=a>A</button>, token {button:b}, dan tanpa key {button} boleh berdampingan.",
		Buttons = {
			a = { Callback = function() Notify("Campur", "tag A") end },
			b = { Title = "B", Callback = function() Notify("Campur", "token B") end },
			-- {button} tanpa key mengambil Buttons[1]
			{ Title = "C", Callback = function() Notify("Campur", "auto C") end },
		},
		Callback = function(v) print("Campur:", v) end,
	})
	Tab:Space()

	-- ---- Alias & shorthand ----
	Tab:Toggle({
		Title = "Alias & bentuk singkat",
		Desc = "{btn:x} adalah alias {button:x}. Entri Buttons juga boleh berupa function telanjang.",
		Buttons = {
			-- function telanjang = { Callback = fn }
			-- Title-nya otomatis memakai nama key-nya: "x"
			x = function() Notify("Shorthand", "Buttons.x = function") end,
		},
		Callback = function(v) print("Alias:", v) end,
	})
	Tab:Space()

	Tab:Paragraph({
		Title = "Key tidak ketemu = segmen dibuang",
		Desc = "Toggle di bawah ini Desc-nya berisi <button=tidak-ada>X</button> tapi Buttons-nya kosong. Perhatikan: tidak muncul teks mentah, tidak muncul error — segmennya hilang.",
	})
	Tab:Toggle({
		Title = "Key tidak ada di Buttons",
		Desc = "Di antara dua tanda kurung ini [<button=tidak-ada>X</button>] seharusnya kosong.",
		Buttons = {},
		Callback = function(v) print("Missing key:", v) end,
	})
end

-- ============================================================================
-- 2. ATRIBUT — variant, warna, ukuran, ikon, locked, precedence
-- ============================================================================

do
	local Tab = Window:Tab({ Title = "2. Atribut", Icon = "sliders-horizontal" })

	Tab:Paragraph({
		Title = "Variant",
		Desc = "Primary (default) = pill solid warna tema. Secondary = transparan + ring outline. Ghost = tanpa background.",
	})
	Tab:Toggle({
		Title = "Tiga variant",
		Desc = "{button:p}  {button:s}  {button:g}",
		Buttons = {
			p = { Title = "Primary",   Variant = "Primary",   Callback = function() Notify("Variant", "Primary") end },
			s = { Title = "Secondary", Variant = "Secondary", Callback = function() Notify("Variant", "Secondary") end },
			g = { Title = "Ghost",     Variant = "Ghost",     Callback = function() Notify("Variant", "Ghost") end },
		},
		Callback = function(v) print("Variant:", v) end,
	})
	Tab:Space()

	Tab:Paragraph({
		Title = "Warna custom",
		Desc = "Color mengalahkan Variant. Warna teks dihitung otomatis supaya tetap kontras (Creator.GetContrastTextColor), jadi background terang dapat teks gelap dan sebaliknya.",
	})
	Tab:Toggle({
		Title = "Warna custom + auto-kontras",
		Desc = "{button:merah} {button:kuning} {button:biru} {button:paksa}",
		Buttons = {
			merah  = { Title = "Danger",  Color = Color3.fromHex("#e11d48"), Callback = function() end },
			kuning = { Title = "Warning", Color = Color3.fromHex("#facc15"), Callback = function() end },
			biru   = { Title = "Info",    Color = Color3.fromHex("#2563eb"), Callback = function() end },
			-- TextColor eksplisit mengalahkan auto-kontras
			paksa  = { Title = "Paksa",   Color = Color3.fromHex("#facc15"), TextColor = Color3.new(1, 0, 0), Callback = function() end },
		},
		Callback = function(v) print("Warna:", v) end,
	})
	Tab:Space()

	Tab:Paragraph({
		Title = "Atribut inline",
		Desc = "Semua field spec bisa di-override langsung di dalam tag/token. Nilai berkutip didukung, jadi label bisa mengandung spasi.",
	})
	Tab:Toggle({
		Title = "Override lewat atribut",
		Desc = 'Default {button:a} • ganti teks <button=a text="Sell All">x</button> • ghost <button=a variant=Ghost>Ghost</button> • besar <button=a size=30 textsize=16>Besar</button> • kotak <button=a radius=6>Kotak</button>',
		Buttons = {
			a = { Title = "A", Icon = "coins", Callback = function(btn) Notify("Atribut", "ditekan: " .. tostring(btn.Key)) end },
		},
		Callback = function(v) print("Atribut:", v) end,
	})
	Tab:Space()

	Tab:Paragraph({
		Title = "Daftar atribut & alias",
		Desc = table.concat({
			"text / title / label      -> Title",
			"icon                      -> Icon (lucide, rbxassetid://, URL)",
			"variant / style           -> Primary | Secondary | Ghost",
			"color / colour / bg       -> warna background (#hex atau nama Creator.Colors)",
			"textcolor / fg            -> warna teks",
			"size / h / height         -> tinggi (default 22)",
			"w / width                 -> lebar paksa (default: menyesuaikan isi)",
			"radius / r                -> radius (default 999 = pill)",
			"textsize / ts             -> ukuran teks (default 13)",
			"iconsize                  -> ukuran ikon (default 14)",
			"padding / pad             -> padding kiri/kanan (default 8)",
			"locked / disabled         -> true/false, 1/0, yes/no, on/off",
		}, "\n"),
	})
	Tab:Space()

	Tab:Paragraph({
		Title = "Precedence (yang belakangan menang)",
		Desc = "tabel Buttons  ->  label di dalam tag  ->  atribut inline\n\nJadi <button=a text=\"X\">Y</button> menghasilkan judul X, bukan Y.",
	})
	Tab:Toggle({
		Title = "Bukti precedence",
		Desc = 'Buttons.Title="DariTabel" • tag saja <button=a>DariTag</button> • tag+atribut <button=a text="DariAtribut">DariTag</button>',
		Buttons = {
			a = { Title = "DariTabel", Callback = function(btn) Notify("Precedence", btn:IsLocked() and "locked" or "ok") end },
		},
		Callback = function(v) print("Precedence:", v) end,
	})
	Tab:Space()

	Tab:Paragraph({
		Title = "Ikon di dalam button",
		Desc = "Icon menerima nama lucide, rbxassetid://, atau URL — sama seperti Icon di element lain.",
	})
	Tab:Toggle({
		Title = "Macam-macam ikon",
		Desc = "{button:lucide} {button:asset} {button:only}",
		Buttons = {
			lucide = { Title = "Lucide", Icon = "coins", Callback = function() end },
			asset  = { Title = "Asset",  Icon = "rbxassetid://84366761557806", Callback = function() end },
			-- Title kosong = ikon saja (pakai spasi supaya tidak jatuh ke nama key)
			only   = { Title = " ",      Icon = "trash-2", Variant = "Secondary", Callback = function() end },
		},
		Callback = function(v) print("Ikon:", v) end,
	})
	Tab:Space()

	Tab:Toggle({
		Title = "Locked per button",
		Desc = "Aktif {button:on} • terkunci lewat spec {button:off} • terkunci lewat atribut <button=on locked=true>Locked</button>",
		Buttons = {
			on  = { Title = "Bisa",     Callback = function() Notify("Locked", "yang ini jalan") end },
			off = { Title = "Terkunci", Locked = true, Callback = function() Notify("Locked", "TIDAK boleh muncul") end },
		},
		Callback = function(v) print("Locked:", v) end,
	})
end

-- ============================================================================
-- 3. SetDesc — kasus "Desc awalnya belum punya inline button"
-- ============================================================================

do
	local Tab = Window:Tab({ Title = "3. SetDesc", Icon = "pencil" })

	Tab:Paragraph({
		Title = "Masalahnya",
		Desc = "Karena Callback hidup di Element.Buttons, menambahkan <button=...> lewat SetDesc SAJA tidak cukup. Kalau elemennya dibuat tanpa Buttons, token-nya tidak bisa di-resolve dan segmennya dibuang diam-diam.",
	})
	Tab:Space()

	-- ---- ❌ SALAH ----
	local Salah = Tab:Toggle({
		Title = "❌ SALAH — dibuat tanpa Buttons",
		Desc = "Sedang mencari item...",
		-- tidak ada Buttons di sini
		Callback = function(v) print("Salah:", v) end,
	})
	Tab:Button({
		Title = "SetDesc + tag button",
		Desc = "Desc-nya berubah, tapi tombolnya HILANG",
		Icon = "triangle-alert",
		Callback = function()
			Salah:SetDesc("Ketemu! <button=sell>Sell</button>")
			Notify("Perhatikan", "Teksnya ganti, tombolnya tidak muncul", "triangle-alert")
		end,
	})
	Tab:Space()

	-- ---- ✅ CARA A: deklarasikan Buttons sejak awal ----
	Tab:Paragraph({
		Title = "✅ Cara A — deklarasikan Buttons sejak awal",
		Desc = "Paling disarankan. Buttons hanyalah kamus spec; entri yang tidak dirujuk Desc tidak dirender, jadi tidak masalah kalau Desc awal belum memakainya.",
	})
	local CaraA = Tab:Toggle({
		Title = "Cara A",
		Desc = "Sedang mencari item...",
		Buttons = {
			-- didaftarkan duluan walau Desc awal belum pakai
			sell = { Icon = "coins", Callback = function() Notify("Cara A", "Sell jalan") end },
		},
		Callback = function(v) print("Cara A:", v) end,
	})
	Tab:Button({
		Title = "SetDesc saja — langsung muncul",
		Icon = "check",
		Callback = function()
			CaraA:SetDesc("Ketemu 12 item! <button=sell>Sell All</button>")
		end,
	})
	Tab:Button({
		Title = "Balik ke Desc tanpa button",
		Icon = "undo-2",
		Callback = function()
			CaraA:SetDesc("Sedang mencari item...")
		end,
	})
	Tab:Space()

	-- ---- ✅ CARA B: SetButtons ----
	Tab:Paragraph({
		Title = "✅ Cara B — daftarkan lewat SetButtons",
		Desc = "Kalau elemennya sudah dibuat tanpa Buttons, pakai SetButtons. Urutannya TIDAK penting: SetDesc dan SetButtons dua-duanya memicu render ulang, jadi mana pun yang jalan terakhir akan memunculkan tombolnya.",
	})
	local CaraB = Tab:Toggle({
		Title = "Cara B",
		Desc = "Sedang mencari item...",
		Callback = function(v) print("Cara B:", v) end,
	})
	Tab:Button({
		Title = "SetButtons dulu, lalu SetDesc",
		Icon = "check",
		Callback = function()
			CaraB:SetButtons({ sell = { Icon = "coins", Callback = function() Notify("Cara B", "Sell jalan") end } })
			CaraB:SetDesc("Ketemu! <button=sell>Sell All</button>")
		end,
	})
	Tab:Button({
		Title = "SetDesc dulu, lalu SetButtons (juga jalan)",
		Desc = "Tombolnya dibuang di langkah pertama, lalu muncul saat SetButtons render ulang",
		Icon = "check",
		Callback = function()
			CaraB:SetDesc("Urutan dibalik <button=sell>Sell</button>")
			CaraB:SetButtons({ sell = { Icon = "coins", Callback = function() Notify("Cara B", "tetap jalan") end } })
		end,
	})
	Tab:Space()

	-- ---- Jebakan: SetDesc dengan string identik ----
	Tab:Paragraph({
		Title = "⚠ Jebakan — SetDesc dengan string identik = no-op",
		Desc = "Element:SetDesc punya early-return (if Element.Desc == text then return end). Jadi kalau tombolnya sempat dibuang, memanggil SetDesc dengan teks yang SAMA tidak akan memperbaikinya. Jangan pula men-set field Buttons secara mentah — itu tidak memicu render.",
	})
	local Jebakan = Tab:Toggle({
		Title = "Demo jebakan",
		Desc = "Sedang mencari item...",
		Callback = function(v) print("Jebakan:", v) end,
	})
	Tab:Button({
		Title = "1. SetDesc (tombol dibuang, Buttons masih nil)",
		Icon = "circle-1",
		Callback = function()
			Jebakan:SetDesc("Ketemu! <button=sell>Sell</button>")
		end,
	})
	Tab:Button({
		Title = "2. ❌ set field Buttons + SetDesc string sama",
		Desc = "Tidak terjadi apa-apa: field mentah tidak render, SetDesc early-return",
		Icon = "circle-2",
		Callback = function()
			Jebakan.Buttons = { sell = { Callback = function() end } }   -- ❌ tanpa render
			Jebakan:SetDesc("Ketemu! <button=sell>Sell</button>")        -- ❌ string sama -> return
			Notify("Masih kosong", "Persis seperti yang dijelaskan", "triangle-alert")
		end,
	})
	Tab:Button({
		Title = "3. ✅ SetButtons — selalu render ulang",
		Desc = "SetButtons memanggil UpdateDesc/UpdateTitle langsung, jadi melewati early-return",
		Icon = "circle-3",
		Callback = function()
			Jebakan:SetButtons({ sell = { Icon = "coins", Callback = function() Notify("Akhirnya", "muncul") end } })
		end,
	})
end

-- ============================================================================
-- 4. UPDATE BERKALA — pola yang benar untuk daftar dinamis
-- ============================================================================

do
	local Tab = Window:Tab({ Title = "4. Daftar dinamis", Icon = "refresh-cw" })

	Tab:Paragraph({
		Title = "Pola untuk daftar yang berubah terus",
		Desc = table.concat({
			"Ini pola yang dipakai kalau Desc berisi daftar item dari loop status (inventory, shop, quest).",
			"",
			"Tiga aturan penting:",
			"",
			"1. SetButtons HANYA SEKALI, di luar loop. SetButtons sengaja men-Destroy semua instance button lalu render ulang Desc dan Title — memanggilnya tiap tick membunuh optimasi reuse-instance.",
			"",
			"2. Key = ANGKA SLOT, bukan nama item. ParseButtonTagHead mengambil KATA PERTAMA sebagai key, jadi <button=Great White Shark> menghasilkan key \"Great\" dan segmennya dibuang. Nama dengan spasi selalu gagal.",
			"",
			"3. Baca target di DALAM Callback, jangan di-capture saat spec dibuat. Slot 1 hari ini item A, sebentar lagi item B — kalau nama-nya di-capture, tombolnya menjual item yang salah setelah daftarnya bergeser.",
			"",
			"Hasilnya: tick yang datanya tidak berubah jadi gratis, karena SetDesc early-return saat teksnya identik.",
		}, "\n"),
	})
	Tab:Space()

	local DAFTAR = {
		{ Name = "Great White Shark", Rarity = "Legendary", Amount = 2,  Value = "1.2M", Locked = false },
		{ Name = "Bass",              Rarity = "Common",    Amount = 41, Value = "820",  Locked = false },
		{ Name = "Golden Koi",        Rarity = "Mythic",    Amount = 1,  Value = "9.5M", Locked = true  },
		{ Name = "Tuna",              Rarity = "Rare",      Amount = 7,  Value = "45K",  Locked = false },
	}

	local InventoryToggle = Tab:Toggle({
		Title = "Sell All Fishes",
		Desc = "Menunggu data...",
		Callback = function(v) print("Auto sell:", v) end,
	})

	-- ===== dibuat SEKALI =====
	local SLOT_MAX    = 60
	local SellTargets = {}   -- slot -> nama item saat ini (berubah tiap refresh)
	local SellButtons = {}   -- slot -> spec (stabil, tidak pernah dibuat ulang)

	for i = 1, SLOT_MAX do
		SellButtons[i] = {
			Title = "Sell",
			Icon = "coins",
			Callback = function()
				-- dibaca SAAT DIKLIK, bukan saat spec dibuat
				local name = SellTargets[i]
				if not name then return end
				Notify("Sell", name, "coins")
			end,
		}
	end

	InventoryToggle:SetButtons(SellButtons)   -- cukup sekali, di luar loop

	-- ===== dipanggil berkali-kali =====
	local function Refresh(items)
		local lines = {}
		table.clear(SellTargets)

		if #items == 0 then
			table.insert(lines, "No fishes to sell")
		else
			table.insert(lines, string.format("%d jenis siap dijual", #items))
			table.insert(lines, " ")

			for i, item in ipairs(items) do
				if i > SLOT_MAX then break end

				SellTargets[i] = item.Name

				-- key = angka slot; item terkunci -> tombolnya redup & tidak bisa diklik
				table.insert(lines, string.format(
					"• %s (%s) x%d - $%s%s <button=%d%s>Sell</button>",
					item.Name,
					item.Rarity,
					item.Amount,
					item.Value,
					item.Locked and " [Locked]" or "",
					i,
					item.Locked and " locked=true" or ""
				))
			end
		end

		InventoryToggle:SetDesc(table.concat(lines, "\n"))
	end

	Refresh(DAFTAR)

	Tab:Button({
		Title = "Refresh (data sama)",
		Desc = "SetDesc early-return: nol rebuild, tombolnya tidak berkedip",
		Icon = "refresh-cw",
		Callback = function()
			Refresh(DAFTAR)
			Notify("Refresh", "Teks identik -> tidak ada render", "refresh-cw")
		end,
	})
	Tab:Button({
		Title = "Hapus 2 item pertama",
		Desc = "Jumlah baris berkurang, instance sisanya dipakai ulang",
		Icon = "minus",
		Callback = function()
			local subset = {}
			for i = 3, #DAFTAR do table.insert(subset, DAFTAR[i]) end
			Refresh(subset)
		end,
	})
	Tab:Button({
		Title = "Kembalikan daftar penuh",
		Icon = "plus",
		Callback = function() Refresh(DAFTAR) end,
	})
	Tab:Button({
		Title = "Kosongkan daftar",
		Icon = "trash-2",
		Callback = function() Refresh({}) end,
	})
	Tab:Space()

	Tab:Paragraph({
		Title = "❌ Yang sering salah ditulis",
		Desc = table.concat({
			"-- SYNTAX ERROR: key dinamis wajib pakai [ ]",
			"table.insert(NewButton, { item.Name = { Callback = f } })",
			"",
			"-- Juga salah bentuk: Buttons harus FLAT, bukan array berisi map",
			"-- table.insert bikin NewButton[1] = { Bass = {...} }",
			"",
			"-- Benar:",
			"NewButton[item.Name] = { Callback = f }",
			"",
			"-- Tapi nama item TIDAK aman dipakai sebagai key di dalam tag,",
			"-- karena hanya kata pertama yang dibaca sebagai key.",
			"-- Pakai angka slot: <button=1>Sell</button> + Buttons[1]",
		}, "\n"),
	})
end

-- ============================================================================
-- 5. SEMUA ELEMEN BER-DESC
-- ============================================================================

do
	local Tab = Window:Tab({ Title = "5. Semua elemen", Icon = "layout-list" })

	Tab:Paragraph({
		Title = "Bukan cuma Toggle",
		Desc = "Semua elemen yang punya Desc mendukungnya: Toggle, Button, Keybind, Dropdown, Input, Slider, Colorpicker, Paragraph. Button juga jalan di Title, bukan hanya Desc.",
	})
	Tab:Space()

	Tab:Toggle({
		Title = "Toggle",
		Desc = "Klik tombolnya <button=x>Aksi</button> — toggle-nya TIDAK ikut berubah.",
		Buttons = { x = { Icon = "zap", Callback = function() Notify("Toggle", "hanya button yang jalan") end } },
		Callback = function(v) Notify("Toggle", "toggle berubah: " .. tostring(v)) end,
	})
	Tab:Space()

	Tab:Button({
		Title = "Button",
		Desc = "Klik tombol inline <button=x>Aksi</button> — Callback element-nya tidak terpanggil.",
		Buttons = { x = { Icon = "zap", Callback = function() Notify("Button", "inline") end } },
		Callback = function() Notify("Button", "callback ELEMENT") end,
	})
	Tab:Space()

	Tab:Keybind({
		Title = "Keybind",
		Desc = "Reset ke default <button=x>Reset</button>",
		Value = "G",
		Buttons = { x = { Variant = "Secondary", Icon = "rotate-ccw", Callback = function() Notify("Keybind", "reset") end } },
		Callback = function(v) print("Keybind:", v) end,
	})
	Tab:Space()

	Tab:Dropdown({
		Title = "Dropdown",
		Desc = "Muat ulang daftar <button=x>Refresh</button>",
		Values = { "Option 1", "Option 2", "Option 3" },
		Value = "Option 1",
		Buttons = { x = { Variant = "Ghost", Icon = "refresh-cw", Callback = function() Notify("Dropdown", "refresh") end } },
		Callback = function(v) print("Dropdown:", v) end,
	})
	Tab:Space()

	Tab:Input({
		Title = "Input",
		Desc = "Tempel dari clipboard <button=x>Paste</button>",
		Placeholder = "Masukkan teks...",
		Buttons = { x = { Icon = "clipboard", Callback = function() Notify("Input", "paste") end } },
		Callback = function(v) print("Input:", v) end,
	})
	Tab:Space()

	Tab:Slider({
		Title = "Slider",
		Desc = "Kembalikan ke nilai awal <button=x>Reset</button>",
		Value = { Min = 0, Max = 100, Default = 50 },
		Buttons = { x = { Variant = "Secondary", Icon = "rotate-ccw", Callback = function() Notify("Slider", "reset") end } },
		Callback = function(v) print("Slider:", v) end,
	})
	Tab:Space()

	Tab:Colorpicker({
		Title = "Colorpicker",
		Desc = "Ambil warna acak <button=x>Random</button>",
		Default = Color3.fromRGB(0, 200, 120),
		Buttons = { x = { Icon = "dices", Callback = function() Notify("Colorpicker", "random") end } },
		Callback = function(c) print("Color:", c) end,
	})
	Tab:Space()

	-- CATATAN PENTING soal Paragraph:
	-- Paragraph SUDAH memakai `Buttons` untuk baris tombol di bagian bawah kartunya,
	-- dan tabel itu dipakai bersama oleh inline button. Efeknya:
	--
	--   * Buttons berbentuk ARRAY  -> baris tombol bawah tetap tampil seperti biasa
	--                                 (perilaku lama tidak berubah), DAN {button}
	--                                 tanpa key di dalam Desc juga akan menunjuk
	--                                 Buttons[1] -> bisa muncul dua-duanya.
	--   * Buttons dengan KEY nama  -> #Buttons == 0, jadi baris tombol bawah tidak
	--                                 dibuat; hanya inline button yang tampil.
	--
	-- Untuk inline button di Paragraph, pakai key bernama supaya tidak bentrok.
	Tab:Paragraph({
		Title = "Paragraph (pakai key bernama)",
		Desc = "Key bernama -> tidak ada baris tombol bawah, hanya inline <button=x>Copy</button>",
		Buttons = { x = { Icon = "copy", Callback = function() Notify("Paragraph", "copy") end } },
	})
	Tab:Space()

	Tab:Paragraph({
		Title = "Paragraph (array = baris tombol bawah, perilaku lama)",
		Desc = "Tanpa token button di Desc, tabel array tetap berperilaku seperti sebelumnya.",
		Buttons = {
			{ Title = "Copy link", Icon = "link", Callback = function() Notify("Paragraph", "link") end },
		},
	})
	Tab:Space()

	Tab:Toggle({
		Title = "Button di TITLE juga bisa <button=x>Info</button>",
		Desc = "Tag/token juga diproses di Title, bukan hanya Desc.",
		Buttons = { x = { Variant = "Ghost", Icon = "info", Callback = function() Notify("Title", "dari Title") end } },
		Callback = function(v) print("Title button:", v) end,
	})
end

-- ============================================================================
-- 6. INTEROP — bareng fitur Desc yang sudah ada
-- ============================================================================

do
	local Tab = Window:Tab({ Title = "6. Interop", Icon = "combine" })

	Tab:Paragraph({
		Title = "Bisa dicampur dengan semua fitur Desc",
		Desc = "Multi-baris (\\n), dua kolom (\\t), token ikon {icon:...}, tag <gradient>, dan gambar rbxassetid:// semuanya tetap jalan.",
	})
	Tab:Space()

	Tab:Toggle({
		Title = "Multi-baris",
		Desc = "Baris pertama tanpa tombol.\nBaris kedua punya tombol <button=a>Aksi A</button>\nBaris ketiga juga <button=b>Aksi B</button>",
		Buttons = {
			a = { Callback = function() Notify("Interop", "A") end },
			b = { Callback = function() Notify("Interop", "B") end },
		},
		Callback = function(v) print("Multiline:", v) end,
	})
	Tab:Space()

	Tab:Toggle({
		Title = "Dua kolom (\\t)",
		Desc = "Kiri: stok 42\tKanan: <button=a>Jual</button>",
		Buttons = { a = { Icon = "coins", Callback = function() Notify("Interop", "kolom kanan") end } },
		Callback = function(v) print("Dua kolom:", v) end,
	})
	Tab:Space()

	Tab:Toggle({
		Title = "Bareng token ikon",
		Desc = "{icon:coins size=18} Saldo 1.2M — {button:a}",
		Buttons = { a = { Title = "Klaim", Icon = "gift", Callback = function() Notify("Interop", "klaim") end } },
		Callback = function(v) print("Ikon:", v) end,
	})
	Tab:Space()

	Tab:Toggle({
		Title = "Bareng gradient",
		Desc = "<gradient=#ff5f6d,#ffc371>Peringatan penting</gradient> — <button=a>Perbaiki</button>",
		Buttons = { a = { Color = Color3.fromHex("#e11d48"), Icon = "wrench", Callback = function() Notify("Interop", "fix") end } },
		Callback = function(v) print("Gradient:", v) end,
	})
	Tab:Space()

	Tab:Toggle({
		Title = "Escape brace",
		Desc = "Tulis {{button}} (kurung dobel) kalau memang mau menampilkan teks {button} apa adanya.",
		Callback = function(v) print("Escape:", v) end,
	})
	Tab:Space()

	Tab:Toggle({
		Title = "InlineIcon = false",
		Desc = "Token ikon dimatikan {icon:coins} tapi button tetap jalan <button=a>Aksi</button>",
		InlineIcon = false,
		Buttons = { a = { Callback = function() Notify("Interop", "button tetap jalan") end } },
		Callback = function(v) print("InlineIcon false:", v) end,
	})
end

-- ============================================================================
-- 7. API RUNTIME
-- ============================================================================

do
	local Tab = Window:Tab({ Title = "7. API", Icon = "terminal" })

	Tab:Paragraph({
		Title = "API yang tersedia",
		Desc = table.concat({
			"Di elemen (semua elemen ber-Desc):",
			"  element:SetDesc(text)",
			"  element:SetButtons(tbl)      -- ganti seluruh tabel spec + render ulang",
			"  element:GetButton(key)       -- Api satu button yang sedang tampil",
			"  element:GetButtons()         -- map key -> Api",
			"",
			"Di objek frame (kalau butuh yang lebih dalam):",
			"  element.ToggleFrame:IsInlineButtonActive()",
			"",
			"Di Api satu button:",
			"  Api:SetTitle(text)     Api:SetIcon(src, size)   Api:SetCallback(fn)",
			"  Api:Lock()             Api:Unlock()             Api:IsLocked()",
			"  Api:IsHovering()       Api:LastPressAt()        Api:SetRadius(n)",
			"  Api:Update(spec)       Api:Destroy()",
			"  Api.Instance           Api.Key",
			"",
			"Callback menerima Api-nya sebagai argumen pertama:",
			"  Callback = function(btn) print(btn.Key) end",
		}, "\n"),
	})
	Tab:Space()

	-- ---- GetButton: cara termurah untuk update label ----
	Tab:Paragraph({
		Title = "GetButton — cara termurah untuk update",
		Desc = "Kalau yang berubah cuma label/ikon, JANGAN SetDesc. Ambil Api-nya langsung. Title, Icon, dan Locked sengaja tidak masuk ItemSignature, jadi instance-nya dipakai ulang tanpa berkedip.",
	})

	local Counter = 0
	local CounterToggle = Tab:Toggle({
		Title = "Counter",
		Desc = "Stok siap dijual: {button:sell}",
		Buttons = {
			sell = {
				Title = "Sell (0)",
				Icon = "coins",
				Callback = function(btn)
					Notify("Sell", "Menjual " .. Counter .. " item", "coins")
				end,
			},
		},
		Callback = function(v) print("Counter toggle:", v) end,
	})

	Tab:Button({
		Title = "Tambah stok (+7)",
		Desc = "Hanya SetTitle — tidak ada re-parse Desc",
		Icon = "plus",
		Callback = function()
			Counter = Counter + 7
			local btn = CounterToggle:GetButton("sell")
			if btn then
				btn:SetTitle("Sell (" .. Counter .. ")")
			end
		end,
	})
	Tab:Button({
		Title = "Kosongkan stok",
		Desc = "Stok 0 -> tombolnya di-Lock, bukan dihapus",
		Icon = "minus",
		Callback = function()
			Counter = 0
			local btn = CounterToggle:GetButton("sell")
			if btn then
				btn:SetTitle("Sell (0)")
				btn:Lock()
			end
		end,
	})
	Tab:Button({
		Title = "Buka lagi",
		Icon = "unlock",
		Callback = function()
			local btn = CounterToggle:GetButton("sell")
			if btn then btn:Unlock() end
		end,
	})
	Tab:Space()

	-- ---- GetButtons ----
	Tab:Paragraph({
		Title = "GetButtons — iterasi semua",
		Desc = "Balik map key -> Api dari button yang SEDANG tampil (yang instance-nya sudah mati otomatis dibersihkan).",
	})
	local MultiToggle = Tab:Toggle({
		Title = "Tiga button",
		Desc = "{button:a} {button:b} {button:c}",
		Buttons = {
			a = { Title = "A", Callback = function() end },
			b = { Title = "B", Callback = function() end },
			c = { Title = "C", Callback = function() end },
		},
		Callback = function(v) print("Multi:", v) end,
	})
	Tab:Button({
		Title = "Print semua key",
		Icon = "list",
		Callback = function()
			local keys = {}
			for key in pairs(MultiToggle:GetButtons()) do
				table.insert(keys, tostring(key))
			end
			table.sort(keys)
			Notify("GetButtons", table.concat(keys, ", "), "list")
			print("keys:", table.concat(keys, ", "))
		end,
	})
	Tab:Button({
		Title = "Tandai semuanya (SetTitle massal)",
		Icon = "check-check",
		Callback = function()
			for key, api in pairs(MultiToggle:GetButtons()) do
				api:SetTitle(tostring(key):upper() .. " ✓")
			end
		end,
	})
	Tab:Space()

	-- ---- Lock / Unlock elemen ----
	Tab:Paragraph({
		Title = "Lock elemen ikut mengunci inline button",
		Desc = "element:Lock() otomatis me-Lock semua inline button-nya. element:Unlock() hanya membuka yang TIDAK punya Locked = true di spec-nya — jadi button yang sengaja kamu kunci tetap terkunci.",
	})
	local LockToggle = Tab:Toggle({
		Title = "Demo Lock",
		Desc = "Bebas {button:a} • sengaja dikunci di spec {button:b}",
		Buttons = {
			a = { Title = "Bebas",  Callback = function() Notify("Lock", "A jalan") end },
			b = { Title = "Kunci", Locked = true, Callback = function() Notify("Lock", "B tidak boleh jalan") end },
		},
		Callback = function(v) print("Lock demo:", v) end,
	})
	Tab:Button({
		Title = "Lock elemen",
		Icon = "lock",
		Callback = function() LockToggle:Lock() end,
	})
	Tab:Button({
		Title = "Unlock elemen",
		Desc = "A terbuka lagi, B tetap terkunci",
		Icon = "unlock",
		Callback = function() LockToggle:Unlock() end,
	})
	Tab:Space()

	-- ---- SetCallback / Update ----
	Tab:Paragraph({
		Title = "SetCallback & Update",
		Desc = "SetCallback mengganti aksi tanpa menyentuh tampilan. Update(spec) mengganti Title/Icon/Callback/Locked sekaligus, juga tanpa rebuild.",
	})
	local SwapToggle = Tab:Toggle({
		Title = "Tukar aksi",
		Desc = "Tombolnya sama, aksinya bisa ditukar {button:x}",
		Buttons = {
			x = { Title = "Mode A", Icon = "circle", Callback = function() Notify("Aksi", "MODE A") end },
		},
		Callback = function(v) print("Swap:", v) end,
	})
	Tab:Button({
		Title = "Ganti ke Mode B (SetCallback saja)",
		Icon = "repeat",
		Callback = function()
			local btn = SwapToggle:GetButton("x")
			if btn then
				btn:SetCallback(function() Notify("Aksi", "MODE B") end)
			end
		end,
	})
	Tab:Button({
		Title = "Update penuh (title + icon + callback)",
		Icon = "wand-sparkles",
		Callback = function()
			local btn = SwapToggle:GetButton("x")
			if btn then
				btn:Update({
					Title = "Mode C",
					Icon = "sparkles",
					Callback = function() Notify("Aksi", "MODE C") end,
				})
			end
		end,
	})
end

Window:SelectTab(1)
