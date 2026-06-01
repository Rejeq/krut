import 'package:track_dev/core/models/auth_token.dart';
import 'package:track_dev/data/source/api_datasource.dart';
import 'package:track_dev/data/source/local_datasource.dart';
import 'package:track_dev/core/repository/user.dart';
import 'package:track_dev/core/models/user.dart';

abstract class UserRepository {
  
  Future<User> getUser();
}


class UserRepositoryImpl implements UserRepository {
  final ApiDataSource apiDataSource;

  UserRepositoryImpl({
    required this.apiDataSource,
  });

  @override
  Future<User> getUser() async {
    final user = await apiDataSource.fetchUser("token");
    return user;
  }

}