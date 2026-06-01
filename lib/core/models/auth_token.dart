import 'package:json_annotation/json_annotation.dart';

part 'auth_token.g.dart';

@JsonSerializable()
class AuthToken {
  final String value;
  final DateTime expiresAt;

  AuthToken({required this.value, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);
}
