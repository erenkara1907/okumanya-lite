import 'package:edumind_intro_app/product/utility/enum/permission_status.dart';

/// Permission result model
class PermissionResult {
  /// Creates a new instance of [PermissionResult].
  const PermissionResult({
    required this.status,
    required this.message,
  });

  /// Creates a new instance of [PermissionResult] with granted status.
  final PermissionStatusApp status;

  /// The message associated with the permission result.
  final String message;

  /// Factory constructor to create a [PermissionResult] with granted status.
  bool get isGranted => status == PermissionStatusApp.granted;

  /// Factory constructor to create a [PermissionResult] with denied status.
  bool get isDenied => status == PermissionStatusApp.denied;

  /// Factory constructor to create a [PermissionResult] with permanently denied status.
  bool get isPermanentlyDenied =>
      status == PermissionStatusApp.permanentlyDenied;
}
