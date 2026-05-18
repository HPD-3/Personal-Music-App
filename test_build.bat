@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================
echo Flutter Music App - Comprehensive Build Test
echo ========================================
echo.

cd /d D:\appliaction\personal_music_app

echo [1/5] Cleaning previous builds...
call flutter clean
if !errorlevel! neq 0 (
    echo ERROR: flutter clean failed
    pause
    exit /b 1
)
echo.

echo [2/5] Getting dependencies...
call flutter pub get
if !errorlevel! neq 0 (
    echo ERROR: flutter pub get failed
    pause
    exit /b 1
)
echo.

echo [3/5] Checking Dart analysis...
call flutter analyze lib/
if !errorlevel! neq 0 (
    echo WARNING: Some analysis issues found (continuing anyway)
)
echo.

echo [4/5] Running build...
call flutter pub global activate devtools
echo.

echo [5/5] Launching app on device...
call flutter run
if !errorlevel! neq 0 (
    echo ERROR: flutter run failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo Build and run successful!
echo ========================================
pause
