--[[
🛡️ ANTI-KICK MOD INTEGRATION FOR TYCOON ENGINE 🛡️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌟 INTEGRATION FEATURES:
✅ Adds anti-kick mod to existing tycoon engine
✅ Creates necessary remote events
✅ Integrates with admin system
✅ Adds configuration options
✅ Maintains compatibility with all existing features

🎯 USAGE:
1. Place this script in ServerStorage
2. Run the game once to integrate the mod
3. The mod will be automatically added to the tycoon engine

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--]]

-- 🎯 CORE SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local DataStoreService = game:GetService("DataStoreService")

-- ⚙️ ANTI-KICK CONFIGURATION
local ANTI_KICK_CONFIG = {
    ENABLED = true,
    CHECK_INTERVAL = 30,               -- How often to check for inactivity (seconds)
    INACTIVITY_THRESHOLD = 900,        -- 15 minutes before anti-kick activates
    MOVEMENT_INTERVAL = 10,            -- How often to move camera (seconds)
    MOVEMENT_DURATION = 2,             -- How long each movement lasts (seconds)
    MOVEMENT_INTENSITY = 0.5,          -- How much to move camera (0.1 = subtle, 2.0 = obvious)
    ENABLE_LOGGING = false,            -- Log anti-kick activities to console
    MOVEMENT_PATTERNS = {              -- Different camera movement patterns
        "gentle_sway",                 -- Gentle side-to-side sway
        "micro_zoom",                  -- Slight zoom in/out
        "rotation_tilt",               -- Subtle rotation
        "position_shift"               -- Small position adjustment
    }
}

print("🛡️ ANTI-KICK MOD INTEGRATION: Starting integration process...")

-- 📊 CREATE ANTI-KICK DATA STORE
local AntiKickDataStore = DataStoreService:GetDataStore("AntiKickModData_v1")

-- 📡 CREATE ANTI-KICK REMOTE EVENTS
local function CreateAntiKickRemotes()
    local remoteFolder = ReplicatedStorage:FindFirstChild("MegaTycoonRemotes")
    if not remoteFolder then
        print("🛡️ ANTI-KICK MOD: Creating MegaTycoonRemotes folder...")
        remoteFolder = Instance.new("Folder")
        remoteFolder.Name = "MegaTycoonRemotes"
        remoteFolder.Parent = ReplicatedStorage
    end
    
    -- Create anti-kick specific remote events
    local antiKickRemotes = {
        "PlayerActivity",      -- Client reports activity to server
        "CameraMovement",      -- Server tells client to move camera
        "AntiKickToggle",      -- Server toggles anti-kick for client
        "AntiKickCommand",     -- Admin commands for anti-kick
        "AntiKickDebug"        -- Debug commands for testing
    }
    
    for _, remoteName in ipairs(antiKickRemotes) do
        if not remoteFolder:FindFirstChild(remoteName) then
            local remoteEvent = Instance.new("RemoteEvent")
            remoteEvent.Name = remoteName
            remoteEvent.Parent = remoteFolder
            print("🛡️ ANTI-KICK MOD: Created remote event: " .. remoteName)
        end
    end
end

-- 🎯 ANTI-KICK SYSTEM
local AntiKickSystem = {}

-- 📊 PLAYER DATA TRACKING
local PlayerData = {}

function AntiKickSystem:Initialize()
    if not ANTI_KICK_CONFIG.ENABLED then
        print("🛡️ ANTI-KICK MOD: Disabled in configuration")
        return
    end
    
    print("🛡️ ANTI-KICK MOD: Initializing integration...")
    
    -- Create remote events
    CreateAntiKickRemotes()
    
    -- Set up player tracking
    self:SetupPlayerTracking()
    
    -- Set up remote event handlers
    self:SetupRemoteHandlers()
    
    -- Start the main loop
    self:StartMainLoop()
    
    print("🛡️ ANTI-KICK MOD: Integration completed successfully")
end

function AntiKickSystem:SetupPlayerTracking()
    -- Track new players
    Players.PlayerAdded:Connect(function(player)
        self:InitializePlayer(player)
    end)
    
    -- Track leaving players
    Players.PlayerRemoving:Connect(function(player)
        self:CleanupPlayer(player)
    end)
    
    -- Initialize existing players
    for _, player in ipairs(Players:GetPlayers()) do
        self:InitializePlayer(player)
    end
end

function AntiKickSystem:InitializePlayer(player)
    PlayerData[player.UserId] = {
        lastActivity = tick(),
        lastInput = tick(),
        isActive = true,
        cameraMovementActive = false,
        currentTween = nil
    }
    
    if ANTI_KICK_CONFIG.ENABLE_LOGGING then
        print("🛡️ ANTI-KICK MOD: Tracking player " .. player.Name)
    end
end

function AntiKickSystem:CleanupPlayer(player)
    local data = PlayerData[player.UserId]
    if data and data.currentTween then
        data.currentTween:Cancel()
    end
    PlayerData[player.UserId] = nil
    
    if ANTI_KICK_CONFIG.ENABLE_LOGGING then
        print("🛡️ ANTI-KICK MOD: Stopped tracking player " .. player.Name)
    end
end

function AntiKickSystem:UpdatePlayerActivity(player)
    local data = PlayerData[player.UserId]
    if data then
        data.lastActivity = tick()
        data.lastInput = tick()
        data.isActive = true
    end
end

function AntiKickSystem:SetupRemoteHandlers()
    local remoteFolder = ReplicatedStorage:FindFirstChild("MegaTycoonRemotes")
    if not remoteFolder then return end
    
    -- Handle player activity reports
    local activityRemote = remoteFolder:FindFirstChild("PlayerActivity")
    if activityRemote then
        activityRemote.OnServerEvent:Connect(function(player)
            self:UpdatePlayerActivity(player)
        end)
    end
    
    -- Handle admin commands
    local commandRemote = remoteFolder:FindFirstChild("AntiKickCommand")
    if commandRemote then
        commandRemote.OnServerEvent:Connect(function(player, command, ...)
            self:HandleAdminCommand(player, command, ...)
        end)
    end
    
    -- Handle debug commands
    local debugRemote = remoteFolder:FindFirstChild("AntiKickDebug")
    if debugRemote then
        debugRemote.OnServerEvent:Connect(function(player, command, ...)
            self:HandleDebugCommand(player, command, ...)
        end)
    end
end

function AntiKickSystem:HandleAdminCommand(player, command, ...)
    local args = {...}
    
    -- Check if player is admin (integrate with your admin system)
    local isAdmin = self:IsPlayerAdmin(player)
    
    if not isAdmin then
        print("🛡️ ANTI-KICK MOD: Non-admin " .. player.Name .. " attempted command: " .. command)
        return
    end
    
    if command == "stats" then
        self:ShowStats(player)
    elseif command == "toggle" then
        ANTI_KICK_CONFIG.ENABLED = not ANTI_KICK_CONFIG.ENABLED
        print("🛡️ ANTI-KICK MOD: " .. (ANTI_KICK_CONFIG.ENABLED and "Enabled" or "Disabled") .. " by " .. player.Name)
    elseif command == "config" then
        self:ShowConfig(player)
    elseif command == "protect" then
        local targetPlayer = args[1]
        if targetPlayer then
            self:ForceProtectPlayer(targetPlayer)
        end
    elseif command == "unprotect" then
        local targetPlayer = args[1]
        if targetPlayer then
            self:ForceUnprotectPlayer(targetPlayer)
        end
    end
end

function AntiKickSystem:HandleDebugCommand(player, command, ...)
    local args = {...}
    
    if command == "test_movement" then
        local pattern = args[1] or "gentle_sway"
        self:TestCameraMovement(player, pattern)
    elseif command == "toggle_logging" then
        ANTI_KICK_CONFIG.ENABLE_LOGGING = not ANTI_KICK_CONFIG.ENABLE_LOGGING
        print("🛡️ ANTI-KICK MOD: Logging " .. (ANTI_KICK_CONFIG.ENABLE_LOGGING and "enabled" or "disabled") .. " by " .. player.Name)
    elseif command == "get_stats" then
        self:ShowPlayerStats(player)
    end
end

function AntiKickSystem:IsPlayerAdmin(player)
    -- Integrate with your existing admin system
    -- For now, we'll use a simple check
    local adminIds = {123456789} -- Add your admin user IDs here
    
    for _, adminId in ipairs(adminIds) do
        if player.UserId == adminId then
            return true
        end
    end
    
    return false
end

function AntiKickSystem:ShowStats(player)
    local stats = {
        totalPlayers = #Players:GetPlayers(),
        protectedPlayers = 0,
        activePlayers = 0
    }
    
    for userId, data in pairs(PlayerData) do
        if data.cameraMovementActive then
            stats.protectedPlayers = stats.protectedPlayers + 1
        end
        if data.isActive then
            stats.activePlayers = stats.activePlayers + 1
        end
    end
    
    print("🛡️ ANTI-KICK MOD Statistics:")
    print("   Total Players: " .. stats.totalPlayers)
    print("   Protected Players: " .. stats.protectedPlayers)
    print("   Active Players: " .. stats.activePlayers)
    print("   Mod Enabled: " .. tostring(ANTI_KICK_CONFIG.ENABLED))
end

function AntiKickSystem:ShowConfig(player)
    print("🛡️ ANTI-KICK MOD Configuration:")
    for key, value in pairs(ANTI_KICK_CONFIG) do
        print("   " .. key .. ": " .. tostring(value))
    end
end

function AntiKickSystem:ShowPlayerStats(player)
    local data = PlayerData[player.UserId]
    if data then
        local timeSinceActivity = tick() - data.lastActivity
        print("🛡️ ANTI-KICK MOD Player Stats for " .. player.Name .. ":")
        print("   Last Activity: " .. math.floor(timeSinceActivity) .. " seconds ago")
        print("   Camera Active: " .. tostring(data.cameraMovementActive))
        print("   Is Active: " .. tostring(data.isActive))
    end
end

function AntiKickSystem:TestCameraMovement(player, pattern)
    local remoteFolder = ReplicatedStorage:FindFirstChild("MegaTycoonRemotes")
    if remoteFolder then
        local cameraRemote = remoteFolder:FindFirstChild("CameraMovement")
        if cameraRemote then
            cameraRemote:FireClient(player, pattern, ANTI_KICK_CONFIG.MOVEMENT_INTENSITY)
            print("🛡️ ANTI-KICK MOD: Tested " .. pattern .. " movement for " .. player.Name)
        end
    end
end

function AntiKickSystem:ForceProtectPlayer(player)
    local data = PlayerData[player.UserId]
    if data then
        data.cameraMovementActive = true
        self:ActivateAntiKick(player, data)
        print("🛡️ ANTI-KICK MOD: Force protected " .. player.Name)
    end
end

function AntiKickSystem:ForceUnprotectPlayer(player)
    local data = PlayerData[player.UserId]
    if data then
        data.cameraMovementActive = false
        self:DeactivateAntiKick(player, data)
        print("🛡️ ANTI-KICK MOD: Force unprotect " .. player.Name)
    end
end

function AntiKickSystem:StartMainLoop()
    spawn(function()
        while true do
            if ANTI_KICK_CONFIG.ENABLED then
                self:CheckAllPlayers()
            end
            wait(ANTI_KICK_CONFIG.CHECK_INTERVAL)
        end
    end)
end

function AntiKickSystem:CheckAllPlayers()
    local currentTime = tick()
    
    for userId, data in pairs(PlayerData) do
        local player = Players:GetPlayerByUserId(userId)
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            local timeSinceActivity = currentTime - data.lastActivity
            
            -- Check if player has been inactive for threshold
            if timeSinceActivity >= ANTI_KICK_CONFIG.INACTIVITY_THRESHOLD and not data.cameraMovementActive then
                self:ActivateAntiKick(player, data)
            end
            
            -- Check if we should stop anti-kick (player became active again)
            if data.cameraMovementActive and (currentTime - data.lastInput) < ANTI_KICK_CONFIG.INACTIVITY_THRESHOLD then
                self:DeactivateAntiKick(player, data)
            end
        end
    end
end

function AntiKickSystem:ActivateAntiKick(player, data)
    if ANTI_KICK_CONFIG.ENABLE_LOGGING then
        print("🛡️ ANTI-KICK MOD: Activating for " .. player.Name .. " (inactive for " .. math.floor((tick() - data.lastActivity) / 60) .. " minutes)")
    end
    
    data.cameraMovementActive = true
    
    -- Notify client to start camera movement
    local remoteFolder = ReplicatedStorage:FindFirstChild("MegaTycoonRemotes")
    if remoteFolder then
        local toggleRemote = remoteFolder:FindFirstChild("AntiKickToggle")
        if toggleRemote then
            toggleRemote:FireClient(player, true)
        end
    end
end

function AntiKickSystem:DeactivateAntiKick(player, data)
    if ANTI_KICK_CONFIG.ENABLE_LOGGING then
        print("🛡️ ANTI-KICK MOD: Deactivating for " .. player.Name .. " (player became active)")
    end
    
    data.cameraMovementActive = false
    
    -- Notify client to stop camera movement
    local remoteFolder = ReplicatedStorage:FindFirstChild("MegaTycoonRemotes")
    if remoteFolder then
        local toggleRemote = remoteFolder:FindFirstChild("AntiKickToggle")
        if toggleRemote then
            toggleRemote:FireClient(player, false)
        end
    end
end

-- 🚀 INTEGRATION WITH EXISTING TYCOON ENGINE
local function IntegrateWithTycoonEngine()
    -- Check if tycoon engine is loaded
    local tycoonLoader = ServerStorage:FindFirstChild("TycoonGameLoader")
    if tycoonLoader then
        print("🛡️ ANTI-KICK MOD: Found existing tycoon engine, integrating...")
        
        -- Add anti-kick configuration to existing engine
        local antiKickModule = Instance.new("ModuleScript")
        antiKickModule.Name = "AntiKickMod"
        antiKickModule.Parent = ServerStorage
        
        -- Create the anti-kick module source
        antiKickModule.Source = [[
-- Anti-Kick Mod Module for Tycoon Engine
local AntiKickMod = {}

AntiKickMod.Config = ]] .. HttpService:JSONEncode(ANTI_KICK_CONFIG) .. [[

return AntiKickMod
]]
        
        print("🛡️ ANTI-KICK MOD: Created integration module")
    else
        print("🛡️ ANTI-KICK MOD: No existing tycoon engine found, running standalone")
    end
end

-- 🎯 FINAL INITIALIZATION
if RunService:IsServer() then
    IntegrateWithTycoonEngine()
    AntiKickSystem:Initialize()
    
    -- Print startup message
    print("🛡️ ANTI-KICK MOD INTEGRATION COMPLETE")
    print("   Protection Threshold: " .. ANTI_KICK_CONFIG.INACTIVITY_THRESHOLD / 60 .. " minutes")
    print("   Movement Interval: " .. ANTI_KICK_CONFIG.MOVEMENT_INTERVAL .. " seconds")
    print("   Movement Intensity: " .. ANTI_KICK_CONFIG.MOVEMENT_INTENSITY)
    print("   Enabled: " .. tostring(ANTI_KICK_CONFIG.ENABLED))
    print("   Integration: " .. (ServerStorage:FindFirstChild("TycoonGameLoader") and "With Tycoon Engine" or "Standalone"))
end

return AntiKickSystem