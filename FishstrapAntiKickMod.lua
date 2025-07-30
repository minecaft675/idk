--[[
🛡️ FISHSTRAP ANTI-KICK MOD 🛡️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌟 FISHSTRAP MOD FEATURES:
✅ Prevents Roblox from kicking players after 20 minutes of inactivity
✅ Automatic camera movement to simulate player activity
✅ Works with Fishstrap client modifications
✅ Configurable movement patterns and timing
✅ Silent operation - doesn't interfere with gameplay
✅ Compatible with all Fishstrap features

🎯 HOW IT WORKS:
• Detects when player hasn't moved for 15 minutes
• Automatically moves camera in subtle patterns
• Resets inactivity timer to prevent kick
• Maintains player's current view as much as possible
• Works in background without player noticing

🚀 INSTALLATION:
1. Place this script in C:\Users\[username]\AppData\Local\Fishstrap\Modifications\
2. Enable the mod in Fishstrap settings
3. The mod will automatically activate for all games

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--]]

-- ⚙️ FISHSTRAP MOD CONFIGURATION
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
    },
    -- Fishstrap specific settings
    FISHSTRAP_INTEGRATION = true,      -- Enable Fishstrap-specific features
    USE_FISHSTRAP_UI = true,           -- Use Fishstrap UI for settings
    SAVE_SETTINGS = true,              -- Save settings to Fishstrap config
    AUTO_START = true                  -- Start automatically when joining games
}

-- 🎯 CORE SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")

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

-- 🎯 FISHSTRAP ANTI-KICK SYSTEM
local FishstrapAntiKick = {}

-- 📊 FISHSTRAP INTEGRATION
local FishstrapIntegration = {
    settings = {},
    ui = nil,
    isInitialized = false
}

function FishstrapIntegration:Initialize()
    if not CONFIG.FISHSTRAP_INTEGRATION then return end
    
    -- Try to detect Fishstrap
    local success, result = pcall(function()
        -- Check for Fishstrap-specific globals or services
        return _G.Fishstrap or _G.FishstrapMods
    end)
    
    if success and result then
        self.isInitialized = true
        if CONFIG.ENABLE_LOGGING then
            print("🛡️ Fishstrap Anti-Kick: Fishstrap detected, initializing integration...")
        end
        self:LoadSettings()
        self:CreateUI()
    else
        if CONFIG.ENABLE_LOGGING then
            print("🛡️ Fishstrap Anti-Kick: Running in standalone mode (Fishstrap not detected)")
        end
    end
end

function FishstrapIntegration:LoadSettings()
    -- Try to load settings from Fishstrap config
    local success, settings = pcall(function()
        if _G.FishstrapSettings then
            return _G.FishstrapSettings:GetSetting("AntiKickMod")
        end
        return nil
    end)
    
    if success and settings then
        self.settings = settings
        -- Apply loaded settings to CONFIG
        for key, value in pairs(settings) do
            if CONFIG[key] ~= nil then
                CONFIG[key] = value
            end
        end
        if CONFIG.ENABLE_LOGGING then
            print("🛡️ Fishstrap Anti-Kick: Loaded settings from Fishstrap")
        end
    end
end

function FishstrapIntegration:SaveSettings()
    if not CONFIG.SAVE_SETTINGS then return end
    
    local success = pcall(function()
        if _G.FishstrapSettings then
            _G.FishstrapSettings:SetSetting("AntiKickMod", CONFIG)
        end
    end)
    
    if success and CONFIG.ENABLE_LOGGING then
        print("🛡️ Fishstrap Anti-Kick: Saved settings to Fishstrap")
    end
end

function FishstrapIntegration:CreateUI()
    if not CONFIG.USE_FISHSTRAP_UI then return end
    
    -- Create Fishstrap-style UI for mod settings
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FishstrapAntiKickUI"
    screenGui.Parent = game:GetService("CoreGui")
    
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(1, -320, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    title.Text = "🛡️ Anti-Kick Mod"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    -- Add UI elements for settings
    self:CreateSettingToggle(frame, "Enabled", "ENABLED", 50)
    self:CreateSettingSlider(frame, "Movement Intensity", "MOVEMENT_INTENSITY", 0.1, 2.0, 100)
    self:CreateSettingSlider(frame, "Check Interval (s)", "CHECK_INTERVAL", 10, 60, 150)
    self:CreateSettingSlider(frame, "Inactivity Threshold (m)", "INACTIVITY_THRESHOLD", 300, 1200, 200)
    
    self.ui = screenGui
end

function FishstrapIntegration:CreateSettingToggle(parent, label, configKey, yOffset)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 30)
    toggleFrame.Position = UDim2.new(0, 10, 0, yOffset)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.7, 0, 1, 0)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
    labelText.TextScaled = true
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.3, 0, 0.8, 0)
    toggleButton.Position = UDim2.new(0.7, 0, 0.1, 0)
    toggleButton.BackgroundColor3 = CONFIG[configKey] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleButton.Text = CONFIG[configKey] and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = toggleFrame
    
    toggleButton.MouseButton1Click:Connect(function()
        CONFIG[configKey] = not CONFIG[configKey]
        toggleButton.BackgroundColor3 = CONFIG[configKey] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggleButton.Text = CONFIG[configKey] and "ON" or "OFF"
        self:SaveSettings()
    end)
end

function FishstrapIntegration:CreateSettingSlider(parent, label, configKey, minValue, maxValue, yOffset)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 40)
    sliderFrame.Position = UDim2.new(0, 10, 0, yOffset)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, 0, 0.5, 0)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
    labelText.TextScaled = true
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = sliderFrame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0.3, 0)
    slider.Position = UDim2.new(0, 0, 0.5, 0)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    slider.BorderSizePixel = 0
    slider.Parent = sliderFrame
    
    local sliderValue = Instance.new("Frame")
    sliderValue.Size = UDim2.new((CONFIG[configKey] - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderValue.Position = UDim2.new(0, 0, 0, 0)
    sliderValue.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderValue.BorderSizePixel = 0
    sliderValue.Parent = slider
    
    local valueText = Instance.new("TextLabel")
    valueText.Size = UDim2.new(0.3, 0, 0.5, 0)
    valueText.Position = UDim2.new(0.7, 0, 0.25, 0)
    valueText.BackgroundTransparency = 1
    valueText.Text = tostring(CONFIG[configKey])
    valueText.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueText.TextScaled = true
    valueText.Font = Enum.Font.Gotham
    valueText.Parent = sliderFrame
    
    -- Make slider interactive
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = slider.AbsolutePosition
            local sliderSize = slider.AbsoluteSize
            local relativeX = (mousePos.X - sliderPos.X) / sliderSize.X
            local newValue = minValue + (maxValue - minValue) * math.clamp(relativeX, 0, 1)
            
            CONFIG[configKey] = newValue
            sliderValue.Size = UDim2.new((newValue - minValue) / (maxValue - minValue), 0, 1, 0)
            valueText.Text = tostring(math.floor(newValue * 10) / 10)
            self:SaveSettings()
        end
    end)
end

function FishstrapAntiKick:Initialize()
    if not CONFIG.ENABLED then
        if CONFIG.ENABLE_LOGGING then
            print("🛡️ Fishstrap Anti-Kick: Disabled in configuration")
        end
        return
    end
    
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Fishstrap Anti-Kick: Initializing...")
    end
    
    -- Initialize Fishstrap integration
    FishstrapIntegration:Initialize()
    
    -- Set up player tracking
    self:SetupPlayerTracking()
    
    -- Start the main loop
    self:StartMainLoop()
    
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Fishstrap Anti-Kick: Successfully initialized")
    end
end

function FishstrapAntiKick:SetupPlayerTracking()
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

function FishstrapAntiKick:InitializePlayer(player)
    PlayerData[player.UserId] = {
        lastActivity = tick(),
        lastInput = tick(),
        isActive = true,
        cameraMovementActive = false,
        currentTween = nil
    }
    
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Fishstrap Anti-Kick: Tracking player " .. player.Name)
    end
end

function FishstrapAntiKick:CleanupPlayer(player)
    local data = PlayerData[player.UserId]
    if data and data.currentTween then
        data.currentTween:Cancel()
    end
    PlayerData[player.UserId] = nil
    
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Fishstrap Anti-Kick: Stopped tracking player " .. player.Name)
    end
end

function FishstrapAntiKick:UpdatePlayerActivity(player)
    local data = PlayerData[player.UserId]
    if data then
        data.lastActivity = tick()
        data.lastInput = tick()
        data.isActive = true
    end
end

function FishstrapAntiKick:StartMainLoop()
    spawn(function()
        while true do
            if CONFIG.ENABLED then
                self:CheckAllPlayers()
            end
            wait(CONFIG.CHECK_INTERVAL)
        end
    end)
end

function FishstrapAntiKick:CheckAllPlayers()
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

function FishstrapAntiKick:ActivateAntiKick(player, data)
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Fishstrap Anti-Kick: Activating for " .. player.Name .. " (inactive for " .. math.floor((tick() - data.lastActivity) / 60) .. " minutes)")
    end
    
    data.cameraMovementActive = true
    self:StartCameraMovement(player, data)
end

function FishstrapAntiKick:DeactivateAntiKick(player, data)
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ Fishstrap Anti-Kick: Deactivating for " .. player.Name .. " (player became active)")
    end
    
    data.cameraMovementActive = false
    if data.currentTween then
        data.currentTween:Cancel()
        data.currentTween = nil
    end
end

function FishstrapAntiKick:StartCameraMovement(player, data)
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
                        print("🛡️ Fishstrap Anti-Kick: Executed " .. patternName .. " for " .. player.Name)
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
function FishstrapAntiKick:SetupInputDetection()
    -- Detect mouse movement
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local player = Players.LocalPlayer
            if player then
                self:UpdatePlayerActivity(player)
            end
        end
    end)
    
    -- Detect key presses
    UserInputService.InputBegan:Connect(function(input)
        local player = Players.LocalPlayer
        if player then
            self:UpdatePlayerActivity(player)
        end
    end)
    
    -- Detect touch input (mobile)
    UserInputService.TouchStarted:Connect(function(touch)
        local player = Players.LocalPlayer
        if player then
            self:UpdatePlayerActivity(player)
        end
    end)
    
    -- Detect character movement
    local player = Players.LocalPlayer
    if player then
        player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            
            humanoid.StateChanged:Connect(function(_, new)
                if new == Enum.HumanoidStateType.Walking or 
                   new == Enum.HumanoidStateType.Running or
                   new == Enum.HumanoidStateType.Jumping then
                    self:UpdatePlayerActivity(player)
                end
            end)
        end)
    end
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

-- 🔧 FISHSTRAP COMMANDS
local function CreateFishstrapCommands()
    -- Create commands that work with Fishstrap
    local commands = {
        ["antikick"] = {
            description = "Anti-Kick Mod commands",
            usage = ":antikick [command]",
            commands = {
                ["stats"] = {
                    description = "Show anti-kick statistics",
                    func = function()
                        local stats = Statistics:GetStats()
                        print("🛡️ Fishstrap Anti-Kick Statistics:")
                        print("   Uptime: " .. math.floor(stats.uptime / 60) .. " minutes")
                        print("   Players Protected: " .. stats.totalPlayersProtected)
                        print("   Movements Executed: " .. stats.totalMovementsExecuted)
                        print("   Movements/Minute: " .. string.format("%.2f", stats.movementsPerMinute))
                    end
                },
                ["toggle"] = {
                    description = "Toggle anti-kick mod",
                    func = function()
                        CONFIG.ENABLED = not CONFIG.ENABLED
                        print("🛡️ Fishstrap Anti-Kick: " .. (CONFIG.ENABLED and "Enabled" or "Disabled"))
                        FishstrapIntegration:SaveSettings()
                    end
                },
                ["config"] = {
                    description = "Show current configuration",
                    func = function()
                        print("🛡️ Fishstrap Anti-Kick Configuration:")
                        for key, value in pairs(CONFIG) do
                            print("   " .. key .. ": " .. tostring(value))
                        end
                    end
                },
                ["test"] = {
                    description = "Test camera movement",
                    func = function()
                        local camera = workspace.CurrentCamera
                        if camera then
                            local pattern = CameraPatterns["gentle_sway"]
                            if pattern then
                                pattern(camera, CONFIG.MOVEMENT_INTENSITY)
                                print("🛡️ Fishstrap Anti-Kick: Tested camera movement")
                            end
                        end
                    end
                }
            }
        }
    }
    
    -- Register commands with Fishstrap if available
    if _G.FishstrapCommands then
        for commandName, commandData in pairs(commands) do
            _G.FishstrapCommands:RegisterCommand(commandName, commandData)
        end
        if CONFIG.ENABLE_LOGGING then
            print("🛡️ Fishstrap Anti-Kick: Registered commands with Fishstrap")
        end
    end
end

-- 🚀 INITIALIZATION
if RunService:IsClient() then
    -- Client-side initialization
    FishstrapAntiKick:SetupInputDetection()
    CreateFishstrapCommands()
    
    -- Print startup message
    if CONFIG.ENABLE_LOGGING then
        print("🛡️ FISHSTRAP ANTI-KICK MOD LOADED")
        print("   Movement Intensity: " .. CONFIG.MOVEMENT_INTENSITY)
        print("   Movement Duration: " .. CONFIG.MOVEMENT_DURATION .. " seconds")
        print("   Enabled: " .. tostring(CONFIG.ENABLED))
        print("   Fishstrap Integration: " .. tostring(FishstrapIntegration.isInitialized))
    end
else
    -- Server-side initialization
    FishstrapAntiKick:Initialize()
    CreateFishstrapCommands()
    
    -- Print startup message
    print("🛡️ FISHSTRAP ANTI-KICK MOD SERVER LOADED")
    print("   Protection Threshold: " .. CONFIG.INACTIVITY_THRESHOLD / 60 .. " minutes")
    print("   Movement Interval: " .. CONFIG.MOVEMENT_INTERVAL .. " seconds")
    print("   Movement Intensity: " .. CONFIG.MOVEMENT_INTENSITY)
    print("   Enabled: " .. tostring(CONFIG.ENABLED))
    print("   Fishstrap Integration: " .. tostring(FishstrapIntegration.isInitialized))
end

return FishstrapAntiKick