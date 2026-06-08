import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:track_dev/providers/auth_provider.dart';
import 'package:track_dev/ui/auth/login_screen.dart';
import 'package:track_dev/ui/home/home_screen.dart';
import 'package:track_dev/ui/projects/projects_screen.dart';
import 'package:track_dev/ui/timer/timer_screen.dart';

// Index of the current tab
final selectedTabProvider = StateProvider<int>((ref) => 0);

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (session) {
        if (session != null && !session.isExpired) {
          return _AuthenticatedShell(ref: ref);
        }
        return const LoginScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => const LoginScreen(),
    );
  }
}

class _AuthenticatedShell extends StatelessWidget {
  final WidgetRef ref;

  const _AuthenticatedShell({required this.ref});

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(selectedTabProvider);
    final notifier = ref.read(selectedTabProvider.notifier);

    const screens = [
      HomeScreen(),
      TimerScreen(),
      ProjectsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          notifier.state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Таймер',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Проекты',
          ),
        ],
      ),
    );
  }
}
