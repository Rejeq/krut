class LocalStorageKeys {
  static const keyRedmineCreds = 'redmine.session.credentials';
  static const keyLastUsername = 'app.session.last_username';
}

abstract class LocalStorageSource {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> clear(String key);
}
