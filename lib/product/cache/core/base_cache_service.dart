import 'package:edumind_intro_app/product/cache/core/core_cache_manager.dart';
import 'package:edumind_intro_app/product/cache/model/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Base class for cache services
abstract class BaseCacheService<T> {
  /// Constructor to initialize the cache service with a specific box name
  BaseCacheService(this.boxName);

  /// The name of the Hive box used for caching
  final String boxName;

  /// Get the appropriate box based on the type
  Box<T>? get _box {
    try {
      if (!CoreCacheManager.instance.isInitialized) {
        if (kDebugMode) {
          print('❌ CoreCacheManager not initialized');
        }
        return null;
      }

      // Type-specific box access
      if (T == UserData) {
        return CoreCacheManager.instance.getUserDataBox() as Box<T>?;
      } else if (T == String) {
        return CoreCacheManager.instance.getSettingsBox() as Box<T>?;
      } else {
        if (kDebugMode) {
          print('❌ Unsupported type for cache: $T');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting box $boxName: $e');
      }
      return null;
    }
  }

  /// Save single item with safety check
  Future<void> save(String key, T item) async {
    try {
      final box = _box;
      if (box == null) {
        if (kDebugMode) {
          print('❌ Cannot save to cache [$boxName]: Box not available');
        }
        return;
      }

      await box.put(key, item);
      if (kDebugMode) {
        print('💾 Saved to cache [$boxName]: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving to cache [$boxName]: $e');
      }
      rethrow;
    }
  }

  /// Get single item with safety check
  T? get(String key) {
    try {
      final box = _box;
      if (box == null) {
        if (kDebugMode) {
          print('❌ Cannot get from cache [$boxName]: Box not available');
        }
        return null;
      }

      final item = box.get(key);
      if (item != null) {
        if (kDebugMode) {
          print('📖 Retrieved from cache [$boxName]: $key');
        }
      } else {
        if (kDebugMode) {
          print('🔍 Item not found in cache [$boxName]: $key');
        }
      }
      return item;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting from cache [$boxName]: $e');
      }
      return null;
    }
  }

  /// Save multiple items with safety check
  Future<void> saveAll(Map<String, T> items) async {
    try {
      final box = _box;
      if (box == null) {
        if (kDebugMode) {
          print(
              '❌ Cannot save multiple to cache [$boxName]: Box not available');
        }
        return;
      }

      await box.putAll(items);
      if (kDebugMode) {
        print('💾 Saved ${items.length} items to cache [$boxName]');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving multiple items to cache [$boxName]: $e');
      }
      rethrow;
    }
  }

  /// Get all items with safety check
  Map<String, T> getAll() {
    try {
      final box = _box;
      if (box == null) {
        if (kDebugMode) {
          print('❌ Cannot get all from cache [$boxName]: Box not available');
        }
        return {};
      }

      final items = Map<String, T>.from(box.toMap());
      if (kDebugMode) {
        print('📖 Retrieved ${items.length} items from cache [$boxName]');
      }
      return items;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting all items from cache [$boxName]: $e');
      }
      return {};
    }
  }

  /// Delete single item with safety check
  Future<void> delete(String key) async {
    try {
      final box = _box;
      if (box == null) {
        if (kDebugMode) {
          print('❌ Cannot delete from cache [$boxName]: Box not available');
        }
        return;
      }

      await box.delete(key);
      if (kDebugMode) {
        print('🗑️ Deleted from cache [$boxName]: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting from cache [$boxName]: $e');
      }
    }
  }

  /// Check if item exists with safety check
  bool exists(String key) {
    try {
      final box = _box;
      if (box == null) {
        if (kDebugMode) {
          print(
              '❌ Cannot check existence in cache [$boxName]: Box not available');
        }
        return false;
      }

      final exists = box.containsKey(key);
      if (kDebugMode) {
        print('🔍 Item exists in cache [$boxName] [$key]: $exists');
      }
      return exists;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking existence in cache [$boxName]: $e');
      }
      return false;
    }
  }

  /// Clear all items in this box with safety check
  Future<void> clear() async {
    try {
      final box = _box;
      if (box == null) {
        if (kDebugMode) {
          print('❌ Cannot clear cache [$boxName]: Box not available');
        }
        return;
      }

      await box.clear();
      if (kDebugMode) {
        print('🗑️ Cleared all items from cache [$boxName]');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error clearing cache [$boxName]: $e');
      }
    }
  }

  /// Get box length with safety check
  int get length {
    try {
      final box = _box;
      return box?.length ?? 0;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting cache length [$boxName]: $e');
      }
      return 0;
    }
  }

  /// Get all keys with safety check
  Iterable<String> get keys {
    try {
      final box = _box;
      return box?.keys.cast<String>() ?? [];
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting cache keys [$boxName]: $e');
      }
      return [];
    }
  }

  /// Get all values with safety check
  Iterable<T> get values {
    try {
      final box = _box;
      return box?.values ?? [];
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting cache values [$boxName]: $e');
      }
      return [];
    }
  }
}
