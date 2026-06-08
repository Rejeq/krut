import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/project.dart';
import 'package:track_dev/core/usecase/project_stats.dart';
import 'package:track_dev/providers/projects_provider.dart';
import 'package:track_dev/utils/value_or_null.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsStatsAsync = ref.watch(projectsStatsProvider);
    final projectsStats = projectsStatsAsync.valueOrNull ?? const [];

    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projectsStats.length,
        itemBuilder: (context, index) {
          final project = projectsStats[index];
          return ProjectCard(stats: project);
        },
      ),
    ),);
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectStats stats;

  const ProjectCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),
        title: Text(
          stats.project.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Выполнено: ${stats.completed} | В ожидании: ${stats.pending}',
        ),
        children: [
          const Divider(),

          _InfoRow(
            icon: Icons.check_circle_outline,
            title: 'Выполненные задачи',
            value: '${stats.completed}',
          ),

          _InfoRow(
            icon: Icons.pending_actions,
            title: 'Задачи в ожидании',
            value: '${stats.pending}',
          ),

          _InfoRow(
            icon: Icons.access_time,
            title: 'Отработано часов',
            value: '${stats.totalWorkHours}',
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              stats.project.description ?? 'Нет описания',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
