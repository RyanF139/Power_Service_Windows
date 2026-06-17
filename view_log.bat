@echo off
cd /d "%~dp0"
title View Power Service Log

if not exist client.log (
    echo [INFO] File client.log belum terbentuk atau service belum pernah menulis log.
    echo Pastikan service sudah dijalankan menggunakan start_service.bat atau auto_install.bat.
    pause
    exit /b 0
)

echo ==================================================
echo   Menampilkan Log Power Service (Real-time)
echo   Tekan Ctrl+C untuk keluar dari tampilan log
echo ==================================================
echo.

:: Menjalankan tail log menggunakan PowerShell
powershell -Command "Get-Content -Path client.log -Wait -Tail 30"
