import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/providers/task_selector_provider.dart';

/// A bottom sheet with filter and sort options for the task selector.
class TaskFilterSortSheet extends ConsumerWidget {
  const TaskFilterSortSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectorState = ref.watch(taskSelectorProvider);
    final notifier = ref.read(taskSelectorProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Фильтр',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _FilterChipRow(
              selected: selectorState.filterMode,
              onSelected: notifier.setFilterMode,
            ),
            const Divider(height: 24),

            // Sort section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Сортировка',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _SortOptionTile(
              title: 'По имени (А → Я)',
              icon: Icons.sort_by_alpha_rounded,
              isSelected: selectorState.sortMode == TaskSortMode.nameAsc,
              onTap: () => notifier.setSortMode(TaskSortMode.nameAsc),
            ),
            _SortOptionTile(
              title: 'По имени (Я → А)',
              icon: Icons.sort_by_alpha_rounded,
              isSelected: selectorState.sortMode == TaskSortMode.nameDesc,
              onTap: () => notifier.setSortMode(TaskSortMode.nameDesc),
            ),
            _SortOptionTile(
              title: 'Сначала новые',
              icon: Icons.arrow_downward_rounded,
              isSelected: selectorState.sortMode == TaskSortMode.updatedDesc,
              onTap: () => notifier.setSortMode(TaskSortMode.updatedDesc),
            ),
            _SortOptionTile(
              title: 'Сначала старые',
              icon: Icons.arrow_upward_rounded,
              isSelected: selectorState.sortMode == TaskSortMode.updatedAsc,
              onTap: () => notifier.setSortMode(TaskSortMode.updatedAsc),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChipRow extends StatelessWidget {
  const _FilterChipRow({
    required this.selected,
    required this.onSelected,
  });

  final TaskFilterMode selected;
  final ValueChanged<TaskFilterMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        _buildChip(context, TaskFilterMode.all, 'Все'),
        _buildChip(context, TaskFilterMode.projectsOnly, 'Проекты'),
        _buildChip(context, TaskFilterMode.issuesOnly, 'Задачи'),
      ],
    );
  }

  Widget _buildChip(BuildContext context, TaskFilterMode mode, String label) {
    return FilterChip(
      label: Text(label),
      selected: selected == mode,
      onSelected: (_) => onSelected(mode),
      showCheckmark: false,
    );
  }
}

class _SortOptionTile extends StatelessWidget {
  const _SortOptionTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(
        icon,
        size: 20,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_rounded, size: 18, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}

/// Convenience function to show the filter/sort sheet.
Future<void> showTaskFilterSortSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (_) => const TaskFilterSortSheet(),
  );
}
