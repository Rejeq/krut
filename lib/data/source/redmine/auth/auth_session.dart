import 'dart:convert';

import 'credentials.dart';
import '../models/shared.dart';
import '../../local/local_storage_source.dart';

class RedmineAuthSession {
  const RedmineAuthSession({required this.credentials});

  final RedmineAuthCredentials credentials;

  RedmineAuthMethod get method => credentials.method;

  JsonMap toJson() => credentials.toJson();

  factory RedmineAuthSession.fromJson(JsonMap json) {
    switch (json['method']) {
      case 'basic':
        return RedmineAuthSession(credentials: RedmineBasicAuthCredentials.fromJson(json));
      case 'apiKey':
        return RedmineAuthSession(credentials: RedmineApiKeyCredentials.fromJson(json));
      default:
        throw const FormatException('Unsupported auth session');
    }
  }
}

class RedmineSessionStore {
  RedmineSessionStore(this.storage);

  final LocalStorageSource storage;
  static const _key = LocalStorageKeys.keyRedmineCreds;

  RedmineAuthSession? _cached;
  bool _isCached = false;

  Future<RedmineAuthSession?> read() async {
    if (_isCached) return _cached;
    final raw = await storage.read(_key);
    if (raw == null || raw.trim().isEmpty) {
      _cached = null;
      _isCached = true;
      return null;
    }
    try {
      _cached = RedmineAuthSession.fromJson(jsonDecode(raw) as JsonMap);
      _isCached = true;
    } catch (_) {
      _cached = null;
      _isCached = false;
    }
    return _cached;
  }

  Future<void> write(RedmineAuthSession session) async {
    _cached = session;
    _isCached = true;
    await storage.write(_key, jsonEncode(session.toJson()));
  }

  Future<void> clear() async {
    _cached = null;
    _isCached = true;
    await storage.clear(_key);
  }
}

