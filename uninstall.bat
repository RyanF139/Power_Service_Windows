@echo off
title Uninstall Power Service Windows
echo ==================================================
echo   Uninstalling Power Service Windows...
echo ==================================================
echo.

:: 1. Hentikan proses latar belakang
echo Menghentikan proses background...
powershell -NoProfile -Command "$processes = Get-CimInstance Win32_Process -Filter \"(Name = 'python.exe' or Name = 'pythonw.exe') and CommandLine like '%%client.py%%'\"; if ($processes) { foreach ($p in $processes) { Stop-Process -Id $p.ProcessId -Force; Write-Host \"[SUCCESS] Menghentikan proses dengan PID: $($p.ProcessId)\" } } else { Write-Host \"[INFO] Tidak ada proses aktif.\" }"
echo.

:: 2. Hapus dari Startup Windows
echo Menghapus pintasan dari Startup Windows...
set "STARTUP_LNK=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\PowerService.lnk"
if exist "%STARTUP_LNK%" (
    del "%STARTUP_LNK%"
    echo [SUCCESS] Shortcut Startup berhasil dihapus.
) else (
    echo [INFO] Shortcut Startup tidak ditemukan.
)
echo.

:: 3. Hapus folder instalasi secara otomatis
echo Menghapus folder instalasi C:\PowerService secara otomatis...
set "INSTALL_DIR=%SystemDrive%\PowerService"
if exist "%INSTALL_DIR%" (
    start /b cmd /c "timeout /t 1 /nobreak >nul & rmdir /s /q ""%INSTALL_DIR%"""
)

echo.
echo ==================================================
echo   Uninstall Selesai!
echo ==================================================
echo Proses latar belakang, startup, dan folder instalan berhasil dihapus.
echo Jendela ini akan tertutup otomatis.
echo.
timeout /t 3 >nul
exit
