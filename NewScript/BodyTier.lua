-- Script Path: game:GetService("Players").animeadityanugraha25.PlayerGui.Features.BodyTier.Board.Container.LocalScript
-- Took 0.07s to decompile.
-- Executor: Delta (1.1.731.944)

local v_u_1 = game.Players.LocalPlayer
local v_u_2 = require(game.ReplicatedStorage.Modules.EternityNum)
local v_u_3 = require(game.ReplicatedStorage.Modules.Manager)
v_u_1:WaitForChild("stats")
local v_u_4 = {
    ["Strength"] = "#ff2626",
    ["Speed"] = "#2e70ff",
    ["Power"] = "#62ff42"
}
local v_u_5 = {
    { "2.5e12", "Speed" },
    { "1e13", "Power" },
    { "2.5e52", "Strength" },
    { "5e37", "Power" },
    { "1e62", "Power" },
    { "2.5e68", "Power" }
}
function text() -- name: text
    -- upvalues: (copy) v_u_1, (copy) v_u_5, (copy) v_u_4, (copy) v_u_3, (copy) v_u_2
    local v6 = v_u_1.stats.BodyTier.Value
    for _, v7 in ipairs(script.Parent.Container:GetChildren()) do
        if v7:IsA("Frame") then
            local v8 = v7.Name
            if tonumber(v8) <= v6 + 1 then
                v7.Visible = true
            else
                v7.Visible = false
            end
            local v9 = v7.Name
            if tonumber(v9) == v6 + 1 then
                v7.BackgroundTransparency = 0.95
            else
                v7.BackgroundTransparency = 0.85
            end
        end
    end
    local v10 = v_u_5[v6 + 1]
    if v10 then
        local v11 = script.Parent.TextButton.TextLabel
        local v12 = v10[1]
        local v13 = v10[2]
        local v14 = v_u_4[v13] or "#ffffff"
        v11.Text = v_u_3.Text(v_u_1, v12) .. " <font color=\"" .. v14 .. "\">" .. v13 .. "</font>"
        local v15 = v10[2]
        local v16 = v10[1]
        if v_u_2.meeq(v_u_1.stats[v15].Value, v16) then
            script.Parent.TextButton.BackgroundColor3 = Color3.fromRGB(90, 255, 78)
            script.Parent.TextButton.UIStroke.Color = Color3.fromRGB(46, 127, 39)
        else
            script.Parent.TextButton.BackgroundColor3 = Color3.fromRGB(255, 74, 77)
            script.Parent.TextButton.UIStroke.Color = Color3.fromRGB(134, 39, 40)
        end
    else
        script.Parent.TextButton.TextLabel.Text = "Maxed"
        script.Parent.TextButton.BackgroundColor3 = Color3.fromRGB(90, 255, 78)
        script.Parent.TextButton.UIStroke.Color = Color3.fromRGB(46, 127, 39)
        return
    end
end
script.Parent.TextButton.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.Features.BodyTier:FireServer()
end)
text()
v_u_1:WaitForChild("stats"):WaitForChild("BodyTier").Changed:Connect(text)
while true do
    task.wait(1)
    text()
end
