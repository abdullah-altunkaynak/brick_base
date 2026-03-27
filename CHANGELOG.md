# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-27

### Added
- Initial release of Brick Base
- `ApiClient` - Dio-based HTTP client with interceptors
  - Automatic Bearer token injection
  - Error handling and transformation
  - Generic type-safe responses
  - Debug logging support
- `SecureStorageService` - Encrypted token storage
  - Android RSA_ECB encryption
  - iOS Keychain integration
  - Token management methods
- `AppException` hierarchy
  - `ApiException` - API/network errors
  - `AuthException` - Authentication errors
  - `StorageException` - Storage operation errors
  - `ParseException` - Serialization errors
- `BuildContext` extensions
  - Screen dimensions and breakpoints
  - Device type detection (mobile, tablet, desktop)
  - Safe navigation helpers
  - Dialog, snackbar, and bottom sheet shortcuts
- `String` extensions
  - Email validation
  - String capitalization
  - Null/empty checks
- `DateTime` extensions (foundation)
- Comprehensive documentation and examples

### Features
- Production-ready code
- Type-safe implementations
- Comprehensive error handling
- Platform support (Android, iOS, Web, Windows, macOS, Linux)
- Fully documented API
