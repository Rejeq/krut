import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/auth_session.dart';
import 'package:track_dev/core/models/error.dart';
import 'package:track_dev/core/repository/auth.dart';
import 'package:track_dev/providers/sources_provider.dart';

class AuthStateNotifier extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    return ref.read(authRepositoryProvider).currentSession();
  }

  Future<void> logIn(
    String servername,
    String username,
    String password,
  ) async {
    final result = await AsyncValue.guard(() async {
      return ref
          .read(authRepositoryProvider)
          .signInWithBasic(
            servername,
            username,
            password,
            furtherUseApiKey: true,
          );
    });

    state = result;

    if (state.hasError) {
      final err = state.error;
      if (err is AuthException && err.kind is UnauthorizedErrorKind) {
        await logOut();
      }

      throw state.error!;
    }
  }

  Future<void> logOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }

  Future<String?> lastLoggedUsername() async {
    return await ref.read(authRepositoryProvider).getLastLoggedUsername();
  }

  Future<String?> lastLoggedServername() async {
    return await ref.read(authRepositoryProvider).getLastLoggedServername();
  }

  Future<void> handleUnauthorized() async {
    await logOut();
  }
}

final authStateProvider =
    AsyncNotifierProvider<AuthStateNotifier, AuthSession?>(
      AuthStateNotifier.new,
    );
