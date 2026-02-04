# Acer Nitro V16 GPU & Fan Fix

Fix for fans running at full speed on **Acer Nitro V16 (ANV16-41 / N24C4)** especially with AMD Ryzen + NVIDIA GPU hybrid graphics on **Linux** and **Windows**. But probably usable for different models of Acer Nitro lineup.

## 🔥 Problem

After switching between desktop environments (Cinnamon/GNOME) or fresh OS install, the NVIDIA GPU stays active constantly, causing:
- 🌪️ **Fans running at maximum speed constantly**
- 🔥 **High temperatures even when idle**
- 🔋 **Poor battery life**
- 🐌 **System feeling sluggish**

This is also an issue for this laptop overall so i added a fix for Windows too, to make the Acer Nitro an affordable and powerful computer you can use in peace.

## ✅ Solution

This script configures hybrid GPU mode properly, ensuring the **AMD integrated GPU is used by default** and NVIDIA GPU only activates when needed for gaming/intensive tasks.

---

## 🐧 Linux Installation

### Quick Install (One Command)
```bash
wget https://raw.githubusercontent.com/DoThatKarma/acer-nitro-v16-linux-fix/main/fix-nitro-gpu.sh && chmod +x fix-nitro-gpu.sh && ./fix-nitro-gpu.sh
```

### Manual Install

1. Download the script:
```bash
git clone https://github.com/DoThatKarma/acer-nitro-v16-linux-fix.git
cd acer-nitro-v16-linux-fix
```

2. Make it executable:
```bash
chmod +x fix-nitro-gpu.sh
```

3. Run the script:
```bash
./fix-nitro-gpu.sh
```

4. **Reboot when prompted**

### What It Does (Linux)

1. ✅ Installs GPU management tools (nvidia-prime, TLP)
2. ✅ Sets GPU to on-demand (hybrid) mode
3. ✅ Configures TLP for optimal laptop power management
4. ✅ Fixes Cinnamon compositor GPU settings
5. ✅ Configures system to use AMD iGPU by default
6. ✅ Adds helper commands for running apps with NVIDIA GPU

### After Installation (Linux)

**Normal Usage (Quiet & Cool):**
Just use your laptop normally. The AMD integrated GPU handles everything, keeping fans quiet and temps low.

**Gaming (Full Performance):**
```bash
# For Steam games
nvidia-run steam

# For other games/apps
nvidia-run ./game-executable

# Alternative
nvidia-offload your-game-command
```

**Check GPU Status:**
```bash
# Check which GPU mode is active
prime-select query

# Check if NVIDIA GPU is currently in use
nvidia-smi

# Monitor temperatures
watch -n 1 sensors
```

---

## 🪟 Windows Installation

### Option A: Easy Install (Recommended for Beginners)

1. **Download:** [fix-nitro-gpu.bat](https://raw.githubusercontent.com/DoThatKarma/acer-nitro-v16-linux-fix/main/fix-nitro-gpu.bat)
   - Right-click the link > Save As > `fix-nitro-gpu.bat`
2. **Double-click** `fix-nitro-gpu.bat`
3. Click **"Yes"** when Windows asks for admin permission
4. Follow on-screen instructions
5. **Restart your computer**

### Option B: PowerShell (Advanced Users)

1. **Download:** [fix-nitro-gpu.ps1](https://raw.githubusercontent.com/DoThatKarma/acer-nitro-v16-linux-fix/main/fix-nitro-gpu.ps1)
2. **Right-click** `fix-nitro-gpu.ps1` > **"Run with PowerShell"**
3. If you get an error about execution policy:
   - Open PowerShell as Administrator
   - Run: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
   - Type `Y` and press Enter
   - Try step 2 again
4. Follow on-screen instructions
5. **Restart your computer**

### Manual NVIDIA Control Panel Setup (Windows)

**After running the script and restarting:**

1. Open **NVIDIA Control Panel** (shortcut on desktop or right-click desktop)
2. Go to **Manage 3D Settings** > **Global Settings**
3. Set **"Preferred graphics processor"** to **"Auto-select"**
4. Click **Apply**

### For Gaming (Windows)

**Method 1:** Per-game settings in NVIDIA Control Panel
- Manage 3D Settings > Program Settings
- Click "Add" and select your game
- Set to "High-performance NVIDIA processor"
- Click Apply

**Method 2:** Right-click method
- Right-click game .exe file
- Select "Run with graphics processor" > "High-performance NVIDIA processor"

**Method 3:** Use the desktop helper
- Drag your game .exe onto `Run-With-NVIDIA.bat` (created on desktop)

---

## 🖥️ Compatibility

**Tested on:**
- ✅ Acer Nitro V16 (ANV16-41 / N24C4)
- ✅ AMD Ryzen 7 8845HS + NVIDIA RTX 4060
- ✅ Linux Mint / Ubuntu / Debian-based distros
- ✅ Cinnamon, GNOME, KDE, XFCE desktop environments
- ✅ Windows 10 / Windows 11

**Should work on:**
- Other Acer Nitro V series with AMD + NVIDIA
- Similar hybrid GPU laptops from other brands

---

## 🔧 Troubleshooting

### Linux: Fans still running full speed?
```bash
# Check if NVIDIA GPU is active
nvidia-smi

# If it shows processes, something is using the GPU
# Kill unnecessary processes or reboot
```

### Linux: Want to always use NVIDIA GPU?
```bash
sudo prime-select nvidia
sudo reboot
```

### Linux: Want to disable NVIDIA GPU completely?
```bash
sudo prime-select intel  # Uses AMD iGPU only
sudo reboot
```

### Linux: Revert all changes
```bash
sudo apt remove tlp tlp-rdw
sudo rm /etc/tlp.conf
sudo rm /etc/environment.d/50-nvidia-prime.conf
sudo prime-select on-demand
sudo reboot
```

### Windows: Script won't run

**Error: Execution policy restriction**
```powershell
# Open PowerShell as Administrator and run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Windows: Fans still loud

- Open **Task Manager** (Ctrl+Shift+Esc)
- Go to **Performance** tab
- Check **GPU 1** (NVIDIA) usage
- If it shows activity, check what's using it under **Processes** tab
- Close unnecessary programs or reboot

### Windows: Revert changes

- Open **NVIDIA Control Panel**
- Manage 3D Settings > **Restore Defaults**
- Open **Services** (Win+R > type `services.msc`)
- Find NVIDIA services and set back to **Automatic**
- Restart computer

---

## 🛠️ Additional Fan Control (Optional)

For **more granular fan control**, try [Div Acer Manager](https://github.com/PXDiv/Div-Acer-Manager-Fan-Controls):
```bash
# Linux only
git clone https://github.com/PXDiv/Div-Acer-Manager-Fan-Controls
cd Div-Acer-Manager-Fan-Controls
sudo ./install.sh
```

---

## 🤝 Contributing

Found this helpful? **Star the repo!** ⭐

Have improvements or found this works on other models? **Pull requests welcome!**

If this works on other Acer models, please [open an issue](https://github.com/DoThatKarma/acer-nitro-v16-linux-fix/issues) to let us know.

---

## 📝 Credits

- Solution discovered while troubleshooting Acer Nitro V16 ANV16-41 (N24C4)
- Thanks to the Linux and Windows communities for GPU management tools
- Created by [@DoThatKarma](https://github.com/DoThatKarma)

---

## 📜 License

**MIT License** - Feel free to use and modify

See [LICENSE](LICENSE) file for details.

---

## ⚠️ Disclaimer

- Use at your own risk. Always backup your data before running system scripts.
- This script modifies system power management settings.
- Not affiliated with Acer or NVIDIA.

---

## 🌟 Support

If this helped you, give it a star! ⭐

Having issues? [Open an issue](https://github.com/DoThatKarma/acer-nitro-v16-linux-fix/issues)
```
--

Hope you enjoy this fix as much as me, it made the computer friendly to use in a quiet enviroment! Please star and share if u liked it!
And let me know if u have some more fixes or comments! :)


Best regards
DoThat
