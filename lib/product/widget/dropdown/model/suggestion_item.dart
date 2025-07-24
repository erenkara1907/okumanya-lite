/// Search suggestion item model for dropdown
class SuggestionItem<T> {
  /// Creates a suggestion item
  const SuggestionItem({
    required this.value,
    required this.label,
    this.subtitle,
  });

  /// The actual value of the item
  final T value;

  /// Display label for the item
  final String label;

  /// Optional subtitle for the item
  final String? subtitle;

  @override
  String toString() => label;
}
