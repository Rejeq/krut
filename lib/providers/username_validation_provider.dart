import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/providers/auth_providers.dart';

sealed class UsernameValidationState {
  const UsernameValidationState();
}

class UsernameValidationIdle extends UsernameValidationState {
  const UsernameValidationIdle();
}

class UsernameValidationLoading extends UsernameValidationState {
  const UsernameValidationLoading();
}

class UsernameValidationSuccess extends UsernameValidationState {
  const UsernameValidationSuccess();
}

class UsernameValidationError extends UsernameValidationState {
  final String message;
  const UsernameValidationError(this.message);
}

class UsernameValidationNotifier extends Notifier<UsernameValidationState> {
  Timer? _debounceTimer;

  @override
  UsernameValidationState build() {
    ref.onDispose(() => _debounceTimer?.cancel());
    return const UsernameValidationIdle();
  }

  void validate(String username) {
    _debounceTimer?.cancel();
    if (username.isEmpty) {
      state = const UsernameValidationIdle();
      return;
    }

    state = const UsernameValidationLoading();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final repo = ref.read(authRepositoryProvider);
        final exists = await repo.isUserExists(username);
        if (exists) {
          state = const UsernameValidationSuccess();
        } else {
          state = const UsernameValidationError('Пользователь не найден');
        }
      } catch (e) {
        state = UsernameValidationError('Ошибка проверки: $e');
      }
    });
  }

  void clear() {
    _debounceTimer?.cancel();
    state = const UsernameValidationIdle();
  }
}

final usernameValidationProvider =
    NotifierProvider.autoDispose<
      UsernameValidationNotifier,
      UsernameValidationState
    >(UsernameValidationNotifier.new);
