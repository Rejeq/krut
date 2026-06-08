import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/providers/sources_provider.dart';

sealed class ValidationState {
  const ValidationState();
}

class ValidationIdle extends ValidationState {
  const ValidationIdle();
}

class ValidationLoading extends ValidationState {
  const ValidationLoading();
}

class ValidationSuccess extends ValidationState {
  const ValidationSuccess();
}

class ValidationError extends ValidationState {
  final String message;
  const ValidationError(this.message);
}

abstract class DebouncedValidationNotifier<T> extends Notifier<ValidationState> {
  Timer? _debounceTimer;

  Duration get debounceDuration => const Duration(milliseconds: 2000);

  bool isEmptyValue(T value);
  Future<ValidationState> validateValue(T value);

  @override
  ValidationState build() {
    ref.onDispose(() => _debounceTimer?.cancel());
    return const ValidationIdle();
  }

  void validate(T value) {
    _debounceTimer?.cancel();

    if (isEmptyValue(value)) {
      state = const ValidationIdle();
      return;
    }

    state = const ValidationLoading();

    _debounceTimer = Timer(debounceDuration, () async {
      try {
        state = await validateValue(value);
      } catch (e) {
        state = ValidationError('Ошибка проверки: $e');
      }
    });
  }

  void clear() {
    _debounceTimer?.cancel();
    state = const ValidationIdle();
  }
}

class ServernameValidationNotifier
    extends DebouncedValidationNotifier<String> {
  @override
  bool isEmptyValue(String value) => value.isEmpty;

  @override
  Future<ValidationState> validateValue(String servername) async {
    final repo = ref.read(authRepositoryProvider);
    final isValid = await repo.isServerValid(servername);

    return isValid
        ? const ValidationSuccess()
        : ValidationError('Проверьте подлинность адреса или включен ли REST api на сервере');
  }
}

final servernameValidationProvider =
    NotifierProvider.autoDispose<ServernameValidationNotifier, ValidationState>(
  ServernameValidationNotifier.new,
);
