import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/time_entry_activity.dart';
import 'package:track_dev/providers/sources_provider.dart';

final activitiesProvider = FutureProvider.autoDispose<List<TimeEntryActivity>>((ref) async {
  final repo = ref.watch(timeEntriesRepositoryProvider);
  return repo.fetchActivities();
});
