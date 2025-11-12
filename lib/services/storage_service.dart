import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';
  static const String _fcmTokenKey = 'fcm_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveUser(String userData) async {
    await _storage.write(key: _userKey, value: userData);
  }

  Future<String?> getUser() async {
    return await _storage.read(key: _userKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> saveFCMToken(String token) async {
    await _storage.write(key: _fcmTokenKey, value: token);
  }

  Future<String?> getFCMToken() async {
    return await _storage.read(key: _fcmTokenKey);
  }

  Future<void> clearFCMToken() async {
    await _storage.delete(key: _fcmTokenKey);
  }
}

