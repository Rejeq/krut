import 'package:json_annotation/json_annotation.dart';

part 'shared.g.dart';

typedef JsonMap = Map<String, dynamic>;

@JsonSerializable(fieldRename: FieldRename.snake)
class RedmineUser {
  const RedmineUser({
    required this.id,
    this.login,
    this.firstname,
    this.lastname,
    this.mail,
    this.admin = false,
    this.active = true,
    this.lastLoginOn,
    this.createdOn,
    this.apiKey,
  });

  final int id;
  final String? login;
  final String? firstname;
  final String? lastname;
  final String? mail;
  final bool admin;
  final bool active;
  final DateTime? lastLoginOn;
  final DateTime? createdOn;
  final String? apiKey;

  String get fullName => [firstname, lastname].where((e) => (e ?? '').trim().isNotEmpty).join(' ').trim();

  factory RedmineUser.fromJson(JsonMap json) => _$RedmineUserFromJson(json);
  JsonMap toJson() => _$RedmineUserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RedmineProject {
  const RedmineProject({
    required this.id,
    required this.name,
    required this.identifier,
    this.description,
    this.homepage,
    this.parentId,
    this.status,
    this.createdOn,
    this.updatedOn,
  });

  final int id;
  final String name;
  final String identifier;
  final String? description;
  final String? homepage;
  final int? parentId;
  final int? status;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  factory RedmineProject.fromJson(JsonMap json) => _$RedmineProjectFromJson(json);
  JsonMap toJson() => _$RedmineProjectToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RedmineIssueCategory {
  const RedmineIssueCategory({
    required this.id,
    required this.name,
    this.projectId,
  });

  final int id;
  final String name;
  final int? projectId;

  factory RedmineIssueCategory.fromJson(JsonMap json) => _$RedmineIssueCategoryFromJson(json);
  JsonMap toJson() => _$RedmineIssueCategoryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RedmineTimeEntryActivity {
  const RedmineTimeEntryActivity({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  final int id;
  final String name;
  final bool isDefault;

  factory RedmineTimeEntryActivity.fromJson(JsonMap json) => _$RedmineTimeEntryActivityFromJson(json);
  JsonMap toJson() => _$RedmineTimeEntryActivityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RedmineTimeEntry {
  const RedmineTimeEntry({
    required this.id,
    required this.hours,
    this.spentOn,
    this.comment,
    this.activityId,
    this.projectId,
    this.issueId,
    this.userId,
    this.createdOn,
    this.updatedOn,
  });

  final int id;
  final double hours;
  final DateTime? spentOn;
  final String? comment;
  final int? activityId;
  final int? projectId;
  final int? issueId;
  final int? userId;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  factory RedmineTimeEntry.fromJson(JsonMap json) => _$RedmineTimeEntryFromJson(json);
  JsonMap toJson() => _$RedmineTimeEntryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RedmineIssue {
  const RedmineIssue({
    required this.id,
    required this.subject,
    this.projectId,
    this.trackerId,
    this.statusId,
    this.priorityId,
    this.authorId,
    this.assignedToId,
    this.categoryId,
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
  final int? categoryId;
  final String? description;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  factory RedmineIssue.fromJson(JsonMap json) => _$RedmineIssueFromJson(json);
  JsonMap toJson() => _$RedmineIssueToJson(this);
}

