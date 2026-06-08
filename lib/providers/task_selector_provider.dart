
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/issue.dart';
import 'package:track_dev/core/models/project.dart';
import 'package:track_dev/providers/issues_provider.dart';
import 'package:track_dev/providers/projects_provider.dart';

/// Determines which types of items the task selector shows.
enum TaskFilterMode {
  all,
  projectsOnly,
  issuesOnly,
}

/// Determines how the task list is sorted.
enum TaskSortMode {
  nameAsc,
  nameDesc,
  updatedDesc,
  updatedAsc,
}

/// A unified item that can be either a [Project] or an [Issue].
sealed class TaskItem {
  const TaskItem();

  String get displayName;
  String get subtitle;
  int get id;
  DateTime? get updatedOn;
  String? get description;
}

class ProjectTaskItem extends TaskItem {
  const ProjectTaskItem(this.project);

  final Project project;

  @override
  String get displayName => project.name;

  @override
  String get subtitle => 'Проект';

  @override
  int get id => project.id;

  @override
  DateTime? get updatedOn => project.updatedOn;

  @override
  String? get description => project.description;
}

class IssueTaskItem extends TaskItem {
  const IssueTaskItem(this.issue);

  final Issue issue;

  @override
  String get displayName => issue.subject;

  @override
  String get subtitle => '#${issue.id}';

  @override
  int get id => issue.id;

  @override
  DateTime? get updatedOn => issue.updatedOn;

  @override
  String? get description => issue.description;
}

/// Holds the current search, filter, and sort configuration.
class TaskSelectorState {
  const TaskSelectorState({
    this.searchQuery = '',
    this.filterMode = TaskFilterMode.all,
    this.sortMode = TaskSortMode.nameAsc,
  });

  final String searchQuery;
  final TaskFilterMode filterMode;
  final TaskSortMode sortMode;

  TaskSelectorState copyWith({
    String? searchQuery,
    TaskFilterMode? filterMode,
    TaskSortMode? sortMode,
  }) {
    return TaskSelectorState(
      searchQuery: searchQuery ?? this.searchQuery,
      filterMode: filterMode ?? this.filterMode,
      sortMode: sortMode ?? this.sortMode,
    );
  }
}

class TaskSelectorNotifier extends Notifier<TaskSelectorState> {
  @override
  TaskSelectorState build() => const TaskSelectorState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilterMode(TaskFilterMode mode) {
    state = state.copyWith(filterMode: mode);
  }

  void setSortMode(TaskSortMode mode) {
    state = state.copyWith(sortMode: mode);
  }
}

final taskSelectorProvider =
    NotifierProvider.autoDispose<TaskSelectorNotifier, TaskSelectorState>(
  TaskSelectorNotifier.new,
);

/// Provides the filtered and sorted list of [TaskItem]s based on the current
/// [TaskSelectorState].
final filteredTaskItemsProvider =
    FutureProvider.autoDispose<List<TaskItem>>((ref) async {
  final selectorState = ref.watch(taskSelectorProvider);
  final projectsAsync = ref.watch(projectsProvider);
  final issuesAsync = ref.watch(issuesProvider);

  final projects = projectsAsync.asData?.value ?? <Project>[];
  final issues = issuesAsync.asData?.value ?? <Issue>[];

  final items = <TaskItem>[];

  // Collect items based on filter mode.
  if (selectorState.filterMode != TaskFilterMode.issuesOnly) {
    items.addAll(projects.map(ProjectTaskItem.new));
  }
  if (selectorState.filterMode != TaskFilterMode.projectsOnly) {
    items.addAll(issues.map(IssueTaskItem.new));
  }

  // Apply search query.
  final query = selectorState.searchQuery.toLowerCase();
  final filtered = query.isEmpty
      ? items
      : items
          .where((item) => item.displayName.toLowerCase().contains(query))
          .toList();

  // Apply sort.
  filtered.sort((a, b) {
    return switch (selectorState.sortMode) {
      TaskSortMode.nameAsc => a.displayName.compareTo(b.displayName),
      TaskSortMode.nameDesc => b.displayName.compareTo(a.displayName),
      TaskSortMode.updatedDesc => _compareNullableDateTime(
          b.updatedOn, a.updatedOn),
      TaskSortMode.updatedAsc => _compareNullableDateTime(
          a.updatedOn, b.updatedOn),
    };
  });

  return filtered;
});

int _compareNullableDateTime(DateTime? a, DateTime? b) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return a.compareTo(b);
}
