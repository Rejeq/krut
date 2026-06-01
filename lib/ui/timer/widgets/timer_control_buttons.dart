import 'package:flutter/material.dart';
import 'package:track_dev/ui/timer/screens/timer_end_screen.dart';

class TimerControlButtons extends StatelessWidget {
  const TimerControlButtons({
    super.key,
    required this.isRunning,
    required this.onStart,
    required this.onPause,
    required this.onStop,
  });

  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    if (!isRunning) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onStart,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Старт'),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onPause,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.orange,
            ),
            child: const Text('Приостановить'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton(
            onPressed: () {
              onStop();
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const TimerEndScreen(),
                ),
              );
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.red,
            ),
            child: const Text('Завершить'),
          ),
        ),
      ],
    );
  }
}
