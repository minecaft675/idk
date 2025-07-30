# Remote Control and Monitoring System

A comprehensive remote control and monitoring system with Discord webhook integration for real-time activity tracking.

## ⚠️ IMPORTANT DISCLAIMER

**This tool is for legitimate remote administration and monitoring purposes only.**
- Only use on computers you own or have explicit permission to monitor
- Respect privacy and legal requirements in your jurisdiction
- This tool should not be used for unauthorized surveillance

## Features

### Client Script (`client_script.py`)
- **Real-time keystroke monitoring** with Discord webhook integration
- **Mouse activity tracking** (clicks, scrolls, movements)
- **Automatic screenshot capture** (every 30 seconds)
- **Webcam video capture** (every 60 seconds)
- **System information gathering** (CPU, memory, disk usage)
- **Socket-based remote control** interface
- **Background monitoring** with minimal resource usage

### Host Script (`host_script.py`)
- **Graphical user interface** for easy control
- **Real-time screenshot viewing** with save capability
- **Activity log monitoring** with detailed keystroke history
- **System information dashboard**
- **Automatic refresh** and continuous monitoring options
- **Connection management** with status indicators

## Installation

### Prerequisites
- Python 3.7 or higher
- Internet connection for Discord webhook
- Webcam (optional, for video monitoring)

### Setup Instructions

1. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Configure Discord Webhook (Optional):**
   - The client script is pre-configured with your Discord webhook
   - To use a different webhook, edit the `DISCORD_WEBHOOK` variable in `client_script.py`

3. **Network Configuration:**
   - Ensure both computers are on the same network or accessible via IP
   - Default port is 9999 (can be changed in both scripts)

## Usage

### Step 1: Run Client Script on Target Computer

On the computer you want to monitor:

```bash
python client_script.py
```

The client will:
- Start monitoring keyboard and mouse activity
- Begin capturing screenshots and video
- Send activity data to Discord webhook
- Listen for remote control commands on port 9999

**Expected output:**
```
Starting Remote Control Client...
Keyboard monitoring started
Mouse monitoring started
Screen capture started
Video capture started
Socket server listening on 0.0.0.0:9999
```

### Step 2: Run Host Script on Control Computer

On your control computer:

```bash
python host_script.py
```

This will open a graphical interface where you can:
- Enter the target computer's IP address
- Click "Connect" to establish connection
- Use various monitoring and control features

### Step 3: Monitor and Control

Once connected, you can:

#### Screenshot Monitoring
- Click "Get Screenshot" for real-time screen capture
- Enable "Auto Refresh Screenshot" for continuous monitoring
- Save screenshots to local files

#### Activity Monitoring
- Click "Get Keystrokes" to view recent keyboard and mouse activity
- Enable "Continuous Monitoring" for ongoing activity tracking
- View detailed timestamps and activity types

#### System Information
- Click "System Info" to view target computer's:
  - Platform and version
  - CPU usage
  - Memory usage
  - Disk usage

## Discord Integration

The client script automatically sends activity data to Discord:

### Activity Reports
- **Keyboard events** with timestamps
- **Mouse clicks** with coordinates
- **Scroll events** with direction
- **Screenshots** every 30 seconds
- **Video frames** every 60 seconds

### Discord Message Format
```
**Recent Activity:**
⌨️ 14:30:25 - 'a' (press)
🖱️ 14:30:26 - Mouse Button.left at (500, 300) (press)
📜 14:30:27 - Scroll (0, -1) at (500, 300)
```

## Configuration Options

### Client Script Configuration

Edit `client_script.py` to modify:

```python
# Connection settings
host_ip = "0.0.0.0"  # Listen on all interfaces
host_port = 9999      # Port for remote control

# Discord webhook
DISCORD_WEBHOOK = "your_webhook_url_here"

# Capture intervals
SCREENSHOT_INTERVAL = 30  # seconds
VIDEO_INTERVAL = 60       # seconds
KEYSTROKE_BUFFER_SIZE = 20
```

### Host Script Configuration

Edit `host_script.py` to modify:

```python
# Default connection settings
client_ip = "localhost"  # Target computer IP
client_port = 9999       # Target computer port

# Display settings
DISPLAY_SIZE = (800, 600)  # Screenshot display size
AUTO_REFRESH_INTERVAL = 10  # seconds
MONITORING_INTERVAL = 30    # seconds
```

## Troubleshooting

### Common Issues

1. **Connection Failed**
   - Check if target computer is running the client script
   - Verify IP address and port are correct
   - Ensure firewall allows connections on port 9999

2. **Discord Webhook Not Working**
   - Verify webhook URL is correct
   - Check internet connection
   - Ensure Discord server allows webhook messages

3. **Permission Errors**
   - Run client script with appropriate permissions
   - On Linux/Mac, may need to run with `sudo` for keyboard monitoring

4. **No Webcam Available**
   - Client will continue without video monitoring
   - Check webcam permissions and drivers

### Performance Optimization

- **Reduce capture frequency** for better performance
- **Limit Discord webhook messages** to avoid rate limits
- **Use wired network** for better connection stability

## Security Considerations

### Network Security
- Use VPN for remote connections
- Configure firewall rules appropriately
- Use strong authentication if needed

### Data Privacy
- Screenshots and video contain sensitive information
- Ensure secure transmission and storage
- Respect privacy laws and regulations

### Discord Webhook Security
- Webhook URLs should be kept private
- Consider using environment variables for webhook URLs
- Monitor webhook usage to prevent abuse

## File Structure

```
remote_control/
├── client_script.py      # Target computer monitoring script
├── host_script.py        # Control computer GUI script
├── requirements.txt      # Python dependencies
├── README_remote_control.md  # This file
└── logs/                # Generated logs (if enabled)
```

## Advanced Features

### Custom Commands
The client script supports custom commands via socket communication:

```python
# Example custom command
command = {
    'type': 'custom',
    'action': 'execute_program',
    'program': 'notepad.exe'
}
```

### Logging
Enable detailed logging by modifying the client script:

```python
import logging
logging.basicConfig(level=logging.DEBUG)
```

### Multiple Clients
The host script can be modified to manage multiple client connections simultaneously.

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Verify all dependencies are installed correctly
3. Ensure proper network connectivity
4. Review Discord webhook configuration

## Legal Notice

This software is provided for educational and legitimate administrative purposes only. Users are responsible for:
- Complying with local laws and regulations
- Obtaining proper authorization before monitoring
- Respecting privacy rights and data protection laws
- Using the software responsibly and ethically

## License

This project is for educational purposes. Use responsibly and in accordance with applicable laws and regulations.