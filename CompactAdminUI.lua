-- 👑 COMPACT ADMIN UI SYSTEM
-- Small corner button that expands to show admin tools

local CompactAdminUI = {}

-- 🎯 SERVICE REFERENCES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function CompactAdminUI:CreateCompactAdminUI()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local adminGui = Instance.new("ScreenGui")
    adminGui.Name = "CompactAdminUI"
    adminGui.Parent = playerGui
    
    -- 👑 COMPACT ADMIN BUTTON (TOP RIGHT CORNER)
    local adminButton = Instance.new("TextButton")
    adminButton.Name = "AdminButton"
    adminButton.Size = UDim2.new(0, 50, 0, 50)
    adminButton.Position = UDim2.new(1, -60, 0, 10)
    adminButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    adminButton.Text = "👑"
    adminButton.TextColor3 = Color3.white
    adminButton.TextScaled = true
    adminButton.Font = Enum.Font.GothamBold
    adminButton.ZIndex = 10
    adminButton.Parent = adminGui
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 25)
    buttonCorner.Parent = adminButton
    
    -- 📋 EXPANDED ADMIN PANEL (HIDDEN BY DEFAULT)
    local adminPanel = Instance.new("Frame")
    adminPanel.Name = "AdminPanel"
    adminPanel.Size = UDim2.new(0, 300, 0, 400)
    adminPanel.Position = UDim2.new(1, -310, 0, 70)
    adminPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    adminPanel.BorderSizePixel = 0
    adminPanel.Visible = false
    adminPanel.ZIndex = 9
    adminPanel.Parent = adminGui
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 12)
    panelCorner.Parent = adminPanel
    
    -- 👑 PANEL TITLE
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -20, 0, 40)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "👑 ADMIN TOOLS"
    titleLabel.TextColor3 = Color3.white
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.ZIndex = 10
    titleLabel.Parent = adminPanel
    
    -- 📋 SCROLL FRAME FOR ADMIN TOOLS
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "AdminScrollFrame"
    scrollFrame.Size = UDim2.new(1, -20, 1, -60)
    scrollFrame.Position = UDim2.new(0, 10, 0, 50)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
    scrollFrame.ZIndex = 10
    scrollFrame.Parent = adminPanel
    
    -- 🔧 ADMIN TOOLS
    local adminTools = {
        {text = "💰 Give Money", action = "GiveMoney", color = Color3.fromRGB(50, 200, 50)},
        {text = "➕ Add Admin", action = "AddAdmin", color = Color3.fromRGB(100, 150, 255)},
        {text = "📢 Broadcast", action = "Broadcast", color = Color3.fromRGB(255, 150, 50)},
        {text = "🔋 Power Diag", action = "PowerDiag", color = Color3.fromRGB(255, 200, 50)},
        {text = "🌪️ Random Event", action = "RandomEvent", color = Color3.fromRGB(150, 100, 255)},
        {text = "👑 Float Down", action = "FloatDown", color = Color3.fromRGB(100, 200, 255)},
        {text = "🔋 Charge All", action = "ChargeAll", color = Color3.fromRGB(100, 255, 200)},
        {text = "🌱 Update Eco", action = "UpdateEco", color = Color3.fromRGB(100, 255, 100)}
    }
    
    for i, tool in ipairs(adminTools) do
        local toolButton = Instance.new("TextButton")
        toolButton.Name = tool.action .. "Button"
        toolButton.Size = UDim2.new(1, -10, 0, 40)
        toolButton.Position = UDim2.new(0, 5, 0, (i-1) * 50 + 10)
        toolButton.BackgroundColor3 = tool.color
        toolButton.Text = tool.text
        toolButton.TextColor3 = Color3.white
        toolButton.TextScaled = true
        toolButton.Font = Enum.Font.Gotham
        toolButton.ZIndex = 11
        toolButton.Parent = scrollFrame
        
        local toolCorner = Instance.new("UICorner")
        toolCorner.CornerRadius = UDim.new(0, 8)
        toolCorner.Parent = toolButton
        
        -- Connect button action
        toolButton.MouseButton1Click:Connect(function()
            CompactAdminUI:ExecuteAdminAction(tool.action)
        end)
        
        -- Hover effect
        toolButton.MouseEnter:Connect(function()
            local tween = TweenService:Create(toolButton, TweenInfo.new(0.2), {
                Size = UDim2.new(1, -5, 0, 42)
            })
            tween:Play()
        end)
        
        toolButton.MouseLeave:Connect(function()
            local tween = TweenService:Create(toolButton, TweenInfo.new(0.2), {
                Size = UDim2.new(1, -10, 0, 40)
            })
            tween:Play()
        end)
    end
    
    -- 🎮 TOGGLE FUNCTIONALITY
    local isExpanded = false
    
    adminButton.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded
        
        if isExpanded then
            -- Show panel with animation
            adminPanel.Visible = true
            adminPanel.Size = UDim2.new(0, 0, 0, 400)
            
            local expandTween = TweenService:Create(adminPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 300, 0, 400)
            })
            expandTween:Play()
            
            -- Rotate button
            local rotateTween = TweenService:Create(adminButton, TweenInfo.new(0.3), {
                Rotation = 180
            })
            rotateTween:Play()
            
        else
            -- Hide panel with animation
            local collapseTween = TweenService:Create(adminPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 0, 0, 400)
            })
            collapseTween:Play()
            
            collapseTween.Completed:Connect(function()
                adminPanel.Visible = false
            end)
            
            -- Rotate button back
            local rotateTween = TweenService:Create(adminButton, TweenInfo.new(0.3), {
                Rotation = 0
            })
            rotateTween:Play()
        end
    end)
    
    -- 🎨 PULSING EFFECT FOR ADMIN BUTTON
    spawn(function()
        while adminButton.Parent do
            local pulseTween = TweenService:Create(adminButton, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            })
            pulseTween:Play()
            wait(4)
            pulseTween:Cancel()
        end
    end)
    
    -- 🖱️ CLICK OUTSIDE TO CLOSE
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isExpanded then
            local mousePos = UserInputService:GetMouseLocation()
            local panelPos = adminPanel.AbsolutePosition
            local panelSize = adminPanel.AbsoluteSize
            
            -- Check if click is outside the panel
            if mousePos.X < panelPos.X or mousePos.X > panelPos.X + panelSize.X or
               mousePos.Y < panelPos.Y or mousePos.Y > panelPos.Y + panelSize.Y then
                
                -- Check if click is also outside the button
                local buttonPos = adminButton.AbsolutePosition
                local buttonSize = adminButton.AbsoluteSize
                
                if mousePos.X < buttonPos.X or mousePos.X > buttonPos.X + buttonSize.X or
                   mousePos.Y < buttonPos.Y or mousePos.Y > buttonPos.Y + buttonSize.Y then
                    
                    -- Close the panel
                    adminButton.MouseButton1Click:Fire()
                end
            end
        end
    end)
    
    return adminGui
end

-- 🎮 EXECUTE ADMIN ACTION
function CompactAdminUI:ExecuteAdminAction(action)
    local remotes = ReplicatedStorage:WaitForChild("TycoonRemotes")
    
    if action == "GiveMoney" then
        -- Quick give money (could add input dialog later)
        local targetPlayer = CompactAdminUI:GetNearestPlayer()
        if targetPlayer then
            remotes.GiveMoney:FireServer(targetPlayer, 10000)
            CompactAdminUI:ShowNotification("💰 Gave $10,000 to " .. targetPlayer.Name)
        else
            CompactAdminUI:ShowNotification("❌ No nearby players found")
        end
        
    elseif action == "AddAdmin" then
        local targetPlayer = CompactAdminUI:GetNearestPlayer()
        if targetPlayer then
            remotes.AddAdmin:FireServer(targetPlayer.UserId)
            CompactAdminUI:ShowNotification("➕ Added " .. targetPlayer.Name .. " as admin")
        else
            CompactAdminUI:ShowNotification("❌ No nearby players found")
        end
        
    elseif action == "Broadcast" then
        remotes.BroadcastMessage:FireServer("Admin message from the corner!")
        CompactAdminUI:ShowNotification("📢 Broadcast sent!")
        
    elseif action == "PowerDiag" then
        remotes.PowerDiagnostics:FireServer()
        CompactAdminUI:ShowNotification("🔋 Running power diagnostics...")
        
    elseif action == "RandomEvent" then
        remotes.TriggerRandomEvent:FireServer()
        CompactAdminUI:ShowNotification("🌪️ Random event triggered!")
        
    elseif action == "FloatDown" then
        remotes.AdminFloatDown:FireServer()
        CompactAdminUI:ShowNotification("👑 Admin float down activated!")
        
    elseif action == "ChargeAll" then
        remotes.ChargeAllBatteries:FireServer()
        CompactAdminUI:ShowNotification("🔋 All batteries charged!")
        
    elseif action == "UpdateEco" then
        remotes.UpdateEcoScore:FireServer()
        CompactAdminUI:ShowNotification("🌱 Eco scores updated!")
    end
end

-- 🎯 GET NEAREST PLAYER
function CompactAdminUI:GetNearestPlayer()
    local player = Players.LocalPlayer
    local character = player.Character
    if not character or not character.PrimaryPart then return nil end
    
    local nearestPlayer = nil
    local shortestDistance = math.huge
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character.PrimaryPart then
            local distance = (character.PrimaryPart.Position - otherPlayer.Character.PrimaryPart.Position).Magnitude
            if distance < shortestDistance and distance < 50 then -- Within 50 studs
                shortestDistance = distance
                nearestPlayer = otherPlayer
            end
        end
    end
    
    return nearestPlayer
end

-- 📝 SHOW NOTIFICATION
function CompactAdminUI:ShowNotification(message)
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "AdminNotification"
    notifGui.Parent = playerGui
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 300, 0, 60)
    notifFrame.Position = UDim2.new(1, -310, 0, 80)
    notifFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notifGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notifFrame
    
    local notifLabel = Instance.new("TextLabel")
    notifLabel.Size = UDim2.new(1, -20, 1, -10)
    notifLabel.Position = UDim2.new(0, 10, 0, 5)
    notifLabel.BackgroundTransparency = 1
    notifLabel.Text = message
    notifLabel.TextColor3 = Color3.white
    notifLabel.TextScaled = true
    notifLabel.Font = Enum.Font.Gotham
    notifLabel.Parent = notifFrame
    
    -- Slide in animation
    notifFrame.Position = UDim2.new(1, 10, 0, 80)
    local slideInTween = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -310, 0, 80)
    })
    slideInTween:Play()
    
    -- Auto-hide after 3 seconds
    spawn(function()
        wait(3)
        local slideOutTween = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(1, 10, 0, 80)
        })
        slideOutTween:Play()
        
        slideOutTween.Completed:Connect(function()
            notifGui:Destroy()
        end)
    end)
end

-- 🎮 CHECK IF PLAYER IS ADMIN
function CompactAdminUI:CheckAdminStatus()
    local player = Players.LocalPlayer
    local remotes = ReplicatedStorage:WaitForChild("TycoonRemotes")
    
    -- This would need to be implemented server-side
    -- For now, return true for testing
    return true
end

-- 🚀 INITIALIZE COMPACT ADMIN UI
function CompactAdminUI:Initialize()
    local player = Players.LocalPlayer
    
    -- Wait for character to load
    player.CharacterAdded:Connect(function()
        wait(2) -- Give time for everything to load
        
        if CompactAdminUI:CheckAdminStatus() then
            CompactAdminUI:CreateCompactAdminUI()
            print("👑 Compact Admin UI loaded for " .. player.Name)
        end
    end)
    
    -- If character already exists
    if player.Character then
        wait(2)
        if CompactAdminUI:CheckAdminStatus() then
            CompactAdminUI:CreateCompactAdminUI()
            print("👑 Compact Admin UI loaded for " .. player.Name)
        end
    end
end

return CompactAdminUI