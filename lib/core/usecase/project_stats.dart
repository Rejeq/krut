import 'package:track_dev/core/models/project.dart';
import 'package:track_dev/core/models/user.dart';
import 'package:track_dev/core/repository/issues.dart';
import 'package:track_dev/core/repository/time_entries.dart';
import 'package:track_dev/core/usecase/stats.dart';

class ProjectStats {
  final Project project;
  final int completed;
  final int pending;
  final int totalWorkHours;

  const ProjectStats({
    required this.project,
    required this.completed,
    required this.pending,
    required this.totalWorkHours,
  });
}

Future<List<ProjectStats>> calculateProjectStats(User target, List<Project> projects, IssuesRepository issuesRepo, TimeEntriesRepository timeEntries) async {
  List<ProjectStats> stats = [];

  for (final project in projects) {
    final entries = await timeEntries.listAll(
      TimeEntriesQuery(projectId: project.id.toString(), userId: int.parse(target.id)),
    );

    final assignedIssues = await issuesRepo.listAll(
      IssuesQuery(assignedToId: target.id),
    );
    
    final completed = countTasks(assignedIssues, target.id, closed: true);
    final pending = countTasks(assignedIssues, target.id, closed: false);
    
    ProjectStats projectStats = ProjectStats(
      project: project,
      completed: completed,
      pending:pending, 
      totalWorkHours: entries.fold<double>(0.0, (sum, entry) => sum + entry.hours).round(),
    );

    stats.add(projectStats);
  }

  return stats;
}