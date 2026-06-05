import 'package:track_dev/core/models/stopwatch_state.dart';

abstract class TimeRepository {
  Future<StopwatchState> getStopwatch(int id);
  Future<List<StopwatchState>> getAllStopwatch();

  Future<void> upsertStopwatch(StopwatchState state);
  Future<void> removeStopwatch(int id);

  Future<int> acquireUniqueId();
  Future<void> releaseUniqueId(int id);
}
