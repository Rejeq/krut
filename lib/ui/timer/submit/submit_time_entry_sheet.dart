import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/time_entry_activity.dart';
import 'package:track_dev/core/models/stopwatch_state.dart';
import 'package:track_dev/providers/activities_provider.dart';
import 'package:track_dev/providers/submit_time_entry_provider.dart';
import 'package:track_dev/providers/projects_provider.dart';
import 'package:track_dev/providers/issues_provider.dart';
import 'package:track_dev/ui/timer/task/task_selector_sheet.dart';
import 'package:track_dev/ui/timer/submit/duration_picker_dialog.dart';

class SubmitTimeEntrySheet extends HookConsumerWidget {
  const SubmitTimeEntrySheet({
    super.key,
    required this.stopwatchState,
  });

  final StopwatchState stopwatchState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final commentController = useTextEditingController();
    final commentFocusNode = useFocusNode();

    useEffect(() {
      Future.microtask(() {
        ref.read(submitTimeEntryProvider.notifier).init(stopwatchState);
        commentController.text = ref.read(submitTimeEntryProvider).comment;
      });
      return null;
    }, const []);

    final state = ref.watch(submitTimeEntryProvider);
    final activitiesAsync = ref.watch(activitiesProvider);

    // Listen to activities provider to set default activity if not set yet
    ref.listen<AsyncValue<List<TimeEntryActivity>>>(activitiesProvider, (previous, next) {
      if (next is AsyncData<List<TimeEntryActivity>>) {
        final currentSelected = ref.read(submitTimeEntryProvider).selectedActivity;
        if (currentSelected == null && next.value.isNotEmpty) {
          final defaultAct = next.value.firstWhere(
            (a) => a.isDefault,
            orElse: () => next.value.first,
          );
          ref.read(submitTimeEntryProvider.notifier).setActivity(defaultAct);
        }
      }
    });

    Future<void> pickTask() async {
      commentFocusNode.unfocus();
      final result = await showTaskSelectorSheet(context);
      if (result != null && context.mounted) {
        ref.read(submitTimeEntryProvider.notifier).setProjectAndIssue(
              result.project,
              result.issue,
            );
      }
    }

    Future<void> pickDate(DateTime initialDate) async {
      commentFocusNode.unfocus();
      final result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (result != null && context.mounted) {
        ref.read(submitTimeEntryProvider.notifier).setSpentOn(result);
      }
    }

    Future<void> pickDuration(int hours, int minutes) async {
      commentFocusNode.unfocus();
      final result = await showDurationPickerDialog(
        context: context,
        initialHours: hours,
        initialMinutes: minutes,
      );
      if (result != null && context.mounted) {
        ref.read(submitTimeEntryProvider.notifier).setDuration(
              result.hours,
              result.minutes,
            );
      }
    }

    Future<void> submit() async {
      if (state.projectId == null && state.issueId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Выберите проект или задачу')),
        );
        return;
      }

      try {
        await ref.read(submitTimeEntryProvider.notifier).submit();
        if (context.mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка отправки: $e')),
          );
        }
      }
    }

    // Resolve project/issue name
    String resolvedTaskName = 'Не выбрано';
    IconData taskIcon = Icons.help_outline_rounded;
    Color taskIconColor = theme.colorScheme.outline;

    if (state.projectId != null) {
      final projectsAsync = ref.watch(projectsProvider);
      final projList = projectsAsync.asData?.value;
      final matchedProj = projList?.where((p) => p.id.toString() == state.projectId).firstOrNull;
      if (matchedProj != null) {
        resolvedTaskName = matchedProj.name;
        taskIcon = Icons.folder_rounded;
        taskIconColor = theme.colorScheme.primary;
      }
    } else if (state.issueId != null) {
      final issuesAsync = ref.watch(issuesProvider);
      final issueList = issuesAsync.asData?.value;
      final matchedIssue = issueList?.where((i) => i.id.toString() == state.issueId).firstOrNull;
      if (matchedIssue != null) {
        resolvedTaskName = '#${matchedIssue.id} ${matchedIssue.subject}';
        taskIcon = Icons.task_alt_rounded;
        taskIconColor = theme.colorScheme.tertiary;
      }
    }

    final Widget activitySelector;
    if (activitiesAsync.isLoading) {
      activitySelector = const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else if (activitiesAsync.hasError) {
      activitySelector = Card(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.2),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Не удалось загрузить активности',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Повторить'),
                onPressed: () => ref.invalidate(activitiesProvider),
              ),
            ],
          ),
        ),
      );
    } else {
      final activities = activitiesAsync.value ?? [];
      activitySelector = DropdownButtonFormField<TimeEntryActivity>(
        key: ValueKey(state.selectedActivity),
        initialValue: state.selectedActivity,
        decoration: InputDecoration(
          labelText: 'Активность',
          prefixIcon: const Icon(Icons.label_outline_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: activities.map((activity) {
          return DropdownMenuItem<TimeEntryActivity>(
            value: activity,
            child: Text(activity.name),
          );
        }).toList(),
        onChanged: state.isSubmitting
            ? null
            : (val) {
                ref.read(submitTimeEntryProvider.notifier).setActivity(val);
              },
      );
    }

    String formatDate(DateTime date) =>
        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Отправить запись времени'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: state.isSubmitting ? null : () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Task picker row
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: theme.colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      enabled: !state.isSubmitting,
                      onTap: pickTask,
                      leading: Icon(taskIcon, color: taskIconColor),
                      title: const Text('Задача / Проект'),
                      subtitle: Text(
                        resolvedTaskName,
                        style: TextStyle(
                          color: resolvedTaskName == 'Не выбрано'
                              ? theme.colorScheme.outline
                              : theme.colorScheme.onSurface,
                          fontWeight: resolvedTaskName == 'Не выбрано'
                              ? FontWeight.normal
                              : FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Date picker row
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: theme.colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      enabled: !state.isSubmitting,
                      onTap: () => pickDate(state.spentOn),
                      leading: const Icon(Icons.calendar_today_rounded),
                      title: const Text('Дата начала'),
                      subtitle: Text(
                        formatDate(state.spentOn),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Duration picker row
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: theme.colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      enabled: !state.isSubmitting,
                      onTap: () => pickDuration(state.durationHours, state.durationMinutes),
                      leading: const Icon(Icons.timer_outlined),
                      title: const Text('Затраченное время'),
                      subtitle: Text(
                        '${state.durationHours} ч. ${state.durationMinutes} мин.',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Activity selector
                  activitySelector,
                  const SizedBox(height: 24),

                  // Comment field
                  TextField(
                    controller: commentController,
                    focusNode: commentFocusNode,
                    enabled: !state.isSubmitting,
                    maxLength: 255,
                    maxLines: 4,
                    onChanged: (text) =>
                        ref.read(submitTimeEntryProvider.notifier).setComment(text),
                    decoration: InputDecoration(
                      labelText: 'Комментарий',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      counterText: '', // Hide standard counter
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Custom character counter aligned to bottom end
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${state.comment.length}/255',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: state.comment.length >= 255
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Action Area
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isSubmitting ? null : submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: state.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Отправить', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showSubmitTimeEntrySheet({
  required BuildContext context,
  required StopwatchState stopwatchState,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 1.0,
        child: SubmitTimeEntrySheet(stopwatchState: stopwatchState),
      );
    },
  );
}
