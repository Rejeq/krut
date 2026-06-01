import 'package:track_dev/core/models/auth_token.dart';
import 'package:track_dev/data/source/api_datasource.dart';
import 'package:track_dev/data/source/local_datasource.dart';
import 'package:track_dev/core/repository/auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiDataSource apiDataSource;
  final LocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.apiDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthToken> logIn(String username, String password) async {
    final token = await apiDataSource.fetchToken(username, password);
    await localDataSource.saveToken(token);
    await localDataSource.saveLastLoggedUsername(username);
    return token;
  }

  @override
  Future<void> logOut() async {
    await localDataSource.clearToken();
  }

  @override
  Future<AuthToken?> getToken() async {
    final token = await localDataSource.getCachedToken();
    if (token == null || token.isExpired) {
      return null;
    }
    return token;
  }

  @override
  Future<bool> isUserExists(String login) async {
    return apiDataSource.isUserExists(login);
  }

  @override
  Future<String?> getLastLoggedUsername() async {
    return localDataSource.getLastLoggedUsername();
  }
}
