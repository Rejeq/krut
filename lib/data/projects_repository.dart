import 'package:track_dev/core/models/project.dart';
import 'package:track_dev/core/models/time_entry.dart';
import 'package:track_dev/core/models/paginated_result.dart';
import 'package:track_dev/core/repository/projects.dart';
import 'package:track_dev/data/source/redmine/redmine_api_source.dart';
import 'package:track_dev/data/source/redmine/models/error.dart';
import 'package:track_dev/data/map/project.dart';
import 'package:track_dev/data/map/time_entry.dart';
import 'package:track_dev/data/map/paginated_result.dart';
import 'package:track_dev/data/map/error.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final RedmineApiSource _apiSource;

  ProjectsRepositoryImpl({required this._apiSource});

  @override
  Future<PaginatedResult<Project>> list({int offset = 0, int limit = 25}) async {
    try {
      final redmineResult = await _apiSource.listProjects(offset: offset, limit: limit);
      return redmineResult.toDomain((item) => item.toDomain());
    } on RedmineApiException catch (e) {
      throw ProjectsException(e.message, mapProjectsKind(e.kind), cause: e);
    }
  }

  @override
  Future<List<Project>> listAll([int pageSize = 100]) async {
    final result = <Project>[];
    var offset = 0;
    while (true) {
      final page = await list(offset: offset, limit: pageSize);
      result.addAll(page.items);
      if (result.length >= (page.totalCount ?? result.length) || page.items.isEmpty) break;
      offset += page.limit;
    }
    return result;
  }

  @override
  Future<PaginatedResult<TimeEntry>> listTimeEntries(
    String projectId, {
    int offset = 0,
    int limit = 25,
    int? userId,
    int? issueId,
    DateTime? spentOnFrom,
    DateTime? spentOnTo,
  }) async {
    try {
      final redmineResult = await _apiSource.listTimeEntries(
        offset: offset,
        limit: limit,
        userId: userId,
        projectId: projectId,
        issueId: issueId,
        spentOnFrom: spentOnFrom,
        spentOnTo: spentOnTo,
      );
      return redmineResult.toDomain((item) => item.toDomain());
    } on RedmineApiException catch (e) {
      throw ProjectsException(e.message, mapProjectsKind(e.kind), cause: e);
    }
  }
}
