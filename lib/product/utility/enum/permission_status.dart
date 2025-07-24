/// Permission status enum
enum PermissionStatusApp {
  /// [granted] - Permission is granted
  granted,

  /// [denied] - Permission is denied
  denied,

  /// [permanentlyDenied] - Permission is permanently denied
  permanentlyDenied,

  /// [restricted] - Permission is restricted
  restricted,

  /// [unknown] - Permission status is unknown
  unknown,

  /// [error] - An error occurred while checking permission status
  error,
}
