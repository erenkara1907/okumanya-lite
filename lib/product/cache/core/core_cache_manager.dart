import 'package:edumind_intro_app/product/cache/model/user_data.dart';
import 'package:edumind_intro_app/product/widget/dropdown/model/school_grade.dart';
import 'package:edumind_intro_app/product/widget/dropdown/model/turkish_city.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Core cache manager using Hive for local storage
class CoreCacheManager {
  CoreCacheManager._();
  static final CoreCacheManager _instance = CoreCacheManager._();

  /// Singleton instance of CoreCacheManager
  static CoreCacheManager get instance => _instance;

  /// Cache box names
  static const String userDataBoxName = 'user_data_box';

  /// Settings box name for metadata
  static const String settingsBoxName = 'settings_box';

  /// Initialization status
  bool _isInitialized = false;

  /// Check if CoreCacheManager is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize Hive and open boxes
  Future<void> initialize() async {
    if (_isInitialized) {
      if (kDebugMode) {
        print('✅ CoreCacheManager already initialized');
      }
      return;
    }

    try {
      await Hive.initFlutter();
      if (kDebugMode) {
        print('📱 Hive Flutter initialized');
      }

      // Register adapters
      _registerAdapters();

      // Open boxes
      await _openBoxes();

      _isInitialized = true;
      if (kDebugMode) {
        print('✅ CoreCacheManager initialized successfully');
      }
    } catch (e) {
      _isInitialized = false;
      if (kDebugMode) {
        print('❌ Error initializing CoreCacheManager: $e');
      }
      rethrow;
    }
  }

  /// Register Hive type adapters
  void _registerAdapters() {
    try {
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter<UserData>(UserDataAdapter());
        if (kDebugMode) {
          print('🔧 UserDataAdapter registered');
        }
      }

      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter<SchoolGrade>(SchoolGradeAdapter());
        if (kDebugMode) {
          print('🔧 SchoolGradeAdapter registered');
        }
      }

      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter<TurkishCity>(TurkishCityAdapter());
        if (kDebugMode) {
          print('🔧 TurkishCityAdapter registered');
        }
      }

      if (kDebugMode) {
        print('🔧 All Hive adapters registered successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error registering adapters: $e');
      }
      rethrow;
    }
  }

  /// Open all required boxes
  Future<void> _openBoxes() async {
    try {
      if (kDebugMode) {
        print('📦 Opening Hive boxes...');
      }

      // Open UserData box
      if (!Hive.isBoxOpen(userDataBoxName)) {
        await Hive.openBox<UserData>(userDataBoxName);
        if (kDebugMode) {
          print('📦 Opened: $userDataBoxName');
        }
      }

      // Open settings box for metadata
      if (!Hive.isBoxOpen(settingsBoxName)) {
        await Hive.openBox<String>(settingsBoxName);
        if (kDebugMode) {
          print('📦 Opened: $settingsBoxName');
        }
      }

      if (kDebugMode) {
        print('📦 All Hive boxes opened successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error opening boxes: $e');
      }
      rethrow;
    }
  }

  /// Get UserData box
  Box<UserData> getUserDataBox() {
    if (!_isInitialized) {
      throw Exception(
          'CoreCacheManager not initialized. Call initialize() first.');
    }

    if (!Hive.isBoxOpen(userDataBoxName)) {
      throw Exception(
          'UserData box is not open. Initialization may have failed.');
    }

    return Hive.box<UserData>(userDataBoxName);
  }

  /// Get Settings box
  Box<String> getSettingsBox() {
    if (!_isInitialized) {
      throw Exception(
          'CoreCacheManager not initialized. Call initialize() first.');
    }

    if (!Hive.isBoxOpen(settingsBoxName)) {
      throw Exception(
          'Settings box is not open. Initialization may have failed.');
    }

    return Hive.box<String>(settingsBoxName);
  }

  /// Check if UserData box is available
  bool isUserDataBoxAvailable() {
    return _isInitialized && Hive.isBoxOpen(userDataBoxName);
  }

  /// Check if Settings box is available
  bool isSettingsBoxAvailable() {
    return _isInitialized && Hive.isBoxOpen(settingsBoxName);
  }

  /// Close all boxes
  Future<void> closeAllBoxes() async {
    try {
      await Hive.close();
      _isInitialized = false;
      if (kDebugMode) {
        print('📦 All Hive boxes closed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error closing boxes: $e');
      }
    }
  }

  /// Clear all cache data
  Future<void> clearAllCache() async {
    try {
      if (isUserDataBoxAvailable()) {
        final userDataBox = getUserDataBox();
        await userDataBox.clear();
      }

      if (isSettingsBoxAvailable()) {
        final settingsBox = getSettingsBox();
        await settingsBox.clear();
      }

      if (kDebugMode) {
        print('🗑️ All cache data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error clearing cache: $e');
      }
    }
  }

  /// Get cache info
  Map<String, dynamic> getCacheInfo() {
    try {
      final userDataBox = isUserDataBoxAvailable() ? getUserDataBox() : null;
      final settingsBox = isSettingsBoxAvailable() ? getSettingsBox() : null;

      return {
        'userDataCount': userDataBox?.length ?? 0,
        'settingsCount': settingsBox?.length ?? 0,
        'totalItems': (userDataBox?.length ?? 0) + (settingsBox?.length ?? 0),
        'isInitialized': _isInitialized,
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting cache info: $e');
      }
      return {
        'userDataCount': 0,
        'settingsCount': 0,
        'totalItems': 0,
        'isInitialized': false,
        'error': e.toString(),
      };
    }
  }
}
