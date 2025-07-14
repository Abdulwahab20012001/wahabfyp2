class SessionController {
  static final SessionController session = SessionController._internal();

  String? userid;

  factory SessionController() {
    return session;
  }
  SessionController._internal() {}
}
