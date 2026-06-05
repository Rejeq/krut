enum AuthMethod { none, basic, apiKey }

class AuthSession {
  AuthMethod method;

  AuthSession(this.method);

  /// Sessions don't expire in this implementation.
  bool get isExpired => false;
}

