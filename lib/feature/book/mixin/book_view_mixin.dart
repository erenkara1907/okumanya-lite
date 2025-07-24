part of '../book_view.dart';

/// A mixin that provides functionality for the [BookView] widget.
mixin BookViewMixin on BaseState<BookView>, TickerProviderStateMixin<BookView> {
  late PageController _pageController;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    final currentPage = context.read<BookViewModel>().state.currentPage;
    _pageController = PageController(
      initialPage: currentPage > 0 ? currentPage - 1 : 0,
    );

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeOutCubic,
      ),
    );

    _flipAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<BookViewModel>().changeFlippingState();
        _flipController.reset();
      }
    });
  }

  Widget _buildContent({required List<BookPage> pages}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadInitialImages(pages: pages);
    });

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTapUp: (details) => _handleTap(details: details, pages: pages),
            behavior: HitTestBehavior.opaque,
            child: _buildPageView(pages: pages),
          ),
        ),
        _buildUIOverlay(pages),
      ],
    );
  }

  Widget _buildUIOverlay(List<BookPage> pages) {
    return BlocBuilder<BookViewModel, BookState>(
      buildWhen: (previous, current) =>
          previous.isLoading != current.isLoading ||
          previous.isOpenMic != current.isOpenMic ||
          previous.currentPage != current.currentPage,
      builder: (context, state) {
        return Stack(
          children: [
            // Back Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: BackButtonArrow(
                onTap: () async {
                  await Microphone.stopRecordingExternal();
                  context
                      .read<BookViewModel>()
                      .setValueToRecording(isRecording: false);
                  context.read<BookViewModel>().clearCurrentPage();
                  context.back();
                },
              ),
            ),

            // Mic button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: TickerMode(
                enabled: !state.isFlipping,
                child: Microphone(
                  state: state,
                  onTap: () async {
                    await Microphone.stopRecordingExternal();
                  },
                  bookId: widget.bookId.toString(),
                ),
              ),
            ),

            if (state.isLoading && pages.isNotEmpty)
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.black54,
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPageView({required List<BookPage> pages}) {
    return BlocBuilder<BookViewModel, BookState>(
      buildWhen: (previous, current) =>
          previous.currentPage != current.currentPage ||
          previous.isFlipping != current.isFlipping,
      builder: (context, state) {
        return PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pages.length,
          onPageChanged: (index) {
            if (!state.isFlipping) {
              context
                  .read<BookViewModel>()
                  .incrementCurrentPage(currentPage: index + 1);
            }
          },
          itemBuilder: (context, index) {
            return _buildOptimizedImagePage(pages[index], index + 1);
          },
        );
      },
    );
  }

  Widget _buildOptimizedImagePage(BookPage page, int pageNumber) {
    return RepaintBoundary(
      child: Image.network(
        page.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          final progress = loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null;

          return ColoredBox(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      value: progress,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Yükleniyor...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;

          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: child,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.read<BookViewModel>().changeErrorState(hasError: true);
            }
          });

          return _buildErrorPage(pageNumber);
        },
      ),
    );
  }

  Widget _buildErrorPage(int pageNumber) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.broken_image,
              color: Colors.white54,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Sayfa $pageNumber yüklenemedi',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(
      {required TapUpDetails details, required List<BookPage> pages}) {
    final state = context.read<BookViewModel>().state;
    if (state.isFlipping) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.localPosition.dx;

    if (tapPosition > screenWidth / 2) {
      _nextPage(state: state, pages: pages);
    } else {
      _previousPage(state: state, pages: pages);
    }
  }

  void _nextPage({required BookState state, required List<BookPage> pages}) {
    if (state.currentPage >= pages.length) {
      showEndOfBookDialog();
      return;
    }

    if (state.currentPage < pages.length && !state.isFlipping) {
      context.read<BookViewModel>().changeFlippingState(isFlipping: true);
      context.read<BookViewModel>().changeFlipDirectionState();
      context
          .read<BookViewModel>()
          .incrementCurrentPage(currentPage: state.currentPage + 1);
      context.read<BookViewModel>().changeErrorState();

      _flipController.forward();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );

      _preloadNextImages(state: state, pages: pages);
    }
  }

  void _previousPage(
      {required BookState state, required List<BookPage> pages}) {
    if (state.currentPage > 1 && !state.isFlipping) {
      context.read<BookViewModel>().changeFlippingState(isFlipping: true);
      context
          .read<BookViewModel>()
          .changeFlipDirectionState(flipDirection: false);
      context
          .read<BookViewModel>()
          .incrementCurrentPage(currentPage: state.currentPage - 1);
      context.read<BookViewModel>().changeErrorState();

      _flipController.forward();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );

      _preloadPreviousImages(state: state, pages: pages);
    }
  }

  void _preloadNextImages(
      {required BookState state, required List<BookPage> pages}) {
    if (!mounted) return;

    for (var i = state.currentPage + 1;
        i <= state.currentPage + 3 && i <= pages.length;
        i++) {
      final imageUrl = pages[i - 1].imageUrl;
      try {
        precacheImage(NetworkImage(imageUrl), context);
      } catch (e) {
        if (kDebugMode) {
          print('Next preload error: $e');
        }
      }
    }
  }

  void _preloadPreviousImages(
      {required BookState state, required List<BookPage> pages}) {
    if (!mounted) return;

    for (var i = state.currentPage - 3; i < state.currentPage && i >= 1; i++) {
      final imageUrl = pages[i - 1].imageUrl;
      try {
        precacheImage(NetworkImage(imageUrl), context);
      } catch (e) {
        if (kDebugMode) {
          print('Previous preload error: $e');
        }
      }
    }
  }

  void _preloadInitialImages({required List<BookPage> pages}) {
    if (!mounted || pages.isEmpty) return;

    final state = context.read<BookViewModel>().state;
    final currentPage = state.currentPage;

    for (var i = (currentPage - 2).clamp(1, pages.length);
        i <= (currentPage + 2).clamp(1, pages.length);
        i++) {
      if (i != currentPage) {
        final imageUrl = pages[i - 1].imageUrl;
        try {
          precacheImage(NetworkImage(imageUrl), context);
        } catch (e) {
          if (kDebugMode) {
            print('Initial preload error: $e');
          }
        }
      }
    }
  }

  void showEndOfBookDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kitap Tamamlandı!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kitabın sonuna geldiniz. Tebrikler!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('İptal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<BookViewModel>().clearCurrentPage();
                          context.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Çık'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
