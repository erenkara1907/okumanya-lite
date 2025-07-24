import 'package:edumind_intro_app/product/permission/model/permission_result.dart';
import 'package:edumind_intro_app/product/utility/enum/permission_status.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Core permission manager for handling microphone permissions
class CorePermissionManager {
  CorePermissionManager._();
  static final CorePermissionManager _instance = CorePermissionManager._();

  /// Singleton instance of CorePermissionManager
  static CorePermissionManager get instance => _instance;

  /// Request microphone permission with detailed result
  Future<PermissionResult> requestMicrophonePermission() async {
    try {
      if (kDebugMode) {
        print('🎤 Requesting microphone permission...');
      }

      final status = await Permission.microphone.request();
      final result = _mapPermissionStatus(status);

      if (kDebugMode) {
        print('🎤 Microphone permission result: ${result.status}');
        print('📝 Message: ${result.message}');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error requesting microphone permission: $e');
      }
      return PermissionResult(
        status: PermissionStatusApp.error,
        message: 'Permission request failed: $e',
      );
    }
  }

  /// Check current microphone permission status
  Future<PermissionResult> checkMicrophonePermission() async {
    try {
      final status = await Permission.microphone.status;
      final result = _mapPermissionStatus(status);

      if (kDebugMode) {
        print('🔍 Current microphone permission: ${result.status}');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking microphone permission: $e');
      }
      return PermissionResult(
        status: PermissionStatusApp.error,
        message: 'Permission check failed: $e',
      );
    }
  }

  /// Map Permission status to custom result
  PermissionResult _mapPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return const PermissionResult(
          status: PermissionStatusApp.granted,
          message: 'Microphone permission granted',
        );
      case PermissionStatus.denied:
        return const PermissionResult(
          status: PermissionStatusApp.denied,
          message: 'Microphone permission denied',
        );
      case PermissionStatus.permanentlyDenied:
        return const PermissionResult(
          status: PermissionStatusApp.permanentlyDenied,
          message:
              'Microphone permission permanently denied. Open settings to grant.',
        );
      case PermissionStatus.restricted:
        return const PermissionResult(
          status: PermissionStatusApp.restricted,
          message: 'Microphone permission restricted by system',
        );
      // ignore: no_default_cases
      default:
        return const PermissionResult(
          status: PermissionStatusApp.unknown,
          message: 'Unknown permission status',
        );
    }
  }
}
