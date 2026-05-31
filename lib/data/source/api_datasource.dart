import 'package:track_dev/core/models/auth_token.dart';

abstract class ApiDataSource {
  // Auth
  Future<bool> isUserExists(String login);
  Future<AuthToken> fetchToken(String login, String password);
}
