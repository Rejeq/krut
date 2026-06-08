import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_dev/data/source/local/local_storage_source.dart';

class DefaultLocalStorageSource implements LocalStorageSource {
  final SharedPreferencesAsync _sharedPreferences;

  DefaultLocalStorageSource(this._sharedPreferences);

  @override
  Future<String?> read(String key) async {
    return await _sharedPreferences.getString(key);
  }

  @override
  Future<void> write(String key, String value) async {
    _sharedPreferences.setString(key, value);
  }

  @override
  Future<void> clear(String key) async {
    _sharedPreferences.remove(key);
  }
}
