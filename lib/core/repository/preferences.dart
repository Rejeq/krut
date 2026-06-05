import 'package:track_dev/core/models/auth_session.dart';

enum ScreenKind {
  home,
  timer,
  projets,
}

enum StatsLayout {
  grid,
  list,
}

abstract class PreferencesRepository {
  Future<void> setAuthMethod(AuthMethod method);
  Future<AuthMethod> getAuthMethod();

  Future<void> setActiveScreen(ScreenKind screen);
  Future<ScreenKind> getActiveScreen();

  Future<void> setServerUrl(String url);
  Future<String?> getServerUrl();

  Future<void> setStatsSelectedProjectId(int? id);
  Future<int?> getStatsSelectedProjectId();

  Future<void> setStatsLayout(StatsLayout layout);
  Future<StatsLayout> getStatsLayout();
}
