import 'package:flutter/material.dart';

/// [ProductButton] for creating a customizable button
class ProductButton extends StatelessWidget {
  /// Creates a [ProductButton] with customizable properties.
  const ProductButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.startColor = const Color(0xFF667eea),
    this.endColor = const Color(0xFF764ba2),
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.width,
    this.height = 50.0,
    this.borderRadius = 20.0,
    this.textStyle,
    this.elevation = 4.0,
    this.disabledStartColor,
    this.disabledEndColor,
  });

  /// Callback function to be called when the button is tapped
  final VoidCallback? onPressed;

  /// Text to be displayed on the button
  final String text;

  /// Start color for the gradient
  final Color startColor;

  /// End color for the gradient
  final Color endColor;

  /// Gradient direction (default: left to right)
  final AlignmentGeometry begin;

  /// Gradient direction (default: right to left)
  final AlignmentGeometry end;

  /// Button width (if null, takes parent's width)
  final double? width;

  /// Button height
  final double height;

  /// Border radius
  final double borderRadius;

  /// Text style (if null, uses theme default)
  final TextStyle? textStyle;

  /// Elevation value
  final double elevation;

  /// Colors to be used in disabled state
  final Color? disabledStartColor;

  /// Colors to be used in disabled state
  final Color? disabledEndColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null;

    // Colors to be used in disabled state
    final effectiveStartColor =
        isEnabled ? startColor : (disabledStartColor ?? Colors.grey.shade400);
    final effectiveEndColor =
        isEnabled ? endColor : (disabledEndColor ?? Colors.grey.shade300);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [effectiveStartColor, effectiveEndColor],
          begin: begin,
          end: end,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: startColor.withOpacity(0.3),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: textStyle ??
                  theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ) ??
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
