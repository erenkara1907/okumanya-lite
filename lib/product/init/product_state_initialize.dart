import 'package:edumind_intro_app/feature/book/view_model/book_view_model.dart';
import 'package:edumind_intro_app/product/state/container/product_items.dart';
import 'package:edumind_intro_app/product/state/view_model/product/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ProductStateInitialize] class to initialize the state of the product
final class ProductStateInitialize extends StatelessWidget {
  /// [ProductStateInitialize] constructor
  const ProductStateInitialize({required this.child, super.key});

  /// [child] property to hold the child widget
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductViewModel>.value(
          value: ProductItems.productViewModel,
        ),
        BlocProvider<BookViewModel>.value(
          value: ProductItems.bookViewModel,
        ),
      ],
      child: child,
    );
  }
}
