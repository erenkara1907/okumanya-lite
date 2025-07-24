import 'package:edumind_intro_app/product/cache/core/core_cache_manager.dart';
import 'package:edumind_intro_app/product/init/config/product_environment.dart';
import 'package:edumind_intro_app/product/state/container/product_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable

/// This class is used to initialize the application process
final class ProductInitialize {
  /// Project basic required initialize
  Future<void> setUp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _productEnvironmentWithContainer();

    await CoreCacheManager.instance.initialize();
  }

  /// DO NOT CHANGE THIS METHOD
  void _productEnvironmentWithContainer() {
    ProductEnvironment.general();

    /// It must be call after [ProductEnvironment.general()]
    ProductContainer.setup();
  }
}
