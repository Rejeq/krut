import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_dev/core/models/auth_token.dart';
import 'package:track_dev/core/repository/auth.dart';
import 'package:track_dev/data/auth_repository.dart';
import 'package:track_dev/data/source/api_datasource.dart';
import 'package:track_dev/data/source/fake_api_datasource.dart';
import 'package:track_dev/data/source/local_datasource.dart';
import 'package:track_dev/data/source/shared_prefs_local_datasource.dart';

final sharedPreferencesAsyncProvider = Provider<SharedPreferencesAsync>((ref) {
  return SharedPreferencesAsync();
});

final apiDataSourceProvider = Provider<ApiDataSource>(
  (ref) => FakeApiDataSource(),
);

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return SharedPreferencesLocalDataSource(ref.watch(sharedPreferencesAsyncProvider));
});


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    apiDataSource: ref.watch(apiDataSourceProvider),
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

class AuthStateNotifier extends AsyncNotifier<AuthToken?> {
  @override
  Future<AuthToken?> build() async {
    return ref.read(authRepositoryProvider).getToken();
  }

  Future<void> logIn(String username, String password) async {
    final result = await AsyncValue.guard(() async {
      return ref.read(authRepositoryProvider).logIn(username, password);
    });

    state = result;

    if (state.hasError) {
      final err = state.error;
      if (err is AuthException && err.kind is TokenExpiredErrorKind) {
        await logOut();
      }

      throw state.error!;
    }
  }

  Future<void> logOut() async {
    await ref.read(authRepositoryProvider).logOut();
    state = const AsyncData(null);
  }

  Future<String?> lastLoggedUsername() async {
    return await ref.read(authRepositoryProvider).getLastLoggedUsername();
  }

  Future<void> handleTokenExpired() async {
    await logOut();
  }
}

final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, AuthToken?>(
  AuthStateNotifier.new,
);
