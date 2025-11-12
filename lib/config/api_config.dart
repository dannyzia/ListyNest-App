import 'package:flutter/foundation.dart';

class ApiConfig {
  // You can override the API base URL at compile time with:
  // flutter run --dart-define=API_BASE_URL=https://your-dev-or-prod/api
  static const String _envBase = String.fromEnvironment('API_BASE_URL', defaultValue: '');

  // Production default (used when no dart-define provided and in release mode)
  static const String _prodBase = 'https://adboard-backend.onrender.com/api';

  // Local development backend
  static const String devBaseUrl = 'http://localhost:5000/api';

  /// The effective base URL the app will use. Priority:
  /// 1. compile-time --dart-define API_BASE_URL
  /// 2. debug mode -> devBaseUrl
  /// 3. release mode -> _prodBase
  static String get current {
    if (_envBase.isNotEmpty) return _envBase;
    if (!kReleaseMode) return devBaseUrl;
    return _prodBase;
  }

  // Backwards-compatible accessor used elsewhere in the codebase
  static String get baseUrl => current;

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String ads = '/ads';
  static const String blogs = '/blogs';
  static const String upload = '/upload/images';
  static const String categories = '/categories';
  static const String currencies = '/currencies';
}
