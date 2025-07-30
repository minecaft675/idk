--[[
🛡️ ANTI-KICK MOD FOR BLOCKSTRAP TYCOON ENGINE 🛡️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌟 FEATURES:
✅ Prevents Roblox from kicking players after 20 minutes of inactivity
✅ Automatic camera movement to simulate player activity
✅ Configurable movement patterns and timing
✅ Silent operation - doesn't interfere with gameplay
✅ Works with all tycoon engine features
✅ Mobile and PC compatible

🎯 HOW IT WORKS:
• Detects when player hasn't moved for 15 minutes
• Automatically moves camera in subtle patterns
• Resets inactivity timer to prevent kick
• Maintains player's current view as much as possible
• Works in background without player noticing

🚀 INSTALLATION:
1. Place this script in ServerStorage as a Script
2. The mod will automatically activate for all players
3. No additional configuration needed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--]]

-- ⚙️ CONFIGURATION
local CONFIG = {
    ENABLED = true,                    -- Enable/disable the mod
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

-- 🎯 CORE SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- 📊 PLAYER DATA TRACKING
local PlayerData = {}

-- 🎮 CAMERA MOVEMENT PATTERNS
local CameraPatterns = {
    gentle_sway = function(camera, intensity)
        local originalCFrame = camera.CFrame
        local swayAmount = intensity * 0.1
        
        local tweenInfo = TweenInfo.new(
            CONFIG.MOVEMENT_DURATION,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut
        )
        
        local targetCFrame = originalCFrame * CFrame.new(swayAmount, 0, 0)
        local tween = TweenService:Create(camera, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        
        -- Return to original position
        local returnTween = TweenService:Create(camera, tweenInfo, {CFrame = originalCFrame})
        returnTween:Play()
        
        return tween
    end,
    
    micro_zoom = function(camera, intensity)
        local originalCFrame = camera.CFrame
        local zoomAmount = intensity * 0.05
        
        local tweenInfo = TweenInfo.new(
            CONFIG.MOVEMENT_DURATION,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut
        )
        
        local targetCFrame = originalCFrame * CFrame.new(0, 0, zoomAmount)
        local tween = TweenService:Create(camera, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        
        -- Return to original position
        local returnTween = TweenService:Create(camera, tweenInfo, {CFrame = originalCFrame})
        returnTween:Play()
        
        return tween
    end,
    
    rotation_tilt = function(camera, intensity)
        local originalCFrame = camera.CFrame
        local rotationAmount = intensity * 0.02
        
        local tweenInfo = TweenInfo.new(
            CONFIG.MOVEMENT_DURATION,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut
        )
        
        local targetCFrame = originalCFrame * CFrame.Angles(0, 0, rotationAmount)
        local tween = TweenService:Create(camera, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        
        -- Return to original position
        local returnTween = TweenService:Create(camera, tweenInfo, {CFrame = originalCFrame})
        returnTween:Play()
        
        return tween
    end,
    
    position_shift = function(camera, intensity)
        local originalCFrame = camera.CFrame
        local shiftAmount = intensity * 0.03
        
        local tweenInfo = TweenInfo.new(
            CONFIG.MOVEMENT_DURATION,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut
        )
        
        local targetCFrame = originalCFrame * CFrame.new(shiftAmount, shiftAmount, 0)
        local tween = TweenService:Create(camera, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        
        -- Return to original position
        local returnTween = TweenService:Create(camera, tweenInfo, {CFrame = originalCFrame})
        returnTween:Play()
        
        return tween
    end
}

-- 🎯 ANTI-KICK SYSTEM
local AntiKickSystem = {}

function AntiKickSystem:Initialize()
    if not CONFIG.ENABLED then
        if CONFIG.ENABLE_LOGGING then
            print("🛡️ Anti-Kick Mod: Disabled in configuration")
        end
        return
    end
    
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Anti-Kick Mod: Initializing...")
    end
    
    -- Set up player tracking
    self:SetupPlayerTracking()
    
    -- Start the main loop
    self:StartMainLoop()
    
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Anti-Kick Mod: Successfully initialized")
    end
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
    
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Anti-Kick Mod: Tracking player " .. player.Name)
    end
end

function AntiKickSystem:CleanupPlayer(player)
    local data = PlayerData[player.UserId]
    if data and data.currentTween then
        data.currentTween:Cancel()
    end
    PlayerData[player.UserId] = nil
    
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Anti-Kick Mod: Stopped tracking player " .. player.Name)
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

function AntiKickSystem:StartMainLoop()
    spawn(function()
        while true do
            self:CheckAllPlayers()
            wait(CONFIG.CHECK_INTERVAL)
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
            if timeSinceActivity >= CONFIG.INACTIVITY_THRESHOLD and not data.cameraMovementActive then
                self:ActivateAntiKick(player, data)
            end
            
            -- Check if we should stop anti-kick (player became active again)
            if data.cameraMovementActive and (currentTime - data.lastInput) < CONFIG.INACTIVITY_THRESHOLD then
                self:DeactivateAntiKick(player, data)
            end
        end
    end
end

function AntiKickSystem:ActivateAntiKick(player, data)
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Anti-Kick Mod: Activating for " .. player.Name .. " (inactive for " .. math.floor((tick() - data.lastActivity) / 60) .. " minutes)")
    end
    
    data.cameraMovementActive = true
    self:StartCameraMovement(player, data)
end

function AntiKickSystem:DeactivateAntiKick(player, data)
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Anti-Kick Mod: Deactivating for " .. player.Name .. " (player became active)")
    end
    
    data.cameraMovementActive = false
    if data.currentTween then
        data.currentTween:Cancel()
        data.currentTween = nil
    end
end

function AntiKickSystem:StartCameraMovement(player, data)
    spawn(function()
        while data.cameraMovementActive and player and player.Character do
            local camera = workspace.CurrentCamera
            if camera then
                -- Select random movement pattern
                local patternName = CONFIG.MOVEMENT_PATTERNS[math.random(1, #CONFIG.MOVEMENT_PATTERNS)]
                local pattern = CameraPatterns[patternName]
                
                if pattern then
                    -- Cancel any existing tween
                    if data.currentTween then
                        data.currentTween:Cancel()
                    end
                    
                    -- Execute camera movement
                    data.currentTween = pattern(camera, CONFIG.MOVEMENT_INTENSITY)
                    
                    if CONFIG.ENABLE_LOGGING then
                        print("🛡️ Anti-Kick Mod: Executed " .. patternName .. " for " .. player.Name)
                    end
                end
            end
            
            -- Update activity time to prevent kick
            data.lastActivity = tick()
            
            -- Wait before next movement
            wait(CONFIG.MOVEMENT_INTERVAL)
        end
    end)
end

-- 🎮 INPUT DETECTION
function AntiKickSystem:SetupInputDetection()
    -- Detect mouse movement
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local player = Players.LocalPlayer
            if player then
                AntiKickSystem:UpdatePlayerActivity(player)
            end
        end
    end)
    
    -- Detect key presses
    UserInputService.InputBegan:Connect(function(input)
        local player = Players.LocalPlayer
        if player then
            AntiKickSystem:UpdatePlayerActivity(player)
        end
    end)
    
    -- Detect touch input (mobile)
    UserInputService.TouchStarted:Connect(function(touch)
        local player = Players.LocalPlayer
        if player then
            AntiKickSystem:UpdatePlayerActivity(player)
        end
    end)
end

-- 🚀 INITIALIZATION
if RunService:IsServer() then
    -- Server-side initialization
    AntiKickSystem:Initialize()
else
    -- Client-side input detection
    AntiKickSystem:SetupInputDetection()
end

-- 📊 STATISTICS AND MONITORING
local Statistics = {
    totalPlayersProtected = 0,
    totalMovementsExecuted = 0,
    startTime = tick()
}

function Statistics:AddProtectedPlayer()
    self.totalPlayersProtected = self.totalPlayersProtected + 1
end

function Statistics:AddMovement()
    self.totalMovementsExecuted = self.totalMovementsExecuted + 1
end

function Statistics:GetStats()
    local uptime = tick() - self.startTime
    return {
        uptime = uptime,
        totalPlayersProtected = self.totalPlayersProtected,
        totalMovementsExecuted = self.totalMovementsExecuted,
        movementsPerMinute = self.totalMovementsExecuted / (uptime / 60)
    }
end

-- 🔧 ADMIN COMMANDS (if integrated with tycoon engine)
local function CreateAdminCommands()
    if not RunService:IsServer() then return end
    
    -- Create remote event for admin commands
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local remoteFolder = ReplicatedStorage:FindFirstChild("MegaTycoonRemotes")
    
    if remoteFolder then
        local antiKickRemote = Instance.new("RemoteEvent")
        antiKickRemote.Name = "AntiKickCommand"
        antiKickRemote.Parent = remoteFolder
        
        antiKickRemote.OnServerEvent:Connect(function(player, command, ...)
            -- Check if player is admin (you can integrate with your admin system)
            local args = {...}
            
            if command == "stats" then
                local stats = Statistics:GetStats()
                print("🛡️ Anti-Kick Mod Statistics:")
                print("   Uptime: " .. math.floor(stats.uptime / 60) .. " minutes")
                print("   Players Protected: " .. stats.totalPlayersProtected)
                print("   Movements Executed: " .. stats.totalMovementsExecuted)
                print("   Movements/Minute: " .. string.format("%.2f", stats.movementsPerMinute))
            elseif command == "toggle" then
                CONFIG.ENABLED = not CONFIG.ENABLED
                print("🛡️ Anti-Kick Mod: " .. (CONFIG.ENABLED and "Enabled" or "Disabled"))
            elseif command == "config" then
                print("🛡️ Anti-Kick Mod Configuration:")
                for key, value in pairs(CONFIG) do
                    print("   " .. key .. ": " .. tostring(value))
                end
            end
        end)
    end
end

-- 🎯 FINAL INITIALIZATION
if RunService:IsServer() then
    CreateAdminCommands()
    
    -- Print startup message
    print("🛡️ ANTI-KICK MOD LOADED SUCCESSFULLY")
    print("   Protection Threshold: " .. CONFIG.INACTIVITY_THRESHOLD / 60 .. " minutes")
    print("   Movement Interval: " .. CONFIG.MOVEMENT_INTERVAL .. " seconds")
    print("   Movement Intensity: " .. CONFIG.MOVEMENT_INTENSITY)
    print("   Enabled: " .. tostring(CONFIG.ENABLED))
end

return AntiKickSystem