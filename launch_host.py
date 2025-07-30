#!/usr/bin/env python3
"""
Simple launcher for the host script
"""

import os
import sys
import subprocess

def main():
    print("🎮 Launching Remote Control Host...")
    print("="*40)
    
    # Check if host_script.py exists
    if not os.path.exists("host_script.py"):
        print("❌ Error: host_script.py not found")
        print("Make sure you're in the correct directory")
        sys.exit(1)
    
    # Check if dependencies are installed
    try:
        import tkinter
        import requests
        import PIL
        print("✅ Dependencies check passed")
    except ImportError as e:
        print(f"❌ Missing dependency: {e}")
        print("Run: python install.py to install dependencies")
        sys.exit(1)
    
    print("\n🖥️  Starting GUI interface...")
    print("🔗 Ready to connect to client")
    print("📊 Screenshot and monitoring tools available")
    print("💾 Save and export capabilities enabled")
    print("\nGUI will open in a new window")
    print("="*40)
    
    try:
        # Run the host script
        subprocess.run([sys.executable, "host_script.py"])
    except KeyboardInterrupt:
        print("\n🛑 Host stopped by user")
    except Exception as e:
        print(f"\n❌ Error running host: {e}")

if __name__ == "__main__":
    main()