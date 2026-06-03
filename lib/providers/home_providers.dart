import 'package:hooks_riverpod/legacy.dart';

class HomeState {
  final String? username;
  final int totalWorkHours;
  final int completedTasks;
  final int pendingTasks;
  final List<(DateTime, int)> workHoursPerDay;

  HomeState({
    this.username,
    this.totalWorkHours = 0,
    this.completedTasks = 0,
    this.pendingTasks = 0,
    this.workHoursPerDay = const [],
  });

  HomeState copyWith({
    String? username,
    int? totalWorkHours,
    int? completedTasks,
    int? pendingTasks,
    List<(DateTime, int)>? workHoursPerDay,
  }) {
    return HomeState(
      username: username ?? this.username,
      totalWorkHours: totalWorkHours ?? this.totalWorkHours,
      completedTasks: completedTasks ?? this.completedTasks,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      workHoursPerDay: workHoursPerDay ?? this.workHoursPerDay,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier()
    : super(
        HomeState(
          username: 'Эллина',
          totalWorkHours: 128,
          completedTasks: 42,
          pendingTasks: 7,
          workHoursPerDay: [
            (DateTime(2026, 5, 26), 6),
            (DateTime(2026, 5, 27), 4),
            (DateTime(2026, 5, 28), 8),
            (DateTime(2026, 5, 29), 5),
            (DateTime(2026, 5, 30), 7),
            (DateTime(2026, 5, 31), 3),
            (DateTime(2026, 6, 1), 6),
          ],
        ),
      );

  void updateUsername(String value) {
    state = state.copyWith(username: value);
  }

  void updateStats({
    int? totalWorkHours,
    int? completedTasks,
    int? pendingTasks,
  }) {
    state = state.copyWith(
      totalWorkHours: totalWorkHours,
      completedTasks: completedTasks,
      pendingTasks: pendingTasks,
    );
  }

  void updateWorkHoursPerDay(List<(DateTime, int)> value) {
    state = state.copyWith(workHoursPerDay: value);
  }
}

final homeStateProvider = StateNotifierProvider<HomeNotifier, HomeState?>((
  ref,
) {
  return HomeNotifier();
});
