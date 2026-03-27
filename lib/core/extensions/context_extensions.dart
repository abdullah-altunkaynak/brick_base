import 'package:flutter/material.dart';

/// BuildContext extensions for safe usage and theming
extension BuildContextX on BuildContext {
  /// Screen dimensions
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  /// Safe context check
  bool get isMounted => mounted;

  /// Theme data
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  /// Media query
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Responsive breakpoints
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  /// Safe navigation
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) async {
    if (!mounted) return null;
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  void pop<T>([T? result]) {
    if (mounted) {
      Navigator.of(this).pop(result);
    }
  }

  /// Safe snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration, action: action),
    );
  }

  /// Safe dialog
  Future<T?> showCustomDialog<T>({
    required WidgetBuilder builder,
    bool isDismissible = true,
  }) async {
    if (!mounted) return null;

    final ctx = this;
    return showDialog<T>(
      context: ctx,
      builder: builder,
      barrierDismissible: isDismissible,
    );
  }

  /// Safe bottom sheet
  Future<T?> showCustomBottomSheet<T>({
    required WidgetBuilder builder,
    bool isDismissible = true,
  }) async {
    if (!mounted) return null;

    final ctx = this;
    return showModalBottomSheet<T>(
      context: ctx,
      builder: builder,
      isDismissible: isDismissible,
      isScrollControlled: true,
    );
  }
}

/// String extensions
extension StringX on String {
  /// Email validation
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is empty or null
  bool get isEmpty => trim().isEmpty;
  bool get isNotEmpty => this.isNotEmpty;

  /// Capitalize first letter
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');
}

/// DateTime extensions
extension DateTimeX on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Format as HH:mm
  String get formattedTime =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// Format as dd/MM/yyyy
  String get formattedDate =>
      '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
}

/// Duration extensions
extension DurationX on Duration {
  /// Format as HH:mm:ss
  String get formatted {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Format as timer (mm:ss)
  String get formattedTimer {
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Num extensions
extension NumX on num {
  /// Format as currency
  String get asCurrency => '₺${toStringAsFixed(2)}';

  /// Format with thousand separators
  String get formatted {
    return toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}

/// List extensions
extension ListX<T> on List<T> {
  /// Check if list is empty
  bool get isEmpty => length == 0;
  bool get isNotEmpty => this.isNotEmpty;

  /// Get first item safely
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last item safely
  T? get lastOrNull => isEmpty ? null : last;
}
