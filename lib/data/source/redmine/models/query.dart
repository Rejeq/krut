import 'shared.dart';

class CreateTimeEntryRequest {
  const CreateTimeEntryRequest({
    this.issueId,
    this.projectId,
    required this.hours,
    this.spentOn,
    this.activityId,
    this.comments,
  }) : assert(issueId != null || projectId != null);

  final int? issueId;
  final int? projectId;
  final double hours;
  final DateTime? spentOn;
  final int? activityId;
  final String? comments;

  JsonMap toJson() => <String, dynamic>{
        'time_entry': <String, dynamic>{
          'issue_id': issueId,
          'project_id': projectId,
          'hours': hours,
          'spent_on': spentOn == null ? null : _ymd(spentOn!),
          'activity_id': activityId,
          'comments': comments,
        }..removeWhere((_, value) => value == null),
      };
}

String _ymd(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}


