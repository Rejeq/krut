import 'package:track_dev/core/usecase/stopwatch.dart';

class StopwatchState {
  final int id;
  final Stopwatch stopwatch;
  final String? attachedProject;
  final String? attachedIssue;

  const StopwatchState({
    required this.id,
    required this.stopwatch,
    this.attachedProject,
    this.attachedIssue,
  });

  StopwatchState copyWith({
    int? id,
    Stopwatch? stopwatch,
    String? attachedProject,
    String? attachedIssue,
  }) {
    return StopwatchState(
      id: id ?? this.id,
      stopwatch: stopwatch ?? this.stopwatch.copyWith(),
      attachedProject: attachedProject ?? this.attachedProject,
      attachedIssue: attachedIssue ?? this.attachedIssue,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StopwatchState &&
        other.id == id &&
        other.stopwatch == stopwatch &&
        other.attachedProject == attachedProject &&
        other.attachedIssue == attachedIssue;
  }

  @override
  int get hashCode =>
      Object.hash(id, stopwatch.hashCode, attachedProject, attachedIssue);

  @override
  String toString() =>
      'StopwatchState(id: $id, stopwatch: $stopwatch, attachedProject: $attachedProject, attachedIssue: $attachedIssue)';
}
