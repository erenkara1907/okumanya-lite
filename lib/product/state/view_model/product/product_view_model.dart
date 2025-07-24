import 'package:edumind_intro_app/product/state/base/base_cubit.dart';
import 'package:edumind_intro_app/product/state/view_model/product/product_state.dart';

/// [ProductViewModel] class to manage the business logic of the [ProductState]
final class ProductViewModel extends BaseCubit<ProductState> {
  /// [ProductViewModel] constructor
  ProductViewModel() : super(const ProductState()) {
    init();
  }

  /// Initialize the view model by loading the theme mode from cache
  Future<void> init() async {
    // final themeModeCacheModel = ProductItems.productCache.themeModeCacheOperation.get('theme_mode');

    // emit(state.copyWith(themeMode: themeModeCacheModel?.themeModeModel.themeMode ?? ThemeMode.light));
  }

  /// Change the theme mode.
  /// [themeMode] is the new theme mode.
  // void changeThemeMode(ThemeMode themeMode) {
  //   ProductItems.productCache.themeModeCacheOperation.add(
  //     ThemeModeCacheModel(
  //       themeModeModel: ThemeModeModel(themeMode: themeMode),
  //     ),
  //   );

  //   emit(state.copyWith(themeMode: themeMode));
  // }
}
