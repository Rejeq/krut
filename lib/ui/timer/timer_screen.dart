import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/providers/timer.dart';
import 'package:track_dev/ui/timer/widgets/timer_clock_face.dart';
import 'package:track_dev/ui/timer/widgets/timer_control_buttons.dart';
import 'package:track_dev/ui/timer/widgets/timer_task_search_bar.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: TimerClockFace(elapsed: timerState.elapsed),
                ),
              ),
              const SizedBox(height: 8),
              const TimerTaskSearchBar(),
              const SizedBox(height: 32),
              TimerControlButtons(
                isRunning: timerState.isRunning,
                onStart: timerNotifier.start,
                onPause: timerNotifier.pause,
                onStop: timerNotifier.stop,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
