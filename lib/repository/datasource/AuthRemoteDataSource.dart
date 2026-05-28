import 'dart:async';

import 'package:flutter_application_1/models/auth_token.dart';
import 'package:flutter_application_1/repository/auth_repository.dart';

abstract class AuthRemoteDataSource {
  Future<bool> checkUserExists(String login);

  Future<AuthToken> fetchToken({
    required String login,
    required String password,
  });
}


class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<bool> checkUserExists(String login) async {
    try {
      /// имитация запроса
      await Future.delayed(const Duration(seconds: 1));

      /// условно пользователь существует
      return login == 'admin';
    } on TimeoutException {
      throw NetworkException('Сервер не отвечает');
    } catch (e) {
      throw NetworkException('Ошибка проверки пользователя: $e');
    }
  }

  @override
  Future<AuthToken> fetchToken({
    required String login,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (login == 'admin' && password == '123456') {
        return AuthToken(
          value: 'TOKEN_123456789',
          expiresAt: DateTime.now().add(
            const Duration(hours: 1),
          ),
        );
      }

      throw AuthException('Неверный логин или пароль');
    } on TimeoutException {
      throw NetworkException('Ошибка сети');
    } catch (e) {
      throw AuthException('Ошибка авторизации: $e');
    }
  }
}
