import 'package:flutter/material.dart';
import 'package:track_dev/ui/timer/screens/task_search_screen.dart';

class TimerTaskSearchBar extends StatelessWidget {
  const TimerTaskSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const TaskSearchScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: outline.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: outline.withValues(alpha: 0.7)),
              const SizedBox(width: 12),
              Text(
                'Поиск задач...',
                style: TextStyle(color: outline.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
