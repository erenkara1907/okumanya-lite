import 'package:flutter/material.dart';

/// SnackBar configuration class
class SnackBarConfig {
  /// Creates a SnackBarConfig instance with the specified parameters.
  const SnackBarConfig({
    required this.backgroundColor,
    required this.icon,
    required this.duration,
  });

  /// [backgroundColor] is the background color of the snackbar.
  final Color backgroundColor;

  /// [icon] is the icon displayed in the snackbar.
  final IconData icon;

  /// [duration] is the duration for which the snackbar will be displayed.
  final Duration duration;
}
