-- 📖 FACTORY ENCYCLOPEDIA UI SYSTEM
-- Interactive tech tree and machine viewer

local FactoryEncyclopedia = {}

-- 🎯 SERVICE REFERENCES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function FactoryEncyclopedia:CreateEncyclopediaUI()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local encyclopediaGui = Instance.new("ScreenGui")
    encyclopediaGui.Name = "FactoryEncyclopedia"
    encyclopediaGui.Parent = playerGui
    
    -- 📖 MAIN ENCYCLOPEDIA FRAME
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "EncyclopediaFrame"
    mainFrame.Size = UDim2.new(0.9, 0, 0.9, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = encyclopediaGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    -- 📖 TITLE BAR
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 80)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
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
    titleLabel.Text = "📖 FACTORY ENCYCLOPEDIA - Tech Tree & Production Chains"
    titleLabel.TextColor3 = Color3.white
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 60, 0, 60)
    closeBtn.Position = UDim2.new(1, -70, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.white
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 15)
    closeBtnCorner.Parent = closeBtn
    
    -- 📋 NAVIGATION TABS
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(1, -20, 0, 50)
    tabFrame.Position = UDim2.new(0, 10, 0, 90)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = mainFrame
    
    local tabs = {
        {name = "🏭 All Machines", id = "AllMachines"},
        {name = "🔗 Production Chains", id = "ProductionChains"},
        {name = "📊 Resource Flow", id = "ResourceFlow"},
        {name = "🎯 Tech Tree", id = "TechTree"}
    }
    
    local tabButtons = {}
    local tabContents = {}
    
    -- Create tab buttons
    for i, tab in ipairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tab.id .. "Tab"
        tabBtn.Size = UDim2.new(0.25, -5, 1, 0)
        tabBtn.Position = UDim2.new((i-1) * 0.25, 2.5, 0, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
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
    contentFrame.Size = UDim2.new(1, -20, 1, -160)
    contentFrame.Position = UDim2.new(0, 10, 0, 150)
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = contentFrame
    
    -- 🏭 ALL MACHINES TAB
    local allMachinesTab = FactoryEncyclopedia:CreateAllMachinesTab(contentFrame)
    tabContents["AllMachines"] = allMachinesTab
    
    -- 🔗 PRODUCTION CHAINS TAB
    local productionChainsTab = FactoryEncyclopedia:CreateProductionChainsTab(contentFrame)
    tabContents["ProductionChains"] = productionChainsTab
    
    -- 📊 RESOURCE FLOW TAB
    local resourceFlowTab = FactoryEncyclopedia:CreateResourceFlowTab(contentFrame)
    tabContents["ResourceFlow"] = resourceFlowTab
    
    -- 🎯 TECH TREE TAB
    local techTreeTab = FactoryEncyclopedia:CreateTechTreeTab(contentFrame)
    tabContents["TechTree"] = techTreeTab
    
    -- 🎮 TAB SWITCHING LOGIC
    local currentTab = "AllMachines"
    
    local function switchTab(tabId)
        -- Hide all tabs
        for id, content in pairs(tabContents) do
            content.Visible = false
            tabButtons[id].BackgroundColor3 = Color3.fromRGB(40, 45, 55)
        end
        
        -- Show selected tab
        tabContents[tabId].Visible = true
        tabButtons[tabId].BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        currentTab = tabId
    end
    
    -- Connect tab buttons
    for id, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            switchTab(id)
        end)
    end
    
    -- Initialize first tab
    switchTab("AllMachines")
    
    -- 🎮 CLOSE FUNCTIONALITY
    closeBtn.MouseButton1Click:Connect(function()
        FactoryEncyclopedia:CloseEncyclopedia(encyclopediaGui)
    end)
    
    return encyclopediaGui
end

-- 🏭 ALL MACHINES TAB
function FactoryEncyclopedia:CreateAllMachinesTab(parent)
    local machinesFrame = Instance.new("Frame")
    machinesFrame.Name = "AllMachinesContent"
    machinesFrame.Size = UDim2.new(1, 0, 1, 0)
    machinesFrame.Position = UDim2.new(0, 0, 0, 0)
    machinesFrame.BackgroundTransparency = 1
    machinesFrame.Parent = parent
    
    -- Category filter buttons
    local filterFrame = Instance.new("Frame")
    filterFrame.Name = "FilterFrame"
    filterFrame.Size = UDim2.new(1, -20, 0, 50)
    filterFrame.Position = UDim2.new(0, 10, 0, 10)
    filterFrame.BackgroundTransparency = 1
    filterFrame.Parent = machinesFrame
    
    local categories = {"All", "Power Generation", "Production", "Logistics", "Maintenance", "Utility"}
    local filterButtons = {}
    
    for i, category in ipairs(categories) do
        local filterBtn = Instance.new("TextButton")
        filterBtn.Name = category .. "Filter"
        filterBtn.Size = UDim2.new(1/6, -5, 1, 0)
        filterBtn.Position = UDim2.new((i-1)/6, 2.5, 0, 0)
        filterBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
        filterBtn.Text = category
        filterBtn.TextColor3 = Color3.white
        filterBtn.TextScaled = true
        filterBtn.Font = Enum.Font.Gotham
        filterBtn.Parent = filterFrame
        
        local filterCorner = Instance.new("UICorner")
        filterCorner.CornerRadius = UDim.new(0, 5)
        filterCorner.Parent = filterBtn
        
        filterButtons[category] = filterBtn
    end
    
    -- Machines scroll frame
    local machinesScroll = Instance.new("ScrollingFrame")
    machinesScroll.Name = "MachinesScrollFrame"
    machinesScroll.Size = UDim2.new(1, -20, 1, -80)
    machinesScroll.Position = UDim2.new(0, 10, 0, 70)
    machinesScroll.BackgroundTransparency = 1
    machinesScroll.BorderSizePixel = 0
    machinesScroll.ScrollBarThickness = 8
    machinesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    machinesScroll.Parent = machinesFrame
    
    -- Machine grid layout
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 280, 0, 120)
    gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = machinesScroll
    
    -- Populate machines
    FactoryEncyclopedia:PopulateMachineGrid(machinesScroll, "All")
    
    -- Filter functionality
    for category, button in pairs(filterButtons) do
        button.MouseButton1Click:Connect(function()
            -- Reset all filter buttons
            for _, btn in pairs(filterButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
            end
            
            -- Highlight selected filter
            button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            
            -- Filter machines
            FactoryEncyclopedia:PopulateMachineGrid(machinesScroll, category)
        end)
    end
    
    -- Set default filter
    filterButtons["All"].BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    
    return machinesFrame
end

-- 🔗 PRODUCTION CHAINS TAB
function FactoryEncyclopedia:CreateProductionChainsTab(parent)
    local chainsFrame = Instance.new("Frame")
    chainsFrame.Name = "ProductionChainsContent"
    chainsFrame.Size = UDim2.new(1, 0, 1, 0)
    chainsFrame.Position = UDim2.new(0, 0, 0, 0)
    chainsFrame.BackgroundTransparency = 1
    chainsFrame.Visible = false
    chainsFrame.Parent = parent
    
    local chainsScroll = Instance.new("ScrollingFrame")
    chainsScroll.Name = "ChainsScrollFrame"
    chainsScroll.Size = UDim2.new(1, -20, 1, -20)
    chainsScroll.Position = UDim2.new(0, 10, 0, 10)
    chainsScroll.BackgroundTransparency = 1
    chainsScroll.BorderSizePixel = 0
    chainsScroll.ScrollBarThickness = 8
    chainsScroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
    chainsScroll.Parent = chainsFrame
    
    -- Production chains data (would come from MachineSystem)
    local productionChains = {
        {
            name = "Basic Electronics",
            flow = "Iron Ore → Iron Ingot → Circuit",
            machines = {"Ore Miner", "Smelter", "Electronics Fab"},
            description = "Basic electronic component production"
        },
        {
            name = "Advanced Manufacturing", 
            flow = "Iron Ore → Steel → Advanced Components",
            machines = {"Ore Miner", "Smelter", "Alloy Furnace", "Assembler"},
            description = "High-tech manufacturing chain"
        },
        {
            name = "Petrochemical Industry",
            flow = "Crude Oil → Fuel + Plastic → Chemicals",
            machines = {"Oil Pump", "Refinery", "Chem Plant"},
            description = "Chemical and plastic production"
        },
        {
            name = "Energy Evolution",
            flow = "Coal → Solar → Fusion Power",
            machines = {"Coal Generator", "Solar Panel", "Fusion Reactor"},
            description = "Power generation progression"
        },
        {
            name = "Quantum Manufacturing",
            flow = "Perfect Ingots → Nanocomponents → Custom Parts",
            machines = {"Quantum Smelter", "Nanofabricator", "3D Printer"},
            description = "Late-game precision manufacturing"
        }
    }
    
    for i, chain in ipairs(productionChains) do
        local chainFrame = Instance.new("Frame")
        chainFrame.Name = "Chain" .. i
        chainFrame.Size = UDim2.new(1, -20, 0, 150)
        chainFrame.Position = UDim2.new(0, 10, 0, (i-1) * 170 + 10)
        chainFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
        chainFrame.BorderSizePixel = 0
        chainFrame.Parent = chainsScroll
        
        local chainCorner = Instance.new("UICorner")
        chainCorner.CornerRadius = UDim.new(0, 10)
        chainCorner.Parent = chainFrame
        
        -- Chain title
        local chainTitle = Instance.new("TextLabel")
        chainTitle.Size = UDim2.new(1, -20, 0, 30)
        chainTitle.Position = UDim2.new(0, 10, 0, 10)
        chainTitle.BackgroundTransparency = 1
        chainTitle.Text = "🔗 " .. chain.name
        chainTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
        chainTitle.TextScaled = true
        chainTitle.Font = Enum.Font.GothamBold
        chainTitle.TextXAlignment = Enum.TextXAlignment.Left
        chainTitle.Parent = chainFrame
        
        -- Flow diagram
        local flowLabel = Instance.new("TextLabel")
        flowLabel.Size = UDim2.new(1, -20, 0, 40)
        flowLabel.Position = UDim2.new(0, 10, 0, 50)
        flowLabel.BackgroundTransparency = 1
        flowLabel.Text = "📊 " .. chain.flow
        flowLabel.TextColor3 = Color3.white
        flowLabel.TextScaled = true
        flowLabel.Font = Enum.Font.Gotham
        flowLabel.TextXAlignment = Enum.TextXAlignment.Left
        flowLabel.Parent = chainFrame
        
        -- Description
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -20, 0, 25)
        descLabel.Position = UDim2.new(0, 10, 0, 100)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = chain.description
        descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        descLabel.TextScaled = true
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = chainFrame
        
        -- View details button
        local detailsBtn = Instance.new("TextButton")
        detailsBtn.Size = UDim2.new(0, 120, 0, 30)
        detailsBtn.Position = UDim2.new(1, -130, 0, 110)
        detailsBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        detailsBtn.Text = "📋 View Details"
        detailsBtn.TextColor3 = Color3.white
        detailsBtn.TextScaled = true
        detailsBtn.Font = Enum.Font.Gotham
        detailsBtn.Parent = chainFrame
        
        local detailsBtnCorner = Instance.new("UICorner")
        detailsBtnCorner.CornerRadius = UDim.new(0, 5)
        detailsBtnCorner.Parent = detailsBtn
        
        detailsBtn.MouseButton1Click:Connect(function()
            FactoryEncyclopedia:ShowChainDetails(chain)
        end)
    end
    
    return chainsFrame
end

-- 📊 RESOURCE FLOW TAB
function FactoryEncyclopedia:CreateResourceFlowTab(parent)
    local resourceFrame = Instance.new("Frame")
    resourceFrame.Name = "ResourceFlowContent"
    resourceFrame.Size = UDim2.new(1, 0, 1, 0)
    resourceFrame.Position = UDim2.new(0, 0, 0, 0)
    resourceFrame.BackgroundTransparency = 1
    resourceFrame.Visible = false
    resourceFrame.Parent = parent
    
    -- Resource flow diagram placeholder
    local flowDiagram = Instance.new("ScrollingFrame")
    flowDiagram.Name = "FlowDiagram"
    flowDiagram.Size = UDim2.new(1, -20, 1, -20)
    flowDiagram.Position = UDim2.new(0, 10, 0, 10)
    flowDiagram.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    flowDiagram.BorderSizePixel = 0
    flowDiagram.ScrollBarThickness = 8
    flowDiagram.CanvasSize = UDim2.new(0, 2000, 0, 1500)
    flowDiagram.Parent = resourceFrame
    
    local flowCorner = Instance.new("UICorner")
    flowCorner.CornerRadius = UDim.new(0, 10)
    flowCorner.Parent = flowDiagram
    
    -- Create interactive flow diagram
    FactoryEncyclopedia:CreateInteractiveFlowDiagram(flowDiagram)
    
    return resourceFrame
end

-- 🎯 TECH TREE TAB
function FactoryEncyclopedia:CreateTechTreeTab(parent)
    local techFrame = Instance.new("Frame")
    techFrame.Name = "TechTreeContent"
    techFrame.Size = UDim2.new(1, 0, 1, 0)
    techFrame.Position = UDim2.new(0, 0, 0, 0)
    techFrame.BackgroundTransparency = 1
    techFrame.Visible = false
    techFrame.Parent = parent
    
    local techScroll = Instance.new("ScrollingFrame")
    techScroll.Name = "TechScrollFrame"
    techScroll.Size = UDim2.new(1, -20, 1, -20)
    techScroll.Position = UDim2.new(0, 10, 0, 10)
    techScroll.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    techScroll.BorderSizePixel = 0
    techScroll.ScrollBarThickness = 8
    techScroll.CanvasSize = UDim2.new(0, 3000, 0, 2000)
    techScroll.Parent = techFrame
    
    local techCorner = Instance.new("UICorner")
    techCorner.CornerRadius = UDim.new(0, 10)
    techCorner.Parent = techScroll
    
    -- Create tech tree visualization
    FactoryEncyclopedia:CreateTechTree(techScroll)
    
    return techFrame
end

-- 🎮 POPULATE MACHINE GRID
function FactoryEncyclopedia:PopulateMachineGrid(scrollFrame, category)
    -- Clear existing children
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Machine data (would come from MachineSystem)
    local sampleMachines = {
        {name = "Coal Generator", category = "Power Generation", emoji = "⚫", power = "100⚡", cost = "$5,000", description = "Basic dirty energy"},
        {name = "Solar Panel", category = "Power Generation", emoji = "☀️", power = "120⚡", cost = "$12,000", description = "Renewable day-only"},
        {name = "Ore Miner", category = "Production", emoji = "⛏️", power = "-50⚡", cost = "$3,000", description = "Extracts ore from ground"},
        {name = "Smelter", category = "Production", emoji = "🔥", power = "-100⚡", cost = "$5,000", description = "Ore to ingots"},
        {name = "Conveyor Belt", category = "Logistics", emoji = "🔄", power = "-5⚡", cost = "$500", description = "Moves items"},
        {name = "Auto-Fixer", category = "Maintenance", emoji = "🤖", power = "-50⚡", cost = "$1,000,000", description = "Repairs machines"},
    }
    
    local yPosition = 10
    local xPosition = 10
    local itemsPerRow = 4
    local currentRow = 0
    local currentCol = 0
    
    for i, machine in ipairs(sampleMachines) do
        if category == "All" or machine.category == category then
            local machineFrame = Instance.new("Frame")
            machineFrame.Name = "Machine" .. i
            machineFrame.Size = UDim2.new(0, 270, 0, 110)
            machineFrame.Position = UDim2.new(0, xPosition + (currentCol * 280), 0, yPosition + (currentRow * 120))
            machineFrame.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
            machineFrame.BorderSizePixel = 0
            machineFrame.Parent = scrollFrame
            
            local machineCorner = Instance.new("UICorner")
            machineCorner.CornerRadius = UDim.new(0, 8)
            machineCorner.Parent = machineFrame
            
            -- Machine emoji
            local emojiLabel = Instance.new("TextLabel")
            emojiLabel.Size = UDim2.new(0, 60, 0, 60)
            emojiLabel.Position = UDim2.new(0, 10, 0, 10)
            emojiLabel.BackgroundTransparency = 1
            emojiLabel.Text = machine.emoji
            emojiLabel.TextScaled = true
            emojiLabel.Font = Enum.Font.GothamBold
            emojiLabel.Parent = machineFrame
            
            -- Machine name
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0, 190, 0, 25)
            nameLabel.Position = UDim2.new(0, 75, 0, 10)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = machine.name
            nameLabel.TextColor3 = Color3.white
            nameLabel.TextScaled = true
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = machineFrame
            
            -- Power & cost info
            local infoLabel = Instance.new("TextLabel")
            infoLabel.Size = UDim2.new(0, 190, 0, 20)
            infoLabel.Position = UDim2.new(0, 75, 0, 35)
            infoLabel.BackgroundTransparency = 1
            infoLabel.Text = machine.power .. " | " .. machine.cost
            infoLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            infoLabel.TextScaled = true
            infoLabel.Font = Enum.Font.Gotham
            infoLabel.TextXAlignment = Enum.TextXAlignment.Left
            infoLabel.Parent = machineFrame
            
            -- Description
            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, -20, 0, 30)
            descLabel.Position = UDim2.new(0, 10, 0, 70)
            descLabel.BackgroundTransparency = 1
            descLabel.Text = machine.description
            descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            descLabel.TextScaled = true
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.Parent = machineFrame
            
            -- Click interaction
            local clickButton = Instance.new("TextButton")
            clickButton.Size = UDim2.new(1, 0, 1, 0)
            clickButton.Position = UDim2.new(0, 0, 0, 0)
            clickButton.BackgroundTransparency = 1
            clickButton.Text = ""
            clickButton.Parent = machineFrame
            
            clickButton.MouseButton1Click:Connect(function()
                FactoryEncyclopedia:ShowMachineDetails(machine)
            end)
            
            -- Update position for next machine
            currentCol = currentCol + 1
            if currentCol >= itemsPerRow then
                currentCol = 0
                currentRow = currentRow + 1
            end
        end
    end
    
    -- Update canvas size
    local totalRows = math.ceil(currentRow + (currentCol > 0 and 1 or 0))
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalRows * 120 + 20)
end

-- 🔍 SHOW MACHINE DETAILS
function FactoryEncyclopedia:ShowMachineDetails(machine)
    -- Create detailed popup for machine
    print("📋 Showing details for: " .. machine.name)
    -- Implementation would show detailed recipe, inputs, outputs, etc.
end

-- 🔗 SHOW CHAIN DETAILS  
function FactoryEncyclopedia:ShowChainDetails(chain)
    -- Create detailed popup for production chain
    print("🔗 Showing chain details for: " .. chain.name)
    -- Implementation would show step-by-step breakdown
end

-- 📊 CREATE INTERACTIVE FLOW DIAGRAM
function FactoryEncyclopedia:CreateInteractiveFlowDiagram(parent)
    -- Create nodes and connections for resource flow
    local nodes = {
        {name = "Iron Ore", pos = Vector2.new(100, 100), color = Color3.fromRGB(150, 100, 50)},
        {name = "Smelter", pos = Vector2.new(300, 100), color = Color3.fromRGB(255, 100, 50)},
        {name = "Iron Ingot", pos = Vector2.new(500, 100), color = Color3.fromRGB(200, 200, 200)},
        {name = "Assembler", pos = Vector2.new(700, 100), color = Color3.fromRGB(100, 150, 255)},
        {name = "Component", pos = Vector2.new(900, 100), color = Color3.fromRGB(50, 255, 150)}
    }
    
    for i, node in ipairs(nodes) do
        local nodeFrame = Instance.new("Frame")
        nodeFrame.Name = "Node" .. i
        nodeFrame.Size = UDim2.new(0, 120, 0, 80)
        nodeFrame.Position = UDim2.new(0, node.pos.X, 0, node.pos.Y)
        nodeFrame.BackgroundColor3 = node.color
        nodeFrame.BorderSizePixel = 0
        nodeFrame.Parent = parent
        
        local nodeCorner = Instance.new("UICorner")
        nodeCorner.CornerRadius = UDim.new(0, 10)
        nodeCorner.Parent = nodeFrame
        
        local nodeLabel = Instance.new("TextLabel")
        nodeLabel.Size = UDim2.new(1, -10, 1, -10)
        nodeLabel.Position = UDim2.new(0, 5, 0, 5)
        nodeLabel.BackgroundTransparency = 1
        nodeLabel.Text = node.name
        nodeLabel.TextColor3 = Color3.white
        nodeLabel.TextScaled = true
        nodeLabel.Font = Enum.Font.GothamBold
        nodeLabel.Parent = nodeFrame
        
        -- Add arrows between nodes
        if i < #nodes then
            local arrow = Instance.new("Frame")
            arrow.Name = "Arrow" .. i
            arrow.Size = UDim2.new(0, 60, 0, 4)
            arrow.Position = UDim2.new(0, node.pos.X + 125, 0, node.pos.Y + 38)
            arrow.BackgroundColor3 = Color3.white
            arrow.BorderSizePixel = 0
            arrow.Parent = parent
            
            -- Arrow head
            local arrowHead = Instance.new("Frame")
            arrowHead.Size = UDim2.new(0, 20, 0, 20)
            arrowHead.Position = UDim2.new(0, node.pos.X + 175, 0, node.pos.Y + 30)
            arrowHead.BackgroundColor3 = Color3.white
            arrowHead.BorderSizePixel = 0
            arrowHead.Rotation = 45
            arrowHead.Parent = parent
        end
    end
end

-- 🎯 CREATE TECH TREE
function FactoryEncyclopedia:CreateTechTree(parent)
    -- Tech tree with prestige levels
    local techLevels = {
        {name = "Prestige 0", machines = {"Coal Generator", "Ore Miner", "Smelter"}, pos = Vector2.new(100, 100)},
        {name = "Prestige 1", machines = {"Solar Panel", "Refinery", "Assembler"}, pos = Vector2.new(100, 300)},
        {name = "Prestige 2", machines = {"Nuclear Reactor", "Alloy Furnace", "Electronics Fab"}, pos = Vector2.new(100, 500)},
        {name = "Prestige 3", machines = {"Fusion Reactor", "3D Printer"}, pos = Vector2.new(100, 700)},
        {name = "Prestige 4", machines = {"Quantum Smelter", "Nanofabricator", "Teleport Pad"}, pos = Vector2.new(100, 900)}
    }
    
    for levelIndex, level in ipairs(techLevels) do
        -- Prestige level header
        local levelFrame = Instance.new("Frame")
        levelFrame.Name = "Level" .. levelIndex
        levelFrame.Size = UDim2.new(0, 200, 0, 60)
        levelFrame.Position = UDim2.new(0, level.pos.X, 0, level.pos.Y - 30)
        levelFrame.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
        levelFrame.BorderSizePixel = 0
        levelFrame.Parent = parent
        
        local levelCorner = Instance.new("UICorner")
        levelCorner.CornerRadius = UDim.new(0, 10)
        levelCorner.Parent = levelFrame
        
        local levelLabel = Instance.new("TextLabel")
        levelLabel.Size = UDim2.new(1, -10, 1, -10)
        levelLabel.Position = UDim2.new(0, 5, 0, 5)
        levelLabel.BackgroundTransparency = 1
        levelLabel.Text = "🏆 " .. level.name
        levelLabel.TextColor3 = Color3.white
        levelLabel.TextScaled = true
        levelLabel.Font = Enum.Font.GothamBold
        levelLabel.Parent = levelFrame
        
        -- Machines in this level
        for i, machineName in ipairs(level.machines) do
            local machineFrame = Instance.new("Frame")
            machineFrame.Name = machineName
            machineFrame.Size = UDim2.new(0, 150, 0, 100)
            machineFrame.Position = UDim2.new(0, level.pos.X + 250 + (i * 170), 0, level.pos.Y)
            machineFrame.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
            machineFrame.BorderSizePixel = 0
            machineFrame.Parent = parent
            
            local machineCorner = Instance.new("UICorner")
            machineCorner.CornerRadius = UDim.new(0, 8)
            machineCorner.Parent = machineFrame
            
            local machineLabel = Instance.new("TextLabel")
            machineLabel.Size = UDim2.new(1, -10, 1, -10)
            machineLabel.Position = UDim2.new(0, 5, 0, 5)
            machineLabel.BackgroundTransparency = 1
            machineLabel.Text = machineName
            machineLabel.TextColor3 = Color3.white
            machineLabel.TextScaled = true
            machineLabel.Font = Enum.Font.Gotham
            machineLabel.Parent = machineFrame
            
            -- Connection line to level
            local connection = Instance.new("Frame")
            connection.Name = "Connection" .. i
            connection.Size = UDim2.new(0, 40, 0, 2)
            connection.Position = UDim2.new(0, level.pos.X + 210, 0, level.pos.Y + 29)
            connection.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            connection.BorderSizePixel = 0
            connection.Parent = parent
        end
    end
end

-- 🎮 TOGGLE ENCYCLOPEDIA
function FactoryEncyclopedia:ToggleEncyclopedia()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local existingGui = playerGui:FindFirstChild("FactoryEncyclopedia")
    
    if existingGui then
        local mainFrame = existingGui.EncyclopediaFrame
        
        if mainFrame.Visible then
            FactoryEncyclopedia:CloseEncyclopedia(existingGui)
        else
            FactoryEncyclopedia:OpenEncyclopedia(existingGui)
        end
    else
        local newGui = FactoryEncyclopedia:CreateEncyclopediaUI()
        FactoryEncyclopedia:OpenEncyclopedia(newGui)
    end
end

-- 📖 OPEN ENCYCLOPEDIA
function FactoryEncyclopedia:OpenEncyclopedia(gui)
    local mainFrame = gui.EncyclopediaFrame
    
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0.9, 0, 0.9, 0),
        Position = UDim2.new(0.05, 0, 0.05, 0)
    })
    
    openTween:Play()
end

-- ❌ CLOSE ENCYCLOPEDIA
function FactoryEncyclopedia:CloseEncyclopedia(gui)
    local mainFrame = gui.EncyclopediaFrame
    
    local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    
    closeTween:Play()
    
    closeTween.Completed:Connect(function()
        mainFrame.Visible = false
    end)
end

return FactoryEncyclopedia