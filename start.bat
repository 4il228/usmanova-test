@echo off
cd /d "%~dp0"
start "" cmd /c "npx serve ."
timeout /t 2 /nobreak >nul
start "" http://localhost:3000
