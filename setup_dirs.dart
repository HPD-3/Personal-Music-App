import 'dart:io';

void main() {
  final directories = [
    'lib/core/constants',
    'lib/core/extensions',
    'lib/core/utils',
    'lib/models',
    'lib/providers',
    'lib/services',
    'lib/screens',
    'lib/widgets/shared',
    'lib/widgets/player',
  ];

  print('Creating Flutter music player app directory structure...\n');

  for (final dirPath in directories) {
    final dir = Directory(dirPath);
    dir.createSync(recursive: true);
    print('✓ Created: $dirPath');
  }

  print('\n✅ All directories created successfully!');
}
