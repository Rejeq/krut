import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/project.dart';
import 'package:track_dev/core/models/issue.dart';
import 'package:track_dev/providers/stopwatch_provider.dart';
import 'package:track_dev/providers/projects_provider.dart';
import 'package:track_dev/providers/issues_provider.dart';

class TimerTaskSearchBar extends ConsumerWidget {
  const TimerTaskSearchBar({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline;

    final timerAsync = ref.watch(stopwatchProvider);
    final stopwatchState = timerAsync.asData?.value;

    IconData leadingIcon = Icons.search;
    Color leadingIconColor = outline.withValues(alpha: 0.7);
    String displayText = 'Поиск задач...';
    TextStyle textStyle = TextStyle(color: outline.withValues(alpha: 0.7));

    if (stopwatchState != null) {
      if (stopwatchState.attachedProject != null) {
        final projectsAsync = ref.watch(projectsProvider);
        Project? matchedProj;
        final projList = projectsAsync.asData?.value;
        if (projList != null) {
          for (final p in projList) {
            if (p.id.toString() == stopwatchState.attachedProject) {
              matchedProj = p;
              break;
            }
          }
        }
        if (matchedProj != null) {
          leadingIcon = Icons.folder_rounded;
          leadingIconColor = theme.colorScheme.primary;
          displayText = matchedProj.name;
          textStyle = TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          );
        }
      } else if (stopwatchState.attachedIssue != null) {
        final issuesAsync = ref.watch(issuesProvider);
        Issue? matchedIssue;
        final issueList = issuesAsync.asData?.value;
        if (issueList != null) {
          for (final i in issueList) {
            if (i.id.toString() == stopwatchState.attachedIssue) {
              matchedIssue = i;
              break;
            }
          }
        }
        if (matchedIssue != null) {
          leadingIcon = Icons.task_alt_rounded;
          leadingIconColor = theme.colorScheme.tertiary;
          displayText = '#${matchedIssue.id} ${matchedIssue.subject}';
          textStyle = TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          );
        }
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: outline.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(leadingIcon, color: leadingIconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  displayText,
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
