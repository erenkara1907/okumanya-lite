import 'package:edumind_intro_app/feature/book/manager/audio_upload_queue_manager.dart';
import 'package:edumind_intro_app/feature/book/view_model/book_view_model.dart';
import 'package:edumind_intro_app/product/cache/service/user_data_cache_service.dart';
import 'package:edumind_intro_app/product/network/core/core_http_client.dart';
import 'package:edumind_intro_app/product/state/container/product_container.dart';
import 'package:edumind_intro_app/product/state/view_model/product/product_view_model.dart';

/// Product items for dependency injection
final class ProductItems {
  ProductItems._();

  /// Product view model
  static ProductViewModel get productViewModel =>
      ProductContainer.read<ProductViewModel>();

  /// Book view model
  static BookViewModel get bookViewModel =>
      ProductContainer.read<BookViewModel>();

  /// Core HTTP client
  static CoreHttpClient get coreHttpClient =>
      ProductContainer.read<CoreHttpClient>();

  /// User Data Cache Service
  static UserDataCacheService get userDataCacheService =>
      ProductContainer.read<UserDataCacheService>();

  /// Audio Upload Queue Manager
  static AudioUploadQueueManager get audioUploadQueueManager =>
      ProductContainer.read<AudioUploadQueueManager>();
}
