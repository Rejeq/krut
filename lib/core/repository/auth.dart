import 'package:track_dev/core/models/auth_session.dart';
import 'package:track_dev/core/models/error.dart';

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
  Future<bool> isServerValid(String servername);

  Future<AuthSession?> currentSession();

  Future<AuthSession> signInWithBasic(
    String servername,
    String username,
    String password, {
    bool furtherUseApiKey = true,
  });

  Future<AuthSession> signInWithApiKey(String servername, String apiKey);

  Future<void> signOut();

  Future<String?> getLastLoggedUsername();
  Future<String?> getLastLoggedServername();
}
