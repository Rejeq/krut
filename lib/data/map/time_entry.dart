import 'package:track_dev/core/models/time_entry.dart';
import 'package:track_dev/core/models/time_entry_activity.dart';
import 'package:track_dev/data/source/redmine/models/shared.dart';

extension RedmineTimeEntryActivityMapper on RedmineTimeEntryActivity {
  TimeEntryActivity toDomain() {
    return TimeEntryActivity(
      id: id,
      name: name,
      isDefault: isDefault,
    );
  }
}

extension RedmineTimeEntryMapper on RedmineTimeEntry {
  TimeEntry toDomain() {
    return TimeEntry(
      id: id,
      hours: hours,
      spentOn: spentOn,
      comment: comment,
      activity: activityId == null ? null : TimeEntryActivity(id: activityId!, name: ''),
      projectId: projectId,
      issueId: issueId,
      userId: userId,
      createdOn: createdOn,
      updatedOn: updatedOn,
    );
  }
}
