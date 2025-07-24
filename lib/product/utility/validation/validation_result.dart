/// Validation result class
class ValidationResult {
  const ValidationResult._({
    required this.isValid,
    this.errorMessage,
  });

  /// Creates a successful validation result
  factory ValidationResult.success() {
    return const ValidationResult._(isValid: true);
  }

  /// Creates a failed validation result with error message
  factory ValidationResult.error(String message) {
    return ValidationResult._(isValid: false, errorMessage: message);
  }

  /// Whether the validation was successful
  final bool isValid;

  /// Error message if validation failed
  final String? errorMessage;
}
