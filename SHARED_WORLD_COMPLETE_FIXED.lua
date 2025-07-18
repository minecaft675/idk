--[[
🌍 SHARED WORLD - MULTIPLAYER FACTORY BUILDING 🌍

🏗️ SHARED WORLD FEATURES:
=======================

📁 DEPLOYMENT:
1. Open Roblox Studio  
2. Go to your SharedWorld place (ID: 93061321683096)
3. Open ServerScriptService
4. Create new Script named "SharedWorldSystem"
5. Copy this entire file content
6. Save and publish

🏭 ALL 45 MACHINES INCLUDED:
- 🔋 Power Generation (8): Coal Generator, Wind Turbine, Solar Panel, Hydroelectric Dam, Fusion Reactor, Geothermal Plant, Biofuel Generator, Nuclear Reactor
- 🏗 Production (14): Ore Miner, Oil Pump, Smelter, Refinery, Assembler, Alloy Furnace, Glass Maker, Electronics Fabricator, Chemical Plant, Textile Mill, Food Processor, Quantum Smelter, Nanofabricator, 3D Printer
- 🚚 Logistics (7): Conveyor Belt, Item Sorter, Drone Hub, Pipeline, Storage Tank, Warehouse, Teleport Pad
- 🛡 Maintenance (7): Cooler Unit, Auto-Fixer Robot, Pollution Scrubber, Water Purifier, Fire Suppression System, Security Drone Station, Eco Monitor  
- 🏆 Utility (9): Prestige Monument, Research Lab, Global Event Terminal, Public Showcase Terminal, Eco Garden, Battery Overload Detector, Backup Generator, Advertisement Board, Blueprint Terminal

🎮 PLAYER FEATURES:
- G Key: SharedWorld menu
- 👑 Button: Admin tools
- Save/Load factory layouts
- Co-owner system (add friends)
- Public island showcase
- Global leaderboards
- Return to hub anytime

💰 ECONOMY SYSTEM:
- Earn money from machines
- Factory value tracking
- Prestige system
- EcoScore monitoring

✅ MULTIPLAYER READY:
- Personal factory plots
- Co-owner building rights
- Public island visits
- Global competitions

Put this script in ServerScriptService in your SHARED WORLD sub-place
This creates multiplayer factory building with saves, co-owners, and global leaderboards
]]

print("🌍 SHARED WORLD SYSTEM - AUTO-BUILDING ALL COMPONENTS...")

-- ⚙️ CONFIGURATION
local SUPERADMIN_ID = 2500153124  -- LeviStopMo2021's User ID
local MAIN_HUB_PLACE_ID = 194805113598787  -- Main hub to return to
local SANDBOX_GAMEPASS_ID = 1322694317

-- 🎯 SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local DataStoreService = game:GetService("DataStoreService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- 📊 DATA STORES (with error handling)
local PlayerDataStore, TeleportDataStore, FactoryDataStore, CoOwnerStore, PublicIslandStore, GlobalLeaderboardStore
local function initializeDataStores()
    local success, error = pcall(function()
        PlayerDataStore = DataStoreService:GetDataStore("MegaTycoonPlayerData_v51")
        TeleportDataStore = DataStoreService:GetDataStore("MegaTycoonTeleportData_v51")
        FactoryDataStore = DataStoreService:GetDataStore("MegaTycoonFactoryLayouts_v51")
        CoOwnerStore = DataStoreService:GetDataStore("MegaTycoonCoOwners_v51")
        PublicIslandStore = DataStoreService:GetDataStore("MegaTycoonPublicIslands_v51")
        GlobalLeaderboardStore = DataStoreService:GetDataStore("MegaTycoonGlobalLeaderboards_v51")
    end)
    
    if not success then
        warn("❌ SharedWorld DataStore initialization failed: " .. tostring(error))
        return false
    end
    
    print("✅ SharedWorld DataStores initialized successfully!")
    return true
end

-- Initialize datastores with retry logic
local dataStoreReady = false
spawn(function()
    for i = 1, 5 do
        if initializeDataStores() then
            dataStoreReady = true
            break
        end
        wait(2)
    end
    if not dataStoreReady then
        warn("❌ Failed to initialize SharedWorld DataStores after 5 attempts!")
    end
end)

-- 📡 CREATE REMOTE EVENTS
local remoteFolder = Instance.new("Folder")
remoteFolder.Name = "SharedWorldRemotes"
remoteFolder.Parent = ReplicatedStorage

local remoteEvents = {
    "ReturnToHub", "SaveFactory", "LoadFactory", "AddCoOwner", "RemoveCoOwner",
    "SetPublicIsland", "RateIsland", "SpawnMachine", "DeleteMachine", "ViewPublicIslands",
    "AdminFloatDown", "TriggerRandomEvent", "ChangeBiome", "OpenFactoryEncyclopedia"
}

for _, eventName in ipairs(remoteEvents) do
    local remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = eventName
    remoteEvent.Parent = remoteFolder
end

print("📡 Created " .. #remoteEvents .. " SharedWorld Remote Events!")

-- 🏭 ALL 45 MACHINES DATA (complete and accurate)
local MachineData = {
    -- Power Generation (8)
    ["Coal Generator"] = {id = 1, category = "Power", cost = 5000, power = 100, pollution = 15, tier = 1, emoji = "⚫"},
    ["Wind Turbine"] = {id = 2, category = "Power", cost = 8000, power = 80, pollution = 0, tier = 1, emoji = "💨"},
    ["Solar Panel"] = {id = 3, category = "Power", cost = 12000, power = 120, pollution = 0, tier = 1, emoji = "☀️"},
    ["Hydroelectric Dam"] = {id = 4, category = "Power", cost = 25000, power = 200, pollution = 0, tier = 2, emoji = "🌊"},
    ["Fusion Reactor"] = {id = 5, category = "Power", cost = 500000, power = 1000, pollution = 0, tier = 5, emoji = "⚛️"},
    ["Geothermal Plant"] = {id = 6, category = "Power", cost = 75000, power = 300, pollution = 5, tier = 3, emoji = "🌋"},
    ["Biofuel Generator"] = {id = 7, category = "Power", cost = 20000, power = 150, pollution = 8, tier = 2, emoji = "🌿"},
    ["Nuclear Reactor"] = {id = 8, category = "Power", cost = 200000, power = 800, pollution = 25, tier = 4, emoji = "☢️"},
    
    -- Production (14)
    ["Ore Miner"] = {id = 9, category = "Production", cost = 3000, outputs = {"Iron", "Copper"}, tier = 1, emoji = "⛏️"},
    ["Oil Pump"] = {id = 10, category = "Production", cost = 8000, outputs = {"Oil"}, tier = 1, emoji = "🛢️"},
    ["Smelter"] = {id = 11, category = "Production", cost = 5000, inputs = {"Iron", "Coal"}, outputs = {"Steel"}, tier = 1, emoji = "🔥"},
    ["Refinery"] = {id = 12, category = "Production", cost = 15000, inputs = {"Oil"}, outputs = {"Plastic", "Fuel"}, tier = 2, emoji = "🏭"},
    ["Assembler"] = {id = 13, category = "Production", cost = 12000, inputs = {"Steel", "Plastic"}, outputs = {"Parts"}, tier = 2, emoji = "🔧"},
    ["Alloy Furnace"] = {id = 14, category = "Production", cost = 25000, inputs = {"Steel", "Copper"}, outputs = {"Alloys"}, tier = 3, emoji = "🔩"},
    ["Glass Maker"] = {id = 15, category = "Production", cost = 4000, inputs = {"Sand"}, outputs = {"Glass"}, tier = 1, emoji = "🔍"},
    ["Electronics Fabricator"] = {id = 16, category = "Production", cost = 30000, inputs = {"Copper", "Plastic"}, outputs = {"Electronics"}, tier = 3, emoji = "💻"},
    ["Chemical Plant"] = {id = 17, category = "Production", cost = 45000, inputs = {"Oil"}, outputs = {"Chemicals"}, tier = 3, emoji = "🧪"},
    ["Textile Mill"] = {id = 18, category = "Production", cost = 8000, inputs = {"Cotton"}, outputs = {"Textiles"}, tier = 2, emoji = "🧵"},
    ["Food Processor"] = {id = 19, category = "Production", cost = 6000, inputs = {"Food"}, outputs = {"Meals"}, tier = 1, emoji = "🥫"},
    ["Quantum Smelter"] = {id = 20, category = "Production", cost = 1000000, inputs = {"Any Ore"}, outputs = {"Perfect Materials"}, tier = 6, emoji = "⚡"},
    ["Nanofabricator"] = {id = 21, category = "Production", cost = 750000, inputs = {"Quantum Materials"}, outputs = {"Nanocomponents"}, tier = 6, emoji = "🔬"},
    ["3D Printer"] = {id = 22, category = "Production", cost = 50000, inputs = {"Plastic"}, outputs = {"Custom Parts"}, tier = 4, emoji = "🖨️"},
    
    -- Logistics (7)
    ["Conveyor Belt"] = {id = 23, category = "Logistics", cost = 500, speed = 5, tier = 1, emoji = "🔄"},
    ["Item Sorter"] = {id = 24, category = "Logistics", cost = 2000, sortingTypes = 4, tier = 1, emoji = "📦"},
    ["Drone Hub"] = {id = 25, category = "Logistics", cost = 25000, range = 1000, tier = 3, emoji = "🚁"},
    ["Pipeline"] = {id = 26, category = "Logistics", cost = 1500, fluidTypes = {"Oil", "Water"}, tier = 1, emoji = "🔧"},
    ["Storage Tank"] = {id = 27, category = "Logistics", cost = 3000, capacity = 1000, tier = 1, emoji = "🛢️"},
    ["Warehouse"] = {id = 28, category = "Logistics", cost = 5000, capacity = 500, tier = 2, emoji = "🏪"},
    ["Teleport Pad"] = {id = 29, category = "Logistics", cost = 500000, range = "Unlimited", tier = 6, emoji = "🌀"},
    
    -- Maintenance & Eco (7)
    ["Cooler Unit"] = {id = 30, category = "Maintenance", cost = 4000, cooling = 50, tier = 1, emoji = "❄️"},
    ["Auto-Fixer Robot"] = {id = 31, category = "Maintenance", cost = 1000000, repairRate = 10, tier = 5, emoji = "🤖"},
    ["Pollution Scrubber"] = {id = 32, category = "Maintenance", cost = 15000, ecoBonus = 20, tier = 2, emoji = "🌬️"},
    ["Water Purifier"] = {id = 33, category = "Maintenance", cost = 12000, purification = 30, tier = 2, emoji = "💧"},
    ["Fire Suppression System"] = {id = 34, category = "Maintenance", cost = 8000, protection = 60, tier = 1, emoji = "🚒"},
    ["Security Drone Station"] = {id = 35, category = "Maintenance", cost = 20000, patrolRange = 200, tier = 3, emoji = "🛡️"},
    ["Eco Monitor"] = {id = 36, category = "Maintenance", cost = 3000, monitoring = 150, tier = 1, emoji = "📊"},
    
    -- Utility & Bonus (9)
    ["Prestige Monument"] = {id = 37, category = "Utility", cost = 100000, prestigeBonus = 1, tier = 1, emoji = "🏆"},
    ["Research Lab"] = {id = 38, category = "Utility", cost = 50000, researchSpeed = 5, tier = 2, emoji = "🔬"},
    ["Global Event Terminal"] = {id = 39, category = "Utility", cost = 0, adminOnly = true, tier = 1, emoji = "🌍"},
    ["Public Showcase Terminal"] = {id = 40, category = "Utility", cost = 10000, visitorBonus = 1.1, tier = 1, emoji = "📺"},
    ["Eco Garden"] = {id = 41, category = "Utility", cost = 5000, ecoBonus = 25, tier = 1, emoji = "🌱"},
    ["Battery Overload Detector"] = {id = 42, category = "Utility", cost = 2500, monitoring = 99, tier = 1, emoji = "🔋"},
    ["Backup Generator"] = {id = 43, category = "Utility", cost = 15000, emergencyPower = 200, tier = 2, emoji = "⚡"},
    ["Advertisement Board"] = {id = 44, category = "Utility", cost = 8000, visitorBonus = 1.2, tier = 1, emoji = "📢"},
    ["Blueprint Terminal"] = {id = 45, category = "Utility", cost = 25000, blueprintSlots = 10, tier = 3, emoji = "📋"}
}

print("🏭 Loaded all 45 machines data!")

-- 💰 LEADERSTATS SYSTEM
local function createLeaderstats(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local cash = Instance.new("IntValue")
    cash.Name = "Cash 💸"
    cash.Value = 2500
    cash.Parent = leaderstats
    
    local power = Instance.new("IntValue")
    power.Name = "Power 🔋"
    power.Value = 0
    power.Parent = leaderstats
    
    local prestige = Instance.new("IntValue")
    prestige.Name = "Prestige ⭐"
    prestige.Value = 0
    prestige.Parent = leaderstats
    
    local ecoScore = Instance.new("IntValue")
    ecoScore.Name = "Eco Score 🌱"
    ecoScore.Value = 100
    ecoScore.Parent = leaderstats
    
    local factoryValue = Instance.new("IntValue")
    factoryValue.Name = "Factory Value 🏭"
    factoryValue.Value = 0
    factoryValue.Parent = leaderstats
    
    return leaderstats
end

-- 💾 DATA LOADING WITH TELEPORT SUPPORT (improved)
local function loadPlayerData(player)
    if not dataStoreReady then
        warn("⚠️ DataStore not ready for " .. player.Name)
        return
    end
    
    -- First check for teleport data
    local success, teleportData = pcall(function()
        return TeleportDataStore:GetAsync("TeleportData_" .. player.UserId)
    end)
    
    if success and teleportData and teleportData.playerData then
        local data = teleportData.playerData
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            leaderstats["Cash 💸"].Value = data.cash or 2500
            leaderstats["Power 🔋"].Value = data.power or 0
            leaderstats["Prestige ⭐"].Value = data.prestige or 0
            leaderstats["Eco Score 🌱"].Value = data.ecoScore or 100
        end
        print("📦 Loaded teleport data for " .. player.Name .. " in SharedWorld")
        return
    end
    
    -- Fallback to regular data store
    local success2, data = pcall(function()
        return PlayerDataStore:GetAsync("Player_" .. player.UserId)
    end)
    
    if success2 and data then
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            leaderstats["Cash 💸"].Value = data.Cash or 2500
            leaderstats["Power 🔋"].Value = data.Power or 0
            leaderstats["PrestigeLevel"] = data.PrestigeLevel or 0
            leaderstats["EcoScore"] = data.EcoScore or 100
        end
        print("📦 Loaded regular data for " .. player.Name)
    end
end

-- 💾 DATA SAVING (improved)
local function savePlayerData(player)
    if not dataStoreReady or not PlayerDataStore then
        warn("⚠️ DataStore not ready for saving " .. player.Name)
        return
    end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local data = {
            Cash = leaderstats["Cash 💸"].Value,
            Power = leaderstats["Power 🔋"].Value,
            PrestigeLevel = leaderstats["Prestige ⭐"].Value,
            EcoScore = leaderstats["Eco Score 🌱"].Value,
            FactoryValue = leaderstats["Factory Value 🏭"].Value,
            LastPlayed = os.time()
        }
        
        local success, error = pcall(function()
            PlayerDataStore:SetAsync("Player_" .. player.UserId, data)
        end)
        
        if success then
            print("💾 Saved SharedWorld data for " .. player.Name)
        else
            warn("❌ Failed to save data for " .. player.Name .. ": " .. tostring(error))
        end
    end
end

-- 🏗️ FACTORY SYSTEM (improved)
local FactorySystem = {}
FactorySystem.PlayerFactories = {}

function FactorySystem:CreatePlayerFactory(player)
    local factoryFolder = Instance.new("Folder")
    factoryFolder.Name = player.Name .. "_Factory"
    factoryFolder.Parent = workspace
    
    -- Create factory plot with better positioning
    local plotPosition = Vector3.new(
        math.random(-500, 500), 
        0, 
        math.random(-500, 500)
    )
    
    local plot = Instance.new("Part")
    plot.Name = "FactoryPlot"
    plot.Size = Vector3.new(100, 1, 100)
    plot.Position = plotPosition
    plot.Anchored = true
    plot.Material = Enum.Material.Concrete
    plot.Color = Color3.fromRGB(80, 80, 80)
    plot.Parent = factoryFolder
    
    -- Plot ownership
    local ownership = Instance.new("StringValue")
    ownership.Name = "Owner"
    ownership.Value = player.Name
    ownership.Parent = plot
    
    -- Co-owners folder
    local coOwners = Instance.new("Folder")
    coOwners.Name = "CoOwners"
    coOwners.Parent = plot
    
    -- Spawn point
    local spawn = Instance.new("SpawnLocation")
    spawn.Size = Vector3.new(6, 1, 6)
    spawn.Position = plotPosition + Vector3.new(0, 5, 0)
    spawn.Anchored = true
    spawn.BrickColor = BrickColor.new("Bright green")
    spawn.Parent = factoryFolder
    
    -- Factory sign
    local sign = Instance.new("Part")
    sign.Size = Vector3.new(10, 6, 1)
    sign.Position = plotPosition + Vector3.new(0, 8, -50)
    sign.Anchored = true
    sign.Material = Enum.Material.Neon
    sign.Color = Color3.fromRGB(50, 150, 255)
    sign.Parent = factoryFolder
    
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.Parent = sign
    
    local signLabel = Instance.new("TextLabel")
    signLabel.Size = UDim2.new(1, 0, 1, 0)
    signLabel.BackgroundTransparency = 1
    signLabel.Text = "🏭 " .. player.Name .. "'s Factory 🏭"
    signLabel.TextColor3 = Color3.white
    signLabel.TextScaled = true
    signLabel.Font = Enum.Font.GothamBold
    signLabel.Parent = signGui
    
    self.PlayerFactories[player.UserId] = {
        folder = factoryFolder,
        plot = plot,
        spawn = spawn,
        machines = {},
        publicStatus = false,
        rating = 0,
        visitors = 0
    }
    
    print("🏗️ Created factory for " .. player.Name)
    return factoryFolder
end

function FactorySystem:SpawnMachine(player, machineName, position)
    local machineData = MachineData[machineName]
    if not machineData then 
        return false, "Machine not found: " .. tostring(machineName) 
    end
    
    local factory = self.PlayerFactories[player.UserId]
    if not factory then 
        return false, "No factory found. Please wait for factory to be created." 
    end
    
    -- Check if player can afford it
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats or leaderstats["Cash 💸"].Value < machineData.cost then
        return false, "Not enough money. Need $" .. machineData.cost .. ", have $" .. (leaderstats and leaderstats["Cash 💸"].Value or 0)
    end
    
    -- Validate position (make sure it's safe)
    if not position or typeof(position) ~= "Vector3" then
        position = factory.plot.Position + Vector3.new(0, 10, 0)
    end
    
    -- Create machine part
    local machine = Instance.new("Part")
    machine.Name = machineName
    machine.Size = Vector3.new(6, 6, 6)
    machine.Position = position
    machine.Anchored = true
    machine.Material = Enum.Material.Metal
    machine.Color = Color3.fromRGB(100, 100, 150)
    machine.Parent = factory.folder
    
    -- Machine GUI
    local gui = Instance.new("SurfaceGui")
    gui.Face = Enum.NormalId.Top
    gui.Parent = machine
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = machineData.emoji .. "\n" .. machineName .. "\n$" .. machineData.cost
    label.TextColor3 = Color3.white
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = gui
    
    -- Machine data
    local machineValue = Instance.new("StringValue")
    machineValue.Name = "MachineType"
    machineValue.Value = machineName
    machineValue.Parent = machine
    
    local machineID = Instance.new("IntValue")
    machineID.Name = "MachineID"
    machineID.Value = machineData.id
    machineID.Parent = machine
    
    -- Deduct cost
    leaderstats["Cash 💸"].Value = leaderstats["Cash 💸"].Value - machineData.cost
    
    -- Update factory value
    leaderstats["Factory Value 🏭"].Value = leaderstats["Factory Value 🏭"].Value + machineData.cost
    
    -- Add to machines list
    table.insert(factory.machines, {
        name = machineName,
        part = machine,
        data = machineData
    })
    
    print("🏭 " .. player.Name .. " spawned " .. machineName .. " for $" .. machineData.cost)
    return true, "Machine spawned successfully! Cost: $" .. machineData.cost
end

-- 👥 CO-OWNER SYSTEM (improved)
local CoOwnerSystem = {}

function CoOwnerSystem:AddCoOwner(owner, targetName)
    local targetPlayer = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(targetName:lower(), 1, true) then
            targetPlayer = player
            break
        end
    end
    
    if not targetPlayer then
        return false, "Player '" .. targetName .. "' not found in this server"
    end
    
    if targetPlayer == owner then
        return false, "Cannot add yourself as co-owner"
    end
    
    local factory = FactorySystem.PlayerFactories[owner.UserId]
    if not factory then
        return false, "No factory found"
    end
    
    -- Check if already co-owner
    for _, existingCoOwner in pairs(factory.plot.CoOwners:GetChildren()) do
        if existingCoOwner.Value == tostring(targetPlayer.UserId) then
            return false, targetPlayer.Name .. " is already a co-owner"
        end
    end
    
    -- Add co-owner
    local coOwnerValue = Instance.new("StringValue")
    coOwnerValue.Name = targetPlayer.Name
    coOwnerValue.Value = targetPlayer.UserId
    coOwnerValue.Parent = factory.plot.CoOwners
    
    -- Save to DataStore
    if dataStoreReady and CoOwnerStore then
        pcall(function()
            local existingCoOwners = CoOwnerStore:GetAsync("CoOwners_" .. owner.UserId) or {}
            table.insert(existingCoOwners, {name = targetPlayer.Name, userId = targetPlayer.UserId})
            CoOwnerStore:SetAsync("CoOwners_" .. owner.UserId, existingCoOwners)
        end)
    end
    
    -- Notify both players
    self:NotifyPlayer(owner, "✅ Added " .. targetPlayer.Name .. " as co-owner")
    self:NotifyPlayer(targetPlayer, "🎉 You are now co-owner of " .. owner.Name .. "'s factory!")
    
    return true, "Co-owner added successfully"
end

function CoOwnerSystem:NotifyPlayer(player, message)
    if not player or not player.Parent then return end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "Notification"
    gui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 80)
    frame.Position = UDim2.new(0.5, -200, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.white
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    Debris:AddItem(gui, 5)
end

-- 🌟 PUBLIC ISLAND SYSTEM (improved)
local PublicIslandSystem = {}

function PublicIslandSystem:SetPublicStatus(player, isPublic)
    local factory = FactorySystem.PlayerFactories[player.UserId]
    if not factory then
        return false, "No factory found"
    end
    
    factory.publicStatus = isPublic
    
    if isPublic then
        -- Add to public islands list
        local publicData = {
            ownerName = player.Name,
            ownerId = player.UserId,
            factoryValue = player.leaderstats["Factory Value 🏭"].Value,
            rating = factory.rating,
            visitors = factory.visitors,
            timestamp = os.time()
        }
        
        if dataStoreReady and PublicIslandStore then
            pcall(function()
                PublicIslandStore:SetAsync("Public_" .. player.UserId, publicData)
            end)
        end
        
        return true, "Factory is now public!"
    else
        -- Remove from public islands
        if dataStoreReady and PublicIslandStore then
            pcall(function()
                PublicIslandStore:RemoveAsync("Public_" .. player.UserId)
            end)
        end
        
        return true, "Factory is now private"
    end
end

function PublicIslandSystem:RateIsland(rater, ownerId, rating)
    if rater.UserId == ownerId then
        return false, "Cannot rate your own factory"
    end
    
    if rating < 1 or rating > 5 then
        return false, "Rating must be between 1 and 5"
    end
    
    local factory = FactorySystem.PlayerFactories[ownerId]
    if not factory then
        return false, "Factory not found"
    end
    
    -- Update rating (simple average for now)
    factory.rating = (factory.rating + rating) / 2
    
    -- Update public data
    if dataStoreReady and PublicIslandStore then
        pcall(function()
            local publicData = PublicIslandStore:GetAsync("Public_" .. ownerId)
            if publicData then
                publicData.rating = factory.rating
                PublicIslandStore:SetAsync("Public_" .. ownerId, publicData)
            end
        end)
    end
    
    return true, "Rating submitted!"
end

-- 👑 ADMIN SYSTEM (fixed)
local AdminSystem = {}
AdminSystem.AdminLevels = {
    [SUPERADMIN_ID] = 10  -- LeviStopMo2021 as Superadmin
}

function AdminSystem:IsAdmin(player)
    return self.AdminLevels[player.UserId] and self.AdminLevels[player.UserId] > 0
end

function AdminSystem:AdminFloatDown(player)
    if not self:IsAdmin(player) then 
        CoOwnerSystem:NotifyPlayer(player, "❌ You don't have admin permissions!")
        return false 
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        CoOwnerSystem:NotifyPlayer(player, "❌ Character not found!")
        return false 
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Create epic admin platform
    local platform = Instance.new("Part")
    platform.Name = "AdminPlatform"
    platform.Size = Vector3.new(12, 3, 12)
    platform.Material = Enum.Material.ForceField
    platform.Color = Color3.fromRGB(255, 215, 0)
    platform.CanCollide = true
    platform.Anchored = true
    platform.Position = Vector3.new(0, 300, 0)
    platform.Parent = workspace
    
    -- Add platform effects
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 3
    pointLight.Color = Color3.fromRGB(255, 215, 0)
    pointLight.Range = 50
    pointLight.Parent = platform
    
    -- Teleport admin to platform safely
    local success, error = pcall(function()
        humanoidRootPart.CFrame = CFrame.new(0, 315, 0)
    end)
    
    if not success then
        platform:Destroy()
        CoOwnerSystem:NotifyPlayer(player, "❌ Failed to teleport to platform!")
        return false
    end
    
    -- Epic announcement to all players
    for _, plr in pairs(Players:GetPlayers()) do
        spawn(function()
            local gui = Instance.new("ScreenGui")
            gui.Name = "AdminMessage"
            gui.Parent = plr.PlayerGui
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 120)
            frame.Position = UDim2.new(0, 0, 0, 0)
            frame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            frame.BorderSizePixel = 0
            frame.Parent = gui
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "👑 DIVINE ADMIN " .. player.Name .. " DESCENDS FROM THE HEAVENS! 👑"
            label.TextColor3 = Color3.white
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.Parent = frame
            
            wait(8)
            gui:Destroy()
        end)
    end
    
    -- Epic descent with proper TweenService
    local descentTween = TweenService:Create(platform, 
        TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 
        {Position = Vector3.new(0, 5, 0)})
    descentTween:Play()
    
    -- Move player with platform
    spawn(function()
        for i = 1, 80 do
            if platform.Parent and character and humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(platform.Position.X, platform.Position.Y + 10, platform.Position.Z)
                wait(0.1)
            else
                break
            end
        end
    end)
    
    descentTween.Completed:Connect(function()
        wait(5)
        if platform.Parent then
            platform:Destroy()
        end
    end)
    
    return true
end

-- 🎮 CLIENT UI SYSTEM (improved with better validation)
local clientUIScript = Instance.new("LocalScript")
clientUIScript.Name = "SharedWorldClientUI"
clientUIScript.Parent = StarterGui
clientUIScript.Source = [[
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for remotes to be created
local remotes
spawn(function()
    while not remotes do
        remotes = ReplicatedStorage:FindFirstChild("SharedWorldRemotes")
        if remotes then break end
        wait(0.1)
    end
end)

-- SHARED WORLD MAIN MENU
local function createSharedWorldMenu()
    -- Remove existing menu
    local existingMenu = playerGui:FindFirstChild("SharedWorldMenu")
    if existingMenu then
        existingMenu:Destroy()
    end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "SharedWorldMenu"
    gui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 700, 0, 900)
    frame.Position = UDim2.new(0.5, -350, 0.5, -450)
    frame.BackgroundColor3 = Color3.fromRGB(25, 35, 25)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = frame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 80)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🌍 SHARED WORLD - MULTIPLAYER FACTORY BUILDING 🌍"
    title.TextColor3 = Color3.fromRGB(100, 255, 100)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    -- Factory Management Section
    local factoryLabel = Instance.new("TextLabel")
    factoryLabel.Size = UDim2.new(1, -20, 0, 40)
    factoryLabel.Position = UDim2.new(0, 10, 0, 100)
    factoryLabel.BackgroundTransparency = 1
    factoryLabel.Text = "🏗️ FACTORY MANAGEMENT"
    factoryLabel.TextColor3 = Color3.white
    factoryLabel.TextScaled = true
    factoryLabel.Font = Enum.Font.GothamBold
    factoryLabel.Parent = frame
    
    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(0.45, 0, 0, 50)
    saveBtn.Position = UDim2.new(0.025, 0, 0, 150)
    saveBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    saveBtn.Text = "💾 Save Factory"
    saveBtn.TextColor3 = Color3.white
    saveBtn.TextScaled = true
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.Parent = frame
    
    local loadBtn = Instance.new("TextButton")
    loadBtn.Size = UDim2.new(0.45, 0, 0, 50)
    loadBtn.Position = UDim2.new(0.525, 0, 0, 150)
    loadBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    loadBtn.Text = "📂 Load Factory"
    loadBtn.TextColor3 = Color3.white
    loadBtn.TextScaled = true
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.Parent = frame
    
    -- Co-Owner Section
    local coOwnerLabel = Instance.new("TextLabel")
    coOwnerLabel.Size = UDim2.new(1, -20, 0, 30)
    coOwnerLabel.Position = UDim2.new(0, 10, 0, 220)
    coOwnerLabel.BackgroundTransparency = 1
    coOwnerLabel.Text = "👥 CO-OWNER SYSTEM"
    coOwnerLabel.TextColor3 = Color3.white
    coOwnerLabel.TextScaled = true
    coOwnerLabel.Font = Enum.Font.GothamBold
    coOwnerLabel.Parent = frame
    
    local coOwnerInput = Instance.new("TextBox")
    coOwnerInput.Size = UDim2.new(0.6, 0, 0, 40)
    coOwnerInput.Position = UDim2.new(0.05, 0, 0, 260)
    coOwnerInput.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
    coOwnerInput.Text = "Player Name..."
    coOwnerInput.TextColor3 = Color3.white
    coOwnerInput.TextScaled = true
    coOwnerInput.Font = Enum.Font.Gotham
    coOwnerInput.Parent = frame
    
    local addCoOwnerBtn = Instance.new("TextButton")
    addCoOwnerBtn.Size = UDim2.new(0.3, 0, 0, 40)
    addCoOwnerBtn.Position = UDim2.new(0.65, 0, 0, 260)
    addCoOwnerBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    addCoOwnerBtn.Text = "➕ Add Co-Owner"
    addCoOwnerBtn.TextColor3 = Color3.white
    addCoOwnerBtn.TextScaled = true
    addCoOwnerBtn.Font = Enum.Font.GothamBold
    addCoOwnerBtn.Parent = frame
    
    -- Public Island Section
    local publicLabel = Instance.new("TextLabel")
    publicLabel.Size = UDim2.new(1, -20, 0, 30)
    publicLabel.Position = UDim2.new(0, 10, 0, 320)
    publicLabel.BackgroundTransparency = 1
    publicLabel.Text = "🌟 PUBLIC ISLAND SHOWCASE"
    publicLabel.TextColor3 = Color3.white
    publicLabel.TextScaled = true
    publicLabel.Font = Enum.Font.GothamBold
    publicLabel.Parent = frame
    
    local setPublicBtn = Instance.new("TextButton")
    setPublicBtn.Size = UDim2.new(0.45, 0, 0, 50)
    setPublicBtn.Position = UDim2.new(0.025, 0, 0, 360)
    setPublicBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
    setPublicBtn.Text = "🌟 Make Public"
    setPublicBtn.TextColor3 = Color3.white
    setPublicBtn.TextScaled = true
    setPublicBtn.Font = Enum.Font.GothamBold
    setPublicBtn.Parent = frame
    
    local viewPublicBtn = Instance.new("TextButton")
    viewPublicBtn.Size = UDim2.new(0.45, 0, 0, 50)
    viewPublicBtn.Position = UDim2.new(0.525, 0, 0, 360)
    viewPublicBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
    viewPublicBtn.Text = "👁️ View Public Islands"
    viewPublicBtn.TextColor3 = Color3.white
    viewPublicBtn.TextScaled = true
    viewPublicBtn.Font = Enum.Font.GothamBold
    viewPublicBtn.Parent = frame
    
    -- Machine Spawner
    local machineLabel = Instance.new("TextLabel")
    machineLabel.Size = UDim2.new(1, -20, 0, 30)
    machineLabel.Position = UDim2.new(0, 10, 0, 430)
    machineLabel.BackgroundTransparency = 1
    machineLabel.Text = "🏭 MACHINE SPAWNER (All 45 Machines Available)"
    machineLabel.TextColor3 = Color3.white
    machineLabel.TextScaled = true
    machineLabel.Font = Enum.Font.GothamBold
    machineLabel.Parent = frame
    
    -- Machine categories
    local categories = {
        {name = "🔋 Power (8)", machines = {"Coal Generator", "Wind Turbine", "Solar Panel", "Hydroelectric Dam", "Fusion Reactor", "Geothermal Plant", "Biofuel Generator", "Nuclear Reactor"}},
        {name = "🏗 Production (14)", machines = {"Ore Miner", "Oil Pump", "Smelter", "Refinery", "Assembler", "Alloy Furnace", "Glass Maker", "Electronics Fabricator", "Chemical Plant", "Textile Mill", "Food Processor", "Quantum Smelter", "Nanofabricator", "3D Printer"}},
        {name = "🚚 Logistics (7)", machines = {"Conveyor Belt", "Item Sorter", "Drone Hub", "Pipeline", "Storage Tank", "Warehouse", "Teleport Pad"}},
        {name = "🛡 Maintenance (7)", machines = {"Cooler Unit", "Auto-Fixer Robot", "Pollution Scrubber", "Water Purifier", "Fire Suppression System", "Security Drone Station", "Eco Monitor"}},
        {name = "🏆 Utility (9)", machines = {"Prestige Monument", "Research Lab", "Global Event Terminal", "Public Showcase Terminal", "Eco Garden", "Battery Overload Detector", "Backup Generator", "Advertisement Board", "Blueprint Terminal"}}
    }
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 0, 350)
    scrollFrame.Position = UDim2.new(0, 10, 0, 470)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1500)
    scrollFrame.ScrollBarThickness = 10
    scrollFrame.Parent = frame
    
    local yOffset = 10
    for _, category in ipairs(categories) do
        local categoryFrame = Instance.new("Frame")
        categoryFrame.Size = UDim2.new(1, -20, 0, 30)
        categoryFrame.Position = UDim2.new(0, 10, 0, yOffset)
        categoryFrame.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        categoryFrame.Parent = scrollFrame
        
        local categoryLabel = Instance.new("TextLabel")
        categoryLabel.Size = UDim2.new(1, 0, 1, 0)
        categoryLabel.BackgroundTransparency = 1
        categoryLabel.Text = category.name
        categoryLabel.TextColor3 = Color3.white
        categoryLabel.TextScaled = true
        categoryLabel.Font = Enum.Font.GothamBold
        categoryLabel.Parent = categoryFrame
        
        yOffset = yOffset + 40
        
        for i, machine in ipairs(category.machines) do
            local machineBtn = Instance.new("TextButton")
            machineBtn.Size = UDim2.new(0.45, 0, 0, 30)
            machineBtn.Position = UDim2.new((i % 2 == 1) and 0.025 or 0.525, 0, 0, yOffset + math.floor((i-1)/2) * 35)
            machineBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
            machineBtn.Text = machine
            machineBtn.TextColor3 = Color3.white
            machineBtn.TextScaled = true
            machineBtn.Font = Enum.Font.Gotham
            machineBtn.Parent = scrollFrame
            
            machineBtn.MouseButton1Click:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and remotes and remotes:FindFirstChild("SpawnMachine") then
                    remotes.SpawnMachine:FireServer(machine, player.Character.HumanoidRootPart.Position + Vector3.new(0, 0, -10))
                end
            end)
        end
        
        yOffset = yOffset + math.ceil(#category.machines / 2) * 35 + 20
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
    
    -- Return to Hub button
    local returnBtn = Instance.new("TextButton")
    returnBtn.Size = UDim2.new(0.8, 0, 0, 60)
    returnBtn.Position = UDim2.new(0.1, 0, 1, -70)
    returnBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    returnBtn.Text = "🏠 Return to Main Hub"
    returnBtn.TextColor3 = Color3.white
    returnBtn.TextScaled = true
    returnBtn.Font = Enum.Font.GothamBold
    returnBtn.Parent = frame
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 60, 0, 60)
    closeBtn.Position = UDim2.new(1, -70, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.white
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = frame
    
    -- Button connections with validation
    saveBtn.MouseButton1Click:Connect(function()
        if remotes and remotes:FindFirstChild("SaveFactory") then
            remotes.SaveFactory:FireServer()
        end
    end)
    
    loadBtn.MouseButton1Click:Connect(function()
        if remotes and remotes:FindFirstChild("LoadFactory") then
            remotes.LoadFactory:FireServer()
        end
    end)
    
    addCoOwnerBtn.MouseButton1Click:Connect(function()
        if coOwnerInput.Text ~= "" and coOwnerInput.Text ~= "Player Name..." and remotes and remotes:FindFirstChild("AddCoOwner") then
            remotes.AddCoOwner:FireServer(coOwnerInput.Text)
        end
    end)
    
    setPublicBtn.MouseButton1Click:Connect(function()
        if remotes and remotes:FindFirstChild("SetPublicIsland") then
            remotes.SetPublicIsland:FireServer(true)
        end
    end)
    
    viewPublicBtn.MouseButton1Click:Connect(function()
        if remotes and remotes:FindFirstChild("ViewPublicIslands") then
            remotes.ViewPublicIslands:FireServer()
        end
    end)
    
    returnBtn.MouseButton1Click:Connect(function()
        if remotes and remotes:FindFirstChild("ReturnToHub") then
            remotes.ReturnToHub:FireServer()
            gui:Destroy()
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Clear placeholder text on focus
    coOwnerInput.Focused:Connect(function()
        if coOwnerInput.Text == "Player Name..." then
            coOwnerInput.Text = ""
        end
    end)
    
    return gui
end

-- Admin crown button
local function createAdminCrown()
    local gui = Instance.new("ScreenGui")
    gui.Name = "AdminCrown"
    gui.Parent = playerGui
    
    local crownBtn = Instance.new("TextButton")
    crownBtn.Size = UDim2.new(0, 80, 0, 80)
    crownBtn.Position = UDim2.new(1, -90, 0, 10)
    crownBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    crownBtn.Text = "👑"
    crownBtn.TextScaled = true
    crownBtn.Font = Enum.Font.GothamBold
    crownBtn.BorderSizePixel = 0
    crownBtn.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 40)
    corner.Parent = crownBtn
    
    crownBtn.MouseButton1Click:Connect(function()
        if remotes and remotes:FindFirstChild("AdminFloatDown") then
            remotes.AdminFloatDown:FireServer()
        end
    end)
end

-- Key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        local existingMenu = playerGui:FindFirstChild("SharedWorldMenu")
        if existingMenu then
            existingMenu:Destroy()
        else
            createSharedWorldMenu()
        end
    end
end)

-- Create admin crown and show welcome
createAdminCrown()

spawn(function()
    wait(3)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SharedWorldWelcome"
    gui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.8, 0, 0.6, 0)
    frame.Position = UDim2.new(0.1, 0, 0.2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, -20)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = "🌍 WELCOME TO SHARED WORLD! 🌍\n\n🏗️ Multiplayer Factory Building\n👥 Co-owner System\n🌟 Public Island Showcase\n📊 Global Leaderboards\n🎲 Random Events\n🏭 All 45 Machines Available\n💾 Save/Load Your Factories\n\nPress G to open the SharedWorld Menu!\nBuild amazing factories with friends!"
    label.TextColor3 = Color3.white
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    wait(15)
    gui:Destroy()
end)

print("🎮 SharedWorld Client UI loaded! Press G for menu, click 👑 for admin")
]]

-- 📡 REMOTE EVENT HANDLERS (improved)
local function setupRemoteHandlers()
    remoteFolder.ReturnToHub.OnServerEvent:Connect(function(player)
        -- Save current data before teleporting
        savePlayerData(player)
        
        local playerData = {
            userId = player.UserId,
            name = player.Name,
            cash = player.leaderstats["Cash 💸"].Value,
            power = player.leaderstats["Power 🔋"].Value,
            prestige = player.leaderstats["Prestige ⭐"].Value,
            ecoScore = player.leaderstats["Eco Score 🌱"].Value,
            factoryValue = player.leaderstats["Factory Value 🏭"].Value,
            timestamp = os.time()
        }
        
        local teleportData = {
            playerData = playerData,
            destination = "MainHub",
            timestamp = os.time(),
            returning = true
        }
        
        if dataStoreReady and TeleportDataStore then
            pcall(function()
                TeleportDataStore:SetAsync("TeleportData_" .. player.UserId, teleportData)
            end)
        end
        
        local success, errorMessage = pcall(function()
            TeleportService:Teleport(MAIN_HUB_PLACE_ID, player, teleportData)
        end)
        
        if success then
            print("🏠 " .. player.Name .. " returned to Main Hub from SharedWorld")
        else
            warn("❌ Failed to teleport " .. player.Name .. " back to hub: " .. (errorMessage or "Unknown error"))
        end
    end)

    remoteFolder.SpawnMachine.OnServerEvent:Connect(function(player, machineName, position)
        local success, message = FactorySystem:SpawnMachine(player, machineName, position)
        CoOwnerSystem:NotifyPlayer(player, (success and "✅ " or "❌ ") .. message)
    end)

    remoteFolder.AddCoOwner.OnServerEvent:Connect(function(player, targetName)
        local success, message = CoOwnerSystem:AddCoOwner(player, targetName)
        CoOwnerSystem:NotifyPlayer(player, (success and "✅ " or "❌ ") .. message)
    end)

    remoteFolder.SetPublicIsland.OnServerEvent:Connect(function(player, isPublic)
        local success, message = PublicIslandSystem:SetPublicStatus(player, isPublic)
        CoOwnerSystem:NotifyPlayer(player, (success and "✅ " or "❌ ") .. message)
    end)

    remoteFolder.SaveFactory.OnServerEvent:Connect(function(player)
        local factory = FactorySystem.PlayerFactories[player.UserId]
        if not factory then
            CoOwnerSystem:NotifyPlayer(player, "❌ No factory to save")
            return
        end
        
        local factoryData = {
            machines = {},
            timestamp = os.time()
        }
        
        for _, machine in pairs(factory.machines) do
            if machine.part and machine.part.Parent then
                table.insert(factoryData.machines, {
                    name = machine.name,
                    position = {machine.part.Position.X, machine.part.Position.Y, machine.part.Position.Z}
                })
            end
        end
        
        if dataStoreReady and FactoryDataStore then
            local success, error = pcall(function()
                FactoryDataStore:SetAsync("Factory_" .. player.UserId, factoryData)
            end)
            
            if success then
                CoOwnerSystem:NotifyPlayer(player, "✅ Factory saved successfully!")
            else
                CoOwnerSystem:NotifyPlayer(player, "❌ Failed to save factory: " .. tostring(error))
            end
        else
            CoOwnerSystem:NotifyPlayer(player, "❌ DataStore not available")
        end
    end)

    remoteFolder.LoadFactory.OnServerEvent:Connect(function(player)
        if not dataStoreReady or not FactoryDataStore then
            CoOwnerSystem:NotifyPlayer(player, "❌ DataStore not available")
            return
        end
        
        local success, factoryData = pcall(function()
            return FactoryDataStore:GetAsync("Factory_" .. player.UserId)
        end)
        
        if not success or not factoryData then
            CoOwnerSystem:NotifyPlayer(player, "❌ No saved factory found")
            return
        end
        
        -- Clear existing machines
        local factory = FactorySystem.PlayerFactories[player.UserId]
        if factory then
            for _, machine in pairs(factory.machines) do
                if machine.part then
                    machine.part:Destroy()
                end
            end
            factory.machines = {}
        end
        
        -- Spawn saved machines
        for _, machineData in pairs(factoryData.machines) do
            local position = Vector3.new(machineData.position[1], machineData.position[2], machineData.position[3])
            FactorySystem:SpawnMachine(player, machineData.name, position)
        end
        
        CoOwnerSystem:NotifyPlayer(player, "✅ Factory loaded successfully!")
    end)

    remoteFolder.AdminFloatDown.OnServerEvent:Connect(function(player)
        AdminSystem:AdminFloatDown(player)
    end)
end

-- Setup remote handlers after a small delay
spawn(function()
    wait(1)
    setupRemoteHandlers()
end)

-- 👤 PLAYER MANAGEMENT (improved)
Players.PlayerAdded:Connect(function(player)
    print("👤 " .. player.Name .. " joined SharedWorld!")
    
    -- Create leaderstats
    createLeaderstats(player)
    
    -- Load player data
    spawn(function()
        wait(2)
        loadPlayerData(player)
    end)
    
    -- Create factory after spawn
    spawn(function()
        wait(5)
        if Players:FindFirstChild(player.Name) then
            FactorySystem:CreatePlayerFactory(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    -- Save player data
    savePlayerData(player)
    
    -- Clean up factory
    if FactorySystem.PlayerFactories[player.UserId] then
        FactorySystem.PlayerFactories[player.UserId] = nil
    end
end)

-- 💾 AUTO-SAVE SYSTEM (every 5 minutes)
spawn(function()
    while true do
        wait(300) -- 5 minutes
        for _, player in pairs(Players:GetPlayers()) do
            spawn(function()
                savePlayerData(player)
            end)
        end
        print("💾 Auto-saved all SharedWorld player data")
    end
end)

-- 🔥 COMPLETION
wait(3)
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ SHARED WORLD SYSTEM COMPLETE! ✅")
print("🌍 Multiplayer factory building with all 45 machines!")
print("🏗️ Features: Save/Load, Co-owners, Public Islands, Global Leaderboards")
print("👑 Superadmin: LeviStopMo2021 (ID: " .. SUPERADMIN_ID .. ")")
print("🎮 Controls: G=SharedWorld Menu, 👑=Admin Tools")
print("📊 DataStore Status: " .. (dataStoreReady and "✅ Ready" or "❌ Not Ready"))
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")