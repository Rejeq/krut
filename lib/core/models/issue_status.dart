class IssueStatus {
  const IssueStatus({
    required this.id,
    required this.name,
    required this.isClosed,
  });

  final int id;
  final String name;
  final bool isClosed;
}

