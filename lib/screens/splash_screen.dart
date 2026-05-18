import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/permission_service.dart';
import '../providers/song_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Request permissions
    final permissionService = PermissionService();
    final permissionGranted = await permissionService.requestAllAudioPermissions();

    if (!mounted) return;

    // Initialize songs
    await context.read<SongProvider>().loadSongs();

    if (!mounted) return;

    // Navigate to home
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1DB954),
                        Color(0xFF1aa34a),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1DB954).withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.music_note,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Personal Music Player',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Offline Music Player',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFB3B3B3),
                  ),
                ),
                const SizedBox(height: 40),
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF1DB954),
                    ),
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
