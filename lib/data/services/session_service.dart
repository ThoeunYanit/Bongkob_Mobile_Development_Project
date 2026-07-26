import '../../../models/stegano_session.dart';

class SessionService {
  static final SessionService instance = SessionService();


  final List<SteganoSession> _sessions = [];

  // returns all sessions newest first
  List<SteganoSession> get sessions => _sessions.reversed.toList();

  // adds a new session
  void add(String mode, String result) {
    _sessions.add(SteganoSession(
      mode:   mode,
      result: result,
      time:   DateTime.now(),
    ));
  }

  // clears all sessions
  void clearAll() => _sessions.clear();
}