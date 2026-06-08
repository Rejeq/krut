import 'package:track_dev/core/models/user.dart';
import 'package:track_dev/data/source/redmine/models/shared.dart';

extension RedmineUserMapper on RedmineUser {
  User toDomain() {
    return User(
      id: id.toString(),
      login: login ?? '',
      firstname: firstname ?? '',
      lastname: lastname ?? '',
    );
  }
}
