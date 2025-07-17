-- 🌍 TELEPORTATION SYSTEM
-- Handles teleporting between Main Hub, SharedWorld, and Sandbox+ sub-places

local TeleportationSystem = {}

-- 🎯 SERVICE REFERENCES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local MarketplaceService = game:GetService("MarketplaceService")

-- 🌍 SUB-PLACE IDS (Replace with your actual place IDs)
local PLACE_IDS = {
    MAIN_HUB = 0,  -- Replace with your main place ID
    SHARED_WORLD = 0,  -- Replace with SharedWorld sub-place ID
    SANDBOX_PLUS = 0   -- Replace with Sandbox+ sub-place ID
}

-- 🎫 GAMEPASS ID
local SANDBOX_GAMEPASS_ID = 1322694317

-- 🚀 TELEPORT TO SHARED WORLD
function TeleportationSystem:TeleportToSharedWorld(player)
    print("🏗️ Teleporting " .. player.Name .. " to SharedWorld...")
    
    -- Save player data before teleporting
    TeleportationSystem:SavePlayerData(player)
    
    -- Create teleport data
    local teleportData = {
        PlayerData = TeleportationSystem:GetPlayerData(player),
        GameMode = "SharedWorld",
        Timestamp = os.time()
    }
    
    -- Attempt teleport with retry logic
    local success, errorMessage = pcall(function()
        if PLACE_IDS.SHARED_WORLD ~= 0 then
            TeleportService:Teleport(PLACE_IDS.SHARED_WORLD, player, teleportData)
        else
            -- If no sub-place, create SharedWorld area in current place
            TeleportationSystem:CreateSharedWorldArea(player)
        end
    end)
    
    if not success then
        warn("❌ Teleport to SharedWorld failed: " .. tostring(errorMessage))
        TeleportationSystem:ShowTeleportError(player, "SharedWorld", errorMessage)
    end
end

-- 🧪 TELEPORT TO SANDBOX+
function TeleportationSystem:TeleportToSandbox(player)
    -- Check gamepass ownership first
    local hasGamepass = TeleportationSystem:CheckGamepassOwnership(player)
    
    if not hasGamepass then
        -- Prompt gamepass purchase
        print("🎫 Prompting gamepass purchase for " .. player.Name)
        MarketplaceService:PromptGamePassPurchase(player, SANDBOX_GAMEPASS_ID)
        return
    end
    
    print("🧪 Teleporting " .. player.Name .. " to Sandbox+...")
    
    -- Save player data before teleporting
    TeleportationSystem:SavePlayerData(player)
    
    -- Create teleport data
    local teleportData = {
        PlayerData = TeleportationSystem:GetPlayerData(player),
        GameMode = "SandboxPlus",
        Timestamp = os.time(),
        GamepassVerified = true
    }
    
    -- Attempt teleport with retry logic
    local success, errorMessage = pcall(function()
        if PLACE_IDS.SANDBOX_PLUS ~= 0 then
            TeleportService:Teleport(PLACE_IDS.SANDBOX_PLUS, player, teleportData)
        else
            -- If no sub-place, create Sandbox+ area in current place
            TeleportationSystem:CreateSandboxArea(player)
        end
    end)
    
    if not success then
        warn("❌ Teleport to Sandbox+ failed: " .. tostring(errorMessage))
        TeleportationSystem:ShowTeleportError(player, "Sandbox+", errorMessage)
    end
end

-- 🏠 TELEPORT TO MAIN HUB
function TeleportationSystem:TeleportToMainHub(player)
    print("🏠 Teleporting " .. player.Name .. " to Main Hub...")
    
    -- Save player data before teleporting
    TeleportationSystem:SavePlayerData(player)
    
    -- Create teleport data
    local teleportData = {
        PlayerData = TeleportationSystem:GetPlayerData(player),
        GameMode = "MainHub",
        Timestamp = os.time()
    }
    
    -- Attempt teleport
    local success, errorMessage = pcall(function()
        if PLACE_IDS.MAIN_HUB ~= 0 then
            TeleportService:Teleport(PLACE_IDS.MAIN_HUB, player, teleportData)
        else
            -- Teleport to spawn in current place
            player:LoadCharacter()
        end
    end)
    
    if not success then
        warn("❌ Teleport to Main Hub failed: " .. tostring(errorMessage))
        TeleportationSystem:ShowTeleportError(player, "Main Hub", errorMessage)
    end
end

-- 🎫 CHECK GAMEPASS OWNERSHIP
function TeleportationSystem:CheckGamepassOwnership(player)
    local success, hasGamepass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, SANDBOX_GAMEPASS_ID)
    end)
    
    return success and hasGamepass
end

-- 💾 SAVE PLAYER DATA
function TeleportationSystem:SavePlayerData(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local playerData = {
        Cash = leaderstats["Cash 💸"].Value,
        Power = leaderstats["Power 🔋"].Value,
        LastPlayed = os.time(),
        TeleportData = {
            LastLocation = game.PlaceId,
            Timestamp = os.time()
        }
    }
    
    -- Save to DataStore
    local success, errorMessage = pcall(function()
        local DataStoreService = game:GetService("DataStoreService")
        local PlayerDataStore = DataStoreService:GetDataStore("TycoonPlayerData_v3")
        PlayerDataStore:SetAsync("Player_" .. player.UserId, playerData)
    end)
    
    if not success then
        warn("❌ Failed to save player data: " .. tostring(errorMessage))
    end
end

-- 📊 GET PLAYER DATA
function TeleportationSystem:GetPlayerData(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return {} end
    
    return {
        UserId = player.UserId,
        Name = player.Name,
        Cash = leaderstats["Cash 💸"].Value,
        Power = leaderstats["Power 🔋"].Value,
        JoinTime = player.AccountAge,
        Timestamp = os.time()
    }
end

-- 🔄 HANDLE TELEPORT DATA ON ARRIVAL
function TeleportationSystem:HandleTeleportArrival(player)
    local teleportData = TeleportService:GetLocalPlayerTeleportData()
    
    if teleportData and teleportData.PlayerData then
        print("📥 Processing teleport data for " .. player.Name)
        
        -- Wait for leaderstats to load
        local leaderstats = player:WaitForChild("leaderstats", 10)
        if leaderstats then
            -- Restore player data
            leaderstats["Cash 💸"].Value = teleportData.PlayerData.Cash or 1000
            leaderstats["Power 🔋"].Value = teleportData.PlayerData.Power or 0
            
            print("✅ Player data restored for " .. player.Name)
        end
        
        -- Handle game mode specific setup
        if teleportData.GameMode == "SharedWorld" then
            TeleportationSystem:SetupSharedWorldPlayer(player)
        elseif teleportData.GameMode == "SandboxPlus" then
            TeleportationSystem:SetupSandboxPlayer(player)
        elseif teleportData.GameMode == "MainHub" then
            TeleportationSystem:SetupMainHubPlayer(player)
        end
    end
end

-- 🏗️ SETUP SHARED WORLD PLAYER
function TeleportationSystem:SetupSharedWorldPlayer(player)
    print("🏗️ Setting up " .. player.Name .. " for SharedWorld")
    
    -- Give SharedWorld-specific tools/abilities
    spawn(function()
        wait(2) -- Wait for character to fully load
        
        -- Create SharedWorld welcome message
        local welcomeGui = TeleportationSystem:CreateWelcomeMessage(player, "🏗️ Welcome to SharedWorld!", "Build together with other players!")
        
        -- Check if admin for special entrance
        local AdminSystem = require(ServerStorage:WaitForChild("AdminSystem"))
        if AdminSystem:IsAdmin(player) then
            local SharedWorld = require(ServerStorage:WaitForChild("SharedWorldSystem"))
            SharedWorld:AdminFloatDown(player)
        end
    end)
end

-- 🧪 SETUP SANDBOX PLAYER
function TeleportationSystem:SetupSandboxPlayer(player)
    print("🧪 Setting up " .. player.Name .. " for Sandbox+")
    
    spawn(function()
        wait(2)
        
        -- Create Sandbox+ welcome message
        local welcomeGui = TeleportationSystem:CreateWelcomeMessage(player, "🧪 Welcome to Sandbox+!", "Unlimited building mode activated!")
        
        -- Enable Sandbox+ UI
        local sandboxGui = ReplicatedStorage.TycoonGUIs:FindFirstChild("SandboxPlusUI")
        if sandboxGui then
            sandboxGui:Clone().Parent = player:WaitForChild("PlayerGui")
        end
    end)
end

-- 🏠 SETUP MAIN HUB PLAYER
function TeleportationSystem:SetupMainHubPlayer(player)
    print("🏠 Setting up " .. player.Name .. " for Main Hub")
    
    spawn(function()
        wait(2)
        
        -- Create Main Hub welcome message
        local welcomeGui = TeleportationSystem:CreateWelcomeMessage(player, "🏠 Welcome to the Main Hub!", "Choose your adventure!")
    end)
end

-- 📝 CREATE WELCOME MESSAGE
function TeleportationSystem:CreateWelcomeMessage(player, title, description)
    local playerGui = player:WaitForChild("PlayerGui")
    
    local welcomeGui = Instance.new("ScreenGui")
    welcomeGui.Name = "WelcomeMessage"
    welcomeGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    frame.Parent = welcomeGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 60)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.white
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = frame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -20, 0, 40)
    descLabel.Position = UDim2.new(0, 10, 0, 80)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.TextScaled = true
    descLabel.Font = Enum.Font.Gotham
    descLabel.Parent = frame
    
    -- Auto-hide after 5 seconds
    spawn(function()
        wait(5)
        welcomeGui:Destroy()
    end)
    
    return welcomeGui
end

-- ❌ SHOW TELEPORT ERROR
function TeleportationSystem:ShowTeleportError(player, destination, errorMessage)
    local playerGui = player:WaitForChild("PlayerGui")
    
    local errorGui = Instance.new("ScreenGui")
    errorGui.Name = "TeleportError"
    errorGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 150)
    frame.Position = UDim2.new(0.5, -200, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = errorGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    
    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(1, -20, 1, -20)
    errorLabel.Position = UDim2.new(0, 10, 0, 10)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = "❌ Failed to teleport to " .. destination .. "\nPlease try again later."
    errorLabel.TextColor3 = Color3.white
    errorLabel.TextScaled = true
    errorLabel.Font = Enum.Font.GothamBold
    errorLabel.Parent = frame
    
    -- Auto-hide after 3 seconds
    spawn(function()
        wait(3)
        errorGui:Destroy()
    end)
end

-- 🏗️ CREATE SHARED WORLD AREA (Fallback)
function TeleportationSystem:CreateSharedWorldArea(player)
    print("🏗️ Creating SharedWorld area for " .. player.Name)
    
    -- Teleport to SharedWorld coordinates in current place
    if player.Character and player.Character.PrimaryPart then
        player.Character:SetPrimaryPartCFrame(CFrame.new(1000, 50, 0))
    end
    
    TeleportationSystem:SetupSharedWorldPlayer(player)
end

-- 🧪 CREATE SANDBOX AREA (Fallback)
function TeleportationSystem:CreateSandboxArea(player)
    print("🧪 Creating Sandbox+ area for " .. player.Name)
    
    -- Teleport to Sandbox+ coordinates in current place
    if player.Character and player.Character.PrimaryPart then
        player.Character:SetPrimaryPartCFrame(CFrame.new(-1000, 50, 0))
    end
    
    TeleportationSystem:SetupSandboxPlayer(player)
end

-- 🔄 RETRY TELEPORT SYSTEM
function TeleportationSystem:RetryTeleport(player, destination, maxRetries)
    maxRetries = maxRetries or 3
    
    for attempt = 1, maxRetries do
        local success = false
        
        if destination == "SharedWorld" then
            success = pcall(function()
                TeleportationSystem:TeleportToSharedWorld(player)
            end)
        elseif destination == "SandboxPlus" then
            success = pcall(function()
                TeleportationSystem:TeleportToSandbox(player)
            end)
        elseif destination == "MainHub" then
            success = pcall(function()
                TeleportationSystem:TeleportToMainHub(player)
            end)
        end
        
        if success then
            print("✅ Teleport attempt " .. attempt .. " successful")
            break
        else
            print("❌ Teleport attempt " .. attempt .. " failed, retrying...")
            wait(2)
        end
    end
end

-- 🎮 INITIALIZE TELEPORTATION SYSTEM
function TeleportationSystem:Initialize()
    print("🌍 Teleportation System initialized")
    
    -- Handle players joining (check for teleport data)
    Players.PlayerAdded:Connect(function(player)
        TeleportationSystem:HandleTeleportArrival(player)
    end)
    
    -- Handle teleport failures
    TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
        warn("❌ Teleport failed for " .. player.Name .. ": " .. tostring(errorMessage))
        TeleportationSystem:ShowTeleportError(player, "destination", errorMessage)
    end)
    
    print("✅ Teleportation handlers connected")
end

return TeleportationSystem