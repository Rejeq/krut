import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/stopwatch_state.dart';
import 'package:track_dev/providers/stopwatch_provider.dart';
import 'package:track_dev/ui/timer/stopwatch_clock.dart';
import 'package:track_dev/ui/timer/timer_control_buttons.dart';
import 'package:track_dev/ui/timer/timer_task_search_bar.dart';
import 'package:track_dev/ui/timer/task/task_selector_sheet.dart';
import 'package:track_dev/ui/timer/submit/submit_time_entry_sheet.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  Future<void> _openTaskSelector(BuildContext context, WidgetRef ref) async {
    final result = await showTaskSelectorSheet(context);
    if (result == null) return;

    await ref.read(stopwatchProvider.notifier).makeNew(
          project: result.project,
          issue: result.issue,
        );
  }

  Future<void> _openSubmitSheet(
    BuildContext context,
    WidgetRef ref,
    StopwatchState timerState,
  ) async {
    // Pause stopwatch
    await ref.read(stopwatchProvider.notifier).stop();

    if (!context.mounted) return;

    // Show submit sheet
    final submitted = await showSubmitTimeEntrySheet(
      context: context,
      stopwatchState: timerState,
    );

    if (submitted == true) {
      await ref.read(stopwatchProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerAsync = ref.watch(stopwatchProvider);
    final timerNotifier = ref.read(stopwatchProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: timerAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Text('Ошибка: $err', style: theme.textTheme.bodyMedium),
            ),
            data: (timerState) => Column(
              children: [
                Expanded(
                  child: Center(
                    child: StopwatchClock(
                      stopwatch: timerState.stopwatch,
                      size: 260,
                      smallLineColor: theme.colorScheme.outlineVariant,
                      largeLineColor: theme.colorScheme.onSurface,
                      textColor: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TimerTaskSearchBar(
                  onTap: () => _openTaskSelector(context, ref),
                ),
                const SizedBox(height: 32),
                TimerControlButtons(
                  isRunning: timerState.stopwatch.isRunning,
                  onStart: () => timerNotifier.start(timerState),
                  onPause: timerNotifier.stop,
                  onStop: timerNotifier.reset,
                  onSubmit: () => _openSubmitSheet(context, ref, timerState),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
