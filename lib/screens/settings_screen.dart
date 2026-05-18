import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      body: Consumer2<ThemeProvider, SettingsProvider>(
        builder: (context, themeProvider, settingsProvider, _) {
          return ListView(
            children: [
              // Theme Settings
              _SettingsSection(
                title: 'Appearance',
                children: [
                  _SettingsTile(
                    icon: Icons.palette,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (_) => themeProvider.toggleDarkMode(),
                      activeThumbColor: const Color(0xFF1DB954),
                    ),
                  ),
                ],
              ),
              // Playback Settings
              _SettingsSection(
                title: 'Playback',
                children: [
                  _SettingsTile(
                    icon: Icons.notifications,
                    title: 'Show Notifications',
                    trailing: Switch(
                      value: settingsProvider.showNotifications,
                      onChanged: (value) {
                        settingsProvider.setShowNotifications(value);
                      },
                      activeThumbColor: const Color(0xFF1DB954),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.volume_up,
                    title: 'Use System Volume',
                    trailing: Switch(
                      value: settingsProvider.useSystemVolume,
                      onChanged: (value) {
                        settingsProvider.setUseSystemVolume(value);
                      },
                      activeThumbColor: const Color(0xFF1DB954),
                    ),
                  ),
                ],
              ),
              // About Section
              _SettingsSection(
                title: 'About',
                children: [
                  _SettingsTile(
                    icon: Icons.info,
                    title: 'Version',
                    subtitle: AppConstants.appVersion,
                  ),
                  _SettingsTile(
                    icon: Icons.copyright,
                    title: 'App Name',
                    subtitle: AppConstants.appName,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1DB954),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(children: children),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1DB954), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
