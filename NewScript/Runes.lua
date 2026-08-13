-- Script Path: game:GetService("ReplicatedStorage").Modules.RuneBoosts
-- Took 0.41s to decompile.
-- Executor: Delta (1.1.733.988)

local v_u_1 = {}
local v_u_2 = require(game.ReplicatedStorage.DeltaNum)
local v_u_3 = {
    ["Starter"] = {
        {
            ["Name"] = "Common",
            ["Chance"] = 0.82597
        },
        {
            ["Name"] = "Uncommon",
            ["Chance"] = 0.16519
        },
        {
            ["Name"] = "Rare",
            ["Chance"] = 0.01
        },
        {
            ["Name"] = "Epic",
            ["Chance"] = 0.0008
        },
        {
            ["Name"] = "Legendary",
            ["Chance"] = 0.000016666666666666667
        },
        {
            ["Name"] = "Mythical",
            ["Chance"] = 1.652892561983471e-6
        },
        {
            ["Name"] = "Secret",
            ["Chance"] = 4e-7
        },
        {
            ["Name"] = "Unknown",
            ["Chance"] = 1e-10
        },
        {
            ["Name"] = "Celestial",
            ["Chance"] = 2.5000000000000002e-30
        },
        {
            ["Name"] = "Ancient",
            ["Chance"] = 2.5e-38
        }
    },
    ["Golden"] = {
        {
            ["Name"] = "Shiny",
            ["Chance"] = 0.999995552
        },
        {
            ["Name"] = "Regal",
            ["Chance"] = 0.00001
        },
        {
            ["Name"] = "Auric",
            ["Chance"] = 5e-7
        },
        {
            ["Name"] = "Imperial",
            ["Chance"] = 4e-8
        },
        {
            ["Name"] = "Treasury",
            ["Chance"] = 8e-9
        },
        {
            ["Name"] = "GildedArcane",
            ["Chance"] = 3.6363636363636364e-16
        },
        {
            ["Name"] = "Kingsmark",
            ["Chance"] = 1.111111111111111e-33
        },
        {
            ["Name"] = "SolSovereign",
            ["Chance"] = 1e-68
        }
    },
    ["Magmer"] = {
        {
            ["Name"] = "Charred",
            ["Chance"] = 0.999995552
        },
        {
            ["Name"] = "Ignis",
            ["Chance"] = 2e-9
        },
        {
            ["Name"] = "Cinder",
            ["Chance"] = 4.0816326530612245e-11
        },
        {
            ["Name"] = "Pyric",
            ["Chance"] = 3.636363636363636e-13
        },
        {
            ["Name"] = "Searing",
            ["Chance"] = 1.0256410256410257e-14
        },
        {
            ["Name"] = "Volcanic",
            ["Chance"] = 6.666666666666667e-18
        },
        {
            ["Name"] = "Worldflare",
            ["Chance"] = 9.999999999999999e-26
        },
        {
            ["Name"] = "InfernalSigil",
            ["Chance"] = 7.999999999999999e-42
        },
        {
            ["Name"] = "Apocalyptic",
            ["Chance"] = 2.5e-97
        }
    },
    ["Plasma"] = {
        {
            ["Name"] = "Plasmatic",
            ["Chance"] = 0.999995552
        },
        {
            ["Name"] = "Arclight",
            ["Chance"] = 1e-18
        },
        {
            ["Name"] = "Voltaris",
            ["Chance"] = 8e-20
        },
        {
            ["Name"] = "Aetherion",
            ["Chance"] = 2.173913043478261e-22
        },
        {
            ["Name"] = "Astralis",
            ["Chance"] = 4.0000000000000003e-28
        },
        {
            ["Name"] = "Ecliptor",
            ["Chance"] = 2.0000000000000003e-45
        },
        {
            ["Name"] = "Cosmic",
            ["Chance"] = 3.9999999999999995e-91
        }
    },
    ["Snow"] = {
        {
            ["Name"] = "Snowfall",
            ["Chance"] = 0.999995552
        },
        {
            ["Name"] = "Frostbite",
            ["Chance"] = 9.999999999999999e-33
        },
        {
            ["Name"] = "Icebound",
            ["Chance"] = 5.0000000000000005e-40
        },
        {
            ["Name"] = "Glacial",
            ["Chance"] = 2e-44
        },
        {
            ["Name"] = "WintersWrath",
            ["Chance"] = 1e-51
        },
        {
            ["Name"] = "AbsoluteZero",
            ["Chance"] = 7.999999999999999e-56
        },
        {
            ["Name"] = "Eternalwhiteout",
            ["Chance"] = 3.3333333333333335e-62
        },
        {
            ["Name"] = "Hailstorm",
            ["Chance"] = 2e-109
        }
    },
    ["Icey"] = {
        {
            ["Name"] = "Frost",
            ["Chance"] = 0.999995552
        },
        {
            ["Name"] = "Glacier",
            ["Chance"] = 2.5000000000000003e-46
        },
        {
            ["Name"] = "Cryo",
            ["Chance"] = 1.176470588235294e-59
        },
        {
            ["Name"] = "Shiver",
            ["Chance"] = 2.0000000000000002e-66
        },
        {
            ["Name"] = "Blizzard",
            ["Chance"] = 6.666666666666667e-76
        },
        {
            ["Name"] = "Hurricane",
            ["Chance"] = 6.25e-85
        },
        {
            ["Name"] = "EternalFrost",
            ["Chance"] = 6.666666666666667e-102
        }
    },
    ["Cave"] = {
        {
            ["Name"] = "Dirt",
            ["Chance"] = 0.98
        },
        {
            ["Name"] = "Shallow",
            ["Chance"] = 0.01
        },
        {
            ["Name"] = "Cavern",
            ["Chance"] = 0.0013333333333333333
        },
        {
            ["Name"] = "Grotto",
            ["Chance"] = 0.00006666666666666667
        },
        {
            ["Name"] = "CrystalCave",
            ["Chance"] = 1e-6
        },
        {
            ["Name"] = "DeepHollow",
            ["Chance"] = 5.7142857142857144e-8
        },
        {
            ["Name"] = "Dripstone",
            ["Chance"] = 5e-9
        },
        {
            ["Name"] = "Bedrock",
            ["Chance"] = 3.3333333333333335e-11
        },
        {
            ["Name"] = "Geode",
            ["Chance"] = 5e-13
        },
        {
            ["Name"] = "Glowstone",
            ["Chance"] = 6.6666666666666664e-15
        },
        {
            ["Name"] = "Moonstone",
            ["Chance"] = 1e-17
        },
        {
            ["Name"] = "Subterra",
            ["Chance"] = 6.6666666666666666e-21
        }
    },
    ["GlobalRune"] = {
        {
            ["Name"] = "Carved",
            ["Chance"] = 0.72
        },
        {
            ["Name"] = "Etched",
            ["Chance"] = 0.17
        },
        {
            ["Name"] = "Inscribed",
            ["Chance"] = 0.07
        },
        {
            ["Name"] = "Runebound",
            ["Chance"] = 0.0388
        },
        {
            ["Name"] = "Worldmarked",
            ["Chance"] = 0.001
        },
        {
            ["Name"] = "Primordial",
            ["Chance"] = 0.0002
        }
    },
    ["HellfireGlobalRune"] = {
        {
            ["Name"] = "Ember",
            ["Chance"] = 0.75
        },
        {
            ["Name"] = "Brimstone",
            ["Chance"] = 0.15
        },
        {
            ["Name"] = "Blaze",
            ["Chance"] = 0.06
        },
        {
            ["Name"] = "Infernal",
            ["Chance"] = 0.0389
        },
        {
            ["Name"] = "Abyssfire",
            ["Chance"] = 0.001
        },
        {
            ["Name"] = "Hellfire",
            ["Chance"] = 0.0001
        }
    }
}
local v_u_4 = {}
local v28 = {
    ["Common"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 2,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Add",
            ["Formula"] = function(p5) -- name: Formula
                return 0.0275 * p5
            end
        }
    },
    ["Uncommon"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 2,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Add",
            ["Formula"] = function(p6) -- name: Formula
                return 0.08 * p6
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Add",
            ["Formula"] = function(p7) -- name: Formula
                return 0.035 * p7
            end
        }
    },
    ["Rare"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 2,
        {
            ["Stat"] = "Essence",
            ["Formula"] = nil,
            ["Cap"] = 125,
            ["Type"] = "Add",
            ["Formula"] = function(p8) -- name: Formula
                return 0.2 * p8
            end
        }
    },
    ["Epic"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 2,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 300,
            ["Type"] = "Add",
            ["Formula"] = function(p9) -- name: Formula
                return 1.2 * p9
            end
        },
        {
            ["Stat"] = "GoldGain",
            ["Formula"] = nil,
            ["Cap"] = 1.25,
            ["Type"] = "Add",
            ["Formula"] = function(p10) -- name: Formula
                return 0.05 * p10
            end
        }
    },
    ["Legendary"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 2,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 1250,
            ["Type"] = "Add",
            ["Formula"] = function(p11) -- name: Formula
                return 1 * 1.09 ^ p11 - 1
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Add",
            ["Formula"] = function(p12) -- name: Formula
                return 0.34 * p12
            end
        },
        {
            ["Stat"] = "RuneBulk",
            ["Formula"] = nil,
            ["Cap"] = 1.5,
            ["Type"] = "Multi",
            ["Formula"] = function(p13) -- name: Formula
                return 1 + 0.1 * p13
            end
        }
    },
    ["Mythical"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 2,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 100000,
            ["Type"] = "Add",
            ["Formula"] = function(p14) -- name: Formula
                return 10 * p14
            end
        },
        {
            ["Stat"] = "GoldGain",
            ["Formula"] = nil,
            ["Cap"] = 4,
            ["Type"] = "Multi",
            ["Formula"] = function(p15) -- name: Formula
                return 1 + 0.05 * p15
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 2.25,
            ["Type"] = "Multi",
            ["Formula"] = function(p16) -- name: Formula
                return 1 + 0.15 * p16
            end
        }
    },
    ["Secret"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 2,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p17) -- name: Formula
                return 1 + p17 ^ 0.62
            end
        },
        {
            ["Stat"] = "RuneClone",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p18) -- name: Formula
                return 1 + p18
            end
        }
    },
    ["Unknown"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 2,
        {
            ["Stat"] = "Damage",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p19) -- name: Formula
                return 1 * 1.01 ^ p19
            end
        },
        {
            ["Stat"] = "Essence",
            ["Formula"] = nil,
            ["Cap"] = 100,
            ["Type"] = "Multi",
            ["Formula"] = function(p20) -- name: Formula
                return 1 * 1.05 ^ p20
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 2.25,
            ["Type"] = "Multi",
            ["Formula"] = function(p21) -- name: Formula
                return 1 + 0.1 * p21
            end
        }
    },
    ["Celestial"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 12,
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p22) -- name: Formula
                return 1 * 1.00154 ^ p22
            end
        },
        {
            ["Stat"] = "GoldGain",
            ["Formula"] = nil,
            ["Cap"] = 12,
            ["Type"] = "Multi",
            ["Formula"] = function(p23) -- name: Formula
                return 1 + 0.0005 * p23
            end
        },
        {
            ["Stat"] = "RuneBulk",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p24) -- name: Formula
                return 1 + 0.0005 * p24
            end
        }
    },
    ["Ancient"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 13,
        {
            ["Stat"] = "PlasmaPoints",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p25) -- name: Formula
                return 1 + p25 ^ 0.25
            end
        },
        {
            ["Stat"] = "SpiritOrbs",
            ["Formula"] = nil,
            ["Cap"] = 75,
            ["Type"] = "Multi",
            ["Formula"] = function(p26) -- name: Formula
                return p26 <= 0 and 1 or 1.75 ^ math.log(p26, 6) * 1
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p27) -- name: Formula
                return 1 + 0.034 * p27
            end
        }
    }
}
v_u_4.Starter = v28
local v50 = {
    ["Shiny"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 7,
        {
            ["Stat"] = "GoldGain",
            ["Formula"] = nil,
            ["Cap"] = 8,
            ["Type"] = "Add",
            ["Formula"] = function(p29) -- name: Formula
                return 0.0014 * p29
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Add",
            ["Formula"] = function(p30) -- name: Formula
                return p30 ^ 0.21
            end
        }
    },
    ["Regal"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 7,
        {
            ["Stat"] = "GoldGain",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Add",
            ["Formula"] = function(p31) -- name: Formula
                return 0.135 * p31
            end
        }
    },
    ["Auric"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 7,
        {
            ["Stat"] = "Damage",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Add",
            ["Formula"] = function(p32) -- name: Formula
                return p32 ^ 0.34
            end
        },
        {
            ["Stat"] = "Essence",
            ["Formula"] = nil,
            ["Cap"] = 20,
            ["Type"] = "Add",
            ["Formula"] = function(p33) -- name: Formula
                return p33 ^ 0.78
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 2.5,
            ["Type"] = "Multi",
            ["Formula"] = function(p34) -- name: Formula
                return 1 + 0.1 * p34
            end
        }
    },
    ["Imperial"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 7,
        {
            ["Stat"] = "GoldGain",
            ["Formula"] = nil,
            ["Cap"] = 125,
            ["Type"] = "Add",
            ["Formula"] = function(p35) -- name: Formula
                return p35
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p36) -- name: Formula
                return 1 + 0.05 * p36
            end
        },
        {
            ["Stat"] = "Essence",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p37) -- name: Formula
                return 1 + 0.03 * p37
            end
        }
    },
    ["Treasury"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 7,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 8,
            ["Type"] = "Multi",
            ["Formula"] = function(p38) -- name: Formula
                return 1 * 1.055 ^ p38
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 4,
            ["Type"] = "Multi",
            ["Formula"] = function(p39) -- name: Formula
                return 1 * 1.05 ^ p39
            end
        },
        {
            ["Stat"] = "GoldChance",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Add",
            ["Formula"] = function(p40) -- name: Formula
                return p40
            end
        }
    },
    ["GildedArcane"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 7,
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 8,
            ["Type"] = "Multi",
            ["Formula"] = function(p41) -- name: Formula
                return 1 + 0.0175 * p41
            end
        },
        {
            ["Stat"] = "Lava",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p42) -- name: Formula
                return 1 + p42 ^ 0.2386
            end
        },
        {
            ["Stat"] = "RuneBulk",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p43) -- name: Formula
                return 1 + 0.05 * p43
            end
        }
    },
    ["Kingsmark"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 13,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 75,
            ["Type"] = "Multi",
            ["Formula"] = function(p44) -- name: Formula
                return 1 + 0.02 * p44
            end
        },
        {
            ["Stat"] = "GoldGain",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p45) -- name: Formula
                return p45 <= 0 and 1 or math.log(p45, 1.75) + 1
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p46) -- name: Formula
                return p46 <= 0 and 1 or math.log(p46, 8) + 1
            end
        }
    },
    ["SolSovereign"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 19,
        {
            ["Stat"] = "GoldGain",
            ["Formula"] = nil,
            ["Cap"] = 100,
            ["Type"] = "Multi",
            ["Formula"] = function(p47) -- name: Formula
                return 1 + 0.5 * p47
            end
        },
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Multi",
            ["Formula"] = function(p48) -- name: Formula
                return 1 + 0.01 * p48
            end
        },
        {
            ["Stat"] = "Ice",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p49) -- name: Formula
                return 1 + 0.0002 * p49
            end
        }
    }
}
v_u_4.Golden = v50
local v75 = {
    ["Charred"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "Magma",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Add",
            ["Formula"] = function(p51) -- name: Formula
                return 0.00002 * p51
            end
        }
    },
    ["Ignis"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "Magma",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Multi",
            ["Formula"] = function(p52) -- name: Formula
                return 1 + p52 ^ 0.17
            end
        },
        {
            ["Stat"] = "Damage",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Add",
            ["Formula"] = function(p53) -- name: Formula
                return 0.001 * p53
            end
        }
    },
    ["Cinder"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Add",
            ["Formula"] = function(p54) -- name: Formula
                return 0.0125 * p54
            end
        },
        {
            ["Stat"] = "GoldGain",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Add",
            ["Formula"] = function(p55) -- name: Formula
                return 1.025 ^ p55
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 1.5,
            ["Type"] = "Multi",
            ["Formula"] = function(p56) -- name: Formula
                return 1 + 0.03 * p56
            end
        }
    },
    ["Pyric"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "Essence",
            ["Formula"] = nil,
            ["Cap"] = 45,
            ["Type"] = "Add",
            ["Formula"] = function(p57) -- name: Formula
                return 0.08 * p57
            end
        },
        {
            ["Stat"] = "Magma",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Add",
            ["Formula"] = function(p58) -- name: Formula
                return 0.00025 * p58
            end
        },
        {
            ["Stat"] = "RuneBulk",
            ["Formula"] = nil,
            ["Cap"] = 8,
            ["Type"] = "Multi",
            ["Formula"] = function(p59) -- name: Formula
                return 1 + 0.04 * p59
            end
        }
    },
    ["Searing"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "Magma",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p60) -- name: Formula
                return 1 + p60 ^ 0.13
            end
        },
        {
            ["Stat"] = "GoldGain",
            ["Formula"] = nil,
            ["Cap"] = 12,
            ["Type"] = "Add",
            ["Formula"] = function(p61) -- name: Formula
                return p61 / 5
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p62) -- name: Formula
                return 1 + 0.025 * p62
            end
        }
    },
    ["Volcanic"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Multi",
            ["Formula"] = function(p63) -- name: Formula
                return p63 <= 0 and 1 or math.log(p63, 2) + 1
            end
        },
        {
            ["Stat"] = "Lava",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p64) -- name: Formula
                return 1 * 1.003 ^ p64
            end
        },
        {
            ["Stat"] = "Magma",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p65) -- name: Formula
                return 1 * 1.01 ^ p65
            end
        }
    },
    ["Worldflare"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "PlasmaPoints",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p66) -- name: Formula
                return p66 <= 0 and 1 or math.log(p66, 30) + 1
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p67) -- name: Formula
                return p67 <= 0 and 1 or math.log(p67, 4) + 1
            end
        },
        {
            ["Stat"] = "Magma",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p68) -- name: Formula
                return 1 + 0.036 * p68
            end
        }
    },
    ["InfernalSigil"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 14,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 45,
            ["Type"] = "Multi",
            ["Formula"] = function(p69) -- name: Formula
                return 1 * 1.0025 ^ p69
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p70) -- name: Formula
                return 1 + 0.0005 * p70
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 9,
            ["Type"] = "Multi",
            ["Formula"] = function(p71) -- name: Formula
                return p71 <= 0 and 1 or 1 * 1.02 ^ p71
            end
        }
    },
    ["Apocalyptic"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 24,
        {
            ["Stat"] = "Credits",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p72) -- name: Formula
                return 1 + 0.005 * p72
            end
        },
        {
            ["Stat"] = "FishLuck",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p73) -- name: Formula
                return 1 * 1.000475 ^ p73
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 1750,
            ["Type"] = "Multi",
            ["Formula"] = function(p74) -- name: Formula
                return 1.00004818 ^ p74
            end
        }
    }
}
v_u_4.Magmer = v75
local v96 = {
    ["Plasmatic"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "PlasmaPoints",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Add",
            ["Formula"] = function(p76) -- name: Formula
                return 1e-9 * p76
            end
        },
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Add",
            ["Formula"] = function(p77) -- name: Formula
                return p77 ^ 0.1
            end
        }
    },
    ["Arclight"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "PlasmaPoints",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Add",
            ["Formula"] = function(p78) -- name: Formula
                return 1.0001 ^ p78 - 1
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 4,
            ["Type"] = "Multi",
            ["Formula"] = function(p79) -- name: Formula
                return 1 + 0.01 * p79
            end
        },
        {
            ["Stat"] = "RuneBulk",
            ["Formula"] = nil,
            ["Cap"] = 4,
            ["Type"] = "Multi",
            ["Formula"] = function(p80) -- name: Formula
                return p80 <= 0 and 1 or math.log(p80, 100) + 1
            end
        }
    },
    ["Voltaris"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "Lava",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p81) -- name: Formula
                return p81 <= 0 and 1 or math.log(p81, 250) + 1
            end
        },
        {
            ["Stat"] = "Magma",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p82) -- name: Formula
                return 1 + 0.01 * p82
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p83) -- name: Formula
                return 1 + 0.004 * p83
            end
        }
    },
    ["Aetherion"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 12,
            ["Type"] = "Multi",
            ["Formula"] = function(p84) -- name: Formula
                return 1 + (1.001 ^ p84 - 1)
            end
        },
        {
            ["Stat"] = "PlasmaPoints",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p85) -- name: Formula
                return 1 + 0.0002 * p85
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 7,
            ["Type"] = "Multi",
            ["Formula"] = function(p86) -- name: Formula
                return 1 + 0.1 * p86
            end
        }
    },
    ["Astralis"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 9,
        {
            ["Stat"] = "PlasmaPoints",
            ["Formula"] = nil,
            ["Cap"] = 9,
            ["Type"] = "Multi",
            ["Formula"] = function(p87) -- name: Formula
                return 1 + p87 ^ 0.24
            end
        },
        {
            ["Stat"] = "Lava",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p88) -- name: Formula
                return 1 + 0.005 * p88
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p89) -- name: Formula
                return 1 + 0.025 * p89
            end
        }
    },
    ["Ecliptor"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 14,
        {
            ["Stat"] = "PlasmaPoints",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p90) -- name: Formula
                return p90 <= 0 and 1 or math.log(p90, 5) + 1
            end
        },
        {
            ["Stat"] = "Lava",
            ["Formula"] = nil,
            ["Cap"] = 6,
            ["Type"] = "Multi",
            ["Formula"] = function(p91) -- name: Formula
                return 1 + 0.001 * p91
            end
        },
        {
            ["Stat"] = "AuraLuck",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p92) -- name: Formula
                return p92 <= 0 and 1 or math.log(p92, 100) + 1
            end
        }
    },
    ["Cosmic"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 14,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 250,
            ["Type"] = "Multi",
            ["Formula"] = function(p93) -- name: Formula
                return 1 + p93 / 2
            end
        },
        {
            ["Stat"] = "SpiritOrbs",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Multi",
            ["Formula"] = function(p94) -- name: Formula
                return 1 + 0.001 * p94
            end
        },
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Multi",
            ["Formula"] = function(p95) -- name: Formula
                return 1 + 0.001 * p95
            end
        }
    }
}
v_u_4.Plasma = v96
local v121 = {
    ["Snowfall"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 1,
        {
            ["Stat"] = "Snowflakes",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p97) -- name: Formula
                return 1 + 0.002 * p97
            end
        },
        {
            ["Stat"] = "Snowflakes",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Multi",
            ["Formula"] = function(p98) -- name: Formula
                return 1 + 6e-8 * p98
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p99) -- name: Formula
                return p99 <= 0 and 1 or math.log(p99, 25) + 1
            end
        }
    },
    ["Frostbite"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 1,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 40,
            ["Type"] = "Multi",
            ["Formula"] = function(p100) -- name: Formula
                return 1 + (1.0001 ^ p100 - 1)
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p101) -- name: Formula
                return p101 <= 0 and 1 or math.log(p101, 12) + 1
            end
        },
        {
            ["Stat"] = "Snowflakes",
            ["Formula"] = nil,
            ["Cap"] = 7,
            ["Type"] = "Multi",
            ["Formula"] = function(p102) -- name: Formula
                return 1 + 0.0075 * p102
            end
        }
    },
    ["Icebound"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 17,
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p103) -- name: Formula
                return 1 + p103 / 2
            end
        },
        {
            ["Stat"] = "Snowflakes",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p104) -- name: Formula
                return 1 + 0.0025 * p104
            end
        },
        {
            ["Stat"] = "PlasmaPoints",
            ["Formula"] = nil,
            ["Cap"] = 9,
            ["Type"] = "Multi",
            ["Formula"] = function(p105) -- name: Formula
                return p105 <= 0 and 1 or math.log(p105, 6) + 1
            end
        }
    },
    ["Glacial"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 17,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 50,
            ["Type"] = "Multi",
            ["Formula"] = function(p106) -- name: Formula
                return 1 + (1.000001 ^ p106 - 1)
            end
        },
        {
            ["Stat"] = "Magma",
            ["Formula"] = nil,
            ["Cap"] = 45,
            ["Type"] = "Multi",
            ["Formula"] = function(p107) -- name: Formula
                return p107 <= 0 and 1 or math.log(p107, 1.8) + 1
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p108) -- name: Formula
                return 1 + 0.06 * p108
            end
        }
    },
    ["WintersWrath"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 17,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p109) -- name: Formula
                return p109 <= 0 and 1 or math.log(p109, 2) + 1
            end
        },
        {
            ["Stat"] = "Snowflakes",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p110) -- name: Formula
                return 1 + 0.005 * p110
            end
        },
        {
            ["Stat"] = "RuneBulk",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p111) -- name: Formula
                return p111 <= 0 and 1 or math.log(p111, 10) + 1
            end
        }
    },
    ["AbsoluteZero"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 17,
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 50,
            ["Type"] = "Multi",
            ["Formula"] = function(p112) -- name: Formula
                return p112 <= 0 and 1 or math.log(p112, 1.54) + 1
            end
        },
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p113) -- name: Formula
                return p113 <= 0 and 1 or math.log(p113, 1.5) + 1
            end
        },
        {
            ["Stat"] = "Ice",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Multi",
            ["Formula"] = function(p114) -- name: Formula
                return 1 + 0.01 * p114
            end
        }
    },
    ["Eternalwhiteout"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 17,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p115) -- name: Formula
                return p115 <= 0 and 1 or math.log(p115, 1.75) + 1
            end
        },
        {
            ["Stat"] = "Ice",
            ["Formula"] = nil,
            ["Cap"] = 6,
            ["Type"] = "Multi",
            ["Formula"] = function(p116) -- name: Formula
                return p116 <= 0 and 1 or math.log(p116, 3) + 1
            end
        },
        {
            ["Stat"] = "AuraLuck",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p117) -- name: Formula
                return p117 <= 0 and 1 or math.log(p117, 2500) + 1
            end
        }
    },
    ["Hailstorm"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 17,
        {
            ["Stat"] = "Snowflakes",
            ["Formula"] = nil,
            ["Cap"] = 40,
            ["Type"] = "Multi",
            ["Formula"] = function(p118) -- name: Formula
                return 1 + p118 * 2
            end
        },
        {
            ["Stat"] = "Credits",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Multi",
            ["Formula"] = function(p119) -- name: Formula
                return p119 <= 0 and 1 or math.log(p119, 2) + 1
            end
        },
        {
            ["Stat"] = "Chi",
            ["Formula"] = nil,
            ["Cap"] = 1000,
            ["Type"] = "Multi",
            ["Formula"] = function(p120) -- name: Formula
                return 1 + 0.001 * p120
            end
        }
    }
}
v_u_4.Snow = v121
local v143 = {
    ["Frost"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 19,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p122) -- name: Formula
                return p122 <= 0 and 1 or math.log(p122, 1000) + 1
            end
        },
        {
            ["Stat"] = "Ice",
            ["Formula"] = nil,
            ["Cap"] = 4,
            ["Type"] = "Multi",
            ["Formula"] = function(p123) -- name: Formula
                return 1 + 1e-15 * p123
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p124) -- name: Formula
                return 1 + p124 ^ 0.05
            end
        }
    },
    ["Glacier"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 19,
        {
            ["Stat"] = "GoldGain",
            ["Formula"] = nil,
            ["Cap"] = 100,
            ["Type"] = "Multi",
            ["Formula"] = function(p125) -- name: Formula
                return 1 + p125 / 15000
            end
        },
        {
            ["Stat"] = "Ice",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p126) -- name: Formula
                return p126 <= 0 and 1 or math.log(p126, 15) + 1
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p127) -- name: Formula
                return 1 + p127
            end
        }
    },
    ["Cryo"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 19,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 35,
            ["Type"] = "Multi",
            ["Formula"] = function(p128) -- name: Formula
                return p128 <= 0 and 1 or math.log(p128, 1.65) + 1
            end
        },
        {
            ["Stat"] = "Ice",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p129) -- name: Formula
                return p129 <= 0 and 1 or math.log(p129, 8) + 1
            end
        },
        {
            ["Stat"] = "AuraLuck",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p130) -- name: Formula
                return p130 <= 0 and 1 or math.log(p130, 50000) + 1
            end
        }
    },
    ["Shiver"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 19,
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p131) -- name: Formula
                return p131 <= 0 and 1 or math.log(p131, 4) + 1
            end
        },
        {
            ["Stat"] = "Ice",
            ["Formula"] = nil,
            ["Cap"] = 6,
            ["Type"] = "Multi",
            ["Formula"] = function(p132) -- name: Formula
                return p132 <= 0 and 1 or 1 + 0.005 * p132
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 7,
            ["Type"] = "Multi",
            ["Formula"] = function(p133) -- name: Formula
                return 1 + 0.15 * p133
            end
        }
    },
    ["Blizzard"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 19,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p134) -- name: Formula
                return p134 <= 0 and 1 or math.log(p134, 2.5) + 1
            end
        },
        {
            ["Stat"] = "Ice",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p135) -- name: Formula
                return p135 <= 0 and 1 or math.log(p135, 5) + 1
            end
        },
        {
            ["Stat"] = "Snowflakes",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p136) -- name: Formula
                return 1 + 0.0005 * p136
            end
        }
    },
    ["Hurricane"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 19,
        {
            ["Stat"] = "Ice",
            ["Formula"] = nil,
            ["Cap"] = 4,
            ["Type"] = "Multi",
            ["Formula"] = function(p137) -- name: Formula
                return 1 + p137
            end
        },
        {
            ["Stat"] = "OreDamage",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Multi",
            ["Formula"] = function(p138) -- name: Formula
                return 1 + 0.14 * p138
            end
        },
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p139) -- name: Formula
                return p139 <= 0 and 1 or math.log(p139, 10) + 1
            end
        }
    },
    ["EternalFrost"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 19,
        {
            ["Stat"] = "Credits",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p140) -- name: Formula
                return p140 <= 0 and 1 or math.log(p140, 4.25) + 1
            end
        },
        {
            ["Stat"] = "FishLuck",
            ["Formula"] = nil,
            ["Cap"] = 30,
            ["Type"] = "Multi",
            ["Formula"] = function(p141) -- name: Formula
                return p141 <= 0 and 1 or math.log(p141, 1.75) + 1
            end
        },
        {
            ["Stat"] = "AuraLuck",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p142) -- name: Formula
                return p142 <= 0 and 1 or math.log(p142, 25) + 1
            end
        }
    }
}
v_u_4.Icey = v143
local v180 = {
    ["Dirt"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 7,
            ["Type"] = "Multi",
            ["Formula"] = function(p144) -- name: Formula
                return 1 + 0.025 * p144
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p145) -- name: Formula
                return 1 + 0.02 * p145
            end
        },
        {
            ["Stat"] = "OreDamage",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p146) -- name: Formula
                return p146 <= 0 and 1 or math.log(p146, 100) + 1
            end
        }
    },
    ["Shallow"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 7,
            ["Type"] = "Multi",
            ["Formula"] = function(p147) -- name: Formula
                return p147 <= 0 and 1 or math.log(p147, 6) + 1
            end
        },
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 12,
            ["Type"] = "Multi",
            ["Formula"] = function(p148) -- name: Formula
                return 1 + p148 ^ 0.45
            end
        },
        {
            ["Stat"] = "CRuneBulk",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p149) -- name: Formula
                return 1 + 0.01 * p149
            end
        }
    },
    ["Cavern"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 10,
            ["Type"] = "Multi",
            ["Formula"] = function(p150) -- name: Formula
                return p150 <= 0 and 1 or math.log(p150, 2) + 1
            end
        },
        {
            ["Stat"] = "OreDamage",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p151) -- name: Formula
                return 1 + 0.005 * p151
            end
        },
        {
            ["Stat"] = "CRuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p152) -- name: Formula
                return 1 + p152 / 2
            end
        }
    },
    ["Grotto"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 7,
            ["Type"] = "Multi",
            ["Formula"] = function(p153) -- name: Formula
                return 1 + p153 * 5
            end
        },
        {
            ["Stat"] = "Ice",
            ["Formula"] = nil,
            ["Cap"] = 45,
            ["Type"] = "Multi",
            ["Formula"] = function(p154) -- name: Formula
                return 1 * 1.003 ^ p154
            end
        },
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Multi",
            ["Formula"] = function(p155) -- name: Formula
                return 1 * 1.015 ^ p155
            end
        }
    },
    ["CrystalCave"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "Shards",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p156) -- name: Formula
                return 1 + 0.1 * p156
            end
        },
        {
            ["Stat"] = "CRuneBulk",
            ["Formula"] = nil,
            ["Cap"] = 7,
            ["Type"] = "Multi",
            ["Formula"] = function(p157) -- name: Formula
                return p157 <= 0 and 1 or 1 + p157 ^ 0.75
            end
        },
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 1000,
            ["Type"] = "Multi",
            ["Formula"] = function(p158) -- name: Formula
                return 1 * 1.01 ^ p158
            end
        }
    },
    ["DeepHollow"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p159) -- name: Formula
                return 1 + 0.02 * p159
            end
        },
        {
            ["Stat"] = "OreDamage",
            ["Formula"] = nil,
            ["Cap"] = 100,
            ["Type"] = "Multi",
            ["Formula"] = function(p160) -- name: Formula
                return 1 + 0.09 * p160
            end
        },
        {
            ["Stat"] = "CRuneClone",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p161) -- name: Formula
                return 1 + p161
            end
        }
    },
    ["Dripstone"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 25,
            ["Type"] = "Multi",
            ["Formula"] = function(p162) -- name: Formula
                return 1 + 0.2 * p162
            end
        },
        {
            ["Stat"] = "Shards",
            ["Formula"] = nil,
            ["Cap"] = 15,
            ["Type"] = "Multi",
            ["Formula"] = function(p163) -- name: Formula
                return p163 <= 0 and 1 or math.log(p163, 2) + 1
            end
        },
        {
            ["Stat"] = "CRuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 4,
            ["Type"] = "Multi",
            ["Formula"] = function(p164) -- name: Formula
                return 1 + 0.5 * p164
            end
        }
    },
    ["Bedrock"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 30,
            ["Type"] = "Multi",
            ["Formula"] = function(p165) -- name: Formula
                return p165 <= 0 and 1 or math.log(p165, 1.25) + 1
            end
        },
        {
            ["Stat"] = "Shards",
            ["Formula"] = nil,
            ["Cap"] = 100,
            ["Type"] = "Multi",
            ["Formula"] = function(p166) -- name: Formula
                return 1 + p166
            end
        },
        {
            ["Stat"] = "AuraLuck",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p167) -- name: Formula
                return 1 + 0.5 * p167
            end
        }
    },
    ["Geode"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "AntiMatter",
            ["Formula"] = nil,
            ["Cap"] = 4,
            ["Type"] = "Multi",
            ["Formula"] = function(p168) -- name: Formula
                return 1 + p168 / 13.4
            end
        },
        {
            ["Stat"] = "RuneBulk",
            ["Formula"] = nil,
            ["Cap"] = 45,
            ["Type"] = "Multi",
            ["Formula"] = function(p169) -- name: Formula
                return 1 + p169 / 2
            end
        },
        {
            ["Stat"] = "PlasmaPoints",
            ["Formula"] = nil,
            ["Cap"] = 4000000,
            ["Type"] = "Multi",
            ["Formula"] = function(p170) -- name: Formula
                return 1 * 1.079 ^ p170
            end
        }
    },
    ["Glowstone"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 256,
            ["Type"] = "Multi",
            ["Formula"] = function(p171) -- name: Formula
                return p171 <= 0 and 1 or 1 * 2 ^ (p171 / 2)
            end
        },
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 100,
            ["Type"] = "Multi",
            ["Formula"] = function(p172) -- name: Formula
                return 1 + 0.1 * p172
            end
        },
        {
            ["Stat"] = "CRuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 2.25,
            ["Type"] = "Multi",
            ["Formula"] = function(p173) -- name: Formula
                return 1 + 0.05 * p173
            end
        }
    },
    ["Moonstone"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "Shards",
            ["Formula"] = nil,
            ["Cap"] = 250,
            ["Type"] = "Multi",
            ["Formula"] = function(p174) -- name: Formula
                return 1 + p174
            end
        },
        {
            ["Stat"] = "OreGain",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p175) -- name: Formula
                return p175 <= 0 and 1 or math.log(p175, 5) + 1
            end
        },
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 50,
            ["Type"] = "Multi",
            ["Formula"] = function(p176) -- name: Formula
                return p176 <= 0 and 1 or math.log(p176, 1.3) + 1
            end
        }
    },
    ["Subterra"] = {
        ["RuneType"] = "Secret",
        ["ClassReq"] = 21,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 1000000,
            ["Type"] = "Multi",
            ["Formula"] = function(p177) -- name: Formula
                return p177 <= 0 and 1 or 1 * 2 ^ (p177 / 60)
            end
        },
        {
            ["Stat"] = "OreGain",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p178) -- name: Formula
                return 1 + p178
            end
        },
        {
            ["Stat"] = "Cash",
            ["Formula"] = nil,
            ["Cap"] = 100,
            ["Type"] = "Multi",
            ["Formula"] = function(p179) -- name: Formula
                return 1 * 1.1 ^ p179
            end
        }
    }
}
v_u_4.Cave = v180
local v189 = {
    ["Carved"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 3,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 1.5,
            ["Type"] = "Multi",
            ["Formula"] = function(p181) -- name: Formula
                return 1 + 0.0035 * p181
            end
        }
    },
    ["Etched"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 4,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p182) -- name: Formula
                return 1 + 0.003 * p182
            end
        }
    },
    ["Inscribed"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 5,
        {
            ["Stat"] = "Essence",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p183) -- name: Formula
                return 1 + 0.01 * p183
            end
        }
    },
    ["Runebound"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 6,
        {
            ["Stat"] = "Essence",
            ["Formula"] = nil,
            ["Cap"] = 5,
            ["Type"] = "Multi",
            ["Formula"] = function(p184) -- name: Formula
                return 1 + 0.02 * p184
            end
        }
    },
    ["Worldmarked"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 7,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p185) -- name: Formula
                return 1 + 0.1 * p185
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 1.75,
            ["Type"] = "Multi",
            ["Formula"] = function(p186) -- name: Formula
                return p186 <= 0 and 1 or 0.25 + p186 ^ 0.34
            end
        }
    },
    ["Primordial"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 8,
        {
            ["Stat"] = "PlayerXp",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p187) -- name: Formula
                return 1 + p187 ^ 0.7
            end
        },
        {
            ["Stat"] = "RuneBulk",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p188) -- name: Formula
                return 1 + 0.25 * p188
            end
        }
    }
}
v_u_4.Global = v189
local v199 = {
    ["Ember"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 3,
        {
            ["Stat"] = "Magma",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p190) -- name: Formula
                return 1 + 0.0025 * p190
            end
        },
        {
            ["Stat"] = "Essence",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p191) -- name: Formula
                return 1 + 0.002 * p191
            end
        }
    },
    ["Brimstone"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 4,
        {
            ["Stat"] = "Magma",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p192) -- name: Formula
                return 1 + 0.003 * p192
            end
        }
    },
    ["Blaze"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 5,
        {
            ["Stat"] = "Power",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p193) -- name: Formula
                return 1 + 0.005 * p193
            end
        }
    },
    ["Infernal"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 6,
        {
            ["Stat"] = "Lava",
            ["Formula"] = nil,
            ["Cap"] = 1.75,
            ["Type"] = "Multi",
            ["Formula"] = function(p194) -- name: Formula
                return 1 + 0.0025 * p194
            end
        }
    },
    ["Abyssfire"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 7,
        {
            ["Stat"] = "RuneBulk",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p195) -- name: Formula
                return 1 + 0.15 * p195
            end
        },
        {
            ["Stat"] = "RuneLuck",
            ["Formula"] = nil,
            ["Cap"] = 1.75,
            ["Type"] = "Multi",
            ["Formula"] = function(p196) -- name: Formula
                return 1 + 0.1 * p196
            end
        }
    },
    ["Hellfire"] = {
        ["RuneType"] = "Normal",
        ["ClassReq"] = 8,
        {
            ["Stat"] = "PlasmaPoints",
            ["Formula"] = nil,
            ["Cap"] = 3,
            ["Type"] = "Multi",
            ["Formula"] = function(p197) -- name: Formula
                return 1 + 0.5 * p197
            end
        },
        {
            ["Stat"] = "AuraLuck",
            ["Formula"] = nil,
            ["Cap"] = 2,
            ["Type"] = "Multi",
            ["Formula"] = function(p198) -- name: Formula
                return 1 + 0.25 * p198
            end
        }
    }
}
v_u_4.HellfireGlobal = v199
local v_u_200 = setmetatable({}, {
    ["__mode"] = "k"
})
local function v_u_205(p_u_201, p202) -- name: watchRuneInstance
    local v203 = p_u_201.RuneConnections[p202]
    if v203 then
        for _, v204 in ipairs(v203) do
            v204:Disconnect()
        end
        p_u_201.RuneConnections[p202] = nil
    end
    if p202:IsA("ValueBase") then
        p_u_201.RuneConnections[p202] = { p202.Changed:Connect(function()
                -- upvalues: (copy) p_u_201
                p_u_201.Totals = {}
            end), p202:GetPropertyChangedSignal("Name"):Connect(function()
                -- upvalues: (copy) p_u_201
                p_u_201.Totals = {}
            end) }
    end
end
local function v_u_211(p206) -- name: disconnectRuneBoostCache
    for v207 in pairs(p206.RuneConnections) do
        local v208 = p206.RuneConnections[v207]
        if v208 then
            for _, v209 in ipairs(v208) do
                v209:Disconnect()
            end
            p206.RuneConnections[v207] = nil
        end
    end
    for _, v210 in ipairs(p206.Connections) do
        v210:Disconnect()
    end
end
local function v_u_228(p212, p213) -- name: createRuneBoostCache
    -- upvalues: (copy) v_u_205
    local v_u_214 = {
        ["DataFolder"] = p213,
        ["Totals"] = {},
        ["RuneConnections"] = setmetatable({}, {
            ["__mode"] = "k"
        }),
        ["Connections"] = {}
    }
    for _, v215 in ipairs(p212:GetChildren()) do
        v_u_205(v_u_214, v215)
    end
    local v216 = v_u_214.Connections
    local v217 = p212.ChildAdded
    local function v219(p218)
        -- upvalues: (ref) v_u_205, (copy) v_u_214
        v_u_205(v_u_214, p218)
        v_u_214.Totals = {}
    end
    table.insert(v216, v217:Connect(v219))
    local v220 = v_u_214.Connections
    local v221 = p212.ChildRemoved
    table.insert(v220, v221:Connect(function(p222)
        -- upvalues: (copy) v_u_214
        local v223 = v_u_214
        local v224 = v223.RuneConnections[p222]
        if v224 then
            for _, v225 in ipairs(v224) do
                v225:Disconnect()
            end
            v223.RuneConnections[p222] = nil
        end
        v_u_214.Totals = {}
    end))
    local v226 = v_u_214.Connections
    local v227 = p213.Class.Changed
    table.insert(v226, v227:Connect(function()
        -- upvalues: (copy) v_u_214
        v_u_214.Totals = {}
    end))
    return v_u_214
end
function v_u_1.RuneBoosts(p229, p230, p231) -- name: RuneBoosts
    -- upvalues: (copy) v_u_4
    local v232 = p231.Class.Value
    local v233 = {}
    for _, v234 in ipairs(p230:GetChildren()) do
        local v235 = v234.Name
        local v236 = v234.Value
        local v237 = v_u_4[p229][v235]
        if v237 and v237.ClassReq <= v232 then
            for _, v238 in ipairs(v237) do
                local v239 = {
                    ["BoostStat"] = v238.Stat,
                    ["BoostType"] = v238.Type,
                    ["Boost"] = v238.Formula(v236),
                    ["Cap"] = v238.Cap,
                    ["RuneName"] = v235
                }
                table.insert(v233, v239)
            end
        end
    end
    return v233
end
function v_u_1.GetTotalBoost(p240, p241, p242, p243) -- name: GetTotalBoost
    -- upvalues: (copy) v_u_200, (copy) v_u_211, (copy) v_u_228, (copy) v_u_1, (copy) v_u_2
    local v244
    if type(p240) == "string" then
        v244 = type(p241) == "string"
    else
        v244 = false
    end
    local v245
    if v244 then
        local v246 = v_u_200[p242]
        if not v246 or v246.DataFolder ~= p243 then
            if v246 then
                v_u_211(v246)
            end
            v246 = v_u_228(p242, p243)
            v_u_200[p242] = v246
        end
        v245 = v246.Totals[p240]
        if not v245 then
            v245 = {}
            v246.Totals[p240] = v245
        end
        local v247 = v245[p241]
        if v247 then
            return v247:clone()
        end
    else
        v245 = nil
    end
    local v248 = v_u_1.RuneBoosts(p240, p242, p243)
    local v249 = v_u_2(0)
    local v250 = v_u_2(1)
    for _, v251 in pairs(v248) do
        local v252 = v251.BoostStat
        if type(v252) == "table" then
            for v253, v254 in ipairs(v251.BoostStat) do
                if v254 == p241 then
                    local v255 = v251.Boost[v253]
                    if v255 > 1e308 or (v255 == (1 / 0) or v255 ~= v255) then
                        v255 = v251.Cap
                    end
                    local v256 = v251.Cap
                    local v257 = v_u_2((math.min(v255, v256)))
                    if v251.BoostType[v253] == "Add" then
                        v249 = v249 + v257
                    elseif v251.BoostType[v253] == "Multi" then
                        v250 = v250 * v257
                    end
                end
            end
        elseif v251.BoostStat == p241 then
            local v258 = v251.Boost
            if v258 > 1e308 or (v258 == (1 / 0) or v258 ~= v258) then
                v258 = v251.Cap
            end
            local v259 = v251.Cap
            local v260 = v_u_2((math.min(v258, v259)))
            if v251.BoostType == "Add" then
                v249 = v249 + v260
            elseif v251.BoostType == "Multi" then
                v250 = v250 * v260
            end
        end
    end
    local v261 = (v_u_2(1) + v249) * v250
    if not v245 then
        return v261
    end
    v245[p241] = v261
    return v261:clone()
end
function v_u_1.GetRuneBoost(p262, p263, p264) -- name: GetRuneBoost
    -- upvalues: (copy) v_u_4
    local v265 = v_u_4[p262][p263]
    if not v265 then
        return {}
    end
    local v266 = {}
    for _, v267 in ipairs(v265) do
        local v268 = {
            ["Stat"] = v267.Stat,
            ["Value"] = v267.Formula(p264),
            ["Type"] = v267.Type,
            ["Cap"] = v267.Cap,
            ["RuneType"] = v265.RuneType
        }
        table.insert(v266, v268)
    end
    return v266
end
function v_u_1.GetDisplayedChance(_, p269, p270, p271) -- name: GetDisplayedChance
    -- upvalues: (copy) v_u_3
    local v272 = p271 or 1
    local v273 = v_u_3[p269]
    if not v273 then
        return nil
    end
    local v274 = {}
    local v275 = {}
    for v276, v277 in ipairs(v273) do
        local v278 = v277.Chance * v272
        if v278 >= 1 then
            table.insert(v274, v276)
            v278 = 1
        end
        v275[v276] = {
            ["Name"] = v277.Name,
            ["Chance"] = v278
        }
    end
    if #v274 > 0 then
        local v279 = v274[#v274]
        for v280 = 1, #v274 - 1 do
            v275[v274[v280]].Chance = 0
        end
        local v281 = 0
        for v282, v283 in ipairs(v275) do
            if v282 ~= v279 then
                v281 = v281 + v283.Chance
            end
        end
        local v284 = v275[v279]
        local v285 = 1 - v281
        v284.Chance = math.max(0, v285)
    end
    local v286 = 0
    for _, v287 in ipairs(v275) do
        v286 = v286 + v287.Chance
    end
    if v286 <= 0 then
        return 0
    end
    for _, v288 in ipairs(v275) do
        if v288.Name == p270 then
            return v288.Chance / v286
        end
    end
    return nil
end
return v_u_1
