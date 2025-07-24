import 'package:edumind_intro_app/product/utility/enum/snackbar_type.dart';
import 'package:edumind_intro_app/product/utility/snackbar/snackbar_config.dart';
import 'package:flutter/material.dart';

/// Core SnackBar utility class
class CoreSnackBar {
  /// Private constructor to prevent instantiation
  CoreSnackBar._();

  /// Shows error snackbar
  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
      action: action,
    );
  }

  /// Shows success snackbar
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
      action: action,
    );
  }

  /// Shows warning snackbar
  static void showWarning(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
      action: action,
    );
  }

  /// Shows info snackbar
  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      type: SnackBarType.info,
      duration: duration,
      action: action,
    );
  }

  /// Shows custom snackbar
  static void showCustom(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration? duration,
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      type: SnackBarType.custom,
      backgroundColor: backgroundColor,
      icon: icon,
      duration: duration,
      action: action,
    );
  }

  /// Private method to show snackbar
  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    Color? backgroundColor,
    IconData? icon,
    Duration? duration,
    SnackBarAction? action,
  }) {
    // Hide current snackbar if any
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBarConfig = _getSnackBarConfig(type);

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon ?? snackBarConfig.icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? snackBarConfig.backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: duration ?? snackBarConfig.duration,
      action: action ?? _getDefaultAction(context, type),
      elevation: 6,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Gets default action for snackbar types
  static SnackBarAction? _getDefaultAction(
      BuildContext context, SnackBarType type) {
    if (type == SnackBarType.error || type == SnackBarType.warning) {
      return SnackBarAction(
        label: 'Tamam',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      );
    }
    return null;
  }

  /// Gets configuration for different snackbar types
  static SnackBarConfig _getSnackBarConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return SnackBarConfig(
          backgroundColor: Colors.red.shade600,
          icon: Icons.error_outline,
          duration: const Duration(seconds: 4),
        );
      case SnackBarType.success:
        return SnackBarConfig(
          backgroundColor: Colors.green.shade600,
          icon: Icons.check_circle_outline,
          duration: const Duration(seconds: 3),
        );
      case SnackBarType.warning:
        return SnackBarConfig(
          backgroundColor: Colors.orange.shade600,
          icon: Icons.warning_outlined,
          duration: const Duration(seconds: 4),
        );
      case SnackBarType.info:
        return SnackBarConfig(
          backgroundColor: Colors.blue.shade600,
          icon: Icons.info_outline,
          duration: const Duration(seconds: 3),
        );
      case SnackBarType.custom:
        return SnackBarConfig(
          backgroundColor: Colors.grey.shade600,
          icon: Icons.notifications_outlined,
          duration: const Duration(seconds: 3),
        );
    }
  }
}
