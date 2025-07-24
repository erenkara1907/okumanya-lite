import 'package:flutter/material.dart';
import 'package:gen/gen.dart';

/// Product color scheme
final class ProductColorScheme {
  ProductColorScheme._();

  /// Light color scheme set
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: ColorName.primary, // Main color used for primary elements
    onPrimary: Colors.white, // Color for text/icons on primary color
    secondary: ColorName.secondary, // Secondary color for accenting the theme
    onSecondary: Colors.white, // Color for text/icons on secondary color
    error: Colors.red, // Color for error elements
    onError: Colors.white, // Color for text/icons on error background
    surface: ColorName.primary, // Surface color for cards, sheets, etc.
    onSurface: ColorName.secondary, // Color for text/icons on surfaces
    surfaceTint: ColorName.primary, // Tint color for surfaces
  );

  /// Dark color scheme set
  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: ColorName.primary, // Primary color for dark mode
    onPrimary: Colors.white, // Text/icons on primary color in dark mode
    secondary: ColorName
        .secondary, // Secondary color for accenting the theme in dark mode
    onSecondary: Colors.white, // Text/icons on secondary color in dark mode
    error: Colors.red, // Error color for dark mode
    onError: Colors.white, // Text/icons on error background in dark mode
    surface:
        ColorName.primary, // Surface color for cards, sheets, etc. in dark mode
    onSurface: ColorName.secondary, // Color for text/icons on surfaces
    surfaceTint: ColorName.primary, // Tint color for surfaces
  );
}
