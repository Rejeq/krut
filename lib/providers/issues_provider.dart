import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/issue.dart';
import 'package:track_dev/providers/sources_provider.dart';

final issuesProvider = FutureProvider<List<Issue>>((ref) async {
  // TODO: Make proper implementation
  final repo = ref.watch(issuesRepositoryProvider);
  return repo.listAll();
});
