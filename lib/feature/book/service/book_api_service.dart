import 'package:edumind_intro_app/feature/book/model/book/book_response.dart';
import 'package:edumind_intro_app/feature/book/model/book_page/book_page_response.dart';
import 'package:edumind_intro_app/product/network/config/http_request_config.dart';
import 'package:edumind_intro_app/product/network/core/core_http_client.dart';
import 'package:edumind_intro_app/product/network/http_result.dart';
import 'package:edumind_intro_app/product/state/container/product_items.dart';
import 'package:edumind_intro_app/product/utility/enum/http_method.dart';
import 'package:flutter/foundation.dart';

/// Service class for handling book-related API calls.
class BookApiService {
  static final CoreHttpClient _httpClient = ProductItems.coreHttpClient;

  /// Fetches a list of books based on the provided categories and levels.
  static Future<HttpResult<BooksResponse>> getBooks({
    required List<int> categories,
    required List<String> levels,
  }) async {
    try {
      if (kDebugMode) {
        print('📚 Fetching books with filters:');
        print('   Categories: $categories');
        print('   Levels: $levels');
      }

      final config = HttpRequestConfig(
        url: '/books/search',
        method: HttpMethod.post,
        body: {
          'category': categories,
          'level': levels,
        },
        timeout: const Duration(seconds: 20),
        retryDelay: const Duration(seconds: 2),
      );

      final result = await _httpClient.request<BooksResponse>(
        config,
        parser: (json) => BooksResponse.fromJson(json as Map<String, dynamic>),
      );

      if (result.isSuccess && result.data != null) {
        if (kDebugMode) {
          print('✅ Books fetched successfully');
          print('📊 Found ${result.data!.count} books');
        }
      } else {
        if (kDebugMode) {
          print('❌ Books fetch failed: ${result.errorMessage}');
        }

        return HttpResult.error('Failed to fetch books: ${result.errorMessage}',
            statusCode: result.statusCode);
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Books service error: $e');
      }
      return HttpResult.error('Failed to fetch books: $e');
    }
  }

  /// Fetches pages for a specific book by its ID.
  static Future<HttpResult<BookPagesResponse>> getBookPages(
      {required int bookId}) async {
    try {
      if (kDebugMode) {
        print('📖 Fetching pages for book ID: $bookId');
      }

      final config = HttpRequestConfig(
        url: '/books/pages/$bookId',
        method: HttpMethod.get,
        timeout: const Duration(seconds: 25),
      );

      final result = await _httpClient.request<BookPagesResponse>(
        config,
        parser: (json) {
          if (kDebugMode) {
            print('🔍 API Response Type: ${json.runtimeType}');
            print('🔍 API Response: $json');
          }

          if (json is List) {
            return BookPagesResponse.fromJson(json);
          } else if (json is Map<String, dynamic> &&
              json.containsKey('pages')) {
            return BookPagesResponse.fromJson(json['pages'] as List);
          } else {
            throw FormatException(
                'Unexpected response format: ${json.runtimeType}, data: $json');
          }
        },
      );

      if (result.isSuccess && result.data != null) {
        if (kDebugMode) {
          print('✅ Book pages fetched successfully');
          print('📊 Found ${result.data!.count} pages');
          print('📝 Text pages: ${result.data!.textPagesCount}');
          print('🔊 Audio pages: ${result.data!.audioPagesCount}');
        }
      } else {
        if (kDebugMode) {
          print('❌ Book pages fetch failed: ${result.errorMessage}');
        }
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Book pages service error: $e');
      }
      return HttpResult.error('Failed to fetch book pages: $e');
    }
  }
}
