/// Book page model matching the API response
class BookPage {
  /// Create a new BookPage instance
  const BookPage({
    required this.id,
    required this.bookId,
    required this.pageNumber,
    required this.textPosition,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.pageText,
    this.audioUrl,
  });

  /// Create a BookPage instance from JSON
  factory BookPage.fromJson(Map<String, dynamic> json) {
    return BookPage(
      id: json['id'] as int,
      bookId: json['book_id'] as int,
      pageNumber: json['page_number'] as int,
      pageText: json['page_text'] as String?,
      textPosition: json['text_position'] as int,
      imageUrl: json['image_url'] as String,
      audioUrl: json['audio_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Unique identifier for the book page
  final int id;

  /// Identifier for the book this page belongs to
  final int bookId;

  /// Page number in the book
  final int pageNumber;

  /// Text content of the page, if available
  final String? pageText;

  /// Position of the text on the page
  final int textPosition;

  /// URL of the image representing the page
  final String imageUrl;

  /// URL of the audio file for the page, if available
  final String? audioUrl;

  /// Timestamp when the page was created
  final DateTime createdAt;

  /// Timestamp when the page was last updated
  final DateTime updatedAt;

  /// Convert the BookPage instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'page_number': pageNumber,
      'page_text': pageText,
      'text_position': textPosition,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Check if page has text content
  bool get hasText => pageText != null && pageText!.isNotEmpty;

  /// Check if page has audio
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;

  /// Check if page has both text and audio
  bool get hasTextAndAudio => hasText && hasAudio;

  /// Get text position description
  String get textPositionDescription {
    switch (textPosition) {
      case 1:
        return 'Top';
      case 2:
        return 'Middle';
      case 3:
        return 'Bottom';
      default:
        return 'Position $textPosition';
    }
  }

  /// Check if this is the first page
  bool get isFirstPage => pageNumber == 1;

  /// Check if image URL is valid
  bool get hasValidImageUrl => imageUrl.isNotEmpty;

  @override
  String toString() {
    return 'BookPage(id: $id, bookId: $bookId, pageNumber: $pageNumber, hasText: $hasText, hasAudio: $hasAudio)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookPage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
