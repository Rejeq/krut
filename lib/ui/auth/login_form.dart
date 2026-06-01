import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/repository/auth.dart';
import 'package:track_dev/providers/auth_providers.dart';
import 'package:track_dev/providers/username_validation_provider.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();

    final usernameValidationError = useState<String?>(null);
    final passwordValidationError = useState<String?>(null);
    final submitFailed = useState<bool>(false);
    final isSubmitting = useState<bool>(false);

    final validationState = ref.watch(usernameValidationProvider);

    useEffect(() {
      Future.microtask(() async {
        final notifier = ref.read(authStateProvider.notifier);
        final lastUsername = await notifier.lastLoggedUsername() ?? '';

        if (context.mounted) {
          usernameController.text = lastUsername;
        }
      });

      return null;
    }, const []);

    useEffect(() {
      void listener() {
        if (usernameValidationError.value != null) {
          usernameValidationError.value = null;
        }

        final validator = ref.read(usernameValidationProvider.notifier);
        validator.validate(usernameController.text);
      }

      usernameController.addListener(listener);
      return () => usernameController.removeListener(listener);
    }, [usernameController]);

    useEffect(() {
      void listener() {
        if (passwordValidationError.value != null) {
          passwordValidationError.value = null;
        }
        if (submitFailed.value) {
          submitFailed.value = false;
        }
      }

      passwordController.addListener(listener);
      return () => passwordController.removeListener(listener);
    }, [passwordController]);

    String? getUsernameErrorText() {
      if (usernameValidationError.value != null) {
        return usernameValidationError.value;
      }
      if (validationState is UsernameValidationError) {
        return validationState.message;
      }
      return null;
    }

    Future<void> submit() async {
      FocusScope.of(context).unfocus();

      final username = usernameController.text.trim();
      final password = passwordController.text;

      bool isValid = true;
      if (username.isEmpty) {
        usernameValidationError.value = 'Имя пользователя не может быть пустым';
        isValid = false;
      }
      if (password.isEmpty) {
        passwordValidationError.value = 'Пароль не может быть пустым';
        isValid = false;
      }

      if (validationState is UsernameValidationError) {
        isValid = false;
      }

      if (!isValid) return;

      isSubmitting.value = true;
      submitFailed.value = false;

      try {
        await ref.read(authStateProvider.notifier).logIn(username, password);
      } on AuthException catch (e) {
        submitFailed.value = true;

        switch (e.kind) {
          case UserNotFoundErrorKind():
            usernameValidationError.value = e.message;
          case IncorrectPasswordErrorKind():
            passwordValidationError.value = e.message;
          default:
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.message),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
        }
      } catch (e) {
        submitFailed.value = true;

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Произошла неизвестная ошибка: $e'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        isSubmitting.value = false;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _UsernameInput(
          controller: usernameController,
          validationState: validationState,
          errorText: getUsernameErrorText(),
        ),
        const SizedBox(height: 18),
        _PasswordInput(
          controller: passwordController,
          errorText: passwordValidationError.value,
          onSubmitted: submit,
        ),
        const SizedBox(height: 32),
        _SubmitButton(
          onPressed: isSubmitting.value ? null : submit,
          isSubmitting: isSubmitting.value,
          submitFailed: submitFailed.value,
        ),
      ],
    );
  }
}

class _UsernameInput extends StatelessWidget {
  final TextEditingController controller;
  final UsernameValidationState validationState;
  final String? errorText;

  const _UsernameInput({
    required this.controller,
    required this.validationState,
    this.errorText,
  });

  Widget? _buildSuffix() {
    if (controller.text.isEmpty) return null;

    return switch (validationState) {
      UsernameValidationLoading() => const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      UsernameValidationSuccess() => const Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
      ),
      UsernameValidationError() => const Icon(
        Icons.error_rounded,
        color: Colors.redAccent,
      ),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Имя пользователя',
        prefixIcon: const Icon(Icons.person_outline_rounded),
        suffixIcon: _buildSuffix(),
        errorText: errorText,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final VoidCallback onSubmitted;

  const _PasswordInput({
    required this.controller,
    required this.errorText,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => onSubmitted(),
      decoration: InputDecoration(
        labelText: 'Пароль',
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        errorText: errorText,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isSubmitting;
  final bool submitFailed;

  const _SubmitButton({
    required this.onPressed,
    required this.isSubmitting,
    required this.submitFailed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 56,
      decoration: BoxDecoration(
        color: submitFailed ? errorColor : primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (submitFailed ? errorColor : primaryColor).withValues(
              alpha: 0.3,
            ),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Войти',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
