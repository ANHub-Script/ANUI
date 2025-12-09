-- [GANTI ISI src/elements/Paragraph.lua DENGAN INI]
local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}
local CreateButton = require("../components/ui/Button").New

-- Helper Gradient
local function GetGradientData(gradientInput)
    if typeof(gradientInput) == "ColorSequence" then
        return gradientInput
    elseif typeof(gradientInput) == "Color3" then
        return ColorSequence.new(gradientInput)
    else
        return ColorSequence.new(Color3.fromRGB(80, 80, 80))
    end
end

function Element:New(ElementConfig)
    ElementConfig.Hover = false  
    ElementConfig.TextOffset = 0  
    ElementConfig.ParentConfig = ElementConfig  
    
    local ParagraphModule = {  
        __type = "Paragraph",  
        Title = ElementConfig.Title or "Paragraph",  
        Desc = ElementConfig.Desc or nil,  
        Locked = ElementConfig.Locked or false,
        Elements = {}
    }  
    
    local Paragraph = require("../components/window/Element")(ElementConfig)  
    ParagraphModule.ParagraphFrame = Paragraph  

    -- [NEW FEATURE] Image/Card Grid Support (CLICKABLE)
    if ElementConfig.Images and #ElementConfig.Images > 0 then
        local GridContainer = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Parent = Paragraph.UIElements.Container,
            LayoutOrder = 2
        }, {
            New("UIGridLayout", {
                CellSize = ElementConfig.ImageSize or UDim2.new(0, 70, 0, 70),
                CellPadding = UDim2.new(0, 8, 0, 8),
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
            }),
            New("UIPadding", {
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10)
            })
        })

        for _, imgData in ipairs(ElementConfig.Images) do
            local Title = imgData.Title or "Item"
            local Quantity = imgData.Quantity
            local ImageId = imgData.Image
            local GradientColor = GetGradientData(imgData.Gradient)
            local BorderColor = GradientColor.Keypoints[1].Value
            
            -- Cek apakah ada Callback (Fungsi Klik)
            local IsInteractive = (type(imgData.Callback) == "function")

            -- 1. Outer Frame (Button atau Frame Biasa)
            local Card = Creator.NewRoundFrame(8, "Squircle", {
                ImageColor3 = BorderColor,
                ClipsDescendants = true,
                Parent = GridContainer,
                -- Jika ada callback, jadikan Active agar menangkap input
                Active = IsInteractive 
            }, {
                -- 2. Inner Shadow
                New("ImageLabel", {
                    Image = "rbxassetid://5554236805",
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(23,23,277,277),
                    Size = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1,
                    ImageColor3 = Color3.new(0,0,0),
                    ImageTransparency = 0.4,
                    ZIndex = 2,
                }),
                
                -- 3. Content Container
                Creator.NewRoundFrame(8, "Squircle", {
                    Size = UDim2.new(1, -4, 1, -4),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ImageColor3 = Color3.new(1,1,1),
                    ClipsDescendants = true,
                    ZIndex = 3,
                }, {
                    New("UIGradient", { Color = GradientColor, Rotation = 45 }),
                    Creator.Image(ImageId, Title, 0, ElementConfig.Window.Folder, "CardIcon", false).ImageLabel,
                    
                    Quantity and New("TextLabel", {
                        Text = Quantity,
                        Size = UDim2.new(1, -8, 0, 12),
                        Position = UDim2.new(0, 4, 0, 2),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextColor3 = Color3.new(1, 1, 1),
                        FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                        TextSize = 10,
                        TextStrokeTransparency = 0.5,
                        ZIndex = 5,
                    }) or nil,

                    New("Frame", {
                        Size = UDim2.new(1, 0, 0, 18),
                        Position = UDim2.new(0, 0, 1, 0),
                        AnchorPoint = Vector2.new(0, 1),
                        BackgroundColor3 = Color3.new(0,0,0),
                        BackgroundTransparency = 0.4,
                        BorderSizePixel = 0,
                        ZIndex = 6,
                    }, {
                        New("TextLabel", {
                            Text = Title,
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            TextColor3 = Color3.new(1, 1, 1),
                            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                            TextSize = 9,
                            TextTruncate = Enum.TextTruncate.AtEnd,
                            ZIndex = 7,
                        })
                    })
                })
            }, IsInteractive) -- Parameter ke-5 true = ImageButton

            -- Fix Image Size
            local imgLabel = Card:FindFirstChild("ImageLabel", true)
            if imgLabel then
                imgLabel.Size = UDim2.new(0.65, 0, 0.65, 0)
                imgLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                imgLabel.Position = UDim2.new(0.5, 0, 0.45, 0)
                imgLabel.BackgroundTransparency = 1
                imgLabel.ScaleType = Enum.ScaleType.Fit
                imgLabel.ZIndex = 4
            end

            -- Bind Klik Event
            if IsInteractive then
                Creator.AddSignal(Card.MouseButton1Click, function()
                    imgData.Callback()
                end)
                
                -- Animasi Klik Sedikit
                Creator.AddSignal(Card.MouseButton1Down, function()
                    game:GetService("TweenService"):Create(Card, TweenInfo.new(0.1), {Size = UDim2.new(0, 70*0.95, 0, 70*0.95)}):Play()
                end)
                Creator.AddSignal(Card.MouseButton1Up, function()
                    game:GetService("TweenService"):Create(Card, TweenInfo.new(0.1), {Size = UDim2.new(0, 70, 0, 70)}):Play()
                end)
            end
        end
    end

    return ParagraphModule.__type, ParagraphModule
end

return Element