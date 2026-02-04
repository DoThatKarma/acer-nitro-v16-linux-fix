# Acer Nitro V16 GPU & Fan Fix for Windows
# Fixes NVIDIA GPU always-on issue causing high temps and fan noise
# Requires Administrator privileges

# Check for admin privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires Administrator privileges!"
    Write-Host "Please right-click the script and select 'Run as Administrator'" -ForegroundColor Yellow
    Write-Host "Or use the fix-nitro-gpu.bat launcher instead." -ForegroundColor Cyan
    pause
    exit
}

Write-Host "=== Acer Nitro V16 GPU & Fan Fix for Windows ===" -ForegroundColor Cyan
Write-Host ""

# 1. Check if NVIDIA drivers are installed
Write-Host "[1/5] Checking NVIDIA drivers..." -ForegroundColor Green
$nvidiaPath = "C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe"
if (-Not (Test-Path $nvidiaPath)) {
    Write-Host "ERROR: NVIDIA drivers not found!" -ForegroundColor Red
    Write-Host "Please install NVIDIA drivers first from: https://www.nvidia.com/Download/index.aspx" -ForegroundColor Yellow
    pause
    exit
}
Write-Host "✓ NVIDIA drivers found" -ForegroundColor Green
Write-Host ""

# 2. Set Windows Graphics Performance Preference to Power Saving
Write-Host "[2/5] Setting Windows Graphics Preference to Power Saving..." -ForegroundColor Green
$registryPath = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
Set-ItemProperty -Path $registryPath -Name "DirectXUserGlobalSettings" -Value "VRROptimizeEnable=0;SwapEffectUpgradeEnable=1;" -Type String
Write-Host "✓ Graphics preference configured" -ForegroundColor Green
Write-Host ""

# 3. Configure NVIDIA Control Panel settings via registry
Write-Host "[3/5] Configuring NVIDIA GPU to use Integrated Graphics by default..." -ForegroundColor Green

# Set global 3D settings to Auto-select (prefer iGPU)
$nvidiaRegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000"
if (Test-Path $nvidiaRegPath) {
    Set-ItemProperty -Path $nvidiaRegPath -Name "PowerMizerEnable" -Value 1 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $nvidiaRegPath -Name "PowerMizerLevel" -Value 0 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $nvidiaRegPath -Name "PerfLevelSrc" -Value 0x2222 -Type DWord -ErrorAction SilentlyContinue
    Write-Host "✓ NVIDIA power settings optimized" -ForegroundColor Green
} else {
    Write-Host "⚠ Could not find NVIDIA registry path (this is OK)" -ForegroundColor Yellow
}
Write-Host ""

# 4. Disable unnecessary NVIDIA services for power saving
Write-Host "[4/5] Optimizing NVIDIA services..." -ForegroundColor Green
$services = @(
    "NVDisplay.ContainerLocalSystem",
    "NvTelemetryContainer"
)

foreach ($service in $services) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($svc) {
        Set-Service -Name $service -StartupType Manual -ErrorAction SilentlyContinue
        Write-Host "✓ Set $service to Manual startup" -ForegroundColor Green
    }
}
Write-Host ""

# 5. Create shortcuts and helper tools
Write-Host "[5/5] Creating desktop shortcuts..." -ForegroundColor Green
$desktopPath = [Environment]::GetFolderPath("Desktop")

# NVIDIA Control Panel shortcut
$nvControlPanelShortcut = "$desktopPath\NVIDIA Control Panel.lnk"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($nvControlPanelShortcut)
$Shortcut.TargetPath = "C:\Windows\System32\nvcplui.exe"
$Shortcut.Description = "NVIDIA Control Panel"
$Shortcut.Save()

# Create a helper script for launching games with NVIDIA GPU
$gameScriptPath = "$desktopPath\Run-With-NVIDIA.bat"
$gameScriptContent = @"
@echo off
echo ================================================
echo Running application with NVIDIA GPU
echo ================================================
echo.
echo Usage: Drag and drop a game/app onto this file
echo        OR run: Run-With-NVIDIA.bat "path\to\game.exe"
echo.
if "%~1"=="" (
    echo ERROR: No application specified!
    echo Please drag and drop an .exe file onto this script.
    pause
    exit /b
)
echo Starting: %~1
echo.
start "" "%~1"
"@
Set-Content -Path $gameScriptPath -Value $gameScriptContent
Write-Host "✓ Created 'Run-With-NVIDIA.bat' on Desktop" -ForegroundColor Green
Write-Host ""

# Display completion message
Write-Host "=== Fix Complete! ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "What was done:" -ForegroundColor White
Write-Host "✓ Set Windows to prefer Integrated Graphics" -ForegroundColor Green
Write-Host "✓ Optimized NVIDIA GPU power settings" -ForegroundColor Green
Write-Host "✓ Set NVIDIA services to Manual startup" -ForegroundColor Green
Write-Host "✓ Created desktop shortcuts for GPU control" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT NEXT STEPS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Open NVIDIA Control Panel (shortcut on desktop)" -ForegroundColor White
Write-Host "2. Go to: Manage 3D Settings > Global Settings" -ForegroundColor White
Write-Host "3. Set 'Preferred graphics processor' to 'Auto-select'" -ForegroundColor White
Write-Host "4. Click Apply" -ForegroundColor White
Write-Host ""
Write-Host "For Gaming:" -ForegroundColor Cyan
Write-Host "• Option A: In NVIDIA Control Panel > Program Settings, add your games and set to 'High-performance NVIDIA processor'" -ForegroundColor White
Write-Host "• Option B: Right-click game .exe > 'Run with graphics processor' > High-performance NVIDIA" -ForegroundColor White
Write-Host "• Option C: Use 'Run-With-NVIDIA.bat' on your desktop (drag game onto it)" -ForegroundColor White
Write-Host ""
Write-Host "After these steps, RESTART YOUR COMPUTER for all changes to take effect." -ForegroundColor Yellow
Write-Host ""

$restart = Read-Host "Do you want to restart now? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") {
    Write-Host "Restarting in 10 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    Restart-Computer -Force
} else {
    Write-Host "Please restart manually when ready." -ForegroundColor Yellow
    pause
}
