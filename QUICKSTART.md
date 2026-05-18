# 🚀 Quick Start Guide

Get your Personal Music Player app running in 5 minutes!

## Prerequisites
- Flutter SDK (3.11.5+)
- Android SDK or emulator
- 5-10 minutes

## Quick Start

### Step 1: Install Dependencies
```bash
cd personal_music_app
flutter pub get
```

### Step 2: Connect Device/Emulator
```bash
flutter devices  # Check available devices
```

### Step 3: Run the App
```bash
flutter run
```

### Step 4: Grant Permissions
When the app starts, tap "Allow" for:
- Storage access (to read music files)
- Media access (for playback)

### Step 5: Enjoy!
- Browse songs in the "Songs" tab
- Tap any song to play
- Use player controls at bottom or tap to open full player

## 🎵 Essential Features

| Feature | How to Use |
|---------|-----------|
| **Play Music** | Tap any song in Songs tab |
| **Next/Previous** | Use skip buttons in mini player |
| **Pause** | Tap pause button |
| **Search** | Type in search box on Songs screen |
| **Sort** | Click sort chips (Name, Artist, Duration, etc.) |
| **Favorites** | Tap heart icon on any song |
| **Full Player** | Tap mini player to open |
| **Playlists** | Create in Playlists tab |
| **Settings** | Tap gear icon in home screen |

## 📱 Navigation

```
Home Screen (Songs/Albums/Artists/Playlists)
    ↓
Tap a Song → Full Player opens
    ↓
Use Controls → Play/Pause/Next/Previous
```

## ⚙️ Build Options

### Debug Build (Fast, Large)
```bash
flutter run -d <device_id>
```

### Release Build (Small, Fast)
```bash
flutter build apk --release
flutter install  # On Android device
```

### Run on Specific Device
```bash
flutter run -d emulator-5554
flutter run -d RF8M32KBBGH  # Physical device
```

## 🐛 Troubleshooting

### No Songs Found?
1. Ensure device has music files (copy some MP3s)
2. Grant storage permission
3. Restart app

### App Crashes?
1. Clean build: `flutter clean`
2. Reinstall: `flutter pub get && flutter run`

### Permission Issues?
1. Go to Settings → Apps → Personal Music Player → Permissions
2. Enable "Files and media"

### Performance Issues?
1. Close other apps
2. Clear app cache in Settings
3. Restart device

## 🔧 Configuration

### Change App Name
Edit `pubspec.yaml` → `name` field

### Change Primary Color
Edit `lib/core/constants/app_colors.dart`

### Change Theme
Edit `lib/providers/theme_provider.dart`

## 📊 App Structure at a Glance

- **Models** - Song, Album, Artist, Playlist data
- **Providers** - State management (Audio, Songs, etc.)
- **Services** - Playback, scanning, storage
- **Screens** - Home, Player, Playlists, etc.
- **Widgets** - Reusable UI components

## 🎯 Common Tasks

### Add a New Feature
1. Create model in `lib/models/`
2. Create provider in `lib/providers/`
3. Create service in `lib/services/` (if needed)
4. Build UI in `lib/screens/`

### Customize Colors
Edit `lib/core/constants/app_colors.dart`

### Change Permissions
Edit `android/app/src/main/AndroidManifest.xml`

### Add Dependencies
```bash
flutter pub add package_name
```

## 📚 More Info

- Full documentation: See `README.md`
- Architecture details: See `BUILD_SUMMARY.md`
- Build report: See `COMPLETION_REPORT.md`

## 🆘 Need Help?

1. Check `README.md` for detailed guide
2. Review `BUILD_SUMMARY.md` for architecture
3. Check Flutter documentation: https://flutter.dev
4. Search issue online with error message

## ✨ Tips

- Use `flutter run -v` for verbose output
- Use `flutter analyze` to check code issues
- Use `flutter format .` to format code
- Use `flutter doctor` to check setup

---

**That's it! Your music player is ready! 🎵**

Enjoy offline music playback! 🚀
