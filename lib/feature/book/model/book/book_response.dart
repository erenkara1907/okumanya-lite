import 'package:edumind_intro_app/feature/book/model/book/book.dart';

/// Response model for books API
class BooksResponse {
  /// BooksResponse constructor
  const BooksResponse({
    required this.books,
  });

  /// Factory constructor to create a BooksResponse instance from JSON
  factory BooksResponse.fromJson(Map<String, dynamic> json) {
    final booksList = json['books'] as List<dynamic>;
    final books = booksList
        .map((bookJson) => Book.fromJson(bookJson as Map<String, dynamic>))
        .toList();

    return BooksResponse(books: books);
  }

  /// List of books in the response
  final List<Book> books;

  /// Convert BooksResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'books': books.map((book) => book.toJson()).toList(),
    };
  }

  /// Get books count
  int get count => books.length;

  /// Check if response is empty
  bool get isEmpty => books.isEmpty;

  /// Check if response has books
  bool get isNotEmpty => books.isNotEmpty;

  /// Get books by level
  List<Book> getBooksByLevel(int level) {
    return books.where((book) => book.level == level).toList();
  }

  /// Get books by category
  List<Book> getBooksByCategory(int categoryId) {
    return books.where((book) => book.categoryId == categoryId).toList();
  }

  /// Get books sorted by title
  List<Book> getSortedByTitle() {
    final sortedBooks = List<Book>.from(books)
      ..sort((a, b) => a.title!.compareTo(b.title!));
    return sortedBooks;
  }

  /// Get books sorted by creation date (newest first)
  List<Book> getSortedByDate() {
    final sortedBooks = List<Book>.from(books)
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return sortedBooks;
  }

  @override
  String toString() {
    return 'BooksResponse(count: $count)';
  }
}
