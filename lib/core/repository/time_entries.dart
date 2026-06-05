import 'package:track_dev/core/models/error.dart';
import 'package:track_dev/core/models/paginated_result.dart';
import 'package:track_dev/core/models/time_entry.dart';
import 'package:track_dev/core/models/time_entry_activity.dart';

sealed class TimeEntriesErrorKind {
  const TimeEntriesErrorKind();
}

final class TimeEntryNotFoundErrorKind extends TimeEntriesErrorKind {
  const TimeEntryNotFoundErrorKind();
}

final class TimeEntryValidationErrorKind extends TimeEntriesErrorKind {
  const TimeEntryValidationErrorKind({this.errors = const <String, List<String>>{}});
  final Map<String, List<String>> errors;
}

final class TimeEntriesNetworkErrorKind extends TimeEntriesErrorKind {
  const TimeEntriesNetworkErrorKind({this.kind});
  final NetworkErrorKind? kind;
}

class TimeEntriesException implements Exception {
  const TimeEntriesException(this.message, this.kind, {this.cause});

  final String message;
  final TimeEntriesErrorKind kind;
  final Object? cause;

  @override
  String toString() => 'TimeEntriesException($kind): $message';
}

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
}

class TimeEntriesQuery {
  const TimeEntriesQuery({
    this.offset = 0,
    this.limit = 25,
    this.userId,
    this.projectId,
    this.issueId,
    this.spentOnFrom,
    this.spentOnTo,
  });

  final int offset;
  final int limit;
  final int? userId;
  final String? projectId;
  final int? issueId;
  final DateTime? spentOnFrom;
  final DateTime? spentOnTo;

  TimeEntriesQuery copyWith({
    int? offset,
    int? limit,
    int? userId,
    String? projectId,
    int? issueId,
    DateTime? spentOnFrom,
    DateTime? spentOnTo,
  }) {
    return TimeEntriesQuery(
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
      issueId: issueId ?? this.issueId,
      spentOnFrom: spentOnFrom ?? this.spentOnFrom,
      spentOnTo: spentOnTo ?? this.spentOnTo,
    );
  }
}

abstract class TimeEntriesRepository {
  Future<PaginatedResult<TimeEntry>> list(TimeEntriesQuery query);
  Future<List<TimeEntry>> listAll(TimeEntriesQuery query);

  Future<TimeEntry> create(CreateTimeEntryRequest request);
  Future<void> delete(int id);
  Future<List<TimeEntryActivity>> fetchActivities();
}
