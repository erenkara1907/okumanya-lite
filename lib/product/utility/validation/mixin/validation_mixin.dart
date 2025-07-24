import 'package:edumind_intro_app/product/utility/snackbar/core_snackbar.dart';
import 'package:edumind_intro_app/product/utility/validation/core_validator.dart';
import 'package:flutter/material.dart';

/// Mixin for adding validation functionality to widgets
mixin ValidationMixin<T extends StatefulWidget> on State<T> {
  /// Validates a required text field and shows error if invalid
  bool validateRequired(
    TextEditingController controller,
    FocusNode focusNode, {
    String? fieldName,
    String? customMessage,
  }) {
    final result = CoreValidator.validateRequired(
      controller.text,
      fieldName: fieldName,
      customMessage: customMessage,
    );

    if (!result.isValid) {
      CoreSnackBar.showError(context, result.errorMessage!);
      focusNode.requestFocus();
      return false;
    }
    return true;
  }

  /// Validates dropdown selection and shows error if invalid
  bool validateDropdown<U>(
    U? value, {
    String? fieldName,
  }) {
    final result = CoreValidator.validateDropdown(
      value,
      fieldName: fieldName,
    );

    if (!result.isValid) {
      CoreSnackBar.showError(context, result.errorMessage!);
      return false;
    }
    return true;
  }

  /// Validates multiple fields and shows first error encountered
  bool validateMultipleFields(List<bool Function()> validators) {
    for (final validator in validators) {
      if (!validator()) {
        return false;
      }
    }
    return true;
  }

  /// Shows success message
  void showSuccess(String message) {
    CoreSnackBar.showSuccess(context, message,
        duration: const Duration(seconds: 1));
  }

  /// Shows error message
  void showError(String message) {
    CoreSnackBar.showError(context, message);
  }

  /// Shows warning message
  void showWarning(String message) {
    CoreSnackBar.showWarning(context, message);
  }

  /// Shows info message
  void showInfo(String message) {
    CoreSnackBar.showInfo(context, message);
  }
}
