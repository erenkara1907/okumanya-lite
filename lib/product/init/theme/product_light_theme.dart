import 'package:edumind_intro_app/product/init/theme/product_color_scheme.dart';
import 'package:edumind_intro_app/product/init/theme/product_theme.dart';
import 'package:edumind_intro_app/product/utility/constant/theme/product_theme_constant.dart';
import 'package:flutter/material.dart';

/// Product light theme for project design
final class ProductLightTheme implements ProductTheme {
  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: ProductColorScheme.lightColorScheme,
        appBarTheme: appBarTheme,
        elevatedButtonTheme: elevatedButtonTheme,
        floatingActionButtonTheme: floatingActionButtonThemeData,
        textTheme: textTheme,
        cardColor: Colors.white,
      );

  @override
  FloatingActionButtonThemeData get floatingActionButtonThemeData =>
      FloatingActionButtonThemeData(
        backgroundColor: ProductColorScheme.lightColorScheme.primary,
        foregroundColor: ProductColorScheme.lightColorScheme.onPrimary,
      );

  @override
  TextTheme get textTheme => ProductThemeConstant.productTextTheme;

  @override
  AppBarTheme get appBarTheme => AppBarTheme(
        backgroundColor: ProductColorScheme
            .lightColorScheme.primary, // AppBar background color
        foregroundColor: ProductColorScheme
            .lightColorScheme.onPrimary, // AppBar text/icon color
        iconTheme: IconThemeData(
            color: ProductColorScheme
                .lightColorScheme.onSurface), // AppBar icon color
      );

  @override
  ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: ProductColorScheme.lightColorScheme.onSecondary,
          backgroundColor: ProductColorScheme
              .lightColorScheme.secondary, // ElevatedButton text/icon color
        ),
      );
}
