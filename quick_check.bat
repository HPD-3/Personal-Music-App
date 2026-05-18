@echo off
echo Building Personal Music App...
cd /d D:\appliaction\personal_music_app
flutter clean && flutter pub get && flutter analyze lib/
pause
