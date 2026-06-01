import 'package:track_dev/core/models/auth_token.dart';
import 'package:track_dev/core/models/user.dart';
import 'package:track_dev/core/repository/auth.dart';
import 'package:track_dev/data/source/api_datasource.dart';

class FakeApiDataSource implements ApiDataSource {
  static const _validLogin = 'admin';
  static const _validPassword = '123456';

  @override
  Future<bool> isUserExists(String login) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return login == _validLogin;
  }

  @override
  Future<AuthToken> fetchToken(String login, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (login != _validLogin) {
      throw AuthException('Пользователь не найден', UserNotFoundErrorKind());
    }

    if (password != _validPassword) {
      throw AuthException('Неверный пароль', IncorrectPasswordErrorKind());
    }

    return AuthToken(
      value: 'TOKEN_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }

  @override
  Future<User> fetchUser(String token) async {
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: '1',
      email: 'admin@example.com',
      name: 'Admin User',
    );
  }
}
