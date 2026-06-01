import 'package:track_dev/core/models/auth_token.dart';
import 'package:track_dev/data/source/local_datasource.dart';

class FakeLocalDataSource implements LocalDataSource {
  AuthToken? _cachedToken;
  String? _lastLoggedUsername;

  @override
  Future<AuthToken?> getCachedToken() async {
    return _cachedToken;
  }

  @override
  Future<void> saveToken(AuthToken token) async {
    _cachedToken = token;
  }

  @override
  Future<void> clearToken() async {
    _cachedToken = null;
  }

  @override
  Future<String?> getLastLoggedUsername() async {
    return _lastLoggedUsername;
  }

  @override
  Future<void> saveLastLoggedUsername(String username) async {
    _lastLoggedUsername = username;
  }
}
