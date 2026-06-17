@echo off
cd /d "%~dp0"
title Start Power Service

if not exist run_hidden.vbs (
    echo [ERROR] File run_hidden.vbs tidak ditemukan.
    echo Harap jalankan auto_install.bat terlebih dahulu untuk instalasi.
    pause
    exit /b 1
)

:: Cek apakah service sudah berjalan
powershell -NoProfile -Command "$p = Get-CimInstance Win32_Process -Filter \"(Name = 'python.exe' or Name = 'pythonw.exe') and CommandLine like '%%client.py%%'\"; if ($p) { exit 1 } else { exit 0 }"
if %errorlevel% equ 1 (
    echo [INFO] Power Service sudah berjalan di background.
    pause
    exit /b 0
)

echo Menjalankan Power Service di background...
wscript.exe run_hidden.vbs
echo [SUCCESS] Power Service berhasil dijalankan.
pause
