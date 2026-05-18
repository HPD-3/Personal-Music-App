import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/audio_provider.dart';
import 'providers/song_provider.dart';
import 'providers/playlist_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/settings_provider.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SongProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProxyProvider<SongProvider, PlaylistProvider>(
          create: (context) => PlaylistProvider(context.read<SongProvider>()),
          update: (_, songProvider, playlistProvider) =>
              playlistProvider ?? PlaylistProvider(songProvider),
        ),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Personal Music Player',
            theme: themeProvider.getTheme(),
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
