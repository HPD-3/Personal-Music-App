# Personal Music Player - Flutter Offline Music App

A modern, feature-rich offline music player application built with Flutter for Android. Play your favorite music with a sleek Material 3 dark theme interface inspired by Spotify and Poweramp.

## 🎵 Features

### Core Functionality
- **Local Music Scanning** - Automatically scans and indexes all audio files on your device
- **Offline Playback** - Play music without internet connection
- **Background Playback** - Continue playing music while using other apps
- **Persistent Playback State** - Resume playback from where you left off

### Playback Controls
- Play, Pause, Next, Previous functionality
- Seek slider with real-time progress tracking
- Shuffle mode for random playback
- Repeat modes (None, All, One)
- Volume control
- Playback speed adjustment

### Music Organization
- **Songs** - Browse all songs by title, artist, album, or date added
- **Albums** - View albums with album artwork
- **Artists** - Explore music by artist
- **Playlists** - Create and manage custom playlists
- **Playlist Song Management** - Add songs from the library and swipe-to-remove in playlist view
- **Favorites** - Bookmark your favorite songs
- **Hidden Songs** - Hide songs you do not want to appear in the app

### User Interface
- **Dark Theme** - Easy on the eyes with Material 3 design
- **Animated Play Button** - Smooth transitions and visual feedback
- **Mini Player** - Quick access mini player at the bottom
- **Full Screen Player** - Immersive full-screen player experience
- **Search & Sort** - Find songs quickly with flexible search and sorting
- **Smart Artist Sorting** - Better artist detection from titles like `Artist - Track Name`
- **Responsive Design** - Works on various screen sizes

### Advanced Features
- **Recently Played** - Track your recently played songs
- **Sleep Timer** - Auto-stop music after a set duration
- **Dynamic Theme Colors** - Colors adapt based on album artwork
- **Local Storage** - All data saved locally with SharedPreferences
- **Notification Support** - Ongoing notification for background playback
- **Media Notification Controls** - Spotify-style Android notification bar while playing

## 🏗️ Architecture

### Clean Architecture with Separation of Concerns
```
lib/
├── core/              # Constants, extensions, utilities
│   ├── constants/     # App colors, constants
│   ├── extensions/    # Dart extensions for convenience
│   └── utils/         # Utility functions
├── models/            # Data models (Song, Album, Artist, Playlist)
├── providers/         # State management (Provider pattern)
├── services/          # Business logic services
├── screens/           # UI screens/pages
├── widgets/           # Reusable widgets
│   ├── shared/        # Common widgets
│   └── player/        # Player-specific widgets
└── main.dart          # App entry point
```

### State Management
- **Provider Pattern** - Clean, scalable state management
- **Multiple Providers** - Separated concerns for audio, songs, playlists, favorites, theme, settings
- **Stream Listeners** - Real-time updates for playback state

### Services Architecture
- **AudioPlaybackService** - Handles audio playback with just_audio
- **AudioQueryService** - Manages device music file scanning with on_audio_query
- **StorageService** - Local data persistence with SharedPreferences
- **PermissionService** - Manages Android permissions

## 📦 Dependencies

### Audio Playback
- `just_audio` (0.9.34) - Powerful audio player
- `audio_service` (0.18.11) - Background playback support

### Audio Discovery
- `on_audio_query` (2.9.0) - Query device audio files

### State Management
- `provider` (6.0.10) - Reactive state management

### Permissions
- `permission_handler` (11.3.0) - Handle Android permissions gracefully

### UI & Theme
- `palette_generator` (0.3.3) - Extract colors from album artwork
- `cached_network_image` (3.3.0) - Efficient image caching

### Storage
- `shared_preferences` (2.2.2) - Local data persistence

### Utilities
- `intl` (0.19.0) - Date and number formatting
- `path_provider` (2.1.0) - Access system directories

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.11.5 or higher)
- Dart SDK (included with Flutter)
- Android SDK (for Android development)
- A device or emulator running Android 6.0 or higher

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd personal_music_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Android**
The app already has the necessary permissions configured in `android/app/src/main/AndroidManifest.xml`:
- `READ_EXTERNAL_STORAGE` - Access music files
- `MANAGE_MEDIA` - Manage media files
- `FOREGROUND_SERVICE` - Background playback
- `FOREGROUND_SERVICE_MEDIA_PLAYBACK` - Media playback foreground service

4. **Build and run**
```bash
flutter run
```

For release build:
```bash
flutter build apk --release
```

## 📱 Screen Guide

### Home Screen
Central hub with bottom navigation:
- **Songs** - All songs with search and sort options
- **Albums** - Albums grid view
- **Artists** - Artists with their music
- **Playlists** - User-created playlists

### Player Screen
Full-screen music player featuring:
- Large album artwork display
- Song title and artist
- Progress slider with time display
- Playback controls (play, pause, next, previous)
- Shuffle and repeat mode toggles
- Album information

### Mini Player
Persistent player at bottom of home screen showing:
- Current song info
- Play/pause button
- Next button
- Quick access to full player

### Settings
App configuration including:
- Notification preferences
- Volume control
- Equalizer settings
- Sleep timer
- Playback speed

## 🔧 Configuration

### Android Manifest
Permissions are configured in `android/app/src/main/AndroidManifest.xml`. The app requires:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.MANAGE_MEDIA" />
<uses-permission android:name="android.permission.MANAGE_AUDIO" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
```

### Theme Configuration
The app uses Material 3 dark theme by default. Colors are defined in:
- `lib/core/constants/app_colors.dart` - Color palette
- `lib/providers/theme_provider.dart` - Theme customization

## 📊 Data Storage

### Local Storage
The app uses SharedPreferences to store:
- **Favorites** - User's favorite songs
- **Playlists** - Custom playlists with song references
- **Recently Played** - Recently played songs history
- **Playback State** - Current playback position
- **Settings** - User preferences

All data is stored locally without any server requirements.

## 🎨 UI/UX Design

### Design Principles
- **Dark Theme** - Primary dark background for battery efficiency and eye comfort
- **Material 3** - Modern Material Design 3 components
- **Spotify-Inspired** - Clean, minimal interface similar to Spotify
- **Smooth Animations** - Fluid transitions between screens
- **Responsive** - Adapts to different screen sizes

### Color Palette
- Primary: Spotify Green (#1DB954)
- Background: Dark (#121212)
- Surface: Dark Gray (#282828)
- Text Primary: White (#FFFFFF)
- Text Secondary: Light Gray (#B3B3B3)

## 🔄 Data Flow

### Song Loading Flow
1. App initialization → Request permissions
2. AudioQueryService scans device storage
3. SongProvider loads and caches all songs
4. UI displays songs from SongProvider
5. User selects song → AudioProvider loads playlist
6. AudioPlaybackService plays the audio file

### Playback State Flow
1. User triggers play action
2. AudioProvider updates state
3. AudioPlaybackService manages playback
4. UI subscribes to playback state streams
5. Position and duration update in real-time
6. Recently played and playback position saved

## 🐛 Troubleshooting

### Permissions Not Granted
- Grant storage permissions in Android settings
- App will request permissions on first launch
- If denied, go to Settings → Apps → Personal Music Player → Permissions

### No Songs Found
- Ensure you have audio files on your device
- Check that the app has storage permission
- Try rescanning by restarting the app

### Playback Issues
- Check volume is not muted
- Ensure audio files are in supported formats (MP3, WAV, FLAC, etc.)
- Try restarting the app

### Performance Issues
- Close other apps to free up memory
- Clear app cache in Settings
- Restart the device

## 📝 License

This project is provided as-is for educational and personal use.

## 👨‍💻 Development

### Code Style
- Follows Dart/Flutter best practices
- Uses meaningful variable and function names
- Minimal comments for self-explanatory code
- Consistent formatting with proper indentation

### Adding New Features
1. Define models in `lib/models/`
2. Create services in `lib/services/`
3. Add providers in `lib/providers/`
4. Build UI in `lib/screens/`
5. Create reusable widgets in `lib/widgets/`

### Testing
Currently, the app uses manual testing. To add automated tests:
```bash
flutter test
```

## 🚀 Future Enhancements
- [ ] Advanced Albums view with full album browsing
- [ ] Artists detailed view with discography
- [ ] Full Playlists management UI
- [ ] Favorites/Liked songs screen
- [ ] Equalizer with preset options
- [ ] Sleep timer countdown display
- [ ] Now playing queue view
- [ ] Playback statistics and history
- [ ] Multiple sort and filter options
- [ ] Gesture controls (swipe for next/prev)
- [ ] Bluetooth playback support
- [ ] Headphone detection
- [ ] Lyrics display (if available)
- [ ] Share songs functionality

## 📞 Support

For issues, questions, or suggestions, please refer to the project documentation or contact the development team.

---

**Built with ❤️ using Flutter**

Made with Flutter and optimized for Android devices. Designed to provide a premium offline music playback experience.
#   P e r s o n a l - M u s i c - A p p 
 
 
