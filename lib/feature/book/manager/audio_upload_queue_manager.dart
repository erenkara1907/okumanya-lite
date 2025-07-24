import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:edumind_intro_app/feature/book/model/audio/audio_upload_queue_item.dart';
import 'package:edumind_intro_app/feature/book/model/audio/audio_upload_response.dart';
import 'package:edumind_intro_app/feature/book/service/audio_upload_api_service.dart';
import 'package:edumind_intro_app/product/network/http_result.dart';
import 'package:edumind_intro_app/product/utility/enum/queue_status.dart';
import 'package:flutter/foundation.dart';

/// Audio Upload Queue Manager - Singleton
class AudioUploadQueueManager {
  AudioUploadQueueManager._internal();
  static AudioUploadQueueManager? _instance;

  /// Get the singleton instance of AudioUploadQueueManager
  static AudioUploadQueueManager get instance =>
      _instance ??= AudioUploadQueueManager._internal();

  final Queue<AudioUploadQueueItem> _queue = Queue<AudioUploadQueueItem>();
  QueueStatus _status = QueueStatus.idle;
  AudioUploadQueueItem? _currentItem;

  // Stream controllers for status updates
  final StreamController<QueueStatus> _statusController =
      StreamController<QueueStatus>.broadcast();
  final StreamController<int> _queueLengthController =
      StreamController<int>.broadcast();
  final StreamController<AudioUploadQueueItem?> _currentItemController =
      StreamController<AudioUploadQueueItem?>.broadcast();

  // Getters

  /// Getters for queue properties
  QueueStatus get status => _status;

  /// Getters for queue properties
  int get queueLength => _queue.length;

  /// Getters for queue properties
  AudioUploadQueueItem? get currentItem => _currentItem;

  /// Getters for queue properties
  bool get isProcessing => _status == QueueStatus.processing;

  /// Getters for queue properties
  bool get isEmpty => _queue.isEmpty && _currentItem == null;

  // Streams

  /// Streams for queue updates
  Stream<QueueStatus> get statusStream => _statusController.stream;

  /// Streams for queue updates
  Stream<int> get queueLengthStream => _queueLengthController.stream;

  /// Streams for queue updates
  Stream<AudioUploadQueueItem?> get currentItemStream =>
      _currentItemController.stream;

  /// Add audio file to upload queue
  Future<String> addToQueue({
    required File audioFile,
    required String customFileName,
    Function(HttpResult<AudioUploadResponse>)? onComplete,
    Function(double progress)? onProgress,
    Function(String error)? onError,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final queueItem = AudioUploadQueueItem(
      id: id,
      audioFile: audioFile,
      customFileName: customFileName,
      createdAt: DateTime.now(),
      onComplete: onComplete,
      onProgress: onProgress,
      onError: onError,
    );

    _queue.add(queueItem);
    _queueLengthController.add(_queue.length);

    if (kDebugMode) {
      print(
          '📥 Audio added to queue: $customFileName (Queue length: ${_queue.length})');
    }

    // Start processing if queue was idle
    if (_status == QueueStatus.idle) {
      _processQueue();
    }

    return id;
  }

  /// Remove item from queue by ID
  bool removeFromQueue(String id) {
    final initialLength = _queue.length;
    _queue.removeWhere((item) => item.id == id);

    if (_queue.length != initialLength) {
      _queueLengthController.add(_queue.length);
      if (kDebugMode) {
        print('🗑️ Removed item from queue: $id');
      }
      return true;
    }
    return false;
  }

  /// Clear all items from queue
  void clearQueue() {
    _queue.clear();
    _queueLengthController.add(0);

    if (kDebugMode) {
      print('🧹 Queue cleared');
    }
  }

  /// Pause queue processing
  void pauseQueue() {
    if (_status == QueueStatus.processing) {
      _status = QueueStatus.paused;
      _statusController.add(_status);

      if (kDebugMode) {
        print('⏸️ Queue paused');
      }
    }
  }

  /// Resume queue processing
  void resumeQueue() {
    if (_status == QueueStatus.paused) {
      _status = QueueStatus.idle;
      _statusController.add(_status);
      _processQueue();

      if (kDebugMode) {
        print('▶️ Queue resumed');
      }
    }
  }

  /// Get queue items as list (for UI display)
  List<AudioUploadQueueItem> getQueueItems() {
    return _queue.toList();
  }

  /// Main queue processing method
  Future<void> _processQueue() async {
    if (_status == QueueStatus.processing || _status == QueueStatus.paused) {
      return;
    }

    if (_queue.isEmpty) {
      _status = QueueStatus.idle;
      _statusController.add(_status);
      return;
    }

    _status = QueueStatus.processing;
    _statusController.add(_status);

    while (_queue.isNotEmpty && _status == QueueStatus.processing) {
      _currentItem = _queue.removeFirst();
      _queueLengthController.add(_queue.length);
      _currentItemController.add(_currentItem);

      if (kDebugMode) {
        print('🎵 Processing audio: ${_currentItem!.customFileName}');
      }

      await _processCurrentItem();
    }

    _currentItem = null;
    _currentItemController.add(null);
    _status = QueueStatus.idle;
    _statusController.add(_status);

    if (kDebugMode) {
      print('✅ Queue processing completed');
    }
  }

  /// Process single queue item
  Future<void> _processCurrentItem() async {
    if (_currentItem == null) return;

    try {
      // Check if file still exists
      if (!await _currentItem!.audioFile.exists()) {
        final error =
            'Audio file no longer exists: ${_currentItem!.audioFile.path}';
        _currentItem!.onError?.call(error);

        if (kDebugMode) {
          print('❌ $error');
        }
        return;
      }

      // Upload the file using CoreHttpClient directly
      final result = await AudioUploadApiService.uploadAudio(
          audioFile: _currentItem!.audioFile);

      // Handle result
      if (result.isSuccess) {
        if (kDebugMode) {
          print('✅ Upload successful: ${_currentItem!.customFileName}');
        }

        // Try to delete local file after successful upload
        try {
          await _currentItem!.audioFile.delete();
          if (kDebugMode) {
            print('🗑️ Local file deleted: ${_currentItem!.audioFile.path}');
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Could not delete local file: $e');
          }
        }
      } else {
        if (kDebugMode) {
          print(
              '❌ Upload failed: ${_currentItem!.customFileName} - ${result.errorMessage}');
        }
      }

      // Call completion callback
      _currentItem!.onComplete?.call(result);
    } catch (e) {
      final error = 'Upload error: $e';
      _currentItem!.onError?.call(error);

      if (kDebugMode) {
        print('❌ $error');
      }
    }
  }

  /// Get queue statistics
  Map<String, dynamic> getQueueStats() {
    return {
      'status': _status.toString(),
      'queueLength': _queue.length,
      'currentItem': _currentItem?.customFileName,
      'totalPending': _queue.length + (_currentItem != null ? 1 : 0),
    };
  }

  /// Dispose resources
  void dispose() {
    _statusController.close();
    _queueLengthController.close();
    _currentItemController.close();
    clearQueue();

    if (kDebugMode) {
      print('🧹 AudioUploadQueueManager disposed');
    }
  }
}
