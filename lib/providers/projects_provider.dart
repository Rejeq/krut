import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/project.dart';
import 'package:track_dev/providers/sources_provider.dart';

final projectsProvider = FutureProvider<List<Project>>((ref) async {
  // TODO: Make proper implementation
  final repo = ref.watch(projectsRepositoryProvider);
  return repo.listAll();
});

