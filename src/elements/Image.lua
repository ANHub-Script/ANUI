local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

local function ParseAspectRatio(aspectRatio)
    if type(aspectRatio) == "string" then
        local width, height = aspectRatio:match("([%d%.]+)%s*[:xX]%s*([%d%.]+)")
        if width and height and tonumber(height) ~= 0 then
            return tonumber(width) / tonumber(height)
        end
    elseif type(aspectRatio) == "number" then
        return aspectRatio
    end
    return nil
end

-- "Native"/"Original"/"Auto" = pakai rasio asli gambarnya
local function IsNativeAspect(value)
    if type(value) ~= "string" then return false end
    value = string.lower(value)
    return value == "native" or value == "original" or value == "auto"
end

function Element:New(Config)
    local ImageModule = {
        __type = "Image",
        Image = Config.Image or "",
        AspectRatio = Config.AspectRatio or "16:9",
        Radius = Config.Radius or Config.Window.ElementConfig.UICorner,

        -- default: gambar TIDAK dipotong, hanya diskalakan proporsional
        ScaleType = Config.ScaleType or (Config.Crop and "Crop") or "Fit",
        -- Native = tinggi elemen mengikuti rasio asli gambar
        Native = Config.Native or Config.KeepAspect or IsNativeAspect(Config.AspectRatio) or false,
        NativeSize = Config.NativeSize,
        Height = Config.Height,
        Size = Config.Size,
    }

    local MainImage
    local aspectRatioConstraint

    -- Rasio awal: dari NativeSize / AspectRatio config.
    -- Kalau minta rasio asli tapi belum terdeteksi, sementara pakai 16:9
    -- lalu diperbaiki otomatis begitu ukuran asli gambar diketahui.
    local nativeSizeVec = Creator.ToVector2(ImageModule.NativeSize)
    local aspectRatio
    if nativeSizeVec and nativeSizeVec.Y > 0 then
        aspectRatio = nativeSizeVec.X / nativeSizeVec.Y
    else
        aspectRatio = ParseAspectRatio(ImageModule.AspectRatio) or (ImageModule.Native and 16/9 or nil)
    end

    local function ApplyAspectRatio(ratio)
        if not ratio or ratio <= 0 then return end
        aspectRatio = ratio
        if aspectRatioConstraint then
            aspectRatioConstraint.AspectRatio = ratio
        elseif MainImage then
            aspectRatioConstraint = New("UIAspectRatioConstraint", {
                Parent = MainImage,
                AspectRatio = ratio,
                AspectType = "ScaleWithParentSize",
                DominantAxis = "Width"
            })
        end
    end

    MainImage = Creator.Image(
        ImageModule.Image,
        (type(ImageModule.Image) == "table" and (ImageModule.Image.url or "Image"))
            or tostring(ImageModule.Image),
        ImageModule.Radius,
        Config.Window.Folder,
        "Image",
        false,
        nil,
        nil,
        {
            ScaleType  = ImageModule.ScaleType,
            NativeSize = ImageModule.NativeSize,
            -- ukuran asli dipakai untuk rasio frame, jadi tidak ada bagian
            -- gambar yang terpotong dan tidak ada ruang kosong di sisinya
            OnNativeSize = ImageModule.Native and function(size)
                if size.Y > 0 then
                    ApplyAspectRatio(size.X / size.Y)
                end
            end or nil,
        }
    )
    MainImage.Parent = Config.Parent
    MainImage.BackgroundTransparency = 1

    -- Ukuran bisa diatur bebas; rasio gambar tetap terjaga oleh ScaleType/Constraint
    if ImageModule.Size then
        MainImage.Size = ImageModule.Size
    elseif ImageModule.Height then
        MainImage.Size = UDim2.new(1, 0, 0, ImageModule.Height)
    else
        MainImage.Size = UDim2.new(1, 0, 0, 0)
    end

    -- Constraint hanya dipakai kalau tinggi tidak ditentukan manual
    if aspectRatio and not ImageModule.Size and not ImageModule.Height then
        ApplyAspectRatio(aspectRatio)
    end

    function ImageModule:SetSize(size)
        if typeof(size) == "UDim2" then
            MainImage.Size = size
        elseif type(size) == "number" then
            MainImage.Size = UDim2.new(1, 0, 0, size)
        end
        return ImageModule
    end

    function ImageModule:SetScaleType(scaleType)
        ImageModule.ScaleType = scaleType
        if MainImage.ImageLabel then
            MainImage.ImageLabel.ScaleType = scaleType
        end
        return ImageModule
    end

    function ImageModule:SetAspectRatio(ratio)
        local source = (type(ImageModule.Image) == "table" and ImageModule.Image.url) or ImageModule.Image
        if IsNativeAspect(ratio) then
            local native = Creator.GetImageNativeSize(source)
            if native and native.Y > 0 then
                ApplyAspectRatio(native.X / native.Y)
            else
                Creator.RequestImageNativeSize(source, function(size)
                    if size.Y > 0 then ApplyAspectRatio(size.X / size.Y) end
                end)
            end
        else
            ApplyAspectRatio(ParseAspectRatio(ratio))
        end
        return ImageModule
    end

    function ImageModule:GetNativeSize()
        local source = (type(ImageModule.Image) == "table" and ImageModule.Image.url) or ImageModule.Image
        return Creator.GetImageNativeSize(source)
    end

    ImageModule.ElementFrame = MainImage
    ImageModule.UIElements = { Main = MainImage }

    function ImageModule:Destroy()
        MainImage:Destroy()
    end

    return ImageModule.__type, ImageModule
end

return Element
