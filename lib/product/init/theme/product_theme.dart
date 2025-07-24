import 'package:flutter/material.dart';

/// Product theme for project design
abstract class ProductTheme {
  /// Floating action button theme data
  FloatingActionButtonThemeData get floatingActionButtonThemeData;

  /// Theme data
  ThemeData get themeData;

  /// Text theme
  TextTheme get textTheme;

  /// App bar theme
  AppBarTheme get appBarTheme;

  /// Elevated button theme data
  ElevatedButtonThemeData get elevatedButtonTheme;
}
