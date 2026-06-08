import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/stopwatch_state.dart';
import 'package:track_dev/core/usecase/stopwatch.dart';
import 'package:track_dev/providers/sources_provider.dart';

class StopwatchNotifier extends AsyncNotifier<StopwatchState> {
  @override
  Future<StopwatchState> build() async {
    return getLatestActive();
  }

  Future<StopwatchState> getLatestActive() async {
    final timeRepo = ref.read(timeRepositoryProivder);
    final stopwatches = await timeRepo.getAllStopwatch();

    if (stopwatches.isEmpty) {
      final newId = await timeRepo.acquireUniqueId();
      final newState = StopwatchState(
        id: newId,
        stopwatch: Stopwatch(),
      );
      await timeRepo.upsertStopwatch(newState);
      return newState;
    }
    final running = stopwatches.cast<StopwatchState?>().firstWhere(
      (e) => e?.stopwatch.isRunning ?? false,
      orElse: () => null,
    );
    return running ?? stopwatches.last;
  }

  Future<List<StopwatchState>> getAll() async {
    final timeRepo = ref.read(timeRepositoryProivder);
    return await timeRepo.getAllStopwatch();
  }

  Future<void> start(StopwatchState stopwatch) async {
    final current = state.asData?.value;
    if (current != null && current.id != stopwatch.id) {
      if (current.stopwatch.isRunning) {
        current.stopwatch.stop();
        await ref.read(timeRepositoryProivder).upsertStopwatch(current);
      }
    }

    final sw = stopwatch.copyWith();
    sw.stopwatch.start();
    await ref.read(timeRepositoryProivder).upsertStopwatch(sw);
    state = AsyncData(sw);
  }

  Future<void> stop() async {
    final current = state.asData?.value.copyWith();
    if (current != null) {
      current.stopwatch.stop();
      await ref.read(timeRepositoryProivder).upsertStopwatch(current);
      state = AsyncData(current);
    }
  }

  Future<void> reset() async {
    final current = state.asData?.value.copyWith();
    if (current != null) {
      current.stopwatch.reset();
      await ref.read(timeRepositoryProivder).upsertStopwatch(current);
      state = AsyncData(current);
    }
  }

  Future<void> makeNew({String? project, String? issue}) async {
    final timeRepo = ref.read(timeRepositoryProivder);
    final current = state.asData?.value;
    if (current != null && current.stopwatch.isRunning) {
      current.stopwatch.stop();
      await timeRepo.upsertStopwatch(current);
    }

    final newId = await timeRepo.acquireUniqueId();
    final newState = StopwatchState(
      id: newId,
      stopwatch: Stopwatch(),
      attachedProject: project,
      attachedIssue: issue,
    );
    await timeRepo.upsertStopwatch(newState);
    await start(newState);
  }
}

final stopwatchProvider = AsyncNotifierProvider<StopwatchNotifier, StopwatchState>(
  StopwatchNotifier.new,
);
