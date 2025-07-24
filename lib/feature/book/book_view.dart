// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:edumind_intro_app/feature/book/model/book_page/book_page.dart';
import 'package:edumind_intro_app/feature/book/view_model/book_state.dart';
import 'package:edumind_intro_app/feature/book/view_model/book_view_model.dart';
import 'package:edumind_intro_app/feature/book/widget/back_button.dart';
import 'package:edumind_intro_app/feature/book/widget/microphone.dart';
import 'package:edumind_intro_app/product/state/base/base_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part './mixin/book_view_mixin.dart';

@RoutePage()

/// JPG Page Viewer Widget
// class BookView extends StatefulWidget {
//   /// Creates a JPG page viewer
//   const BookView({
//     required this.bookId,
//     super.key,
//   });

//   final int bookId;

//   @override
//   State<BookView> createState() => _BookViewState();
// }

// class _BookViewState extends BaseState<BookView>
//     with TickerProviderStateMixin<BookView>, BookViewMixin, AutomaticKeepAliveClientMixin {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<BookViewModel>().loadBookPages(bookId: widget.bookId);
//     });
//   }

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: RepaintBoundary(
//         child: AnnotatedRegion<SystemUiOverlayStyle>(
//           value: const SystemUiOverlayStyle(
//             statusBarColor: Colors.transparent,
//             statusBarIconBrightness: Brightness.light,
//             systemNavigationBarColor: Colors.black,
//           ),
//           child: BlocBuilder<BookViewModel, BookState>(
//             builder: (context, state) {
//               if (state.isLoading && state.pages.isEmpty) {
//                 return _buildLoadingScreen();
//               }

//               if (state.hasError && state.pages.isEmpty) {
//                 return _buildErrorScreen();
//               }

//               if (state.pages.isEmpty && !state.isLoading) {
//                 return _buildEmptyScreen();
//               }

//               return _buildContent(pages: state.pages);
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingScreen() {
//     return Stack(
//       children: [
//         const ColoredBox(
//           color: Colors.black,
//           child: SizedBox.expand(),
//         ),

//         Positioned(
//           top: MediaQuery.of(context).padding.top + 16,
//           left: 16,
//           child: BackButtonArrow(
//             onTap: () async {
//               await Microphone.stopRecordingExternal();
//               context.read<BookViewModel>().setValueToMic(isOpenMic: false);
//               context.read<BookViewModel>().clearCurrentPage();
//               context.back();
//             },
//           ),
//         ),

//         // Loading indicator
//         const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 strokeWidth: 2,
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Kitap yükleniyor...',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildErrorScreen() {
//     return Stack(
//       children: [
//         const ColoredBox(
//           color: Colors.black,
//           child: SizedBox.expand(),
//         ),
//         Positioned(
//           top: MediaQuery.of(context).padding.top + 16,
//           left: 16,
//           child: BackButtonArrow(
//             onTap: () async {
//               await Microphone.stopRecordingExternal();
//               context.read<BookViewModel>().setValueToMic(isOpenMic: false);
//               context.read<BookViewModel>().clearCurrentPage();
//               context.back();
//             },
//           ),
//         ),
//         Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.error_outline,
//                 color: Colors.white54,
//                 size: 64,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Kitap yüklenirken hata oluştu',
//                 style: TextStyle(
//                   color: Colors.white54,
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<BookViewModel>().loadBookPages(bookId: widget.bookId);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: Colors.black,
//                 ),
//                 child: const Text('Tekrar Dene'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyScreen() {
//     return Stack(
//       children: [
//         const ColoredBox(
//           color: Colors.black,
//           child: SizedBox.expand(),
//         ),
//         Positioned(
//           top: MediaQuery.of(context).padding.top + 16,
//           left: 16,
//           child: BackButtonArrow(
//             onTap: () async {
//               await Microphone.stopRecordingExternal();
//               context.read<BookViewModel>().setValueToMic(isOpenMic: false);
//               context.read<BookViewModel>().clearCurrentPage();
//               context.back();
//             },
//           ),
//         ),
//         const Center(
//           child: Text(
//             'Bu kitap için sayfa bulunamadı',
//             style: TextStyle(
//               color: Colors.white54,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class BookView extends StatefulWidget {
  const BookView({
    required this.bookId,
    super.key,
  });

  final int bookId;

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends BaseState<BookView>
    with
        TickerProviderStateMixin<BookView>,
        BookViewMixin,
        AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    // Optimizasyon: PostFrameCallback yerine immediate call
    _initializeBook();
  }

  void _initializeBook() {
    // Sistem UI'ını hemen ayarla
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
      ),
    );

    // Kitap sayfalarını yükle
    context.read<BookViewModel>().loadBookPages(bookId: widget.bookId);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.black,
      // Optimizasyon: RepaintBoundary'yi sadece gerekli yerlerde kullan
      body: BlocBuilder<BookViewModel, BookState>(
        // Optimizasyon: Sadece gerekli state değişikliklerinde rebuild
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.hasError != current.hasError ||
            previous.pages.length != current.pages.length,
        builder: (context, state) {
          // Optimizasyon: Basit loading state
          if (state.isLoading && state.pages.isEmpty) {
            return _buildQuickLoadingScreen();
          }

          if (state.hasError && state.pages.isEmpty) {
            return _buildErrorScreen();
          }

          if (state.pages.isEmpty && !state.isLoading) {
            return _buildEmptyScreen();
          }

          return _buildContent(pages: state.pages);
        },
      ),
    );
  }

  // Optimizasyon: Daha basit loading screen
  Widget _buildQuickLoadingScreen() {
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: [
          // Back button hemen göster
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: BackButtonArrow(
              onTap: _handleBackButton,
            ),
          ),

          // Minimal loading indicator
          const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: BackButtonArrow(
              onTap: _handleBackButton,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white54,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kitap yüklenirken hata oluştu',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    context
                        .read<BookViewModel>()
                        .loadBookPages(bookId: widget.bookId);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.1),
                  ),
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyScreen() {
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: BackButtonArrow(
              onTap: _handleBackButton,
            ),
          ),
          const Center(
            child: Text(
              'Bu kitap için sayfa bulunamadı',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleBackButton() async {
    await Microphone.stopRecordingExternal();
    context.read<BookViewModel>().setValueToMic(isOpenMic: false);
    context.read<BookViewModel>().clearCurrentPage();
    context.back();
  }
}
