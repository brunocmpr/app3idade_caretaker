class TokenBuffer {
  String _token = '';

  String get token => _token;

  set token(String value) {
    if (value.isNotEmpty) {
      _token = value;
    } else {
      clear();
    }
  }

  clear() {
    _token = '';
  }

  bool isTokenAvailable() => _token.isNotEmpty;

  TokenBuffer._constructor();
  static final TokenBuffer _instance = TokenBuffer._constructor();
  factory TokenBuffer() {
    return _instance;
  }
}
