local cloneref = (cloneref or clonereference or function(instance) return instance end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local Mouse = cloneref(game:GetService("Players")).LocalPlayer:GetMouse()
local Camera = cloneref(game:GetService("Workspace")).CurrentCamera

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateLabel = require("../components/ui/Label").New
local CreateInput = require("../components/ui/Input").New
local CreateDropdown = require("../components/ui/Dropdown").New

local CurrentCamera = workspace.CurrentCamera

local Element = {
    UICorner = 10,
    UIPadding = 12,
    MenuCorner = 15,
    MenuPadding = 5,
    TabPadding = 10,
    SearchBarHeight = 39,
    TabIcon = 18,
}

function Element:New(Config)
    local Dropdown = {
        __type = "Dropdown",
        Title = Config.Title or "Dropdown",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or false,
        Values = Config.Values or {},
        MenuWidth = Config.MenuWidth,
        Value = Config.Value,
        AllowNone = Config.AllowNone,
        SearchBarEnabled = Config.SearchBarEnabled or false,
        Multi = Config.Multi,
        Callback = Config.Callback or nil,
        
        UIElements = {},
        
        Opened = false,
        Tabs = {},
        
        Width = 150,
    }
    
    if Dropdown.Multi and not Dropdown.Value then
        Dropdown.Value = {}
    end
    
    local CanCallback = true
    
    Dropdown.DropdownFrame = require("../components/window/Element")({
        Title = Dropdown.Title,
        Desc = Dropdown.Desc,
        Image = Config.Image,
        ImageSize = Config.ImageSize,
        IconThemed = Config.IconThemed,
        Color = Config.Color,
        Parent = Config.Parent,
        TextOffset = Dropdown.Callback and Dropdown.Width or 20,
        Hover = not Dropdown.Callback and true or false,
        Tab = Config.Tab,
        Index = Config.Index,
        Window = Config.Window,
        ElementTable = Dropdown,
        ParentConfig = Config,
        ParentType = Config.ParentType,
    })
    
    
    if Dropdown.Callback then
        Dropdown.UIElements.Dropdown = CreateLabel("", nil, Dropdown.DropdownFrame.UIElements.Main, nil, Config.Window.NewElements and 12 or 10)
        
        Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate = "AtEnd"
        Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Size = UDim2.new(1, Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset - 18 - 12 - 12,0,0)
        
        Dropdown.UIElements.Dropdown.Size = UDim2.new(0,Dropdown.Width,0,36)
        Dropdown.UIElements.Dropdown.Position = UDim2.new(1,0,Config.Window.NewElements and 0 or 0.5,0)
        Dropdown.UIElements.Dropdown.AnchorPoint = Vector2.new(1,Config.Window.NewElements and 0 or 0.5)
    end
    
    -- 1. [FITUR BARU] SetMainImage: Mengubah gambar utama elemen (yang di kiri / "AN" Image)
    -- Ini mengakses fungsi SetImage milik wrapper Element utama
    function Dropdown:SetMainImage(image)
        if Dropdown.DropdownFrame and Dropdown.DropdownFrame.SetImage then
            Dropdown.DropdownFrame:SetImage(image)
        end
    end

    -- 2. SetValueImage: Mengubah gambar di dalam kotak value (yang di kanan)
    function Dropdown:SetValueImage(image)
        if Dropdown.UIElements.Dropdown then
             local Container = Dropdown.UIElements.Dropdown.Frame.Frame
             
             local TextLabel = Container:FindFirstChild("TextLabel")
             local DynamicIcon = Container:FindFirstChild("DynamicValueIcon")
             
             if image and image ~= "" then
                 if not DynamicIcon then
                     DynamicIcon = New("ImageLabel", {
                         Name = "DynamicValueIcon",
                         Size = UDim2.new(0, 21, 0, 21),
                         BackgroundTransparency = 1,
                         ThemeTag = {
                             ImageColor3 = "Icon",
                         },
                         LayoutOrder = -1,
                         Parent = Container
                     })
                 end
                 
                 local ic = Creator.Icon(image)
                 if ic then
                     DynamicIcon.Image = ic[1]
                     DynamicIcon.ImageRectSize = ic[2].ImageRectSize
                     DynamicIcon.ImageRectOffset = ic[2].ImageRectPosition
                 else
                     DynamicIcon.Image = image
                     DynamicIcon.ImageRectSize = Vector2.new(0,0)
                     DynamicIcon.ImageRectOffset = Vector2.new(0,0)
                 end
                 
                 DynamicIcon.Visible = true
                 
                 if TextLabel then
                     TextLabel.Size = UDim2.new(1, -29, 1, 0)
                 end
             else
                 if DynamicIcon then
                     DynamicIcon.Visible = false
                 end
                 if TextLabel then
                     TextLabel.Size = UDim2.new(1, 0, 1, 0)
                 end
             end
        end
    end
    
    -- Mapping fungsi lama untuk kompatibilitas
    function Dropdown:SetValueIcon(image)
        Dropdown:SetValueImage(image)
    end
    
    Dropdown.DropdownMenu = CreateDropdown(Config, Dropdown, Element, CanCallback, "Dropdown")
    
    Dropdown.Display = Dropdown.DropdownMenu.Display
    Dropdown.Refresh = Dropdown.DropdownMenu.Refresh
    Dropdown.Select = Dropdown.DropdownMenu.Select
    Dropdown.Open = Dropdown.DropdownMenu.Open
    Dropdown.Close = Dropdown.DropdownMenu.Close
    
    -- [MODIFIKASI] UpdatePosition untuk memaksa menu ke ATAS
    local OriginalUpdatePosition = UpdatePosition -- Menyimpan referensi fungsi lokal jika ada di scope CreateDropdown (biasanya tidak terakses langsung, jadi kita override logikanya di sini jika memungkinkan, atau memodifikasi file komponen Dropdown). 
    -- Karena logic UpdatePosition ada di file `src/components/ui/Dropdown.lua`, dan file ini (`src/elements/Dropdown.lua`) hanya wrapper, kita perlu memastikan logic posisi dihandle.
    -- TAPI, di ANUI struktur file, logic posisi biasanya ada di `CreateDropdown` (components/ui/Dropdown).
    
    -- NAMUN, ANUI menggunakan AddSignal di dalam `components/ui/Dropdown.lua`. 
    -- Kita tidak bisa dengan mudah meng-override fungsi lokal di file lain tanpa mengedit file `components/ui/Dropdown.lua`.
    -- TAPI, untungnya `Dropdown.DropdownMenu` adalah tabel yang dikembalikan.
    -- Mari kita lihat `src/components/ui/Dropdown.lua` yang Anda berikan sebelumnya. Di sana ada fungsi `UpdatePosition` lokal.
    
    -- **PENTING**: Karena Anda meminta perubahan logika tampilan (ke atas), idealnya kita ubah di `components/ui/Dropdown.lua`. 
    -- Tapi karena saya hanya mengedit file `src/elements/Dropdown.lua` sekarang, saya akan mencoba meng-override logic tersebut melalui Signal baru yang menimpa posisi.

    local DropdownIcon = New("ImageLabel", {
        Image = Creator.Icon("chevrons-up-down")[1],
        ImageRectOffset = Creator.Icon("chevrons-up-down")[2].ImageRectPosition,
        ImageRectSize = Creator.Icon("chevrons-up-down")[2].ImageRectSize,
        Size = UDim2.new(0,18,0,18),
        Position = UDim2.new(
            1,
            Dropdown.UIElements.Dropdown and -12 or 0,
            0.5,
            0
        ),
        ThemeTag = {
            ImageColor3 = "Icon"
        },
        AnchorPoint = Vector2.new(1,0.5),
        Parent = Dropdown.UIElements.Dropdown and Dropdown.UIElements.Dropdown.Frame or Dropdown.DropdownFrame.UIElements.Main
    })
    
    function Dropdown:Lock()
        Dropdown.Locked = true
        CanCallback = false
        return Dropdown.DropdownFrame:Lock()
    end
    function Dropdown:Unlock()
        Dropdown.Locked = false
        CanCallback = true
        return Dropdown.DropdownFrame:Unlock()
    end
    
    if Dropdown.Locked then
        Dropdown:Lock()
    end
    
    -- 3. [FITUR BARU] Toggle Logic (Open/Close)
    local ClickableArea = (Dropdown.UIElements.Dropdown and Dropdown.UIElements.Dropdown.MouseButton1Click or Dropdown.DropdownFrame.UIElements.Main.MouseButton1Click)
    
    -- Kita perlu menghapus koneksi lama yang dibuat di `components/ui/Dropdown.lua` jika memungkinkan, atau menimpanya.
    -- Karena kita tidak bisa menghapus koneksi lokal di file lain dengan mudah, kita akan menggunakan trik:
    -- Kita akan membiarkan koneksi lama, tapi kita akan memodifikasi fungsi `Open` di Dropdown object agar bertindak sebagai Toggle jika sudah terbuka.
    
    local OriginalOpen = Dropdown.Open
    local OriginalClose = Dropdown.Close
    
    -- Override fungsi Open agar menjadi Toggle Logic
    -- Catatan: Ini agak hacky. Cara terbaik sebenarnya adalah mengedit `components/ui/Dropdown.lua`.
    -- TAPI, di sini kita akan menggunakan logic di wrapper ini.
    
    -- Mari kita buat fungsi ForceUpdatePosition untuk memaksa ke atas
    local function ForceUpwardsPosition()
        local button = Dropdown.UIElements.Dropdown or Dropdown.DropdownFrame.UIElements.Main
        local menu = Dropdown.UIElements.MenuCanvas
        
        -- Hitung posisi Y agar berada DI ATAS tombol
        -- Posisi Y = Tombol Y - Tinggi Menu - Padding
        local UpY = button.AbsolutePosition.Y - menu.AbsoluteSize.Y - 5 -- 5 pixel padding
        
        menu.Position = UDim2.new(
            0, 
            button.AbsolutePosition.X + button.AbsoluteSize.X, -- Anchor Point (1,0) jadi X sejajar kanan
            0, 
            UpY
        )
    end

    -- Kita bind fungsi posisi ke atas ini ke perubahan size/posisi
    Creator.AddSignal(Dropdown.UIElements.MenuCanvas:GetPropertyChangedSignal("AbsoluteSize"), function()
        if Dropdown.Opened then ForceUpwardsPosition() end
    end)
    Creator.AddSignal(Dropdown.UIElements.MenuCanvas:GetPropertyChangedSignal("AbsolutePosition"), function()
         -- Kita biarkan default jalan dulu, lalu kita timpa frame berikutnya jika perlu, 
         -- tapi karena render stepped mungkin flicker, lebih baik kita hook ke fungsi Open.
    end)
    
    -- Override Open untuk memaksa posisi ke atas setelah dibuka
    Dropdown.Open = function()
        OriginalOpen()
        -- Paksa posisi ke atas setelah frame dirender
        task.spawn(function()
            RunService.RenderStepped:Wait()
            ForceUpwardsPosition()
        end)
    end

    -- [PERBAIKAN TOGGLE]
    -- Masalahnya: `components/ui/Dropdown.lua` sudah memiliki event `MouseButton1Click` yang memanggil `Open()`.
    -- Kita tidak bisa mendisconnectnya dari sini karena variabel signalnya lokal di sana.
    -- SOLUSI: Kita akan memanipulasi `CanCallback` atau status `Opened`? Tidak.
    -- Solusi terbaik tanpa mengedit file lain adalah mengubah fungsi `Dropdown.Open` itu sendiri.
    
    -- Kita ubah fungsi Dropdown.Open menjadi fungsi Toggle cerdas
    Dropdown.Open = function()
        if Dropdown.Opened then
            -- Jika sudah terbuka, kita tutup (Toggle behavior)
            Dropdown.Close()
        else
            -- Jika tertutup, kita buka (dan paksa ke atas)
            OriginalOpen()
            task.spawn(function()
                -- Tunggu sebentar agar size terupdate layoutnya
                RunService.RenderStepped:Wait() 
                ForceUpwardsPosition()
            end)
        end
    end
    
    return Dropdown.__type, Dropdown
end

return Element