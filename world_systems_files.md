# World Systems Files - bc-8b4bc26e-6c96-4cb0-a41f-1528cc94c6c1

This document contains the key files for the three world systems in the tycoon game: **Main World/Hub**, **Shared World**, and **Sandbox Plus**.

## 📋 System Overview

The game features three interconnected worlds:
1. **🏠 Main Hub** - The central hub with UI and world selection
2. **🏗️ Shared World** - Collaborative building area with biomes and co-ownership
3. **🧪 Sandbox Plus** - Premium unlimited building mode (requires gamepass)

---

## 🏠 Main World/Hub Files

### Primary Hub System
The Main Hub is implemented across multiple loader files and the teleportation system.

**Key Features:**
- Central world selection interface
- Player data management
- World teleportation hub
- Main tycoon gameplay

**Main Files:**
- `TycoonGameLoader.lua` - Core hub implementation
- `ULTIMATE_TYCOON_LOADER.lua` - Extended hub system
- `ULTIMATE_TYCOON_LOADER_COMPLETE.lua` - Complete hub with all features
- `TeleportationSystem.lua` - Hub teleportation logic

---

## 🏗️ Shared World Files

### Core Shared World System
**File: `TeleportationSystem.lua`** - Lines 22, 202, 336
Contains the main shared world teleportation and setup logic.

**Key Shared World Features:**
- Collaborative building areas
- Biome system (Forest, Desert, Snow, Volcano, Ocean)
- Co-ownership mechanics
- Admin floating entrance effect
- Weather and time systems
- Natural resource bonuses per biome

### Shared World Implementation Sections

#### From `TycoonGameLoader.lua` (Lines 329-400):
```lua
-- 🏗️ SHARED WORLD SYSTEM
function TycoonLoader:CreateSharedWorldSystem()
    local sharedWorldModule = Instance.new("ModuleScript")
    sharedWorldModule.Name = "SharedWorldSystem"
    sharedWorldModule.Parent = ServerStorage
    
    local sharedWorldCode = [[
    local SharedWorld = {}
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local DataStoreService = game:GetService("DataStoreService")

    -- 🏗️ SHARED WORLD MECHANICS
    SharedWorld.PlayerPlots = {}
    SharedWorld.CoOwners = {}
    SharedWorld.PublicIslands = {}

    -- 🌿 BIOMES SYSTEM
    local Biomes = {
        Forest = {efficiency = 1.2, color = Color3.fromRGB(50, 150, 50)},
        Desert = {efficiency = 0.8, color = Color3.fromRGB(255, 200, 100)}, 
        Snow = {efficiency = 0.9, color = Color3.fromRGB(200, 200, 255)},
        Volcano = {efficiency = 1.5, color = Color3.fromRGB(255, 100, 50)}
    }

    -- 👑 ADMIN FLOAT DOWN EFFECT
    function SharedWorld:AdminFloatDown(adminPlayer)
        local character = adminPlayer.Character
        if not character then return end
        
        -- Create floating platform
        local platform = Instance.new("Part")
        platform.Name = "AdminPlatform"
        platform.Size = Vector3.new(6, 1, 6)
        platform.Material = Enum.Material.ForceField
        platform.BrickColor = BrickColor.new("Bright blue")
        platform.CanCollide = true
        platform.Anchored = true
        platform.Position = Vector3.new(0, 200, 0)
        platform.Parent = workspace
        
        -- Teleport admin to platform
        character:SetPrimaryPartCFrame(CFrame.new(0, 205, 0))
        
        -- Float down animation
        local tween = TweenService:Create(platform, TweenInfo.new(3, Enum.EasingStyle.Sine), {Position = Vector3.new(0, 10, 0)})
        tween:Play()
    end
```

#### From `ULTIMATE_TYCOON_LOADER_COMPLETE.lua` (Lines 1390-1450):
```lua
-- 🏗️ COMPREHENSIVE SHARED WORLD SYSTEM
local sharedWorldModule = Instance.new("ModuleScript")
sharedWorldModule.Name = "SharedWorldSystem"
sharedWorldModule.Parent = ServerStorage
sharedWorldModule.Source = [[
local SharedWorld = {}

-- DATA STORES
SharedWorld.PlotDataStore = DataStoreService:GetDataStore("SharedWorldPlots_v4")
SharedWorld.CoOwnerDataStore = DataStoreService:GetDataStore("CoOwners_v4")
SharedWorld.PublicIslandStore = DataStoreService:GetDataStore("PublicIslands_v4")

-- SHARED WORLD DATA
SharedWorld.PlayerPlots = {}
SharedWorld.CoOwners = {}
SharedWorld.PublicIslands = {}
SharedWorld.Biomes = {"Forest", "Desert", "Snow", "Volcano", "Ocean"}
SharedWorld.CurrentBiome = "Forest"
SharedWorld.Weather = "Clear"
SharedWorld.TimeOfDay = 12

-- BIOME EFFECTS
SharedWorld.BiomeEffects = {
    Forest = {
        description = "Lush forests boost biofuel and wood production",
        powerBonus = {["Biofuel Generator"] = 1.4},
        pollution = -10,
        naturalResources = {"Wood", "Biomass", "Fresh Water"}
    },
    Desert = {
        description = "Harsh desert perfect for solar and mining",
        powerBonus = {["Solar Panel"] = 1.5, ["Wind Turbine"] = 1.3},
        resourceBonus = {["Ore Miner"] = 1.2},
        pollution = 0,
        naturalResources = {"Sand", "Rare Minerals", "Oil"}
    },
    Snow = {
        description = "Cold climate reduces cooling costs",
        coolingBonus = 0.5,
        powerBonus = {["Wind Turbine"] = 1.2},
        pollution = -5,
        naturalResources = {"Ice", "Clean Water", "Frost Crystals"}
    },
    Volcano = {
        description = "Volcanic activity provides geothermal power",
        powerBonus = {["Geothermal Plant"] = 1.8},
        resourceBonus = {["Ore Miner"] = 1.3},
        pollution = 5,
        naturalResources = {"Magma", "Sulfur", "Volcanic Glass"}
    },
    Ocean = {
        description = "Coastal access enables hydro power and fishing",
        powerBonus = {["Hydroelectric Dam"] = 1.6},
        pollution = -15,
        naturalResources = {"Water", "Salt", "Fish", "Seaweed"}
    }
}
```

---

## 🧪 Sandbox Plus Files

### Main Sandbox Plus File
**File: `SandboxPlusUI.lua`** (Complete 565-line file)

This is the complete UI system for Sandbox Plus with the following features:

#### Key Features:
- **🎁 Spawn Menu** - Categorized item spawning system
- **⚡ Time Control** - Time acceleration (1x, 2x, 4x, 8x speed)
- **👑 Admin Tools** - Money, battery charging, machine fixes
- **📊 Settings** - Configuration options
- **🎮 Interactive UI** - Tabbed interface with hover effects

#### Item Categories Available:
- **🏭 Machines**: Factory Machine, Money Printer, Auto Sorter, Resource Generator
- **⚡ Power**: Solar Panel, Battery, Power Generator, Fuel Tank
- **🛤️ Transport**: Conveyor Belt, Teleporter, Dropper, Collector
- **🏗️ Structure**: Foundation, Wall, Roof, Platform

#### Admin Functions:
- Give $1,000,000 instantly
- Charge all batteries
- Fix all machines
- Maximize eco score
- Toggle pollution effects

### Sandbox Plus System Implementation

#### From `TycoonGameLoader.lua`:
```lua
SANDBOX_PLUS = "SandboxPlus"

-- Sandbox Plus System
local SandboxPlus = {}

function SandboxPlus:HasGamepass(player)
    local success, hasGamepass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, SANDBOX_GAMEPASS_ID)
    end)
    return success and hasGamepass
end

SandboxPlus.TimeMultiplier = 1
function SandboxPlus:SetTimeAcceleration(multiplier)
    SandboxPlus.TimeMultiplier = multiplier
end

SandboxPlus.PollutionEnabled = true
function SandboxPlus:TogglePollution(enabled)
    SandboxPlus.PollutionEnabled = enabled
end

SandboxPlus.SpawnableItems = {
    "Conveyor Belt", "Solar Panel", "Battery", "Factory Machine", "Resource Generator"
}

function SandboxPlus:SpawnItem(player, itemName, position)
    if not SandboxPlus:HasGamepass(player) then
        return false, "Sandbox+ gamepass required"
    end
    -- Spawn logic here
end
```

---

## 🌍 Teleportation System

**File: `TeleportationSystem.lua`** (Complete 410-line file)

### Core Teleportation Functions:
- `TeleportToSharedWorld(player)` - Teleport to shared world
- `TeleportToSandbox(player)` - Teleport to Sandbox+ (with gamepass check)
- `TeleportToMainHub(player)` - Return to main hub
- `HandleTeleportArrival(player)` - Process incoming teleport data

### World Setup Functions:
- `SetupSharedWorldPlayer(player)` - Configure player for shared world
- `SetupSandboxPlayer(player)` - Configure player for Sandbox+
- `SetupMainHubPlayer(player)` - Configure player for main hub

### Place IDs Configuration:
```lua
local PLACE_IDS = {
    MAIN_HUB = 0,        -- Replace with your main place ID
    SHARED_WORLD = 0,    -- Replace with SharedWorld sub-place ID
    SANDBOX_PLUS = 0     -- Replace with Sandbox+ sub-place ID
}
```

---

## 📁 Complete File List

### Essential World System Files:
1. **`SandboxPlusUI.lua`** - Complete Sandbox+ interface (565 lines)
2. **`TeleportationSystem.lua`** - World teleportation system (410 lines)
3. **`TycoonGameLoader.lua`** - Main hub and core systems (992 lines)
4. **`ULTIMATE_TYCOON_LOADER.lua`** - Extended systems (897 lines)
5. **`ULTIMATE_TYCOON_LOADER_COMPLETE.lua`** - Complete implementation (2094 lines)

### Supporting Files:
- **`AdminPanelUI.lua`** - Admin controls with shared world tools
- **`MachineSystem.lua`** - Machine logic with Sandbox+ integration
- **`README.md`** - Documentation and setup instructions

---

## 🎮 Usage Instructions

1. **Main Hub**: Central starting point with world selection UI
2. **Shared World**: Collaborative building with biome effects and co-ownership
3. **Sandbox Plus**: Premium unlimited building mode (requires gamepass #1322694317)

Each world maintains separate player data and provides unique gameplay mechanics while allowing seamless teleportation between them.