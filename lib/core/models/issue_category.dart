class IssueCategory {
  const IssueCategory({
    required this.id,
    required this.name,
    this.projectId,
  });

  final int id;
  final String name;
  final int? projectId;
}
