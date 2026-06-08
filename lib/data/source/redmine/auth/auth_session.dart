import 'dart:convert';

import 'credentials.dart';
import '../models/shared.dart';
import '../../local/local_storage_source.dart';

class RedmineAuthSession {
  final String baseUrl;
  final RedmineAuthCredentials credentials;

  const RedmineAuthSession({required this.baseUrl, required this.credentials});

  RedmineAuthMethod get method => credentials.method;

  JsonMap toJson() => {'baseUrl': baseUrl, ...credentials.toJson()};

  factory RedmineAuthSession.fromJson(JsonMap json) {
    final baseUrl = json['baseUrl'].toString();
    final credentials = switch (json['method'].toString()) {
      'basic' => RedmineBasicAuthCredentials.fromJson(json),
      'apiKey' => RedmineApiKeyCredentials.fromJson(json),
      _ => throw const FormatException('Unsupported auth session'),
    };

    return RedmineAuthSession(baseUrl: baseUrl, credentials: credentials);
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
