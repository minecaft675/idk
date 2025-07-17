-- 🏭 COMPREHENSIVE MACHINE SYSTEM
-- All 45 machines with recipes, power usage, and production chains

local MachineSystem = {}

-- 🎯 SERVICE REFERENCES
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- 🏭 MACHINE DATABASE (45 Total)
MachineSystem.Machines = {
    -- 🔋 POWER GENERATION (8 Total)
    ["Coal Generator"] = {
        id = 1,
        category = "Power Generation",
        emoji = "⚫",
        description = "Basic, dirty energy source",
        powerOutput = 100,
        powerConsumption = 0,
        pollution = 15,
        inputs = {"Coal"},
        outputs = {"Electricity"},
        biomeRestrictions = {},
        prestigeRequired = 0,
        cost = 5000,
        buildTime = 30,
        recipes = {
            {input = {Coal = 1}, output = {Electricity = 100}, time = 10}
        }
    },
    
    ["Wind Turbine"] = {
        id = 2,
        category = "Power Generation", 
        emoji = "💨",
        description = "Clean but variable energy",
        powerOutput = 80,
        powerConsumption = 0,
        pollution = 0,
        inputs = {},
        outputs = {"Electricity"},
        biomeRestrictions = {},
        prestigeRequired = 0,
        cost = 8000,
        buildTime = 45,
        variableOutput = true,
        recipes = {
            {input = {}, output = {Electricity = 80}, time = 5}
        }
    },
    
    ["Solar Panel"] = {
        id = 3,
        category = "Power Generation",
        emoji = "☀️", 
        description = "Renewable, day-only power",
        powerOutput = 120,
        powerConsumption = 0,
        pollution = 0,
        inputs = {},
        outputs = {"Electricity"},
        biomeRestrictions = {},
        prestigeRequired = 0,
        cost = 12000,
        buildTime = 60,
        dayOnly = true,
        recipes = {
            {input = {}, output = {Electricity = 120}, time = 3, dayOnly = true}
        }
    },
    
    ["Hydroelectric Dam"] = {
        id = 4,
        category = "Power Generation",
        emoji = "🌊",
        description = "Requires water biome",
        powerOutput = 200,
        powerConsumption = 0,
        pollution = 0,
        inputs = {"Water"},
        outputs = {"Electricity"},
        biomeRestrictions = {"Water"},
        prestigeRequired = 1,
        cost = 25000,
        buildTime = 120,
        recipes = {
            {input = {Water = 1}, output = {Electricity = 200}, time = 5}
        }
    },
    
    ["Fusion Reactor"] = {
        id = 5,
        category = "Power Generation",
        emoji = "⚛️",
        description = "Infinite power source",
        powerOutput = 1000,
        powerConsumption = 0,
        pollution = 0,
        inputs = {"Hydrogen", "Helium"},
        outputs = {"Electricity"},
        biomeRestrictions = {},
        prestigeRequired = 3,
        cost = 500000,
        buildTime = 600,
        recipes = {
            {input = {Hydrogen = 1, Helium = 1}, output = {Electricity = 1000}, time = 1}
        }
    },
    
    ["Geothermal Plant"] = {
        id = 6,
        category = "Power Generation",
        emoji = "🌋",
        description = "Volcano-only biome power",
        powerOutput = 300,
        powerConsumption = 0,
        pollution = 5,
        inputs = {},
        outputs = {"Electricity", "Steam"},
        biomeRestrictions = {"Volcano"},
        prestigeRequired = 2,
        cost = 75000,
        buildTime = 180,
        recipes = {
            {input = {}, output = {Electricity = 300, Steam = 50}, time = 8}
        }
    },
    
    ["Biofuel Generator"] = {
        id = 7,
        category = "Power Generation",
        emoji = "🌿",
        description = "Burns plant waste for energy",
        powerOutput = 150,
        powerConsumption = 0,
        pollution = 8,
        inputs = {"Plant Waste", "Biomass"},
        outputs = {"Electricity"},
        biomeRestrictions = {},
        prestigeRequired = 1,
        cost = 20000,
        buildTime = 75,
        recipes = {
            {input = {PlantWaste = 2}, output = {Electricity = 150}, time = 15},
            {input = {Biomass = 1}, output = {Electricity = 180}, time = 12}
        }
    },
    
    ["Nuclear Reactor"] = {
        id = 8,
        category = "Power Generation",
        emoji = "☢️",
        description = "High power, meltdown risk",
        powerOutput = 800,
        powerConsumption = 0,
        pollution = 25,
        inputs = {"Uranium", "Water"},
        outputs = {"Electricity", "Nuclear Waste"},
        biomeRestrictions = {},
        prestigeRequired = 2,
        cost = 200000,
        buildTime = 300,
        meltdownRisk = true,
        recipes = {
            {input = {Uranium = 1, Water = 5}, output = {Electricity = 800, NuclearWaste = 1}, time = 60}
        }
    },
    
    -- 🏗️ PRODUCTION MACHINES (14 Total)
    ["Ore Miner"] = {
        id = 9,
        category = "Production",
        emoji = "⛏️",
        description = "Extracts ore from ground",
        powerOutput = 0,
        powerConsumption = 50,
        pollution = 10,
        inputs = {},
        outputs = {"Iron Ore", "Copper Ore", "Coal"},
        biomeRestrictions = {},
        prestigeRequired = 0,
        cost = 3000,
        buildTime = 20,
        recipes = {
            {input = {}, output = {IronOre = 2, CopperOre = 1}, time = 20},
            {input = {}, output = {Coal = 3}, time = 25}
        }
    },
    
    ["Oil Pump"] = {
        id = 10,
        category = "Production",
        emoji = "🛢️",
        description = "Extracts crude oil",
        powerOutput = 0,
        powerConsumption = 75,
        pollution = 15,
        inputs = {},
        outputs = {"Crude Oil"},
        biomeRestrictions = {"Desert", "Ocean"},
        prestigeRequired = 0,
        cost = 8000,
        buildTime = 45,
        recipes = {
            {input = {}, output = {CrudeOil = 3}, time = 30}
        }
    },
    
    ["Smelter"] = {
        id = 11,
        category = "Production",
        emoji = "🔥",
        description = "Converts ore to ingots",
        powerOutput = 0,
        powerConsumption = 100,
        pollution = 20,
        inputs = {"Iron Ore", "Copper Ore", "Coal"},
        outputs = {"Iron Ingot", "Copper Ingot"},
        biomeRestrictions = {},
        prestigeRequired = 0,
        cost = 5000,
        buildTime = 30,
        recipes = {
            {input = {IronOre = 2, Coal = 1}, output = {IronIngot = 1}, time = 15},
            {input = {CopperOre = 2, Coal = 1}, output = {CopperIngot = 1}, time = 12}
        }
    },
    
    ["Refinery"] = {
        id = 12,
        category = "Production",
        emoji = "🏭",
        description = "Processes crude oil into fuel and plastics",
        powerOutput = 0,
        powerConsumption = 150,
        pollution = 30,
        inputs = {"Crude Oil"},
        outputs = {"Fuel", "Plastic"},
        biomeRestrictions = {},
        prestigeRequired = 1,
        cost = 15000,
        buildTime = 60,
        recipes = {
            {input = {CrudeOil = 3}, output = {Fuel = 2, Plastic = 1}, time = 25}
        }
    },
    
    ["Assembler"] = {
        id = 13,
        category = "Production",
        emoji = "🔧",
        description = "Combines parts into products",
        powerOutput = 0,
        powerConsumption = 80,
        pollution = 5,
        inputs = {"Iron Ingot", "Copper Ingot", "Plastic"},
        outputs = {"Gear", "Wire", "Component"},
        biomeRestrictions = {},
        prestigeRequired = 1,
        cost = 12000,
        buildTime = 45,
        recipes = {
            {input = {IronIngot = 2}, output = {Gear = 1}, time = 20},
            {input = {CopperIngot = 1}, output = {Wire = 3}, time = 15},
            {input = {IronIngot = 1, Plastic = 1}, output = {Component = 1}, time = 18}
        }
    },
    
    ["Alloy Furnace"] = {
        id = 14,
        category = "Production",
        emoji = "🔩",
        description = "Mixes metals into alloys",
        powerOutput = 0,
        powerConsumption = 200,
        pollution = 25,
        inputs = {"Iron Ingot", "Copper Ingot", "Coal"},
        outputs = {"Steel", "Bronze", "Advanced Alloy"},
        biomeRestrictions = {},
        prestigeRequired = 2,
        cost = 25000,
        buildTime = 90,
        recipes = {
            {input = {IronIngot = 3, Coal = 2}, output = {Steel = 1}, time = 30},
            {input = {CopperIngot = 3, IronIngot = 1}, output = {Bronze = 1}, time = 25},
            {input = {Steel = 2, CopperIngot = 1}, output = {AdvancedAlloy = 1}, time = 45}
        }
    },
    
    ["Glass Maker"] = {
        id = 15,
        category = "Production",
        emoji = "🔍",
        description = "Converts sand to glass",
        powerOutput = 0,
        powerConsumption = 60,
        pollution = 5,
        inputs = {"Sand"},
        outputs = {"Glass"},
        biomeRestrictions = {},
        prestigeRequired = 0,
        cost = 4000,
        buildTime = 25,
        recipes = {
            {input = {Sand = 2}, output = {Glass = 1}, time = 20}
        }
    },
    
    ["Electronics Fab"] = {
        id = 16,
        category = "Production",
        emoji = "💻",
        description = "Creates circuits from metals and plastic",
        powerOutput = 0,
        powerConsumption = 120,
        pollution = 10,
        inputs = {"Copper Ingot", "Plastic", "Glass"},
        outputs = {"Circuit", "Microchip"},
        biomeRestrictions = {},
        prestigeRequired = 2,
        cost = 30000,
        buildTime = 75,
        recipes = {
            {input = {CopperIngot = 1, Plastic = 1}, output = {Circuit = 1}, time = 25},
            {input = {Circuit = 2, Glass = 1}, output = {Microchip = 1}, time = 40}
        }
    },
    
    ["Chem Plant"] = {
        id = 17,
        category = "Production",
        emoji = "🧪",
        description = "Produces chemicals from oil and minerals",
        powerOutput = 0,
        powerConsumption = 180,
        pollution = 40,
        inputs = {"Crude Oil", "Water", "Salt"},
        outputs = {"Chemical", "Acid", "Polymer"},
        biomeRestrictions = {},
        prestigeRequired = 2,
        cost = 45000,
        buildTime = 120,
        recipes = {
            {input = {CrudeOil = 2, Water = 3}, output = {Chemical = 2}, time = 35},
            {input = {Chemical = 1, Salt = 1}, output = {Acid = 1}, time = 25},
            {input = {Chemical = 3}, output = {Polymer = 1}, time = 50}
        }
    },
    
    ["Textile Mill"] = {
        id = 18,
        category = "Production",
        emoji = "🧵",
        description = "Processes cotton and wool into cloth",
        powerOutput = 0,
        powerConsumption = 70,
        pollution = 3,
        inputs = {"Cotton", "Wool"},
        outputs = {"Cloth", "Thread"},
        biomeRestrictions = {},
        prestigeRequired = 1,
        cost = 8000,
        buildTime = 40,
        recipes = {
            {input = {Cotton = 3}, output = {Cloth = 1}, time = 30},
            {input = {Wool = 2}, output = {Thread = 4}, time = 20}
        }
    },
    
    ["Food Processor"] = {
        id = 19,
        category = "Production",
        emoji = "🥫",
        description = "Packages raw food into meals",
        powerOutput = 0,
        powerConsumption = 40,
        pollution = 2,
        inputs = {"Wheat", "Meat", "Vegetables"},
        outputs = {"Packaged Meal", "Snacks"},
        biomeRestrictions = {},
        prestigeRequired = 0,
        cost = 6000,
        buildTime = 35,
        recipes = {
            {input = {Wheat = 2, Meat = 1}, output = {PackagedMeal = 2}, time = 25},
            {input = {Vegetables = 3}, output = {Snacks = 4}, time = 15}
        }
    },
    
    ["Quantum Smelter"] = {
        id = 20,
        category = "Production",
        emoji = "⚡",
        description = "Prestige 4 upgrade to smelter",
        powerOutput = 0,
        powerConsumption = 300,
        pollution = 0,
        inputs = {"Any Ore", "Quantum Catalyst"},
        outputs = {"Perfect Ingot"},
        biomeRestrictions = {},
        prestigeRequired = 4,
        cost = 1000000,
        buildTime = 480,
        recipes = {
            {input = {IronOre = 1, QuantumCatalyst = 1}, output = {PerfectIronIngot = 2}, time = 5},
            {input = {CopperOre = 1, QuantumCatalyst = 1}, output = {PerfectCopperIngot = 2}, time = 5}
        }
    },
    
    ["Nanofabricator"] = {
        id = 21,
        category = "Production",
        emoji = "🔬",
        description = "Builds nano-components for late-game",
        powerOutput = 0,
        powerConsumption = 500,
        pollution = 0,
        inputs = {"Carbon", "Silicon", "Rare Earth"},
        outputs = {"Nanocomponent", "Nanotube"},
        biomeRestrictions = {},
        prestigeRequired = 4,
        cost = 750000,
        buildTime = 360,
        recipes = {
            {input = {Carbon = 5, Silicon = 2}, output = {Nanocomponent = 1}, time = 60},
            {input = {RareEarth = 1, Carbon = 10}, output = {Nanotube = 1}, time = 90}
        }
    },
    
    ["3D Printer"] = {
        id = 22,
        category = "Production",
        emoji = "🖨️",
        description = "Prints small parts on demand",
        powerOutput = 0,
        powerConsumption = 90,
        pollution = 1,
        inputs = {"Plastic", "Metal Powder"},
        outputs = {"Custom Part", "Prototype"},
        biomeRestrictions = {},
        prestigeRequired = 3,
        cost = 50000,
        buildTime = 100,
        recipes = {
            {input = {Plastic = 2, MetalPowder = 1}, output = {CustomPart = 1}, time = 20},
            {input = {MetalPowder = 3}, output = {Prototype = 1}, time = 45}
        }
    }
}

-- 🚚 LOGISTICS & UTILITY MACHINES
local logisticsMachines = {
    ["Conveyor Belt"] = {
        id = 23, category = "Logistics", emoji = "🔄", description = "Moves items between machines",
        powerConsumption = 5, cost = 500, buildTime = 10
    },
    ["Item Sorter"] = {
        id = 24, category = "Logistics", emoji = "📦", description = "Splits item types to different outputs",
        powerConsumption = 15, cost = 2000, buildTime = 20
    },
    ["Drone Hub"] = {
        id = 25, category = "Logistics", emoji = "🚁", description = "Long-distance delivery system",
        powerConsumption = 100, cost = 25000, buildTime = 60, prestigeRequired = 2
    },
    ["Pipeline"] = {
        id = 26, category = "Logistics", emoji = "🔧", description = "Transports fluids",
        powerConsumption = 10, cost = 1500, buildTime = 15
    },
    ["Storage Tank"] = {
        id = 27, category = "Logistics", emoji = "🛢️", description = "Holds liquid materials",
        powerConsumption = 2, cost = 3000, buildTime = 25
    },
    ["Warehouse"] = {
        id = 28, category = "Logistics", emoji = "🏪", description = "Stores solid goods",
        powerConsumption = 5, cost = 5000, buildTime = 30
    },
    ["Teleport Pad"] = {
        id = 29, category = "Logistics", emoji = "🌀", description = "Late-game instant transport",
        powerConsumption = 1000, cost = 500000, buildTime = 300, prestigeRequired = 4
    }
}

-- 🛡️ MAINTENANCE & ECO MACHINES  
local maintenanceMachines = {
    ["Cooler Unit"] = {
        id = 30, category = "Maintenance", emoji = "❄️", description = "Prevents machine overheating",
        powerConsumption = 30, cost = 4000, buildTime = 20
    },
    ["Auto-Fixer Robot"] = {
        id = 31, category = "Maintenance", emoji = "🤖", description = "Automatically repairs machines",
        powerConsumption = 50, cost = 1000000, buildTime = 240, prestigeRequired = 3
    },
    ["Pollution Scrubber"] = {
        id = 32, category = "Maintenance", emoji = "🌬️", description = "Cleans air pollution",
        powerConsumption = 80, cost = 15000, buildTime = 45, ecoBonus = 20
    },
    ["Water Purifier"] = {
        id = 33, category = "Maintenance", emoji = "💧", description = "Cleans polluted water",
        powerConsumption = 60, cost = 12000, buildTime = 40, ecoBonus = 15
    },
    ["Fire Suppression"] = {
        id = 34, category = "Maintenance", emoji = "🚒", description = "Prevents factory fires",
        powerConsumption = 20, cost = 8000, buildTime = 30
    },
    ["Security Drone"] = {
        id = 35, category = "Maintenance", emoji = "🛡️", description = "Stops sabotage in public plots",
        powerConsumption = 40, cost = 20000, buildTime = 50, prestigeRequired = 2
    },
    ["Eco Monitor"] = {
        id = 36, category = "Maintenance", emoji = "📊", description = "Shows live Eco Score",
        powerConsumption = 10, cost = 3000, buildTime = 15
    }
}

-- 🏆 UTILITY & BONUS MACHINES
local utilityMachines = {
    ["Prestige Monument"] = {
        id = 37, category = "Utility", emoji = "🏆", description = "Unlocks next prestige level",
        powerConsumption = 0, cost = 100000, buildTime = 300
    },
    ["Research Lab"] = {
        id = 38, category = "Utility", emoji = "🔬", description = "Unlocks technology upgrades",
        powerConsumption = 200, cost = 50000, buildTime = 120, prestigeRequired = 1
    },
    ["Global Event Terminal"] = {
        id = 39, category = "Utility", emoji = "🌍", description = "Admin-only event control",
        powerConsumption = 100, cost = 0, buildTime = 60, adminOnly = true
    },
    ["Public Showcase Terminal"] = {
        id = 40, category = "Utility", emoji = "📺", description = "Makes island publicly viewable",
        powerConsumption = 25, cost = 10000, buildTime = 40
    },
    ["Eco Garden"] = {
        id = 41, category = "Utility", emoji = "🌱", description = "Boosts Eco Score naturally",
        powerConsumption = 0, cost = 5000, buildTime = 30, ecoBonus = 25
    },
    ["Battery Detector"] = {
        id = 42, category = "Utility", emoji = "🔋", description = "Alerts on power issues",
        powerConsumption = 5, cost = 2500, buildTime = 20
    },
    ["Backup Generator"] = {
        id = 43, category = "Utility", emoji = "⚡", description = "Emergency power backup",
        powerConsumption = 0, powerOutput = 200, cost = 15000, buildTime = 50
    },
    ["Advertisement Board"] = {
        id = 44, category = "Utility", emoji = "📢", description = "Boosts plot visitor count",
        powerConsumption = 15, cost = 8000, buildTime = 35
    },
    ["Blueprint Terminal"] = {
        id = 45, category = "Utility", emoji = "📋", description = "Saves/loads factory blueprints",
        powerConsumption = 50, cost = 25000, buildTime = 60, prestigeRequired = 2
    }
}

-- Merge all machine categories
for name, data in pairs(logisticsMachines) do
    MachineSystem.Machines[name] = data
end
for name, data in pairs(maintenanceMachines) do
    MachineSystem.Machines[name] = data
end
for name, data in pairs(utilityMachines) do
    MachineSystem.Machines[name] = data
end

-- 🔗 PRODUCTION CHAINS
MachineSystem.ProductionChains = {
    ["Basic Electronics"] = {
        chain = {"Ore Miner", "Smelter", "Electronics Fab"},
        flow = "Iron Ore → Iron Ingot → Circuit",
        description = "Basic electronic component production"
    },
    
    ["Advanced Manufacturing"] = {
        chain = {"Ore Miner", "Smelter", "Alloy Furnace", "Assembler"},
        flow = "Iron Ore → Iron Ingot → Steel → Advanced Component",
        description = "High-tech manufacturing chain"
    },
    
    ["Petrochemical"] = {
        chain = {"Oil Pump", "Refinery", "Chem Plant"},
        flow = "Crude Oil → Fuel + Plastic → Chemicals",
        description = "Chemical and plastic production"
    },
    
    ["Energy Production"] = {
        chain = {"Coal Generator", "Solar Panel", "Fusion Reactor"},
        flow = "Coal → Solar → Fusion Power",
        description = "Power generation evolution"
    },
    
    ["Quantum Manufacturing"] = {
        chain = {"Quantum Smelter", "Nanofabricator", "3D Printer"},
        flow = "Perfect Ingots → Nanocomponents → Custom Parts",
        description = "Late-game precision manufacturing"
    }
}

-- 🎯 MACHINE SYSTEM FUNCTIONS
function MachineSystem:GetMachine(machineName)
    return MachineSystem.Machines[machineName]
end

function MachineSystem:GetMachinesByCategory(category)
    local machines = {}
    for name, data in pairs(MachineSystem.Machines) do
        if data.category == category then
            machines[name] = data
        end
    end
    return machines
end

function MachineSystem:GetProductionChain(chainName)
    return MachineSystem.ProductionChains[chainName]
end

function MachineSystem:CanPlayerBuild(player, machineName)
    local machine = MachineSystem.Machines[machineName]
    if not machine then return false, "Machine not found" end
    
    -- Check prestige requirement
    local playerPrestige = MachineSystem:GetPlayerPrestige(player)
    if machine.prestigeRequired and playerPrestige < machine.prestigeRequired then
        return false, "Prestige " .. machine.prestigeRequired .. " required"
    end
    
    -- Check admin-only
    if machine.adminOnly then
        local AdminSystem = require(game.ServerStorage.AdminSystem)
        if not AdminSystem:IsAdmin(player) then
            return false, "Admin-only machine"
        end
    end
    
    -- Check gamepass requirements (for Sandbox+)
    if machine.gamepassRequired then
        local SandboxPlus = require(game.ServerStorage.SandboxPlusSystem)
        if not SandboxPlus:HasGamepass(player) then
            return false, "Sandbox+ gamepass required"
        end
    end
    
    return true, "Can build"
end

function MachineSystem:GetPlayerPrestige(player)
    -- Get player's prestige level from leaderstats or data
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Prestige") then
        return leaderstats.Prestige.Value
    end
    return 0
end

function MachineSystem:GetBuildCost(machineName, playerPrestige)
    local machine = MachineSystem.Machines[machineName]
    if not machine then return 0 end
    
    -- Apply prestige discounts
    local cost = machine.cost
    if playerPrestige > 0 then
        cost = cost * (1 - (playerPrestige * 0.1)) -- 10% discount per prestige
    end
    
    return math.floor(cost)
end

function MachineSystem:GetMachineEfficiency(machineName, biome, ecoScore)
    local machine = MachineSystem.Machines[machineName]
    if not machine then return 1 end
    
    local efficiency = 1.0
    
    -- Biome effects
    if biome == "Volcano" and machine.category == "Power Generation" then
        efficiency = efficiency * 1.3
    elseif biome == "Forest" and machine.category == "Production" then
        efficiency = efficiency * 1.1
    elseif biome == "Desert" and machine.powerConsumption > 100 then
        efficiency = efficiency * 0.9 -- Hot climate penalty
    end
    
    -- Eco score bonus
    if ecoScore > 75 then
        efficiency = efficiency * 1.2
    elseif ecoScore > 50 then
        efficiency = efficiency * 1.1
    elseif ecoScore < 25 then
        efficiency = efficiency * 0.8
    end
    
    return efficiency
end

-- 🔥 MACHINE SPAWNING SYSTEM
function MachineSystem:SpawnMachine(machineName, position, owner)
    local machine = MachineSystem.Machines[machineName]
    if not machine then return nil end
    
    -- Create machine part
    local machinePart = Instance.new("Part")
    machinePart.Name = machineName
    machinePart.Size = Vector3.new(8, 6, 8)
    machinePart.Position = position
    machinePart.Material = Enum.Material.Metal
    machinePart.Color = MachineSystem:GetMachineColor(machine.category)
    machinePart.CanCollide = true
    machinePart.Anchored = true
    
    -- Add machine data
    local machineData = Instance.new("ObjectValue")
    machineData.Name = "MachineData"
    machineData.Parent = machinePart
    
    -- Store machine info
    local machineInfo = Instance.new("StringValue")
    machineInfo.Name = "MachineType"
    machineInfo.Value = machineName
    machineInfo.Parent = machinePart
    
    local ownerInfo = Instance.new("StringValue")
    ownerInfo.Name = "Owner"
    ownerInfo.Value = owner.Name
    ownerInfo.Parent = machinePart
    
    -- Power values
    local powerOutput = Instance.new("IntValue")
    powerOutput.Name = "PowerOutput"
    powerOutput.Value = machine.powerOutput or 0
    powerOutput.Parent = machinePart
    
    local powerConsumption = Instance.new("IntValue")
    powerConsumption.Name = "PowerConsumption"
    powerConsumption.Value = machine.powerConsumption or 0
    powerConsumption.Parent = machinePart
    
    -- Production status
    local isActive = Instance.new("BoolValue")
    isActive.Name = "IsActive"
    isActive.Value = true
    isActive.Parent = machinePart
    
    local health = Instance.new("IntValue")
    health.Name = "Health"
    health.Value = 100
    health.Parent = machinePart
    
    -- Add visual effects
    MachineSystem:AddMachineEffects(machinePart, machine)
    
    machinePart.Parent = workspace
    return machinePart
end

function MachineSystem:GetMachineColor(category)
    local colors = {
        ["Power Generation"] = Color3.fromRGB(255, 200, 50),
        ["Production"] = Color3.fromRGB(100, 150, 255),
        ["Logistics"] = Color3.fromRGB(50, 255, 150),
        ["Maintenance"] = Color3.fromRGB(255, 100, 100),
        ["Utility"] = Color3.fromRGB(200, 100, 255)
    }
    return colors[category] or Color3.fromRGB(128, 128, 128)
end

function MachineSystem:AddMachineEffects(machinePart, machine)
    -- Add emoji display
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.Parent = machinePart
    
    local emojiLabel = Instance.new("TextLabel")
    emojiLabel.Size = UDim2.new(1, 0, 1, 0)
    emojiLabel.BackgroundTransparency = 1
    emojiLabel.Text = machine.emoji
    emojiLabel.TextScaled = true
    emojiLabel.Font = Enum.Font.GothamBold
    emojiLabel.Parent = billboard
    
    -- Add particle effects for certain machines
    if machine.category == "Power Generation" then
        local attachment = Instance.new("Attachment")
        attachment.Position = Vector3.new(0, 3, 0)
        attachment.Parent = machinePart
        
        local particles = Instance.new("ParticleEmitter")
        particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
        particles.Rate = 50
        particles.Lifetime = NumberRange.new(2, 4)
        particles.Color = ColorSequence.new(Color3.fromRGB(255, 200, 100))
        particles.Parent = attachment
    end
end

return MachineSystem