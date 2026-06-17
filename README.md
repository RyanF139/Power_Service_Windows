# Windows Power Service (Pull/Polling Client)

Service background sederhana untuk OS Windows yang memantau perintah status daya (Shutdown, Sleep) dari server monitoring pusat dengan melakukan polling (Pull Model).

## Keunggulan
- **Aman**: Tidak memerlukan pembukaan port masuk (inbound port) pada PC Windows.
- **Mudah**: Bekerja dengan baik di belakang router/NAT tanpa port-forwarding.
- **Ringan**: Tidak menggunakan library web server berat seperti FastAPI/Uvicorn.

## Persyaratan
- Windows OS
- Python 3.8 ke atas

## Cara Menjalankan Secara Manual (Development/Testing)
1. Konfigurasikan file `.env` di folder ini (masukkan URL backend Anda pada `BACKEND_URL`).
2. Double click file `run.bat` di dalam folder ini.
3. Script akan secara otomatis membuat virtual environment (`venv`), menginstal dependensi (`python-dotenv`), dan mulai melakukan pengecekan ke server secara periodik.

---

## Cara Install Sebagai Windows Background Service (Production)
Untuk menjalankan skrip ini di background secara otomatis saat Windows boot, disarankan menggunakan **NSSM (Non-Sucking Service Manager)**:

1. Unduh **NSSM** dari [nssm.cc](https://nssm.cc/download).
2. Ekstrak file `nssm.exe` (pilih versi 64-bit).
3. Buka **Command Prompt (CMD)** atau **PowerShell** sebagai **Administrator**.
4. Daftarkan service baru dengan perintah:
   ```cmd
   path\to\nssm.exe install WindowsPowerService
   ```
5. Pada jendela GUI NSSM yang muncul, isi kolom berikut:
   - **Path**: Path ke python executable di virtual environment Anda, contoh:
     `C:\Users\TUF\Documents\python\app\monitoring-dc\app\power_service_windows\venv\Scripts\python.exe`
   - **Startup directory**: Path ke folder proyek service Anda:
     `C:\Users\TUF\Documents\python\app\monitoring-dc\app\power_service_windows`
   - **Arguments**: `client.py`
6. Klik **Install service**.
7. Jalankan service dengan perintah:
   ```cmd
   nssm start WindowsPowerService
   ```
