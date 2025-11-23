local ANUI = {
    Window = nil,
    Theme = nil,
    Creator = require("./modules/Creator"),
    LocalizationModule = require("./modules/Localization"),
    NotificationModule = require("./components/Notification"),
    Themes = nil,
    Transparent = false,
    
    TransparencyValue = .15,
    
    UIScale = 1,
    
    ConfigManager = nil,
    Version = "0.0.0",
    
    Services = require("./utils/services/Init"),
    
    OnThemeChangeFunction = nil,
    
    cloneref = nil,
    UIScaleObj = nil,
}


local cloneref = (cloneref or clonereference or function(instance) return instance end)

ANUI.cloneref = cloneref

local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))
local CoreGui= cloneref(game:GetService("CoreGui"))

local LocalPlayer = Players.LocalPlayer or nil

local Package = HttpService:JSONDecode(require("../build/package"))
if Package then
    ANUI.Version = Package.version
end

local KeySystem = require("./components/KeySystem")

local ServicesModule = ANUI.Services


local Creator = ANUI.Creator

local New = Creator.New
local Tween = Creator.Tween


local Acrylic = require("./utils/Acrylic/Init")


local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local GUIParent = gethui and gethui() or (CoreGui or game.Players.LocalPlayer:WaitForChild("PlayerGui"))

local UIScaleObj = New("UIScale", {
    Scale = ANUI.Scale,
})

ANUI.UIScaleObj = UIScaleObj

ANUI.ScreenGui = New("ScreenGui", {
    Name = "ANUI",
    Parent = GUIParent,
    IgnoreGuiInset = true,
    ScreenInsets = "None",
}, {
    
    New("Folder", {
        Name = "Window"
    }),
    -- New("Folder", {
    --     Name = "Notifications"
    -- }),
    -- New("Folder", {
    --     Name = "Dropdowns"
    -- }),
    New("Folder", {
        Name = "KeySystem"
    }),
    New("Folder", {
        Name = "Popups"
    }),
    New("Folder", {
        Name = "ToolTips"
    })
})

ANUI.NotificationGui = New("ScreenGui", {
    Name = "ANUI/Notifications",
    Parent = GUIParent,
    IgnoreGuiInset = true,
})
ANUI.DropdownGui = New("ScreenGui", {
    Name = "ANUI/Dropdowns",
    Parent = GUIParent,
    IgnoreGuiInset = true,
})
ProtectGui(ANUI.ScreenGui)
ProtectGui(ANUI.NotificationGui)
ProtectGui(ANUI.DropdownGui)

Creator.Init(ANUI)


function ANUI:SetParent(parent)
    ANUI.ScreenGui.Parent = parent
    ANUI.NotificationGui.Parent = parent
    ANUI.DropdownGui.Parent = parent
end
math.clamp(ANUI.TransparencyValue, 0, 1)

local Holder = ANUI.NotificationModule.Init(ANUI.NotificationGui)

function ANUI:Notify(Config)
    Config.Holder = Holder.Frame
    Config.Window = ANUI.Window
    --Config.ANUI = ANUI
    return ANUI.NotificationModule.New(Config)
end

function ANUI:SetNotificationLower(Val)
    Holder.SetLower(Val)
end

function ANUI:SetFont(FontId)
    Creator.UpdateFont(FontId)
end

function ANUI:OnThemeChange(func)
    ANUI.OnThemeChangeFunction = func
end

function ANUI:AddTheme(LTheme)
    ANUI.Themes[LTheme.Name] = LTheme
    return LTheme
end

function ANUI:SetTheme(Value)
    if ANUI.Themes[Value] then
        ANUI.Theme = ANUI.Themes[Value]
        Creator.SetTheme(ANUI.Themes[Value])
        
        if ANUI.OnThemeChangeFunction then
            ANUI.OnThemeChangeFunction(Value)
        end
        --Creator.UpdateTheme()
        
        return ANUI.Themes[Value]
    end
    return nil
end

function ANUI:GetThemes()
    return ANUI.Themes
end
function ANUI:GetCurrentTheme()
    return ANUI.Theme.Name
end
function ANUI:GetTransparency()
    return ANUI.Transparent or false
end
function ANUI:GetWindowSize()
    return Window.UIElements.Main.Size
end
function ANUI:Localization(LocalizationConfig)
    return ANUI.LocalizationModule:New(LocalizationConfig, Creator)
end

function ANUI:SetLanguage(Value)
    if Creator.Localization then
        return Creator.SetLanguage(Value)
    end
    return false
end

function ANUI:ToggleAcrylic(Value)
	if ANUI.Window and ANUI.Window.AcrylicPaint and ANUI.Window.AcrylicPaint.Model then
		ANUI.Window.Acrylic = Value
		ANUI.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
		if Value then
			Acrylic.Enable()
		else
			Acrylic.Disable()
		end
	end
end



function ANUI:Gradient(stops, props)
    local colorSequence = {}
    local transparencySequence = {}

    for posStr, stop in next, stops do
        local position = tonumber(posStr)
        if position then
            position = math.clamp(position / 100, 0, 1)
            table.insert(colorSequence, ColorSequenceKeypoint.new(position, stop.Color))
            table.insert(transparencySequence, NumberSequenceKeypoint.new(position, stop.Transparency or 0))
        end
    end

    table.sort(colorSequence, function(a, b) return a.Time < b.Time end)
    table.sort(transparencySequence, function(a, b) return a.Time < b.Time end)


    if #colorSequence < 2 then
        error("ColorSequence requires at least 2 keypoints")
    end


    local gradientData = {
        Color = ColorSequence.new(colorSequence),
        Transparency = NumberSequence.new(transparencySequence),
    }

    if props then
        for k, v in pairs(props) do
            gradientData[k] = v
        end
    end

    return gradientData
end


function ANUI:Popup(PopupConfig)
    PopupConfig.ANUI = ANUI
    return require("./components/popup/Init").new(PopupConfig)
end


ANUI.Themes = require("./themes/Init")(ANUI)

Creator.Themes = ANUI.Themes


ANUI:SetTheme("Dark")
ANUI:SetLanguage(Creator.Language)


function ANUI:CreateWindow(Config)
    local CreateWindow = require("./components/window/Init")
    
    if not isfolder("ANUI") then
        makefolder("ANUI")
    end
    if Config.Folder then
        makefolder(Config.Folder)
    else
        makefolder(Config.Title)
    end
    
    Config.ANUI = ANUI
    Config.Parent = ANUI.ScreenGui.Window
    
    if ANUI.Window then
        warn("You cannot create more than one window")
        return
    end
    
    local CanLoadWindow = true
    
    local Theme = ANUI.Themes[Config.Theme or "Dark"]
    
    --ANUI.Theme = Theme
    Creator.SetTheme(Theme)
    
    
    local hwid = gethwid or function()
        return Players.LocalPlayer.UserId
    end
    
    local Filename = hwid()
    
    if Config.KeySystem then
        CanLoadWindow = false
    
        local function loadKeysystem()
            KeySystem.new(Config, Filename, function(c) CanLoadWindow = c end)
        end
    
        local keyPath = (Config.Folder or "Temp") .. "/" .. Filename .. ".key"
        
        if Config.KeySystem.KeyValidator then
            if Config.KeySystem.SaveKey and isfile(keyPath) then
                local savedKey = readfile(keyPath)
                local isValid = Config.KeySystem.KeyValidator(savedKey)
                
                if isValid then
                    CanLoadWindow = true
                else
                    loadKeysystem()
                end
            else
                loadKeysystem()
            end
        elseif not Config.KeySystem.API then
            if Config.KeySystem.SaveKey and isfile(keyPath) then
                local savedKey = readfile(keyPath)
                local isKey = (type(Config.KeySystem.Key) == "table")
                    and table.find(Config.KeySystem.Key, savedKey)
                    or tostring(Config.KeySystem.Key) == tostring(savedKey)
                    
                if isKey then
                    CanLoadWindow = true
                else
                    loadKeysystem()
                end
            else
                loadKeysystem()
            end
        else
            if isfile(keyPath) then
                local fileKey = readfile(keyPath)
                local isSuccess = false
                 
                for _, i in next, Config.KeySystem.API do
                    local serviceData = ANUI.Services[i.Type]
                    if serviceData then
                        local args = {}
                        for _, argName in next, serviceData.Args do
                            table.insert(args, i[argName])
                        end
                        
                        local service = serviceData.New(table.unpack(args))
                        local success = service.Verify(fileKey)
                        if success then
                            isSuccess = true
                            break
                        end
                    end
                end
                    
                CanLoadWindow = isSuccess
                if not isSuccess then loadKeysystem() end
            else
                loadKeysystem()
            end
        end
        
        repeat task.wait() until CanLoadWindow
    end

    local Window = CreateWindow(Config)

    ANUI.Transparent = Config.Transparent
    ANUI.Window = Window
    
    if Config.Acrylic then
        Acrylic.init()
    end
    
    -- function Window:ToggleTransparency(Value)
    --     ANUI.Transparent = Value
    --     ANUI.Window.Transparent = Value
        
    --     Window.UIElements.Main.Background.BackgroundTransparency = Value and ANUI.TransparencyValue or 0
    --     Window.UIElements.Main.Background.ImageLabel.ImageTransparency = Value and ANUI.TransparencyValue or 0
    --     Window.UIElements.Main.Gradient.UIGradient.Transparency = NumberSequence.new{
    --         NumberSequenceKeypoint.new(0, 1), 
    --         NumberSequenceKeypoint.new(1, Value and 0.85 or 0.7),
    --     }
    -- end
    
    return Window
end

return ANUI