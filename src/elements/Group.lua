local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
    local GroupModule = {
        __type = "Group",
        Elements = {}
    }
    
    local GroupFrame = New("Frame", {
        Size = UDim2.new(1,0,0,0),
        BackgroundTransparency = 1,
        AutomaticSize = "Y",
        Parent = Config.Parent,
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            HorizontalAlignment = "Center",
            VerticalAlignment = "Center",
            Padding = UDim.new(0, Config.Tab and Config.Tab.Gap or ((Config.Window and Config.Window.NewElements) and 1 or 6))
        }),
    })
    
    GroupModule.GroupFrame = GroupFrame
    
    local ElementsModule = Config.ElementsModule
    ElementsModule.Load(
        GroupModule, 
        GroupFrame, 
        ElementsModule.Elements,
        Config.Window, 
        Config.ANUI,
        function(CurrentElement, AllElements)
            local Gap = Config.Tab and Config.Tab.Gap or ((Config.Window and Config.Window.NewElements) and 1 or 6)
            
            local StretchableElements = {}
            local TotalFixedWidth = 0
            
            for _, Element in next, AllElements do
                if Element.__type == "Space" then
                    TotalFixedWidth = TotalFixedWidth + (Element.ElementFrame.Size.X.Offset or 6)
                elseif Element.__type == "Divider" then
                    TotalFixedWidth = TotalFixedWidth + (Element.ElementFrame.Size.X.Offset or 1)
                else
                    table.insert(StretchableElements, Element)
                end
            end
            
            local StretchCount = #StretchableElements
            if StretchCount == 0 then return end
            
            local containerWidth = GroupFrame.AbsoluteSize.X
            local scalePerElement
            if containerWidth and containerWidth > 0 then
                local totalGap = Gap * (StretchCount - 1)
                local usableWidth = math.max(containerWidth - totalGap - TotalFixedWidth, 0)
                scalePerElement = (usableWidth / containerWidth) / StretchCount
            else
                scalePerElement = 1 / StretchCount
            end
            
            for _, Element in next, StretchableElements do
                if Element.ElementFrame then
                    Element.ElementFrame.Size = UDim2.new(scalePerElement, 0, 1, 0)
                end
            end
        end,  
        ElementsModule, 
        Config.UIScale, 
        Config.Tab
    )
    
    
    
    return GroupModule.__type, GroupModule
end

return Element
