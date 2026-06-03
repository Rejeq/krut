import 'package:track_dev/core/models/issue.dart';
import 'package:track_dev/core/models/issue_category.dart';
import 'package:track_dev/data/source/redmine/models/shared.dart';

extension RedmineIssueCategoryMapper on RedmineIssueCategory {
  IssueCategory toDomain() {
    return IssueCategory(
      id: id,
      name: name,
      projectId: projectId,
    );
  }
}

extension RedmineIssueMapper on RedmineIssue {
  Issue toDomain() {
    return Issue(
      id: id,
      subject: subject,
      projectId: projectId,
      trackerId: trackerId,
      statusId: statusId,
      priorityId: priorityId,
      authorId: authorId,
      assignedToId: assignedToId,
      category: categoryId == null ? null : IssueCategory(id: categoryId!, name: ''),
      description: description,
      createdOn: createdOn,
      updatedOn: updatedOn,
    );
  }
}
