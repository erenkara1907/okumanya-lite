/// Audio quality enum for API optimization
enum AudioQuality {
  /// 16kHz, 64kbps - for speech recognition
  low,

  /// 22kHz, 128kbps - balanced quality/size
  medium,

  /// 44kHz, 256kbps - high quality
  high,
}
