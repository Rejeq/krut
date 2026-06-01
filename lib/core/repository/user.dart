import 'package:track_dev/core/models/auth_token.dart';
import 'package:track_dev/core/models/user.dart';


abstract class UserRepository {
  
  Future<User> getUser();
}
