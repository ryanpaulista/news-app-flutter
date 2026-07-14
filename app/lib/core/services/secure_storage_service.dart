import 'package:app/core/services/app_exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Guarda o token de acesso de forma segura (Keychain no iOS, Keystore no Android).
class SecureStorageService {
  static const _tokenKey = 'access_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (_) {
      throw const SecureStorageException();
    }
  }

  Future<String?> readToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (_) {
      throw const SecureStorageException();
    }
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (_) {
      throw const SecureStorageException();
    }
  }
}

final secureStorage = SecureStorageService();
