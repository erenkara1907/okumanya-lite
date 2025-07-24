import 'package:edumind_intro_app/feature/book/model/book_page/book_page.dart';

/// Response model for book pages API
class BookPagesResponse {
  /// Constructor for BookPagesResponse
  const BookPagesResponse({
    required this.pages,
  });

  /// Factory constructor to create a BookPagesResponse instance from JSON
  factory BookPagesResponse.fromJson(List<dynamic> jsonList) {
    final pages = jsonList
        .map((pageJson) => BookPage.fromJson(pageJson as Map<String, dynamic>))
        .toList();

    return BookPagesResponse(pages: pages);
  }

  /// List of book pages in the response
  final List<BookPage> pages;

  /// Convert to JSON (returns List, not Map)
  List<Map<String, dynamic>> toJson() {
    return pages.map((page) => page.toJson()).toList();
  }

  /// Get pages count
  int get count => pages.length;

  /// Check if response is empty
  bool get isEmpty => pages.isEmpty;

  /// Check if response has pages
  bool get isNotEmpty => pages.isNotEmpty;

  /// Get page by page number
  BookPage? getPageByNumber(int pageNumber) {
    try {
      return pages.firstWhere((page) => page.pageNumber == pageNumber);
    } catch (e) {
      return null;
    }
  }

  /// Get first page
  BookPage? get firstPage => pages.isNotEmpty ? pages.first : null;

  /// Get last page
  BookPage? get lastPage => pages.isNotEmpty ? pages.last : null;

  /// Get pages sorted by page number
  List<BookPage> getSortedPages() {
    final sortedPages = List<BookPage>.from(pages)
      ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
    return sortedPages;
  }

  /// Get pages with text content
  List<BookPage> getPagesWithText() {
    return pages.where((page) => page.hasText).toList();
  }

  /// Get pages with audio content
  List<BookPage> getPagesWithAudio() {
    return pages.where((page) => page.hasAudio).toList();
  }

  /// Get pages in a specific range
  List<BookPage> getPagesInRange(int startPage, int endPage) {
    return pages
        .where(
          (page) => page.pageNumber >= startPage && page.pageNumber <= endPage,
        )
        .toList();
  }

  /// Get total number of pages with text
  int get textPagesCount => pages.where((page) => page.hasText).length;

  /// Get total number of pages with audio
  int get audioPagesCount => pages.where((page) => page.hasAudio).length;

  /// Check if all pages have images
  bool get allPagesHaveImages => pages.every((page) => page.hasValidImageUrl);

  @override
  String toString() {
    return 'BookPagesResponse(count: $count, textPages: $textPagesCount, audioPages: $audioPagesCount)';
  }
}
