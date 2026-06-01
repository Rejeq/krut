import 'package:hooks_riverpod/hooks_riverpod.dart';

class Project {
  final String name;
  final String? description;
  final int completedTasks;
  final int pendingTasks;
  final int totalHours;

  Project({
    required this.name,
    this.description,
    required this.completedTasks,
    required this.pendingTasks,
    required this.totalHours,
  });
}

// Провайдер списка проектов
final projectsProvider = Provider<List<Project>>((ref) {
  return [
    Project(name: 'Проект Alpha', completedTasks: 12, pendingTasks: 3, totalHours: 40),
    Project(name: 'Проект Beta', completedTasks: 8, pendingTasks: 5, totalHours: 30),
    Project(name: 'Проект Gamma', completedTasks: 20, pendingTasks: 2, totalHours: 60),
  ];
});