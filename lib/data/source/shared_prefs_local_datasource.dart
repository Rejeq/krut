import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_dev/core/models/auth_token.dart';
import 'package:track_dev/data/source/local_datasource.dart';

class SharedPreferencesLocalDataSource implements LocalDataSource {
  final SharedPreferencesAsync _sharedPreferences;

  static const _keyToken = 'auth_token_json';
  static const _keyLastUsername = 'last_logged_username';

  SharedPreferencesLocalDataSource(this._sharedPreferences);

  @override
  Future<AuthToken?> getCachedToken() async {
    final jsonStr = await _sharedPreferences.getString(_keyToken);
    if (jsonStr == null) return null;

    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AuthToken.fromJson(map);
    } catch (_) {
      await clearToken();
      return null;
    }
  }

  @override
  Future<void> saveToken(AuthToken token) async {
    final map = token.toJson();
    await _sharedPreferences.setString(_keyToken, jsonEncode(map));
  }

  @override
  Future<void> clearToken() async {
    await _sharedPreferences.remove(_keyToken);
  }

  @override
  Future<String?> getLastLoggedUsername() async {
    return await _sharedPreferences.getString(_keyLastUsername);
  }

  @override
  Future<void> saveLastLoggedUsername(String username) async {
    await _sharedPreferences.setString(_keyLastUsername, username);
  }
}

