import 'package:flutter/foundation.dart';
import 'package:gen/gen.dart';

/// Product environment manager class
final class ProductEnvironment {
  /// Set up product environment
  ProductEnvironment.setUp({required ProductConfiguration config}) {
    _config = config;
  }

  /// General product environment setup
  ProductEnvironment.general() {
    _config = kDebugMode ? DevEnv() : ProdEnv();
  }

  static late final ProductConfiguration _config;
}

/// Get product environment items
enum ProductEnvironmentItems {
  /// Network base url
  baseUrl;

  /// Get value from product environment
  String get value {
    try {
      switch (this) {
        case ProductEnvironmentItems.baseUrl:
          return ProductEnvironment._config.baseUrl;
      }
    } catch (e) {
      throw Exception('Product environment is not initialized');
    }
  }
}
