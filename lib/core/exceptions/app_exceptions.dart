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

  /// Smart error message extractor.
  /// Dynamically captures the backend message (whether it is a String or a JSON Map)
  /// at runtime without creating dependencies on underlying HTTP libraries (like Dio).
  String get backendMessage {
    final err = originalError;
    if (err == null) return message;

    try {
      // Step 1: Check if the object has a 'response' field and it is not null (e.g., DioException)
      // Dart dynamic invocations throw NoSuchMethodError or TypeError if the field does not exist.
      final dynamic dynamicError = err;
      final dynamic response = dynamicError.response;

      if (response != null) {
        final dynamic data = response.data;
        if (data != null) {
          // Scenario A: Backend returns the error as a JSON object containing a 'message' key
          if (data is Map && data.containsKey('message')) {
            return data['message'].toString();
          }
          // Scenario B: Backend returns the error directly as a plain text String
          return data.toString();
        }
      }

      // Step 2: If there is no response, check if the library itself generated an error message (e.g., dioError.message)
      final dynamic msg = dynamicError.message;
      if (msg != null) {
        return msg.toString();
      }
    } catch (_) {
      // If any error occurs during dynamic property resolution (e.g., field not found),
      // it silently falls through to the default message below.
    }

    // Returns the default system message if no specific backend message could be extracted
    // from the originalError.
    return message;
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
      message: '$dataType The object could not be parsed.',
      code: 'PARSE_ERROR',
    );
  }
}
