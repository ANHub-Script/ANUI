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
    
    -- 1. [FIX POSISI GAMBAR UTAMA]
    function Dropdown:SetMainImage(image)
        if Dropdown.DropdownFrame and Dropdown.DropdownFrame.SetImage then
            -- Panggil fungsi bawaan Element
            Dropdown.DropdownFrame:SetImage(image)

            -- FIX: Secara default SetImage menaruh gambar di urutan terakhir (kanan).
            -- Kita cari gambar tersebut dan set LayoutOrder = -1 agar pindah ke kiri.
            local Container = Dropdown.DropdownFrame.UIElements.Container
            local OuterTitleFrame = Container and Container:FindFirstChild("TitleFrame")
            
            if OuterTitleFrame then
                for _, child in ipairs(OuterTitleFrame:GetChildren()) do
                    -- Di Element.lua, container text bernama "TitleFrame". 
                    -- Jadi frame apapun yang BUKAN "TitleFrame" (dan bukan Layout) adalah Icon-nya.
                    if child:IsA("Frame") and child.Name ~= "TitleFrame" then
                        child.LayoutOrder = -1
                    end
                end
            end
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
    
    function Dropdown:SetValueIcon(image)
        Dropdown:SetValueImage(image)
    end
    
    Dropdown.DropdownMenu = CreateDropdown(Config, Dropdown, Element, CanCallback, "Dropdown")
    
    Dropdown.Display = Dropdown.DropdownMenu.Display
    Dropdown.Refresh = Dropdown.DropdownMenu.Refresh
    Dropdown.Select = Dropdown.DropdownMenu.Select
    Dropdown.Open = Dropdown.DropdownMenu.Open
    Dropdown.Close = Dropdown.DropdownMenu.Close
    
    local OriginalOpen = Dropdown.Open
    
    -- Fungsi bantuan untuk memaksa posisi menu ke ATAS
    local function ForceUpwardsPosition()
        local button = Dropdown.UIElements.Dropdown or Dropdown.DropdownFrame.UIElements.Main
        local menu = Dropdown.UIElements.MenuCanvas
        
        -- Hitung posisi Y agar berada tepat DI ATAS tombol
        local UpY = button.AbsolutePosition.Y - menu.AbsoluteSize.Y - 5 -- 5px padding
        
        menu.Position = UDim2.new(
            0, 
            button.AbsolutePosition.X + button.AbsoluteSize.X, 
            0, 
            UpY
        )
    end

    -- Bind ke perubahan size untuk menjaga posisi tetap di atas
    Creator.AddSignal(Dropdown.UIElements.MenuCanvas:GetPropertyChangedSignal("AbsoluteSize"), function()
        if Dropdown.Opened then ForceUpwardsPosition() end
    end)

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
    
    -- 3. [LOGIC TOGGLE (Buka/Tutup) & POSISI ATAS]
    Dropdown.Open = function()
        if Dropdown.Opened then
            -- Jika sudah terbuka, tutup (Toggle)
            Dropdown.Close()
        else
            -- Jika tertutup, buka
            OriginalOpen()
            -- Paksa posisi ke atas setelah frame dirender
            task.spawn(function()
                game:GetService("RunService").RenderStepped:Wait()
                ForceUpwardsPosition()
            end)
        end
    end
    
    return Dropdown.__type, Dropdown
end

return Element