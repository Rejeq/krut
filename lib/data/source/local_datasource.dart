import 'package:track_dev/core/models/auth_token.dart';

abstract class LocalDataSource {
  Future<AuthToken?> getCachedToken();
  Future<void> saveToken(AuthToken token);
  Future<void> clearToken();

  Future<String?> getLastLoggedUsername();
  Future<void> saveLastLoggedUsername(String username);
}
