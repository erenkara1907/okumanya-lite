/// Queue status enum
enum QueueStatus {
  /// The queue is currently idle, meaning no items are being processed.
  idle,

  /// The queue is currently processing items.
  processing,

  /// The queue is currently paused, meaning processing is temporarily halted.
  paused,
}
