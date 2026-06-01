import 'package:track_dev/core/models/auth_token.dart';

sealed class AuthErrorKind {}

class NetworkErrorKind extends AuthErrorKind {
  final int? code;
  NetworkErrorKind({this.code});
}

class UserNotFoundErrorKind extends AuthErrorKind {}

class IncorrectPasswordErrorKind extends AuthErrorKind {}

class TokenExpiredErrorKind extends AuthErrorKind {}

class AuthException implements Exception {
  final AuthErrorKind kind;
  final String message;

  AuthException(this.message, this.kind);

  @override
  String toString() => 'AuthException($kind): $message';
}

abstract class AuthRepository {
  /// Authenticates the user and persists the token locally.
  Future<AuthToken> logIn(String username, String password);

  /// Clears the locally stored token.
  Future<void> logOut();

  /// Returns the locally cached token, or `null` if none / expired.
  Future<AuthToken?> getToken();

  /// Checks with the server whether [login] corresponds to an existing user.
  Future<bool> isUserExists(String login);

  /// Returns the latest logged username from local storage.
  Future<String?> getLastLoggedUsername();
}
