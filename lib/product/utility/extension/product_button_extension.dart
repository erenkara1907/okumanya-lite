import 'package:edumind_intro_app/product/widget/button/product_button.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';

/// Predefined gradient buttons with factory constructors
extension ProductButtonPresets on ProductButton {
  /// Blue-purple gradient button
  static ProductButton bluePurple({
    required VoidCallback? onPressed,
    required String text,
    Key? key,
    double? width,
    double height = 50.0,
    double borderRadius = 12.0,
    TextStyle? textStyle,
  }) {
    return ProductButton(
      key: key,
      onPressed: onPressed,
      text: text,
      width: width,
      height: height,
      borderRadius: borderRadius,
      textStyle: textStyle,
    );
  }

  /// Orange-red gradient button
  static ProductButton orangeRed({
    required VoidCallback? onPressed,
    required String text,
    Key? key,
    double? width,
    double height = 50.0,
    double borderRadius = 12.0,
    TextStyle? textStyle,
  }) {
    return ProductButton(
      key: key,
      onPressed: onPressed,
      text: text,
      startColor: const Color(0xFFf093fb),
      endColor: const Color(0xFFf5576c),
      width: width,
      height: height,
      borderRadius: borderRadius,
      textStyle: textStyle,
    );
  }

  /// Green-blue gradient button
  static ProductButton greenBlue({
    required VoidCallback? onPressed,
    required String text,
    Key? key,
    double? width,
    double height = 50.0,
    double borderRadius = 20.0,
    TextStyle? textStyle,
  }) {
    return ProductButton(
      key: key,
      onPressed: onPressed,
      text: text,
      startColor: ColorName.green,
      endColor: ColorName.blue,
      width: width,
      height: height,
      borderRadius: borderRadius,
      textStyle: textStyle,
    );
  }
}
