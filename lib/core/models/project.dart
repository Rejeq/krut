class Project {
  const Project({
    required this.id,
    required this.name,
    this.description,
    this.status,
    this.updatedOn,
  });

  final int id;
  final String name;
  final String? description;
  final int? status;
  final DateTime? updatedOn;
}
