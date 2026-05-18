import 'dart:io';
import 'package:path/path.dart' as path;

void main() async {
  final libPath = Directory('lib');
  
  final directories = [
    'core/constants',
    'core/extensions',
    'core/utils',
    'models',
    'providers',
    'services',
    'screens',
    'widgets/shared',
    'widgets/player',
  ];

  for (final dir in directories) {
    final fullPath = path.join(libPath.path, dir);
    final directory = Directory(fullPath);
    
    if (!await directory.exists()) {
      await directory.create(recursive: true);
      print('✓ Created: lib/$dir');
    } else {
      print('✓ Already exists: lib/$dir');
    }
  }
  
  print('\nAll directories created successfully!');
}
