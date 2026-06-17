import os
import time
import subprocess
import urllib.request
import urllib.error
import json
import socket
from dotenv import load_dotenv

# Load environment variables dari file .env
load_dotenv()

BACKEND_URL = os.getenv("BACKEND_URL", "http://localhost:3001")
AUTH_TOKEN = os.getenv("AUTH_TOKEN", "20181110008")
IDENTIFY_BY = os.getenv("IDENTIFY_BY", "ip").lower()
IDENTIFY_VALUE = os.getenv("IDENTIFY_VALUE", "")
POLL_INTERVAL = float(os.getenv("POLL_INTERVAL_SECONDS", "10"))

def get_local_ip():
    try:
        # Mendapatkan IP lokal mesin ini yang terhubung ke jaringan
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "127.0.0.1"

# Tentukan nilai identifikasi perangkat jika kosong
if not IDENTIFY_VALUE:
    if IDENTIFY_BY == "ip":
        IDENTIFY_VALUE = get_local_ip()
        print(f"Detected local IP: {IDENTIFY_VALUE}")
    else:
        print("Warning: IDENTIFY_BY is set to mac but IDENTIFY_VALUE is empty. Please set it in .env")
        IDENTIFY_VALUE = "00:00:00:00:00:00"

print(f"--------------------------------------------------")
print(f"Starting Windows Power Service Client (Pull Model)")
print(f"Backend URL  : {BACKEND_URL}")
print(f"Identify By  : {IDENTIFY_BY} = {IDENTIFY_VALUE}")
print(f"Poll Interval: {POLL_INTERVAL} seconds")
print(f"--------------------------------------------------")

while True:
    try:
        # Membentuk URL polling
        url = f"{BACKEND_URL}/api/v1/devices/poll/power-state?{IDENTIFY_BY}={IDENTIFY_VALUE}&token={AUTH_TOKEN}"
        
        req = urllib.request.Request(url)
        with urllib.request.urlopen(req, timeout=5) as response:
            data = json.loads(response.read().decode())
            
            if data.get("success"):
                action = data.get("action", "power_on")
                
                if action == "power_off":
                    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] Received command: power_off -> Initiating Shutdown")
                    subprocess.Popen("shutdown /s /t 0", shell=True)
                elif action == "power_sleep":
                    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] Received command: power_sleep -> Initiating Sleep")
                    subprocess.Popen("rundll32.exe powrprof.dll,SetSuspendState 0,1,0", shell=True)
                elif action == "power_reboot":
                    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] Received command: power_reboot -> Initiating Reboot")
                    subprocess.Popen("shutdown /r /t 0", shell=True)
                else:
                    # power_on atau status normal lainnya -> diamkan
                    pass
            else:
                print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] Server returned failure: {data.get('message')}")
                
    except urllib.error.URLError as e:
        print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] Connection error: {e.reason}")
    except Exception as e:
        print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] Error in polling loop: {str(e)}")
        
    time.sleep(POLL_INTERVAL)
