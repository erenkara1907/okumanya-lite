import 'dart:io';

import 'package:edumind_intro_app/product/utility/audio/model/recording_result.dart';
import 'package:edumind_intro_app/product/utility/enum/audio_quality.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Core audio recorder for recording and preparing files for API upload
class CoreAudioRecorder {
  CoreAudioRecorder._();
  static final CoreAudioRecorder _instance = CoreAudioRecorder._();
  static CoreAudioRecorder get instance => _instance;

  final AudioRecorder _recorder = AudioRecorder();
  bool _isInitialized = false;
  String? _currentRecordingPath;
  DateTime? _recordingStartTime;

  /// Initialize the audio recorder
  Future<RecordingResult> initialize() async {
    try {
      if (_isInitialized) {
        if (kDebugMode) {
          print('✅ Audio recorder already initialized');
        }
        return RecordingResult.success('Already initialized');
      }

      // Check permissions
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        return RecordingResult.error('Microphone permission required');
      }

      _isInitialized = true;
      if (kDebugMode) {
        print('✅ Audio recorder initialized successfully');
      }

      return RecordingResult.success('Recorder initialized');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing audio recorder: $e');
      }
      return RecordingResult.error('Initialization failed: $e');
    }
  }

  /// Start audio recording optimized for API upload
  Future<RecordingResult> startRecording({
    String? customFileName,
    AudioQuality quality = AudioQuality.medium,
  }) async {
    try {
      // Initialize if needed
      if (!_isInitialized) {
        final initResult = await initialize();
        if (!initResult.isSuccess) {
          return initResult;
        }
      }

      // Check if already recording
      if (await _recorder.isRecording()) {
        return RecordingResult.error('Already recording');
      }

      // Generate file path
      final filePath = await _generateFilePath(customFileName);
      final config = _getRecordingConfig(quality);

      await _recorder.start(config, path: filePath);
      _currentRecordingPath = filePath;
      _recordingStartTime = DateTime.now();

      if (kDebugMode) {
        print('🎤 Recording started');
        print('📁 File path: $filePath');
        print('⚙️ Quality: ${quality.name}');
      }

      return RecordingResult.success(
        'Recording started',
        filePath: filePath,
        startTime: _recordingStartTime,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error starting recording: $e');
      }
      return RecordingResult.error('Failed to start recording: $e');
    }
  }

  /// Stop recording and return file info for API upload
  Future<RecordingResult> stopRecording() async {
    try {
      if (!await _recorder.isRecording()) {
        return RecordingResult.error('Not currently recording');
      }

      final path = await _recorder.stop();
      final finalPath = path ?? _currentRecordingPath;
      final endTime = DateTime.now();

      if (finalPath == null) {
        return RecordingResult.error('Recording path is null');
      }

      // Validate file exists and has content
      final file = File(finalPath);
      if (!await file.exists()) {
        return RecordingResult.error('Recording file not found');
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        return RecordingResult.error('Recording file is empty');
      }

      final duration = _recordingStartTime != null
          ? endTime.difference(_recordingStartTime!)
          : null;

      if (kDebugMode) {
        print('🛑 Recording stopped successfully');
        print('📁 File: $finalPath');
        print('📊 Size: ${(fileSize / 1024).toStringAsFixed(1)} KB');
        print('⏱️ Duration: ${duration?.inSeconds ?? 'Unknown'} seconds');
      }

      _currentRecordingPath = null;
      _recordingStartTime = null;

      return RecordingResult.success(
        'Recording completed',
        filePath: finalPath,
        fileSizeBytes: fileSize,
        duration: duration,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error stopping recording: $e');
      }
      return RecordingResult.error('Failed to stop recording: $e');
    }
  }

  /// Cancel recording and delete the file
  Future<RecordingResult> cancelRecording() async {
    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }

      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
          if (kDebugMode) {
            print('🗑️ Recording cancelled and file deleted');
          }
        }
        _currentRecordingPath = null;
        _recordingStartTime = null;
      }

      return RecordingResult.success('Recording cancelled');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cancelling recording: $e');
      }
      return RecordingResult.error('Failed to cancel recording: $e');
    }
  }

  /// Check if currently recording
  Future<bool> isRecording() async {
    try {
      return await _recorder.isRecording();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking recording status: $e');
      }
      return false;
    }
  }

  /// Get recording duration stream
  // Stream<Duration> get durationStream {
  //   return _recorder.onStateChanged.map((state) => state.duration);
  // }

  /// Generate file path for recording
  Future<String> _generateFilePath(String? customFileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${directory.path}/audio_recordings');

    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = customFileName ?? 'voice_$timestamp';

    return '${recordingsDir.path}/$fileName.wav';
  }

  /// Get recording configuration based on quality
  RecordConfig _getRecordingConfig(AudioQuality quality) {
    switch (quality) {
      case AudioQuality.low:
        return const RecordConfig(
          sampleRate: 16000,
          encoder: AudioEncoder.wav,
          bitRate: 64000,
        );
      case AudioQuality.medium:
        return const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 22050,
        );
      case AudioQuality.high:
        return const RecordConfig(
          encoder: AudioEncoder.wav,
          bitRate: 256000,
        );
    }
  }

  /// Clean up old recording files (call periodically)
  Future<void> cleanupOldRecordings({int maxAgeHours = 24}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final recordingsDir = Directory('${directory.path}/audio_recordings');

      if (!await recordingsDir.exists()) return;

      final files = recordingsDir.listSync();
      final cutoffTime = DateTime.now().subtract(Duration(hours: maxAgeHours));

      for (final file in files) {
        if (file is File) {
          final stat = await file.stat();
          if (stat.modified.isBefore(cutoffTime)) {
            await file.delete();
            if (kDebugMode) {
              print('🗑️ Deleted old recording: ${file.path}');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cleaning up recordings: $e');
      }
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }
      await _recorder.dispose();
      _isInitialized = false;

      if (kDebugMode) {
        print('🧹 Audio recorder disposed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error disposing audio recorder: $e');
      }
    }
  }
}
