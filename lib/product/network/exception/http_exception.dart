/// Base class for HTTP exceptions
class HttpException implements Exception {
  /// Create an HTTP exception with a message, optional status code, and headers
  const HttpException(this.message, {this.statusCode, this.headers});

  /// Create an HTTP exception with a message
  final String message;

  /// Optional HTTP status code associated with the exception
  final int? statusCode;

  /// Optional headers associated with the HTTP response
  final Map<String, dynamic>? headers;

  @override
  String toString() => 'HttpException: $message (Status: $statusCode)';
}

/// Network connectivity exception
class NetworkException extends HttpException {
  /// Create a network exception with a message
  const NetworkException(super.message);
}

/// Server error exception (5xx)
class ServerException extends HttpException {
  /// Create a server exception with a message, optional status code, and headers
  const ServerException(super.message, {super.statusCode, super.headers});
}

/// Client error exception (4xx)
class ClientException extends HttpException {
  /// Create a client exception with a message, optional status code, and headers
  const ClientException(super.message, {super.statusCode, super.headers});
}

/// Timeout exception
class TimeoutException extends HttpException {
  /// Create a timeout exception with a message
  const TimeoutException(super.message);
}

/// Parsing exception
class ParsingException extends HttpException {
  /// Create a parsing exception with a message
  const ParsingException(super.message);
}
