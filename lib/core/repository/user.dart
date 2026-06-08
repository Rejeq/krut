import 'package:track_dev/core/models/error.dart';
import 'package:track_dev/core/models/user.dart';

sealed class UserErrorKind {
  const UserErrorKind();
}

final class CurrentUserUnavailableErrorKind extends UserErrorKind {
  const CurrentUserUnavailableErrorKind();
}

final class UserNetworkErrorKind extends UserErrorKind {
  const UserNetworkErrorKind({this.kind});
  final NetworkErrorKind? kind;
}

class UserException implements Exception {
  const UserException(this.message, this.kind, {this.cause});

  final String message;
  final UserErrorKind kind;
  final Object? cause;

  @override
  String toString() => 'UserException($kind): $message';
}

abstract class UserRepository {
  Future<User> fetchCurrentUser();
}
