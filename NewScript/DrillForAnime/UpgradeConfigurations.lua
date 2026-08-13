-- Script Path: game:GetService("ReplicatedStorage").Modules.UpgradeConfigurations
-- Took 0.02s to decompile.
-- Executor: Delta (1.1.731.944)

local v1 = {
    ["Speed"] = {
        {
            ["Speed"] = 27,
            ["MoneyCost"] = 0
        },
        {
            ["Speed"] = 28,
            ["MoneyCost"] = 1000
        },
        {
            ["Speed"] = 29,
            ["MoneyCost"] = 2200
        },
        {
            ["Speed"] = 30,
            ["MoneyCost"] = 4800
        },
        {
            ["Speed"] = 31,
            ["MoneyCost"] = 10000
        },
        {
            ["Speed"] = 32,
            ["MoneyCost"] = 22000
        },
        {
            ["Speed"] = 33,
            ["MoneyCost"] = 47000
        },
        {
            ["Speed"] = 34,
            ["MoneyCost"] = 100000
        },
        {
            ["Speed"] = 35,
            ["MoneyCost"] = 215000
        },
        {
            ["Speed"] = 36,
            ["MoneyCost"] = 460000
        },
        {
            ["Speed"] = 37,
            ["MoneyCost"] = 980000
        },
        {
            ["Speed"] = 38,
            ["MoneyCost"] = 2100000
        },
        {
            ["Speed"] = 39,
            ["MoneyCost"] = 4500000
        },
        {
            ["Speed"] = 40,
            ["MoneyCost"] = 9500000
        },
        {
            ["Speed"] = 41,
            ["MoneyCost"] = 20000000
        },
        {
            ["Speed"] = 42,
            ["MoneyCost"] = 43000000
        },
        {
            ["Speed"] = 43,
            ["MoneyCost"] = 92000000
        },
        {
            ["Speed"] = 44,
            ["MoneyCost"] = 195000000
        },
        {
            ["Speed"] = 45,
            ["MoneyCost"] = 410000000
        },
        {
            ["Speed"] = 46,
            ["MoneyCost"] = 880000000
        },
        {
            ["Speed"] = 47,
            ["MoneyCost"] = 1850000000
        },
        {
            ["Speed"] = 48,
            ["MoneyCost"] = 4000000000
        },
        {
            ["Speed"] = 49,
            ["MoneyCost"] = 13000000000
        },
        {
            ["Speed"] = 50,
            ["MoneyCost"] = 25000000000
        },
        {
            ["Speed"] = 51,
            ["MoneyCost"] = 52000000000
        },
        {
            ["Speed"] = 52,
            ["MoneyCost"] = 110000000000
        },
        {
            ["Speed"] = 53,
            ["MoneyCost"] = 230000000000
        },
        {
            ["Speed"] = 54,
            ["MoneyCost"] = 480000000000
        },
        {
            ["Speed"] = 55,
            ["MoneyCost"] = 1000000000000
        },
        {
            ["Speed"] = 56,
            ["MoneyCost"] = 5000000000000
        },
        {
            ["Speed"] = 57,
            ["MoneyCost"] = 35000000000000
        },
        {
            ["Speed"] = 58,
            ["MoneyCost"] = 150000000000000
        },
        {
            ["Speed"] = 59,
            ["MoneyCost"] = 675000000000000
        },
        {
            ["Speed"] = 60,
            ["MoneyCost"] = 4500000000000000
        }
    },
    ["SpeedRobux"] = {
        ["RobuxProductId"] = 3584753075,
        ["Tiers"] = 5
    },
    ["Jump"] = {
        {
            ["JumpHeight"] = 7.2,
            ["MoneyCost"] = 0
        },
        {
            ["JumpHeight"] = 8.2,
            ["MoneyCost"] = 500
        },
        {
            ["JumpHeight"] = 9.2,
            ["MoneyCost"] = 750
        },
        {
            ["JumpHeight"] = 10.2,
            ["MoneyCost"] = 1200
        },
        {
            ["JumpHeight"] = 11.2,
            ["MoneyCost"] = 1700
        },
        {
            ["JumpHeight"] = 12.2,
            ["MoneyCost"] = 2600
        },
        {
            ["JumpHeight"] = 13.2,
            ["MoneyCost"] = 3800
        },
        {
            ["JumpHeight"] = 14.2,
            ["MoneyCost"] = 5800
        },
        {
            ["JumpHeight"] = 15.2,
            ["MoneyCost"] = 8600
        },
        {
            ["JumpHeight"] = 16.2,
            ["MoneyCost"] = 13000
        },
        {
            ["JumpHeight"] = 17.2,
            ["MoneyCost"] = 21000
        },
        {
            ["JumpHeight"] = 18.2,
            ["MoneyCost"] = 32000
        },
        {
            ["JumpHeight"] = 19.2,
            ["MoneyCost"] = 45000
        },
        {
            ["JumpHeight"] = 20.2,
            ["MoneyCost"] = 67000
        },
        {
            ["JumpHeight"] = 21.2,
            ["MoneyCost"] = 100000
        },
        {
            ["JumpHeight"] = 22.2,
            ["MoneyCost"] = 160000
        },
        {
            ["JumpHeight"] = 23.2,
            ["MoneyCost"] = 225000
        },
        {
            ["JumpHeight"] = 24.2,
            ["MoneyCost"] = 350000
        },
        {
            ["JumpHeight"] = 25.2,
            ["MoneyCost"] = 500000
        },
        {
            ["JumpHeight"] = 26.2,
            ["MoneyCost"] = 750000
        }
    },
    ["JumpRobux"] = {
        ["RobuxProductId"] = 3584753234,
        ["Tiers"] = 5
    },
    ["Carry"] = {
        {
            ["Capacity"] = 1,
            ["MoneyCost"] = 0
        },
        {
            ["Capacity"] = 2,
            ["MoneyCost"] = 5000000
        },
        {
            ["Capacity"] = 3,
            ["MoneyCost"] = 50000000
        },
        {
            ["Capacity"] = 4,
            ["MoneyCost"] = 1250000000
        }
    },
    ["CarryRobux"] = {
        ["RobuxProductId"] = 3584753414,
        ["RobuxPrice"] = 0
    }
}
local v_u_2 = {
    { 50, 1 },
    { 250, 5 },
    { 1000, 10 },
    { 5000, 50 },
    { 25000, 100 },
    { 100000, 500 },
    { 250000, 2500 },
    { 1000000, 10000 },
    { 10000000, 100000 },
    { 100000000, 1000000 }
}
v1.Power = (function() -- name: generatePowerTable
    -- upvalues: (copy) v_u_2
    local v3 = 10
    local v4 = {
        {
            ["Power"] = 10,
            ["MoneyCost"] = 0
        }
    }
    for _, v5 in ipairs(v_u_2) do
        local v6 = v5[1]
        local v7 = v5[2]
        while v3 < v6 do
            local v8 = v3 + v7
            v3 = math.min(v8, v6)
            local v9 = v3 ^ 1.75 * 15
            local v10 = {
                ["Power"] = v3,
                ["MoneyCost"] = math.floor(v9)
            }
            table.insert(v4, v10)
        end
    end
    return v4
end)()
v1.PowerRobux = {
    ["RobuxProductId"] = 0,
    ["Tiers"] = 5
}
return v1
