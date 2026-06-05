import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/repository/preferences.dart';
import 'package:track_dev/providers/projects_provider.dart';
import 'package:track_dev/providers/stats_provider.dart';
import 'package:track_dev/ui/utils/tabbed_bottom_sheet.dart';
import 'package:track_dev/utils/value_or_null.dart';

Future<T?> showHomeFilter<T>(BuildContext context) {
  return showTabbedBottomSheet(
    context: context,
    maxHeightFactor: 0.35,
    tabs: [
      (tab: const Tab(text: 'Фильтры'), content: FilterOptions()),
      (tab: const Tab(text: 'Вид'), content: const DisplayOptions()),
    ],
  );
}

class FilterOptions extends ConsumerWidget {
  const FilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProject = ref.watch(statsProjectFilterProvider).valueOrNull;

    final projectsAsync = ref.watch(projectsProvider);
    final projects = projectsAsync.valueOrNull ?? const [];

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        RadioListTile<int?>(
          title: const Text('Все проекты'),
          value: null,
          groupValue: selectedProject?.id,
          onChanged: (_) =>
              ref.read(statsProjectFilterProvider.notifier).setProject(null),
        ),
        ...projects.map((project) {
          return RadioListTile<int?>(
            title: Text(project.name),
            value: project.id,
            groupValue: selectedProject?.id,
            onChanged: (_) => ref
                .read(statsProjectFilterProvider.notifier)
                .setProject(project),
          );
        }),
      ],
    );
  }
}

class DisplayOptions extends ConsumerWidget {
  const DisplayOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLayout =
        ref.watch(statsLayoutProvider).valueOrNull ?? StatsLayout.grid;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        RadioListTile<StatsLayout>(
          title: const Text('Сетка'),
          subtitle: const Text('Отображать карточки в две колонки'),
          value: StatsLayout.grid,
          groupValue: selectedLayout,
          onChanged: (val) {
            if (val != null) {
              ref.read(statsLayoutProvider.notifier).setLayout(val);
            }
          },
        ),
        RadioListTile<StatsLayout>(
          title: const Text('Список'),
          subtitle: const Text('Отображать карточки в одну колонку'),
          value: StatsLayout.list,
          groupValue: selectedLayout,
          onChanged: (val) {
            if (val != null) {
              ref.read(statsLayoutProvider.notifier).setLayout(val);
            }
          },
        ),
      ],
    );
  }
}
