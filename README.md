# Brick Base

[![pub package](https://img.shields.io/pub/v/brick_base.svg)](https://pub.dev/packages/brick_base)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A production-ready Flutter package providing a solid foundation for your projects with:

- 🔐 **Secure Token Management** - Encrypted storage with flutter_secure_storage
- 🌐 **API Client** - Dio-based HTTP client with interceptors and error handling
- 🚨 **Exception Hierarchy** - Type-safe exception handling with custom error types
- 🛠️ **Useful Extensions** - BuildContext, String, and DateTime utilities
- 📱 **Responsive Design Helpers** - Screen size detection (mobile, tablet, desktop)

## Features

### ApiClient
Complete HTTP client with:
- Automatic token injection via interceptors
- Error handling and transformation
- Generic type-safe responses
- Debug logging in development

### SecureStorageService
Token and sensitive data management:
- Android RSA_ECB encryption
- iOS Keychain integration
- Simple token operations

### Exception Handling
```dart
class ApiException extends AppException { }
class AuthException extends AppException { }
class StorageException extends AppException { }
class ParseException extends AppException { }
```

### Extensions
BuildContext utilities:
- `screenWidth`, `screenHeight`
- `isMobile`, `isTablet`, `isDesktop`
- Safe navigation with `safeNavigateTo`
- Easy snackbar, dialog, and bottom sheet displays

String utilities:
- `.isValidEmail`
- `.capitalize()`
- `.isNotEmpty`

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  brick_base: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Initialize in main.dart

```dart
import 'package:brick_base/brick_base.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final secureStorage = SecureStorageService();
  final apiClient = ApiClient(secureStorage);
  
  runApp(const MyApp());
}
```

### API Requests

```dart
// GET request
final user = await apiClient.get<Map>('/users/1');

// POST request
final response = await apiClient.post<Map>(
  '/users',
  data: {'name': 'John', 'email': 'john@example.com'}
);

// PUT request
await apiClient.put<Map>('/users/1', data: updateData);

// DELETE request
await apiClient.delete('/users/1');
```

### Error Handling

```dart
try {
  final data = await apiClient.get<Map>('/data');
} on AuthException catch (e) {
  // Handle authentication errors
  print('Auth error: ${e.message}');
} on ApiException catch (e) {
  // Handle API errors
  print('API error: ${e.message}');
} on AppException catch (e) {
  // Handle general app errors
  print('Error: ${e.message}');
}
```

### BuildContext Extensions

```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Screen width: ${context.screenWidth}'),
      if (context.isMobile)
        MobileView()
      else if (context.isTablet)
        TabletView()
      else
        DesktopView(),
    ],
  );
}
```

### Secure Storage

```dart
final storage = SecureStorageService();

// Save token
await storage.saveToken('user_token_here');

// Get token
final token = await storage.getToken();

// Delete
await storage.delete('token_key');
```

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Requirements

- Flutter: >= 3.16.0
- Dart: >= 3.11.0

## Configuration

### Android (AndroidManifest.xml)

```xml
<manifest ...>
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.USE_CREDENTIALS" />
</manifest>
```

### iOS (Info.plist)

```xml
<key>NSLocalNetworkUsageDescription</key>
<string>This app requires network access</string>
```

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For support, please open an issue on [GitHub](https://github.com/abdullahaltunkaynak/brick_base/issues)
