import 'package:track_dev/core/models/stopwatch_state.dart';
import 'package:track_dev/core/usecase/stopwatch.dart';

extension StopwatchMapper on Stopwatch {
  Map<String, dynamic> toJson() {
    return {
      'base': base.inSeconds,
      'runningSince': runningSince?.toIso8601String(),
    };
  }
}

extension StopwatchStateMapper on StopwatchState {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stopwatch': stopwatch.toJson(),
      'attachedProject': attachedProject,
      'attachedIssue': attachedIssue,
    };
  }
}

Stopwatch stopwatchFromJson(Map<String, dynamic> json) {
  final base = Duration(seconds: (json['base'] as int?) ?? 0);
  DateTime? runningSince;

  final s = json['runningSince'] as String?;
  if (s != null) {
    final parsed = DateTime.parse(s);
    final now = DateTime.now();
    runningSince = parsed.isAfter(now) ? now : parsed;
  }

  return Stopwatch(base: base, runningSince: runningSince);
}

StopwatchState stopwatchStateFromJson(Map<String, dynamic> json) {
  return StopwatchState(
    id: json['id'] as int,
    stopwatch: stopwatchFromJson(json['stopwatch'] as Map<String, dynamic>),
    attachedProject: json['attachedProject'] as String?,
    attachedIssue: json['attachedIssue'] as String?,
  );
}
