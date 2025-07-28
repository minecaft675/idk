# 🚀 Flying Box Teleport System

A lunar script that teleports you to a flying box that descends to the bottom of the world with spectacular visual effects!

## ✨ Features

- **Flying Box Creation**: Spawns a glowing neon box high above the player
- **Smooth Descent**: The box smoothly descends to the bottom of the world
- **Particle Effects**: Beautiful particle trails and explosion effects
- **Sound Effects**: Immersive sound effects for teleportation and landing
- **UI Button**: Easy-to-use button interface
- **Rotation Animation**: The box rotates during descent for extra visual appeal

## 🎮 How to Use

### Method 1: Using the UI Button
1. Run the `FlyingBoxLoader.lua` script
2. A blue button labeled "🚀 Flying Box Teleport" will appear on your screen
3. Click the button to start your flying box adventure!

### Method 2: Direct Function Call
```lua
local FlyingBoxTeleport = require(script.Parent.FlyingBoxTeleport)
local player = game.Players.LocalPlayer
FlyingBoxTeleport:TeleportToFlyingBox(player)
```

## 🎨 Customization

You can easily customize the system by modifying the `CONFIG` table in `FlyingBoxTeleport.lua`:

```lua
local CONFIG = {
    BOX_SIZE = Vector3.new(8, 8, 8),        -- Size of the flying box
    DESCENT_SPEED = 50,                      -- Speed of descent (studs per second)
    TELEPORT_HEIGHT = 1000,                  -- Height above player to spawn box
    PARTICLE_COUNT = 50,                     -- Number of particles in trail
    GLOW_INTENSITY = 0.8,                    -- Brightness of the glow effect
    SOUND_VOLUME = 0.5                       -- Volume of sound effects
}
```

## 🎨 Visual Effects

- **Glowing Box**: Neon material with point light for dramatic effect
- **Particle Trails**: Golden particles follow the box during descent
- **Teleport Effect**: Particle burst when player teleports to the box
- **Landing Effect**: Massive explosion and particle burst at the bottom
- **Rotation**: The box spins 360 degrees during descent

## 🎵 Sound Effects

- **Teleport Sound**: Electronic ping when teleporting to the box
- **Descent Sound**: Water impact sound during descent
- **Landing Sound**: Explosion sound when reaching the bottom

## 🔧 Technical Details

### Files Included:
- `FlyingBoxTeleport.lua` - Main system with all functionality
- `FlyingBoxLoader.lua` - Simple loader script
- `FlyingBoxTeleport_README.md` - This documentation

### Dependencies:
- Roblox Services: Players, TweenService, RunService, Debris, SoundService
- No external dependencies required

### Safety Features:
- Automatic cleanup of particles and sounds
- Player movement temporarily disabled during teleportation
- Error handling for missing player/character
- Proper connection cleanup to prevent memory leaks

## 🚀 Installation

1. Place both `FlyingBoxTeleport.lua` and `FlyingBoxLoader.lua` in your Roblox place
2. Run the `FlyingBoxLoader.lua` script
3. Enjoy your flying box teleportation!

## 🎯 Tips

- The box descends to Y = -1000 (deep underground)
- Player movement is disabled for 2 seconds after teleportation
- The box automatically cleans up after 3 seconds at the bottom
- You can modify the descent speed for faster or slower journeys

## 🐛 Troubleshooting

- **Button not appearing**: Make sure the script is running in a LocalScript context
- **No sound effects**: Check that SoundService is enabled
- **Performance issues**: Reduce `PARTICLE_COUNT` in the CONFIG table

---

**Created with ❤️ for epic teleportation adventures!**