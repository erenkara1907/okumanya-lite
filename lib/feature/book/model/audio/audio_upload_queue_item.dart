// Queue item model
import 'dart:io';

import 'package:edumind_intro_app/feature/book/model/audio/audio_upload_response.dart';
import 'package:edumind_intro_app/product/network/http_result.dart';

/// This file is part of the Book App project.
class AudioUploadQueueItem {
  /// Creates an item for the audio upload queue.
  AudioUploadQueueItem({
    required this.id,
    required this.audioFile,
    required this.customFileName,
    required this.createdAt,
    this.onComplete,
    this.onProgress,
    this.onError,
  });

  /// Unique identifier for the audio upload item.
  final String id;

  /// The audio file to be uploaded.
  final File audioFile;

  /// Custom file name for the audio upload.
  final String customFileName;

  /// Timestamp when the upload item was created.
  final DateTime createdAt;

  /// Callbacks for upload completion, progress, and error handling.
  final Function(HttpResult<AudioUploadResponse>)? onComplete;
  final Function(double progress)? onProgress;
  final Function(String error)? onError;
}
