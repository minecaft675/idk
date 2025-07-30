#!/usr/bin/env python3
"""
Installation script for Remote Control System
Automatically installs dependencies and sets up the environment
"""

import subprocess
import sys
import os
import platform

def check_python_version():
    """Check if Python version is compatible"""
    if sys.version_info < (3, 7):
        print("❌ Error: Python 3.7 or higher is required")
        print(f"Current version: {sys.version}")
        return False
    print(f"✅ Python version: {sys.version}")
    return True

def install_dependencies():
    """Install required Python packages"""
    print("\n📦 Installing dependencies...")
    
    try:
        # Install from requirements.txt
        subprocess.check_call([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"])
        print("✅ Dependencies installed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error installing dependencies: {e}")
        return False

def check_system_requirements():
    """Check system requirements"""
    print("\n🔍 Checking system requirements...")
    
    # Check OS
    system = platform.system()
    print(f"✅ Operating System: {system}")
    
    # Check for webcam (optional)
    try:
        import cv2
        cap = cv2.VideoCapture(0)
        if cap.isOpened():
            print("✅ Webcam detected")
        else:
            print("⚠️  No webcam detected (video monitoring will be disabled)")
        cap.release()
    except ImportError:
        print("⚠️  OpenCV not installed (video monitoring will be disabled)")
    
    # Check for GUI support
    try:
        import tkinter
        print("✅ GUI support available")
    except ImportError:
        print("❌ GUI support not available (host script may not work)")
        return False
    
    return True

def create_directories():
    """Create necessary directories"""
    print("\n📁 Creating directories...")
    
    directories = ["logs", "screenshots", "saved_data"]
    
    for directory in directories:
        if not os.path.exists(directory):
            os.makedirs(directory)
            print(f"✅ Created directory: {directory}")
        else:
            print(f"✅ Directory exists: {directory}")

def test_imports():
    """Test if all required modules can be imported"""
    print("\n🧪 Testing imports...")
    
    required_modules = [
        "requests",
        "PIL",
        "pynput",
        "cv2",
        "numpy",
        "psutil",
        "tkinter"
    ]
    
    failed_imports = []
    
    for module in required_modules:
        try:
            __import__(module)
            print(f"✅ {module}")
        except ImportError:
            print(f"❌ {module}")
            failed_imports.append(module)
    
    if failed_imports:
        print(f"\n⚠️  Failed to import: {', '.join(failed_imports)}")
        return False
    
    print("✅ All imports successful")
    return True

def show_next_steps():
    """Show next steps to the user"""
    print("\n" + "="*50)
    print("🎉 Installation Complete!")
    print("="*50)
    
    print("\n📋 Next Steps:")
    print("1. On the target computer, run:")
    print("   python client_script.py")
    print("\n2. On your control computer, run:")
    print("   python host_script.py")
    print("\n3. Enter the target computer's IP address in the host script")
    print("4. Click 'Connect' to start monitoring")
    
    print("\n📚 For detailed instructions, see: README_remote_control.md")
    
    print("\n⚠️  Important Notes:")
    print("- Only use on computers you own or have permission to monitor")
    print("- Ensure both computers are on the same network")
    print("- Check firewall settings if connection fails")
    print("- The Discord webhook is pre-configured in the client script")

def main():
    """Main installation function"""
    print("🚀 Remote Control System Installation")
    print("="*40)
    
    # Check Python version
    if not check_python_version():
        sys.exit(1)
    
    # Check system requirements
    if not check_system_requirements():
        print("\n❌ System requirements not met")
        sys.exit(1)
    
    # Install dependencies
    if not install_dependencies():
        print("\n❌ Failed to install dependencies")
        sys.exit(1)
    
    # Test imports
    if not test_imports():
        print("\n❌ Some modules failed to import")
        print("Try running: pip install -r requirements.txt manually")
        sys.exit(1)
    
    # Create directories
    create_directories()
    
    # Show next steps
    show_next_steps()

if __name__ == "__main__":
    main()