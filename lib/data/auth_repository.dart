import 'package:track_dev/core/models/user.dart';
import 'package:track_dev/core/repository/auth.dart';
import 'package:track_dev/data/source/local/local_storage_source.dart';
import 'package:track_dev/data/source/redmine/auth/auth_session.dart';
import 'package:track_dev/data/source/redmine/auth/credentials.dart';
import 'package:track_dev/data/source/redmine/redmine_api_source.dart';
import 'package:track_dev/data/source/redmine/models/shared.dart';
import 'package:track_dev/data/source/redmine/models/error.dart';
import 'package:track_dev/data/map/user.dart';
import 'package:track_dev/data/map/error.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalStorageSource _localStorage;
  final RedmineApiSource _apiSource;
  final RedmineSessionStore _sessionStore;

  AuthRepositoryImpl({
    required LocalStorageSource localStorage,
    required RedmineApiSource apiSource,
    required RedmineSessionStore sessionStore,
  })  : _localStorage = localStorage,
        _apiSource = apiSource,
        _sessionStore = sessionStore;

  Future<RedmineAuthSession?> currentSession() => _sessionStore.read();

  Future<RedmineUser?> currentUser() async {
    try {
      return await _apiSource.fetchCurrentUser();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<User> signInWithBasic({
    required String username,
    required String password,
    bool furtherUseApiKey = true,
  }) async {
    try {
      await _sessionStore.write(
        RedmineAuthSession(
          credentials: RedmineBasicAuthCredentials(username: username, password: password),
        ),
      );
      final redmineUser = await currentUser();
      if (redmineUser == null) {
        await signOut();
        throw const RedmineApiException('Basic authentication failed', SessionExpiredErrorKind());
      }

      await _setLastLoggedUsername(username);

      if (furtherUseApiKey && redmineUser.apiKey != null) {
        try {
          return await signInWithApiKey(apiKey: redmineUser.apiKey!);
        } catch (_) {
          // Fallback to basic auth session if API key sign in fails
          await _sessionStore.write(
            RedmineAuthSession(
              credentials: RedmineBasicAuthCredentials(username: username, password: password),
            ),
          );
        }
      }

      return redmineUser.toDomain();
    } on RedmineApiException catch (e) {
      throw AuthException(e.message, mapAuthKind(e.kind), cause: e);
    }
  }

  @override
  Future<User> signInWithApiKey({required String apiKey}) async {
    try {
      await _sessionStore.write(
        RedmineAuthSession(
          credentials: RedmineApiKeyCredentials(apiKey: apiKey),
        ),
      );
      final redmineUser = await currentUser();
      if (redmineUser == null) {
        await signOut();
        throw const RedmineApiException('API key authentication failed', NotFoundErrorKind());
      }
      return redmineUser.toDomain();
    } on RedmineApiException catch (e) {
      throw AuthException(e.message, mapAuthKind(e.kind), cause: e);
    }
  }

  @override
  Future<void> signOut() => _sessionStore.clear();

  @override
  Future<String?> getLastLoggedUsername() async {
    return _localStorage.read(_lastUsernameKey);
  }

  Future<void> _setLastLoggedUsername(String username) async {
    await _localStorage.write(_lastUsernameKey, username);
  }
}

const _lastUsernameKey = LocalStorageKeys.keyLastUsername;
