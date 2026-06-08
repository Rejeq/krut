import 'package:track_dev/core/models/error.dart';
import 'package:track_dev/core/models/project.dart';
import 'package:track_dev/core/models/time_entry.dart';
import 'package:track_dev/core/models/paginated_result.dart';

sealed class ProjectsErrorKind {
  const ProjectsErrorKind();
}

final class ProjectNotFoundErrorKind extends ProjectsErrorKind {
  const ProjectNotFoundErrorKind();
}

final class ProjectsNetworkErrorKind extends ProjectsErrorKind {
  const ProjectsNetworkErrorKind({this.kind});
  final NetworkErrorKind? kind;
}

class ProjectsException implements Exception {
  const ProjectsException(this.message, this.kind, {this.cause});

  final String message;
  final ProjectsErrorKind kind;
  final Object? cause;

  @override
  String toString() => 'ProjectsException($kind): $message';
}

abstract class ProjectsRepository {
  Future<PaginatedResult<Project>> list({int offset = 0, int limit = 25});

  Future<List<Project>> listAll([int pageSize = 100]);

  Future<PaginatedResult<TimeEntry>> listTimeEntries(
    String projectId, {
    int offset = 0,
    int limit = 25,
    int? userId,
    int? issueId,
    DateTime? spentOnFrom,
    DateTime? spentOnTo,
  });
}
