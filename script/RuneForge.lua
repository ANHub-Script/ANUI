-- Path: game:GetService("Players").animeadityanugraha25.PlayerGui.Features.RuneForge.Board.Container.LocalScript
-- Code
local v_u_1 = game.Players.LocalPlayer
local v2 = v_u_1:WaitForChild("stats")
local v_u_3 = v2:WaitForChild("RuneForge")
local v_u_4 = v_u_1:WaitForChild("Runes")
local v_u_5 = require(game.ReplicatedStorage.Modules.Manager)
local v_u_6 = script.Parent:WaitForChild("Right")
local v_u_7 = script.Parent:WaitForChild("Left")
local v_u_8 = script.Parent:WaitForChild("TextButton")
local v_u_9 = v2:WaitForChild("BodyTier")
local v_u_10 = Color3.fromRGB(78, 253, 48)
local v_u_11 = Color3.fromRGB(253, 57, 57)
local v_u_12 = Color3.fromRGB(78, 253, 48)
local v_u_13 = Color3.fromRGB(253, 57, 57)
local v_u_14 = Color3.fromRGB(43, 138, 26)
local v_u_15 = Color3.fromRGB(144, 32, 32)
local v_u_16 = {
    ["1"] = {
        ["currency"] = 50000000,
        ["rune"] = "Noob",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(249, 236, 95)
    },
    ["2"] = {
        ["currency"] = 12500000000,
        ["rune"] = "Spark",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(120, 220, 255)
    },
    ["3"] = {
        ["currency"] = 250000000,
        ["rune"] = "Master",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(249, 59, 59)
    },
    ["4"] = {
        ["currency"] = 1250000,
        ["rune"] = "Inferno",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(160, 20, 120)
    },
    ["5"] = {
        ["currency"] = 1250,
        ["rune"] = "Celestial",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(170, 120, 255)
    },
    ["6"] = {
        ["currency"] = 50,
        ["rune"] = "Eternal",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(0, 208, 249)
    },
    ["7"] = {
        ["currency"] = 50,
        ["rune"] = "Omniscient",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(100, 0, 249)
    },
    ["8"] = {
        ["currency"] = 50000000,
        ["rune"] = "Barbell",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(150, 150, 150)
    },
    ["9"] = {
        ["currency"] = 50,
        ["rune"] = "Olympian",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(255, 245, 120)
    },
    ["10"] = {
        ["currency"] = 500000000000,
        ["rune"] = "Steel",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(120, 170, 255)
    },
    ["11"] = {
        ["currency"] = 75,
        ["rune"] = "Ascendant",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(180, 80, 255)
    },
    ["12"] = {
        ["currency"] = 2.5e27,
        ["rune"] = "Barbell",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(150, 150, 150)
    },
    ["13"] = {
        ["currency"] = 1250,
        ["rune"] = "Ascendant",
        ["color"] = nil,
        ["color"] = Color3.fromRGB(180, 80, 255)
    }
}
local function v_u_19() -- name: UpdateFrames
    -- upvalues: (copy) v_u_6, (copy) v_u_9, (copy) v_u_3, (copy) v_u_10, (copy) v_u_11
    for v17 = 1, 13 do
        local v18 = v_u_6:FindFirstChild((tostring(v17)))
        if v18 then
            if v17 >= 8 then
                v18.Visible = v_u_9.Value >= 4
            else
                v18.Visible = true
            end
            if v17 <= v_u_3.Value then
                v18.BackgroundColor3 = v_u_10
            else
                v18.BackgroundColor3 = v_u_11
            end
        end
    end
end
local function v_u_24() -- name: UpdateForgeButton
    -- upvalues: (copy) v_u_3, (copy) v_u_9, (copy) v_u_8, (copy) v_u_12, (copy) v_u_14, (copy) v_u_7, (copy) v_u_16, (copy) v_u_4, (copy) v_u_5, (copy) v_u_1, (copy) v_u_13, (copy) v_u_15
    local v20 = v_u_3.Value + 1
    if v20 >= 8 and v_u_9.Value < 4 then
        v_u_8.BackgroundColor3 = v_u_12
        v_u_8.UIStroke.Color = v_u_14
        v_u_8.TextLabel.Text = "Max Level"
        v_u_7.Rune.Text = "MAX"
        v_u_7.Rune.TextColor3 = Color3.fromRGB(255, 255, 255)
        return
    else
        local v21 = v_u_16[tostring(v20)]
        if v21 then
            local v22 = v_u_4:FindFirstChild(v21.rune)
            local v23 = v22 and v22.Value or 0
            v_u_7.Rune.Text = v_u_5.Text(v_u_1, v21.currency) .. " " .. v21.rune
            v_u_7.Rune.TextColor3 = v21.color
            if v21.currency <= v23 then
                v_u_8.BackgroundColor3 = v_u_12
                v_u_8.UIStroke.Color = v_u_14
                v_u_8.TextLabel.Text = "Forge"
            else
                v_u_8.BackgroundColor3 = v_u_13
                v_u_8.UIStroke.Color = v_u_15
                v_u_8.TextLabel.Text = "Can\'t Afford"
            end
        else
            v_u_8.TextLabel.Text = "Max Level"
            v_u_8.BackgroundColor3 = v_u_12
            v_u_8.UIStroke.Color = v_u_14
            v_u_7.Rune.Text = "MAX"
            v_u_7.Rune.TextColor3 = Color3.fromRGB(255, 255, 255)
            return
        end
    end
end
local function v25() -- name: UpdateAll
    -- upvalues: (copy) v_u_19, (copy) v_u_24
    v_u_19()
    v_u_24()
end
script.Parent.TextButton.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.Features.RuneForge:FireServer()
end)
function text() -- name: text
    -- upvalues: (copy) v_u_1
    if v_u_1.stats.BodyTier.Value >= 4 then
        script.Parent.Desc.Text = "Resets ALL <font color=\"#14fa1f\">Basic</font>, <font color=\"#14a6fa\">Elemental</font> and <font color=\"#606060\">Gym</font> Runes"
    else
        script.Parent.Desc.Text = "Resets ALL <font color=\"#14fa1f\">Basic</font> and <font color=\"#14a6fa\">Elemental</font> Runes"
    end
end
text()
v_u_1:WaitForChild("stats"):WaitForChild("BodyTier").Changed:Connect(text)
v_u_19()
v_u_24()
v_u_3:GetPropertyChangedSignal("Value"):Connect(v25)
v_u_9:GetPropertyChangedSignal("Value"):Connect(v25)
for _, v26 in ipairs(v_u_4:GetChildren()) do
    if v26:IsA("IntValue") or v26:IsA("NumberValue") then
        v26:GetPropertyChangedSignal("Value"):Connect(v_u_24)
    end
end
