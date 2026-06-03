import 'models/shared.dart';
import 'models/query.dart';
import 'package:track_dev/core/models/paginated_result.dart';

abstract class RedmineApiSource {
  Future<RedmineUser> fetchCurrentUser();

  Future<PaginatedResult<RedmineProject>> listProjects({int offset = 0, int limit = 25});

  Future<PaginatedResult<RedmineTimeEntry>> listTimeEntries({
    int offset = 0,
    int limit = 25,
    int? userId,
    String? projectId,
    int? issueId,
    DateTime? spentOnFrom,
    DateTime? spentOnTo,
  });

  Future<RedmineTimeEntry> createTimeEntry(CreateTimeEntryRequest request);
  Future<void> deleteTimeEntry(int id);
  Future<List<RedmineTimeEntryActivity>> listTimeEntryActivities();

  Future<PaginatedResult<RedmineIssue>> listIssues({
    int offset = 0,
    int limit = 25,
    String? sort,
    int? projectId,
    int? subprojectId,
    int? trackerId,
    String? statusId,
    String? assignedToId,
    int? parentId,
    String? issueId,
  });

  Future<List<RedmineIssueCategory>> listIssueCategories(String projectId);
}

