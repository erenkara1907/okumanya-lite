import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:edumind_intro_app/product/widget/dropdown/model/suggestion_item.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';

/// Generic search dropdown widget using drop_down_search_field package
///
/// This widget provides a reusable dropdown component with search functionality
class ProductSearchDropdown<T> extends StatelessWidget {
  /// Creates a [ProductSearchDropdown] with customizable properties
  const ProductSearchDropdown({
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
    this.hintText,
    this.labelText,
    this.borderRadius = 20.0,
    this.validator,
    this.enabled = true,
    this.fillColor,
    this.borderColor,
    this.textStyle,
    this.hintStyle,
    this.contentPadding,
    this.maxSuggestionsInViewPort = 5,
    this.suggestionsBoxMaxHeight = 300.0,
    this.displayAllSuggestionWhenTap = true,
    this.prefixIcon,
  });

  /// List of suggestion items to display in dropdown
  final List<SuggestionItem<T>> items;

  /// Callback when selection changes
  final ValueChanged<SuggestionItem<T>?> onChanged;

  /// Currently selected value
  final SuggestionItem<T>? value;

  /// Hint text when no item is selected
  final String? hintText;

  /// Label text for the dropdown
  final String? labelText;

  /// Border radius for the dropdown
  final double borderRadius;

  /// Validator function for form validation
  final String? Function(SuggestionItem<T>?)? validator;

  /// Whether the dropdown is enabled
  final bool enabled;

  /// Fill color for the dropdown
  final Color? fillColor;

  /// Border color for the dropdown
  final Color? borderColor;

  /// Text style for selected value
  final TextStyle? textStyle;

  /// Hint text style
  final TextStyle? hintStyle;

  /// Content padding inside dropdown
  final EdgeInsetsGeometry? contentPadding;

  /// Maximum suggestions visible in viewport
  final int maxSuggestionsInViewPort;

  /// Maximum height for suggestions box
  final double suggestionsBoxMaxHeight;

  /// Whether to display all suggestions when tapped
  final bool displayAllSuggestionWhenTap;

  /// Optional prefix icon to display inside the dropdown
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        DropDownSearchFormField<SuggestionItem<T>>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: TextEditingController(text: value?.label ?? ''),
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              filled: true,
              fillColor: fillColor ?? Colors.white,
              contentPadding: contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: borderColor ?? theme.colorScheme.outline,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: borderColor ?? theme.colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: ColorName.blue,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                ),
              ),
              hintStyle: hintStyle ??
                  theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.black45,
                  ),
              prefixIcon: prefixIcon,
            ),
            style: textStyle ??
                theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
            enabled: enabled,
          ),
          suggestionsCallback: (pattern) {
            return items
                .where(
                  (item) =>
                      item.label.toLowerCase().contains(pattern.toLowerCase()),
                )
                .toList();
          },
          itemBuilder: (context, SuggestionItem<T> suggestion) {
            return ListTile(
              title: Text(
                suggestion.label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
              ),
              subtitle: suggestion.subtitle != null
                  ? Text(
                      suggestion.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    )
                  : null,
              dense: true,
            );
          },
          onSuggestionSelected: onChanged,
          validator: (String? value) {
            final selectedItem = items.firstWhere(
              (item) => item.label == value,
            );
            return validator?.call(selectedItem);
          },
          displayAllSuggestionWhenTap: displayAllSuggestionWhenTap,
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white,
            elevation: 8,
          ),
        ),
        const Positioned(
          right: 16,
          top: 0,
          bottom: 0,
          child: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}
