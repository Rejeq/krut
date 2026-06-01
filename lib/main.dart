import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/providers/auth_providers.dart';
import 'package:track_dev/ui/auth/login_screen.dart';
import 'package:track_dev/ui/home/home_screen.dart';
import 'package:track_dev/ui/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'TrackDev',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: authState.when(
        data: (token) {
          if (token != null && !token.isExpired) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stack) => const LoginScreen(),
      ),
    );
  }
}
