import 'package:edumind_intro_app/feature/book/model/book/book.dart';
import 'package:edumind_intro_app/feature/book/model/book_page/book_page.dart';
import 'package:equatable/equatable.dart';

/// BookState represents the state of the book view
final class BookState extends Equatable {
  /// Creates a new instance of BookState
  const BookState({
    this.isOpenMic = true,
    this.currentPage = 1,
    this.isLoading = false,
    this.hasError = false,
    this.isFlipping = false,
    this.flipDirection = true,
    this.books = const [],
    this.isRecording = false,
    this.duration = Duration.zero,
    this.isLoadingPage = false,
    this.pages = const [],
    this.errorMessage,
    this.lastError,
    this.lastErrorStatusCode,
  });

  /// [isOpenMic] indicates whether the microphone is open
  final bool isOpenMic;

  /// [currentPage] represents the current page number of the book
  final int currentPage;

  /// [isLoading] indicates whether the book is currently loading
  final bool isLoading;

  /// [isLoading] indicates whether the book is currently loading
  final bool isLoadingPage;

  /// [hasError] indicates whether there was an error loading the book
  final bool hasError;

  /// [isFlipping] indicates whether the book is currently flipping pages
  final bool isFlipping;

  /// Creates a copy of BookState with the given properties replaced by the new values
  final bool flipDirection;

  /// [books] is the list of books in the current state
  final List<Book> books;

  /// [pages] is the list of book pages in the current state
  final List<BookPage> pages;

  /// [isRecording] indicates whether the book is currently being recorded
  final bool isRecording;

  /// [duration] is the duration of the book recording
  final Duration duration;

  /// [errorMessage] contains the error message if there was an error
  final String? errorMessage;

  /// [lastError]
  final String? lastError;

  /// [lastErrorStatusCode]
  final int? lastErrorStatusCode;

  @override
  List<Object?> get props => [
        isOpenMic,
        currentPage,
        isLoading,
        hasError,
        isFlipping,
        flipDirection,
        books,
        isRecording,
        duration,
        isLoadingPage,
        pages,
        errorMessage,
        lastError,
        lastErrorStatusCode,
      ];

  /// Creates a copy of BookState with the given properties replaced by the new values
  BookState copyWith({
    bool? isOpenMic,
    int? currentPage,
    bool? isLoading,
    bool? hasError,
    bool? isFlipping,
    bool? flipDirection,
    List<Book>? books,
    bool? isRecording,
    Duration? duration,
    bool? isLoadingPage,
    List<BookPage>? pages,
    String? errorMessage,
    String? lastError,
    int? lastErrorStatusCode,
  }) {
    return BookState(
      isOpenMic: isOpenMic ?? this.isOpenMic,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      isFlipping: isFlipping ?? this.isFlipping,
      flipDirection: flipDirection ?? this.flipDirection,
      books: books ?? this.books,
      isRecording: isRecording ?? this.isRecording,
      duration: duration ?? this.duration,
      isLoadingPage: isLoadingPage ?? this.isLoadingPage,
      pages: pages ?? this.pages,
      errorMessage: errorMessage ?? this.errorMessage,
      lastError: lastError ?? this.lastError,
      lastErrorStatusCode: lastErrorStatusCode ?? this.lastErrorStatusCode,
    );
  }
}
