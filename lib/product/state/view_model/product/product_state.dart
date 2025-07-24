import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// [ProductState] class to hold the state of the product
final class ProductState extends Equatable {
  /// [ProductState] constructor
  const ProductState({
    this.themeMode = ThemeMode.light,
  });

  /// [themeMode] property to hold the theme mode
  final ThemeMode themeMode;

  @override
  List<Object?> get props => [
        themeMode,
      ];

  /// [copyWith] method to copy the object
  ProductState copyWith({
    ThemeMode? themeMode,
  }) {
    return ProductState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
