import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../exceptions/app_exceptions.dart';
import 'secure_storage.dart';

/// Dio-based API Client with token management and error handling
class ApiClient {
  static const String baseUrl = 'https://localhost/api';
  static const Duration _connectionTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  late final Dio _dio;
  final SecureStorageService _secureStorage;

  ApiClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _connectionTimeout,
        receiveTimeout: _receiveTimeout,
        contentType: 'application/json',
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_TokenInterceptor(_secureStorage));
    _dio.interceptors.add(_ErrorInterceptor());

    // Logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  /// GET request
  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw ApiException.from(e);
    }
  }

  /// POST request
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw ApiException.from(e);
    }
  }

  /// PUT request
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw ApiException.from(e);
    }
  }

  /// DELETE request
  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw ApiException.from(e);
    }
  }

  /// Handle response
  T _handleResponse<T>(Response<Map<String, dynamic>> response) {
    final statusCode = response.statusCode ?? 500;

    if (statusCode >= 200 && statusCode < 300) {
      // Success
      final data = response.data;
      if (data == null) {
        throw ApiException(message: 'Empty response received');
      }

      // API response format: { success: bool, data: T, message?: string }
      if (data['success'] == false) {
        throw ApiException(
          message: data['message'] ?? 'Request failed',
          code: data['code'],
        );
      }

      return data as T;
    } else if (statusCode == 401) {
      throw AuthException.unauthorized();
    } else if (statusCode == 403) {
      throw AuthException.unauthorized();
    } else {
      throw ApiException(
        message: 'API Error ($statusCode)',
        code: statusCode.toString(),
      );
    }
  }
}

/// Token management interceptor
class _TokenInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  _TokenInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _secureStorage.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Token could not be read, proceed
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expired, delete from storage
      try {
        await _secureStorage.delete('auth_token');
      } catch (e) {
        // Log error
      }
    }

    handler.next(err);
  }
}

/// Error handling and standardization interceptor
class _ErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Standardize error message
    String message = err.message ?? 'Unknown error';

    if (err.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout';
    } else if (err.type == DioExceptionType.receiveTimeout) {
      message = 'Response timeout exceeded';
    } else if (err.type == DioExceptionType.sendTimeout) {
      message = 'Send timeout exceeded';
    } else if (err.type == DioExceptionType.badResponse) {
      message = 'Server error: ${err.response?.statusCode}';
    } else if (err.type == DioExceptionType.unknown) {
      message = 'Check your internet connection';
    }

    // Log the error
    if (kDebugMode) {
      debugPrint('🔴 API Error: $message\n${err.toString()}');
    }

    handler.next(err);
  }
}
