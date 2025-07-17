-- ████████╗██╗   ██╗ ██████╗ ██████╗  ██████╗ ███╗   ██╗    ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
-- ╚══██╔══╝╚██╗ ██╔╝██╔════╝██╔═══██╗██╔═══██╗████╗  ██║    ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝
--    ██║    ╚████╔╝ ██║     ██║   ██║██║   ██║██╔██╗ ██║    █████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗  
--    ██║     ╚██╔╝  ██║     ██║   ██║██║   ██║██║╚██╗██║    ██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝  
--    ██║      ██║   ╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║    ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗
--    ╚═╝      ╚═╝    ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝    ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝

--[[
🌟 TYCOON ENGINE v3.0 - SELF-DESTRUCTING LOADER 🌟
▪️ Creates full multiplayer tycoon game with 3 worlds
▪️ Admin/Co-owner systems built-in
▪️ Eco mechanics, events, leaderboards
▪️ Gamepass integration (Sandbox+)
▪️ Mobile/Console compatible
▪️ Builds everything then deletes itself

🚀 BY: Advanced Game Systems
👑 SUPERADMIN: LeviStopMo2021 (hardcoded)
--]]

local TycoonLoader = {}

-- ⚙️ CORE CONFIGURATION
local CONFIG = {
    SANDBOX_GAMEPASS_ID = 1322694317,
    SUPERADMIN_ID = 123456789, -- Replace with LeviStopMo2021's actual user ID
    DEBUG_MODE = true,
    VERSION = "3.0"
}

-- 🎯 SERVICE REFERENCES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local DataStoreService = game:GetService("DataStoreService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

-- 📊 DATA STORES
local PlayerDataStore = DataStoreService:GetDataStore("TycoonPlayerData_v3")
local AdminDataStore = DataStoreService:GetDataStore("TycoonAdmins_v3")
local LeaderboardStore = DataStoreService:GetDataStore("TycoonLeaderboards_v3")
local PublicIslandStore = DataStoreService:GetDataStore("PublicIslands_v3")

-- 🌍 GAME MODES
local GameModes = {
    MAIN_HUB = "MainHub",
    SHARED_WORLD = "SharedWorld", 
    SANDBOX_PLUS = "SandboxPlus"
}

-- 📡 REMOTE EVENTS SETUP
function TycoonLoader:CreateRemoteEvents()
    local remoteFolder = Instance.new("Folder")
    remoteFolder.Name = "TycoonRemotes"
    remoteFolder.Parent = ReplicatedStorage
    
    local events = {
        -- 🏛️ MAIN HUB EVENTS
        "TeleportToWorld",
        "OpenAdminPanel",
        "BroadcastMessage",
        "GiveMoney",
        "AddAdmin",
        "RemoveAdmin",
        "PowerDiagnostics",
        
        -- 🏗️ SHARED WORLD EVENTS  
        "SaveFactory",
        "LoadFactory",
        "AddCoOwner",
        "RemoveCoOwner",
        "AdminFloatDown",
        "EarnChickenBadge",
        "UpdateLeaderboard",
        "SetPublicIsland",
        "RateIsland",
        
        -- 🧪 SANDBOX+ EVENTS
        "SpawnItem",
        "TimeAcceleration",
        "TogglePollution",
        "AdminGiveMoney",
        "ChargeAllBatteries",
        
        -- 🔥 BONUS SYSTEM EVENTS
        "TriggerRandomEvent",
        "BuyAutoFixer",
        "UpdateEcoScore",
        "ViewResourceFlow"
    }
    
    local functions = {
        "GetPlayerData",
        "CheckGamepassOwnership", 
        "GetLeaderboards",
        "GetPublicIslands"
    }
    
    -- Create RemoteEvents
    for _, eventName in ipairs(events) do
        local remoteEvent = Instance.new("RemoteEvent")
        remoteEvent.Name = eventName
        remoteEvent.Parent = remoteFolder
    end
    
    -- Create RemoteFunctions
    for _, funcName in ipairs(functions) do
        local remoteFunction = Instance.new("RemoteFunction")
        remoteFunction.Name = funcName
        remoteFunction.Parent = remoteFolder
    end
    
    print("✅ Remote Events & Functions created!")
end

-- 👑 ADMIN SYSTEM SETUP
function TycoonLoader:CreateAdminSystem()
    local adminModule = Instance.new("ModuleScript")
    adminModule.Name = "AdminSystem"
    adminModule.Parent = ServerStorage
    
    local adminCode = [[
local AdminSystem = {}
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local AdminDataStore = DataStoreService:GetDataStore("TycoonAdmins_v3")

-- 👑 SUPERADMIN (HARDCODED)
local SUPERADMIN_ID = ]] .. CONFIG.SUPERADMIN_ID .. [[

-- 📋 ADMIN LISTS
AdminSystem.Admins = {}
AdminSystem.CoOwners = {}

-- 🔧 ADMIN FUNCTIONS
function AdminSystem:IsAdmin(player)
    return player.UserId == SUPERADMIN_ID or AdminSystem.Admins[player.UserId]
end

function AdminSystem:AddAdmin(adminPlayer, targetUserId)
    if not AdminSystem:IsAdmin(adminPlayer) then return false end
    
    AdminSystem.Admins[targetUserId] = true
    AdminSystem:SaveAdminData()
    return true
end

function AdminSystem:RemoveAdmin(adminPlayer, targetUserId)
    if adminPlayer.UserId ~= SUPERADMIN_ID then return false end
    
    AdminSystem.Admins[targetUserId] = nil
    AdminSystem:SaveAdminData()
    return true
end

function AdminSystem:SaveAdminData()
    pcall(function()
        AdminDataStore:SetAsync("AdminList", AdminSystem.Admins)
    end)
end

function AdminSystem:LoadAdminData()
    local success, data = pcall(function()
        return AdminDataStore:GetAsync("AdminList") or {}
    end)
    
    if success then
        AdminSystem.Admins = data
    end
end

-- Initialize on startup
AdminSystem:LoadAdminData()

return AdminSystem
]]
    
    adminModule.Source = adminCode
    print("👑 Admin System created!")
end

-- 💰 LEADERSTATS SYSTEM
function TycoonLoader:CreateLeaderstats()
    local leaderstatsScript = Instance.new("Script")
    leaderstatsScript.Name = "LeaderstatsManager"
    leaderstatsScript.Parent = ServerStorage
    
    local leaderstatsCode = [[
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("TycoonPlayerData_v3")

local function onPlayerJoined(player)
    -- 📊 Create leaderstats
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local cash = Instance.new("IntValue")
    cash.Name = "Cash 💸"
    cash.Value = 1000 -- Starting money
    cash.Parent = leaderstats
    
    local power = Instance.new("IntValue") 
    power.Name = "Power 🔋"
    power.Value = 0
    power.Parent = leaderstats
    
    -- 💾 Load player data
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync("Player_" .. player.UserId) or {}
    end)
    
    if success and data then
        cash.Value = data.Cash or 1000
        power.Value = data.Power or 0
    end
end

local function onPlayerLeft(player)
    -- 💾 Save player data
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local data = {
            Cash = leaderstats["Cash 💸"].Value,
            Power = leaderstats["Power 🔋"].Value,
            LastPlayed = os.time()
        }
        
        pcall(function()
            PlayerDataStore:SetAsync("Player_" .. player.UserId, data)
        end)
    end
end

Players.PlayerAdded:Connect(onPlayerJoined)
Players.PlayerRemoving:Connect(onPlayerLeft)
]]
    
    leaderstatsScript.Source = leaderstatsCode
    print("💰 Leaderstats System created!")
end

-- 🎨 UI SYSTEM CREATION
function TycoonLoader:CreateMainUI()
    local guiFolder = Instance.new("Folder")
    guiFolder.Name = "TycoonGUIs"
    guiFolder.Parent = ReplicatedStorage
    
    -- 🖥️ MAIN HUB UI
    local mainHubGui = Instance.new("ScreenGui")
    mainHubGui.Name = "MainHubUI"
    mainHubGui.Parent = guiFolder
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = mainHubGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    title.Text = "🌟 TYCOON ENGINE v3.0"
    title.TextColor3 = Color3.white
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title
    
    -- 🌍 World Buttons
    local worldButtons = {
        {name = "🏗️ Enter SharedWorld", color = Color3.fromRGB(50, 200, 50), action = "SharedWorld"},
        {name = "🧪 Sandbox+ (Premium)", color = Color3.fromRGB(255, 150, 50), action = "SandboxPlus"},
        {name = "⚙️ Settings", color = Color3.fromRGB(100, 100, 100), action = "Settings"},
        {name = "👑 Admin Panel", color = Color3.fromRGB(255, 50, 50), action = "Admin"}
    }
    
    for i, buttonData in ipairs(worldButtons) do
        local button = Instance.new("TextButton")
        button.Name = buttonData.action .. "Button"
        button.Size = UDim2.new(0.9, 0, 0, 70)
        button.Position = UDim2.new(0.05, 0, 0, 80 + (i * 85))
        button.BackgroundColor3 = buttonData.color
        button.Text = buttonData.name
        button.TextColor3 = Color3.white
        button.TextScaled = true
        button.Font = Enum.Font.Gotham
        button.Parent = mainFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button
        
        -- Hover effect
        button.MouseEnter:Connect(function()
            local tween = TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0.95, 0, 0, 75)})
            tween:Play()
        end)
        
        button.MouseLeave:Connect(function()
            local tween = TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0.9, 0, 0, 70)})
            tween:Play()
        end)
    end
    
    print("🎨 Main Hub UI created!")
end

-- 🏗️ SHARED WORLD SYSTEM
function TycoonLoader:CreateSharedWorldSystem()
    local sharedWorldModule = Instance.new("ModuleScript")
    sharedWorldModule.Name = "SharedWorldSystem"
    sharedWorldModule.Parent = ServerStorage
    
    local sharedWorldCode = [[
local SharedWorld = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local DataStoreService = game:GetService("DataStoreService")

-- 🏗️ SHARED WORLD MECHANICS
SharedWorld.PlayerPlots = {}
SharedWorld.CoOwners = {}
SharedWorld.PublicIslands = {}

-- 🌿 BIOMES SYSTEM
local Biomes = {
    Forest = {efficiency = 1.2, color = Color3.fromRGB(50, 150, 50)},
    Desert = {efficiency = 0.8, color = Color3.fromRGB(255, 200, 100)}, 
    Snow = {efficiency = 0.9, color = Color3.fromRGB(200, 200, 255)},
    Volcano = {efficiency = 1.5, color = Color3.fromRGB(255, 100, 50)}
}

-- 👑 ADMIN FLOAT DOWN EFFECT
function SharedWorld:AdminFloatDown(adminPlayer)
    local character = adminPlayer.Character
    if not character then return end
    
    -- Create floating platform
    local platform = Instance.new("Part")
    platform.Name = "AdminPlatform"
    platform.Size = Vector3.new(6, 1, 6)
    platform.Material = Enum.Material.ForceField
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.CanCollide = true
    platform.Anchored = true
    platform.Position = Vector3.new(0, 200, 0)
    platform.Parent = workspace
    
    -- Teleport admin to platform
    character:SetPrimaryPartCFrame(CFrame.new(0, 205, 0))
    
    -- Float down animation
    local tween = TweenService:Create(platform, TweenInfo.new(3, Enum.EasingStyle.Sine), {Position = Vector3.new(0, 10, 0)})
    tween:Play()
    
    -- Move character with platform
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if character.PrimaryPart then
            character:SetPrimaryPartCFrame(CFrame.new(platform.Position + Vector3.new(0, 5, 0)))
        else
            connection:Disconnect()
        end
    end)
    
    -- Clean up after landing
    tween.Completed:Connect(function()
        wait(2)
        platform:Destroy()
        connection:Disconnect()
        
        -- 🏅 Enable Chicken Finger Badge earning
        SharedWorld:EnableChickenBadge(adminPlayer)
    end)
end

-- 🏅 CHICKEN FINGER BADGE SYSTEM
function SharedWorld:EnableChickenBadge(adminPlayer)
    local badge = Instance.new("BoolValue")
    badge.Name = "ChickenBadgeActive"
    badge.Value = true
    badge.Parent = adminPlayer
    
    local character = adminPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Jumped:Connect(function()
                -- Check if other players are nearby
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= adminPlayer and player.Character then
                        local distance = (player.Character.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude
                        if distance < 10 then
                            SharedWorld:AwardChickenBadge(player)
                        end
                    end
                end
            end)
        end
    end
    
    -- Badge expires after 30 seconds
    wait(30)
    badge:Destroy()
end

function SharedWorld:AwardChickenBadge(player)
    -- Award the chicken finger badge
    local badge = Instance.new("StringValue")
    badge.Name = "ChickenFingerBadge"
    badge.Value = "🏅 Chicken Finger Champion!"
    badge.Parent = player
    
    print(player.Name .. " earned the Chicken Finger Badge! 🏅")
end

-- 🌪️ RANDOM EVENTS SYSTEM
SharedWorld.Events = {
    SolarStorm = function()
        print("🌞 Solar Storm! Solar panels +50% efficiency!")
        -- Boost solar panel efficiency logic here
    end,
    
    VolcanicEruption = function()
        print("🌋 Volcanic Eruption! Fuel costs increased!")
        -- Increase fuel costs logic here
    end,
    
    TechBoom = function()
        print("💻 Tech Boom! Electronics sell for double!")
        -- Double electronics value logic here
    end
}

function SharedWorld:TriggerRandomEvent()
    local events = {"SolarStorm", "VolcanicEruption", "TechBoom"}
    local randomEvent = events[math.random(1, #events)]
    SharedWorld.Events[randomEvent]()
end

return SharedWorld
]]
    
    sharedWorldModule.Source = sharedWorldCode
    print("🏗️ SharedWorld System created!")
end

-- 🧪 SANDBOX+ SYSTEM  
function TycoonLoader:CreateSandboxSystem()
    local sandboxModule = Instance.new("ModuleScript")
    sandboxModule.Name = "SandboxPlusSystem"
    sandboxModule.Parent = ServerStorage
    
    local sandboxCode = [[
local SandboxPlus = {}
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

-- 🎫 GAMEPASS VERIFICATION
local SANDBOX_GAMEPASS_ID = ]] .. CONFIG.SANDBOX_GAMEPASS_ID .. [[

function SandboxPlus:HasGamepass(player)
    local success, hasGamepass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, SANDBOX_GAMEPASS_ID)
    end)
    return success and hasGamepass
end

-- ⚡ TIME ACCELERATION
SandboxPlus.TimeMultiplier = 1

function SandboxPlus:SetTimeAcceleration(multiplier)
    SandboxPlus.TimeMultiplier = multiplier
    print("⚡ Time acceleration set to " .. multiplier .. "x")
end

-- 🌱 POLLUTION TOGGLE
SandboxPlus.PollutionEnabled = true

function SandboxPlus:TogglePollution(enabled)
    SandboxPlus.PollutionEnabled = enabled
    local status = enabled and "ON" or "OFF" 
    print("🌱 Pollution effects: " .. status)
end

-- 🎁 ITEM SPAWNING
SandboxPlus.SpawnableItems = {
    "Conveyor Belt", "Solar Panel", "Battery", "Factory Machine",
    "Resource Generator", "Money Printer", "Auto Sorter"
}

function SandboxPlus:SpawnItem(player, itemName, position)
    if not SandboxPlus:HasGamepass(player) then
        return false, "❌ Sandbox+ Gamepass required!"
    end
    
    if not table.find(SandboxPlus.SpawnableItems, itemName) then
        return false, "❌ Invalid item name!"
    end
    
    -- Create the item (placeholder logic)
    local item = Instance.new("Part")
    item.Name = itemName
    item.Size = Vector3.new(4, 4, 4)
    item.Material = Enum.Material.Neon
    item.BrickColor = BrickColor.random()
    item.Position = position or Vector3.new(0, 10, 0)
    item.Parent = workspace
    
    return true, "✅ " .. itemName .. " spawned!"
end

-- 👑 ADMIN OVERRIDE TOOLS
function SandboxPlus:AdminGiveMoney(adminPlayer, amount)
    local AdminSystem = require(game.ServerStorage.AdminSystem)
    if not AdminSystem:IsAdmin(adminPlayer) then return false end
    
    local leaderstats = adminPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        leaderstats["Cash 💸"].Value = leaderstats["Cash 💸"].Value + amount
        return true
    end
    return false
end

function SandboxPlus:ChargeAllBatteries(adminPlayer)
    local AdminSystem = require(game.ServerStorage.AdminSystem)
    if not AdminSystem:IsAdmin(adminPlayer) then return false end
    
    -- Find all batteries in workspace and charge them
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:find("Battery") and obj:FindFirstChild("Charge") then
            obj.Charge.Value = 100
        end
    end
    
    print("🔋 All batteries charged by admin: " .. adminPlayer.Name)
    return true
end

return SandboxPlus
]]
    
    sandboxModule.Source = sandboxCode
    print("🧪 Sandbox+ System created!")
end

-- 🔥 BONUS SYSTEMS
function TycoonLoader:CreateBonusSystems()
    local bonusModule = Instance.new("ModuleScript") 
    bonusModule.Name = "BonusSystems"
    bonusModule.Parent = ServerStorage
    
    local bonusCode = [[
local BonusSystems = {}
local Players = game:GetService("Players")

-- 🤖 AUTO-FIXER ROBOT
BonusSystems.AutoFixers = {}

function BonusSystems:BuyAutoFixer(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return false end
    
    local cash = leaderstats["Cash 💸"]
    if cash.Value < 1000000 then
        return false, "❌ Need $1,000,000 for Auto-Fixer Robot!"
    end
    
    cash.Value = cash.Value - 1000000
    BonusSystems.AutoFixers[player.UserId] = true
    
    -- Start auto-fixing
    BonusSystems:StartAutoFixer(player)
    return true, "✅ Auto-Fixer Robot purchased!"
end

function BonusSystems:StartAutoFixer(player)
    spawn(function()
        while BonusSystems.AutoFixers[player.UserId] and player.Parent do
            wait(10) -- Check every 10 seconds
            
            -- Find broken machines (placeholder logic)
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:find("Machine") and obj:FindFirstChild("Broken") and obj.Broken.Value then
                    obj.Broken.Value = false
                    print("🔧 Auto-Fixer repaired " .. obj.Name)
                end
            end
        end
    end)
end

-- 📊 RESOURCE FLOW GRAPH
function BonusSystems:GenerateResourceFlow(player)
    local flowData = {
        nodes = {},
        connections = {}
    }
    
    -- Analyze player's factory (placeholder)
    local playerPlot = workspace:FindFirstChild(player.Name .. "_Plot")
    if playerPlot then
        for _, machine in pairs(playerPlot:GetChildren()) do
            if machine.Name:find("Machine") then
                table.insert(flowData.nodes, {
                    name = machine.Name,
                    position = machine.Position,
                    type = "Machine"
                })
            end
        end
    end
    
    return flowData
end

-- 🏆 ECO SCORE SYSTEM
BonusSystems.EcoScores = {}

function BonusSystems:CalculateEcoScore(player)
    local score = 100 -- Base score
    
    -- Deduct for pollution
    local pollution = BonusSystems:GetPlayerPollution(player)
    score = score - (pollution * 10)
    
    -- Add for renewable energy
    local renewableEnergy = BonusSystems:GetRenewableEnergyUsage(player)
    score = score + (renewableEnergy * 5)
    
    BonusSystems.EcoScores[player.UserId] = math.max(0, math.min(100, score))
    return BonusSystems.EcoScores[player.UserId]
end

function BonusSystems:GetPlayerPollution(player)
    -- Placeholder pollution calculation
    return math.random(0, 10)
end

function BonusSystems:GetRenewableEnergyUsage(player)
    -- Placeholder renewable energy calculation
    return math.random(0, 20)
end

-- 🌟 PUBLIC ISLAND SHOWCASE
BonusSystems.PublicIslands = {}

function BonusSystems:SetIslandPublic(player, isPublic)
    BonusSystems.PublicIslands[player.UserId] = {
        isPublic = isPublic,
        rating = 0,
        votes = 0,
        adminApproved = false
    }
    
    return true
end

function BonusSystems:RateIsland(raterPlayer, targetUserId, rating)
    local island = BonusSystems.PublicIslands[targetUserId]
    if not island or not island.isPublic then return false end
    
    -- Update rating
    island.votes = island.votes + 1
    island.rating = ((island.rating * (island.votes - 1)) + rating) / island.votes
    
    -- Check for admin approval
    local AdminSystem = require(game.ServerStorage.AdminSystem)
    if AdminSystem:IsAdmin(raterPlayer) and rating == 5 then
        island.adminApproved = true
        print("⭐ Admin approved island of player ID: " .. targetUserId)
    end
    
    return true
end

return BonusSystems
]]
    
    bonusModule.Source = bonusCode
    print("🔥 Bonus Systems created!")
end

-- 🎮 REMOTE EVENT HANDLERS
function TycoonLoader:SetupRemoteHandlers()
    local handlerScript = Instance.new("Script")
    handlerScript.Name = "RemoteEventHandlers"
    handlerScript.Parent = ServerStorage
    
    local handlerCode = [[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

-- Module references
local AdminSystem = require(script.Parent.AdminSystem)
local SharedWorld = require(script.Parent.SharedWorldSystem)
local SandboxPlus = require(script.Parent.SandboxPlusSystem)
local BonusSystems = require(script.Parent.BonusSystems)

local remotes = ReplicatedStorage.TycoonRemotes

-- 🏛️ MAIN HUB HANDLERS
remotes.TeleportToWorld.OnServerEvent:Connect(function(player, worldType)
    if worldType == "SharedWorld" then
        print(player.Name .. " teleporting to SharedWorld")
        -- Teleport logic here
    elseif worldType == "SandboxPlus" then
        if SandboxPlus:HasGamepass(player) then
            print(player.Name .. " teleporting to Sandbox+")
            -- Teleport logic here
        else
            -- Prompt gamepass purchase
            game:GetService("MarketplaceService"):PromptGamePassPurchase(player, ]] .. CONFIG.SANDBOX_GAMEPASS_ID .. [[)
        end
    end
end)

remotes.BroadcastMessage.OnServerEvent:Connect(function(player, message)
    if AdminSystem:IsAdmin(player) then
        for _, p in pairs(Players:GetPlayers()) do
            -- Send message to all players
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = "📢 [ADMIN] " .. player.Name .. ": " .. message;
                Color = Color3.new(1, 0.5, 0);
                Font = Enum.Font.GothamBold;
                FontSize = Enum.FontSize.Size18;
            })
        end
    end
end)

remotes.GiveMoney.OnServerEvent:Connect(function(adminPlayer, targetPlayer, amount)
    if AdminSystem:IsAdmin(adminPlayer) and targetPlayer then
        local leaderstats = targetPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            leaderstats["Cash 💸"].Value = leaderstats["Cash 💸"].Value + amount
            print("💰 " .. adminPlayer.Name .. " gave $" .. amount .. " to " .. targetPlayer.Name)
        end
    end
end)

-- 🏗️ SHARED WORLD HANDLERS
remotes.AdminFloatDown.OnServerEvent:Connect(function(player)
    if AdminSystem:IsAdmin(player) then
        SharedWorld:AdminFloatDown(player)
    end
end)

remotes.TriggerRandomEvent.OnServerEvent:Connect(function(player)
    if AdminSystem:IsAdmin(player) then
        SharedWorld:TriggerRandomEvent()
    end
end)

-- 🧪 SANDBOX+ HANDLERS
remotes.SpawnItem.OnServerEvent:Connect(function(player, itemName, position)
    local success, message = SandboxPlus:SpawnItem(player, itemName, position)
    -- Send result back to player
end)

remotes.TimeAcceleration.OnServerEvent:Connect(function(player, multiplier)
    if SandboxPlus:HasGamepass(player) then
        SandboxPlus:SetTimeAcceleration(multiplier)
    end
end)

-- 🔥 BONUS SYSTEM HANDLERS
remotes.BuyAutoFixer.OnServerEvent:Connect(function(player)
    local success, message = BonusSystems:BuyAutoFixer(player)
    -- Send result back to player
end)

remotes.UpdateEcoScore.OnServerEvent:Connect(function(player)
    local score = BonusSystems:CalculateEcoScore(player)
    -- Update player's eco score display
end)

-- 📊 REMOTE FUNCTIONS
remotes.GetPlayerData.OnServerInvoke = function(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        return {
            Cash = leaderstats["Cash 💸"].Value,
            Power = leaderstats["Power 🔋"].Value,
            EcoScore = BonusSystems.EcoScores[player.UserId] or 0
        }
    end
    return {}
end

remotes.CheckGamepassOwnership.OnServerInvoke = function(player)
    return SandboxPlus:HasGamepass(player)
end

print("🎮 Remote Event Handlers setup complete!")
]]
    
    handlerScript.Source = handlerCode
    print("🎮 Remote Event Handlers created!")
end

-- 📱 CLIENT-SIDE UI SCRIPTS
function TycoonLoader:CreateClientScripts()
    local clientScript = Instance.new("LocalScript")
    clientScript.Name = "TycoonClientMain"
    clientScript.Parent = ReplicatedStorage.TycoonGUIs.MainHubUI
    
    local clientCode = [[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("TycoonRemotes")
local mainGui = script.Parent

-- 🎮 UI INITIALIZATION
local mainFrame = mainGui:WaitForChild("MainFrame")
local isGuiOpen = false

-- Toggle GUI with G key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        isGuiOpen = not isGuiOpen
        local targetPosition = isGuiOpen and UDim2.new(0.5, -200, 0.5, -250) or UDim2.new(0.5, -200, -1, 0)
        
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = targetPosition})
        tween:Play()
    end
end)

-- 🌍 BUTTON CONNECTIONS
local sharedWorldBtn = mainFrame:WaitForChild("SharedWorldButton")
local sandboxBtn = mainFrame:WaitForChild("SandboxPlusButton")
local settingsBtn = mainFrame:WaitForChild("SettingsButton")
local adminBtn = mainFrame:WaitForChild("AdminButton")

sharedWorldBtn.MouseButton1Click:Connect(function()
    remotes.TeleportToWorld:FireServer("SharedWorld")
end)

sandboxBtn.MouseButton1Click:Connect(function()
    remotes.TeleportToWorld:FireServer("SandboxPlus")
end)

settingsBtn.MouseButton1Click:Connect(function()
    -- Open settings menu
    print("⚙️ Settings menu opened")
end)

adminBtn.MouseButton1Click:Connect(function()
    -- Open admin panel
    remotes.OpenAdminPanel:FireServer()
end)

-- 🎨 STARTUP ANIMATION
spawn(function()
    wait(1)
    mainFrame.Position = UDim2.new(0.5, -200, -1, 0)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(1, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -200, 0.5, -250)})
    tween:Play()
    isGuiOpen = true
end)

print("🎨 Client UI initialized!")
]]
    
    clientScript.Source = clientCode
    print("📱 Client Scripts created!")
end

-- 🚀 MAIN LOADER EXECUTION
function TycoonLoader:Initialize()
    print("🌟 TYCOON ENGINE v" .. CONFIG.VERSION .. " - INITIALIZING...")
    print("👑 Superadmin: " .. CONFIG.SUPERADMIN_ID)
    
    -- Create all systems
    self:CreateRemoteEvents()
    self:CreateAdminSystem()
    self:CreateLeaderstats()
    self:CreateMainUI()
    self:CreateSharedWorldSystem()
    self:CreateSandboxSystem()
    self:CreateBonusSystems()
    self:SetupRemoteHandlers()
    self:CreateClientScripts()
    
    print("✅ TYCOON ENGINE FULLY LOADED!")
    print("🎮 Press G in-game to open main menu")
    print("👑 Admin tools ready for superadmin")
    print("🌍 3 worlds: Main Hub ↔ SharedWorld ↔ Sandbox+")
    
    -- 💀 SELF-DESTRUCT (optional)
    if not CONFIG.DEBUG_MODE then
        wait(5)
        print("💀 Self-destructing loader...")
        script:Destroy()
    end
end

-- 🚀 START THE ENGINE
TycoonLoader:Initialize()

return TycoonLoader