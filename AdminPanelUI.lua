-- 👑 ADMIN PANEL UI SYSTEM
-- Complete admin interface with all management tools

local AdminPanelUI = {}

-- 🎯 SERVICE REFERENCES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function AdminPanelUI:CreateAdminPanel()
    local adminGui = Instance.new("ScreenGui")
    adminGui.Name = "AdminPanelUI"
    adminGui.Parent = ReplicatedStorage:WaitForChild("TycoonGUIs")
    
    -- 👑 MAIN ADMIN FRAME
    local adminFrame = Instance.new("Frame")
    adminFrame.Name = "AdminFrame"
    adminFrame.Size = UDim2.new(0, 600, 0, 700)
    adminFrame.Position = UDim2.new(0.5, -300, 0.5, -350)
    adminFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    adminFrame.BorderSizePixel = 0
    adminFrame.Visible = false
    adminFrame.Parent = adminGui
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = adminFrame
    
    -- 👑 TITLE BAR
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 60)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = adminFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    titleLabel.Position = UDim2.new(0.1, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "👑 ADMIN CONTROL PANEL"
    titleLabel.TextColor3 = Color3.white
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -50, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.white
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeBtn
    
    -- 📋 SCROLL FRAME FOR ADMIN TOOLS
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "AdminToolsScroll"
    scrollFrame.Size = UDim2.new(1, -20, 1, -80)
    scrollFrame.Position = UDim2.new(0, 10, 0, 70)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1200)
    scrollFrame.Parent = adminFrame
    
    -- 💰 MONEY MANAGEMENT SECTION
    local moneySection = AdminPanelUI:CreateSection(scrollFrame, "💰 MONEY MANAGEMENT", 0)
    
    -- Target player input
    local playerInput = AdminPanelUI:CreateInputBox(moneySection, "Target Player Name:", "Enter username...")
    local amountInput = AdminPanelUI:CreateInputBox(moneySection, "Amount:", "Enter amount...")
    local giveMoneyBtn = AdminPanelUI:CreateButton(moneySection, "💸 Give Money", Color3.fromRGB(50, 200, 50))
    
    -- 👥 PLAYER MANAGEMENT SECTION
    local playerSection = AdminPanelUI:CreateSection(scrollFrame, "👥 PLAYER MANAGEMENT", 200)
    
    local adminInput = AdminPanelUI:CreateInputBox(playerSection, "Player to Add/Remove:", "Enter username...")
    local addAdminBtn = AdminPanelUI:CreateButton(playerSection, "➕ Add Admin", Color3.fromRGB(100, 150, 255))
    local removeAdminBtn = AdminPanelUI:CreateButton(playerSection, "➖ Remove Admin", Color3.fromRGB(255, 100, 100))
    
    -- 📢 BROADCAST SECTION
    local broadcastSection = AdminPanelUI:CreateSection(scrollFrame, "📢 BROADCAST MESSAGES", 400)
    
    local messageInput = AdminPanelUI:CreateInputBox(broadcastSection, "Message:", "Enter broadcast message...")
    local broadcastBtn = AdminPanelUI:CreateButton(broadcastSection, "📣 Send Broadcast", Color3.fromRGB(255, 150, 50))
    
    -- 🔧 DIAGNOSTIC TOOLS SECTION
    local diagnosticSection = AdminPanelUI:CreateSection(scrollFrame, "🔧 DIAGNOSTIC TOOLS", 600)
    
    local powerDiagBtn = AdminPanelUI:CreateButton(diagnosticSection, "🔋 Power Diagnostics", Color3.fromRGB(255, 200, 50))
    local serverEventsBtn = AdminPanelUI:CreateButton(diagnosticSection, "🌪️ Trigger Random Event", Color3.fromRGB(150, 100, 255))
    local ecoScoreBtn = AdminPanelUI:CreateButton(diagnosticSection, "🌱 Update Eco Scores", Color3.fromRGB(100, 255, 100))
    
    -- 🏗️ SHARED WORLD TOOLS SECTION
    local sharedWorldSection = AdminPanelUI:CreateSection(scrollFrame, "🏗️ SHARED WORLD TOOLS", 800)
    
    local floatDownBtn = AdminPanelUI:CreateButton(sharedWorldSection, "👑 Admin Float Down", Color3.fromRGB(100, 200, 255))
    local approveIslandBtn = AdminPanelUI:CreateButton(sharedWorldSection, "⭐ Approve Public Island", Color3.fromRGB(255, 200, 100))
    
    -- 🧪 SANDBOX+ ADMIN OVERRIDE SECTION
    local sandboxSection = AdminPanelUI:CreateSection(scrollFrame, "🧪 SANDBOX+ OVERRIDES", 1000)
    
    local chargeBatteriesBtn = AdminPanelUI:CreateButton(sandboxSection, "🔋 Charge All Batteries", Color3.fromRGB(100, 255, 200))
    local giveMoneyPersonalBtn = AdminPanelUI:CreateButton(sandboxSection, "💰 Give Yourself Money", Color3.fromRGB(255, 200, 50))
    
    -- 🎮 EVENT CONNECTIONS
    AdminPanelUI:ConnectAdminEvents(adminFrame, playerInput, amountInput, giveMoneyBtn, adminInput, addAdminBtn, removeAdminBtn, messageInput, broadcastBtn, powerDiagBtn, serverEventsBtn, ecoScoreBtn, floatDownBtn, approveIslandBtn, chargeBatteriesBtn, giveMoneyPersonalBtn, closeBtn)
    
    return adminGui
end

-- 📦 CREATE SECTION HELPER
function AdminPanelUI:CreateSection(parent, title, yPosition)
    local section = Instance.new("Frame")
    section.Name = title:gsub("[^%w]", "")
    section.Size = UDim2.new(1, -20, 0, 180)
    section.Position = UDim2.new(0, 10, 0, yPosition)
    section.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 10)
    sectionCorner.Parent = section
    
    -- Section title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "SectionTitle"
    titleLabel.Size = UDim2.new(1, -20, 0, 40)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.white
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section
    
    return section
end

-- 📝 CREATE INPUT BOX HELPER
function AdminPanelUI:CreateInputBox(parent, labelText, placeholder)
    local yPos = #parent:GetChildren() * 35 + 45
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = labelText:gsub("[^%w]", "") .. "Label"
    label.Size = UDim2.new(0.3, 0, 0, 25)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.white
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    -- Input box
    local input = Instance.new("TextBox")
    input.Name = labelText:gsub("[^%w]", "") .. "Input"
    input.Size = UDim2.new(0.65, -10, 0, 25)
    input.Position = UDim2.new(0.35, 0, 0, yPos)
    input.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    input.BorderSizePixel = 0
    input.Text = ""
    input.PlaceholderText = placeholder
    input.TextColor3 = Color3.white
    input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    input.TextScaled = true
    input.Font = Enum.Font.Gotham
    input.Parent = parent
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 5)
    inputCorner.Parent = input
    
    return input
end

-- 🔘 CREATE BUTTON HELPER
function AdminPanelUI:CreateButton(parent, text, color)
    local yPos = #parent:GetChildren() * 35 + 45
    
    local button = Instance.new("TextButton")
    button.Name = text:gsub("[^%w]", "") .. "Button"
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.white
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, -15, 0, 32)})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, 30)})
        tween:Play()
    end)
    
    return button
end

-- 🎮 CONNECT ADMIN EVENTS
function AdminPanelUI:ConnectAdminEvents(adminFrame, playerInput, amountInput, giveMoneyBtn, adminInput, addAdminBtn, removeAdminBtn, messageInput, broadcastBtn, powerDiagBtn, serverEventsBtn, ecoScoreBtn, floatDownBtn, approveIslandBtn, chargeBatteriesBtn, giveMoneyPersonalBtn, closeBtn)
    
    local remotes = ReplicatedStorage:WaitForChild("TycoonRemotes")
    
    -- Close panel
    closeBtn.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(adminFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -300, -1, 0)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            adminFrame.Visible = false
        end)
    end)
    
    -- 💰 Money Management
    giveMoneyBtn.MouseButton1Click:Connect(function()
        local targetName = playerInput.Text
        local amount = tonumber(amountInput.Text)
        
        if targetName ~= "" and amount then
            local targetPlayer = Players:FindFirstChild(targetName)
            if targetPlayer then
                remotes.GiveMoney:FireServer(targetPlayer, amount)
                playerInput.Text = ""
                amountInput.Text = ""
                print("💰 Gave $" .. amount .. " to " .. targetName)
            else
                print("❌ Player not found: " .. targetName)
            end
        end
    end)
    
    -- 👥 Admin Management
    addAdminBtn.MouseButton1Click:Connect(function()
        local targetName = adminInput.Text
        if targetName ~= "" then
            local targetPlayer = Players:FindFirstChild(targetName)
            if targetPlayer then
                remotes.AddAdmin:FireServer(targetPlayer.UserId)
                adminInput.Text = ""
                print("➕ Added admin: " .. targetName)
            else
                print("❌ Player not found: " .. targetName)
            end
        end
    end)
    
    removeAdminBtn.MouseButton1Click:Connect(function()
        local targetName = adminInput.Text
        if targetName ~= "" then
            local targetPlayer = Players:FindFirstChild(targetName)
            if targetPlayer then
                remotes.RemoveAdmin:FireServer(targetPlayer.UserId)
                adminInput.Text = ""
                print("➖ Removed admin: " .. targetName)
            else
                print("❌ Player not found: " .. targetName)
            end
        end
    end)
    
    -- 📢 Broadcast
    broadcastBtn.MouseButton1Click:Connect(function()
        local message = messageInput.Text
        if message ~= "" then
            remotes.BroadcastMessage:FireServer(message)
            messageInput.Text = ""
            print("📣 Broadcasted: " .. message)
        end
    end)
    
    -- 🔧 Diagnostic Tools
    powerDiagBtn.MouseButton1Click:Connect(function()
        remotes.PowerDiagnostics:FireServer()
        print("🔋 Running power diagnostics...")
    end)
    
    serverEventsBtn.MouseButton1Click:Connect(function()
        remotes.TriggerRandomEvent:FireServer()
        print("🌪️ Triggered random event!")
    end)
    
    ecoScoreBtn.MouseButton1Click:Connect(function()
        remotes.UpdateEcoScore:FireServer()
        print("🌱 Updated eco scores for all players!")
    end)
    
    -- 🏗️ SharedWorld Tools
    floatDownBtn.MouseButton1Click:Connect(function()
        remotes.AdminFloatDown:FireServer()
        print("👑 Admin float down activated!")
    end)
    
    approveIslandBtn.MouseButton1Click:Connect(function()
        -- This would need additional UI for selecting which island to approve
        print("⭐ Island approval system activated!")
    end)
    
    -- 🧪 Sandbox+ Overrides
    chargeBatteriesBtn.MouseButton1Click:Connect(function()
        remotes.ChargeAllBatteries:FireServer()
        print("🔋 Charged all batteries!")
    end)
    
    giveMoneyPersonalBtn.MouseButton1Click:Connect(function()
        remotes.AdminGiveMoney:FireServer(1000000) -- Give 1M to self
        print("💰 Gave yourself $1,000,000!")
    end)
end

-- 🎮 TOGGLE ADMIN PANEL FUNCTION
function AdminPanelUI:ToggleAdminPanel()
    local adminGui = ReplicatedStorage.TycoonGUIs:FindFirstChild("AdminPanelUI")
    if not adminGui then
        adminGui = AdminPanelUI:CreateAdminPanel()
    end
    
    local adminFrame = adminGui.AdminFrame
    
    if adminFrame.Visible then
        -- Hide panel
        local tween = TweenService:Create(adminFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -300, -1, 0)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            adminFrame.Visible = false
        end)
    else
        -- Show panel
        adminFrame.Visible = true
        adminFrame.Position = UDim2.new(0.5, -300, -1, 0)
        
        local tween = TweenService:Create(adminFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -300, 0.5, -350)
        })
        tween:Play()
    end
end

return AdminPanelUI