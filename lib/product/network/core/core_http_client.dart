import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:edumind_intro_app/product/network/config/http_request_config.dart';
import 'package:edumind_intro_app/product/network/exception/http_exception.dart';
import 'package:edumind_intro_app/product/network/http_result.dart';
import 'package:edumind_intro_app/product/utility/enum/http_method.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Core HTTP client with best practices implementation
class CoreHttpClient {
  CoreHttpClient._();
  static final CoreHttpClient _instance = CoreHttpClient._();

  /// Singleton instance of CoreHttpClient
  static CoreHttpClient get instance => _instance;

  /// Base URL for API endpoints
  static const String _baseUrl = 'https://okul.okumanya.com.tr/api';

  /// Default timeout duration
  static const Duration _defaultTimeout = Duration(seconds: 30);

  /// HTTP client instance
  final http.Client _client = http.Client();

  /// Auth token storage
  String? _authToken;

  /// Global headers that will be added to all requests
  final Map<String, String> _globalHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
    if (kDebugMode) {
      print('🔐 Auth token updated');
    }
  }

  /// Clear authentication token
  void clearAuthToken() {
    _authToken = null;
    if (kDebugMode) {
      print('🔓 Auth token cleared');
    }
  }

  /// Add global header
  void addGlobalHeader(String key, String value) {
    _globalHeaders[key] = value;
  }

  /// Remove global header
  void removeGlobalHeader(String key) {
    _globalHeaders.remove(key);
  }

  /// Execute HTTP request with retry logic and error handling
  Future<HttpResult<T>> request<T>(
    HttpRequestConfig config, {
    required T Function(dynamic) parser,
  }) async {
    var attemptCount = 0;

    while (attemptCount <= config.retryCount) {
      try {
        if (kDebugMode) {
          print(
              '🌐 HTTP Request Attempt ${attemptCount + 1}/${config.retryCount + 1}');
          print(
              '📍 ${config.method.value} ${_buildUrl(config.url, config.queryParameters)}');
        }

        final response = await _executeRequest(config);

        if (kDebugMode) {
          print('📊 Response Status: ${response.statusCode}');
          print('📦 Response Length: ${response.body.length} bytes');
        }

        // Handle different status codes
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return _handleSuccessResponse<T>(response, parser);
        } else if (response.statusCode >= 400 && response.statusCode < 500) {
          return _handleClientError(response);
        } else if (response.statusCode >= 500) {
          throw ServerException(
            'Server error: ${response.statusCode}',
            statusCode: response.statusCode,
          );
        } else {
          throw HttpException('Unexpected status code: ${response.statusCode}');
        }
      } on SocketException catch (e) {
        if (kDebugMode) {
          print('🔌 Network error: $e');
        }
        if (attemptCount == config.retryCount) {
          return HttpResult.error('Network connection failed: ${e.message}');
        }
      } on TimeoutException catch (e) {
        if (kDebugMode) {
          print('⏰ Timeout error: $e');
        }
        if (attemptCount == config.retryCount) {
          return HttpResult.error('Request timeout: ${e.message}');
        }
      } on FormatException catch (e) {
        if (kDebugMode) {
          print('📝 Parsing error: $e');
        }
        return HttpResult.error('Failed to parse response: ${e.message}');
      } on HttpException catch (e) {
        if (kDebugMode) {
          print('🚨 HTTP error: $e');
        }
        if (attemptCount == config.retryCount) {
          return HttpResult.error(e.message, statusCode: e.statusCode);
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Unexpected error: $e');
        }
        if (attemptCount == config.retryCount) {
          return HttpResult.error('Unexpected error: $e');
        }
      }

      // Wait before retry (except for the last attempt)
      if (attemptCount < config.retryCount) {
        await Future.delayed(config.retryDelay * (attemptCount + 1));
      }

      attemptCount++;
    }

    return HttpResult.error('All retry attempts failed');
  }

  /// Execute the actual HTTP request
  Future<http.Response> _executeRequest(HttpRequestConfig config) async {
    final url = _buildUrl(config.url, config.queryParameters);
    final headers = _buildHeaders(config);
    final timeout = config.timeout ?? _defaultTimeout;

    switch (config.method) {
      case HttpMethod.get:
        return _client.get(Uri.parse(url), headers: headers).timeout(timeout);

      case HttpMethod.post:
        return _client
            .post(
              Uri.parse(url),
              headers: headers,
              body: config.body != null ? jsonEncode(config.body) : null,
            )
            .timeout(timeout);

      case HttpMethod.put:
        return _client
            .put(
              Uri.parse(url),
              headers: headers,
              body: config.body != null ? jsonEncode(config.body) : null,
            )
            .timeout(timeout);

      case HttpMethod.delete:
        return _client
            .delete(Uri.parse(url), headers: headers)
            .timeout(timeout);

      case HttpMethod.patch:
        return _client
            .patch(
              Uri.parse(url),
              headers: headers,
              body: config.body != null ? jsonEncode(config.body) : null,
            )
            .timeout(timeout);
    }
  }

  /// Build complete URL with query parameters
  String _buildUrl(String endpoint, Map<String, dynamic>? queryParams) {
    final baseUrl =
        endpoint.startsWith('http') ? endpoint : '$_baseUrl$endpoint';

    if (queryParams == null || queryParams.isEmpty) {
      return baseUrl;
    }

    final uri = Uri.parse(baseUrl);
    final newUri = uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        ...queryParams.map((key, value) => MapEntry(key, value.toString())),
      },
    );

    return newUri.toString();
  }

  /// Build request headers
  Map<String, String> _buildHeaders(HttpRequestConfig config) {
    final headers = Map<String, String>.from(_globalHeaders);

    // Add auth token if required and available
    if (config.requiresAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    // Add custom headers
    if (config.headers != null) {
      headers.addAll(config.headers!);
    }

    return headers;
  }

  /// Handle successful response
  HttpResult<T> _handleSuccessResponse<T>(
    http.Response response,
    T Function(dynamic) parser,
  ) {
    try {
      if (response.body.isEmpty) {
        // Handle empty success response
        return HttpResult.success(
          parser({}),
          statusCode: response.statusCode,
        );
      }

      final jsonData = jsonDecode(response.body);
      final parsedData = parser(jsonData);

      return HttpResult.success(
        parsedData,
        statusCode: response.statusCode,
        headers: response.headers,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Parsing error: $e');
        print('📄 Response body: ${response.body}');
      }
      return HttpResult.error('Failed to parse response: $e');
    }
  }

  /// Handle client error (4xx)
  HttpResult<T> _handleClientError<T>(http.Response response) {
    try {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final errorMessage = jsonData['message'] ??
          jsonData['error'] ??
          'Client error: ${response.statusCode}';

      return HttpResult.error(
        errorMessage.toString(),
        statusCode: response.statusCode,
        headers: response.headers,
      );
    } catch (e) {
      return HttpResult.error(
        'Client error: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Upload file with progress tracking
  Future<HttpResult<T>> uploadFile<T>({
    required String endpoint,
    required File file,
    required String fieldName,
    required T Function(dynamic) parser,
    Map<String, String>? additionalFields,
    Map<String, String>? headers,
  }) async {
    try {
      if (kDebugMode) {
        print('📤 Uploading file: ${file.path}');
        print('📊 File size: ${await file.length()} bytes');
      }

      final url = _buildUrl(endpoint, null);
      final request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      final requestHeaders = _buildHeaders(
        HttpRequestConfig(
          url: endpoint,
          method: HttpMethod.post,
          headers: headers,
        ),
      );
      request.headers.addAll(requestHeaders);

      // Add file
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();
      final multipartFile = http.MultipartFile(
        fieldName,
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Add additional fields
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      // Send request with progress tracking
      final streamedResponse = await _client.send(request);

      // Convert to regular response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _handleSuccessResponse<T>(response, parser);
      } else {
        return _handleClientError<T>(response);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ File upload error: $e');
      }
      return HttpResult.error('File upload failed: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
    if (kDebugMode) {
      print('🧹 HTTP client disposed');
    }
  }
}
