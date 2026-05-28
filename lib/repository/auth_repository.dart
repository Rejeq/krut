import 'dart:async';

import 'package:flutter_application_1/models/auth_token.dart';
import 'package:flutter_application_1/repository/datasource/AuthLocalDataSource.dart';
import 'package:flutter_application_1/repository/datasource/AuthRemoteDataSource.dart';

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class NetworkException extends AuthException {
  NetworkException(super.message);
}

class CacheException extends AuthException {
  CacheException(super.message);
}

class UserNotFoundException extends AuthException {
  UserNotFoundException(super.message);
}

/// =========================
/// REPOSITORY
/// =========================

abstract class AuthRepository {
  Future<bool> userExists(String login);

  Future<AuthToken> getToken({
    required String login,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Проверка существования пользователя
  @override
  Future<bool> userExists(String login) async {
    try {
      return await remoteDataSource.checkUserExists(login);
    } on TimeoutException {
      throw NetworkException('Сервер не отвечает');
    } catch (e) {
      throw AuthException('Ошибка проверки пользователя: $e');
    }
  }

  /// Получение токена:
  /// 1. Сначала пробуем взять из кэша
  /// 2. Если нет или просрочен — идем в сеть
  @override
  Future<AuthToken> getToken({
    required String login,
    required String password,
  }) async {
    try {
      final newToken = await remoteDataSource.fetchToken(
        login: login,
        password: password,
      );

      await localDataSource.saveToken(newToken);

      return newToken;
    } on TimeoutException {
      throw NetworkException('Ошибка сети');
    } on UserNotFoundException {
      rethrow;
    } catch (e) {
      throw AuthException('Ошибка авторизации: $e');
    }
  }
}