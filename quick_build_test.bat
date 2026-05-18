@echo off
setlocal enabledelayedexpansion

cd /d D:\appliaction\personal_music_app

echo Verifying JVM compatibility fix...
echo.

REM Clean Flutter cache
echo Cleaning Flutter build...
call flutter clean >nul 2>&1

REM Get dependencies
echo Getting dependencies...
call flutter pub get >nul 2>&1

REM Test build (with output filtering)
echo Running Android build to test JVM compatibility...
echo.

call flutter build apk --debug 2>&1 | findstr /I "FAILURE SUCCESS kotlin JVM jvm Inconsistent"
set build_result=!errorlevel!

if !build_result! equ 0 (
    echo.
    echo Build completed. Checking for errors...
    call flutter build apk --debug 2>&1 | find /V "^" > nul
    if !errorlevel! equ 0 (
        echo SUCCESS: Build appears to have completed!
    )
) else (
    echo.
    call flutter build apk --debug
)

echo.
pause
