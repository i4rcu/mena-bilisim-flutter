class UserSession {
  static final UserSession _singleton = UserSession._internal();

  factory UserSession() {
    return _singleton;
  }

  UserSession._internal();

  int? userId;
}
