import 'dart:async';
import 'dart:io';

import 'package:edumind_intro_app/feature/book/model/book/book.dart';
import 'package:edumind_intro_app/feature/book/model/book_page/book_page.dart';
import 'package:edumind_intro_app/feature/book/service/audio_upload_api_service.dart';
import 'package:edumind_intro_app/feature/book/service/book_api_service.dart';
import 'package:edumind_intro_app/feature/book/view_model/book_state.dart';
import 'package:edumind_intro_app/product/network/exception/http_exception.dart';
import 'package:edumind_intro_app/product/permission/core_permission_manager.dart';
import 'package:edumind_intro_app/product/state/base/base_cubit.dart';
import 'package:edumind_intro_app/product/state/container/product_items.dart';
import 'package:edumind_intro_app/product/utility/audio/core_audio_recorder.dart';
import 'package:edumind_intro_app/product/utility/audio/model/recording_result.dart';
import 'package:edumind_intro_app/product/utility/enum/permission_status.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// BookViewModel is a ViewModel for managing the state of the book view
final class BookViewModel extends BaseCubit<BookState> {
  /// Creates a new instance of BookViewModel with the initial state
  BookViewModel() : super(const BookState());

  final _cacheService = ProductItems.userDataCacheService;

  final _permissionManager = CorePermissionManager.instance;
  final _audioRecorder = CoreAudioRecorder.instance;

  String _customFileName = '';

  Timer? _timer;

  final Map<int, List<BookPage>> _pageCache = {};

  /// Toggles the microphone state
  void toggleMic() {
    emit(state.copyWith(isOpenMic: !state.isOpenMic));
  }

  void _setError(String? error, {int? statusCode}) {
    emit(state.copyWith(lastError: error, lastErrorStatusCode: statusCode));
  }

  void _clearError() {
    emit(state.copyWith());
  }

  /// Fetches the list of books from the API and updates the state
  Future<List<Book>> getBooks() async {
    try {
      _clearError();

      var level = '';
      final user = _cacheService.getCurrentUser();

      if (user != null) {
        level = user.grade.id;
      }

      final result = await BookApiService.getBooks(
        categories: [99],
        levels: [level],
      );

      if (result.isSuccess && result.data != null) {
        return result.data!.books;
      } else {
        final errorMessage =
            result.errorMessage ?? 'İnternet bağlantınızı kontrol edin';

        _setError(errorMessage, statusCode: result.statusCode);

        if (kDebugMode) {
          print('Error fetching books: ${result.errorMessage}');
        }

        throw ServerException(
          errorMessage,
          statusCode: result.statusCode,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('ViewModel getBooks error: $e');
      }

      if (e is ServerException) {
        _setError(e.message, statusCode: e.statusCode);
        rethrow;
      }

      _setError(e.toString());
      throw ServerException(
          'Kitaplar yüklenirken beklenmeyen bir hata oluştu: $e');
    }
  }

  /// Loads book pages for the given book ID
  Future<void> loadBookPages({required int bookId}) async {
    try {
      if (_pageCache.containsKey(bookId)) {
        emit(
          state.copyWith(
            pages: _pageCache[bookId],
            isLoading: false,
            hasError: false,
          ),
        );
        return;
      }

      // Loading state'ini emit et
      emit(
        state.copyWith(
          isLoading: true,
          hasError: false,
        ),
      );

      final result = await BookApiService.getBookPages(bookId: bookId);

      if (result.data!.pages.isNotEmpty && result.data != null) {
        _pageCache[bookId] = result.data!.pages;
      }

      // Success state'ini emit et
      emit(
        state.copyWith(
          pages: result.data!.pages,
          isLoading: false,
          hasError: false,
        ),
      );
    } catch (e) {
      // Error state'ini emit et
      emit(
        state.copyWith(
          isLoading: false,
          hasError: true,
          pages: [],
          errorMessage: e.toString(),
        ),
      );

      debugPrint('Error loading book pages: $e');
    }
  }

  /// Legacy method for backward compatibility
  Future<List<BookPage>?> getBookPages({required int bookId}) async {
    await loadBookPages(bookId: bookId);
    return state.pages;
  }

  /// Fetches the book pages for a given book ID
  // Future<List<BookPage>> getBookPages({required int bookId}) async {
  //   final result = await BookApiService.getBookPages(bookId: bookId);

  //   if (result.isSuccess && result.data != null) {
  //     return result.data!.pages;
  //   } else {
  //     if (kDebugMode) {
  //       print('Error fetching book pages: ${result.errorMessage}');
  //     }
  //     return [];
  //   }
  // }

  /// Sets the value for recording state
  void setValueToRecording({required bool isRecording}) {
    emit(state.copyWith(isRecording: isRecording));
  }

  /// Sets the microphone state to open or closed
  void setValueToMic({required bool isOpenMic}) {
    emit(state.copyWith(isOpenMic: isOpenMic));
  }

  /// Clears the current page number
  void clearCurrentPage() {
    emit(state.copyWith(currentPage: 1));
  }

  /// Increments the current page number
  void incrementCurrentPage({required int currentPage}) {
    emit(state.copyWith(currentPage: currentPage));
  }

  /// Decrements the current page number
  void decrementCurrentPage({required int currentPage}) {
    if (state.currentPage > 1) {
      emit(state.copyWith(currentPage: currentPage));
    }
  }

  /// Change the loading state
  void changeLoadingState({bool isLoading = false}) {
    emit(state.copyWith(isLoading: isLoading));
  }

  /// Change the loading page state
  void changeLoadingPageState({bool isLoadingPage = false}) {
    emit(state.copyWith(isLoadingPage: isLoadingPage));
  }

  /// Change the flipping state
  void changeFlippingState({bool isFlipping = false}) {
    emit(state.copyWith(isFlipping: isFlipping));
  }

  /// Change the Flip Direction state
  void changeFlipDirectionState({bool flipDirection = true}) {
    emit(state.copyWith(flipDirection: flipDirection));
  }

  /// Change the error state
  void changeErrorState({bool hasError = false}) {
    emit(state.copyWith(hasError: hasError));
  }

  /// Preloads pages for a specific book (for optimization)
  Future<void> preloadBookPages({required int bookId}) async {
    if (!_pageCache.containsKey(bookId)) {
      try {
        final result = await BookApiService.getBookPages(bookId: bookId);
        _pageCache[bookId] = result.data!.pages;
      } catch (e) {
        debugPrint('Error preloading book pages: $e');
      }
    }
  }

  /// Gets cached pages if available
  List<BookPage>? getCachedPages({required int bookId}) {
    return _pageCache[bookId];
  }

  /// Checks if pages are cached
  bool isPagesCached({required int bookId}) {
    return _pageCache.containsKey(bookId);
  }

  /// Handles page change with stop and start recording
  Future<void> handlePageChangeWithStopStart({
    required String bookId,
    required void Function() onAnimationsStart,
    required void Function() onAnimationsStop,
    required void Function() settingsDialog,
  }) async {
    print('state recording: ${state.isRecording}');
    if (state.isRecording) {
      await stopRecording(onAnimation: onAnimationsStop);
    }

    if (!state.isRecording) {
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(isOpenMic: true));
      startRecording(
          bookId: bookId,
          onAnimations: onAnimationsStart,
          settingsDialog: settingsDialog);
    }
  }

  /// Starts the recording timer and updates the state with the current duration
  Future<void> startRecording({
    required String bookId,
    required void Function() onAnimations,
    required void Function() settingsDialog,
  }) async {
    try {
      if (state.isRecording) {
        if (kDebugMode) {
          print('⚠️ Already recording, skipping start');
        }
        return;
      }

      if (kDebugMode) {
        print('🎤 Starting recording process...');
      }

      final permissionResult =
          await _permissionManager.checkMicrophonePermission();

      if (kDebugMode) {
        print('🔍 Permission check result: ${permissionResult.status}');
        print('📝 Message: ${permissionResult.message}');
      }

      if (permissionResult.status == PermissionStatusApp.granted) {
        await _startActualRecording(bookId: bookId, onAnimations: onAnimations);
      } else if (permissionResult.status == PermissionStatusApp.denied) {
        final requestResult =
            await _permissionManager.requestMicrophonePermission();

        if (requestResult.status == PermissionStatusApp.granted) {
          await _startActualRecording(
              bookId: bookId, onAnimations: onAnimations);
        } else if (requestResult.status ==
            PermissionStatusApp.permanentlyDenied) {
          settingsDialog();
        }
      } else if (permissionResult.status ==
          PermissionStatusApp.permanentlyDenied) {
        settingsDialog();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in _startRecording: $e');
      }
    }
  }

  Future<void> _startActualRecording({
    required String bookId,
    required void Function() onAnimations,
  }) async {
    try {
      if (kDebugMode) {
        print('🎙️ Starting actual recording...');
      }

      // Generate custom filename: bookId_pageNumber_userId_uuid
      _customFileName = _generateCustomFileName(bookId: bookId);

      if (kDebugMode) {
        print('📝 Custom filename: $_customFileName');
      }

      // Start recording with custom filename
      final recordingResult = await _audioRecorder.startRecording(
        customFileName: _customFileName,
      );

      if (recordingResult.isSuccess) {
        emit(state.copyWith(isRecording: true, duration: Duration.zero));

        onAnimations();

        // Timer.periodic(const Duration(seconds: 1), (timer) {
        //   emit(state.copyWith(duration: state.duration + const Duration(seconds: 1)));

        //   if (!state.isRecording) {
        //     timer.cancel();
        //     return;
        //   }
        // });

        var counter = 0;
        _timer?.cancel(); // var olan varsa iptal et
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          counter++;
          emit(state.copyWith(duration: Duration(seconds: counter)));
        });

        if (kDebugMode) {
          print(
              '✅ Recording started successfully with filename: $_customFileName');
          print('📁 Expected file path: ${recordingResult.filePath}');
        }
      } else {
        if (kDebugMode) {
          print('❌ Recording failed: ${recordingResult.message}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in _startActualRecording: $e');
      }
    }
  }

  /// Stops the recording and updates the state
  Future<void> stopRecording({required void Function() onAnimation}) async {
    try {
      if (kDebugMode) {
        print('🛑 Stopping recording...');
      }

      await stopRecordingInternal(onAnimation: onAnimation);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error stopping recording: $e');
      }
    }
  }

  /// Internal method to stop recording
  Future<void> stopRecordingInternal(
      {required void Function() onAnimation}) async {
    onAnimation();

    _timer?.cancel();
    _timer = null;

    emit(
      state.copyWith(
        isRecording: false,
        duration: Duration.zero,
        isOpenMic: false,
      ),
    );

    final recordingResult = await _audioRecorder.stopRecording();

    if (recordingResult.isSuccess && recordingResult.filePath != null) {
      await _uploadRecording(recordingResult);

      if (kDebugMode) {
        print('✅ Recording stopped successfully');
        print('📁 File path: ${recordingResult.filePath}');
        print('⏱️ Duration: ${recordingResult.durationFormatted}');
      }
    } else {
      if (kDebugMode) {
        print('❌ Recording stop failed: ${recordingResult.message}');
      }
    }
  }

  Future<void> _uploadRecording(RecordingResult recordingResult) async {
    if (recordingResult.filePath == null) return;

    final audioFile = File(recordingResult.filePath!);

    try {
      // Add to upload queue using the enhanced service
      final queueId = await AudioUploadApiService.uploadAudioWithQueue(
        audioFile: audioFile,
        customFileName: _customFileName,
        onProgress: (progress) {
          if (kDebugMode) {
            print(
                '📊 Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
          }
        },
        onComplete: (result) {
          if (result.isSuccess) {
            if (kDebugMode) {
              print('✅ Audio upload completed: $_customFileName');
              print('🔗 Server response: ${result.data}');
            }
          } else {
            if (kDebugMode) {
              print('❌ Audio upload failed: ${result.errorMessage}');
            }
          }
        },
      );

      if (kDebugMode) {
        print('📥 Audio queued with ID: $queueId');
        print(
            '📊 Current queue stats: ${AudioUploadApiService.getQueueStats()}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding to queue: $e');
      }

      try {
        await audioFile.delete();
      } catch (deleteError) {
        if (kDebugMode) {
          print('⚠️ Could not delete failed file: $deleteError');
        }
      }
    }
  }

  String _generateCustomFileName({required String bookId}) {
    final user = _cacheService.getCurrentUser();

    if (user == null) {
      if (kDebugMode) {
        print('❌ No user found, cannot generate filename');
      }
      return 'unknown_user';
    }

    const uuid = Uuid();

    final pageId = state.currentPage.toString();
    final cityId = user.city.id;
    final gradeId = user.grade.id; // Assuming grade.id is the level ID
    final uuidString = uuid.v4();

    final filename = '${bookId}_${pageId}_${cityId}_${gradeId}_$uuidString';

    if (kDebugMode) {
      print('🏷️ Generated filename: $filename');
    }

    return filename;
  }
}
