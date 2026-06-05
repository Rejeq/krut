import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DurationPickerDialog extends HookWidget {
  const DurationPickerDialog({
    super.key,
    required this.initialHours,
    required this.initialMinutes,
  });

  final int initialHours;
  final int initialMinutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedHours = useState(initialHours);
    final selectedMinutes = useState(initialMinutes);
    final hoursController = useMemoized(
      () => FixedExtentScrollController(initialItem: initialHours),
    );
    final minutesController = useMemoized(
      () => FixedExtentScrollController(initialItem: initialMinutes),
    );
    useEffect(() {
      return () {
        hoursController.dispose();
        minutesController.dispose();
      };
    }, const []);

    return AlertDialog(
      title: const Text('Затраченное время'),
      content: SizedBox(
        height: 200,
        width: 280,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hours wheel
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  ListWheelScrollView.useDelegate(
                    controller: hoursController,
                    itemExtent: 40,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      selectedHours.value = index;
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        if (index < 0) return null;
                        return Center(
                          child: Text(
                            '$index',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: selectedHours.value == index
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: selectedHours.value == index
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'ч',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 24),
            // Minutes wheel
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  ListWheelScrollView.useDelegate(
                    controller: minutesController,
                    itemExtent: 40,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      selectedMinutes.value = index.remainder(60).abs();
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: List.generate(60, (index) {
                        return Center(
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: selectedMinutes.value == index
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: selectedMinutes.value == index
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'мин',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(
              (hours: selectedHours.value, minutes: selectedMinutes.value),
            );
          },
          child: const Text('Ок'),
        ),
      ],
    );
  }
}

Future<({int hours, int minutes})?> showDurationPickerDialog({
  required BuildContext context,
  required int initialHours,
  required int initialMinutes,
}) {
  return showDialog<({int hours, int minutes})>(
    context: context,
    builder: (context) => DurationPickerDialog(
      initialHours: initialHours,
      initialMinutes: initialMinutes,
    ),
  );
}
