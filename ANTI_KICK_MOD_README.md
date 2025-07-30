# 🛡️ ANTI-KICK MOD FOR BLOCKSTRAP TYCOON ENGINE

## 📋 OVERVIEW

The Anti-Kick Mod is a comprehensive solution that prevents Roblox from kicking players after 20 minutes of inactivity by automatically moving the camera to simulate player activity. This mod is specifically designed to work with the Blockstrap Tycoon Engine and provides seamless integration with all existing features.

## 🌟 FEATURES

### ✅ Core Protection
- **Prevents Roblox Kicks**: Automatically detects when players are inactive for 15 minutes
- **Camera Movement**: Subtle camera movements that simulate player activity
- **Silent Operation**: Works in the background without interfering with gameplay
- **Smart Detection**: Only activates when needed and stops when player becomes active

### ✅ Movement Patterns
- **Gentle Sway**: Side-to-side camera movement
- **Micro Zoom**: Slight zoom in/out effect
- **Rotation Tilt**: Subtle camera rotation
- **Position Shift**: Small position adjustments

### ✅ Integration Features
- **Tycoon Engine Compatible**: Works with all existing tycoon features
- **Admin System Integration**: Admin commands for controlling the mod
- **Mobile & PC Support**: Works on all platforms
- **Configurable Settings**: Easy to customize behavior

## 🚀 INSTALLATION

### 📁 File Placement

#### 🖥️ **ServerStorage** (Server-side scripts)
Place these files in **ServerStorage**:
```
ServerStorage/
├── AntiKickMod.lua (Script)           -- Main anti-kick system
└── AntiKickIntegration.lua (Script)   -- Integration with tycoon engine
```

#### 📱 **StarterPlayer/StarterPlayerScripts** (Client-side)
Place this file in **StarterPlayer > StarterPlayerScripts**:
```
StarterPlayerScripts/
└── AntiKickClient.lua (LocalScript)   -- Client-side camera handling
```

### ⚙️ **Step-by-Step Setup**

1. **Copy the Scripts**
   - Copy `AntiKickMod.lua` to **ServerStorage**
   - Copy `AntiKickIntegration.lua` to **ServerStorage**
   - Copy `AntiKickClient.lua` to **StarterPlayer > StarterPlayerScripts**

2. **Run the Game**
   - Start the game once to initialize the mod
   - The integration script will automatically set up everything

3. **Verify Installation**
   - Check the console for "🛡️ ANTI-KICK MOD" messages
   - The mod should show "Integration completed successfully"

## ⚙️ CONFIGURATION

### 🔧 **Main Configuration** (AntiKickMod.lua)

```lua
local CONFIG = {
    ENABLED = true,                    -- Enable/disable the mod
    CHECK_INTERVAL = 30,               -- How often to check for inactivity (seconds)
    INACTIVITY_THRESHOLD = 900,        -- 15 minutes before anti-kick activates
    MOVEMENT_INTERVAL = 10,            -- How often to move camera (seconds)
    MOVEMENT_DURATION = 2,             -- How long each movement lasts (seconds)
    MOVEMENT_INTENSITY = 0.5,          -- How much to move camera (0.1 = subtle, 2.0 = obvious)
    ENABLE_LOGGING = false,            -- Log anti-kick activities to console
}
```

### 🎮 **Client Configuration** (AntiKickClient.lua)

```lua
local CLIENT_CONFIG = {
    ENABLED = true,
    MOVEMENT_INTENSITY = 0.5,
    MOVEMENT_DURATION = 2,
    ENABLE_LOGGING = false
}
```

## 🎯 HOW IT WORKS

### 📊 **Activity Detection**
1. **Input Monitoring**: Tracks mouse movement, key presses, touch input
2. **Character Movement**: Monitors walking, running, jumping
3. **Camera Changes**: Detects manual camera adjustments
4. **Inactivity Timer**: Starts counting after 15 minutes of no activity

### 🎮 **Camera Movement System**
1. **Pattern Selection**: Randomly chooses from 4 movement patterns
2. **Smooth Animation**: Uses TweenService for fluid camera movements
3. **Return to Position**: Always returns to original camera position
4. **Intensity Control**: Configurable movement strength

### 🔄 **Activation Cycle**
1. **Monitor**: Continuously checks player activity
2. **Detect**: Identifies when player has been inactive for 15 minutes
3. **Activate**: Starts automatic camera movements
4. **Maintain**: Continues until player becomes active again
5. **Deactivate**: Stops when player shows activity

## 👑 ADMIN COMMANDS

### 🔧 **Available Commands**

#### **Server Console Commands**
```lua
-- Show mod statistics
:antikick stats

-- Toggle mod on/off
:antikick toggle

-- Show configuration
:antikick config

-- Force protect a player
:antikick protect [player]

-- Force unprotect a player
:antikick unprotect [player]
```

#### **Debug Commands**
```lua
-- Test camera movement
:antikick test_movement [pattern]

-- Toggle logging
:antikick toggle_logging

-- Get player stats
:antikick get_stats
```

### 🎮 **Movement Patterns**
- `gentle_sway` - Side-to-side movement
- `micro_zoom` - Zoom in/out effect
- `rotation_tilt` - Camera rotation
- `position_shift` - Position adjustment

## 📊 MONITORING & STATISTICS

### 📈 **Server Statistics**
- Total players protected
- Movements executed
- Uptime tracking
- Protection rate

### 📱 **Client Statistics**
- Movements executed locally
- Last movement time
- Camera activity status

### 🔍 **Console Output**
```
🛡️ ANTI-KICK MOD: Activating for PlayerName (inactive for 15 minutes)
🛡️ ANTI-KICK MOD: Executed gentle_sway for PlayerName
🛡️ ANTI-KICK MOD: Deactivating for PlayerName (player became active)
```

## 🛠️ TROUBLESHOOTING

### ❌ **Common Issues**

**"Mod not working"**
- Check if scripts are in correct locations
- Verify console for initialization messages
- Ensure CONFIG.ENABLED = true

**"Camera movements too obvious"**
- Reduce MOVEMENT_INTENSITY (try 0.2)
- Increase MOVEMENT_DURATION (try 3-4 seconds)
- Use more subtle patterns

**"Players still getting kicked"**
- Check INACTIVITY_THRESHOLD (should be 900 seconds = 15 minutes)
- Verify CHECK_INTERVAL (should be 30 seconds)
- Enable ENABLE_LOGGING to see activity

**"Integration not working"**
- Ensure tycoon engine is loaded first
- Check for remote event creation messages
- Verify admin system integration

### 🔧 **Debug Mode**
Enable logging to see detailed activity:
```lua
ENABLE_LOGGING = true
```

### 📱 **Mobile Testing**
- Test on mobile devices
- Verify touch input detection
- Check camera movement smoothness

## 🎯 ADVANCED CUSTOMIZATION

### 🎨 **Custom Movement Patterns**
Add new patterns to `CameraPatterns` in both server and client scripts:

```lua
custom_pattern = function(camera, intensity)
    local originalCFrame = camera.CFrame
    local customAmount = intensity * 0.05
    
    local tweenInfo = TweenInfo.new(
        CONFIG.MOVEMENT_DURATION,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut
    )
    
    local targetCFrame = originalCFrame * CFrame.new(customAmount, 0, customAmount)
    local tween = TweenService:Create(camera, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    -- Return to original position
    local returnTween = TweenService:Create(camera, tweenInfo, {CFrame = originalCFrame})
    returnTween:Play()
    
    return tween
end
```

### ⚙️ **Performance Optimization**
For large servers, adjust these settings:
```lua
CHECK_INTERVAL = 60,        -- Check less frequently
MOVEMENT_INTERVAL = 15,     -- Move camera less often
ENABLE_LOGGING = false,     -- Disable logging for performance
```

### 🔒 **Security Features**
- Admin-only commands
- Input validation
- Rate limiting
- Error handling

## 📱 PLATFORM COMPATIBILITY

### ✅ **Supported Platforms**
- **PC**: Full functionality with mouse/keyboard input
- **Mobile**: Touch input detection and smooth camera movement
- **Console**: Controller input detection
- **Tablet**: Touch and stylus input support

### 🎮 **Input Detection**
- Mouse movement and clicks
- Keyboard presses
- Touch screen input
- Controller input
- Character movement
- Camera changes

## 🔄 UPDATES & MAINTENANCE

### 📝 **Version History**
- **v1.0**: Initial release with basic protection
- **v1.1**: Added admin commands and statistics
- **v1.2**: Enhanced mobile support and performance
- **v1.3**: Integration with tycoon engine

### 🔧 **Maintenance Tips**
- Monitor console for error messages
- Check player feedback about movement intensity
- Adjust settings based on server performance
- Update admin list as needed

## 📞 SUPPORT

### 🐛 **Bug Reports**
Include in your report:
- What were you doing when it happened?
- Error messages from console
- Steps to reproduce
- Your Roblox username

### 💡 **Feature Requests**
Suggest new features with:
- Clear description
- Why it would be useful
- How it should work
- Any visual mockups

### 🔄 **Updates**
Check for updates regularly:
- New movement patterns
- Performance improvements
- Bug fixes
- Platform enhancements

## 📝 LICENSE & CREDITS

### 👑 **Created By**
- **Blockstrap Mod Team**
- **Compatible with**: Blockstrap Tycoon Engine v3.0+

### 🎯 **Features**
- ✅ Prevents Roblox inactivity kicks
- ✅ Subtle camera movement system
- ✅ Full tycoon engine integration
- ✅ Admin command system
- ✅ Mobile and PC compatible
- ✅ Configurable settings
- ✅ Performance optimized

### 🚀 **Technical Details**
- **Language**: Lua
- **Platform**: Roblox
- **Dependencies**: TweenService, UserInputService
- **Integration**: Blockstrap Tycoon Engine
- **Performance**: Low impact, optimized for large servers

---

## 🎉 FINAL NOTES

The Anti-Kick Mod is designed to be:
- **Reliable**: Prevents kicks consistently
- **Subtle**: Players won't notice the camera movements
- **Efficient**: Low performance impact
- **Compatible**: Works with all tycoon features
- **Configurable**: Easy to adjust for your needs

**Just install the scripts, configure the settings, and your players will never be kicked for inactivity again!**

---

*🛡️ For the ultimate tycoon experience, combine this mod with the full Blockstrap Tycoon Engine for a complete, kick-free gaming experience!*