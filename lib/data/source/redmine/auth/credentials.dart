import '../models/shared.dart';

enum RedmineAuthMethod { none, basic, apiKey }

sealed class RedmineAuthCredentials {
  const RedmineAuthCredentials();
  RedmineAuthMethod get method;
  JsonMap toJson();
}

class RedmineBasicAuthCredentials extends RedmineAuthCredentials {
  const RedmineBasicAuthCredentials({required this.username, required this.password});

  final String username;
  final String password;

  @override
  RedmineAuthMethod get method => RedmineAuthMethod.basic;

  // TODO: Encrypt the password
  @override
  JsonMap toJson() => {'method': method.name, 'username': username, 'password': password};

  factory RedmineBasicAuthCredentials.fromJson(JsonMap json) => RedmineBasicAuthCredentials(
        username: json['username'] as String,
        password: json['password'] as String,
      );
}

class RedmineApiKeyCredentials extends RedmineAuthCredentials {
  const RedmineApiKeyCredentials({required this.apiKey});

  final String apiKey;

  @override
  RedmineAuthMethod get method => RedmineAuthMethod.apiKey;

  // TODO: Encrypt the api key
  @override
  JsonMap toJson() => {'method': method.name, 'apiKey': apiKey};

  factory RedmineApiKeyCredentials.fromJson(JsonMap json) => RedmineApiKeyCredentials(apiKey: json['apiKey'] as String);
}

