import 'package:track_dev/core/models/auth_session.dart';
import 'package:track_dev/data/source/redmine/auth/auth_session.dart';
import 'package:track_dev/data/source/redmine/auth/credentials.dart';

extension AuthSessionMapper on RedmineAuthSession {
  AuthSession toDomain() {
    final authMethod = switch (method) {
      RedmineAuthMethod.none => AuthMethod.none,
      RedmineAuthMethod.basic => AuthMethod.basic,
      RedmineAuthMethod.apiKey => AuthMethod.apiKey,
    };

    return AuthSession(authMethod);
  }
}
