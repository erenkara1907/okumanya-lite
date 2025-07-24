import 'package:edumind_intro_app/product/state/container/product_items.dart';
import 'package:edumind_intro_app/product/state/view_model/product/product_view_model.dart';
import 'package:flutter/material.dart';

/// Base state for all states
abstract class BaseState<T extends StatefulWidget> extends State<T> {
  /// Product view model
  ProductViewModel get productViewModel => ProductItems.productViewModel;
}
