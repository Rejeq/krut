import 'package:track_dev/core/models/issue_category.dart';

class Issue {
  const Issue({
    required this.id,
    required this.subject,
    this.projectId,
    this.trackerId,
    this.statusId,
    this.priorityId,
    this.authorId,
    this.assignedToId,
    this.category,
    this.description,
    this.createdOn,
    this.updatedOn,
  });

  final int id;
  final String subject;
  final int? projectId;
  final int? trackerId;
  final int? statusId;
  final int? priorityId;
  final int? authorId;
  final int? assignedToId;
  final IssueCategory? category;
  final String? description;
  final DateTime? createdOn;
  final DateTime? updatedOn;
}

