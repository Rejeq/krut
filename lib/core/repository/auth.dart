import 'package:track_dev/core/models/error.dart';
import 'package:track_dev/core/models/user.dart';

sealed class AuthErrorKind {
  const AuthErrorKind();
}

final class IncorrectPasswordErrorKind extends AuthErrorKind {
  const IncorrectPasswordErrorKind();
}

final class UserNotFoundErrorKind extends AuthErrorKind {
  const UserNotFoundErrorKind();
}

final class AuthNetworkErrorKind extends AuthErrorKind {
  const AuthNetworkErrorKind({this.kind});
  final NetworkErrorKind? kind;
}

class AuthException implements Exception {
  const AuthException(this.message, this.kind, {this.cause});

  final String message;
  final AuthErrorKind kind;
  final Object? cause;

  @override
  String toString() => 'AuthException($kind): $message';
}

abstract class AuthRepository {
  Future<User> signInWithBasic({
    required String username,
    required String password,
    bool furtherUseApiKey = true,
  });

  Future<User> signInWithApiKey({required String apiKey});

  Future<void> signOut();

  Future<String?> getLastLoggedUsername();
}
