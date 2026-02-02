/// API Client
/// HTTP client with interceptors for auth, logging, and error handling
library api_client;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:global_trust_hub/core/api/api_config.dart';
import 'package:global_trust_hub/core/api/api_exceptions.dart';
import 'package:global_trust_hub/core/storage/secure_storage.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  final SecureStorageService _storage = SecureStorageService();

  ApiClient._() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),);

    _setupInterceptors();
  }

  factory ApiClient() {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    // Auth interceptor - attach token to requests
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        if (kDebugMode) {
          debugPrint('→ ${options.method} ${options.uri}');
        }
        
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint('← ${response.statusCode} ${response.requestOptions.uri}');
        }
        handler.next(response);
      },
      onError: (error, handler) async {
        if (kDebugMode) {
          debugPrint('✖ ${error.response?.statusCode} ${error.requestOptions.uri}');
          debugPrint('  Error: ${error.message}');
        }
        
        // Handle 401 - try to refresh token
        if (error.response?.statusCode == 401) {
          try {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the original request
              final retryResponse = await _retryRequest(error.requestOptions);
              return handler.resolve(retryResponse);
            }
          } catch (_) {
            // Refresh failed, clear tokens
            await _storage.clearAll();
          }
        }
        
        handler.next(error);
      },
    ),);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio().post(
        '${ApiConfig.apiBaseUrl}${ApiConfig.refreshToken}',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['access_token'] as String;
        await _storage.saveAccessToken(newAccessToken);
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final token = await _storage.getAccessToken();
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $token',
      },
    );

    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // Generic request methods
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return parser != null ? parser(response.data) : response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return parser != null ? parser(response.data) : response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> patch<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.patch(path, data: data);
      return parser != null ? parser(response.data) : response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> delete<T>(
    String path, {
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.delete(path);
      return parser != null ? parser(response.data) : response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException();
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data as Map<String, dynamic>?;
        final message = responseData?['detail'] as String? ?? 
                       responseData?['message'] as String? ??
                       'Request failed';
        
        switch (statusCode) {
          case 401:
            return UnauthorizedException(message: message);
          case 403:
            return ForbiddenException(message: message);
          case 404:
            return NotFoundException(message: message);
          case 422:
            return ValidationException(message: message);
          case 500:
          case 502:
          case 503:
            return ServerException(message: message);
          default:
            return ApiException(message: message, statusCode: statusCode);
        }
      
      default:
        return ApiException(message: error.message ?? 'Unknown error');
    }
  }
}
