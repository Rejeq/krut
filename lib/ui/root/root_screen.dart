import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:track_dev/ui/home/home_screen.dart';
import 'package:track_dev/ui/projects/projects_screen.dart';
import 'package:track_dev/ui/timer/timer_screen.dart';

// Индекс текущей вкладки
final selectedTabProvider = StateProvider<int>((ref) => 0);

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(selectedTabProvider);
    final notifier = ref.read(selectedTabProvider.notifier);

    final screens = const [
      HomeScreen(),
      ProjectsScreen(),
      TimerScreen(),
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
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Проекты',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Таймер',
          ),
        ],
      ),
    );
  }
}