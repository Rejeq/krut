import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/repository/auth.dart';
import 'package:track_dev/providers/auth_provider.dart';
import 'package:track_dev/providers/input_validator_provider.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverController = useTextEditingController();
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();

    final serverValidationState = ref.watch(servernameValidationProvider);
    final serverValidationError = useState<String?>(null);
    final usernameValidationError = useState<String?>(null);
    final passwordValidationError = useState<String?>(null);
    final submitFailed = useState<bool>(false);
    final isSubmitting = useState<bool>(false);

    useEffect(() {
      Future.microtask(() async {
        final notifier = ref.read(authStateProvider.notifier);
        final lastUsername = await notifier.lastLoggedUsername() ?? '';
        final savedServer = await notifier.lastLoggedServername() ?? '';

        if (context.mounted) {
          usernameController.text = lastUsername;
          serverController.text = savedServer;
        }
      });

      return null;
    }, const []);

    useEffect(() {
      void listener() {
        if (serverValidationError.value != null) {
          serverValidationError.value = null;
        }

        final validator = ref.read(servernameValidationProvider.notifier);
        validator.validate(serverController.text);
      }

      serverController.addListener(listener);
      return () => serverController.removeListener(listener);
    }, [serverController]);

    String? getServerErrorText() {
      if (serverValidationError.value != null) {
        return serverValidationError.value;
      }

      if (serverValidationState is ValidationError) {
        return serverValidationState.message;
      }

      return null;
    }

    useEffect(() {
      void listener() {
        if (usernameValidationError.value != null) {
          usernameValidationError.value = null;
        }
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

    Future<void> submit() async {
      FocusScope.of(context).unfocus();

      final server = serverController.text.trim();
      final username = usernameController.text.trim();
      final password = passwordController.text;

      bool isValid = true;
      if (server.isEmpty) {
        serverValidationError.value = 'Адрес сервера не может быть пустым';
        isValid = false;
      }
      if (username.isEmpty) {
        usernameValidationError.value = 'Имя пользователя не может быть пустым';
        isValid = false;
      }
      if (password.isEmpty) {
        passwordValidationError.value = 'Пароль не может быть пустым';
        isValid = false;
      }

      if (!isValid) return;

      isSubmitting.value = true;
      submitFailed.value = false;

      try {
        final authProvider = ref.read(authStateProvider.notifier);

        await authProvider.logIn(server, username, password);
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
        _ServerInput(
          controller: serverController,
          validationState: serverValidationState,
          errorText: getServerErrorText(),
        ),
        const SizedBox(height: 18),
        _UsernameInput(
          controller: usernameController,
          errorText: usernameValidationError.value,
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

class _ServerInput extends StatelessWidget {
  final TextEditingController controller;
  final ValidationState validationState;
  final String? errorText;

  const _ServerInput({
    required this.controller,
    required this.validationState,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        labelText: 'Адрес сервера Redmine',
        hintText: 'https://demo.redmine.org',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: const Icon(Icons.dns_outlined),
        suffixIcon: _buildSuffix(),
        errorText: errorText,
      ),
    );
  }

  Widget? _buildSuffix() {
    if (controller.text.isEmpty) {
      return null;
    }

    return switch (validationState) {
      ValidationLoading() => const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      ValidationSuccess() => const Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
      ),
      ValidationError(message: _) => const Icon(
        Icons.error_rounded,
        color: Colors.redAccent,
      ),
      ValidationIdle() => null,
    };
  }
}

class _UsernameInput extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const _UsernameInput({required this.controller, this.errorText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Имя пользователя',
        prefixIcon: const Icon(Icons.person_outline_rounded),
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
