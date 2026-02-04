@echo off
:: Acer Nitro V16 GPU Fix - Easy Launcher for Windows
:: This runs the PowerShell script with admin rights automatically

title Acer Nitro V16 GPU Fix

echo ================================================
echo   Acer Nitro V16 GPU ^& Fan Fix for Windows
echo ================================================
echo.
echo This script will fix NVIDIA GPU staying active
echo and causing loud fans on your Acer Nitro V16.
echo.
echo The script will:
echo  - Configure GPU to use AMD iGPU by default
echo  - Optimize power management settings
echo  - Create shortcuts for easy GPU control
echo.
echo ================================================
echo.
pause

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running with Administrator privileges...
    echo.
    powershell -ExecutionPolicy Bypass -File "%~dp0fix-nitro-gpu.ps1"
    if %errorLevel% == 0 (
        echo.
        echo ================================================
        echo   Fix completed successfully!
        echo ================================================
        echo.
    ) else (
        echo.
        echo [ERROR] Script failed. Please check the errors above.
        echo.
    )
) else (
    echo [INFO] Requesting Administrator privileges...
    echo.
    powershell -Command "Start-Process cmd -ArgumentList '/c """"%~f0""""' -Verb RunAs"
    exit
)

pause
