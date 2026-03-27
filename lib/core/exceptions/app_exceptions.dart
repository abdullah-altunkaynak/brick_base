/// A comprehensive exception class that can cover the entire application for complete error catching
library;

abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException({required this.message, this.code, this.originalError});

  @override
  String toString() => message;
}

/// API/Network related exceptions
class ApiException extends AppException {
  ApiException({required super.message, super.code, super.originalError});

  factory ApiException.from(dynamic error) {
    if (error is ApiException) return error;

    return ApiException(message: error.toString(), originalError: error);
  }
}

/// Authentication related exceptions
class AuthException extends AppException {
  AuthException({required super.message, super.code, super.originalError});

  factory AuthException.invalidCredentials() {
    return AuthException(
      message: 'Invalid email or password',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthException.tokenExpired() {
    return AuthException(
      message: 'Your session has expired. Please log in again.',
      code: 'TOKEN_EXPIRED',
    );
  }

  factory AuthException.unauthorized() {
    return AuthException(
      message: 'You do not have permission for this operation',
      code: 'UNAUTHORIZED',
    );
  }
}

/// Data/Storage related exceptions
class StorageException extends AppException {
  StorageException({required super.message, super.code, super.originalError});

  factory StorageException.notFound(String key) {
    return StorageException(message: '$key not found', code: 'NOT_FOUND');
  }
}

/// Generic application exception
class AppError extends AppException {
  AppError({required super.message, super.code, super.originalError});
}

/// Parse/Serialization exceptions
class ParseException extends AppException {
  ParseException({required super.message, super.code, super.originalError});

  factory ParseException.fromJson(String dataType) {
    return ParseException(
      message: '$dataType nesnesi parse edilemedi',
      code: 'PARSE_ERROR',
    );
  }
}
