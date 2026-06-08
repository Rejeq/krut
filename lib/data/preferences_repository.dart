import 'package:track_dev/core/models/auth_session.dart';
import 'package:track_dev/core/repository/preferences.dart';
import 'package:track_dev/data/source/local/local_storage_source.dart';

class LocalPreferencesRepository implements PreferencesRepository {
  final LocalStorageSource _localStorage;

  LocalPreferencesRepository(this._localStorage);

  @override
  Future<void> setAuthMethod(AuthMethod method) async {
    await _localStorage.write(_keyAuthMethod, method.name);
  }

  @override
  Future<AuthMethod> getAuthMethod() async {
    final value = await _localStorage.read(_keyAuthMethod);
    if (value == null) return AuthMethod.basic;
    try {
      return AuthMethod.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return AuthMethod.basic;
    }
  }

  @override
  Future<void> setActiveScreen(ScreenKind screen) async {
    await _localStorage.write(_keyActiveScreen, screen.name);
  }

  @override
  Future<ScreenKind> getActiveScreen() async {
    final value = await _localStorage.read(_keyActiveScreen);
    if (value == null) return ScreenKind.home;
    try {
      return ScreenKind.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return ScreenKind.home;
    }
  }

  @override
  Future<void> setServerUrl(String url) async {
    await _localStorage.write(_keyServerUrl, url);
  }

  @override
  Future<String?> getServerUrl() async {
    return await _localStorage.read(_keyServerUrl);
  }

  @override
  Future<void> setStatsSelectedProjectId(int? id) async {
    if (id == null) {
      await _localStorage.clear(_keyStatsSelectedProjectId);
    } else {
      await _localStorage.write(_keyStatsSelectedProjectId, id.toString());
    }
  }

  @override
  Future<int?> getStatsSelectedProjectId() async {
    final value = await _localStorage.read(_keyStatsSelectedProjectId);
    if (value == null) return null;
    return int.tryParse(value);
  }

  @override
  Future<void> setStatsLayout(StatsLayout layout) async {
    await _localStorage.write(_keyStatsLayout, layout.name);
  }

  @override
  Future<StatsLayout> getStatsLayout() async {
    final value = await _localStorage.read(_keyStatsLayout);
    if (value == null) return StatsLayout.grid;
    try {
      return StatsLayout.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return StatsLayout.grid;
    }
  }
}

const _keyAuthMethod = LocalStorageKeys.keyAuthMethod;
const _keyActiveScreen = LocalStorageKeys.keyActiveScreen;
const _keyServerUrl = LocalStorageKeys.keyServerUrl;
const _keyStatsSelectedProjectId = LocalStorageKeys.keyStatsSelectedProjectId;
const _keyStatsLayout = LocalStorageKeys.keyStatsLayout;
