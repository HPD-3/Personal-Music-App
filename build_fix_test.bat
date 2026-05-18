@echo off
echo.
echo ========================================
echo Flutter Music App - Build Fix Test
echo ========================================
echo.

cd /d D:\appliaction\personal_music_app

echo [1/3] Running flutter clean...
call flutter clean
if %errorlevel% neq 0 (
    echo ERROR: flutter clean failed
    pause
    exit /b 1
)
echo.

echo [2/3] Running flutter pub get...
call flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: flutter pub get failed
    pause
    exit /b 1
)
echo.

echo [3/3] Running flutter run...
call flutter run
if %errorlevel% neq 0 (
    echo ERROR: flutter run failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo Build successful!
echo ========================================
pause
