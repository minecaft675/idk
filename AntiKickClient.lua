--[[
🛡️ ANTI-KICK MOD CLIENT SCRIPT 🛡️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌟 CLIENT-SIDE FEATURES:
✅ Handles camera movements on client
✅ Detects player input activity
✅ Communicates with server-side mod
✅ Smooth camera animations
✅ Mobile and PC compatible

🎯 PLACEMENT:
Place this script in StarterPlayer > StarterPlayerScripts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--]]

-- 🎯 CORE SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 📊 CLIENT CONFIGURATION
local CLIENT_CONFIG = {
    ENABLED = true,
    MOVEMENT_INTENSITY = 0.5,
    MOVEMENT_DURATION = 2,
    ENABLE_LOGGING = false
}

-- 🎮 CAMERA MOVEMENT PATTERNS (Client-side)
local CameraPatterns = {
    gentle_sway = function(camera, intensity)
        local originalCFrame = camera.CFrame
        local swayAmount = intensity * 0.1
        
        local tweenInfo = TweenInfo.new(
            CLIENT_CONFIG.MOVEMENT_DURATION,
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
            CLIENT_CONFIG.MOVEMENT_DURATION,
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
            CLIENT_CONFIG.MOVEMENT_DURATION,
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
            CLIENT_CONFIG.MOVEMENT_DURATION,
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

-- 🎯 CLIENT ANTI-KICK SYSTEM
local ClientAntiKick = {}

-- 📊 CLIENT DATA
local ClientData = {
    lastActivity = tick(),
    isActive = true,
    currentTween = nil,
    cameraMovementActive = false
}

function ClientAntiKick:Initialize()
    if not CLIENT_CONFIG.ENABLED then
        if CLIENT_CONFIG.ENABLE_LOGGING then
            print("🛡️ Anti-Kick Client: Disabled in configuration")
        end
        return
    end
    
    if CLIENT_CONFIG.ENABLE_LOGGING then
        print("🛡️ Anti-Kick Client: Initializing...")
    end
    
    -- Set up input detection
    self:SetupInputDetection()
    
    -- Set up remote event handling
    self:SetupRemoteEvents()
    
    if CLIENT_CONFIG.ENABLE_LOGGING then
        print("🛡️ Anti-Kick Client: Successfully initialized")
    end
end

function ClientAntiKick:SetupInputDetection()
    -- Detect mouse movement
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            self:UpdateActivity()
        end
    end)
    
    -- Detect key presses
    UserInputService.InputBegan:Connect(function(input)
        self:UpdateActivity()
    end)
    
    -- Detect touch input (mobile)
    UserInputService.TouchStarted:Connect(function(touch)
        self:UpdateActivity()
    end)
    
    -- Detect mouse clicks
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.MouseButton2 then
            self:UpdateActivity()
        end
    end)
    
    -- Detect scrolling
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            self:UpdateActivity()
        end
    end)
end

function ClientAntiKick:UpdateActivity()
    ClientData.lastActivity = tick()
    ClientData.isActive = true
    
    -- Notify server of activity
    self:NotifyServerActivity()
end

function ClientAntiKick:NotifyServerActivity()
    local remoteFolder = ReplicatedStorage:FindFirstChild("MegaTycoonRemotes")
    if remoteFolder then
        local activityRemote = remoteFolder:FindFirstChild("PlayerActivity")
        if activityRemote then
            activityRemote:FireServer()
        end
    end
end

function ClientAntiKick:SetupRemoteEvents()
    local remoteFolder = ReplicatedStorage:FindFirstChild("MegaTycoonRemotes")
    if remoteFolder then
        -- Handle camera movement commands from server
        local cameraRemote = remoteFolder:FindFirstChild("CameraMovement")
        if cameraRemote then
            cameraRemote.OnClientEvent:Connect(function(patternName, intensity)
                self:ExecuteCameraMovement(patternName, intensity or CLIENT_CONFIG.MOVEMENT_INTENSITY)
            end)
        end
        
        -- Handle anti-kick activation/deactivation
        local antiKickRemote = remoteFolder:FindFirstChild("AntiKickToggle")
        if antiKickRemote then
            antiKickRemote.OnClientEvent:Connect(function(enabled)
                if enabled then
                    self:ActivateCameraMovement()
                else
                    self:DeactivateCameraMovement()
                end
            end)
        end
    end
end

function ClientAntiKick:ExecuteCameraMovement(patternName, intensity)
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local pattern = CameraPatterns[patternName]
    if not pattern then return end
    
    -- Cancel any existing tween
    if ClientData.currentTween then
        ClientData.currentTween:Cancel()
    end
    
    -- Execute the camera movement
    ClientData.currentTween = pattern(camera, intensity)
    
    if CLIENT_CONFIG.ENABLE_LOGGING then
        print("🛡️ Anti-Kick Client: Executed " .. patternName .. " movement")
    end
end

function ClientAntiKick:ActivateCameraMovement()
    ClientData.cameraMovementActive = true
    
    if CLIENT_CONFIG.ENABLE_LOGGING then
        print("🛡️ Anti-Kick Client: Camera movement activated")
    end
    
    -- Start automatic camera movements
    spawn(function()
        while ClientData.cameraMovementActive do
            local patterns = {"gentle_sway", "micro_zoom", "rotation_tilt", "position_shift"}
            local randomPattern = patterns[math.random(1, #patterns)]
            
            self:ExecuteCameraMovement(randomPattern, CLIENT_CONFIG.MOVEMENT_INTENSITY)
            
            -- Wait before next movement
            wait(10) -- 10 seconds between movements
        end
    end)
end

function ClientAntiKick:DeactivateCameraMovement()
    ClientData.cameraMovementActive = false
    
    -- Cancel any ongoing tween
    if ClientData.currentTween then
        ClientData.currentTween:Cancel()
        ClientData.currentTween = nil
    end
    
    if CLIENT_CONFIG.ENABLE_LOGGING then
        print("🛡️ Anti-Kick Client: Camera movement deactivated")
    end
end

-- 🎮 ENHANCED INPUT DETECTION
function ClientAntiKick:SetupEnhancedInputDetection()
    -- Track character movement
    local player = Players.LocalPlayer
    if player then
        player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            
            humanoid.StateChanged:Connect(function(_, new)
                if new == Enum.HumanoidStateType.Walking or 
                   new == Enum.HumanoidStateType.Running or
                   new == Enum.HumanoidStateType.Jumping then
                    self:UpdateActivity()
                end
            end)
        end)
    end
    
    -- Track camera changes
    local camera = workspace.CurrentCamera
    if camera then
        camera:GetPropertyChangedSignal("CFrame"):Connect(function()
            -- Only update if it's not our anti-kick movement
            if not ClientData.cameraMovementActive then
                self:UpdateActivity()
            end
        end)
    end
end

-- 📊 CLIENT STATISTICS
local ClientStats = {
    movementsExecuted = 0,
    lastMovementTime = 0
}

function ClientStats:AddMovement()
    self.movementsExecuted = self.movementsExecuted + 1
    self.lastMovementTime = tick()
end

function ClientStats:GetStats()
    return {
        movementsExecuted = self.movementsExecuted,
        lastMovementTime = self.lastMovementTime,
        timeSinceLastMovement = tick() - self.lastMovementTime
    }
end

-- 🔧 DEBUG COMMANDS (for testing)
local function SetupDebugCommands()
    -- Create a debug remote for testing
    local remoteFolder = ReplicatedStorage:FindFirstChild("MegaTycoonRemotes")
    if remoteFolder then
        local debugRemote = Instance.new("RemoteEvent")
        debugRemote.Name = "AntiKickDebug"
        debugRemote.Parent = remoteFolder
        
        debugRemote.OnClientEvent:Connect(function(command, ...)
            local args = {...}
            
            if command == "test_movement" then
                local pattern = args[1] or "gentle_sway"
                ClientAntiKick:ExecuteCameraMovement(pattern, CLIENT_CONFIG.MOVEMENT_INTENSITY)
                print("🛡️ Anti-Kick Client: Tested " .. pattern .. " movement")
            elseif command == "toggle_logging" then
                CLIENT_CONFIG.ENABLE_LOGGING = not CLIENT_CONFIG.ENABLE_LOGGING
                print("🛡️ Anti-Kick Client: Logging " .. (CLIENT_CONFIG.ENABLE_LOGGING and "enabled" or "disabled"))
            elseif command == "get_stats" then
                local stats = ClientStats:GetStats()
                print("🛡️ Anti-Kick Client Statistics:")
                print("   Movements Executed: " .. stats.movementsExecuted)
                print("   Last Movement: " .. math.floor(stats.timeSinceLastMovement) .. " seconds ago")
                print("   Camera Active: " .. tostring(ClientData.cameraMovementActive))
            end
        end)
    end
end

-- 🚀 INITIALIZATION
ClientAntiKick:Initialize()
ClientAntiKick:SetupEnhancedInputDetection()
SetupDebugCommands()

-- Print startup message
if CLIENT_CONFIG.ENABLE_LOGGING then
    print("🛡️ ANTI-KICK CLIENT LOADED SUCCESSFULLY")
    print("   Movement Intensity: " .. CLIENT_CONFIG.MOVEMENT_INTENSITY)
    print("   Movement Duration: " .. CLIENT_CONFIG.MOVEMENT_DURATION .. " seconds")
    print("   Enabled: " .. tostring(CLIENT_CONFIG.ENABLED))
end

return ClientAntiKick