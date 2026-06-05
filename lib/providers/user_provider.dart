import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/user.dart';
import 'package:track_dev/providers/sources_provider.dart';

class UserStateNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return ref.read(userRepositoryProvider).fetchCurrentUser();
  }
}

final userStateProvider = AsyncNotifierProvider<UserStateNotifier, User?>(
  UserStateNotifier.new,
);
