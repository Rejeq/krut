import 'package:track_dev/core/models/auth_session.dart';
import 'package:track_dev/core/repository/auth.dart';
import 'package:track_dev/data/map/auth_session.dart';
import 'package:track_dev/data/source/local/local_storage_source.dart';
import 'package:track_dev/data/source/redmine/auth/auth_session.dart';
import 'package:track_dev/data/source/redmine/auth/credentials.dart';
import 'package:track_dev/data/source/redmine/redmine_api_source.dart';
import 'package:track_dev/data/source/redmine/models/shared.dart';
import 'package:track_dev/data/source/redmine/models/error.dart';
import 'package:track_dev/data/map/error.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalStorageSource _localStorage;
  final RedmineApiSource _apiSource;
  final RedmineSessionStore _sessionStore;

  AuthRepositoryImpl({
    required this._localStorage,
    required this._apiSource,
    required this._sessionStore,
  });

  // TODO: Servename formatter
  // Uri? formatBaseUrl(String servername) {
  //   final raw = servername.trim();
  //   if (raw.isEmpty) return null;
  //
  //   final parsed = Uri.tryParse(raw);
  //   if (parsed == null) return null;
  //
  //   final base = parsed.hasScheme
  //       ? parsed
  //       : Uri.tryParse('https://$raw');
  //
  //   if (base == null || !base.hasAuthority) return null;
  //
  //   final path = base.path.endsWith('/')
  //       ? '${base.path}issues.json'
  //       : '${base.path}/issues.json';
  //
  //   return base.replace(
  //     path: path,
  //     queryParameters: const <String, String>{},
  //     fragment: '',
  //   );
  // }

  @override
  Future<bool> isServerValid(String servername) {
    // TODO: Validate that servername is correctly formated
    return _apiSource.checkBeacon(servername);
  }

  @override
  Future<AuthSession?> currentSession() async {
    final session = await _sessionStore.read();
    return session?.toDomain();
  }

  @override
  Future<AuthSession> signInWithBasic(
    String servername,
    String username,
    String password, {
    bool furtherUseApiKey = true,
  }) async {
    try {
      // TODO: Validate that servername is correctly formated
      final session = RedmineAuthSession(
        baseUrl: servername,
        credentials: RedmineBasicAuthCredentials(
          username: username,
          password: password,
        ),
      );

      await _sessionStore.write(session);
      final redmineUser = await _currentUser();
      if (redmineUser == null) {
        await signOut();
        throw const RedmineApiException(
          'Basic authentication failed',
          SessionExpiredErrorKind(),
        );
      }

      await _setLastLoggedUsername(username);

      if (furtherUseApiKey && redmineUser.apiKey != null) {
        try {
          return await signInWithApiKey(servername, redmineUser.apiKey!);
        } catch (_) {
          // Fallback to basic auth session if API key sign in fails
          await _sessionStore.write(session);
        }
      }

      await _setLastLoggedServername(servername);
      return session.toDomain();
    } on RedmineApiException catch (e) {
      throw AuthException(e.message, mapAuthKind(e.kind), cause: e);
    }
  }

  @override
  Future<AuthSession> signInWithApiKey(
    String servername,
    String apiKey,
  ) async {
    try {
      // TODO: Validate that servername is correctly formated
      final session = RedmineAuthSession(
        baseUrl: servername,
        credentials: RedmineApiKeyCredentials(apiKey: apiKey),
      );

      await _sessionStore.write(session);
      final redmineUser = await _currentUser();
      if (redmineUser == null) {
        await signOut();
        throw const RedmineApiException(
          'API key authentication failed',
          NotFoundErrorKind(),
        );
      }

      await _setLastLoggedServername(servername);
      return session.toDomain();
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

  @override
  Future<String?> getLastLoggedServername() async {
    return _localStorage.read(_lastServernameKey);
  }

  Future<void> _setLastLoggedServername(String servername) async {
    await _localStorage.write(_lastServernameKey, servername);
  }

  Future<RedmineUser?> _currentUser() async {
    try {
      return await _apiSource.fetchCurrentUser();
    } catch (_) {
      return null;
    }
  }
}

const _lastUsernameKey = LocalStorageKeys.keyLastUsername;
const _lastServernameKey = LocalStorageKeys.keyLastServername;
