import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/project.dart';
import 'package:track_dev/core/usecase/project_stats.dart';
import 'package:track_dev/providers/sources_provider.dart';
import 'package:track_dev/providers/user_provider.dart';
import 'package:track_dev/utils/value_or_null.dart';

final projectsProvider = FutureProvider<List<Project>>((ref) async {
  // TODO: Make proper implementation
  final repo = ref.watch(projectsRepositoryProvider);
  return repo.listAll();
});

final projectsStatsProvider = FutureProvider<List<ProjectStats>>((ref) async {
  final user = ref.watch(userStateProvider).valueOrNull;
  final projects = ref.watch(projectsProvider).valueOrNull ?? const [];
  final issuesRepo = ref.watch(issuesRepositoryProvider);
  final timeEntries = ref.watch(timeEntriesRepositoryProvider);
  
  if (user == null) {
    return [];
  }
  
  return calculateProjectStats(user, projects, issuesRepo, timeEntries);
});