import 'package:track_dev/core/models/user.dart';
import 'package:track_dev/core/repository/user.dart';
import 'package:track_dev/data/source/redmine/redmine_api_source.dart';
import 'package:track_dev/data/source/redmine/models/error.dart';
import 'package:track_dev/data/map/user.dart';
import 'package:track_dev/data/map/error.dart';

class UserRepositoryImpl implements UserRepository {
  final RedmineApiSource _apiSource;

  UserRepositoryImpl({required this._apiSource});

  @override
  Future<User> fetchCurrentUser() async {
    try {
      final redmineUser = await _apiSource.fetchCurrentUser();
      return redmineUser.toDomain();
    } on RedmineApiException catch (e) {
      throw UserException(e.message, mapUserKind(e.kind), cause: e);
    }
  }
}
