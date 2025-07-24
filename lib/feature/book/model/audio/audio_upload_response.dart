/// Audio upload response model
class AudioUploadResponse {
  /// Creates an instance of [AudioUploadResponse].
  const AudioUploadResponse({
    required this.success,
    required this.message,
    required this.path,
  });

  /// Creates an instance of [AudioUploadResponse] from a JSON map.
  factory AudioUploadResponse.fromJson(Map<String, dynamic> json) {
    return AudioUploadResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      path: json['path'] as String,
    );
  }

  /// Indicates whether the audio upload was successful.
  final bool success;

  /// A message providing additional information about the upload.
  final String message;

  /// The path where the uploaded audio file is stored.
  final String path;

  /// Converts the instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'path': path,
    };
  }

  @override
  String toString() {
    return 'AudioUploadResponse(success: $success, message: $message, path: $path)';
  }
}
