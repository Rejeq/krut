class LocalStorageKeys {
  static const keyRedmineCreds = 'redmine.session.credentials';
  static const keyLastUsername = 'app.session.last_username';
  static const keyLastServername = 'app.session.last_servername';

  static const keyAuthMethod = 'prefs.auth_method';
  static const keyActiveScreen = 'prefs.active_screen';
  static const keyServerUrl = 'prefs.server_url';
  static const keyStatsSelectedProjectId = 'prefs.stats_selected_project_id';
  static const keyStatsLayout = 'prefs.stats_layout';
}

abstract class LocalStorageSource {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> clear(String key);
}
