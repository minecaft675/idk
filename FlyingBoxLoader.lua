-- 🚀 FLYING BOX TELEPORT LOADER
-- Simple loader script to initialize the flying box teleport system

-- Load the main system
local FlyingBoxTeleport = require(script.Parent.FlyingBoxTeleport)

-- Initialize the system
FlyingBoxTeleport:Initialize()

print("🚀 Flying Box Teleport System loaded successfully!")
print("🎮 Click the '🚀 Flying Box Teleport' button to start your descent!")

-- Optional: Auto-teleport after 5 seconds (for testing)
-- task.delay(5, function()
--     local player = game.Players.LocalPlayer
--     if player then
--         FlyingBoxTeleport:TeleportToFlyingBox(player)
--     end
-- end)