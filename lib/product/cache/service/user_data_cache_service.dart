import 'package:edumind_intro_app/product/cache/core/base_cache_service.dart';

import 'package:edumind_intro_app/product/cache/core/core_cache_manager.dart';
import 'package:edumind_intro_app/product/cache/model/user_data.dart';
import 'package:flutter/foundation.dart';

/// Cache service for UserData
class UserDataCacheService extends BaseCacheService<UserData> {
  /// Constructor for UserDataCacheService
  UserDataCacheService() : super(CoreCacheManager.userDataBoxName);

  static final UserDataCacheService _instance = UserDataCacheService();

  /// Singleton instance of UserDataCacheService
  static UserDataCacheService get instance => _instance;

  /// Cache keys
  static const String currentUserKey = 'current_user';

  /// Key for storing last login timestamp
  static const String lastLoginKey = 'last_login';

  /// Save current user data
  Future<void> saveCurrentUser(UserData userData) async {
    try {
      await save(currentUserKey, userData);
      await _saveMetadata(userData);

      if (kDebugMode) {
        print('👤 Current user saved to cache:');
        print('   • ID: ${userData.id}');
        print('   • Nickname: ${userData.nickName}');
        print('   • School: ${userData.schoolName}');
        print('   • City: ${userData.city.name}');
        print('   • Grade: ${userData.grade.id}');
        print('─' * 50);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving current user: $e');
      }
      rethrow;
    }
  }

  /// Get current user data
  UserData? getCurrentUser() {
    try {
      final userData = get(currentUserKey);
      if (userData != null) {
        if (kDebugMode) {
          print('👤 Current user retrieved from cache:');
          print('   • ID: ${userData.id}');
          print('   • Nickname: ${userData.nickName}');
          print('   • School: ${userData.schoolName}');
          print('─' * 50);
        }
      }
      return userData;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting current user: $e');
      }
      return null;
    }
  }

  /// Save user login timestamp and metadata
  Future<void> _saveMetadata(UserData userData) async {
    try {
      if (CoreCacheManager.instance.isSettingsBoxAvailable()) {
        final settingsBox = CoreCacheManager.instance.getSettingsBox();
        await settingsBox.put(lastLoginKey, DateTime.now().toIso8601String());
        // await settingsBox.put('user_id', userData.id);
        // await settingsBox.put('nickname', userData.nickName);
        await settingsBox.put('user_id', userData.id);
        await settingsBox.put('nickname', userData.nickName);
        await settingsBox.put('school_name', userData.schoolName);
        await settingsBox.put('city', userData.city.name);
        await settingsBox.put('grade', userData.grade.name);

        if (kDebugMode) {
          print('📝 User metadata saved to settings');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving metadata: $e');
      }
      // Don't rethrow - metadata is not critical
    }
  }

  /// Get user login history
  List<UserData> getUserHistory() {
    try {
      final allUsers = getAll();
      final currentUser = getCurrentUser();
      final history =
          allUsers.values.where((user) => user.id != currentUser?.id).toList();

      if (kDebugMode) {
        print('📚 User history: ${history.length} previous users');
        for (final user in history) {
          print('   • ${user.nickName} (${user.createdAt})');
        }
      }

      return history;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting user history: $e');
      }
      return [];
    }
  }

  /// Logout current user (but keep in history)
  Future<void> logout() async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        // Keep user in history with timestamp key
        await save('history_${currentUser.id}', currentUser);

        // Remove from current user
        await delete(currentUserKey);

        if (kDebugMode) {
          print('👋 User logged out: ${currentUser.nickName}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error logging out: $e');
      }
    }
  }

  /// Switch to different user
  Future<void> switchUser(String userId) async {
    try {
      final allUsers = getAll();
      final targetUser = allUsers.values.firstWhere(
        (user) => user.id == userId,
        orElse: () => throw Exception('User not found: $userId'),
      );

      await saveCurrentUser(targetUser);

      if (kDebugMode) {
        print('🔄 Switched to user: ${targetUser.nickName}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error switching user: $e');
      }
      rethrow;
    }
  }

  /// Get last login timestamp
  String? getLastLoginTime() {
    try {
      if (CoreCacheManager.instance.isSettingsBoxAvailable()) {
        final settingsBox = CoreCacheManager.instance.getSettingsBox();
        return settingsBox.get(lastLoginKey);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting last login time: $e');
      }
      return null;
    }
  }
}
