import 'package:track_dev/core/models/project.dart';
import 'package:track_dev/data/source/redmine/models/shared.dart';

extension RedmineProjectMapper on RedmineProject {
  Project toDomain() {
    return Project(
      id: id,
      name: name,
      description: description,
      status: status,
      updatedOn: updatedOn,
    );
  }
}
