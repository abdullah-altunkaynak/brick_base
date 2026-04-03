import 'package:flutter/material.dart';
import 'package:brick_base/brick_base.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Brick Base services
  final secureStorage = SecureStorageService();
  final apiClient = ApiClient(secureStorage, baseUrl: 'https://localhost/api');

  runApp(MyApp(secureStorage: secureStorage, apiClient: apiClient));
}

class MyApp extends StatelessWidget {
  final SecureStorageService secureStorage;
  final ApiClient apiClient;

  const MyApp({
    required this.secureStorage,
    required this.apiClient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brick Base Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: ExamplePage(secureStorage: secureStorage, apiClient: apiClient),
    );
  }
}

class ExamplePage extends StatefulWidget {
  final SecureStorageService secureStorage;
  final ApiClient apiClient;

  const ExamplePage({
    required this.secureStorage,
    required this.apiClient,
    super.key,
  });

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  late SecureStorageService _storage;
  late ApiClient _apiClient;
  String _status = 'Ready';

  @override
  void initState() {
    super.initState();
    _storage = widget.secureStorage;
    _apiClient = widget.apiClient;
  }

  Future<void> _saveToken() async {
    try {
      await _storage.saveToken('example_token_123');
      setState(() => _status = '✅ Token saved securely');
    } on StorageException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    }
  }

  Future<void> _retrieveToken() async {
    try {
      final token = await _storage.getToken();
      setState(() => _status = '📄 Token: ${token ?? 'Not found'}');
    } on StorageException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    }
  }

  Future<void> _makeApiCall() async {
    try {
      // Example API call (will fail without real server, but demonstrates usage)
      setState(() => _status = '📡 Calling API...');
      // final response = await _apiClient.get<Map>('/users');
      // setState(() => _status = '✅ API Success');
      setState(
        () => _status = '📡 API client ready (set baseUrl in ApiClient)',
      );
    } on ApiException catch (e) {
      setState(() => _status = '❌ API Error: ${e.message}');
    } on AppException catch (e) {
      setState(() => _status = '❌ Error: ${e.message}');
    }
  }

  Future<void> _clearStorage() async {
    try {
      await _storage.clear();
      setState(() => _status = '🧹 Storage cleared');
    } on StorageException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Brick Base Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Responsive breakpoints display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Device Info', style: context.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Screen Width: ${context.screenWidth.toStringAsFixed(0)}px',
                    ),
                    Text('Is Mobile: ${context.isMobile}'),
                    Text('Is Tablet: ${context.isTablet}'),
                    Text('Is Desktop: ${context.isDesktop}'),
                    Text(
                      'Orientation: ${context.isPortrait ? 'Portrait' : 'Landscape'}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Status display
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Status: $_status',
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Text('Actions', style: context.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveToken,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Token'),
                ),
                ElevatedButton.icon(
                  onPressed: _retrieveToken,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Get Token'),
                ),
                ElevatedButton.icon(
                  onPressed: _makeApiCall,
                  icon: const Icon(Icons.cloud),
                  label: const Text('API Call'),
                ),
                ElevatedButton.icon(
                  onPressed: _clearStorage,
                  icon: const Icon(Icons.delete),
                  label: const Text('Clear Storage'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Feature list
            Text('Features Demonstrated', style: context.textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FeatureItem(
                      'SecureStorageService',
                      'Token & data encryption',
                    ),
                    _FeatureItem('ApiClient', 'HTTP requests with Dio'),
                    _FeatureItem('Exceptions', 'Type-safe error handling'),
                    _FeatureItem(
                      'BuildContext Extensions',
                      'Responsive UI helpers',
                    ),
                    _FeatureItem(
                      'String Extensions',
                      'Email validation, capitalize',
                    ),
                    _FeatureItem(
                      'Device Detection',
                      'Mobile/Tablet/Desktop checks',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String title;
  final String description;

  const _FeatureItem(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
