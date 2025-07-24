/// Recording result model
class RecordingResult {
  const RecordingResult._({
    required this.isSuccess,
    required this.message,
    this.filePath,
    this.fileSizeBytes,
    this.duration,
    this.startTime,
  });

  /// Factory constructor for a successful recording result
  factory RecordingResult.success(
    String message, {
    String? filePath,
    int? fileSizeBytes,
    Duration? duration,
    DateTime? startTime,
  }) {
    return RecordingResult._(
      isSuccess: true,
      message: message,
      filePath: filePath,
      fileSizeBytes: fileSizeBytes,
      duration: duration,
      startTime: startTime,
    );
  }

  /// Factory constructor for an error recording result
  factory RecordingResult.error(String message) {
    return RecordingResult._(
      isSuccess: false,
      message: message,
    );
  }

  /// [isSuccess] indicates whether the recording was successful
  final bool isSuccess;

  /// [message] contains the result message, which can be an error or success message
  final String message;

  /// Optional fields for additional information about the recording
  final String? filePath;

  /// [fileSizeBytes] is the size of the recorded file in bytes
  final int? fileSizeBytes;

  /// [duration] is the duration of the recording
  final Duration? duration;

  /// [startTime] is the time when the recording started
  final DateTime? startTime;

  /// Getters for formatted output
  String? get fileSizeFormatted {
    if (fileSizeBytes == null) return null;

    final kb = fileSizeBytes! / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    } else {
      final mb = kb / 1024;
      return '${mb.toStringAsFixed(1)} MB';
    }
  }

  /// [durationFormatted] returns the duration in MM:SS format
  String? get durationFormatted {
    if (duration == null) return null;

    final minutes = duration!.inMinutes;
    final seconds = duration!.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
