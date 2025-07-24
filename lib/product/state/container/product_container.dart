import 'package:edumind_intro_app/feature/book/manager/audio_upload_queue_manager.dart';
import 'package:edumind_intro_app/feature/book/view_model/book_view_model.dart';
import 'package:edumind_intro_app/product/cache/service/user_data_cache_service.dart';
import 'package:edumind_intro_app/product/network/core/core_http_client.dart';
import 'package:edumind_intro_app/product/state/view_model/product/product_view_model.dart';
import 'package:get_it/get_it.dart';

/// Product container for dependency injection
final class ProductContainer {
  ProductContainer._();
  static final _getIt = GetIt.I;

  /// Product core required dependencies
  static void setup() {
    _getIt
      ..registerLazySingleton<ProductViewModel>(ProductViewModel.new)
      ..registerLazySingleton<CoreHttpClient>(() => CoreHttpClient.instance)
      ..registerLazySingleton<UserDataCacheService>(
          () => UserDataCacheService.instance)
      ..registerLazySingleton<AudioUploadQueueManager>(
          () => AudioUploadQueueManager.instance)
      ..registerLazySingleton<BookViewModel>(BookViewModel.new);
  }

  /// Read the dependency from the container
  static T read<T extends Object>() => _getIt<T>();
}
