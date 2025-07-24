import 'package:flutter/material.dart';

/// An extension on [BuildContext] to provide responsive utilities.
extension ResponsiveContext on BuildContext {
  /// Gets the responsive app bar height based on the screen size.
  double get responsiveHorizontalPadding {
    final screenWidth = MediaQuery.of(this).size.width;
    if (screenWidth >= 1200) return 32;
    if (screenWidth >= 768) return 24;
    return 16;
  }

  /// [isTablet] returns true if the screen width is 768 pixels or more.
  bool get isTablet => MediaQuery.of(this).size.width >= 768;

  /// [isMobile] returns true if the screen width is less than 768 pixels.
  bool get isMobile => MediaQuery.of(this).size.width < 768;
}
