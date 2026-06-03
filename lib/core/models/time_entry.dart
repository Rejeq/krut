import 'package:track_dev/core/models/time_entry_activity.dart';

class TimeEntry {
  const TimeEntry({
    required this.id,
    required this.hours,
    this.spentOn,
    this.comment,
    this.activity,
    this.projectId,
    this.issueId,
    this.userId,
    this.createdOn,
    this.updatedOn,
  });

  final int id;
  final double hours;
  final DateTime? spentOn;
  final String? comment;
  final TimeEntryActivity? activity;
  final int? projectId;
  final int? issueId;
  final int? userId;
  final DateTime? createdOn;
  final DateTime? updatedOn;
}

