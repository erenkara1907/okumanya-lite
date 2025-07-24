import 'package:edumind_intro_app/product/utility/enum/http_method.dart';

/// HTTP request configuration
class HttpRequestConfig {
  /// Create a new HTTP request configuration
  const HttpRequestConfig({
    required this.url,
    required this.method,
    this.queryParameters,
    this.body,
    this.headers,
    this.timeout,
    this.requiresAuth = true,
    this.retryCount = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  /// The URL for the HTTP request
  final String url;

  /// The HTTP method to use for the request
  final HttpMethod method;

  /// Optional query parameters to include in the request
  final Map<String, dynamic>? queryParameters;

  /// Optional body for the request (for POST, PUT, etc.)
  final Map<String, dynamic>? body;

  /// Optional headers to include in the request
  final Map<String, String>? headers;

  /// Optional timeout for the request
  final Duration? timeout;

  /// Whether the request requires authentication
  final bool requiresAuth;

  /// Number of times to retry the request on failure
  final int retryCount;

  /// Delay between retries
  final Duration retryDelay;

  /// Create a copy with updated values
  HttpRequestConfig copyWith({
    String? url,
    HttpMethod? method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
    bool? requiresAuth,
    int? retryCount,
    Duration? retryDelay,
  }) {
    return HttpRequestConfig(
      url: url ?? this.url,
      method: method ?? this.method,
      queryParameters: queryParameters ?? this.queryParameters,
      body: body ?? this.body,
      headers: headers ?? this.headers,
      timeout: timeout ?? this.timeout,
      requiresAuth: requiresAuth ?? this.requiresAuth,
      retryCount: retryCount ?? this.retryCount,
      retryDelay: retryDelay ?? this.retryDelay,
    );
  }
}
