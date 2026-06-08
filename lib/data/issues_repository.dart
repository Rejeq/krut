import 'package:track_dev/core/models/issue.dart';
import 'package:track_dev/core/models/issue_category.dart';
import 'package:track_dev/core/models/paginated_result.dart';
import 'package:track_dev/core/repository/issues.dart';
import 'package:track_dev/data/source/redmine/redmine_api_source.dart';
import 'package:track_dev/data/source/redmine/models/error.dart';
import 'package:track_dev/data/map/issue.dart';
import 'package:track_dev/data/map/paginated_result.dart';
import 'package:track_dev/data/map/error.dart';

class IssuesRepositoryImpl implements IssuesRepository {
  final RedmineApiSource _apiSource;

  IssuesRepositoryImpl({required this._apiSource});

  @override
  Future<PaginatedResult<Issue>> list(IssuesQuery query) async {
    try {
      final redmineResult = await _apiSource.listIssues(
        offset: query.offset,
        limit: query.limit,
        sort: query.sort,
        projectId: query.projectId,
        subprojectId: query.subprojectId,
        trackerId: query.trackerId,
        statusId: query.statusId,
        assignedToId: query.assignedToId,
        parentId: query.parentId,
        issueId: query.issueId,
      );
      return redmineResult.toDomain((item) => item.toDomain());
    } on RedmineApiException catch (e) {
      throw IssuesException(e.message, mapIssuesKind(e.kind), cause: e);
    }
  }

  @override
  Future<List<Issue>> listAll([IssuesQuery query = const IssuesQuery(limit: 100)]) async {
    final result = <Issue>[];
    var offset = query.offset;
    while (true) {
      final page = await list(IssuesQuery(
        offset: offset,
        limit: query.limit,
        sort: query.sort,
        projectId: query.projectId,
        subprojectId: query.subprojectId,
        trackerId: query.trackerId,
        statusId: query.statusId,
        assignedToId: query.assignedToId,
        parentId: query.parentId,
        issueId: query.issueId,
      ));
      result.addAll(page.items);
      if (result.length >= (page.totalCount ?? result.length) || page.items.isEmpty) break;
      offset += page.limit;
    }
    return result;
  }

  @override
  Future<List<IssueCategory>> fetchIssueCategories(String projectId) async {
    try {
      final list = await _apiSource.listIssueCategories(projectId);
      return list.map((item) => item.toDomain()).toList();
    } on RedmineApiException catch (e) {
      throw IssuesException(e.message, mapIssuesKind(e.kind), cause: e);
    }
  }
}
