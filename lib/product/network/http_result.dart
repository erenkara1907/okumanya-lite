/// Generic result wrapper for HTTP operations
class HttpResult<T> {
  const HttpResult._({
    required this.isSuccess,
    this.data,
    this.errorMessage,
    this.statusCode,
    this.headers,
  });

  /// Create a successful result
  factory HttpResult.success(
    T data, {
    int? statusCode,
    Map<String, dynamic>? headers,
  }) {
    return HttpResult._(
      isSuccess: true,
      data: data,
      statusCode: statusCode,
      headers: headers,
    );
  }

  /// Create an error result
  factory HttpResult.error(
    String message, {
    int? statusCode,
    Map<String, dynamic>? headers,
  }) {
    return HttpResult._(
      isSuccess: false,
      errorMessage: message,
      statusCode: statusCode,
      headers: headers,
    );
  }

  /// [isSuccess] indicates if the operation was successful
  final bool isSuccess;

  /// [data] contains the result data if successful
  final T? data;

  /// [errorMessage] contains the error message if the operation failed
  final String? errorMessage;

  /// [statusCode] contains the HTTP status code if available
  final int? statusCode;

  /// [headers] contains any additional headers returned with the response
  final Map<String, dynamic>? headers;

  /// Check if result has data
  bool get hasData => data != null;

  /// Get data or throw exception
  T get dataOrThrow {
    if (isSuccess && data != null) {
      return data!;
    }
    throw Exception(errorMessage ?? 'No data available');
  }

  @override
  String toString() {
    return 'HttpResult(isSuccess: $isSuccess, data: $data, error: $errorMessage, statusCode: $statusCode)';
  }
}
