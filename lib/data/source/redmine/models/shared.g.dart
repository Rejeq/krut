// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedmineUser _$RedmineUserFromJson(Map<String, dynamic> json) => RedmineUser(
  id: (json['id'] as num).toInt(),
  login: json['login'] as String?,
  firstname: json['firstname'] as String?,
  lastname: json['lastname'] as String?,
  mail: json['mail'] as String?,
  admin: json['admin'] as bool? ?? false,
  active: json['active'] as bool? ?? true,
  lastLoginOn: json['last_login_on'] == null
      ? null
      : DateTime.parse(json['last_login_on'] as String),
  createdOn: json['created_on'] == null
      ? null
      : DateTime.parse(json['created_on'] as String),
  apiKey: json['api_key'] as String?,
);

Map<String, dynamic> _$RedmineUserToJson(RedmineUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'mail': instance.mail,
      'admin': instance.admin,
      'active': instance.active,
      'last_login_on': instance.lastLoginOn?.toIso8601String(),
      'created_on': instance.createdOn?.toIso8601String(),
      'api_key': instance.apiKey,
    };

RedmineProject _$RedmineProjectFromJson(Map<String, dynamic> json) =>
    RedmineProject(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      identifier: json['identifier'] as String,
      description: json['description'] as String?,
      homepage: json['homepage'] as String?,
      parentId: (json['parent_id'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      createdOn: json['created_on'] == null
          ? null
          : DateTime.parse(json['created_on'] as String),
      updatedOn: json['updated_on'] == null
          ? null
          : DateTime.parse(json['updated_on'] as String),
    );

Map<String, dynamic> _$RedmineProjectToJson(RedmineProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'identifier': instance.identifier,
      'description': instance.description,
      'homepage': instance.homepage,
      'parent_id': instance.parentId,
      'status': instance.status,
      'created_on': instance.createdOn?.toIso8601String(),
      'updated_on': instance.updatedOn?.toIso8601String(),
    };

RedmineIssueCategory _$RedmineIssueCategoryFromJson(
  Map<String, dynamic> json,
) => RedmineIssueCategory(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  projectId: (json['project_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$RedmineIssueCategoryToJson(
  RedmineIssueCategory instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'project_id': instance.projectId,
};

RedmineTimeEntryActivity _$RedmineTimeEntryActivityFromJson(
  Map<String, dynamic> json,
) => RedmineTimeEntryActivity(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  isDefault: json['is_default'] as bool? ?? false,
);

Map<String, dynamic> _$RedmineTimeEntryActivityToJson(
  RedmineTimeEntryActivity instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'is_default': instance.isDefault,
};

RedmineTimeEntry _$RedmineTimeEntryFromJson(Map<String, dynamic> json) =>
    RedmineTimeEntry(
      id: (json['id'] as num).toInt(),
      hours: (json['hours'] as num).toDouble(),
      spentOn: json['spent_on'] == null
          ? null
          : DateTime.parse(json['spent_on'] as String),
      comment: json['comment'] as String?,
      activityId: (json['activity_id'] as num?)?.toInt(),
      projectId: (json['project_id'] as num?)?.toInt(),
      issueId: (json['issue_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      createdOn: json['created_on'] == null
          ? null
          : DateTime.parse(json['created_on'] as String),
      updatedOn: json['updated_on'] == null
          ? null
          : DateTime.parse(json['updated_on'] as String),
    );

Map<String, dynamic> _$RedmineTimeEntryToJson(RedmineTimeEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hours': instance.hours,
      'spent_on': instance.spentOn?.toIso8601String(),
      'comment': instance.comment,
      'activity_id': instance.activityId,
      'project_id': instance.projectId,
      'issue_id': instance.issueId,
      'user_id': instance.userId,
      'created_on': instance.createdOn?.toIso8601String(),
      'updated_on': instance.updatedOn?.toIso8601String(),
    };

RedmineIssue _$RedmineIssueFromJson(Map<String, dynamic> json) => RedmineIssue(
  id: (json['id'] as num).toInt(),
  subject: json['subject'] as String,
  projectId: (json['project_id'] as num?)?.toInt(),
  trackerId: (json['tracker_id'] as num?)?.toInt(),
  statusId: (json['status_id'] as num?)?.toInt(),
  priorityId: (json['priority_id'] as num?)?.toInt(),
  authorId: (json['author_id'] as num?)?.toInt(),
  assignedToId: (json['assigned_to_id'] as num?)?.toInt(),
  categoryId: (json['category_id'] as num?)?.toInt(),
  description: json['description'] as String?,
  createdOn: json['created_on'] == null
      ? null
      : DateTime.parse(json['created_on'] as String),
  updatedOn: json['updated_on'] == null
      ? null
      : DateTime.parse(json['updated_on'] as String),
);

Map<String, dynamic> _$RedmineIssueToJson(RedmineIssue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'project_id': instance.projectId,
      'tracker_id': instance.trackerId,
      'status_id': instance.statusId,
      'priority_id': instance.priorityId,
      'author_id': instance.authorId,
      'assigned_to_id': instance.assignedToId,
      'category_id': instance.categoryId,
      'description': instance.description,
      'created_on': instance.createdOn?.toIso8601String(),
      'updated_on': instance.updatedOn?.toIso8601String(),
    };
