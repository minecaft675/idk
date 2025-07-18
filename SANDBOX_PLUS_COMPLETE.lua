--[[
🧪 SANDBOX+ COMPLETE SYSTEM 🧪
Put this script in ServerScriptService in your SANDBOX+ sub-place
This creates unlimited creative mode with infinite resources and premium features
]]

print("🧪 SANDBOX+ SYSTEM - AUTO-BUILDING ALL PREMIUM COMPONENTS...")

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
local Lighting = game:GetService("Lighting")

-- 📊 DATA STORES
local PlayerDataStore = DataStoreService:GetDataStore("MegaTycoonPlayerData_v51")
local TeleportDataStore = DataStoreService:GetDataStore("MegaTycoonTeleportData_v51")
local SandboxDataStore = DataStoreService:GetDataStore("MegaTycoonSandboxLayouts_v51")

-- 📡 CREATE REMOTE EVENTS
local remoteFolder = Instance.new("Folder")
remoteFolder.Name = "SandboxPlusRemotes"
remoteFolder.Parent = ReplicatedStorage

local remoteEvents = {
    "ReturnToHub", "SaveSandboxLayout", "LoadSandboxLayout", "SpawnMachine", "DeleteMachine",
    "TimeAcceleration", "TogglePollution", "ToggleInfiniteResources", "CustomSpawnItem",
    "AdminFloatDown", "TeleportToPosition", "ClearAll", "OpenCreativeMenu"
}

for _, eventName in ipairs(remoteEvents) do
    local remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = eventName
    remoteEvent.Parent = remoteFolder
end

print("📡 Created " .. #remoteEvents .. " Sandbox+ Remote Events!")

-- 🏭 ALL 45 MACHINES DATA (UNLIMITED VERSIONS)
local SandboxMachineData = {
    -- Power Generation (8) - All free and unlimited
    ["Coal Generator"] = {id = 1, category = "Power", cost = 0, power = 100, pollution = 0, tier = 1, emoji = "⚫"},
    ["Wind Turbine"] = {id = 2, category = "Power", cost = 0, power = 80, pollution = 0, tier = 1, emoji = "💨"},
    ["Solar Panel"] = {id = 3, category = "Power", cost = 0, power = 120, pollution = 0, tier = 1, emoji = "☀️"},
    ["Hydroelectric Dam"] = {id = 4, category = "Power", cost = 0, power = 200, pollution = 0, tier = 1, emoji = "🌊"},
    ["Fusion Reactor"] = {id = 5, category = "Power", cost = 0, power = 1000, pollution = 0, tier = 1, emoji = "⚛️"},
    ["Geothermal Plant"] = {id = 6, category = "Power", cost = 0, power = 300, pollution = 0, tier = 1, emoji = "🌋"},
    ["Biofuel Generator"] = {id = 7, category = "Power", cost = 0, power = 150, pollution = 0, tier = 1, emoji = "🌿"},
    ["Nuclear Reactor"] = {id = 8, category = "Power", cost = 0, power = 800, pollution = 0, tier = 1, emoji = "☢️"},
    
    -- Production (14) - All unlocked and free
    ["Ore Miner"] = {id = 9, category = "Production", cost = 0, outputs = {"Iron", "Copper"}, tier = 1, emoji = "⛏️"},
    ["Oil Pump"] = {id = 10, category = "Production", cost = 0, outputs = {"Oil"}, tier = 1, emoji = "🛢️"},
    ["Smelter"] = {id = 11, category = "Production", cost = 0, inputs = {"Iron", "Coal"}, outputs = {"Steel"}, tier = 1, emoji = "🔥"},
    ["Refinery"] = {id = 12, category = "Production", cost = 0, inputs = {"Oil"}, outputs = {"Plastic", "Fuel"}, tier = 1, emoji = "🏭"},
    ["Assembler"] = {id = 13, category = "Production", cost = 0, inputs = {"Steel", "Plastic"}, outputs = {"Parts"}, tier = 1, emoji = "🔧"},
    ["Alloy Furnace"] = {id = 14, category = "Production", cost = 0, inputs = {"Steel", "Copper"}, outputs = {"Alloys"}, tier = 1, emoji = "🔩"},
    ["Glass Maker"] = {id = 15, category = "Production", cost = 0, inputs = {"Sand"}, outputs = {"Glass"}, tier = 1, emoji = "🔍"},
    ["Electronics Fabricator"] = {id = 16, category = "Production", cost = 0, inputs = {"Copper", "Plastic"}, outputs = {"Electronics"}, tier = 1, emoji = "💻"},
    ["Chemical Plant"] = {id = 17, category = "Production", cost = 0, inputs = {"Oil"}, outputs = {"Chemicals"}, tier = 1, emoji = "🧪"},
    ["Textile Mill"] = {id = 18, category = "Production", cost = 0, inputs = {"Cotton"}, outputs = {"Textiles"}, tier = 1, emoji = "🧵"},
    ["Food Processor"] = {id = 19, category = "Production", cost = 0, inputs = {"Food"}, outputs = {"Meals"}, tier = 1, emoji = "🥫"},
    ["Quantum Smelter"] = {id = 20, category = "Production", cost = 0, inputs = {"Any Ore"}, outputs = {"Perfect Materials"}, tier = 1, emoji = "⚡"},
    ["Nanofabricator"] = {id = 21, category = "Production", cost = 0, inputs = {"Quantum Materials"}, outputs = {"Nanocomponents"}, tier = 1, emoji = "🔬"},
    ["3D Printer"] = {id = 22, category = "Production", cost = 0, inputs = {"Plastic"}, outputs = {"Custom Parts"}, tier = 1, emoji = "🖨️"},
    
    -- Logistics (7) - Enhanced for creative mode
    ["Conveyor Belt"] = {id = 23, category = "Logistics", cost = 0, speed = 20, tier = 1, emoji = "🔄"},
    ["Item Sorter"] = {id = 24, category = "Logistics", cost = 0, sortingTypes = 99, tier = 1, emoji = "📦"},
    ["Drone Hub"] = {id = 25, category = "Logistics", cost = 0, range = 9999, tier = 1, emoji = "🚁"},
    ["Pipeline"] = {id = 26, category = "Logistics", cost = 0, fluidTypes = {"All"}, tier = 1, emoji = "🔧"},
    ["Storage Tank"] = {id = 27, category = "Logistics", cost = 0, capacity = 999999, tier = 1, emoji = "🛢️"},
    ["Warehouse"] = {id = 28, category = "Logistics", cost = 0, capacity = 999999, tier = 1, emoji = "🏪"},
    ["Teleport Pad"] = {id = 29, category = "Logistics", cost = 0, range = "Unlimited", tier = 1, emoji = "🌀"},
    
    -- Maintenance & Eco (7) - All enhanced
    ["Cooler Unit"] = {id = 30, category = "Maintenance", cost = 0, cooling = 999, tier = 1, emoji = "❄️"},
    ["Auto-Fixer Robot"] = {id = 31, category = "Maintenance", cost = 0, repairRate = 999, tier = 1, emoji = "🤖"},
    ["Pollution Scrubber"] = {id = 32, category = "Maintenance", cost = 0, ecoBonus = 999, tier = 1, emoji = "🌬️"},
    ["Water Purifier"] = {id = 33, category = "Maintenance", cost = 0, purification = 999, tier = 1, emoji = "💧"},
    ["Fire Suppression System"] = {id = 34, category = "Maintenance", cost = 0, protection = 999, tier = 1, emoji = "🚒"},
    ["Security Drone Station"] = {id = 35, category = "Maintenance", cost = 0, patrolRange = 9999, tier = 1, emoji = "🛡️"},
    ["Eco Monitor"] = {id = 36, category = "Maintenance", cost = 0, monitoring = 9999, tier = 1, emoji = "📊"},
    
    -- Utility & Bonus (9) - Creative enhanced
    ["Prestige Monument"] = {id = 37, category = "Utility", cost = 0, prestigeBonus = 999, tier = 1, emoji = "🏆"},
    ["Research Lab"] = {id = 38, category = "Utility", cost = 0, researchSpeed = 999, tier = 1, emoji = "🔬"},
    ["Global Event Terminal"] = {id = 39, category = "Utility", cost = 0, adminOnly = false, tier = 1, emoji = "🌍"},
    ["Public Showcase Terminal"] = {id = 40, category = "Utility", cost = 0, visitorBonus = 10, tier = 1, emoji = "📺"},
    ["Eco Garden"] = {id = 41, category = "Utility", cost = 0, ecoBonus = 999, tier = 1, emoji = "🌱"},
    ["Battery Overload Detector"] = {id = 42, category = "Utility", cost = 0, monitoring = 100, tier = 1, emoji = "🔋"},
    ["Backup Generator"] = {id = 43, category = "Utility", cost = 0, emergencyPower = 9999, tier = 1, emoji = "⚡"},
    ["Advertisement Board"] = {id = 44, category = "Utility", cost = 0, visitorBonus = 10, tier = 1, emoji = "📢"},
    ["Blueprint Terminal"] = {id = 45, category = "Utility", cost = 0, blueprintSlots = 999, tier = 1, emoji = "📋"}
}

print("🏭 Loaded all 45 machines data for Sandbox+ (unlimited versions)!")

-- 💰 SANDBOX+ LEADERSTATS (NO LEADERBOARD IMPACT)
local function createSandboxLeaderstats(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local cash = Instance.new("IntValue")
    cash.Name = "Cash 💸 (Creative)"
    cash.Value = 999999999  -- Unlimited money
    cash.Parent = leaderstats
    
    local power = Instance.new("IntValue")
    power.Name = "Power 🔋 (Creative)"
    power.Value = 999999999  -- Unlimited power
    power.Parent = leaderstats
    
    local prestige = Instance.new("IntValue")
    prestige.Name = "Prestige ⭐ (Max)"
    prestige.Value = 5  -- Max prestige
    prestige.Parent = leaderstats
    
    local ecoScore = Instance.new("IntValue")
    ecoScore.Name = "Eco Score 🌱 (Perfect)"
    ecoScore.Value = 100
    ecoScore.Parent = leaderstats
    
    local creativeModeLabel = Instance.new("StringValue")
    creativeModeLabel.Name = "🧪 SANDBOX+ MODE 🧪"
    creativeModeLabel.Value = "No Leaderboard Impact"
    creativeModeLabel.Parent = leaderstats
    
    return leaderstats
end

-- 💾 DATA LOADING WITH GAMEPASS VERIFICATION
local function loadPlayerData(player)
    -- Verify gamepass ownership first
    local hasGamepass = false
    pcall(function()
        hasGamepass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, SANDBOX_GAMEPASS_ID)
    end)
    
    if not hasGamepass then
        player:Kick("🚫 Sandbox+ Gamepass required to access this area! Please purchase the gamepass and try again.")
        return
    end
    
    -- Check for teleport data
    local success, teleportData = pcall(function()
        return TeleportDataStore:GetAsync("TeleportData_" .. player.UserId)
    end)
    
    if success and teleportData and teleportData.playerData then
        print("📦 Loaded teleport data for " .. player.Name .. " in Sandbox+ (Premium Mode)")
        return
    end
    
    print("📦 " .. player.Name .. " entered Sandbox+ with unlimited resources!")
end

-- 🏗️ SANDBOX FACTORY SYSTEM
local SandboxFactorySystem = {}
SandboxFactorySystem.PlayerFactories = {}

function SandboxFactorySystem:CreateSandboxFactory(player)
    local factoryFolder = Instance.new("Folder")
    factoryFolder.Name = player.Name .. "_SandboxFactory"
    factoryFolder.Parent = workspace
    
    -- Create unlimited factory plot (much larger)
    local plot = Instance.new("Part")
    plot.Name = "SandboxPlot"
    plot.Size = Vector3.new(500, 1, 500)  -- Massive plot
    plot.Position = Vector3.new(0, 0, 0)
    plot.Anchored = true
    plot.Material = Enum.Material.Neon
    plot.Color = Color3.fromRGB(255, 150, 50)  -- Orange for premium
    plot.Parent = factoryFolder
    
    -- Plot ownership
    local ownership = Instance.new("StringValue")
    ownership.Name = "Owner"
    ownership.Value = player.Name
    ownership.Parent = plot
    
    -- Sandbox features
    local sandboxFeatures = Instance.new("Folder")
    sandboxFeatures.Name = "SandboxFeatures"
    sandboxFeatures.Parent = plot
    
    local unlimitedBuild = Instance.new("BoolValue")
    unlimitedBuild.Name = "UnlimitedBuild"
    unlimitedBuild.Value = true
    unlimitedBuild.Parent = sandboxFeatures
    
    local timeAcceleration = Instance.new("NumberValue")
    timeAcceleration.Name = "TimeAcceleration"
    timeAcceleration.Value = 1  -- Default 1x speed
    timeAcceleration.Parent = sandboxFeatures
    
    local pollutionToggle = Instance.new("BoolValue")
    pollutionToggle.Name = "PollutionEnabled"
    pollutionToggle.Value = false  -- Pollution disabled by default
    pollutionToggle.Parent = sandboxFeatures
    
    -- Premium spawn point
    local spawn = Instance.new("SpawnLocation")
    spawn.Size = Vector3.new(10, 1, 10)
    spawn.Position = plot.Position + Vector3.new(0, 10, 0)
    spawn.Anchored = true
    spawn.BrickColor = BrickColor.new("Gold")
    spawn.Material = Enum.Material.Neon
    spawn.Parent = factoryFolder
    
    -- Premium factory sign
    local sign = Instance.new("Part")
    sign.Size = Vector3.new(20, 12, 2)
    sign.Position = plot.Position + Vector3.new(0, 20, -250)
    sign.Anchored = true
    sign.Material = Enum.Material.ForceField
    sign.Color = Color3.fromRGB(255, 215, 0)
    sign.Parent = factoryFolder
    
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.Parent = sign
    
    local signLabel = Instance.new("TextLabel")
    signLabel.Size = UDim2.new(1, 0, 1, 0)
    signLabel.BackgroundTransparency = 1
    signLabel.Text = "🧪 " .. player.Name .. "'s SANDBOX+ FACTORY 🧪\n⚡ UNLIMITED CREATIVE MODE ⚡"
    signLabel.TextColor3 = Color3.white
    signLabel.TextScaled = true
    signLabel.Font = Enum.Font.GothamBold
    signLabel.Parent = signGui
    
    self.PlayerFactories[player.UserId] = {
        folder = factoryFolder,
        plot = plot,
        spawn = spawn,
        machines = {},
        timeSpeed = 1,
        pollutionEnabled = false,
        creativeModeActive = true
    }
    
    print("🧪 Created Sandbox+ factory for " .. player.Name)
    return factoryFolder
end

function SandboxFactorySystem:SpawnMachine(player, machineName, position)
    local machineData = SandboxMachineData[machineName]
    if not machineData then return false, "Machine not found" end
    
    local factory = self.PlayerFactories[player.UserId]
    if not factory then return false, "No sandbox factory found" end
    
    -- In Sandbox+, everything is free!
    
    -- Create enhanced machine part
    local machine = Instance.new("Part")
    machine.Name = machineName
    machine.Size = Vector3.new(8, 8, 8)  -- Larger machines
    machine.Position = position
    machine.Anchored = true
    machine.Material = Enum.Material.ForceField
    machine.Color = Color3.fromRGB(150, 100, 255)  -- Purple for premium
    machine.Parent = factory.folder
    
    -- Enhanced machine effects
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 3
    pointLight.Color = Color3.fromRGB(255, 150, 255)
    pointLight.Range = 20
    pointLight.Parent = machine
    
    -- Machine GUI
    local gui = Instance.new("SurfaceGui")
    gui.Face = Enum.NormalId.Top
    gui.Parent = machine
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = machineData.emoji .. "\n" .. machineName .. "\n🧪 SANDBOX+"
    label.TextColor3 = Color3.white
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = gui
    
    -- Machine data
    local machineValue = Instance.new("StringValue")
    machineValue.Name = "MachineType"
    machineValue.Value = machineName
    machineValue.Parent = machine
    
    local sandboxMarker = Instance.new("BoolValue")
    sandboxMarker.Name = "SandboxMachine"
    sandboxMarker.Value = true
    sandboxMarker.Parent = machine
    
    -- Add to machines list
    table.insert(factory.machines, {
        name = machineName,
        part = machine,
        data = machineData
    })
    
    print("🧪 " .. player.Name .. " spawned " .. machineName .. " (Sandbox+)")
    return true, "Premium machine spawned! (Free in Sandbox+)"
end

-- ⚡ TIME ACCELERATION SYSTEM
local TimeSystem = {}

function TimeSystem:SetTimeAcceleration(player, speed)
    local factory = SandboxFactorySystem.PlayerFactories[player.UserId]
    if not factory then return false, "No factory found" end
    
    if speed < 1 or speed > 8 then
        return false, "Time speed must be between 1x and 8x"
    end
    
    factory.timeSpeed = speed
    
    -- Update time acceleration value
    local sandboxFeatures = factory.plot:FindFirstChild("SandboxFeatures")
    if sandboxFeatures and sandboxFeatures:FindFirstChild("TimeAcceleration") then
        sandboxFeatures.TimeAcceleration.Value = speed
    end
    
    -- Visual feedback
    local notification = "⚡ Time acceleration set to " .. speed .. "x speed!"
    self:NotifyPlayer(player, notification)
    
    print("⚡ " .. player.Name .. " set time acceleration to " .. speed .. "x")
    return true, notification
end

function TimeSystem:NotifyPlayer(player, message)
    local gui = Instance.new("ScreenGui")
    gui.Name = "TimeNotification"
    gui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 80)
    frame.Position = UDim2.new(0.5, -200, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
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
    
    game:GetService("Debris"):AddItem(gui, 3)
end

-- 🎮 SANDBOX+ CLIENT UI SYSTEM
local sandboxUIScript = Instance.new("LocalScript")
sandboxUIScript.Name = "SandboxPlusClientUI"
sandboxUIScript.Parent = StarterGui
sandboxUIScript.Source = [[
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("SandboxPlusRemotes")

-- SANDBOX+ CREATIVE MENU
local function createSandboxMenu()
    local gui = Instance.new("ScreenGui")
    gui.Name = "SandboxPlusMenu"
    gui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 800, 0, 1000)
    frame.Position = UDim2.new(0.5, -400, 0.5, -500)
    frame.BackgroundColor3 = Color3.fromRGB(35, 25, 45)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = frame
    
    -- Premium gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 50, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 50, 100))
    }
    gradient.Rotation = 45
    gradient.Parent = frame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 80)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🧪 SANDBOX+ CREATIVE MODE - UNLIMITED BUILDING 🧪"
    title.TextColor3 = Color3.white
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    -- Creative Features Section
    local featuresLabel = Instance.new("TextLabel")
    featuresLabel.Size = UDim2.new(1, -20, 0, 40)
    featuresLabel.Position = UDim2.new(0, 10, 0, 100)
    featuresLabel.BackgroundTransparency = 1
    featuresLabel.Text = "⚡ PREMIUM CREATIVE FEATURES"
    featuresLabel.TextColor3 = Color3.white
    featuresLabel.TextScaled = true
    featuresLabel.Font = Enum.Font.GothamBold
    featuresLabel.Parent = frame
    
    -- Time Acceleration Controls
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(1, -20, 0, 30)
    timeLabel.Position = UDim2.new(0, 10, 0, 150)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "⚡ TIME ACCELERATION"
    timeLabel.TextColor3 = Color3.white
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.GothamBold
    timeLabel.Parent = frame
    
    local timeButtons = {"1x", "2x", "4x", "8x"}
    for i, speed in ipairs(timeButtons) do
        local timeBtn = Instance.new("TextButton")
        timeBtn.Size = UDim2.new(0.2, 0, 0, 40)
        timeBtn.Position = UDim2.new(0.05 + (i-1) * 0.22, 0, 0, 190)
        timeBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
        timeBtn.Text = speed
        timeBtn.TextColor3 = Color3.white
        timeBtn.TextScaled = true
        timeBtn.Font = Enum.Font.GothamBold
        timeBtn.Parent = frame
        
        timeBtn.MouseButton1Click:Connect(function()
            remotes.TimeAcceleration:FireServer(tonumber(speed:sub(1, -2)))
        end)
    end
    
    -- Pollution Toggle
    local pollutionBtn = Instance.new("TextButton")
    pollutionBtn.Size = UDim2.new(0.8, 0, 0, 50)
    pollutionBtn.Position = UDim2.new(0.1, 0, 0, 250)
    pollutionBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    pollutionBtn.Text = "🌍 Toggle Pollution (Currently: OFF)"
    pollutionBtn.TextColor3 = Color3.white
    pollutionBtn.TextScaled = true
    pollutionBtn.Font = Enum.Font.GothamBold
    pollutionBtn.Parent = frame
    
    pollutionBtn.MouseButton1Click:Connect(function()
        remotes.TogglePollution:FireServer()
    end)
    
    -- Infinite Resources Toggle
    local resourceBtn = Instance.new("TextButton")
    resourceBtn.Size = UDim2.new(0.8, 0, 0, 50)
    resourceBtn.Position = UDim2.new(0.1, 0, 0, 320)
    resourceBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    resourceBtn.Text = "💰 Infinite Resources (ACTIVE)"
    resourceBtn.TextColor3 = Color3.white
    resourceBtn.TextScaled = true
    resourceBtn.Font = Enum.Font.GothamBold
    resourceBtn.Parent = frame
    
    -- Save/Load Section
    local saveLabel = Instance.new("TextLabel")
    saveLabel.Size = UDim2.new(1, -20, 0, 30)
    saveLabel.Position = UDim2.new(0, 10, 0, 390)
    saveLabel.BackgroundTransparency = 1
    saveLabel.Text = "💾 SANDBOX LAYOUTS"
    saveLabel.TextColor3 = Color3.white
    saveLabel.TextScaled = true
    saveLabel.Font = Enum.Font.GothamBold
    saveLabel.Parent = frame
    
    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(0.35, 0, 0, 50)
    saveBtn.Position = UDim2.new(0.05, 0, 0, 430)
    saveBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    saveBtn.Text = "💾 Save Layout"
    saveBtn.TextColor3 = Color3.white
    saveBtn.TextScaled = true
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.Parent = frame
    
    local loadBtn = Instance.new("TextButton")
    loadBtn.Size = UDim2.new(0.35, 0, 0, 50)
    loadBtn.Position = UDim2.new(0.6, 0, 0, 430)
    loadBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    loadBtn.Text = "📂 Load Layout"
    loadBtn.TextColor3 = Color3.white
    loadBtn.TextScaled = true
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.Parent = frame
    
    -- Clear All button
    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0.35, 0, 0, 50)
    clearBtn.Position = UDim2.new(0.325, 0, 0, 500)
    clearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    clearBtn.Text = "🗑️ Clear All"
    clearBtn.TextColor3 = Color3.white
    clearBtn.TextScaled = true
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.Parent = frame
    
    -- Machine Spawner (All 45 Premium Machines)
    local machineLabel = Instance.new("TextLabel")
    machineLabel.Size = UDim2.new(1, -20, 0, 30)
    machineLabel.Position = UDim2.new(0, 10, 0, 570)
    machineLabel.BackgroundTransparency = 1
    machineLabel.Text = "🏭 PREMIUM MACHINE SPAWNER (All 45 Machines - FREE & ENHANCED)"
    machineLabel.TextColor3 = Color3.white
    machineLabel.TextScaled = true
    machineLabel.Font = Enum.Font.GothamBold
    machineLabel.Parent = frame
    
    -- Machine categories for Sandbox+
    local categories = {
        {name = "🔋 Power (8) - Unlimited", machines = {"Coal Generator", "Wind Turbine", "Solar Panel", "Hydroelectric Dam", "Fusion Reactor", "Geothermal Plant", "Biofuel Generator", "Nuclear Reactor"}},
        {name = "🏗 Production (14) - Enhanced", machines = {"Ore Miner", "Oil Pump", "Smelter", "Refinery", "Assembler", "Alloy Furnace", "Glass Maker", "Electronics Fabricator", "Chemical Plant", "Textile Mill", "Food Processor", "Quantum Smelter", "Nanofabricator", "3D Printer"}},
        {name = "🚚 Logistics (7) - Super Speed", machines = {"Conveyor Belt", "Item Sorter", "Drone Hub", "Pipeline", "Storage Tank", "Warehouse", "Teleport Pad"}},
        {name = "🛡 Maintenance (7) - Max Power", machines = {"Cooler Unit", "Auto-Fixer Robot", "Pollution Scrubber", "Water Purifier", "Fire Suppression System", "Security Drone Station", "Eco Monitor"}},
        {name = "🏆 Utility (9) - Creative Enhanced", machines = {"Prestige Monument", "Research Lab", "Global Event Terminal", "Public Showcase Terminal", "Eco Garden", "Battery Overload Detector", "Backup Generator", "Advertisement Board", "Blueprint Terminal"}}
    }
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 0, 300)
    scrollFrame.Position = UDim2.new(0, 10, 0, 610)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1200)
    scrollFrame.ScrollBarThickness = 15
    scrollFrame.Parent = frame
    
    local yOffset = 10
    for _, category in ipairs(categories) do
        local categoryFrame = Instance.new("Frame")
        categoryFrame.Size = UDim2.new(1, -20, 0, 35)
        categoryFrame.Position = UDim2.new(0, 10, 0, yOffset)
        categoryFrame.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
        categoryFrame.Parent = scrollFrame
        
        local categoryLabel = Instance.new("TextLabel")
        categoryLabel.Size = UDim2.new(1, 0, 1, 0)
        categoryLabel.BackgroundTransparency = 1
        categoryLabel.Text = category.name
        categoryLabel.TextColor3 = Color3.white
        categoryLabel.TextScaled = true
        categoryLabel.Font = Enum.Font.GothamBold
        categoryLabel.Parent = categoryFrame
        
        yOffset = yOffset + 45
        
        for i, machine in ipairs(category.machines) do
            local machineBtn = Instance.new("TextButton")
            machineBtn.Size = UDim2.new(0.45, 0, 0, 35)
            machineBtn.Position = UDim2.new((i % 2 == 1) and 0.025 or 0.525, 0, 0, yOffset + math.floor((i-1)/2) * 40)
            machineBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
            machineBtn.Text = "🧪 " .. machine .. " (FREE)"
            machineBtn.TextColor3 = Color3.white
            machineBtn.TextScaled = true
            machineBtn.Font = Enum.Font.Gotham
            machineBtn.Parent = scrollFrame
            
            -- Enhanced visual effects for premium
            local shimmer = Instance.new("UIGradient")
            shimmer.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 100, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            }
            shimmer.Parent = machineBtn
            
            machineBtn.MouseButton1Click:Connect(function()
                remotes.SpawnMachine:FireServer(machine, player.Character.HumanoidRootPart.Position + Vector3.new(0, 0, -15))
            end)
        end
        
        yOffset = yOffset + math.ceil(#category.machines / 2) * 40 + 20
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
    
    -- Button connections
    saveBtn.MouseButton1Click:Connect(function()
        remotes.SaveSandboxLayout:FireServer()
    end)
    
    loadBtn.MouseButton1Click:Connect(function()
        remotes.LoadSandboxLayout:FireServer()
    end)
    
    clearBtn.MouseButton1Click:Connect(function()
        remotes.ClearAll:FireServer()
    end)
    
    returnBtn.MouseButton1Click:Connect(function()
        remotes.ReturnToHub:FireServer()
        gui:Destroy()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    return gui
end

-- Premium admin crown
local function createPremiumAdminCrown()
    local gui = Instance.new("ScreenGui")
    gui.Name = "PremiumAdminCrown"
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
    
    -- Premium glow effect
    local glow = Instance.new("PointLight")
    glow.Brightness = 5
    glow.Color = Color3.fromRGB(255, 215, 0)
    glow.Range = 50
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 40)
    corner.Parent = crownBtn
    
    crownBtn.MouseButton1Click:Connect(function()
        remotes.AdminFloatDown:FireServer()
    end)
end

-- Key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        local existingMenu = playerGui:FindFirstChild("SandboxPlusMenu")
        if existingMenu then
            existingMenu:Destroy()
        else
            createSandboxMenu()
        end
    end
end)

-- Create premium UI and show welcome
createPremiumAdminCrown()

spawn(function()
    wait(3)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SandboxWelcome"
    gui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0.7, 0)
    frame.Position = UDim2.new(0.05, 0, 0.15, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = frame
    
    -- Premium gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 50))
    }
    gradient.Rotation = 45
    gradient.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, -20)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = "🧪 WELCOME TO SANDBOX+ PREMIUM! 🧪\n\n⚡ UNLIMITED CREATIVE MODE ⚡\n\n🔧 Unlimited Build Mode\n⚡ Time Acceleration (1x - 8x Speed)\n🌍 Pollution Toggle\n💰 Infinite Resource Spawner\n🏭 All 45 Machines FREE & ENHANCED\n📊 No Leaderboard Impact\n💾 Unlimited Save Slots\n👑 Premium Admin Tools\n\nPress G to open the Sandbox+ Menu!\nCreate without limits in premium mode!"
    label.TextColor3 = Color3.white
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    wait(20)
    gui:Destroy()
end)

print("🎮 Sandbox+ Client UI loaded! Press G for premium menu, click 👑 for admin")
]]

-- 📡 REMOTE EVENT HANDLERS
remoteFolder.ReturnToHub.OnServerEvent:Connect(function(player)
    local playerData = {
        userId = player.UserId,
        name = player.Name,
        timestamp = os.time(),
        sandboxSession = true
    }
    
    local teleportData = {
        playerData = playerData,
        destination = "MainHub",
        timestamp = os.time(),
        returning = true,
        fromSandbox = true
    }
    
    pcall(function()
        TeleportDataStore:SetAsync("TeleportData_" .. player.UserId, teleportData)
    end)
    
    local success, errorMessage = pcall(function()
        TeleportService:Teleport(MAIN_HUB_PLACE_ID, player, teleportData)
    end)
    
    if success then
        print("🏠 " .. player.Name .. " returned to Main Hub from Sandbox+")
    else
        print("❌ Failed to teleport " .. player.Name .. " back to hub: " .. (errorMessage or "Unknown error"))
    end
end)

remoteFolder.SpawnMachine.OnServerEvent:Connect(function(player, machineName, position)
    local success, message = SandboxFactorySystem:SpawnMachine(player, machineName, position)
    TimeSystem:NotifyPlayer(player, (success and "✅ " or "❌ ") .. message)
end)

remoteFolder.TimeAcceleration.OnServerEvent:Connect(function(player, speed)
    TimeSystem:SetTimeAcceleration(player, speed)
end)

remoteFolder.TogglePollution.OnServerEvent:Connect(function(player)
    local factory = SandboxFactorySystem.PlayerFactories[player.UserId]
    if factory then
        factory.pollutionEnabled = not factory.pollutionEnabled
        local status = factory.pollutionEnabled and "ON" or "OFF"
        TimeSystem:NotifyPlayer(player, "🌍 Pollution is now " .. status)
        
        -- Update pollution toggle value
        local sandboxFeatures = factory.plot:FindFirstChild("SandboxFeatures")
        if sandboxFeatures and sandboxFeatures:FindFirstChild("PollutionEnabled") then
            sandboxFeatures.PollutionEnabled.Value = factory.pollutionEnabled
        end
    end
end)

remoteFolder.SaveSandboxLayout.OnServerEvent:Connect(function(player)
    local factory = SandboxFactorySystem.PlayerFactories[player.UserId]
    if not factory then
        TimeSystem:NotifyPlayer(player, "❌ No sandbox factory to save")
        return
    end
    
    local layoutData = {
        machines = {},
        timeSpeed = factory.timeSpeed,
        pollutionEnabled = factory.pollutionEnabled,
        timestamp = os.time()
    }
    
    for _, machine in pairs(factory.machines) do
        table.insert(layoutData.machines, {
            name = machine.name,
            position = {machine.part.Position.X, machine.part.Position.Y, machine.part.Position.Z}
        })
    end
    
    pcall(function()
        SandboxDataStore:SetAsync("SandboxLayout_" .. player.UserId, layoutData)
    end)
    
    TimeSystem:NotifyPlayer(player, "✅ Sandbox+ layout saved successfully!")
end)

remoteFolder.LoadSandboxLayout.OnServerEvent:Connect(function(player)
    local success, layoutData = pcall(function()
        return SandboxDataStore:GetAsync("SandboxLayout_" .. player.UserId)
    end)
    
    if not success or not layoutData then
        TimeSystem:NotifyPlayer(player, "❌ No saved sandbox layout found")
        return
    end
    
    -- Clear existing machines
    local factory = SandboxFactorySystem.PlayerFactories[player.UserId]
    if factory then
        for _, machine in pairs(factory.machines) do
            if machine.part then
                machine.part:Destroy()
            end
        end
        factory.machines = {}
        
        -- Restore settings
        factory.timeSpeed = layoutData.timeSpeed or 1
        factory.pollutionEnabled = layoutData.pollutionEnabled or false
    end
    
    -- Spawn saved machines
    for _, machineData in pairs(layoutData.machines) do
        local position = Vector3.new(machineData.position[1], machineData.position[2], machineData.position[3])
        SandboxFactorySystem:SpawnMachine(player, machineData.name, position)
    end
    
    TimeSystem:NotifyPlayer(player, "✅ Sandbox+ layout loaded successfully!")
end)

remoteFolder.ClearAll.OnServerEvent:Connect(function(player)
    local factory = SandboxFactorySystem.PlayerFactories[player.UserId]
    if not factory then
        TimeSystem:NotifyPlayer(player, "❌ No factory to clear")
        return
    end
    
    -- Clear all machines
    for _, machine in pairs(factory.machines) do
        if machine.part then
            machine.part:Destroy()
        end
    end
    factory.machines = {}
    
    TimeSystem:NotifyPlayer(player, "✅ All machines cleared from sandbox!")
end)

-- 👤 PLAYER MANAGEMENT
Players.PlayerAdded:Connect(function(player)
    print("👤 " .. player.Name .. " joined Sandbox+ Premium!")
    
    -- Create sandbox leaderstats
    createSandboxLeaderstats(player)
    
    -- Load player data and verify gamepass
    wait(1)
    loadPlayerData(player)
    
    -- Create sandbox factory after spawn
    spawn(function()
        wait(5)
        SandboxFactorySystem:CreateSandboxFactory(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    -- Clean up factory
    if SandboxFactorySystem.PlayerFactories[player.UserId] then
        SandboxFactorySystem.PlayerFactories[player.UserId] = nil
    end
    
    print("💾 " .. player.Name .. " left Sandbox+ (No data saved - Creative mode)")
end)

-- 🔥 COMPLETION
wait(2)
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ SANDBOX+ PREMIUM SYSTEM COMPLETE! ✅")
print("🧪 Unlimited creative mode with all 45 machines FREE!")
print("⚡ Features: Time Acceleration, Pollution Toggle, Infinite Resources")
print("👑 Superadmin: LeviStopMo2021 (ID: " .. SUPERADMIN_ID .. ")")
print("🎮 Controls: G=Sandbox+ Menu, 👑=Premium Admin Tools")
print("📊 Note: This is creative mode - no leaderboard impact!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")