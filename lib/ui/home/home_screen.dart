import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:track_dev/core/models/project.dart';
import 'package:track_dev/core/repository/preferences.dart';
import 'package:track_dev/core/usecase/stats.dart';
import 'package:track_dev/providers/auth_provider.dart';
import 'package:track_dev/providers/stats_provider.dart';
import 'package:track_dev/providers/user_provider.dart';
import 'package:track_dev/ui/home/detailed_list.dart';
import 'package:track_dev/ui/home/filter.dart';
import 'package:track_dev/ui/home/stat_card.dart';
import 'package:track_dev/ui/home/work_hours_chart.dart';
import 'package:track_dev/ui/root/root_screen.dart';
import 'package:track_dev/utils/value_or_null.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStateProvider);
    final statsAsync = ref.watch(statsStateProvider);
    final layoutAsync = ref.watch(statsLayoutProvider);

    final user = userAsync.valueOrNull;
    final displayName = user?.firstname ?? user?.login ?? 'Пользователь';

    final theme = Theme.of(context);

    // Show error to the user in case of statsAsync failed with the error
    if (statsAsync.hasError && !statsAsync.isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка загрузки статистики',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${statsAsync.error}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(statsStateProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Повторить'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(authStateProvider.notifier).logOut();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Выйти'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final isLoading = statsAsync.isLoading;
    final statsState = statsAsync.valueOrNull;
    final layout = layoutAsync.valueOrNull ?? StatsLayout.grid;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        // TODO: Wrap with `Skeleton.keep` widgets that have static state
        child: Skeletonizer(
          enabled: isLoading,
          child: _HomeBody(
            username: displayName,
            stats: statsState?.stats ?? _placeholderStats,
            layout: layout,
            projectFilter: statsState?.projectFilter,
            start:
                statsState?.start ??
                DateTime.now().subtract(const Duration(days: 7)),
            end: statsState?.end ?? DateTime.now(),
            onTotalHoursClick: () {
              ref.read(selectedTabProvider.notifier).state =
                  2; // Switch to Timer tab
            },
            onCompletedTasksClick: () {
              ref.read(selectedTabProvider.notifier).state =
                  1; // Switch to Projects tab
            },
            onPendingTasksClick: () {
              ref.read(selectedTabProvider.notifier).state =
                  1; // Switch to Projects tab
            },
            onWorkingDaysClick: () {
              ref.read(selectedTabProvider.notifier).state =
                  2; // Switch to Timer tab
            },
            onSwipeChart: statsState == null
                ? null
                : (newRange) {
                    ref
                        .read(statsStateProvider.notifier)
                        .periodStats(
                          newRange.start,
                          newRange.end,
                          statsState.projectFilter,
                        );
                  },
            onFilter: () {
              showHomeFilter<void>(context);
            },
            onLogout: () {
              ref.read(authStateProvider.notifier).logOut();
            },
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final String username;
  final Stats stats;
  final StatsLayout layout;
  final Project? projectFilter;
  final DateTime start;
  final DateTime end;
  final VoidCallback onTotalHoursClick;
  final VoidCallback onCompletedTasksClick;
  final VoidCallback onPendingTasksClick;
  final VoidCallback onWorkingDaysClick;
  final OnSwipeTimeWindow? onSwipeChart;
  final VoidCallback onFilter;
  final VoidCallback onLogout;

  const _HomeBody({
    required this.username,
    required this.stats,
    required this.layout,
    required this.projectFilter,
    required this.start,
    required this.end,
    required this.onTotalHoursClick,
    required this.onCompletedTasksClick,
    required this.onPendingTasksClick,
    required this.onWorkingDaysClick,
    required this.onSwipeChart,
    required this.onFilter,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateRangeStr = '${_formatDate(start)} - ${_formatDate(end)}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            username: username,
            projectFilter: projectFilter,
            onFilter: onFilter,
            onLogout: onLogout,
          ),
          const SizedBox(height: 20),
          HomeStatCards(
            stats: stats,
            layout: layout,
            onTotalHoursClick: onTotalHoursClick,
            onCompletedTasksClick: onCompletedTasksClick,
            onPendingTasksClick: onPendingTasksClick,
            onWorkingDaysClick: onWorkingDaysClick,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Рабочие часы',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              // TODO: The dateRangeStr should be showed in the header, like project filter
              Text(
                dateRangeStr,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          WorkHoursChart(
            data: stats.workHoursPerDay,
            range: DateTimeRange(start: start, end: end),
            onSwipe: onSwipeChart,
            // onClick: () {
            //   // TODO: When the date is clicked, DetailedList should show data
            //   // in that specific day
            // },
          ),
          const SizedBox(height: 24),
          Text(
            'Задачи',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          DetailedList(data: stats.workHoursPerDay),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'янв',
      'фев',
      'мар',
      'апр',
      'май',
      'июн',
      'июл',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _Header extends StatelessWidget {
  final String username;
  final Project? projectFilter;
  final VoidCallback onFilter;
  final VoidCallback onLogout;

  const _Header({
    required this.username,
    required this.projectFilter,
    required this.onFilter,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.logout), onPressed: onLogout),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Привет,',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    username,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (projectFilter != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              projectFilter!.name,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        IconButton(onPressed: onFilter, icon: const Icon(Icons.filter_list)),
      ],
    );
  }
}

/// Placeholder stats used to render the skeleton layout while loading.
final _placeholderStats = Stats(
  totalWorkHours: 0,
  completedTasks: 0,
  pendingTasks: 0,
  workHoursPerDay: Map.fromEntries(
    List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final normalizedDate = DateTime(date.year, date.month, date.day);
      return MapEntry(
        normalizedDate,
        const DayStats(total: 0, workHoursPerIssue: []),
      );
    }),
  ),
);
