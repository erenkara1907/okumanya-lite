/// Book model matching the API response
class Book {
  /// Book constructor
  const Book({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.bookType,
    required this.learningOutcome,
    required this.publisher,
    required this.letterCount,
    required this.wordCount,
    required this.pageCount,
    required this.shortSummary,
    required this.level,
    required this.coverImageLibrary,
    required this.coverImageSquare,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to create a Book instance from JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String,
      categoryId: json['category_id'] as int,
      bookType: json['book_type'] as String,
      learningOutcome: json['learning_outcome'] as String,
      publisher: json['publisher'] as String,
      letterCount: json['letter_count'] as int,
      wordCount: json['word_count'] as int,
      pageCount: json['page_count'] as int,
      shortSummary: json['short_summary'] as String,
      level: json['level'] as int,
      coverImageLibrary: json['cover_image_library'] as String,
      coverImageSquare: json['cover_image_square'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// [id] is the unique identifier for the book
  final int? id;

  /// [title] is the name of the book
  final String? title;

  /// [categoryId] is the identifier for the book's category
  final int? categoryId;

  /// [bookType] describes the type of book (e.g., fiction, non-fiction)
  final String? bookType;

  /// [learningOutcome] describes the expected learning outcomes from reading the book
  final String? learningOutcome;

  /// [publisher] is the name of the publisher of the book
  final String? publisher;

  /// [letterCount] is the total number of letters in the book
  final int? letterCount;

  /// [wordCount] is the total number of words in the book
  final int? wordCount;

  /// [pageCount] is the total number of pages in the book
  final int? pageCount;

  /// [shortSummary] provides a brief summary of the book's content
  final String? shortSummary;

  /// [level] indicates the difficulty level of the book
  final int? level;

  /// [coverImageLibrary] is the URL for the book's cover image in library view
  final String? coverImageLibrary;

  /// [coverImageSquare] is the URL for the book's cover image in square format
  final String? coverImageSquare;

  /// [createdAt] is the timestamp when the book was created
  final DateTime? createdAt;

  /// [updatedAt] is the timestamp when the book was last updated
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category_id': categoryId,
      'book_type': bookType,
      'learning_outcome': learningOutcome,
      'publisher': publisher,
      'letter_count': letterCount,
      'word_count': wordCount,
      'page_count': pageCount,
      'short_summary': shortSummary,
      'level': level,
      'cover_image_library': coverImageLibrary,
      'cover_image_square': coverImageSquare,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get reading time estimation in minutes
  int get estimatedReadingTime {
    // Average reading speed: 200-250 words per minute
    return (wordCount! / 225).ceil();
  }

  /// Get difficulty level text
  String get difficultyText {
    switch (level) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Elementary';
      case 3:
        return 'Intermediate';
      case 4:
        return 'Advanced';
      default:
        return 'Level $level';
    }
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, level: $level, pages: $pageCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
