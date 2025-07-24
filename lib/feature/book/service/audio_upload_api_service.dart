// import 'dart:io';

// import 'package:edumind_intro_app/feature/book/model/audio/audio_upload_response.dart';
// import 'package:edumind_intro_app/product/network/core/core_http_client.dart';
// import 'package:edumind_intro_app/product/network/http_result.dart';
// import 'package:edumind_intro_app/product/state/container/product_items.dart';
// import 'package:flutter/foundation.dart';

// /// This file is part of the Book App project.
// class AudioUploadApiService {
//   static final CoreHttpClient _httpClient = ProductItems.coreHttpClient;

//   static Future<HttpResult<AudioUploadResponse>> uploadAudio({
//     required File audioFile,
//     Function(double progress)? onProgress,
//   }) async {
//     try {
//       if (kDebugMode) {
//         print('🎵 Starting audio upload...');
//         print('📁 File path: ${audioFile.path}');
//         print('📊 File size: ${await audioFile.length()} bytes');
//       }

//       // Check if file exists
//       if (!await audioFile.exists()) {
//         return HttpResult.error('Audio file does not exist');
//       }

//       // Upload file using CoreHttpClient
//       final result = await _httpClient.uploadFile<AudioUploadResponse>(
//         endpoint: 'https://panel.okumanya.com.tr/api/record/upload_lite',
//         file: audioFile,
//         fieldName: 'record_file', // Common field name for file uploads
//         parser: (json) => AudioUploadResponse.fromJson(json as Map<String, dynamic>),
//         headers: {
//           // Remove Content-Type to let the system set it automatically for multipart
//           'Content-Type': 'multipart/form-data',
//           'X-API-KEY': '6f1b25545ce74f9badff5322be12b1dc',
//         },
//       );

//       if (result.isSuccess && result.data != null) {
//         if (kDebugMode) {
//           print('✅ Audio upload successful');
//           print('📄 Response: ${result.data}');
//           print('🔗 Uploaded path: ${result.data!.path}');
//         }
//       } else {
//         if (kDebugMode) {
//           print('❌ Audio upload failed: ${result.errorMessage}');
//           print('📊 Status code: ${result.statusCode}');
//         }
//       }

//       return result;
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Audio upload service error: $e');
//       }
//       return HttpResult.error('Audio upload failed: $e');
//     }
//   }
// }

import 'dart:io';
import 'package:edumind_intro_app/feature/book/manager/audio_upload_queue_manager.dart';
import 'package:edumind_intro_app/feature/book/model/audio/audio_upload_response.dart';
import 'package:edumind_intro_app/product/network/core/core_http_client.dart';
import 'package:edumind_intro_app/product/network/http_result.dart';
import 'package:edumind_intro_app/product/state/container/product_items.dart';
import 'package:edumind_intro_app/product/utility/enum/queue_status.dart';
import 'package:flutter/foundation.dart';

/// Enhanced Audio Upload API Service with Queue Support
class AudioUploadApiService {
  static final CoreHttpClient _httpClient = ProductItems.coreHttpClient;
  static final AudioUploadQueueManager _queueManager =
      ProductItems.audioUploadQueueManager;

  /// Direct upload without queue (for immediate uploads)
  static Future<HttpResult<AudioUploadResponse>> uploadAudio({
    required File audioFile,
  }) async {
    try {
      if (kDebugMode) {
        print('🎵 Starting direct audio upload...');
        print('📁 File path: ${audioFile.path}');
        print('📊 File size: ${await audioFile.length()} bytes');
      }

      // Check if file exists
      if (!await audioFile.exists()) {
        return HttpResult.error('Audio file does not exist');
      }

      // Upload file using CoreHttpClient
      final result = await _httpClient.uploadFile<AudioUploadResponse>(
        endpoint: 'https://panel.okumanya.com.tr/api/record/upload_lite',
        file: audioFile,
        fieldName: 'record_file',
        parser: (json) =>
            AudioUploadResponse.fromJson(json as Map<String, dynamic>),
        headers: {
          'X-API-KEY': '6f1b25545ce74f9badff5322be12b1dc',
        },
      );

      if (result.isSuccess && result.data != null) {
        if (kDebugMode) {
          print('✅ Direct audio upload successful');
          print('📄 Response: ${result.data}');
          print('🔗 Uploaded path: ${result.data!.path}');
        }
      } else {
        if (kDebugMode) {
          print('❌ Direct audio upload failed: ${result.errorMessage}');
          print('📊 Status code: ${result.statusCode}');
        }
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Direct audio upload service error: $e');
      }
      return HttpResult.error('Audio upload failed: $e');
    }
  }

  /// Queue-based upload (recommended for multiple files)
  static Future<String> uploadAudioWithQueue({
    required File audioFile,
    required String customFileName,
    Function(HttpResult<AudioUploadResponse>)? onComplete,
    Function(double progress)? onProgress,
    Function(String error)? onError,
  }) async {
    if (kDebugMode) {
      print('📥 Adding audio to upload queue: $customFileName');
    }

    return _queueManager.addToQueue(
      audioFile: audioFile,
      customFileName: customFileName,
      onComplete: onComplete,
      onProgress: onProgress,
      onError: onError,
    );
  }

  /// Batch upload multiple files to queue
  static Future<List<String>> uploadMultipleAudiosWithQueue({
    required List<File> audioFiles,
    required List<String> customFileNames,
    Function(HttpResult<AudioUploadResponse>)? onComplete,
    Function(double progress)? onProgress,
    Function(String error)? onError,
  }) async {
    if (audioFiles.length != customFileNames.length) {
      throw ArgumentError(
          'Audio files and custom file names lists must have the same length');
    }

    final queueIds = <String>[];

    for (var i = 0; i < audioFiles.length; i++) {
      final queueId = await uploadAudioWithQueue(
        audioFile: audioFiles[i],
        customFileName: customFileNames[i],
        onComplete: onComplete,
        onProgress: onProgress,
        onError: onError,
      );
      queueIds.add(queueId);
    }

    if (kDebugMode) {
      print('📥 Added ${audioFiles.length} files to upload queue');
      print('🆔 Queue IDs: $queueIds');
    }

    return queueIds;
  }

  /// Get upload queue statistics
  static Map<String, dynamic> getQueueStats() {
    return _queueManager.getQueueStats();
  }

  /// Pause upload queue
  static void pauseQueue() {
    _queueManager.pauseQueue();
  }

  /// Resume upload queue
  static void resumeQueue() {
    _queueManager.resumeQueue();
  }

  /// Clear upload queue
  static void clearQueue() {
    _queueManager.clearQueue();
  }

  /// Remove specific item from queue
  static bool removeFromQueue(String queueId) {
    return _queueManager.removeFromQueue(queueId);
  }

  /// Get queue length
  static int get queueLength => _queueManager.queueLength;

  /// Check if queue is processing
  static bool get isQueueProcessing => _queueManager.isProcessing;

  /// Get queue status stream
  static Stream<QueueStatus> get queueStatusStream =>
      _queueManager.statusStream;

  /// Get queue length stream
  static Stream<int> get queueLengthStream => _queueManager.queueLengthStream;
}
