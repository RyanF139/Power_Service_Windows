@echo off
title Stop Power Service

echo Menghentikan Power Service di background...

:: Mencari proses python yang mengeksekusi client.py dan menghentikannya secara paksa
powershell -Command "$processes = Get-CimInstance Win32_Process -Filter \"CommandLine like '%%client.py%%'\"; if ($processes) { foreach ($p in $processes) { Stop-Process -Id $p.ProcessId -Force; Write-Host \"[SUCCESS] Menghentikan proses dengan PID: $($p.ProcessId)\" } } else { Write-Host \"[INFO] Tidak ada proses Power Service yang sedang berjalan.\" }"

echo Selesai.
pause
