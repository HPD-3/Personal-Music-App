import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // Screen dimensions
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  
  // Responsive checks
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  // Device padding
  EdgeInsets get devicePadding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // Navigation
  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  void popUntil(String routeName) {
    Navigator.of(this).popUntil(ModalRoute.withName(routeName));
  }

  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
}
