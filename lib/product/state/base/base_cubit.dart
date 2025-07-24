import 'package:flutter_bloc/flutter_bloc.dart';

/// BaseCubit class to manage the business logic of the Cubit
abstract class BaseCubit<T extends Object> extends Cubit<T> {
  /// BaseCubit constructor
  BaseCubit(super.initialState);

  /// Product error tracking
  // ErrorHandler get errorHandler => ProductItems.errorHandler;

  @override
  void emit(T state) {
    if (isClosed) return;
    super.emit(state);
  }
}
