import 'package:track_dev/core/models/user.dart';
import 'package:track_dev/core/models/time_entry.dart';
import 'package:track_dev/core/models/issue.dart';
import 'package:track_dev/core/repository/issues.dart';

class Stats {
  final int totalWorkHours;
  final int completedTasks;
  final int pendingTasks;
  final Map<DateTime, DayStats> workHoursPerDay;

  const Stats({
    required this.totalWorkHours,
    required this.completedTasks,
    required this.pendingTasks,
    required this.workHoursPerDay,
  });
}

class DayStats {
  final int total;
  final List<(Issue, int)> workHoursPerIssue;

  const DayStats({
    required this.total,
    required this.workHoursPerIssue,
  });
}

Future<Stats> calculateStats(
  User target,
  List<TimeEntry> entries,
  IssuesRepository issuesRepo,
) async {
  // Fetch issues assigned to the user (needed for pending/completed counts).
  final assignedIssues = await issuesRepo.listAll(
    IssuesQuery(assignedToId: target.id),
  );

  final completed = countTasks(assignedIssues, target.id, closed: true);
  final pending = countTasks(assignedIssues, target.id, closed: false);

  // Collect issue IDs referenced by time entries that are not in the assigned
  // list, so we also include issues the user worked on but isn't assigned to.
  final assignedIds = assignedIssues.map((i) => i.id).toSet();
  final entryIssueIds = entries
      .map((e) => e.issueId)
      .whereType<int>()
      .toSet()
      .difference(assignedIds);

  List<Issue> allIssues = List.empty();
  if (entryIssueIds.isNotEmpty) {
    final extraIssues = await issuesRepo.listAll(
      IssuesQuery(issueId: entryIssueIds.join(',')),
    );
    allIssues.addAll(extraIssues);
  }

  final totalHours = entries.fold<double>(0.0, (sum, entry) => sum + entry.hours).round();
  final workHoursDay = calculateWorkHoursPerDay(entries, allIssues);

  return Stats(
    totalWorkHours: totalHours,
    completedTasks: completed,
    pendingTasks: pending,
    workHoursPerDay: workHoursDay,
  );
}

int countTasks(List<Issue> issues, String userId, {required bool closed}) {
  return issues.where((issue) =>
    issue.assignedToId?.toString() == userId &&
    (issue.status?.isClosed ?? false) == closed
  ).length;
}

// Expose the result in hash map type
Map<DateTime, DayStats> calculateWorkHoursPerDay(
  List<TimeEntry> entries,
  List<Issue> issues,
) {
  final Map<DateTime, Map<int, double>> dailyIssueHours = {};

  for (final entry in entries) {
    if (entry.spentOn == null) continue;
    final date = DateTime(entry.spentOn!.year, entry.spentOn!.month, entry.spentOn!.day);

    dailyIssueHours.putIfAbsent(date, () => {});
    final issueId = entry.issueId ?? 0;

    dailyIssueHours[date]![issueId] = (dailyIssueHours[date]![issueId] ?? 0.0) + entry.hours;
  }

  final Map<DateTime, DayStats> result = {};

  for (final date in dailyIssueHours.keys) {
    final issueMap = dailyIssueHours[date]!;
    double dayTotal = 0.0;
    final List<(Issue, int)> workHoursPerIssue = [];

    for (final entry in issueMap.entries) {
      final issueId = entry.key;
      final hours = entry.value;
      dayTotal += hours;

      final issue = issues.firstWhere(
        (i) => i.id == issueId,
        orElse: () => Issue(id: issueId, subject: 'Задача #$issueId'),
      );

      workHoursPerIssue.add((issue, hours.round()));
    }

    result[date] = DayStats(
      total: dayTotal.round(),
      workHoursPerIssue: workHoursPerIssue,
    );
  }

  return result;
}
