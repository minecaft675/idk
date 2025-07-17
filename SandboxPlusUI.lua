-- 🧪 SANDBOX+ UI SYSTEM
-- Premium gamepass exclusive interface with unlimited build mode

local SandboxPlusUI = {}

-- 🎯 SERVICE REFERENCES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Mouse = Players.LocalPlayer:GetMouse()

function SandboxPlusUI:CreateSandboxUI()
    local sandboxGui = Instance.new("ScreenGui")
    sandboxGui.Name = "SandboxPlusUI"
    sandboxGui.Parent = ReplicatedStorage:WaitForChild("TycoonGUIs")
    
    -- 🧪 MAIN SANDBOX FRAME
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "SandboxMainFrame"
    mainFrame.Size = UDim2.new(0, 800, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = sandboxGui
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    -- 🧪 TITLE BAR
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 60)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0.15, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🧪 SANDBOX+ UNLIMITED MODE"
    titleLabel.TextColor3 = Color3.white
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    -- Toggle button (minimize/maximize)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Size = UDim2.new(0, 40, 0, 40)
    toggleBtn.Position = UDim2.new(1, -100, 0, 10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    toggleBtn.Text = "─"
    toggleBtn.TextColor3 = Color3.white
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = titleBar
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(0, 8)
    toggleBtnCorner.Parent = toggleBtn
    
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
    
    -- 📋 TAB SYSTEM
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(1, -20, 0, 40)
    tabFrame.Position = UDim2.new(0, 10, 0, 70)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = mainFrame
    
    local tabs = {
        {name = "🎁 Spawn Menu", id = "SpawnMenu"},
        {name = "⚡ Time Control", id = "TimeControl"},
        {name = "👑 Admin Tools", id = "AdminTools"},
        {name = "📊 Settings", id = "Settings"}
    }
    
    local tabButtons = {}
    local tabContents = {}
    
    -- Create tab buttons
    for i, tab in ipairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tab.id .. "Tab"
        tabBtn.Size = UDim2.new(0.25, -5, 1, 0)
        tabBtn.Position = UDim2.new((i-1) * 0.25, 2.5, 0, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        tabBtn.Text = tab.name
        tabBtn.TextColor3 = Color3.white
        tabBtn.TextScaled = true
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.Parent = tabFrame
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabBtn
        
        tabButtons[tab.id] = tabBtn
    end
    
    -- 📋 CONTENT AREA
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -130)
    contentFrame.Position = UDim2.new(0, 10, 0, 120)
    contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = contentFrame
    
    -- 🎁 SPAWN MENU TAB
    local spawnTab = SandboxPlusUI:CreateSpawnMenuTab(contentFrame)
    tabContents["SpawnMenu"] = spawnTab
    
    -- ⚡ TIME CONTROL TAB
    local timeTab = SandboxPlusUI:CreateTimeControlTab(contentFrame)
    tabContents["TimeControl"] = timeTab
    
    -- 👑 ADMIN TOOLS TAB
    local adminTab = SandboxPlusUI:CreateAdminToolsTab(contentFrame)
    tabContents["AdminTools"] = adminTab
    
    -- 📊 SETTINGS TAB
    local settingsTab = SandboxPlusUI:CreateSettingsTab(contentFrame)
    tabContents["Settings"] = settingsTab
    
    -- 🎮 TAB SWITCHING LOGIC
    local currentTab = "SpawnMenu"
    
    local function switchTab(tabId)
        -- Hide all tabs
        for id, content in pairs(tabContents) do
            content.Visible = false
            tabButtons[id].BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end
        
        -- Show selected tab
        tabContents[tabId].Visible = true
        tabButtons[tabId].BackgroundColor3 = Color3.fromRGB(255, 150, 50)
        currentTab = tabId
    end
    
    -- Connect tab buttons
    for id, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            switchTab(id)
        end)
    end
    
    -- Initialize first tab
    switchTab("SpawnMenu")
    
    -- 🎮 MAIN UI CONTROLS
    SandboxPlusUI:ConnectSandboxEvents(mainFrame, toggleBtn, closeBtn)
    
    return sandboxGui
end

-- 🎁 SPAWN MENU TAB
function SandboxPlusUI:CreateSpawnMenuTab(parent)
    local spawnFrame = Instance.new("Frame")
    spawnFrame.Name = "SpawnMenuContent"
    spawnFrame.Size = UDim2.new(1, 0, 1, 0)
    spawnFrame.Position = UDim2.new(0, 0, 0, 0)
    spawnFrame.BackgroundTransparency = 1
    spawnFrame.Parent = parent
    
    -- 📋 ITEM CATEGORIES
    local categories = {
        ["🏭 Machines"] = {"Factory Machine", "Money Printer", "Auto Sorter", "Resource Generator"},
        ["⚡ Power"] = {"Solar Panel", "Battery", "Power Generator", "Fuel Tank"},
        ["🛤️ Transport"] = {"Conveyor Belt", "Teleporter", "Dropper", "Collector"},
        ["🏗️ Structure"] = {"Foundation", "Wall", "Roof", "Platform"}
    }
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ItemScrollFrame"
    scrollFrame.Size = UDim2.new(1, -20, 1, -20)
    scrollFrame.Position = UDim2.new(0, 10, 0, 10)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = spawnFrame
    
    local yPosition = 0
    
    for categoryName, items in pairs(categories) do
        -- Category header
        local categoryLabel = Instance.new("TextLabel")
        categoryLabel.Name = categoryName:gsub("[^%w]", "") .. "Label"
        categoryLabel.Size = UDim2.new(1, -20, 0, 40)
        categoryLabel.Position = UDim2.new(0, 10, 0, yPosition)
        categoryLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        categoryLabel.Text = categoryName
        categoryLabel.TextColor3 = Color3.white
        categoryLabel.TextScaled = true
        categoryLabel.Font = Enum.Font.GothamBold
        categoryLabel.Parent = scrollFrame
        
        local categoryCorner = Instance.new("UICorner")
        categoryCorner.CornerRadius = UDim.new(0, 8)
        categoryCorner.Parent = categoryLabel
        
        yPosition = yPosition + 50
        
        -- Item buttons
        for i, itemName in ipairs(items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Name = itemName:gsub("[^%w]", "") .. "Button"
            itemBtn.Size = UDim2.new(0.48, 0, 0, 60)
            itemBtn.Position = UDim2.new(((i-1) % 2) * 0.52, 10, 0, yPosition + math.floor((i-1) / 2) * 70)
            itemBtn.BackgroundColor3 = Color3.fromRGB(70, 100, 150)
            itemBtn.Text = "📦 " .. itemName
            itemBtn.TextColor3 = Color3.white
            itemBtn.TextScaled = true
            itemBtn.Font = Enum.Font.Gotham
            itemBtn.Parent = scrollFrame
            
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 8)
            itemCorner.Parent = itemBtn
            
            -- Spawn item on click
            itemBtn.MouseButton1Click:Connect(function()
                SandboxPlusUI:SpawnItem(itemName)
            end)
            
            -- Hover effect
            itemBtn.MouseEnter:Connect(function()
                local tween = TweenService:Create(itemBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(90, 120, 170)
                })
                tween:Play()
            end)
            
            itemBtn.MouseLeave:Connect(function()
                local tween = TweenService:Create(itemBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(70, 100, 150)
                })
                tween:Play()
            end)
        end
        
        yPosition = yPosition + math.ceil(#items / 2) * 70 + 20
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPosition)
    
    return spawnFrame
end

-- ⚡ TIME CONTROL TAB
function SandboxPlusUI:CreateTimeControlTab(parent)
    local timeFrame = Instance.new("Frame")
    timeFrame.Name = "TimeControlContent"
    timeFrame.Size = UDim2.new(1, 0, 1, 0)
    timeFrame.Position = UDim2.new(0, 0, 0, 0)
    timeFrame.BackgroundTransparency = 1
    timeFrame.Visible = false
    timeFrame.Parent = parent
    
    -- ⚡ TIME ACCELERATION CONTROLS
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Name = "TimeLabel"
    timeLabel.Size = UDim2.new(1, -40, 0, 60)
    timeLabel.Position = UDim2.new(0, 20, 0, 20)
    timeLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    timeLabel.Text = "⚡ TIME ACCELERATION CONTROL"
    timeLabel.TextColor3 = Color3.white
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.GothamBold
    timeLabel.Parent = timeFrame
    
    local timeLabelCorner = Instance.new("UICorner")
    timeLabelCorner.CornerRadius = UDim.new(0, 10)
    timeLabelCorner.Parent = timeLabel
    
    -- Time multiplier buttons
    local timeButtons = {
        {text = "1x Speed", multiplier = 1, color = Color3.fromRGB(100, 100, 100)},
        {text = "2x Speed", multiplier = 2, color = Color3.fromRGB(100, 150, 100)},
        {text = "4x Speed", multiplier = 4, color = Color3.fromRGB(150, 100, 100)},
        {text = "8x Speed", multiplier = 8, color = Color3.fromRGB(200, 100, 100)}
    }
    
    for i, btnData in ipairs(timeButtons) do
        local timeBtn = Instance.new("TextButton")
        timeBtn.Name = "Time" .. btnData.multiplier .. "xButton"
        timeBtn.Size = UDim2.new(0.2, -10, 0, 50)
        timeBtn.Position = UDim2.new((i-1) * 0.25 + 0.025, 0, 0, 100)
        timeBtn.BackgroundColor3 = btnData.color
        timeBtn.Text = btnData.text
        timeBtn.TextColor3 = Color3.white
        timeBtn.TextScaled = true
        timeBtn.Font = Enum.Font.GothamBold
        timeBtn.Parent = timeFrame
        
        local timeBtnCorner = Instance.new("UICorner")
        timeBtnCorner.CornerRadius = UDim.new(0, 8)
        timeBtnCorner.Parent = timeBtn
        
        timeBtn.MouseButton1Click:Connect(function()
            SandboxPlusUI:SetTimeAcceleration(btnData.multiplier)
        end)
    end
    
    -- 🌱 POLLUTION TOGGLE
    local pollutionToggle = Instance.new("TextButton")
    pollutionToggle.Name = "PollutionToggle"
    pollutionToggle.Size = UDim2.new(0.6, 0, 0, 50)
    pollutionToggle.Position = UDim2.new(0.2, 0, 0, 180)
    pollutionToggle.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    pollutionToggle.Text = "🌱 Pollution Effects: ON"
    pollutionToggle.TextColor3 = Color3.white
    pollutionToggle.TextScaled = true
    pollutionToggle.Font = Enum.Font.GothamBold
    pollutionToggle.Parent = timeFrame
    
    local pollutionCorner = Instance.new("UICorner")
    pollutionCorner.CornerRadius = UDim.new(0, 8)
    pollutionCorner.Parent = pollutionToggle
    
    local pollutionEnabled = true
    
    pollutionToggle.MouseButton1Click:Connect(function()
        pollutionEnabled = not pollutionEnabled
        if pollutionEnabled then
            pollutionToggle.Text = "🌱 Pollution Effects: ON"
            pollutionToggle.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        else
            pollutionToggle.Text = "🚫 Pollution Effects: OFF"
            pollutionToggle.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
        end
        SandboxPlusUI:TogglePollution(pollutionEnabled)
    end)
    
    return timeFrame
end

-- 👑 ADMIN TOOLS TAB
function SandboxPlusUI:CreateAdminToolsTab(parent)
    local adminFrame = Instance.new("Frame")
    adminFrame.Name = "AdminToolsContent"
    adminFrame.Size = UDim2.new(1, 0, 1, 0)
    adminFrame.Position = UDim2.new(0, 0, 0, 0)
    adminFrame.BackgroundTransparency = 1
    adminFrame.Visible = false
    adminFrame.Parent = parent
    
    -- 👑 ADMIN OVERRIDE TOOLS
    local adminLabel = Instance.new("TextLabel")
    adminLabel.Name = "AdminLabel"
    adminLabel.Size = UDim2.new(1, -40, 0, 50)
    adminLabel.Position = UDim2.new(0, 20, 0, 20)
    adminLabel.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    adminLabel.Text = "👑 ADMIN OVERRIDE TOOLS"
    adminLabel.TextColor3 = Color3.white
    adminLabel.TextScaled = true
    adminLabel.Font = Enum.Font.GothamBold
    adminLabel.Parent = adminFrame
    
    local adminLabelCorner = Instance.new("UICorner")
    adminLabelCorner.CornerRadius = UDim.new(0, 10)
    adminLabelCorner.Parent = adminLabel
    
    -- Admin buttons
    local adminButtons = {
        {text = "💰 Give $1,000,000", action = "GiveMoney", color = Color3.fromRGB(100, 200, 100)},
        {text = "🔋 Charge All Batteries", action = "ChargeBatteries", color = Color3.fromRGB(100, 150, 255)},
        {text = "🔧 Fix All Machines", action = "FixMachines", color = Color3.fromRGB(255, 150, 100)},
        {text = "🌟 Max Eco Score", action = "MaxEcoScore", color = Color3.fromRGB(150, 255, 150)}
    }
    
    for i, btnData in ipairs(adminButtons) do
        local adminBtn = Instance.new("TextButton")
        adminBtn.Name = btnData.action .. "Button"
        adminBtn.Size = UDim2.new(0.45, 0, 0, 60)
        adminBtn.Position = UDim2.new(((i-1) % 2) * 0.5 + 0.025, 0, 0, 90 + math.floor((i-1) / 2) * 80)
        adminBtn.BackgroundColor3 = btnData.color
        adminBtn.Text = btnData.text
        adminBtn.TextColor3 = Color3.white
        adminBtn.TextScaled = true
        adminBtn.Font = Enum.Font.GothamBold
        adminBtn.Parent = adminFrame
        
        local adminBtnCorner = Instance.new("UICorner")
        adminBtnCorner.CornerRadius = UDim.new(0, 8)
        adminBtnCorner.Parent = adminBtn
        
        adminBtn.MouseButton1Click:Connect(function()
            SandboxPlusUI:ExecuteAdminAction(btnData.action)
        end)
    end
    
    return adminFrame
end

-- 📊 SETTINGS TAB
function SandboxPlusUI:CreateSettingsTab(parent)
    local settingsFrame = Instance.new("Frame")
    settingsFrame.Name = "SettingsContent"
    settingsFrame.Size = UDim2.new(1, 0, 1, 0)
    settingsFrame.Position = UDim2.new(0, 0, 0, 0)
    settingsFrame.BackgroundTransparency = 1
    settingsFrame.Visible = false
    settingsFrame.Parent = parent
    
    -- Settings content (placeholder)
    local settingsLabel = Instance.new("TextLabel")
    settingsLabel.Name = "SettingsLabel"
    settingsLabel.Size = UDim2.new(1, -40, 0, 50)
    settingsLabel.Position = UDim2.new(0, 20, 0, 20)
    settingsLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    settingsLabel.Text = "📊 SANDBOX+ SETTINGS"
    settingsLabel.TextColor3 = Color3.white
    settingsLabel.TextScaled = true
    settingsLabel.Font = Enum.Font.GothamBold
    settingsLabel.Parent = settingsFrame
    
    local settingsLabelCorner = Instance.new("UICorner")
    settingsLabelCorner.CornerRadius = UDim.new(0, 10)
    settingsLabelCorner.Parent = settingsLabel
    
    return settingsFrame
end

-- 🎁 SPAWN ITEM FUNCTION
function SandboxPlusUI:SpawnItem(itemName)
    local remotes = ReplicatedStorage:WaitForChild("TycoonRemotes")
    local spawnPosition = Mouse.Hit.Position + Vector3.new(0, 5, 0)
    
    remotes.SpawnItem:FireServer(itemName, spawnPosition)
    print("🎁 Spawning: " .. itemName)
end

-- ⚡ SET TIME ACCELERATION
function SandboxPlusUI:SetTimeAcceleration(multiplier)
    local remotes = ReplicatedStorage:WaitForChild("TycoonRemotes")
    remotes.TimeAcceleration:FireServer(multiplier)
    print("⚡ Time set to " .. multiplier .. "x speed")
end

-- 🌱 TOGGLE POLLUTION
function SandboxPlusUI:TogglePollution(enabled)
    local remotes = ReplicatedStorage:WaitForChild("TycoonRemotes")
    remotes.TogglePollution:FireServer(enabled)
    print("🌱 Pollution: " .. (enabled and "ON" or "OFF"))
end

-- 👑 EXECUTE ADMIN ACTION
function SandboxPlusUI:ExecuteAdminAction(action)
    local remotes = ReplicatedStorage:WaitForChild("TycoonRemotes")
    
    if action == "GiveMoney" then
        remotes.AdminGiveMoney:FireServer(1000000)
    elseif action == "ChargeBatteries" then
        remotes.ChargeAllBatteries:FireServer()
    elseif action == "FixMachines" then
        -- Custom action for fixing machines
        print("🔧 Fixing all machines...")
    elseif action == "MaxEcoScore" then
        -- Custom action for maxing eco score
        print("🌟 Maximizing eco score...")
    end
end

-- 🎮 CONNECT SANDBOX EVENTS
function SandboxPlusUI:ConnectSandboxEvents(mainFrame, toggleBtn, closeBtn)
    local isMinimized = false
    local originalSize = mainFrame.Size
    
    -- Toggle minimize/maximize
    toggleBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 400, 0, 60)
            })
            tween:Play()
            toggleBtn.Text = "□"
        else
            local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {
                Size = originalSize
            })
            tween:Play()
            toggleBtn.Text = "─"
        end
    end)
    
    -- Close UI
    closeBtn.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -400, -1, 0)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    end)
end

-- 🎮 TOGGLE SANDBOX UI FUNCTION
function SandboxPlusUI:ToggleSandboxUI()
    local sandboxGui = ReplicatedStorage.TycoonGUIs:FindFirstChild("SandboxPlusUI")
    if not sandboxGui then
        sandboxGui = SandboxPlusUI:CreateSandboxUI()
    end
    
    local mainFrame = sandboxGui.SandboxMainFrame
    
    if mainFrame.Visible then
        -- Hide UI
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -400, -1, 0)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    else
        -- Show UI
        mainFrame.Visible = true
        mainFrame.Position = UDim2.new(0.5, -400, -1, 0)
        
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -400, 0.5, -300)
        })
        tween:Play()
    end
end

return SandboxPlusUI