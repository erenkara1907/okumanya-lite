// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [BookListView]
class BookListRoute extends PageRouteInfo<void> {
  const BookListRoute({List<PageRouteInfo>? children})
      : super(
          BookListRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BookListView();
    },
  );
}

/// generated route for
/// [BookView]
class BookRoute extends PageRouteInfo<BookRouteArgs> {
  BookRoute({
    required int bookId,
    List<PageRouteInfo>? children,
  }) : super(
          BookRoute.name,
          args: BookRouteArgs(
            bookId: bookId,
          ),
          initialChildren: children,
        );

  static const String name = 'BookRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookRouteArgs>();
      return BookView(
        bookId: args.bookId,
      );
    },
  );
}

class BookRouteArgs {
  const BookRouteArgs({
    required this.bookId,
  });

  final int bookId;

  @override
  String toString() {
    return 'BookRouteArgs{bookId: $bookId}';
  }
}

/// generated route for
/// [QuestionnaireView]
class QuestionnaireRoute extends PageRouteInfo<void> {
  const QuestionnaireRoute({List<PageRouteInfo>? children})
      : super(
          QuestionnaireRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuestionnaireRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QuestionnaireView();
    },
  );
}
