import 'package:edumind_intro_app/feature/auth/questionnaire/model/login_response.dart';
import 'package:edumind_intro_app/product/network/config/http_request_config.dart';
import 'package:edumind_intro_app/product/network/core/core_http_client.dart';
import 'package:edumind_intro_app/product/network/http_result.dart';
import 'package:edumind_intro_app/product/state/container/product_items.dart';
import 'package:edumind_intro_app/product/utility/enum/http_method.dart';
import 'package:flutter/foundation.dart';

/// Service class for handling authentication-related API calls.
class AuthApiService {
  static final CoreHttpClient _httpClient = ProductItems.coreHttpClient;

  /// Attempts to log in a user with the provided email and password.
  static Future<HttpResult<LoginResponse>> login() async {
    try {
      const config = HttpRequestConfig(
        url: '/login',
        method: HttpMethod.post,
        body: {
          'email': 'ozgur@okumanya.com.tr',
          'password': '12345678',
        },
        requiresAuth: false, // Login doesn't require auth token
        timeout: Duration(seconds: 15),
      );

      final result = await _httpClient.request<LoginResponse>(
        config,
        parser: (dynamic json) =>
            LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      if (result.isSuccess && result.data != null) {
        // Set token in HTTP client for future requests
        _httpClient.setAuthToken(result.data!.token);

        if (kDebugMode) {
          print('✅ Login successful');
          print('🔑 Token saved and set in HTTP client');
        }
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Login service error: $e');
      }
      return HttpResult.error('Login failed: $e');
    }
  }
}
