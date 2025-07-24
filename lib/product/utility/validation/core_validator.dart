import 'package:edumind_intro_app/product/utility/validation/validation_result.dart';

/// Core validation class for form validation
class CoreValidator {
  /// Private constructor to prevent instantiation
  CoreValidator._();

  /// Validates if a text field is not empty
  static ValidationResult validateRequired(
    String? value, {
    String? fieldName,
    String? customMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.error(
        customMessage ?? '${fieldName ?? 'Bu alan'} boş bırakılamaz',
      );
    }
    return ValidationResult.success();
  }

  /// Validates dropdown selection
  static ValidationResult validateDropdown<T>(
    T? value, {
    String? fieldName,
  }) {
    if (value == null) {
      return ValidationResult.error(
          '${fieldName ?? 'Bir seçenek'} seçilmelidir');
    }
    return ValidationResult.success();
  }

  /// Validates multiple fields at once
  static ValidationResult validateMultiple(List<ValidationResult> results) {
    for (final result in results) {
      if (!result.isValid) {
        return result;
      }
    }
    return ValidationResult.success();
  }
}
