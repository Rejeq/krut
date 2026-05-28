import 'package:flutter_application_1/models/auth_token.dart';
import 'package:flutter_application_1/repository/auth_repository.dart';

abstract class AuthLocalDataSource {
  Future<AuthToken?> getCachedToken();

  Future<void> saveToken(AuthToken token);

  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthToken? _cachedToken;

  @override
  Future<AuthToken?> getCachedToken() async {
    try {
      return _cachedToken;
    } catch (e) {
      throw CacheException('Ошибка чтения кэша: $e');
    }
  }

  @override
  Future<void> saveToken(AuthToken token) async {
    try {
      _cachedToken = token;
    } catch (e) {
      throw CacheException('Ошибка сохранения токена: $e');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      _cachedToken = null;
    } catch (e) {
      throw CacheException('Ошибка очистки кэша: $e');
    }
  }
}