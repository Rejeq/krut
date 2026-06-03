import 'package:track_dev/core/models/error.dart' as core;
import 'package:track_dev/core/repository/auth.dart';
import 'package:track_dev/core/repository/issues.dart';
import 'package:track_dev/core/repository/projects.dart';
import 'package:track_dev/core/repository/time_entries.dart';
import 'package:track_dev/core/repository/user.dart';
import 'package:track_dev/data/source/redmine/models/error.dart' as redmine;

core.NetworkErrorKind? mapNetworkKind(redmine.RedmineErrorKind kind) {
  return switch (kind) {
    redmine.NoConnectionErrorKind() => const core.NoConnectionErrorKind(),
    redmine.TimeoutErrorKind() => const core.TimeoutErrorKind(),
    redmine.RequestCanceledErrorKind() => const core.RequestCanceledErrorKind(),
    redmine.UnauthorizedErrorKind() => const core.UnauthorizedErrorKind(),
    redmine.ForbiddenErrorKind() => const core.ForbiddenErrorKind(),
    redmine.NotFoundErrorKind() => const core.NotFoundErrorKind(),
    redmine.ConflictErrorKind() => const core.ConflictErrorKind(),
    redmine.NetworkErrorKind(code: final code) => core.NetworkErrorKind(code: code),
    _ => null,
  };
}

AuthErrorKind mapAuthKind(redmine.RedmineErrorKind kind) {
  return switch (kind) {
    redmine.SessionExpiredErrorKind() ||
    redmine.UnauthorizedErrorKind() ||
    redmine.ForbiddenErrorKind() =>
      const IncorrectPasswordErrorKind(),
    redmine.NotFoundErrorKind() => const UserNotFoundErrorKind(),
    _ => AuthNetworkErrorKind(kind: mapNetworkKind(kind)),
  };
}

IssuesErrorKind mapIssuesKind(redmine.RedmineErrorKind kind) {
  return switch (kind) {
    redmine.NotFoundErrorKind() => const IssueNotFoundErrorKind(),
    redmine.ValidationErrorKind(errors: final errors) => IssueValidationErrorKind(errors: errors),
    _ => IssuesNetworkErrorKind(kind: mapNetworkKind(kind)),
  };
}

ProjectsErrorKind mapProjectsKind(redmine.RedmineErrorKind kind) {
  return switch (kind) {
    redmine.NotFoundErrorKind() => const ProjectNotFoundErrorKind(),
    _ => ProjectsNetworkErrorKind(kind: mapNetworkKind(kind)),
  };
}

TimeEntriesErrorKind mapTimeEntriesKind(redmine.RedmineErrorKind kind) {
  return switch (kind) {
    redmine.NotFoundErrorKind() => const TimeEntryNotFoundErrorKind(),
    redmine.ValidationErrorKind(errors: final errors) => TimeEntryValidationErrorKind(errors: errors),
    _ => TimeEntriesNetworkErrorKind(kind: mapNetworkKind(kind)),
  };
}

UserErrorKind mapUserKind(redmine.RedmineErrorKind kind) {
  return switch (kind) {
    redmine.NotFoundErrorKind() ||
    redmine.UnauthorizedErrorKind() ||
    redmine.ForbiddenErrorKind() =>
      const CurrentUserUnavailableErrorKind(),
    _ => UserNetworkErrorKind(kind: mapNetworkKind(kind)),
  };
}
