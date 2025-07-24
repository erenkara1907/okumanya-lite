import 'package:edumind_intro_app/product/init/product_initialize.dart';
import 'package:edumind_intro_app/product/init/product_state_initialize.dart';
import 'package:edumind_intro_app/product/init/theme/product_light_theme.dart';
import 'package:edumind_intro_app/product/navigation/app_router.dart';
import 'package:edumind_intro_app/product/state/container/product_items.dart';
import 'package:edumind_intro_app/product/state/view_model/product/product_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  await ProductInitialize().setUp();

  runApp(const ProductStateInitialize(child: _MyApp()));
}

/// This is the main class for the app
class _MyApp extends StatefulWidget {
  const _MyApp();

  static final _appRouter = AppRouter();

  @override
  State<_MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print('📱 App lifecycle changed: $state');
    }

    switch (state) {
      case AppLifecycleState.paused:
        ProductItems.audioUploadQueueManager.pauseQueue();
        if (kDebugMode) {
          print('⏸️ Queue paused (app background)');
        }

      case AppLifecycleState.resumed:
        ProductItems.audioUploadQueueManager.resumeQueue();
        if (kDebugMode) {
          print('▶️ Queue resumed (app foregrounded)');
        }

      case AppLifecycleState.detached:
        // App completely closed
        ProductItems.audioUploadQueueManager.clearQueue();
        if (kDebugMode) {
          print('🧹 Queue cleared (app detached)');
        }

      case AppLifecycleState.inactive:
        // App temporarily inactive (exm: phone call)
        if (kDebugMode) {
          print('😴 App inactive');
        }

      case AppLifecycleState.hidden:
        // iOS specific - app hidden
        if (kDebugMode) {
          print('🙈 App hidden');
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _MyApp._appRouter.config(),
      theme: ProductLightTheme().themeData,
      themeMode: context.watch<ProductViewModel>().state.themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
