--[[
🏠 MAIN HUB COMPLETE SYSTEM 🏠
Put this script in ServerScriptService in your MAIN HUB place
This creates the full hub with teleportation and friend invitation system
]]

print("🏠 MAIN HUB SYSTEM - AUTO-BUILDING ALL COMPONENTS...")

-- ⚙️ CONFIGURATION
local SUPERADMIN_ID = 2500153124  -- LeviStopMo2021's User ID
local MAIN_HUB_PLACE_ID = 194805113598787  -- This place ID
local SHARED_WORLD_PLACE_ID = 0  -- SET TO YOUR SHARED WORLD SUB-PLACE ID
local SANDBOX_PLUS_PLACE_ID = 0  -- SET TO YOUR SANDBOX+ SUB-PLACE ID
local SANDBOX_GAMEPASS_ID = 1322694317

-- 🎯 SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local DataStoreService = game:GetService("DataStoreService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")

-- 📊 DATA STORES
local PlayerDataStore = DataStoreService:GetDataStore("MegaTycoonPlayerData_v51")
local FriendInviteStore = DataStoreService:GetDataStore("MegaTycoonFriendInvites_v51")
local TeleportDataStore = DataStoreService:GetDataStore("MegaTycoonTeleportData_v51")

-- 📡 CREATE REMOTE EVENTS
local remoteFolder = Instance.new("Folder")
remoteFolder.Name = "MegaTycoonRemotes"
remoteFolder.Parent = ReplicatedStorage

local remoteEvents = {
    "TeleportToSharedWorld", "TeleportToSandboxPlus", "InviteFriend", "AcceptInvite",
    "OpenMainMenu", "CloseMainMenu", "OpenAdminPanel", "BroadcastMessage",
    "GiveMoney", "AdminFloatDown", "TriggerRandomEvent"
}

for _, eventName in ipairs(remoteEvents) do
    local remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = eventName
    remoteEvent.Parent = remoteFolder
end

print("📡 Created " .. #remoteEvents .. " Remote Events!")

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
    
    return leaderstats
end

-- 💾 DATA LOADING
local function loadPlayerData(player)
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync("Player_" .. player.UserId)
    end)
    
    if success and data then
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            leaderstats["Cash 💸"].Value = data.Cash or 2500
            leaderstats["Power 🔋"].Value = data.Power or 0
            leaderstats["Prestige ⭐"].Value = data.PrestigeLevel or 0
            leaderstats["Eco Score 🌱"].Value = data.EcoScore or 100
        end
        print("📦 Loaded data for " .. player.Name)
    end
end

-- 🌐 TELEPORTATION SYSTEM
local TeleportationSystem = {}
TeleportationSystem.TeleportCooldowns = {}

function TeleportationSystem:PreparePlayerData(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    return {
        userId = player.UserId,
        name = player.Name,
        cash = leaderstats and leaderstats["Cash 💸"].Value or 2500,
        power = leaderstats and leaderstats["Power 🔋"].Value or 0,
        prestige = leaderstats and leaderstats["Prestige ⭐"].Value or 0,
        ecoScore = leaderstats and leaderstats["Eco Score 🌱"].Value or 100,
        timestamp = os.time()
    }
end

function TeleportationSystem:TeleportToSharedWorld(player)
    if self.TeleportCooldowns[player.UserId] and 
       tick() - self.TeleportCooldowns[player.UserId] < 5 then
        return false, "Please wait before teleporting again"
    end
    
    if SHARED_WORLD_PLACE_ID == 0 then
        return false, "SharedWorld Place ID not configured. Contact admin."
    end
    
    local playerData = self:PreparePlayerData(player)
    local teleportData = {
        playerData = playerData,
        destination = "SharedWorld",
        timestamp = os.time(),
        gamemode = "Multiplayer"
    }
    
    pcall(function()
        TeleportDataStore:SetAsync("TeleportData_" .. player.UserId, teleportData)
    end)
    
    local success, errorMessage = pcall(function()
        TeleportService:Teleport(SHARED_WORLD_PLACE_ID, player, teleportData)
    end)
    
    if success then
        self.TeleportCooldowns[player.UserId] = tick()
        print("🌍 " .. player.Name .. " teleported to SharedWorld")
        return true, "Teleporting to SharedWorld..."
    else
        return false, "Teleport failed: " .. (errorMessage or "Unknown error")
    end
end

function TeleportationSystem:TeleportToSandboxPlus(player)
    -- Check gamepass ownership
    local hasGamepass = false
    pcall(function()
        hasGamepass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, SANDBOX_GAMEPASS_ID)
    end)
    
    if not hasGamepass then
        pcall(function()
            MarketplaceService:PromptGamePassPurchase(player, SANDBOX_GAMEPASS_ID)
        end)
        return false, "Sandbox+ Gamepass required! Purchase prompt opened."
    end
    
    if self.TeleportCooldowns[player.UserId] and 
       tick() - self.TeleportCooldowns[player.UserId] < 5 then
        return false, "Please wait before teleporting again"
    end
    
    if SANDBOX_PLUS_PLACE_ID == 0 then
        return false, "Sandbox+ Place ID not configured. Contact admin."
    end
    
    local playerData = self:PreparePlayerData(player)
    local teleportData = {
        playerData = playerData,
        destination = "SandboxPlus",
        timestamp = os.time(),
        gamemode = "Premium",
        sandboxFeatures = {
            unlimitedBuild = true,
            timeAcceleration = true,
            pollutionToggle = true,
            infiniteResources = true,
            noLeaderboardImpact = true
        }
    }
    
    pcall(function()
        TeleportDataStore:SetAsync("TeleportData_" .. player.UserId, teleportData)
    end)
    
    local success, errorMessage = pcall(function()
        TeleportService:Teleport(SANDBOX_PLUS_PLACE_ID, player, teleportData)
    end)
    
    if success then
        self.TeleportCooldowns[player.UserId] = tick()
        print("🧪 " .. player.Name .. " teleported to Sandbox+")
        return true, "Teleporting to Sandbox+..."
    else
        return false, "Teleport failed: " .. (errorMessage or "Unknown error")
    end
end

-- 👥 FRIEND INVITATION SYSTEM
local FriendSystem = {}

function FriendSystem:InviteFriend(inviter, targetName, destination)
    local targetPlayer = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(targetName:lower()) then
            targetPlayer = player
            break
        end
    end
    
    if not targetPlayer then
        return false, "Player not found"
    end
    
    if targetPlayer == inviter then
        return false, "Cannot invite yourself"
    end
    
    -- Create invitation
    local inviteData = {
        inviterId = inviter.UserId,
        inviterName = inviter.Name,
        targetId = targetPlayer.UserId,
        targetName = targetPlayer.Name,
        destination = destination,
        timestamp = os.time(),
        expires = os.time() + 300 -- 5 minutes
    }
    
    pcall(function()
        FriendInviteStore:SetAsync("Invite_" .. targetPlayer.UserId, inviteData)
    end)
    
    -- Show invitation to target player
    self:ShowInvitation(targetPlayer, inviteData)
    
    return true, "Invitation sent to " .. targetPlayer.Name
end

function FriendSystem:ShowInvitation(player, inviteData)
    local gui = Instance.new("ScreenGui")
    gui.Name = "FriendInvitation"
    gui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 50)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🎉 FRIEND INVITATION 🎉"
    title.TextColor3 = Color3.white
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -20, 0, 60)
    message.Position = UDim2.new(0, 10, 0, 60)
    message.BackgroundTransparency = 1
    message.Text = inviteData.inviterName .. " invited you to " .. inviteData.destination .. "!"
    message.TextColor3 = Color3.white
    message.TextScaled = true
    message.Font = Enum.Font.Gotham
    message.Parent = frame
    
    -- Accept button
    local acceptBtn = Instance.new("TextButton")
    acceptBtn.Size = UDim2.new(0.4, 0, 0, 40)
    acceptBtn.Position = UDim2.new(0.05, 0, 1, -50)
    acceptBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    acceptBtn.Text = "✅ Accept"
    acceptBtn.TextColor3 = Color3.white
    acceptBtn.TextScaled = true
    acceptBtn.Font = Enum.Font.GothamBold
    acceptBtn.Parent = frame
    
    local acceptCorner = Instance.new("UICorner")
    acceptCorner.CornerRadius = UDim.new(0, 8)
    acceptCorner.Parent = acceptBtn
    
    -- Decline button
    local declineBtn = Instance.new("TextButton")
    declineBtn.Size = UDim2.new(0.4, 0, 0, 40)
    declineBtn.Position = UDim2.new(0.55, 0, 1, -50)
    declineBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    declineBtn.Text = "❌ Decline"
    declineBtn.TextColor3 = Color3.white
    declineBtn.TextScaled = true
    declineBtn.Font = Enum.Font.GothamBold
    declineBtn.Parent = frame
    
    local declineCorner = Instance.new("UICorner")
    declineCorner.CornerRadius = UDim.new(0, 8)
    declineCorner.Parent = declineBtn
    
    acceptBtn.MouseButton1Click:Connect(function()
        self:AcceptInvitation(player, inviteData)
        gui:Destroy()
    end)
    
    declineBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Auto-expire after 5 minutes
    game:GetService("Debris"):AddItem(gui, 300)
end

function FriendSystem:AcceptInvitation(player, inviteData)
    if os.time() > inviteData.expires then
        return false, "Invitation has expired"
    end
    
    -- Teleport together
    if inviteData.destination == "SharedWorld" then
        TeleportationSystem:TeleportToSharedWorld(player)
    elseif inviteData.destination == "Sandbox+" then
        TeleportationSystem:TeleportToSandboxPlus(player)
    end
    
    return true, "Joining " .. inviteData.inviterName .. " in " .. inviteData.destination
end

-- 👑 ADMIN SYSTEM
local AdminSystem = {}
AdminSystem.AdminLevels = {
    [SUPERADMIN_ID] = 10  -- LeviStopMo2021 as Superadmin
}

function AdminSystem:IsAdmin(player)
    return self.AdminLevels[player.UserId] and self.AdminLevels[player.UserId] > 0
end

function AdminSystem:AdminFloatDown(player)
    if not self:IsAdmin(player) then return false end
    
    local character = player.Character
    if not character or not character.PrimaryPart then return false end
    
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
    
    -- Teleport admin to platform
    character:SetPrimaryPartCFrame(CFrame.new(0, 315, 0))
    
    -- Epic announcement
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
    
    -- Epic descent
    local descentTween = game:GetService("TweenService"):Create(platform, 
        TweenInfo.new(8, Enum.EasingStyle.Sine), {Position = Vector3.new(0, 5, 0)})
    descentTween:Play()
    
    descentTween.Completed:Connect(function()
        wait(5)
        platform:Destroy()
    end)
    
    return true
end

-- 🎮 CLIENT UI SYSTEM
local clientUIScript = Instance.new("LocalScript")
clientUIScript.Name = "MainHubClientUI"
clientUIScript.Parent = StarterGui
clientUIScript.Source = [[
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("MegaTycoonRemotes")

-- MAIN MENU
local function createMainMenu()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MainMenu"
    gui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 600, 0, 800)
    frame.Position = UDim2.new(0.5, -300, 0.5, -400)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
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
    title.Text = "🌟 MEGA TYCOON EMPIRE 🌟"
    title.TextColor3 = Color3.white
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    -- SharedWorld Section
    local sharedLabel = Instance.new("TextLabel")
    sharedLabel.Size = UDim2.new(1, -20, 0, 40)
    sharedLabel.Position = UDim2.new(0, 10, 0, 100)
    sharedLabel.BackgroundTransparency = 1
    sharedLabel.Text = "🌍 SHARED WORLD - Multiplayer Factory Building"
    sharedLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
    sharedLabel.TextScaled = true
    sharedLabel.Font = Enum.Font.GothamBold
    sharedLabel.Parent = frame
    
    local sharedBtn = Instance.new("TextButton")
    sharedBtn.Size = UDim2.new(0.8, 0, 0, 60)
    sharedBtn.Position = UDim2.new(0.1, 0, 0, 150)
    sharedBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    sharedBtn.Text = "🏗️ Enter My SharedWorld"
    sharedBtn.TextColor3 = Color3.white
    sharedBtn.TextScaled = true
    sharedBtn.Font = Enum.Font.GothamBold
    sharedBtn.Parent = frame
    
    local sharedCorner = Instance.new("UICorner")
    sharedCorner.CornerRadius = UDim.new(0, 10)
    sharedCorner.Parent = sharedBtn
    
    -- Friend invite for SharedWorld
    local friendLabel = Instance.new("TextLabel")
    friendLabel.Size = UDim2.new(1, -20, 0, 30)
    friendLabel.Position = UDim2.new(0, 10, 0, 220)
    friendLabel.BackgroundTransparency = 1
    friendLabel.Text = "👥 Invite Friend to SharedWorld:"
    friendLabel.TextColor3 = Color3.white
    friendLabel.TextScaled = true
    friendLabel.Font = Enum.Font.Gotham
    friendLabel.Parent = frame
    
    local friendInput = Instance.new("TextBox")
    friendInput.Size = UDim2.new(0.6, 0, 0, 40)
    friendInput.Position = UDim2.new(0.05, 0, 0, 250)
    friendInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    friendInput.Text = "Player Name..."
    friendInput.TextColor3 = Color3.white
    friendInput.TextScaled = true
    friendInput.Font = Enum.Font.Gotham
    friendInput.Parent = frame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = friendInput
    
    local inviteBtn = Instance.new("TextButton")
    inviteBtn.Size = UDim2.new(0.3, 0, 0, 40)
    inviteBtn.Position = UDim2.new(0.65, 0, 0, 250)
    inviteBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    inviteBtn.Text = "📤 Invite"
    inviteBtn.TextColor3 = Color3.white
    inviteBtn.TextScaled = true
    inviteBtn.Font = Enum.Font.GothamBold
    inviteBtn.Parent = frame
    
    local inviteCorner = Instance.new("UICorner")
    inviteCorner.CornerRadius = UDim.new(0, 8)
    inviteCorner.Parent = inviteBtn
    
    -- Sandbox+ Section
    local sandboxLabel = Instance.new("TextLabel")
    sandboxLabel.Size = UDim2.new(1, -20, 0, 40)
    sandboxLabel.Position = UDim2.new(0, 10, 0, 320)
    sandboxLabel.BackgroundTransparency = 1
    sandboxLabel.Text = "🧪 SANDBOX+ - Premium Creative Mode"
    sandboxLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
    sandboxLabel.TextScaled = true
    sandboxLabel.Font = Enum.Font.GothamBold
    sandboxLabel.Parent = frame
    
    local sandboxBtn = Instance.new("TextButton")
    sandboxBtn.Size = UDim2.new(0.8, 0, 0, 60)
    sandboxBtn.Position = UDim2.new(0.1, 0, 0, 370)
    sandboxBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
    sandboxBtn.Text = "🔧 Enter My Sandbox+"
    sandboxBtn.TextColor3 = Color3.white
    sandboxBtn.TextScaled = true
    sandboxBtn.Font = Enum.Font.GothamBold
    sandboxBtn.Parent = frame
    
    local sandboxCorner = Instance.new("UICorner")
    sandboxCorner.CornerRadius = UDim.new(0, 10)
    sandboxCorner.Parent = sandboxBtn
    
    -- Sandbox+ friend invite
    local sandboxFriendLabel = Instance.new("TextLabel")
    sandboxFriendLabel.Size = UDim2.new(1, -20, 0, 30)
    sandboxFriendLabel.Position = UDim2.new(0, 10, 0, 440)
    sandboxFriendLabel.BackgroundTransparency = 1
    sandboxFriendLabel.Text = "👥 Invite Friend to Sandbox+:"
    sandboxFriendLabel.TextColor3 = Color3.white
    sandboxFriendLabel.TextScaled = true
    sandboxFriendLabel.Font = Enum.Font.Gotham
    sandboxFriendLabel.Parent = frame
    
    local sandboxFriendInput = Instance.new("TextBox")
    sandboxFriendInput.Size = UDim2.new(0.6, 0, 0, 40)
    sandboxFriendInput.Position = UDim2.new(0.05, 0, 0, 470)
    sandboxFriendInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sandboxFriendInput.Text = "Player Name..."
    sandboxFriendInput.TextColor3 = Color3.white
    sandboxFriendInput.TextScaled = true
    sandboxFriendInput.Font = Enum.Font.Gotham
    sandboxFriendInput.Parent = frame
    
    local sandboxInputCorner = Instance.new("UICorner")
    sandboxInputCorner.CornerRadius = UDim.new(0, 8)
    sandboxInputCorner.Parent = sandboxFriendInput
    
    local sandboxInviteBtn = Instance.new("TextButton")
    sandboxInviteBtn.Size = UDim2.new(0.3, 0, 0, 40)
    sandboxInviteBtn.Position = UDim2.new(0.65, 0, 0, 470)
    sandboxInviteBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
    sandboxInviteBtn.Text = "📤 Invite"
    sandboxInviteBtn.TextColor3 = Color3.white
    sandboxInviteBtn.TextScaled = true
    sandboxInviteBtn.Font = Enum.Font.GothamBold
    sandboxInviteBtn.Parent = frame
    
    local sandboxInviteCorner = Instance.new("UICorner")
    sandboxInviteCorner.CornerRadius = UDim.new(0, 8)
    sandboxInviteCorner.Parent = sandboxInviteBtn
    
    -- Features info
    local featuresLabel = Instance.new("TextLabel")
    featuresLabel.Size = UDim2.new(1, -20, 0, 140)
    featuresLabel.Position = UDim2.new(0, 10, 0, 530)
    featuresLabel.BackgroundTransparency = 1
    featuresLabel.Text = "🌟 FEATURES:\n🏭 45 Unique Machines\n🌍 Dynamic Biomes\n🏆 Prestige System\n🎲 Random Events\n👥 Friend System\n💾 Auto-Save Progress"
    featuresLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    featuresLabel.TextScaled = true
    featuresLabel.Font = Enum.Font.Gotham
    featuresLabel.TextYAlignment = Enum.TextYAlignment.Top
    featuresLabel.Parent = frame
    
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
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 30)
    closeCorner.Parent = closeBtn
    
    -- Button connections
    sharedBtn.MouseButton1Click:Connect(function()
        remotes.TeleportToSharedWorld:FireServer()
        gui:Destroy()
    end)
    
    sandboxBtn.MouseButton1Click:Connect(function()
        remotes.TeleportToSandboxPlus:FireServer()
        gui:Destroy()
    end)
    
    inviteBtn.MouseButton1Click:Connect(function()
        if friendInput.Text ~= "" and friendInput.Text ~= "Player Name..." then
            remotes.InviteFriend:FireServer(friendInput.Text, "SharedWorld")
        end
    end)
    
    sandboxInviteBtn.MouseButton1Click:Connect(function()
        if sandboxFriendInput.Text ~= "" and sandboxFriendInput.Text ~= "Player Name..." then
            remotes.InviteFriend:FireServer(sandboxFriendInput.Text, "Sandbox+")
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
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
        remotes.AdminFloatDown:FireServer()
    end)
end

-- Key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        local existingMenu = playerGui:FindFirstChild("MainMenu")
        if existingMenu then
            existingMenu:Destroy()
        else
            createMainMenu()
        end
    end
end)

-- Create admin crown and show welcome
createAdminCrown()

spawn(function()
    wait(3)
    local gui = Instance.new("ScreenGui")
    gui.Name = "WelcomeMessage"
    gui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.6, 0, 0.4, 0)
    frame.Position = UDim2.new(0.2, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 80, 150)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, -20)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = "🌟 Welcome to Mega Tycoon Empire! 🌟\n\nPress G to open the Main Menu\nClick 👑 for Admin Tools\n\n🏗️ Build factories in SharedWorld\n🧪 Create freely in Sandbox+\n👥 Invite friends to join you!"
    label.TextColor3 = Color3.white
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    wait(10)
    gui:Destroy()
end)

print("🎮 Main Hub Client UI loaded! Press G for menu, click 👑 for admin")
]]

-- 📡 REMOTE EVENT HANDLERS
remoteFolder.TeleportToSharedWorld.OnServerEvent:Connect(function(player)
    local success, message = TeleportationSystem:TeleportToSharedWorld(player)
    if not success then
        -- Send error message to player
        local gui = Instance.new("ScreenGui")
        gui.Name = "ErrorMessage"
        gui.Parent = player.PlayerGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 400, 0, 100)
        frame.Position = UDim2.new(0.5, -200, 0.1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        frame.BorderSizePixel = 0
        frame.Parent = gui
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "❌ " .. message
        label.TextColor3 = Color3.white
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = frame
        
        game:GetService("Debris"):AddItem(gui, 5)
    end
end)

remoteFolder.TeleportToSandboxPlus.OnServerEvent:Connect(function(player)
    local success, message = TeleportationSystem:TeleportToSandboxPlus(player)
    if not success then
        -- Send error message to player
        local gui = Instance.new("ScreenGui")
        gui.Name = "ErrorMessage"
        gui.Parent = player.PlayerGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 400, 0, 100)
        frame.Position = UDim2.new(0.5, -200, 0.1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        frame.BorderSizePixel = 0
        frame.Parent = gui
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "❌ " .. message
        label.TextColor3 = Color3.white
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = frame
        
        game:GetService("Debris"):AddItem(gui, 5)
    end
end)

remoteFolder.InviteFriend.OnServerEvent:Connect(function(player, targetName, destination)
    local success, message = FriendSystem:InviteFriend(player, targetName, destination)
    
    -- Send result message to player
    local gui = Instance.new("ScreenGui")
    gui.Name = "InviteResult"
    gui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 100)
    frame.Position = UDim2.new(0.5, -200, 0.1, 0)
    frame.BackgroundColor3 = success and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = (success and "✅ " or "❌ ") .. message
    label.TextColor3 = Color3.white
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    game:GetService("Debris"):AddItem(gui, 5)
end)

remoteFolder.AdminFloatDown.OnServerEvent:Connect(function(player)
    AdminSystem:AdminFloatDown(player)
end)

-- 👤 PLAYER MANAGEMENT
Players.PlayerAdded:Connect(function(player)
    print("👤 " .. player.Name .. " joined the Main Hub!")
    
    -- Create leaderstats
    createLeaderstats(player)
    
    -- Load player data
    wait(1)
    loadPlayerData(player)
    
    -- Check for pending teleport data (returning from sub-place)
    spawn(function()
        wait(2)
        local success, teleportData = pcall(function()
            return TeleportDataStore:GetAsync("TeleportData_" .. player.UserId)
        end)
        
        if success and teleportData and teleportData.returning then
            print("📦 " .. player.Name .. " returned from " .. (teleportData.destination or "sub-place"))
            -- Restore any data if needed
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    -- Save player data
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local data = {
            Cash = leaderstats["Cash 💸"].Value,
            Power = leaderstats["Power 🔋"].Value,
            PrestigeLevel = leaderstats["Prestige ⭐"].Value,
            EcoScore = leaderstats["Eco Score 🌱"].Value,
            LastPlayed = os.time()
        }
        
        pcall(function()
            PlayerDataStore:SetAsync("Player_" .. player.UserId, data)
        end)
        
        print("💾 Saved data for " .. player.Name)
    end
end)

-- 🔥 COMPLETION
wait(2)
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ MAIN HUB SYSTEM COMPLETE! ✅")
print("🏠 Main Hub Place ID: " .. MAIN_HUB_PLACE_ID)
print("👑 Superadmin: LeviStopMo2021 (ID: " .. SUPERADMIN_ID .. ")")
print("🎮 Controls: G=Main Menu, 👑=Admin Tools")
print("📝 IMPORTANT: Set your SharedWorld and Sandbox+ Place IDs in the configuration!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")