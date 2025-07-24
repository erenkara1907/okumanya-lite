import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edumind_intro_app/feature/book/model/book/book.dart';
import 'package:edumind_intro_app/feature/book/view_model/book_state.dart';
import 'package:edumind_intro_app/feature/book/view_model/book_view_model.dart';
import 'package:edumind_intro_app/feature/book/widget/responsive_app_bar.dart';
import 'package:edumind_intro_app/product/navigation/app_router.dart';
import 'package:edumind_intro_app/product/state/base/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen/gen.dart';
import 'package:kartal/kartal.dart';

part './mixin/book_list_view_mixin.dart';

@RoutePage()

/// A view that displays a list of books.
class BookListView extends StatefulWidget {
  /// Creates a new instance of [BookListView].
  const BookListView({super.key});

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends BaseState<BookListView>
    with BookListViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ResponsiveAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _headerSection(context),
            const SizedBox(height: 16),
            Expanded(
              child: context.read<BookViewModel>().getBooks().ext.toBuild(
                    onSuccess: (books) {
                      return books!.isNotEmpty
                          ? _buildBooksGrid(context, books: books)
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 48,
                                    color: context.general.colorScheme.primary
                                        .withValues(alpha: 100),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Kitap bulunamadı',
                                    style: context.general.textTheme.bodyLarge
                                        ?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                    },
                    loadingWidget: const Center(
                      child: CircularProgressIndicator(
                        color: ColorName.primary,
                      ),
                    ),
                    notFoundWidget: _errorWidget(),
                    onError: _errorWidget(),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder<BookViewModel, BookState> _errorWidget() {
    return BlocBuilder<BookViewModel, BookState>(
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 56,
                  color: Colors.red.withValues(alpha: 200),
                ),
                const SizedBox(height: 16),
                Text(
                  'Server Error',
                  style: context.general.textTheme.headlineSmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (state.lastErrorStatusCode != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 30),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Status Code: ${state.lastErrorStatusCode}',
                      style: context.general.textTheme.bodySmall?.copyWith(
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 100),
                    ),
                  ),
                  child: Text(
                    state.lastError ?? 'Unexpected Error',
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.bodyMedium?.copyWith(
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBooksGrid(BuildContext context, {required List<Book> books}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth >= 768;

        final crossAxisCount = isTablet ? 3 : 2;
        final itemSpacing = isTablet ? 20.0 : 16.0;

        const aspectRatio = 0.5625;

        return GridView.builder(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          cacheExtent: 200,
          padding: const EdgeInsets.only(bottom: 24),
          physics: const ClampingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: itemSpacing,
            mainAxisSpacing: itemSpacing,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return _buildBookCard(context, book, index);
          },
        );
      },
    );
  }

  Widget _buildBookCard(BuildContext context, Book book, int index) {
    return MouseRegion(
      onEnter: (_) =>
          context.read<BookViewModel>().preloadBookPages(bookId: book.id ?? 0),
      child: GestureDetector(
        onTap: () => _onBookTap(book),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Book Cover Image
                _buildBookCover(book),

                // Gradient Overlay
                _buildGradientOverlay(),

                // Book Information
                _buildBookInfo(context, book),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookCover(Book book) {
    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: book.coverImageLibrary ?? '',
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildLoadingCover(),
        errorWidget: (context, url, error) => _buildPlaceholderCover(),
        maxWidthDiskCache: 600,
        maxHeightDiskCache: 800,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),
        memCacheWidth: 600,
        memCacheHeight: 800,
        cacheKey: 'book_cover_${book.id}',
      ),
    );
  }

  Widget _buildPlaceholderCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade300,
            Colors.purple.shade300,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.book,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLoadingCover() {
    return ColoredBox(
      color: Colors.grey.shade200,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
            stops: const [0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildBookInfo(BuildContext context, Book book) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          book.title ?? '',
          style: context.general.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void _onBookTap(Book book) {
    context.read<BookViewModel>().setValueToMic(isOpenMic: true);
    context.router.push(BookRoute(bookId: book.id ?? 0));

    debugPrint('Book tapped: ${book.title}');
  }

  Row _headerSection(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.book_outlined,
            size: 28,
            color: context.general.colorScheme.primary.withValues(alpha: 100)),
        const SizedBox(width: 8),
        Text(
          'Kitaplar',
          style: context.general.textTheme.headlineMedium?.copyWith(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
