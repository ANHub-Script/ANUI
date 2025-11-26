
local cloneref = (cloneref or clonereference or function(instance) return instance end)

local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local LocalizationService = cloneref(game:GetService("LocalizationService"))
local HttpService = cloneref(game:GetService("HttpService"))

local RenderStepped = RunService.Heartbeat

local IconsURL = "https://raw.githubusercontent.com/ANHub-Script/Icons/main/Main-v2.lua"

local Icons = loadstring(
    game.HttpGetAsync and game:HttpGetAsync(IconsURL)
    or HttpService:GetAsync(IconsURL) --studio
)()
Icons.SetIconsType("lucide")

local ANUI

local Creator = {
    Font = "rbxassetid://12187365364",
    Localization = nil,
    CanDraggable = true,
    Theme = nil,
    Themes = nil,
    Icons = Icons,
    Signals = {},
    Objects = {},
    LocalizationObjects = {},
    FontObjects = {},
    Language = string.match(LocalizationService.SystemLocaleId , "^[a-z]+"),
    Request = http_request or (syn and syn.request) or request,
    DefaultProperties = {
        ScreenGui = {
            ResetOnSpawn = false,
            ZIndexBehavior = "Sibling",
        },
        CanvasGroup = {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.new(1,1,1),
        },
        Frame = {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.new(1,1,1),
        },
        TextLabel = {
            BackgroundColor3 = Color3.new(1,1,1),
            BorderSizePixel = 0,
            Text = "",
            RichText = true,
            TextColor3 = Color3.new(1,1,1),
            TextSize = 14,
        }, TextButton = {
            BackgroundColor3 = Color3.new(1,1,1),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor= false,
            TextColor3 = Color3.new(1,1,1),
            TextSize = 14,
        },
        TextBox = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            ClearTextOnFocus = false,
            Text = "",
            TextColor3 = Color3.new(0, 0, 0),
            TextSize = 14,
        },
        ImageLabel = {
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
        },
        ImageButton = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            AutoButtonColor = false,
        },
        UIListLayout = {
            SortOrder = "LayoutOrder",
        },
        ScrollingFrame = {
            ScrollBarImageTransparency = 1,
            BorderSizePixel = 0,
        },
        VideoFrame = {
            BorderSizePixel = 0,
        }
    },
    Colors = {
        Red = "#e53935",
        Orange = "#f57c00",
        Green = "#43a047",
        Blue = "#039be5",
        White = "#ffffff",
        Grey = "#484848",
    },
    ThemeFallbacks = require("../themes/Fallbacks"),
    Shapes = {
        Square = "rbxassetid://82909646051652",
        ["Square-Outline"] = "rbxassetid://72946211851948",
        
        Squircle = "rbxassetid://80999662900595",
        SquircleOutline = "rbxassetid://117788349049947",
        ["Squircle-Outline"] = "rbxassetid://117817408534198",
        
        SquircleOutline2 = "rbxassetid://117817408534198",
        
        ["Shadow-sm"] = "rbxassetid://84825982946844",
        
        ["Squircle-TL-TR"] = "rbxassetid://73569156276236",
        ["Squircle-BL-BR"] = "rbxassetid://93853842912264",
        ["Squircle-TL-TR-Outline"] = "rbxassetid://136702870075563",
        ["Squircle-BL-BR-Outline"] = "rbxassetid://75035847706564",
    }
}

function Creator.Init(WindUITable)
    ANUI = WindUITable
end

function Creator.AddSignal(Signal, Function)
    local conn = Signal:Connect(Function)
    table.insert(Creator.Signals, conn)
    return conn
end

function Creator.DisconnectAll()
	for idx, signal in next, Creator.Signals do
		local Connection = table.remove(Creator.Signals, idx)
		Connection:Disconnect()
	end
end

function Creator.SafeCallback(Function, ...)
    if not Function then
        return
    end
    
    local Success, Event = pcall(Function, ...)
    if not Success then
        if ANUI and ANUI.Window and ANUI.Window.Debug then
            local _, i = Event:find(":%d+: ")
        
            warn("[ ANUI: DEBUG Mode ] " .. Event)
            
            return ANUI:Notify({
                Title = "DEBUG Mode: Error",
                Content = not i and Event or Event:sub(i + 1),
                Duration = 8,
            })
        end
    end
end

function Creator.Gradient(stops, props)
    if ANUI and ANUI.Gradient then
        return ANUI:Gradient(stops, props)
    end
    
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

function Creator.SetTheme(Theme)
    Creator.Theme = Theme
    Creator.UpdateTheme(nil, false)
end

function Creator.AddFontObject(Object)
    table.insert(Creator.FontObjects, Object)
    Creator.UpdateFont(Creator.Font)
end

function Creator.UpdateFont(FontId)
    Creator.Font = FontId
    for _,Obj in next, Creator.FontObjects do
        Obj.FontFace = Font.new(FontId, Obj.FontFace.Weight, Obj.FontFace.Style)
    end
end

function Creator.GetThemeProperty(Property, Theme)
    local function getValue(prop, themeTable)
        local value = themeTable[prop]
        
        if value == nil then return nil end
        
        if typeof(value) == "string" and string.sub(value, 1, 1) == "#" then
            return Color3.fromHex(value)
        end
        
        if typeof(value) == "Color3" then
            return value
        end
        
        if typeof(value) == "number" then
            return value
        end
        
        if typeof(value) == "table" and value.Color and value.Transparency then
            return value
        end
        
        if typeof(value) == "function" then
            return value()
        end
        
        return value
    end

    local value = getValue(Property, Theme)
    if value ~= nil then
        if typeof(value) == "string" and string.sub(value, 1, 1) ~= "#" then
            local referencedValue = Creator.GetThemeProperty(value, Theme)
            if referencedValue ~= nil then
                return referencedValue
            end
        else
            return value
        end
    end

    local fallbackProperty = Creator.ThemeFallbacks[Property]
    if fallbackProperty ~= nil then
        if typeof(fallbackProperty) == "string" and string.sub(fallbackProperty, 1, 1) ~= "#" then
            return Creator.GetThemeProperty(fallbackProperty, Theme)
        else
            return getValue(Property, {[Property] = fallbackProperty})
        end
    end

    value = getValue(Property, Creator.Themes["Dark"])
    if value ~= nil then
        if typeof(value) == "string" and string.sub(value, 1, 1) ~= "#" then
            local referencedValue = Creator.GetThemeProperty(value, Creator.Themes["Dark"])
            if referencedValue ~= nil then
                return referencedValue
            end
        else
            return value
        end
    end

    if fallbackProperty ~= nil then
        if typeof(fallbackProperty) == "string" and string.sub(fallbackProperty, 1, 1) ~= "#" then
            return Creator.GetThemeProperty(fallbackProperty, Creator.Themes["Dark"])
        else
            return getValue(Property, {[Property] = fallbackProperty})
        end
    end

    return nil
end

function Creator.AddThemeObject(Object, Properties)
    Creator.Objects[Object] = { Object = Object, Properties = Properties }
    Creator.UpdateTheme(Object, false)
    return Object
end

function Creator.AddLangObject(idx)
    local currentObj = Creator.LocalizationObjects[idx]
    local Object = currentObj.Object
    local TranslationId = currentObjTranslationId
    Creator.UpdateLang(Object, TranslationId)
    return Object
end

function Creator.UpdateTheme(TargetObject, isTween)
    local function ApplyTheme(objData)
        for Property, ColorKey in pairs(objData.Properties or {}) do
            local value = Creator.GetThemeProperty(ColorKey, Creator.Theme)
            if value ~= nil then
                if typeof(value) == "Color3" then
                    local gradient = objData.Object:FindFirstChild("WindUIGradient")
                    if gradient then
                        gradient:Destroy()
                    end
                    
                    if not isTween then
                        objData.Object[Property] = value
                    else
                        Creator.Tween(objData.Object, 0.08, { [Property] = value }):Play()
                    end
                elseif typeof(value) == "table" and value.Color and value.Transparency then
                    objData.Object[Property] = Color3.new(1, 1, 1)
                    
                    local gradient = objData.Object:FindFirstChild("WindUIGradient")
                    if not gradient then
                        gradient = Instance.new("UIGradient")
                        gradient.Name = "WindUIGradient"
                        gradient.Parent = objData.Object
                    end
                    
                    gradient.Color = value.Color
                    gradient.Transparency = value.Transparency
                    
                    for prop, propValue in pairs(value) do
                        if prop ~= "Color" and prop ~= "Transparency" and gradient[prop] ~= nil then
                            gradient[prop] = propValue
                        end
                    end
                elseif typeof(value) == "number" then
                    if not isTween then
                        objData.Object[Property] = value
                    else
                        Creator.Tween(objData.Object, 0.08, { [Property] = value }):Play()
                    end
                end
            else

                local gradient = objData.Object:FindFirstChild("WindUIGradient")
                if gradient then
                    gradient:Destroy()
                end
            end
        end
    end

    if TargetObject then
        local objData = Creator.Objects[TargetObject]
        if objData then
            ApplyTheme(objData)
        end
    else
        for _, objData in pairs(Creator.Objects) do
            ApplyTheme(objData)
        end
    end
end

function Creator.SetLangForObject(index)
    if Creator.Localization and Creator.Localization.Enabled then
        local data = Creator.LocalizationObjects[index]
        if not data then return end
        
        local obj = data.Object
        local translationId = data.TranslationId
        
        local translations = Creator.Localization.Translations[Creator.Language]
        if translations and translations[translationId] then
            obj.Text = translations[translationId]
        else
            local enTranslations = Creator.Localization and Creator.Localization.Translations and Creator.Localization.Translations.en or nil
            if enTranslations and enTranslations[translationId] then
                obj.Text = enTranslations[translationId]
            else
                obj.Text = "[" .. translationId .. "]"
            end
        end
    end
end

function Creator:ChangeTranslationKey(object, newKey)
    if Creator.Localization and Creator.Localization.Enabled then
        local ParsedKey = string.match(newKey, "^" .. Creator.Localization.Prefix .. "(.+)")
        if ParsedKey then
            for i, data in ipairs(Creator.LocalizationObjects) do
                if data.Object == object then
                    data.TranslationId = ParsedKey
                    Creator.SetLangForObject(i)
                    return
                end
            end
            
            table.insert(Creator.LocalizationObjects, {
                TranslationId = ParsedKey,
                Object = object
            })
            Creator.SetLangForObject(#Creator.LocalizationObjects)
        end
    end
end

function Creator.UpdateLang(newLang)
    if newLang then
        Creator.Language = newLang
    end
    
    for i = 1, #Creator.LocalizationObjects do
        local data = Creator.LocalizationObjects[i]
        if data.Object and data.Object.Parent ~= nil then
            Creator.SetLangForObject(i)
        else
            Creator.LocalizationObjects[i] = nil
        end
    end
end

function Creator.SetLanguage(lang)
    Creator.Language = lang
    Creator.UpdateLang()
end

function Creator.Icon(Icon, formatdefault)
    return Icons.Icon(Icon, nil, formatdefault ~= false)
end

function Creator.AddIcons(packName, iconsData)
    return Icons.AddIcons(packName, iconsData)
end

function Creator.New(Name, Properties, Children)
    local Object = Instance.new(Name)
    
    for Name, Value in next, Creator.DefaultProperties[Name] or {} do
        Object[Name] = Value
    end
    
    for Name, Value in next, Properties or {} do
        if Name ~= "ThemeTag" then
            Object[Name] = Value
        end
        if Creator.Localization and Creator.Localization.Enabled and Name == "Text" then
            local TranslationId = string.match(Value, "^" .. Creator.Localization.Prefix .. "(.+)")
            if TranslationId then
                local currentId = #Creator.LocalizationObjects + 1
                Creator.LocalizationObjects[currentId] = { TranslationId = TranslationId, Object = Object }
                
                Creator.SetLangForObject(currentId)
            end
        end
    end
    
    for _, Child in next, Children or {} do
        Child.Parent = Object
    end
    
    if Properties and Properties.ThemeTag then
        Creator.AddThemeObject(Object, Properties.ThemeTag)
    end
    if Properties and Properties.FontFace then
        Creator.AddFontObject(Object)
    end
    return Object
end

function Creator.Tween(Object, Time, Properties, ...)
    return TweenService:Create(Object, TweenInfo.new(Time, ...), Properties)
end

function Creator.NewRoundFrame(Radius, Type, Properties, Children, isButton, ReturnTable)
    local function getImageForType(shapeType)
        return Creator.Shapes[shapeType]
    end
    
    local function getSliceCenterForType(shapeType)
        return shapeType ~= "Shadow-sm" and Rect.new(
            512/2,
            512/2,
            512/2,
            512/2
        ) or Rect.new(512,512,512,512)
    end
    
    local Image = Creator.New(isButton and "ImageButton" or "ImageLabel", {
        Image = getImageForType(Type),
        ScaleType = "Slice",
        SliceCenter = getSliceCenterForType(Type),
        SliceScale = 1,
        BackgroundTransparency = 1,
        ThemeTag = Properties.ThemeTag and Properties.ThemeTag
    }, Children)
    
    for k, v in pairs(Properties or {}) do
        if k ~= "ThemeTag" then
            Image[k] = v
        end
    end

    local function UpdateSliceScale(newRadius)
        local sliceScale = Type ~= "Shadow-sm" and (newRadius / (512/2)) or (newRadius/512)
        Image.SliceScale = math.max(sliceScale, 0.0001)
    end
    
    local Wrapper = {}
    
    function Wrapper:SetRadius(newRadius)
        UpdateSliceScale(newRadius)
    end
    
    function Wrapper:SetType(newType)
        Type = newType
        Image.Image = getImageForType(newType)
        Image.SliceCenter = getSliceCenterForType(newType)
        UpdateSliceScale(Radius)
    end
    
    function Wrapper:UpdateShape(newRadius, newType)
        if newType then
            Type = newType
            Image.Image = getImageForType(newType)
            Image.SliceCenter = getSliceCenterForType(newType)
        end
        if newRadius then
            Radius = newRadius
        end
        UpdateSliceScale(Radius)
    end
    
    function Wrapper:GetRadius()
        return Radius
    end
    
    function Wrapper:GetType()
        return Type
    end
    
    UpdateSliceScale(Radius)

    return Image, ReturnTable and Wrapper or nil
end

local New = Creator.New
local Tween = Creator.Tween

function Creator.SetDraggable(can)
    Creator.CanDraggable = can
end



function Creator.Drag(mainFrame, dragFrames, ondrag)
    local currentDragFrame = nil
    local dragging, dragStart, startPos
    local DragModule = {
        CanDraggable = true
    }
    
    if not dragFrames or typeof(dragFrames) ~= "table" then
        dragFrames = {mainFrame}
    end
    
    local function update(input)
        if not dragging or not DragModule.CanDraggable then return end
        
        local delta = input.Position - dragStart
        Creator.Tween(mainFrame, 0.02, {Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )}):Play()
    end
    
    for _, dragFrame in pairs(dragFrames) do
        dragFrame.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and DragModule.CanDraggable then
                if currentDragFrame == nil then
                    currentDragFrame = dragFrame
                    dragging = true
                    dragStart = input.Position
                    startPos = mainFrame.Position
                    
                    if ondrag and typeof(ondrag) == "function" then 
                        ondrag(true, currentDragFrame)
                    end
                    
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                            currentDragFrame = nil
                            
                            if ondrag and typeof(ondrag) == "function" then 
                                ondrag(false, nil)
                            end
                        end
                    end)
                end
            end
        end)
        
        dragFrame.InputChanged:Connect(function(input)
            if dragging and currentDragFrame == dragFrame then
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    update(input)
                end
            end
        end)
    end
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and currentDragFrame ~= nil then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                update(input)
            end
        end
    end)
    
    function DragModule:Set(v)
        DragModule.CanDraggable = v
    end
    
    return DragModule
end


Icons.Init(New, "Icon")


function Creator.SanitizeFilename(url)
    local filename = url:match("([^/]+)$") or url
    
    filename = filename:gsub("%.[^%.]+$", "")
    
    filename = filename:gsub("[^%w%-_]", "_")
    
    if #filename > 50 then
        filename = filename:sub(1, 50)
    end
    
    return filename
end

local function SafeGetEnv(key)
    local ok, val = pcall(function()
        if getgenv then
            return getgenv()[key]
        end
        return nil
    end)
    if ok then return val end
    return nil
end

local function DownloadFile(url, filePath)
    local resp = Creator.Request({ Url = url, Method = "GET" })
    local body = resp and (resp.Body or resp) or ""
    writefile(filePath, body)
    local ok, asset = pcall(getcustomasset, filePath)
    if ok then return asset end
    return nil
end

function Creator.ConvertGifToMp4(url, dir, Type, Name)
    local apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDIxODQ5ZGVjMzc5NTc4N2NhMGMyNzgwMGE5ZDEzNzVmNjk0YzRmNzRiZWUzODYzYzAzOWQwNGYwMWMyYmJlOWM1ZjFhZjBmNzhiOWRiYTMiLCJpYXQiOjE3NjM5MTUzMzAuNjYxODg1LCJuYmYiOjE3NjM5MTUzMzAuNjYxODg2LCJleHAiOjQ5MTk1ODg5MzAuNjU2OTQ3LCJzdWIiOiI3MzU0OTc2MyIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.G6d420ydHlzvLFHIYUMfpgm1KgNctMeoSea484Xv8p0T7iyxqBN-6eLHzHA9H4olIneel01H_jLeEh4XOxNiCZI0P06mRaGZW41Ix2zjiCtsVxYJItOAjnmhdvWsbaYr69Kq_XzFUKYTuiXZbi7M9mqHpevCGDG6INVBhlZ4Wa87RIA0ILdAraYqu7733Ek9FI23oB8zyou5fJRsLyc7uO7Hpisy-jSSq_vBfR9tZwCu6ey3754FvFxBTHfu9t6J2yUP-UFb85UiOHl9IZ8b_M0iyASM7v1v0Z6EIEuq0PrgF2WDBjPbBUwG5N_fZC-sEFCh5NgdVArOInudIhsP6bAEwjHa_cC2c6bGQY1Nh3MVNnh2VHsz6-ArnJH8zjMlV-OqO6k92YYETgUco13xq6lm8VD2IluUtI9EGmdlkveQ3q_D8Kwn3tFQR-CbDVgsb9b1v4Ygjv_vgTUs-AYq-MPLE4tPpnh75jOArYA28hHddqqBQhQbpmBX2dx1MKeuqiz6U8hj2zmJ7WTSPBLl48lU0L_ekZpqwipJ3wTd22wauGPk1pp91KBVUFJ-C7aQKZ6tudyH-joxt5z_GBZAMUnmLFn9hytbLlbsoYHwomJn0srq8suDqWMHcV7mWhebxl8VqpYguoM-_D6EzxOn0_BmMss8oZL2RwmELX0UKZ8"
    local targetMp4 = dir .. "/" .. Type .. "-" .. Name .. ".mp4"
    if not apiKey then return nil end
    local jobBody = HttpService:JSONEncode({
        tasks = {
            ["import-1"] = { operation = "import/url", url = url },
            ["convert-1"] = { operation = "convert", input = "import-1", input_format = "gif", output_format = "mp4" },
            ["export-1"] = { operation = "export/url", input = "convert-1" }
        }
    })
    local okCreate, createRes = pcall(function()
        return Creator.Request({
            Url = "https://api.cloudconvert.com/v2/jobs",
            Method = "POST",
            Headers = {
                ["Authorization"] = "Bearer " .. apiKey,
                ["Content-Type"] = "application/json",
                ["Accept"] = "application/json",
            },
            Body = jobBody,
        })
    end)
    if not okCreate or not createRes or not createRes.Body then return nil end
    local parsedCreateOk, createData = pcall(function() return HttpService:JSONDecode(createRes.Body) end)
    if not parsedCreateOk or not createData or not createData.data or not createData.data.id then return nil end
    local jobId = createData.data.id
    local fileUrl = nil
    for i=1,60 do
        task.wait(0.5)
        local okStat, statRes = pcall(function()
            return Creator.Request({
                Url = "https://api.cloudconvert.com/v2/jobs/" .. jobId,
                Method = "GET",
                Headers = {
                    ["Authorization"] = "Bearer " .. apiKey,
                    ["Accept"] = "application/json",
                }
            })
        end)
        if okStat and statRes and statRes.Body then
            local parsedStatOk, statData = pcall(function() return HttpService:JSONDecode(statRes.Body) end)
            if parsedStatOk and statData and statData.data and statData.data.tasks then
                for _, t in pairs(statData.data.tasks) do
                    if t.operation == "export/url" and t.status == "finished" and t.result and t.result.files and t.result.files[1] and t.result.files[1].url then
                        fileUrl = t.result.files[1].url
                        break
                    end
                end
            end
        end
        if fileUrl then break end
    end
    if not fileUrl then return nil end
    local asset = DownloadFile(fileUrl, targetMp4)
    return asset
end

function Creator.ConvertGifToWebm(url, dir, Type, Name)
    local apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDIxODQ5ZGVjMzc5NTc4N2NhMGMyNzgwMGE5ZDEzNzVmNjk0YzRmNzRiZWUzODYzYzAzOWQwNGYwMWMyYmJlOWM1ZjFhZjBmNzhiOWRiYTMiLCJpYXQiOjE3NjM5MTUzMzAuNjYxODg1LCJuYmYiOjE3NjM5MTUzMzAuNjYxODg2LCJleHAiOjQ5MTk1ODg5MzAuNjU2OTQ3LCJzdWIiOiI3MzU0OTc2MyIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.G6d420ydHlzvLFHIYUMfpgm1KgNctMeoSea484Xv8p0T7iyxqBN-6eLHzHA9H4olIneel01H_jLeEh4XOxNiCZI0P06mRaGZW41Ix2zjiCtsVxYJItOAjnmhdvWsbaYr69Kq_XzFUKYTuiXZbi7M9mqHpevCGDG6INVBhlZ4Wa87RIA0ILdAraYqu7733Ek9FI23oB8zyou5fJRsLyc7uO7Hpisy-jSSq_vBfR9tZwCu6ey3754FvFxBTHfu9t6J2yUP-UFb85UiOHl9IZ8b_M0iyASM7v1v0Z6EIEuq0PrgF2WDBjPbBUwG5N_fZC-sEFCh5NgdVArOInudIhsP6bAEwjHa_cC2c6bGQY1Nh3MVNnh2VHsz6-ArnJH8zjMlV-OqO6k92YYETgUco13xq6lm8VD2IluUtI9EGmdlkveQ3q_D8Kwn3tFQR-CbDVgsb9b1v4Ygjv_vgTUs-AYq-MPLE4tPpnh75jOArYA28hHddqqBQhQbpmBX2dx1MKeuqiz6U8hj2zmJ7WTSPBLl48lU0L_ekZpqwipJ3wTd22wauGPk1pp91KBVUFJ-C7aQKZ6tudyH-joxt5z_GBZAMUnmLFn9hytbLlbsoYHwomJn0srq8suDqWMHcV7mWhebxl8VqpYguoM-_D6EzxOn0_BmMss8oZL2RwmELX0UKZ8"
    local targetWebm = dir .. "/" .. Type .. "-" .. Name .. ".webm"
    if not apiKey then return nil end
    local jobBody = HttpService:JSONEncode({
        tasks = {
            ["import-1"] = { operation = "import/url", url = url },
            ["convert-1"] = { operation = "convert", input = "import-1", input_format = "gif", output_format = "webm", video_codec = "vp9" },
            ["export-1"] = { operation = "export/url", input = "convert-1" }
        }
    })
    local okCreate, createRes = pcall(function()
        return Creator.Request({
            Url = "https://api.cloudconvert.com/v2/jobs",
            Method = "POST",
            Headers = {
                ["Authorization"] = "Bearer " .. apiKey,
                ["Content-Type"] = "application/json",
                ["Accept"] = "application/json",
            },
            Body = jobBody,
        })
    end)
    if not okCreate or not createRes or not createRes.Body then return nil end
    local parsedCreateOk, createData = pcall(function() return HttpService:JSONDecode(createRes.Body) end)
    if not parsedCreateOk or not createData or not createData.data or not createData.data.id then return nil end
    local jobId = createData.data.id
    local fileUrl = nil
    for i=1,60 do
        task.wait(0.5)
        local okStat, statRes = pcall(function()
            return Creator.Request({
                Url = "https://api.cloudconvert.com/v2/jobs/" .. jobId,
                Method = "GET",
                Headers = {
                    ["Authorization"] = "Bearer " .. apiKey,
                    ["Accept"] = "application/json",
                }
            })
        end)
        if okStat and statRes and statRes.Body then
            local parsedStatOk, statData = pcall(function() return HttpService:JSONDecode(statRes.Body) end)
            if parsedStatOk and statData and statData.data and statData.data.tasks then
                for _, t in pairs(statData.data.tasks) do
                    if t.operation == "export/url" and t.status == "finished" and t.result and t.result.files and t.result.files[1] and t.result.files[1].url then
                        fileUrl = t.result.files[1].url
                        break
                    end
                end
            end
        end
        if fileUrl then break end
    end
    if not fileUrl then return nil end
    local asset = DownloadFile(fileUrl, targetWebm)
    return asset
end

local function GetBaseUrl(url)
    return url:match("^[^%?]+") or url
end

local function LoadUrlMap(dir)
    local mapPath = dir .. "/urlmap.json"
    if isfile and isfile(mapPath) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(mapPath)) end)
        if ok and typeof(data) == "table" then return data end
    end
    return {}
end

local function SaveUrlMap(dir, map)
    local mapPath = dir .. "/urlmap.json"
    writefile(mapPath, HttpService:JSONEncode(map))
end

function Creator.Image(Img, Name, Corner, Folder, Type, IsThemeTag, Themed, ThemeTagName)
    Folder = Folder or "Temp"
    Name = Creator.SanitizeFilename(Name)
    
    local ImageFrame = New("Frame", {
        Size = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
    }, {
        New("ImageLabel", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            ScaleType = "Crop",
            ThemeTag = (Creator.Icon(Img) or Themed) and {
                ImageColor3 = IsThemeTag and (ThemeTagName or "Icon") or nil 
            } or nil,
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,Corner)
            })
        })
    })
    local ImageLabel = ImageFrame:FindFirstChildOfClass("ImageLabel")
    local SourceUrl = (type(Img) == "table" and Img.url) or Img
    local PreFileGif = (type(Img) == "table" and (Img.gif or Img.file)) or nil
    local PreFileMp4 = (type(Img) == "table" and Img.mp4) or nil
    local PreFileWebm = (type(Img) == "table" and Img.webm) or nil
    if type(SourceUrl) == "string" and Creator.Icon(SourceUrl) then
        local ic = Creator.Icon(SourceUrl)
        if not ImageLabel then
            ImageLabel = New("ImageLabel", {
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                ScaleType = "Crop",
            })
            ImageLabel.Parent = ImageFrame
        end
        ImageLabel.Image = ic[1]
        ImageLabel.ImageRectOffset = ic[2].ImageRectPosition
        ImageLabel.ImageRectSize = ic[2].ImageRectSize
    elseif type(SourceUrl) == "string" and string.find(SourceUrl,"http") then
        local dir = "ANUI/" .. Folder .. "/assets"
        if isfolder and makefolder then
            if not isfolder("ANUI") then makefolder("ANUI") end
            if not isfolder("ANUI/" .. Folder) then makefolder("ANUI/" .. Folder) end
            if not isfolder(dir) then makefolder(dir) end
        end
        local success, respErr = pcall(function()
            task.spawn(function()
                local urlKey = GetBaseUrl(SourceUrl)
                local map = LoadUrlMap(dir)
                local entry = map[urlKey]
                if PreFileWebm and isfile and isfile(dir .. "/" .. PreFileWebm) then
                    local okMp, mpAsset = pcall(getcustomasset, dir .. "/" .. PreFileWebm)
                    if okMp then
                        local VideoFrame = New("VideoFrame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1,0,1,0),
                            Video = mpAsset,
                            Looped = true,
                            Volume = 0,
                        }, {
                            New("UICorner", { CornerRadius = UDim.new(0,Corner) })
                        })
                        VideoFrame.Parent = ImageFrame
                        ImageLabel.Visible = false
                        VideoFrame:Play()
                        map[urlKey] = map[urlKey] or {}
                        map[urlKey].webm = PreFileWebm
                        SaveUrlMap(dir, map)
                        return
                    end
                end
                if PreFileMp4 and isfile and isfile(dir .. "/" .. PreFileMp4) then
                    local okMp, mpAsset = pcall(getcustomasset, dir .. "/" .. PreFileMp4)
                    if okMp then
                        local VideoFrame = New("VideoFrame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1,0,1,0),
                            Video = mpAsset,
                            Looped = true,
                            Volume = 0,
                        }, {
                            New("UICorner", { CornerRadius = UDim.new(0,Corner) })
                        })
                        VideoFrame.Parent = ImageFrame
                        ImageLabel.Visible = false
                        VideoFrame:Play()
                        map[urlKey] = map[urlKey] or {}
                        map[urlKey].mp4 = PreFileMp4
                        SaveUrlMap(dir, map)
                        return
                    end
                end
                if PreFileGif and isfile and isfile(dir .. "/" .. PreFileGif) then
                    local okGif, gifAsset = pcall(getcustomasset, dir .. "/" .. PreFileGif)
                    if okGif and ImageLabel then
                        ImageLabel.Image = gifAsset
                        ImageLabel.ScaleType = "Fit"
                    end
                end
                if entry and entry.mp4 and isfile and isfile(dir .. "/" .. entry.mp4) then
                    local okMp, mpAsset = pcall(getcustomasset, dir .. "/" .. entry.mp4)
                    if okMp then
                        local VideoFrame = New("VideoFrame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1,0,1,0),
                            Video = mpAsset,
                            Looped = true,
                            Volume = 0,
                        }, {
                            New("UICorner", { CornerRadius = UDim.new(0,Corner) })
                        })
                        VideoFrame.Parent = ImageFrame
                        ImageLabel.Visible = false
                        VideoFrame:Play()
                        return
                    end
                end
                if entry and entry.webm and isfile and isfile(dir .. "/" .. entry.webm) then
                    local okMp, mpAsset = pcall(getcustomasset, dir .. "/" .. entry.webm)
                    if okMp then
                        local VideoFrame = New("VideoFrame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1,0,1,0),
                            Video = mpAsset,
                            Looped = true,
                            Volume = 0,
                        }, {
                            New("UICorner", { CornerRadius = UDim.new(0,Corner) })
                        })
                        VideoFrame.Parent = ImageFrame
                        ImageLabel.Visible = false
                        VideoFrame:Play()
                        return
                    end
                end
                if entry and entry.gif and isfile and isfile(dir .. "/" .. entry.gif) then
                    local okGif, gifAsset = pcall(getcustomasset, dir .. "/" .. entry.gif)
                    if okGif and ImageLabel then
                        ImageLabel.Image = gifAsset
                        ImageLabel.ScaleType = "Fit"
                    end
                    local videoAsset = Creator.ConvertGifToWebm(SourceUrl, dir, Type, Name)
                    if videoAsset then
                        entry.webm = Type .. "-" .. Name .. ".webm"
                        SaveUrlMap(dir, map)
                        local VideoFrame = New("VideoFrame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1,0,1,0),
                            Video = videoAsset,
                            Looped = true,
                            Volume = 0,
                        }, {
                            New("UICorner", { CornerRadius = UDim.new(0,Corner) })
                        })
                        VideoFrame.Parent = ImageFrame
                        ImageLabel.Visible = false
                        VideoFrame:Play()
                        return
                    end
                end
                local resp = Creator.Request({ Url = SourceUrl, Method = "GET" })
                local body = resp and (resp.Body or resp) or ""
                local baseUrl = GetBaseUrl(SourceUrl)
                local ext = string.lower((baseUrl:match("%.([%w]+)$") or ""))
                local ctype = nil
                if resp and resp.Headers then
                    ctype = resp.Headers["Content-Type"] or resp.Headers["content-type"] or resp.Headers["Content-type"]
                end
                if not ext or ext == "" then
                    if ctype then
                        if string.find(ctype, "gif") then ext = "gif"
                        elseif string.find(ctype, "jpeg") or string.find(ctype, "jpg") then ext = "jpg"
                        elseif string.find(ctype, "png") then ext = "png" else ext = "png" end
                    else
                        ext = "png"
                    end
                end
                local FileName = Type .. "-" .. Name .. "." .. ext
                local FullPath = dir .. "/" .. FileName
                writefile(FullPath, body)
                map[baseUrl] = map[baseUrl] or {}
                if ext == "gif" then
                    map[baseUrl].gif = FileName
                    SaveUrlMap(dir, map)
                    if ImageLabel then ImageLabel.ScaleType = "Fit" end
                    local videoAsset = Creator.ConvertGifToWebm(SourceUrl, dir, Type, Name)
                    if videoAsset then
                        map[baseUrl].webm = Type .. "-" .. Name .. ".webm"
                        SaveUrlMap(dir, map)
                        local VideoFrame = New("VideoFrame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1,0,1,0),
                            Video = videoAsset,
                            Looped = true,
                            Volume = 0,
                        }, {
                            New("UICorner", { CornerRadius = UDim.new(0,Corner) })
                        })
                        VideoFrame.Parent = ImageFrame
                        ImageLabel.Visible = false
                        VideoFrame:Play()
                        return
                    end
                end
                local ok, asset = pcall(getcustomasset, FullPath)
                if ok then
                    if ImageLabel then ImageLabel.Image = asset end
                else
                    warn(string.format("[ ANUI.Creator ] Failed to load custom asset '%s': %s", FullPath, tostring(asset)))
                    ImageFrame:Destroy()
                    return
                end
            end)
        end)
        if not success then
            warn("[ ANUI.Creator ]  '" .. tostring(identifyexecutor and identifyexecutor() or "unknown") .. "' doesnt support the URL Images. Error: " .. tostring(respErr))
            ImageFrame:Destroy()
        end
    elseif SourceUrl == "" then
        ImageFrame.Visible = false
    else
        if ImageLabel then ImageLabel.Image = SourceUrl end
    end
    
    return ImageFrame
end


return Creator
