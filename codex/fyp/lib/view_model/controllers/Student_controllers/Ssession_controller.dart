class SSessionController {
  static final SSessionController session = SSessionController._internal();

  String? userid;

  factory SSessionController() {
    return session;
  }
  SSessionController._internal() {}
}
