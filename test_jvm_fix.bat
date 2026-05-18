@echo off
setlocal enabledelayedexpansion

cd /d D:\appliaction\personal_music_app

echo Testing JVM compatibility fix...
echo.

echo [1/3] Cleaning build...
call flutter clean
if !errorlevel! neq 0 (
    echo ERROR: flutter clean failed
    pause
    exit /b 1
)
echo Cleaning completed successfully.
echo.

echo [2/3] Getting dependencies...
call flutter pub get
if !errorlevel! neq 0 (
    echo ERROR: flutter pub get failed
    pause
    exit /b 1
)
echo Dependencies resolved successfully.
echo.

echo [3/3] Building Android app (debug)...
call flutter build apk --debug 2>&1 | findstr /C:"BUILD FAILED" /C:"BUILD SUCCESSFUL" /C:"Inconsistent"
if !errorlevel! equ 0 (
    echo.
    echo Build test completed. Check output above for results.
) else (
    echo.
    echo Running full build output...
    call flutter build apk --debug
)

pause
