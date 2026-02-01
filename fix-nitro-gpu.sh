#!/bin/bash
# Acer Nitro V16 Cinnamon + NVIDIA Fix Script
# Fixes GPU power management and fan issues after DE switching

echo "=== Acer Nitro V16 GPU & Fan Fix for Cinnamon ==="
echo ""

# 1. Check current GPU mode
echo "[1/6] Checking current GPU configuration..."
prime-select query 2>/dev/null || echo "prime-select not found, will install"
echo ""

# 2. Install necessary packages
echo "[2/6] Installing GPU management tools..."
sudo apt update
sudo apt install -y nvidia-prime system76-power tlp tlp-rdw
echo ""

# 3. Set GPU to on-demand mode (hybrid)
echo "[3/6] Setting GPU to on-demand (hybrid) mode..."
sudo prime-select on-demand
echo ""

# 4. Configure TLP for better power management
echo "[4/6] Configuring TLP for laptop power management..."
sudo tee /etc/tlp.conf > /dev/null <<'EOF'
# TLP configuration for Acer Nitro V16

# CPU Scaling Governor
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave

# CPU Energy Performance
CPU_ENERGY_PERF_POLICY_ON_AC=balance_performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power

# CPU Boost
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0

# Platform Profile (AMD)
PLATFORM_PROFILE_ON_AC=balanced
PLATFORM_PROFILE_ON_BAT=low-power

# Runtime Power Management for PCI(e) devices
RUNTIME_PM_ON_AC=auto
RUNTIME_PM_ON_BAT=auto

# NVIDIA GPU runtime power management
RUNTIME_PM_DRIVER_DENYLIST="nouveau nvidia"

# SATA Link Power Management
SATA_LINKPWR_ON_AC="med_power_with_dipm max_performance"
SATA_LINKPWR_ON_BAT="med_power_with_dipm min_power"

# WiFi Power Saving
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=on
EOF

sudo systemctl enable tlp
sudo systemctl start tlp
echo ""

# 5. Fix Cinnamon compositor settings
echo "[5/6] Optimizing Cinnamon settings for hybrid GPU..."
gsettings set org.cinnamon.desktop.wm.preferences unredirect-fullscreen-windows true
gsettings set org.cinnamon.muffin unredirect-fullscreen-windows true
echo ""

# 6. Set NVIDIA settings to use integrated GPU by default
echo "[6/6] Configuring NVIDIA to use iGPU by default..."
sudo tee /etc/environment.d/50-nvidia-prime.conf > /dev/null <<'EOF'
# Use integrated GPU by default
__NV_PRIME_RENDER_OFFLOAD=0
__GLX_VENDOR_LIBRARY_NAME=
DRI_PRIME=
EOF

# Add NVIDIA offload functions to bashrc
if ! grep -q "nvidia-offload" ~/.bashrc; then
    cat >> ~/.bashrc <<'EOF'

# NVIDIA GPU offload functions
alias nvidia-offload='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia'
alias nvidia-run='DRI_PRIME=1 __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia'
EOF
fi

echo ""
echo "=== Fix Complete! ==="
echo ""
echo "What was done:"
echo "✓ Installed GPU power management tools"
echo "✓ Set GPU to on-demand (hybrid) mode"
echo "✓ Configured TLP for better laptop power management"
echo "✓ Fixed Cinnamon compositor settings"
echo "✓ Set system to use integrated GPU by default"
echo ""
echo "IMPORTANT: REBOOT NOW for changes to take effect!"
echo ""
echo "After reboot:"
echo "• Normal use = AMD iGPU (quiet fans, cool temps)"
echo "• Gaming = Run games with: nvidia-run <game-command>"
echo "  Example: nvidia-run steam"
echo ""
echo "To check GPU status: prime-select query"
echo "To check which GPU is active: nvidia-smi"
echo ""
read -p "Reboot now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo reboot
fi
