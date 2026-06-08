sealed class RedmineErrorKind {
  const RedmineErrorKind();
}

class NetworkErrorKind extends RedmineErrorKind {
  const NetworkErrorKind({this.code});
  final int? code;
}

final class NoConnectionErrorKind extends NetworkErrorKind {
  const NoConnectionErrorKind() : super();
}

final class TimeoutErrorKind extends NetworkErrorKind {
  const TimeoutErrorKind() : super();
}

final class RequestCanceledErrorKind extends RedmineErrorKind {
  const RequestCanceledErrorKind();
}

final class UnauthorizedErrorKind extends RedmineErrorKind {
  const UnauthorizedErrorKind();
}

final class ForbiddenErrorKind extends RedmineErrorKind {
  const ForbiddenErrorKind();
}

final class NotFoundErrorKind extends RedmineErrorKind {
  const NotFoundErrorKind();
}

final class ConflictErrorKind extends RedmineErrorKind {
  const ConflictErrorKind();
}

final class ValidationErrorKind extends RedmineErrorKind {
  const ValidationErrorKind({this.errors = const <String, List<String>>{}});
  final Map<String, List<String>> errors;
}

final class SessionExpiredErrorKind extends RedmineErrorKind {
  const SessionExpiredErrorKind();
}

final class UnexpectedResponseErrorKind extends RedmineErrorKind {
  const UnexpectedResponseErrorKind(this.detail);
  final String detail;
}

final class UnknownErrorKind extends RedmineErrorKind {
  const UnknownErrorKind({this.detail});
  final String? detail;
}

class RedmineApiException implements Exception {
  const RedmineApiException(this.message, this.kind, {this.cause});

  final String message;
  final RedmineErrorKind kind;
  final Object? cause;

  @override
  String toString() => 'RedmineApiException($kind): $message';
}

