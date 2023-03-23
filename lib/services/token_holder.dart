class TokenHolder {
  static String token = "";

  static clear() {
    token = "";
  }

  TokenHolder._constructor();
  static final TokenHolder _instance = TokenHolder._constructor();
  factory TokenHolder() {
    return _instance;
  }
}
