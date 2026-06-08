import 'package:track_dev/core/models/error.dart';
import 'package:track_dev/core/models/issue.dart';
import 'package:track_dev/core/models/issue_category.dart';
import 'package:track_dev/core/models/paginated_result.dart';

sealed class IssuesErrorKind {
  const IssuesErrorKind();
}

final class IssueNotFoundErrorKind extends IssuesErrorKind {
  const IssueNotFoundErrorKind();
}

final class IssueValidationErrorKind extends IssuesErrorKind {
  const IssueValidationErrorKind({this.errors = const <String, List<String>>{}});
  final Map<String, List<String>> errors;
}

final class IssuesNetworkErrorKind extends IssuesErrorKind {
  const IssuesNetworkErrorKind({this.kind});
  final NetworkErrorKind? kind;
}

class IssuesException implements Exception {
  const IssuesException(this.message, this.kind, {this.cause});

  final String message;
  final IssuesErrorKind kind;
  final Object? cause;

  @override
  String toString() => 'IssuesException($kind): $message';
}

class IssuesQuery {
  const IssuesQuery({
    this.offset = 0,
    this.limit = 25,
    this.sort,
    this.projectId,
    this.subprojectId,
    this.trackerId,
    this.statusId,
    this.assignedToId,
    this.parentId,
    this.issueId,
  });

  final int offset;
  final int limit;
  final String? sort;
  final int? projectId;
  final int? subprojectId;
  final int? trackerId;
  final String? statusId;
  final String? assignedToId;
  final int? parentId;
  final String? issueId;
}

abstract class IssuesRepository {
  Future<PaginatedResult<Issue>> list(IssuesQuery query);

  Future<List<Issue>> listAll([IssuesQuery query = const IssuesQuery(limit: 100)]);

  Future<List<IssueCategory>> fetchIssueCategories(String projectId);
}
