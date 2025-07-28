-- 🚀 FLYING BOX TELEPORT SYSTEM
-- Lunar script that teleports player to a flying box descending to world bottom

local FlyingBoxTeleport = {}

-- 🎯 SERVICE REFERENCES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

-- 🎨 CONFIGURATION
local CONFIG = {
    BOX_SIZE = Vector3.new(8, 8, 8),
    DESCENT_SPEED = 50, -- studs per second
    TELEPORT_HEIGHT = 1000, -- height above player to spawn box
    PARTICLE_COUNT = 50,
    GLOW_INTENSITY = 0.8,
    SOUND_VOLUME = 0.5
}

-- 🎵 SOUND EFFECTS
local SOUNDS = {
    TELEPORT = "rbxasset://sounds/electronicpingshort.wav",
    DESCENT = "rbxasset://sounds/impact_water.wav",
    LANDING = "rbxasset://sounds/impact_explosion_02.wav"
}

-- 🎨 COLORS
local COLORS = {
    BOX_PRIMARY = Color3.fromRGB(100, 200, 255),
    BOX_SECONDARY = Color3.fromRGB(50, 150, 255),
    PARTICLE_TRAIL = Color3.fromRGB(255, 255, 100),
    GLOW_EFFECT = Color3.fromRGB(255, 255, 150)
}

-- 🚀 MAIN TELEPORT FUNCTION
function FlyingBoxTeleport:TeleportToFlyingBox(player)
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        warn("❌ Player or character not found for teleportation")
        return
    end
    
    print("🚀 Starting flying box teleport for " .. player.Name)
    
    -- Get player position
    local playerRoot = player.Character.HumanoidRootPart
    local startPosition = playerRoot.Position
    
    -- Create the flying box
    local flyingBox = FlyingBoxTeleport:CreateFlyingBox(startPosition)
    
    -- Teleport player to the box
    FlyingBoxTeleport:TeleportPlayerToBox(player, flyingBox)
    
    -- Start descent animation
    FlyingBoxTeleport:StartDescent(flyingBox, player)
end

-- 🎨 CREATE FLYING BOX
function FlyingBoxTeleport:CreateFlyingBox(startPosition)
    local box = Instance.new("Part")
    box.Name = "FlyingTeleportBox"
    box.Size = CONFIG.BOX_SIZE
    box.Position = startPosition + Vector3.new(0, CONFIG.TELEPORT_HEIGHT, 0)
    box.Anchored = true
    box.CanCollide = false
    box.Material = Enum.Material.Neon
    box.Color = COLORS.BOX_PRIMARY
    box.Parent = workspace
    
    -- Create box mesh
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cube
    mesh.Parent = box
    
    -- Add glow effect
    local pointLight = Instance.new("PointLight")
    pointLight.Color = COLORS.GLOW_EFFECT
    pointLight.Range = 20
    pointLight.Brightness = CONFIG.GLOW_INTENSITY
    pointLight.Parent = box
    
    -- Add particle trail
    FlyingBoxTeleport:AddParticleTrail(box)
    
    -- Add teleport sound
    FlyingBoxTeleport:PlaySound(box, SOUNDS.TELEPORT)
    
    return box
end

-- ✨ ADD PARTICLE TRAIL
function FlyingBoxTeleport:AddParticleTrail(part)
    local attachment = Instance.new("Attachment")
    attachment.Parent = part
    attachment.Position = Vector3.new(0, -CONFIG.BOX_SIZE.Y/2, 0)
    
    local particleEmitter = Instance.new("ParticleEmitter")
    particleEmitter.Parent = attachment
    particleEmitter.Color = ColorSequence.new(COLORS.PARTICLE_TRAIL)
    particleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 0)
    })
    particleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    particleEmitter.Lifetime = NumberRange.new(1, 2)
    particleEmitter.Rate = CONFIG.PARTICLE_COUNT
    particleEmitter.Speed = NumberRange.new(5, 10)
    particleEmitter.SpreadAngle = Vector2.new(45, 45)
    particleEmitter.Acceleration = Vector3.new(0, -10, 0)
    
    return particleEmitter
end

-- 🎵 PLAY SOUND EFFECT
function FlyingBoxTeleport:PlaySound(parent, soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = CONFIG.SOUND_VOLUME
    sound.Parent = parent
    sound:Play()
    
    -- Clean up sound after playing
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- 🚀 TELEPORT PLAYER TO BOX
function FlyingBoxTeleport:TeleportPlayerToBox(player, box)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = player.Character.HumanoidRootPart
    local humanoid = player.Character:FindFirstChild("Humanoid")
    
    -- Create teleport effect
    FlyingBoxTeleport:CreateTeleportEffect(humanoidRootPart.Position)
    
    -- Teleport player to box
    humanoidRootPart.CFrame = CFrame.new(box.Position + Vector3.new(0, CONFIG.BOX_SIZE.Y/2 + 3, 0))
    
    -- Disable player movement temporarily
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        
        -- Re-enable after 2 seconds
        task.delay(2, function()
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end)
    end
end

-- ✨ CREATE TELEPORT EFFECT
function FlyingBoxTeleport:CreateTeleportEffect(position)
    -- Create explosion effect
    local explosion = Instance.new("Explosion")
    explosion.Position = position
    explosion.BlastRadius = 0
    explosion.BlastPressure = 0
    explosion.DestroyJointRadiusPercent = 0
    explosion.Parent = workspace
    
    -- Create particle burst
    for i = 1, 20 do
        local particle = Instance.new("Part")
        particle.Size = Vector3.new(0.5, 0.5, 0.5)
        particle.Position = position + Vector3.new(
            math.random(-5, 5),
            math.random(-5, 5),
            math.random(-5, 5)
        )
        particle.Anchored = false
        particle.CanCollide = false
        particle.Material = Enum.Material.Neon
        particle.Color = COLORS.PARTICLE_TRAIL
        particle.Parent = workspace
        
        -- Add velocity
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(
            math.random(-20, 20),
            math.random(10, 30),
            math.random(-20, 20)
        )
        bodyVelocity.Parent = particle
        
        -- Clean up particle
        Debris:AddItem(particle, 3)
        Debris:AddItem(bodyVelocity, 3)
    end
end

-- 📉 START DESCENT ANIMATION
function FlyingBoxTeleport:StartDescent(box, player)
    local startPosition = box.Position
    local endPosition = Vector3.new(startPosition.X, -1000, startPosition.Z) -- Go deep underground
    
    -- Create descent tween
    local descentTween = TweenService:Create(
        box,
        TweenInfo.new(
            math.abs(endPosition.Y - startPosition.Y) / CONFIG.DESCENT_SPEED,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        ),
        {Position = endPosition}
    )
    
    -- Add rotation during descent
    local rotationTween = TweenService:Create(
        box,
        TweenInfo.new(
            math.abs(endPosition.Y - startPosition.Y) / CONFIG.DESCENT_SPEED,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        ),
        {CFrame = CFrame.new(box.Position) * CFrame.Angles(0, math.rad(360), 0)}
    )
    
    -- Start descent
    descentTween:Play()
    rotationTween:Play()
    
    -- Play descent sound
    FlyingBoxTeleport:PlaySound(box, SOUNDS.DESCENT)
    
    -- Monitor descent progress
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not box or not box.Parent then
            connection:Disconnect()
            return
        end
        
        -- Keep player on the box during descent
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            humanoidRootPart.CFrame = CFrame.new(box.Position + Vector3.new(0, CONFIG.BOX_SIZE.Y/2 + 3, 0))
        end
        
        -- Check if we've reached the bottom
        if box.Position.Y <= endPosition.Y + 10 then
            connection:Disconnect()
            FlyingBoxTeleport:OnDescentComplete(box, player)
        end
    end)
    
    -- Clean up connection when tween completes
    descentTween.Completed:Connect(function()
        if connection then
            connection:Disconnect()
        end
    end)
end

-- 🎯 DESCENT COMPLETE
function FlyingBoxTeleport:OnDescentComplete(box, player)
    print("🎯 Flying box descent completed for " .. player.Name)
    
    -- Play landing sound
    FlyingBoxTeleport:PlaySound(box, SOUNDS.LANDING)
    
    -- Create landing effect
    FlyingBoxTeleport:CreateLandingEffect(box.Position)
    
    -- Teleport player to final position
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character.HumanoidRootPart
        humanoidRootPart.CFrame = CFrame.new(box.Position + Vector3.new(0, 10, 0))
    end
    
    -- Clean up box after delay
    task.delay(3, function()
        if box and box.Parent then
            box:Destroy()
        end
    end)
end

-- 💥 CREATE LANDING EFFECT
function FlyingBoxTeleport:CreateLandingEffect(position)
    -- Create large explosion effect
    local explosion = Instance.new("Explosion")
    explosion.Position = position
    explosion.BlastRadius = 20
    explosion.BlastPressure = 0
    explosion.DestroyJointRadiusPercent = 0
    explosion.Parent = workspace
    
    -- Create massive particle burst
    for i = 1, 50 do
        local particle = Instance.new("Part")
        particle.Size = Vector3.new(1, 1, 1)
        particle.Position = position + Vector3.new(
            math.random(-30, 30),
            math.random(-10, 10),
            math.random(-30, 30)
        )
        particle.Anchored = false
        particle.CanCollide = false
        particle.Material = Enum.Material.Neon
        particle.Color = Color3.fromRGB(255, 255, 100)
        particle.Parent = workspace
        
        -- Add velocity
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(
            math.random(-50, 50),
            math.random(20, 60),
            math.random(-50, 50)
        )
        bodyVelocity.Parent = particle
        
        -- Clean up particle
        Debris:AddItem(particle, 5)
        Debris:AddItem(bodyVelocity, 5)
    end
end

-- 🎮 CREATE UI BUTTON
function FlyingBoxTeleport:CreateTeleportButton()
    local player = Players.LocalPlayer
    if not player then return end
    
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlyingBoxTeleportGUI"
    screenGui.Parent = playerGui
    
    -- Create button
    local button = Instance.new("TextButton")
    button.Name = "TeleportButton"
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = UDim2.new(0, 20, 0, 20)
    button.BackgroundColor3 = COLORS.BOX_PRIMARY
    button.Text = "🚀 Flying Box Teleport"
    button.TextColor3 = Color3.white
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    -- Add hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundColor3 = COLORS.BOX_SECONDARY
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundColor3 = COLORS.BOX_PRIMARY
        }):Play()
    end)
    
    -- Add click handler
    button.MouseButton1Click:Connect(function()
        FlyingBoxTeleport:TeleportToFlyingBox(player)
    end)
    
    return button
end

-- 🚀 INITIALIZE SYSTEM
function FlyingBoxTeleport:Initialize()
    print("🚀 Initializing Flying Box Teleport System...")
    
    -- Create UI button for local player
    local player = Players.LocalPlayer
    if player then
        FlyingBoxTeleport:CreateTeleportButton()
    end
    
    -- Handle new players joining
    Players.PlayerAdded:Connect(function(player)
        task.wait(2) -- Wait for player to load
        if player == Players.LocalPlayer then
            FlyingBoxTeleport:CreateTeleportButton()
        end
    end)
end

-- 🎯 EXPORT FUNCTIONS
FlyingBoxTeleport.TeleportToFlyingBox = FlyingBoxTeleport.TeleportToFlyingBox
FlyingBoxTeleport.Initialize = FlyingBoxTeleport.Initialize

return FlyingBoxTeleport