local Creator = require("../../modules/Creator")
local New = Creator.New
local NewRoundFrame = Creator.NewRoundFrame
local Tween = Creator.Tween

local cloneref = (cloneref or clonereference or function(instance) return instance end)

local function Color3ToHSB(color)
    local r, g, b = color.R, color.G, color.B
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local delta = max - min

    local h = 0
    if delta ~= 0 then
        if max == r then
            h = (g - b) / delta % 6
        elseif max == g then
            h = (b - r) / delta + 2
        else
            h = (r - g) / delta + 4
        end
        h = h * 60
    else
        h = 0
    end

    local s = (max == 0) and 0 or (delta / max)
    local v = max

    return {
        h = math.floor(h + 0.5),
        s = s,
        b = v
    }
end

local function GetPerceivedBrightness(color)
    local r = color.R
    local g = color.G
    local b = color.B
    return 0.299 * r + 0.587 * g + 0.114 * b
end

local function GetTextColorForHSB(color)
    local hsb = Color3ToHSB(color)
    local h, s, b = hsb.h, hsb.s, hsb.b
    if GetPerceivedBrightness(color) > 0.5 then
        return Color3.fromHSV(h / 360, 0, 0.05)
    else
        return Color3.fromHSV(h / 360, 0, 0.98)
    end
end

-- Mengubah daftar Color3 menjadi ColorSequence (rata untuk setiap titik)
local function ColorsToSequence(colors)
    if #colors == 1 then
        return ColorSequence.new(colors[1])
    end

    local keypoints = {}
    for i, color in ipairs(colors) do
        local time = (i - 1) / (#colors - 1)
        table.insert(keypoints, ColorSequenceKeypoint.new(time, color))
    end
    return ColorSequence.new(keypoints)
end

-- Menerima ColorSequence, Color3, atau table (list Color3 dan/atau { Color = ..., Rotation = ..., dst })
-- dan mengembalikan properti siap-pakai untuk Instance "UIGradient"
local function ResolveGradientProps(Gradient)
    if not Gradient then return nil end

    local ColorSeq
    local Props = {}

    if typeof(Gradient) == "ColorSequence" then
        ColorSeq = Gradient
    elseif typeof(Gradient) == "Color3" then
        ColorSeq = ColorSequence.new(Gradient)
    elseif typeof(Gradient) == "table" then
        local Colors = {}
        for _, v in ipairs(Gradient) do
            if typeof(v) == "Color3" then
                table.insert(Colors, v)
            end
        end

        if Gradient.Color then
            if typeof(Gradient.Color) == "ColorSequence" then
                ColorSeq = Gradient.Color
            elseif typeof(Gradient.Color) == "Color3" then
                ColorSeq = ColorSequence.new(Gradient.Color)
            elseif typeof(Gradient.Color) == "table" and #Gradient.Color > 0 then
                Colors = Gradient.Color
            end
        end

        if not ColorSeq and #Colors > 0 then
            ColorSeq = ColorsToSequence(Colors)
        end

        for k, v in pairs(Gradient) do
            if k ~= "Color" and typeof(k) == "string" then
                Props[k] = v
            end
        end
    end

    if not ColorSeq then return nil end

    Props.Color = ColorSeq
    return Props
end

local GRADIENT_TAG_PLAIN = "<gradient>"
local GRADIENT_TAG_CLOSE = "</gradient>"

-- Parse atribut tag, contoh: "FF3CAC,784BA0,2B86C5" atau "FF3CAC,2B86C5|90" (|rotasi opsional)
-- Mengembalikan gradient props {Color = ColorSequence, Rotation = number?} atau nil kalau tidak valid
local function ParseGradientAttr(attr)
    if not attr or attr == "" then return nil end

    local colorPart, rotationPart = attr, nil
    local barPos = string.find(attr, "|", 1, true)
    if barPos then
        colorPart = string.sub(attr, 1, barPos - 1)
        rotationPart = string.sub(attr, barPos + 1)
    end

    local colors = {}
    for hex in string.gmatch(colorPart, "[^,]+") do
        hex = hex:match("^%s*(.-)%s*$")
        if hex ~= "" then
            local ok, color = pcall(Color3.fromHex, hex)
            if ok and color then
                table.insert(colors, color)
            end
        end
    end

    if #colors == 0 then return nil end

    local props = { Color = ColorsToSequence(colors) }
    if rotationPart then
        local rotationNum = tonumber(rotationPart)
        if rotationNum then
            props.Rotation = rotationNum
        end
    end

    return props
end

-- Memecah teks menjadi beberapa segmen: teks biasa, gambar (rbxassetid://),
-- dan teks yang ditandai tag gradient (agar hanya sebagian teks yang gradient).
-- Mendukung dua bentuk tag:
--   <gradient>...</gradient>              -> pakai TitleGradient/DescGradient milik elemen
--   <gradient=HEX1,HEX2,...>...</gradient> -> gradient custom miliknya sendiri (bisa beda-beda per tag)
local function ParseTextSegments(str)
    local Segments = {}
    local pos = 1
    local CurrentGradient = false -- false = normal, true = pakai gradient elemen, table = gradient custom
    local length = #str

    while pos <= length do
        local imgS, imgE = string.find(str, "rbxassetid://%d+", pos)
        local plainS, plainE = string.find(str, GRADIENT_TAG_PLAIN, pos, true)
        local attrS, attrE, attrCapture = string.find(str, "<gradient=([^>]*)>", pos)
        local closeS, closeE = string.find(str, GRADIENT_TAG_CLOSE, pos, true)

        local nextS, nextE, kind, attrVal
        for _, candidate in ipairs({
            {s = imgS, e = imgE, k = "Image"},
            {s = plainS, e = plainE, k = "OpenPlain"},
            {s = attrS, e = attrE, k = "OpenAttr", attr = attrCapture},
            {s = closeS, e = closeE, k = "Close"},
        }) do
            if candidate.s and (not nextS or candidate.s < nextS) then
                nextS, nextE, kind, attrVal = candidate.s, candidate.e, candidate.k, candidate.attr
            end
        end

        if not nextS then
            local rest = string.sub(str, pos)
            if rest ~= "" then
                table.insert(Segments, {Type = "Text", Content = rest, Gradient = CurrentGradient})
            end
            break
        end

        local textPart = string.sub(str, pos, nextS - 1)
        if textPart ~= "" then
            table.insert(Segments, {Type = "Text", Content = textPart, Gradient = CurrentGradient})
        end

        if kind == "Image" then
            table.insert(Segments, {Type = "Image", Content = string.sub(str, nextS, nextE)})
        elseif kind == "OpenPlain" then
            CurrentGradient = true
        elseif kind == "OpenAttr" then
            CurrentGradient = ParseGradientAttr(attrVal) or true
        elseif kind == "Close" then
            CurrentGradient = false
        end

        pos = nextE + 1
    end

    return Segments
end

-- Cek apakah teks butuh dipecah jadi beberapa TextLabel (ada gambar inline dan/atau tag gradient parsial)
local function HasRichTokens(str)
    if not str or str == "" then return false end
    return string.find(str, "rbxassetid://%d+") ~= nil
        or string.find(str, GRADIENT_TAG_PLAIN, 1, true) ~= nil
        or string.find(str, "<gradient=", 1, true) ~= nil
end

-- Mengubah nilai Gradient sebuah segmen (false/true/table) menjadi UIGradient props final
local function ResolveItemGradientProps(GradientValue, ElementGradient)
    if typeof(GradientValue) == "table" then
        return ResolveGradientProps(GradientValue)
    elseif GradientValue ~= false then
        return ResolveGradientProps(ElementGradient)
    end
    return nil
end

-- Signature ringkas untuk membandingkan apakah gradient sebuah segmen berubah (dipakai untuk reuse instance)
local function GradientSignature(GradientValue)
    if GradientValue == false or GradientValue == nil then
        return ""
    elseif GradientValue == true then
        return "@default"
    elseif typeof(GradientValue) == "table" and GradientValue.Color then
        local parts = {}
        for _, kp in ipairs(GradientValue.Color.Keypoints) do
            table.insert(parts, string.format("%.3f:%s", kp.Time, kp.Value:ToHex()))
        end
        if GradientValue.Rotation then
            table.insert(parts, "R" .. tostring(GradientValue.Rotation))
        end
        return table.concat(parts, "|")
    end
    return ""
end

-- Menambah/memperbarui/menghapus UIGradient "TextGradient" pada sebuah TextLabel
local function ApplyGradientToLabel(Label, GradientProps)
    if not Label then return end

    local Existing = Label:FindFirstChild("TextGradient")

    if GradientProps then
        if not Existing then
            Existing = Instance.new("UIGradient")
            Existing.Name = "TextGradient"
            Existing.Parent = Label
        end
        for k, v in pairs(GradientProps) do
            Existing[k] = v
        end
        Label.TextColor3 = Color3.new(1, 1, 1)
    elseif Existing then
        Existing:Destroy()
    end
end

local function getElementPosition(elements, targetIndex)
    if type(targetIndex) ~= "number" or targetIndex ~= math.floor(targetIndex) then
        return nil, 1
    end

    local maxIndex = #elements
    
    if maxIndex == 0 or targetIndex < 1 or targetIndex > maxIndex then
        return nil, 2
    end

    local function isDelimiter(el)
        if el == nil then return true end
        local t = el.__type
        return t == "Divider" or t == "Space" or t == "Section" or t == "Code" or t == "Paragraph"
    end

    if isDelimiter(elements[targetIndex]) then
        return nil, 3
    end

    local function calculate(pos, size)
        if size == 1 then return "Squircle" end
        if pos == 1 then return "Squircle-TL-TR" end
        if pos == size then return "Squircle-BL-BR" end
        return "Square"
    end

    local groupStart = 1
    local groupCount = 0

    for i = 1, maxIndex do
        local el = elements[i]
        if isDelimiter(el) then
            if targetIndex >= groupStart and targetIndex <= i - 1 then
                local pos = targetIndex - groupStart + 1
                return calculate(pos, groupCount)
            end
            groupStart = i + 1
            groupCount = 0
        else
            groupCount = groupCount + 1
        end
    end

    if targetIndex >= groupStart and targetIndex <= maxIndex then
        local pos = targetIndex - groupStart + 1
        return calculate(pos, groupCount)
    end

    return nil, 4
end

return function(Config)
    local Element = {
        Title = Config.Title,
        Desc = Config.Desc or nil,
        Hover = Config.Hover,
        Thumbnail = Config.Thumbnail,
        ThumbnailSize = Config.ThumbnailSize or 80,
        Image = Config.Image,
        IconThemed = Config.IconThemed or false,
        ImageSize = Config.ImageSize or 30,
        Color = Config.Color,
        TitleGradient = Config.TitleGradient,
        DescGradient = Config.DescGradient,
        Scalable = Config.Scalable,
        Parent = Config.Parent,
        Justify = Config.Justify or "Between", 
        UIPadding = Config.Window.ElementConfig.UIPadding,
        UICorner = Config.Window.ElementConfig.UICorner,
        UIElements = {},
        DescColumnWidth = Config.DescColumnWidth,
        
        Index = Config.Index
    }
    
    local ImageSize = Element.ImageSize
    local ThumbnailSize = Element.ThumbnailSize
    local CanHover = true
    local IconOffset = 0
    
    local ThumbnailFrame
    local ImageFrame
    if Element.Thumbnail then
        ThumbnailFrame = Creator.Image(
            Element.Thumbnail, 
            Element.Title, 
            Config.Window.NewElements and Element.UICorner-11 or (Element.UICorner-4), 
            Config.Window.Folder,
            "Thumbnail",
            false,
            Element.IconThemed
        )
        ThumbnailFrame.Size = UDim2.new(1,0,0,ThumbnailSize)
    end
    if Element.Image then
        ImageFrame = Creator.Image(
            Element.Image, 
            Element.Title, 
            Config.Window.NewElements and Element.UICorner-11 or (Element.UICorner-4), 
            Config.Window.Folder,
            "Image",
            Element.IconThemed,
            not Element.Color and true or false,
            "ElementIcon"
        )
        if typeof(Element.Color) == "string" then 
            ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
        elseif typeof(Element.Color) == "Color3" then
            ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Element.Color)
        end
        
        ImageFrame.Size = UDim2.new(0,ImageSize,0,ImageSize)
        
        IconOffset = ImageSize
    end
    
    -- Helper Create Text
    -- UseGradient: nil/true = ikuti gradient elemen (default, untuk teks tanpa tag <gradient>)
    --              false = paksa warna normal (dipakai untuk segmen teks di luar tag <gradient>)
    local function CreateText(Title, Type, UseGradient)
        local TextColor = typeof(Element.Color) == "string" 
            and GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
            or typeof(Element.Color) == "Color3" 
            and GetTextColorForHSB(Element.Color)
        
        local GradientProps = ResolveItemGradientProps(UseGradient, Type == "Desc" and Element.DescGradient or Element.TitleGradient)
        
        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Text = Title or "",
            TextSize = Type == "Desc" and 15 or 17,
            TextXAlignment = "Left",
            ThemeTag = {
                TextColor3 = (not Element.Color and not GradientProps) and ("Element" .. Type) or nil,
            },
            TextColor3 = GradientProps and Color3.new(1, 1, 1) or (Element.Color and TextColor or nil),
            TextTransparency = Type == "Desc" and .3 or 0,
            TextWrapped = true,
            Size = UDim2.new(Element.Justify == "Between" and 1 or 0,0,0,0),
            AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
            FontFace = Font.new(Creator.Font, Type == "Desc" and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold)
        })
        
        ApplyGradientToLabel(Label, GradientProps)
        
        return Label
    end
    
    local Title = CreateText(Element.Title, "Title")
    local TitleRich = New("Frame", {
        Name = "TitleRich",
        BackgroundTransparency = 1,
        Size = UDim2.new(Element.Justify == "Between" and 1 or 0,0,0,0),
        AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
        Visible = false,
    }, {
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
    })
    
    -- Container Deskripsi
    local DescContainer = New("Frame", {
        Name = "DescContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, {
        New("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 2),
        })
    })

    -- [FUNGSI OPTIMASI LAG] UpdateDesc dengan Reuse Instance
    local function UpdateDesc(text)

        if not text or text == "" then
            DescContainer.Visible = false
            return
        end
        DescContainer.Visible = true

        local function parseInline(str)
            return ParseTextSegments(str)
        end

        local function getColumnWidth()
            if typeof(Element.DescColumnWidth) == "number" and Element.DescColumnWidth > 0 then
                return math.floor(Element.DescColumnWidth)
            end
            
            local w = DescContainer.AbsoluteSize.X
            if not w or w <= 0 then
                return 320
            end
            return math.clamp(math.floor(w * 0.62), 220, 520)
        end

        local function getOrCreateListLayout(parent)
            local layout = parent:FindFirstChild("UIListLayout")
            if not layout then
                layout = New("UIListLayout", {
                    Parent = parent,
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4),
                    VerticalAlignment = Enum.VerticalAlignment.Center
                })
            else
                layout.FillDirection = Enum.FillDirection.Horizontal
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Padding = UDim.new(0, 4)
                layout.VerticalAlignment = Enum.VerticalAlignment.Center
            end
            return layout
        end

        local function updateItemsInContainer(container, items)
            local currentItems = {}
            for _, c in ipairs(container:GetChildren()) do 
                if c:IsA("GuiObject") then table.insert(currentItems, c) end 
            end

            for j, itemData in ipairs(items) do
                local itemFrame = currentItems[j]
                
                if itemFrame then
                    local isText = itemFrame:IsA("TextLabel")
                    local isImage = itemFrame:IsA("ImageLabel")
                    local gradientChanged = isText and (itemFrame:GetAttribute("GradientSig") ~= GradientSignature(itemData.Gradient))
                    if (itemData.Type == "Text" and not isText) or (itemData.Type == "Image" and not isImage) or gradientChanged then
                        itemFrame:Destroy()
                        itemFrame = nil
                    end
                end

                if not itemFrame then
                    if itemData.Type == "Text" then
                        itemFrame = CreateText(itemData.Content, "Desc", itemData.Gradient)
                        itemFrame:SetAttribute("GradientSig", GradientSignature(itemData.Gradient))
                        itemFrame.Parent = container
                    else
                        itemFrame = New("ImageLabel", {
                            Parent = container,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0, 16, 0, 16),
                            ScaleType = Enum.ScaleType.Fit,
                            ThemeTag = { ImageColor3 = "ElementDesc" },
                            ImageTransparency = 0.3
                        })
                    end
                end
                
                itemFrame.LayoutOrder = j
                itemFrame.Visible = true
                
                if itemData.Type == "Text" then
                    if itemFrame.Text ~= itemData.Content then
                        itemFrame.Text = itemData.Content
                    end
                    ApplyGradientToLabel(itemFrame, ResolveItemGradientProps(itemData.Gradient, Element.DescGradient))
                    if #items == 1 then
                        itemFrame.Size = UDim2.new(1, 0, 0, 0)
                        itemFrame.AutomaticSize = Enum.AutomaticSize.Y
                        itemFrame.TextWrapped = true
                    else
                        itemFrame.Size = UDim2.new(0, 0, 0, 0)
                        itemFrame.AutomaticSize = Enum.AutomaticSize.XY
                        itemFrame.TextWrapped = false 
                    end
                else
                    if itemFrame.Image ~= itemData.Content then
                        itemFrame.Image = itemData.Content
                    end
                    if Element.Color then
                        if typeof(Element.Color) == "string" then
                            itemFrame.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
                        elseif typeof(Element.Color) == "Color3" then
                            itemFrame.ImageColor3 = GetTextColorForHSB(Element.Color)
                        end
                    end
                end
            end
            
            for k = #items + 1, #currentItems do
                currentItems[k]:Destroy()
            end
        end

        local lines = string.split(text, "\n")
        local parsedData = {}
        for _, line in ipairs(lines) do
            local cols = string.split(line, "\t")
            if #cols >= 2 then
                table.insert(parsedData, {Cols = {parseInline(cols[1] or ""), parseInline(cols[2] or "")}})
            else
                table.insert(parsedData, {Cols = {parseInline(line)}})
            end
        end

        local currentLines = {}
        for _, c in ipairs(DescContainer:GetChildren()) do
            if c:IsA("Frame") then table.insert(currentLines, c) end
        end

        for i, lineData in ipairs(parsedData) do
            local lineFrame = currentLines[i]
            
            if not lineFrame then
                lineFrame = New("Frame", {
                    Parent = DescContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
            end
            lineFrame.LayoutOrder = i
            lineFrame.Visible = true

            local cols = lineData.Cols
            if #cols >= 2 then
                local colWidth = getColumnWidth()
                local lineLayout = getOrCreateListLayout(lineFrame)
                lineLayout.Padding = UDim.new(0, 0)

                local leftCol = lineFrame:FindFirstChild("Col1")
                if not leftCol then
                    leftCol = New("Frame", {
                        Name = "Col1",
                        Parent = lineFrame,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, colWidth, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                    })
                    getOrCreateListLayout(leftCol)
                else
                    leftCol.Size = UDim2.new(0, colWidth, 0, 0)
                    leftCol.AutomaticSize = Enum.AutomaticSize.Y
                    getOrCreateListLayout(leftCol)
                end

                local rightCol = lineFrame:FindFirstChild("Col2")
                if not rightCol then
                    rightCol = New("Frame", {
                        Name = "Col2",
                        Parent = lineFrame,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -colWidth, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                    })
                    getOrCreateListLayout(rightCol)
                else
                    rightCol.Size = UDim2.new(1, -colWidth, 0, 0)
                    rightCol.AutomaticSize = Enum.AutomaticSize.Y
                    getOrCreateListLayout(rightCol)
                end

                for _, c in ipairs(lineFrame:GetChildren()) do
                    if c:IsA("GuiObject") and c ~= leftCol and c ~= rightCol then
                        c:Destroy()
                    end
                end

                updateItemsInContainer(leftCol, cols[1])
                updateItemsInContainer(rightCol, cols[2])
            else
                for _, c in ipairs(lineFrame:GetChildren()) do
                    if c:IsA("Frame") and (c.Name == "Col1" or c.Name == "Col2") then
                        c:Destroy()
                    end
                end
                
                getOrCreateListLayout(lineFrame)
                updateItemsInContainer(lineFrame, cols[1])
            end
        end

        for k = #parsedData + 1, #currentLines do
            currentLines[k]:Destroy()
        end
    end
    
    local function UpdateTitle(text)
        Title.Text = text or ""
        ApplyGradientToLabel(Title, ResolveGradientProps(Element.TitleGradient))
        
        if not text or text == "" then
            Title.Visible = true
            TitleRich.Visible = false
            return
        end
        
        if not HasRichTokens(text) then
            Title.Visible = true
            TitleRich.Visible = false
            return
        end
        
        Title.Visible = false
        TitleRich.Visible = true
        
        for _, c in ipairs(TitleRich:GetChildren()) do
            if c:IsA("GuiObject") then
                c:Destroy()
            end
        end
        
        local items = ParseTextSegments(text)
        
        for idx, item in ipairs(items) do
            if item.Type == "Text" then
                local lbl = CreateText(item.Content, "Title", item.Gradient)
                lbl.LayoutOrder = idx
                if #items == 1 then
                    lbl.Size = UDim2.new(1, 0, 0, 0)
                    lbl.AutomaticSize = Enum.AutomaticSize.Y
                    lbl.TextWrapped = true
                else
                    lbl.Size = UDim2.new(0, 0, 0, 0)
                    lbl.AutomaticSize = Enum.AutomaticSize.XY
                    lbl.TextWrapped = false
                end
                lbl.Parent = TitleRich
            else
                local img = New("ImageLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 18, 0, 18),
                    ScaleType = Enum.ScaleType.Fit,
                    ThemeTag = { ImageColor3 = "ElementTitle" },
                    ImageTransparency = 0,
                    Image = item.Content,
                    LayoutOrder = idx,
                })
                
                if Element.Color then
                    if typeof(Element.Color) == "string" then
                        img.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
                    elseif typeof(Element.Color) == "Color3" then
                        img.ImageColor3 = GetTextColorForHSB(Element.Color)
                    end
                end
                
                img.Parent = TitleRich
            end
        end
    end
    
    Element.UIElements.Container = New("Frame", {
        Size = UDim2.new(1,0,1,0),
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0,Element.UIPadding),
            FillDirection = "Vertical",
            VerticalAlignment = "Center",
            HorizontalAlignment = Element.Justify == "Between" and "Left" or "Center",
        }),
        ThumbnailFrame,
        New("Frame", {
            Size = UDim2.new(
                Element.Justify == "Between" and 1 or 0,
                Element.Justify == "Between" and -Config.TextOffset or 0,
                0,
                0
            ),
            AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
            BackgroundTransparency = 1,
            Name = "TitleFrame",
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,Element.UIPadding),
                FillDirection = "Horizontal",
                -- Title & Description harus selalu tetap di posisi atas (Top) dan tidak boleh
                -- ikut bergeser/ter-center mengikuti tinggi Icon atau Image, apa pun jenis
                -- elemennya (Toggle, Dropdown, Paragraph, dll). Icon/Image yang lebih tinggi
                -- dari Title+Desc cukup "menjulur" ke bawah dari titik atas yang sama.
                VerticalAlignment = Config.Window.NewElements and ( Element.Justify == "Between" and "Top" or "Center" ) or "Center",
                HorizontalAlignment = Element.Justify ~= "Between" and Element.Justify or "Center",
            }),
            ImageFrame,
            New("Frame", {
                BackgroundTransparency = 1,
                AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
                Size = UDim2.new(
                    Element.Justify == "Between" and 1 or 0,
                    Element.Justify == "Between" and ( ImageFrame and -IconOffset-Element.UIPadding or -IconOffset ) or 0,
                    1,
                    0
                ),
                Name = "TitleFrame",
            }, {
                New("UIPadding", {
                    PaddingTop = UDim.new(0,Config.Window.NewElements and Element.UIPadding/2 or 0),
                    PaddingLeft = UDim.new(0,Config.Window.NewElements and Element.UIPadding/2 or 0),
                    PaddingRight = UDim.new(0,Config.Window.NewElements and Element.UIPadding/2 or 0),
                    PaddingBottom = UDim.new(0,Config.Window.NewElements and Element.UIPadding/2 or 0),
                }),
                New("UIListLayout", {
                    Padding = UDim.new(0,6),
                    FillDirection = "Vertical",
                    VerticalAlignment = "Center",
                    HorizontalAlignment = "Left",
                }),
                Title,
                TitleRich,
                DescContainer -- Menggunakan Container Pintar
            }),
        })
    })
    
    -- Ambil custom config, fallback ke "lock"
    local LockIconAsset = Config.LockedIcon or Config.LockIcon or "lock"
    local LockedIconSize = Config.LockedIconSize or 20
    local LockedIconColor = Config.LockedIconColor or Color3.new(1,1,1)
    local LockedIconTransparency = Config.LockedIconTransparency or .4

    local LockedIcon = Creator.Image(
        LockIconAsset, "lock", 0, Config.Window.Folder, "Lock", false
    )
    LockedIcon.Size = UDim2.new(0, LockedIconSize, 0, LockedIconSize)
    LockedIcon.ImageLabel.ImageColor3 = LockedIconColor
    LockedIcon.ImageLabel.ImageTransparency = LockedIconTransparency
    
    local LockedTitle = New("TextLabel", {
        Text = "Locked",
        TextSize = 18,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        AutomaticSize = "XY",
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1,1,1),
        TextTransparency = .05,
    })
    
    local ElementFullFrame = New("Frame", {
        Size = UDim2.new(1,Element.UIPadding*2,1,Element.UIPadding*2),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.new(0.5,0,0.5,0),
        ZIndex = 9999999,
    })
    
    local Locked, LockedTable = NewRoundFrame(Element.UICorner, "Squircle", {
        Size = UDim2.new(1,0,1,0),
        ImageTransparency = .25,
        ImageColor3 = Color3.new(0,0,0),
        Visible = false,
        Active = false,
        Parent = ElementFullFrame,
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            Padding = UDim.new(0,8)
        }),
        LockedIcon, LockedTitle
    }, nil, true)
    
    local HighlightOutline, HighlightOutlineTable = NewRoundFrame(Element.UICorner, "Squircle-Outline", {
        Size = UDim2.new(1,0,1,0),
        ImageTransparency = 1, 
        Active = false,
        ThemeTag = { ImageColor3 = "Text" },
        Parent = ElementFullFrame,
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            Padding = UDim.new(0,8)
        }),
    }, nil, true)
    
    local Highlight, HighlightTable = NewRoundFrame(Element.UICorner, "Squircle", {
        Size = UDim2.new(1,0,1,0),
        ImageTransparency = 1, 
        Active = false,
        ThemeTag = { ImageColor3 = "Text" },
        Parent = ElementFullFrame,
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            Padding = UDim.new(0,8)
        }),
    }, nil, true)
    
    local HoverOutline, HoverOutlineTable = NewRoundFrame(Element.UICorner, "Squircle-Outline", {
        Size = UDim2.new(1,0,1,0),
        ImageTransparency = 1, 
        Active = false,
        ThemeTag = { ImageColor3 = "Text" },
        Parent = ElementFullFrame,
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            Padding = UDim.new(0,8)
        }),
        New("UIGradient", {
            Name = "HoverGradient",
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),     
                NumberSequenceKeypoint.new(0.25, 0.9),
                NumberSequenceKeypoint.new(0.5, 0.3), 
                NumberSequenceKeypoint.new(0.75, 0.9), 
                NumberSequenceKeypoint.new(1, 1)      
            }),
        }),
    }, nil, true)
    
    local Hover, HoverTable = NewRoundFrame(Element.UICorner, "Squircle", {
        Size = UDim2.new(1,0,1,0),
        ImageTransparency = 1, 
        Active = false,
        ThemeTag = { ImageColor3 = "Text" },
        Parent = ElementFullFrame,
    }, {
        New("UIGradient", {
            Name = "HoverGradient",
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),     
                NumberSequenceKeypoint.new(0.25, 0.9),
                NumberSequenceKeypoint.new(0.5, 0.3), 
                NumberSequenceKeypoint.new(0.75, 0.9), 
                NumberSequenceKeypoint.new(1, 1)      
            }),
        }),
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            Padding = UDim.new(0,8)
        }),
    }, nil, true)
    
    local Main, MainTable = NewRoundFrame(Element.UICorner, "Squircle", {
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = "Y",
        ImageTransparency = Element.Color and .05 or .93,
        Parent = Config.Parent,
        ThemeTag = {
            ImageColor3 = not Element.Color and "ElementBackground" or nil
        },
        ImageColor3 = Element.Color and 
            ( 
                typeof(Element.Color) == "string" 
                    and Color3.fromHex(Creator.Colors[Element.Color]) 
                    or typeof(Element.Color) == "Color3" 
                    and Element.Color
            ) or nil
    }, {
        Element.UIElements.Container,
        ElementFullFrame,
        New("UIPadding", {
            PaddingTop = UDim.new(0,Element.UIPadding),
            PaddingLeft = UDim.new(0,Element.UIPadding),
            PaddingRight = UDim.new(0,Element.UIPadding),
            PaddingBottom = UDim.new(0,Element.UIPadding),
        }),
    }, true, true)
    
    Element.UIElements.Main = Main
    Element.UIElements.Locked = Locked
    
    if Element.Hover then
        Creator.AddSignal(Main.MouseEnter, function()
            if CanHover then
                Tween(Main, .12, {ImageTransparency = Element.Color and .15 or .9}):Play()
                Tween(Hover, .12, {ImageTransparency = .9}):Play()
                Tween(HoverOutline, .12, {ImageTransparency = .8}):Play()
                Creator.AddSignal(Main.MouseMoved, function(x,y)
                    Hover.HoverGradient.Offset = Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
                    HoverOutline.HoverGradient.Offset = Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
                end)
            end
        end)
        Creator.AddSignal(Main.InputEnded, function()
            if CanHover then
                Tween(Main, .12, {ImageTransparency = Element.Color and .05 or .93}):Play()
                Tween(Hover, .12, {ImageTransparency = 1}):Play()
                Tween(HoverOutline, .12, {ImageTransparency = 1}):Play()
            end
        end)
    end
    
    function Element:SetTitle(text)
        Element.Title = text
        UpdateTitle(text)
    end
    
    function Element:SetTitleGradient(gradient)
        Element.TitleGradient = gradient
        UpdateTitle(Element.Title)
    end
    
    function Element:SetDescGradient(gradient)
        Element.DescGradient = gradient
        UpdateDesc(Element.Desc)
    end
    
    function Element:SetDesc(text)
        -- [OPTIMASI 1] Equality Check: Jika teks sama persis, JANGAN update apapun.
        if Element.Desc == text then
            return 
        end
        
        Element.Desc = text
        UpdateDesc(text) -- Panggil parser yang sudah dioptimasi
        
        if Config.ElementTable then
             Config.ElementTable.Desc = text
        end
    end
    
    -- Inisialisasi awal
    UpdateDesc(Element.Desc)
    UpdateTitle(Element.Title)

    function Element:Colorize(obj, prop)
        if Element.Color then
            obj[prop] = typeof(Element.Color) == "string" 
                and GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
                or typeof(Element.Color) == "Color3" 
                and GetTextColorForHSB(Element.Color)
                or nil 
        end
    end
    
    if Config.ElementTable then
        if Title and Title.GetPropertyChangedSignal then
            Creator.AddSignal(Title:GetPropertyChangedSignal("Text"), function()
                if Element.Title ~= Title.Text then
                    Element:SetTitle(Title.Text)
                    Config.ElementTable.Title = Title.Text
                end
            end)
        end
    end
    
    function Element:SetThumbnail(newThumbnail, newSize)
        Element.Thumbnail = newThumbnail
        if newSize then
            Element.ThumbnailSize = newSize
            ThumbnailSize = newSize
        end
        
        if ThumbnailFrame then
            if newThumbnail then
                ThumbnailFrame:Destroy()
                ThumbnailFrame = Creator.Image(
                    newThumbnail, 
                    Element.Title, 
                    Element.UICorner-3, 
                    Config.Window.Folder,
                    "Thumbnail",
                    false,
                    Element.IconThemed
                )
                ThumbnailFrame.Size = UDim2.new(1,0,0,ThumbnailSize)
                ThumbnailFrame.Parent = Element.UIElements.Container
                local layout = Element.UIElements.Container:FindFirstChild("UIListLayout")
                if layout then
                    ThumbnailFrame.LayoutOrder = -1
                end
            else
                ThumbnailFrame.Visible = false
            end
        else
            if newThumbnail then
                ThumbnailFrame = Creator.Image(
                    newThumbnail, 
                    Element.Title, 
                    Element.UICorner-3, 
                    Config.Window.Folder,
                    "Thumbnail",
                    false,
                    Element.IconThemed
                )
                ThumbnailFrame.Size = UDim2.new(1,0,0,ThumbnailSize)
                ThumbnailFrame.Parent = Element.UIElements.Container
                local layout = Element.UIElements.Container:FindFirstChild("UIListLayout")
                if layout then
                    ThumbnailFrame.LayoutOrder = -1
                end
            end
        end
    end
    
    function Element:SetImage(newImage, newSize)
        Element.Image = newImage
        if newSize then
            Element.ImageSize = newSize
            ImageSize = newSize
        end

        local oldFrame = ImageFrame
        if newImage then
            local newFrame = Creator.Image(
                newImage,
                Element.Title,
                Element.UICorner-3,
                Config.Window.Folder,
                "Image",
                not Element.Color and true or false
            )
            if typeof(Element.Color) == "string" and newFrame.ImageLabel then
                newFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
            elseif typeof(Element.Color) == "Color3" and newFrame.ImageLabel then
                newFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Element.Color)
            end
            newFrame.Visible = true
            newFrame.Size = UDim2.new(0, ImageSize, 0, ImageSize)
            IconOffset = ImageSize
            if oldFrame and oldFrame.Parent then oldFrame:Destroy() end
            newFrame.Parent = Element.UIElements.Container.TitleFrame
            ImageFrame = newFrame
        else
            if ImageFrame then
                ImageFrame.Visible = false
            end
            IconOffset = 0
        end

        Element.UIElements.Container.TitleFrame.TitleFrame.Size = UDim2.new(1, -IconOffset, 1, 0)
    end
    
    function Element:Destroy()
        Main:Destroy()
    end

    function Element:SetLockedIcon(asset, size, color, transparency)
        if LockedIcon and LockedIcon.ImageLabel then
            if asset then
                LockedIcon.ImageLabel.Image = asset
            end
            if size then
                LockedIcon.Size = UDim2.new(0, size, 0, size)
            end
            if color then
                LockedIcon.ImageLabel.ImageColor3 = color
            end
            if transparency then
                LockedIcon.ImageLabel.ImageTransparency = transparency
            end
        end
    end
    function Element:Lock(text,Image) -- Tambahkan 'text' di dalam kurung
        CanHover = false
        LockIconAsset = Image or LockIconAsset
        LockedTitle.Text = text or "Locked" -- Tambahkan baris ini untuk ganti teksnya
        Locked.Active = true
        Locked.Visible = true
    end
    
    function Element:Unlock()
        CanHover = true
        Locked.Active = false
        Locked.Visible = false
    end
    
    function Element:Highlight()
        local OutlineGradient = New("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),     
                NumberSequenceKeypoint.new(0.1, 0.9),
                NumberSequenceKeypoint.new(0.5, 0.3), 
                NumberSequenceKeypoint.new(0.9, 0.9), 
                NumberSequenceKeypoint.new(1, 1)      
            }),
            Rotation = 0,
            Offset = Vector2.new(-1, 0),
            Parent = HighlightOutline
        })
        
        local HighlightGradient = New("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),     
                NumberSequenceKeypoint.new(0.15, 0.8),
                NumberSequenceKeypoint.new(0.5, 0.1), 
                NumberSequenceKeypoint.new(0.85, 0.8), 
                NumberSequenceKeypoint.new(1, 1)      
            }),
            Rotation = 0,
            Offset = Vector2.new(-1, 0),
            Parent = Highlight
        })
        
        HighlightOutline.ImageTransparency = 0.65
        Highlight.ImageTransparency = 0.88
        
        Tween(OutlineGradient, 0.75, {
            Offset = Vector2.new(1, 0)
        }):Play()
        
        Tween(HighlightGradient, 0.75, {
            Offset = Vector2.new(1, 0)
        }):Play()
        
        task.spawn(function()
            task.wait(.75)
            HighlightOutline.ImageTransparency = 1
            Highlight.ImageTransparency = 1
            OutlineGradient:Destroy()
            HighlightGradient:Destroy()
        end)
    end
    
    function Element.UpdateShape(Tab)
        if Config.Window.NewElements then
            local newShape
            local pType = Config.ParentType or (Config.ParentConfig and Config.ParentConfig.ParentType)
            if pType == "Group" or pType == "Paragraph" then
                newShape = "Squircle"
            else
                newShape = getElementPosition(Tab.Elements, Element.Index)
            end
            
            if newShape and Main then
                MainTable:SetType(newShape)
                LockedTable:SetType(newShape)
                HighlightTable:SetType(newShape)
                HighlightOutlineTable:SetType(newShape .. "-Outline")
                HoverTable:SetType(newShape)
                HoverOutlineTable:SetType(newShape .. "-Outline")
            end
        end
    end
    
    return Element
end
