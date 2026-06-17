@echo off
cd /d "%~dp0"
echo Checking python installation...
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python was not found. Please install Python first.
    pause
    exit /b 1
)

if not exist venv (
    echo Creating virtual environment...
    python -m venv venv
)

echo Activating virtual environment...
call venv\Scripts\activate

echo Installing requirements...
pip install -r requirements.txt

echo Starting Windows Power Service Client (Pull Model)...
python client.py
pause
