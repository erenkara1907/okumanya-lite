import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:kartal/kartal.dart';

/// ProductInput is a widget for inputting product details
class ProductInput extends StatelessWidget {
  /// Creates a new instance of [ProductInput]
  const ProductInput({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.prefixIcon,
    super.key,
  });

  /// Controller for the text input
  final TextEditingController controller;

  /// FocusNode for managing focus state of the input field
  final FocusNode focusNode;

  /// Hint text to display when the input field is empty
  final String hintText;

  /// Optional prefix icon to display inside the input field
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: context.general.textTheme.bodyLarge?.copyWith(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: context.general.textTheme.bodyLarge?.copyWith(
          color: Colors.black45,
        ),
        filled: true,
        fillColor: context.general.colorScheme.secondary,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: context.general.colorScheme.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: ColorName.blue,
            width: 2,
          ),
        ),
      ),
    );
  }
}
