class NetworkErrorKind {
  const NetworkErrorKind({this.code});
  final int? code;
}

final class NoConnectionErrorKind extends NetworkErrorKind {
  const NoConnectionErrorKind() : super();
}

final class TimeoutErrorKind extends NetworkErrorKind {
  const TimeoutErrorKind() : super();
}

final class RequestCanceledErrorKind extends NetworkErrorKind {
  const RequestCanceledErrorKind();
}

final class UnauthorizedErrorKind extends NetworkErrorKind {
  const UnauthorizedErrorKind();
}

final class ForbiddenErrorKind extends NetworkErrorKind {
  const ForbiddenErrorKind();
}

final class NotFoundErrorKind extends NetworkErrorKind {
  const NotFoundErrorKind();
}

final class ConflictErrorKind extends NetworkErrorKind {
  const ConflictErrorKind();
}

