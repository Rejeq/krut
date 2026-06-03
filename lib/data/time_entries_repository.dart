import 'package:track_dev/core/models/time_entry.dart';
import 'package:track_dev/core/models/time_entry_activity.dart';
import 'package:track_dev/core/models/paginated_result.dart';
import 'package:track_dev/core/repository/time_entries.dart';
import 'package:track_dev/data/source/redmine/redmine_api_source.dart';
import 'package:track_dev/data/source/redmine/models/query.dart' as redmine_query;
import 'package:track_dev/data/source/redmine/models/error.dart';
import 'package:track_dev/data/map/time_entry.dart';
import 'package:track_dev/data/map/paginated_result.dart';
import 'package:track_dev/data/map/error.dart';

class TimeEntriesRepositoryImpl implements TimeEntriesRepository {
  final RedmineApiSource _apiSource;

  TimeEntriesRepositoryImpl({required RedmineApiSource apiSource}) : _apiSource = apiSource;

  @override
  Future<PaginatedResult<TimeEntry>> list(TimeEntriesQuery query) async {
    try {
      final redmineResult = await _apiSource.listTimeEntries(
        offset: query.offset,
        limit: query.limit,
        userId: query.userId,
        projectId: query.projectId,
        issueId: query.issueId,
        spentOnFrom: query.spentOnFrom,
        spentOnTo: query.spentOnTo,
      );
      return redmineResult.toDomain((item) => item.toDomain());
    } on RedmineApiException catch (e) {
      throw TimeEntriesException(e.message, mapTimeEntriesKind(e.kind), cause: e);
    }
  }

  @override
  Future<TimeEntry> create(CreateTimeEntryRequest request) async {
    try {
      final redmineRequest = redmine_query.CreateTimeEntryRequest(
        issueId: request.issueId,
        projectId: request.projectId,
        hours: request.hours,
        spentOn: request.spentOn,
        activityId: request.activityId,
        comments: request.comments,
      );
      final result = await _apiSource.createTimeEntry(redmineRequest);
      return result.toDomain();
    } on RedmineApiException catch (e) {
      throw TimeEntriesException(e.message, mapTimeEntriesKind(e.kind), cause: e);
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await _apiSource.deleteTimeEntry(id);
    } on RedmineApiException catch (e) {
      throw TimeEntriesException(e.message, mapTimeEntriesKind(e.kind), cause: e);
    }
  }

  @override
  Future<List<TimeEntryActivity>> fetchActivities() async {
    try {
      final activities = await _apiSource.listTimeEntryActivities();
      return activities.map((item) => item.toDomain()).toList();
    } on RedmineApiException catch (e) {
      throw TimeEntriesException(e.message, mapTimeEntriesKind(e.kind), cause: e);
    }
  }
}
